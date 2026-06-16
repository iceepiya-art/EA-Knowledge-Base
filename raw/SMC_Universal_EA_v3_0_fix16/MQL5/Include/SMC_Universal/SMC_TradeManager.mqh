//+------------------------------------------------------------------+
//| SMC_TradeManager.mqh — SMC Universal EA v3.0                    |
//| fix14:                                                           |
//|   - Spread check ใช้ m_maxSpread (Input) แทน MAX_SPREAD_DEF    |
//|   - Cooldown: preserve lastTradeBar หลัง trade ปิด             |
//|   - avgWinRR / avgLossRR คำนวณจาก sumWinRR/sumLossRR ที่ถูกต้อง |
//+------------------------------------------------------------------+
#ifndef SMC_TRADEMANAGER_MQH
#define SMC_TRADEMANAGER_MQH

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_SymbolManager.mqh>
#include <SMC_Universal\SMC_MoneyManager.mqh>
#include <SMC_Universal\SMC_Journal.mqh>
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

class CSMCTradeManager {
private:
   CSymbolManager*   m_sm;
   CSMCMoneyManager* m_mm;
   CSMCJournal*      m_jn;

   CTrade        m_trade;
   CPositionInfo m_pos;

   TradeRecord   m_rec[];

   double  m_trailStart;
   double  m_trailStep;
   double  m_simTP;
   int     m_maxPos;
   bool    m_showVisual;
   double  m_maxSpread;   // FIX14: ใช้ค่า Input จริง

   string  ObjPfx(const string sym) { return "SMC3_"+sym+"_"; }
   void    ClearObjs(const string sym) { ObjectsDeleteAll(0, ObjPfx(sym)); }

   void DrawRect(const string name, datetime t1, double hi, datetime t2, double lo, color c) {
      ObjectDelete(0,name);
      ObjectCreate(0,name,OBJ_RECTANGLE,0,t1,hi,t2,lo);
      ObjectSetInteger(0,name,OBJPROP_COLOR,c);
      ObjectSetInteger(0,name,OBJPROP_FILL,true);
      ObjectSetInteger(0,name,OBJPROP_BACK,true);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   }
   void DrawLine(const string name, datetime t1, datetime t2, double p, color c) {
      ObjectDelete(0,name);
      ObjectCreate(0,name,OBJ_TREND,0,t1,p,t2,p);
      ObjectSetInteger(0,name,OBJPROP_COLOR,c);
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DOT);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
      ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   }
   void DrawText(const string name, datetime t, double p, string txt, color c, bool up=true) {
      ObjectDelete(0,name);
      ObjectCreate(0,name,OBJ_TEXT,0,t,p);
      ObjectSetString(0,name,OBJPROP_TEXT,txt);
      ObjectSetInteger(0,name,OBJPROP_COLOR,c);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,9);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,up?ANCHOR_LEFT_LOWER:ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   }

   void DrawSignal(int si, const string sym, double zHi, double zLo,
                   double fHi, double fLo, datetime tFrom, datetime tNow, bool isBull) {
      if(!m_showVisual) return;
      string pfx = ObjPfx(sym);
      DrawRect(pfx+"ZONE", tFrom, zHi, tNow, zLo, C'15,50,25');
      DrawText(pfx+"ZONE_LBL", tFrom, zHi, "Zone 50-62%", C'80,200,80', true);
      if(fHi>0&&fLo>0) {
         color fc = isBull ? C'20,80,40' : C'80,20,20';
         DrawRect(pfx+"FVG", tFrom, fHi, tNow, fLo, fc);
         DrawText(pfx+"FVG_LBL", tFrom, isBull?fLo:fHi, "FVG★", clrYellow, !isBull);
      }
   }

   void DrawEntry(int si, const string sym, datetime tE, double ep, double sl, double tp, bool isBull) {
      if(!m_showVisual) return;
      string pfx = ObjPfx(sym);
      datetime tEnd = iTime(sym, PERIOD_CURRENT, 0);
      DrawText(pfx+"ENTRY",     tE, ep, "★", clrYellow, isBull);
      DrawText(pfx+"ENTRY_LBL", tE, isBull?ep-_Point*5:ep+_Point*5, isBull?"BUY":"SELL", clrYellow, isBull);
      DrawLine(pfx+"SL", tE, tEnd, sl, clrTomato);
      DrawLine(pfx+"TP", tE, tEnd, tp, clrLimeGreen);
      DrawText(pfx+"SL_LBL", tE, sl, "SL", clrTomato,   isBull);
      DrawText(pfx+"TP_LBL", tE, tp, "TP", clrLimeGreen, !isBull);
   }

   void UpdateSLLine(int si, const string sym, double newSL) {
      if(!m_showVisual) return;
      string pfx = ObjPfx(sym);
      datetime tEnd = iTime(sym, PERIOD_CURRENT, 0);
      DrawLine(pfx+"SL", m_rec[si].entryTime, tEnd, newSL, clrTomato);
   }

   bool HasPos(const string sym) {
      for(int i=0; i<PositionsTotal(); i++) {
         if(!m_pos.SelectByIndex(i)) continue;
         if(m_pos.Symbol()==sym && m_pos.Magic()==EA_MAGIC) return true;
      }
      return false;
   }

   int TotalActive() {
      int cnt=0;
      if(m_sm==NULL) return 0;
      for(int i=0; i<m_sm.Count(); i++)
         if(m_rec[i].active && m_rec[i].state!=TS_CLOSED) cnt++;
      return cnt;
   }

   void UpdateStats(int si) {
      string sym = m_rec[si].symbol;
      if(!HistorySelect(TimeCurrent()-86400*7, TimeCurrent())) return;
      int total = HistoryDealsTotal();
      for(int i=total-1; i>=0; i--) {
         ulong tk = HistoryDealGetTicket(i);
         if(HistoryDealGetString(tk,DEAL_SYMBOL)!=sym) continue;
         if((ulong)HistoryDealGetInteger(tk,DEAL_MAGIC)!=EA_MAGIC) continue;
         int type=(int)HistoryDealGetInteger(tk,DEAL_TYPE);
         if(type!=DEAL_TYPE_BUY&&type!=DEAL_TYPE_SELL) continue;
         double pnl    = HistoryDealGetDouble(tk,DEAL_PROFIT);
         double exitPx = HistoryDealGetDouble(tk,DEAL_PRICE);
         double pipSz  = (m_sm!=NULL) ? m_sm.GetPipSize(sym) : _Point;
         double pips   = m_rec[si].isBull ?
                         (exitPx-m_rec[si].entryPx)/pipSz :
                         (m_rec[si].entryPx-exitPx)/pipSz;
         double actualRR = (m_rec[si].oneR>0) ?
                           (m_rec[si].isBull ? (exitPx-m_rec[si].entryPx) : (m_rec[si].entryPx-exitPx))
                           / m_rec[si].oneR : 0.0;

         m_rec[si].totalPips += pips;
         m_rec[si].totalRR   += actualRR;
         m_rec[si].totalPnL  += pnl;

         if(pnl > 0) {
            m_rec[si].wins++;
            m_rec[si].sumWinRR += actualRR;   // FIX14
            if(actualRR > m_rec[si].maxWinRR) m_rec[si].maxWinRR = actualRR;
         } else {
            m_rec[si].losses++;
            m_rec[si].sumLossRR += actualRR;  // FIX14
            if(actualRR < m_rec[si].maxLossRR) m_rec[si].maxLossRR = actualRR;
         }
         if(m_jn!=NULL)
            m_jn.Log(SMCEVT_CLOSE, sym,
               StringFormat("%s RR=%.2f Pips=%.1f PnL=%.2f",
                            pnl>0?"WIN":"LOSS", actualRR, pips, pnl), pnl);
         break;
      }
   }

public:
   CSMCTradeManager() {
      m_sm=NULL; m_mm=NULL; m_jn=NULL;
      m_trailStart=TRAIL_START_DEF; m_trailStep=TRAIL_STEP_DEF;
      m_simTP=SIM_TP_DEF; m_maxPos=MAX_POS_TOTAL;
      m_showVisual=true; m_maxSpread=MAX_SPREAD_DEF;
   }

   void SetManagers(CSymbolManager* sm, CSMCMoneyManager* mm, CSMCJournal* jn) {
      m_sm=sm; m_mm=mm; m_jn=jn;
   }

   //--- fix14: เพิ่ม maxSpreadPts parameter
   void SetParams(double trailStart, double trailStep, double simTP,
                  int maxPos, bool showVisual, double maxSpreadPts=MAX_SPREAD_DEF) {
      m_trailStart=trailStart; m_trailStep=trailStep;
      m_simTP=simTP; m_maxPos=maxPos; m_showVisual=showVisual;
      m_maxSpread=(maxSpreadPts>0)?maxSpreadPts:MAX_SPREAD_DEF;
   }

   void Init() {
      if(m_sm==NULL) return;
      int n = m_sm.Count();
      ArrayResize(m_rec, n);
      for(int i=0; i<n; i++) {
         ZeroMemory(m_rec[i]);
         m_rec[i].symbol = m_sm.GetSymbol(i);
      }
      m_trade.SetExpertMagicNumber(EA_MAGIC);
      m_trade.SetDeviationInPoints(20);
      m_trade.SetTypeFilling(ORDER_FILLING_FOK);
      Print("[TM] Init — ", n, " symbols | MaxSpread=", m_maxSpread, "pts");
   }

   void Deinit() {
      if(m_sm==NULL) return;
      for(int i=0; i<m_sm.Count(); i++) ClearObjs(m_rec[i].symbol);
   }

   bool OpenPosition(int si, bool isBull, double entryPx, double initSL,
                     double oneR, double fvgHi, double fvgLo,
                     double zHi, double zLo, datetime tZoneFrom) {
      if(si<0||si>=m_sm.Count()) return false;
      string sym = m_rec[si].symbol;

      if(TotalActive() >= m_maxPos) {
         if(m_jn!=NULL) m_jn.Log(SMCEVT_SKIP,sym,"Max positions reached",0);
         return false;
      }

      double tp  = isBull ? entryPx+oneR*m_simTP : entryPx-oneR*m_simTP;
      double lot = (m_mm!=NULL) ? m_mm.CalcLot(sym,entryPx,initSL) : 0.0;
      if(lot<=0) return false;

      //--- FIX14: ใช้ m_maxSpread (จาก Input) แทน MAX_SPREAD_DEF
      double spreadPts = (double)SymbolInfoInteger(sym,SYMBOL_SPREAD);
      if(spreadPts > m_maxSpread) {
         if(m_jn!=NULL) m_jn.Log(SMCEVT_SKIP,sym,
            StringFormat("Spread %.0f > %.0f pts",spreadPts,m_maxSpread),0);
         return false;
      }

      int digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      bool ok = isBull ?
         m_trade.Buy (lot,sym,0,NormalizeDouble(initSL,digits),NormalizeDouble(tp,digits),"SMC_v3") :
         m_trade.Sell(lot,sym,0,NormalizeDouble(initSL,digits),NormalizeDouble(tp,digits),"SMC_v3");
      if(!ok) {
         PrintFormat("[TM] %s open failed: %s", sym, m_trade.ResultRetcodeDescription());
         return false;
      }

      datetime tNow = iTime(sym,PERIOD_CURRENT,0);
      m_rec[si].active      = true;
      m_rec[si].isBull      = isBull;
      m_rec[si].state       = TS_OPEN;
      m_rec[si].entryPx     = entryPx;
      m_rec[si].slPx        = initSL;
      m_rec[si].tpPx        = tp;
      m_rec[si].oneR        = oneR;
      m_rec[si].nextTrailAt = m_trailStart;
      m_rec[si].entryTime   = tNow;
      m_rec[si].fvgHi       = fvgHi;
      m_rec[si].fvgLo       = fvgLo;
      m_rec[si].zoneHi      = zHi;
      m_rec[si].zoneLo      = zLo;
      m_rec[si].lastTradeBar= iBars(sym,PERIOD_CURRENT);

      DrawSignal(si,sym,zHi,zLo,fvgHi,fvgLo,tZoneFrom,tNow,isBull);
      DrawEntry(si,sym,tNow,entryPx,initSL,tp,isBull);

      PrintFormat("[TM] ✅ %s %s | Entry=%.5f SL=%.5f TP=%.5f 1R=%.5f Lot=%.2f",
                  sym, isBull?"BUY":"SELL", entryPx,initSL,tp,oneR,lot);
      if(m_jn!=NULL)
         m_jn.Log(SMCEVT_OPEN,sym,
            StringFormat("%s Entry=%.5f SL=%.5f 1R=%.5f Lot=%.2f",
                         isBull?"BUY":"SELL",entryPx,initSL,oneR,lot),0.0);
      return true;
   }

   void TrailAll() {
      if(m_sm==NULL) return;
      for(int si=0; si<m_sm.Count(); si++) {
         if(!m_rec[si].active) continue;
         if(m_rec[si].state==TS_CLOSED) continue;
         if(!HasPos(m_rec[si].symbol)) {
            UpdateStats(si);
            ClearObjs(m_rec[si].symbol);
            //--- FIX14: เก็บ lastTradeBar ไว้ก่อน ZeroMemory (cooldown ยังใช้งานได้)
            int savedBar = m_rec[si].lastTradeBar;
            double sumW  = m_rec[si].sumWinRR;
            double sumL  = m_rec[si].sumLossRR;
            int wins     = m_rec[si].wins;
            int losses   = m_rec[si].losses;
            double tPips = m_rec[si].totalPips;
            double tRR   = m_rec[si].totalRR;
            double tPnL  = m_rec[si].totalPnL;
            double mWR   = m_rec[si].maxWinRR;
            double mLR   = m_rec[si].maxLossRR;
            ZeroMemory(m_rec[si]);
            m_rec[si].symbol       = m_sm.GetSymbol(si);
            m_rec[si].lastTradeBar = savedBar;  // FIX14: restore cooldown
            m_rec[si].sumWinRR     = sumW;
            m_rec[si].sumLossRR    = sumL;
            m_rec[si].wins         = wins;
            m_rec[si].losses       = losses;
            m_rec[si].totalPips    = tPips;
            m_rec[si].totalRR      = tRR;
            m_rec[si].totalPnL     = tPnL;
            m_rec[si].maxWinRR     = mWR;
            m_rec[si].maxLossRR    = mLR;
            continue;
         }
         Trail(si);
      }
   }

   void Trail(int si) {
      string sym  = m_rec[si].symbol;
      bool isBull = m_rec[si].isBull;
      double price= isBull ? SymbolInfoDouble(sym,SYMBOL_BID)
                           : SymbolInfoDouble(sym,SYMBOL_ASK);
      if(m_rec[si].oneR<=0) return;

      double curRR = MathAbs(price-m_rec[si].entryPx)/m_rec[si].oneR;
      while(curRR >= m_rec[si].nextTrailAt) {
         double lockRR = m_rec[si].nextTrailAt - m_trailStep;
         double newSL  = isBull ? m_rec[si].entryPx+lockRR*m_rec[si].oneR
                                : m_rec[si].entryPx-lockRR*m_rec[si].oneR;
         newSL = NormalizeDouble(newSL,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS));

         bool better = isBull ? (newSL>m_rec[si].slPx) : (newSL<m_rec[si].slPx);
         if(better) {
            for(int i=0; i<PositionsTotal(); i++) {
               if(!m_pos.SelectByIndex(i)) continue;
               if(m_pos.Symbol()!=sym||m_pos.Magic()!=EA_MAGIC) continue;
               if(m_trade.PositionModify(sym,newSL,m_pos.TakeProfit())) {
                  m_rec[si].slPx = newSL;
                  m_rec[si].state = TS_TRAIL;
                  UpdateSLLine(si,sym,newSL);
                  PrintFormat("[TM] 🔒 %s Trail→%.5f (lock %.1fR)",sym,newSL,lockRR);
                  if(m_jn!=NULL)
                     m_jn.Log(SMCEVT_TRAIL,sym,
                        StringFormat("SL=%.5f (%.1fR)",newSL,lockRR),0.0);
               }
            }
         }
         m_rec[si].nextTrailAt += m_trailStep;
      }
   }

   void MonitorAll() {
      if(m_sm==NULL) return;
      for(int si=0; si<m_sm.Count(); si++) {
         if(!m_rec[si].active) continue;
         if(m_rec[si].state==TS_CLOSED) continue;
         if(!HasPos(m_rec[si].symbol)) {
            UpdateStats(si);
            ClearObjs(m_rec[si].symbol);
            m_rec[si].active = false;
            m_rec[si].state  = TS_CLOSED;
         }
      }
   }

   //--- FIX14: avgWinRR / avgLossRR ใช้ sumWinRR/sumLossRR จริง
   TradeStats GetGlobalStats() {
      TradeStats s; ZeroMemory(s);
      double sumWinRR=0, sumLossRR=0;
      if(m_sm==NULL) return s;
      for(int i=0; i<m_sm.Count(); i++) {
         s.wins      += m_rec[i].wins;
         s.losses    += m_rec[i].losses;
         s.totalPips += m_rec[i].totalPips;
         s.totalPnL  += m_rec[i].totalPnL;
         s.totalRR   += m_rec[i].totalRR;
         sumWinRR    += m_rec[i].sumWinRR;   // FIX14
         sumLossRR   += m_rec[i].sumLossRR;  // FIX14
      }
      s.totalTrades = s.wins + s.losses;
      s.winRate     = s.totalTrades>0 ? (double)s.wins/s.totalTrades*100.0 : 0;
      s.avgRR       = s.totalTrades>0 ? s.totalRR/s.totalTrades : 0;
      s.avgWinRR    = s.wins>0   ? sumWinRR/s.wins    : 0;  // FIX14
      s.avgLossRR   = s.losses>0 ? sumLossRR/s.losses : 0;  // FIX14
      double grossWin  = (sumWinRR>0)  ?  sumWinRR  : 0;
      double grossLoss = (sumLossRR<0) ? -sumLossRR : 0;
      s.profitFactor = grossLoss>0 ? grossWin/grossLoss : (grossWin>0?999:0);
      return s;
   }

   TradeStats GetSymbolStats(int si) {
      TradeStats s; ZeroMemory(s);
      if(si<0||si>=ArraySize(m_rec)) return s;
      s.wins        = m_rec[si].wins;
      s.losses      = m_rec[si].losses;
      s.totalTrades = s.wins+s.losses;
      s.winRate     = s.totalTrades>0 ? (double)s.wins/s.totalTrades*100.0 : 0;
      s.totalRR     = m_rec[si].totalRR;
      s.avgRR       = s.totalTrades>0 ? s.totalRR/s.totalTrades : 0;
      s.avgWinRR    = s.wins>0   ? m_rec[si].sumWinRR/s.wins    : 0;  // FIX14
      s.avgLossRR   = s.losses>0 ? m_rec[si].sumLossRR/s.losses : 0;  // FIX14
      s.totalPips   = m_rec[si].totalPips;
      s.totalPnL    = m_rec[si].totalPnL;
      return s;
   }

   bool         IsActive(int si)  const { return (si>=0&&si<ArraySize(m_rec))?m_rec[si].active:false; }
   TradeRecord  GetRecord(int si) const { return m_rec[si]; }
   int          TotalOpen()             { return TotalActive(); }

   bool IsCooldown(int si, int cooldownBars) {
      // FIX14: ตรวจ lastTradeBar โดยไม่ขึ้นกับ active (cooldown ทำงานแม้หลัง trade ปิด)
      if(m_rec[si].lastTradeBar<=0) return false;
      int cur = iBars(m_rec[si].symbol, PERIOD_CURRENT);
      return (cur - m_rec[si].lastTradeBar) < cooldownBars;
   }
};

#endif
