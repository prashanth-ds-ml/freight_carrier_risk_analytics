# Weekly Review - Carrier Risk Monitoring

## What Changed

- Confirmed the three-source carrier risk model: census, inspections, and crashes.
- Validated that DOT number is the common carrier identifier for first-pass joins.
- Built the project narrative around curated `pbi_*` reporting views instead of raw files.

## Top Observations

| Observation | Evidence | Implication |
|---|---|---|
| Event coverage is sparse | 660,563 carriers with inspection activity vs 4,437,569 carrier census rows | Dashboard should aggregate to carrier level |
| Crash linkage is limited to DOT-linked records | 713,175 carriers with DOT-linked crash activity | Crash KPIs should distinguish linked vs raw crash universe |
| High-risk review pool is material | 329,821 carriers with `risk_score >= 3` | Risk tiers are needed for prioritization |
| Active carrier base is large | 2,192,273 active carriers | Exception reporting should focus analyst attention |

## Recommended Actions

- Use curated Power BI views as the dashboard layer.
- Prioritize carriers with high risk score and active operating status.
- Keep identity/authority exceptions separate from inspection/crash risk to avoid mixing data quality and safety signals.
- Use weekly exception exports for follow-up review.
