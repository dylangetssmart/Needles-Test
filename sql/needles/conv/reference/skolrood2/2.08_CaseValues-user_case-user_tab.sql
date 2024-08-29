
/* ########################################################
- Compare the following values
    - user_tab_data.Paralegals_Est_Value
    - user_case_data.Attorneys_Est_Value
- Set sma_mst_CaseValue.csvnFromValue = to the lower value
- Set sma_mst_CaseValue.csvnToValue = to the higher value
*/

-- Drop the temporary table if it exists
IF OBJECT_ID('tempdb..#TempCaseValues') IS NOT NULL
DROP TABLE #TempCaseValues;

-- Create the temporary table
CREATE TABLE #TempCaseValues (
    CaseID varchar(25),
    Paralegals_Est_Value NUMERIC(9, 2) NULL,
    Attorneys_Est_Value NUMERIC(9, 2) NULL
);

-- Insert data into the temporary table
INSERT INTO #TempCaseValues (CaseID, Paralegals_Est_Value, Attorneys_Est_Value)
SELECT
    u.case_id AS CaseID,
    CAST(ut.Paralegals_Est_Value AS NUMERIC(9, 2)) AS Paralegals_Est_Value,
    CAST(uc.Attorneys_Est_Value AS NUMERIC(9, 2)) AS Attorneys_Est_Value
FROM NeedlesSLF..user_tab_data ut
JOIN NeedlesSLF..user_case_data uc ON d.casenum = u.case_id
WHERE isnull(ut.Paralegals_Est_Value,'') <> '' or isnull(uc.Attorneys_Est_Value,'') <> ''

-- Update the sma_TRN_Cases table
UPDATE sma_TRN_Cases
SET
    casnCaseValueFrom = CASE
                            WHEN tc.Paralegals_Est_Value <= tc.Attorneys_Est_Value
                                THEN tc.Paralegals_Est_Value
                            ELSE tc.Attorneys_Est_Value
                        END,
    casnCaseValueTo = CASE
                          WHEN tc.Paralegals_Est_Value > tc.Attorneys_Est_Value
                            THEN tc.Paralegals_Est_Value
                          ELSE tc.Attorneys_Est_Value
                      END
FROM #TempCaseValues tc
WHERE sma_TRN_Cases.CaseID = tc.CaseID;
