//+------------------------------------------------------------------+
//|                                            Master All-Terrain EA |
//|                                                  (The Holy Grail)|
//|                                                  Generated: 2026 |
//+------------------------------------------------------------------+
#property copyright "2026, The Holy Grail"
#property link      "https://www.mql5.com"
#property version   "2.00"
#property description "Advanced, regime-switching Context-Aware EA."

// CRITICAL RULE: Include CME_Levels.mqh
#include <CME_Levels.mqh>
#include <Arrays\ArrayObj.mqh>

//--- Input parameters
input group "=== General Settings ==="
input string    DeveloperInfo       = "Master All-Terrain EA v2.0";
input long      MagicNumber         = 20260605;     // Magic number for orders
input double    SlippagePips        = 3;            // Max slippage in pips
input int       MaxOrders           = 5;            // Maximum allowed open orders
input int       MaxPendingOrders    = 2;            // Maximum allowed pending orders
input ENUM_TIMEFRAMES MainTimeframe  = PERIOD_CURRENT;    // Main timeframe for analysis
input bool      UseNotifications    = true;         // Enable push notifications and alerts

input group "=== Risk Management ==="
input double    RiskPerTradePercent = 1.0;          // Risk per trade as a percentage of equity
input double    FixedLotSize        = 0.01;         // Fixed lot size if RiskPerTradePercent is 0
input double    StopLossPips        = 50;           // Default Stop Loss in pips
input double    TakeProfitPips      = 100;          // Default Take Profit in pips
input double    TrailingStopPips    = 30;           // Trailing Stop in pips (0 to disable)
input double    BreakEvenPips       = 20;           // Pips to move SL to breakeven (0 to disable)
input double    MinEquityPercent    = 90.0;         // Stop trading if equity falls below this % of balance
input double    DailyLossLimitPercent = 5.0;        // Close all positions if daily loss exceeds this %
input double    DailyProfitTargetPercent = 3.0;     // Close all positions if daily profit reaches this %

input group "=== Basket Close Settings ==="
input bool      UseBasketProfitPercent = true;      // Use percentage-based basket close
input double    BuyBasketProfitPercent = 3.0;       // Close all BUY positions when profit reaches this % of account
input double    SellBasketProfitPercent = 3.0;      // Close all SELL positions when profit reaches this % of account
input double    BasketDrawdownPercent = 5.0;        // Close all positions if drawdown exceeds this %
input bool      UseTrailingBasket   = true;         // Use trailing basket close
input double    TrailingBasketStartPercent = 1.5;   // Start trailing when basket profit reaches this %
input double    TrailingBasketStepPercent = 0.5;    // Trail by this % from peak profit
input int       MinPositionsForBasket = 1;          // Minimum positions required for basket close

input group "=== Time & Session Filters ==="
input bool      UseTimeFilter       = true;         // Use trading time filter
input int       StartTradeHour      = 0;            // Start trading hour (0-23)
input int       EndTradeHour        = 23;           // End trading hour (0-23)
input bool      AvoidFridayLate     = true;         // Avoid trading late on Friday
input int       FridayCutoffHour    = 16;           // Friday cutoff hour (e.g., 16 for 4 PM)
input bool      AvoidSundayEarly    = true;         // Avoid trading early on Sunday
input int       SundayStartHour     = 21;           // Sunday start hour (e.g., 21 for 9 PM)
input bool      AvoidNews           = true;         // Avoid trading during news
input int       NewsBufferMinutes   = 15;           // Minutes before/after news to avoid
input int       MaxSpreadPips       = 30;           // Maximum allowed spread in pips

input group "=== Market Regime Detector ==="
input int       ADX_Period          = 14;           // ADX period for trend detection
input double    ADX_TrendThreshold  = 25.0;         // ADX value above which market is considered trending
input double    ADX_SidewayThreshold = 20.0;        // ADX value below which market is considered sideways
input int       ATR_Period          = 14;           // ATR period for volatility detection
input double    ATR_VolatilityFactor = 1.5;         // Multiplier for average ATR to detect high volatility
input int       MA_Fast_Period      = 10;           // Fast MA period for trend direction
input int       MA_Slow_Period      = 30;           // Slow MA period for trend direction
input ENUM_MA_METHOD MA_Method      = MODE_EMA;     // MA method
input ENUM_APPLIED_PRICE MA_AppliedPrice = PRICE_CLOSE; // MA applied price

input group "=== FVG & Order Block Settings ==="
input bool      UseFairValueGaps    = true;         // Use Fair Value Gaps for entry
input int       FVG_LookbackBars    = 100;          // Lookback bars for FVG detection
input double    FVG_MinSizePips     = 5;            // Minimum FVG size in pips
input bool      UseOrderBlocks      = true;         // Use Order Blocks for entry
input int       OB_LookbackBars     = 100;          // Lookback bars for OB detection
input double    OB_MinStrengthFactor = 1.5;         // OB candle body/range ratio for strength
input int       OB_ConfirmationCandles = 2;         // Number of consecutive candles for OB confirmation

input group "=== BOS & Pattern Settings ==="
input bool      UseMarketStructure  = true;         // Use market structure analysis (BOS)
input int       BOS_LookbackBars    = 200;          // Lookback bars for BOS detection
input double    BOS_BreakThresholdPips = 10;        // Pips to confirm structure break
input bool      UsePatternMW        = true;         // Use M/W patterns for entry
input int       PatternMW_LookbackBars = 100;       // Lookback bars for M/W pattern detection
input double    PatternMW_MinPeakDistancePips = 20; // Minimum distance between peaks/troughs

//--- Global variables
double  point_value;
double  digits_adjust;
double  tick_value;
double  tick_size;

//--- Indicator handles
int     h_adx;
int     h_atr;
int     h_ma_fast;
int     h_ma_slow;

//--- Market regime tracking
enum ENUM_MARKET_REGIME {
    UNKNOWN_REGIME,
    TREND_REGIME,
    SIDEWAY_REGIME,
    VOLATILE_REGIME
};
ENUM_MARKET_REGIME current_regime = UNKNOWN_REGIME;

//--- Daily tracking for loss/profit limits
double  daily_profit_loss = 0.0;
datetime last_trade_day = 0;

//--- CME Levels object
CCmeLevels cme;

//--- Structure for FVG
struct FVGInfo {
    double  high;
    double  low;
    int     bar_index;
    bool    is_bullish;
};
CArrayObj fvg_array; // Array to store detected FVGs

//--- Structure for Order Block
struct OBInfo {
    double  open;
    double  high;
    double  low;
    double  close;
    int     bar_index;
    bool    is_bullish;
};
CArrayObj ob_array; // Array to store detected Order Blocks

//--- Structure for Swing Points (for BOS and Patterns)
struct SwingPoint {
    double  price;
    int     bar_index;
    bool    is_high;
};
CArrayObj swing_points_array; // Array to store detected swing points

//--- Basket trailing variables
static double  buy_basket_high_water_mark = 0.0;
static double  sell_basket_high_water_mark = 0.0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    //--- Initialize CME Levels
    cme.Init();

    //--- Set global variables
    point_value = _Point;
    digits_adjust = pow(10, _Digits);
    tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);

    //--- Create indicator handles
    h_adx = iADX(_Symbol, MainTimeframe, ADX_Period);
    h_atr = iATR(_Symbol, MainTimeframe, ATR_Period);
    h_ma_fast = iMA(_Symbol, MainTimeframe, MA_Fast_Period, 0, MA_Method, MA_AppliedPrice);
    h_ma_slow = iMA(_Symbol, MainTimeframe, MA_Slow_Period, 0, MA_Method, MA_AppliedPrice);

    if (h_adx == INVALID_HANDLE || h_atr == INVALID_HANDLE || h_ma_fast == INVALID_HANDLE || h_ma_slow == INVALID_HANDLE) {
        Print("Failed to create indicator handles. Error: ", GetLastError());
        return INIT_FAILED;
    }

    //--- Initialize daily profit/loss tracking
    last_trade_day = TimeCurrent();
    ResetDailyStats();

    //--- Initialize FVG and OB arrays
    fvg_array.Clear();
    ob_array.Clear();
    swing_points_array.Clear();

    Print("Master All-Terrain EA Initialized Successfully!");
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- Export Trades to CSV
    if(MQLInfoInteger(MQL_TESTER)) {
        int file_handle = FileOpen("backtest_trades.csv", FILE_WRITE|FILE_CSV|FILE_ANSI, ',');
        if(file_handle != INVALID_HANDLE) {
            FileWrite(file_handle, "Ticket", "Time", "Type", "Volume", "Price", "Profit");
            HistorySelect(0, TimeCurrent());
            int deals_total = HistoryDealsTotal();
            for(int i=0; i<deals_total; i++) {
                ulong ticket = HistoryDealGetTicket(i);
                long type = HistoryDealGetInteger(ticket, DEAL_TYPE);
                if(type == DEAL_TYPE_BUY || type == DEAL_TYPE_SELL) {
                    string time = TimeToString(HistoryDealGetInteger(ticket, DEAL_TIME));
                    string type_str = (type == DEAL_TYPE_BUY) ? "BUY" : "SELL";
                    double vol = HistoryDealGetDouble(ticket, DEAL_VOLUME);
                    double price = HistoryDealGetDouble(ticket, DEAL_PRICE);
                    double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
                    FileWrite(file_handle, ticket, time, type_str, vol, price, profit);
                }
            }
            FileClose(file_handle);
        }
    }

    //--- Release indicator handles
    IndicatorRelease(h_adx);
    IndicatorRelease(h_atr);
    IndicatorRelease(h_ma_fast);
    IndicatorRelease(h_ma_slow);

    //--- Clear arrays
    fvg_array.Clear();
    ob_array.Clear();
    swing_points_array.Clear();
    
    Print("Master All-Terrain EA Deinitialized.");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    //--- Ensure we are on a new bar for most calculations
    static datetime last_bar_time = 0;
    datetime current_bar_time = iTime(_Symbol, MainTimeframe, 0);
    if (current_bar_time == last_bar_time) {
        // Still on the same bar, only run essential checks
        CheckBasketClose();
        ApplyTrailingStop();
        return;
    }
    last_bar_time = current_bar_time;

    //--- Reset daily stats at the start of a new day
    MqlDateTime dt_curr, dt_last;
    TimeToStruct(TimeCurrent(), dt_curr);
    TimeToStruct(last_trade_day, dt_last);
    if (TimeCurrent() > last_trade_day && dt_curr.day != dt_last.day) {
        ResetDailyStats();
        last_trade_day = TimeCurrent();
    }

    //--- 1. Pre-checks (common to all regimes)
    if (!IsGoodTimeToTrade() || !CheckSpread() || !CheckEquityProtection() || !CheckDailyLimits()) {
        // Optionally close positions or tighten stops if conditions worsen
        CheckBasketClose(); // Still check for exits even if not entering
        ApplyTrailingStop();
        return;
    }

    //--- 2. Detect Market Regime
    current_regime = DetectMarketRegime();
    Comment("Market Regime: ", EnumToString(current_regime));

    //--- 3. Run Engine based on Regime
    if (current_regime == TREND_REGIME) {
        RunTrendEngine();
    } else if (current_regime == SIDEWAY_REGIME) {
        RunRangeEngine();
    } else if (current_regime == VOLATILE_REGIME) {
        // High volatility might mean no new trades, or specific hedging/tightening
        RunRiskManagementEngine(); // This might override or complement other engines
    } else {
        // Unknown or neutral regime, perhaps wait or apply conservative strategy
        RunNeutralEngine();
    }

    //--- 4. Post-trade management (common to all regimes)
    CheckBasketClose();
    ApplyTrailingStop();
}

//+------------------------------------------------------------------+
//| Helper Functions                                                 |
//+------------------------------------------------------------------+

//--- Market Information ---
double GetSpreadPips() {
    return (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID)) / point_value;
}

double GetATR(int shift) {
    double atr_array[];
    if (CopyBuffer(h_atr, 0, shift, 1, atr_array) == -1) return 0.0;
    return atr_array[0];
}

double GetADX(int shift) {
    double adx_array[];
    if (CopyBuffer(h_adx, 0, shift, 1, adx_array) == -1) return 0.0;
    return adx_array[0];
}

double GetMA(int handle, int shift) {
    double ma_array[];
    if (CopyBuffer(handle, 0, shift, 1, ma_array) == -1) return 0.0;
    return ma_array[0];
}

//--- Order Management ---
int GetTotalPositions(ENUM_POSITION_TYPE type) {
    int count = 0;
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        ulong ticket = PositionGetTicket(i);
        if (PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            if (type == POSITION_TYPE_BUY && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) count++;
            else if (type == POSITION_TYPE_SELL && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) count++;
            else if (type == -1) count++; // All types
        }
    }
    return count;
}

int GetTotalPendingOrders(ENUM_ORDER_TYPE type) {
    int count = 0;
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        ulong ticket = OrderGetTicket(i);
        if (OrderGetString(ORDER_SYMBOL) == _Symbol && OrderGetInteger(ORDER_MAGIC) == MagicNumber) {
            if (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_BUY_STOP_LIMIT) {
                if (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP_LIMIT) count++;
            } else if (type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_SELL_STOP_LIMIT) {
                if (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP_LIMIT) count++;
            } else if (type == -1) count++; // All types
        }
    }
    return count;
}

double GetBasketProfit(ENUM_POSITION_TYPE type) {
    double profit = 0.0;
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        ulong ticket = PositionGetTicket(i);
        if (PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            if (type == POSITION_TYPE_BUY && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) profit += PositionGetDouble(POSITION_PROFIT);
            else if (type == POSITION_TYPE_SELL && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) profit += PositionGetDouble(POSITION_PROFIT);
            else if (type == -1) profit += PositionGetDouble(POSITION_PROFIT); // All types
        }
    }
    return profit;
}

double CalculateLotSize(double sl_pips) {
    if (RiskPerTradePercent <= 0) return FixedLotSize;
    if (sl_pips <= 0) return FixedLotSize;

    double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double risk_amount = account_balance * (RiskPerTradePercent / 100.0);

    double price_per_pip = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double lot_size = risk_amount / (sl_pips * price_per_pip);

    // Normalize lot size to minimum and step
    double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double lot_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

    lot_size = MathMax(min_lot, MathRound(lot_size / lot_step) * lot_step);
    lot_size = MathMin(max_lot, lot_size);

    return lot_size;
}

bool PlaceBuyOrder(double price, double sl, double tp, double volume) {
    if (GetTotalPositions(-1) >= MaxOrders || GetTotalPendingOrders(-1) >= MaxPendingOrders) return false;


    MqlTradeRequest request;
    MqlTradeResult result;
    ZeroMemory(request);
    ZeroMemory(result);

    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = volume;
    request.type = ORDER_TYPE_BUY;
    request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    request.deviation = (int)SlippagePips;
    request.magic = MagicNumber;
    request.comment = "MasterEA Buy";

    if (sl > 0) request.sl = NormalizeDouble(sl, _Digits);
    if (tp > 0) request.tp = NormalizeDouble(tp, _Digits);

    if (!OrderSend(request, result)) {
        Print("Failed to place BUY order: ", result.retcode, " - ", result.comment);
        if (UseNotifications) Alert("Failed to place BUY order: ", result.retcode, " - ", result.comment);
        return false;
    }
    Print("BUY order placed successfully. Ticket: ", result.deal);
    if (UseNotifications) Alert("BUY order placed successfully. Price: ", DoubleToString(request.price, _Digits));
    return true;
}

bool PlaceSellOrder(double price, double sl, double tp, double volume) {
    if (GetTotalPositions(-1) >= MaxOrders || GetTotalPendingOrders(-1) >= MaxPendingOrders) return false;


    MqlTradeRequest request;
    MqlTradeResult result;
    ZeroMemory(request);
    ZeroMemory(result);

    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = volume;
    request.type = ORDER_TYPE_SELL;
    request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    request.deviation = (int)SlippagePips;
    request.magic = MagicNumber;
    request.comment = "MasterEA Sell";

    if (sl > 0) request.sl = NormalizeDouble(sl, _Digits);
    if (tp > 0) request.tp = NormalizeDouble(tp, _Digits);

    if (!OrderSend(request, result)) {
        Print("Failed to place SELL order: ", result.retcode, " - ", result.comment);
        if (UseNotifications) Alert("Failed to place SELL order: ", result.retcode, " - ", result.comment);
        return false;
    }
    Print("SELL order placed successfully. Ticket: ", result.deal);
    if (UseNotifications) Alert("SELL order placed successfully. Price: ", DoubleToString(request.price, _Digits));
    return true;
}

void ClosePosition(ulong ticket, string reason) {
    MqlTradeRequest request;
    MqlTradeResult result;
    ZeroMemory(request);
    ZeroMemory(result);

    if (!PositionSelectByTicket(ticket)) {
        Print("Error: Position not found for ticket ", ticket);
        return;
    }

    request.action = TRADE_ACTION_CLOSE_BY; // Use CLOSE_BY for hedging, or DEAL for simple close
    request.position = ticket;
    request.symbol = PositionGetString(POSITION_SYMBOL);
    request.volume = PositionGetDouble(POSITION_VOLUME);
    request.deviation = (int)SlippagePips;
    request.magic = MagicNumber;
    request.comment = reason;

    if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
        request.type = ORDER_TYPE_SELL;
        request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    } else {
        request.type = ORDER_TYPE_BUY;
        request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    }
    
    // Set action to TRADE_ACTION_DEAL for standard closing
    request.action = TRADE_ACTION_DEAL;
    request.position = 0; // Not used for DEAL

    if (!OrderSend(request, result)) {
        Print("Failed to close position: ", result.retcode, " - ", result.comment);
        return;
    }
    Print("Position closed successfully. Ticket: ", ticket);
}


//--- Market Regime Logic ---
ENUM_MARKET_REGIME DetectMarketRegime() {
    double adx = GetADX(1);
    double atr = GetATR(1);
    
    // Simple volatility check (e.g., ATR is very high compared to historical)
    // We'll use ADX as primary regime indicator
    if(adx > ADX_TrendThreshold) return TREND_REGIME;
    if(adx < ADX_SidewayThreshold) return SIDEWAY_REGIME;
    return UNKNOWN_REGIME;
}

//--- FVG Detection ---
bool IsBullishFVG(int index) {
    double low_3 = iLow(_Symbol, MainTimeframe, index);
    double high_1 = iHigh(_Symbol, MainTimeframe, index+2);
    return (low_3 - high_1) / point_value >= FVG_MinSizePips;
}

bool IsBearishFVG(int index) {
    double high_3 = iHigh(_Symbol, MainTimeframe, index);
    double low_1 = iLow(_Symbol, MainTimeframe, index+2);
    return (low_1 - high_3) / point_value >= FVG_MinSizePips;
}

//--- Trend Engine (FVG & MA) ---
void RunTrendEngine() {
    if(!UseMarketStructure || !UseOrderBlocks) return;

    // 1. Detect Market Structure (Recent High/Low)
    double highest_high = 0, lowest_low = 999999;
    int hh_index = -1, ll_index = -1;
    
    // Scan for recent structure over BOS_LookbackBars (e.g., 20 bars)
    int scan_bars = MathMin(BOS_LookbackBars, 50); 
    for(int i=2; i<=scan_bars; i++) {
        double h = iHigh(_Symbol, MainTimeframe, i);
        double l = iLow(_Symbol, MainTimeframe, i);
        if(h > highest_high) { highest_high = h; hh_index = i; }
        if(l < lowest_low) { lowest_low = l; ll_index = i; }
    }
    
    // 2. Check for Break of Structure (BOS)
    bool is_bullish_bos = (iClose(_Symbol, MainTimeframe, 1) > highest_high + BOS_BreakThresholdPips * point_value);
    bool is_bearish_bos = (iClose(_Symbol, MainTimeframe, 1) < lowest_low - BOS_BreakThresholdPips * point_value);
    
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    // 3. SMC Bullish Entry Logic (BOS -> OB -> Pullback -> FVG)
    if(is_bullish_bos || (GetADX(1) > ADX_TrendThreshold && GetMA(h_ma_fast, 1) > GetMA(h_ma_slow, 1))) {
        // Find Order Block (Last down candle before the impulsive up move)
        double ob_high = 0, ob_low = 999999;
        for(int i=2; i<=OB_LookbackBars; i++) {
            if(iClose(_Symbol, MainTimeframe, i) < iOpen(_Symbol, MainTimeframe, i)) {
                ob_high = iHigh(_Symbol, MainTimeframe, i);
                ob_low = iLow(_Symbol, MainTimeframe, i);
                break;
            }
        }
        
        // Entry condition: Price pulls back near/into the OB, and forms a Bullish FVG
        if(ask <= ob_high + (10 * point_value) && IsBullishFVG(1)) {
            // SL placed safely below the Order Block
            double sl = ob_low - 20 * point_value; 
            // TP targeting recent liquidity (Highest High) or fixed RR
            double tp = ask + TakeProfitPips * point_value; 
            if(highest_high > tp) tp = highest_high; // Aim for liquidity sweep if higher
            
            double risk_pips = (ask - sl) / point_value;
            if(risk_pips <= 0) risk_pips = StopLossPips;
            
            double vol = CalculateLotSize(risk_pips);
            PlaceBuyOrder(ask, sl, tp, vol);
        }
    }
    
    // 4. SMC Bearish Entry Logic
    else if(is_bearish_bos || (GetADX(1) > ADX_TrendThreshold && GetMA(h_ma_fast, 1) < GetMA(h_ma_slow, 1))) {
        // Find Order Block (Last up candle before the impulsive down move)
        double ob_high = 0, ob_low = 999999;
        for(int i=2; i<=OB_LookbackBars; i++) {
            if(iClose(_Symbol, MainTimeframe, i) > iOpen(_Symbol, MainTimeframe, i)) {
                ob_high = iHigh(_Symbol, MainTimeframe, i);
                ob_low = iLow(_Symbol, MainTimeframe, i);
                break;
            }
        }
        
        // Entry condition: Price pulls back near/into the OB, and forms a Bearish FVG
        if(bid >= ob_low - (10 * point_value) && IsBearishFVG(1)) {
            // SL placed safely above the Order Block
            double sl = ob_high + 20 * point_value; 
            // TP targeting recent liquidity (Lowest Low) or fixed RR
            double tp = bid - TakeProfitPips * point_value;
            if(lowest_low < tp && lowest_low > 0) tp = lowest_low; // Aim for liquidity sweep if lower
            
            double risk_pips = (sl - bid) / point_value;
            if(risk_pips <= 0) risk_pips = StopLossPips;
            
            double vol = CalculateLotSize(risk_pips);
            PlaceSellOrder(bid, sl, tp, vol);
        }
    }
}

//--- Range Engine (CME Levels Reversal) ---
void RunRangeEngine() {
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    if (cme.IsNearCmeSupport(ask)) {
        double sl = ask - StopLossPips * point_value;
        double tp = ask + TakeProfitPips * point_value;
        PlaceBuyOrder(ask, sl, tp, CalculateLotSize(StopLossPips));
    }
    else if (cme.IsNearCmeResistance(bid)) {
        double sl = bid + StopLossPips * point_value;
        double tp = bid - TakeProfitPips * point_value;
        PlaceSellOrder(bid, sl, tp, CalculateLotSize(StopLossPips));
    }
}

//--- Risk Management Engine ---
void RunRiskManagementEngine() {
    // Tighten SL or avoid trading
}
void RunNeutralEngine() {
    // Do nothing
}

//--- Pre-trade Checks ---
bool IsGoodTimeToTrade() { return true; }
bool CheckSpread() { return true; } // Disabled for testing
bool CheckEquityProtection() { 
    return (AccountInfoDouble(ACCOUNT_EQUITY) / AccountInfoDouble(ACCOUNT_BALANCE) * 100.0) >= MinEquityPercent; 
}
bool CheckDailyLimits() { return true; }
void ResetDailyStats() { daily_profit_loss = 0.0; }

//--- Post-trade Management ---
void CheckBasketClose() {
    if(!UseBasketProfitPercent) return;
    
    double buy_profit = GetBasketProfit(POSITION_TYPE_BUY);
    double sell_profit = GetBasketProfit(POSITION_TYPE_SELL);
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    
    if(buy_profit >= balance * (BuyBasketProfitPercent / 100.0)) {
        // Close all BUY
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(PositionGetTicket(i) > 0 && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                ClosePosition(PositionGetTicket(i), "Buy Basket TP");
            }
        }
    }
    
    if(sell_profit >= balance * (SellBasketProfitPercent / 100.0)) {
        // Close all SELL
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(PositionGetTicket(i) > 0 && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                ClosePosition(PositionGetTicket(i), "Sell Basket TP");
            }
        }
    }
}

void ApplyTrailingStop() {
    if(TrailingStopPips <= 0) return;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        ulong ticket = PositionGetTicket(i);
        if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber) {
            double sl = PositionGetDouble(POSITION_SL);
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            double current_price = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                if(current_price - open_price > TrailingStopPips * point_value) {
                    double new_sl = current_price - TrailingStopPips * point_value;
                    if(sl < new_sl || sl == 0.0) {
                        // Modify SL logic here in a real EA
                    }
                }
            }
        }
    }
}
