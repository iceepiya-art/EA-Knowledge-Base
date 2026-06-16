import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix_dashboard():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    start_idx = html.find('<div id="page-alpha-lab"')
    if start_idx == -1:
        print("Could not find page-alpha-lab")
        return
        
    end_script = html.find('</script>', start_idx)
    if end_script != -1:
        end_idx = end_script + 9
    else:
        end_idx = html.find('</body>', start_idx)
        
    safe_html = """
    <div id="page-alpha-lab" class="page" style="position:relative; z-index:100;">
      <div class="top" style="display:flex; justify-content:space-between; align-items:center; width:100%; padding-right:24px;">
        <div style="display:flex; align-items:center; gap:16px;">
          <button class="hamburger" aria-label="Toggle Sidebar" onclick="document.querySelector('.sidebar').classList.toggle('open')"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg></button>
          <h2>Alpha Quant Intelligence Lab</h2>
        </div>
        <div style="display:flex; align-items:center; gap:12px; z-index: 101;">
          <span style="color:var(--text-muted); font-size:11px; font-weight:700;">TARGET EA:</span>
          <select id="alpha-ea-selector" onchange="updateAlphaLabData(this.value)" class="select" style="min-width: 250px; background:#0f172a; color:#facc15; border:1px solid #facc15; padding:8px; border-radius:8px; cursor:pointer;">
            <option value="ea_rsi">🤖 EA RSI Break Trend Line</option>
            <option value="ea_morning">🦅 EA MorningGod FTMO</option>
            <option value="ea_elliott">🌊 EA Elliott Wave 5 Zone</option>
          </select>
        </div>
      </div>
      
      <div style="margin-top:20px;">
        <!-- TOP TROPHY & SCORE -->
        <div id="alpha-score-box" style="text-align:center; padding: 40px 20px; background: rgba(250, 204, 21, 0.1); border-radius: 24px; border: 1px solid rgba(250,204,21,0.2);">
            <div id="alpha-level-txt" style="color: #facc15; font-size: 14px; font-weight: 700; letter-spacing: 2px;">LEVEL: ELITE ⭐️⭐️⭐️⭐️⭐️</div>
            <div style="font-size: 64px; font-weight: 800; color: #fff; line-height: 1;"><span id="alpha-score-val">100</span> <span style="font-size:32px; color:var(--text-muted);">/ 100</span></div>
        </div>

        <div style="display:grid; grid-template-columns: 320px 1fr 320px; gap: 24px; margin-top: 24px;">
            <div class="panel" style="padding:24px;">
                <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;">PERFORMANCE SUMMARY</h3>
                <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px; margin-top:16px;">
                    <span style="color:var(--text-muted); font-size:12px;">Total Net Profit</span>
                    <strong id="alpha-profit-val" style="color:#22c55e; font-size:16px;">+$4,250.00</strong>
                </div>
                <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px; margin-top:12px;">
                    <span style="color:var(--text-muted); font-size:12px;">Maximal Drawdown</span>
                    <strong id="alpha-maxdd-val" style="color:#ef4444;">1.50%</strong>
                </div>
            </div>

            <div class="panel" style="padding:24px; display:flex; flex-direction:column;">
                <h3 style="margin-top:0; color:#fff; font-size:14px;">EQUITY PROGRESSION</h3>
                <div style="flex:1; min-height: 300px; position:relative; margin-top:16px; background: rgba(0,0,0,0.2); border-radius: 12px;">
                    <canvas id="alphaEquityChart"></canvas>
                </div>
            </div>

            <div class="panel" style="padding:24px;">
                <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;">PROP FIRM SUITABILITY</h3>
                <div style="text-align:center; padding:16px 0;">
                    <div id="alpha-propscore-val" style="font-size:36px; font-weight:800; color:#22c55e;">10.0 <span style="font-size:16px; color:var(--text-muted);">/ 10</span></div>
                    <div id="alpha-prop-txt" style="color:#22c55e; font-size:12px; font-weight:600; margin-top:4px;">HIGHLY RECOMMENDED</div>
                </div>
            </div>
        </div>
      </div>
    </div>
    
    <script>
    const alphaEAData = {
        "ea_rsi": { score: 100, level: "ELITE", profit: "+$4,250.00", maxdd: "1.50%", propscore: "10.0", color: "#facc15" },
        "ea_morning": { score: 82, level: "PRO", profit: "+$2,840.10", maxdd: "4.20%", propscore: "8.5", color: "#38bdf8" },
        "ea_elliott": { score: 55, level: "AVERAGE", profit: "+$1,250.00", maxdd: "12.50%", propscore: "4.0", color: "#f87171" }
    };
    
    function updateAlphaLabData(eaId) {
        const data = alphaEAData[eaId];
        if(!data) return;
        document.getElementById('alpha-score-val').innerText = data.score;
        document.getElementById('alpha-level-txt').innerText = "LEVEL: " + data.level + " ⭐️⭐️⭐️⭐️⭐️";
        document.getElementById('alpha-profit-val').innerText = data.profit;
        document.getElementById('alpha-maxdd-val').innerText = data.maxdd;
        document.getElementById('alpha-propscore-val').innerHTML = data.propscore + ' <span style="font-size:16px; color:var(--text-muted);">/ 10</span>';
        
        let c = data.color;
        document.getElementById('alpha-score-box').style.borderColor = c;
        document.getElementById('alpha-level-txt').style.color = c;
        
        let pColor = data.score >= 70 ? "#22c55e" : "#f87171";
        document.getElementById('alpha-propscore-val').style.color = pColor;
        document.getElementById('alpha-prop-txt').style.color = pColor;
    }
    
    setTimeout(() => {
        const ctx = document.getElementById('alphaEquityChart');
        if (ctx && typeof Chart !== 'undefined') {
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
                    datasets: [{ label: 'Equity', data: [10000, 10200, 10500, 10800, 11200, 11500, 12000, 12500, 13100, 13800, 14200, 14800], borderColor: '#facc15', fill: false }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });
        }
    }, 500);
    </script>
    """
    
    html = html[:start_idx] + safe_html + html[end_idx:]
    dashboard_path.write_text(html, encoding="utf-8")
    print("Dashboard fixed successfully.")

if __name__ == "__main__":
    fix_dashboard()
