//+------------------------------------------------------------------+
//| SMC_Universal_EA_v3.0.mq5                                       |
//| Multi-symbol SMC EA — กำหนด watchlist เองใน Input               |
//| Signal: W/M + BOS + FVG★ + Zone 50-62% + OB SL                 |
//| fix15 (2026-03-26):                                              |
//|   feat: Multi-Timeframe (MTF) — HTF zone confirm LTF entry      |
//|   HTF (H1/H4): Scan zone + cache ต่อ symbol (bar-based update)  |
//|   LTF (M5/M1): Entry เฉพาะเมื่ออยู่ใน HTF zone + direction match|
//|   New inputs: InpUseMTF, InpHTFPeriod, InpLTFPeriod             |
//|   InpUseMTF=false → single-TF mode (fix14 behavior)             |
//| fix16 (2026-03-27):                                              |
//|   refactor: ตัด Block Mode session filter ออก เหลือแค่ Window   |
//|   Session Filter: Sess1/Sess2 HHMM + BlockFriday เท่านั้น       |
//| fix17 (2026-04-18):                                              |
//|   feat: SC₁₀₀ Regime Gate (SMC_RegimeFilter.mqh)                |
//|   SC₁₀₀<0.25 TRENDING→follow β₁ | SC₁₀₀>0.35 REVERTING→CHoCH  |
//|   CRASH/WEAK → skip entry entirely                               |
//| fix20 (2026-04-19):                                              |
//|   feat: RSI(20)+SMA(50) confirm สำหรับ REVERTING regime          |
//|   feat: FTMO Swing mode (ไม่มี daily limit) + Total DD stop 8%  |
//|   feat: Session 3 — Asian 07:00-08:00 (เพิ่ม trade frequency)   |
//| fix21 (2026-04-19):                                              |
//|   refactor: CB.Init() → broker-agnostic (challengeBalance +      |
//|     dailyLossLimit + totalBrokerLimit + internalDDStop)          |
//|   dailyLossLimit=0 → Swing (ไม่มี daily limit)                   |
//| fix22 (2026-04-22):                                              |
//|   feat: BOS-Retest mode (InpUseBOSRetest) — fallback entry      |
//|     เมื่อ W/M pattern ไม่เจอ ใช้ BOS level + FVG retest แทน    |
//|   feat: DIAG breakdown — swing/bos/wm/fvg/zone/ob counters       |
//|     รู้ว่า scan fail ตรงขั้นตอนไหน                               |
//+------------------------------------------------------------------+
#property copyright "SMC Universal EA v3.0"
#property version   "3.00"
#property description "Multi-symbol SMC | W/M+BOS+FVG+Zone+OB | ATR Lot | R-Trail | MTF | SC100 Regime | fix22"

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_Journal.mqh>
#include <SMC_Universal\SMC_SymbolManager.mqh>
#include <SMC_Universal\SMC_MoneyManager.mqh>
#include <SMC_Universal\SMC_Scanner.mqh>
#include <SMC_Universal\SMC_TradeManager.mqh>
#include <SMC_Universal\SMC_CircuitBreaker.mqh>
#include <SMC_Universal\SMC_TimeFilter.mqh>
#include <SMC_Universal\SMC_NewsFilter.mqh>
#include <SMC_Universal\SMC_Dashboard.mqh>
#include <SMC_Universal\SMC_MTFManager.mqh>
#include <SMC_Universal\SMC_RegimeFilter.mqh>  // fix17: SC₁₀₀ Regime Gate

//+------------------------------------------------------------------+
//| Input Groups                                                     |
//+------------------------------------------------------------------+
input group "=== Symbol List ==="
input ENUM_SYMBOL_PRESET InpPreset   = PRESET_FX_GOLD;
input string InpSymbols  = "EURUSD,GBPUSD,USDJPY,XAUUSD,AUDUSD,USDCAD";

input group "=== Multi-Timeframe (MTF) ==="
input bool             InpUseMTF     = false;          // เปิด MTF mode (HTF confirm LTF)
input ENUM_TIMEFRAMES  InpHTFPeriod  = PERIOD_H1;      // HTF Timeframe (H1 หรือ H4)
input ENUM_TIMEFRAMES  InpLTFPeriod  = PERIOD_M5;      // LTF Timeframe (M5 หรือ M1)

input group "=== Signal Detection ==="
input int    InpSwingLB       = 5;
input int    InpW23Tol        = 12;
input int    InpW23Lookback   = 300;
input int    InpFVGLookback   = 300;
input int    InpMaxFVG        = 3;
input int    InpOBLookback    = 150;
input int    InpZoneBase      = 5;
input bool   InpUseBOSRetest  = false;  // fix22: BOS+FVG fallback เมื่อ W/M ไม่เจอ

input group "=== Money Management ==="
input double InpRiskPercent   = 1.0;
input double InpMaxSpreadPts  = 50;

input group "=== Trail / TP ==="
input double InpTrailStartR   = 1.5;
input double InpTrailStepR    = 0.5;
input double InpSimTP_R       = 6.0;

input group "=== Session Filter ==="
input bool   InpTFEnabled     = true;        // เปิด/ปิด Session Filter
input int    InpSess1Start    = 1400;        // Session 1 Start — London (HHMM)
input int    InpSess1End      = 1500;        // Session 1 End
input bool   InpSess2Enable   = true;        // เปิด Session 2 — NY Open
input int    InpSess2Start    = 2030;        // Session 2 Start (HHMM)
input int    InpSess2End      = 2100;        // Session 2 End
input bool   InpSess3Enable   = true;        // fix20: เปิด Session 3 — Asian
input int    InpSess3Start    = 700;         // fix20: Session 3 Start (HHMM)
input int    InpSess3End      = 800;         // fix20: Session 3 End
input bool   InpBlockFriday   = true;        // Block Friday close
input int    InpFridayHour    = 20;          // Block ตั้งแต่ชั่วโมงนี้วันศุกร์

input group "=== SMC Gate Filters ==="
input bool   InpRequireTrend  = true;    // ต้องมี HH+HL (Bull) / LH+LL (Bear)
input bool   InpRequireSweep  = true;    // ต้องมี BSL/SSL sweep ก่อน entry (NinjaThai หลักการ)
input int    InpSweepLB       = 150;     // fix25: SSL/BSL sweep lookback bars (default=150=OB range)
input bool   InpStrictCHoCH   = true;    // CHoCH gate: direction-specific ก่อน FVG

input group "=== SC₁₀₀ Regime Gate ==="
input bool   InpUseRegime     = true;    // เปิด SC₁₀₀ Regime Gate
input bool   InpAutoThreshold = true;    // fix19: auto-scale threshold ตาม TF อัตโนมัติ
input double InpSC100Trend    = 0.25;   // threshold TRENDING
input double InpSC100Revert   = 0.35;   // threshold REVERTING
input double InpSC100Crash    = 0.22;   // threshold CRASH
input int    InpSC100Bars     = 100;    // lookback bars for SC₁₀₀
input int    InpBeta1Bars     = 50;     // lookback bars for β₁ OLS
input bool   InpUseRSIConfirm = true;   // fix20: RSI+SMA confirm สำหรับ REVERTING
input int    InpRSIPeriod     = 20;     // fix20: RSI period
input int    InpSMAPeriod     = 50;     // fix20: SMA period
input double InpRSIOS         = 35.0;   // fix20: RSI Oversold threshold (LONG)
input double InpRSIOB         = 65.0;   // fix20: RSI Overbought threshold (SHORT)

input group "=== Challenge / Broker Rules ==="
input double InpChallengeBalance = 0;      // Starting balance (0 = auto จาก account)
input double InpProfitTarget     = 10.0;   // Target profit %  | FTMO=10 | E8=8 | True=10
input double InpDailyLossLimit   = 0.0;    // Daily loss limit % | 0=Swing | FTMO Norm=5 | E8=4
input double InpTotalBrokerLimit = 10.0;   // Broker max DD % | FTMO=10 | E8=8 | True=10
input double InpInternalDDStop   = 8.0;    // Internal stop % (buffer ก่อนถึง broker limit)
input int    InpMinTradeDays     = 4;      // Min trading days | FTMO=4 | E8=5 | True=10

input group "=== Other Filters ==="
input int    InpMaxPositions  = 10;
input int    InpCooldownBars  = 3;
input double InpCBLossPct     = 3.0;    // daily CB % (ใช้เฉพาะ Normal mode)
input int    InpNewsBlockMin  = 30;

input group "=== Visual ==="
input bool   InpShowVisual    = true;

//+------------------------------------------------------------------+
//| Globals                                                          |
//+------------------------------------------------------------------+
CSMCJournal         g_jn;
CSymbolManager      g_sm;
CSMCMoneyManager    g_mm;
CSMCScanner         g_sc;
CSMCTradeManager    g_tm;
CSMCCircuitBreaker  g_cb;
CSMCTimeFilter      g_tf;
CSMCNewsFilter      g_nf;
CSMCDashboard       g_db;
CSMCMTFManager      g_mtf;       // fix15: MTF manager
CSMCRegimeFilter    g_rf;        // fix17: SC₁₀₀ Regime Gate

datetime g_lastBar = 0;
bool     g_ready   = false;

//+------------------------------------------------------------------+
//| License Settings — แก้ค่า 3 บรรทัดนี้เท่านั้น                  |
//+------------------------------------------------------------------+
const bool      INTERNAL_LOCK_DEMO   = false;              // false = อนุญาต real | true = demo only
const datetime  INTERNAL_EXPIRY      = D'2126.12.31 23:59'; // วันหมดอายุ (Real + Demo)
const long      INTERNAL_ACCOUNT_LOCK = 153186222;         // 0 = ไม่ล็อค | ใส่เลขพอร์ตเพื่อล็อค real

//+------------------------------------------------------------------+
bool CheckLicense() {
   long     curAcc = AccountInfoInteger(ACCOUNT_LOGIN);
   datetime now    = TimeCurrent();
   ENUM_ACCOUNT_TRADE_MODE mode = (ENUM_ACCOUNT_TRADE_MODE)
                                   AccountInfoInteger(ACCOUNT_TRADE_MODE);
   string modeStr = (mode==ACCOUNT_TRADE_MODE_REAL)?"REAL":
                    (mode==ACCOUNT_TRADE_MODE_DEMO)?"DEMO":"CONTEST";
   PrintFormat("[LICENSE] Account:%I64d Mode:%s Date:%s",
               curAcc, modeStr, TimeToString(now,TIME_DATE));

   // หมดอายุ (Real + Demo ใช้ INTERNAL_EXPIRY เดียวกัน)
   if(now > INTERNAL_EXPIRY) {
      PrintFormat("[LICENSE] FAIL — Expired");
      MessageBox(StringFormat("EA หมดอายุ\nหมดอายุ: %s\nวันนี้: %s",
                 TimeToString(INTERNAL_EXPIRY,TIME_DATE),
                 TimeToString(now,TIME_DATE)),
                 "SMC Universal EA v3.0 — Expired", MB_OK|MB_ICONERROR);
      return false;
   }

   // ล็อค Demo only
   if(INTERNAL_LOCK_DEMO && mode == ACCOUNT_TRADE_MODE_REAL) {
      PrintFormat("[LICENSE] FAIL — Demo only mode");
      MessageBox("EA นี้อนุญาตเฉพาะ Demo account เท่านั้น",
                 "SMC Universal EA v3.0 — Unauthorized", MB_OK|MB_ICONERROR);
      return false;
   }

   // ล็อค Real account number
   if(mode == ACCOUNT_TRADE_MODE_REAL &&
      INTERNAL_ACCOUNT_LOCK != 0 && curAcc != INTERNAL_ACCOUNT_LOCK) {
      PrintFormat("[LICENSE] FAIL — Real #%I64d not authorized",curAcc);
      MessageBox(StringFormat("Real #%I64d ไม่ได้รับอนุญาต\nพอร์ตที่ใช้ได้: #%I64d",
                 curAcc, INTERNAL_ACCOUNT_LOCK),
                 "SMC Universal EA v3.0 — Unauthorized", MB_OK|MB_ICONERROR);
      return false;
   }

   int d = (int)((INTERNAL_EXPIRY - now) / 86400);
   PrintFormat("[LICENSE] OK %s #%I64d | %d days left", modeStr, curAcc, d);
   if(d <= 7) PrintFormat("[LICENSE] WARNING: เหลือ %d วัน!", d);
   return true;
}

//+------------------------------------------------------------------+
string ResolveSymbolList() {
   switch(InpPreset) {
      case PRESET_FX_MAJORS: return PRESET_MAJORS;
      case PRESET_FX_GOLD:   return PRESET_GOLD_MAJORS;
      case PRESET_FX_28:     return PRESET_FOREX28;
      case PRESET_IDX:       return PRESET_INDICES;
      case PRESET_GOLD_IDX:  return PRESET_GOLD_IDX_S;
      case PRESET_CRYPTO:    return PRESET_CRYPTO_S;
      default:               return InpSymbols;
   }
}

//+------------------------------------------------------------------+
//| Pre-run position report (all watchlist symbols)                  |
//+------------------------------------------------------------------+
void ReportOpenPositions() {
   // รัน หลัง g_sm.Init() เท่านั้น — ใช้ g_sm.Count() / g_sm.GetSymbol()
   int symCount = g_sm.Count();
   int grandTotal = 0;
   double grandPnl = 0;

   Print("========== [PRE-RUN] ตรวจสอบไม้ค้าง (ทุก symbol) ==========");

   for(int si = 0; si < symCount; si++) {
      string sym = g_sm.GetSymbol(si);
      double bid  = SymbolInfoDouble(sym, SYMBOL_BID);
      int    cntB=0, cntS=0;
      double pnlB=0, pnlS=0, lotB=0, lotS=0;
      double deepBuy=bid, deepSell=bid;
      double deepBuyPnl=0, deepSellPnl=0;
      ulong  deepBuyTkt=0, deepSellTkt=0;

      for(int i = 0; i < PositionsTotal(); i++) {
         ulong t = PositionGetTicket(i);
         if(!PositionSelectByTicket(t)) continue;
         if(PositionGetString(POSITION_SYMBOL) != sym) continue;
         if(PositionGetInteger(POSITION_MAGIC)  != EA_MAGIC) continue;

         ENUM_POSITION_TYPE pt = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         double openPx = PositionGetDouble(POSITION_PRICE_OPEN);
         double lot    = PositionGetDouble(POSITION_VOLUME);
         double pnl    = PositionGetDouble(POSITION_PROFIT)
                       + PositionGetDouble(POSITION_SWAP)
                       + PositionGetDouble(POSITION_COMMISSION);
         double pt_val = SymbolInfoDouble(sym, SYMBOL_POINT);
         if(pt_val <= 0) pt_val = 0.00001;
         double distPts = (pt == POSITION_TYPE_BUY)
                          ? (bid - openPx) / pt_val
                          : (openPx - bid) / pt_val;

         PrintFormat(" [%s] %s #%I64u | Open:%.5f | Lot:%.2f | P&L:%+.2f | Dist:%+.0fpts",
                     (pt==POSITION_TYPE_BUY?"BUY ":"SELL"), sym, t, openPx, lot, pnl, distPts);

         if(pt == POSITION_TYPE_BUY) {
            cntB++; pnlB+=pnl; lotB+=lot;
            if(openPx < deepBuy || deepBuyTkt==0) { deepBuy=openPx; deepBuyPnl=pnl; deepBuyTkt=t; }
         } else {
            cntS++; pnlS+=pnl; lotS+=lot;
            if(openPx > deepSell || deepSellTkt==0) { deepSell=openPx; deepSellPnl=pnl; deepSellTkt=t; }
         }
      }

      int symTotal = cntB + cntS;
      if(symTotal > 0) {
         double pv = SymbolInfoDouble(sym, SYMBOL_POINT);
         if(pv <= 0) pv = 0.00001;
         PrintFormat(" → %s | BUY:%d SELL:%d | P&L:%+.2f %s",
                     sym, cntB, cntS, pnlB+pnlS, AccountInfoString(ACCOUNT_CURRENCY));
         if(deepBuyTkt  != 0) PrintFormat("   ★ BUY  ลึกสุด: Open=%.5f Dist=%+.0fpts P&L=%+.2f",
                                           deepBuy,  (bid-deepBuy)/pv,  deepBuyPnl);
         if(deepSellTkt != 0) PrintFormat("   ★ SELL ลึกสุด: Open=%.5f Dist=%+.0fpts P&L=%+.2f",
                                           deepSell, (deepSell-bid)/pv, deepSellPnl);
         grandTotal += symTotal;
         grandPnl   += pnlB + pnlS;
      }
   }

   Print("-------------------------------------------");
   if(grandTotal == 0)
      Print(" ไม่มีไม้ค้างทุก symbol — พร้อมเริ่มต้นใหม่");
   else
      PrintFormat(" รวมทุก symbol: %d ไม้ | P&L:%+.2f %s",
                  grandTotal, grandPnl, AccountInfoString(ACCOUNT_CURRENCY));
   Print("=================================================");
}

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit() {
   if(!CheckLicense()) return INIT_FAILED;

   // Journal
   g_jn.Init();

   // Symbol Manager
   string symList = ResolveSymbolList();
   PrintFormat("[EA] Symbol preset: %s", symList);
   if(!g_sm.Init(symList)) {
      Print("[EA] ERROR: no valid symbols");
      return INIT_FAILED;
   }

   // Money Manager
   g_mm.SetSymbolManager(&g_sm);
   g_mm.SetRiskPct(InpRiskPercent);

   // Scanner — ส่ง gate flags
   g_sc.SetSymbolManager(&g_sm);
   g_sc.SetParams(InpSwingLB, InpW23Tol, InpW23Lookback,
                  InpFVGLookback, InpMaxFVG, InpOBLookback, InpZoneBase,
                  InpRequireTrend, InpRequireSweep, InpStrictCHoCH);
   g_sc.SetBOSRetest(InpUseBOSRetest); // fix22
   g_sc.SetSweepLB(InpSweepLB);       // fix25: SSL/BSL sweep lookback

   // Trade Manager
   g_tm.SetManagers(&g_sm, &g_mm, &g_jn);
   g_tm.SetParams(InpTrailStartR, InpTrailStepR, InpSimTP_R,
                  InpMaxPositions, InpShowVisual, InpMaxSpreadPts);
   g_tm.Init();

   // Circuit Breaker — fix21: broker-agnostic (dailyLossLimit=0 → Swing)
   g_cb.Init(&g_jn,
             InpChallengeBalance,
             InpDailyLossLimit,
             InpTotalBrokerLimit,
             InpInternalDDStop,
             InpProfitTarget,
             InpMinTradeDays);

   // Time Filter — fix20: เพิ่ม Session 3 Asian
   g_tf.Configure(InpTFEnabled,
                  InpSess1Start, InpSess1End,
                  InpSess2Enable, InpSess2Start, InpSess2End,
                  InpBlockFriday, InpFridayHour,
                  InpSess3Enable, InpSess3Start, InpSess3End);

   // News Filter
   g_nf.SetBlockMin(InpNewsBlockMin);
   g_nf.Refresh();

   // fix15: MTF Manager — Init เฉพาะเมื่อ InpUseMTF=true
   if(InpUseMTF)
      g_mtf.Init(&g_sm, &g_sc, InpHTFPeriod, InpLTFPeriod);

   // fix17+fix20: SC₁₀₀ Regime Gate + RSI confirm
   g_rf.Init(InpUseRegime, InpSC100Trend, InpSC100Revert, InpSC100Crash,
             InpSC100Bars, InpBeta1Bars,
             InpUseRSIConfirm, InpRSIPeriod, InpSMAPeriod, InpRSIOS, InpRSIOB);
   // fix19: auto-scale threshold ตาม TF ที่ใช้เทรดจริง
   if(InpUseRegime && InpAutoThreshold)
      g_rf.AutoThreshold(PERIOD_CURRENT);
   // fix18: per-symbol arrays (ต้องเรียกหลัง g_sm.Init)
   g_rf.InitSymbols(g_sm.Count());

   // Dashboard
   datetime _exp = INTERNAL_EXPIRY;
   int licDays = (int)((_exp-TimeCurrent())/86400);
   string expStr = TimeToString(_exp,TIME_DATE);
   g_db.Init(&g_sm,&g_tm,&g_cb,&g_tf,&g_nf,licDays,&g_rf);

   // EA ready + timer (ใน backtest ไม่ต้องใช้ timer — ประหยัด resource)
   g_ready = true;
   if(!MQLInfoInteger(MQL_TESTER))
      EventSetMillisecondTimer(1000);

   string gateStr = StringFormat("Trend=%s Sweep=%s CHoCH=%s",
                                  InpRequireTrend?"ON":"OFF",
                                  InpRequireSweep?"ON":"OFF",
                                  InpStrictCHoCH?"ON":"OFF");
   string sessStr = StringFormat("Window %04d-%04d / %04d-%04d",
                   InpSess1Start,InpSess1End,InpSess2Start,InpSess2End);
   string mtfStr  = InpUseMTF ?
      StringFormat("MTF ON HTF=%s LTF=%s", EnumToString(InpHTFPeriod), EnumToString(InpLTFPeriod))
      : "MTF OFF (single-TF)";
   string rfStr = InpUseRegime ?
      StringFormat("SC100 ON thr=%.2f/%.2f/%.2f [%dsyms]", InpSC100Crash,InpSC100Trend,InpSC100Revert,g_sm.Count())
      : "SC100 OFF";
   string swingStr = (InpDailyLossLimit <= 0) ?
      StringFormat("SWING | InternalStop=%.1f%%", InpInternalDDStop) :
      StringFormat("NORMAL | DailyLimit=%.1f%% | InternalStop=%.1f%%", InpDailyLossLimit, InpInternalDDStop);
   string rsiStr = InpUseRSIConfirm ?
      StringFormat("RSI%d/SMA%d OS=%.0f OB=%.0f", InpRSIPeriod, InpSMAPeriod, InpRSIOS, InpRSIOB) : "RSI_OFF";
   string bosStr  = InpUseBOSRetest ? "BOS-Retest=ON" : "BOS-Retest=OFF";
   string sweepStr= InpRequireSweep ?
      StringFormat("Sweep=ON lb=%d", InpSweepLB) : "Sweep=OFF";

   // fix25: TF recommendation — NinjaThai ใช้ M1 เป็น primary entry TF
   ENUM_TIMEFRAMES curTF = PERIOD_CURRENT;
   if(curTF != PERIOD_M1) {
      string tfName = EnumToString(curTF);
      PrintFormat("[SMC] ⚠️ TF=%s — NinjaThai Entry Model ใช้ M1 (M1 CHoCH+FVG)", tfName);
      if(curTF == PERIOD_H1 || curTF == PERIOD_H4)
         Print("[SMC] ⚠️ H1/H4: Session windows (30-60 min) ไม่ align กับ H1 bars → ใช้ M1 หรือ M5");
   }

   // fix25: News filter warning ใน backtest — MT5 Calendar ไม่ทำงานใน tester
   if(MQLInfoInteger(MQL_TESTER) && InpNewsBlockMin > 0)
      PrintFormat("[SMC] ⚠️ Backtest: InpNewsBlockMin=%d — MT5 Calendar ไม่ทำงานใน tester อาจ block ทุก symbol → ลอง InpNewsBlockMin=0",
                  InpNewsBlockMin);

   PrintFormat("[SMC v3.0 fix25] Init OK | %d syms | Acct:%I64d | Exp:%s (%dd) | Gates:[%s] | %s | %s | Sess:[%s] | %s | %s | %s | %s | %s",
               g_sm.Count(), AccountInfoInteger(ACCOUNT_LOGIN),
               expStr, licDays, gateStr, bosStr, sweepStr, sessStr, mtfStr, rfStr, swingStr, rsiStr);
   ReportOpenPositions();
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   EventKillTimer();
   if(InpUseMTF) g_mtf.Deinit();
   g_db.Destroy();
   g_sm.Deinit();
   g_tm.Deinit();
}

//+------------------------------------------------------------------+
void OnTick() {
   if(!g_ready) return;
   datetime curBar = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(curBar == g_lastBar) return;
   g_lastBar = curBar;
   OnNewBar();
}

//+------------------------------------------------------------------+
void OnTimer() {
   if(!g_ready) return;
   if(MQLInfoInteger(MQL_TESTER)) return;  // ไม่ redraw ใน backtest
   g_db.Redraw();
}

//+------------------------------------------------------------------+
void OnNewBar() {
   g_tm.MonitorAll();
   g_tm.TrailAll();

   g_cb.Check();
   if(g_cb.IsTripped()) {
      Print("[EA] Circuit breaker tripped — skip entry");
      if(!MQLInfoInteger(MQL_TESTER)) g_db.Redraw();
      return;
   }

   if(!g_tf.IsAllowed()) {
      s_cntSession++;   // [DIAG]
      if(!MQLInfoInteger(MQL_TESTER)) g_db.Redraw();
      return;
   }

   g_nf.Refresh();
   ScanAllSymbols();
   if(!MQLInfoInteger(MQL_TESTER)) g_db.Redraw();
}

//--- [DIAG] counters reset daily
static int s_diagBars=0, s_cntSession=0, s_cntActive=0,
           s_cntCool=0, s_cntNews=0, s_cntScan=0, s_cntRegime=0,
           s_cntCalcFail=0, s_cntEntry=0;   // fix24: s_cntNews
static datetime s_diagDay=0;

void DiagReset() {
   MqlDateTime dt; TimeToStruct(TimeCurrent(),dt);
   datetime today = StringToTime(StringFormat("%04d.%02d.%02d",dt.year,dt.mon,dt.day));
   if(today==s_diagDay) return;
   if(s_diagDay!=0) {
      PrintFormat("[DIAG] %s sess=%d active=%d cool=%d news=%d scan_fail=%d regime=%d calcFail=%d entries=%d",
                  TimeToString(s_diagDay,TIME_DATE),
                  s_cntSession,s_cntActive,s_cntCool,s_cntNews,s_cntScan,s_cntRegime,s_cntCalcFail,s_cntEntry);
      // fix22+fix23: scanner breakdown ครบทุก path
      PrintFormat("[DIAG-SCAN] %s data=%d swing=%d bos=%d wm=%d gate=%d ac=%d fvg=%d zone=%d ob=%d | bos_retest_ok=%d",
                  TimeToString(s_diagDay,TIME_DATE),
                  g_sc.m_diagFailData,  g_sc.m_diagFailSwing, g_sc.m_diagFailBOS,
                  g_sc.m_diagFailWM,    g_sc.m_diagFailGate,  g_sc.m_diagFailAC,
                  g_sc.m_diagFailFVG,   g_sc.m_diagFailZone,  g_sc.m_diagFailOB,
                  g_sc.m_diagBOSRetestOK);
      g_sc.ResetDiag();
   }
   s_diagDay=today; s_cntSession=0; s_cntActive=0; s_cntCool=0;
   s_cntNews=0; s_cntScan=0; s_cntRegime=0; s_cntCalcFail=0; s_cntEntry=0;
}

//+------------------------------------------------------------------+
void ScanAllSymbols() {
   DiagReset();

   for(int si=0; si<g_sm.Count(); si++) {
      string sym = g_sm.GetSymbol(si);

      if(g_tm.IsActive(si))               { s_cntActive++; continue; }
      if(g_tm.IsCooldown(si,InpCooldownBars)) { s_cntCool++; continue; }

      if(g_nf.IsBlocked(sym)) {
         s_cntNews++;  // fix24: news block counter
         g_jn.Log(SMCEVT_NEWS, sym, "Blocked by news", 0);
         continue;
      }

      //--- fix15: MTF gate
      if(InpUseMTF) {
         g_mtf.RefreshHTF(si, sym);
         if(!g_mtf.IsHTFReady(si)) continue;
         double midPrice = (iHigh(sym,InpLTFPeriod,1) + iLow(sym,InpLTFPeriod,1)) * 0.5;
         if(!g_mtf.IsInHTFZone(si, midPrice)) continue;
      }

      //--- fix18: SC₁₀₀ Regime Gate
      g_rf.Update(si, sym);

      //--- LTF Scan
      ENUM_TIMEFRAMES scanTF = InpUseMTF ? InpLTFPeriod : PERIOD_CURRENT;
      ZoneResult zone;
      if(!g_sc.Scan(sym, zone, scanTF)) { s_cntScan++; continue; }

      if(InpUseMTF && !g_mtf.DirectionMatch(si, zone.isBull)) continue;

      //--- fix18+fix20: Regime gate + RSI confirm
      if(!g_rf.IsAllowed(si, zone.isBull, sym, scanTF)) {
         s_cntRegime++;
         g_jn.Log(SMCEVT_NEWS, sym,
                  StringFormat("Regime=%s SC100=%.3f b1=%.5f — skip",
                               g_rf.RegimeStr(si), g_rf.GetSC100(si), g_rf.GetBeta1(si)), 0);
         continue;
      }

      double atr = g_sm.GetATR(si);
      if(atr<=0) {
         double h=iHigh(sym,scanTF,1);
         double l=iLow(sym,scanTF,1);
         atr = (h-l>0)?h-l:SymbolInfoDouble(sym,SYMBOL_POINT)*50;
      }

      double entryPx=0, initSL=0, oneR=0, tp=0;
      bool   isBull=false;
      if(!CSMCScanner::CalcEntry(sym,zone,atr,entryPx,initSL,oneR,tp,isBull,InpSimTP_R,scanTF)) {
         s_cntCalcFail++;   // fix23: CalcEntry failure counter
         continue;
      }

      s_cntEntry++;
      g_tm.OpenPosition(si, isBull, entryPx, initSL, oneR,
                        zone.fvgHi, zone.fvgLo,
                        zone.zHi,   zone.zLo,
                        zone.tZoneFrom);
   }
}

//--- [DIAG] พิมพ์สรุป ตอน OnTester เสร็จ
void PrintDiagSummary() {
   PrintFormat("[DIAG-FINAL] sess=%d active=%d cool=%d news=%d scan_fail=%d regime=%d calcFail=%d entries=%d",
               s_cntSession,s_cntActive,s_cntCool,s_cntNews,s_cntScan,s_cntRegime,s_cntCalcFail,s_cntEntry);
   // fix22+fix23: scanner breakdown สรุป
   PrintFormat("[DIAG-SCAN-FINAL] data=%d swing=%d bos=%d wm=%d gate=%d ac=%d fvg=%d zone=%d ob=%d | bos_retest_ok=%d",
               g_sc.m_diagFailData,  g_sc.m_diagFailSwing, g_sc.m_diagFailBOS,
               g_sc.m_diagFailWM,    g_sc.m_diagFailGate,  g_sc.m_diagFailAC,
               g_sc.m_diagFailFVG,   g_sc.m_diagFailZone,  g_sc.m_diagFailOB,
               g_sc.m_diagBOSRetestOK);
}

//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long&lp,const double&dp,const string&sp){}
double OnTester() { PrintDiagSummary(); return TesterStatistics(STAT_PROFIT_FACTOR); }
//+------------------------------------------------------------------+
