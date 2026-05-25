# EDA Summary

This project has moved from raw FMCSA table exploration into a curated BI summary-layer design.

## Source Tables Reviewed

| Source | Role in Analysis |
|---|---|
| Company Census | Carrier master / identity / authority / operating attributes |
| Vehicle Inspection File | Inspection events, violations, out-of-service signals |
| Crash File | Crash-history and severity signals |

## Confirmed Data Shape

- `DOT_NUMBER` is the central cross-table carrier identifier.
- The carrier census table is the base carrier universe.
- Inspection and crash files are event-level sources that require carrier-level aggregation before dashboarding.
- Public crash and inspection files exclude driver-level details, so the project appropriately focuses on carrier-level risk monitoring.

## Summary-Layer Findings

| Output | Finding |
|---|---|
| Carrier census base | 4,437,569 carrier rows |
| Inspection summary | 660,563 carriers with inspection activity |
| Crash summary | 713,175 carriers with DOT-linked crash activity |
| Active carriers | 2,192,273 carriers with `status_code = 'A'` |
| High-risk first-pass score | 329,821 carriers with `risk_score >= 3` |

## Modeling Decision

Power BI should use curated `pbi_*` views instead of raw source tables. This keeps the dashboard model smaller, safer, and easier to explain:

- `pbi_carrier_risk_summary`
- `pbi_identity_authority_exceptions`
- `pbi_inspection_risk`
- `pbi_crash_risk`
- `pbi_high_risk_carriers`

## Interpretation

The event data is sparse relative to the full carrier universe, so carrier-level aggregation is the correct grain for executive monitoring. The project should focus on review prioritization, data quality exceptions, and risk segmentation rather than row-level event browsing.
