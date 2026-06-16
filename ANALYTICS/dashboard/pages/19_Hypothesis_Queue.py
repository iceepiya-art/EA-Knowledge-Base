"""
19_Hypothesis_Queue.py — Hypothesis Queue

Focused view of the research-to-hypothesis conversion pipeline.
Shows: research items ready to convert + hypotheses in idea/testing state.
One-click workflow: Research → Hypothesis → Testing → Observing.
"""

import sys, os, json
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import load_trades, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from notebooklm_ingestor import (
    run_migration as run_inbox_migration,
    CATEGORY_LABELS, CATEGORY_COLORS,
    get_inbox_items, convert_to_hypothesis,
)
from hypothesis_tracker import (
    run_migration as run_hyp_migration,
    STATUSES, STATUS_COLORS,
    get_hypotheses, get_hypothesis, update_hypothesis,
    compute_live_stats, refresh_all_stats,
    advance_to_observing,
)

st.set_page_config(
    page_title="Hypothesis Queue — QTrade OS",
    page_icon="🔬",
    layout="wide",
)

run_inbox_migration()
run_hyp_migration()

df_all = load_trades()

# ── Header ────────────────────────────────────────────────────────────────────
st.title("🔬 Hypothesis Queue")
st.caption(
    "Pipeline from research → hypothesis → testing → observing → validated. "
    "All promotion decisions are manual — no auto-validation."
)

all_hyps  = get_hypotheses()
inbox_all = get_inbox_items()

counts = all_hyps["status"].value_counts().to_dict() if not all_hyps.empty else {}
has_draft = inbox_all[inbox_all["hypothesis_draft"].notna()
                      & (inbox_all["hyp_id"].isna() | (inbox_all["hyp_id"] == ""))
                      ].shape[0] if not inbox_all.empty else 0

q1, q2, q3, q4, q5 = st.columns(5)
q1.metric("📬 Research Ready",  has_draft, help="Research items with hypothesis draft, not yet converted")
q2.metric("💡 Ideas",          counts.get("idea",      0))
q3.metric("🔬 Testing",        counts.get("testing",   0), delta="collecting evidence")
q4.metric("🔭 Observing",      counts.get("observing", 0), delta="awaiting review")
q5.metric("✅ Validated",      counts.get("validated", 0))

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1 — RESEARCH READY TO CONVERT
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("📬 Research → Hypothesis Conversions")
st.caption("Research items with generated hypothesis drafts, not yet converted.")

ready = inbox_all[
    inbox_all["hypothesis_draft"].notna() &
    (inbox_all["hyp_id"].isna() | (inbox_all["hyp_id"] == ""))
] if not inbox_all.empty else pd.DataFrame()

if ready.empty:
    st.info(
        "No research items ready to convert. "
        "Add research in the **Research Inbox** (page 17), "
        "then come back here to convert drafts to hypotheses."
    )
else:
    for _, row in ready.iterrows():
        item_id = row["item_id"]
        cat     = row.get("category", "uncategorized")
        cat_col = CATEGORY_COLORS.get(cat, "#546e7a")
        cat_lbl = CATEGORY_LABELS.get(cat, cat)

        with st.expander(
            f"**{item_id}** — {row['title']}  "
            f"| <span style='color:{cat_col}'>{cat_lbl}</span>",
            expanded=False,
        ):
            rc1, rc2 = st.columns([3, 2])

            with rc1:
                st.markdown("**Hypothesis Draft:**")
                st.markdown(row.get("hypothesis_draft") or "—")
                if row.get("source_url"):
                    st.markdown(f"🔗 [Source]({row['source_url']})")

            with rc2:
                st.markdown("**Convert to Hypothesis**")
                with st.form(f"q_conv_{item_id}"):
                    qc1, qc2 = st.columns(2)
                    q_ea   = qc1.text_input("EA (optional)")
                    q_sym  = qc2.text_input("Symbol (optional)")
                    qc3, qc4 = st.columns(2)
                    q_sess = qc3.selectbox("Session",
                                           ["","Asian","London","Pre_NY","London_NY","NY","Other"])
                    q_reg  = qc4.selectbox("Regime",
                                           ["","TRENDING","REVERTING","WEAK","CRASH"])
                    qc5, qc6 = st.columns(2)
                    q_wr = qc5.number_input("Target WR (%)", 0.0, 100.0, 55.0, step=1.0)
                    q_pf = qc6.number_input("Target PF",     0.0, 10.0,   1.5, step=0.1)
                    q_min = st.number_input("Min trades", 10, 500, 30)

                    if st.form_submit_button("🧬 Create Hypothesis", type="primary",
                                             use_container_width=True):
                        ok, hyp_id, msg = convert_to_hypothesis(
                            item_id,
                            ea_name    = q_ea    or None,
                            symbol     = q_sym   or None,
                            session    = q_sess  or None,
                            regime     = q_reg   or None,
                            target_wr  = q_wr/100 if q_wr > 0 else None,
                            target_pf  = q_pf    if q_pf > 0 else None,
                            min_trades = int(q_min),
                        )
                        if ok:
                            st.success(f"Created **{hyp_id}** — go to Testing queue")
                        else:
                            st.error(msg)
                        st.rerun()

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2 — ACTIVE PIPELINE  (idea + testing + observing)
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("🔬 Active Pipeline")

# Refresh button
rb1, rb2 = st.columns([1, 4])
if rb1.button("🔄 Refresh Stats"):
    n = refresh_all_stats(df_all)
    st.success(f"Refreshed {n}")
    st.rerun()

active_hyps = all_hyps[all_hyps["status"].isin(["idea", "testing", "observing"])].copy()

if active_hyps.empty:
    st.info("No active hypotheses. Convert research items above to start.")
else:
    # Compact table view
    table_rows = []
    for _, row in active_hyps.iterrows():
        n     = int(row.get("actual_n") or 0)
        min_n = int(row.get("min_trades") or 30)
        conf  = float(row.get("confidence_score") or 0)
        prog  = min(n / max(min_n, 1), 1.0) * 100
        table_rows.append({
            "ID":       row["hyp_id"],
            "Title":    row["title"][:45],
            "Status":   row["status"].upper(),
            "EA":       row.get("ea_name") or "—",
            "N / Min":  f"{n} / {min_n}",
            "Progress": prog,
            "WR":       pct(row.get("actual_wr")) if row.get("actual_wr") else "—",
            "Conf":     conf,
        })

    tdf = pd.DataFrame(table_rows)
    st.dataframe(
        tdf, use_container_width=True, hide_index=True,
        column_config={
            "Progress": st.column_config.ProgressColumn(
                "Sample %", min_value=0, max_value=100, format="%.0f%%",
            ),
            "Conf": st.column_config.ProgressColumn(
                "Confidence", min_value=0, max_value=100, format="%.0f",
            ),
        },
    )

    # Detail + action per hypothesis
    sel = st.selectbox(
        "Select hypothesis for quick actions",
        ["—"] + active_hyps["hyp_id"].tolist(),
        key="queue_sel",
    )

    if sel and sel != "—":
        hyp  = get_hypothesis(sel)
        row  = active_hyps[active_hyps["hyp_id"] == sel].iloc[0]
        status = row["status"]
        n      = int(row.get("actual_n") or 0)
        min_n  = int(row.get("min_trades") or 30)

        sc1, sc2, sc3, sc4 = st.columns(4)
        sc1.metric("Status",   status.upper())
        sc2.metric("N trades", f"{n:,}")
        sc3.metric("WR",       pct(row.get("actual_wr")) if row.get("actual_wr") else "—")
        sc4.metric("Progress", f"{min(n/max(min_n,1),1.0)*100:.0f}%")

        a1, a2, a3, a4 = st.columns(4)

        if status == "idea":
            if a1.button("▶ Start Testing", key=f"q_test_{sel}"):
                update_hypothesis(sel, {"status": "testing"})
                st.rerun()

        if status == "testing":
            if a1.button("🔭 Mark Observing", key=f"q_obs_{sel}",
                         disabled=(n < min_n),
                         help=f"Need {min_n} trades (have {n})"):
                ok, msg = advance_to_observing(sel)
                st.success(msg) if ok else st.error(msg)
                st.rerun()

        if status in ("testing", "observing"):
            if a2.button("⏸ Pause → Idea", key=f"q_pause_{sel}"):
                update_hypothesis(sel, {"status": "idea"})
                st.rerun()
            if a3.button("❌ Reject", key=f"q_rej_{sel}"):
                update_hypothesis(sel, {"status": "rejected"})
                st.rerun()

        if a4.button("Open in 🧬 Hypotheses", key=f"q_open_{sel}"):
            st.switch_page("pages/15_Hypotheses.py")

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3 — RECENTLY VALIDATED
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("✅ Recently Validated")

val_hyps = all_hyps[all_hyps["status"] == "validated"].head(5)
if val_hyps.empty:
    st.info("No validated hypotheses yet.")
else:
    for _, row in val_hyps.iterrows():
        col_a, col_b, col_c = st.columns([3, 1, 1])
        col_a.markdown(f"**{row['hyp_id']}** — {row['title'][:55]}")
        col_b.markdown(f"WR: {pct(row.get('actual_wr')) if row.get('actual_wr') else '—'}")
        col_c.markdown(f"PF: {num(row.get('actual_pf')) if row.get('actual_pf') else '—'}")

st.divider()
st.caption(
    "For full hypothesis management (evidence, audit trail, edge promotion), "
    "use **🧬 Hypotheses** (page 15)."
)
