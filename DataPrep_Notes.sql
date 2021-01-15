USE YAF

DROP TABLE IF EXISTS SF_Notes

SELECT top 5000 nid, b.id, dated,  dbo.udf_striphtml(noted) 'noted', 'Completed' 'Status', 'Normal' 'Priority'
INTO SF_Notes
FROM Load_Notes a INNER JOIN Staging..LoadedAccounts b
  on cast(a.did as bigint) = cast(b.Reaganomics_ID__c as bigint)
WHERE DATALENGTH(noted) < 32000
ORDER by id, nid

CREATE INDEX idx_id on SF_notes(id)


INSERT INTO SF_Notes
SELECT nid, b.id, dated,  dbo.udf_striphtml(noted) 'noted', 'Completed' 'Status', 'Normal' 'Priority'
FROM Load_Notes a INNER JOIN LoadedAccounts b
  on cast(a.did as bigint) = cast(b.Reaganomics_ID__c as bigint)
WHERE DATALENGTH(noted) < 32000
AND nid NOT IN (SELECT reaganomics_note_id__C FROM LoadedTasks WHERE CreatedDate > ='2020-12-23')

INSERT INTO SF_Notes
SELECT nid, b.id, dated,  dbo.udf_striphtml(noted) 'noted', 'Completed' 'Status', 'Normal' 'Priority'
FROM Load_Notes a INNER JOIN LoadedAccounts b
  on cast(a.did as bigint) = cast(b.Reaganomics_ID__c as bigint)
WHERE --DATALENGTH(dbo.udf_striphtml(noted) )< 32000 AND
 nid NOT IN (SELECT reaganomics_note_id__C FROM LoadedTasks WHERE CreatedDate > ='2020-12-23')
 and noted is not null



select *
from sf_notes
where nid = 59357

select *
from sf_notes
where nid NOT IN (SELECT reaganomics_note_id__C FROM LoadedTasks WHERE CreatedDate > ='2020-12-23')
order by id, nid

select *
from Load_Notes
where nid NOT IN (SELECT nid from sf_notes)
order by nid, did


select *
from Load_Notes
where nid not in (SELECT reaganomics_note_id__C FROM LoadedTasks WHERE CreatedDate > ='2020-12-23')
order by nid, did


SELECT *
from loadedtasks


--130k
SELECT COUNT(*)
FROM LOAD_NOTES
WHERE DATALENGTH(noted) < 32000

select *
from staging..LoadedAccounts
where Reaganomics_ID__c = 16

select *
from load_notes
where nid = 8391


select *
from load_notes
where noted like '%|||%'