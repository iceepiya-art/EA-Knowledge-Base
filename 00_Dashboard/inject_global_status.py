import re
from pathlib import Path

dashboard_path = Path("G:/My Drive/save log-blueprint-skill/EA-Knowledge-Base/00_Dashboard/EA_Knowledge_Brain_Dashboard.html")
js_path = Path("G:/My Drive/save log-blueprint-skill/EA-Knowledge-Base/00_Dashboard/test_1.js")

# 1. Update HTML
html_content = dashboard_path.read_text(encoding="utf-8", errors="ignore")

widget_html = """
          <section class="panel" id="system-engineering-status-panel" style="margin-top: 20px;">
            <div class="panel-head">
              <div class="panel-title">System Engineering & Conflicts</div>
              <span id="blueprint-status-badge" class="badge b-muted">Checking</span>
            </div>
            <div class="panel-body">
              <div class="grid-2" style="margin-bottom: 12px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                <div class="stat-box" style="border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; padding: 12px; background: rgba(0,0,0,0.18);">
                  <span class="stat-label" style="display: block; color: var(--muted); font-size: 10px; text-transform: uppercase; font-weight: 700;">Conflicts Auto-Resolved</span>
                  <strong class="stat-value" id="conflict-resolved-count" style="display: block; margin-top: 6px; font-size: 22px; color: var(--green);">-</strong>
                </div>
                <div class="stat-box" style="border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; padding: 12px; background: rgba(0,0,0,0.18);">
                  <span class="stat-label" style="display: block; color: var(--muted); font-size: 10px; text-transform: uppercase; font-weight: 700;">Conflicts Pending Review</span>
                  <strong class="stat-value" id="conflict-pending-count" style="display: block; margin-top: 6px; font-size: 22px; color: var(--yellow);">-</strong>
                </div>
              </div>
              <div style="font-size:12px; color:var(--muted); border-top: 1px solid rgba(255,255,255,0.05); padding-top: 10px; margin-top: 10px;">
                <i data-lucide="check-circle" style="width:12px; height:12px; margin-right:4px; color:var(--green)"></i>
                Blueprint Generation: <b id="blueprint-status-text" style="color:var(--text)">Not Ready</b>
              </div>
            </div>
          </section>
"""

if 'id="system-engineering-status-panel"' not in html_content:
    # Try to inject after ea-components-summary-panel
    match = re.search(r'(<section class="panel" id="ea-components-summary-panel">.*?</section>)', html_content, re.DOTALL)
    if match:
        original = match.group(1)
        html_content = html_content.replace(original, original + widget_html)
        dashboard_path.write_text(html_content, encoding="utf-8")
        print("HTML injected successfully.")
    else:
        print("Could not find ea-components-summary-panel to inject HTML.")
else:
    print("HTML widget already exists.")

# 2. Update JS
js_content = js_path.read_text(encoding="utf-8", errors="ignore")
js_injection = """
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
"""

# Find where to inject in JS. test_1.js has the `loadStatus` function which updates KPIs.
# I'll inject after `if (eaRulesEl) eaRulesEl.textContent = (data.ea_rules ?? 0).toLocaleString();`

if 'conflict-resolved-count' not in js_content:
    target_str = "if (eaRulesEl) eaRulesEl.textContent = (data.ea_rules ?? 0).toLocaleString();"
    if target_str in js_content:
        js_content = js_content.replace(target_str, target_str + js_injection)
        js_path.write_text(js_content, encoding="utf-8")
        print("JS injected successfully.")
    else:
        print("Could not find injection point in JS.")
else:
    print("JS widget code already exists.")
