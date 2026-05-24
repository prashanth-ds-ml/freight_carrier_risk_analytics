-- Raw import validation and first-pass understanding queries for MySQL.
-- Run after scripts/import_fmcsa_to_mysql.py completes.

-- 1. Row counts
SELECT 'raw_company_census' AS table_name, COUNT(*) AS row_count
FROM raw_company_census
UNION ALL
SELECT 'raw_crash' AS table_name, COUNT(*) AS row_count
FROM raw_crash
UNION ALL
SELECT 'raw_vehicle_inspection' AS table_name, COUNT(*) AS row_count
FROM raw_vehicle_inspection;


-- 2. Key completeness and distinctness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT DOT_NUMBER) AS distinct_dot_number,
    SUM(CASE WHEN NULLIF(TRIM(DOT_NUMBER), '') IS NULL THEN 1 ELSE 0 END) AS missing_dot_number
FROM raw_company_census;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CRASH_ID) AS distinct_crash_id,
    COUNT(DISTINCT DOT_NUMBER) AS distinct_dot_number,
    SUM(CASE WHEN NULLIF(TRIM(DOT_NUMBER), '') IS NULL THEN 1 ELSE 0 END) AS missing_dot_number
FROM raw_crash;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT INSPECTION_ID) AS distinct_inspection_id,
    COUNT(DISTINCT DOT_NUMBER) AS distinct_dot_number,
    SUM(CASE WHEN NULLIF(TRIM(DOT_NUMBER), '') IS NULL THEN 1 ELSE 0 END) AS missing_dot_number
FROM raw_vehicle_inspection;


-- 3. Census data understanding
SELECT STATUS_CODE, COUNT(*) AS carrier_count
FROM raw_company_census
GROUP BY STATUS_CODE
ORDER BY carrier_count DESC;

SELECT
    SUM(CASE WHEN NULLIF(TRIM(LEGAL_NAME), '') IS NULL THEN 1 ELSE 0 END) AS missing_legal_name,
    SUM(CASE WHEN NULLIF(TRIM(PHY_CITY), '') IS NULL THEN 1 ELSE 0 END) AS missing_phy_city,
    SUM(CASE WHEN NULLIF(TRIM(PHY_STATE), '') IS NULL THEN 1 ELSE 0 END) AS missing_phy_state,
    SUM(CASE WHEN NULLIF(TRIM(PHY_ZIP), '') IS NULL THEN 1 ELSE 0 END) AS missing_phy_zip,
    SUM(CASE WHEN NULLIF(TRIM(TOTAL_DRIVERS), '') IS NULL THEN 1 ELSE 0 END) AS missing_total_drivers,
    SUM(CASE WHEN NULLIF(TRIM(POWER_UNITS), '') IS NULL THEN 1 ELSE 0 END) AS missing_power_units
FROM raw_company_census;

SELECT
    MIN(STR_TO_DATE(ADD_DATE, '%Y%m%d')) AS min_add_date,
    MAX(STR_TO_DATE(ADD_DATE, '%Y%m%d')) AS max_add_date,
    MIN(STR_TO_DATE(MCS150_DATE, '%Y%m%d')) AS min_mcs150_date,
    MAX(STR_TO_DATE(MCS150_DATE, '%Y%m%d')) AS max_mcs150_date
FROM raw_company_census
WHERE NULLIF(TRIM(ADD_DATE), '') IS NOT NULL
   OR NULLIF(TRIM(MCS150_DATE), '') IS NOT NULL;


-- 4. Crash data understanding
SELECT
    SUM(CASE WHEN NULLIF(TRIM(STATE), '') IS NULL THEN 1 ELSE 0 END) AS missing_state,
    SUM(CASE WHEN NULLIF(TRIM(REPORT_NUMBER), '') IS NULL THEN 1 ELSE 0 END) AS missing_report_number,
    SUM(CASE WHEN NULLIF(TRIM(FATALITIES), '') IS NULL THEN 1 ELSE 0 END) AS missing_fatalities,
    SUM(CASE WHEN NULLIF(TRIM(INJURIES), '') IS NULL THEN 1 ELSE 0 END) AS missing_injuries
FROM raw_crash;

SELECT
    MIN(STR_TO_DATE(REPORT_DATE, '%Y%m%d')) AS min_report_date,
    MAX(STR_TO_DATE(REPORT_DATE, '%Y%m%d')) AS max_report_date
FROM raw_crash
WHERE NULLIF(TRIM(REPORT_DATE), '') IS NOT NULL;

SELECT TOW_AWAY, FEDERAL_RECORDABLE, COUNT(*) AS crash_rows
FROM raw_crash
GROUP BY TOW_AWAY, FEDERAL_RECORDABLE
ORDER BY crash_rows DESC;


-- 5. Vehicle inspection data understanding
SELECT
    SUM(CASE WHEN NULLIF(TRIM(INSP_DATE), '') IS NULL THEN 1 ELSE 0 END) AS missing_insp_date,
    SUM(CASE WHEN NULLIF(TRIM(VIOL_TOTAL), '') IS NULL THEN 1 ELSE 0 END) AS missing_viol_total,
    SUM(CASE WHEN NULLIF(TRIM(OOS_TOTAL), '') IS NULL THEN 1 ELSE 0 END) AS missing_oos_total,
    SUM(CASE WHEN NULLIF(TRIM(REPORT_STATE), '') IS NULL THEN 1 ELSE 0 END) AS missing_report_state
FROM raw_vehicle_inspection;

SELECT
    MIN(STR_TO_DATE(INSP_DATE, '%Y%m%d')) AS min_insp_date,
    MAX(STR_TO_DATE(INSP_DATE, '%Y%m%d')) AS max_insp_date
FROM raw_vehicle_inspection
WHERE NULLIF(TRIM(INSP_DATE), '') IS NOT NULL;

SELECT INSP_LEVEL_ID, COUNT(*) AS inspection_rows
FROM raw_vehicle_inspection
GROUP BY INSP_LEVEL_ID
ORDER BY inspection_rows DESC;


-- 6. Join readiness
SELECT COUNT(*) AS inspections_without_census_match
FROM raw_vehicle_inspection i
LEFT JOIN raw_company_census c
    ON TRIM(i.DOT_NUMBER) = TRIM(c.DOT_NUMBER)
WHERE NULLIF(TRIM(i.DOT_NUMBER), '') IS NOT NULL
  AND c.DOT_NUMBER IS NULL;

SELECT COUNT(*) AS crashes_without_census_match
FROM raw_crash cr
LEFT JOIN raw_company_census c
    ON TRIM(cr.DOT_NUMBER) = TRIM(c.DOT_NUMBER)
WHERE NULLIF(TRIM(cr.DOT_NUMBER), '') IS NOT NULL
  AND c.DOT_NUMBER IS NULL;


-- 7. Quick raw samples
SELECT DOT_NUMBER, LEGAL_NAME, STATUS_CODE, PHY_STATE, POWER_UNITS, TOTAL_DRIVERS
FROM raw_company_census
LIMIT 10;

SELECT CRASH_ID, REPORT_NUMBER, DOT_NUMBER, REPORT_DATE, STATE, FATALITIES, INJURIES
FROM raw_crash
LIMIT 10;

SELECT INSPECTION_ID, DOT_NUMBER, INSP_DATE, REPORT_STATE, VIOL_TOTAL, OOS_TOTAL
FROM raw_vehicle_inspection
LIMIT 10;
