/*Updates*/

/*Deceased*/
	--Contacts
	SELECT c.id, a.ReaganomicsContactID, a.did, a.IndDeceased, a.dateofdeath
	FROM SF_Contact a INNER JOIN Achive_SF_Contact b
	  on a.did = b.did
	INNER JOIN Staging..LoadedContacts c
	  on b.ReaganomicsContactID = c.Reaganomics_Contact_ID__c
	WHERE a.IndDeceased <> b.inddeceased
	and c.Reaganomics_Contact_ID__c <> ''
	   
	--Accounts
	SELECT c.id, a.did, a.DeletedReason, a.DeletedDate
	FROM SF_Account a INNER JOIN Archive_SF_Account b
	  on a.did = b.did
	INNER JOIN Staging..LoadedAccounts c
	  on b.did = c.Reaganomics_ID__c
	WHERE a.DeletedReason <> b.DeletedReason
	and c.Reaganomics_ID__c <> ''


	SELECT b.id, a.did, a.DeletedReason, a.DeletedDate
	FROM SF_Account a INNER JOIN Staging..LoadedAccounts b
	  on a.did = b.Reaganomics_ID__c
	WHERE DeletedReason = 'DECEASED' and
		  b.Reaganomics_ID__c <> ''



	--Checks
	select *
	from sf_account
	where DeletedReason = 'deceased' and
		  did in (select did from SF_Contact where IndDeceased = 0)


	select *
	from SF_Contact
	where IndDeceased = 1 and
		  did not in (select did from SF_Account where DeletedReason = 'deceased')

	select *
	from SF_Account
	where DeletedReason = 'deceased' and DeletedDate is null


/*Duplicates*/
--Donations
SELECT DISTINCT c.id, a.dkey, a.gift_date, a.did, a.amount
INTO #DonationDupes
FROM Load_Donation a INNER JOIN Load_Donation b
  on a.did = b.did and
	 a.gift_date = b.gift_date and
	 a.amount = b.amount
LEFT JOIN STAGING..LoadedDonations c
  on a.dkey = c.Import_ID__c
WHERE a.dkey <> b.dkey
ORDER BY did

--only loaded 1 of the dupes
DELETE a
FROM #DonationDupes a INNER JOIN #DonationDupes b
  on a.amount = b.amount and
     a.did = b.did and
	 a.gift_date = b.gift_date
WHERE a.dkey <> b.dkey and
      b.id is null and
	  a.id is not null

--not loaded
DELETE FROM #DonationDupes
WHERE ID IS NULL


SELECT *
INTO DonationDupes
FROM #DonationDupes


select *
from Load_Donation
where dkey not in (select Import_ID__c from STAGING..LoadedDonations )

--Accounts
--2695
/*
with t1 as (
  select name, lefT(zip, 5) 'zip', street, addr2, count(*) 'DupCount', MIN(akey) 'DupGroup'
  from v_donoraddress
  where name > ' ' and zip > ' ' and street > ' '
  group by name, lefT(zip, 5), street, addr2
  having count(*) > 1
)
select  t1.DupGroup, a.did, a.name, a.addr_type, a.street, a.addr2, a.city, a.state, a.zip
into #dupes1
from v_donoraddress a inner join t1
on a.name   = t1.name and
   lefT(a.zip, 5)    = t1.zip    and
   a.street = t1.street and
   a.addr2  = t1.addr2
ORDER BY t1.DupGroup
*/

drop table #dupes2
--3334
;with t1 as (
  select first, last, LEFT(zip, 5) 'zip', street, addr2, count(*) 'DupCount', MIN(akey) 'DupGroup'
  from v_donoraddress
  where name > ' ' and zip > ' ' and street > ' '
  group by first, last, LEFT(zip, 5), street, addr2
  having count(*) > 1
)
select distinct t1.DupGroup, a.did, a.first, a.last, a.name, a.addr_type, a.street, a.addr2, a.city, a.state, a.zip
into #dupes2
from v_donoraddress a inner join t1
on a.first   = t1.first and
   a.last	= t1.last and
   LEFT(a.zip, 5)    = t1.zip    and
   a.street = t1.street and
   a.addr2  = t1.addr2
WHERE did <> 574399 --pulled in twice because address is in altaddr twice
ORDER BY t1.DupGroup

SELECT *
INTO DonorDupes
FROM #dupes2

alter table yaf..donordupes
add  id varchar(100)

UPDATE a
SET id = b.id
FROM yaf..donordupes a INNER JOIN Staging..LoadedAccounts b
  on a.did = b.Reaganomics_ID__c



select *
from #dupes2
where did not in (select did from #dupes1)

select *
from #dupes2 a LEFT JOIN staging..LoadedAccounts b
  on a.did = b.Reaganomics_ID__c
where b.id is null


select *
from #dupes2
where DupGroup = 905542

select *
from staging..LoadedAccounts
where Reaganomics_ID__c = 574399

select *
from Load_Donor
where did = 574399

select *
from V_DonorAddress
where first = 'aurelia' and last = 'bennett'


select *
from Load_Donor
where first = 'aurelia' and last = 'bennett'

select *
from Load_AltAddr
where did = 574399



select *
from yaf..donationdupes

