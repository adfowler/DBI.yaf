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

SELECT DISTINCT TOP 150000
  a.did,
  a.title,
  a.name,
  a.first,
  a.middle,
  a.last,
  a.suffix,
  a.salutation,
  a.add_date,
--  a.stamp,
  a.cumulative,
  a.movemgr,
  a.dateofbirth,
  a.dateofdeath,
--  a.strDonorImage,
  a.ModifiedUserId,
  a.emailaddress,
  a.frozen,
  a.spousedod,
  a.movemgr2,
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
			ELSE NULL
		END 'Type',
  --a.addr2,
  a.street + ' ' + a.addr2 'BillingStreet',
  a.city,
  a.state,
  a.zip,
  a.alt_from,
  a.alt_to,
--  a.alt_annual,
  a.institution,
  a.phone,
  a.defaultaddr,
  a.longitude,
  a.latitude,
  a.country,
  a.vanity,
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
  CAST(0 AS BIT) 'SpecialDonor',
  CAST('' AS VARCHAR(20)) 'ProfessionalMailingList'

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
WHERE a.defaultaddr = 1


/*Update Preferences*/
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


/*Update legacy*/
UPDATE a
SET LegacySocietyStatus = CASE la.uniquekey 
							WHEN 'EXECUTIVE MEMBER' THEN 'L1=Confirmed Estate Gift (Executive Member)'
							WHEN 'LEGACY CLUB' THEN 'L2=Pledged Estate Gift'
							WHEN 'LC PLAN' THEN 'L3=Planned Estate Gift'
							WHEN 'LEGACY' THEN 'L4 = Requested Legacy Information'
							WHEN 'TORCH OF FREEDOM' THEN 'Torch of Freedom'
						    ELSE ''
						   END 
FROM SF_Account a INNER JOIN Load_Attributes la
  on a.did = la.did

--Deceased legacies
UPDATE SF_Account
SET LegacySocietyStatus = 'LD = Deceased Legacy Society Member'
WHERE did IN (SELECT did FROM Load_Attributes WHERE uniquekey = 'DECEASED')
  AND LegacySocietyStatus IS NOT NULL

--GivingCapacity
UPDATE a
SET GivingCapacity = CASE la.uniquekey
						WHEN 'WEALTHENGINE300-499K' THEN '$300K-$499K'
						WHEN 'WEALTHENGINE500-999K' THEN '$500K-$999K'
						WHEN 'WEALTHENGINE $1-4.9M' THEN '$1M-$4.9M'
						WHEN 'WEALTHENGINE $5M+'	THEN '$5M+'
						ELSE ''
					END
FROM SF_Account a INNER JOIN Load_Attributes la
  ON a.did = la.did

/*Deleted*/
UPDATE a
SET a.DeletedReason = CASE la.uniquekey 
						WHEN 'DECEASED' THEN 'Deceased'
						WHEN 'DELETED' THEN 'Deleted'
						ELSE '' 
					  END ,
	a.DeletedDate = dated --dated always has the date, descriptions sometimes has initials
FROM SF_Account a INNER JOIN Load_Attributes la
  on a.did = la.did
WHERE la.uniquekey IN ('DELETED DATE', 'DELETED', 'DECEASED') 

--
UPDATE a
SET a.MikeReganTY = CASE WHEN uniquekey = 'MIKE REAGAN T.Y.' THEN 1 ELSE 0 END,
	a.DonorClubLevel = CASE WHEN uniquekey = 'RAWHIDE CIRCLE' THEN 'Rawhide Circle' ELSE '' END,
	a.SpecialDonor = CASE WHEN uniquekey = 'SPECIAL DONOR' THEN 1 ELSE 0 END ,
	a.ProfessionalMailingList = CASE uniquekey 
									WHEN 'ESTATE PLANNING' THEN 'Estate Planning'
									WHEN 'ALLIED ATTORNEY' THEN 'Allied Attorney'
									ELSE '' 
								 END
FROM SF_Account a INNER JOIN Load_Attributes la
  on a.did = la.did




  select top 500*
  from SF_Account
  where ProfessionalMailingList <> ''

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