USE [YAF]
GO
/****** Object:  StoredProcedure [dbo].[DataExtract]    Script Date: 12/21/2021 5:41:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DataExtract] AS
-- =============================================
-- Author:		Andrew Fowler
-- Create date: 11/10/2020
-- Description:	This procedure should only be run after hours. It pulls in data from YAF's linked server db into our YAF db.
--==============================================

BEGIN
	/*Prep*/
	SET NOCOUNT ON
	DBCC TRACEON(460)--This gives us more detailed error messages, particularly for truncation errors. DBCC TRACEON(460, -1) Sets it on gloabally, not just this session.

	/*Clean staging tables*/
	TRUNCATE TABLE Load_AltAddr
	TRUNCATE TABLE Load_Attributes
	TRUNCATE TABLE Load_Books
	TRUNCATE TABLE Load_Conference
	TRUNCATE TABLE Load_Contact
	TRUNCATE TABLE Load_Donation
	TRUNCATE TABLE Load_Donor
	TRUNCATE TABLE Load_Events
	TRUNCATE TABLE Load_Lookups
	TRUNCATE TABLE Load_Mail
	TRUNCATE TABLE Load_MailAttribute
	TRUNCATE TABLE Load_Notes
	TRUNCATE TABLE Load_Personal
	TRUNCATE TABLE Load_Phones
	TRUNCATE TABLE Load_Premiums
	TRUNCATE TABLE Load_Projects
	TRUNCATE TABLE Load_Recognition

	/*Extract Data*/
	--AltAddr
	SELECT 'AltAddr Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_AltAddr
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM AltAddr')
	
	SELECT 'AltAddr Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)
	--SELECT CHAR(13)+CHAR(10)
	

	--Attributes
	SELECT 'Attributes Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Attributes
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Attributes')

	SELECT 'Attributes Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Books
	SELECT 'Books Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Books
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Books')

	SELECT 'Books Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Conference
	SELECT 'Conference Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Conference
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Conference')

	SELECT 'Conference Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)



	--Contact
	SELECT 'Contact Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Contact
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM contact')

	SELECT 'Contact Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Donation
	SELECT 'Donation Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Donation
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Donation')

	SELECT 'Donation Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Donor
	SELECT 'Donor Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Donor
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Donor')

	SELECT 'Donor Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Events
	SELECT 'Events Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Events
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Events')

	SELECT 'Events Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Lookups
	SELECT 'Lookups Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Lookups
	SELECT *
	FROM openquery(YAF, 'SELECT * FROM Lookups')

	SELECT 'Lookups Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Mail
	SELECT 'Mail Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Mail
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Mail')
	
	SELECT 'Mail Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)


	--MailAttribute
	SELECT 'MailAttribute Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_MailAttribute
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM MailAttribute')
	
	SELECT 'MailAttribute Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Personal
	SELECT 'Personal Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Personal
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Personal')

	SELECT 'Personal Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Phones
	SELECT 'Phones Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Phones
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Phones')

	SELECT 'Phones Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Premiums
	SELECT 'Premiums Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Premiums
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Premiums')

	SELECT 'Premiums Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Projects
	SELECT 'Projects Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Projects
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Projects')

	SELECT 'Projects Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Recognition
	SELECT 'Recognition Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Recognition
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Recognition')

	SELECT 'Recognition Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Notes
	SELECT 'Notes Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	/* FYI: this might throw an "out of memory" error when trying to run. If so, you need to allow inprocess for the linked server provider:
				    Open Server Objects -> Linked Servers -> Providers
					Right click on MSDASQL and click Properties.
					Enable Allow inprocess provider options.
					Run query again.
	*/

	EXEC master.dbo.sp_MSset_oledb_prop N'MSDASQL', N'AllowInProcess', 1

	INSERT INTO YAF..Load_Notes
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Notes WHERE dated >= ''2019-01-01''')

	EXEC master.dbo.sp_MSset_oledb_prop N'MSDASQL', N'AllowInProcess', 0

	SELECT 'Notes Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	/*QA the counts of a few tables*/
	--add tables you want to qa here.
	EXEC QA_ExtractUpdate 'AltAddr'
	EXEC QA_ExtractUpdate 'Donation'
	EXEC QA_ExtractUpdate 'Donor'

	DBCC TRACEOFF(460)

END





