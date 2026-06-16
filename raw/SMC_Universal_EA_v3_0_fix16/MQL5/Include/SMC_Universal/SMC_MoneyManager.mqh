//+------------------------------------------------------------------+
//| SMC_MoneyManager.mqh — SMC Universal EA v3.0                    |
//| Risk-based lot sizing ใช้ SL distance (universal ทุก asset)     |
//+------------------------------------------------------------------+
#ifndef SMC_MONEYMANAGER_MQH
#define SMC_MONEYMANAGER_MQH

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_SymbolManager.mqh>

class CSMCMoneyManager {
private:
   CSymbolManager* m_sm;
   double          m_riskPct;    // % ของ balance ต่อ trade

public:
   CSMCMoneyManager() { m_sm=NULL; m_riskPct=RISK_PCT_DEF; }

   void SetSymbolManager(CSymbolManager* sm) { m_sm=sm; }
   void SetRiskPct(double pct)               { m_riskPct=(pct>0)?pct:RISK_PCT_DEF; }

   double GetBalance()  const { return AccountInfoDouble(ACCOUNT_BALANCE); }
   double GetEquity()   const { return AccountInfoDouble(ACCOUNT_EQUITY);  }
   double RiskAmount()  const { return GetBalance()*m_riskPct/100.0; }

   //--- คำนวณ lot จาก SL distance (price units) — universal ทุก asset
   //    Lot = RiskAmount / (SL_distance / TickSize × TickValue)
   double CalcLot(const string sym, double entry, double sl) {
      double dist = MathAbs(entry-sl);
      if(dist<=0||m_sm==NULL) return 0.0;

      double tickVal  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
      double tickSize = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
      if(tickVal<=0||tickSize<=0) return 0.0;

      double riskAmt  = RiskAmount();
      double rawLot   = riskAmt / (dist/tickSize*tickVal);
      return m_sm.NormLot(sym, rawLot);
   }

   //--- Risk ที่จะเสีย (USD) จาก lot และ SL distance
   double CalcRisk(const string sym, double lot, double entry, double sl) {
      double dist     = MathAbs(entry-sl);
      double tickVal  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
      double tickSize = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
      if(tickVal<=0||tickSize<=0) return 0.0;
      return lot * (dist/tickSize) * tickVal;
   }
};

#endif
