/******************************************************************************************************/
/* DataPrep_Campaign																				  */
/* Author: Andrew Fowler - December, 2021															  */
/*																									  */
/* OVERVIEW																							  */
/*  This script rolls data to the SF Project level.													  */
/******************************************************************************************************/
DECLARE @err_no int,
              @err_severity int,
              @err_state int,
              @err_line int,
              @err_message varchar(4000),
              @newline char(1)
 
BEGIN TRY

	USE YAF

	TRUNCATE TABLE upd_Campaign
	
	INSERT INTO upd_Campaign
	SELECT	pid,
			source,
			source,	--name
			description,
			mail_date,
			ranch,
			njc,
			premiums,
			premium_min,
			gross_mailed,
			mail_cost,
			thank_you,
			agency,
			'',	--record type
			NULL --HashKey
	FROM Load_Projects

	/*Updates*/
	--RecordType
	--These were existing values from Elizabeth we don't want to overwrite
	
	/*UPDATE u	
	SET u.RecordType = l.RecordType
	FROM upd_Campaign u INNER JOIN lkup_Campaign l
	  on u.pid = l.pid
	 */

	--Delete elizabeths.
	--Would be deleted anyway, but saves them from going through any further processing.
	DELETE upd_Campaign
	WHERE pid in (SELECT pid FROM lkup_Campaign)

	--Use mail_cost (ActualCost) to determine if it's a mailing per Elizabeth 12/29/21
	UPDATE upd_Campaign
	SET RecordType = CASE WHEN ActualCost > 0 THEN 'Mailing' ELSE 'Other' END
	WHERE RecordType = ''

	--Dates
	UPDATE upd_Campaign
	SET mail_date = REPLACE(mail_date, '0221', '2021')
	WHERE YEAR(mail_date) = 0221

	--HashKey
	UPDATE upd_Campaign
	SET HashKey =  HASHBYTES('MD5', (SELECT pid, source, name, Description, mail_date, ranch, njc, premiums, premiums_min, NumberSent, ActualCost, thank_you_type, agency, RecordType FROM (VALUES(null))foo(bar) FOR XML AUTO)) 


	/*Determine updates/adds*/
	DECLARE @updates int,
			@adds int,
			@table char(8) = 'Campaign',
			@updatedate smalldatetime = CAST(getdate() AS DATE)

	SET @updates = (SELECT COUNT(DISTINCT(u.pid)) 
				   FROM upd_Campaign u INNER JOIN mst_Campaign m
					on u.pid = m.pid
				   WHERE u.HashKey <> m.HashKey)

	SET @adds = (SELECT COUNT(DISTINCT(pid))
				 FROM upd_Campaign
				 WHERE pid not in (SELECT pid FROM mst_Campaign)
				)

	INSERT INTO UpdateLog(TableName, UpdateDate, Updates, Adds, Deletes)
	SELECT @table, @updatedate, @updates, @adds, 0


	/*Archive updates*/
	INSERT INTO Archive_Campaign
	SELECT m.*, CAST(GETDATE() AS DATE) 'ArchiveDate'
	FROM mst_Campaign m INNER JOIN upd_Campaign u
	  on m.pid = u.pid
	WHERE m.HashKey <> u.HashKey

	/*Delete unchanged records*/
	DELETE u
	FROM upd_Campaign u INNER JOIN mst_Campaign m
	 on u.pid = m.pid AND
		u.HashKey = m.HashKey

	
	/*Merge with master*/
	MERGE mst_Campaign m
	USING upd_Campaign u
		ON m.pid = u.pid
	WHEN MATCHED THEN
		UPDATE
		SET 
			m.source = u.source,
			m.Name = u.Name,
			m.Description = u.Description,
			m.mail_date = u.mail_date,
			m.ranch = u.ranch,
			m.njc = u.njc,
			m.premiums = u.premiums,
			m.premiums_min = u.premiums_min,
			m.NumberSent = u.NumberSent,
			m.ActualCost = u.ActualCost,
			m.thank_you_type = u.thank_you_type,
			m.agency = u.agency,
			m.RecordType = u.RecordType,
			m.HashKey = u.HashKey
	WHEN NOT MATCHED THEN
		INSERT (pid, source, Name, Description, mail_date, ranch, njc, premiums, premiums_min, NumberSent, ActualCost, thank_you_type, agency, RecordType, HashKey) 
		VALUES (pid, source, Name, Description, mail_date, ranch, njc, premiums, premiums_min, NumberSent, ActualCost, thank_you_type, agency, RecordType, HashKey);


 END TRY
       BEGIN CATCH
              SELECT @err_no=ERROR_NUMBER(),
                     @err_severity=ERROR_SEVERITY(),
                     @err_state=ERROR_STATE(),
                     @err_line=ERROR_LINE(),
                     @err_message=ERROR_MESSAGE()
 
             SET @newline = CHAR(10)
 
              PRINT 'Error in the SF Campaign load process'
 
              RAISERROR('Error Number: %d, Severity: %d, State: %d, Line: %d, %s%s', 15, 1,
                     @err_no, @err_severity, @err_state, @err_line, @newline, @err_message) WITH LOG
 
      END CATCH



