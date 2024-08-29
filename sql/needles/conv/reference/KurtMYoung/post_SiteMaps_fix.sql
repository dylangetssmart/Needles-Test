
declare @caseGroupID int

DECLARE siteMap_cursor CURSOR FOR 

SELECT csmnCaseGroupID--, Count(csmnCaseGroupID)
FROM sma_mst_sitemaps
GROUP BY csmncaseGroupid
HAVING Count(csmnCaseGroupID) > 200

OPEN siteMap_cursor 
FETCH NEXT FROM siteMap_cursor INTO @caseGroupID
WHILE @@FETCH_STATUS = 0
BEGIN

		DELETE sma_mst_sitemaps
		WHERE csmnCaseGroupID in (@caseGroupID)

		INSERT INTO sma_MST_SiteMaps
		(
			csmnParentId,
			csmsurl,
			csmsTitle,
			csmncasegroupid,
			csmbVisible,
			csmnnodelevel,
			csmnnodeid,
			csmsuniquetitle
		)
		SELECT csmnParentId,
				csmsurl,
				csmsTitle,
				@caseGroupID,  --csmncasegroupid,
				csmbVisible,
				csmnnodelevel,
				csmnnodeid,
				csmsuniquetitle
		From sma_mst_sitemaps
		where csmnCaseGroupId = 0


FETCH NEXT FROM siteMap_cursor INTO @caseGroupID
END 
CLOSE siteMap_cursor;
DEALLOCATE siteMap_cursor;
