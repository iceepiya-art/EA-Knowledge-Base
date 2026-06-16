"""
16_Weekly_Review.py — Weekly Review Generator

Auto-generates a pre-filled markdown weekly review note from trade data.
The human fills in qualitative sections (what worked, what didn't, lessons).
Stats are computed automatically from the trades database.
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd
from datetime import date, timedelta
from pathlib import Path

from utils import load_trades, sidebar_filters, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from weekly_generator import (
    generate_weekly_review, list_weekly_reviews,
    _load_week_trades, _kpis, _best_ea, _best_session, _top_mistakes,
    BASE_DIR, WEEKLY_DIR,
)

st.set_page_config(
    page_title="Weekly Review — QTrade OS",
    page_icon="📅",
    layout="wide",
)

st.title("📅 Weekly Review Generator")
st.caption(
    "Auto-generates stats-filled weekly review notes. "
    "You add the qualitative sections. Export to Obsidian vault."
)

WEEKLY_DIR.mkdir(parents=True, exist_ok=True)

# ── ISO week picker ────────────────────────────────────────────────────────────
today       = date.today()
last_monday = today - timedelta(days=today.weekday() + 7)
iso         = last_monday.isocalendar()
default_wk  = f"{iso[0]}-W{iso[1]:02d}"

hc1, hc2, hc3 = st.columns([2, 1, 1])
week_input  = hc1.text_input("ISO Week", value=default_wk,
                              placeholder="2026-W19",
                              help="Format: YYYY-Www  e.g. 2026-W19")
overwrite   = hc2.toggle("Overwrite if exists", value=False)
gen_btn     = hc3.button("⚡ Generate Review", type="primary", use_container_width=True)

if gen_btn:
    week_str = week_input.strip()
    if not week_str:
        st.error("Enter a week in format YYYY-Www")
    else:
        with st.spinner(f"Generating review for {week_str}…"):
            try:
                note_path, summary = generate_weekly_review(week_str, overwrite=overwrite)
                if summary.get("skipped"):
                    st.info(
                        f"Review for **{week_str}** already exists. "
                        f"Enable **Overwrite** to regenerate."
                    )
                else:
                    rel = str(note_path.relative_to(BASE_DIR))
                    st.success(f"Generated: `{rel}`")
                    m1, m2, m3 = st.columns(3)
                    m1.metric("Trades",  summary.get("total_trades", 0))
                    m2.metric("Net PnL", usd(summary.get("net_pnl")))
                    m3.metric("Win Rate",pct(summary.get("win_rate")))

                    # Preview button
                    if note_path.exists():
                        st.download_button(
                            "⬇ Download .md",
                            note_path.read_text(encoding="utf-8"),
                            file_name=note_path.name,
                            mime="text/markdown",
                        )
            except ValueError as e:
                st.error(str(e))

st.divider()

# ── Previous reviews list ──────────────────────────────────────────────────────
st.subheader("Previous Weekly Reviews")

reviews = list_weekly_reviews()
if reviews.empty:
    st.info(
        "No weekly reviews generated yet. "
        "Enter a week above and click **Generate Review**."
    )
else:
    # Format for display
    disp = reviews.copy()
    if "win_rate" in disp.columns:
        disp["win_rate"] = disp["win_rate"].apply(
            lambda v: pct(float(v)) if v and str(v) != "nan" else "—"
        )
    if "net_pnl" in disp.columns:
        disp["net_pnl"] = disp["net_pnl"].apply(
            lambda v: usd(float(v)) if v and str(v) != "nan" else "—"
        )
    disp.columns = [c.replace("_", " ").title() for c in disp.columns]
    st.dataframe(disp, use_container_width=True, hide_index=True)

    # Open in Obsidian link
    st.caption(
        "To open in Obsidian: use the **Open vault in Obsidian** button in the app, "
        "then navigate to `10_Research/13_Weekly_Reviews/`."
    )

    # Select and preview
    selected_week = st.selectbox(
        "Preview a review",
        ["—"] + reviews["week"].tolist(),
        key="preview_week_sel",
    )
    if selected_week != "—":
        note_file = WEEKLY_DIR / f"{selected_week}.md"
        if note_file.exists():
            content = note_file.read_text(encoding="utf-8", errors="ignore")

            # Strip YAML for display
            body = content
            if content.startswith("---"):
                end = content.find("\n---", 3)
                if end != -1:
                    body = content[end + 4:]

            st.markdown(body)

            dl_col, _ = st.columns([1, 3])
            dl_col.download_button(
                "⬇ Download",
                content,
                file_name=note_file.name,
                mime="text/markdown",
                key=f"dl_{selected_week}",
            )
        else:
            st.warning(f"File not found: {note_file.name}")

st.divider()

# ── This week live preview ─────────────────────────────────────────────────────
st.subheader("This Week — Live Stats Preview")

this_monday = today - timedelta(days=today.weekday())
df_week     = _load_week_trades(this_monday, today)
k           = _kpis(df_week)

if not df_week.empty:
    p1, p2, p3, p4, p5 = st.columns(5)
    p1.metric("Trades",      k.get("total", 0))
    p2.metric("Win Rate",    pct(k.get("wr")))
    p3.metric("Net PnL",     usd(k.get("net")))
    p4.metric("Best EA",     _best_ea(df_week))
    p5.metric("Best Session",_best_session(df_week))

    # Running equity this week
    df_week_sorted = df_week.sort_values("open_time")
    df_week_sorted["cum_pnl"] = df_week_sorted["pnl_usd"].cumsum()

    fig_week = go.Figure(go.Scatter(
        x=df_week_sorted["open_time"],
        y=df_week_sorted["cum_pnl"],
        mode="lines+markers",
        line=dict(color=C_WIN if k.get("net", 0) >= 0 else C_LOSS, width=2),
        fill="tozeroy",
        fillcolor="rgba(38,166,154,0.10)" if k.get("net", 0) >= 0 else "rgba(239,83,80,0.10)",
        marker=dict(size=4),
        hovertemplate="%{x|%H:%M}<br>Cum PnL: $%{y:,.2f}<extra></extra>",
    ))
    fig_week.add_hline(y=0, line_color="#546e7a", line_width=1)
    fig_week.update_layout(
        height=260,
        title=f"Running equity — week of {this_monday}",
        xaxis=dict(gridcolor="#1e2130"),
        yaxis=dict(title="Cum PnL (USD)", gridcolor="#1e2130"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=40, b=0),
    )
    st.plotly_chart(fig_week, use_container_width=True)

    # Mistakes this week
    mistakes = _top_mistakes(df_week)
    if mistakes:
        st.markdown("**Top mistakes this week:** " + "  ·  ".join(
            f"`{m}`" for m in mistakes
        ))
else:
    st.info(f"No trades recorded this week ({this_monday} → {today}).")

st.divider()

# ── Obsidian open button ───────────────────────────────────────────────────────
st.subheader("Open in Obsidian")
vault_name = BASE_DIR.name  # "EA-Knowledge-Base"
obsidian_url = f"obsidian://open?vault={vault_name}&file=10_Research%2F13_Weekly_Reviews"
st.link_button(
    "Open 13_Weekly_Reviews in Obsidian",
    obsidian_url,
)
st.caption(
    "Obsidian must be running with the EA-Knowledge-Base vault open. "
    "Fill in the qualitative sections after the dashboard populates the stats."
)
