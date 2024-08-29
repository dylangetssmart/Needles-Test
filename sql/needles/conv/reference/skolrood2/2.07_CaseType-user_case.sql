/* ########################################################
- Update case types from user_case_data.Type_of_case
- Update case sub types from user_case_data.Type_of_accident
*/

-- Case Type
UPDATE sma_TRN_Cases
SET
    casnOrgCaseTypeID = (
        select cstnCaseTypeID
        from sma_MST_CaseType
        where cstsType = d.Type_of_Case
    )
from NeedlesSLF..user_case_data d
WHERE isnull(d.type_of_case,'') <> ''

-- Case Sub Type
UPDATE sma_TRN_Cases
SET
    casnCaseTypeID = (
        select cstnCaseSubTypeID
        from sma_MST_CaseSubType
        where cstsDscrptn = d.type_of_accident
    )
from NeedlesSLF..user_case_data d
WHERE isnull(d.type_of_accident,'') <> ''