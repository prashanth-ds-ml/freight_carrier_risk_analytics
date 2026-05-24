# Insights

Current confirmed findings from the raw SQL inventory step:

- The project data model is clearly a three-table model:
  - `raw_company_census` as the carrier master table
  - `raw_crash` as the crash event table
  - `raw_vehicle_inspection` as the inspection event table
- The census table is substantially wider than the two event tables and will need focused column selection rather than blanket usage.
- The inspection and crash tables contain both business-relevant fields and source-system fields, so later cleaning should separate analytics columns from operational metadata columns.
- `DOT_NUMBER` is confirmed as the central cross-table carrier identifier for the initial analysis design.

Current confirmed findings from the first BI summary build:

- `carrier_risk_summary` has 4,437,569 carrier rows, matching the carrier census base.
- `inspection_summary_by_carrier` covers 660,563 carriers with inspection activity.
- `crash_summary_by_carrier` covers 713,175 carriers with DOT-linked crash activity.
- 2,192,273 carriers currently have `status_code = 'A'`.
- 329,821 carriers currently score `risk_score >= 3` under the first version of the risk logic.

Interpretation:

- the raw source is much larger than the operationally active/risk-observable carrier subset
- inspections and crashes are sparse relative to the full carrier universe, so carrier-level aggregation is the right BI design choice
- the first summary model is already sufficient for dashboarding and first-pass risk prioritization

Current official analysis framework:

- the version 1 project is structured around 15 analysis questions
- those questions are grouped into:
  - census-focused analysis
  - inspection-focused analysis
  - crash-focused analysis
  - integrated carrier-risk analysis
- this ensures all three source files are used properly in the project story instead of relying on a single summary metric alone

Expected insight themes:

- carrier identity completeness,
- inspection and OOS risk concentration,
- crash-history concentration,
- carrier status/authority exception patterns,
- state-level risk distribution,
- data quality issues requiring escalation.

