-- First-pass staging views for MySQL.
-- Assumes the raw tables were loaded by scripts/import_fmcsa_to_mysql.py.

DROP VIEW IF EXISTS stg_company_census;
CREATE VIEW stg_company_census AS
SELECT
    CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED) AS dot_number,
    NULLIF(TRIM(LEGAL_NAME), '') AS legal_name,
    NULLIF(TRIM(DBA_NAME), '') AS dba_name,
    NULLIF(TRIM(STATUS_CODE), '') AS status_code,
    NULLIF(TRIM(CARRIER_OPERATION), '') AS carrier_operation,
    NULLIF(TRIM(BUSINESS_ORG_DESC), '') AS business_org_desc,
    NULLIF(TRIM(PHY_CITY), '') AS phy_city,
    NULLIF(TRIM(PHY_STATE), '') AS phy_state,
    NULLIF(TRIM(PHY_ZIP), '') AS phy_zip,
    NULLIF(TRIM(PHY_COUNTRY), '') AS phy_country,
    CAST(NULLIF(TRIM(TRUCK_UNITS), '') AS UNSIGNED) AS truck_units,
    CAST(NULLIF(TRIM(POWER_UNITS), '') AS UNSIGNED) AS power_units,
    CAST(NULLIF(TRIM(TOTAL_DRIVERS), '') AS UNSIGNED) AS total_drivers,
    CAST(NULLIF(TRIM(TOTAL_CDL), '') AS UNSIGNED) AS total_cdl,
    NULLIF(TRIM(HM_Ind), '') AS hm_ind,
    NULLIF(TRIM(SAFETY_RATING), '') AS safety_rating,
    NULLIF(TRIM(DOCKET1_STATUS_CODE), '') AS docket1_status_code,
    NULLIF(TRIM(EMAIL_ADDRESS), '') AS email_address,
    CASE
        WHEN LENGTH(TRIM(ADD_DATE)) = 8 THEN
            substr(TRIM(ADD_DATE), 1, 4) || '-' || substr(TRIM(ADD_DATE), 5, 2) || '-' || substr(TRIM(ADD_DATE), 7, 2)
    END AS add_date,
    CASE
        WHEN LENGTH(TRIM(MCS150_DATE)) = 8 THEN
            substr(TRIM(MCS150_DATE), 1, 4) || '-' || substr(TRIM(MCS150_DATE), 5, 2) || '-' || substr(TRIM(MCS150_DATE), 7, 2)
    END AS mcs150_date,
    CASE
        WHEN LENGTH(TRIM(REVIEW_DATE)) = 8 THEN
            substr(TRIM(REVIEW_DATE), 1, 4) || '-' || substr(TRIM(REVIEW_DATE), 5, 2) || '-' || substr(TRIM(REVIEW_DATE), 7, 2)
    END AS review_date,
    CASE
        WHEN LENGTH(TRIM(SAFETY_RATING_DATE)) = 8 THEN
            substr(TRIM(SAFETY_RATING_DATE), 1, 4) || '-' || substr(TRIM(SAFETY_RATING_DATE), 5, 2) || '-' || substr(TRIM(SAFETY_RATING_DATE), 7, 2)
    END AS safety_rating_date
FROM raw_company_census;

DROP VIEW IF EXISTS stg_vehicle_inspection;
CREATE VIEW stg_vehicle_inspection AS
SELECT
    CAST(NULLIF(TRIM(INSPECTION_ID), '') AS UNSIGNED) AS inspection_id,
    CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED) AS dot_number,
    NULLIF(TRIM(REPORT_STATE), '') AS report_state,
    NULLIF(TRIM(LOCATION), '') AS location,
    NULLIF(TRIM(LOCATION_DESC), '') AS location_desc,
    NULLIF(TRIM(REGION), '') AS region,
    NULLIF(TRIM(CI_STATUS_CODE), '') AS ci_status_code,
    NULLIF(TRIM(INSP_LEVEL_ID), '') AS insp_level_id,
    NULLIF(TRIM(POST_ACC_IND), '') AS post_acc_ind,
    CAST(NULLIF(TRIM(GROSS_COMB_VEH_WT), '') AS UNSIGNED) AS gross_comb_veh_wt,
    CAST(NULLIF(TRIM(VIOL_TOTAL), '') AS UNSIGNED) AS viol_total,
    CAST(NULLIF(TRIM(OOS_TOTAL), '') AS UNSIGNED) AS oos_total,
    CAST(NULLIF(TRIM(DRIVER_VIOL_TOTAL), '') AS UNSIGNED) AS driver_viol_total,
    CAST(NULLIF(TRIM(DRIVER_OOS_TOTAL), '') AS UNSIGNED) AS driver_oos_total,
    CAST(NULLIF(TRIM(VEHICLE_VIOL_TOTAL), '') AS UNSIGNED) AS vehicle_viol_total,
    CAST(NULLIF(TRIM(VEHICLE_OOS_TOTAL), '') AS UNSIGNED) AS vehicle_oos_total,
    CAST(NULLIF(TRIM(HAZMAT_VIOL_TOTAL), '') AS UNSIGNED) AS hazmat_viol_total,
    CAST(NULLIF(TRIM(HAZMAT_OOS_TOTAL), '') AS UNSIGNED) AS hazmat_oos_total,
    NULLIF(TRIM(INSP_CARRIER_NAME), '') AS insp_carrier_name,
    NULLIF(TRIM(INSP_CARRIER_CITY), '') AS insp_carrier_city,
    NULLIF(TRIM(INSP_CARRIER_STATE), '') AS insp_carrier_state,
    NULLIF(TRIM(INSP_CARRIER_ZIP_CODE), '') AS insp_carrier_zip_code,
    CASE
        WHEN LENGTH(TRIM(INSP_DATE)) = 8 THEN
            substr(TRIM(INSP_DATE), 1, 4) || '-' || substr(TRIM(INSP_DATE), 5, 2) || '-' || substr(TRIM(INSP_DATE), 7, 2)
    END AS insp_date,
    CASE
        WHEN LENGTH(TRIM(FINAL_STATUS_DATE)) = 12 THEN
            substr(TRIM(FINAL_STATUS_DATE), 1, 4) || '-' || substr(TRIM(FINAL_STATUS_DATE), 5, 2) || '-' || substr(TRIM(FINAL_STATUS_DATE), 7, 2)
    END AS final_status_date,
    CASE
        WHEN LENGTH(TRIM(MCMIS_ADD_DATE)) = 12 THEN
            substr(TRIM(MCMIS_ADD_DATE), 1, 4) || '-' || substr(TRIM(MCMIS_ADD_DATE), 5, 2) || '-' || substr(TRIM(MCMIS_ADD_DATE), 7, 2)
    END AS mcmis_add_date
FROM raw_vehicle_inspection;

DROP VIEW IF EXISTS stg_crash;
CREATE VIEW stg_crash AS
SELECT
    CAST(NULLIF(TRIM(CRASH_ID), '') AS UNSIGNED) AS crash_id,
    NULLIF(TRIM(REPORT_NUMBER), '') AS report_number,
    CAST(NULLIF(TRIM(REPORT_SEQ_NO), '') AS UNSIGNED) AS report_seq_no,
    CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED) AS dot_number,
    NULLIF(TRIM(REPORT_STATE), '') AS report_state,
    NULLIF(TRIM(CITY), '') AS city,
    NULLIF(TRIM(STATE), '') AS state,
    NULLIF(TRIM(LOCATION), '') AS location,
    NULLIF(TRIM(CI_STATUS_CODE), '') AS ci_status_code,
    CAST(NULLIF(TRIM(VEHICLES_IN_ACCIDENT), '') AS UNSIGNED) AS vehicles_in_accident,
    CAST(NULLIF(TRIM(FATALITIES), '') AS UNSIGNED) AS fatalities,
    CAST(NULLIF(TRIM(INJURIES), '') AS UNSIGNED) AS injuries,
    NULLIF(TRIM(TOW_AWAY), '') AS tow_away,
    NULLIF(TRIM(FEDERAL_RECORDABLE), '') AS federal_recordable,
    NULLIF(TRIM(STATE_RECORDABLE), '') AS state_recordable,
    NULLIF(TRIM(CRASH_CARRIER_NAME), '') AS crash_carrier_name,
    NULLIF(TRIM(CRASH_CARRIER_CITY), '') AS crash_carrier_city,
    NULLIF(TRIM(CRASH_CARRIER_STATE), '') AS crash_carrier_state,
    NULLIF(TRIM(CRASH_CARRIER_ZIP_CODE), '') AS crash_carrier_zip_code,
    CASE
        WHEN LENGTH(TRIM(REPORT_DATE)) = 8 THEN
            substr(TRIM(REPORT_DATE), 1, 4) || '-' || substr(TRIM(REPORT_DATE), 5, 2) || '-' || substr(TRIM(REPORT_DATE), 7, 2)
    END AS report_date,
    CASE
        WHEN LENGTH(TRIM(FINAL_STATUS_DATE)) = 12 THEN
            substr(TRIM(FINAL_STATUS_DATE), 1, 4) || '-' || substr(TRIM(FINAL_STATUS_DATE), 5, 2) || '-' || substr(TRIM(FINAL_STATUS_DATE), 7, 2)
    END AS final_status_date,
    CASE
        WHEN LENGTH(TRIM(ADD_DATE)) = 12 THEN
            substr(TRIM(ADD_DATE), 1, 4) || '-' || substr(TRIM(ADD_DATE), 5, 2) || '-' || substr(TRIM(ADD_DATE), 7, 2)
    END AS add_date
FROM raw_crash;

