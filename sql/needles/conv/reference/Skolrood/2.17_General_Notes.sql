-- use [SANeedlesSLF]
GO

/*
alter table [sma_TRN_Notes] disable trigger all
delete from [sma_TRN_Notes] 
DBCC CHECKIDENT ('[sma_TRN_Notes]', RESEED, 0);
alter table [sma_TRN_Notes] enable trigger all
*/
if not exists (Select * From sys.tables t join sys.columns c on t.object_id = c.object_id where t.name = 'Sma_trn_notes' and c.name = 'saga')
begin
	alter table sma_trn_notes
	add SAGA int
end
GO

----(0)----
INSERT INTO [sma_MST_NoteTypes] ( nttsDscrptn, nttsNoteText )
SELECT DISTINCT 
    topic as nttsDscrptn,
    topic as nttsNoteText
FROM NeedlesSLF.[dbo].[case_notes_Indexed]
    EXCEPT
SELECT nttsDscrptn, nttsNoteText FROM [sma_MST_NoteTypes]
GO

---
ALTER TABLE [sma_TRN_Notes] disable trigger all
GO
---

----(1)----
INSERT INTO [sma_TRN_Notes]
(
      [notnCaseID]
	  ,[notnNoteTypeID]
	  ,[notmDescription]
	  ,[notmPlainText]
	  ,[notnContactCtgID]
	  ,[notnContactId]
	  ,[notsPriority]
	  ,[notnFormID]
	  ,[notnRecUserID]
	  ,[notdDtCreated]
	  ,[notnModifyUserID]
	  ,[notdDtModified]
	  ,[notnLevelNo]
	  ,[notdDtInserted]
	  ,[WorkPlanItemId]
	  ,[notnSubject]
	  ,SAGA
)
SELECT 
    casnCaseID							as [notnCaseID]
    ,(
		select min(nttnNoteTypeID)
		from [sma_MST_NoteTypes]
		where nttsDscrptn=N.topic
	)									as [notnNoteTypeID]
    ,note								as [notmDescription]
    ,replace(note, char(10), '<br>')	as [notmPlainText]
    ,0									as [notnContactCtgID]
    ,null								as [notnContactId]
    ,null								as [notsPriority]
    ,null								as [notnFormID]
    ,U.usrnUserID						as [notnRecUserID]
    ,CASE
    	WHEN N.note_date BETWEEN '1900-01-01' AND '2079-06-06' AND CONVERT(time, ISNULL(N.note_time,'00:00:00')) <> CONVERT(time,'00:00:00')
        	THEN CAST(CAST(N.note_date AS DATETIME) + CAST(N.note_time AS DATETIME) AS DATETIME)
    	WHEN N.note_date BETWEEN '1900-01-01' AND '2079-06-06' AND CONVERT(time, ISNULL(N.note_time,'00:00:00')) = CONVERT(time,'00:00:00') 
	        THEN CAST(CAST(N.note_date AS DATETIME) + CAST('00:00:00' AS DATETIME) AS DATETIME)
	    ELSE '1900-01-01'
	END									AS notdDtCreated
    ,null								as [notnModifyUserID]
    ,null								as notdDtModified
    ,null								as [notnLevelNo]
    ,null								as [notdDtInserted]
    ,null		 						as [WorkPlanItemId]
    ,null		 						as [notnSubject]
	,note_key							as SAGA
FROM NeedlesSLF.[dbo].[case_notes_Indexed] N
	JOIN [sma_TRN_Cases] C
		on C.cassCaseNumber = N.case_num
	LEFT JOIN [sma_MST_Users] U
		on U.saga=N.staff_id 
	LEFT JOIN [sma_TRN_Notes] ns
		on ns.saga = note_key
WHERE ns.notnNoteID IS NULL
GO


--alter table sma_trn_notes disable trigger all
--update  sma_trn_notes set notmPlainText=replace(notmPlainText,char(10),'<br>') where  notmPlainText like '%'+char(10)+'%'
--alter table sma_trn_notes enable trigger all

---
ALTER TABLE [sma_TRN_Notes] enable trigger all
GO
---

