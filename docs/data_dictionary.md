# Data Dictionary

This dictionary reflects the analysis fields planned from the public FMCSA extracts and the raw MySQL imports currently loaded for analysis. The public source files were described in the catalog as last updated on May 19, 2026. Crash and inspection public releases exclude driver-level details for privacy reasons.

## Current Raw Table Understanding

The imported raw tables currently support a three-table model:

- `raw_company_census`: carrier master table with 147 columns
- `raw_crash`: crash event table with 59 columns
- `raw_vehicle_inspection`: inspection event table with 63 columns

Current interpretation:

- `raw_company_census` defines who the carrier is
- `raw_vehicle_inspection` describes inspection outcomes and operational enforcement risk
- `raw_crash` describes crash history and crash severity exposure

Current analysis implication:

- `DOT_NUMBER` is the central carrier join key across the three raw tables
- the census table is wide and should be narrowed to a business-relevant subset before deeper modeling
- the inspection and crash tables should be treated as event-level fact tables, not master records

## Carrier Census

Source notes:

- Includes active, inactive, and pending FMCSA-registered entities
- USDOT number is the core entity identifier
- Covers entity identity, business operations, equipment, driver counts, and carrier review attributes

Current observed column families:

- identity and status: `DOT_NUMBER`, `LEGAL_NAME`, `DBA_NAME`, `STATUS_CODE`
- geography: `PHY_STREET`, `PHY_CITY`, `PHY_STATE`, `PHY_ZIP`
- business and authority: `CARRIER_OPERATION`, `BUSINESS_ORG_DESC`, `DOCKET*`, `DOCKET*_STATUS_CODE`
- fleet and drivers: `TRUCK_UNITS`, `POWER_UNITS`, `TOTAL_DRIVERS`, `TOTAL_CDL`
- cargo profile: `CRGO_*`
- equipment ownership and leasing: `OWN*`, `TRM*`, `TRP*`

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

Current observed column families:

- event identity: `INSPECTION_ID`
- carrier join key: `DOT_NUMBER`
- date and place: `INSP_DATE`, `REPORT_STATE`, `LOCATION`, `LOCATION_DESC`
- inspection context: `INSP_LEVEL_ID`, `REGION`, `POST_ACC_IND`
- outcome metrics: `VIOL_TOTAL`, `OOS_TOTAL`, `DRIVER_OOS_TOTAL`, `VEHICLE_OOS_TOTAL`, `HAZMAT_OOS_TOTAL`
- source/system fields: `SNET_*`, `UPLOAD_*`, `TRANSACTION_*`

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

Current observed column families:

- event identity: `CRASH_ID`, `REPORT_NUMBER`, `REPORT_SEQ_NO`
- carrier join key: `DOT_NUMBER`
- date and place: `REPORT_DATE`, `REPORT_TIME`, `CITY`, `STATE`, `LOCATION`
- severity: `FATALITIES`, `INJURIES`, `TOW_AWAY`, `FEDERAL_RECORDABLE`, `STATE_RECORDABLE`
- vehicle/environment context: `WEATHER_CONDITION_ID`, `LIGHT_CONDITION_ID`, `VEHICLE_CONFIGURATION_ID`
- carrier snapshot in crash record: `CRASH_CARRIER_NAME`, `CRASH_CARRIER_STATE`, `DOCKET_NUMBER`

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

