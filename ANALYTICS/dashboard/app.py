"""
app.py — QTrade OS Dashboard home page.

Run from the EA-Knowledge-Base root:
  py -3.14 -m streamlit run ANALYTICS/dashboard/app.py --server.port 5055
"""

import sys
import os

# Add core to path so pages can import utils and performance
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st

st.set_page_config(
    page_title="QTrade OS",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.markdown("""
<style>
[data-testid="metric-container"] {
    background: #1e2130;
    border: 1px solid #2d3147;
    border-radius: 8px;
    padding: 12px 16px;
}
[data-testid="metric-container"] label { color: #8892b0 !important; font-size: 0.78rem; }
[data-testid="stMetricValue"]          { font-size: 1.5rem !important; }
.stDataFrame                           { font-size: 0.82rem; }
</style>
""", unsafe_allow_html=True)

from utils import load_trades, pct, usd, num

st.title("📊 QTrade OS")
st.caption("AI-Assisted Quantitative Trading Operating System")
st.divider()

df = load_trades()

if df.empty:
    st.warning(
        "**No trade data found.**  \n"
        "Run **IMPORT_TRADES.bat** to import your existing trades, then refresh this page."
    )
else:
    from performance import compute_kpis
    k = compute_kpis(df)

    c1, c2, c3, c4, c5 = st.columns(5)
    c1.metric("Total Trades",   f"{k['total_trades']:,}")
    c2.metric("Win Rate",       pct(k["win_rate"]))
    c3.metric("Profit Factor",  num(k["profit_factor"]) if k["profit_factor"] else "∞")
    c4.metric("Expectancy",     usd(k["expectancy"]))
    c5.metric("Net PnL",        usd(k["net_pnl"]))

st.divider()
st.markdown("""
### Pages

| Page | When to use |
|---|---|
| 📈 **Overview**     | Every day — equity curve, monthly PnL, recent trades |
| 🎯 **Edge**         | Weekly — which regime/session has real edge |
| 🧠 **Behavior**     | Weekly — which mistake costs the most |
| 🛡️ **Risk Monitor** | Before every session — daily limit, streak, alerts |
| 🏷 **Annotate** | After trading — tag execution quality, mistakes, and context |
| 🔍 **Trade Detail** | Deep review — link screenshots, notes, and research |
| 🤖 **EA Overview** | Portfolio view — EA cards, equity, registry |
| 🏆 **Leaderboard** | Compare EAs — rank score, expectancy, win rate |
| ⚠️ **EA Risk** | Risk review — drawdown, VaR, Kelly, streaks |
| 🔗 **Correlation** | Portfolio construction — EA correlation and diversification |
| ⏰ **Session** | Timing edge — EA x session and hour-of-day behavior |
| 💱 **Pairs** | Symbol edge — EA x symbol, regime, direction |
| 📚 **Research Intelligence** | Export analytics into Obsidian strategy knowledge |
| 🧪 **Research Ideas** | Ingest YouTube, articles, PDFs, EA docs, and testable ideas |
| 🧬 **Hypotheses** | Track research → evidence pipeline, promote to validated edges |
| 📅 **Weekly Review** | Auto-generate weekly stat summaries, export to Obsidian |
| 📥 **Research Inbox** | Paste NotebookLM links · auto-classify · generate hypothesis drafts |
| 📚 **Research Library** | Browse all ingested research by category · search · link to strategy |
| 🔬 **Hypothesis Queue** | Research → hypothesis conversion pipeline · one-click workflow |
| 📊 **Validation Tracker** | Statistical validation progress · confidence scores · edge health |
| 🔬 **Research Pipeline** | Learning Arena → QTrade import · full pipeline funnel · traceability chain |
| 📚 **Principle Library** | Mindset principles · mental models · danger flag scanner |
| 📐 **Research Standards** | Research & engineering standards tracker · AI workflow checklist |
| 🕸️ **Knowledge Graph** | Strategy/regime/concept relationships · intelligence queries · build links |
| ⚠️ **Contradiction Scanner** | Reasoning health · contradiction detector · weak evidence · duplicates |
| 🛡️ **Risk Principle Matrix** | Strategy × regime matrix · risk rule coverage · behavior impact |

← Select a page from the sidebar to begin.
""")

st.divider()
st.caption(
    f"Database: `DATA/processed/trades.sqlite`  |  "
    f"Trades loaded: {len(df):,}  |  "
    f"Last updated: refresh page to reload"
)
