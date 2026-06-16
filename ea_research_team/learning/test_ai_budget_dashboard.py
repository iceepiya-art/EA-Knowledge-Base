from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DASHBOARD = ROOT / "00_Dashboard" / "EA_Knowledge_Brain_Dashboard.html"


def test_dashboard_contains_ai_budget_panel_and_footer_status():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="ai-budget-panel"' in html
    assert 'id="ai-budget-used"' in html
    assert 'id="ai-budget-left"' in html
    assert 'id="ai-budget-footer"' in html
    assert "/api/learning/ai-budget" in html


def test_dashboard_contains_ai_budget_details_target():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="ai-budget-details-panel"' in html
    assert 'id="ai-budget-details-body"' in html
    assert "showAIBudgetDetails()" in html
    assert "renderAIBudgetDetails(data)" in html


def test_dashboard_ai_budget_save_soon_uses_warning_treatment():
    html = DASHBOARD.read_text(encoding="utf-8")
    color_start = html.index("function aiBudgetColor(status)")
    color_block = html[color_start:html.index("function aiBudgetBadgeClass", color_start)]
    badge_start = html.index("function aiBudgetBadgeClass(status)")
    badge_block = html[badge_start:html.index("function renderAIBudget", badge_start)]

    assert "status === 'save_soon'" in color_block
    assert "return 'var(--yellow)'" in color_block
    assert "status === 'save_soon'" in badge_block
    assert "return 'badge b-yellow'" in badge_block


def test_dashboard_ai_budget_details_render_includes_operational_fields():
    html = DASHBOARD.read_text(encoding="utf-8")
    render_start = html.index("function renderAIBudgetDetails(data)")
    render_block = html[render_start:html.index("async function showAIBudgetDetails", render_start)]

    assert "data.daily_budget_units" in render_block
    assert "data.used_units" in render_block
    assert "data.warning_percent" in render_block
    assert "data.hard_stop_percent" in render_block
    assert "data.usage_log_path" in render_block
    assert "fallback.local_llm_lightwork" in render_block
    assert "fallback.local_whisper" in render_block
    assert "fallback.keyword_extraction" in render_block
    assert "providerRows" in render_block


def test_dashboard_ai_budget_details_button_opens_settings_and_scrolls_panel():
    html = DASHBOARD.read_text(encoding="utf-8")
    show_start = html.index("async function showAIBudgetDetails()")
    show_block = html[show_start:html.index("async function refreshAIBudget", show_start)]

    assert "showPage('settings')" in show_block
    assert "window._lastAIBudget || await refreshAIBudget()" in show_block
    assert "renderAIBudgetDetails(data)" in show_block
    assert "scrollIntoView" in show_block


def test_dashboard_ai_budget_default_providers_include_lm_studio():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "LM Studio" in html


def test_dashboard_loads_ai_budget_on_initial_page_load():
    html = DASHBOARD.read_text(encoding="utf-8")
    init_start = html.index("document.addEventListener('DOMContentLoaded'")
    init_block = html[init_start:html.index("// Check YouTube status", init_start)]

    assert "refreshAIBudget()" in init_block
    assert "setInterval(refreshAIBudget" in html


def test_dashboard_contains_research_assistant_panel():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="research-assistant-panel"' in html
    assert 'id="research-stage"' in html
    assert 'id="research-next-action"' in html
    assert "/api/learning/research-state" in html


def test_dashboard_loads_research_state_on_refresh_and_initial_page_load():
    html = DASHBOARD.read_text(encoding="utf-8")
    refresh_start = html.index("async function refreshAll()")
    refresh_block = html[refresh_start:html.index("async function fetchDownloadStatus", refresh_start)]
    init_start = html.index("document.addEventListener('DOMContentLoaded'")
    init_block = html[init_start:html.index("// Check YouTube status", init_start)]

    assert "refreshResearchState()" in refresh_block
    assert "refreshResearchState()" in init_block


def test_dashboard_contains_parallel_agent_panel():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="parallel-agent-panel"' in html
    assert 'id="parallel-agent-badge"' in html
    assert 'id="parallel-agent-list"' in html
    assert "/api/learning/parallel-agent-status" in html


def test_dashboard_renders_parallel_agent_reports_on_refresh_and_initial_load():
    html = DASHBOARD.read_text(encoding="utf-8")
    render_start = html.index("function renderParallelAgentStatus(data)")
    render_block = html[render_start:html.index("async function refreshParallelAgentStatus", render_start)]
    refresh_start = html.index("async function refreshAll()")
    refresh_block = html[refresh_start:html.index("async function fetchDownloadStatus", refresh_start)]
    init_start = html.index("document.addEventListener('DOMContentLoaded'")
    init_block = html[init_start:html.index("// Check YouTube status", init_start)]

    assert "data.reports" in render_block
    assert "data.safe_to_execute" in render_block
    assert "data.blocking_reason" in render_block
    assert "report.recommendation" in render_block
    assert "refreshParallelAgentStatus()" in refresh_block
    assert "refreshParallelAgentStatus()" in init_block
    assert "setInterval(refreshParallelAgentStatus" in html


def test_dashboard_contains_startup_connection_gate_rows():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="manager-status"' in html
    assert 'id="api-status"' in html
    assert 'id="obsidian-status"' in html
    assert 'id="conflict-status"' in html
    assert 'id="knowledge-status"' in html
    assert 'id="yt-status"' in html
    assert 'id="telegram-status"' in html


def test_dashboard_runs_startup_connection_gate_before_initial_load():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "async function runStartupConnectionGate()" in html
    gate_start = html.index("async function runStartupConnectionGate()")
    gate_block = html[gate_start:html.index("async function loadStatus", gate_start)]
    assert "/api/manager/status" in gate_block
    assert "/api/learning/status" in gate_block
    assert "/api/learning/youtube-status" in gate_block
    assert "/api/learning/telegram-status" in gate_block
    assert "All Systems Operational" in gate_block

    init_start = html.index("document.addEventListener('DOMContentLoaded'")
    init_block = html[init_start:html.index("// Check YouTube status", init_start)]
    assert "await runStartupConnectionGate()" in init_block
    assert init_block.index("await runStartupConnectionGate()") < init_block.index("await loadStatus()")


def test_dashboard_contains_ea_registry_nav_and_page():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "showPage('ea-registry')" in html
    assert 'id="page-ea-registry"' in html
    assert 'id="ea-registry-form"' in html
    assert 'id="ea-registry-table-body"' in html
    assert 'id="ea-registry-total"' in html


def test_dashboard_ea_registry_wires_api_and_submit_flow():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/eas" in html
    assert "async function loadEARegistry()" in html
    assert "function renderEARegistry(items)" in html
    assert "async function submitEARegistry(event)" in html
    assert "loadEARegistry()" in html[html.index("function showPage"):html.index("function updateClock")]


def test_dashboard_contains_per_ea_detail_panel_on_ea_registry_page():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="ea-detail-panel"' in html
    assert 'id="ea-detail-title"' in html
    assert 'id="ea-detail-decision-total"' in html
    assert 'id="ea-detail-win-rate"' in html
    assert 'id="ea-detail-decision-trade-ratio"' in html
    assert 'id="ea-detail-blade-health"' in html
    assert 'id="ea-detail-command-allowed"' in html
    assert 'id="ea-detail-body"' in html


def test_dashboard_per_ea_detail_wires_api_and_row_action():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/eas/${encodeURIComponent(eaId)}/detail" in html
    assert "async function loadEADetail(eaId)" in html
    assert "function renderEADetail(data)" in html
    render_start = html.index("function renderEARegistry(items)")
    render_block = html[render_start:html.index("async function loadEARegistry", render_start)]
    assert "loadEADetail" in render_block


def test_dashboard_ea_detail_renders_connected_trade_stats():
    html = DASHBOARD.read_text(encoding="utf-8")

    render_start = html.index("function renderEADetail(data)")
    render_block = html[render_start:html.index("async function loadEADetail", render_start)]
    assert "trade.source === 'not_connected' ? 'Trades not connected' : 'Trade Records'" in render_block
    assert "trade.win_rate == null ? '—' : `${trade.win_rate}%`" in render_block
    assert "trade.net_pnl == null ? '—' : trade.net_pnl" in render_block
    assert "trade.total_trades ?? 0" in render_block
    assert "trade.wins ?? 0" in render_block
    assert "trade.losses ?? 0" in render_block


def test_dashboard_ea_detail_renders_decision_to_trade_comparison():
    html = DASHBOARD.read_text(encoding="utf-8")

    render_start = html.index("function renderEADetail(data)")
    render_block = html[render_start:html.index("async function loadEADetail", render_start)]
    assert "performance_comparison" in render_block
    assert "ea-detail-decision-trade-ratio" in render_block
    assert "ea-detail-blade-health" in render_block
    assert "ea-detail-command-allowed" in render_block
    assert "comparison.summary_label" in render_block


def test_dashboard_contains_market_battlefield_and_mission_control_panels():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="market-battlefield-panel"' in html
    assert 'id="market-battlefield-body"' in html
    assert 'id="mission-control-panel"' in html
    assert 'id="mission-control-body"' in html
    assert 'id="today-command-summary-panel"' in html
    assert 'id="today-command-decisions"' in html
    assert 'id="today-command-trades"' in html
    assert 'id="today-command-net-pnl"' in html
    assert 'id="today-command-blade-health"' in html


def test_dashboard_market_battlefield_wires_existing_read_only_data():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "async function loadCommandDashboard()" in html
    assert "function renderMarketBattlefield" in html
    assert "function renderMissionControl" in html
    assert "function renderTodayCommandSummary" in html
    assert "/api/trading/eas/${encodeURIComponent(item.ea_id)}/detail" in html
    assert "/api/trading/blade/intents" in html
    assert "/api/trading/commands/state" in html
    assert "order_send false" in html
    assert "loadCommandDashboard(data.items || [])" in html


def test_dashboard_contains_operator_readiness_panel():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="operator-readiness-panel"' in html
    assert 'id="operator-readiness-ready"' in html
    assert 'id="operator-readiness-api"' in html
    assert 'id="operator-readiness-trade-records"' in html
    assert 'id="operator-readiness-blade"' in html
    assert 'id="operator-readiness-body"' in html


def test_dashboard_operator_readiness_wires_api_and_refresh():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/operator-readiness" in html
    assert "/api/trading/operator-readiness/export" in html
    assert "async function loadOperatorReadiness()" in html
    assert "async function exportOperatorReadinessReport()" in html
    assert "function renderOperatorReadiness" in html
    assert "loadOperatorReadiness()" in html[html.index("function showPage"):html.index("function updateClock")]


def test_dashboard_contains_pre_live_checklist_gate():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="pre-live-checklist-ready"' in html
    assert 'id="pre-live-checklist-live"' in html
    assert 'id="pre-live-checklist-order-send"' in html
    assert 'id="pre-live-checklist-body"' in html
    assert "/api/trading/pre-live-checklist" in html
    assert "async function loadPreLiveChecklist()" in html
    assert "function renderPreLiveChecklist" in html
    assert "loadPreLiveChecklist()" in html[html.index("function showPage"):html.index("function updateClock")]


def test_dashboard_contains_decision_journal_panel_on_ea_registry_page():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="decision-journal-total"' in html
    assert 'id="decision-journal-veto"' in html
    assert 'id="decision-journal-risk-rejected"' in html
    assert 'id="decision-journal-body"' in html


def test_dashboard_decision_journal_wires_api_and_refresh():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/decisions" in html
    assert "/api/trading/decision-stats" in html
    assert "async function loadDecisionJournal()" in html
    assert "function renderDecisionJournal" in html
    assert "loadDecisionJournal()" in html[html.index("function showPage"):html.index("function updateClock")]


def test_dashboard_contains_blade_intent_panel_on_ea_registry_page():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="blade-intent-panel"' in html
    assert 'id="blade-intent-total"' in html
    assert 'id="blade-intent-last"' in html
    assert 'id="blade-intent-rejected"' in html
    assert 'id="blade-intent-blocked"' in html
    assert 'id="blade-intent-filter-ea"' in html
    assert 'id="blade-intent-body"' in html


def test_dashboard_blade_intents_wire_api_and_refresh():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/blade/intents" in html
    assert "/api/trading/blade/dry-run" in html
    assert "async function loadBladeIntents()" in html
    assert "function renderBladeIntents" in html
    assert "populateBladeIntentFilter" in html
    assert "blade-intent-filter-ea" in html
    assert "status === 'rejected'" in html
    assert "status === 'blocked'" in html
    assert "async function createBladeDryRunIntentFromDecision" in html
    show_block = html[html.index("function showPage"):html.index("function updateClock")]
    assert "loadBladeIntents()" in show_block


def test_dashboard_decision_journal_has_blade_dry_run_action():
    html = DASHBOARD.read_text(encoding="utf-8")
    render_start = html.index("function renderDecisionJournal")
    render_block = html[render_start:html.index("async function loadDecisionJournal", render_start)]

    assert "createBladeDryRunIntentFromDecision" in render_block
    assert "risk_gate?.approved === true" in render_block
    assert "BLADE" in render_block


def test_dashboard_contains_risk_gate_panel_on_ea_registry_page():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="risk-gate-state"' in html
    assert 'id="risk-gate-global-kill"' in html
    assert 'id="risk-gate-ea-kills"' in html
    assert 'id="risk-gate-limits"' in html


def test_dashboard_risk_gate_wires_state_api_and_refresh():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/risk/state" in html
    assert "async function loadRiskGateState()" in html
    assert "function renderRiskGateState" in html
    assert "loadRiskGateState()" in html[html.index("function showPage"):html.index("function updateClock")]


def test_dashboard_contains_command_center_panel_on_ea_registry_page():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert 'id="command-center-state"' in html
    assert 'id="command-global-mode"' in html
    assert 'id="command-global-kill"' in html
    assert 'id="command-history-body"' in html


def test_dashboard_command_center_wires_state_api_and_dispatch():
    html = DASHBOARD.read_text(encoding="utf-8")

    assert "/api/trading/commands/state" in html
    assert "/api/trading/commands" in html
    assert "async function loadCommandState()" in html
    assert "function renderCommandState" in html
    assert "async function dispatchTradingCommand" in html
    show_block = html[html.index("function showPage"):html.index("function updateClock")]
    assert "loadCommandState()" in show_block
