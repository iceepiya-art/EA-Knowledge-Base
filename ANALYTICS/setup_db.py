"""
setup_db.py — Initialize SQLite database using Python built-in sqlite3.
No external tools required. Safe to re-run on existing database.

Run:
  py -3.14 ANALYTICS/setup_db.py
"""

import sqlite3
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DB_PATH  = BASE_DIR / "DATA" / "processed" / "trades.sqlite"
SQL_PATH = BASE_DIR / "SYSTEM" / "config" / "schema.sql"

def init_database():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)

    if not SQL_PATH.exists():
        print(f"ERROR: Schema file not found: {SQL_PATH}")
        sys.exit(1)

    sql = SQL_PATH.read_text(encoding="utf-8")

    # sqlite3 executescript doesn't support GENERATED ALWAYS columns in older SQLite
    # Split and run statements individually, skipping unsupported ones
    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()

    # Check SQLite version for generated column support (requires 3.31+)
    ver = tuple(int(x) for x in sqlite3.sqlite_version.split("."))
    if ver < (3, 31, 0):
        print(f"SQLite {sqlite3.sqlite_version} — removing GENERATED ALWAYS columns for compatibility")
        sql = _strip_generated_columns(sql)

    try:
        con.executescript(sql)
        con.commit()
        print(f"Database initialized: {DB_PATH}")
        print(f"SQLite version: {sqlite3.sqlite_version}")

        # Verify tables created
        cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
        tables = [r[0] for r in cur.fetchall()]
        print(f"Tables: {', '.join(tables)}")

    except sqlite3.Error as e:
        print(f"ERROR initializing database: {e}")
        sys.exit(1)
    finally:
        con.close()


def _strip_generated_columns(sql: str) -> str:
    """Remove GENERATED ALWAYS AS columns for older SQLite compatibility."""
    lines = []
    for line in sql.splitlines():
        if "GENERATED ALWAYS AS" in line or "GENERATED ALWAYS" in line:
            # Convert to regular nullable column by keeping only the name and type
            parts = line.strip().split()
            if len(parts) >= 2:
                lines.append(f"    {parts[0]}    {parts[1]},")
        else:
            lines.append(line)
    return "\n".join(lines)


def run_migrations():
    """Apply incremental migrations in order. Safe to re-run."""
    migrations = sorted(
        (BASE_DIR / "DATA" / "migrations").glob("0*.sql")
    )
    con = sqlite3.connect(DB_PATH)
    for mig in migrations:
        print(f"Applying migration: {mig.name}")
        try:
            con.executescript(mig.read_text(encoding="utf-8"))
            con.commit()
        except sqlite3.Error as e:
            print(f"  WARN: {e}")
    con.close()
    print("Migrations complete.")


if __name__ == "__main__":
    init_database()
    run_migrations()
