import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import json

import streamlit as st

from research_exporter import BASE_DIR, RESEARCH_DIR
from research_ingestor import (
    IDEA_STATUSES,
    SOURCE_TYPES,
    ensure_research_ingestion_structure,
    ingest_file,
    ingest_inbox,
    list_research_ideas,
    save_raw_research,
    update_idea_status,
)

st.set_page_config(page_title="Research Ideas - QTrade OS", page_icon=":material/science:", layout="wide")
st.title("Research Ideas")
st.caption("Capture trading knowledge as testable ideas. Research never becomes a live rule automatically.")

ensure_research_ingestion_structure()

ideas = list_research_ideas()
status_counts = ideas["status"].value_counts().to_dict() if not ideas.empty else {}

c1, c2, c3, c4 = st.columns(4)
c1.metric("Ideas", f"{len(ideas):,}" if not ideas.empty else "0")
c2.metric("Untested", status_counts.get("untested", 0))
c3.metric("Testing", status_counts.get("testing", 0))
c4.metric("Validated", status_counts.get("validated", 0))

st.divider()

tab_add, tab_ingest, tab_manage, tab_workflow = st.tabs([
    "Add Raw Research",
    "Ingest Inbox",
    "Manage Ideas",
    "Workflow",
])

with tab_add:
    st.subheader("Save Raw Research To Inbox")
    with st.form("raw_research_form"):
        title = st.text_input("Title", placeholder="YouTube - London session breakout filter")
        source_type = st.selectbox("Source type", SOURCE_TYPES, index=SOURCE_TYPES.index("manual"))
        source_url = st.text_input("Source URL", placeholder="https://...")
        idea_status = st.selectbox("Idea status", IDEA_STATUSES, index=0)
        body = st.text_area(
            "Raw notes / transcript / article summary / PDF summary / EA document notes",
            height=260,
            placeholder=(
                "Paste research here. Include any concept, rules, market condition, "
                "entry, exit, risk, strengths, weaknesses, and hypothesis if available."
            ),
        )
        save_and_ingest = st.checkbox("Ingest immediately after saving", value=True)
        submitted = st.form_submit_button("Save Research", type="primary", use_container_width=True)

    if submitted:
        if not title.strip() or not body.strip():
            st.error("Title and raw notes are required.")
        else:
            raw_path = save_raw_research(
                title=title.strip(),
                body=body.strip(),
                source_type=source_type,
                source_url=source_url.strip(),
                idea_status=idea_status,
            )
            st.success(f"Saved raw research: {raw_path.relative_to(BASE_DIR)}")
            if save_and_ingest:
                result = ingest_file(raw_path, default_status=idea_status, move_raw=False)
                st.json(result.as_dict())

with tab_ingest:
    st.subheader("Inbox Processor")
    st.write(
        "Processes Markdown or text notes in `10_Research/00_Inbox` into structured "
        "research notes and backtest idea notes."
    )
    default_status = st.selectbox("Default status for notes without YAML status", IDEA_STATUSES, index=0)
    move_raw = st.toggle("Move raw files to 00_Inbox/_processed after ingestion", value=False)
    if st.button("Ingest Inbox", type="primary", use_container_width=True):
        with st.spinner("Extracting research fields and test ideas..."):
            results = ingest_inbox(default_status=default_status, move_raw=move_raw)
        st.success(f"Ingested {len(results)} file(s).")
        st.code(json.dumps(results, indent=2, ensure_ascii=False), language="json")

with tab_manage:
    st.subheader("Idea Lifecycle")
    st.write("Allowed statuses: `untested`, `testing`, `validated`, `rejected`.")
    ideas = list_research_ideas()
    if ideas.empty:
        st.info("No structured research ideas yet.")
    else:
        filter_status = st.selectbox("Filter by status", ["All"] + IDEA_STATUSES)
        view = ideas.copy()
        if filter_status != "All":
            view = view[view["status"] == filter_status]
        st.dataframe(view, use_container_width=True, hide_index=True)

        st.divider()
        st.markdown("#### Update Status")
        path = st.selectbox("Idea file", ideas["path"].tolist())
        new_status = st.selectbox("New status", IDEA_STATUSES, index=0)
        if st.button("Update Idea Status", use_container_width=True):
            ok, msg = update_idea_status(path, new_status)
            if ok:
                st.success(msg)
                st.rerun()
            else:
                st.error(msg)

with tab_workflow:
    st.subheader("Practical Workflow")
    st.markdown(
        """
1. Save raw research in `10_Research/00_Inbox`.
2. Convert it into structured notes with this page.
3. Review extracted concept, rules, conditions, entry, exit, risk, strengths, weaknesses, and hypothesis.
4. Open the generated test idea in `10_Research/10_Test_Ideas`.
5. Backtest manually or with your chosen backtest tool.
6. Change status only after evidence:
   - `untested`: captured but not tested
   - `testing`: currently being tested
   - `validated`: passed review and has evidence
   - `rejected`: failed test or not useful

Research notes may link to strategies, sessions, symbols, regimes, and EA performance,
but they do not change live trading behavior.
"""
    )
    st.code(str((RESEARCH_DIR / "00_Inbox").relative_to(BASE_DIR)))
    st.code(str((RESEARCH_DIR / "09_Source_Notes").relative_to(BASE_DIR)))
    st.code(str((RESEARCH_DIR / "10_Test_Ideas").relative_to(BASE_DIR)))
