/******************************************************************************************************/
/* DataPrep_Donation																				  */
/* Author: Andrew Fowler - December, 2021															  */
/*																									  */
/* OVERVIEW																							  */
/*  This script rolls data to the SF Donation level. It uses data from donations and projects         */
/******************************************************************************************************/


DECLARE @err_no int,
              @err_severity int,
              @err_state int,
              @err_line int,
              @err_message varchar(4000),
              @newline char(1)

 
BEGIN TRY

USE YAF


TRUNCATE TABLE upd_Donation


--ALTER INDEX ALL ON upd_Donation DISABLE

INSERT INTO upd_Donation
SELECT DISTINCT 
		dkey, 
		d.did , 
		gift_date, 
		amount, 
		ld.SF_Value 'don_type', 
		ld.Method, 
		ld.Description 'ReganomicsDonationType', 
		check_num, 
		d.thank_you, 
		'Received' 'Stage', --there are future donations but those are said to be typos by YAF
		ISNULL(a.last,'') + ' - ' +  cast(gift_date as varchar(15)) 'DonationName',
		d.source,
		MIN(lp.pid) 'pid',
		CAST('' AS VARCHAR(50))	'Description',
		CAST(0 AS BIT) 'PotentialDupe',
		NULL 'HashKey'
FROM Load_Donation d INNER JOIN mst_Account a
  on d.did = a.did
INNER JOIN Load_Projects lp	--Records get rejected if they aren't from known campaigns
  on d.source = lp.source
LEFT JOIN lkup_DonType ld
  on d.don_type = ld.Don_Type
GROUP BY d.dkey, d.did, gift_date, amount, ld.SF_Value, ld.Method, ld.Description, check_num, d.thank_you, d.source, a.last

--ALTER INDEX ALL ON upd_Donation REBUILD


/*Drops for records that will fail becuase of missing data in other tables. They will error when loading into Salesforce*/

--campaigns we haven't loaded yet. 
DELETE FROM upd_Donation
WHERE pid NOT IN (SELECT pid FROM mst_Campaign)

--people we haven't loaded yet.
DELETE FROM upd_Donation
WHERE did NOT IN (SELECT did FROM mst_Account)

/*Data fixes*/
--Bad check_num
UPDATE upd_Donation
SET Description = check_num,
	check_num = ''
WHERE (ISNUMERIC(CHECK_NUM) = 0 
   or LEN(check_num) > 12)


--Bad dates
--1010 -> 2010
UPDATE upd_Donation
SET gift_date = DATEADD(YEAR,1000,GIFT_DATE)
WHERE YEAR(GIFT_DATE) = 1010

--0200 -> 2000
UPDATE upd_Donation
SET gift_date = REPLACE(gift_date, '0200', '2000')
WHERE YEAR(gift_date) = 0200

--0201 -> 2021. Based on similar dkeys
UPDATE upd_Donation
SET gift_date = REPLACE(gift_date, '0201', '2021')
WHERE YEAR(gift_date) = 0201

DROP TABLE IF EXISTS #datefix

/* Fix bad dates */
--Grabs most recent good date for records with bad gift date
SELECT a.*, c.NewDate
INTO #datefix
FROM upd_Donation a CROSS APPLY (SELECT MAX(Gift_Date) 'NewDate' FROM upd_Donation b WHERE b.dkey between a.dkey - 5 and a.dkey and b.gift_date > '1950-01-01') c
WHERE a.gift_date <  '1950-01-01' 

UPDATE a
SET a.gift_date = b.NewDate
FROM upd_Donation a INNER JOIN #datefix b
  on a.dkey = b.dkey

UPDATE a
SET DonationName = ISNULL(c.last,'') + ' - ' +  cast(a.gift_date as varchar(15))
FROM upd_Donation a INNER JOIN #datefix b
  on a.dkey = b.dkey
INNER JOIN mst_Account c
  on a.did = c.did


UPDATE upd_Donation
SET DonationName = 'Anonymous - ' +  cast(gift_date as varchar(15))
WHERE did in (SELECT did FROM mst_Account WHERE name = 'Anonymous')


/*Duplicates*/
DROP TABLE IF EXISTS #DonationDupes

SELECT DISTINCT a.dkey, a.gift_date, a.did, a.amount
INTO #DonationDupes
FROM upd_Donation a INNER JOIN upd_Donation b
  on a.did = b.did and
	 a.gift_date = b.gift_date and
	 a.amount = b.amount
WHERE a.dkey <> b.dkey
ORDER BY did


UPDATE a
SET a.PotentialDupe = 1
FROM upd_Donation a INNER JOIN #DonationDupes b
  on a.dkey = b.dkey

UPDATE upd_Donation
SET PotentialDupe = 0
WHERE PotentialDupe IS NULL

/*Update HashKey*/
UPDATE upd_donation
SET HashKey =  HASHBYTES('MD5', (SELECT did, gift_date, amount, don_type, Method, ReganomicsDonationType, check_num, thank_you, Stage, DonationName, pid, Description, PotentialDupe FROM (VALUES(null))foo(bar) FOR XML AUTO)) 


/*Determine updates/adds*/
DECLARE @updates int,
		@adds int,
		@deletes int,
		@table char(8) = 'Donation',
		@updatedate smalldatetime = CAST(getdate() AS DATE)

SET @updates = (SELECT COUNT(DISTINCT(u.dkey)) 
			    FROM upd_donation u INNER JOIN mst_Donation m
				 on u.dkey = m.dkey
			    WHERE u.HashKey <> m.HashKey)


SET @adds = (SELECT COUNT(DISTINCT(dkey))
			 FROM upd_donation
			 WHERE dkey not in (SELECT dkey FROM mst_Donation)
			)

SET @deletes = (SELECT COUNT(DISTINCT(dkey))
				FROM mst_Donation
				WHERE dkey not in (SELECT dkey FROM upd_Donation)
			   )


INSERT INTO UpdateLog(TableName, UpdateDate, Updates, Adds, Deletes)
SELECT @table, @updatedate, @updates, @adds, @deletes


/*Archive*/
--Updates
INSERT INTO Archive_Donation
SELECT m.*, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM mst_Donation m INNER JOIN upd_Donation u
  on m.dkey = u.dkey
WHERE m.HashKey <> u.HashKey

--Deletes
INSERT INTO Archive_Donation
SELECT m.*, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM mst_Donation m
WHERE dkey not in (SELECT dkey FROM upd_Donation)

/*Export for donation deletions*/
--Running from TSQL since it's just a 1 column export of a few records.
-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1;  
  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
  
-- To enable the feature.  
EXECUTE sp_configure 'xp_cmdshell', 1;  
  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
 
DECLARE @sql varchar(8000)
SELECT @sql = 'bcp "SELECT ''Id'' union all SELECT dx.Id FROM yaf..mst_Donation m INNER JOIN yaf..xref_Donation dx on m.dkey = dx.dkey WHERE m.dkey not in (SELECT dkey FROM yaf..upd_Donation)" queryout D:\Processes\YAF\SFUpdate\Data\DeletedDonations.csv -c -t, -T -S' + @@servername
exec master..xp_cmdshell @sql

/*
another way to find deletes
 select *
 from Archive_Donation 
 where dkey not in (select dkey from yaf..upd_Donation)
 and archivedate = cast(getdate() as date)

 */

/*Remove deleted donations*/
DELETE mst_Donation 
WHERE dkey not in (SELECT dkey FROM upd_Donation)

/*Delete unchanged records*/
DELETE u
FROM upd_Donation u INNER JOIN mst_Donation m
 on u.did = m.did and
    u.HashKey = m.HashKey


/*Merge with master*/
MERGE mst_Donation m
USING upd_Donation u
	ON m.dkey = u.dkey
WHEN MATCHED THEN
	UPDATE
	SET m.did = u.did,
		m.gift_date = u.gift_date,
		m.amount = u.amount,
		m.don_type = u.don_type,
		m.Method = u.Method,
		m.ReganomicsDonationType = u.ReganomicsDonationType,
		m.check_num = u.check_num,
		m.thank_you = u.thank_you,
		m.Stage = u.Stage,
		m.DonationName = u.DonationName,
		m.source = u.source,
		m.pid = u.pid,
		m.Description = u.Description,
		m.PotentialDupe = u.PotentialDupe,
		m.HashKey = u.HashKey

WHEN NOT MATCHED THEN
	INSERT (dkey, did, gift_date, amount, don_type, Method, ReganomicsDonationType, check_num, thank_you, Stage, DonationName, source, pid, Description, PotentialDupe, HashKey)
	VALUES (dkey, did, gift_date, amount, don_type, Method, ReganomicsDonationType, check_num, thank_you, Stage, DonationName, source, pid, Description, PotentialDupe, HashKey);

 END TRY
       BEGIN CATCH
              SELECT @err_no=ERROR_NUMBER(),
                     @err_severity=ERROR_SEVERITY(),
                     @err_state=ERROR_STATE(),
                     @err_line=ERROR_LINE(),
                     @err_message=ERROR_MESSAGE()
 
             SET @newline = CHAR(10)
 
              PRINT 'Error in the Donation sync process'
 
              RAISERROR('Error Number: %d, Severity: %d, State: %d, Line: %d, %s%s', 15, 1,
                     @err_no, @err_severity, @err_state, @err_line, @newline, @err_message) WITH LOG
 
       END CATCH

