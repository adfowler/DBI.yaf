/******************************************************************************************************************************************/
/* This script rolls data to the SF Account level. It joins Donors to AltAddr, then rolls up Books, Events, Mail, Pekrsonal, Premiums,    */
/* and Recognition into delimited string fields. Only default addresses are included.                                                     */
/******************************************************************************************************************************************/


/*

This script can and should be cleaned up/organized. It doesn't take long to run, but we don't need to hit tables multiple times (for example the load_attributes table).


*/

USE YAF



DROP TABLE IF EXISTS SF_Account

;WITH 
at1 AS (
  SELECT DISTINCT
    did,
    CASE
      WHEN charindex(uniquekey, description) > 0    THEN description  -- uniquekey is included in the description
      WHEN description = ' ' OR description IS NULL THEN uniquekey
      WHEN uniquekey   = ' ' OR uniquekey   IS NULL THEN description
      ELSE uniquekey + ' (' + description + ')'                       -- enclose description in parenthesis
    END 'Attribute'
  FROM Load_Attributes
),
attributelist AS (
  SELECT did, STRING_AGG(Attribute, ';')  WITHIN GROUP (ORDER BY Attribute ASC) 'AttributeList'
  FROM at1
  GROUP BY did
),
bk1 AS (
  SELECT DISTINCT did, uniquekey
  FROM Load_Books
),
booklist AS (
  SELECT did, STRING_AGG(uniquekey, ';')  WITHIN GROUP (ORDER BY uniquekey ASC) 'BookList'
  FROM bk1
  GROUP BY did
),
ev1 AS (
  SELECT DISTINCT
    did,
    CASE
      WHEN charindex(uniquekey, description) > 0    THEN description  -- uniquekey is included in the description
      WHEN description = ' ' OR description IS NULL THEN uniquekey
      WHEN uniquekey   = ' ' OR uniquekey   IS NULL THEN description
      ELSE uniquekey + ' (' + description + ')'                       -- enclose description in parenthesis
    END 'SFEvent'
  FROM Load_Events
),
eventlist AS (
  SELECT did, STRING_AGG(SFEvent, ';')  WITHIN GROUP (ORDER BY SFEvent ASC) 'EventList'
  FROM ev1
  GROUP BY did
),
ml1 AS (
  SELECT DISTINCT
    did,
    CASE
      WHEN charindex(uniquekey, description) > 0    THEN description  -- uniquekey is included in the description
      WHEN description = ' ' OR description IS NULL THEN uniquekey
      WHEN uniquekey   = ' ' OR uniquekey   IS NULL THEN description
      ELSE uniquekey + ' (' + description + ')'                       -- enclose description in parenthesis
    END 'SFMail'
  FROM Load_Mail
),
maillist AS (
  SELECT did, STRING_AGG(SFMail, ';')  WITHIN GROUP (ORDER BY SFMail ASC) 'MailList'
  FROM ml1
  GROUP BY did
),
pl1 AS (
  SELECT DISTINCT
    did,
    CASE
      WHEN charindex(uniquekey, description) > 0    THEN description  -- uniquekey is included in the description
      WHEN description = ' ' OR description IS NULL THEN uniquekey
      WHEN uniquekey   = ' ' OR uniquekey   IS NULL THEN description
      ELSE uniquekey + ' (' + description + ')'                       -- enclose description in parenthesis
    END 'SFPersonal'
  FROM Load_Personal
),
personallist AS (
  SELECT did, STRING_AGG(SFPersonal, ';')  WITHIN GROUP (ORDER BY SFPersonal ASC) 'PersonalList'
  FROM pl1
  GROUP BY did
),
pr1 AS (
  SELECT DISTINCT did, uniquekey 'SFPremium'
  FROM Load_Premiums
),
premiumlist AS (
  SELECT did, STRING_AGG(SFPremium, ';')  WITHIN GROUP (ORDER BY SFPremium ASC) 'PremiumList'
  FROM pr1
  GROUP BY did
),
rc1 AS (
  SELECT DISTINCT
    did,
    CASE
      WHEN charindex(uniquekey, description) > 0    THEN description  -- uniquekey is included in the description
      WHEN description = ' ' OR description IS NULL THEN uniquekey
      WHEN uniquekey   = ' ' OR uniquekey   IS NULL THEN description
      ELSE uniquekey + ' (' + description + ')'                       -- enclose description in parenthesis
    END 'SFRecognition'
  FROM Load_Recognition
),
recognitionlist AS (
  SELECT did, STRING_AGG(SFRecognition, ';')  WITHIN GROUP (ORDER BY SFRecognition ASC) 'RecognitionList'
  FROM rc1
  GROUP BY did
),
Gifts as (
		SELECT did, 
		SUM(CASE WHEN YEAR(gift_date) = 2018 THEN amount ELSE 0 END) 'Gifts2018', 
		SUM(CASE WHEN YEAR(gift_date) = 2017 THEN amount ELSE 0 END) 'Gifts2017', 
		SUM(CASE WHEN YEAR(gift_date) = 2016 THEN amount ELSE 0 END) 'Gifts2016', 
		SUM(CASE WHEN YEAR(gift_date) = 2015 THEN amount ELSE 0 END) 'Gifts2015', 
		SUM(CASE WHEN YEAR(gift_date) = 2014 THEN amount ELSE 0 END) 'Gifts2014', 
		SUM(CASE WHEN YEAR(gift_date) = 2013 THEN amount ELSE 0 END) 'Gifts2013', 
		SUM(CASE WHEN YEAR(gift_date) = 2012 THEN amount ELSE 0 END) 'Gifts2012', 
		MIN(gift_date) 'FirstGift', MAX(gift_date) 'LastGift'
		FROM Load_Donation
		GROUP BY did
),
PhoneBank as (
 SELECT did, STRING_AGG(phone + ' (' + ttype + ')', ';')  WITHIN GROUP (ORDER BY phone ASC) 'PhoneList'
 FROM load_phones
 WHERE phone <> ''
 GROUP BY did
),
Speakers as (
SELECT DISTINCT did, Description
FROM Load_Attributes
WHERE uniquekey = 'SPEAKER'
),
SpeakerList as (
SELECT did, STRING_AGG(Description, ';') WITHIN GROUP (ORDER BY Description asc) 'SpeakerList'
FROM Speakers
GROUP BY did
),
SpeakerDislike as (
SELECT DISTINCT did, Description
FROM Load_Attributes
WHERE uniquekey = 'SPEAKER DISLIKE'
),
SpeakerDislikeList as (
SELECT did, STRING_AGG(Description, ';') WITHIN GROUP (ORDER BY Description asc) 'SpeakerDislikeList'
FROM SpeakerDislike
GROUP BY did
),
AccountSource as (
SELECT DISTINCT did, description
FROM Load_Attributes
WHERE uniquekey IN ('ORIGLIST', 'SOURCE')
),
AccountSourceList as (
SELECT did, STRING_AGG(Description, ';') WITHIN GROUP (ORDER BY Description asc) 'AccountSourceList'
FROM AccountSource
GROUP BY did
)

SELECT DISTINCT 
  a.did,
  ISNULL(a.title, '') 'title',
  ISNULL(a.name, '') 'name',
  ISNULL(a.first, '') 'first',
  ISNULL(a.middle, '') 'middle',
  ISNULL(a.last, '') 'last',
  ISNULL(a.suffix, '') 'suffix',
  ISNULL(a.salutation, '') 'salutation',
  a.add_date,
--  a.stamp,
  a.cumulative,
  ISNULL(a.movemgr, '') 'movemgr',
  ISNULL(a.dateofbirth, '') 'dateofbirth',
  ISNULL(a.dateofdeath, '') 'dateofdeath',
--  a.strDonorImage,
  ISNULL(a.ModifiedUserId, '') 'ModifiedUserId',
  REPLACE(a.emailaddress, ' ', '') 'emailaddress',
  ISNULL(a.frozen, 0) 'frozen',
  ISNULL(a.spousedod, '') 'spousedod',
  ISNULL(a.movemgr2, '') 'movemgr2',
  a.akey,
  --a.addr_type,
  CASE WHEN addr_type LIKE '%HOME%' and addr_type <> '2ND HOME' THEN 'Home'
			WHEN addr_type = '2ND HOME' THEN '2nd Home'
		    WHEN addr_type = 'FOUNDATION' OR addr_type LIKE 'FNDT%' THEN 'Foundation'
			WHEN addr_type LIKE '%compan%' THEN 'Company'
			WHEN addr_type = 'OFFICE' THEN 'Office'
			WHEN addr_type like 'OTHER%' AND (institution LIKE '%inc.%' OR institution LIKE '%Incorporated%') THEN 'Company'
			WHEN addr_type LIKE 'OTHER%' AND institution LIKE '%Foundation%' THEN 'Foundation'
			WHEN addr_type LIKE 'VACATION' THEN 'Vacation'
			WHEN addr_type LIKE '%WINTER%' THEN 'Winter Home'
			ELSE ''
		END 'Type',
  --a.addr2,
  ISNULL(a.street,'') + ' ' + ISNULL(a.addr2, '') 'BillingStreet',
  ISNULL(a.city, '') 'city',
  ISNULL(a.state, '') 'state',
  ISNULL(a.zip, '') 'zip',
  ISNULL(a.alt_from, '') 'alt_from',
  ISNULL(a.alt_to, '') 'alt_to',
--  a.alt_annual,
  REPLACE(ISNULL(a.institution, '') , '"', '') 'institution',
  ISNULL(a.phone, '') 'phone',
  a.defaultaddr,
  a.longitude,
  a.latitude,
  ISNULL(a.country, '') 'country',
  ISNULL(a.vanity, '') 'vanity',
  CASE WHEN a.frozen = 1 THEN 'Frozen'
	   WHEN a.Deleted = 1 THEN 'Deleted'
	   WHEN h.FirstGift >= DATEADD(month, -12, GETDATE()) THEN 'New'
	   WHEN h.LastGift >= DATEADD(month, -24, GETDATE()) THEN 'Active'
	   WHEN DATEDIFF(month, LastGift, GETDATE()) BETWEEN 25 AND 36 THEN 'Lapsed'
	   WHEN h.LastGift <= DATEADD(month, -37, GETDATE()) THEN 'Inactive'
	   ELSE 'Prospect'
  END 'Status',
  b.BookList,
  c.EventList,
  d.MailList,
  e.PersonalList,
  f.PremiumList,
  g.RecognitionList,
  /*SF Preference tab*/
  CAST(NULL AS VARCHAR(25)) 'SolicitationSchedule',
  CAST(NULL AS VARCHAR(10)) 'CommunicationFrequency',
  CASE WHEN d.MailList LIKE '%MAILSTOP%' THEN 1 ELSE 0 END 'StopMail',
  CAST(NULL AS VARCHAR(20)) 'ProspectList',
  CASE WHEN d.Maillist LIKE '%NOEXCHG%' THEN 1 ELSE 0 END 'DoNotExchange',
  CASE WHEN d.MailList LIKE '%NO SOLICITATIONS%' THEN 1 ELSE 0 END 'NoSolicitations',
  CASE WHEN d.MailList LIKE '%NOMAIL%' THEN 1 ELSE 0 END 'NoMail',
  CAST(0 AS INT)  'BusinessReplyEnvolopeRequired',
  CASE WHEN d.MailList LIKE '%NO AGENCY MAILINGS%' THEN 1 ELSE 0 END 'NoAgencyMailings',
  CASE WHEN d.MailList LIKE '%SHORTLTR%' THEN 1 ELSE 0 END 'ShortLetter',
  CASE WHEN d.MailList LIKE '%NOCALLS%' THEN 1 ELSE 0 END 'NoPhoneCalls',
  CAST(NULL AS VARCHAR(35)) 'ThankYouLetterPreference',
  CAST(NULL AS VARCHAR(20)) 'StudentThankYou',
  CAST(NULL AS VARCHAR(20)) 'NJCPreference',
  CASE WHEN d.MailList LIKE '%NO MASS EMAIL%' THEN 1 ELSE 0 END 'NoMassEmails',
  CAST(NULL AS VARCHAR(35)) 'RanchPreference',
  CAST(NULL AS VARCHAR(45)) 'InvitationPreference',
  CAST(NULL AS VARCHAR(35)) 'CruisePreference',
 -- FirstGift,
  --LastGift,

  CAST('' AS VARCHAR(100)) 'LegacySocietyStatus',
  /*Gift totals by year*/
  h.Gifts2012,
  h.Gifts2013,
  h.Gifts2014,
  h.Gifts2015,
  h.Gifts2016,
  h.Gifts2017,
  h.Gifts2018,


  j.PhoneList,
  k.SpeakerList,
  l.SpeakerDislikeList,
  m.AccountSourceList,
  n.AttributeList,
  CAST('' AS VARCHAR(15)) 'GivingCapacity',
  CAST('' AS VARCHAR(15)) 'DeletedReason',
  CAST(NULL AS DATE) 'DeletedDate',
  CAST(0 AS BIT) 'MikeReganTY',
  CAST('' AS VARCHAR(20)) 'DonorClubLevel',
  CAST('False' AS VARCHAR(5)) 'SpecialDonor',
  CAST('' AS VARCHAR(20)) 'ProfessionalMailingList',
  CAST('' AS VARCHAR(20)) 'AccountType',
  CAST('' AS VARCHAR(50)) 'LegacySource',
  CAST(0 AS BIT) 'IndAnonymous',
  CAST(0 AS BIT) 'IndPotentialDupe'
INTO SF_Account
FROM V_DonorAddress a
LEFT OUTER JOIN booklist b
  ON a.did = b.did
LEFT OUTER JOIN eventlist c
  ON a.did = c.did
LEFT OUTER JOIN maillist d
  ON a.did = d.did
LEFT OUTER JOIN personallist e
  ON a.did = e.did
LEFT OUTER JOIN premiumlist f
  ON a.did = f.did
LEFT OUTER JOIN recognitionlist g
  ON a.did = g.did
LEFT OUTER JOIN Gifts h
  ON a.did = h.did
LEFT OUTER JOIN Load_Attributes i
  ON a.did = i.did
LEFT OUTER JOIN PhoneBank j
  ON a.did = j.did
LEFT OUTER JOIN SpeakerList k
  ON a.did = k.did
LEFT OUTER JOIN SpeakerDislikeList l
  ON a.did = l.did
LEFT OUTER JOIN AccountSourceList m
  ON a.did = m.did
LEFT OUTER JOIN attributelist n
  ON a.did = n.did
WHERE a.defaultaddr = 1 --AND A.did IN (SELECT Reaganomics_ID__c FROM Staging..LoadedAccounts WHERE Reaganomics_ID__c <> '')
--and a.did not in (select did from staging..YAF_LoadedAccounts)
  --and a.did in (select reaganomics_id__c from staging..loadedaccounts where Reaganomics_ID__c > '')

  CREATE INDEX idx_SF_Account ON SF_Account(did)
/*Update Mail Preferences*/
--Some of these that match on longer strings can be combinied into 1 update statement. The BRE and YEARLY matches should still be kept separately since they are smaller common strings that could lead to mis mappings.
--SolicitationSchedule
UPDATE a
SET a.SolicitationSchedule = CASE m.uniquekey
								WHEN 'MAJOR APPEALS' THEN 'Major Appeals Only'
								WHEN 'END OF YEAR' THEN 'End of Year Only'
								WHEN 'Annual Appeal Only' THEN 'Annual Appeal Only'
							  END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('ANNUAL APPEAL ONLY', 'MAJOR APPEALS', 'END OF YEAR')

--CommunicationFrequency
UPDATE a
SET a.CommunicationFrequency = m.uniquekey
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('YEARLY', 'TWICE', 'QUARTERLY')

--ProspectList
UPDATE a
SET a.ProspectList = CASE m.uniquekey
						WHEN 'PROSPECT LIST A' THEN 'A: $10,000+'
						WHEN 'PROSPECT LIST B' THEN 'B: $1000+'
						WHEN 'PROSPECT LIST C' THEN 'C: $100+'
						WHEN 'PROSPECT LIST D' THEN 'D: Internal Mailings'
					 END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did


--BusinessReplyEnvolopeRequired
UPDATE a
SET a.BusinessReplyEnvolopeRequired = 1
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey = 'BRE'

--ThankYouLetterPreference
UPDATE a
SET a.ThankYouLetterPreference = CASE m.uniquekey
									WHEN 'E-MAIL THANK YOU' THEN 'Email Only'
									WHEN 'NO THANK YOU LTR' THEN 'No Thank You Letters'
									--WHEN 'END OF YEAR' THEN 'Send EOY Statement Only'
								 END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('E-MAIL THANK YOU', 'NO THANK YOU LTR')

UPDATE a
SET a.ThankYouLetterPreference = 'Send EOY Statement Only'
FROM SF_Account a INNER JOIN Load_Attributes la
  on a.did = la.did
WHERE la.uniquekey = 'YEARLY STATEMENT'

--StudentThankyou
UPDATE a
SET a.StudentThankyou = CASE m.uniquekey
							WHEN 'NOSTUDENTTY' THEN 'Do Not Send'
							WHEN 'STUDENT TY' THEN 'Send'
						END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('NOSTUDENTTY', 'STUDENT TY')

--NJCPreference
UPDATE a
SET a.NJCPreference = CASE m.uniquekey
						WHEN 'NO NJC' THEN 'Do Not Send any NJC'
						WHEN 'NJC ONLY' THEN 'Send only NJC'
					  END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('NO NJC', 'NJC ONLY')

--RanchPreference
UPDATE a
SET a.RanchPreference = CASE m.uniquekey
						WHEN 'RANCH NO' THEN 'Do Not Send any Ranch Materials'
						WHEN 'RANCH ONLY' THEN 'Send only Ranch Materials'
					  END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('RANCH NO', 'RANCH ONLY')

--InvitationPreference
UPDATE a
SET a.InvitationPreference = CASE m.uniquekey
						WHEN 'NO INVITATIONS' THEN 'No Invitations'
						WHEN 'INVITATIONS' THEN 'Send All Invitations'
						WHEN 'CONTINUE INVITATIONS' THEN 'Send All Invitations, even if Date Expired'
					  END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('CONTINUE INVITATIONS', 'INVITATIONS', 'NO INVITATIONS')

--CruisePreference
UPDATE a
SET a.CruisePreference = CASE m.uniquekey
						WHEN 'CRUISE FUTURE' THEN 'Interested in Future Cruise'
						WHEN 'CRUISE NO' THEN 'Don''t Cruise'
					  END
FROM SF_Account a INNER JOIN Load_Mail m
  on a.did = m.did
WHERE uniquekey IN ('CRUISE FUTURE', 'CRUISE NO')



/*Attributes*/
--This is cleaner than the way we hit the Load_Mail table over and over above, however we have to be careful with similar strings while using LIKE. Ex. LegacySocietyStatus matches on both LEGACY and LEGACY CLUB.
UPDATE SF_Account
SET MikeReganTY = CASE WHEN AttributeList LIKE '%MIKE REAGAN T.Y.%' THEN 1 ELSE 0 END,
	DonorClubLevel =  CASE WHEN AttributeList LIKE '%RAWHIDE CIRCLE%' THEN 'Rawhide Circle' ELSE '' END,
	SpecialDonor = CASE WHEN AttributeList LIKE '%SPECIAL DONOR%' THEN 'True' ELSE SpecialDonor END,
	ProfessionalMailingList = CASE WHEN AttributeList LIKE '%ESTATE PLANNING%' THEN 'Estate Planning'
								   WHEN AttributeList LIKE '%ALLIED ATTORNEY%' THEN 'Allied Attorney'
								   ELSE ''
							   END,
	AccountType = CASE WHEN AttributeList LIKE '%ALUMNI%' THEN '0124W0000007acaQAA' ELSE '0124W00000075jJQAQ' END, --this is the code in Salesforce that will transalte to Alumnus Record on import/update
	DeletedReason = CASE WHEN AttributeList LIKE '%DECEASED%' OR did IN (SELECT did FROM V_DonorAddress WHERE dateofdeath IS NOT NULL) THEN 'Deceased'
						 WHEN AttributeList LIKE '%DELETED%' THEN 'Deleted'
						 ELSE ''
					END,
	GivingCapacity = CASE WHEN AttributeList LIKE '%WEALTHENGINE300-499K%' THEN '$300K-$499K'
						  WHEN AttributeList LIKE '%WEALTHENGINE500-999K%' THEN '$500K-$999K'
						  WHEN AttributeList LIKE '%WEALTHENGINE $1-4.9M%' THEN '$1M-$4.9M'
						  WHEN AttributeList LIKE '%WEALTHENGINE $5M+%'	   THEN '$5M+'
						  ELSE ''
					END,
	LegacySocietyStatus = CASE WHEN AttributeList LIKE '%EXECUTIVE MEMBER%' THEN 'L1=Confirmed Estate Gift (Executive Member)'
							   WHEN AttributeList LIKE '%LEGACY CLUB%' THEN 'L2=Pledged Estate Gift'	--This needs to be matched on before the '%LEGACY%' match for L4.
							   WHEN AttributeList LIKE '%LC PLAN%' THEN 'L3=Planned Estate Gift'
							   WHEN AttributeList LIKE '%LEGACY%' THEN 'L4 = Requested Legacy Information'
							   WHEN AttributeList LIKE '%TORCH OF FREEDOM%' THEN 'Torch of Freedom'
							   ELSE ''
						  END

--Deceased legacies
UPDATE SF_Account
SET LegacySocietyStatus = 'LD = Deceased Legacy Society Member'
WHERE AttributeList LIKE '%DECEASED%'
  AND LegacySocietyStatus IS NOT NULL

--LegacySource
UPDATE a
SET a.LegacySource = la.description
FROM SF_Account a INNER JOIN Load_Attributes la
  on a.did = la.did
WHERE la.uniquekey = 'LEGACY'


--DeletedDate
UPDATE a
SET DeletedDate = dated
FROM SF_Account a INNER JOIN Load_Attributes la
  on a.did = la.did
WHERE la.uniquekey IN ('DELETED DATE', 'DELETED', 'DECEASED') 

UPDATE a
SET DeletedDate = b.dateofdeath
FROM SF_Account a INNER JOIN V_DonorAddress b
  on a.did = b.did
WHERE b.did IS NOT NULL AND
      a.DeletedDate IS NULL AND
	  a.DeletedReason = 'DECEASED'


/*Clean up*/
--blank names
--pass 1 - set to first + last name
UPDATE SF_Account
SET name = first + ' ' + last
WHERE name = ''
 AND first <> ''
 --AND  did NOT IN (SELECT Reaganomics_ID__c FROM LoadedAccounts WHERE Reaganomics_ID__c <> '')

--pass 2 - set to company
UPDATE SF_Account
SET name = institution
WHERE  name = ''
 AND (institution IS NOT NULL OR institution <> '')
 --AND did NOT IN (SELECT Reaganomics_ID__c FROM LoadedAccounts WHERE Reaganomics_ID__c <> '')

 --anonymous
UPDATE SF_Account
SET IndAnonymous = 1,
	name = 'Anonymous'
WHERE name = '' and
	  institution =''


--Bad emails
UPDATE SF_Account
SET emailaddress = ''
WHERE emailaddress not like '%@%.%' or
	  emailaddress like '%@%@%'

      
/*1 off emails*/
--after everything else and it is still being returned as a bad email
UPDATE SF_Account
SET emailaddress = CASE emailaddress
					WHEN 'helenMaryWarren@massmail.state.ma.' THEN 'helenMaryWarren@massmail.state.ma'
					WHEN 'D.DA34@&Yahoo.com' THEN 'D.DA34@Yahoo.com'
					WHEN 'don.covert@g,mail.com' THEN 'don.covert@gmail.com'
					WHEN 'reesae@aol..com' THEN 'reesae@aol.com'
					ELSE emailaddress
				  END





--Export to name parser for pulling spouse contacts
SELECT  did, title, first, middle, last, suffix, BillingStreet, city, state, zip, institution
FROM SF_Account

/*Post Address standardization*/
SELECT ListId, RecordNumber, ListType, Honorific, FirstName, MiddleName, LastName, Suffix, SpouseFirstName, SpouseMiddleName, CompanyName, FinalAddress1 'AddressLine1', FinalAddress2 'AddressLine2', FinalCity 'City', FinalState 'State', FinalZipcode 'ZipCode', FinalZip4 'Zip4', CarrierRoute,
    CountyFIPS, DeliveryPoint, CMRA, ValidationFlag, DPVFootnotes, DPVIndicator, DPVVacant, StandardizationCode, LOTNumber, RecordType, MatchFlag, MoveType, MoveDate, HouseholdHash, ContactID, QualityScore, CAST('' AS CHAR(1)) 'RejectCode', ParseCode, Gender,
    CAST(NULL AS INT) 'PriorityLevel', CAST(NULL AS VARCHAR(25)) 'DonorID', CAST(NULL AS VARCHAR(5)) 'MissionCode', CAST(NULL AS VARCHAR(3)) 'ListCode', CAST(NULL AS INTEGER) 'DbId', CAST(NULL AS INTEGER) 'SiteId', CAST(0 AS BIT) 'Keeper', CAST(NULL AS BINARY(32)) 'ContactHash', CAST(0 AS BIT) 'IndicateDMA', CAST(0 AS BIT) 'IndicateDeceased', CAST(0 AS BIT) 'IndicatePrison',  CAST('' AS VARCHAR(2)) 'HouseSegment '
INTO #ProjectWork
FROM YAFAccounts_20211128_Results



--Update DonorIds for house records
;WITH House as (
		--Break out original data into it's fields. You'll have to check this query to see what rows coorespond to the fields we need.
		SELECT	ListID, 
				RecordNumber, 
				[value] as String, 
				Row_Number() Over(Partition By recordnumber order by %%physloc%% ) rn
		FROM YAFAccounts_20211128_Results 
		 cross apply string_split(FullOriginalRecord,',')	
		),
	  --Pull out the fields we need
	  DonorInfo as (
		SELECT Listid, 
		       RecordNumber, 
			   CASE WHEN rn = 2 THEN REPLACE(string,'''','') ELSE '' END 'DonorID'
			   --CASE WHEN rn = 2 THEN REPLACE(string,'''','') ELSE '' END 'MissionCode'
		FROM House 
		),
	  --clean out blanks, probably not necessary since we are just updating.
	  DonorInfoFinal as (
		SELECT ListId, RecordNumber, MAX(DonorID) 'DonorId'
		FROM DonorInfo
		GROUP BY ListID, RecordNumber
		)

UPDATE a
SET a.DonorID = b.DonorID
FROM #ProjectWork a INNER JOIN DonorInfoFinal b
  on a.ListID = b.ListID and
     a.RecordNumber = b.RecordNumber

UPDATE a
SET a.BillingStreet = RTRIM(b.AddressLine1 + ' ' + b.AddressLine2)
FROM SF_Account a INNER JOIN #ProjectWork b
  on a.did = b.DonorID
WHERE b.StandardizationCode < 92

select top 500*
from SF_Account


/*Set Dupes*/

drop table IF EXISTS #dupes

--3334
;with t1 as (
  select first, last, LEFT(zip, 5) 'zip', BillingStreet, count(*) 'DupCount', MIN(akey) 'DupGroup'
  from SF_Account
  where name > ' ' and zip > ' ' and BillingStreet > ' '
  group by first, last, LEFT(zip, 5), BillingStreet
  having count(*) > 1
)
select distinct t1.DupGroup, a.did, a.first, a.last, a.name, a.Type, a.BillingStreet, a.city, a.state, a.zip
into #dupes
from SF_Account a inner join t1
on a.first   = t1.first and
   a.last	= t1.last and
   LEFT(a.zip, 5)    = t1.zip    and
   a.BillingStreet = t1.BillingStreet 
WHERE did <> 574399 --pulled in twice because address is in altaddr twice
ORDER BY t1.DupGroup

UPDATE a
SET a.IndPotentialDupe = 1
FROM SF_Account a INNER JOIN #dupes b
  on a.did = b.did

--Export in waves
exec ExportAccounts 0
exec ExportAccounts 1
exec ExportAccounts 2
SELECT * FROM SF_Account WHERE Did % 5 >2



/*Check what loaded*/
	TRUNCATE TABLE LoadedAccounts
	ALTER TABLE LoadedAccounts DROP CONSTRAINT pk_LoadedAccounts

	--export file from jitterbit 
	BULK INSERT LoadedAccounts
	FROM 'D:\Processes\YAF\LoadedAccounts.csv'
	WITH
	(
		FIRSTROW = 2, --Second row if header row in file
		FIELDTERMINATOR = ',',  --CSV field delimiter
		ROWTERMINATOR = '\n',   --Use to shift the control to next row
		ERRORFILE = 'D:\Processes\YAF\LoadedAccounts',
		TABLOCK
	)

	DELETE FROM LoadedAccounts
	WHERE Reaganomics_ID__c = '""'

ALTER TABLE LoadedAccounts
ALTER COLUMN Reaganomics_ID__c VARCHAR(10) NOT NULL
ALTER TABLE LoadedAccounts ADD CONSTRAINT pk_LoadedAccounts Primary Key (Reaganomics_ID__c)

/*Export missed*/
SELECT *
FROM V_SFAccount_ToLoad

UPDATE V_SFAccount_ToLoad
SET emailaddress = ''

select count(*) from loadedaccounts
select count(*) from sf_account



---------------------------------------------------------------





  select top 500*
  from SF_Account
  where AttributeList like '%LEGACY CLUB%'

  select *
  from SF_Account
  where MailList like '%PROSPECT LIST b%'

  SELECT *
  FROM SF_Account
  WHERE DeletedReason = '' AND DeletedDate IS NOT NULL

  select *
  from Load_Attributes
  where uniquekey like 'speaker%'


  SELECT *
  FROM Load_Attributes
  WHERE uniquekey = 'WEALTHENGINE300-499K'

  SELECT *
  FROM Load_Donor
  where did = 185656

  select *
  from Load_AltAddr
  where did = 185656

  select *
  from V_DonorAddress
  where did = 185656