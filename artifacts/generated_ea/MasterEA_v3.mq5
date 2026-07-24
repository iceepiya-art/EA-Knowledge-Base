//+------------------------------------------------------------------+
//|                                                  MasterEA_v3.mq5 |
//|                                  Copyright 2026, EA-Knowledge-Base |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "EA-Knowledge-Base"
#property link      "https://www.mql5.com"
#property version   "3.00"

#include <Trade\Trade.mqh>

enum ENUM_ACCOUNT_RISK_PROFILE
  {
   ACCOUNT_PROFILE_PERSONAL = 0,
   ACCOUNT_PROFILE_FTMO_2STEP = 1,
   ACCOUNT_PROFILE_TOPSTEP = 2
  };

input group "=== API Configuration ==="
input string    API_SERVER          = "http://127.0.0.1:5000"; 
input int       WebRequestTimeoutMs = 10000;
input int       MagicNumber         = 999;
input double    RiskPercent         = 0.20; // Base risk; FTMO ladder overrides when enabled
input double    MaxRiskPerTradeDollar = 12.50; // 0.25% of a $5K evaluation

input group "=== Account Lock / Risk Profile ==="
input ENUM_ACCOUNT_RISK_PROFILE AccountRiskProfile = ACCOUNT_PROFILE_PERSONAL;
input long      ExpectedAccountLogin = 0; // 0 disables the login lock
input double    PersonalEquityFloor = 0.0; // 0 disables personal floor
input double    FTMOInitialBalance = 0.0; // Required for FTMO 2-Step
input double    FTMOSafetyBufferPercent = 20.0; // Block before the 5%% daily / 10%% max limit
input double    FTMODailyInternalLossPercent = 4.0; // Internal stop, stricter than FTMO 5%%
input bool      EnableFTMORiskLadder = true;
input double    FTMORiskStep1 = 0.20;
input double    FTMORiskStep2 = 0.25;
input double    FTMORiskStep3 = 0.30;
input double    FTMORiskStep4 = 0.35;
input int       FTMOMaxConsecutiveSL = 12;

input group "=== Prop Firm / Topstep Safety ==="
input double    MaxDailyLossDollar  = 0.0;    // 0 disables this legacy broker-day circuit breaker; FTMO 4%% guard remains active
input double    MaxDailyProfitDollar = 0.0;   // 0 disables this optional broker-day profit stop
input int       MaxOpenPositionsPerSymbol = 1;
input int       MaxSpreadPoints     = 50;      // Skip signals if spread is > 50 points
input int       StartTradingHour    = 14;      // Avoid Asian Session (e.g. 14 = London Open)
input int       EndTradingHour      = 22;      // Avoid Asian Session (e.g. 22 = NY Close)
input bool      DemoAfternoonWindow = true;   // Demo: broker 10:00-14:00 (Thai 14:00-18:00)
input bool      Demo24HourTestMode = true;    // Forward-statistics mode: observe all broker hours (execution remains dry-run)
input bool      UAT_AllowAllHoursForSignalTest = false; // UAT only: bypass hour gate for journal evidence
input bool      UAT_DryRunNoTradeForSignalTest = false; // UAT only: log accepted signals without placing orders
input bool      UseM1ExecutionContext = true; // DEMO TEST: use M1 ATR/risk context with tick execution
input int       TradeCooldownSeconds = 60;   // DEMO TEST: minimum time between accepted trade attempts

input group "=== Native MT5 USD News Guard ==="
input bool      UseMT5EconomicCalendar = true;
input int       MT5NewsBlockBeforeMinutes = 60;
input int       MT5NewsBlockAfterMinutes  = 60;
input bool      MT5PushNewsAlert = true;

input group "=== Survivor Mechanics ==="
input int       RRStepTrailStart    = 3;    // At +3R, lock +1R
input int       RRStepTrailOffset   = 2;    // Locked R = achieved R - 2

input group "=== Grid / Recovery Mechanics (DEACTIVATED) ==="
input int       AutoGridStepPoints  = 250;  
// Grid and loss-recovery scaling are intentionally unavailable in this FTMO EA.
// Keeping these as constants prevents an input change from re-enabling either path.
const bool      EnableAutoGrid      = false;
const bool      AllowRecoveryScaling = false;
input int       MaxGridSteps        = 7;    

// Strategy Parameters (Updated Dynamically from /api/strategy/daily)
double VirtualTP_ATR_Multiplier = 4.0;
double VirtualSL_ATR_Multiplier = 2.0;
double BreakEven_ATR_Multiplier = 1.5;
double RecoveryLotMultiplier    = 1.0;

bool EnableRunner = true;
CTrade trade;
string lastSignalId = "";
string latestCmeDataString = "";
datetime lastStrategyCheckTime = 0;
datetime lastTradeAttemptTime = 0;
ulong    lastNativeNewsAlertEventId = 0;
// Compatibility values are only referenced by ManageLegacyTrades_Disabled(),
// which is never called. Live exits use ManageTrades() RR step trailing.
double legacy_target_profit_percent = 0.1;
double legacy_trail_profit_percent = 0.05;
double legacy_highest_usd_profit = 0;

int h_atr;

// FTMO's daily-loss day changes at midnight in Prague time (CET/CEST), not
// at the broker's server midnight.  The two variables form one persistent
// transaction: date key first, then the balance captured for that date.
string FTMOResetKeyPrefix()
  {
   return "MasterEA_v3_FTMO_reset_" + (string)AccountInfoInteger(ACCOUNT_LOGIN) + "_";
  }

int LastSundayOfMonth(const int year,const int month)
  {
   MqlDateTime d;
   d.year=year; d.mon=month+1; d.day=1; d.hour=0; d.min=0; d.sec=0;
   if(month==12) { d.year=year+1; d.mon=1; }
   datetime first_next=StructToTime(d);
   datetime last_day=first_next-86400;
   MqlDateTime last;
   TimeToStruct(last_day,last);
   return last.day-last.day_of_week;
  }

// EU DST: 01:00 UTC on the final Sunday of March through 01:00 UTC on the
// final Sunday of October.  Using UTC makes this independent of MT5 broker time.
bool IsCentralEuropeSummerTime(const datetime utc)
  {
   MqlDateTime d; TimeToStruct(utc,d);
   int march_day=LastSundayOfMonth(d.year,3);
   int october_day=LastSundayOfMonth(d.year,10);
   MqlDateTime start; start.year=d.year; start.mon=3; start.day=march_day; start.hour=1; start.min=0; start.sec=0;
   MqlDateTime finish; finish.year=d.year; finish.mon=10; finish.day=october_day; finish.hour=1; finish.min=0; finish.sec=0;
   return (utc>=StructToTime(start) && utc<StructToTime(finish));
  }

datetime CentralEuropeNow()
  {
   datetime utc=TimeGMT();
   return utc+(IsCentralEuropeSummerTime(utc) ? 2*3600 : 3600);
  }

double FTMODailyResetBalance=0.0;
int FTMODailyResetDateKey=0;

bool RefreshFTMODailyReset(string &reason)
  {
   reason="";
   if(AccountRiskProfile!=ACCOUNT_PROFILE_FTMO_2STEP) return true;
   MqlDateTime ce; TimeToStruct(CentralEuropeNow(),ce);
   int date_key=ce.year*10000+ce.mon*100+ce.day;
   string day_key=FTMOResetKeyPrefix()+"date";
   string balance_key=FTMOResetKeyPrefix()+"balance";
   double stored_date=0.0,stored_balance=0.0;
   bool have_date=GlobalVariableGet(day_key,stored_date);
   bool have_balance=GlobalVariableGet(balance_key,stored_balance);
   if(have_date && have_balance && (int)stored_date==date_key && stored_balance>0.0)
     { FTMODailyResetDateKey=date_key; FTMODailyResetBalance=stored_balance; return true; }
   // First timer/tick after CE(S)T midnight records the balance automatically.
   double balance=AccountInfoDouble(ACCOUNT_BALANCE);
   if(balance<=0.0 || GlobalVariableSet(balance_key,balance)==0 || GlobalVariableSet(day_key,(double)date_key)==0)
     { reason="ftmo_daily_reset_persistence_failed"; return false; }
   FTMODailyResetDateKey=date_key;
   FTMODailyResetBalance=balance;
   Print("FTMO CE(S)T daily reset recorded. date=",date_key," balance=",DoubleToString(balance,2));
   return true;
  }

bool CanOpenNewTrade(string &reason)
  {
   reason = "";
   long login = AccountInfoInteger(ACCOUNT_LOGIN);
   // Topstep execution is deliberately owned by the TopstepX API executor.
   // Never allow an MT5-attached EA to open a Topstep-profile trade.
   if(AccountRiskProfile == ACCOUNT_PROFILE_TOPSTEP)
     { reason="topstep_profile_requires_topstepx_api_guard"; return false; }
   if(AccountRiskProfile != ACCOUNT_PROFILE_FTMO_2STEP)
     { reason="account_risk_profile_must_be_ftmo_2step"; return false; }
   if(ExpectedAccountLogin <= 0 || login != ExpectedAccountLogin)
     {
      reason = StringFormat("account_lock_mismatch expected=%I64d actual=%I64d", ExpectedAccountLogin, login);
      return false;
     }
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   if(FTMOInitialBalance <= 0.0)
     { reason = "ftmo_profile_not_configured"; return false; }
   if(!RefreshFTMODailyReset(reason) || FTMODailyResetBalance<=0.0)
     return false;
   double daily_floor = FTMODailyResetBalance - FTMOInitialBalance * (FTMODailyInternalLossPercent / 100.0);
   double max_floor = FTMOInitialBalance * 0.90;
   double daily_remaining=equity-daily_floor;
   double max_remaining=equity-max_floor;
   double buffer = FTMOInitialBalance * 0.05 * MathMax(0.0, FTMOSafetyBufferPercent) / 100.0;
   if(daily_remaining<=0.0) { reason="ftmo_internal_daily_loss_4pct_reached"; return false; }
   if(max_remaining<=0.0) { reason="ftmo_maximum_loss_10pct_reached"; return false; }
   if(max_remaining<=buffer) { reason="ftmo_maximum_loss_safety_buffer_reached"; return false; }
   double next_risk=FTMORiskPercentForNextTrade();
   if(next_risk<=0.0) { reason="ftmo_risk_ladder_12_consecutive_sl_reached"; return false; }
   Print("FTMO preflight passed. reset_date=",FTMODailyResetDateKey," reset_balance=",DoubleToString(FTMODailyResetBalance,2)," daily_remaining=",DoubleToString(daily_remaining,2)," max_remaining=",DoubleToString(max_remaining,2)," next_risk_pct=",DoubleToString(next_risk,2));
   return true;
  }

double FTMORiskPercentForNextTrade()
  {
   if(AccountRiskProfile != ACCOUNT_PROFILE_FTMO_2STEP || !EnableFTMORiskLadder) return RiskPercent;
   int losses = 0;
   if(!HistorySelect(TimeCurrent() - 30 * 86400, TimeCurrent())) return FTMORiskStep1;
   for(int i = HistoryDealsTotal() - 1; i >= 0; --i)
     {
      ulong deal = HistoryDealGetTicket(i);
      if((int)HistoryDealGetInteger(deal, DEAL_MAGIC) != MagicNumber) continue;
      if(HistoryDealGetInteger(deal, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;
      long reason = HistoryDealGetInteger(deal, DEAL_REASON);
      if(reason == DEAL_REASON_TP) break;
      if(reason == DEAL_REASON_SL) { losses++; if(losses >= FTMOMaxConsecutiveSL) return 0.0; continue; }
      break;
     }
   if(losses <= 0) return FTMORiskStep1;
   if(losses == 1) return FTMORiskStep2;
   if(losses == 2) return FTMORiskStep3;
   return FTMORiskStep4;
  }

bool IsNativeUsdHighImpactNewsBlocked(string &reason)
  {
   reason = "";
   if(!UseMT5EconomicCalendar || MQLInfoInteger(MQL_TESTER)) return false;

   datetime now = TimeCurrent();
   datetime from = now - MathMax(0, MT5NewsBlockAfterMinutes) * 60;
   datetime to   = now + MathMax(0, MT5NewsBlockBeforeMinutes) * 60;
   MqlCalendarValue values[];
   int count = CalendarValueHistory(values, from, to, NULL, "USD");
   if(count < 0)
     {
      Print("MT5 economic calendar unavailable; external news gate remains active. error=", GetLastError());
      return false;
     }

   for(int i = 0; i < count; i++)
     {
      MqlCalendarEvent event;
      if(!CalendarEventById(values[i].event_id, event)) continue;
      if(event.importance != CALENDAR_IMPORTANCE_HIGH) continue;

      long minutes = (long)((values[i].time - now) / 60);
      reason = StringFormat("MT5 USD high-impact news: %s at %s (%d min)",
                            event.name, TimeToString(values[i].time, TIME_DATE|TIME_MINUTES), minutes);
      if(values[i].event_id != lastNativeNewsAlertEventId)
        {
         lastNativeNewsAlertEventId = values[i].event_id;
         Print("NEWS BLOCK: ", reason);
         if(MT5PushNewsAlert)
            SendNotification("MasterEA NEWS BLOCK " + _Symbol + ": " + event.name);
        }
      return true;
     }
   return false;
  }

string ProcessedSignalFileName()
  {
   return "MasterEA_v3_last_signal_" + (string)AccountInfoInteger(ACCOUNT_LOGIN) + "_" + _Symbol + ".txt";
  }

void LoadPersistedSignalId()
  {
   int handle = FileOpen(ProcessedSignalFileName(), FILE_READ|FILE_TXT|FILE_COMMON);
   if(handle == INVALID_HANDLE) return;
   lastSignalId = FileReadString(handle);
   FileClose(handle);
  }

void MarkSignalProcessed(string signal_id)
  {
   lastSignalId = signal_id;
   int handle = FileOpen(ProcessedSignalFileName(), FILE_WRITE|FILE_TXT|FILE_COMMON);
   if(handle == INVALID_HANDLE) { Print("WARNING: failed to persist signal_id=", signal_id); return; }
   FileWrite(handle, signal_id);
   FileClose(handle);
  }

double CapLotToApprovedSignal(string symbol, double candidate_lot, double approved_lot, string signal_id)
  {
   double step = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
   double min_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   if(approved_lot <= 0.0 || step <= 0.0 || approved_lot + 1e-8 < min_lot) { Print("Signal rejected: invalid approved lot. signal_id=", signal_id); return 0.0; }
   double capped = NormalizeDouble(MathFloor((MathMin(candidate_lot, approved_lot) + 1e-8) / step) * step, 2);
   if(capped + 1e-8 < min_lot) return 0.0;
   if(candidate_lot > approved_lot + 1e-8) Print("Lot capped to SAGE approval. signal_id=", signal_id, " calculated=", candidate_lot, " approved=", approved_lot, " used=", capped);
   return capped;
  }

// Global strategy mode updated by AI
string current_strategy_mode = "HedgeGrid";

// Circuit Breaker States
bool HaltTradingForDay = false;
double StartOfDayBalance = 0;
int CurrentDay = -1;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(MagicNumber);
   h_atr = iATR(_Symbol, UseM1ExecutionContext ? PERIOD_M1 : PERIOD_CURRENT, 14);
   LoadPersistedSignalId();
   string account_reason;
   if(!CanOpenNewTrade(account_reason))
      Print("MasterEA account guard is blocking new trades: ", account_reason);
   
   FetchDailyStrategy();
   
   EventSetTimer(1); // Poll API every second
   
   Print("MasterEA_v3 Initialized. Acting as Trade Manager for AI signals.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   IndicatorRelease(h_atr);
  }

void ManageTrades();
void ManageAutoGrid();

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Check Day Rollover
   MqlDateTime dt;
   TimeCurrent(dt);
   if (dt.day != CurrentDay) {
       CurrentDay = dt.day;
       StartOfDayBalance = AccountInfoDouble(ACCOUNT_BALANCE);
       HaltTradingForDay = false;
       Print("New Trading Day! Balance recorded: ", StartOfDayBalance);
   }

   // Master MT5 Circuit Breaker
   if (!HaltTradingForDay) {
       double current_equity = AccountInfoDouble(ACCOUNT_EQUITY);
       double daily_pnl = current_equity - StartOfDayBalance;
       
       if (MaxDailyLossDollar > 0.0 && daily_pnl <= -MaxDailyLossDollar) {
           Print("CIRCUIT BREAKER HIT (MT5): Daily Loss Limit breached (-$", MaxDailyLossDollar, ")! Closing scoped EA positions only.");
           HaltTradingForDay = true;
           CloseScopedPositions("daily_loss_circuit_breaker");
       }
       else if (MaxDailyProfitDollar > 0.0 && daily_pnl >= MaxDailyProfitDollar) {
           Print("PROFIT TARGET HIT (MT5): Daily Profit Target reached (+$", MaxDailyProfitDollar, ")! Closing scoped EA positions only.");
           HaltTradingForDay = true;
           CloseScopedPositions("daily_profit_circuit_breaker");
       }
   }

   ManageTrades();
  }

//+------------------------------------------------------------------+
//| Timer function for polling signals                               |
//+------------------------------------------------------------------+
void OnTimer()
  {
   string reset_reason;
   if(AccountRiskProfile==ACCOUNT_PROFILE_FTMO_2STEP && !RefreshFTMODailyReset(reset_reason))
      Print("FTMO fail-closed: ",reset_reason);
   // Check strategy every hour
   datetime currentTime = TimeCurrent();
   if(currentTime - lastStrategyCheckTime >= 3600)
     {
      FetchDailyStrategy();
      lastStrategyCheckTime = currentTime;
     }
     
   FetchSignal();
  }

void FetchSignal()
  {
   string cookie=NULL,headers;
   char post[],result[];
   string latestSignalURL = API_SERVER + "/api/signals/latest?symbol=" + _Symbol;
   string req_headers = "ngrok-skip-browser-warning: true\r\n";
   
   int res = WebRequest("GET", latestSignalURL, req_headers, WebRequestTimeoutMs, post, result, headers);
   if(res == 200)
     {
      string responseText = CharArrayToString(result);
      string signalId = ExtractJsonString(responseText, "signal_id");
       
      if (signalId == "")
        {
         Print("Signal rejected: no signal_id in API response. URL=", latestSignalURL);
         return;
        }
      
      if (signalId == lastSignalId)
        {
         return;
        }
      
      if (HaltTradingForDay)
        {
         Print("Signal rejected: circuit breaker active. signal_id=", signalId);
         return;
        }
      string account_reason;
      if(!CanOpenNewTrade(account_reason))
        {
         Print("Signal rejected: account risk guard. reason=", account_reason, " signal_id=", signalId);
         return;
        }
       
      MqlDateTime dt;
      TimeCurrent(dt);
      bool in_primary_window = (dt.hour >= StartTradingHour && dt.hour < EndTradingHour);
      bool in_demo_afternoon_window = (DemoAfternoonWindow && dt.hour >= 10 && dt.hour < 14);
      bool in_24h_demo_test_mode = Demo24HourTestMode;
      if (!in_24h_demo_test_mode && !UAT_AllowAllHoursForSignalTest && !in_primary_window && !in_demo_afternoon_window) {
          Print("Signal rejected: outside trading window. signal_id=", signalId, " hour=", dt.hour, " allowed=10-14 or ", StartTradingHour, "-", EndTradingHour);
          return; // Outside of trading window
      }
      if (in_24h_demo_test_mode) {
          Print("DEMO 24H TEST MODE: trading-hour gate bypassed. signal_id=", signalId, " hour=", dt.hour);
      }
      if (UAT_AllowAllHoursForSignalTest) {
          Print("UAT override active: trading window bypassed. signal_id=", signalId, " hour=", dt.hour, " production_allowed=", StartTradingHour, "-", EndTradingHour);
      }

      if (signalId != "" && signalId != lastSignalId)
        {
         string action = ExtractJsonString(responseText, "action");
         string sig_symbol = ExtractJsonString(responseText, "symbol");
         string strategy_mode = ExtractJsonString(responseText, "strategy_mode");
         string cme_data_string = ExtractJsonString(responseText, "cme_mql5_input_string");
         bool isHoldAction = (action == "HOLD" || action == "hold" || action == "WAIT" || action == "wait");
         bool supportedAction = (isHoldAction || action == "BUY" || action == "SELL" || action == "buy" || action == "sell" || action == "limit_buy" || action == "limit_sell");
         bool symbolMatches = (sig_symbol == _Symbol || sig_symbol == "");
         
         Print("Signal received from API: signal_id=", signalId, " action=", action, " signal_symbol=", sig_symbol, " chart_symbol=", _Symbol);
         
         if (!symbolMatches)
           {
            MarkSignalProcessed(signalId);
            Print("Signal rejected: Symbol mismatch. signal_id=", signalId, " signal_symbol=", sig_symbol, " chart_symbol=", _Symbol);
            return;
           }
         
         if (!supportedAction)
           {
            MarkSignalProcessed(signalId);
            Print("Signal rejected: unsupported action. signal_id=", signalId, " action=", action);
            return;
           }

         if (isHoldAction)
           {
            MarkSignalProcessed(signalId);
            Print("Signal accepted as no-trade state: signal_id=", signalId, " action=", action);
            return;
           }

         string cme_status = ExtractJsonString(responseText, "cme_freshness_status");
         string cme_source_time = ExtractJsonString(responseText, "cme_source_time");
         if (cme_status != "fresh" || cme_source_time == "")
           {
            MarkSignalProcessed(signalId);
            Print("Signal rejected: CME scheduled refresh is unavailable or retrying. signal_id=", signalId,
                  " status=", cme_status, " source_time=", cme_source_time);
            return;
           }

         string native_news_reason;
         if(IsNativeUsdHighImpactNewsBlocked(native_news_reason))
           {
            MarkSignalProcessed(signalId);
            Print("Signal rejected: ", native_news_reason, " signal_id=", signalId);
            return;
           }
         
         MarkSignalProcessed(signalId);
         if (strategy_mode != "") current_strategy_mode = strategy_mode;
         if (cme_data_string != "" && cme_data_string != latestCmeDataString)
           {
            latestCmeDataString = cme_data_string;
            Print("CME data string updated from signal payload. Length: ", StringLen(latestCmeDataString));
           }

         bool uatDryRunEffective = (UAT_DryRunNoTradeForSignalTest || UAT_AllowAllHoursForSignalTest);
         Print("Signal accepted for execution. signal_id=", signalId, " action=", action, " chart_symbol=", _Symbol);
         if (uatDryRunEffective)
           {
            Print("UAT dry run: signal accepted but trade execution skipped. signal_id=", signalId, " action=", action, " chart_symbol=", _Symbol);
            return;
          }

         if (lastTradeAttemptTime > 0 && (TimeCurrent() - lastTradeAttemptTime) < TradeCooldownSeconds)
           {
            Print("Signal deferred by trade cooldown. signal_id=", signalId,
                  " remaining_sec=", TradeCooldownSeconds - (TimeCurrent() - lastTradeAttemptTime));
            return;
           }
          
         // We support BUY, SELL, buy, sell, limit_buy, limit_sell
         if (supportedAction && symbolMatches)
           {
            double point_value = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            
            string sl_str = ExtractJsonString(responseText, "sl");
            double ai_sl = (sl_str != "") ? StringToDouble(sl_str) : 0.0;
            
            string entry_str = ExtractJsonString(responseText, "entry");
            double ai_entry = (entry_str != "") ? StringToDouble(entry_str) : 0.0;
            string approved_lot_str = ExtractJsonString(responseText, "lot");
            double approved_lot = (approved_lot_str != "") ? StringToDouble(approved_lot_str) : 0.0;
            
            // No fixed TP: the RR step-trailing manager locks profit from +3R.
            
            // 1. Count existing positions for Recovery Multiplier
            int buy_count = 0, sell_count = 0;
            double avg_buy_price = 0, avg_sell_price = 0;
            double total_buy_volume = 0, total_sell_volume = 0;
            
            for(int i=0; i<PositionsTotal(); i++) {
                ulong ticket = PositionGetTicket(i);
                if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
                    double volume = PositionGetDouble(POSITION_VOLUME);
                    double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
                    long type = PositionGetInteger(POSITION_TYPE);
                    if (type == POSITION_TYPE_BUY) {
                        buy_count++;
                        avg_buy_price += open_price * volume;
                        total_buy_volume += volume;
                    } else if (type == POSITION_TYPE_SELL) {
                        sell_count++;
                        avg_sell_price += open_price * volume;
                        total_sell_volume += volume;
                    }
                }
            }
            if (total_buy_volume > 0) avg_buy_price /= total_buy_volume;
            if (total_sell_volume > 0) avg_sell_price /= total_sell_volume;

            if(buy_count + sell_count >= MaxOpenPositionsPerSymbol) {
               Print("Signal rejected: prop forward-test position cap reached. signal_id=", signalId);
               return;
            }
            
            if(action == "BUY" || action == "buy" || action == "limit_buy")
              {
               double current_spread = (ask - bid) / point_value;
               double avg_spread = GetAverageSpread(_Symbol, 100);
               double max_allowed_spread = (avg_spread > 0) ? (avg_spread * 1.5) : MaxSpreadPoints;
               
               if (current_spread > max_allowed_spread) {
                   Print("Spread too high! Dynamic Max (1.5x Avg): ", max_allowed_spread, " Current: ", current_spread);
                   return;
               }
               
               double calc_sl = ai_sl;
               if(!ValidateStopLoss(_Symbol, true, ask, calc_sl, signalId)) return;
               double lot = CalculateLotSize(_Symbol, ask, calc_sl);
               lot = CapLotToApprovedSignal(_Symbol, lot, approved_lot, signalId);
               if(lot <= 0.0) {
                   Print("Signal rejected: lot calculation failed or would exceed risk/min-lot constraints. signal_id=", signalId, " entry=", ask, " sl=", calc_sl);
                   return;
               }
               if (AllowRecoveryScaling && buy_count > 0 && ask < avg_buy_price && RecoveryLotMultiplier > 1.0) {
                   // Tiered Recovery Logic for Breakout/HedgeGrid
                   double rec_mult = (strategy_mode == "HedgeGrid") ? 1.2 : ((buy_count < 3) ? 1.6 : 1.35);
                   lot = lot * MathPow(rec_mult, buy_count);
                   double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
                   if (lot > max_lot) lot = max_lot;
                   lot = CapLotToApprovedSignal(_Symbol, lot, approved_lot, signalId);
                   if(lot <= 0.0) return;
                   Print("AI Tiered Recovery Mode! Multiplying BUY lot to: ", lot);
               }
               if (action == "limit_buy") {
                   double target_price = (ai_entry > 0) ? ai_entry : bid - ((bid - calc_sl) * 0.5); // Use API entry or Estimate 50% pullback
                   if(!ValidateStopLoss(_Symbol, true, target_price, calc_sl, signalId)) return;
                   lastTradeAttemptTime = TimeCurrent();
                   bool order_ok = trade.BuyLimit(lot, target_price, _Symbol, calc_sl, 0.0, 0, 0, StringSubstr("AI:" + signalId, 0, 31));
                   LogTradeResult(order_ok, "BUY_LIMIT", signalId, lot, target_price, calc_sl, 0.0);
               } else {
                   lastTradeAttemptTime = TimeCurrent();
                   bool order_ok = trade.Buy(lot, _Symbol, ask, calc_sl, 0.0, StringSubstr("AI:" + signalId, 0, 31));
                   LogTradeResult(order_ok, "BUY", signalId, lot, ask, calc_sl, 0.0);
               }
              }
            else if(action == "SELL" || action == "sell" || action == "limit_sell")
              {
               double current_spread = (ask - bid) / point_value;
               double avg_spread = GetAverageSpread(_Symbol, 100);
               double max_allowed_spread = (avg_spread > 0) ? (avg_spread * 1.5) : MaxSpreadPoints;
               
               if (current_spread > max_allowed_spread) {
                   Print("Spread too high! Dynamic Max (1.5x Avg): ", max_allowed_spread, " Current: ", current_spread);
                   return;
               }

               double calc_sl = ai_sl;
               if(!ValidateStopLoss(_Symbol, false, bid, calc_sl, signalId)) return;
               double lot = CalculateLotSize(_Symbol, bid, calc_sl);
               lot = CapLotToApprovedSignal(_Symbol, lot, approved_lot, signalId);
               if(lot <= 0.0) {
                   Print("Signal rejected: lot calculation failed or would exceed risk/min-lot constraints. signal_id=", signalId, " entry=", bid, " sl=", calc_sl);
                   return;
               }
               if (AllowRecoveryScaling && sell_count > 0 && bid > avg_sell_price && RecoveryLotMultiplier > 1.0) {
                   // Tiered Recovery Logic for Breakout/HedgeGrid
                   double rec_mult = (strategy_mode == "HedgeGrid") ? 1.2 : ((sell_count < 3) ? 1.6 : 1.35);
                   lot = lot * MathPow(rec_mult, sell_count);
                   double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
                   if (lot > max_lot) lot = max_lot;
                   lot = CapLotToApprovedSignal(_Symbol, lot, approved_lot, signalId);
                   if(lot <= 0.0) return;
                   Print("AI Tiered Recovery Mode! Multiplying SELL lot to: ", lot);
               }
               if (action == "limit_sell") {
                   double target_price = (ai_entry > 0) ? ai_entry : ask + ((calc_sl - ask) * 0.5); // Use API entry or Estimate 50% pullback
                   if(!ValidateStopLoss(_Symbol, false, target_price, calc_sl, signalId)) return;
                   lastTradeAttemptTime = TimeCurrent();
                   bool order_ok = trade.SellLimit(lot, target_price, _Symbol, calc_sl, 0.0, 0, 0, StringSubstr("AI:" + signalId, 0, 31));
                   LogTradeResult(order_ok, "SELL_LIMIT", signalId, lot, target_price, calc_sl, 0.0);
               } else {
                   lastTradeAttemptTime = TimeCurrent();
                   bool order_ok = trade.Sell(lot, _Symbol, bid, calc_sl, 0.0, StringSubstr("AI:" + signalId, 0, 31));
                   LogTradeResult(order_ok, "SELL", signalId, lot, bid, calc_sl, 0.0);
               }
              }
           }
         }
      }
   else
     {
      Print("WebRequest error: latest signal API request failed. status=", res, " last_error=", GetLastError(), " url=", latestSignalURL);
     }
   }

void FetchDailyStrategy()
  {
   string cookie=NULL,headers;
   char post[],result[];
   string strategyURL = API_SERVER + "/api/strategy/daily";
   string req_headers = "ngrok-skip-browser-warning: true\r\n";
   
   int res = WebRequest("GET", strategyURL, req_headers, WebRequestTimeoutMs, post, result, headers);
   if(res == 200)
     {
      string responseText = CharArrayToString(result);
      
      string vtp_str = ExtractJsonString(responseText, "VirtualTP_ATR_Multiplier");
      string vsl_str = ExtractJsonString(responseText, "VirtualSL_ATR_Multiplier");
      string be_str = ExtractJsonString(responseText, "BreakEven_ATR_Multiplier");
      string rec_str = ExtractJsonString(responseText, "RecoveryLotMultiplier");
      
      if(vtp_str != "") VirtualTP_ATR_Multiplier = StringToDouble(vtp_str);
      if(vsl_str != "") VirtualSL_ATR_Multiplier = StringToDouble(vsl_str);
      if(be_str != "") BreakEven_ATR_Multiplier = StringToDouble(be_str);
      if(rec_str != "") RecoveryLotMultiplier = StringToDouble(rec_str);
      
      Print("Loaded AI Strategy: V_TP=", VirtualTP_ATR_Multiplier, " V_SL=", VirtualSL_ATR_Multiplier, " BE=", BreakEven_ATR_Multiplier);
     }
  }

string ExtractJsonString(string json, string key)
  {
   string searchKey = "\"" + key + "\":";
   int pos = StringFind(json, searchKey);
   if(pos < 0) return "";
   
   int valStart = pos + StringLen(searchKey);
   while(valStart < StringLen(json) && (StringSubstr(json, valStart, 1) == " " || StringSubstr(json, valStart, 1) == "\n" || StringSubstr(json, valStart, 1) == "\r")) valStart++;
   
   if(StringSubstr(json, valStart, 1) == "\"")
     {
      int endQuote = StringFind(json, "\"", valStart + 1);
      if(endQuote > 0) return StringSubstr(json, valStart + 1, endQuote - valStart - 1);
     }
   else
     {
      int endComma = StringFind(json, ",", valStart);
      int endBrace = StringFind(json, "}", valStart);
      int endPos = endComma;
      if(endPos < 0 || (endBrace > 0 && endBrace < endComma)) endPos = endBrace;
      if(endPos > 0)
        {
         string val = StringSubstr(json, valStart, endPos - valStart);
         StringReplace(val, " ", "");
         StringReplace(val, "\r", "");
         StringReplace(val, "\n", "");
         return val;
        }
     }
   return "";
  }

int CloseScopedPositions(string reason)
  {
   int closed_count = 0;
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if(trade.PositionClose(ticket))
        {
         closed_count++;
         Print("Scoped close succeeded. reason=", reason, " ticket=", ticket);
        }
      else
        {
         Print("Scoped close failed. reason=", reason, " ticket=", ticket, " retcode=", trade.ResultRetcode(), " desc=", trade.ResultRetcodeDescription());
        }
     }
   Print("Scoped close completed. reason=", reason, " closed_count=", closed_count);
   return closed_count;
  }

bool ValidateStopLoss(string sym, bool is_buy, double entry_price, double sl_price, string signal_id)
  {
   if(sl_price <= 0.0)
     {
      Print("Signal rejected: missing or invalid broker-side SL. signal_id=", signal_id, " entry=", entry_price, " sl=", sl_price);
      return false;
     }
   double point = SymbolInfoDouble(sym, SYMBOL_POINT);
   double tick_size = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   long stops_level = SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
   double min_distance = MathMax(tick_size, stops_level * point);
   double distance = MathAbs(entry_price - sl_price);
   if(is_buy && sl_price >= entry_price)
     {
      Print("Signal rejected: BUY SL must be below entry. signal_id=", signal_id, " entry=", entry_price, " sl=", sl_price);
      return false;
     }
   if(!is_buy && sl_price <= entry_price)
     {
      Print("Signal rejected: SELL SL must be above entry. signal_id=", signal_id, " entry=", entry_price, " sl=", sl_price);
      return false;
     }
   if(distance < min_distance)
     {
      Print("Signal rejected: SL distance below broker minimum. signal_id=", signal_id, " distance=", distance, " minimum=", min_distance);
      return false;
     }
   return true;
  }

bool ValidateTakeProfit(string sym, bool is_buy, double entry_price, double tp_price, string signal_id)
  {
   if(tp_price <= 0.0)
     {
      Print("Signal rejected: missing or invalid CME broker-side TP. signal_id=", signal_id, " entry=", entry_price, " tp=", tp_price);
      return false;
     }
   double point = SymbolInfoDouble(sym, SYMBOL_POINT);
   double tick_size = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   long stops_level = SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
   double min_distance = MathMax(tick_size, stops_level * point);
   double distance = MathAbs(entry_price - tp_price);
   if(is_buy && tp_price <= entry_price)
     {
      Print("Signal rejected: BUY TP must be above entry. signal_id=", signal_id, " entry=", entry_price, " tp=", tp_price);
      return false;
     }
   if(!is_buy && tp_price >= entry_price)
     {
      Print("Signal rejected: SELL TP must be below entry. signal_id=", signal_id, " entry=", entry_price, " tp=", tp_price);
      return false;
     }
   if(distance < min_distance)
     {
      Print("Signal rejected: TP distance below broker minimum. signal_id=", signal_id, " distance=", distance, " minimum=", min_distance);
      return false;
     }
   return true;
  }

void LogTradeResult(bool ok, string action, string signal_id, double lot, double price, double sl, double tp)
  {
   if(ok)
     {
      Print("Trade order accepted by broker. action=", action, " signal_id=", signal_id, " lot=", lot, " price=", price, " sl=", sl, " tp=", tp, " retcode=", trade.ResultRetcode(), " desc=", trade.ResultRetcodeDescription());
     }
   else
     {
      Print("Trade order failed. action=", action, " signal_id=", signal_id, " lot=", lot, " price=", price, " sl=", sl, " tp=", tp, " retcode=", trade.ResultRetcode(), " desc=", trade.ResultRetcodeDescription(), " last_error=", GetLastError());
     }
  }

double CalculateLotSize(string sym, double entry_price, double sl_price)
  {
   double effective_risk_percent = FTMORiskPercentForNextTrade();
   if(effective_risk_percent <= 0)
     { Print("FTMO risk decision: BLOCK next_risk_pct=0 reason=consecutive_sl_limit"); return 0.0; }
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double risk_amount = balance * (effective_risk_percent / 100.0);
   if(MaxRiskPerTradeDollar > 0.0) risk_amount = MathMin(risk_amount, MaxRiskPerTradeDollar);
   Print("FTMO risk decision: next_risk_pct=",DoubleToString(effective_risk_percent,2)," risk_amount=",DoubleToString(risk_amount,2));
   double tick_value = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double tick_size = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   if(tick_size == 0 || tick_value == 0 || sl_price == 0 || MathAbs(entry_price - sl_price) < tick_size) 
      return 0.0;
      
   double sl_points = MathAbs(entry_price - sl_price) / tick_size;
   
   // --- ATR Dynamic Volatility Adjustment (HedgeGrid Synergy) ---
   double atr_val[];
   CopyBuffer(h_atr, 0, 0, 1, atr_val);
   if (atr_val[0] > 0) {
       double atr_points = atr_val[0] / tick_size;
       // Pad the SL distance artificially if volatility is extremely high
       if (sl_points < atr_points * 0.5) {
           sl_points = atr_points * 0.5;
       }
   }
   
   double lot_size = risk_amount / (sl_points * tick_value);
   double min_lot = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double max_lot = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   double step_lot = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   lot_size = MathRound(lot_size / step_lot) * step_lot;
   if(lot_size < min_lot) return 0.0;
   if(lot_size > max_lot) lot_size = max_lot;
   return lot_size;
  }

void BroadcastSignal(string type, double sl, double tp) {
    string msg = "{\"action\": \"publish\", \"symbol\": \"" + _Symbol + "\", \"type\": \"" + type + "\", \"price\": " + DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits) + ", \"sl\": " + DoubleToString(sl, _Digits) + ", \"tp\": " + DoubleToString(tp, _Digits) + "}\n";
    uchar data[];
    StringToCharArray(msg, data);

    for(int attempt = 1; attempt <= 3; attempt++) {
        int socket = SocketCreate();
        if(socket != INVALID_HANDLE) {
            if(SocketConnect(socket, "127.0.0.1", 5555, 1500)) {
                int sent = SocketSend(socket, data, ArraySize(data)-1);
                SocketClose(socket);
                if(sent == ArraySize(data)-1) {
                    Print("Broadcasted " + type + " signal via Socket (attempt " + IntegerToString(attempt) + ")");
                    return;
                }
            } else {
                SocketClose(socket);
            }
        }
        if(attempt < 3) Sleep(150);
    }
    Print("Failed to connect/send to Signal Distributor after 3 attempts. error=" + IntegerToString(GetLastError()));
}

string RRInitialSLKey(ulong ticket)
  {
   return "MasterEA_RRInitialSL_" + IntegerToString((long)ticket);
  }

bool RRStopMeetsBrokerDistance(long position_type, double stop_price)
  {
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   long stops_level = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double minimum = MathMax(tick_size, stops_level * point);
   double market_price = (position_type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   return (position_type == POSITION_TYPE_BUY) ? (stop_price <= market_price - minimum) : (stop_price >= market_price + minimum);
  }

void ManageTrades()
  {
   // Each ticket retains its original broker-side SL in a terminal global
   // variable. That makes R stable after the stop has already been moved.
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      long position_type = PositionGetInteger(POSITION_TYPE);
      double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
      double current_sl = PositionGetDouble(POSITION_SL);
      double current_tp = PositionGetDouble(POSITION_TP);
      string initial_key = RRInitialSLKey(ticket);
      if(!GlobalVariableCheck(initial_key) && current_sl > 0.0)
         GlobalVariableSet(initial_key, current_sl);
      if(!GlobalVariableCheck(initial_key))
        {
         Print("RR trail waiting for broker-side initial SL. ticket=", ticket);
         continue;
        }
      double initial_sl = GlobalVariableGet(initial_key);
      double initial_risk = MathAbs(open_price - initial_sl);
      if(initial_risk <= 0.0) continue;

      // Remove a legacy/fixed TP once, so an old target cannot close a runner.
      if(current_tp > 0.0)
        {
         if(!trade.PositionModify(ticket, current_sl, 0.0))
            Print("RR trail failed to clear legacy TP. ticket=", ticket, " retcode=", trade.ResultRetcode(), " desc=", trade.ResultRetcodeDescription());
        }

      double market_price = (position_type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double current_r = (position_type == POSITION_TYPE_BUY) ? (market_price - open_price) / initial_risk : (open_price - market_price) / initial_risk;
      int achieved_r = (int)MathFloor(current_r + 0.000001);
      if(achieved_r < RRStepTrailStart) continue;
      int locked_r = achieved_r - RRStepTrailOffset;
      if(locked_r < 1) locked_r = 1;
      double desired_sl = (position_type == POSITION_TYPE_BUY) ? open_price + locked_r * initial_risk : open_price - locked_r * initial_risk;
      desired_sl = NormalizeDouble(desired_sl, _Digits);
      bool improves_stop = (position_type == POSITION_TYPE_BUY) ? (current_sl == 0.0 || desired_sl > current_sl) : (current_sl == 0.0 || desired_sl < current_sl);
      if(!improves_stop || !RRStopMeetsBrokerDistance(position_type, desired_sl)) continue;
      if(trade.PositionModify(ticket, desired_sl, 0.0))
        {
         Print("RR step trail moved SL. ticket=", ticket, " achieved_r=", achieved_r, " locked_r=", locked_r, " new_sl=", desired_sl);
         BroadcastSignal("MODIFY", desired_sl, 0);
        }
      else
         Print("RR step trail failed. ticket=", ticket, " retcode=", trade.ResultRetcode(), " desc=", trade.ResultRetcodeDescription());
     }
  }

void ManageLegacyTrades_Disabled() {
    double point_value = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double total_profit = 0;
    int buy_count = 0, sell_count = 0;
    double avg_buy_price = 0, avg_sell_price = 0;
    double total_buy_volume = 0, total_sell_volume = 0;
    
    for(int i=0; i<PositionsTotal(); i++) {
        ulong ticket = PositionGetTicket(i);
        if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            double profit = PositionGetDouble(POSITION_PROFIT);
            total_profit += profit;
            
            double volume = PositionGetDouble(POSITION_VOLUME);
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            long type = PositionGetInteger(POSITION_TYPE);
            
            if (type == POSITION_TYPE_BUY) {
                buy_count++;
                avg_buy_price += open_price * volume;
                total_buy_volume += volume;
            } else if (type == POSITION_TYPE_SELL) {
                sell_count++;
                avg_sell_price += open_price * volume;
                total_sell_volume += volume;
            }
        }
    }
    
    if (total_buy_volume > 0) avg_buy_price /= total_buy_volume;
    if (total_sell_volume > 0) avg_sell_price /= total_sell_volume;
      
      // --- Smart % Trailing (Never close negative logic) ---
      double total_volume = total_buy_volume + total_sell_volume;
      if (total_volume > 0) {
          double balance = AccountInfoDouble(ACCOUNT_BALANCE);
          double dyn_target = balance * (legacy_target_profit_percent / 100.0);
          double dyn_trail = balance * (legacy_trail_profit_percent / 100.0);
          
          if (total_profit >= dyn_target) {
              if (total_profit > legacy_highest_usd_profit) legacy_highest_usd_profit = total_profit;
              
              if (total_profit < legacy_highest_usd_profit - dyn_trail && total_profit > 0) { // Enforce STRICT positive close
                  Print("Smart Profit Trailing Triggered! Securing: $", total_profit);
                  // Close all positions
                  for(int i=PositionsTotal()-1; i>=0; i--) {
                      ulong ticket = PositionGetTicket(i);
                      if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
                          trade.PositionClose(ticket);
                      }
                  }
                  legacy_highest_usd_profit = 0;
                  return; // Exit ManageTrades since all are closed
              }
          } else {
              legacy_highest_usd_profit = 0; // Reset if below target
          }
      }
      // -------------------------------------------------------------
    
    double atr_array[];
    CopyBuffer(h_atr, 0, 1, 1, atr_array);
    double current_atr = atr_array[0];
    if (current_atr <= 0) return;
    
    double virtual_tp_distance = current_atr * VirtualTP_ATR_Multiplier;
    double virtual_sl_distance = current_atr * VirtualSL_ATR_Multiplier;
    
    // Check Buy Basket
    if (buy_count > 0) {
        double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        if (current_price <= avg_buy_price - virtual_sl_distance) {
            for(int i=PositionsTotal()-1; i>=0; i--) {
                ulong ticket = PositionGetTicket(i);
                if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                    trade.PositionClose(ticket);
                }
            }
            Print("Virtual SL Hit! Closed all Buy positions.");
            BroadcastSignal("CLOSE_ALL", 0, 0);
        }
        else if (current_price >= avg_buy_price + virtual_tp_distance) {
            for(int i=PositionsTotal()-1; i>=0; i--) {
                ulong ticket = PositionGetTicket(i);
                if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                    double volume = PositionGetDouble(POSITION_VOLUME);
                    double close_vol = MathRound((volume * 0.70) / SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP)) * SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
                    trade.SetExpertMagicNumber(MagicNumber);
                    if (close_vol >= SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN)) {
                        trade.PositionClosePartial(ticket, close_vol);
                        Print("Virtual TP Hit (1:4)! Partial Closed Buy ticket: ", ticket);
                        BroadcastSignal("CLOSE_ALL_EXCEPT_BEST", 0, 0);
                    }
                    double be_sl = NormalizeDouble(avg_buy_price + (10 * point_value), _Digits);
                    if(trade.PositionModify(ticket, be_sl, 0)) BroadcastSignal("MODIFY", be_sl, 0);
                }
            }
        }
    }
    
    // Check Sell Basket
    if (sell_count > 0) {
        double current_price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        if (current_price >= avg_sell_price + virtual_sl_distance) {
            for(int i=PositionsTotal()-1; i>=0; i--) {
                ulong ticket = PositionGetTicket(i);
                if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                    trade.PositionClose(ticket);
                }
            }
            Print("Virtual SL Hit! Closed all Sell positions.");
            BroadcastSignal("CLOSE_ALL", 0, 0);
        }
        else if (current_price <= avg_sell_price - virtual_tp_distance) {
            for(int i=PositionsTotal()-1; i>=0; i--) {
                ulong ticket = PositionGetTicket(i);
                if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                    double volume = PositionGetDouble(POSITION_VOLUME);
                    double close_vol = MathRound((volume * 0.70) / SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP)) * SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
                    trade.SetExpertMagicNumber(MagicNumber);
                    if (close_vol >= SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN)) {
                        trade.PositionClosePartial(ticket, close_vol);
                        Print("Virtual TP Hit (1:4)! Partial Closed Sell ticket: ", ticket);
                        BroadcastSignal("CLOSE_ALL_EXCEPT_BEST", 0, 0);
                    }
                    double be_sl = NormalizeDouble(avg_sell_price - (10 * point_value), _Digits);
                    if(trade.PositionModify(ticket, be_sl, 0)) BroadcastSignal("MODIFY", be_sl, 0);
                }
            }
        }
    }
    
    // Auto Break-Even
    double be_distance = current_atr * BreakEven_ATR_Multiplier;
    for(int i=PositionsTotal()-1; i>=0; i--) {
        ulong ticket = PositionGetTicket(i);
        if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            long type = PositionGetInteger(POSITION_TYPE);
            double current_sl = PositionGetDouble(POSITION_SL);
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            trade.SetExpertMagicNumber(MagicNumber);
            
            if (type == POSITION_TYPE_BUY && current_sl == 0) {
                double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
                if (current_price >= open_price + be_distance) {
                    double be_sl = NormalizeDouble(open_price + (10 * point_value), _Digits);
                    if(trade.PositionModify(ticket, be_sl, 0)) {
                        Print("Auto Break-Even Triggered for Buy ticket: ", ticket);
                        BroadcastSignal("MODIFY", be_sl, 0);
                    }
                }
            } else if (type == POSITION_TYPE_SELL && current_sl == 0) {
                double current_price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
                if (current_price <= open_price - be_distance) {
                    double be_sl = NormalizeDouble(open_price - (10 * point_value), _Digits);
                    if(trade.PositionModify(ticket, be_sl, 0)) {
                        Print("Auto Break-Even Triggered for Sell ticket: ", ticket);
                        BroadcastSignal("MODIFY", be_sl, 0);
                    }
                }
            }
        }
    }
    
    // ATR Trailing Stop for Runners
    for(int i=PositionsTotal()-1; i>=0; i--) {
        ulong ticket = PositionGetTicket(i);
        if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            long type = PositionGetInteger(POSITION_TYPE);
            double current_sl = PositionGetDouble(POSITION_SL);
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            
            bool is_runner = false;
            if (type == POSITION_TYPE_BUY && current_sl >= open_price) is_runner = true;
            if (type == POSITION_TYPE_SELL && current_sl > 0 && current_sl <= open_price) is_runner = true;
            
            if (is_runner && EnableRunner) {
                double trail_dist = current_atr * 2.0; // Fixed trailing distance for runners
                double new_sl = 0;
                trade.SetExpertMagicNumber(MagicNumber);
                
                if (type == POSITION_TYPE_BUY) {
                    double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
                    new_sl = NormalizeDouble(current_price - trail_dist, _Digits);
                    if (new_sl > current_sl + (10 * point_value)) {
                        if(trade.PositionModify(ticket, new_sl, 0)) BroadcastSignal("MODIFY", new_sl, 0);
                    }
                } else {
                    double current_price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
                    new_sl = NormalizeDouble(current_price + trail_dist, _Digits);
                    if (new_sl < current_sl - (10 * point_value) || current_sl == 0) {
                        if(trade.PositionModify(ticket, new_sl, 0)) BroadcastSignal("MODIFY", new_sl, 0);
                    }
                }
            }
        }
    }
}

void ManageAutoGrid() {
    double point_value = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    double current_atr = 0.0;
    double atr_arr[];
    ArraySetAsSeries(atr_arr, true);
    if(CopyBuffer(h_atr, 0, 0, 1, atr_arr) > 0) {
        current_atr = atr_arr[0];
    }
    
    // Dynamic Step: Use ATR x1.5 if it's larger than the static AutoGridStepPoints
    double dyn_step = AutoGridStepPoints * point_value;
    if (current_atr > 0 && (current_atr * 1.5) > dyn_step) {
        dyn_step = current_atr * 1.5;
    }
    
    int buy_count = 0, sell_count = 0;
    double lowest_buy = 9999999, highest_sell = 0;
    double last_buy_lot = 0, last_sell_lot = 0;
    
    for(int i=0; i<PositionsTotal(); i++) {
        ulong ticket = PositionGetTicket(i);
        if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            double volume = PositionGetDouble(POSITION_VOLUME);
            long type = PositionGetInteger(POSITION_TYPE);
            
            if (type == POSITION_TYPE_BUY) {
                buy_count++;
                if (open_price < lowest_buy) { lowest_buy = open_price; last_buy_lot = volume; }
            } else if (type == POSITION_TYPE_SELL) {
                sell_count++;
                if (open_price > highest_sell) { highest_sell = open_price; last_sell_lot = volume; }
            }
        }
    }
    
    // Auto Grid for BUY
    if (buy_count > 0 && buy_count < MaxGridSteps) {
        if (ask <= lowest_buy - dyn_step) {
            double rec_mult = (current_strategy_mode == "HedgeGrid") ? 1.2 : ((buy_count < 3) ? 1.6 : 1.35);
            double lot = NormalizeDouble(last_buy_lot * rec_mult, 2);
            double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
            double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
            if (lot < min_lot) lot = min_lot;
            if (lot > max_lot) lot = max_lot;
            
            double grid_sl = NormalizeDouble(ask - MathMax(current_atr * VirtualSL_ATR_Multiplier, dyn_step), _Digits);
            if(!ValidateStopLoss(_Symbol, true, ask, grid_sl, "AUTO_GRID_BUY")) return;
            bool order_ok = trade.Buy(lot, _Symbol, ask, grid_sl, 0.0, "Auto-Grid Recovery BUY");
            LogTradeResult(order_ok, "AUTO_GRID_BUY", "AUTO_GRID_BUY", lot, ask, grid_sl, 0.0);
            Print("Auto-Grid Executed BUY! Step distance reached. Lot: ", lot, " Dist: ", dyn_step);
        }
    }
    
    // Auto Grid for SELL
    if (sell_count > 0 && sell_count < MaxGridSteps) {
        if (bid >= highest_sell + dyn_step) {
            double rec_mult = (current_strategy_mode == "HedgeGrid") ? 1.2 : ((sell_count < 3) ? 1.6 : 1.35);
            double lot = NormalizeDouble(last_sell_lot * rec_mult, 2);
            double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
            double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
            if (lot < min_lot) lot = min_lot;
            if (lot > max_lot) lot = max_lot;
            
            double grid_sl = NormalizeDouble(bid + MathMax(current_atr * VirtualSL_ATR_Multiplier, dyn_step), _Digits);
            if(!ValidateStopLoss(_Symbol, false, bid, grid_sl, "AUTO_GRID_SELL")) return;
            bool order_ok = trade.Sell(lot, _Symbol, bid, grid_sl, 0.0, "Auto-Grid Recovery SELL");
            LogTradeResult(order_ok, "AUTO_GRID_SELL", "AUTO_GRID_SELL", lot, bid, grid_sl, 0.0);
            Print("Auto-Grid Executed SELL! Step distance reached. Lot: ", lot, " Dist: ", dyn_step);
        }
    }
}

double GetAverageSpread(string symbol, int periods) {
    double avg_spread = 0;
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    if(CopyRates(symbol, PERIOD_CURRENT, 0, periods, rates) == periods) {
        for(int i=0; i<periods; i++) {
            avg_spread += rates[i].spread;
        }
        avg_spread /= periods;
    }
    return avg_spread;
}
