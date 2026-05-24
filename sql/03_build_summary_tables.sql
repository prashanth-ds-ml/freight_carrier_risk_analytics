DROP VIEW IF EXISTS company_census_selected;

CREATE VIEW company_census_selected AS
SELECT
    CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED) AS dot_number,
    NULLIF(TRIM(LEGAL_NAME), '') AS legal_name,
    NULLIF(TRIM(DBA_NAME), '') AS dba_name,
    NULLIF(TRIM(STATUS_CODE), '') AS status_code,
    NULLIF(TRIM(DOCKET1_STATUS_CODE), '') AS docket1_status_code,
    NULLIF(TRIM(PHY_STREET), '') AS phy_street,
    NULLIF(TRIM(PHY_CITY), '') AS phy_city,
    NULLIF(TRIM(PHY_STATE), '') AS phy_state,
    NULLIF(TRIM(PHY_ZIP), '') AS phy_zip,
    NULLIF(TRIM(CARRIER_OPERATION), '') AS carrier_operation,
    NULLIF(TRIM(BUSINESS_ORG_DESC), '') AS business_org_desc,
    CAST(NULLIF(TRIM(POWER_UNITS), '') AS UNSIGNED) AS power_units,
    CAST(NULLIF(TRIM(TRUCK_UNITS), '') AS UNSIGNED) AS truck_units,
    CAST(NULLIF(TRIM(TOTAL_DRIVERS), '') AS UNSIGNED) AS total_drivers,
    CAST(NULLIF(TRIM(TOTAL_CDL), '') AS UNSIGNED) AS total_cdl,
    NULLIF(TRIM(HM_Ind), '') AS hm_ind,
    CASE
        WHEN LENGTH(TRIM(ADD_DATE)) = 8 THEN STR_TO_DATE(TRIM(ADD_DATE), '%Y%m%d')
        ELSE NULL
    END AS add_date,
    CASE
        WHEN LENGTH(TRIM(MCS150_DATE)) = 8 THEN STR_TO_DATE(TRIM(MCS150_DATE), '%Y%m%d')
        ELSE NULL
    END AS mcs150_date,
    NULLIF(TRIM(SAFETY_RATING), '') AS safety_rating,
    CASE
        WHEN LENGTH(TRIM(SAFETY_RATING_DATE)) = 8 THEN STR_TO_DATE(TRIM(SAFETY_RATING_DATE), '%Y%m%d')
        ELSE NULL
    END AS safety_rating_date,
    NULLIF(TRIM(EMAIL_ADDRESS), '') AS email_address
FROM raw_company_census;


DROP TABLE IF EXISTS inspection_summary_by_carrier;

CREATE TABLE inspection_summary_by_carrier AS
SELECT
    CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED) AS dot_number,
    COUNT(*) AS inspection_count,
    SUM(COALESCE(CAST(NULLIF(TRIM(VIOL_TOTAL), '') AS UNSIGNED), 0)) AS total_violations,
    SUM(COALESCE(CAST(NULLIF(TRIM(OOS_TOTAL), '') AS UNSIGNED), 0)) AS total_oos,
    SUM(COALESCE(CAST(NULLIF(TRIM(DRIVER_OOS_TOTAL), '') AS UNSIGNED), 0)) AS driver_oos_total,
    SUM(COALESCE(CAST(NULLIF(TRIM(VEHICLE_OOS_TOTAL), '') AS UNSIGNED), 0)) AS vehicle_oos_total,
    SUM(COALESCE(CAST(NULLIF(TRIM(HAZMAT_OOS_TOTAL), '') AS UNSIGNED), 0)) AS hazmat_oos_total,
    SUM(CASE WHEN NULLIF(TRIM(POST_ACC_IND), '') = 'Y' THEN 1 ELSE 0 END) AS post_accident_inspection_count,
    MAX(
        CASE
            WHEN LENGTH(TRIM(INSP_DATE)) = 8 THEN STR_TO_DATE(TRIM(INSP_DATE), '%Y%m%d')
            ELSE NULL
        END
    ) AS latest_insp_date
FROM raw_vehicle_inspection
WHERE NULLIF(TRIM(DOT_NUMBER), '') IS NOT NULL
GROUP BY CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED);

CREATE INDEX idx_inspection_summary_dot ON inspection_summary_by_carrier (dot_number);


DROP TABLE IF EXISTS crash_summary_by_carrier;

CREATE TABLE crash_summary_by_carrier AS
SELECT
    CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED) AS dot_number,
    COUNT(*) AS crash_count,
    SUM(CASE WHEN COALESCE(CAST(NULLIF(TRIM(INJURIES), '') AS UNSIGNED), 0) > 0 THEN 1 ELSE 0 END) AS injury_crash_count,
    SUM(CASE WHEN COALESCE(CAST(NULLIF(TRIM(FATALITIES), '') AS UNSIGNED), 0) > 0 THEN 1 ELSE 0 END) AS fatal_crash_count,
    SUM(CASE WHEN NULLIF(TRIM(TOW_AWAY), '') = 'Y' THEN 1 ELSE 0 END) AS tow_away_count,
    SUM(CASE WHEN NULLIF(TRIM(FEDERAL_RECORDABLE), '') = 'Y' THEN 1 ELSE 0 END) AS federal_recordable_count,
    MAX(
        CASE
            WHEN LENGTH(TRIM(REPORT_DATE)) = 8 THEN STR_TO_DATE(TRIM(REPORT_DATE), '%Y%m%d')
            ELSE NULL
        END
    ) AS latest_crash_date
FROM raw_crash
WHERE NULLIF(TRIM(DOT_NUMBER), '') IS NOT NULL
GROUP BY CAST(NULLIF(TRIM(DOT_NUMBER), '') AS UNSIGNED);

CREATE INDEX idx_crash_summary_dot ON crash_summary_by_carrier (dot_number);


DROP TABLE IF EXISTS carrier_risk_summary;

CREATE TABLE carrier_risk_summary AS
SELECT
    c.dot_number,
    c.legal_name,
    c.dba_name,
    c.status_code,
    c.docket1_status_code,
    c.phy_street,
    c.phy_city,
    c.phy_state,
    c.phy_zip,
    c.carrier_operation,
    c.business_org_desc,
    c.power_units,
    c.truck_units,
    c.total_drivers,
    c.total_cdl,
    c.hm_ind,
    c.add_date,
    c.mcs150_date,
    c.safety_rating,
    c.safety_rating_date,
    c.email_address,
    COALESCE(i.inspection_count, 0) AS inspection_count,
    COALESCE(i.total_violations, 0) AS total_violations,
    COALESCE(i.total_oos, 0) AS total_oos,
    COALESCE(i.driver_oos_total, 0) AS driver_oos_total,
    COALESCE(i.vehicle_oos_total, 0) AS vehicle_oos_total,
    COALESCE(i.hazmat_oos_total, 0) AS hazmat_oos_total,
    COALESCE(i.post_accident_inspection_count, 0) AS post_accident_inspection_count,
    i.latest_insp_date,
    COALESCE(cr.crash_count, 0) AS crash_count,
    COALESCE(cr.injury_crash_count, 0) AS injury_crash_count,
    COALESCE(cr.fatal_crash_count, 0) AS fatal_crash_count,
    COALESCE(cr.tow_away_count, 0) AS tow_away_count,
    COALESCE(cr.federal_recordable_count, 0) AS federal_recordable_count,
    cr.latest_crash_date,
    CASE
        WHEN c.legal_name IS NULL
          OR c.phy_state IS NULL
          OR c.phy_city IS NULL
          OR c.phy_zip IS NULL THEN 1
        ELSE 0
    END AS missing_identity_flag,
    CASE
        WHEN c.status_code IS NULL OR c.status_code <> 'A' THEN 1
        ELSE 0
    END AS inactive_or_nonactive_status_flag,
    CASE
        WHEN c.docket1_status_code IS NULL OR c.docket1_status_code <> 'A' THEN 1
        ELSE 0
    END AS authority_issue_flag,
    CASE
        WHEN COALESCE(i.inspection_count, 0) > 0
         AND (COALESCE(i.total_oos, 0) / i.inspection_count) >= 0.3 THEN 1
        ELSE 0
    END AS high_oos_flag,
    CASE
        WHEN COALESCE(i.inspection_count, 0) > 0
         AND (COALESCE(i.total_violations, 0) / i.inspection_count) >= 2 THEN 1
        ELSE 0
    END AS high_violation_flag,
    CASE
        WHEN COALESCE(cr.crash_count, 0) > 0 THEN 1
        ELSE 0
    END AS crash_history_flag,
    CASE
        WHEN c.hm_ind = 'Y' THEN 1
        ELSE 0
    END AS hazmat_flag,
    (
        CASE
            WHEN c.legal_name IS NULL
              OR c.phy_state IS NULL
              OR c.phy_city IS NULL
              OR c.phy_zip IS NULL THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN c.status_code IS NULL OR c.status_code <> 'A' THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN c.docket1_status_code IS NULL OR c.docket1_status_code <> 'A' THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN COALESCE(i.inspection_count, 0) > 0
             AND (COALESCE(i.total_oos, 0) / i.inspection_count) >= 0.3 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN COALESCE(i.inspection_count, 0) > 0
             AND (COALESCE(i.total_violations, 0) / i.inspection_count) >= 2 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN COALESCE(cr.crash_count, 0) > 0 THEN 1
            ELSE 0
        END
    ) AS risk_score
FROM company_census_selected c
LEFT JOIN inspection_summary_by_carrier i
    ON c.dot_number = i.dot_number
LEFT JOIN crash_summary_by_carrier cr
    ON c.dot_number = cr.dot_number;

CREATE INDEX idx_carrier_risk_summary_dot ON carrier_risk_summary (dot_number);
CREATE INDEX idx_carrier_risk_summary_state ON carrier_risk_summary (phy_state(8));
CREATE INDEX idx_carrier_risk_summary_status ON carrier_risk_summary (status_code(8));
CREATE INDEX idx_carrier_risk_summary_risk_score ON carrier_risk_summary (risk_score);
