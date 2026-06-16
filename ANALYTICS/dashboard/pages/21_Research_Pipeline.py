"""
21_Research_Pipeline.py — Research Pipeline

Full traceability from Learning Arena intake → Hypothesis → Validated Edge.
Shows: Learning Arena sync, 6-state research lifecycle, atoms, traceability chain.
"""

import sys, os, json
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import pct, num, C_WIN, C_LOSS, C_PRIMARY
from notebooklm_ingestor import (
    run_migration, STATUSES, STATUS_COLORS,
    CATEGORY_LABELS, CATEGORY_COLORS, SOURCE_ICONS,
    get_inbox_items, inbox_summary,
)
from learning_arena_bridge import (
    sync_from_arena, get_arena_queue_stats,
    get_pipeline_counts, get_traceability_chain,
    get_recent_atoms, QUEUE_PATH, ATOMS_PATH,
)
from hypothesis_tracker import (
    run_migration as run_hyp_migration,
    get_hypotheses, get_edges,
)

st.set_page_config(
    page_title="Research Pipeline — QTrade OS",
    page_icon="🔬",
    layout="wide",
)

run_migration()
run_hyp_migration()

# ── Header ────────────────────────────────────────────────────────────────────
st.title("🔬 Research Pipeline")
st.caption(
    "Full traceability: Learning Arena intake → QTrade research → Hypothesis → Validated Edge. "
    "Import Learning Arena items to link research to trade statistics."
)

counts = get_pipeline_counts()

c1, c2, c3, c4, c5, c6 = st.columns(6)
c1.metric("🏟 Arena Written",  counts.get("arena_written",   0), help="Items written to Obsidian vault by Learning Arena")
c2.metric("📬 Research Inbox", counts.get("research_inbox",  0), help="Items in QTrade research_inbox (inbox status)")
c3.metric("🔭 Reviewing",      counts.get("research_review", 0), help="Items under human review")
c4.metric("🧬 Hypotheses",     counts.get("hyp_testing",     0) + counts.get("hyp_observing", 0), help="Active hypotheses (testing + observing)")
c5.metric("✅ Validated",      counts.get("hyp_validated",   0))
c6.metric("🔗 Live Edges",     counts.get("edges_live",      0))

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1 — LEARNING ARENA SYNC
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("🏟 Learning Arena → QTrade OS Import")

arena_stats = get_arena_queue_stats()
arena_found = arena_stats["queue_exists"]

if not arena_found:
    st.warning(
        f"Learning Arena queue not found at `{QUEUE_PATH}`. "
        "Make sure the EA Business OS (ea_research_team/learning/) is in the same vault."
    )
else:
    a1, a2, a3, a4, a5 = st.columns(5)
    a1.metric("Total Items",   arena_stats["total"])
    a2.metric("Written",       arena_stats["written"],  help="Written to Obsidian vault")
    a3.metric("Approved",      arena_stats["approved"], help="Approved but not yet written")
    a4.metric("Pending",       arena_stats["pending"],  help="Waiting for human review in Learning Arena")
    a5.metric("Atoms",         arena_stats["total_atoms"], help="Atomic insights extracted by Learning Arena")

    st.divider()

    # Sync controls
    sc1, sc2, sc3 = st.columns([1, 1, 3])
    if sc1.button("📥 Import Written Items", type="primary",
                  help="Import all items with status 'written' from Learning Arena"):
        result = sync_from_arena(statuses=["written"])
        if result["synced"] > 0:
            st.success(
                f"Imported {result['synced']} new items. "
                f"Skipped {result['skipped']} already-imported."
            )
        elif result["skipped"] > 0:
            st.info(f"All {result['skipped']} written items already imported.")
        else:
            st.warning("No written items found in Learning Arena queue.")
        st.rerun()

    if sc2.button("📥 Import All Approved",
                  help="Import approved + written items"):
        result = sync_from_arena(statuses=["written", "approved"])
        st.success(
            f"Synced {result['synced']} items. "
            f"Skipped {result['skipped']}. Errors: {result['errors']}."
        )
        st.rerun()

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2 — PIPELINE FUNNEL
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("Pipeline Funnel")

funnel_labels = [
    "Arena Written",
    "In Research Inbox",
    "Under Review",
    "Hypothesis Created",
    "Testing / Observing",
    "Validated Edge",
]
funnel_values = [
    counts.get("arena_written",   0),
    counts.get("research_total",  0),
    counts.get("research_review", 0),
    counts.get("hyp_idea",        0) + counts.get("hyp_testing", 0) + counts.get("hyp_observing", 0),
    counts.get("hyp_testing",     0) + counts.get("hyp_observing", 0),
    counts.get("edges_live",      0),
]

if any(v > 0 for v in funnel_values):
    fig_funnel = go.Figure(go.Funnel(
        y=funnel_labels,
        x=funnel_values,
        textinfo="value+percent previous",
        marker=dict(color=[
            "#29b6f6", "#ffd600", "#fb8c00", "#5c6bc0", "#26a69a", "#ef5350"
        ]),
    ))
    fig_funnel.update_layout(
        height=340,
        paper_bgcolor="rgba(0,0,0,0)",
        plot_bgcolor="rgba(0,0,0,0)",
        font=dict(color="#e0e0e0"),
        margin=dict(l=0, r=0, t=10, b=0),
    )
    st.plotly_chart(fig_funnel, use_container_width=True)
else:
    st.info(
        "No pipeline data yet. Import Learning Arena items above, "
        "then convert research items to hypotheses in **🧬 Hypotheses** (page 15)."
    )

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3 — RESEARCH LIFECYCLE TABLE
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("Research Lifecycle")

# Status filter
f1, f2, f3 = st.columns([2, 2, 3])
status_filter = f1.selectbox(
    "Status",
    ["All"] + STATUSES,
    format_func=lambda s: f"{STATUS_COLORS.get(s, '')} {s.title()}" if s != "All" else "All statuses",
    key="pipeline_status_filter",
)
src_filter = f2.selectbox(
    "Source",
    ["All", "learning_arena", "notebooklm", "youtube", "article", "pdf", "book", "podcast", "manual", "other"],
    format_func=lambda s: f"{SOURCE_ICONS.get(s, '🔗')} {s.replace('_',' ').title()}" if s != "All" else "All sources",
    key="pipeline_src_filter",
)

all_items = get_inbox_items(
    status=None if status_filter == "All" else status_filter,
)

if src_filter != "All" and not all_items.empty:
    all_items = all_items[all_items["source_type"] == src_filter]

if all_items.empty:
    st.info("No research items match the filter.")
else:
    # Build display table
    rows = []
    for _, r in all_items.iterrows():
        cat   = r.get("category", "uncategorized")
        src   = r.get("source_type", "other")
        st_v  = r.get("status", "inbox")
        rows.append({
            "Item ID":    r["item_id"],
            "Title":      str(r.get("title", ""))[:50],
            "Source":     f"{SOURCE_ICONS.get(src, '🔗')} {src.replace('_',' ').title()}",
            "Category":   CATEGORY_LABELS.get(cat, cat),
            "Status":     st_v.upper(),
            "Hypothesis": r.get("hyp_id") or "—",
            "Arena":      "✅" if r.get("arena_id") else "—",
            "Created":    str(r.get("created_at", ""))[:10],
        })

    df_tbl = pd.DataFrame(rows)
    event = st.dataframe(
        df_tbl, use_container_width=True, hide_index=True, on_select="rerun",
        selection_mode="single-row",
    )

    # Detail panel for selected row
    selected_rows = event.selection.get("rows", []) if hasattr(event, "selection") else []
    if selected_rows:
        sel_idx  = selected_rows[0]
        sel_item = all_items.iloc[sel_idx]
        _sid = sel_item["item_id"]

        st.divider()
        _cat = sel_item.get("category", "uncategorized")
        _cc  = CATEGORY_COLORS.get(_cat, "#546e7a")
        _cl  = CATEGORY_LABELS.get(_cat, _cat)
        st.markdown(
            f"**{_sid}** — {sel_item.get('title', '')}  "
            f"<span style='color:{_cc}'>[{_cl}]</span>",
            unsafe_allow_html=True,
        )

        d1, d2, d3 = st.columns(3)
        d1.write(f"**Status:** {sel_item.get('status','').upper()}")
        d2.write(f"**Source:** {sel_item.get('source_type','')}")
        if sel_item.get("hyp_id"):
            d3.write(f"**Hypothesis:** {sel_item['hyp_id']}")

        if sel_item.get("summary"):
            st.caption(sel_item["summary"][:300])

        # Show atoms if from arena
        if sel_item.get("arena_id") and sel_item.get("atoms_json"):
            try:
                atoms = json.loads(sel_item["atoms_json"])
                if atoms:
                    st.markdown("**Atomic Insights:**")
                    for atom in atoms[:5]:
                        conf = atom.get("confidence", "medium")
                        icon = {"high": "🟢", "medium": "🟡", "low": "🔴"}.get(conf, "⚪")
                        st.markdown(
                            f"- {icon} **{atom.get('insight', '')}**  "
                            f"*({atom.get('topic', '')})*"
                        )
            except Exception:
                pass

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4 — TRACEABILITY CHAIN
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("Traceability Chain")
st.caption("Research items that have been converted to hypotheses and beyond.")

chains = get_traceability_chain()

if not chains:
    st.info(
        "No traceability chains yet. "
        "Convert research items to hypotheses in **🔬 Hypothesis Queue** (page 19)."
    )
else:
    for chain in chains:
        hyp_status  = chain.get("hyp_status", "")
        edge_id     = chain.get("edge_id")
        conf        = chain.get("confidence_score") or 0
        _sc         = "#26a69a" if hyp_status == "validated" else ("#ffd600" if hyp_status in ("testing","observing") else "#8892b0")

        with st.expander(
            f"**{chain.get('hyp_id','?')}** — {str(chain.get('research_title',''))[:50]}",
            expanded=False,
        ):
            t1, t2, t3, t4 = st.columns(4)

            # Research node
            _rsrc = chain.get("source_type", "other")
            t1.markdown(
                f"**Research**  \n"
                f"{SOURCE_ICONS.get(_rsrc,'🔗')} {str(chain.get('research_title',''))[:35]}  \n"
                f"*{CATEGORY_LABELS.get(chain.get('category',''),'')}"
                f"{'  ·  🏟 Arena' if chain.get('arena_id') else ''}*"
            )

            # Hypothesis node
            _hstyle = f"color:{_sc}"
            t2.markdown(
                f"**Hypothesis**  \n"
                f"{chain.get('hyp_id','—')}  \n"
                f"<span style='{_hstyle}'>{hyp_status.upper()}</span>  \n"
                f"Conf: {conf:.0f}/100",
                unsafe_allow_html=True,
            )

            # Stats node
            actual_n  = chain.get("actual_n") or 0
            min_n     = chain.get("min_trades") or 30
            actual_wr = chain.get("actual_wr")
            actual_pf = chain.get("actual_pf")
            t3.markdown(
                f"**Live Stats**  \n"
                f"N: {actual_n} / {min_n}  \n"
                f"WR: {pct(actual_wr) if actual_wr else '—'}  \n"
                f"PF: {num(actual_pf) if actual_pf else '—'}"
            )

            # Edge node
            if edge_id:
                al   = chain.get("alert_level", "ok")
                _ec  = {"ok":"#26a69a","watch":"#ffd600","warn":"#fb8c00","degrade":"#ef5350"}.get(al, "#546e7a")
                t4.markdown(
                    f"**Live Edge**  \n"
                    f"{edge_id}  \n"
                    f"Score: {chain.get('edge_score') or 0:.0f}/100  \n"
                    f"<span style='color:{_ec}'>{al.upper()}</span>",
                    unsafe_allow_html=True,
                )
            else:
                t4.markdown("**Live Edge**  \n*Not promoted yet*")

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5 — RECENT ATOMS
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("⚡ Recent Atomic Insights")
st.caption("Latest insights extracted by Learning Arena atomizer from approved research.")

atoms = get_recent_atoms(15)

if not atoms:
    st.info("No atoms yet. Learning Arena extracts atoms after approving items.")
else:
    for atom in reversed(atoms):
        conf     = atom.get("confidence", "medium")
        icon     = {"high": "🟢", "medium": "🟡", "low": "🔴"}.get(conf, "⚪")
        applies  = ", ".join(atom.get("applies_to", []))
        topic    = atom.get("topic", "")
        st.markdown(
            f"{icon} **{atom.get('insight', '')}**  \n"
            f"&nbsp;&nbsp;&nbsp;*{topic}*"
            + (f" · applies to: `{applies}`" if applies else "")
            + (f"  \n&nbsp;&nbsp;&nbsp;→ {atom.get('action','')}" if atom.get("action") else ""),
            unsafe_allow_html=True,
        )

st.divider()
st.caption(
    "Import research via **📥 Research Inbox** (page 17) · "
    "Browse library via **📚 Research Library** (page 18) · "
    "Convert to hypothesis via **🔬 Hypothesis Queue** (page 19) · "
    "Track validation via **📊 Validation Tracker** (page 20)"
)
