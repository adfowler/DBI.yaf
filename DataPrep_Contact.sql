DROP TABLE IF EXISTS SF_Contact

--Primary
select 	--ckey 'ReaganomicsContactID',
		'P' + CAST(did AS VARCHAR(10))'ReaganomicsContactID',
		did,
		b.Honorific 'Salutation',
		b.FirstName,
		b.MiddleName,
		b.LastName,
		b.Suffix,
		'Primary' 'relation',
		a.dateofbirth 'birthday',
		a.dateofdeath,
		a.emailaddress,
		a.phone 'cphone',
		'' 'alma_mater',
		'' 'grad_date',
		0 'BoardOfGovernrs',
		0 'RRCDocent',
		0 'BoardOfDirectors',
		0 'Parents',
		CAST(NULL AS DATE) 'Anniversary',
		CAST(NULL AS VARCHAR(50)) 'Veteran'
into SF_Contact
from V_DonorAddress a inner join Parser_Post b
  on a.did = b.DbId
where did IN (SELECT did FROM SF_Account) --accounts need to be loaded first
--did in (select DbId from parser_post where spousefirstname <> '')  and
      /*did in (23978,23981,23986,23989,23991,23993,23995,23999,24000,24005,24006,24009,24016,24021,24022,24026,24027,24030,24042,24044,
24045,24047,24049,24051,24053,24054,24055,24056,24061,24062,24064,24066,24071,24073,24074,24075,24076,24079,24082,24084,24086,
24090,24092,24094,24096,24098,24102,24105,24107,24110,24111,24112,24113,24115,24118,24120,24129,24270,24381,24427,24525,
24572,24663,24700,24734,24833,24882,24932,24965,24986,25084,25171,25212,25227,25277,25328,25442,25499,25628,25832,25881,
26019,26085,26110,26168,26303,26347,26365,26608,26691,26804,27056,27072,27195,27223,27256,27258,27670,27809,27867,27869,
27942);--IN Account
*/
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
		b.cphone,
		'' 'alma_mater',
		'' 'grad_date',
		'' 'email_address',
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
--BoardOfGovernors
UPDATE c
SET c.BoardOfGovernrs = 1
FROM SF_Contact c INNER JOIN Load_Attributes a
  on c.did = a.did
WHERE a.uniquekey = 'BOARD OF GOVERNORS' AND
      c.ReaganomicsContactID LIKE 'P%'

--RRCDocent
UPDATE c
SET c.RRCDocent = 1
FROM SF_Contact c INNER JOIN Load_Attributes a
  on c.did = a.did
WHERE a.uniquekey = 'RRC Docent' AND
      c.ReaganomicsContactID LIKE 'P%'

--BoardOfDirectors
UPDATE c
SET c.BoardOfDirectors = 1
FROM SF_Contact c INNER JOIN Load_Attributes a
  on c.did = a.did
WHERE a.uniquekey = 'BOARD OF DIRECTORS' AND
      c.ReaganomicsContactID LIKE 'P%'


--Parents
UPDATE c
SET c.Parents = 1
FROM SF_Contact c INNER JOIN Load_Attributes a
  on c.did = a.did
WHERE a.uniquekey = 'PARENTS'


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


select *
from SF_Contact