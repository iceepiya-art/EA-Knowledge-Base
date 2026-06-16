//+------------------------------------------------------------------+
//|                              HedgeGrid_V23.mq5                   |
//|   V23: ATR Week Grid + Dynamic Lot + Smart Trailing (rebuilt)    |
//|   รองรับทุกสกุลเงิน ทุกโบรค — pip value จาก broker จริง         |
//+------------------------------------------------------------------+
#property strict
#include <Trade\Trade.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>

//=====================================================================
//=== [ INTERNAL SECURITY LOCK ] ===
//=====================================================================
const bool      INTERNAL_LOCK_DEMO = false;                   // false = อนุญาต real account
const datetime  INTERNAL_EXPIRY    = D'2126.12.31 23:59';

const long INTERNAL_ACCOUNT_LOCK = 0;          // 0 = ไม่ล็อค | ใส่เลขพอร์ตเพื่อล็อค

enum ENUM_START_MODE  { M_MANUAL = 0, M_AUTO_PA = 1 };
enum ENUM_TRADE_MODE  { T_FOLLOW_FIXED = 0, T_FOLLOW_STEP = 1, T_AGAINST_STEP = 2, T_BOTH_STEP = 3, T_HYBRID_STEP = 4 };
enum ENUM_PROFIT_MODE { CLOSE_INDEPENDENT = 0, CLOSE_COMBINED = 1 };
enum ENUM_DIST_MODE   { DIST_FIXED = 0, DIST_ATR = 1 };
enum ENUM_RESUME_MODE { RESUME_HOUR = 0, RESUME_MARKET_OPEN = 1, RESUME_MANUAL = 2 };

//--- Input Parameters
input group "=== [ โหมดการทำงานหลัก ] ==="
input ENUM_START_MODE   InpStartMode              = M_AUTO_PA;
input ENUM_PROFIT_MODE  InpProfitCloseMode        = CLOSE_INDEPENDENT;

input group "=== [ การตั้งค่าการเทรด ] ==="
input double            InpInitialLot             = 0.05;           // ใช้เมื่อ InpUseDynamicLot = false
input double            InpLotStep                = 0.05;
input int               InpMaxOrdersPerSide       = 80;
input double            InpMaxLotSize             = 10.0;
input ENUM_TRADE_MODE   InpTradeMode              = T_HYBRID_STEP;

input group "=== [ ATR Dynamic Grid Distance ] ==="
input ENUM_DIST_MODE    InpDistMode               = DIST_ATR;
input int               InpLossDistance           = 1000;           // fallback fixed (points)
input int               InpAtrPeriod              = 14;             // ATR Day period
input int               InpMinGridPoints          = 600;            // ratio ~1.7x (Week/Day XAUUSD) → grid ~1,000pts
input double            InpGridStep               = 0.1;            // +10%/ไม้

input group "=== [ ATR Dynamic Lot Sizing ] ==="
input bool              InpUseDynamicLot          = true;
input double            InpRiskPct                = 0.01;           // 1% ของทุนต่อ grid move
input double            InpAtrFraction            = 1.0;            // fraction ของ ATR Day (1.0 = full ATR)
input double            InpLotMin                 = 0.001;          // ขั้นต่ำ (ลดเพื่อให้ dynamic lot ได้ค่าจริง)

input group "=== [ Smart Trailing Profit ] ==="
input double            InpActivateMult           = 2.0;            // ไม่ใช้แล้ว (reserved)
input double            InpActivatePct            = 0.01;           // Activate เมื่อกำไร = Balance × 1%
input double            InpTrailingAtrMult        = 0.0001;          // TrailStep = lot × grid × pipVal × mult
input double            InpTrailMinPct            = 0.001;          // TrailStep ขั้นต่ำ = Balance × 0.1%
input int               InpCombinedThreshold      = 10;             // ไม้รวม ≥ ค่านี้ → Combined mode

input group "=== [ Cut Loss System ] ==="
input bool              InpUseCutLoss         = false;            // เปิด/ปิดระบบ cut
input double            InpCutLossAmount      = 1000.0;           // ตัดเมื่อ floating P&L รวม <= -$X
input ENUM_RESUME_MODE  InpResumeMode         = RESUME_HOUR;      // โหมดกลับมาทำงาน
input int               InpResumeAfterHours   = 4;                // (RESUME_HOUR) กลับมาหลังกี่ชั่วโมง
input int               InpMarketOpenHour     = 0;                // (RESUME_MARKET_OPEN) กลับตอนกี่โมง 0-23

input group "=== [ Mobile Control ] ==="
input bool              InpUseMobileControl       = true;

input group "=== [ Dashboard ] ==="
input bool              InpShowDashboard          = true;
input ENUM_BASE_CORNER  InpDashboardCorner        = CORNER_RIGHT_UPPER;
input color             InpBgColor                = C'35,35,35';

//=====================================================================
//=== [ GLOBAL VARIABLES ] ===
//=====================================================================
CTrade   m_trade;
int      magicNumber       = 987654;

// ATR Handles
int      g_atrDayHandle    = INVALID_HANDLE;
int      g_atrWkHandle     = INVALID_HANDLE;

// ATR Cache — อัปเดตเฉพาะแท่ง D1 ใหม่
double   g_cachedAtrDay    = 0;
double   g_cachedAtrWeek   = 0;
double   g_cachedPipVal    = 0;
datetime g_lastAtrUpdate   = 0;
bool     g_atrError        = false;

// 3-decimal broker normalization (XAUUSD.iux 3 digits → _Point=0.001)
// g_pntNorm = 0.01 always (normalized "standard point" = $0.01 per point)
double   g_pntNorm         = 0.01;

// Trailing State
double   g_peakBuy         = 0;
double   g_peakSell        = 0;
double   g_peakTotal       = 0;
bool     g_trailActiveBuy  = false;
bool     g_trailActiveSell = false;
bool     g_trailActiveTotal= false;
bool     g_wasCombined     = false;

// EA State
bool     g_isEAOn          = true;

// Cut Loss State
bool     g_cutTriggered    = false;   // true = EA หยุดเพราะ cut loss
datetime g_cutTime         = 0;       // เวลาที่ cut เกิดขึ้น

// Dashboard labels
CChartObjectRectLabel m_bg;
CChartObjectLabel     m_labels[15];

//=====================================================================
//=== [ SECURITY ] ===
//=====================================================================
bool IsAuthorized() {
   // 1. ตรวจวันหมดอายุ
   if(TimeCurrent() > INTERNAL_EXPIRY) {
      Alert("EA หมดอายุ! กรุณาติดต่อผู้พัฒนา");
      return false;
   }

   // 2. ตรวจ Demo Lock
   if(INTERNAL_LOCK_DEMO && AccountInfoInteger(ACCOUNT_TRADE_MODE) != ACCOUNT_TRADE_MODE_DEMO) {
      Alert("ERROR: DEMO ONLY!");
      return false;
   }

   // 3. ตรวจเลขพอร์ต
   if(INTERNAL_ACCOUNT_LOCK != 0 && AccountInfoInteger(ACCOUNT_LOGIN) != INTERNAL_ACCOUNT_LOCK) {
      Alert("ไม่ได้รับอนุญาต! Account #" + (string)AccountInfoInteger(ACCOUNT_LOGIN));
      return false;
   }

   return true;
}

//=====================================================================
//=== [ PRE-RUN POSITION REPORT ] ===
//=====================================================================
void ReportOpenPositions() {
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   int    cntB=0,   cntS=0;
   double pnlB=0,   pnlS=0,   lotB=0,   lotS=0;
   double deepBuy=bid, deepSell=bid;   // ราคาไม้ที่ค้างมากสุด
   double deepBuyPnl=0, deepSellPnl=0;
   ulong  deepBuyTkt=0, deepSellTkt=0;

   Print("========== [PRE-RUN] ตรวจสอบไม้ค้าง ==========");
   Print(StringFormat(" Symbol: %s | BID: %.5f | Magic: %d", _Symbol, bid, magicNumber));

   for(int i = 0; i < PositionsTotal(); i++) {
      ulong t = PositionGetTicket(i);
      if(!PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)  != magicNumber) continue;

      ENUM_POSITION_TYPE pt  = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double openPx  = PositionGetDouble(POSITION_PRICE_OPEN);
      double lot     = PositionGetDouble(POSITION_VOLUME);
      double pnl     = PositionGetDouble(POSITION_PROFIT)
                     + PositionGetDouble(POSITION_SWAP)
                     + PositionGetDouble(POSITION_COMMISSION);
      double distPts = (pt == POSITION_TYPE_BUY)
                       ? (bid - openPx) / g_pntNorm
                       : (openPx - bid) / g_pntNorm;
      string distStr = StringFormat("%+.0fpts", distPts);
      string side    = (pt == POSITION_TYPE_BUY) ? "BUY " : "SELL";

      PrintFormat(" [%s] #%I64u | Open:%.5f | Lot:%.2f | P&L:%+.2f | Dist:%s",
                  side, t, openPx, lot, pnl, distStr);

      if(pt == POSITION_TYPE_BUY) {
         cntB++; pnlB += pnl; lotB += lot;
         if(openPx < deepBuy || deepBuyTkt == 0) {
            deepBuy=openPx; deepBuyPnl=pnl; deepBuyTkt=t;
         }
      } else {
         cntS++; pnlS += pnl; lotS += lot;
         if(openPx > deepSell || deepSellTkt == 0) {
            deepSell=openPx; deepSellPnl=pnl; deepSellTkt=t;
         }
      }
   }

   int totalPos = cntB + cntS;
   if(totalPos == 0) {
      Print(" ไม่มีไม้ค้าง — พร้อมเริ่มต้นใหม่");
   } else {
      Print("-------------------------------------------");
      PrintFormat(" BUY  %d ไม้ | Lot:%.2f | P&L:%+.2f", cntB, lotB, pnlB);
      PrintFormat(" SELL %d ไม้ | Lot:%.2f | P&L:%+.2f", cntS, lotS, pnlS);
      PrintFormat(" รวม  %d ไม้ | P&L:%+.2f %s", totalPos, pnlB+pnlS,
                  AccountInfoString(ACCOUNT_CURRENCY));
      if(deepBuyTkt  != 0) PrintFormat(" ★ BUY  ลึกสุด: Open=%.5f | Dist=%+.0fpts | P&L=%+.2f",
                                        deepBuy,  (bid-deepBuy)/g_pntNorm,  deepBuyPnl);
      if(deepSellTkt != 0) PrintFormat(" ★ SELL ลึกสุด: Open=%.5f | Dist=%+.0fpts | P&L=%+.2f",
                                        deepSell, (deepSell-bid)/g_pntNorm, deepSellPnl);

      // คำเตือนถ้าไม้มาก
      if(totalPos >= InpMaxOrdersPerSide)
         Print(" !! WARNING: ไม้ค้างเต็ม MaxOrdersPerSide — EA จะไม่เพิ่มไม้ใหม่ !!");
      else if(totalPos >= InpMaxOrdersPerSide * 0.7)
         PrintFormat(" ! CAUTION: ไม้ค้าง %d/%d ไม้ (%.0f%%) ใกล้ limit",
                     totalPos, InpMaxOrdersPerSide,
                     100.0*totalPos/InpMaxOrdersPerSide);
   }
   Print("=================================================");
}

//=====================================================================
//=== [ INIT / DEINIT ] ===
//=====================================================================
int OnInit() {
   if(!IsAuthorized()) return(INIT_FAILED);
   m_trade.SetExpertMagicNumber(magicNumber);

   g_atrDayHandle = iATR(_Symbol, PERIOD_D1, InpAtrPeriod);
   g_atrWkHandle  = iATR(_Symbol, PERIOD_W1, 4);

   if(g_atrDayHandle == INVALID_HANDLE || g_atrWkHandle == INVALID_HANDLE) {
      Print("WARNING: ไม่สามารถสร้าง ATR Handle ได้ — จะใช้ DIST_FIXED แทน");
      g_atrError = true;
   }

   // Normalize _Point to 0.01 scale for 3-decimal brokers (e.g. _Digits=3 → _Point=0.001)
   g_pntNorm = (_Digits >= 3) ? _Point * 10.0 : _Point;

   UpdateAtrCache();
   ReportOpenPositions();

   if(InpShowDashboard) { InitDashboard(); ChartRedraw(); }
   PrintFormat("HedgeGrid V23 | DistMode=%s | DynLot=%s | Acct=%s [%s] | CurrFactor=%.4f | Digits=%d | pntNorm=%.5f | InitLot=%.2f",
               (InpDistMode == DIST_ATR ? "ATR" : "FIXED"),
               (InpUseDynamicLot ? "ON" : "OFF"),
               AccountInfoString(ACCOUNT_CURRENCY),
               (IsCentAccount() ? "CENT" : "STANDARD"),
               GetCurrencyFactor(),
               _Digits, g_pntNorm,
               GetInitialLot());
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, "HG_");
   if(g_atrDayHandle != INVALID_HANDLE) IndicatorRelease(g_atrDayHandle);
   if(g_atrWkHandle  != INVALID_HANDLE) IndicatorRelease(g_atrWkHandle);
}

//=====================================================================
//=== [ ATR CACHE ] ===
//=====================================================================
void UpdateAtrCache() {
   datetime barTime = iTime(_Symbol, PERIOD_D1, 0);
   if(barTime == g_lastAtrUpdate && g_cachedAtrDay > 0) return;

   double atrDay[], atrWk[];
   ArraySetAsSeries(atrDay, true);
   ArraySetAsSeries(atrWk,  true);

   bool okD = (g_atrDayHandle != INVALID_HANDLE &&
               CopyBuffer(g_atrDayHandle, 0, 1, 1, atrDay) >= 1 &&
               atrDay[0] > 0);
   bool okW = (g_atrWkHandle  != INVALID_HANDLE &&
               CopyBuffer(g_atrWkHandle,  0, 1, 1, atrWk)  >= 1 &&
               atrWk[0]  > 0);

   g_atrError = !(okD && okW);

   if(okD) g_cachedAtrDay  = atrDay[0] / g_pntNorm;
   if(okW) g_cachedAtrWeek = atrWk[0]  / g_pntNorm;

   g_cachedPipVal   = GetPipValue();
   g_lastAtrUpdate  = barTime;

   PrintFormat("ATR Cache | Day=%.0fpts Week=%.0fpts Ratio=%.2f PipVal=$%.4f/pt/lot Error=%s",
               g_cachedAtrDay, g_cachedAtrWeek,
               (g_cachedAtrDay > 0 ? g_cachedAtrWeek/g_cachedAtrDay : 0),
               g_cachedPipVal, g_atrError ? "YES" : "NO");
   PrintFormat("TickVal=$%.5f TickSize=%.5f _Point=%.5f Digits=%d pntNorm=%.5f",
               SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE),
               SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE),
               _Point, _Digits, g_pntNorm);
}

//=====================================================================
//=== [ BROKER HELPERS ] ===
//=====================================================================

//--- ตรวจหา suffix ของโบรค อัตโนมัติจาก _Symbol
//    เช่น "XAUUSD.iux" → suffix = ".iux"
//         "EURUSDm"    → suffix = "m"
//         "XAUUSD"     → suffix = ""
string GetBrokerSuffix() {
   string sym = _Symbol;
   // หา suffix โดยตัด base currency pairs ออก
   // base symbols ที่รู้จัก
   string bases[] = {"XAUUSD","EURUSD","GBPUSD","USDJPY","USDCHF",
                      "AUDUSD","NZDUSD","USDCAD","XAGUSD","BTCUSD"};
   for(int i = 0; i < ArraySize(bases); i++) {
      int len = StringLen(bases[i]);
      if(StringLen(sym) >= len && StringSubstr(sym, 0, len) == bases[i])
         return StringSubstr(sym, len); // คืน suffix ที่เหลือ
   }
   return "";
}

//--- ตรวจสอบ Cent Account อัตโนมัติ
bool IsCentAccount() {
   string cur = AccountInfoString(ACCOUNT_CURRENCY);
   StringToLower(cur);
   if(StringFind(cur, "cent") >= 0) return true;
   if(StringFind(cur, "usc")  >= 0) return true;
   // ตรวจจาก symbol suffix เช่น XAUUSDc
   string sfx = GetBrokerSuffix();
   StringToLower(sfx);
   if(sfx == "c" || sfx == ".c") return true;
   return false;
}

//--- แปลง account currency → USD factor
double GetCurrencyFactor() {
   if(IsCentAccount()) return 0.01;

   string cur = AccountInfoString(ACCOUNT_CURRENCY);
   StringToUpper(cur);
   if(cur == "USD") return 1.0;

   // หา suffix ของโบรคเพื่อต่อท้าย pair
   string sfx = GetBrokerSuffix();

   string pairDirect  = cur + "USD" + sfx;  // "EURUSD.iux"
   string pairReverse = "USD" + cur + sfx;  // "USDJPY.iux"

   double rate = 0;
   double ask  = SymbolInfoDouble(pairDirect, SYMBOL_ASK);
   if(ask > 0) { rate = ask; }
   else {
      ask = SymbolInfoDouble(pairReverse, SYMBOL_ASK);
      if(ask > 0) rate = 1.0 / ask;
   }

   // ถ้ายังไม่เจอ ลองไม่มี suffix
   if(rate <= 0) {
      ask = SymbolInfoDouble(cur + "USD", SYMBOL_ASK);
      if(ask > 0) rate = ask;
      else {
         ask = SymbolInfoDouble("USD" + cur, SYMBOL_ASK);
         if(ask > 0) rate = 1.0 / ask;
      }
   }

   if(rate <= 0) {
      PrintFormat("WARNING: ไม่พบ rate ของ %s (suffix='%s') → ใช้ factor=1.0", cur, sfx);
      return 1.0;
   }
   return rate;
}

//--- PipValue ต่อ 1 point ต่อ 1 lot (หน่วย account currency)
//    แล้วแปลงเป็น USD ด้วย CurrencyFactor
double GetPipValue() {
   double tickVal  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0 || tickVal <= 0) return 10.0;

   // $/pt/lot ในหน่วย account currency
   double pipVal = tickVal / tickSize;
   if(pipVal <= 0) return 10.0;

   // แปลงเป็น USD (หรือหาร 100 ถ้า cent)
   pipVal *= GetCurrencyFactor();
   return pipVal;
}

double NormalizeLot(double lot) {
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double mn   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double mx   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(step <= 0) step = 0.01;
   lot = MathRound(lot / step) * step;
   return MathMax(mn, MathMin(mx, lot));
}

//=====================================================================
//=== [ DYNAMIC LOT ] ===
//=====================================================================
double GetInitialLot() {
   if(!InpUseDynamicLot) return InpInitialLot;
   if(g_atrError || g_cachedAtrWeek <= 0 || g_cachedPipVal <= 0) return InpInitialLot;

   // Balance ในหน่วย account currency → แปลงเป็น USD ก่อน
   double balance    = AccountInfoDouble(ACCOUNT_BALANCE) * GetCurrencyFactor();
   double riskDollar = balance * InpRiskPct;
   double atrRef     = g_cachedAtrWeek * InpAtrFraction;  // ใช้ ATR Week(4) แทน ATR Day
   if(atrRef <= 0) return InpInitialLot;

   // lot = riskDollar(USD) / (atrWk × pipValue(USD/pt/lot))
   double lot = riskDollar / (atrRef * g_cachedPipVal);

   static int dbg = 0;
   if(++dbg >= 500) {
      dbg = 0;
      PrintFormat("DynLot | Bal=%s%.0f (USD:$%.0f) Risk=$%.2f ATRwk=%.0fpts PipVal=$%.4f → Lot=%.3f",
                  AccountInfoString(ACCOUNT_CURRENCY),
                  AccountInfoDouble(ACCOUNT_BALANCE),
                  balance, riskDollar, g_cachedAtrWeek, g_cachedPipVal, lot);
   }

   return NormalizeLot(MathMax(InpLotMin, lot));
}

//=====================================================================
//=== [ GRID DISTANCE ] ===
//=====================================================================
double GetGridDistance(int orderIndex) {
   if(InpDistMode == DIST_FIXED || g_atrError || g_cachedAtrDay <= 0 || g_cachedAtrWeek <= 0)
      return InpLossDistance;

   double ratio    = g_cachedAtrWeek / g_cachedAtrDay;
   double gridDist = ratio * InpMinGridPoints * (1.0 + orderIndex * InpGridStep);

   // Clamp: ขั้นต่ำ = InpMinGridPoints (absolute), สูงสุด = 3× MinGridPoints
   // ไม่ใช้ 0.5× เพราะถ้า ratio ต่ำ (เช่น 1.7×) จะได้แคบเกิน
   double minDist = (double)InpMinGridPoints;
   double maxDist = InpMinGridPoints * 3.0;
   gridDist = MathMax(minDist, MathMin(maxDist, gridDist));

   static int dbg = 0;
   if(++dbg >= 200) {
      dbg = 0;
      PrintFormat("Grid | Ratio=%.2f MinGrid=%d Grid[%d]=%.0fpts",
                  ratio, InpMinGridPoints, orderIndex, gridDist);
   }

   return NormalizeDouble(gridDist, 0);
}

//=====================================================================
//=== [ POSITION HELPERS ] ===
//=====================================================================
int CountPos(ENUM_POSITION_TYPE side) {
   int c = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == magicNumber &&
         PositionGetInteger(POSITION_TYPE)  == side) c++;
   }
   return c;
}

double GetSideProfit(ENUM_POSITION_TYPE side) {
   double p = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == magicNumber &&
         PositionGetInteger(POSITION_TYPE)  == side)
         p += PositionGetDouble(POSITION_PROFIT) +
              PositionGetDouble(POSITION_SWAP)   +
              PositionGetDouble(POSITION_COMMISSION);
   }
   return p;
}

double GetTotalLot(ENUM_POSITION_TYPE side) {
   double lot = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == magicNumber &&
         PositionGetInteger(POSITION_TYPE)  == side)
         lot += PositionGetDouble(POSITION_VOLUME);
   }
   return lot;
}

void CloseSide(ENUM_POSITION_TYPE side) {
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == magicNumber &&
         PositionGetInteger(POSITION_TYPE)  == side)
         m_trade.PositionClose(t);
   }
}

ulong GetLastTicket(ENUM_POSITION_TYPE side) {
   ulong    lastT    = 0;
   datetime lastTime = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == magicNumber &&
         PositionGetInteger(POSITION_TYPE)  == side) {
         if((datetime)PositionGetInteger(POSITION_TIME) > lastTime) {
            lastTime = (datetime)PositionGetInteger(POSITION_TIME);
            lastT    = t;
         }
      }
   }
   return lastT;
}

bool IsLevelOccupied(ENUM_POSITION_TYPE side, double p, double gridDist) {
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == magicNumber &&
         PositionGetInteger(POSITION_TYPE)  == side) {
         if(MathAbs(p - PositionGetDouble(POSITION_PRICE_OPEN)) < gridDist * 0.7 * g_pntNorm)
            return true;
      }
   }
   return false;
}

void ResetTrailingState() {
   g_peakBuy = 0; g_peakSell = 0; g_peakTotal = 0;
   g_trailActiveBuy = false; g_trailActiveSell = false; g_trailActiveTotal = false;
}

//=====================================================================
//=== [ SMART TRAILING PROFIT ] ===
//=====================================================================
void ManageTrailingProfit() {
   int  totalOrders = CountPos(POSITION_TYPE_BUY) + CountPos(POSITION_TYPE_SELL);
   bool isCombined  = (totalOrders >= InpCombinedThreshold);

   // Detect mode switch → reset state
   if(isCombined != g_wasCombined) {
      ResetTrailingState();
      g_wasCombined = isCombined;
      Print("Trailing mode switch → ", isCombined ? "COMBINED" : "INDEPENDENT", " | State reset");
   }

   // ใช้ raw account currency เพื่อให้ตรงกับ GetSideProfit() (cent=cents, USD=dollars)
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   if(isCombined) {
      // === Combined Mode ===
      double totalLot    = GetTotalLot(POSITION_TYPE_BUY) + GetTotalLot(POSITION_TYPE_SELL);
      double totalProfit = GetSideProfit(POSITION_TYPE_BUY) + GetSideProfit(POSITION_TYPE_SELL);

      // Activate = Balance × InpActivatePct (simple, เข้าใจง่าย ควบคุมได้)
      double activateLevel = balance * InpActivatePct;

      // TrailStep ในหน่วย account currency (หาร GetCurrencyFactor เพื่อ convert จาก USD)
      double gridPts   = GetGridDistance(totalOrders > 0 ? totalOrders : 1);
      double trailStep = totalLot * gridPts * g_cachedPipVal * InpTrailingAtrMult / GetCurrencyFactor();
      trailStep        = MathMax(trailStep, balance * InpTrailMinPct);

      if(!g_trailActiveTotal) {
         if(totalProfit >= activateLevel) {
            g_trailActiveTotal = true;
            g_peakTotal        = totalProfit;
            PrintFormat("Trailing ACTIVATED (Combined) | Peak=$%.2f Activate=$%.2f TrailStep=$%.2f",
                        g_peakTotal, activateLevel, trailStep);
         }
      } else {
         if(totalProfit > g_peakTotal) g_peakTotal = totalProfit;
         double drawback = g_peakTotal - totalProfit;
         if(drawback >= trailStep) {
            PrintFormat("Trailing CLOSE (Combined) | Peak=$%.2f Current=$%.2f Drawback=$%.2f Step=$%.2f",
                        g_peakTotal, totalProfit, drawback, trailStep);
            CloseSide(POSITION_TYPE_BUY);
            CloseSide(POSITION_TYPE_SELL);
            ResetTrailingState();
         }
      }
   } else {
      // === Independent Mode ===

      // --- BUY ---
      double buyLot    = GetTotalLot(POSITION_TYPE_BUY);
      double buyProfit = GetSideProfit(POSITION_TYPE_BUY);
      if(CountPos(POSITION_TYPE_BUY) > 0) {
         double activateB  = balance * InpActivatePct;
         double gridPtsB   = GetGridDistance(CountPos(POSITION_TYPE_BUY));
         double trailStepB = buyLot * gridPtsB * g_cachedPipVal * InpTrailingAtrMult / GetCurrencyFactor();
         trailStepB        = MathMax(trailStepB, balance * InpTrailMinPct);

         if(!g_trailActiveBuy) {
            if(buyProfit >= activateB) {
               g_trailActiveBuy = true;
               g_peakBuy        = buyProfit;
               PrintFormat("Trailing ACTIVATED (BUY) | Peak=$%.2f Activate=$%.2f Step=$%.2f",
                           g_peakBuy, activateB, trailStepB);
            }
         } else {
            if(buyProfit > g_peakBuy) g_peakBuy = buyProfit;
            double drawback = g_peakBuy - buyProfit;
            if(drawback >= trailStepB) {
               PrintFormat("Trailing CLOSE (BUY) | Peak=$%.2f Drawback=$%.2f Step=$%.2f",
                           g_peakBuy, drawback, trailStepB);
               CloseSide(POSITION_TYPE_BUY);
               g_peakBuy = 0; g_trailActiveBuy = false;
            }
         }
      } else { g_peakBuy = 0; g_trailActiveBuy = false; }

      // --- SELL ---
      double sellLot    = GetTotalLot(POSITION_TYPE_SELL);
      double sellProfit = GetSideProfit(POSITION_TYPE_SELL);
      if(CountPos(POSITION_TYPE_SELL) > 0) {
         double activateS  = balance * InpActivatePct;
         double gridPtsS   = GetGridDistance(CountPos(POSITION_TYPE_SELL));
         double trailStepS = sellLot * gridPtsS * g_cachedPipVal * InpTrailingAtrMult / GetCurrencyFactor();
         trailStepS        = MathMax(trailStepS, balance * InpTrailMinPct);

         if(!g_trailActiveSell) {
            if(sellProfit >= activateS) {
               g_trailActiveSell = true;
               g_peakSell        = sellProfit;
               PrintFormat("Trailing ACTIVATED (SELL) | Peak=$%.2f Activate=$%.2f Step=$%.2f",
                           g_peakSell, activateS, trailStepS);
            }
         } else {
            if(sellProfit > g_peakSell) g_peakSell = sellProfit;
            double drawback = g_peakSell - sellProfit;
            if(drawback >= trailStepS) {
               PrintFormat("Trailing CLOSE (SELL) | Peak=$%.2f Drawback=$%.2f Step=$%.2f",
                           g_peakSell, drawback, trailStepS);
               CloseSide(POSITION_TYPE_SELL);
               g_peakSell = 0; g_trailActiveSell = false;
            }
         }
      } else { g_peakSell = 0; g_trailActiveSell = false; }
   }
}

//=====================================================================
//=== [ AUTO PA SIGNAL ] ===
//=====================================================================
void CheckPASignals() {
   MqlRates r[]; ArraySetAsSeries(r, true);
   if(CopyRates(_Symbol, _Period, 0, 3, r) < 3) return;
   bool buySig  = (r[1].close > r[1].open) && (r[2].open > r[2].close) &&
                  (r[1].close >= r[2].open) && (r[1].open <= r[2].close);
   bool sellSig = (r[1].open > r[1].close) && (r[2].close > r[2].open) &&
                  (r[1].open >= r[2].close) && (r[1].close <= r[2].open);
   double initLot = GetInitialLot();
   if(buySig  && CountPos(POSITION_TYPE_BUY)  == 0) m_trade.Buy(initLot,  _Symbol);
   if(sellSig && CountPos(POSITION_TYPE_SELL) == 0) m_trade.Sell(initLot, _Symbol);
}

//=====================================================================
//=== [ GRID MANAGEMENT ] ===
//=====================================================================
void ManageSide(ENUM_POSITION_TYPE side) {
   int count = CountPos(side);
   if(count == 0) return;

   ulong lastT = GetLastTicket(side);
   if(lastT > 0 && PositionSelectByTicket(lastT)) {
      double lastP    = PositionGetDouble(POSITION_PRICE_OPEN);
      double lastL    = PositionGetDouble(POSITION_VOLUME);
      double bid      = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask      = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double curP     = (side == POSITION_TYPE_BUY) ? bid : ask;
      double gridDist = GetGridDistance(count);

      if(IsLevelOccupied(side, curP, gridDist) || count >= InpMaxOrdersPerSide) return;

      bool isF = (side == POSITION_TYPE_BUY) ?
                 (ask >= lastP + gridDist * g_pntNorm) :
                 (bid <= lastP - gridDist * g_pntNorm);
      bool isA = (side == POSITION_TYPE_BUY) ?
                 (bid <= lastP - gridDist * g_pntNorm) :
                 (ask >= lastP + gridDist * g_pntNorm);

      double initLot = GetInitialLot();
      double nL = 0;
      // ใช้ initLot เป็น step เพื่อให้การเพิ่ม lot สัมพันธ์กับ dynamic lot จริง
      // ไม้ 1=0.005 → ไม้ 2=0.010 → ไม้ 3=0.015 (สม่ำเสมอ ไม่กระโดด)
      if     (InpTradeMode == T_HYBRID_STEP)                   { if(isF) nL = initLot; else if(isA) nL = lastL + initLot; }
      else if(InpTradeMode == T_FOLLOW_FIXED  && isF)           nL = initLot;
      else if(InpTradeMode == T_FOLLOW_STEP   && isF)           nL = lastL + initLot;
      else if(InpTradeMode == T_AGAINST_STEP  && isA)           nL = lastL + initLot;
      else if(InpTradeMode == T_BOTH_STEP     && (isF || isA))  nL = lastL + initLot;

      if(nL > 0) {
         nL = NormalizeLot(MathMin(nL, InpMaxLotSize));
         if(side == POSITION_TYPE_BUY) m_trade.Buy(nL,  _Symbol);
         else                          m_trade.Sell(nL, _Symbol);
      }
   }
}

//=====================================================================
//=== [ ON TICK ] ===
//=====================================================================
void OnTick() {
   if(TimeCurrent() > INTERNAL_EXPIRY) {
      CloseSide(POSITION_TYPE_BUY); CloseSide(POSITION_TYPE_SELL);
      ExpertRemove(); return;
   }

   // 1. อัปเดต ATR Cache (cheap — skip ถ้าแท่งเดิม)
   UpdateAtrCache();

   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   double dd = AccountInfoDouble(ACCOUNT_BALANCE) - AccountInfoDouble(ACCOUNT_EQUITY);

   // 2. Mobile Control
   if(InpUseMobileControl) {
      for(int i = OrdersTotal()-1; i >= 0; i--) {
         if(OrderSelect(OrderGetTicket(i))) {
            string com = OrderGetString(ORDER_COMMENT); StringToUpper(com);
            if(com == "CLOSE ALL" || com == "ปิดสถานะทั้งหมด") {
               CloseSide(POSITION_TYPE_BUY); CloseSide(POSITION_TYPE_SELL);
               ResetTrailingState(); return;
            }
         }
      }
   }

   // 3. Auto PA Signal
   if(InpStartMode == M_AUTO_PA && g_isEAOn) {
      static datetime last_time = 0;
      if(last_time != iTime(_Symbol, _Period, 0)) {
         last_time = iTime(_Symbol, _Period, 0);
         CheckPASignals();
      }
   }

   // 4. Smart Trailing Profit
   if(g_isEAOn) ManageTrailingProfit();

   // 5. Grid Management
   if(g_isEAOn) {
      ManageSide(POSITION_TYPE_BUY);
      ManageSide(POSITION_TYPE_SELL);
   }

   // 6. Cut Loss System
   CheckCutLoss();
   CheckAutoResume();

   if(InpShowDashboard) DrawDashboard(dd, dt);
}

//=====================================================================
//=== [ CUT LOSS SYSTEM ] ===
//=====================================================================
void CheckCutLoss() {
   if(!InpUseCutLoss || g_cutTriggered) return;

   double totalPnL = GetSideProfit(POSITION_TYPE_BUY) + GetSideProfit(POSITION_TYPE_SELL);
   // แปลง PnL เป็น USD ก่อนเทียบ (InpCutLossAmount ใส่เป็น USD เสมอ)
   if(totalPnL * GetCurrencyFactor() <= -MathAbs(InpCutLossAmount)) {
      CloseSide(POSITION_TYPE_BUY);
      CloseSide(POSITION_TYPE_SELL);
      g_isEAOn       = false;
      g_cutTriggered = true;
      g_cutTime      = TimeCurrent();
      ResetTrailingState();
      PrintFormat("CutLoss TRIGGERED | PnL=$%.2f | Threshold=-$%.2f | ResumeMode=%d",
                  totalPnL, InpCutLossAmount, InpResumeMode);
   }
}

string GetResumeTimeStr() {
   if(InpResumeMode == RESUME_MANUAL)       return "Manual";
   if(InpResumeMode == RESUME_MARKET_OPEN)  return StringFormat("MktOpen %02d:00", InpMarketOpenHour);
   // RESUME_HOUR
   datetime resumeAt = g_cutTime + (datetime)(InpResumeAfterHours * 3600);
   MqlDateTime r; TimeToStruct(resumeAt, r);
   return StringFormat("%02d:%02d (+%dh)", r.hour, r.min, InpResumeAfterHours);
}

void CheckAutoResume() {
   if(!g_cutTriggered || g_isEAOn) return;
   if(InpResumeMode == RESUME_MANUAL) return;

   datetime now = TimeCurrent();
   MqlDateTime dt; TimeToStruct(now, dt);
   bool doResume = false;

   if(InpResumeMode == RESUME_HOUR) {
      doResume = (now >= g_cutTime + (datetime)(InpResumeAfterHours * 3600));
   } else if(InpResumeMode == RESUME_MARKET_OPEN) {
      // กลับตอน HH:00 ของวันถัดไป (ต้องผ่านไปอย่างน้อย 1 ชั่วโมงก่อน resume กันซ้ำ)
      doResume = (dt.hour == InpMarketOpenHour && dt.min < 5 && now > g_cutTime + 3600);
   }

   if(doResume) {
      g_isEAOn       = true;
      g_cutTriggered = false;
      g_cutTime      = 0;
      PrintFormat("AutoResume | Mode=%d | Time=%s", InpResumeMode, TimeToString(TimeCurrent()));
   }
}

//=====================================================================
//=== [ DASHBOARD ] ===
//=====================================================================
void InitDashboard() {
   if(ObjectFind(0, "HG_BG") < 0) {
      m_bg.Create(0, "HG_BG", 0, 10, 10, 280, 270);
      m_bg.Corner(InpDashboardCorner);
      m_bg.BackColor(InpBgColor);
   }
   for(int i = 0; i < 15; i++) {
      string n = "HG_L" + (string)i;
      if(ObjectFind(0, n) < 0) {
         m_labels[i].Create(0, n, 0, 22, 18 + (i * 17));
         m_labels[i].Corner(InpDashboardCorner);
         m_labels[i].FontSize(8);
      }
   }
}

void DrawDashboard(double dd, MqlDateTime &dt) {
   int    cntB        = CountPos(POSITION_TYPE_BUY);
   int    cntS        = CountPos(POSITION_TYPE_SELL);
   int    totalOrders = cntB + cntS;
   bool   isCombined  = (totalOrders >= InpCombinedThreshold);
   double lotB        = GetTotalLot(POSITION_TYPE_BUY);
   double lotS        = GetTotalLot(POSITION_TYPE_SELL);
   double lotTotal    = lotB + lotS;
   double gridNow     = GetGridDistance(totalOrders > 0 ? totalOrders : 1);
   // แสดงตาม account currency จริง (USC=cents, USD=dollars ไม่ convert)
   double balance     = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity      = AccountInfoDouble(ACCOUNT_EQUITY);
   string curStr      = AccountInfoString(ACCOUNT_CURRENCY);

   // Activate = Balance × % (simple)
   // TrailStep = lot × grid × pipVal × mult (scale ตาม exposure)
   double lotRef       = isCombined ? lotTotal : MathMax(lotB, lotS);
   double activate     = balance * InpActivatePct;
   double trailStep    = lotRef * gridNow * g_cachedPipVal * InpTrailingAtrMult;
   trailStep           = MathMax(trailStep, balance * InpTrailMinPct);

   string trailB  = g_trailActiveBuy   ? StringFormat("Peak:%.1f", g_peakBuy)   : "รอ";
   string trailS  = g_trailActiveSell  ? StringFormat("Peak:%.1f", g_peakSell)  : "รอ";
   string trailT  = g_trailActiveTotal ? StringFormat("Peak:%.1f", g_peakTotal) : "รอ";
   string initLotStr = StringFormat("%.2f (%s)", GetInitialLot(), InpUseDynamicLot?"Dynamic(Wk)":"Fixed");
   string modeStr    = (InpTradeMode==T_HYBRID_STEP?"HYBRID":
                        InpTradeMode==T_FOLLOW_STEP?"FOLLOW_STEP":
                        InpTradeMode==T_AGAINST_STEP?"AGAINST":
                        InpTradeMode==T_BOTH_STEP?"BOTH":"FOLLOW_FIX");

   string titles[15];
   titles[0]  = "   \u2605 HEDGE GRID PA V23 \u2605";
   titles[1]  = StringFormat(" Equity:%.2f  Bal:%.2f [%s]", equity, balance, curStr);
   titles[2]  = StringFormat(" BUY:  %.2f | %dไม้ | Lot:%.2f", GetSideProfit(POSITION_TYPE_BUY),  cntB, lotB);
   titles[3]  = StringFormat(" SELL: %.2f | %dไม้ | Lot:%.2f", GetSideProfit(POSITION_TYPE_SELL), cntS, lotS);
   titles[4]  = StringFormat(" Mode: %s (%d/%d)", isCombined?"COMBINED":"INDEPENDENT", totalOrders, InpCombinedThreshold);
   titles[5]  = StringFormat(" DD: %.2f %s", dd, curStr);
   titles[6]  = StringFormat(" Grid: %.0fpts (%s) Min:%d", gridNow, InpDistMode==DIST_ATR?"ATR":"FIXED", InpMinGridPoints);
   titles[7]  = StringFormat(" ATR Day:%.0fpts  Week:%.0fpts", g_cachedAtrDay, g_cachedAtrWeek);
   titles[8]  = StringFormat(" Activate:%.2f  TrailStep:%.2f", activate, trailStep);
   titles[9]  = StringFormat(" Trail BUY:  %s", trailB);
   titles[10] = StringFormat(" Trail SELL: %s", trailS);
   titles[11] = StringFormat(" Init Lot: %s", initLotStr);
   titles[12] = StringFormat(" Trade:%s  Start:%s", modeStr, InpStartMode==M_AUTO_PA?"AUTO PA":"MANUAL");
   string statusStr = g_isEAOn ? "RUNNING" : (g_cutTriggered ? "CUT" : "STOPPED");
   titles[13] = StringFormat(" Status:%s  %02d:%02d", statusStr, dt.hour, dt.min);

   // Row[14] priority: ATR ERROR > CUT info > Expiry
   MqlDateTime expDt; TimeToStruct(INTERNAL_EXPIRY, expDt);
   string expiryStr = StringFormat(" Expiry: %04d.%02d.%02d", expDt.year, expDt.mon, expDt.day);
   if(g_atrError)
      titles[14] = " !! ATR ERROR - FIXED MODE !!";
   else if(g_cutTriggered)
      titles[14] = StringFormat(" CUT %.0f %s | Resume: %s", InpCutLossAmount, curStr, GetResumeTimeStr());
   else if(isCombined)
      titles[14] = StringFormat(" Combined Trail: %s", trailT);
   else
      titles[14] = expiryStr;

   if(ObjectFind(0, "HG_BG") < 0) InitDashboard();

   for(int i = 0; i < 15; i++) {
      string n = "HG_L" + (string)i;
      if(ObjectFind(0, n) < 0) InitDashboard();
      m_labels[i].Description(titles[i]);

      color c = clrWhite;
      if(i == 0)                           c = clrGold;
      if(i == 4  && isCombined)            c = clrYellow;
      if(i == 6  && InpDistMode==DIST_ATR) c = clrAqua;
      if(i == 9  && g_trailActiveBuy)      c = clrLimeGreen;
      if(i == 10 && g_trailActiveSell)     c = clrLimeGreen;
      if(i == 13 && g_cutTriggered)         c = clrOrange;
      if(i == 13 && !g_isEAOn && !g_cutTriggered) c = clrRed;
      if(i == 14 && g_atrError)            c = clrRed;
      if(i == 14 && g_cutTriggered && !g_atrError) c = clrOrange;
      m_labels[i].Color(c);
   }
   ChartRedraw();
}
