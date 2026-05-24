SELECT COUNT(*) AS total_carriers
FROM carrier_risk_summary;

SELECT
    COUNT(*) AS active_carriers,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS active_carrier_pct
FROM carrier_risk_summary
WHERE status_code = 'A';

SELECT
    COUNT(*) AS carriers_with_missing_identity,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS missing_identity_pct
FROM carrier_risk_summary
WHERE missing_identity_flag = 1;

SELECT
    SUM(inspection_count) AS total_inspections,
    SUM(total_violations) AS total_violations,
    ROUND(SUM(total_violations) / NULLIF(SUM(inspection_count), 0), 2) AS violation_rate
FROM carrier_risk_summary;

SELECT
    SUM(inspection_count) AS total_inspections,
    SUM(total_oos) AS total_oos,
    ROUND(SUM(total_oos) / NULLIF(SUM(inspection_count), 0), 4) AS oos_rate
FROM carrier_risk_summary;

SELECT
    SUM(crash_count) AS total_linked_crashes,
    SUM(injury_crash_count) AS injury_crashes,
    SUM(fatal_crash_count) AS fatal_crashes
FROM carrier_risk_summary;

SELECT
    COUNT(*) AS high_risk_carriers,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS high_risk_carrier_pct
FROM carrier_risk_summary
WHERE risk_score >= 3;

SELECT
    risk_score,
    COUNT(*) AS carrier_count
FROM carrier_risk_summary
GROUP BY risk_score
ORDER BY risk_score DESC;

