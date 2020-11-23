/******************************************************************************************************************************************/
/* This script rolls data to the SF Account level. It joins Donors to AltAddr, then rolls up Books, Events, Mail, Pekrsonal, Premiums,    */
/* and Recognition into delimited string fields. Only default addresses are included.                                                     */
/******************************************************************************************************************************************/

USE YAF

DROP TABLE IF EXISTS SF_Account

;WITH bk1 AS (
  SELECT DISTINCT did, uniquekey
  FROM Load_Books
),
booklist AS (
  SELECT did, STRING_AGG(uniquekey, ';')  WITHIN GROUP (ORDER BY uniquekey ASC) 'BookList'
  FROM bk1
  GROUP BY did
),
ev1 AS (
  SELECT DISTINCT did, uniquekey 'SFEvent'
  FROM Load_Events
),
eventlist AS (
  SELECT did, STRING_AGG(SFEvent, ';')  WITHIN GROUP (ORDER BY SFEvent ASC) 'EventList'
  FROM ev1
  GROUP BY did
),
ml1 AS (
  SELECT DISTINCT did, uniquekey 'SFMail'
  FROM Load_Mail
),
maillist AS (
  SELECT did, STRING_AGG(SFMail, ';')  WITHIN GROUP (ORDER BY SFMail ASC) 'MailList'
  FROM ml1
  GROUP BY did
),
pl1 AS (
  SELECT DISTINCT did, uniquekey 'SFPersonal'
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
  SELECT DISTINCT did, uniquekey 'SFRecognition'
  FROM Load_Recognition
),
recognitionlist AS (
  SELECT did, STRING_AGG(SFRecognition, ';')  WITHIN GROUP (ORDER BY SFRecognition ASC) 'RecognitionList'
  FROM rc1
  GROUP BY did
)
SELECT
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
  a.addr_type,
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
  b.BookList,
  c.EventList,
  d.MailList,
  e.PersonalList,
  f.PremiumList,
  g.RecognitionList
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
WHERE a.defaultaddr = 1
ORDER BY a.did
