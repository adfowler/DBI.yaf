ALTER PROCEDURE DataExtract AS
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
	TRUNCATE TABLE Load_Recognition

	/*Extract Data*/
	--AltAddr
	SELECT 'AltAddr Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_AltAddr
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM AltAddr WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'AltAddr Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)
	--SELECT CHAR(13)+CHAR(10)


	--Attributes
	SELECT 'Attributes Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Attributes
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Attributes WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Attributes Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Books
	SELECT 'Books Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Books
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Books WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Books Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Donation
	SELECT 'Donation Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Donation
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Donation WHERE gift_date >= ''2020-01-01'' LIMIT 10')

	SELECT 'Donation Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Donor
	SELECT 'Donor Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Donor
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Donor WHERE stamp <> add_date and stamp >= ''2020-01-01'' LIMIT 10')

	SELECT 'Donor Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Events
	SELECT 'Events Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Events
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Events WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Events Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Lookups
	SELECT 'Lookups Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Lookups
	SELECT *
	FROM openquery(YAF, 'SELECT * FROM Lookups LIMIT 10')

	SELECT 'Lookups Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Mail
	SELECT 'Mail Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Mail
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Mail WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Mail Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Notes
	SELECT 'Notes Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Notes
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Notes WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Notes Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Personal
	SELECT 'Personal Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Personal
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Personal WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Personal Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Phones
	SELECT 'Phones Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Phones
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Phones WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Phones Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Premiums
	SELECT 'Premiums Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Premiums
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Premiums WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Premiums Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

	--Recognition
	SELECT 'Recognition Start: '+ CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121)

	INSERT INTO YAF..Load_Recognition
	SELECT *
	FROM OPENQUERY(YAF, 'SELECT * FROM Recognition WHERE did in (select did from donation where gift_date >= ''2020-01-01'') LIMIT 10')

	SELECT 'Recognition Finish: ' + CONVERT(VARCHAR(25), CURRENT_TIMESTAMP, 121) + CHAR(13)+CHAR(10)

END
