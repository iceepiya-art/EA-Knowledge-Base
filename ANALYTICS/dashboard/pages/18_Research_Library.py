"""
18_Research_Library.py — Research Library

Organized, searchable view of all processed research.
Filter by category, source type, date range.
Link research to strategies and hypotheses.
"""

import sys, os, json
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import C_WIN, C_LOSS, C_PRIMARY
from notebooklm_ingestor import (
    run_migration,
    CATEGORIES, CATEGORY_LABELS, CATEGORY_COLORS,
    SOURCE_TYPES, SOURCE_ICONS, STATUSES, STATUS_COLORS,
    get_inbox_items, get_item, update_item_status,
    convert_to_hypothesis, link_to_strategy,
    get_actions, complete_action, add_action, inbox_summary,
)

st.set_page_config(
    page_title="Research Library — QTrade OS",
    page_icon="📚",
    layout="wide",
)

run_migration()

st.title("📚 Research Library")
st.caption(
    "All processed research organized by category. "
    "Search, filter, and link research to trading strategies and hypotheses."
)

# ── Summary bar ───────────────────────────────────────────────────────────────
summary = inbox_summary()
by_cat  = summary.get("by_category", {})
total   = sum(summary.get("by_status", {}).values())

if by_cat:
    cat_df = pd.DataFrame([
        {"Category": CATEGORY_LABELS.get(k, k), "Count": v, "Color": CATEGORY_COLORS.get(k, "#546e7a")}
        for k, v in sorted(by_cat.items(), key=lambda x: -x[1])
    ])
    fig_cat = go.Figure(go.Bar(
        x=cat_df["Category"], y=cat_df["Count"],
        marker_color=cat_df["Color"],
        text=cat_df["Count"], textposition="auto",
    ))
    fig_cat.update_layout(
        height=180, title="Research by Category",
        xaxis=dict(gridcolor="#1e2130"),
        yaxis=dict(gridcolor="#1e2130"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=40, b=0),
    )
    st.plotly_chart(fig_cat, use_container_width=True)

st.divider()

# ── Filters ───────────────────────────────────────────────────────────────────
f1, f2, f3, f4 = st.columns([3, 2, 2, 1])

search_q   = f1.text_input("🔍 Search", placeholder="Search title or summary…")
filter_cat = f2.selectbox(
    "Category",
    ["All"] + CATEGORIES,
    format_func=lambda x: CATEGORY_LABELS.get(x, x) if x != "All" else "All categories",
)
filter_src = f3.selectbox(
    "Source type",
    ["All"] + SOURCE_TYPES,
    format_func=lambda x: f"{SOURCE_ICONS.get(x,'🔗')} {x.capitalize()}" if x != "All" else "All sources",
)
filter_status = f4.selectbox("Status", ["All"] + STATUSES)

# Load and filter
all_items = get_inbox_items(
    status=None if filter_status == "All" else filter_status,
    category=None if filter_cat == "All" else filter_cat,
)

if filter_src != "All" and not all_items.empty:
    all_items = all_items[all_items["source_type"] == filter_src]

if search_q and not all_items.empty:
    q = search_q.lower()
    mask = (
        all_items["title"].str.lower().str.contains(q, na=False) |
        all_items["summary"].str.lower().str.contains(q, na=False)
    )
    all_items = all_items[mask]

# Sort
sort_opt = st.selectbox(
    "Sort by",
    ["Newest first", "Oldest first", "Category", "Source type"],
    horizontal=False,
    label_visibility="collapsed",
)
if not all_items.empty:
    if sort_opt == "Oldest first":
        all_items = all_items.sort_values("created_at", ascending=True)
    elif sort_opt == "Category":
        all_items = all_items.sort_values("category")
    elif sort_opt == "Source type":
        all_items = all_items.sort_values("source_type")

st.caption(f"**{len(all_items)}** items")

if all_items.empty:
    st.info(
        "No research items match the current filter. "
        "Add research via **Research Inbox** (page 17)."
    )
else:
    # ── Card grid: 3 per row ──────────────────────────────────────────────────
    items_list = all_items.to_dict("records")
    cols_per_row = 3

    for row_start in range(0, len(items_list), cols_per_row):
        row_items = items_list[row_start:row_start + cols_per_row]
        cols = st.columns(cols_per_row)

        for ci, item in enumerate(row_items):
            cat     = item.get("category", "uncategorized")
            cat_col = CATEGORY_COLORS.get(cat, "#546e7a")
            cat_lbl = CATEGORY_LABELS.get(cat, cat)
            src     = item.get("source_type", "other")
            src_icon = SOURCE_ICONS.get(src, "🔗")
            status  = item.get("status", "inbox")
            st_col  = STATUS_COLORS.get(status, "#546e7a")
            tags    = [t for t in (item.get("tags") or "").split(",") if t.strip()]
            summary_text = (item.get("summary") or "")[:200]

            with cols[ci]:
                st.markdown(
                    f"<div style='border:1px solid {cat_col};border-radius:8px;"
                    f"padding:14px;margin-bottom:8px;background:#0e1117'>"
                    f"<div style='display:flex;justify-content:space-between;align-items:flex-start'>"
                    f"<span style='font-size:0.7rem;color:{cat_col}'>{cat_lbl.upper()}</span>"
                    f"<span style='font-size:0.7rem;color:{st_col}'>{status.upper()}</span>"
                    f"</div>"
                    f"<div style='font-weight:600;margin:6px 0 4px 0'>{src_icon} {item['title'][:55]}</div>"
                    f"<div style='font-size:0.78rem;color:#8892b0'>{summary_text}{'…' if len(item.get('summary','')) > 200 else ''}</div>"
                    f"<div style='margin-top:8px;font-size:0.7rem;color:#546e7a'>"
                    f"📅 {str(item.get('created_at',''))[:10]}"
                    f"{'  ·  🧬 ' + item['hyp_id'] if item.get('hyp_id') else ''}"
                    f"</div>"
                    f"</div>",
                    unsafe_allow_html=True,
                )
                if tags:
                    st.caption("🏷 " + "  ·  ".join(tags[:4]))

                btn1, btn2 = st.columns(2)
                if btn1.button("View", key=f"view_{item['item_id']}"):
                    st.session_state["lib_selected"] = item["item_id"]
                if item.get("source_url"):
                    btn2.link_button("Source", item["source_url"])

    # ── Detail panel ─────────────────────────────────────────────────────────
    selected_id = st.session_state.get("lib_selected")
    if selected_id:
        item = get_item(selected_id)
        if item:
            st.divider()
            cat     = item["category"]
            cat_col = CATEGORY_COLORS.get(cat, "#546e7a")
            cat_lbl = CATEGORY_LABELS.get(cat, cat)
            src     = item.get("source_type", "other")

            st.markdown(
                f"## {SOURCE_ICONS.get(src,'🔗')} {item['title']}  "
                f"<span style='color:{cat_col};font-size:0.9rem'>[{cat_lbl}]</span>",
                unsafe_allow_html=True,
            )

            if item.get("source_url"):
                st.markdown(f"🔗 [Open in {src.capitalize()}]({item['source_url']})")

            # Content tabs
            d1, d2, d3, d4, d5 = st.tabs([
                "📄 Summary", "🧬 Hypothesis", "✅ Actions", "📋 Checklist", "⚙️ Manage",
            ])

            with d1:
                if item.get("summary"):
                    st.markdown(item["summary"])
                try:
                    insights = json.loads(item.get("key_insights") or "[]")
                except Exception:
                    insights = []
                if insights:
                    st.markdown("**Key insights:**")
                    for ins in insights:
                        st.markdown(f"- {ins}")
                if item.get("raw_notes"):
                    st.markdown("**Raw notes:**")
                    st.text(item["raw_notes"])

            with d2:
                st.markdown(item.get("hypothesis_draft") or "No hypothesis draft generated.")
                if not item.get("hyp_id"):
                    st.divider()
                    st.markdown("**Convert to hypothesis:**")
                    with st.form(f"lib_conv_{selected_id}"):
                        lc1, lc2 = st.columns(2)
                        l_ea  = lc1.text_input("EA")
                        l_sym = lc2.text_input("Symbol")
                        lc3, lc4 = st.columns(2)
                        l_wr = lc3.number_input("Target WR (%)", 0.0, 100.0, 55.0)
                        l_pf = lc4.number_input("Target PF",     0.0, 10.0,   1.5, step=0.1)
                        if st.form_submit_button("🧬 Convert", type="primary"):
                            ok, hyp_id, msg = convert_to_hypothesis(
                                selected_id,
                                ea_name=l_ea or None, symbol=l_sym or None,
                                target_wr=l_wr/100 if l_wr > 0 else None,
                                target_pf=l_pf if l_pf > 0 else None,
                            )
                            st.success(msg) if ok else st.error(msg)
                            st.rerun()
                else:
                    st.success(f"Converted to hypothesis **{item['hyp_id']}**")

            with d3:
                db_acts = get_actions(selected_id)
                try:
                    json_acts = json.loads(item.get("action_items") or "[]")
                except Exception:
                    json_acts = []

                if db_acts.empty:
                    for a in json_acts:
                        st.markdown(f"- [ ] {a}")
                else:
                    for _, act in db_acts.iterrows():
                        done = bool(act.get("completed"))
                        col_a, col_b = st.columns([5, 1])
                        col_a.markdown(
                            f"{'✅' if done else '⬜'} "
                            f"{'~~' if done else ''}{act['action_text']}{'~~' if done else ''}"
                        )
                        if not done and col_b.button("✓", key=f"d_done_{act['action_id']}"):
                            complete_action(int(act["action_id"]))
                            st.rerun()

            with d4:
                try:
                    cl_list = json.loads(item.get("test_checklist") or "[]")
                except Exception:
                    cl_list = []
                for c in cl_list:
                    st.markdown(f"- [ ] {c}")

            with d5:
                # Status management
                st.markdown("**Status**")
                sm1, sm2, sm3 = st.columns(3)
                cur_status = item["status"]
                for btn_status, col in zip(
                    [s for s in STATUSES if s != cur_status], [sm1, sm2, sm3]
                ):
                    if col.button(
                        f"→ {btn_status.capitalize()}",
                        key=f"lib_status_{selected_id}_{btn_status}",
                    ):
                        update_item_status(selected_id, btn_status)
                        st.rerun()

                st.markdown("**Link to strategy / EA**")
                with st.form(f"lib_link_{selected_id}"):
                    ea_input = st.text_input("EA / Strategy", value=item.get("ea_link") or "")
                    if st.form_submit_button("🔗 Save Link"):
                        link_to_strategy(selected_id, ea_input.strip())
                        st.rerun()

                if item.get("note_path"):
                    st.markdown("**Vault note**")
                    st.code(item["note_path"])
                    vault_name = "EA-Knowledge-Base"
                    note_key = item["note_path"].replace("\\", "/").replace(".md", "")
                    import urllib.parse
                    obsidian_url = f"obsidian://open?vault={vault_name}&file={urllib.parse.quote(note_key)}"
                    st.link_button("Open in Obsidian", obsidian_url)

    # ── Source type distribution ──────────────────────────────────────────────
    if not all_items.empty and len(all_items) >= 2:
        st.divider()
        sc1, sc2 = st.columns(2)

        with sc1:
            src_counts = all_items["source_type"].value_counts()
            fig_src = go.Figure(go.Pie(
                labels=[f"{SOURCE_ICONS.get(k,'🔗')} {k.capitalize()}" for k in src_counts.index],
                values=src_counts.values,
                hole=0.4,
                marker=dict(colors=[C_PRIMARY, C_WIN, "#ffd600", "#fb8c00",
                                     "#ab47bc", "#29b6f6", "#8d6e63", "#546e7a"]),
            ))
            fig_src.update_layout(
                height=250, title="By Source Type",
                paper_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=40, b=0),
                legend=dict(font=dict(size=10)),
            )
            st.plotly_chart(fig_src, use_container_width=True)

        with sc2:
            stat_counts = all_items["status"].value_counts()
            fig_st = go.Figure(go.Bar(
                x=stat_counts.index,
                y=stat_counts.values,
                marker_color=[STATUS_COLORS.get(s, "#546e7a") for s in stat_counts.index],
                text=stat_counts.values, textposition="auto",
            ))
            fig_st.update_layout(
                height=250, title="By Status",
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=40, b=0),
            )
            st.plotly_chart(fig_st, use_container_width=True)
