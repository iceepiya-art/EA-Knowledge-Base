import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def upgrade_dashboard():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    start_idx = html.find('<div id="page-alpha-lab"')
    if start_idx == -1:
        print("Could not find page-alpha-lab")
        return
        
    # Find the end of the script tag injected earlier
    end_script = html.find('</script>', start_idx)
    if end_script != -1:
        end_idx = end_script + 9 # len('</script>')
    else:
        # Fallback if script not found
        end_idx = html.find('</body>', start_idx)
        
    if end_idx == -1 or end_idx < start_idx:
        print("Could not find end of alpha lab block")
        return
        
    new_html = """
    <div id="page-alpha-lab" class="page">
      <div class="top" style="display:flex; justify-content:space-between; align-items:center; width:100%; padding-right:24px;">
        <div style="display:flex; align-items:center; gap:16px;">
          <button class="hamburger" aria-label="Toggle Sidebar"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg></button>
          <h2>Alpha Quant Intelligence Lab</h2>
        </div>
        <div style="display:flex; align-items:center; gap:12px;">
          <span style="color:var(--text-muted); font-size:11px; font-weight:700; letter-spacing:0.5px;">TARGET EA:</span>
          <select id="alpha-ea-selector" onchange="updateAlphaLabData(this.value)" class="select" style="min-width: 280px; border-color:var(--yellow); color:var(--yellow); font-weight:600;">
            <option value="ea_rsi">🤖 EA RSI Break Trend Line (M5)</option>
            <option value="ea_morning">🦅 EA MorningGod FTMO (M15)</option>
            <option value="ea_elliott">🌊 EA Elliott Wave 5 Zone (H1)</option>
          </select>
        </div>
      </div>
      
      <div style="margin-top:20px;">
        <!-- TOP TROPHY & SCORE -->
        <div id="alpha-score-box" style="text-align:center; padding: 40px 20px; background: linear-gradient(180deg, rgba(250, 204, 21, 0.1) 0%, transparent 100%); border-radius: 24px; border: 1px solid rgba(250,204,21,0.2); box-shadow: 0 10px 40px rgba(0,0,0,0.5); transition: all 0.5s;">
            <svg id="alpha-trophy-icon" xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#facc15" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="filter: drop-shadow(0 0 15px rgba(250,204,21,0.6)); transition: all 0.5s;"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
            <div id="alpha-level-txt" style="color: var(--yellow); font-size: 14px; font-weight: 700; letter-spacing: 2px; margin-top: 10px; transition: all 0.5s;">LEVEL: ELITE ⭐️⭐️⭐️⭐️⭐️</div>
            <div style="font-size: 64px; font-weight: 800; color: #fff; text-shadow: 0 0 20px rgba(255,255,255,0.2); line-height: 1;"><span id="alpha-score-val">100</span> <span style="font-size:32px; color:var(--text-muted);">/ 100</span></div>
            <div style="color: var(--text-muted); font-size: 14px; font-weight: 600; letter-spacing: 1px;">ALPHA SCORE</div>
        </div>

        <div style="display:grid; grid-template-columns: 320px 1fr 320px; gap: 24px; margin-top: 24px;">
            <!-- LEFT PANEL: PERFORMANCE -->
            <div class="panel" style="padding:24px;">
                <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;"><i data-lucide="bar-chart-2" style="width:16px; height:16px; vertical-align:middle; margin-right:8px;"></i> PERFORMANCE SUMMARY</h3>
                <div style="display:grid; gap:12px; margin-top:16px;">
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Initial Deposit</span>
                        <strong style="color:#fff;">$10,000.00</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Total Net Profit</span>
                        <strong id="alpha-profit-val" style="color:var(--green); font-size:16px; text-shadow:0 0 10px var(--green-glow); transition: color 0.3s;">+$4,250.00</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Profit Factor</span>
                        <strong id="alpha-pf-val" style="color:#fff;">2.10</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Absolute Drawdown</span>
                        <strong id="alpha-absdd-val" style="color:var(--red);">$124.50</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Maximal Drawdown</span>
                        <strong id="alpha-maxdd-val" style="color:var(--red);">1.50%</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Total Trades</span>
                        <strong id="alpha-trades-val" style="color:#fff;">210</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Win Rate</span>
                        <strong id="alpha-winrate-val" style="color:#fff;">78.00%</strong>
                    </div>
                </div>
            </div>

            <!-- CENTER PANEL: EQUITY CURVE -->
            <div class="panel" style="padding:24px; display:flex; flex-direction:column;">
                <h3 style="margin-top:0; color:#fff; font-size:14px;"><i data-lucide="trending-up" style="width:16px; height:16px; vertical-align:middle; margin-right:8px;"></i> EQUITY PROGRESSION</h3>
                <div style="flex:1; min-height: 300px; position:relative; margin-top:16px; background: rgba(0,0,0,0.2); border-radius: 12px; border:1px solid rgba(255,255,255,0.05);">
                    <canvas id="alphaEquityChart"></canvas>
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px; margin-top:16px;">
                    <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16,185,129,0.3); padding:16px; border-radius:12px; text-align:center;">
                        <div style="color:var(--green); font-size:11px; font-weight:700; letter-spacing:1px;">SHARPE RATIO</div>
                        <div id="alpha-sharpe-val" style="font-size:24px; font-weight:800; color:#fff; margin-top:4px;">3.45</div>
                        <div style="color:var(--green); font-size:12px; margin-top:4px;">Excellent</div>
                    </div>
                    <div style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59,130,246,0.3); padding:16px; border-radius:12px; text-align:center;">
                        <div style="color:var(--blue); font-size:11px; font-weight:700; letter-spacing:1px;">RECOVERY FACTOR</div>
                        <div id="alpha-recovery-val" style="font-size:24px; font-weight:800; color:#fff; margin-top:4px;">5.12</div>
                        <div style="color:var(--blue); font-size:12px; margin-top:4px;">Outstanding</div>
                    </div>
                </div>
            </div>

            <!-- RIGHT PANEL: STRENGTHS & PROP FIRM -->
            <div style="display:flex; flex-direction:column; gap:24px;">
                <div class="panel" style="padding:24px;">
                    <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;"><i data-lucide="shield-check" style="width:16px; height:16px; vertical-align:middle; margin-right:8px;"></i> KEY STRENGTHS</h3>
                    <div id="alpha-strengths-container" style="display:grid; gap:12px; margin-top:16px;">
                        <div style="display:flex; align-items:center; gap:12px; background:rgba(0,0,0,0.2); padding:12px; border-radius:12px; border:1px solid rgba(34,197,94,0.2);">
                            <div style="width:32px; height:32px; border-radius:8px; background:rgba(34,197,94,0.1); display:grid; place-items:center; color:var(--green);"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
                            <div>
                                <div style="color:#fff; font-weight:600; font-size:12px;">LOW DRAWDOWN</div>
                                <div style="color:var(--text-muted); font-size:11px; margin-top:2px;">Only 1.5% Max DD</div>
                            </div>
                        </div>
                        <div style="display:flex; align-items:center; gap:12px; background:rgba(0,0,0,0.2); padding:12px; border-radius:12px; border:1px solid rgba(59,130,246,0.2);">
                            <div style="width:32px; height:32px; border-radius:8px; background:rgba(59,130,246,0.1); display:grid; place-items:center; color:var(--blue);"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v20"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
                            <div>
                                <div style="color:#fff; font-weight:600; font-size:12px;">HIGH WIN RATE</div>
                                <div style="color:var(--text-muted); font-size:11px; margin-top:2px;">78.0% Win Rate</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="alpha-prop-box" class="panel" style="padding:24px; border-color: rgba(16,185,129,0.3); transition: all 0.3s;">
                    <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;"><i data-lucide="check-square" style="width:16px; height:16px; vertical-align:middle; margin-right:8px; color:inherit;"></i> PROP FIRM SUITABILITY</h3>
                    <div style="text-align:center; padding:16px 0;">
                        <div id="alpha-propscore-val" style="font-size:36px; font-weight:800; color:inherit; text-shadow:0 0 15px rgba(255,255,255,0.2); line-height:1;">10.0 <span style="font-size:16px; color:var(--text-muted); font-weight:500;">/ 10</span></div>
                        <div id="alpha-prop-txt" style="color:inherit; font-size:12px; font-weight:600; margin-top:4px;">HIGHLY RECOMMENDED</div>
                    </div>
                    <div style="display:grid; gap:8px;">
                        <div style="display:flex; justify-content:space-between; font-size:12px; color:#fff;"><span style="color:var(--text-muted)">FTMO Challenge</span><i id="p-ftmo" data-lucide="check" style="color:var(--green); width:14px; height:14px;"></i></div>
                        <div style="display:flex; justify-content:space-between; font-size:12px; color:#fff;"><span style="color:var(--text-muted)">FundedNext</span><i id="p-fn" data-lucide="check" style="color:var(--green); width:14px; height:14px;"></i></div>
                        <div style="display:flex; justify-content:space-between; font-size:12px; color:#fff;"><span style="color:var(--text-muted)">The 5ers</span><i id="p-5er" data-lucide="check" style="color:var(--green); width:14px; height:14px;"></i></div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>
    
    <script>
    const alphaEAData = {
        "ea_rsi": {
            score: 100, level: "ELITE", 
            profit: "+$4,250.00", pf: "2.10", absdd: "$124.50", maxdd: "1.50%", trades: "210", winrate: "78.00%",
            propscore: "10.0", sharpe: "3.45", recovery: "5.12",
            equity: [10000, 10200, 10150, 10500, 10800, 10750, 11200, 11600, 11500, 12000, 13100, 14250],
            color: "var(--yellow)"
        },
        "ea_morning": {
            score: 82, level: "PRO", 
            profit: "+$2,840.10", pf: "1.75", absdd: "$340.00", maxdd: "4.20%", trades: "415", winrate: "65.50%",
            propscore: "8.5", sharpe: "2.10", recovery: "3.20",
            equity: [10000, 9800, 10300, 10100, 10600, 10500, 11000, 10800, 11500, 11200, 12100, 12840],
            color: "var(--blue)"
        },
        "ea_elliott": {
            score: 55, level: "AVERAGE", 
            profit: "+$1,250.00", pf: "1.20", absdd: "$850.00", maxdd: "12.50%", trades: "85", winrate: "48.20%",
            propscore: "4.0", sharpe: "0.85", recovery: "1.15",
            equity: [10000, 9500, 9200, 10500, 10100, 9800, 11000, 10600, 10200, 11500, 10800, 11250],
            color: "var(--red)"
        }
    };
    
    let alphaChartInst = null;
    
    function initAlphaChart() {
        const ctx = document.getElementById('alphaEquityChart');
        if (!ctx) return;
        const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(250, 204, 21, 0.4)');
        gradient.addColorStop(1, 'rgba(250, 204, 21, 0.0)');
        
        alphaChartInst = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Equity ($)',
                    data: alphaEAData['ea_rsi'].equity,
                    borderColor: '#facc15',
                    backgroundColor: gradient,
                    borderWidth: 3, pointBackgroundColor: '#fff', pointBorderColor: '#facc15', pointBorderWidth: 2, pointRadius: 4, pointHoverRadius: 6, fill: true, tension: 0.4
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false }, tooltip: { backgroundColor: 'rgba(15,23,42,0.9)', titleColor: '#fff', bodyColor: '#fff' } },
                scales: { x: { grid: { color: 'rgba(255,255,255,0.05)' } }, y: { grid: { color: 'rgba(255,255,255,0.05)' } } }
            }
        });
    }

    function updateAlphaLabData(eaId) {
        const data = alphaEAData[eaId];
        if(!data) return;
        
        document.getElementById('alpha-score-val').innerText = data.score;
        document.getElementById('alpha-level-txt').innerText = "LEVEL: " + data.level + " ⭐️⭐️⭐️⭐️⭐️";
        document.getElementById('alpha-profit-val').innerText = data.profit;
        document.getElementById('alpha-pf-val').innerText = data.pf;
        document.getElementById('alpha-absdd-val').innerText = data.absdd;
        document.getElementById('alpha-maxdd-val').innerText = data.maxdd;
        document.getElementById('alpha-trades-val').innerText = data.trades;
        document.getElementById('alpha-winrate-val').innerText = data.winrate;
        document.getElementById('alpha-propscore-val').innerHTML = data.propscore + ' <span style="font-size:16px; color:var(--text-muted); font-weight:500;">/ 10</span>';
        document.getElementById('alpha-sharpe-val').innerText = data.sharpe;
        document.getElementById('alpha-recovery-val').innerText = data.recovery;
        
        // Colors & Theme updates
        let themeColor = data.color;
        let pColor = data.score >= 70 ? "var(--green)" : "var(--red)";
        
        document.getElementById('alpha-score-box').style.background = `linear-gradient(180deg, ${themeColor.replace(')', ', 0.1)').replace('var(--','rgba(')} 0%, transparent 100%)`;
        document.getElementById('alpha-score-box').style.borderColor = themeColor;
        document.getElementById('alpha-level-txt').style.color = themeColor;
        document.getElementById('alpha-trophy-icon').setAttribute('stroke', themeColor);
        document.getElementById('alpha-profit-val').style.color = data.profit.includes('-') ? 'var(--red)' : 'var(--green)';
        
        document.getElementById('alpha-prop-box').style.borderColor = pColor;
        document.getElementById('alpha-prop-box').style.color = pColor;
        
        // Update Chart
        if(alphaChartInst) {
            alphaChartInst.data.datasets[0].data = data.equity;
            const ctx = document.getElementById('alphaEquityChart');
            const grad = ctx.getContext('2d').createLinearGradient(0,0,0,400);
            
            let colorHex = themeColor === 'var(--yellow)' ? '#facc15' : (themeColor === 'var(--blue)' ? '#38bdf8' : '#f87171');
            grad.addColorStop(0, colorHex + '66');
            grad.addColorStop(1, colorHex + '00');
            
            alphaChartInst.data.datasets[0].borderColor = colorHex;
            alphaChartInst.data.datasets[0].pointBorderColor = colorHex;
            alphaChartInst.data.datasets[0].backgroundColor = grad;
            alphaChartInst.update();
        }
    }
    
    document.addEventListener("DOMContentLoaded", function() {
        initAlphaChart();
        // ensure lucide icons are drawn
        if(window.lucide) lucide.createIcons();
    });
    </script>
    """
    
    html = html[:start_idx] + new_html + html[end_idx:]
    dashboard_path.write_text(html, encoding="utf-8")
    print("Dashboard upgraded with EA Dropdown successfully.")

if __name__ == "__main__":
    upgrade_dashboard()
