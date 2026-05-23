import getpass
import os
import sys
from pathlib import Path

import mysql.connector


MYSQL_HOST = os.getenv("MYSQL_HOST", "127.0.0.1")
MYSQL_PORT = int(os.getenv("MYSQL_PORT", "3306"))
MYSQL_USER = os.getenv("MYSQL_USER", "root")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE", "feright_risk_analysis")


def get_password() -> str:
    if MYSQL_PASSWORD:
        return MYSQL_PASSWORD
    return getpass.getpass("MySQL password for root: ")


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python scripts/run_mysql_script.py <sql_file>")

    sql_path = Path(sys.argv[1]).resolve()
    if not sql_path.exists():
        raise FileNotFoundError(f"SQL file not found: {sql_path}")

    script = sql_path.read_text(encoding="utf-8")
    with mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=get_password(),
        database=MYSQL_DATABASE,
        allow_local_infile=True,
        autocommit=True,
    ) as conn:
        with conn.cursor() as cursor:
            for statement in [part.strip() for part in script.split(";") if part.strip()]:
                cursor.execute(statement)

    print(f"Executed {sql_path} on `{MYSQL_DATABASE}`")


if __name__ == "__main__":
    main()
