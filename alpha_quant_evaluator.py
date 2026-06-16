import json
import math

class AlphaQuantEvaluator:
    def __init__(self, stats: dict):
        self.stats = stats
        self.score = 0
        self.level = "UNKNOWN"
        self.edge = 0.0
        self.prop_score = 0.0
        self.strengths = []

    def evaluate(self):
        # 1. Parse Key Metrics
        profit_factor = float(self.stats.get("Profit Factor", "1.0"))
        net_profit = float(str(self.stats.get("Total Net Profit", "0")).replace("$","").replace(",",""))
        max_dd_pct = float(str(self.stats.get("Maximal Drawdown", "0")).split("%")[0].strip() or "0")
        total_trades = int(self.stats.get("Total Trades", "0"))
        win_rate = float(str(self.stats.get("Profit Trades (% of total)", "0")).split("%")[0].strip() or "0")
        
        # 2. Alpha Score Calculation (0-100)
        score = 0
        if profit_factor >= 2.0: score += 30
        elif profit_factor >= 1.5: score += 20
        elif profit_factor > 1.0: score += 10
        
        if max_dd_pct <= 3.0: score += 35
        elif max_dd_pct <= 5.0: score += 25
        elif max_dd_pct <= 10.0: score += 15
        
        if win_rate >= 70: score += 20
        elif win_rate >= 50: score += 10
        
        if total_trades > 100: score += 15
        elif total_trades > 50: score += 5
        
        self.score = min(100, score)
        
        # Level
        if self.score >= 85: self.level = "ELITE"
        elif self.score >= 70: self.level = "PRO"
        elif self.score >= 50: self.level = "AVERAGE"
        else: self.level = "POOR"
        
        # 3. Prop Firm Readiness (0-10)
        prop = 0
        if max_dd_pct <= 5.0: prop += 5
        elif max_dd_pct <= 10.0: prop += 2
        
        if profit_factor > 1.5: prop += 3
        if total_trades > 50: prop += 2
        
        self.prop_score = min(10.0, prop)
        
        # 4. Strengths
        if max_dd_pct <= 5.0:
            self.strengths.append({"title": "LOW DRAWDOWN", "desc": f"Only {max_dd_pct}% Max DD"})
        if win_rate >= 70:
            self.strengths.append({"title": "HIGH WIN RATE", "desc": f"{win_rate}% Win Rate"})
        if profit_factor >= 1.5:
            self.strengths.append({"title": "STRONG PROFIT FACTOR", "desc": f"{profit_factor} PF"})
            
        return {
            "alpha_score": self.score,
            "level": self.level,
            "prop_score": self.prop_score,
            "strengths": self.strengths
        }

if __name__ == "__main__":
    mock_data = {
        "Profit Factor": "1.85",
        "Total Net Profit": "2616.45",
        "Maximal Drawdown": "2.06%",
        "Total Trades": "145",
        "Profit Trades (% of total)": "82.57%"
    }
    evaluator = AlphaQuantEvaluator(mock_data)
    result = evaluator.evaluate()
    print("AI Alpha Score Result:")
    print(json.dumps(result, indent=2))
