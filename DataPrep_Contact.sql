SELECT *, 
	HASHBYTES('SHA2_256',
		ISNULL(UPPER(Salutation), '') +
		ISNULL(UPPER(FirstName), '') +
		ISNULL(UPPER(MiddleName), '') +
		ISNULL(UPPER(LastName), '') +
		ISNULL(UPPER(Suffix), '') +
		ISNULL(UPPER(relation), '') +
		ISNULL(UPPER(Salutation), '') +
		ISNULL(CAST(birthday AS VARCHAR(10)), '') +
		ISNULL(CAST(dateofdeath AS VARCHAR(10)), '') +
		ISNULL(UPPER(IndDeceased), '') +
		ISNULL(UPPER(EmailAddress), '') +
		ISNULL(UPPER(cphone), '') +
		ISNULL(UPPER(alma_mater), '') +
		ISNULL(UPPER(EmailAddress), '') +
		ISNULL(CAST(grad_date AS VARCHAR(10)), '') +
		ISNULL(UPPER(BoardOfGovernrs), '') +
		ISNULL(UPPER(RRCDocent), '') +
		ISNULL(UPPER(BoardOfDirectors), '') +
		ISNULL(UPPER(Parents), '') +
		ISNULL(UPPER(Anniversary), '') +
		ISNULL(UPPER(Veteran), '') 
		) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
INTO Archive_SFContact
FROM SF_Contact

CREATE INDEX idx_Archive_SFContact ON Archive_SFContact(did)
CREATE INDEX idx_HashKey ON Archive_SFContact(HashKey)

DROP TABLE IF EXISTS SF_Contact

--Primary
select 	--ckey 'ReaganomicsContactID',
		'P' + CAST(did AS VARCHAR(10))'ReaganomicsContactID',
		did,
		CASE WHEN b.Honorific = '' THEN a.title ELSE b.Honorific END 'Salutation',
		CASE WHEN b.FirstName = '' THEN a.first ELSE b.FirstName END 'FirstName',
		CASE WHEN b.MiddleName = '' THEN a.middle ELSE b.MiddleName END 'MiddleName', 
		CASE WHEN b.LastName = '' THEN a.last ELSE b.LastName END 'LastName',
		CASE WHEN b.Suffix = '' THEN a.suffix ELSE b.Suffix END 'Suffix',
		'Primary' 'relation',
		a.dateofbirth 'birthday',
		a.dateofdeath,
		CASE WHEN a.dateofdeath IS NOT NULL OR did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'DECEASED' or description = 'DECEASED') THEN 1 ELSE 0 END 'IndDeceased',
		ISNULL(a.emailaddress, '') 'EmailAddress',
		ISNULL(a.phone, '') 'cphone',
		'' 'alma_mater',
		'' 'grad_date',
		0 'BoardOfGovernrs',
		0 'RRCDocent',
		0 'BoardOfDirectors',
		0 'Parents',
		CAST(NULL AS DATE) 'Anniversary',
		CAST(NULL AS VARCHAR(50)) 'Veteran'
into SF_Contact
from V_DonorAddress a inner join Parser_Post b --ParserPost is from NameCruncher
  on a.did = b.DbId
where did in (select did from SF_Account) and
      a.defaultaddr = 1

CREATE INDEX idx_SF_Contact ON SF_Contact(did)

--spouses
INSERT INTO SF_Contact 
select 	'S' + DbId 'ReaganomicsContactID',
		DbId,
		'' 'Salutation',
		SpouseFirstName,
		SpouseMiddleName,
		a.LastName,
		'' Suffix,
		'Spouse' 'relation',
		NULL 'birthday',
		NULL 'DateOfDeath',
		0 'IndDeceased',
		'' 'email_address',
		b.cphone,
		'' 'alma_mater',
		'' 'grad_date',
		0 'BoardOfGovernrs',
		0 'RRCDocent',
		0 'BoardOfDirectors',
		0 'Parents',
		CAST(NULL AS DATE) 'Anniversary',
		CAST(NULL AS VARCHAR(50)) 'Veteran'
		FROM Parser_Post a INNER JOIN SF_Contact b
  on a.DbId = b.did
WHERE  SpouseFirstName <> ''

/*Updates*/
--dateof death
UPDATE a
SET a.dateofdeath = b.dated
FROM SF_Contact a INNER JOIN Load_Attributes b
  on a.did = b.did
WHERE a.dateofdeath is null and (b.uniquekey = 'DECEASED' or b.description = 'DECEASED')

--BoardOfGovernors
UPDATE SF_Contact
SET BoardOfGovernrs = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'BOARD OF GOVERNORS') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--RRCDocent
UPDATE SF_Contact
SET RRCDocent = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'RRC DOCENT') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--BoardOfDirectors
UPDATE SF_Contact
SET BoardOfDirectors = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'BOARD OF DIRECTORS') AND
	  ReaganomicsContactID LIKE 'P%' --Primary contact

--Parents
UPDATE SF_Contact
SET Parents = 1
WHERE did IN (SELECT did FROM Load_Attributes WHERE description LIKE '%Parents of conference%') 


--Anniversary
UPDATE c
SET c.Anniversary = p.description
FROM SF_Contact c INNER JOIN Load_Personal p
  on c.did = p.did
WHERE p.uniquekey = 'anniversary'


--Veteran
UPDATE c
SET c.Veteran = p.description
FROM SF_Contact c INNER JOIN Load_Personal p
  on c.did = p.did
WHERE p.uniquekey = 'veteran'

CREATE INDEX idx_SF_Contact_ReaganomicsContactID on SF_Contact (ReaganomicsContactID)
--CREATE INDEX idx_LoadedAccounts_ReaganomicsContactID on Staging..LoadedContacts (Reaganomics_Contact_ID__c)


--Blank last names
ALTER TABLE SF_Contact
ALTER COLUMN LastName varchar(100)

UPDATE a
SET a.LastName = b.institution
FROM SF_Contact a INNER JOIN V_DonorAddress b
  on a.did = b.did
WHERE (a.LastName = '' or a.LastName is null)
and a.ReaganomicsContactID LIKE 'P%'



--Bad emails
UPDATE SF_Contact
SET emailaddress = ''
WHERE emailaddress not like '%@%.%' or
	  emailaddress like '%@%@%' or
	  EmailAddress like '%..%'or
	  EmailAddress like '%.'


UPDATE SF_Contact
SET EmailAddress = REPLACE(EmailAddress, ' ' ,'')


UPDATE SF_Contact
SET LastName = 'Hunter'
WHERE did = 362345

ALTER TABLE SF_Contact
ADD HashKey varbinary(8000)

UPDATE SF_Contact
SET HashKey = HASHBYTES('SHA2_256',
		ISNULL(UPPER(Salutation), '') +
		ISNULL(UPPER(FirstName), '') +
		ISNULL(UPPER(MiddleName), '') +
		ISNULL(UPPER(LastName), '') +
		ISNULL(UPPER(Suffix), '') +
		ISNULL(UPPER(relation), '') +
		ISNULL(UPPER(Salutation), '') +
		ISNULL(CAST(birthday AS VARCHAR(10)), '') +
		ISNULL(CAST(dateofdeath AS VARCHAR(10)), '') +
		ISNULL(UPPER(IndDeceased), '') +
		ISNULL(UPPER(EmailAddress), '') +
		ISNULL(UPPER(cphone), '') +
		ISNULL(UPPER(alma_mater), '') +
		ISNULL(UPPER(EmailAddress), '') +
		ISNULL(CAST(grad_date AS VARCHAR(10)), '') +
		ISNULL(UPPER(BoardOfGovernrs), '') +
		ISNULL(UPPER(RRCDocent), '') +
		ISNULL(UPPER(BoardOfDirectors), '') +
		ISNULL(UPPER(Parents), '') +
		ISNULL(UPPER(Anniversary), '') +
		ISNULL(UPPER(Veteran), '') 
		)
CREATE INDEX idx_HashKey ON SF_Contact(HashKey)

--New/Updated records
SELECT *
FROM SF_Contact
WHERE HashKey NOT IN (SELECT HashKey FROM Archive_SFContact)

select * from SF_Contact where did = 245057
select * from Archive_SFContact where did = 245057
 
--See what contacts didn't make it
SELECT *
FROM SF_Contact
WHERE ReaganomicsContactID NOT IN (SELECT Reaganomics_Contact_ID__c FROM LoadedContacts WHERE SystemModstamp > '2021-09-21')

--Everything with an email address that didn't make it in the first load failed becuase of bad formattting, set to blank
UPDATE SF_Contact
SET EmailAddress = ''
WHERE ReaganomicsContactID NOT IN (SELECT Reaganomics_Contact_ID__c FROM LoadedContacts WHERE SystemModstamp > '2021-09-21')
  AND EmailAddress <> ''

--Last Names not making it in. Set to anonymous?
UPDATE SF_Contact
SET LastName = 'Anonymous'
WHERE ReaganomicsContactID NOT IN (SELECT Reaganomics_Contact_ID__c FROM LoadedContacts WHERE SystemModstamp > '2021-09-21')
  AND (LastName IS NULL OR LastName = '')

--truncate table loadedaccounts

