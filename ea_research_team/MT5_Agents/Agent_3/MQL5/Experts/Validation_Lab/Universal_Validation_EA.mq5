//+------------------------------------------------------------------+
//|                                     Universal_Validation_EA.mq5 |
//|                             EA Knowledge Base Validation System |
//+------------------------------------------------------------------+
#property copyright "EA Research Team"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

input int InpRuleID = 1; // Rule ID (1=MA, 2=RSI, 3=Stoch, 4=MACD, 5=BB)
input double InpRiskPercent = 1.0; // Risk per trade (%)
input int InpStopLossPips = 30; // Fixed SL in pips
input int InpTakeProfitPips = 30; // Fixed TP in pips (1:1 RR)

CTrade trade;
CPositionInfo position;

int handle_ma_fast, handle_ma_slow;
int handle_rsi;
int handle_stoch;
int handle_macd;
int handle_bb;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(12345 + InpRuleID);
   
   // Initialize indicators based on Rule ID
   switch(InpRuleID)
     {
      case 1: // Moving Average Cross
         handle_ma_fast = iMA(_Symbol, _Period, 10, 0, MODE_EMA, PRICE_CLOSE);
         handle_ma_slow = iMA(_Symbol, _Period, 50, 0, MODE_EMA, PRICE_CLOSE);
         break;
      case 2: // RSI
         handle_rsi = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);
         break;
      case 3: // Stochastic
         handle_stoch = iStochastic(_Symbol, _Period, 5, 3, 3, MODE_SMA, STO_LOWHIGH);
         break;
      case 4: // MACD
         handle_macd = iMACD(_Symbol, _Period, 12, 26, 9, PRICE_CLOSE);
         break;
      case 5: // Bollinger Bands
         handle_bb = iBands(_Symbol, _Period, 20, 0, 2.0, PRICE_CLOSE);
         break;
      default:
         Print("Invalid Rule ID: ", InpRuleID);
         return(INIT_FAILED);
     }
     
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }

//+------------------------------------------------------------------+
//| Calculate Lot Size based on 1% Risk                              |
//+------------------------------------------------------------------+
double CalculateLotSize(int sl_points)
  {
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double risk_amount = balance * (InpRiskPercent / 100.0);
   double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   if(tick_value == 0 || tick_size == 0 || sl_points == 0) return SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   
   double risk_per_lot = (sl_points * point / tick_size) * tick_value;
   double lot = risk_amount / risk_per_lot;
   
   double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   lot = MathFloor(lot / step) * step;
   
   if(lot < min_lot) lot = min_lot;
   if(lot > max_lot) lot = max_lot;
   
   return lot;
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Check market hours (Avoid weekend and 23:00-01:00 daily break for XAUUSD)
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   if(dt.day_of_week == 0 || dt.day_of_week == 6) return;
   if(dt.hour == 23 || dt.hour == 0) return;

   // Only 1 trade at a time
   if(PositionsTotal() > 0) return;
   
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   int multiplier = (digits == 3 || digits == 5) ? 10 : 1;
   
   int sl_points = InpStopLossPips * multiplier;
   int tp_points = InpTakeProfitPips * multiplier;
   
   double lot = CalculateLotSize(sl_points);
   
   int signal = 0; // 1 = Buy, -1 = Sell
   
   // Evaluate rule
   switch(InpRuleID)
     {
      case 1: // MA Cross
        {
         double fast[2], slow[2];
         CopyBuffer(handle_ma_fast, 0, 0, 2, fast);
         CopyBuffer(handle_ma_slow, 0, 0, 2, slow);
         if(fast[1] > slow[1] && fast[0] <= slow[0]) signal = 1;
         if(fast[1] < slow[1] && fast[0] >= slow[0]) signal = -1;
        }
        break;
      case 2: // RSI
        {
         double rsi[2];
         CopyBuffer(handle_rsi, 0, 0, 2, rsi);
         if(rsi[1] > 30 && rsi[0] <= 30) signal = 1; // Cross under 30
         if(rsi[1] < 70 && rsi[0] >= 70) signal = -1; // Cross over 70
        }
        break;
      case 3: // Stochastic
        {
         double stoch_m[2], stoch_s[2];
         CopyBuffer(handle_stoch, 0, 0, 2, stoch_m);
         CopyBuffer(handle_stoch, 1, 0, 2, stoch_s);
         if(stoch_m[1] > stoch_s[1] && stoch_m[0] <= stoch_s[0] && stoch_m[1] < 20) signal = 1;
         if(stoch_m[1] < stoch_s[1] && stoch_m[0] >= stoch_s[0] && stoch_m[1] > 80) signal = -1;
        }
        break;
      case 4: // MACD
        {
         double macd_m[2], macd_s[2];
         CopyBuffer(handle_macd, 0, 0, 2, macd_m);
         CopyBuffer(handle_macd, 1, 0, 2, macd_s);
         if(macd_m[1] > macd_s[1] && macd_m[0] <= macd_s[0] && macd_m[1] < 0) signal = 1;
         if(macd_m[1] < macd_s[1] && macd_m[0] >= macd_s[0] && macd_m[1] > 0) signal = -1;
        }
        break;
      case 5: // Bollinger Bands
        {
         double bb_up[1], bb_dn[1];
         CopyBuffer(handle_bb, 1, 0, 1, bb_up);
         CopyBuffer(handle_bb, 2, 0, 1, bb_dn);
         if(ask <= bb_dn[0]) signal = 1;
         if(bid >= bb_up[0]) signal = -1;
        }
        break;
     }
     
   // Execute Trade
   if(signal == 1)
     {
      double sl = ask - (sl_points * point);
      double tp = ask + (tp_points * point);
      trade.Buy(lot, _Symbol, ask, sl, tp, "Validation Rule " + IntegerToString(InpRuleID));
     }
   else if(signal == -1)
     {
      double sl = bid + (sl_points * point);
      double tp = bid - (tp_points * point);
      trade.Sell(lot, _Symbol, bid, sl, tp, "Validation Rule " + IntegerToString(InpRuleID));
     }
  }
//+------------------------------------------------------------------+
