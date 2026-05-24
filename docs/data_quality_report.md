# Data Quality Report

Current status:

- Raw data has been imported into MySQL
- Column inventory has been completed as the first SQL-first analysis step
- Confirmed raw table widths:
  - `raw_company_census`: 147 columns
  - `raw_crash`: 59 columns
  - `raw_vehicle_inspection`: 63 columns

Why this first step matters:

- it confirms the imported schema before null checks or cleaning
- it tells us which columns really exist in MySQL
- it gives us the exact field names needed for later quality checks

Planned checks:

| Check | Purpose |
|---|---|
| Missing DOT numbers | Validate carrier join keys |
| Duplicate DOT numbers in census extract | Identify duplicate carrier master records |
| Missing legal names | Identity completeness check |
| Missing physical state/city/zip | Location completeness check |
| Invalid or future dates | Date quality validation |
| Inspection records without matching carrier | Join quality check |
| Crash records without matching carrier | Join quality check |
| Null violation/OOS fields | KPI reliability check |

Immediate next SQL checks:

- null and blank analysis for core business columns
- null and blank analysis for all columns where useful
- validation of key fields such as `DOT_NUMBER`, `CRASH_ID`, and `INSPECTION_ID`
- identification of sparse column groups in the census table

Current working note:

- broad cleaning has intentionally not started yet because the team chose to understand the raw schema first and reason about column relevance before transforming the data.

