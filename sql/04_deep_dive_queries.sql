SELECT
    dot_number,
    legal_name,
    phy_state,
    status_code,
    docket1_status_code,
    inspection_count,
    total_violations,
    total_oos,
    crash_count,
    injury_crash_count,
    fatal_crash_count,
    risk_score
FROM carrier_risk_summary
WHERE risk_score >= 3
ORDER BY risk_score DESC, crash_count DESC, total_oos DESC
LIMIT 100;

SELECT
    phy_state,
    COUNT(*) AS carrier_count,
    SUM(CASE WHEN risk_score >= 3 THEN 1 ELSE 0 END) AS high_risk_carrier_count,
    ROUND(100 * SUM(CASE WHEN risk_score >= 3 THEN 1 ELSE 0 END) / COUNT(*), 2) AS high_risk_pct
FROM carrier_risk_summary
WHERE phy_state IS NOT NULL
GROUP BY phy_state
ORDER BY high_risk_carrier_count DESC
LIMIT 25;

SELECT
    carrier_operation,
    COUNT(*) AS carrier_count,
    ROUND(AVG(inspection_count), 2) AS avg_inspections,
    ROUND(AVG(crash_count), 2) AS avg_crashes,
    ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM carrier_risk_summary
WHERE carrier_operation IS NOT NULL
GROUP BY carrier_operation
ORDER BY avg_risk_score DESC, carrier_count DESC;

SELECT
    business_org_desc,
    COUNT(*) AS carrier_count,
    ROUND(AVG(inspection_count), 2) AS avg_inspections,
    ROUND(AVG(crash_count), 2) AS avg_crashes,
    ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM carrier_risk_summary
WHERE business_org_desc IS NOT NULL
GROUP BY business_org_desc
ORDER BY avg_risk_score DESC, carrier_count DESC;

