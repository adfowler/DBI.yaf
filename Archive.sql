/*

Archives previously loaded data

*/

--AltAddr
INSERT INTO Archive_AltAddr
SELECT *, 
	HASHBYTES('SHA2_256',
	CAST(did AS VARCHAR(10))+
	ISNULL(UPPER(addr_type), '') +
	ISNULL(UPPER(addr2), '')  +
	ISNULL(UPPER(street), '') +
	ISNULL(UPPER(city), '') +
	ISNULL(UPPER(state), '')  +
	ISNULL(UPPER(left(zip,5)), '')  +
	ISNULL(UPPER(alt_from), '')  + 
	ISNULL(UPPER(alt_to), '') +
	ISNULL(UPPER(alt_annual), '') +
	ISNULL(UPPER(institution), '') +
	ISNULL(UPPER(phone), '')  +
	ISNULL(UPPER(defaultaddr), '')   +
	--ISNULL(UPPER(longitude), '')  + 
	--ISNULL(UPPER(latitude), '') +
	ISNULL(UPPER(country), '') +
	ISNULL(UPPER(vanity), '')  
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_AltAddr


--Attributes
INSERT INTO Archive_Attributes
SELECT *,
	HASHBYTES('SHA2_256',
	uniquekey +
	ISNULL(Description, '')
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Attributes

--Books
INSERT INTO Archive_Books
SELECT *,
	HASHBYTES('SHA2_256',
	uniquekey +
	ISNULL(Description, '')
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Books

--Conference
INSERT INTO Archive_Conference
SELECT *, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Conference

--Contact
INSERT INTO Archive_Contact
SELECT *, 
	HASHBYTES('SHA2_256',
	CAST(did as varchar(10)) +
	cname +
	ISNULL(relation, '') +
	ISNULL(CAST(birthday AS VARCHAR(10)), '') +
	ISNULL(cphone, '') +
	ISNULL(alma_mater, '') +
	ISNULL(CAST(grad_date AS VARCHAR(10)), '') +
	ISNULL(email_address, '') +
	ISNULL(CAST(cdod AS VARCHAR(10)), '') 
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Contact

--Donation
INSERT INTO Archive_Donation
SELECT *,
	HASHBYTES('SHA2_256',
	ISNULL(CAST(did as varchar(10)), '') +
	ISNULL(source, '') +
	ISNULL(CAST(gift_date as varchar(10)), '') +
	ISNULL(CAST(amount as varchar(25)), '') +
	ISNULL(don_type, '') +
	ISNULL(check_num, '') +
	ISNULL(thank_you, '') 
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Donation

--Donor
INSERT INTO Archive_Donor
SELECT *,
	HASHBYTES('SHA2_256',
	ISNULL(CAST(did as varchar(10)), '') +
	ISNULL(title, '') +
	ISNULL(name, '') +
	ISNULL(first, '') +
	ISNULL(middle, '') +
	ISNULL(last, '') +
	ISNULL(suffix, '') +
	ISNULL(salutation, '') +
	ISNULL(CAST(add_date as varchar(10)), '') +
	ISNULL(CAST(cumulative as varchar(15)), '') +
	ISNULL(movemgr, '') +
	ISNULL(CAST(dateofbirth as varchar(10)), '') +
	ISNULL(CAST(dateofdeath as varchar(10)), '') +
	ISNULL(ModifiedUserId, '') +
	ISNULL(emailaddress, '') +
	ISNULL(frozen, '') +
	ISNULL(CAST(spousedod as varchar(10)), '') +
	ISNULL(movemgr2, '')
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Donor

--Events
INSERT INTO Archive_Events
SELECT *,
	HASHBYTES('SHA2_256',
	uniquekey +
	ISNULL(Description, '')
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Events

--Lookups
INSERT INTO Archive_Lookups 
SELECT *,
	HASHBYTES('SHA2_256',
		ISNULL(CAST(lid as varchar(10)), '') +
		ISNULL(lu_group, '') +
		ISNULL(lu_unique, '') +
		ISNULL(lu_desc, '') +
		ISNULL(CAST(lu_multi as varchar(5)), '') +
		ISNULL(lu_type, '') +
		ISNULL(lu_desc2, '') 
		) 'HashKey',
			CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Lookups

--Mail
INSERT INTO Archive_Mail
SELECT *,
	HASHBYTES('SHA2_256',
	uniquekey +
	ISNULL(Description, '')
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Mail

--MailAttribute
INSERT INTO Archive_MailAttribute
SELECT *, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_MailAttribute

--Notes 
INSERT INTO Archive_Notes (Nid, Did, Dated, Uid, Noted, Timein, ArchiveDate)
SELECT *, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Notes


UPDATE Archive_Notes
SET HashKey = HASHBYTES('SHA2_256',
			ISNULL(CAST(did as varchar(10)), '') +
			ISNULL(CAST(Dated as varchar(10)), '') +
			ISNULL(CAST(noted AS varchar(max)), '')
			)



--Personal
INSERT INTO Archive_Personal
SELECT *,
	HASHBYTES('SHA2_256',
	uniquekey +
	ISNULL(Description, '')
	) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Personal

--Phones
INSERT INTO Archive_Phones
SELECT *,
	HASHBYTES('SHA2_256',
		ISNULL(CAST(did as varchar(10)), '') +
		ISNULL(ttype, '') +
		ISNULL(phone, '') +
		ISNULL(ext, '') +
		ISNULL(status, '')
		) 'HashKey',
		CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Phones

--Premiums
INSERT INTO Archive_Premiums
SELECT *,
	HASHBYTES('SHA2_256',
		ISNULL(CAST(did as varchar(10)), '') +
		ISNULL(uniquekey, '') +
		ISNULL(description, '')
		) 'HashKey',
		CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Premiums

--Projects
INSERT INTO Archive_Projects
SELECT *, CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Projects

--Recognition
INSERT INTO Archive_Recognition
SELECT *,
	HASHBYTES('SHA2_256',
		ISNULL(CAST(did as varchar(10)), '') +
		ISNULL(uniquekey, '') +
		ISNULL(description, '')
		) 'HashKey',
		CAST(GETDATE() AS DATE) 'ArchiveDate'
FROM Load_Recognition

--SF_Account
INSERT INTO Archive_SFAccount
SELECT *, CAST(GETDATE() AS DATE)
FROM SF_Account