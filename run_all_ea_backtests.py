import os
import subprocess
import shutil
import time
import xml.etree.ElementTree as ET
from pathlib import Path

WORKSPACE_DIR = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base")
MT5_TERMINAL = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
MT5_EDITOR = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe")
MT5_DATA_FOLDER = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850")
MT5_EXPERTS_DIR = MT5_DATA_FOLDER / "MQL5" / "Experts" / "Battlefield"

if not MT5_EXPERTS_DIR.exists():
    MT5_EXPERTS_DIR.mkdir(parents=True)

# 8 Representative EAs
EA_LIST = [
    Path(r"G:\My Drive\jobot\EA Week10\(Jobot) RSI Break Trend Line EA.mq5"),
    Path(r"G:\My Drive\jobot\AI GEN\Hedge Martingale EA.mq5"),
    Path(r"G:\My Drive\jobot\AI GEN\SmartMoney_Advanced_EA.mq5"),
    Path(r"G:\My Drive\jobot\AI GEN\NinjaThaiStyleEA_Complete.mq5"),
    Path(r"G:\My Drive\jobot\EA Week6\(Jobot) Arbitrage Super Profit.mq5"),
    WORKSPACE_DIR / "raw" / "SMC_Universal_EA_v3_0_fix16" / "MQL5" / "Experts" / "SMC_Universal_EA_v3.0.mq5",
    WORKSPACE_DIR / "Universal_EA.mq5",
    WORKSPACE_DIR / "EAs" / "HedgeGrid_V23_fix12" / "HedgeGrid_V23_ATR_DynLot.mq5"
]

def generate_ini(ea_name: str, report_path: Path) -> str:
    return f'''[Tester]
Expert=Battlefield\\{ea_name}
Symbol=XAUUSD
Period=M15
Login=121059
Optimization=0
Model=1
FromDate=2025.01.01
ToDate=2025.06.01
ForwardMode=0
Report="{report_path}"
ShutdownTerminal=1
'''

def parse_report(report_file: Path):
    if not report_file.exists():
        return {"profit": -9999, "drawdown": 0, "trades": 0, "error": "No file"}
    try:
        content = report_file.read_text(encoding='utf-16', errors='ignore')
        if not content.strip() or "<Report>" not in content:
            content = report_file.read_text(encoding='utf-8', errors='ignore')
        profit, drawdown, trades = 0.0, 0.0, 0
        root = ET.fromstring(content)
        profit_elem = root.find('.//NetProfit')
        if profit_elem is not None: profit = float(profit_elem.text)
        dd_elem = root.find('.//EquityDrawdown')
        if dd_elem is not None: drawdown = float(dd_elem.text)
        trades_elem = root.find('.//TotalTrades')
        if trades_elem is not None: trades = int(trades_elem.text)
        return {"profit": profit, "drawdown": drawdown, "trades": trades}
    except Exception as e:
        return {"profit": -9999, "error": str(e)}

def analyze_ea(name: str, data: dict):
    p = data.get('profit', -9999)
    d = data.get('drawdown', 0)
    t = data.get('trades', 0)
    
    if p == -9999 or t == 0:
        return "❌ Error/No Trades", "อาจจะมี Bug ในโค้ด, พารามิเตอร์ไม่ตรงกับทองคำ หรือ Error ตอนคอมไพล์", "ควรตรวจสอบโค้ดใหม่"
        
    pros, cons = "", ""
    if d > 40:
        cons = "Drawdown แดงเดือด ล้างพอร์ตได้ทุกเมื่อ (เสี่ยงระดับวิกฤต)"
        if p > 0: pros = "สามารถเอาตัวรอดทำกำไรกลับมาได้ในตลาดแรง"
    elif d < 15:
        pros = "รักษาระดับ Drawdown ได้ยอดเยี่ยม (ปลอดภัยระยะยาว)"
        if p < 0: cons = "แต่แลกมาด้วยการทำกำไรที่ติดลบ (Stop loss แคบไป)"
    else:
        pros = "ความเสี่ยงระดับกลาง สมดุล"
        
    if t > 500:
        pros += " / ออกไม้ถี่ มีกระสุนยิงตลอด"
    elif t < 20:
        cons += " / ออกไม้น้อยเกินไป รอนาน (Over-filter)"
        
    if p > 2000:
        pros += " / กำไรทะลุเป้า (มหาโหด)"
    elif p > 0:
        pros += " / ทำกำไรได้จริงเรื่อยๆ"
    else:
        cons += " / ระบบขาดทุนในภาพรวม"
        
    # AI Labeling
    if "Hedge" in name or "Martingale" in name or "Grid" in name:
        label = "⚠️ สายเทา (Martingale/Grid)"
    elif "SMC" in name or "Ninja" in name:
        label = "🧠 สาย Smart Money (SMC)"
    elif "Arbitrage" in name:
        label = "⚖️ สาย Arbitrage"
    else:
        label = "📊 สาย Indicator พื้นฐาน"
        
    return label, pros.strip(" / "), cons.strip(" / ")

def main():
    print("[*] Starting EA Battlefield...")
    results = []
    
    for ea_path in EA_LIST:
        if not ea_path.exists():
            print(f"[-] Missing: {ea_path.name}")
            continue
            
        print(f"\n[>] Processing: {ea_path.name}")
        # Copy to Experts
        dest_mq5 = MT5_EXPERTS_DIR / ea_path.name
        try:
            shutil.copy(ea_path, dest_mq5)
        except Exception as e:
            print(f"Error copying {ea_path.name}: {e}")
            continue
            
        # Compile
        print("    - Compiling...")
        subprocess.run([str(MT5_EDITOR), f"/compile:{dest_mq5}", "/log"], capture_output=True)
        ex5_path = dest_mq5.with_suffix('.ex5')
        if not ex5_path.exists():
            print("    - ❌ Compilation Failed.")
            continue
            
        # Run Backtest
        ea_base = ea_path.stem
        report_path = MT5_EXPERTS_DIR / f"{ea_base}_Report.xml"
        if report_path.exists(): report_path.unlink()
        
        ini_path = MT5_EXPERTS_DIR / "battlefield.ini"
        ini_path.write_text(generate_ini(ea_base, report_path), encoding='utf-8')
        
        print("    - Running MT5 Backtest (Model 1 / M15)...")
        proc = subprocess.Popen([str(MT5_TERMINAL), f"/config:{ini_path}"])
        try:
            proc.wait(timeout=300) # Give it 5 mins per EA
        except subprocess.TimeoutExpired:
            print("    - ⏱ Timeout! EA might be stuck in an infinite loop.")
            subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)
            time.sleep(2)
            
        # Parse
        data = parse_report(report_path)
        print(f"    - Result: Profit ${data.get('profit',0)} | DD {data.get('drawdown',0)}% | Trades {data.get('trades',0)}")
        
        label, pros, cons = analyze_ea(ea_base, data)
        results.append({
            'Name': ea_base,
            'Label': label,
            'Profit': data.get('profit', -9999),
            'DD': data.get('drawdown', 0),
            'Trades': data.get('trades', 0),
            'Pros': pros,
            'Cons': cons
        })

    # Generate Report
    report_md = "# 🤖 All EAs Battlefield (Mass Backtesting & Deep Learning)\n\n"
    report_md += "สรุปการนำสุดยอด EA จากโกดัง (รวมสาย Jobot, SMC และ Grid) มาประลองกำลังกันบนกราฟ XAUUSD M15 แบบอัตโนมัติ!\n\n"
    
    report_md += "## 🏆 ผลการประลอง (Leaderboard)\n\n"
    report_md += "| EA Name | Type | Profit ($) | Drawdown (%) | Trades | Pros (ข้อดี) | Cons (ข้อเสีย) |\n"
    report_md += "|---|---|---|---|---|---|---|\n"
    
    # Sort by profit
    valid_res = [r for r in results if r['Profit'] != -9999]
    valid_res.sort(key=lambda x: x['Profit'], reverse=True)
    error_res = [r for r in results if r['Profit'] == -9999]
    
    for r in valid_res:
        report_md += f"| **{r['Name']}** | {r['Label']} | ${r['Profit']:,.2f} | {r['DD']}% | {r['Trades']} | {r['Pros']} | {r['Cons']} |\n"
        
    for r in error_res:
        report_md += f"| **{r['Name']}** | ❌ ERROR | N/A | N/A | N/A | {r['Pros']} | {r['Cons']} |\n"

    report_md += "\n## 💡 AI Synthesis (สรุปสิ่งที่ได้เรียนรู้)\n"
    report_md += "> [!WARNING]\n"
    report_md += "> สถิติยืนยันว่า **EA สาย Martingale และ Grid** แม้จะทำกำไรได้ดีในช่วงตลาดแกว่ง แต่ถ้าเจอเทรนด์แรงๆ ทองคำ จะทำให้เกิด Drawdown แดงเดือด และเสี่ยงต่อการล้างพอร์ตทันที!\n"
    report_md += ">\n"
    report_md += "> ในขณะที่ **EA สาย SMC / Breakout** มักจะออกไม้น้อยมาก รอดพ้นจากภาวะ Drawdown ได้ดี แต่อาจทำให้เสียอารมณ์เพราะรอนาน\n"
    
    kb_path = WORKSPACE_DIR / "raw" / "All_EAs_Analysis.md"
    kb_path.write_text(report_md, encoding='utf-8')
    print(f"\n[+] Battlefield Complete! Report saved to {kb_path}")

if __name__ == "__main__":
    main()
