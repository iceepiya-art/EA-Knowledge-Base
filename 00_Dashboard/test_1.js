
  // ──────────────────────────────────────────────────────────────────────────
  // CONFIG
  // ──────────────────────────────────────────────────────────────────────────
  const API_BASE = 'http://127.0.0.1:5000';
  const MANAGER_BASE = 'http://127.0.0.1:5050';
  let apiReachable = false;

  // ──────────────────────────────────────────────────────────────────────────
  // API HELPER
  // ──────────────────────────────────────────────────────────────────────────
  async function apiFetch(method, path, body) {
    const resp = await fetch(API_BASE + path, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: body != null ? JSON.stringify(body) : undefined,
    });
    const data = await resp.json().catch(() => ({ error: 'Invalid JSON response' }));
    if (!resp.ok) throw new Error(data.error || `HTTP ${resp.status}`);
    return data;
  }

  async function managerFetch(method, path) {
    const resp = await fetch(MANAGER_BASE + path, {
      method,
      headers: { 'Content-Type': 'application/json' },
    });
    const data = await resp.json().catch(() => ({ error: 'Invalid JSON response' }));
    if (!resp.ok) throw new Error(data.error || `HTTP ${resp.status}`);
    return data;
  }

  function escapeHtml(value) {
    return String(value ?? '').replace(/[&<>"']/g, ch => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[ch]));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // TOAST
  // ──────────────────────────────────────────────────────────────────────────
  function toast(type, msg, duration = 4000) {
    const el = document.createElement('div');
    el.className = `toast ${type}`;
    el.textContent = msg;
    document.getElementById('toast-container').appendChild(el);
    setTimeout(() => el.remove(), duration);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // LOADING STATE FOR BUTTONS
  // ──────────────────────────────────────────────────────────────────────────
  function setLoading(btnId, loading) {
    const btn = document.getElementById(btnId);
    if (!btn) return;
    btn.classList.toggle('loading', loading);
  }

  function setStepStatus(stepId, text, color) {
    const el = document.getElementById(stepId);
    if (!el) return;
    el.textContent = text;
    el.style.color = color || 'var(--green)';
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STATUS — GET /api/learning/status
  // ──────────────────────────────────────────────────────────────────────────
  let _lastStatus = null;
  let progressChartInstance = null;

  async function loadStatus() {
    try {
      const data = await apiFetch('GET', '/api/learning/status');
      _lastStatus = data;

      // KPI cards
      document.getElementById('kpi-channels').textContent    = data.channels.total;
      document.getElementById('kpi-total').textContent       = data.videos.total.toLocaleString();
      document.getElementById('kpi-learned').textContent     = data.videos.learned.toLocaleString();
      document.getElementById('kpi-needs-check').textContent = data.videos.needs_check;
      document.getElementById('kpi-concepts').textContent    = data.concepts_written;
      document.getElementById('kpi-confidence').textContent  = data.concepts.avg_confidence
        ? data.concepts.avg_confidence + '%'
        : '—';

      // Intake progress nodes
      document.getElementById('prog-total').textContent      = data.videos.total;
      document.getElementById('prog-learned').textContent    = data.videos.learned;
      document.getElementById('prog-written').textContent    = data.videos.learned;
      document.getElementById('prog-needs-check').textContent= data.videos.needs_check;
      document.getElementById('prog-failed').textContent     = data.videos.failed;
      document.getElementById('prog-concepts').textContent   = data.concepts.total;
      document.getElementById('prog-notes').textContent      = data.concepts_written;

      // Update Chart.js
      const chartCanvas = document.getElementById('progressChart');
      if (chartCanvas) {
        const chartData = [
          data.videos.learned,
          data.videos.needs_check,
          data.videos.failed,
          Math.max(0, data.videos.total - data.videos.learned - data.videos.needs_check - data.videos.failed)
        ];
        
        if (!progressChartInstance) {
          progressChartInstance = new Chart(chartCanvas, {
            type: 'doughnut',
            data: {
              labels: ['Done', 'Needs Check', 'Failed', 'Pending'],
              datasets: [{
                data: chartData,
                backgroundColor: [
                  'rgba(74, 222, 128, 0.8)', // green
                  'rgba(250, 204, 21, 0.8)', // yellow
                  'rgba(248, 113, 113, 0.8)', // red
                  'rgba(56, 189, 248, 0.3)'  // faint blue
                ],
                borderWidth: 0,
                hoverOffset: 4
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              cutout: '70%',
              plugins: {
                legend: { display: false },
                tooltip: {
                  backgroundColor: 'rgba(15, 23, 42, 0.9)',
                  titleColor: '#f8fafc',
                  bodyColor: '#94a3b8',
                  borderColor: 'rgba(255,255,255,0.1)',
                  borderWidth: 1
                }
              }
            }
          });
        } else {
          progressChartInstance.data.datasets[0].data = chartData;
          progressChartInstance.update();
        }
      }

      // Loop stats
      document.getElementById('loop-concepts').textContent   = data.concepts_written + ' Notes';
      document.getElementById('loop-videos').textContent     = data.videos.total + ' Videos';
      document.getElementById('loop-learned').textContent    = data.videos.learned + ' Learned';
      document.getElementById('loop-channels').textContent   = data.channels.total + ' Tracked';
      document.getElementById('loop-confidence').textContent = (data.concepts.avg_confidence || '—') + '%';

      // EA Rules count (new)
      const eaRulesEl = document.getElementById('kpi-ea-rules');
      if (eaRulesEl) eaRulesEl.textContent = (data.ea_rules ?? 0).toLocaleString();
      // Conflict & Blueprint stats (new)
      const conflictResEl = document.getElementById('conflict-resolved-count');
      const conflictPendEl = document.getElementById('conflict-pending-count');
      const blueprintBadge = document.getElementById('blueprint-status-badge');
      const blueprintText = document.getElementById('blueprint-status-text');

      if (conflictResEl && data.conflicts) conflictResEl.textContent = (data.conflicts.resolved ?? 0).toLocaleString();
      if (conflictPendEl && data.conflicts) conflictPendEl.textContent = (data.conflicts.pending ?? 0).toLocaleString();
      
      if (blueprintBadge) {
        const isReady = data.blueprint_ready;
        blueprintBadge.textContent = isReady ? 'READY' : 'BUILDING';
        blueprintBadge.className = 'badge b-' + (isReady ? 'green' : 'yellow');
        if (blueprintText) {
          blueprintText.textContent = isReady ? 'MQL5 Master Blueprint is ready for deployment' : 'Collecting rules for Blueprint generation';
          blueprintText.style.color = isReady ? 'var(--green)' : 'var(--yellow)';
        }
      }


      // API status indicator
      setApiOnline(true);

      // Render merge/knowledge list
      renderMergeList(data);

    } catch (e) {
      setApiOnline(false);
      console.error('loadStatus error:', e);
    }
  }

  function setApiOnline(online) {
    apiReachable = !!online;
    document.getElementById('api-dot').style.color = online ? 'var(--green)' : 'var(--red)';
    document.getElementById('api-status').textContent = online ? 'Online' : 'Offline';
    document.getElementById('api-status').style.color = online ? 'var(--green)' : 'var(--red)';
    document.getElementById('api-status-text').textContent = online ? 'All Systems Operational' : 'Cannot reach 127.0.0.1:5000';
    
    ['obsidian-status', 'conflict-status', 'knowledge-status'].forEach(id => {
       const el = document.getElementById(id);
       if (el) {
          el.textContent = online ? 'Online' : 'Offline';
          el.style.color = online ? 'var(--green)' : 'var(--red)';
       }
    });
  }

  function setManagerOnline(online, data = {}) {
    const mgr = document.getElementById('manager-status');
    const server = document.getElementById('server-control-status');
    const startBtn = document.getElementById('btn-server-start');
    const restartBtn = document.getElementById('btn-server-restart');
    const stopBtn = document.getElementById('btn-server-stop');
    if (mgr) {
      mgr.textContent = online ? 'Online' : 'Offline';
      mgr.style.color = online ? 'var(--green)' : 'var(--red)';
    }
    const apiOnline = !!data.api_online;
    const managed = !!data.managed;
    if (server) {
      server.textContent = !online ? (apiOnline ? 'External API' : 'No Manager') : apiOnline ? (managed ? 'Managed' : 'External') : 'Stopped';
      server.style.color = !online ? (apiOnline ? 'var(--green)' : 'var(--red)') : apiOnline ? 'var(--green)' : 'var(--yellow)';
    }
    if (startBtn) startBtn.disabled = !online || apiOnline;
    if (restartBtn) restartBtn.disabled = !online || (apiOnline && !managed);
    if (stopBtn) stopBtn.disabled = !online || !managed;
  }

  async function loadManagerStatus() {
    try {
      const data = await managerFetch('GET', '/api/manager/status');
      setManagerOnline(true, data);
      return data;
    } catch (e) {
      setManagerOnline(false, { api_online: apiReachable, managed: false });
      return null;
    }
  }

  async function startServer() {
    setLoading('btn-server-start', true);
    try {
      const data = await managerFetch('POST', '/api/manager/start');
      toast('success', data.api_online ? 'Server started' : 'Start requested, waiting for API');
      await new Promise(r => setTimeout(r, 1000));
      await refreshAll();
    } catch (e) {
      toast('error', `Start failed: ${e.message}. Run python ea_research_team/learning/server_manager.py first.`);
    } finally {
      setLoading('btn-server-start', false);
      loadManagerStatus();
    }
  }

  async function stopServer() {
    setLoading('btn-server-stop', true);
    try {
      await managerFetch('POST', '/api/manager/stop');
      toast('info', 'Server stopped');
      setApiOnline(false);
      await loadManagerStatus();
    } catch (e) {
      toast('error', `Stop failed: ${e.message}`);
    } finally {
      setLoading('btn-server-stop', false);
    }
  }

  async function restartServer() {
    setLoading('btn-server-restart', true);
    try {
      const data = await managerFetch('POST', '/api/manager/restart');
      toast('success', data.start?.api_online ? 'Server restarted' : 'Restart requested, waiting for API');
      await new Promise(r => setTimeout(r, 1200));
      await refreshAll();
    } catch (e) {
      toast('error', `Restart failed: ${e.message}`);
    } finally {
      setLoading('btn-server-restart', false);
      loadManagerStatus();
    }
  }

  async function checkYouTubeStatus() {
    const el = document.getElementById('yt-status');
    if (!el) return;
    try {
      const res = await fetch(`${API_BASE}/api/learning/youtube-status`);
      const data = await res.json();
      if (data.status === 'ok') {
        el.textContent = 'Online';
        el.style.color = 'var(--green)';
        showToast('YouTube unblocked! Ready to learn new videos.', 'success');
      } else if (data.status === 'blocked') {
        el.textContent = 'Blocked';
        el.style.color = 'var(--red)';
      } else {
        el.textContent = 'Error';
        el.style.color = 'var(--yellow)';
      }
    } catch {
      el.textContent = 'N/A';
      el.style.color = '#666';
    }
  }

  async function checkTelegramStatus() {
    const el = document.getElementById('telegram-status');
    if (!el) return;
    try {
      const res = await fetch(`${API_BASE}/api/learning/telegram-status`);
      const data = await res.json();
      if (data.status === 'ok') {
        el.textContent = 'Online';
        el.style.color = 'var(--green)';
      } else if (data.status === 'unconfigured') {
        el.textContent = 'Unconfigured';
        el.style.color = 'var(--muted)';
      } else {
        el.textContent = 'Offline';
        el.style.color = 'var(--red)';
      }
    } catch {
      el.textContent = 'N/A';
      el.style.color = '#666';
    }
  }

  let _lastResearchState = null;

  function researchQualityClass(status) {
    if (status === 'pass') return 'badge b-green';
    if (status === 'blocked') return 'badge b-red';
    return 'badge b-yellow';
  }

  function renderResearchState(data) {
    _lastResearchState = data;
    const readiness = Math.max(0, Math.min(100, Number(data.readiness_percent || 0)));
    const quality = data.quality_gate || {};
    const metrics = data.metrics || {};
    const videos = metrics.videos || {};
    const concepts = metrics.concepts || {};
    const conflicts = metrics.conflicts || {};
    const components = metrics.components || {};
    const action = data.recommended_action || {};

    const meter = document.getElementById('research-meter');
    const readinessEl = document.getElementById('research-readiness');
    const stageEl = document.getElementById('research-stage');
    const nextEl = document.getElementById('research-next-action');
    const qualityEl = document.getElementById('research-quality');
    const blockersEl = document.getElementById('research-blockers');
    const actionBtn = document.getElementById('research-action-btn');

    const color = quality.status === 'blocked' ? 'var(--red)' : quality.status === 'pass' ? 'var(--green)' : 'var(--yellow)';
    if (meter) {
      meter.style.setProperty('--research-ready', `${readiness}%`);
      meter.style.background = `radial-gradient(circle closest-side, rgba(17,24,39,0.96) 68%, transparent 70%), conic-gradient(${color} 0 ${readiness}%, rgba(148,163,184,0.18) ${readiness}% 100%)`;
    }
    if (readinessEl) readinessEl.textContent = `${readiness}%`;
    if (stageEl) stageEl.textContent = data.stage?.label || 'Research State';
    if (nextEl) nextEl.textContent = action.label ? `Next: ${action.label}` : 'Next action ready';
    if (qualityEl) {
      qualityEl.textContent = quality.label || 'Needs Review';
      qualityEl.className = researchQualityClass(quality.status);
    }
    if (actionBtn) actionBtn.innerHTML = `<i data-lucide="sparkles"></i> ${escapeHtml(action.command || 'Next Action')}`;

    const setText = (id, value) => {
      const el = document.getElementById(id);
      if (el) el.textContent = value;
    };
    setText('research-evidence', `${videos.learned || 0}/${videos.total || 0}`);
    setText('research-concepts', `${concepts.total || 0}`);
    setText('research-conflicts', `${conflicts.pending || 0} pending`);
    setText('research-rules', `${components.total_rules || 0}`);

    const blockers = Array.isArray(quality.blockers) ? quality.blockers : [];
    if (blockersEl) {
      blockersEl.innerHTML = blockers.length
        ? blockers.slice(0, 4).map((item) => `<div>${escapeHtml(item)}</div>`).join('')
        : '<div style="border-left-color:rgba(34,197,94,0.75)">No blocking research issues detected.</div>';
    }
    if (window.lucide) lucide.createIcons();
  }

  async function refreshResearchState() {
    try {
      const data = await apiFetch('GET', '/api/learning/research-state');
      renderResearchState(data);
      return data;
    } catch (e) {
      const stageEl = document.getElementById('research-stage');
      const nextEl = document.getElementById('research-next-action');
      const qualityEl = document.getElementById('research-quality');
      if (stageEl) stageEl.textContent = 'Unavailable';
      if (nextEl) nextEl.textContent = `Cannot read research state: ${e.message}`;
      if (qualityEl) {
        qualityEl.textContent = 'Offline';
        qualityEl.className = 'badge b-red';
      }
      return null;
    }
  }

  function runResearchRecommendedAction() {
    const actionId = _lastResearchState?.recommended_action?.id;
    const handlers = {
      ingest_evidence: () => document.getElementById('universal-input')?.focus(),
      retry_needs_check: () => learnNew(true),
      extract_raw: () => runExtractRaw(),
      merge_knowledge: () => runMergeKnowledge(),
      review_conflicts: () => showPage('graph'),
      write_concepts: () => runWriteConcepts(),
      extract_components: () => runEAComponents(),
      build_blueprint: () => generateBlueprint(),
      review_ea_idea: () => showPage('blueprint'),
    };
    const handler = handlers[actionId];
    if (handler) {
      handler();
    } else {
      toast('info', 'Research state is ready. Refresh if the next action looks stale.');
    }
  }

  function renderParallelAgentStatus(data) {
    const reports = Array.isArray(data?.reports) ? data.reports : [];
    const badge = document.getElementById('parallel-agent-badge');
    const count = document.getElementById('parallel-agent-count');
    const state = document.getElementById('parallel-agent-state');
    const next = document.getElementById('parallel-agent-next');
    const list = document.getElementById('parallel-agent-list');
    const meter = document.getElementById('parallel-agent-meter');
    const safeToExecute = !!data.safe_to_execute;
    const blockingReason = data.blocking_reason || null;
    const hasErrors = reports.some(report => report.status === 'error' || report.status === 'warning');
    const color = hasErrors || !safeToExecute ? 'var(--yellow)' : data?.running ? 'var(--green)' : 'var(--muted)';

    if (badge) {
      badge.textContent = safeToExecute ? 'Ready' : blockingReason ? 'Blocked' : 'Idle';
      badge.className = safeToExecute ? 'badge b-green' : blockingReason ? 'badge b-yellow' : 'badge';
    }
    if (count) count.textContent = `${reports.length}`;
    if (meter) {
      const filled = Math.min(100, reports.length * 25);
      meter.style.background = `radial-gradient(circle closest-side, rgba(17,24,39,0.96) 68%, transparent 70%), conic-gradient(${color} 0 ${filled}%, rgba(148,163,184,0.18) ${filled}% 100%)`;
    }
    if (state) state.textContent = safeToExecute ? 'safe_to_execute' : (blockingReason || data?.status || 'not_started');
    const primary = reports.find(report => report.job === 'diag_runtime_health') || reports[0];
    if (next) next.textContent = blockingReason ? `Blocked: ${blockingReason}` : (primary?.recommendation || 'No advisory reports yet.');
    if (list) {
      list.innerHTML = reports.length
        ? reports.map(report => `
            <div style="border-left-color:${report.status === 'ok' ? 'rgba(34,197,94,0.75)' : 'rgba(245,158,11,0.75)'}">
              <b style="color:var(--text)">${escapeHtml(report.agent || report.job || 'Agent')}</b>
              <span style="color:var(--muted)"> ${escapeHtml(report.summary || '')}</span>
              <div style="color:var(--cyan);margin-top:3px">${escapeHtml(report.recommendation || '')}</div>
            </div>
          `).join('')
        : '<div>No advisory reports yet.</div>';
    }
    if (window.lucide) lucide.createIcons();
  }

  async function refreshParallelAgentStatus() {
    try {
      const data = await apiFetch('GET', '/api/learning/parallel-agent-status');
      renderParallelAgentStatus(data);
      return data;
    } catch (e) {
      const badge = document.getElementById('parallel-agent-badge');
      const state = document.getElementById('parallel-agent-state');
      const next = document.getElementById('parallel-agent-next');
      if (badge) {
        badge.textContent = 'Offline';
        badge.className = 'badge b-red';
      }
      if (state) state.textContent = 'Unavailable';
      if (next) next.textContent = `Cannot read agent reports: ${e.message}`;
      return null;
    }
  }

  function aiBudgetColor(status) {
    if (status === 'stop_heavy') return 'var(--red)';
    if (status === 'save_soon') return 'var(--yellow)';
    return 'var(--green)';
  }

  function aiBudgetBadgeClass(status) {
    if (status === 'stop_heavy') return 'badge b-red';
    if (status === 'save_soon') return 'badge b-yellow';
    return 'badge b-green';
  }

  function renderAIBudget(data) {
    const used = Math.max(0, Math.min(100, Number(data.used_percent || 0)));
    const left = Math.max(0, Math.min(100, Number(data.left_percent ?? (100 - used))));
    const color = aiBudgetColor(data.status);

    const meter = document.getElementById('ai-budget-meter');
    const usedEl = document.getElementById('ai-budget-used');
    const leftEl = document.getElementById('ai-budget-left');
    const recEl = document.getElementById('ai-budget-recommendation');
    const msgEl = document.getElementById('ai-budget-message');
    const providersEl = document.getElementById('ai-budget-providers');
    const footerEl = document.getElementById('ai-budget-footer');
    window._lastAIBudget = data;

    if (meter) {
      meter.style.setProperty('--ai-budget-used', `${used}%`);
      meter.style.background = `radial-gradient(circle closest-side, rgba(17,24,39,0.96) 68%, transparent 70%), conic-gradient(${color} 0 ${used}%, rgba(148,163,184,0.18) ${used}% 100%)`;
    }
    if (usedEl) usedEl.textContent = `${used}%`;
    if (leftEl) {
      leftEl.textContent = `${left}% left`;
      leftEl.className = aiBudgetBadgeClass(data.status);
    }
    if (recEl) {
      recEl.textContent = data.recommendation || 'Continue';
      recEl.style.color = color;
    }
    if (msgEl) msgEl.textContent = data.message || data.mode || 'AI budget status ready.';

    const providers = Array.isArray(data.providers) ? data.providers : [];
    if (providersEl && providers.length) {
      providersEl.innerHTML = providers.map((p) => {
        const pct = Math.max(0, Math.min(100, Number(p.used_percent || 0)));
        const cls = p.id === 'gemini' ? ' gemini' : p.id === 'openrouter' ? ' openrouter' : '';
        const label = escapeHtml(p.label || p.id || 'Provider');
        const suffix = p.configured ? `${pct}%` : 'Missing';
        return `
          <div class="ai-provider-row">
            <div class="ai-provider-name">${label}</div>
            <div class="ai-provider-track"><div class="ai-provider-fill${cls}" style="width:${pct}%"></div></div>
            <div class="ai-provider-percent">${suffix}</div>
          </div>`;
      }).join('');
    }

    if (footerEl) {
      footerEl.innerHTML = `<i class="ai-budget-footer-dot" style="background:${color};box-shadow:0 0 8px ${color}"></i>AI Budget: ${left}% left | ${escapeHtml(data.mode || 'Unknown')} | ${escapeHtml(data.recommendation || 'Continue')}`;
    }
    renderAIBudgetDetails(data);
  }

  function renderAIBudgetDetails(data) {
    const panel = document.getElementById('ai-budget-details-panel');
    if (!panel || !data) return;
    const color = aiBudgetColor(data.status);
    const statusEl = document.getElementById('ai-budget-details-status');
    const dailyEl = document.getElementById('ai-budget-details-daily');
    const usedEl = document.getElementById('ai-budget-details-used');
    const thresholdEl = document.getElementById('ai-budget-details-thresholds');
    const bodyEl = document.getElementById('ai-budget-details-body');

    if (statusEl) {
      statusEl.textContent = `${data.recommendation || 'Continue'} (${data.status || 'continue'})`;
      statusEl.style.color = color;
    }
    if (dailyEl) dailyEl.textContent = `${data.daily_budget_units ?? '-'} units`;
    if (usedEl) usedEl.textContent = `${data.used_units ?? 0} units | ${data.used_percent ?? 0}% used | ${data.left_percent ?? 100}% left`;
    if (thresholdEl) thresholdEl.textContent = `${data.warning_percent ?? 70}% warning / ${data.hard_stop_percent ?? 90}% hard stop`;
    if (bodyEl) {
      const providers = Array.isArray(data.providers) ? data.providers : [];
      const providerRows = providers.map((p) => {
        const providerStatus = p.configured ? (p.status || 'configured') : 'missing';
        const model = p.model ? ` | ${escapeHtml(p.model)}` : '';
        return `${escapeHtml(p.label || p.id || 'Provider')}: ${escapeHtml(providerStatus)} | ${Number(p.used_percent || 0)}%${model}`;
      });
      const fallback = data.fallback || {};
      const fallbackRows = [
        `Local LLM lightwork: ${fallback.local_llm_lightwork ? 'yes' : 'no'}`,
        `Local Whisper: ${fallback.local_whisper ? 'yes' : 'no'}`,
        `Keyword extraction: ${fallback.keyword_extraction ? 'yes' : 'no'}`
      ];
      bodyEl.innerHTML = [
        `Mode: ${escapeHtml(data.mode || 'Unknown')}`,
        `Message: ${escapeHtml(data.message || '')}`,
        `Usage log: ${escapeHtml(data.usage_log_path || '')}`,
        providerRows.length ? `Providers:<br>${providerRows.map(row => `&nbsp;&nbsp;- ${row}`).join('<br>')}` : 'Providers: none reported',
        `Fallback:<br>${fallbackRows.map(row => `&nbsp;&nbsp;- ${row}`).join('<br>')}`
      ].join('<br>');
    }
  }

  async function showAIBudgetDetails() {
    showPage('settings');
    const data = window._lastAIBudget || await refreshAIBudget();
    if (data) renderAIBudgetDetails(data);
    setTimeout(() => {
      const panel = document.getElementById('ai-budget-details-panel');
      if (panel) panel.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 80);
  }

  async function refreshAIBudget() {
    try {
      const data = await apiFetch('GET', '/api/learning/ai-budget');
      renderAIBudget(data);
      return data;
    } catch (e) {
      const recEl = document.getElementById('ai-budget-recommendation');
      const msgEl = document.getElementById('ai-budget-message');
      const footerEl = document.getElementById('ai-budget-footer');
      if (recEl) {
        recEl.textContent = 'Unavailable';
        recEl.style.color = 'var(--red)';
      }
      if (msgEl) msgEl.textContent = `Cannot read AI budget: ${e.message}`;
      if (footerEl) footerEl.innerHTML = '<i class="ai-budget-footer-dot" style="background:var(--red)"></i>AI Budget: unavailable';
      return null;
    }
  }

  function renderMergeList(data) {
    let e = data.extract||{}, m = data.merge||{}, d = data.dedup||{}, w = data.write||{}, c = data.detect||{}, ar = data.auto_resolve||{}, comp = data.ea_components||{}, bp = data.blueprint||{};
    setStepStatus('step-extract',    `${e.written??0} written`, 'var(--green)');
    setStepStatus('step-merge',      `${m.new??0} new`, 'var(--green)');
    setStepStatus('step-dedup',      `${d.removed??0} removed`, 'var(--green)');
    setStepStatus('step-write',      `${w.updated??0} updated`, 'var(--green)');
    setStepStatus('step-detect',     `${c.new??0} new`, 'var(--green)');
    setStepStatus('step-resolve',    `${ar.auto_resolved??0} resolved, ${ar.still_pending??0} pending`, ar.still_pending > 0 ? 'var(--yellow)' : 'var(--green)');
    setStepStatus('step-components', `${comp.total_rules??0} rules`, 'var(--green)');
    setStepStatus('step-blueprint',  bp.ea_readiness ?? 'done', 'var(--green)');
  }

  async function runFullPipeline() {
    setLoading('btn-pipeline', true);
    setLoading('btn-refresh', true);
    const resultEl = document.getElementById('pipeline-result');
    if (resultEl) resultEl.innerHTML = 'Running full pipeline...';
    
    try {
      const data = await apiFetch('POST', '/api/learning/pipeline/run');
      let e = data.extract||{}, m = data.merge||{}, d = data.dedup||{}, w = data.write||{}, c = data.detect||{}, ar = data.auto_resolve||{}, comp = data.ea_components||{}, bp = data.blueprint||{};
      setStepStatus('step-extract',    `${e.written??0} written`, 'var(--green)');
      setStepStatus('step-merge',      `${m.new??0} new`, 'var(--green)');
      setStepStatus('step-dedup',      `${d.removed??0} removed`, 'var(--green)');
      setStepStatus('step-write',      `${w.updated??0} updated`, 'var(--green)');
      setStepStatus('step-detect',     `${c.new??0} new`, 'var(--green)');
      setStepStatus('step-resolve',    `${ar.auto_resolved??0} resolved, ${ar.still_pending??0} pending`, ar.still_pending > 0 ? 'var(--yellow)' : 'var(--green)');
      setStepStatus('step-components', `${comp.total_rules??0} rules`, 'var(--green)');
      setStepStatus('step-blueprint',  bp.ea_readiness ?? 'done', 'var(--green)');
      setStepStatus('step-pipeline',   'Done 8/8', 'var(--green)');
      if (resultEl) resultEl.innerHTML = _pipelineResultHtml(0, 0, data);
      toast('success', 'Pipeline complete — 8/8 steps done!');
      await loadStatus();
      await loadConflicts();
    } catch (err) {
      setStepStatus('step-pipeline', 'Error', 'var(--red)');
      if (resultEl) resultEl.innerHTML = `<span style="color:var(--red)">Error: ${err.message}</span>`;
      toast('error', `Pipeline error: ${err.message}`);
    } finally {
      setLoading('btn-pipeline', false);
      setLoading('btn-refresh', false);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // QUEUE TABLE (from manifest via status — simplified view)
  // ──────────────────────────────────────────────────────────────────────────
  let _queueData = [];

  async function loadQueueTable() {
    const container = document.getElementById('queue-table-container');
    // We re-use status info to render a simplified queue
    try {
      if (!_lastStatus) await loadStatus();
      const v = _lastStatus.videos;
      _queueData = [
        { label: 'Learned (transcript done)', count: v.learned, status: 'raw_evidence_written', badge: 'b-green', badgeText: 'Learned' },
        { label: 'Needs transcript check',    count: v.needs_check, status: 'needs_transcript_check', badge: 'b-yellow', badgeText: 'Needs Check' },
        { label: 'Failed last attempt',       count: v.failed, status: 'failed', badge: 'b-red', badgeText: 'Failed' },
        { label: 'Discovered (queued)',        count: v.discovered, status: 'discovered', badge: 'b-blue', badgeText: 'Queued' },
      ];
      renderQueueTable(_queueData);
    } catch (e) {
      container.innerHTML = `<div class="empty-state" style="color:var(--red)">Error: ${e.message}</div>`;
    }
  }

  function renderQueueTable(rows) {
    const container = document.getElementById('queue-table-container');
    const filter = document.getElementById('queue-filter').value;
    const search = (document.getElementById('queue-search').value || '').toLowerCase();

    const filtered = rows.filter(r => {
      if (filter && r.status !== filter) return false;
      if (search && !r.label.toLowerCase().includes(search)) return false;
      return true;
    });

    if (filtered.length === 0) {
      container.innerHTML = '<div class="empty-state">No matching items.</div>';
      return;
    }

    container.innerHTML = `
      <table>
        <thead><tr><th>Category</th><th>Count</th><th>Status</th></tr></thead>
        <tbody>
          ${filtered.map(r => `
            <tr>
              <td>${r.label}</td>
              <td>${r.count}</td>
              <td><span class="badge ${r.badge}">${r.badgeText}</span></td>
            </tr>`).join('')}
        </tbody>
      </table>`;
  }

  function filterQueue() {
    renderQueueTable(_queueData);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // REFRESH ALL
  // ──────────────────────────────────────────────────────────────────────────
  async function refreshAll() {
    setLoading('btn-refresh', true);
    try {
      checkYouTubeStatus();
      checkTelegramStatus();
      await loadStatus();
      await loadManagerStatus();
      await loadConflicts();
      await loadQueueTable();
      await loadYouTubeSources();
      await refreshResearchState();
      await refreshParallelAgentStatus();
      await refreshAIBudget();
      toast('info', 'Dashboard refreshed');
    } finally {
      setLoading('btn-refresh', false);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PAGE SWITCHING
  // ──────────────────────────────────────────────────────────────────────────
  function showPage(pageId) {
    // hide all pages robustly
    document.querySelectorAll('.page').forEach(p => {
        p.classList.remove('active');
        p.style.display = 'none';
    });
    const target = document.getElementById('page-' + pageId);
    if (target) {
        target.classList.add('active');
        target.style.display = 'block';
    }

    // update nav active state — match by onclick attribute
    document.querySelectorAll('.nav a').forEach(a => {
      a.classList.remove('active');
      const oc = a.getAttribute('onclick') || '';
      if (oc.includes(`showPage('${pageId}')`)) a.classList.add('active');
    });

    // lazy-load page data
    if (pageId === 'graph')      loadKnowledgeGraph();
    if (pageId === 'components') loadEAComponents();
    if (pageId === 'queue')      loadQueueFull();
    if (pageId === 'blueprint')  loadBlueprint();
    if (pageId === 'logbook')    loadLogbook();
    if (pageId === 'backtest')   loadBacktestSummary();
    if (pageId === 'settings') {
      loadCookiesStatus();
      loadEngineStatus();
      loadRemoteInboxStatus();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // QUEUE PAGE — full detail table
  // ──────────────────────────────────────────────────────────────────────────
  async function loadQueueFull() {
    const tbody = document.getElementById('queue-body2');
    if (!tbody) return;
    tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;color:var(--muted)">Loading...</td></tr>';
    try {
      const data = await apiFetch('GET', '/api/learning/manifest');
      const manifest = data.videos || {};
      const rows = Object.entries(manifest);
      if (rows.length === 0) {
        tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;color:var(--muted)">No videos yet.</td></tr>';
        return;
      }
      const filter = (document.getElementById('queue-filter2') || {}).value || '';
      const statusBadge = {
        raw_evidence_written: ['b-green', 'Learned'],
        structured_extracted: ['b-blue', 'Structured'],
        needs_transcript_check: ['b-yellow', 'Needs Check'],
        failed: ['b-red', 'Failed'],
        discovered: ['b-muted', 'Discovered'],
      };
      const filtered = rows.filter(([, v]) => !filter || v.status === filter);
      tbody.innerHTML = filtered.map(([vid, v]) => {
        const [cls, label] = statusBadge[v.status] || ['b-muted', v.status];
        const title = (v.title || vid).replace(/</g, '&lt;');
        return `<tr>
          <td style="font-size:11px;color:var(--muted);font-family:monospace">${vid}</td>
          <td style="max-width:360px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${title}</td>
          <td><span class="badge ${cls}">${label}</span></td>
        </tr>`;
      }).join('');
    } catch (e) {
      tbody.innerHTML = `<tr><td colspan="3" style="color:var(--red)">Error: ${e.message}</td></tr>`;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // KNOWLEDGE GRAPH
  // ──────────────────────────────────────────────────────────────────────────
  async function loadKnowledgeGraph() {
    const body = document.getElementById('graph-body');
    if (!body) return;
    body.innerHTML = '<div class="loading-row"><div class="spinner"></div>Loading...</div>';
    try {
      const data = await apiFetch('GET', '/api/learning/knowledge-index');
      const concepts = data.concepts || {};
      const entries = Object.values(concepts).sort((a, b) => b.confidence - a.confidence);
      if (entries.length === 0) {
        body.innerHTML = '<div class="empty-state">No concepts indexed yet. Run the learning pipeline first.</div>';
        return;
      }
      const readinessColor = { high: 'var(--green)', medium: 'var(--yellow)', low: 'var(--red)' };
      body.innerHTML = `
        <div style="margin-bottom:16px;font-size:12px;color:var(--muted)">
          ${entries.length} concepts indexed &nbsp;·&nbsp;
          Sorted by confidence score
        </div>
        <div style="background:#0d1e2c;border:1px solid #1e3548;border-radius:8px;padding:16px;margin-bottom:24px;height:300px">
          <canvas id="knowledgeChart"></canvas>
        </div>
        <div style="display:flex;flex-direction:column;gap:10px">
          ${entries.map(c => {
            const conf = Math.round(c.confidence || 0);
            const bar = Math.min(100, conf);
            const col = conf >= 70 ? 'var(--green)' : conf >= 40 ? 'var(--yellow)' : 'var(--red)';
            const sources = (c.sources || []).length;
            const ruleTypes = (c.related_rule_types || []).join(', ') || '—';
            return `
              <div style="background:#0d1e2c;border:1px solid #1e3548;border-radius:8px;padding:12px 16px">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
                  <span style="font-weight:600;font-size:13px">${c.concept}</span>
                  <span style="font-size:12px;color:${col};font-weight:600">${conf}%</span>
                </div>
                <div class="conf-bar-wrap" style="height:6px;background:#1e2d3d;border-radius:3px;margin-bottom:8px">
                  <div class="conf-bar" style="width:${bar}%;height:100%;background:${col};border-radius:3px;transition:width .4s"></div>
                </div>
                <div style="display:flex;gap:16px;font-size:11px;color:var(--muted)">
                  <span>Sources: <b style="color:var(--text)">${sources}</b></span>
                  <span>Evidence: <b style="color:var(--text)">${c.evidence_count || 0}</b></span>
                  <span>Rule types: <b style="color:var(--cyan)">${ruleTypes}</b></span>
                </div>
              </div>`;
          }).join('')}
        </div>`;
        
      renderKnowledgeChart(entries);
    } catch (e) {
      body.innerHTML = `<div class="empty-state" style="color:var(--red)">Error: ${e.message}</div>`;
    }
  }

  let _kChart = null;
  function renderKnowledgeChart(entries) {
    const ctx = document.getElementById('knowledgeChart');
    if (!ctx) return;
    if (_kChart) _kChart.destroy();
    
    // Sort top 15 by sources to make chart readable
    const topEntries = [...entries].sort((a,b) => (b.sources||[]).length - (a.sources||[]).length).slice(0, 15);
    const labels = topEntries.map(e => e.concept);
    const dataSources = topEntries.map(e => (e.sources||[]).length);
    const dataScores = topEntries.map(e => Math.round(e.confidence || 0));

    _kChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Sources (Videos)',
            data: dataSources,
            backgroundColor: 'rgba(56, 189, 248, 0.8)',
            yAxisID: 'y'
          },
          {
            label: 'Confidence Score (%)',
            data: dataScores,
            type: 'line',
            borderColor: 'rgba(74, 222, 128, 1)',
            backgroundColor: 'rgba(74, 222, 128, 0.2)',
            borderWidth: 2,
            tension: 0.3,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { labels: { color: '#94a3b8' } }
        },
        scales: {
          x: { ticks: { color: '#94a3b8', maxRotation: 45, minRotation: 45 }, grid: { color: 'rgba(255,255,255,0.05)' } },
          y: { 
            type: 'linear', display: true, position: 'left',
            ticks: { color: '#38bdf8', stepSize: 1 }, 
            grid: { color: 'rgba(255,255,255,0.05)' },
            title: { display: true, text: 'Number of Sources', color: '#94a3b8' }
          },
          y1: { 
            type: 'linear', display: true, position: 'right',
            ticks: { color: '#4ade80' }, grid: { drawOnChartArea: false },
            title: { display: true, text: 'Confidence (%)', color: '#94a3b8' },
            min: 0, max: 100
          }
        }
      }
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // EA COMPONENTS
  // ──────────────────────────────────────────────────────────────────────────
  const COMP_LABELS = { entry: 'Entry', stop_loss: 'Stop Loss', exit: 'Exit / TP', filter: 'Filter', regime: 'Regime' };
  const COMP_COLORS = { entry: 'var(--green)', stop_loss: 'var(--red)', exit: 'var(--cyan)', filter: 'var(--yellow)', regime: 'var(--purple)' };

  async function loadEAComponents() {
    const body = document.getElementById('comp-body');
    const summary = document.getElementById('comp-summary');
    const badge = document.getElementById('comp-readiness-badge');
    if (!body) return;
    body.innerHTML = '<div class="loading-row"><div class="spinner"></div>Loading...</div>';
    try {
      const data = await apiFetch('GET', '/api/learning/ea-components');
      const s = data.summary || {};
      const comps = data.components || {};
      const readiness = s.ea_readiness || 'low';
      const rCol = { high: 'var(--green)', medium: 'var(--yellow)', low: 'var(--red)' }[readiness] || 'var(--muted)';
      if (badge) { badge.textContent = 'EA Readiness: ' + readiness.toUpperCase(); badge.style.color = rCol; badge.style.background = '#0d1e2c'; }
      if (summary) summary.innerHTML = `
        Total rules: <b style="color:var(--text)">${s.total_rules || 0}</b> &nbsp;·&nbsp;
        Complete: <b style="color:var(--green)">${(s.components_complete || []).join(', ') || '—'}</b> &nbsp;·&nbsp;
        Missing: <b style="color:var(--red)">${(s.components_missing || []).join(', ') || '—'}</b> &nbsp;·&nbsp;
        Generated: <b style="color:var(--muted)">${(data.generated_at || '').slice(0, 16)}</b>`;

      const types = ['entry', 'stop_loss', 'exit', 'filter', 'regime'];
      const hasAny = types.some(t => (comps[t] || []).length > 0);
      if (!hasAny) {
        body.innerHTML = '<div class="empty-state">No EA components extracted yet. Run the extractor or learn more videos first.</div>';
        return;
      }

      body.innerHTML = types.map(t => {
        const rules = comps[t] || [];
        const col = COMP_COLORS[t];
        const label = COMP_LABELS[t];
        if (rules.length === 0) return `
          <div style="margin-bottom:20px">
            <div style="font-size:12px;font-weight:700;color:${col};text-transform:uppercase;letter-spacing:.08em;margin-bottom:8px;display:flex;align-items:center;gap:6px">
              <span style="width:8px;height:8px;border-radius:50%;background:${col};display:inline-block"></span>${label}
              <span style="font-weight:400;color:var(--muted)">(none)</span>
            </div>
          </div>`;
        return `
          <div style="margin-bottom:20px">
            <div style="font-size:12px;font-weight:700;color:${col};text-transform:uppercase;letter-spacing:.08em;margin-bottom:8px;display:flex;align-items:center;gap:6px">
              <span style="width:8px;height:8px;border-radius:50%;background:${col};display:inline-block"></span>
              ${label} <span style="font-weight:400;color:var(--muted)">(${rules.length})</span>
            </div>
            <div style="display:flex;flex-direction:column;gap:6px">
              ${rules.map(r => `
                <div class="comp-rule-card" style="background:#0d1e2c;border:1px solid #1e3548;border-left:3px solid ${col};border-radius:6px;padding:10px 14px">
                  <div style="font-size:13px;margin-bottom:4px">${r.rule.replace(/</g, '&lt;')}</div>
                  <div style="display:flex;gap:12px;font-size:11px;color:var(--muted)">
                    <span>freq: <b style="color:var(--text)">${r.frequency}</b></span>
                    <span>sources: <b style="color:var(--text)">${(r.sources || []).length}</b></span>
                    ${(r.concepts || []).length ? `<span>concepts: <b style="color:var(--cyan)">${r.concepts.join(', ')}</b></span>` : ''}
                  </div>
                </div>`).join('')}
            </div>
          </div>`;
      }).join('');
    } catch (e) {
      body.innerHTML = `<div class="empty-state" style="color:var(--red)">Error: ${e.message}</div>`;
    }
  }

  async function runEAComponents() {
    const body = document.getElementById('comp-body');
    if (body) body.innerHTML = '<div class="loading-row"><div class="spinner"></div>Extracting EA components...</div>';
    try {
      await apiFetch('POST', '/api/learning/ea-components', {});
      toast('success', 'EA components extracted');
      await loadEAComponents();
    } catch (e) {
      toast('error', `Extract failed: ${e.message}`);
      if (body) body.innerHTML = `<div class="empty-state" style="color:var(--red)">Error: ${e.message}</div>`;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // EA BLUEPRINT
  // ──────────────────────────────────────────────────────────────────────────
  let _lastBlueprintCode = null;

  async function loadBlueprint() {
    const body   = document.getElementById('bp-body');
    const badge  = document.getElementById('bp-readiness-badge');
    const sumEl  = document.getElementById('bp-summary');
    if (!body) return;
    try {
      const data = await apiFetch('GET', '/api/learning/blueprint');
      if (!data.mql5_code) return; // nothing generated yet — keep placeholder
      _renderBlueprintResult(data);
    } catch (_) { /* no blueprint yet — keep placeholder */ }
  }

  function _renderBlueprintResult(data) {
    const body  = document.getElementById('bp-body');
    const badge = document.getElementById('bp-readiness-badge');
    const sumEl = document.getElementById('bp-summary');
    const dlBtn = document.getElementById('btn-download-bp');
    const s = data.summary || {};
    const readiness = s.ea_readiness || 'low';
    const rCol = { high: 'var(--green)', medium: 'var(--yellow)', low: 'var(--red)' }[readiness] || 'var(--muted)';
    if (badge) { badge.textContent = 'EA Readiness: ' + readiness.toUpperCase(); badge.style.color = rCol; badge.style.background = '#0d1e2c'; }
    if (sumEl) sumEl.innerHTML = `
      Rules used: <b style="color:var(--text)">${s.total_rules_used || 0}</b> &nbsp;·&nbsp;
      Components: <b style="color:var(--green)">${(s.components_used || []).join(', ') || '—'}</b> &nbsp;·&nbsp;
      Generated: <b style="color:var(--muted)">${(data.generated_at || '').slice(0, 16)}</b>`;
    _lastBlueprintCode = data.mql5_code;
    if (dlBtn) dlBtn.style.display = '';
    
    // Create Flow Diagram HTML
    const flowOrder = ['regime', 'filter', 'entry', 'stop_loss', 'exit'];
    const compLabels = { regime: 'Regime', filter: 'Filter', entry: 'Entry', stop_loss: 'Stop Loss', exit: 'Exit / TP' };
    const compIcons = { regime: 'globe', filter: 'filter', entry: 'target', stop_loss: 'shield-alert', exit: 'log-out' };
    const used = s.components_used || [];
    
    let flowHTML = '<div class="blueprint-flow" style="display:flex;flex-direction:column;gap:12px;">';
    flowOrder.forEach((comp, idx) => {
      const isUsed = used.includes(comp);
      const color = isUsed ? 'var(--blue)' : 'var(--muted)';
      const bg = isUsed ? 'rgba(56,189,248,0.1)' : 'rgba(255,255,255,0.02)';
      const border = isUsed ? '1px solid rgba(56,189,248,0.3)' : '1px dashed rgba(255,255,255,0.1)';
      
      flowHTML += `
        <div style="background:${bg}; border:${border}; border-radius:12px; padding:16px; display:flex; align-items:center; gap:12px; position:relative; box-shadow:0 4px 15px rgba(0,0,0,0.1); transition:all 0.3s; transform-origin:center;" onmouseover="this.style.transform='scale(1.02)'" onmouseout="this.style.transform='scale(1)'">
          <div style="width:40px;height:40px;border-radius:50%;background:rgba(0,0,0,0.3);display:grid;place-items:center;color:${color}; border:1px solid ${color};">
            <i data-lucide="${compIcons[comp]}"></i>
          </div>
          <div>
            <div style="font-weight:700;font-size:14px;color:${isUsed ? '#fff' : 'var(--muted)'};letter-spacing:0.05em;text-transform:uppercase;">${compLabels[comp]}</div>
            <div style="font-size:11px;color:var(--muted);margin-top:2px;">${isUsed ? 'Rules Extracted & Active' : 'No Rules Found'}</div>
          </div>
        </div>
      `;
      // Add arrow down if not last
      if (idx < flowOrder.length - 1) {
        flowHTML += `
          <div style="height:20px; width:2px; background:linear-gradient(to bottom, ${isUsed ? 'rgba(56,189,248,0.5)' : 'rgba(255,255,255,0.1)'}, transparent); margin:0 auto;"></div>
        `;
      }
    });
    flowHTML += '</div>';

    if (body) {
      body.innerHTML = `
        <div style="display:grid; grid-template-columns: 280px 1fr; gap: 24px;">
          <div>
            <div style="font-size:13px; font-weight:700; color:var(--text-muted); margin-bottom:16px; text-transform:uppercase; letter-spacing:0.05em;">Execution Flow</div>
            ${flowHTML}
          </div>
          <div>
            <div style="font-size:13px; font-weight:700; color:var(--text-muted); margin-bottom:16px; text-transform:uppercase; letter-spacing:0.05em;">Generated MQL5 Code</div>
            <pre style="margin:0;padding:20px;background:#050e15;border-radius:12px;font-size:12.5px;font-family:'Fira Code', Consolas, monospace;
                        color:#c9e8ff;overflow:auto;max-height:calc(100vh - 280px);white-space:pre;line-height:1.6;
                        border:1px solid #1e3548; box-shadow: inset 0 0 20px rgba(0,0,0,0.5);">${data.mql5_code.replace(/</g, '&lt;')}</pre>
          </div>
        </div>`;
      // Re-initialize icons since we injected new HTML with data-lucide
      if (window.lucide) window.lucide.createIcons();
    }
  }

  async function generateBlueprint() {
    const body = document.getElementById('bp-body');
    setLoading('btn-generate-bp', true);
    if (body) body.innerHTML = '<div class="loading-row"><div class="spinner"></div>Generating MQL5 code...</div>';
    try {
      const data = await apiFetch('POST', '/api/learning/blueprint', {});
      _renderBlueprintResult(data);
      toast('success', 'Blueprint generated — ' + (data.summary?.total_rules_used || 0) + ' rules embedded');
    } catch (e) {
      toast('error', `Generate failed: ${e.message}`);
      if (body) body.innerHTML = `<div class="empty-state" style="color:var(--red)">Error: ${e.message}<br><small>Run EA Components extractor first (EA Components page → Re-extract)</small></div>`;
    } finally {
      setLoading('btn-generate-bp', false);
    }
  }

  function downloadBlueprint() {
    if (!_lastBlueprintCode) return;
    const blob = new Blob([_lastBlueprintCode], { type: 'text/plain;charset=utf-8' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = 'EA_KnowledgeBrain_v1.mq5';
    a.click();
    URL.revokeObjectURL(url);
    toast('success', 'Downloaded EA_KnowledgeBrain_v1.mq5');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CLOCK
  // ──────────────────────────────────────────────────────────────────────────
  function updateClock() {
    const now = new Date();
    document.getElementById('clock-time').textContent =
      now.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DOWNLOAD PROGRESS POLLING
  // ──────────────────────────────────────────────────────────────────────────
  async function fetchDownloadStatus() {
    try {
      const data = await apiFetch('GET', '/api/learning/download-status');
      const dlPanel = document.getElementById('download-progress');
      if (data.running) {
        dlPanel.style.display = 'block';
        document.getElementById('dl-percent').textContent = data.percent + '%';
        document.getElementById('dl-bar').style.width = data.percent + '%';
        
        const currentLabel = data.current_index + '/' + data.total;
        document.getElementById('dl-status-text').textContent = 'Bulk Processing (' + currentLabel + ') - ' + data.status;
        
        const vidInfo = data.current_video_id ? '[' + data.current_channel + '] ' + data.current_title : 'Initializing...';
        document.getElementById('dl-video-text').textContent = vidInfo;
      } else {
        if (data.status === 'Completed' || data.status === 'Not Running') {
           dlPanel.style.display = 'none';
        }
      }
    } catch(e) {
       // Ignore if offline
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // AUTO-REFRESH every 60 s
  // ──────────────────────────────────────────────────────────────────────────
  setInterval(updateClock, 1000);
  setInterval(refreshAll, 60000);
  setInterval(refreshResearchState, 60000);
  setInterval(refreshParallelAgentStatus, 60000);
  setInterval(refreshAIBudget, 60000);
  setInterval(fetchDownloadStatus, 2000);

  // ──────────────────────────────────────────────────────────────────────────
  // INIT
  // ──────────────────────────────────────────────────────────────────────────
  document.addEventListener('DOMContentLoaded', async () => {
    lucide.createIcons();
    updateClock();
    await loadStatus();
    await loadManagerStatus();
    await loadConflicts();
    await loadQueueTable();
    await loadYouTubeSources();
    await refreshResearchState();
    await refreshParallelAgentStatus();
    await refreshAIBudget();
    checkYouTubeStatus();
    checkTelegramStatus();
  });

  // Check YouTube status every 2 minutes independently
  setInterval(checkYouTubeStatus, 120000);
  setInterval(checkTelegramStatus, 120000);

  // ──────────────────────────────────────────────────────────────────────────
  // SETTINGS — YouTube Cookies
  // ──────────────────────────────────────────────────────────────────────────
  function setEngineRow(id, status, readyText = 'Ready', missingText = 'Missing') {
    const el = document.getElementById(id);
    if (!el) return;
    const ready = status === 'available' || status === 'cookies_configured';
    el.textContent = ready ? readyText : missingText;
    el.style.color = ready ? 'var(--green)' : 'var(--yellow)';
  }

  async function loadEngineStatus() {
    const detail = document.getElementById('engine-status-detail');
    try {
      const data = await apiFetch('GET', '/api/learning/engine-status');
      setEngineRow('engine-video-status', data.video_transcription?.status, 'Ready', 'Needs engine');
      setEngineRow('engine-ocr-status', data.image_ocr?.status, 'Ready', 'Needs OCR');
      setEngineRow('engine-youtube-status', data.youtube?.status, 'Cookies saved', 'No cookies');
      const localRaw = document.getElementById('engine-local-raw-status');
      if (localRaw) {
        localRaw.textContent = `${data.local_raw?.notes_count || 0} notes`;
        localRaw.style.color = 'var(--cyan)';
      }
      if (detail) {
        const videoProviders = data.video_transcription?.providers || {};
        const imageProviders = data.image_ocr?.providers || {};
        detail.innerHTML = [
          `Video: faster-whisper ${videoProviders.faster_whisper ? 'yes' : 'no'}, openai-whisper ${videoProviders.openai_whisper ? 'yes' : 'no'}, CLI ${videoProviders.whisper_cli ? 'yes' : 'no'}`,
          `OCR: Pillow ${imageProviders.pillow ? 'yes' : 'no'}, pytesseract ${imageProviders.pytesseract ? 'yes' : 'no'}, CLI ${imageProviders.tesseract_cli ? 'yes' : 'no'}`,
          `Local raw: ${escapeHtml(data.local_raw?.path || '')}`
        ].join('<br>');
      }
    } catch (e) {
      if (detail) {
        detail.style.color = 'var(--red)';
        detail.textContent = 'Engine status unavailable: ' + e.message;
      }
    }
  }

  async function loadCookiesStatus() {
    try {
      const data = await apiFetch('GET', '/api/learning/settings/cookies');
      const badge = document.getElementById('yt-cookie-badge');
      if (!badge) return;
      if (data.exists) {
        badge.textContent = `✓ Saved (${(data.size_bytes / 1024).toFixed(1)} KB)`;
        badge.style.background = 'rgba(39,212,127,.15)';
        badge.style.color = 'var(--green)';
      } else {
        badge.textContent = '✗ No cookies';
        badge.style.background = 'rgba(240,91,85,.12)';
        badge.style.color = 'var(--red)';
      }
    } catch (_) {}
  }

  async function loadRemoteInboxStatus() {
    const pending = document.getElementById('remote-inbox-pending');
    const imported = document.getElementById('remote-inbox-imported');
    const root = document.getElementById('remote-inbox-root');
    const detail = document.getElementById('remote-inbox-detail');
    try {
      const data = await apiFetch('GET', '/api/learning/remote-inbox/status');
      if (pending) {
        pending.textContent = `${data.pending?.total || 0} pending`;
        pending.style.color = (data.pending?.total || 0) > 0 ? 'var(--yellow)' : 'var(--green)';
      }
      if (imported) {
        imported.textContent = `${data.manifest?.imported || 0} imported`;
        imported.style.color = 'var(--cyan)';
      }
      if (root) {
        root.textContent = data.root || '-';
        root.title = data.root || '';
      }
      if (detail) {
        const p = data.pending || {};
        detail.style.color = '#7a9bb5';
        detail.innerHTML = [
          `Text ${p.text || 0}, Images ${p.images || 0}, Videos ${p.videos || 0}, URLs ${p.urls || 0}`,
          `Raw output: ${escapeHtml(data.raw_dir || '')}`,
          `Manifest: ${data.manifest_exists ? 'ready' : 'not created yet'}`
        ].join('<br>');
      }
    } catch (e) {
      if (pending) {
        pending.textContent = 'Unavailable';
        pending.style.color = 'var(--red)';
      }
      if (detail) {
        detail.style.color = 'var(--red)';
        detail.textContent = 'Remote inbox unavailable: ' + e.message;
      }
    }
  }

  async function processRemoteInbox(autoPipeline = false) {
    setLoading('btn-remote-inbox-process', true);
    setLoading('btn-remote-inbox-pipeline', true);
    const detail = document.getElementById('remote-inbox-detail');
    if (detail) {
      detail.style.color = '#7a9bb5';
      detail.textContent = autoPipeline ? 'Processing remote inbox and starting pipeline...' : 'Processing remote inbox...';
    }
    try {
      const data = await apiFetch('POST', '/api/learning/remote-inbox/process', { auto_pipeline: autoPipeline });
      const pipelineText = data.pipeline ? ', pipeline started' : '';
      toast(data.failed ? 'info' : 'success', `Remote inbox: ${data.imported || 0} imported, ${data.failed || 0} failed${pipelineText}`);
      if (detail) {
        detail.innerHTML = [
          `Processed ${data.processed || 0}, imported ${data.imported || 0}, skipped ${data.skipped || 0}, failed ${data.failed || 0}${pipelineText}`,
          `Raw output: ${escapeHtml(data.raw_dir || '')}`
        ].join('<br>');
      }
      await loadRemoteInboxStatus();
    } catch (e) {
      toast('error', 'Remote inbox failed: ' + e.message);
      if (detail) {
        detail.style.color = 'var(--red)';
        detail.textContent = 'Remote inbox failed: ' + e.message;
      }
    } finally {
      setLoading('btn-remote-inbox-process', false);
      setLoading('btn-remote-inbox-pipeline', false);
    }
  }

  async function saveCookies() {
    const content = document.getElementById('cookies-textarea').value;
    if (!content.trim()) { showToast('Paste cookies first', 'error'); return; }
    try {
      const data = await apiFetch('POST', '/api/learning/settings/cookies', { content });
      showToast(`Cookies saved — ${data.lines} cookie lines`, 'success');
      await loadCookiesStatus();
    } catch (e) { showToast('Save failed: ' + e.message, 'error'); }
  }

  async function deleteCookies() {
    if (!confirm('Delete saved cookies? YouTube will be blocked again.')) return;
    await apiFetch('DELETE', '/api/learning/settings/cookies');
    document.getElementById('cookies-textarea').value = '';
    showToast('Cookies deleted', 'success');
    await loadCookiesStatus();
  }

  async function testYouTube() {
    const resultEl = document.getElementById('yt-test-result');
    resultEl.style.display = 'block';
    resultEl.style.background = 'rgba(14,30,44,.8)';
    resultEl.style.color = '#8fa8ba';
    resultEl.style.border = '1px solid #1d4054';
    resultEl.textContent = '⏳ Testing connection to YouTube…';
    try {
      const data = await apiFetch('POST', '/api/learning/settings/test-youtube');
      if (data.status === 'ok') {
        resultEl.style.background = 'rgba(39,212,127,.1)';
        resultEl.style.color = 'var(--green)';
        resultEl.style.border = '1px solid rgba(39,212,127,.3)';
        resultEl.textContent = `✓ Connected — fetched ${data.entries} transcript entries (video: ${data.video_id})`;
        document.getElementById('yt-status').textContent = 'Connected';
        const safeDetail = data.entries != null
          ? `fetched ${data.entries} transcript entries${data.video_id ? ` (video: ${data.video_id})` : ''}`
          : data.words != null
            ? `fetched ${data.words} transcript words${data.language ? ` (${data.language})` : ''}`
            : (data.message || 'YouTube accessible');
        resultEl.textContent = `Connected - ${safeDetail}`;
        document.getElementById('yt-status').style.color = 'var(--green)';
      } else if (data.status === 'no_cookies') {
        resultEl.style.background = 'rgba(247,185,40,.1)';
        resultEl.style.color = 'var(--yellow)';
        resultEl.style.border = '1px solid rgba(247,185,40,.3)';
        resultEl.textContent = '⚠ ' + data.error;
      } else {
        resultEl.style.background = 'rgba(240,91,85,.1)';
        resultEl.style.color = 'var(--red)';
        resultEl.style.border = '1px solid rgba(240,91,85,.3)';
        resultEl.textContent = '✗ ' + (data.error || 'Connection failed');
      }
    } catch (e) {
      resultEl.style.color = 'var(--red)';
      resultEl.textContent = '✗ ' + e.message;
    }
  }


  async function loadLogbook() {
    let container = document.getElementById('logbook-container');
    if (!container) return;
    container.innerHTML = '<div class="loading-row"><div class="spinner"></div>Loading logbook...</div>';
    try {
      let res = await fetch('http://127.0.0.1:5000/api/learning/conflicts');
      if (!res.ok) throw new Error("API error");
      let data = await res.json();
      let conflicts = data.conflicts || [];
      
      let html = '';
      if (conflicts.length === 0) {
        html = '<div class="empty-state">No conflicts recorded yet.</div>';
      } else {
        conflicts.forEach(c => {
          let statusColor = c.status === 'resolved' ? 'var(--green)' : 'var(--yellow)';
          let icon = c.status === 'resolved' ? 'check-circle' : 'clock';
          
          let varA = c.rule_a || (c.variants && c.variants[0] ? c.variants[0].text : 'N/A');
          let varB = c.rule_b || (c.variants && c.variants[1] ? c.variants[1].text : 'N/A');
          let resNote = c.resolution_note ? `<div style="margin-top:8px; padding-top:8px; border-top:1px dashed rgba(255,255,255,0.1); color:var(--green); font-size:12px;"><b>Resolution:</b> ${c.resolution_note}</div>` : '';
          
          html += `
            <div class="conflict-card" style="margin-bottom: 12px; display: flex; flex-direction: column; gap: 8px;">
              <div style="display:flex; justify-content:space-between; align-items:center;">
                <b style="color:var(--blue); font-size: 14px;">${c.concept}</b>
                <span class="badge" style="color: ${statusColor}; border-color: ${statusColor}; background: rgba(0,0,0,0.2);"><i data-lucide="${icon}" style="width:12px;height:12px;margin-right:4px;"></i>${c.status.toUpperCase()}</span>
              </div>
              <div style="font-size:12px; color:#fff;">
                <div style="background:rgba(255,255,255,0.05); padding:8px; border-radius:6px; margin-bottom:4px;">
                  <strong style="color:var(--text-muted)">Variant A:</strong> ${varA}
                </div>
                <div style="background:rgba(255,255,255,0.05); padding:8px; border-radius:6px;">
                  <strong style="color:var(--text-muted)">Variant B:</strong> ${varB}
                </div>
              </div>
              ${resNote}
            </div>
          `;
        });
      }
      container.innerHTML = html;
      lucide.createIcons();
    } catch (err) {
      container.innerHTML = `<div class="empty-state" style="color:var(--red)">Failed to load logbook. API might be offline.</div>`;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // BACKTEST SUMMARY (Fintech Style)
  // ──────────────────────────────────────────────────────────────────────────
  async function loadBacktestSummary() {
    if (window.backtestChartInitialized) return; // Only load once

    try {
      const resp = await fetch(API_BASE + '/api/learning/trades');
      if (!resp.ok) throw new Error('Could not fetch trades_log.csv');
      const csvText = await resp.text();

      // Parse CSV
      const lines = csvText.trim().split('\\n');
      if (lines.length < 2) return;
      
      let totalProfit = 0;
      let wins = 0;
      let maxEquity = 0;
      let maxDrawdown = 0;
      let chartData = [];
      let currentEquity = 0;

      // Extract Headers
      const headers = lines[0].split(',');
      const timeIdx = headers.indexOf('time');
      const pnlIdx = headers.indexOf('pnl');
      const eqIdx = headers.indexOf('equity');

      for (let i = 1; i < lines.length; i++) {
        const row = lines[i].split(',');
        if (row.length < 3) continue;

        const timeStr = row[timeIdx];
        const pnl = parseFloat(row[pnlIdx]);
        const eq = parseFloat(row[eqIdx]);

        if (isNaN(pnl) || isNaN(eq)) continue;

        totalProfit += pnl;
        if (pnl > 0) wins++;

        if (eq > maxEquity) maxEquity = eq;
        const drawdown = ((maxEquity - eq) / maxEquity) * 100;
        if (drawdown > maxDrawdown) maxDrawdown = drawdown;

        currentEquity = eq;
        
        // Lightweight charts wants timestamp (seconds) or YYYY-MM-DD
        // Trades time is like '2026-01-06 14:43:00'
        const tObj = new Date(timeStr);
        if (!isNaN(tObj.getTime())) {
          chartData.push({
            time: tObj.getTime() / 1000,
            value: eq
          });
        }
      }

      // Sort chart data by time
      chartData.sort((a,b) => a.time - b.time);

      const tradesCount = lines.length - 1;
      const winRate = tradesCount > 0 ? ((wins / tradesCount) * 100).toFixed(1) : 0;
      
      document.getElementById('bt-total-profit').innerText = '$' + totalProfit.toFixed(2);
      document.getElementById('bt-win-rate').innerText = winRate + '%';
      document.getElementById('bt-max-dd').innerText = maxDrawdown.toFixed(2) + '%';

      // Render Lightweight Chart
      const container = document.getElementById('equity-chart');
      const chart = LightweightCharts.createChart(container, {
        layout: {
          background: { type: 'solid', color: 'transparent' },
          textColor: '#F8FAFC',
        },
        grid: {
          vertLines: { color: 'rgba(255,255,255,0.05)' },
          horzLines: { color: 'rgba(255,255,255,0.05)' },
        },
        rightPriceScale: {
          borderVisible: false,
        },
        timeScale: {
          borderVisible: false,
          timeVisible: true,
          secondsVisible: false,
        },
        crosshair: {
          mode: LightweightCharts.CrosshairMode.Normal,
          vertLine: { width: 1, color: 'rgba(245, 158, 11, 0.5)', style: LightweightCharts.LineStyle.Dashed },
          horzLine: { width: 1, color: 'rgba(245, 158, 11, 0.5)', style: LightweightCharts.LineStyle.Dashed },
        }
      });

      const areaSeries = chart.addAreaSeries({
        lineColor: '#8B5CF6',
        topColor: 'rgba(139, 92, 246, 0.4)',
        bottomColor: 'rgba(139, 92, 246, 0.0)',
        lineWidth: 2,
        priceFormat: {
          type: 'price',
          precision: 2,
          minMove: 0.01,
        },
      });

      areaSeries.setData(chartData);
      chart.timeScale().fitContent();

      // Handle resize
      window.addEventListener('resize', () => {
        chart.applyOptions({ width: container.clientWidth });
      });

      window.backtestChartInitialized = true;
    } catch (err) {
      console.error(err);
      document.getElementById('equity-chart').innerHTML = `<div style="color:#FCA5A5">Error loading backtest data: ${err.message}</div>`;
    }
  }

