"""
17_Research_Inbox.py — NotebookLM & Research Link Ingestion

Paste a NotebookLM share link and your research summary.
QTrade OS auto-classifies, generates hypothesis draft, action items,
test checklist, and saves an organized Obsidian note.

Workflow: inbox → processing → library | archived
"""

import sys, os, json
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from notebooklm_ingestor import (
    run_migration, ensure_inbox_folder,
    CATEGORIES, CATEGORY_LABELS, CATEGORY_COLORS,
    SOURCE_TYPES, SOURCE_ICONS, STATUSES, STATUS_COLORS,
    auto_classify, generate_tags,
    extract_key_insights, extract_action_items,
    generate_hypothesis_draft, generate_test_checklist,
    ingest_research, get_inbox_items, get_item, update_item_status,
    convert_to_hypothesis, link_to_strategy,
    add_action, get_actions, get_all_actions, complete_action, reopen_action,
    inbox_summary,
)

st.set_page_config(
    page_title="Research Inbox — QTrade OS",
    page_icon="📥",
    layout="wide",
)

run_migration()
ensure_inbox_folder()

# ── Header ────────────────────────────────────────────────────────────────────
st.title("📥 Research Inbox")
st.caption(
    "Paste NotebookLM share links + your research summaries. "
    "QTrade OS organizes, classifies, and generates hypothesis drafts automatically."
)

summary_data = inbox_summary()
by_status    = summary_data.get("by_status", {})

h1, h2, h3, h4, h5, h6 = st.columns(6)
h1.metric("📬 Inbox",      by_status.get("inbox",      0))
h2.metric("⚙️ Processing", by_status.get("processing", 0))
h3.metric("📚 Library",    by_status.get("library",    0))
h4.metric("🗄 Archived",   by_status.get("archived",   0))
h5.metric("📋 Pending Actions", summary_data.get("pending_actions", 0))
total = sum(by_status.values())
h6.metric("Total Items", total)

st.divider()

tab_new, tab_inbox, tab_processing, tab_actions = st.tabs([
    "➕ New Ingest", "📬 Inbox", "⚙️ Processing", "📋 Actions",
])


# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — NEW INGEST
# ══════════════════════════════════════════════════════════════════════════════
with tab_new:
    st.subheader("Ingest Research")
    st.caption(
        "NotebookLM has no public API — paste your summary directly from the notebook. "
        "QTrade OS will auto-classify and generate structured notes."
    )

    # Source type selector
    src_icons_row = "  ".join(f"{v} {k.upper()}" for k, v in SOURCE_ICONS.items())
    st.caption(src_icons_row)

    col_form, col_preview = st.columns([3, 2])

    with col_form:
        with st.form("ingest_form", clear_on_submit=False):
            st.markdown("#### Source")
            fi1, fi2 = st.columns([1, 2])
            f_src_type = fi1.selectbox(
                "Source type",
                SOURCE_TYPES,
                format_func=lambda x: f"{SOURCE_ICONS.get(x,'🔗')} {x.capitalize()}",
            )
            f_url = fi2.text_input(
                "Share URL",
                placeholder="https://notebooklm.google.com/notebook/...",
            )

            st.markdown("#### Content")
            f_title = st.text_input(
                "Title *",
                placeholder="London session momentum trading with QField — NotebookLM analysis",
            )
            f_summary = st.text_area(
                "Summary / Key findings *",
                height=160,
                placeholder=(
                    "Paste your NotebookLM summary here.\n"
                    "Include: key insights, statistics, and what was concluded.\n"
                    "Example: 'The notebook analyzed 6 months of London session trades. "
                    "Win rate was 62% vs 51% outside London. QField performs better "
                    "in TRENDING regime with RSI divergence confirmation...'"
                ),
            )
            f_notes = st.text_area(
                "Raw notes (optional)",
                height=80,
                placeholder="Additional quotes, page refs, or your own notes…",
            )

            st.markdown("#### Classification")
            cat_options = ["Auto-detect"] + CATEGORIES
            fc1, fc2 = st.columns(2)
            f_cat = fc1.selectbox(
                "Category",
                cat_options,
                format_func=lambda x: CATEGORY_LABELS.get(x, x.capitalize())
                            if x != "Auto-detect" else "⚡ Auto-detect",
            )
            f_tags_raw = fc2.text_input(
                "Extra tags (comma-separated)",
                placeholder="qfield, london, sc100",
            )

            submitted = st.form_submit_button(
                "⚡ Ingest Research", type="primary", use_container_width=True,
            )

    with col_preview:
        st.markdown("#### Live Preview")
        st.caption("Fill title + summary to see auto-generated content:")

        # Get current values for preview (outside form — reads last submitted state)
        preview_title   = st.session_state.get("_preview_title",   "")
        preview_summary = st.session_state.get("_preview_summary", "")

        if preview_title or preview_summary:
            cat_preview = auto_classify(preview_title, preview_summary)
            _cc = CATEGORY_COLORS.get(cat_preview, "#546e7a")
            _cl = CATEGORY_LABELS.get(cat_preview, cat_preview)
            st.markdown(
                f"**Detected category:** "
                f"<span style='color:{_cc}'>{_cl}</span>",
                unsafe_allow_html=True,
            )

            draft = generate_hypothesis_draft(preview_title, preview_summary, cat_preview)
            with st.expander("📝 Hypothesis Draft", expanded=True):
                st.markdown(draft)

            actions = extract_action_items(preview_summary)
            if actions:
                with st.expander("✅ Action Items", expanded=False):
                    for a in actions:
                        st.markdown(f"- [ ] {a}")

            checklist = generate_test_checklist(cat_preview)
            with st.expander("📋 Test Checklist", expanded=False):
                for c in checklist[:5]:
                    st.markdown(f"- [ ] {c}")
                if len(checklist) > 5:
                    st.caption(f"+ {len(checklist)-5} more items")
        else:
            st.info("Start filling in the form to see auto-generated content here.")

    # Handle submission
    if submitted:
        # Store preview values in session_state
        st.session_state["_preview_title"]   = f_title
        st.session_state["_preview_summary"] = f_summary

        if not f_title.strip():
            st.error("Title is required.")
        elif not f_summary.strip():
            st.error("Summary is required — paste your NotebookLM findings.")
        else:
            category = None if f_cat == "Auto-detect" else f_cat
            extra_tags = [t.strip() for t in f_tags_raw.split(",") if t.strip()]
            tags = generate_tags(f_title, f_summary, category or auto_classify(f_title, f_summary))
            tags = list(dict.fromkeys(tags + extra_tags))  # deduplicate

            with st.spinner("Generating notes and saving to vault…"):
                ok, item_id, msg = ingest_research(
                    title       = f_title.strip(),
                    source_url  = f_url.strip(),
                    source_type = f_src_type,
                    summary     = f_summary.strip(),
                    raw_notes   = f_notes.strip(),
                    category    = category,
                    tags        = tags,
                )

            if ok:
                item = get_item(item_id)
                cat = item["category"] if item else "uncategorized"
                st.success(f"✅ **{item_id}** ingested — {CATEGORY_LABELS.get(cat, cat)}")

                # Show generated content
                if item:
                    rc1, rc2 = st.columns(2)
                    with rc1:
                        st.markdown("**🧬 Hypothesis Draft**")
                        st.markdown(item.get("hypothesis_draft") or "—")
                    with rc2:
                        st.markdown("**✅ Action Items**")
                        actions_j = item.get("action_items") or "[]"
                        try:
                            actions_list = json.loads(actions_j)
                        except Exception:
                            actions_list = []
                        for a in actions_list:
                            st.markdown(f"- [ ] {a}")

                    if item.get("note_path"):
                        st.caption(f"Note saved: `{item['note_path']}`")

                st.session_state["_preview_title"]   = ""
                st.session_state["_preview_summary"] = ""
            else:
                st.error(f"Ingest failed: {msg}")

    # Preview trigger: update session state on any text change
    # (Streamlit re-runs on every interaction, so these keys always hold latest values)
    # We use a workaround: show preview text fields outside form
    st.divider()
    st.markdown("##### Quick preview (optional — type here to see live classification)")
    pc1, pc2 = st.columns(2)
    preview_t = pc1.text_input("Preview title", key="_preview_title",
                               label_visibility="collapsed",
                               placeholder="Title for preview…")
    preview_s = pc2.text_area("Preview summary", key="_preview_summary",
                              label_visibility="collapsed",
                              placeholder="Paste summary for preview…",
                              height=60)


# ══════════════════════════════════════════════════════════════════════════════
# SHARED ITEM CARD RENDERER
# ══════════════════════════════════════════════════════════════════════════════

def _render_item_card(row, show_convert: bool = False, show_process: bool = False):
    item_id  = row["item_id"]
    status   = row["status"]
    cat      = row["category"]
    src_type = row.get("source_type", "other")
    icon     = SOURCE_ICONS.get(src_type, "🔗")
    cat_col  = CATEGORY_COLORS.get(cat, "#546e7a")
    cat_lbl  = CATEGORY_LABELS.get(cat, cat)

    actions_j  = row.get("action_items") or "[]"
    checklist_j = row.get("test_checklist") or "[]"
    insights_j  = row.get("key_insights") or "[]"
    try:
        actions_list   = json.loads(actions_j)
        checklist_list = json.loads(checklist_j)
        insights_list  = json.loads(insights_j)
    except Exception:
        actions_list = checklist_list = insights_list = []

    with st.expander(
        f"{icon} **{item_id}** — {row['title']}  "
        f"| <span style='color:{cat_col}'>{cat_lbl}</span>",
        expanded=False,
    ):
        ic1, ic2 = st.columns([3, 1])

        with ic1:
            if row.get("source_url"):
                st.markdown(f"🔗 [Open source]({row['source_url']})")
            if row.get("summary"):
                st.markdown(f"**Summary:** {row['summary'][:400]}{'…' if len(row.get('summary','')) > 400 else ''}")
            if insights_list:
                st.markdown("**Key insights:**")
                for ins in insights_list[:3]:
                    st.markdown(f"  - {ins}")

        with ic2:
            tags = [t for t in (row.get("tags") or "").split(",") if t.strip()]
            if tags:
                st.caption("🏷 " + "  ·  ".join(tags[:4]))
            st.caption(f"📅 {str(row.get('created_at',''))[:10]}")
            if row.get("hyp_id"):
                st.caption(f"🧬 Linked: {row['hyp_id']}")
            if row.get("ea_link"):
                st.caption(f"🤖 EA: {row['ea_link']}")

        # Content tabs
        ct1, ct2, ct3, ct4 = st.tabs(["🧬 Hypothesis", "✅ Actions", "📋 Checklist", "⚙️ Manage"])

        with ct1:
            st.markdown(row.get("hypothesis_draft") or "No draft.")

        with ct2:
            db_actions = get_actions(item_id)
            if db_actions.empty:
                for a in actions_list:
                    st.markdown(f"- [ ] {a}")
            else:
                for _, act in db_actions.iterrows():
                    done = bool(act.get("completed"))
                    prefix = "~~" if done else ""
                    suffix = "~~" if done else ""
                    st.markdown(f"- {'✅' if done else '⬜'} {prefix}{act['action_text']}{suffix}")
                    if not done:
                        if st.button("Complete", key=f"done_{act['action_id']}"):
                            complete_action(int(act["action_id"]))
                            st.rerun()

            with st.form(f"add_act_{item_id}"):
                new_act = st.text_input("Add action", placeholder="New action item…")
                act_type = st.selectbox("Type", ["todo","test","hypothesis","note","reference"])
                if st.form_submit_button("Add"):
                    if new_act.strip():
                        add_action(item_id, new_act.strip(), act_type)
                        st.rerun()

        with ct3:
            for c in checklist_list:
                st.markdown(f"- [ ] {c}")

        with ct4:
            # Status transitions
            st.markdown("**Status transitions**")
            m1, m2, m3, m4 = st.columns(4)

            if status == "inbox":
                if m1.button("▶ Process", key=f"proc_{item_id}"):
                    update_item_status(item_id, "processing"); st.rerun()
                if m2.button("📚 Library", key=f"lib_{item_id}"):
                    update_item_status(item_id, "library"); st.rerun()
                if m3.button("🗄 Archive", key=f"arch_{item_id}"):
                    update_item_status(item_id, "archived"); st.rerun()

            elif status == "processing":
                if m1.button("📚 → Library", key=f"lib2_{item_id}"):
                    update_item_status(item_id, "library"); st.rerun()
                if m2.button("🗄 Archive", key=f"arch2_{item_id}"):
                    update_item_status(item_id, "archived"); st.rerun()
                if m3.button("📬 ← Inbox", key=f"back_{item_id}"):
                    update_item_status(item_id, "inbox"); st.rerun()

            elif status == "library":
                if m1.button("🗄 Archive", key=f"arch3_{item_id}"):
                    update_item_status(item_id, "archived"); st.rerun()
                if m2.button("⚙️ Re-process", key=f"reproc_{item_id}"):
                    update_item_status(item_id, "processing"); st.rerun()

            elif status == "archived":
                if m1.button("↺ Restore", key=f"restore_{item_id}"):
                    update_item_status(item_id, "inbox"); st.rerun()

            st.markdown("**Convert to Hypothesis**")
            if not row.get("hyp_id"):
                with st.form(f"conv_{item_id}"):
                    cc1, cc2 = st.columns(2)
                    c_ea  = cc1.text_input("EA name (optional)")
                    c_sym = cc2.text_input("Symbol (optional)")
                    cc3, cc4 = st.columns(2)
                    c_sess  = cc3.selectbox("Session", ["","Asian","London","Pre_NY","London_NY","NY","Other"])
                    c_reg   = cc4.selectbox("Regime", ["","TRENDING","REVERTING","WEAK","CRASH"])
                    cc5, cc6 = st.columns(2)
                    c_twr = cc5.number_input("Target WR (%)", 0.0, 100.0, 55.0, step=1.0)
                    c_tpf = cc6.number_input("Target PF", 0.0, 10.0, 1.5, step=0.1)
                    if st.form_submit_button("🧬 Create Hypothesis", type="primary"):
                        ok, hyp_id, msg = convert_to_hypothesis(
                            item_id, ea_name=c_ea or None, symbol=c_sym or None,
                            session=c_sess or None, regime=c_reg or None,
                            target_wr=c_twr/100 if c_twr > 0 else None,
                            target_pf=c_tpf if c_tpf > 0 else None,
                        )
                        if ok:
                            st.success(f"Created hypothesis **{hyp_id}**")
                        else:
                            st.error(msg)
                        st.rerun()
            else:
                st.caption(f"✅ Already converted to hypothesis **{row['hyp_id']}**")

            st.markdown("**Link to Strategy**")
            with st.form(f"link_{item_id}"):
                ea_name = st.text_input("EA / Strategy name", value=row.get("ea_link") or "")
                if st.form_submit_button("🔗 Link"):
                    if ea_name.strip():
                        link_to_strategy(item_id, ea_name.strip())
                        st.rerun()


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — INBOX
# ══════════════════════════════════════════════════════════════════════════════
with tab_inbox:
    st.subheader("Inbox")
    st.caption("New items awaiting review and processing.")

    # Filter
    ib1, ib2, ib3 = st.columns([2, 1, 1])
    ib_cat = ib1.selectbox(
        "Filter category",
        ["All"] + CATEGORIES,
        format_func=lambda x: CATEGORY_LABELS.get(x, x) if x != "All" else "All categories",
        key="ib_cat",
    )
    ib_sort = ib2.selectbox("Sort", ["newest", "oldest", "category"], key="ib_sort")

    inbox_df = get_inbox_items(status="inbox",
                               category=None if ib_cat == "All" else ib_cat)
    if ib_sort == "oldest":
        inbox_df = inbox_df.sort_values("created_at", ascending=True)
    elif ib_sort == "category":
        inbox_df = inbox_df.sort_values("category")

    ib2.metric("Items", len(inbox_df))

    if inbox_df.empty:
        st.info("Inbox is empty. Use **New Ingest** to add research.")
    else:
        # Quick-process all button
        if ib3.button("▶ Process All", key="process_all"):
            for _, r in inbox_df.iterrows():
                update_item_status(r["item_id"], "processing")
            st.rerun()

        for _, row in inbox_df.iterrows():
            _render_item_card(row)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — PROCESSING
# ══════════════════════════════════════════════════════════════════════════════
with tab_processing:
    st.subheader("Processing")
    st.caption("Items being reviewed, annotated, and converted to hypotheses.")

    proc_df = get_inbox_items(status="processing")

    if proc_df.empty:
        st.info("No items in processing.")
    else:
        st.caption(f"{len(proc_df)} items")
        for _, row in proc_df.iterrows():
            _render_item_card(row, show_convert=True)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — ACTIONS
# ══════════════════════════════════════════════════════════════════════════════
with tab_actions:
    st.subheader("Action Items")
    st.caption("All pending research action items across all inbox items.")

    show_done = st.toggle("Show completed actions", value=False)
    all_acts  = get_all_actions(completed=None if show_done else False)

    if all_acts.empty:
        st.info("No action items yet.")
    else:
        # Group by item
        action_types = sorted(all_acts["action_type"].unique().tolist())
        filter_type = st.selectbox("Filter type", ["All"] + action_types, key="act_type_filter")

        if filter_type != "All":
            all_acts = all_acts[all_acts["action_type"] == filter_type]

        st.caption(f"{len(all_acts)} action(s)")

        # Count pending by type
        pending = all_acts[all_acts["completed"] == 0]
        if not pending.empty:
            type_counts = pending["action_type"].value_counts()
            tc_cols = st.columns(len(type_counts))
            for ci, (atype, cnt) in enumerate(type_counts.items()):
                tc_cols[ci].metric(atype.capitalize(), cnt)

        st.divider()

        # Render as grouped list
        for item_id, group in all_acts.groupby("item_id", sort=False):
            item_title = group.iloc[0].get("item_title", item_id)
            cat        = group.iloc[0].get("category", "uncategorized")
            cat_col    = CATEGORY_COLORS.get(cat, "#546e7a")

            st.markdown(
                f"<div style='background:{cat_col}20;border-left:3px solid {cat_col};"
                f"padding:4px 10px;border-radius:4px;margin:8px 0 4px 0'>"
                f"<b>{item_id}</b> — {item_title[:60]}</div>",
                unsafe_allow_html=True,
            )

            for _, act in group.iterrows():
                done  = bool(act.get("completed"))
                prefix = "~~" if done else ""
                suffix = "~~" if done else ""
                a1, a2, a3 = st.columns([4, 1, 1])
                type_icon = {"todo":"⬜","test":"🧪","hypothesis":"🧬",
                             "note":"📝","reference":"🔗"}.get(act["action_type"], "⬜")
                a1.markdown(
                    f"{'✅' if done else type_icon} {prefix}{act['action_text']}{suffix}  "
                    f"<span style='color:#8892b0;font-size:0.75rem'>[{act['action_type']}]</span>",
                    unsafe_allow_html=True,
                )
                if not done:
                    if a2.button("✓ Done", key=f"done_all_{act['action_id']}"):
                        complete_action(int(act["action_id"]))
                        st.rerun()
                else:
                    if a3.button("↺", key=f"reopen_{act['action_id']}"):
                        reopen_action(int(act["action_id"]))
                        st.rerun()
