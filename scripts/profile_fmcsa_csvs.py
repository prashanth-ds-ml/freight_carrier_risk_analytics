import csv
import json
from collections import Counter
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor
from dataclasses import dataclass
from pathlib import Path
import os
from typing import Dict, List, Optional, Tuple


BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data" / "raw"
OUTPUT_DIR = BASE_DIR / "outputs" / "profiling"

FILES = {
    "company_census": DATA_DIR / "Company_Census_File.csv",
    "crash": DATA_DIR / "Crash_File.csv",
    "vehicle_inspection": DATA_DIR / "Vehicle_Inspection_File.csv",
}

KEY_FIELDS = {
    "company_census": ["DOT_NUMBER", "LEGAL_NAME", "STATUS_CODE", "PHY_STATE", "POWER_UNITS", "TOTAL_DRIVERS"],
    "crash": ["CRASH_ID", "REPORT_NUMBER", "DOT_NUMBER", "REPORT_DATE", "STATE", "FATALITIES", "INJURIES"],
    "vehicle_inspection": ["INSPECTION_ID", "DOT_NUMBER", "INSP_DATE", "REPORT_STATE", "VIOL_TOTAL", "OOS_TOTAL"],
}

SAMPLE_VALUES = 5


def is_blank(value: Optional[str]) -> bool:
    return value is None or value.strip() == ""


def detect_type(value: str) -> str:
    text = value.strip()
    if text == "":
        return "blank"

    digits = text.replace("-", "").replace(".", "")
    if digits.isdigit():
        if "." in text:
            return "float"
        return "int"

    compact = text.replace(" ", "")
    if len(compact) == 8 and compact.isdigit():
        return "date_yyyymmdd"
    if len(compact) == 12 and compact.isdigit():
        return "datetime_yyyymmdd_hhmm"

    upper = text.upper()
    if upper in {"Y", "N", "T", "F"}:
        return "flag"

    return "string"


@dataclass
class ColumnProfile:
    non_null: int = 0
    blank: int = 0
    max_length: int = 0
    type_counter: Counter = None
    samples: List[str] = None

    def __post_init__(self) -> None:
        if self.type_counter is None:
            self.type_counter = Counter()
        if self.samples is None:
            self.samples = []

    def update(self, value: str) -> None:
        if is_blank(value):
            self.blank += 1
            return

        cleaned = value.strip()
        self.non_null += 1
        self.max_length = max(self.max_length, len(cleaned))
        self.type_counter[detect_type(cleaned)] += 1
        if len(self.samples) < SAMPLE_VALUES and cleaned not in self.samples:
            self.samples.append(cleaned)

    def to_dict(self, row_count: int) -> Dict[str, object]:
        dominant_type = None
        if self.type_counter:
            dominant_type = self.type_counter.most_common(1)[0][0]
        return {
            "non_null_count": self.non_null,
            "blank_count": self.blank,
            "null_pct": round((self.blank / row_count) * 100, 2) if row_count else 0.0,
            "dominant_type": dominant_type,
            "type_counts": dict(self.type_counter),
            "max_length": self.max_length,
            "sample_values": self.samples,
        }


def profile_csv(path: Path, dataset_name: str) -> Dict[str, object]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames or []
        profiles = {field: ColumnProfile() for field in fieldnames}
        row_count = 0
        dot_missing = 0
        dot_samples = []
        unique_dot_numbers = set()
        duplicate_primary = 0
        primary_key_seen = set()

        primary_key = "DOT_NUMBER" if dataset_name == "company_census" else (
            "CRASH_ID" if dataset_name == "crash" else "INSPECTION_ID"
        )

        for row in reader:
            row_count += 1
            for field in fieldnames:
                profiles[field].update(row.get(field, ""))

            dot = (row.get("DOT_NUMBER") or "").strip()
            if is_blank(dot):
                dot_missing += 1
            else:
                unique_dot_numbers.add(dot)
                if len(dot_samples) < SAMPLE_VALUES and dot not in dot_samples:
                    dot_samples.append(dot)

            key_value = (row.get(primary_key) or "").strip()
            if not is_blank(key_value):
                if key_value in primary_key_seen:
                    duplicate_primary += 1
                else:
                    primary_key_seen.add(key_value)

    key_field_summary = {}
    for field in KEY_FIELDS[dataset_name]:
        if field in profiles:
            key_field_summary[field] = profiles[field].to_dict(row_count)

    return {
        "file": str(path),
        "size_mb": round(path.stat().st_size / (1024 * 1024), 2),
        "rows": row_count,
        "columns": len(fieldnames),
        "fieldnames": fieldnames,
        "primary_key": primary_key,
        "duplicate_primary_key_rows": duplicate_primary,
        "dot_number_missing_count": dot_missing,
        "dot_number_missing_pct": round((dot_missing / row_count) * 100, 4) if row_count else 0.0,
        "unique_dot_number_count": len(unique_dot_numbers),
        "dot_number_samples": dot_samples,
        "selected_column_profiles": key_field_summary,
    }


def profile_one(args: Tuple[str, Path]) -> Tuple[str, Dict[str, object]]:
    dataset_name, path = args
    return dataset_name, profile_csv(path, dataset_name)


def write_markdown_report(results: Dict[str, Dict[str, object]]) -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    report_path = OUTPUT_DIR / "fmcsa_profile_summary.md"

    lines: List[str] = []
    lines.append("# FMCSA Raw Data Profile")
    lines.append("")
    lines.append("Generated by `scripts/profile_fmcsa_csvs.py` from local CSV files in `data/raw`.")
    lines.append("")

    for name, result in results.items():
        lines.append(f"## {name.replace('_', ' ').title()}")
        lines.append("")
        lines.append(f"- File: `{result['file']}`")
        lines.append(f"- Size (MB): `{result['size_mb']}`")
        lines.append(f"- Rows: `{result['rows']}`")
        lines.append(f"- Columns: `{result['columns']}`")
        lines.append(f"- Primary key checked: `{result['primary_key']}`")
        lines.append(f"- Duplicate primary-key rows: `{result['duplicate_primary_key_rows']}`")
        lines.append(
            f"- Missing `DOT_NUMBER`: `{result['dot_number_missing_count']}` "
            f"({result['dot_number_missing_pct']}%)"
        )
        lines.append(f"- Unique `DOT_NUMBER` count: `{result['unique_dot_number_count']}`")
        lines.append("")
        lines.append("### Selected Columns")
        lines.append("")
        lines.append("| Column | Non-null | Null % | Dominant Type | Max Length | Sample Values |")
        lines.append("|---|---:|---:|---|---:|---|")
        for column, profile in result["selected_column_profiles"].items():
            sample_values = ", ".join(profile["sample_values"])
            lines.append(
                f"| `{column}` | {profile['non_null_count']} | {profile['null_pct']} | "
                f"{profile['dominant_type']} | {profile['max_length']} | {sample_values} |"
            )
        lines.append("")
        lines.append("### First Columns")
        lines.append("")
        lines.append(", ".join(f"`{field}`" for field in result["fieldnames"][:20]))
        lines.append("")

    report_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    missing = [str(path) for path in FILES.values() if not path.exists()]
    if missing:
        raise FileNotFoundError(f"Missing required files: {missing}")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    max_workers = min(len(FILES), os.cpu_count() or 1)
    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        profiled = executor.map(profile_one, FILES.items())
        results = dict(profiled)

    json_path = OUTPUT_DIR / "fmcsa_profile_summary.json"
    with ThreadPoolExecutor(max_workers=2) as executor:
        json_future = executor.submit(
            json_path.write_text,
            json.dumps(results, indent=2),
            encoding="utf-8",
        )
        md_future = executor.submit(write_markdown_report, results)
        json_future.result()
        md_future.result()

    print("Wrote:")
    print(json_path)
    print(OUTPUT_DIR / "fmcsa_profile_summary.md")


if __name__ == "__main__":
    main()
