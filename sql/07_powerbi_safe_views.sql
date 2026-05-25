USE feright_risk_analysis;

DROP VIEW IF EXISTS pbi_carrier_risk_summary;
CREATE VIEW pbi_carrier_risk_summary AS
SELECT
    CAST(dot_number AS SIGNED) AS dot_number,
    CAST(legal_name AS CHAR(255)) AS legal_name,
    CAST(dba_name AS CHAR(255)) AS dba_name,
    CAST(status_code AS CHAR(25)) AS status_code,
    CAST(docket1_status_code AS CHAR(25)) AS docket1_status_code,
    CAST(phy_street AS CHAR(255)) AS phy_street,
    CAST(phy_city AS CHAR(100)) AS phy_city,
    CAST(phy_state AS CHAR(10)) AS phy_state,
    CAST(phy_zip AS CHAR(20)) AS phy_zip,
    CAST(carrier_operation AS CHAR(100)) AS carrier_operation,
    CAST(business_org_desc AS CHAR(100)) AS business_org_desc,
    CAST(power_units AS SIGNED) AS power_units,
    CAST(truck_units AS SIGNED) AS truck_units,
    CAST(total_drivers AS SIGNED) AS total_drivers,
    CAST(total_cdl AS SIGNED) AS total_cdl,
    CAST(hm_ind AS CHAR(10)) AS hm_ind,
    add_date,
    mcs150_date,
    CAST(safety_rating AS CHAR(50)) AS safety_rating,
    safety_rating_date,
    CAST(email_address AS CHAR(255)) AS email_address,
    CAST(inspection_count AS SIGNED) AS inspection_count,
    CAST(total_violations AS SIGNED) AS total_violations,
    CAST(total_oos AS SIGNED) AS total_oos,
    CAST(driver_oos_total AS SIGNED) AS driver_oos_total,
    CAST(vehicle_oos_total AS SIGNED) AS vehicle_oos_total,
    CAST(hazmat_oos_total AS SIGNED) AS hazmat_oos_total,
    CAST(post_accident_inspection_count AS SIGNED) AS post_accident_inspection_count,
    latest_insp_date,
    CAST(crash_count AS SIGNED) AS crash_count,
    CAST(injury_crash_count AS SIGNED) AS injury_crash_count,
    CAST(fatal_crash_count AS SIGNED) AS fatal_crash_count,
    CAST(tow_away_count AS SIGNED) AS tow_away_count,
    CAST(federal_recordable_count AS SIGNED) AS federal_recordable_count,
    latest_crash_date,
    CAST(missing_identity_flag AS SIGNED) AS missing_identity_flag,
    CAST(inactive_or_nonactive_status_flag AS SIGNED) AS inactive_or_nonactive_status_flag,
    CAST(authority_issue_flag AS SIGNED) AS authority_issue_flag,
    CAST(high_oos_flag AS SIGNED) AS high_oos_flag,
    CAST(high_violation_flag AS SIGNED) AS high_violation_flag,
    CAST(crash_history_flag AS SIGNED) AS crash_history_flag,
    CAST(hazmat_flag AS SIGNED) AS hazmat_flag,
    CAST(risk_score AS SIGNED) AS risk_score
FROM carrier_risk_summary;


DROP VIEW IF EXISTS pbi_carrier_profile;
CREATE VIEW pbi_carrier_profile AS
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
FROM pbi_carrier_risk_summary;


DROP VIEW IF EXISTS pbi_identity_authority_exceptions;
CREATE VIEW pbi_identity_authority_exceptions AS
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
FROM pbi_carrier_risk_summary
WHERE missing_identity_flag = 1
   OR inactive_or_nonactive_status_flag = 1
   OR authority_issue_flag = 1;


DROP VIEW IF EXISTS pbi_inspection_risk;
CREATE VIEW pbi_inspection_risk AS
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
        WHEN inspection_count > 0 THEN CAST(total_violations AS DECIMAL(18,4)) / CAST(inspection_count AS DECIMAL(18,4))
        ELSE NULL
    END AS violation_rate,
    CASE
        WHEN inspection_count > 0 THEN CAST(total_oos AS DECIMAL(18,4)) / CAST(inspection_count AS DECIMAL(18,4))
        ELSE NULL
    END AS oos_rate,
    risk_score
FROM pbi_carrier_risk_summary
WHERE inspection_count > 0;


DROP VIEW IF EXISTS pbi_crash_risk;
CREATE VIEW pbi_crash_risk AS
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
FROM pbi_carrier_risk_summary
WHERE crash_count > 0;


DROP VIEW IF EXISTS pbi_high_risk_carriers;
CREATE VIEW pbi_high_risk_carriers AS
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
FROM pbi_carrier_risk_summary
WHERE risk_score >= 3;
