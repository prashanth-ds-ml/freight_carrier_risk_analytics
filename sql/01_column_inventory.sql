SELECT
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME
FROM information_schema.columns
WHERE TABLE_SCHEMA = 'feright_risk_analysis'
  AND TABLE_NAME IN ('raw_company_census', 'raw_crash', 'raw_vehicle_inspection')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
