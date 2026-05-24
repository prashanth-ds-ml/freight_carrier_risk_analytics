USE feright_risk_analysis;

-- 1. How many total carriers do we have?
SELECT COUNT(*) AS total_carriers
FROM carrier_risk_summary;


-- 2. How many are active vs non-active?
SELECT
    CASE
        WHEN status_code = 'A' THEN 'Active'
        ELSE 'Non-Active or Unknown'
    END AS carrier_status_group,
    COUNT(*) AS carrier_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS carrier_pct
FROM carrier_risk_summary
GROUP BY
    CASE
        WHEN status_code = 'A' THEN 'Active'
        ELSE 'Non-Active or Unknown'
    END
ORDER BY carrier_count DESC;


-- 3. How many carriers have missing identity information?
SELECT
    COUNT(*) AS carriers_with_missing_identity,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS missing_identity_pct
FROM carrier_risk_summary
WHERE missing_identity_flag = 1;


-- 4. How many carriers have authority issues?
SELECT
    COUNT(*) AS carriers_with_authority_issues,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS authority_issue_pct
FROM carrier_risk_summary
WHERE authority_issue_flag = 1;


-- 5. How many carriers have inspection activity?
SELECT
    COUNT(*) AS carriers_with_inspections,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS carriers_with_inspections_pct
FROM carrier_risk_summary
WHERE inspection_count > 0;


-- 6. How many carriers have crash history?
SELECT
    COUNT(*) AS carriers_with_crashes,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS carriers_with_crashes_pct
FROM carrier_risk_summary
WHERE crash_count > 0;


-- 7. What is the overall violation rate and OOS rate?
SELECT
    SUM(inspection_count) AS total_inspections,
    SUM(total_violations) AS total_violations,
    SUM(total_oos) AS total_oos,
    ROUND(SUM(total_violations) / NULLIF(SUM(inspection_count), 0), 2) AS violation_rate,
    ROUND(SUM(total_oos) / NULLIF(SUM(inspection_count), 0), 4) AS oos_rate
FROM carrier_risk_summary;


-- 8. How many carriers are flagged high OOS or high violation?
SELECT
    SUM(CASE WHEN high_oos_flag = 1 THEN 1 ELSE 0 END) AS high_oos_carriers,
    SUM(CASE WHEN high_violation_flag = 1 THEN 1 ELSE 0 END) AS high_violation_carriers,
    SUM(CASE WHEN high_oos_flag = 1 OR high_violation_flag = 1 THEN 1 ELSE 0 END) AS carriers_with_any_inspection_risk_flag
FROM carrier_risk_summary;


-- 9. How many carriers are high-risk by risk_score?
SELECT
    COUNT(*) AS high_risk_carriers,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM carrier_risk_summary), 2) AS high_risk_carrier_pct
FROM carrier_risk_summary
WHERE risk_score >= 3;


-- 10. Which states have the most high-risk carriers?
SELECT
    phy_state,
    COUNT(*) AS high_risk_carrier_count
FROM carrier_risk_summary
WHERE risk_score >= 3
  AND phy_state IS NOT NULL
GROUP BY phy_state
ORDER BY high_risk_carrier_count DESC
LIMIT 20;


-- 11. Which carrier operation types have the highest average risk?
SELECT
    carrier_operation,
    COUNT(*) AS carrier_count,
    ROUND(AVG(risk_score), 2) AS avg_risk_score,
    ROUND(AVG(inspection_count), 2) AS avg_inspection_count,
    ROUND(AVG(crash_count), 2) AS avg_crash_count
FROM carrier_risk_summary
WHERE carrier_operation IS NOT NULL
GROUP BY carrier_operation
ORDER BY avg_risk_score DESC, carrier_count DESC;


-- 12. Which carriers should be prioritized for manual review?
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
    missing_identity_flag,
    inactive_or_nonactive_status_flag,
    authority_issue_flag,
    high_oos_flag,
    high_violation_flag,
    crash_history_flag,
    hazmat_flag,
    risk_score
FROM carrier_risk_summary
WHERE risk_score >= 3
ORDER BY risk_score DESC, fatal_crash_count DESC, crash_count DESC, total_oos DESC
LIMIT 100;
