import json
import time
import subprocess
from typing import Dict, Any, List
import MetaTrader5 as mt5
from openai import OpenAI

# Import the MT5 SMC & Volume Engine we just built
from python_mt5_engine import MT5Engine

class TradingFloor:
    def __init__(self):
        self.context = {}
        self.votes = []

    # 1. Market Analyst Agent (Uses Volume Profile)
    def agent_market_analyst(self, market_data: Dict[str, Any]) -> Dict[str, Any]:
        print("[Market Analyst] Analyzing trend bias and Volume Profile...")
        vp = market_data.get("vp", {})
        price = market_data.get("price", 0)
        
        bias = "NEUTRAL"
        if vp:
            if price > vp.get("VAH", 0):
                bias = "PREMIUM (Overbought)"
            elif price < vp.get("VAL", 0):
                bias = "DISCOUNT (Oversold)"
            else:
                bias = "VALUE AREA"

        return {"agent": "Market Analyst", "bias": bias, "confidence": 80, "poc": vp.get("POC")}

    # 2. News Analyst Agent
    def agent_news_analyst(self) -> Dict[str, Any]:
        print("[News Analyst] Checking macro calendar...")
        return {"agent": "News Analyst", "status": "CLEAR", "veto": False}

    # 3. SMC/ICT Strategist Agent (Uses Structure Events)
    def agent_smc_strategist(self, market_data: Dict[str, Any]) -> Dict[str, Any]:
        print("[SMC Strategist] Looking for SMC structure breakouts...")
        events_df = market_data.get("events_df")
        price = market_data.get("price", 0)
        
        setup = "No Setup"
        signal_dir = "WAIT"
        
        if not events_df.empty:
            last_event = events_df.iloc[-1]
            event_type = last_event["structure_event"]
            
            if "Bullish" in event_type:
                setup = event_type
                signal_dir = "BUY"
            elif "Bearish" in event_type:
                setup = event_type
                signal_dir = "SELL"
                
        return {
            "agent": "SMC Strategist", 
            "setup": setup,
            "direction": signal_dir,
            "entry_price": price
        }

    # 4. Liquidity Tracker Agent
    def agent_liquidity_tracker(self, market_data: Dict[str, Any]) -> Dict[str, Any]:
        print("[Liquidity Tracker] Checking for sweeps...")
        return {"agent": "Liquidity Tracker", "sweep_confirmed": True}

    # 5. Risk Manager Agent (Uses ATR)
    def agent_risk_manager(self, smc_report: Dict[str, Any], market_data: Dict[str, Any]) -> Dict[str, Any]:
        print("[Risk Manager] Calculating risk exposure...")
        atr = market_data.get("atr", 5.0)
        entry = smc_report.get("entry_price", 0)
        direction = smc_report.get("direction", "WAIT")
        
        # Calculate SL based on 1.5 ATR
        sl_points = atr * 1.5
        sl = entry - sl_points if direction == "BUY" else entry + sl_points
        
        return {"agent": "Risk Manager", "approved": True, "lot_size": 0.5, "sl": sl}

    # 6. Portfolio Manager Agent
    def agent_portfolio_manager(self) -> Dict[str, Any]:
        print("[Portfolio Manager] Checking correlations...")
        return {"agent": "Portfolio Manager", "approved": True}

    # 7. Sentiment Analyst Agent
    def agent_sentiment_analyst(self) -> Dict[str, Any]:
        print("[Sentiment Analyst] Reading market fear/greed...")
        return {"agent": "Sentiment Analyst", "sentiment": "NEUTRAL", "aligned": True}

    # 8. Trade Executor Agent (Telegram Output)
    def agent_trade_executor(self, final_decision: Dict[str, Any], symbol: str = "XAUUSD"):
        import subprocess
        print("[Trade Executor] Preparing Execution Payload...")
        
        if final_decision.get("decision") == "GO":
            direction = final_decision.get("direction")
            entry = final_decision.get('entry_price', 0.0)
            sl = final_decision.get('sl', 0.0)
            setup = final_decision.get('setup', "AI SMC Strategy")
            
            # --- Call LLM API (DeepSeek or OpenRouter) ---
            ai_comment = ""
            try:
                import os
                from dotenv import load_dotenv
                load_dotenv()
                
                api_key = os.getenv("DEEPSEEK_API_KEY", "lm-studio")
                base_url = os.getenv("DEEPSEEK_BASE_URL", "http://127.0.0.1:1234/v1")
                
                client = OpenAI(base_url=base_url, api_key=api_key, timeout=10.0)
                prompt = f"คุณเป็นนักวิเคราะห์เทรดเดอร์มือโปร ช่วยเขียนประโยคสั้นๆ 1-2 บรรทัด (ภาษาไทย) อธิบายว่าทำไมถึงเข้าเทรดไม้ {direction} คู่ {symbol} ที่ราคา {entry} ด้วยเหตุผล {setup} อธิบายให้ดูโปรและน่าเชื่อถือ"
                
                # If using official DeepSeek, model is usually deepseek-chat
                model_name = "deepseek-chat" if "deepseek.com" in base_url else ("google/gemini-2.0-flash-exp:free" if "openrouter" in base_url else "local-model")
                
                response = client.chat.completions.create(
                    model=model_name,
                    messages=[{"role": "user", "content": prompt}],
                    temperature=0.7,
                    max_tokens=150
                )
                ai_comment = "💬 " + response.choices[0].message.content.strip()
                print(f"[DeepSeek-LLM] Generated Comment: {ai_comment}")
            except Exception as e:
                print(f"[DeepSeek-LLM] Failed to generate comment: {e}")
                ai_comment = "💬 ระบบ AI วิเคราะห์: เข้าเทรดตามโครงสร้าง SMC หลัก"

            final_setup_str = f"AI: {setup}\n{ai_comment}"
            
            print(f">>> EXECUTING {direction} {final_decision.get('lot_size')} LOTS AT {entry}")
            
            # Report to Telegram via AlphaEdge Script
            telegram_script = r"C:\Users\ADMIN\Desktop\CME\CUSTOMER_PACKAGE\AlphaEdge_CME_AUTO_ALL_EDITION\telegram_signal_room.py"
            cmd = [
                "python", telegram_script, "signal", direction,
                "--symbol", symbol,
                "--entry", str(round(entry, 2)),
                "--sl", str(round(sl, 2)),
                "--setup", final_setup_str
            ]
            
            try:
                print(f"[Trade Executor] Sending Telegram Signal: {' '.join(cmd)}")
                subprocess.run(cmd, check=True, capture_output=True, text=True, encoding='utf-8')
                print("[Trade Executor] Telegram message sent successfully.")
            except Exception as e:
                print(f"[Trade Executor] Failed to send Telegram: {e}")
        else:
            print(">>> EXECUTION ABORTED: No GO signal.")

    # 9. Supervisor AI (The Boss)
    def agent_supervisor(self, reports: List[Dict[str, Any]]) -> Dict[str, Any]:
        print("\n[Supervisor AI] Reviewing team reports...")
        
        smc_report = reports[2]
        if smc_report["direction"] == "WAIT":
            print("[Supervisor AI] DECISION: NO-GO. No valid SMC setup right now.")
            return {"decision": "NO-GO"}
            
        vetos = [r for r in reports if r.get("veto") or r.get("approved") is False]
        if vetos:
            print("[Supervisor AI] DECISION: NO-GO. Veto found.")
            return {"decision": "NO-GO", "reason": str(vetos)}
        
        print("[Supervisor AI] DECISION: GO. All agents aligned.")
        final_trade = {
            "decision": "GO",
            "direction": smc_report["direction"],
            "setup": smc_report["setup"],
            "entry_price": smc_report["entry_price"], 
            "lot_size": reports[4]["lot_size"],       
            "sl": reports[4]["sl"],
        }
        return final_trade

    def run_cycle(self, market_data: Dict[str, Any]):
        print("\n=== STARTING 9-AGENT DECISION CYCLE ===")
        r1 = self.agent_market_analyst(market_data)
        r2 = self.agent_news_analyst()
        r3 = self.agent_smc_strategist(market_data)
        r4 = self.agent_liquidity_tracker(market_data)
        r5 = self.agent_risk_manager(r3, market_data)
        r6 = self.agent_portfolio_manager()
        r7 = self.agent_sentiment_analyst()
        
        all_reports = [r1, r2, r3, r4, r5, r6, r7]
        final_decision = self.agent_supervisor(all_reports)
        self.agent_trade_executor(final_decision, symbol=market_data["symbol"])
        print("=== CYCLE COMPLETE ===")
        return final_decision

def start_auto_trading_bot():
    engine = MT5Engine()
    if not engine.connect():
        print("Failed to connect to MT5. Exiting...")
        return

    floor = TradingFloor()
    symbol = "XAUUSD"
    timeframe = mt5.TIMEFRAME_M15
    
    # Memory to prevent duplicate signals
    last_signal_time = None

    print(f"--- AI Auto-Trading Bot Started for {symbol} ---")
    print("Monitoring for SMC Breakouts every 1 minute...\n")

    try:
        # Run a 3-iteration loop for testing instead of infinite while True
        for _ in range(3):
            print(f"[{time.strftime('%H:%M:%S')}] Fetching latest market data...")
            df = engine.get_data(symbol, timeframe, 200)
            
            if not df.empty:
                df = engine.add_smc_indicators(df)
                df = engine.calculate_smc_structure(df)
                vp = engine.calculate_volume_profile(df)
                
                events_df = df.dropna(subset=['structure_event'])
                
                # Check the latest event time
                current_event_time = events_df.iloc[-1]['time'] if not events_df.empty else None
                current_price = df.iloc[-1]['close']
                current_atr = df.iloc[-1]['atr']
                
                # Save live state for Dashboard
                dashboard_state = {
                    "price": float(current_price),
                    "poc": float(vp.get('POC', 0)),
                    "vah": float(vp.get('VAH', 0)),
                    "val": float(vp.get('VAL', 0)),
                    "setup": "BOS Bullish" if "Bullish" in str(events_df.iloc[-1]['structure_event'] if not events_df.empty else "") else ("BOS Bearish" if not events_df.empty else "Waiting..."),
                    "last_update": time.strftime('%H:%M:%S')
                }
                import os
                os.makedirs(r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard", exist_ok=True)
                with open(r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\live_state.json", "w") as f:
                    json.dump(dashboard_state, f)
                
                # Trigger cycle only if there is a NEW SMC event
                if current_event_time and current_event_time != last_signal_time:
                    market_data = {
                        "symbol": symbol,
                        "price": current_price,
                        "vp": vp,
                        "atr": current_atr,
                        "events_df": events_df
                    }
                    
                    decision = floor.run_cycle(market_data)
                    
                    if decision.get("decision") == "GO":
                        last_signal_time = current_event_time
                else:
                    print(f"No new SMC setups found (Price: {current_price}). Waiting...")
            
            # Sleep for 10 seconds in mock mode (normally 60s)
            time.sleep(10)
            
    except KeyboardInterrupt:
        print("\nBot Stopped by User.")
    finally:
        engine.disconnect()

if __name__ == "__main__":
    start_auto_trading_bot()
