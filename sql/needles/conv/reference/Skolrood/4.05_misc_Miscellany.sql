-- use SANeedlesSLF
GO

TRUNCATE TABLE sma_TRN_RoleCaseStuffMainRoles
GO

IF (SELECT COUNT(*) FROM sma_TRN_RoleCaseStuffMainRoles)=0
BEGIN
                INSERT INTO sma_TRN_RoleCaseStuffMainRoles([CaseID],[AttyContactID],[ParalegalContactID],                [CaseManagerContactID])
                SELECT cssnCaseID AS CaseID,  [1], [2],[3]
                FROM
                (SELECT SS.cssnCaseID, SS.cssnStaffID, RG.RoleGroupID
                FROM sma_TRN_CaseStaff SS
                JOIN sma_MST_RolePriorityGroup RG ON RoleID = cssnRoleID and SS.cssdToDate IS NULL
                OUTER APPLY   (
                                SELECT TOP 1  cssnCaseID AS CaseID, RoleGroupID, PriorityFlag, cssnStaffID , cssnPKID
                                FROM  sma_TRN_CaseStaff sss
                                JOIN sma_MST_RolePriorityGroup RF ON RoleID = cssnRoleID
                                WHERE sss.cssdToDate IS NULL and sss.cssnCaseID  IS NOT NULL and sss.cssnCaseID = SS.cssnCaseID and RG.RoleGroupID = RF.RoleGroupID
                                ORDER BY CAseID, PriorityFlag, sss.cssdFromDate) dddd
                WHERE dddd.CaseID = SS.cssnCaseID and dddd.cssnPKID = ss.cssnPKID and  dddd.RoleGroupID is not null) AS SourceTable
                PIVOT
                (
                AVG(cssnStaffID)
                FOR RoleGroupID IN ([1], [2],[3])
                ) AS PivotTable
END
