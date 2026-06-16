import datetime

log_entry = f"\n\n## {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - Pause Requested\n"
log_entry += "- **Status**: PAUSED BY USER\n"
log_entry += "- **Details**: User requested to pause. The Parallel Supervisor (Task 811) is currently running in the background testing the fixed Universal EA (Deposit=100000, Leverage=100, and log parsing fallback enabled). Will review results when resuming.\n"

with open(".agent_handoff/HANDOFF_LOG.md", "a", encoding="utf-8-sig") as f:
    f.write(log_entry)
