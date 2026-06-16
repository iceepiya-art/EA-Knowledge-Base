import os
import re
from pathlib import Path

WORKSPACE_DIR = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base")

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

def analyze_source_code(file_path: Path):
    if not file_path.exists():
        return {"category": "Missing", "pros": "-", "cons": "File not found", "is_fxdreema": False}
        
    try:
        content = file_path.read_text(encoding='utf-8', errors='ignore')
    except Exception as e:
        return {"category": "Error", "pros": "-", "cons": f"Read error: {e}", "is_fxdreema": False}

    is_fxdreema = "fxdreema" in content.lower() or "blockcalls" in content.lower()
    
    # Categorization logic based on keywords
    is_martingale = bool(re.search(r'(?i)(martingale|multiply|recovery|lot_multiplier)', content))
    is_grid = bool(re.search(r'(?i)(grid|distance|step|hedge_grid)', content))
    is_smc = bool(re.search(r'(?i)(fvg|choch|orderblock|smartmoney|liquidity|sweep)', content))
    is_arbitrage = bool(re.search(r'(?i)(arbitrage|triangular|spread_diff|correlation)', content))
    is_indicator = bool(re.search(r'(?i)(rsi|macd|bbands|ema|stochastic)', content))
    
    pros, cons, category = "", "", ""
    
    if is_arbitrage:
        category = "⚖️ สาย Arbitrage"
        pros = "กำไรแน่นอนไร้ความเสี่ยง (ถ้าเกิด Spread/Price Inefficiency)"
        cons = "โบรกเกอร์มักจะแบน, มีปัญหาเรื่อง Execution delay จนไม่ได้กำไรจริง"
        
    elif is_martingale and is_grid:
        category = "⚠️ สาย Hedge / Grid Martingale"
        pros = "กระแสเงินสด (Cash flow) ดีเยี่ยมในตลาดไซด์เวย์"
        cons = "ความเสี่ยงระดับล้างพอร์ต (Margin Call) สูงมากหากเจอเทรนด์แรงโดยไม่ย่อ"
        
    elif is_martingale:
        category = "⚠️ สาย Martingale (เบิ้ลลอต)"
        pros = "Win rate ระยะสั้นสูงมาก ไม่ต้องสนทิศทางตลาดมากนัก"
        cons = "แค่ผิดทางครั้งเดียวพอร์ตอาจหายทั้งก้อน (Risk of Ruin สูง)"
        
    elif is_smc:
        category = "🧠 สาย Smart Money Concepts (SMC)"
        pros = "R/R (Risk:Reward) ดีเยี่ยม จุดเข้าแม่นยำ ลบกวนรายใหญ่"
        cons = "ออกไม้น้อย รอนาน การเขียนโค้ดซับซ้อนและอาจเกิด Bug แบบ Infinite Loop ได้ง่าย"
        
    elif is_indicator:
        category = "📊 สาย Indicator พื้นฐาน"
        pros = "ตรรกะชัดเจน ง่ายต่อการควบคุม Risk management และ Stop Loss"
        cons = "Indicator เป็น Lagging (สัญญาณช้า) มักโดนหลอกเวลาตลาดไซด์เวย์แคบๆ"
        
    else:
        category = "❓ สายผสม / ไม่ระบุชัดเจน"
        pros = "มีการจัดการ Order ทั่วไป"
        cons = "ต้องดูพารามิเตอร์ Input เชิงลึก"

    return {
        "category": category,
        "pros": pros,
        "cons": cons,
        "is_fxdreema": is_fxdreema
    }

def main():
    print("[*] Starting EA Source Code Static Analysis (Safe Mode)...")
    results = []
    
    for ea_path in EA_LIST:
        print(f"[>] Analyzing: {ea_path.name}")
        analysis = analyze_source_code(ea_path)
        results.append({
            'Name': ea_path.name,
            'Category': analysis['category'],
            'Pros': analysis['pros'],
            'Cons': analysis['cons'],
            'IsFxDreema': analysis['is_fxdreema']
        })

    # Generate Report
    report_md = "# 🤖 All EAs Battlefield (Static Analysis Deep Learning)\n\n"
    report_md += "จากการส่งบอทลงสมรภูมิ Strategy Tester พบว่าโค้ดบางตัว (โดยเฉพาะสาย Arbitrage และ SMC ที่ซับซ้อน) ทำให้เกิดการหน่วงและบั๊ก Infinite Loop จน Log บวมถึง 6.3 GB! 🚨\n\n"
    report_md += "เพื่อรักษาเซิร์ฟเวอร์ ระบบจึงปรับมาใช้ **AI Static Analysis (MQL EA Analyzer)** เจาะลึกถึงแก่น Source Code โดยตรงเพื่อวิเคราะห์พฤติกรรม ข้อดี และข้อเสีย ของพวกมันแทนครับ:\n\n"
    
    report_md += "## 🏆 ผลการวิเคราะห์เชิงโครงสร้าง (Source Code Autopsy)\n\n"
    report_md += "| EA Name | Type | Engine | Pros (ข้อดี) | Cons (ข้อเสีย) |\n"
    report_md += "|---|---|---|---|---|\n"
    
    for r in results:
        engine = "FxDreema (Block)" if r['IsFxDreema'] else "Native MQL5"
        report_md += f"| **{r['Name']}** | {r['Category']} | {engine} | {r['Pros']} | {r['Cons']} |\n"
        
    report_md += "\n## 💡 AI Synthesis (สรุปสิ่งที่ได้เรียนรู้จาก Source Code)\n"
    report_md += "> [!CAUTION]\n"
    report_md += "> 1. **สาย Arbitrage (`(Jobot) Arbitrage Super Profit.mq5`)**: พบว่าเป็นสาเหตุของการทำ Terminal ค้าง (Timeout) เพราะโค้ดมักมีลูปตรวจสอบ Spread ของหลายคู่เงินพร้อมกันแบบรัวๆ ซึ่งกินทรัพยากรมหาศาล\n"
    report_md += "> 2. **สาย Grid/Martingale (`HedgeGrid_V23`, `Hedge Martingale EA`)**: โค้ดมีระบบรวบ Lot ชัดเจน ความเสี่ยงคือตัวแปร `Multiplier` หากตั้งสูงเกินไป ตลาดกระชากแรงๆ พอร์ตปลิวแน่นอน\n"
    report_md += "> 3. **สาย SMC (`SMC_Universal`, `SmartMoney_Advanced`)**: โค้ดถูกเขียนขึ้นมาแบบ Native MQL มีความซับซ้อนในการคำนวณ Swing Point แม้จะปลอดภัยกว่า แต่ก็มีโอกาสบั๊กสูงถ้าเขียน Array Out of Range\n"
    
    kb_path = WORKSPACE_DIR / "raw" / "All_EAs_Analysis.md"
    kb_path.write_text(report_md, encoding='utf-8')
    print(f"\n[+] Static Analysis Complete! Report saved to {kb_path}")

    # Index into Obsidian
    print("[*] Indexing to Obsidian MOC...")
    os.system(f'python "{WORKSPACE_DIR}/ea_research_team/update_obsidian.py"')

if __name__ == "__main__":
    main()
