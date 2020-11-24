USE [YAF]
GO
/****** Object:  StoredProcedure [dbo].[DataExtract]    Script Date: 11/24/2020 9:40:36 AM ******/
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
	DBCC TRACEON(460, -1)--This gives us more detailed error messages, particularly for truncation errors.

	/*Clean staging tables*/
	TRUNCATE TABLE Load_AltAddr
	TRUNCATE TABLE Load_Attributes
	TRUNCATE TABLE Load_Books
	TRUNCATE TABLE Load_Donation
	TRUNCATE TABLE Load_Donor
	TRUNCATE TABLE Load_Events
	TRUNCATE TABLE Load_Lookups
	TRUNCATE TABLE Load_Mail
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

	--Notes
	SELECT 'Notes Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) 

	INSERT INTO YAF..Load_Notes
	SELECT * 
	FROM OPENQUERY(YAF, 'SELECT * FROM Notes')

	SELECT 'Notes Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

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

END





