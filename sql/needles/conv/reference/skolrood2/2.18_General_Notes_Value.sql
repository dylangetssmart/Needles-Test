-- use [SANeedlesSLF]
go

/*
alter table [sma_TRN_Notes] disable trigger all
delete from [sma_TRN_Notes] 
DBCC CHECKIDENT ('[sma_TRN_Notes]', RESEED, 0);
alter table [sma_TRN_Notes] enable trigger all
*/

----(0)----
INSERT INTO [sma_MST_NoteTypes] (
    nttsDscrptn,
    nttsNoteText
)
SELECT 
    'Balance Verify'			 as nttsDscrptn,
    'Verify Outstanding Balances'	 as nttsNoteText
EXCEPT
SELECT  
    nttsDscrptn,
    nttsNoteText
FROM [sma_MST_NoteTypes]

---
ALTER TABLE [sma_TRN_Notes] DISABLE TRIGGER ALL
GO
---

----(1)----
INSERT INTO [sma_TRN_Notes] (
      [notnCaseID],[notnNoteTypeID],[notmDescription],[notmPlainText],[notnContactCtgID],[notnContactId],[notsPriority],[notnFormID],[notnRecUserID],
      [notdDtCreated],[notnModifyUserID],[notdDtModified],[notnLevelNo],[notdDtInserted],[WorkPlanItemId],[notnSubject]
)
SELECT 
    casnCaseID	 as [notnCaseID],
    (select nttnNoteTypeID from [sma_MST_NoteTypes] where nttsDscrptn='Balance Verify') as [notnNoteTypeID],
    note		 as [notmDescription],
    note		 as [notmPlainText],
    0			 as [notnContactCtgID],
    null		 as [notnContactId],
    null		 as [notsPriority],
    null		 as [notnFormID],
    U.usrnUserID as [notnRecUserID],
    case
	   when N.note_date between '1900-01-01' and '2079-06-06' and convert(time,isnull(N.note_time,'00:00:00')) <> convert(time,'00:00:00')  
		  then CAST(CAST(N.note_date AS DATE) AS DATETIME) + CAST(CAST(N.note_time AS TIME) AS DATETIME)
	   else null
    end			 as notdDtCreated,
    null		 as [notnModifyUserID],
    null		 as notdDtModified,
    null		 as [notnLevelNo],
    null		 as [notdDtInserted],
    null		 as [WorkPlanItemId],
    null		 as [notnSubject]
FROM NeedlesSLF.[dbo].[value_notes] N
JOIN NeedlesSLF.[dbo].[value_Indexed] V on V.value_id=N.value_num
JOIN [sma_TRN_Cases] C on C.cassCaseNumber = V.case_id
JOIN [sma_MST_Users] U on U.saga=N.staff_id 
GO

---
ALTER TABLE [sma_TRN_Notes] ENABLE TRIGGER ALL
GO
---

-----------------------------------------
--INSERT RELATED TO FIELD FOR NOTES
-----------------------------------------
INSERT INTO sma_TRN_NoteContacts (NoteID, UniqueContactID)
SELECT DISTINCT note.notnNoteID, ioc.UNQCID
--select v.provider, ioc.*, n.note, note.*
FROM NeedlesSLF..[value_notes] N
JOIN NeedlesSLF..value_Indexed V on V.value_id=N.value_num
JOIN sma_trn_Cases cas on cas.cassCaseNumber = v.case_id
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = v.[provider]
JOIN [sma_TRN_Notes] note on note.saga = n.note_key
					and note.[notnNoteTypeID] = (select nttnNoteTypeID from [sma_MST_NoteTypes] where nttsDscrptn='Balance Verify')



