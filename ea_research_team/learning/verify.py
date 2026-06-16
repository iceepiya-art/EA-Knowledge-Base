"""Run: python verify.py — quick smoke test for all key routes."""
import sys
import os
os.environ.setdefault("PYTHONIOENCODING", "utf-8")
sys.path.insert(0, os.path.dirname(__file__))
import review_app

c = review_app.app.test_client()
checks = [
    ("/",                 200, "Learning Review"),
    ("/hub",              200, "EA Decision Board"),
    ("/ea/hedgegrid",     200, "HedgeGrid"),
    ("/ea/smc_universal", 200, "SMC"),
    ("/ea/gold_breakout", 200, "Gold Breakout"),
]
ok = True
for path, code, text in checks:
    r = c.get(path)
    body = r.get_data(as_text=True)
    status = "OK  " if r.status_code == code and text in body else "FAIL"
    print(f"  {status}  {path}")
    if status.strip() == "FAIL":
        ok = False
        print(f"       status={r.status_code}, text_found={text in body}")
print()
print("ALL GOOD" if ok else "FAILURES FOUND")
sys.exit(0 if ok else 1)
