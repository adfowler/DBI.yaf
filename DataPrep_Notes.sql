/******************************************************************************************************/
/* DataPrep_Notes 																					  */
/* Author: Andrew Fowler - December, 2021															  */
/*																									  */
/* OVERVIEW																							  */
/*  This script rolls data to the SF Notes level. It only pulls in notes with a length under 32k      */
/*  AFTER stripping html tags																		  */
/* NOTE																								  */
/*	The striphtml script could be periodically updated as more tags are discovered. Its not perfect   */
/******************************************************************************************************/

DECLARE @err_no int,
              @err_severity int,
              @err_state int,
              @err_line int,
              @err_message varchar(4000),
              @newline char(1)
 
BEGIN TRY

USE YAF

	TRUNCATE TABLE upd_Notes

	--ALTER INDEX ALL ON upd_Notes DISABLE

	--Inserts all notes for loaded accounts where the note is under 32000 characters after html cleanup
	INSERT INTO upd_Notes (nid, did, dated, noted, Status, Priority)
	SELECT nid, 
		   did,
		   dated, 
		   noted,
		   'Completed' 'Status', 
		   'Normal' 'Priority'
	FROM Load_Notes 
	WHERE-- DATALENGTH(dbo.striphtml(noted) )< 32000 AND
		  noted is not null AND
		  did IN (SELECT did FROM mst_Account) --Only for people we already have, otherwise SF will kick it out

	--ALTER INDEX ALL ON upd_Notes REBUILD
	
	-- Update SF_AccountId. Needed for upsert
	UPDATE u
	SET u.SF_AccountID = a.id
	FROM upd_Notes u INNER JOIN xref_Account a
	  on cast(u.did as bigint) = cast(a.did as bigint)

	--Remove notes without a loaded account (they'll be picked up later)
	DELETE upd_Notes
	WHERE SF_AccountID IS NULL

	-- Update noted
	UPDATE upd_Notes
	SET noted = dbo.striphtml(noted)

	--remove quotes test
	UPDATE upd_Notes
	SET noted = REPLACE(noted, '"', '''')
	WHERE noted like '%"%'

--HashKey
UPDATE upd_Notes
SET HashKey =  HASHBYTES('MD5', (SELECT did, dated, noted, status, Priority FROM (VALUES(null))foo(bar) FOR XML AUTO)) 

/*Determine updates/adds*/
DECLARE @updates int,
		@adds int,
		@table char(7) = 'Notes',
		@updatedate smalldatetime = CAST(getdate() AS DATE)

SET @updates = (SELECT COUNT(DISTINCT(u.nid)) 
			   FROM upd_Notes u INNER JOIN mst_Notes m
				on u.nid = m.nid
			   WHERE u.HashKey <> m.HashKey)

SET @adds = (SELECT COUNT(DISTINCT(nid))
			 FROM upd_Notes
			 WHERE nid not in (SELECT nid FROM mst_Notes)
			)

INSERT INTO UpdateLog(TableName, UpdateDate, Updates, Adds, Deletes)
SELECT @table, @updatedate, @updates, @adds, 0


/*Archive updates*/
INSERT INTO Archive_Notes
SELECT m.*, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM mst_Notes m INNER JOIN upd_Notes u
  on m.nid = u.nid
WHERE m.HashKey <> u.HashKey

/*Delete unchanged records*/
DELETE u
FROM upd_Notes u INNER JOIN mst_Notes m
 on u.nid = m.nid AND
    u.HashKey = m.HashKey



/*Merge with master*/
MERGE mst_notes m
USING upd_notes u
	ON m.nid = u.nid
WHEN MATCHED THEN
	UPDATE
	SET 
		m.did = u.did,
		m.dated = u.dated,
		m.noted = u.noted,
		m.Status = u.Status,
		m.Priority = u.Priority,
		m.SF_AccountID = u.SF_AccountID,
		m.HashKey = u.HashKey

WHEN NOT MATCHED THEN
	INSERT (nid, did, dated, noted, Status, Priority, SF_AccountID, HashKey)
	VALUES  (nid, did, dated, noted, Status, Priority, SF_AccountID, HashKey);


 END TRY
       BEGIN CATCH
              SELECT @err_no=ERROR_NUMBER(),
                     @err_severity=ERROR_SEVERITY(),
                     @err_state=ERROR_STATE(),
                     @err_line=ERROR_LINE(),
                     @err_message=ERROR_MESSAGE()
 
             SET @newline = CHAR(10)
 
              PRINT 'Error in the Notes sync process'
 
              RAISERROR('Error Number: %d, Severity: %d, State: %d, Line: %d, %s%s', 15, 1,
                     @err_no, @err_severity, @err_state, @err_line, @newline, @err_message) WITH LOG
 
      END CATCH
