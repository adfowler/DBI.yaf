/******************************************************************************************************/
/* LoadSFIds 																					      */
/* Author: Andrew Fowler - December, 2021															  */
/*																									  */
/* OVERVIEW																							  */
/*  This script loads the IDs from Salesforce that are needed during the sync process			      */
/******************************************************************************************************/

DECLARE @err_no int,
              @err_severity int,
              @err_state int,
              @err_line int,
              @err_message varchar(4000),
              @newline char(1)
 
BEGIN TRY

USE YAF

--WAITFOR TIME '06:00:00';

/*xref_Account*/
	TRUNCATE TABLE xref_Account

	/*Get table ready for insert*/
	ALTER TABLE xref_Account DROP CONSTRAINT pk_xref_Account

	ALTER TABLE xref_Account
	ALTER COLUMN did varchar(15)

	/*Load file*/
		--export file from jitterbit 
		BULK INSERT xref_Account
		FROM 'D:\Processes\YAF\SFUpdate\Data\LoadedAccounts.csv'
		WITH
		(
			FIRSTROW = 2, --Second row if header row in file
			FIELDTERMINATOR = ',',  --CSV field delimiter
			ROWTERMINATOR = '\n',   --Use to shift the control to next row
			--ERRORFILE = 'D:\Processes\YAF\SFUpdate\Logs\LoadedAccounts_log',
			TABLOCK
		)

	/*Clean table*/
	DELETE FROM xref_Account
	WHERE did = '""'

	ALTER TABLE xref_Account
	ALTER COLUMN did int NOT NULL

	ALTER TABLE xref_Account
	ADD CONSTRAINT pk_xref_Account PRIMARY KEY (did)


/*xref_Donation*/
	TRUNCATE TABLE xref_Donation

	/*Get table ready for insert*/
	ALTER TABLE xref_Donation DROP CONSTRAINT pk_xref_Donation

	ALTER TABLE xref_Donation
	ALTER COLUMN dkey varchar(15)


	/*Load file*/
		--export file from jitterbit 
		BULK INSERT xref_Donation
		FROM 'D:\Processes\YAF\SFUpdate\Data\LoadedDonations.csv'
		WITH
		(
			FIRSTROW = 2, --Second row if header row in file
			FIELDTERMINATOR = ',',  --CSV field delimiter
			ROWTERMINATOR = '\n',   --Use to shift the control to next row
			--ERRORFILE = 'D:\Processes\YAF\SFUpdate\Logs\LoadedDonations_log',
			TABLOCK
		)

	/*Clean table*/
	DELETE FROM xref_Donation
	WHERE dkey = '""'

	ALTER TABLE xref_Donation
	ALTER COLUMN dkey int NOT NULL

	ALTER TABLE xref_Donation
	ADD CONSTRAINT pk_xref_Donation PRIMARY KEY (dkey)

/*xref_Notes*/
	TRUNCATE TABLE xref_Notes

	/*Get table ready for insert*/
	ALTER INDEX ALL ON xref_Notes DISABLE
	--ALTER TABLE xref_Notes DROP CONSTRAINT pk_xref_Notes

	ALTER TABLE xref_Notes
	ALTER COLUMN nid varchar(15)


	/*Load file*/
		--export file from jitterbit 
		BULK INSERT xref_Notes
		FROM 'D:\Processes\YAF\SFUpdate\Data\LoadedTasks.csv'
		WITH
		(
			FIRSTROW = 2, --Second row if header row in file
			FIELDTERMINATOR = ',',  --CSV field delimiter
			ROWTERMINATOR = '\n',   --Use to shift the control to next row
			--ERRORFILE = 'D:\Processes\YAF\SFUpdate\Logs\LoadedDonations_log',
			TABLOCK
		)

	/*Clean table*/
	DELETE FROM xref_Notes
	WHERE nid = '""'

	ALTER TABLE xref_Notes
	ALTER COLUMN nid int NOT NULL

	ALTER INDEX ALL ON xref_Notes REBUILD
	--ALTER TABLE xref_Notes
	--ADD CONSTRAINT pk_xref_Notes PRIMARY KEY (nid) 


 END TRY
       BEGIN CATCH
              SELECT @err_no=ERROR_NUMBER(),
                     @err_severity=ERROR_SEVERITY(),
                     @err_state=ERROR_STATE(),
                     @err_line=ERROR_LINE(),
                     @err_message=ERROR_MESSAGE()
 
             SET @newline = CHAR(10)
 
              PRINT 'Error in the SF IDs load process'
 
              RAISERROR('Error Number: %d, Severity: %d, State: %d, Line: %d, %s%s', 15, 1,
                     @err_no, @err_severity, @err_state, @err_line, @newline, @err_message) WITH LOG
 
      END CATCH