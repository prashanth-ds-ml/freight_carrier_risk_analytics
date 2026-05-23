import csv
import getpass
import os
from pathlib import Path
from typing import Iterable, List, Sequence

import mysql.connector


BASE_DIR = Path(__file__).resolve().parents[1]
RAW_DIR = BASE_DIR / "data" / "raw"
BATCH_SIZE = 5000

FILES = {
    "raw_company_census": RAW_DIR / "Company_Census_File.csv",
    "raw_crash": RAW_DIR / "Crash_File.csv",
    "raw_vehicle_inspection": RAW_DIR / "Vehicle_Inspection_File.csv",
}


def quote_identifier(name: str) -> str:
    return "`" + name.replace("`", "``") + "`"


def normalize_headers(headers: Sequence[str]) -> List[str]:
    cleaned = []
    seen = {}
    for header in headers:
        name = header.strip()
        if not name:
            raise ValueError("Encountered empty header name")
        count = seen.get(name, 0)
        if count:
            name = f"{name}_{count + 1}"
        seen[header.strip()] = count + 1
        cleaned.append(name)
    return cleaned


def get_mysql_host() -> str:
    return os.getenv("MYSQL_HOST", "127.0.0.1")


def get_mysql_port() -> int:
    return int(os.getenv("MYSQL_PORT", "3306"))


def get_mysql_user() -> str:
    return os.getenv("MYSQL_USER", "root")


def get_mysql_database() -> str:
    return os.getenv("MYSQL_DATABASE", "feright_risk_analysis")


def get_password() -> str:
    env_password = os.getenv("MYSQL_PASSWORD")
    if env_password:
        return env_password
    return getpass.getpass(f"MySQL password for {get_mysql_user()}: ")


def get_database_connection(password: str):
    return mysql.connector.connect(
        host=get_mysql_host(),
        port=get_mysql_port(),
        user=get_mysql_user(),
        password=password,
        database=get_mysql_database(),
        allow_local_infile=True,
        autocommit=True,
    )


def ensure_database(cursor) -> None:
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {quote_identifier(get_mysql_database())}")


def create_table(cursor, table_name: str, headers: Sequence[str]) -> None:
    column_defs = ",\n    ".join(f"{quote_identifier(col)} TEXT NULL" for col in headers)
    ddl = (
        f"DROP TABLE IF EXISTS {quote_identifier(table_name)};\n"
        f"CREATE TABLE {quote_identifier(table_name)} (\n"
        f"    {column_defs}\n"
        f") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
    )
    for statement in ddl.split(";\n"):
        statement = statement.strip()
        if statement:
            cursor.execute(statement)


def chunked(rows: Iterable[List[str]], size: int) -> Iterable[List[List[str]]]:
    batch: List[List[str]] = []
    for row in rows:
        batch.append(row)
        if len(batch) >= size:
            yield batch
            batch = []
    if batch:
        yield batch


def load_csv(cursor, table_name: str, csv_path: Path, headers: Sequence[str]) -> None:
    path_text = str(csv_path.resolve()).replace("\\", "\\\\")
    columns = ", ".join(quote_identifier(col) for col in headers)
    sql = f"""
        LOAD DATA LOCAL INFILE '{path_text}'
        INTO TABLE {quote_identifier(table_name)}
        CHARACTER SET utf8mb4
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\\n'
        IGNORE 1 LINES
        ({columns})
    """
    cursor.execute(sql)


def insert_csv_in_batches(cursor, table_name: str, csv_path: Path, headers: Sequence[str]) -> None:
    columns = ", ".join(quote_identifier(col) for col in headers)
    placeholders = ", ".join(["%s"] * len(headers))
    sql = (
        f"INSERT INTO {quote_identifier(table_name)} ({columns}) "
        f"VALUES ({placeholders})"
    )

    inserted = 0
    with csv_path.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f)
        next(reader)
        for batch in chunked(reader, BATCH_SIZE):
            cursor.executemany(sql, batch)
            inserted += len(batch)
            if inserted % 100000 == 0:
                print(f"{table_name}: inserted {inserted:,} rows")

    print(f"{table_name}: completed {inserted:,} rows using batch inserts")


def create_indexes(cursor) -> None:
    statements = [
        "CREATE INDEX idx_company_census_dot ON raw_company_census (DOT_NUMBER(32))",
        "CREATE INDEX idx_crash_dot ON raw_crash (DOT_NUMBER(32))",
        "CREATE INDEX idx_crash_id ON raw_crash (CRASH_ID(32))",
        "CREATE INDEX idx_vehicle_insp_dot ON raw_vehicle_inspection (DOT_NUMBER(32))",
        "CREATE INDEX idx_vehicle_insp_id ON raw_vehicle_inspection (INSPECTION_ID(32))",
    ]
    for statement in statements:
        cursor.execute(statement)


def read_headers(csv_path: Path) -> List[str]:
    with csv_path.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f)
        return normalize_headers(next(reader))


def main() -> None:
    missing = [str(path) for path in FILES.values() if not path.exists()]
    if missing:
        raise FileNotFoundError(f"Missing required files: {missing}")

    password = get_password()
    with mysql.connector.connect(
        host=get_mysql_host(),
        port=get_mysql_port(),
        user=get_mysql_user(),
        password=password,
        allow_local_infile=True,
        autocommit=True,
    ) as server_conn:
        with server_conn.cursor() as cursor:
            ensure_database(cursor)

    with get_database_connection(password) as conn:
        with conn.cursor() as cursor:
            for table_name, csv_path in FILES.items():
                headers = read_headers(csv_path)
                print(f"Preparing {table_name} from {csv_path.name}")
                create_table(cursor, table_name, headers)
                print(f"Loading {csv_path.name} into {table_name}")
                try:
                    load_csv(cursor, table_name, csv_path, headers)
                    print(f"{table_name}: loaded with LOAD DATA LOCAL INFILE")
                except mysql.connector.Error as err:
                    if getattr(err, "errno", None) == 3948:
                        print(
                            f"{table_name}: LOAD DATA LOCAL INFILE is disabled; "
                            "falling back to batch inserts"
                        )
                        insert_csv_in_batches(cursor, table_name, csv_path, headers)
                    else:
                        raise

            print("Creating indexes")
            create_indexes(cursor)

    print(
        f"Imported files into MySQL database `{get_mysql_database()}` on "
        f"{get_mysql_host()}:{get_mysql_port()}"
    )


if __name__ == "__main__":
    main()
