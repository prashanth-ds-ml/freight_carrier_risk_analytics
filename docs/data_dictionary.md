# Data Dictionary

## Carrier Census

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

| Field | Meaning |
|---|---|
| `crash_id` | Crash event identifier |
| `dot_number` | Carrier identifier |
| `report_date` | Crash report date |
| `fatalities` | Fatality count |
| `injuries` | Injury count |
| `tow_away` | Tow-away indicator |
| `federal_recordable` | Federal recordable crash indicator |

