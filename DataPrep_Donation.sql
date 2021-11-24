--Probably change to only archiving new data...
INSERT INTO Archive_SFDonation
  SELECT *,
	     HASHBYTES('SHA2_256',
				ISNULL(CAST(gift_date AS VARCHAR(10)), '') +
				ISNULL(CAST(amount AS VARCHAR(15)), '') +
				ISNULL(UPPER(don_type), '') +
				ISNULL(UPPER(Method), '') +
				ISNULL(UPPER(ReganomicsDonationType), '') +
				ISNULL(UPPER(check_num), '') +
				ISNULL(UPPER(thank_you), '') +
				ISNULL(UPPER(Stage), '') +
				ISNULL(UPPER(DonationName), '') +
				ISNULL(UPPER(source), '') +
				ISNULL(UPPER(pid), '') +
				ISNULL(UPPER(Description), '')
				) 'Hashkey',
		 CAST(GETDATE() AS DATE) 'ArchiveDate'
  FROM SF_Donation



DROP TABLE IF EXISTS SF_Donation

SELECT DISTINCT 
		dkey, 
		d.did , 
		gift_date, 
		amount, 
		ld.SF_Value 'don_type', 
		ld.Method, 
		ld.Description 'ReganomicsDonationType', 
		check_num, 
		d.thank_you, 
		'Received' 'Stage', --there are future donations but those are said to be typos by YAF
		ISNULL(a.last,'') + ' - ' +  cast(gift_date as varchar(15)) 'DonationName',
		d.source,
		MIN(lp.pid) 'pid',
		CAST('' AS VARCHAR(50))	'Description',
		CAST(0 AS BIT) 'PotentialDupe'
INTO SF_Donation
FROM Load_Donation d INNER JOIN SF_Account a
  on d.did = a.did
INNER JOIN Load_Projects lp	--Records get rejected if they aren't from known cACMEaigns
  on d.source = lp.source
LEFT JOIN Lookup_DonType ld
  on d.don_type = ld.Don_Type
GROUP BY d.dkey, d.did, gift_date, amount, ld.SF_Value, ld.Method, ld.Description, check_num, d.thank_you, d.source, a.last


CREATE INDEX idx_SF_Donation_dkey ON SF_Donation(dkey)
CREATE INDEX idx_SF_Donation_did ON SF_Donation(did)

/*Data fixes*/
--Bad check_num
UPDATE SF_Donation
SET Description = check_num,
	check_num = ''
WHERE (ISNUMERIC(CHECK_NUM) = 0 or LEN(check_num) > 12)


--Bad dates
--1010 -> 2010
UPDATE SF_Donation
SET gift_date = DATEADD(YEAR,1000,GIFT_DATE)
WHERE YEAR(GIFT_DATE) = 1010

--0200 -> 2000
UPDATE SF_Donation
SET gift_date = REPLACE(gift_date, '0200', '2000')
WHERE YEAR(gift_date) = 0200


DROP TABLE IF EXISTS #datefix

--Grabs most recent good date for records with bad gift date
SELECT a.*, c.NewDate
INTO #datefix
FROM SF_Donation a CROSS APPLY (SELECT MAX(Gift_Date) 'NewDate' FROM SF_Donation b WHERE b.dkey between a.dkey - 5 and a.dkey and b.gift_date > '1950-01-01') c
WHERE a.gift_date <  '1950-01-01' 

UPDATE a
SET a.gift_date = b.NewDate
FROM SF_Donation a INNER JOIN #datefix b
  on a.dkey = b.dkey

UPDATE a
SET DonationName = ISNULL(c.last,'') + ' - ' +  cast(a.gift_date as varchar(15))
FROM SF_Donation a INNER JOIN #datefix b
  on a.dkey = b.dkey
INNER JOIN SF_Account c
  on a.did = c.did


UPDATE SF_Donation
SET DonationName = 'Anonymous - ' +  cast(gift_date as varchar(15))
WHERE did in (SELECT did FROM SF_Account WHERE name = 'Anonymous')

/*Duplicates*/
DROP TABLE IF EXISTS #DonationDupes

SELECT DISTINCT a.dkey, a.gift_date, a.did, a.amount
INTO #DonationDupes
FROM Load_Donation a INNER JOIN Load_Donation b
  on a.did = b.did and
	 a.gift_date = b.gift_date and
	 a.amount = b.amount
WHERE a.dkey <> b.dkey
ORDER BY did

select * from #DonationDupes
order by did, gift_date, amount

--only loaded 1 of the dupes
/*
DELETE a
FROM #DonationDupes a INNER JOIN #DonationDupes b
  on a.amount = b.amount and
     a.did = b.did and
	 a.gift_date = b.gift_date
WHERE a.dkey < b.dkey 
*/
drop table if exists donationdupes

SELECT *
INTO DonationDupes
FROM #DonationDupes

UPDATE a
SET a.PotentialDupe = 1
FROM SF_Donation a INNER JOIN DonationDupes b
  on a.dkey = b.dkey

UPDATE SF_Donation
SET PotentialDupe = 0
WHERE PotentialDupe IS NULL


--2,343,163
SELECT COUNT(*)
FROM SF_Donation
 
 /*Export*/
 SELECT *
 FROM SF_Donation
 WHERE did % 5 <2
 ORDER BY did, dkey


 select *
 from SF_Donation
 where gift_date = '2001-08-01'
 and did = 94222
 and amount = 25.00

 select count(*) from sf_donation
 select count(*) from Load_Donation


 --2637
 --2270 orphans

 select *
 from Load_Donation a LEFT JOIN Load_Donor b
   on a.did = b.did
 where dkey not in (select dkey from SF_Donation)	--2637
 and b.did is not null --2270 nulls (orphans)
 and source in (select source from Load_Projects)--164		367
 and b.did  in (select did from Load_AltAddr where defaultaddr = 1)
 order by a.did

 select *
 from load_donation a  LEFT JOIN Load_Donor b
   on a.did = b.did
 where dkey not in (select dkey from SF_Donation)
  and b.did is not null
  and b.did not in (select did from Load_AltAddr where defaultaddr = 1)

   select *
 from Load_Donation a LEFT JOIN Load_Donor b
   on a.did = b.did
 where dkey not in (select dkey from SF_Donation)	--2637
 and source not in (select source from Load_Projects)--164		367

 select *
 from SF_Account
 where did = 103696

 select *
 from Load_Donor
 where did = 103696

 select *
 from Load_AltAddr
 where did = 103696

