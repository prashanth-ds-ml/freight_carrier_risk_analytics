# Recommendations

Recommendations will be finalized after analysis.

Expected recommendation themes:

- prioritize manual review for carriers with inactive status and recent OOS events,
- escalate carriers missing critical identity fields,
- monitor carriers with limited operating history and high-risk indicators,
- improve data-quality checks before carrier onboarding or assignment.

Current working recommendations based on the first summary build:

- Use `carrier_risk_summary` as the first Power BI source instead of connecting dashboards directly to raw event tables.
- Prioritize review of carriers with `risk_score >= 3`.
- Separate linked crash analysis from all-crash raw analysis because carrier-level crash metrics depend on available `DOT_NUMBER`.
- Start dashboarding with carrier-level KPIs and exception views before adding deeper segmentation or coded-field analysis.
- Use Power BI helper views to simplify dashboard page design and keep field exposure focused by page purpose.

