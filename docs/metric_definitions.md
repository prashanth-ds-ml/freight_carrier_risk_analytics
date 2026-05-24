# Metric Definitions

| Metric | Formula | Business Meaning |
|---|---|---|
| Active Carrier % | Active carriers / total carriers | Share of carriers with active status |
| Missing Identity Field % | Carriers missing key identity fields / total carriers | Data completeness risk |
| Inspection Count | Count of inspection events | Carrier safety review volume |
| Violation Rate | Total violations / total inspections | Frequency of violations |
| OOS Rate | Out-of-service events / total inspections | Share of inspections with OOS outcomes |
| Crash Count | Count of DOT-linked crash records | Historical crash exposure at the carrier level |
| Injury Crash Count | Crashes with injuries > 0 | Higher-severity crash signal |
| Risk Score | Sum of selected risk flags | Composite review prioritization metric |

## Current Summary Model Metrics

The current BI layer is built in MySQL table `carrier_risk_summary` and includes:

- identity flags:
  - `missing_identity_flag`
  - `inactive_or_nonactive_status_flag`
  - `authority_issue_flag`
- inspection metrics:
  - `inspection_count`
  - `total_violations`
  - `total_oos`
  - `driver_oos_total`
  - `vehicle_oos_total`
  - `hazmat_oos_total`
  - `post_accident_inspection_count`
  - `latest_insp_date`
- crash metrics:
  - `crash_count`
  - `injury_crash_count`
  - `fatal_crash_count`
  - `tow_away_count`
  - `federal_recordable_count`
  - `latest_crash_date`
- risk flags:
  - `high_oos_flag`
  - `high_violation_flag`
  - `crash_history_flag`
  - `hazmat_flag`
- summary score:
  - `risk_score`

Current flag logic:

- `missing_identity_flag` = 1 if legal name or physical city/state/zip is missing
- `inactive_or_nonactive_status_flag` = 1 if `status_code` is null or not `A`
- `authority_issue_flag` = 1 if `docket1_status_code` is null or not `A`
- `high_oos_flag` = 1 if `total_oos / inspection_count >= 0.3`
- `high_violation_flag` = 1 if `total_violations / inspection_count >= 2`
- `crash_history_flag` = 1 if `crash_count > 0`
- `hazmat_flag` = 1 if `hm_ind = 'Y'`

