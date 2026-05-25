# Recommendations

Recommendations will be finalized after analysis.

Expected recommendation themes:

- prioritize manual review for carriers with inactive status and recent OOS events,
- escalate carriers missing critical identity fields,
- monitor carriers with limited operating history and high-risk indicators,
- improve data-quality checks before carrier onboarding or assignment.

Current working recommendations based on the first summary build:

- Do not connect Power BI directly to the raw MySQL tables or raw CSV files.
- Use the Power BI-safe `pbi_*` MySQL views as the reporting layer.
- Prioritize review of carriers with `risk_score >= 3`.
- Separate linked crash analysis from all-crash raw analysis because carrier-level crash metrics depend on available `DOT_NUMBER`.
- Start dashboarding with carrier-level KPIs and exception views before adding deeper segmentation or coded-field analysis.
- Keep each dashboard page tied to one business-focused source:
  - `pbi_carrier_risk_summary`
  - `pbi_identity_authority_exceptions`
  - `pbi_inspection_risk`
  - `pbi_crash_risk`

