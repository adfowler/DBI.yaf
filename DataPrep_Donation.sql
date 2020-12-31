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
		lp.pid
INTO SF_Donation
from Load_Donation d INNER JOIN SF_Account a
  on d.did = a.did
INNER JOIN Load_Projects lp
  on d.source = lp.source
LEFT JOIN Lookup_DonType ld
  on d.don_type = ld.Don_Type

 DELETE FROM SF_Donation
 WHERE DKEY IN (SELECT IMPORT_ID__C FROM STAGING..LOADEDDONATIONS)

 select count(*)
 from SF_Donation


 select *
 from SF_Donation
 order by dkey

 select *
 from staging..LoadedAccounts
 where Reaganomics_ID__c = 30413

 select *
 from Load_Donor
 where did = 30413