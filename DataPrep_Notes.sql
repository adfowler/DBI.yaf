
SELECT top 100 nid, b.id, dated,  dbo.udf_striphtml(noted) 'noted', 'Completed' 'Status', 'Normal' 'Priority'
FROM Load_Notes a INNER JOIN Staging..LoadedAccounts b
  on cast(a.did as bigint) = cast(b.Reaganomics_ID__c as bigint)
WHERE DATALENGTH(noted) < 32000
order by id, nid


select *
from staging..LoadedAccounts
where Reaganomics_ID__c = 16

select *
from load_notes
where nid = 8391


select *
from load_notes
where noted like '%|||%'