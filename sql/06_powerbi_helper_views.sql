USE feright_risk_analysis;

DROP VIEW IF EXISTS vw_carrier_profile;
CREATE VIEW vw_carrier_profile AS
SELECT
    dot_number,
    legal_name,
    dba_name,
    status_code,
    docket1_status_code,
    phy_city,
    phy_state,
    phy_zip,
    carrier_operation,
    business_org_desc,
    power_units,
    truck_units,
    total_drivers,
    total_cdl,
    hm_ind,
    add_date,
    mcs150_date,
    safety_rating,
    safety_rating_date,
    email_address
FROM carrier_risk_summary;


DROP VIEW IF EXISTS vw_identity_authority_exceptions;
CREATE VIEW vw_identity_authority_exceptions AS
SELECT
    dot_number,
    legal_name,
    dba_name,
    status_code,
    docket1_status_code,
    phy_city,
    phy_state,
    phy_zip,
    email_address,
    missing_identity_flag,
    inactive_or_nonactive_status_flag,
    authority_issue_flag,
    risk_score
FROM carrier_risk_summary
WHERE missing_identity_flag = 1
   OR inactive_or_nonactive_status_flag = 1
   OR authority_issue_flag = 1;


DROP VIEW IF EXISTS vw_inspection_risk;
CREATE VIEW vw_inspection_risk AS
SELECT
    dot_number,
    legal_name,
    phy_state,
    carrier_operation,
    business_org_desc,
    inspection_count,
    total_violations,
    total_oos,
    driver_oos_total,
    vehicle_oos_total,
    hazmat_oos_total,
    post_accident_inspection_count,
    latest_insp_date,
    high_oos_flag,
    high_violation_flag,
    CASE
        WHEN inspection_count > 0 THEN ROUND(total_violations / inspection_count, 2)
        ELSE NULL
    END AS violation_rate,
    CASE
        WHEN inspection_count > 0 THEN ROUND(total_oos / inspection_count, 4)
        ELSE NULL
    END AS oos_rate,
    risk_score
FROM carrier_risk_summary
WHERE inspection_count > 0;


DROP VIEW IF EXISTS vw_crash_risk;
CREATE VIEW vw_crash_risk AS
SELECT
    dot_number,
    legal_name,
    phy_state,
    carrier_operation,
    business_org_desc,
    crash_count,
    injury_crash_count,
    fatal_crash_count,
    tow_away_count,
    federal_recordable_count,
    latest_crash_date,
    crash_history_flag,
    risk_score
FROM carrier_risk_summary
WHERE crash_count > 0;


DROP VIEW IF EXISTS vw_high_risk_carriers;
CREATE VIEW vw_high_risk_carriers AS
SELECT
    dot_number,
    legal_name,
    dba_name,
    phy_state,
    carrier_operation,
    business_org_desc,
    status_code,
    docket1_status_code,
    inspection_count,
    total_violations,
    total_oos,
    crash_count,
    injury_crash_count,
    fatal_crash_count,
    missing_identity_flag,
    inactive_or_nonactive_status_flag,
    authority_issue_flag,
    high_oos_flag,
    high_violation_flag,
    crash_history_flag,
    hazmat_flag,
    risk_score
FROM carrier_risk_summary
WHERE risk_score >= 3;
