# Data Dictionary

This dictionary reflects the analysis fields planned from the public FMCSA extracts. The public source files were described in the catalog as last updated on May 19, 2026. Crash and inspection public releases exclude driver-level details for privacy reasons.

## Carrier Census

Source notes:

- Includes active, inactive, and pending FMCSA-registered entities
- USDOT number is the core entity identifier
- Covers entity identity, business operations, equipment, driver counts, and carrier review attributes

| Field | Meaning |
|---|---|
| `dot_number` | Carrier identifier |
| `legal_name` | Registered legal carrier name |
| `dba_name` | Doing-business-as name |
| `status_code` | Carrier status indicator |
| `phy_state`, `phy_city`, `phy_zip` | Physical location |
| `add_date` | Carrier add/registration date |
| `carrier_operation` | Carrier operation type |
| `business_org_desc` | Business organization description |
| `power_units`, `truck_units` | Equipment indicators |
| `total_drivers`, `total_cdl` | Driver counts |
| `safety_rating` | Safety rating when available |
| `hm_ind` | Hazardous materials indicator |
| `docket1_status_code` | Docket authority status |

## Vehicle Inspections

Source notes:

- Inspection activity from FMCSA MCMIS public inspection files
- Public file excludes driver information
- Out-of-service metrics are key enforcement outcomes

| Field | Meaning |
|---|---|
| `inspection_id` | Inspection event identifier |
| `dot_number` | Carrier identifier |
| `insp_date` | Inspection date |
| `viol_total` | Total violations |
| `oos_total` | Total out-of-service events |
| `driver_oos_total` | Driver out-of-service events |
| `vehicle_oos_total` | Vehicle out-of-service events |
| `hazmat_oos_total` | Hazmat out-of-service events |

## Crashes

Source notes:

- Public crash data derived from state police reports
- Public file excludes driver information
- One real-world crash may map to multiple file rows if multiple commercial motor vehicles were involved
- `crash_report_number` should be retained when available to group related records correctly

| Field | Meaning |
|---|---|
| `crash_id` | Crash event identifier |
| `dot_number` | Carrier identifier |
| `crash_report_number` | Shared identifier for multiple records tied to the same crash |
| `report_date` | Crash report date |
| `fatalities` | Fatality count |
| `injuries` | Injury count |
| `tow_away` | Tow-away indicator |
| `federal_recordable` | Federal recordable crash indicator |

