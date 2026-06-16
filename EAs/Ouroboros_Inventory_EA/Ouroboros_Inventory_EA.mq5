//+------------------------------------------------------------------+
//| Ouroboros Inventory EA v1                                       |
//| Fixed-lot inventory harvesting with explicit portfolio guards.  |
//+------------------------------------------------------------------+
#property strict
#property version   "1.00"
#property description "Inventory harvesting research EA. AUTO mode trades only in tester and monitors on charts."

#include <Trade\Trade.mqh>

enum ENUM_OUROBOROS_MODE
{
   MODE_AUTO = 0,
   MODE_TESTER = 1,
   MODE_MONITOR = 2,
   MODE_TRADE = 3
};

enum ENUM_INVENTORY_CLASS
{
   CLASS_NEUTRAL = 0,
   CLASS_CORE_ASSET = 1,
   CLASS_HARVESTABLE = 2,
   CLASS_DEBT = 3
};

enum ENUM_SAFETY_STATE
{
   SAFETY_NORMAL = 0,
   SAFETY_PAUSED = 1,
   SAFETY_EMERGENCY = 2
};

enum ENUM_PENDING_ACTION
{
   ACTION_NONE = 0,
   ACTION_HARVEST = 1,
   ACTION_DEBT_CLOSE = 2,
   ACTION_EMERGENCY_CLOSE = 3
};

input group "=== Operating Mode ==="
input ENUM_OUROBOROS_MODE InpMode = MODE_AUTO;
input bool   InpEnableTrading = false;
input long   InpMagic = 6132026;

input group "=== Inventory ==="
input double InpFixedLot = 0.01;
input int    InpMaxPositionsPerSide = 10;
input double InpMaxTotalLots = 0.20;
input int    InpAtrPeriod = 14;
input double InpAtrGridMultiplier = 1.00;
input int    InpMinGridPoints = 500;

input group "=== Harvest And Debt ==="
input double InpCoreProfitMoney = 2.00;
input double InpHarvestTriggerMoney = 5.00;
input double InpHarvestFraction = 0.50;
input double InpCoreMinVolume = 0.01;
input double InpDebtMinLossMoney = 1.00;
input double InpPairingReserveMoney = 0.50;
input double InpMinPairNetMoney = 0.10;
input double InpEstimatedExitCommissionPerLot = 0.00;
input double InpEstimatedRebatePerLot = 0.00;

input group "=== Portfolio Protection ==="
input double InpPauseDrawdownPct = 8.00;
input double InpEmergencyDrawdownPct = 12.00;
input double InpMinMarginLevelPct = 300.00;
input double InpEmergencyMarginLevelPct = 150.00;
input int    InpMaxSpreadPoints = 100;
input bool   InpAutoResumeAfterEmergency = false;

input group "=== Display And Audit ==="
input bool   InpShowDashboard = true;
input bool   InpWriteAuditLog = true;

struct PositionSnapshot
{
   ulong ticket;
   ENUM_POSITION_TYPE side;
   double volume;
   double open_price;
   double net_profit;
   datetime open_time;
   ENUM_INVENTORY_CLASS inventory_class;
};

CTrade g_trade;
PositionSnapshot g_positions[];
int g_atrHandle = INVALID_HANDLE;
datetime g_lastBarTime = 0;
double g_peakEquity = 0.0;
double g_harvestCredit = 0.0;
double g_totalHarvested = 0.0;
double g_totalDebtRetired = 0.0;
bool g_emergencyLatched = false;
bool g_mutationInFlight = false;
ENUM_PENDING_ACTION g_pendingAction = ACTION_NONE;
ulong g_pendingTicket = 0;

ENUM_OUROBOROS_MODE ActiveMode()
{
   if(InpMode == MODE_AUTO)
      return MQLInfoInteger(MQL_TESTER) ? MODE_TESTER : MODE_MONITOR;
   return InpMode;
}

string ModeName()
{
   ENUM_OUROBOROS_MODE mode = ActiveMode();
   if(mode == MODE_TESTER) return "TESTER";
   if(mode == MODE_TRADE) return "TRADE";
   return "MONITOR";
}

string SafetyName(const ENUM_SAFETY_STATE state)
{
   if(state == SAFETY_EMERGENCY) return "EMERGENCY";
   if(state == SAFETY_PAUSED) return "PAUSED";
   return "NORMAL";
}

bool ValidateInputs()
{
   if(InpMagic <= 0 || InpFixedLot <= 0.0 || InpMaxPositionsPerSide < 1)
      return false;
   if(InpMaxTotalLots < InpFixedLot || InpAtrPeriod < 2 || InpMinGridPoints < 1)
      return false;
   if(InpHarvestFraction <= 0.0 || InpHarvestFraction >= 1.0)
      return false;
   if(InpCoreMinVolume <= 0.0 || InpHarvestTriggerMoney < InpCoreProfitMoney)
      return false;
   if(InpPauseDrawdownPct <= 0.0 || InpEmergencyDrawdownPct <= InpPauseDrawdownPct)
      return false;
   if(InpEmergencyMarginLevelPct <= 0.0 || InpMinMarginLevelPct <= InpEmergencyMarginLevelPct)
      return false;
   if(InpMaxSpreadPoints < 1)
      return false;
   return true;
}

bool CanMutateTrades()
{
   ENUM_OUROBOROS_MODE mode = ActiveMode();
   if(g_emergencyLatched && !InpAutoResumeAfterEmergency)
      return false;
   if(ActiveMode() == MODE_MONITOR)
      return false;
   if(mode == MODE_TESTER)
      return (bool)MQLInfoInteger(MQL_TESTER);
   if(mode == MODE_TRADE)
      return InpEnableTrading
         && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)
         && (bool)MQLInfoInteger(MQL_TRADE_ALLOWED);
   return false;
}

bool CanExecuteEmergency()
{
   ENUM_OUROBOROS_MODE mode = ActiveMode();
   if(mode == MODE_MONITOR)
      return false;
   if(mode == MODE_TESTER)
      return (bool)MQLInfoInteger(MQL_TESTER);
   if(mode == MODE_TRADE)
      return InpEnableTrading
         && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)
         && (bool)MQLInfoInteger(MQL_TRADE_ALLOWED);
   return false;
}

double NormalizeVolume(const double requested)
{
   double minimum = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maximum = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(step <= 0.0) step = minimum;
   if(step <= 0.0) return 0.0;
   if(requested < minimum) return 0.0;

   double bounded = MathMax(minimum, MathMin(maximum, requested));
   double normalized = MathFloor((bounded + 1e-12) / step) * step;
   int digits = 0;
   double probe = step;
   while(digits < 8 && MathAbs(probe - MathRound(probe)) > 1e-9)
   {
      probe *= 10.0;
      digits++;
   }
   return NormalizeDouble(normalized, digits);
}

double EstimatedExitCost(const double volume)
{
   return MathMax(0.0, InpEstimatedExitCommissionPerLot) * volume;
}

ENUM_INVENTORY_CLASS ClassifyPosition(const double net_profit,
                                       const double volume)
{
   double after_cost = net_profit - EstimatedExitCost(volume);
   double minimum = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double close_volume = NormalizeVolume(volume * InpHarvestFraction);
   double retained = NormalizeVolume(volume - close_volume);

   if(after_cost >= InpHarvestTriggerMoney
      && close_volume >= minimum
      && retained >= MathMax(minimum, InpCoreMinVolume))
      return CLASS_HARVESTABLE;
   if(after_cost >= InpCoreProfitMoney)
      return CLASS_CORE_ASSET;
   if(after_cost <= -InpDebtMinLossMoney)
      return CLASS_DEBT;
   return CLASS_NEUTRAL;
}

void RefreshPositions()
{
   ArrayResize(g_positions, 0);
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;

      int size = ArraySize(g_positions);
      ArrayResize(g_positions, size + 1);
      g_positions[size].ticket = ticket;
      g_positions[size].side = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      g_positions[size].volume = PositionGetDouble(POSITION_VOLUME);
      g_positions[size].open_price = PositionGetDouble(POSITION_PRICE_OPEN);
      g_positions[size].net_profit = PositionGetDouble(POSITION_PROFIT)
                                    + PositionGetDouble(POSITION_SWAP);
      g_positions[size].open_time = (datetime)PositionGetInteger(POSITION_TIME);
      g_positions[size].inventory_class = ClassifyPosition(
         g_positions[size].net_profit,
         g_positions[size].volume
      );
   }
}

double CurrentDrawdownPct()
{
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   if(equity > g_peakEquity) g_peakEquity = equity;
   if(g_peakEquity <= 0.0) return 0.0;
   return MathMax(0.0, (g_peakEquity - equity) / g_peakEquity * 100.0);
}

double CurrentMarginLevelPct()
{
   double margin = AccountInfoDouble(ACCOUNT_MARGIN);
   if(margin <= 0.0) return 999999.0;
   return AccountInfoDouble(ACCOUNT_EQUITY) / margin * 100.0;
}

int CurrentSpreadPoints()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(_Point <= 0.0) return 0;
   return (int)MathRound((ask - bid) / _Point);
}

double TotalManagedLots()
{
   double total = 0.0;
   for(int i = 0; i < ArraySize(g_positions); i++)
      total += g_positions[i].volume;
   return total;
}

ENUM_SAFETY_STATE EvaluateSafetyState(const double drawdown,
                                       const double margin_level,
                                       const int spread,
                                       const double total_lots)
{
   if(drawdown >= InpEmergencyDrawdownPct
      || margin_level <= InpEmergencyMarginLevelPct)
      return SAFETY_EMERGENCY;
   if(g_emergencyLatched
      || drawdown >= InpPauseDrawdownPct
      || margin_level <= InpMinMarginLevelPct
      || spread > InpMaxSpreadPoints
      || total_lots >= InpMaxTotalLots)
      return SAFETY_PAUSED;
   return SAFETY_NORMAL;
}

double CalculateGridPoints()
{
   double minimum = (double)InpMinGridPoints;
   if(g_atrHandle == INVALID_HANDLE || _Point <= 0.0)
      return minimum;

   double values[1];
   if(CopyBuffer(g_atrHandle, 0, 1, 1, values) != 1 || values[0] <= 0.0)
      return minimum;
   return MathMax(minimum, values[0] * InpAtrGridMultiplier / _Point);
}

bool IsNewBar()
{
   datetime current = iTime(_Symbol, _Period, 0);
   if(current <= 0) return false;
   if(g_lastBarTime == 0)
   {
      g_lastBarTime = current;
      return false;
   }
   if(current == g_lastBarTime) return false;
   g_lastBarTime = current;
   return true;
}

int CountSide(const ENUM_POSITION_TYPE side)
{
   int count = 0;
   for(int i = 0; i < ArraySize(g_positions); i++)
      if(g_positions[i].side == side) count++;
   return count;
}

double LotsSide(const ENUM_POSITION_TYPE side)
{
   double lots = 0.0;
   for(int i = 0; i < ArraySize(g_positions); i++)
      if(g_positions[i].side == side) lots += g_positions[i].volume;
   return lots;
}

double LatestSeedPrice(const ENUM_POSITION_TYPE side)
{
   datetime latest_time = 0;
   double latest_price = 0.0;
   for(int i = 0; i < ArraySize(g_positions); i++)
   {
      if(g_positions[i].side != side) continue;
      if(g_positions[i].open_time >= latest_time)
      {
         latest_time = g_positions[i].open_time;
         latest_price = g_positions[i].open_price;
      }
   }
   return latest_price;
}

int SelectHarvestCandidate()
{
   int selected = -1;
   double best = -DBL_MAX;
   for(int i = 0; i < ArraySize(g_positions); i++)
   {
      if(g_positions[i].inventory_class != CLASS_HARVESTABLE) continue;
      if(g_positions[i].net_profit > best)
      {
         best = g_positions[i].net_profit;
         selected = i;
      }
   }
   return selected;
}

int SelectDebtCandidate()
{
   int selected = -1;
   double smallest_loss = DBL_MAX;
   for(int i = 0; i < ArraySize(g_positions); i++)
   {
      if(g_positions[i].inventory_class != CLASS_DEBT) continue;
      double loss = MathAbs(g_positions[i].net_profit - EstimatedExitCost(g_positions[i].volume));
      if(loss < smallest_loss)
      {
         smallest_loss = loss;
         selected = i;
      }
   }
   return selected;
}

bool CanPairDebt(const PositionSnapshot &debt)
{
   double expected_loss = MathAbs(debt.net_profit - EstimatedExitCost(debt.volume));
   return g_harvestCredit - expected_loss - InpPairingReserveMoney
      >= InpMinPairNetMoney;
}

void WriteAudit(const string event_name,
                const ulong ticket = 0,
                const string side = "",
                const double volume = 0.0,
                const double net_profit = 0.0,
                const long return_code = 0)
{
   if(!InpWriteAuditLog) return;
   int handle = FileOpen("ouroboros_inventory_audit.csv",
                         FILE_READ | FILE_WRITE | FILE_CSV | FILE_COMMON | FILE_SHARE_READ,
                         ',');
   if(handle == INVALID_HANDLE) return;
   if(FileSize(handle) == 0)
      FileWrite(handle, "time", "event", "symbol", "ticket", "side", "volume",
                "net_profit", "harvest_credit", "drawdown_pct", "margin_level", "return_code");
   FileSeek(handle, 0, SEEK_END);
   FileWrite(handle,
             TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS),
             event_name, _Symbol, ticket, side,
             DoubleToString(volume, 4), DoubleToString(net_profit, 2),
             DoubleToString(g_harvestCredit, 2), DoubleToString(CurrentDrawdownPct(), 2),
             DoubleToString(CurrentMarginLevelPct(), 2), return_code);
   FileClose(handle);
}

void SetPendingAction(const ENUM_PENDING_ACTION action, const ulong ticket)
{
   g_pendingAction = action;
   g_pendingTicket = ticket;
   g_mutationInFlight = true;
}

void ClearPendingAction()
{
   g_pendingAction = ACTION_NONE;
   g_pendingTicket = 0;
   g_mutationInFlight = false;
}

bool ExecuteHarvest(const int index)
{
   if(!CanMutateTrades()) return false;
   if(index < 0 || index >= ArraySize(g_positions) || g_mutationInFlight) return false;

   PositionSnapshot item = g_positions[index];
   double minimum = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double close_volume = NormalizeVolume(item.volume * InpHarvestFraction);
   double retained = NormalizeVolume(item.volume - close_volume);
   if(close_volume < minimum || retained < MathMax(minimum, InpCoreMinVolume))
      return false;

   SetPendingAction(ACTION_HARVEST, item.ticket);
   WriteAudit("harvest_request", item.ticket,
              item.side == POSITION_TYPE_BUY ? "BUY" : "SELL",
              close_volume, item.net_profit, 0);
   bool ok = g_trade.PositionClosePartial(item.ticket, close_volume);
   if(!ok)
   {
      WriteAudit("harvest_failed", item.ticket, "", close_volume,
                 item.net_profit, (long)g_trade.ResultRetcode());
      ClearPendingAction();
   }
   return ok;
}

bool ExecuteDebtRetirement(const int index)
{
   if(!CanMutateTrades()) return false;
   if(index < 0 || index >= ArraySize(g_positions) || g_mutationInFlight) return false;
   PositionSnapshot item = g_positions[index];
   if(!CanPairDebt(item)) return false;

   SetPendingAction(ACTION_DEBT_CLOSE, item.ticket);
   WriteAudit("debt_close_request", item.ticket,
              item.side == POSITION_TYPE_BUY ? "BUY" : "SELL",
              item.volume, item.net_profit, 0);
   bool ok = g_trade.PositionClose(item.ticket);
   if(!ok)
   {
      WriteAudit("debt_close_failed", item.ticket, "", item.volume,
                 item.net_profit, (long)g_trade.ResultRetcode());
      ClearPendingAction();
   }
   return ok;
}

bool OpenSeed(const ENUM_POSITION_TYPE side, const string reason)
{
   if(!CanMutateTrades() || g_mutationInFlight) return false;
   double volume = NormalizeVolume(InpFixedLot);
   if(volume <= 0.0) return false;

   g_mutationInFlight = true;
   bool ok = false;
   if(side == POSITION_TYPE_BUY)
      ok = g_trade.Buy(volume, _Symbol, 0.0, 0.0, 0.0, "OURO_BUY_" + reason);
   else
      ok = g_trade.Sell(volume, _Symbol, 0.0, 0.0, 0.0, "OURO_SELL_" + reason);

   WriteAudit(ok ? reason : reason + "_failed", 0,
              side == POSITION_TYPE_BUY ? "BUY" : "SELL",
              volume, 0.0, (long)g_trade.ResultRetcode());
   g_mutationInFlight = false;
   return ok;
}

bool ManageSeeding(const ENUM_SAFETY_STATE safety)
{
   if(safety != SAFETY_NORMAL || !IsNewBar()) return false;
   if(TotalManagedLots() + NormalizeVolume(InpFixedLot) > InpMaxTotalLots + 1e-9)
      return false;

   int buys = CountSide(POSITION_TYPE_BUY);
   int sells = CountSide(POSITION_TYPE_SELL);
   if(buys == 0) return OpenSeed(POSITION_TYPE_BUY, "seed");
   if(sells == 0) return OpenSeed(POSITION_TYPE_SELL, "seed");

   double grid_price = CalculateGridPoints() * _Point;
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   if(buys < InpMaxPositionsPerSide
      && MathAbs(ask - LatestSeedPrice(POSITION_TYPE_BUY)) >= grid_price)
      return OpenSeed(POSITION_TYPE_BUY, "reseed");
   if(sells < InpMaxPositionsPerSide
      && MathAbs(bid - LatestSeedPrice(POSITION_TYPE_SELL)) >= grid_price)
      return OpenSeed(POSITION_TYPE_SELL, "reseed");
   return false;
}

bool EmergencyCloseAll()
{
   bool emergency_permission = CanExecuteEmergency();
   g_emergencyLatched = true;
   if(ActiveMode() == MODE_MONITOR)
   {
      WriteAudit("emergency_monitor_alert");
      return false;
   }
   if(!emergency_permission || g_mutationInFlight) return false;

   for(int i = ArraySize(g_positions) - 1; i >= 0; i--)
   {
      SetPendingAction(ACTION_EMERGENCY_CLOSE, g_positions[i].ticket);
      bool ok = g_trade.PositionClose(g_positions[i].ticket);
      WriteAudit(ok ? "emergency_close_request" : "emergency_close_failed",
                 g_positions[i].ticket, "", g_positions[i].volume,
                 g_positions[i].net_profit, (long)g_trade.ResultRetcode());
      if(!ok) ClearPendingAction();
      return ok;
   }
   return false;
}

void UpdateDashboard(const ENUM_SAFETY_STATE safety,
                     const double drawdown,
                     const double margin_level,
                     const int spread)
{
   if(!InpShowDashboard)
   {
      Comment("");
      return;
   }

   int core = 0, harvestable = 0, debt = 0, neutral = 0;
   double floating = 0.0;
   for(int i = 0; i < ArraySize(g_positions); i++)
   {
      floating += g_positions[i].net_profit;
      if(g_positions[i].inventory_class == CLASS_CORE_ASSET) core++;
      else if(g_positions[i].inventory_class == CLASS_HARVESTABLE) harvestable++;
      else if(g_positions[i].inventory_class == CLASS_DEBT) debt++;
      else neutral++;
   }

   string text = "OUROBOROS INVENTORY EA v1\n";
   text += "Mode: " + ModeName() + " | Mutation: " + (CanMutateTrades() ? "ENABLED" : "BLOCKED") + "\n";
   text += "Safety: " + SafetyName(safety) + " | Emergency latch: " + (g_emergencyLatched ? "ON" : "OFF") + "\n";
   text += StringFormat("Balance %.2f | Equity %.2f | Floating %+.2f\n",
                        AccountInfoDouble(ACCOUNT_BALANCE), AccountInfoDouble(ACCOUNT_EQUITY), floating);
   text += StringFormat("DD %.2f%% | Margin %.1f%% | Spread %d pts\n", drawdown, margin_level, spread);
   text += StringFormat("BUY %d / %.2f | SELL %d / %.2f | Total %.2f\n",
                        CountSide(POSITION_TYPE_BUY), LotsSide(POSITION_TYPE_BUY),
                        CountSide(POSITION_TYPE_SELL), LotsSide(POSITION_TYPE_SELL),
                        TotalManagedLots());
   text += StringFormat("Core %d | Harvestable %d | Debt %d | Neutral %d\n",
                        core, harvestable, debt, neutral);
   text += StringFormat("Harvest credit %.2f | Harvested %.2f | Debt retired %.2f\n",
                        g_harvestCredit, g_totalHarvested, g_totalDebtRetired);
   text += StringFormat("Grid %.0f pts | Rebate display %.2f/lot",
                        CalculateGridPoints(), InpEstimatedRebatePerLot);
   Comment(text);
}

int OnInit()
{
   if(!ValidateInputs())
   {
      Print("Ouroboros: invalid inputs");
      return INIT_PARAMETERS_INCORRECT;
   }
   if((ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE)
      != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {
      Print("Ouroboros requires an MT5 hedging account");
      return INIT_FAILED;
   }
   if(InpMode == MODE_TESTER && !MQLInfoInteger(MQL_TESTER))
   {
      Print("TESTER mode can only run in Strategy Tester");
      return INIT_FAILED;
   }
   if(InpMode == MODE_TRADE && !InpEnableTrading)
      Print("TRADE mode selected but InpEnableTrading is false; mutations remain blocked");

   g_trade.SetExpertMagicNumber(InpMagic);
   g_trade.SetTypeFillingBySymbol(_Symbol);
   g_atrHandle = iATR(_Symbol, _Period, InpAtrPeriod);
   if(g_atrHandle == INVALID_HANDLE)
      Print("ATR unavailable; minimum grid distance will be used");

   g_peakEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   g_lastBarTime = iTime(_Symbol, _Period, 0);
   RefreshPositions();
   WriteAudit("initialized");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(g_atrHandle != INVALID_HANDLE) IndicatorRelease(g_atrHandle);
   Comment("");
   WriteAudit("deinitialized", 0, "", 0.0, 0.0, reason);
}

void OnTick()
{
   RefreshPositions();
   double drawdown = CurrentDrawdownPct();
   double margin_level = CurrentMarginLevelPct();
   int spread = CurrentSpreadPoints();
   ENUM_SAFETY_STATE safety = EvaluateSafetyState(
      drawdown, margin_level, spread, TotalManagedLots()
   );

   if(safety == SAFETY_EMERGENCY)
   {
      EmergencyCloseAll();
      UpdateDashboard(safety, drawdown, margin_level, spread);
      return;
   }

   UpdateDashboard(safety, drawdown, margin_level, spread);
   if(ActiveMode() == MODE_MONITOR || !CanMutateTrades()) return;

   int harvest = SelectHarvestCandidate();
   if(harvest >= 0 && ExecuteHarvest(harvest)) return;

   int debt = SelectDebtCandidate();
   if(debt >= 0 && ExecuteDebtRetirement(debt)) return;

   ManageSeeding(safety);
}

void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
{
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD || trans.deal == 0) return;
   if(!HistoryDealSelect(trans.deal)) return;
   if(HistoryDealGetString(trans.deal, DEAL_SYMBOL) != _Symbol) return;
   if(HistoryDealGetInteger(trans.deal, DEAL_MAGIC) != InpMagic) return;
   if((ENUM_DEAL_ENTRY)HistoryDealGetInteger(trans.deal, DEAL_ENTRY) != DEAL_ENTRY_OUT) return;

   double realized = HistoryDealGetDouble(trans.deal, DEAL_PROFIT)
                   + HistoryDealGetDouble(trans.deal, DEAL_SWAP)
                   + HistoryDealGetDouble(trans.deal, DEAL_COMMISSION)
                   + HistoryDealGetDouble(trans.deal, DEAL_FEE);
   double volume = HistoryDealGetDouble(trans.deal, DEAL_VOLUME);

   if(g_pendingAction == ACTION_HARVEST)
   {
      double credit = MathMax(0.0, realized);
      g_harvestCredit += credit;
      g_totalHarvested += credit;
      WriteAudit("harvest_result", g_pendingTicket, "", volume, realized, result.retcode);
      ClearPendingAction();
   }
   else if(g_pendingAction == ACTION_DEBT_CLOSE)
   {
      double consumed = MathAbs(MathMin(0.0, realized));
      g_harvestCredit = MathMax(0.0, g_harvestCredit - consumed);
      g_totalDebtRetired += consumed;
      WriteAudit("debt_close_result", g_pendingTicket, "", volume, realized, result.retcode);
      ClearPendingAction();
   }
   else if(g_pendingAction == ACTION_EMERGENCY_CLOSE)
   {
      WriteAudit("emergency_close_result", g_pendingTicket, "", volume, realized, result.retcode);
      ClearPendingAction();
   }
}
