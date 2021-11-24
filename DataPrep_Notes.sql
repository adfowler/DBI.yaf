USE YAF

SELECT *,
	HASHBYTES('SHA2_256',
			ISNULL(id, '') +
			ISNULL(CAST(dated as varchar(10)), '') + 
			ISNULL(noted, '') +
			ISNULL(Status, '') +
			ISNULL(Priority, '')
			) 'HashKey',
	CAST(GETDATE() AS DATE) 'ArchiveDate'
INTO Archive_SFNotes
FROM SF_Notes

	TRUNCATE TABLE SF_Notes


	--Inserts all notes for loaded accounts where the note is under 32000 characters after html cleanup
	INSERT INTO SF_Notes (nid, id, dated, noted, Status, Priority)
	SELECT nid, 
		   b.id, 
		   dated, 
		   dbo.striphtml(noted) 'noted', 
		   'Completed' 'Status', 
		   'Normal' 'Priority'
	FROM Load_Notes a INNER JOIN LoadedAccounts b
	  on cast(a.did as bigint) = cast(b.Reaganomics_ID__c as bigint)
	WHERE DATALENGTH(dbo.striphtml(noted) )< 32000 AND
		  noted is not null
 --nid NOT IN (SELECT reaganomics_note_id__C FROM LoadedTasks WHERE CreatedDate > ='2020-12-23')


--Export query. 
SELECT nid, id , dated,  noted, Status, Priority
FROM SF_Notes
WHERE nid not in (SELECT nid FROM Archive_SFNotes)
ORDER BY nid

--Export query for new/changed records only
;WITH MostRecent as (SELECT nid, MAX(ArchiveDate) 'ArchiveDate'
					 FROM Archive_SFNotes
					 GROUP BY nid
					 )
		SELECT *
		FROM SF_Notes sn 
		LEFT JOIN MostRecent mr
		  on sn.nid = mr.nid
		LEFT JOIN Archive_SFNotes an
		  on mr.nid = an.nid
		   and mr.ArchiveDate = an.ArchiveDate
		WHERE HASHBYTES('SHA2_256',
					ISNULL(sn.id, '') +
					ISNULL(CAST(sn.dated as varchar(10)), '') + 
					ISNULL(sn.noted, '') +
					ISNULL(sn.Status, '') +
					ISNULL(sn.Priority, '')
					) <> an.HashKey
			or an.HashKey is null

select *
from load_notes
WHERE NID = 37279



/*
--Export query. Removes new line characters.

SELECT top 500 nid, dated,  REPLACE(REPLACE(noted,CHAR(13)+CHAR(10),' '), CHAR(10), ' ') 'noted', Status, Priority
from SF_Notes
where nid not in (select cast(reaganomics_note_id__c as int) from loadedtasks)
*/


/* QAs */


--QAs for notes not inserted
--not in SF_Notes
SELECT *
FROM Load_Notes
WHERE nid NOT IN (SELECT nid from SF_Notes)
ORDER BY nid, did

--Not loaded into SF
SELECT *
FROM Load_Notes
WHERE nid not in (SELECT reaganomics_note_id__C FROM LoadedTasks WHERE CreatedDate > ='2020-12-23')
ORDER BY nid, did

--130k
SELECT COUNT(*)
FROM Load_Notes
WHERE DATALENGTH(noted) < 32000


select * from load_notes where nid = 25955
select * from sf_notes where nid = 25955





select nid, sf_nid, sf_accountid, dated, REPLACE(noted, '"', '\"') AS 'noted', Status, Priority
from SF_Notes_html
 where nid = 40992

 select *
 from LoadedTasks
 where description like '%"%'
 
select *
from SF_Notes
where noted like '%mdash%'

select *
from  Load_Notes
where noted like '%&nbsp;%'



select *, dbo.StripHTML(noted) from load_notes where nid = 24804 

select count(*)
 from SF_Notes_html
 where nid = 121832

 select *
 from load_notes
 where nid = 121832

 select *
 from SF_Account
 where did = 121832

 select *
 from load_notes
 where nid not in (select nid from SF_Notes_html)

 select *
 from Load_Notes
 where noted like '%<w:LidThemeOther>%'





	
	select *
	from sf_notes
	where nid = 25004