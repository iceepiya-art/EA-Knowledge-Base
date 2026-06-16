//+------------------------------------------------------------------+
//| SMC_Dashboard.mqh — SMC Universal EA v3.0                       |
//| Native MT5 OBJ_LABEL dashboard — multi-symbol status            |
//| fix18: แสดง Regime (TREND/WEAK/REVERT/CRASH) ต่อ symbol         |
//+------------------------------------------------------------------+
#ifndef SMC_DASHBOARD_MQH
#define SMC_DASHBOARD_MQH

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_SymbolManager.mqh>
#include <SMC_Universal\SMC_TradeManager.mqh>
#include <SMC_Universal\SMC_CircuitBreaker.mqh>
#include <SMC_Universal\SMC_TimeFilter.mqh>
#include <SMC_Universal\SMC_NewsFilter.mqh>
#include <SMC_Universal\SMC_RegimeFilter.mqh>

#define DB_PFX "SMCDB_"

class CSMCDashboard {
private:
   CSymbolManager*    m_sm;
   CSMCTradeManager*  m_tm;
   CSMCCircuitBreaker* m_cb;
   CSMCTimeFilter*    m_tf;
   CSMCNewsFilter*    m_nf;
   CSMCRegimeFilter*  m_rf;    // fix18: Regime display

   int   m_x, m_y, m_lh, m_fs;
   int   m_daysLeft;

   void ObjDel(const string n) { ObjectDelete(0,n); }

   void BG(const string n, int x, int y, int w, int h, color bg) {
      ObjDel(n);
      ObjectCreate(0,n,OBJ_RECTANGLE_LABEL,0,0,0);
      ObjectSetInteger(0,n,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,n,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,n,OBJPROP_XSIZE,w);
      ObjectSetInteger(0,n,OBJPROP_YSIZE,h);
      ObjectSetInteger(0,n,OBJPROP_BGCOLOR,bg);
      ObjectSetInteger(0,n,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,n,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,n,OBJPROP_BACK,false);
      ObjectSetInteger(0,n,OBJPROP_SELECTABLE,false);
   }

   void Lbl(const string n, int x, int y, const string txt, color c, int fs=9) {
      ObjDel(n);
      ObjectCreate(0,n,OBJ_LABEL,0,0,0);
      ObjectSetString(0,n,OBJPROP_TEXT,txt);
      ObjectSetInteger(0,n,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,n,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,n,OBJPROP_COLOR,c);
      ObjectSetInteger(0,n,OBJPROP_FONTSIZE,fs);
      ObjectSetInteger(0,n,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,n,OBJPROP_SELECTABLE,false);
   }

public:
   CSMCDashboard() { m_sm=NULL; m_tm=NULL; m_cb=NULL; m_tf=NULL; m_nf=NULL; m_rf=NULL;
                     m_x=10; m_y=28; m_lh=15; m_fs=9; m_daysLeft=99999; }

   void Init(CSymbolManager* sm, CSMCTradeManager* tm,
             CSMCCircuitBreaker* cb, CSMCTimeFilter* tf, CSMCNewsFilter* nf,
             int daysLeft=99999, CSMCRegimeFilter* rf=NULL) {
      m_sm=sm; m_tm=tm; m_cb=cb; m_tf=tf; m_nf=nf; m_rf=rf;
      m_daysLeft=daysLeft;
   }

   void Destroy() { ObjectsDeleteAll(0, DB_PFX); }

   void Redraw() {
      if(m_sm==NULL||m_tm==NULL) return;
      TradeStats gs = m_tm.GetGlobalStats();

      int syms = m_sm.Count();
      // rows = title(1) + challenge_pnl(1) + challenge_dd(1) + session(1) + positions(1) + divider(1)
      //      + stats_header(1) + stats_rows(4) + divider(1) + sym rows + expiry(1)
      int statRows = 4;
      int rows  = 7 + statRows + 1 + syms + 1;
      int bgW   = 280;
      int bgH   = rows*m_lh + 16;
      int x     = m_x, y = m_y;

      BG(DB_PFX+"BG", x-4, y-4, bgW, bgH, C'13,15,26');
      int row=0;

      // ── Title
      Lbl(DB_PFX+"T0", x, y+row*m_lh,
          StringFormat("SMC Universal EA v3.0  [%d sym]", syms),
          clrWhite, m_fs+1); row++;

      // ── Challenge Progress
      if(m_cb != NULL) {
         double profPct  = m_cb.ProfitPct();
         double ddPct    = m_cb.TotalDDPct();
         double tgt      = m_cb.ProfitTarget();
         double brokerDD = m_cb.TotalBrokerLimit();
         double intStop  = m_cb.InternalDDStop();
         bool   cbTrip   = m_cb.IsTripped();
         string modeStr  = m_cb.IsSwingMode() ? "SWING" : "NORM";

         // P&L progress line
         color profC = (profPct >= tgt) ? clrGold :
                       (profPct >= 0)   ? clrLimeGreen : clrTomato;
         string profBar = "";
         int barFill = (int)(MathAbs(profPct) / tgt * 10);
         for(int b=0; b<MathMin(barFill,10); b++) profBar += (profPct>=0 ? "█" : "▒");
         Lbl(DB_PFX+"T1A", x, y+row*m_lh,
             StringFormat("P&L %s%.1f%% / +%.0f%%  [%s]  %s",
                          profPct>=0?"+":"", profPct, tgt, modeStr, profBar),
             profC, m_fs); row++;

         // DD protection line
         color ddC = cbTrip ? clrTomato :
                     (ddPct >= intStop*0.8) ? clrOrange : C'50,55,70';
         string cbFlag = cbTrip ? " STOPPED" : "";
         Lbl(DB_PFX+"T1B", x, y+row*m_lh,
             StringFormat("DD -%s%.1f%%  int:%.0f%%  lmt:%.0f%%%s",
                          ddPct>0?"":"+", ddPct, intStop, brokerDD, cbFlag),
             ddC, m_fs); row++;
      } else { row += 2; }

      // ── Session / News
      string tfS = (m_tf!=NULL)?m_tf.StatusLabel():"TF:N/A";
      color  tfC = (m_tf!=NULL&&m_tf.IsAllowed())?clrLimeGreen:clrOrange;
      Lbl(DB_PFX+"T2", x, y+row*m_lh,
          StringFormat("Session:%s  News:%s", tfS,
          (m_nf!=NULL&&m_nf.IsAvailable())?"ON":"OFF"), tfC); row++;

      // ── Open positions
      int tot = m_tm.TotalOpen();
      Lbl(DB_PFX+"T3", x, y+row*m_lh,
          StringFormat("Open:%d/%d  Equity:%.2f",
                       tot, MAX_POS_TOTAL, AccountInfoDouble(ACCOUNT_EQUITY)),
          clrSilver); row++;

      // ══ STATS PANEL ════════════════════════════════════════
      Lbl(DB_PFX+"SD0", x, y+row*m_lh, "── STATS ──────────────────", C'40,44,60'); row++;

      // Trades | Winrate
      color wrC = gs.winRate>=50 ? clrLimeGreen : clrTomato;
      Lbl(DB_PFX+"SD1", x, y+row*m_lh,
          StringFormat("Trades:%d  W:%d  L:%d  WR:%.0f%%",
                       gs.totalTrades, gs.wins, gs.losses, gs.winRate),
          wrC); row++;

      // RR avg | Profit Factor
      color rrC = gs.avgRR>=0 ? clrLimeGreen : clrTomato;
      string pfStr = gs.profitFactor>=999 ? "∞" : DoubleToString(gs.profitFactor,2);
      Lbl(DB_PFX+"SD2", x, y+row*m_lh,
          StringFormat("AvgRR:%.2f  PF:%s  RR:%s%.2f",
                       gs.avgRR, pfStr,
                       gs.totalRR>=0?"+":"", gs.totalRR),
          rrC); row++;

      // PnL | Pips
      color pnlC = gs.totalPnL>=0 ? clrLimeGreen : clrTomato;
      Lbl(DB_PFX+"SD3", x, y+row*m_lh,
          StringFormat("PnL:%s%.2f  Pips:%s%.1f",
                       gs.totalPnL>=0?"+":"", gs.totalPnL,
                       gs.totalPips>=0?"+":"", gs.totalPips),
          pnlC); row++;

      // AvgWin | AvgLoss RR
      Lbl(DB_PFX+"SD4", x, y+row*m_lh,
          StringFormat("Win RR:+%.2f  Loss RR:%.2f",
                       gs.avgWinRR, gs.avgLossRR),
          C'160,160,160'); row++;

      // ══ SYMBOL LIST ════════════════════════════════════════
      Lbl(DB_PFX+"DIV", x, y+row*m_lh, "── SYMBOLS ────────────────", C'40,44,60'); row++;

      for(int si=0; si<syms; si++) {
         string sym  = m_sm.GetSymbol(si);
         bool   act  = m_tm.IsActive(si);
         string stateStr = "─";
         color  stateC   = C'50,55,70';

         if(act) {
            TradeRecord r  = m_tm.GetRecord(si);
            double bid     = SymbolInfoDouble(sym,SYMBOL_BID);
            double curRR   = (r.oneR>0)?MathAbs(bid-r.entryPx)/r.oneR:0;
            stateStr = StringFormat("%s %.1fR %s",
                          r.isBull?"▲":"▼", curRR,
                          (r.state==TS_TRAIL)?"TRL":"OPEN");
            stateC = r.isBull?clrLimeGreen:clrTomato;
         } else {
            // แสดง stats ย่อ per-symbol ถ้าไม่มี active position
            TradeStats ss = m_tm.GetSymbolStats(si);
            if(ss.totalTrades > 0) {
               stateStr = StringFormat("W%d/L%d WR%.0f%% RR%s%.1f",
                             ss.wins, ss.losses, ss.winRate,
                             ss.totalRR>=0?"+":"", ss.totalRR);
               stateC = ss.winRate>=50?C'80,160,80':C'160,80,80';
            }
         }

         bool blocked = (m_nf!=NULL)&&m_nf.IsBlocked(sym);

         // fix18: Regime badge
         string regStr = "";
         color  regC   = C'50,55,70';
         if(m_rf != NULL) {
            regStr = m_rf.RegimeStr(si);
            switch(m_rf.GetRegime(si)) {
               case REGIME_TRENDING:  regC = C'60,160,60';  break;
               case REGIME_REVERTING: regC = C'60,120,200'; break;
               case REGIME_CRASH:     regC = clrTomato;     break;
               case REGIME_WEAK:      regC = C'80,80,80';   break;
            }
         }

         Lbl(DB_PFX+"R"+IntegerToString(si), x+bgW-68, y+row*m_lh,
             regStr, regC, m_fs-1);
         Lbl(DB_PFX+"S"+IntegerToString(si), x, y+row*m_lh,
             StringFormat("%-8s %s%s", sym, stateStr, blocked?" 📰":""),
             stateC); row++;
      }

      // ── Expiry
      color expC = m_daysLeft<=7?clrTomato:C'40,44,60';
      Lbl(DB_PFX+"EXP", x+bgW-70, y+(rows-1)*m_lh,
          StringFormat("Exp %dd",m_daysLeft), expC, m_fs-1);

      ChartRedraw();
   }
};

#endif
