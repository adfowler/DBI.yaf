/******************************************************************************************************/
/* DataPrep_Contact																					  */
/* Author: Andrew Fowler - December, 2021															  */
/*																									  */
/* OVERVIEW																							  */
/*  This script rolls data to the SF Contact level. It applies attribute and personal data to the     */
/*  contact record.																					  */
/*  Only default addresses are included.															  */
/******************************************************************************************************/


DECLARE @err_no int,
              @err_severity int,
              @err_state int,
              @err_line int,
              @err_message varchar(4000),
              @newline char(1)
 
BEGIN TRY

USE YAF

TRUNCATE TABLE upd_Contact

DROP INDEX IF EXISTS upd_Contract.idx_upd_Contact_did
DROP INDEX IF EXISTS upd_Contract.idx_upd_Contact_RCID_Hash

--Primary contacts (from donors)
INSERT INTO upd_Contact
SELECT 	--ckey 'ReaganomicsContactID',
		'P' + CAST(did AS VARCHAR(10))'ReaganomicsContactID',
		did,
		title 'Salutation',
		first 'FirstName',
		middle 'MiddleName', 
		last 'LastName',
		suffix 'Suffix',
		'Primary' 'relation',
		dateofbirth 'birthday',
		dateofdeath,
		CASE WHEN dateofdeath IS NOT NULL OR did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'DECEASED' or description = 'DECEASED') THEN 1 ELSE 0 END 'IndDeceased',
		ISNULL(emailaddress, '') 'EmailAddress',
		ISNULL(phone, '') 'cphone',
		'' 'alma_mater',
		'' 'grad_date',
		0 'BoardOfGovernrs',
		0 'RRCDocent',
		0 'BoardOfDirectors',
		0 'Parents',
		CAST(NULL AS DATE) 'Anniversary',
		CAST(NULL AS VARCHAR(50)) 'Veteran',
		NULL 'HashKey'
FROM V_DonorAddress 
WHERE did in (SELECT did FROM mst_Account) and
      defaultaddr = 1


--From contacts table
INSERT INTO upd_Contact (ReaganomicsContactID, did, FirstName, relation, birthday, dateofdeath, IndDeceased, EmailAddress, cphone, alma_mater, grad_date, BoardOfGovernrs, RRCDocent, BoardOfDirectors,Parents)
SELECT ckey,
		did,
		cname,
		relation,
		birthday,
		cdod,
		CASE WHEN cdod IS NULL THEN 0 ELSE 0 END,
		ISNULL(email_address, ''),
		ISNULL(cphone, ''),
		alma_mater,
		grad_date,
		0,
		0,
		0,
		0
FROM Load_Contact

CREATE INDEX idx_upd_Contact_did ON upd_Contact(did)
CREATE INDEX idx_upd_Contact_RCID_Hash ON upd_Contact(ReaganomicsContactID, HashKey)

/*Updates*/

--dateof death
UPDATE a
SET a.dateofdeath = b.dated
FROM upd_Contact a INNER JOIN Load_Attributes b
  on a.did = b.did
WHERE a.dateofdeath is null AND 
      a.ReaganomicsContactID LIKE 'P%' AND	-- primary contacts
     (b.uniquekey = 'DECEASED' or b.description = 'DECEASED')

--BoardOfGovernors
UPDATE upd_Contact
SET BoardOfGovernrs = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'BOARD OF GOVERNORS') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--RRCDocent
UPDATE upd_Contact
SET RRCDocent = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'RRC DOCENT') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--BoardOfDirectors
UPDATE upd_Contact
SET BoardOfDirectors = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'BOARD OF DIRECTORS') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--Parents
UPDATE upd_Contact
SET Parents = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE description LIKE '%Parents of conference%') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact


--Anniversary
UPDATE c
SET c.Anniversary = p.description
FROM upd_Contact c INNER JOIN Load_Personal p
  on c.did = p.did
WHERE p.uniquekey = 'anniversary' AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--Veteran
UPDATE c
SET c.Veteran = p.description
FROM upd_Contact c INNER JOIN Load_Personal p
  on c.did = p.did
WHERE p.uniquekey = 'veteran' AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact


--Blank last names
UPDATE a
SET a.LastName = b.institution
FROM upd_Contact a INNER JOIN V_DonorAddress b
  on a.did = b.did
WHERE (a.LastName = '' or a.LastName is null)
and a.ReaganomicsContactID LIKE 'P%'



--Bad emails
UPDATE upd_Contact
SET emailaddress = ''
WHERE emailaddress not like '%@%.%' or
	  emailaddress like '%@%@%' or
	  EmailAddress like '%..%'or
	  EmailAddress like '%.'

UPDATE upd_Contact
SET EmailAddress = REPLACE(EmailAddress, ' ' ,'')

--HashKey
UPDATE upd_Contact
SET HashKey =  HASHBYTES('MD5', (SELECT did, Salutation, FirstName, MiddleName, LastName, Suffix, relation, birthday, dateofdeath, IndDeceased, EmailAddress, cphone, alma_mater, grad_date, BoardOfGovernrs, RRCDocent, BoardOfDirectors, Parents, Anniversary, Veteran FROM (VALUES(null))foo(bar) FOR XML AUTO)) 

/*Determine updates/adds*/
DECLARE @updates int,
		@adds int,
		@table char(7) = 'Contact',
		@updatedate smalldatetime = CAST(getdate() AS DATE)

SET @updates = (SELECT COUNT(DISTINCT(u.did)) 
			   FROM upd_Contact u INNER JOIN mst_Contact m
				on u.ReaganomicsContactID = m.ReaganomicsContactID
			   WHERE u.HashKey <> m.HashKey)

SET @adds = (SELECT COUNT(DISTINCT(did))
			 FROM upd_Contact
			 WHERE ReaganomicsContactID not in (SELECT ReaganomicsContactID FROM mst_Contact)
			)

INSERT INTO UpdateLog(TableName, UpdateDate, Updates, Adds, Deletes)
SELECT @table, @updatedate, @updates, @adds, 0

/*Archive updates*/
INSERT INTO Archive_Contact
SELECT m.*, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM mst_Contact m INNER JOIN upd_Contact u
  on m.ReaganomicsContactID = u.ReaganomicsContactID
WHERE m.HashKey <> u.HashKey

/*Delete unchanged records*/
DELETE u
FROM upd_Contact u INNER JOIN mst_Contact m
 on u.ReaganomicsContactID = m.ReaganomicsContactID AND
    u.HashKey = m.HashKey

/*Merge with master*/
MERGE mst_Contact m
USING upd_Contact u
	ON m.ReaganomicsContactID = u.ReaganomicsContactID
WHEN MATCHED THEN
	UPDATE
	SET 
		m.did = u.did,
		m.Salutation = u.Salutation,
		m.FirstName = u.FirstName,
		m.MiddleName = u.MiddleName,
		m.LastName = u.LastName,
		m.Suffix = u.Suffix,
		m.relation = u.relation,
		m.birthday = u.birthday,
		m.dateofdeath = u.dateofdeath,
		m.IndDeceased = u.IndDeceased,
		m.EmailAddress = u.EmailAddress,
		m.cphone = u.cphone,
		m.alma_mater = u.alma_mater,
		m.grad_date = u.grad_date,
		m.BoardOfGovernrs = u.BoardOfGovernrs,
		m.RRCDocent = u.RRCDocent,
		m.BoardOfDirectors = u.BoardOfDirectors,
		m.Parents = u.Parents,
		m.Anniversary = u.Anniversary,
		m.Veteran = u.Veteran,
		m.HashKey = u.HashKey
WHEN NOT MATCHED THEN
	INSERT (ReaganomicsContactID, did, Salutation, FirstName, MiddleName, LastName, Suffix, relation, birthday, dateofdeath, IndDeceased, EmailAddress, cphone, alma_mater, grad_date, BoardOfGovernrs, RRCDocent, BoardOfDirectors, Parents, Anniversary, Veteran, HashKey)
	VALUES  (ReaganomicsContactID, did, Salutation, FirstName, MiddleName, LastName, Suffix, relation, birthday, dateofdeath, IndDeceased, EmailAddress, cphone, alma_mater, grad_date, BoardOfGovernrs, RRCDocent, BoardOfDirectors, Parents, Anniversary, Veteran, HashKey);

 END TRY
       BEGIN CATCH
              SELECT @err_no=ERROR_NUMBER(),
                     @err_severity=ERROR_SEVERITY(),
                     @err_state=ERROR_STATE(),
                     @err_line=ERROR_LINE(),
                     @err_message=ERROR_MESSAGE()
 
             SET @newline = CHAR(10)
 
              PRINT 'Error in the Contact sync process'
 
              RAISERROR('Error Number: %d, Severity: %d, State: %d, Line: %d, %s%s', 15, 1,
                     @err_no, @err_severity, @err_state, @err_line, @newline, @err_message) WITH LOG
 
      END CATCH
