import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import json
from pathlib import Path

import streamlit as st

from utils import load_trades, sidebar_filters, require_data
from research_exporter import BASE_DIR, RESEARCH_DIR, ensure_vault_structure, export_all, scan_research_notes

st.set_page_config(page_title="Research Intelligence - QTrade OS", page_icon=":material/psychology:", layout="wide")
st.title("Research Intelligence")
st.caption("Turn analytics, trades, and NotebookLM summaries into durable Obsidian trading intelligence.")

df_all = load_trades()
df = sidebar_filters(df_all)

if not require_data(df, min_rows=1):
    st.stop()

ensure_vault_structure(write_templates=True)
notes = scan_research_notes()

c1, c2, c3, c4 = st.columns(4)
c1.metric("Trades in scope", f"{len(df):,}")
c2.metric("Research notes scanned", f"{len(notes):,}")
c3.metric("Strategies", f"{df['strategy'].nunique() if 'strategy' in df else 0:,}")
c4.metric("Generated vault", str(RESEARCH_DIR.relative_to(BASE_DIR)))

st.divider()

left, right = st.columns([2, 1], gap="large")

with left:
    st.subheader("Export Pipeline")
    st.write(
        "Rebuilds strategy pages, session pages, symbol pages, regime pages, "
        "mistake library notes, trade links, analytics insight, AI review packet, "
        "and the research index."
    )

    trade_limit = st.number_input("Trade-link export limit", min_value=10, max_value=1000, value=100, step=10)
    annotated_only = st.toggle("Export annotated trades only", value=True)
    overwrite = st.toggle("Overwrite generated notes", value=True)

    if st.button("Rebuild Research Intelligence", type="primary", use_container_width=True):
        with st.spinner("Writing Obsidian intelligence notes..."):
            result = export_all(
                df=df,
                overwrite=overwrite,
                trade_limit=int(trade_limit),
                annotated_trades_only=annotated_only,
            )
        st.success("Research intelligence export complete.")
        st.json(result["summary"])
        with st.expander("Export details"):
            st.code(json.dumps(result, indent=2), language="json")

with right:
    st.subheader("Open In Obsidian")
    links = [
        ("Research index", RESEARCH_DIR / "_Indexes" / "Research_Intelligence_Index.md"),
        ("Strategy library", RESEARCH_DIR / "01_Strategies"),
        ("Mistake library", RESEARCH_DIR / "07_Mistake_Library"),
        ("Regime library", RESEARCH_DIR / "04_Regimes"),
        ("AI exports", RESEARCH_DIR / "08_AI_Exports"),
        ("Inbox", RESEARCH_DIR / "00_Inbox"),
    ]
    for label, path in links:
        rel = path.relative_to(BASE_DIR)
        st.code(str(rel))

st.divider()

st.subheader("Markdown Ingestion Contract")
st.markdown(
    """
Place NotebookLM or manual research notes in `10_Research/00_Inbox` with YAML frontmatter.
The exporter scans markdown text and frontmatter fields, then links notes to strategies,
symbols, sessions, regimes, mistakes, analytics insights, and trade notes.

Required practical fields:

```yaml
---
type: research_note
status: inbox
source: NotebookLM
strategies: [QField]
symbols: [XAUUSD]
sessions: [London_NY]
regimes: [TRENDING]
mistakes: [late_entry]
tags: [research, trading-intelligence]
---
```
"""
)

if not notes.empty:
    preview = notes[["name", "folder", "type", "status"]].head(50).copy()
    st.dataframe(preview, use_container_width=True, hide_index=True)
