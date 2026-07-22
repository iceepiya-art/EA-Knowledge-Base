import os
import time
import requests
import logging
from typing import Optional, Dict, Any
from datetime import datetime
from zoneinfo import ZoneInfo

logging.basicConfig(level=logging.INFO, format='%(asctime)s - TOPSTEPX - %(message)s')

class TopstepXClient:
    """
    Template Executor for ProjectX (TopstepX) API.
    Handles authentication, order placement, and contract scaling validation
    specifically designed for a $50K Express Funded Account using MICRO contracts.
    """
    
    BASE_URL = "https://api.topstepx.com"
    
    # Map MT5 CFD symbols to Topstep Futures symbols (Micro contracts by default)
    SYMBOL_MAP = {
        "USTEC": "MNQ",
        "US100": "MNQ",
        "US30": "MYM",
        "US500": "MES",
        "SPX500": "MES",
        "XAUUSD": "MGC",
        "BTCUSD": "MBT"
    }

    def __init__(self):
        self.api_key = os.getenv('TOPSTEPX_API_KEY', '')
        self.username = os.getenv('TOPSTEPX_USERNAME', '')
        self.token = None
        self.session = requests.Session()
        
        # Circuit Breaker Variables
        self.start_of_day_balance = 0.0 # Will be initialized on first auth
        self.halt_trading = False
        self.last_signal_id = ""
        self.last_account_id = None
        self.last_contract_id = None
        
        if not self.api_key:
            logging.warning("TOPSTEPX_API_KEY is not set in environment variables.")

    def authenticate(self) -> bool:
        """
        Authenticate with ProjectX Gateway to receive a JWT using loginKey.
        """
        try:
            auth_url = f"{self.BASE_URL}/api/Auth/loginKey"
            payload = {
                "userName": self.username,
                "apiKey": self.api_key
            }
            response = self.session.post(auth_url, json=payload, headers={"accept": "text/plain", "Content-Type": "application/json"})
            if response.status_code == 200:
                data = response.json()
                if data.get("success"):
                    self.token = data.get("token")
                    self.session.headers.update({"Authorization": f"Bearer {self.token}"})
                    logging.info("TopstepX Authentication Successful.")
                    
                    if self.start_of_day_balance == 0.0:
                        bal = self.get_account_balance()
                        if bal > 0:
                            self.start_of_day_balance = bal
                            logging.info(f"Start of Day Balance recorded: ${self.start_of_day_balance:,.2f}")
                            
                    return True
                else:
                    logging.error(f"TopstepX Auth Failed: {data.get('errorMessage')}")
                    return False
            else:
                logging.error(f"TopstepX Auth HTTP Error: {response.status_code}")
                return False
        except Exception as e:
            logging.error(f"Authentication failed: {e}")
            return False

    def validate_micro_scaling(self, balance: float, requested_contracts: int) -> int:
        """
        Enforce Topstep's 50K Scaling Plan for MICRO contracts.
        Ratio is 10:1 (Mini:Micro). Limits: 20 -> 30 -> 50.
        """
        max_allowed = 0
        
        if balance < 51500:
            max_allowed = 20  # 2 Mini equivalents
        elif 51500 <= balance < 52000:
            max_allowed = 30  # 3 Mini equivalents
        else:
            max_allowed = 50  # 5 Mini equivalents

        if requested_contracts > max_allowed:
            logging.warning(f"Scaling limit exceeded! Requested: {requested_contracts}, Allowed: {max_allowed} (Balance: ${balance:,.2f})")
            logging.warning(f"Auto-slicing order down to {max_allowed} micro contracts to prevent rule violation.")
            return max_allowed
        
        return requested_contracts

    def calculate_futures_contracts(self, symbol: str, balance: float, entry_price: float, sl_price: float) -> int:
        """
        Calculate integer contract size based on user's specific rule:
        Trading capital is $2,000 (Topstep Max Loss Limit), divided into 20 bullets.
        Therefore, fixed risk budget = $100 per trade.
        """
        if sl_price <= 0 or entry_price <= 0:
            return 1 # Default to 1 if no SL provided
            
        # Determine Point Value based on symbol
        point_value = 2.0 # Default (e.g. MNQ)
        if "MGC" in symbol or "XAU" in symbol:
            point_value = 10.0 # Micro Gold is $10 per point
            
        # User explicitly requested: $2000 capital / 20 trades = $100 per trade
        risk_budget = 2000.0 / 20.0
        
        sl_points = abs(entry_price - sl_price)
        if sl_points == 0:
            return 1
            
        risk_per_contract = sl_points * point_value
        
        if risk_per_contract > 0:
            contracts = int(risk_budget // risk_per_contract) # Floor division
        else:
            contracts = 1
            
        # If the risk budget is too tight for even 1 contract, default to 1 micro
        return max(1, contracts)

    def get_account_balance(self) -> float:
        """
        Fetch current account balance via ProjectX API.
        """
        url = f"{self.BASE_URL}/api/Account/search"
        payload = {"onlyActiveAccounts": True}
        try:
            res = self.session.post(url, json=payload)
            data = res.json()
            if data.get("success") and data.get("accounts"):
                # Returns list of accounts. Get balance of the first active account.
                return float(data["accounts"][0].get("balance", 50000.00))
        except Exception as e:
            logging.error(f"Failed to fetch balance: {e}")
        return 50000.00
        
    def get_account_id(self) -> int:
        """Fetch the first active account ID."""
        url = f"{self.BASE_URL}/api/Account/search"
        payload = {"onlyActiveAccounts": True}
        try:
            res = self.session.post(url, json=payload)
            data = res.json()
            if data.get("success") and data.get("accounts"):
                return data["accounts"][0]["id"]
        except Exception as e:
            logging.error(f"Failed to get account ID: {e}")
        return 1

    def get_risk_snapshot(self) -> Dict[str, Any]:
        """Return the selected account's live balance/equity and configured MLL.

        A Topstep order must fail closed when its account cannot be resolved or
        when MLL is unavailable.  The API model has changed field names over
        time, so accepted aliases are intentionally explicit.
        """
        expected = os.getenv("TOPSTEP_ACCOUNT_ID", "").strip()
        response = self.session.post(f"{self.BASE_URL}/api/Account/search", json={"onlyActiveAccounts": True})
        data = response.json()
        accounts = data.get("accounts", []) if data.get("success") else []
        account = next((item for item in accounts if not expected or str(item.get("id")) == expected), None)
        if not account:
            return {"ok": False, "reason": "topstep_account_not_found"}
        balance = float(account.get("balance", 0.0) or 0.0)
        unrealized = float(account.get("unrealizedPnl", account.get("openPnl", account.get("openProfitLoss", 0.0))) or 0.0)
        equity = float(account.get("equity", balance + unrealized) or 0.0)
        configured_floor = os.getenv("TOPSTEP_MLL_FLOOR", "").strip()
        api_floor = account.get("maximumLossLimit", account.get("maxLossLimit", account.get("mllFloor")))
        try:
            mll_floor = float(configured_floor or api_floor)
        except (TypeError, ValueError):
            return {"ok": False, "reason": "topstep_mll_not_configured", "account": account}
        return {"ok": True, "account_id": account.get("id"), "balance": balance, "equity": equity, "mll_floor": mll_floor}

    def get_contract_id(self, symbol_name: str) -> str:
        """Find the contract ID for the given symbol."""
        url = f"{self.BASE_URL}/api/Contract/available"
        payload = {"live": False}
        try:
            res = self.session.post(url, json=payload)
            data = res.json()
            if data.get("success"):
                for contract in data.get("contracts", []):
                    if contract.get("name") == symbol_name or contract.get("symbolId", "").endswith(symbol_name):
                        return contract.get("id")
        except Exception as e:
            logging.error(f"Failed to fetch contracts: {e}")
        return ""

    def place_order(self, symbol: str, action: str, entry_price: float, sl: Optional[float] = None, tp: Optional[float] = None) -> Dict[str, Any]:
        """
        Submit a trade to the TopstepX REST API.
        Action: "BUY" or "SELL"
        """
        if not self.authenticate():
            return {"error": "Authentication failed"}

        snapshot = self.get_risk_snapshot()
        if not snapshot.get("ok"):
            logging.critical("Topstep risk guard blocked order: %s", snapshot.get("reason"))
            return {"error": snapshot.get("reason", "topstep_risk_snapshot_failed")}
        current_balance = float(snapshot["balance"])
        account_id = int(snapshot["account_id"])
        
        # Convert MT5 Symbol to Topstep Futures Symbol
        clean_symbol = symbol.replace(".m", "").replace("m", "").replace("-", "") # Cleanup MT5 suffixes
        topstep_symbol = self.SYMBOL_MAP.get(clean_symbol, symbol)

        # Calculate optimal contracts based on 0.1% risk of balance
        raw_contracts = self.calculate_futures_contracts(
            symbol=topstep_symbol,
            balance=current_balance, 
            entry_price=entry_price, 
            sl_price=sl if sl else 0.0
        )
        
        # Enforce Scaling Plan
        safe_contracts = self.validate_micro_scaling(current_balance, raw_contracts)
        from account_risk_guard import evaluate_topstep
        max_contracts = int(os.getenv("TOPSTEP_MAX_CONTRACTS", "0") or 0)
        if max_contracts <= 0:
            logging.critical("Topstep risk guard blocked order: TOPSTEP_MAX_CONTRACTS is required.")
            return {"error": "topstep_contract_limit_not_configured"}
        decision = evaluate_topstep(
            equity=float(snapshot["equity"]), mll_floor=float(snapshot["mll_floor"]),
            requested_contracts=safe_contracts, max_contracts=max_contracts,
            now=datetime.now(ZoneInfo("America/Chicago")),
        )
        if not decision.allowed:
            logging.critical("Topstep risk guard blocked order: %s (MLL remaining $%.2f)", decision.reason, decision.max_remaining or 0.0)
            return {"error": decision.reason, "mll_remaining": decision.max_remaining}
        
        contract_id = self.get_contract_id(topstep_symbol)
        if not contract_id:
             logging.error(f"Could not find valid contract ID for {topstep_symbol}")
             return {"error": f"Invalid contract for {topstep_symbol}"}

        self.last_account_id = account_id
        self.last_contract_id = contract_id

        # ProjectX API: side 1 = Buy, side 2 = Sell
        # ProjectX API: type 2 = Market Order
        side = 1 if action.upper() == "BUY" else 2
        
        order_payload = {
            "accountId": account_id,
            "contractId": contract_id,
            "type": 2, # Market
            "side": side,
            "size": safe_contracts
        }
        
        logging.info(f"Dispatching API Order to TopstepX: {order_payload}")
        
        order_url = f"{self.BASE_URL}/api/Order/place"
        try:
            response = self.session.post(order_url, json=order_payload)
            data = response.json()
            if data.get("success"):
                logging.info(f"TopstepX Order Placed: ID {data.get('orderId')}")
                
                # We would also place separate Stop Loss and Take Profit orders here,
                # but ProjectX requires specific Bracket endpoints. Using Virtual SL/TP instead.
                import json
                virtual_pos_path = os.path.join(os.path.dirname(__file__), "virtual_position.json")
                try:
                    with open(virtual_pos_path, "w") as f:
                        json.dump({
                            "symbol": topstep_symbol,
                            "mt5_symbol": symbol,
                            "side": side,
                            "entry_price": entry_price,
                            "sl": sl if sl else 0.0,
                            "tp": tp if tp else 0.0,
                            "orderId": data.get("orderId"),
                            "timestamp": datetime.now().isoformat()
                        }, f)
                except Exception as e:
                    logging.error(f"Failed to save virtual position: {e}")

                return {"status": "success", "order": order_payload, "orderId": data.get("orderId")}
            else:
                logging.error(f"TopstepX Order Failed: {data.get('errorMessage')}")
                return {"error": data.get('errorMessage')}
        except Exception as e:
            return {"error": str(e)}

    def flatten_all(self):
        """
        Emergency close all open positions and cancel working orders.
        """
        logging.critical("Executing TOPSTEPX FLATTEN ALL command via API!")
        
        if self.last_account_id and self.last_contract_id:
            close_url = f"{self.BASE_URL}/api/Position/closeContract"
            payload = {
                "accountId": self.last_account_id,
                "contractId": self.last_contract_id
            }
            try:
                res = self.session.post(close_url, json=payload)
                data = res.json()
                if data.get("success"):
                    logging.info(f"Flatten Successful: Position on {self.last_contract_id} closed.")
                    
                    # Clear virtual position
                    import json
                    virtual_pos_path = os.path.join(os.path.dirname(__file__), "virtual_position.json")
                    if os.path.exists(virtual_pos_path):
                        try:
                            os.remove(virtual_pos_path)
                            self.last_contract_id = None
                            self.last_account_id = None
                        except Exception as e:
                            logging.error(f"Failed to clear virtual position: {e}")
                else:
                    logging.error(f"Flatten Failed: {data.get('errorMessage')}")
            except Exception as e:
                logging.error(f"Flatten exception: {e}")
        else:
            logging.warning("No recent contract tracked to flatten.")
            
        return True

    def get_virtual_position(self) -> Optional[Dict[str, Any]]:
        import json
        virtual_pos_path = os.path.join(os.path.dirname(__file__), "virtual_position.json")
        if os.path.exists(virtual_pos_path):
            try:
                with open(virtual_pos_path, "r") as f:
                    return json.load(f)
            except:
                pass
        return None

    def check_circuit_breakers(self) -> bool:
        """
        Check Daily Loss Limit (-$950) and Hard Profit Target ($1500).
        Returns True if trading should be Halted.
        """
        if self.halt_trading:
            return True
            
        current_balance = self.get_account_balance()
        # Simulated Floating P&L for now (would be fetched from API)
        floating_pnl = 0.0
        
        daily_pnl = (current_balance + floating_pnl) - self.start_of_day_balance
        
        if daily_pnl <= -950.0:
            logging.critical(f"CIRCUIT BREAKER HIT: Daily Loss at ${daily_pnl:.2f} (Limit is -$1000). Halting trading to prevent rule violation!")
            self.flatten_all()
            self.halt_trading = True
            return True
            
        if daily_pnl >= 1500.0:
            logging.critical(f"PROFIT TARGET HIT: Daily Profit at ${daily_pnl:.2f} (50% Consistency Cap). Securing the bag and halting trading for the day!")
            self.flatten_all()
            self.halt_trading = True
            return True
            
        return False

    def start_polling(self, flask_url: str = "http://127.0.0.1:5000"):
        """
        Poll the local Flask server for signals and execute them in TopstepX.
        """
        logging.info("Starting TopstepX Executor Signal Poller...")
        while True:
            try:
                if self.check_circuit_breakers():
                    time.sleep(60)
                    continue
                    
                response = requests.get(f"{flask_url}/api/signals/latest", timeout=5)
                if response.status_code == 200:
                    data = response.json()
                    signal_id = data.get("signal_id")
                    
                    if signal_id and signal_id != self.last_signal_id:
                        self.last_signal_id = signal_id
                        action = data.get("action")
                        symbol = data.get("symbol")
                        sl = data.get("sl")
                        tp = data.get("tp")
                        
                        # Use simulated current price from data or 0
                        # Real system would fetch live price from TopstepX
                        entry_price = 0.0 
                        if sl: sl = float(sl)
                        if tp: tp = float(tp)
                        
                        if action in ["BUY", "SELL"]:
                            self.place_order(symbol, action, entry_price, sl, tp)
            
            except Exception as e:
                logging.error(f"Polling error: {e}")
                
            time.sleep(1)

if __name__ == "__main__":
    # Test the scaling logic
    client = TopstepXClient()
    
    # Test 1: Start of 50K account
    safe_qty = client.validate_micro_scaling(50000, 25)
    print(f"Test 1 (Balance 50k, request 25): Executed {safe_qty}") # Should be 20
    
    # Test 2: Grew to 51.6K
    safe_qty = client.validate_micro_scaling(51600, 35)
    print(f"Test 2 (Balance 51.6k, request 35): Executed {safe_qty}") # Should be 30
