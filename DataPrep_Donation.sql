DROP TABLE IF EXISTS SF_Donation

select distinct dkey, 
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
		CAST('' AS VARCHAR(50))	'Description'
INTO SF_Donation
from Load_Donation d INNER JOIN SF_Account a
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
WHERE dkey NOT IN (SELECT IMPORT_ID__C FROM LoadedDonations)
AND (ISNUMERIC(CHECK_NUM) = 0 or LEN(check_num) > 12)


--Bad dates
--1010 -> 2010
UPDATE SF_Donation
SET gift_date = DATEADD(YEAR,1000,GIFT_DATE)
WHERE YEAR(GIFT_DATE) = 1010

--0200 -> 2000
UPDATE SF_Donation
SET gift_date = REPLACE(gift_date, '0200', '2000')
WHERE YEAR(gift_date) = 0200


drop table #datefix

select a.*, c.NewDate
into #datefix
from SF_Donation a CROSS APPLY (SELECT MAX(Gift_Date) 'NewDate' FROM SF_Donation b WHERE b.dkey between a.dkey - 5 and a.dkey and b.gift_date > '1950-01-01') c
where a.gift_date <  '1950-01-01' 

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



 DELETE FROM SF_Donation
 WHERE DKEY IN (SELECT IMPORT_ID__C LOADEDDONATIONS)



 select *
 from SF_Donation
 WHERE DKEY not IN (SELECT IMPORT_ID__C FROM LoadedDonations)
 ORDER BY DKEY, DID



 select count(*) from sf_donation
 select count(*) from Load_Donation


 --2587
 --2200 orphans

 select *
 from Load_Donation a LEFT JOIN Load_Donor b
   on a.did = b.did
 where dkey not in (select dkey from SF_Donation)
 and b.did is not null --2200
 and source in (select source from Load_Projects)
 and b.did in (select did from Load_AltAddr where defaultaddr = 1)
 order by a.did


 select *
 from SF_Account
 where did = 103696

 select *
 from Load_Donor
 where did = 103696

 select *
 from Load_AltAddr
 where did = 103696

 select *
 from staging..LoadedAccounts
 where Reaganomics_ID__c = 32

 select *
 from Load_Donation
 where did not in (select did from Load_Donor)


 select *
 from Load_Projects
 where source = 'HARVAR'