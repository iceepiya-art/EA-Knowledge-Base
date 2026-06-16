//+------------------------------------------------------------------+
//|                                Gold_Breakout_100Bar_Survivor.mq5 |
//|                                     Copyright 2026, Gemini AI    |
//+------------------------------------------------------------------+
// fix1: กัน Race Condition (cS>=1 / cB>=1 guard)
// fix2: Self-contained — ไม่ใช้ #include ใดเลย
// fix3: Tester-compatible (filling retry + debug log)
// fix4: Bypass security เมื่ออยู่ใน Strategy Tester
//       (FTMO-Demo บางบัญชี return ACCOUNT_TRADE_MODE_REAL → INIT_FAILED เดิม)
// fix5: เพิ่ม _Symbol filter ทุก loop (ป้องกัน cross-symbol magic collision)
//       fix dynLot → ใช้ tickVal/tickSize แทน hardcode /10 (รองรับทุก symbol)
//       fix GetStats → รวม POSITION_COMMISSION ใน floating P&L
//+------------------------------------------------------------------+
#property strict

// --- [SECURITY SETTINGS] ---
const bool     INTERNAL_LOCK_DEMO   = false;           // false = อนุญาต real account
const datetime INTERNAL_EXPIRY      = D'2126.12.31 23:59';
const long     INTERNAL_ACCOUNT_LOCK = 153186222;      // 0 = ไม่ล็อค | ใส่เลขพอร์ตเพื่อล็อค

//--- [INPUT SETTINGS] ---
input int    InpLookback           = 100;
input double InpRiskPercent        = 0.01;
input double InpMultEarly          = 1.6;
input double InpMultLate           = 1.35;
input double InpMaxLotLimit        = 100.0;
input double InpTargetUSD          = 1.0;
input double InpTrailingUSD        = 0.4;
input int    InpMaxTotalTrades     = 6;
input double InpMaxDrawdownPercent = 25.0;
input int    InpMagic              = 888999;
input bool   InpDebugLog           = true;  // เปิด/ปิด debug print

double   globalHighPrice = 0, globalLowPrice = 0, maxSeenProfit = 0;
datetime lastTradeTime   = 0;

//+------------------------------------------------------------------+
//| Native Trade Helpers                                             |
//+------------------------------------------------------------------+

// ลอง 3 filling modes: IOC → FOK → RETURN
// ป้องกัน broker/tester ที่รองรับแค่บางโหมด
bool TradeMarket(ENUM_ORDER_TYPE type, double lot, string comment) {
   ENUM_ORDER_TYPE_FILLING fills[3] = {ORDER_FILLING_IOC, ORDER_FILLING_FOK, ORDER_FILLING_RETURN};
   MqlTradeRequest req = {};
   MqlTradeResult  res = {};
   req.action    = TRADE_ACTION_DEAL;
   req.symbol    = _Symbol;
   req.volume    = lot;
   req.type      = type;
   req.deviation = 30;
   req.magic     = InpMagic;
   req.comment   = comment;

   for(int fi = 0; fi < 3; fi++) {
      req.type_filling = fills[fi];
      req.price = (type == ORDER_TYPE_BUY)
                  ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                  : SymbolInfoDouble(_Symbol, SYMBOL_BID);
      res.retcode = 0;
      if(OrderSend(req, res) &&
         (res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED))
         return true;
   }
   Print("[ERR] TradeMarket FAILED retcode=", res.retcode,
         " type=", EnumToString(type), " lot=", lot, " | ", comment);
   return false;
}

bool TradePending(ENUM_ORDER_TYPE type, double lot, double price, string comment) {
   ENUM_ORDER_TYPE_FILLING fills[3] = {ORDER_FILLING_IOC, ORDER_FILLING_FOK, ORDER_FILLING_RETURN};
   MqlTradeRequest req = {};
   MqlTradeResult  res = {};
   req.action    = TRADE_ACTION_PENDING;
   req.symbol    = _Symbol;
   req.volume    = lot;
   req.type      = type;
   req.price     = price;
   req.magic     = InpMagic;
   req.comment   = comment;
   req.type_time = ORDER_TIME_GTC;

   for(int fi = 0; fi < 3; fi++) {
      req.type_filling = fills[fi];
      res.retcode = 0;
      if(OrderSend(req, res) &&
         (res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED))
         return true;
   }
   Print("[ERR] TradePending FAILED retcode=", res.retcode,
         " type=", EnumToString(type), " price=", price, " | ", comment);
   return false;
}

bool ClosePosition(ulong ticket) {
   if(!PositionSelectByTicket(ticket)) return false;
   ENUM_POSITION_TYPE pt  = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   double             lot = PositionGetDouble(POSITION_VOLUME);
   ENUM_ORDER_TYPE    ct  = (pt == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   ENUM_ORDER_TYPE_FILLING fills[3] = {ORDER_FILLING_IOC, ORDER_FILLING_FOK, ORDER_FILLING_RETURN};
   MqlTradeRequest req = {};
   MqlTradeResult  res = {};
   req.action    = TRADE_ACTION_DEAL;
   req.symbol    = _Symbol;
   req.position  = ticket;
   req.volume    = lot;
   req.type      = ct;
   req.deviation = 30;
   req.magic     = InpMagic;

   for(int fi = 0; fi < 3; fi++) {
      req.type_filling = fills[fi];
      req.price = (ct == ORDER_TYPE_SELL)
                  ? SymbolInfoDouble(_Symbol, SYMBOL_BID)
                  : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      res.retcode = 0;
      if(OrderSend(req, res) &&
         (res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED))
         return true;
   }
   Print("[ERR] ClosePos FAILED retcode=", res.retcode, " ticket=", ticket);
   return false;
}

bool DeletePendingOrder(ulong ticket) {
   MqlTradeRequest req = {};
   MqlTradeResult  res = {};
   req.action = TRADE_ACTION_REMOVE;
   req.order  = ticket;
   bool ok = OrderSend(req, res);
   return ok && (res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED);
}

//+------------------------------------------------------------------+
//| Pre-run position report                                          |
//+------------------------------------------------------------------+
void ReportOpenPositions() {
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   int    cntB=0, cntS=0;
   double pnlB=0, pnlS=0, lotB=0, lotS=0;
   double deepBuy=bid, deepSell=bid;
   double deepBuyPnl=0, deepSellPnl=0;
   ulong  deepBuyTkt=0, deepSellTkt=0;

   Print("========== [PRE-RUN] ตรวจสอบไม้ค้าง ==========");
   Print(StringFormat(" Symbol: %s | BID: %.5f | Magic: %d", _Symbol, bid, InpMagic));

   for(int i = 0; i < PositionsTotal(); i++) {
      ulong t = PositionGetTicket(i);
      if(!PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)  != InpMagic) continue;

      ENUM_POSITION_TYPE pt = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double openPx = PositionGetDouble(POSITION_PRICE_OPEN);
      double lot    = PositionGetDouble(POSITION_VOLUME);
      double pnl    = PositionGetDouble(POSITION_PROFIT)
                    + PositionGetDouble(POSITION_SWAP)
                    + PositionGetDouble(POSITION_COMMISSION);
      double distPts = (pt == POSITION_TYPE_BUY)
                       ? (bid - openPx) / _Point
                       : (openPx - bid) / _Point;

      PrintFormat(" [%s] #%I64u | Open:%.5f | Lot:%.2f | P&L:%+.2f | Dist:%+.0fpts",
                  (pt==POSITION_TYPE_BUY?"BUY ":"SELL"), t, openPx, lot, pnl, distPts);

      if(pt == POSITION_TYPE_BUY) {
         cntB++; pnlB+=pnl; lotB+=lot;
         if(openPx < deepBuy || deepBuyTkt==0) { deepBuy=openPx; deepBuyPnl=pnl; deepBuyTkt=t; }
      } else {
         cntS++; pnlS+=pnl; lotS+=lot;
         if(openPx > deepSell || deepSellTkt==0) { deepSell=openPx; deepSellPnl=pnl; deepSellTkt=t; }
      }
   }

   int total = cntB + cntS;
   if(total == 0) {
      Print(" ไม่มีไม้ค้าง — พร้อมเริ่มต้นใหม่");
   } else {
      Print("-------------------------------------------");
      PrintFormat(" BUY  %d ไม้ | Lot:%.2f | P&L:%+.2f", cntB, lotB, pnlB);
      PrintFormat(" SELL %d ไม้ | Lot:%.2f | P&L:%+.2f", cntS, lotS, pnlS);
      PrintFormat(" รวม  %d ไม้ | P&L:%+.2f %s", total, pnlB+pnlS, AccountInfoString(ACCOUNT_CURRENCY));
      if(deepBuyTkt  != 0) PrintFormat(" ★ BUY  ลึกสุด: Open=%.5f | Dist=%+.0fpts | P&L=%+.2f",
                                        deepBuy,  (bid-deepBuy)/_Point,  deepBuyPnl);
      if(deepSellTkt != 0) PrintFormat(" ★ SELL ลึกสุด: Open=%.5f | Dist=%+.0fpts | P&L=%+.2f",
                                        deepSell, (deepSell-bid)/_Point, deepSellPnl);
      if(total >= InpMaxTotalTrades)
         Print(" !! WARNING: ไม้ค้างเต็ม InpMaxTotalTrades — EA จะไม่เพิ่มไม้ใหม่ !!");
   }
   Print("=================================================");
}

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit() {
   bool isTester = (bool)MQLInfoInteger(MQL_TESTER);
   long currentAcc = AccountInfoInteger(ACCOUNT_LOGIN);
   ENUM_ACCOUNT_TRADE_MODE accMode = (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);

   Print("[INIT] START | Tester=", isTester,
         " Mode=", EnumToString(accMode),
         " Acc=", currentAcc,
         " Symbol=", _Symbol);

   // fix4: ข้าม security check ทั้งหมดเมื่ออยู่ใน Strategy Tester
   // เหตุ: FTMO-Demo บาง account คืนค่า ACCOUNT_TRADE_MODE_REAL
   //       ทำให้ account number check fail → INIT_FAILED → 0 trades
   if(!isTester) {
      if(TimeCurrent() > INTERNAL_EXPIRY) {
         Alert("EA EXPIRED");
         ExpertRemove();
         return(INIT_FAILED);
      }
      if(INTERNAL_LOCK_DEMO && accMode == ACCOUNT_TRADE_MODE_REAL) {
         Alert("DEMO ONLY");
         ExpertRemove();
         return(INIT_FAILED);
      }
      if(INTERNAL_ACCOUNT_LOCK != 0 && accMode == ACCOUNT_TRADE_MODE_REAL &&
         currentAcc != INTERNAL_ACCOUNT_LOCK) {
         Alert("UNAUTHORIZED: #" + IntegerToString(currentAcc));
         ExpertRemove();
         return(INIT_FAILED);
      }
      Print("[INIT] SECURITY OK — Acct=", currentAcc, " Mode=", EnumToString(accMode));
   } else {
      Print("[INIT] TESTER MODE — security bypassed, ready to trade");
   }
   ReportOpenPositions();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick() {
   // fix4: ข้าม security ใน Tester
   if(!MQLInfoInteger(MQL_TESTER)) {
      if(TimeCurrent() > INTERNAL_EXPIRY) { ExpertRemove(); return; }
      if(INTERNAL_ACCOUNT_LOCK != 0 &&
         AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL &&
         AccountInfoInteger(ACCOUNT_LOGIN) != INTERNAL_ACCOUNT_LOCK) { ExpertRemove(); return; }
   }

   int cB=0, cS=0; double fP=0, lL=0, tL=0; ENUM_POSITION_TYPE lT = POSITION_TYPE_BUY;
   double totalProfit = GetStats(cB, cS, fP, lL, lT, tL);
   int totalGroups = cB + cS;

   // 1. [SAFETY] Equity Stop Loss
   if(totalGroups > 0 &&
      AccountInfoDouble(ACCOUNT_EQUITY) < AccountInfoDouble(ACCOUNT_BALANCE) * (1.0 - InpMaxDrawdownPercent/100.0)) {
      CloseAllAndReset(); return;
   }

   // 2. [EXIT] Trailing Profit
   if(totalGroups > 0) {
      double adjTarget     = (totalGroups >= 5) ? 0.1 : InpTargetUSD;
      double dynamicTarget = (tL / 0.01) * adjTarget;
      double dynamicTrail  = (tL / 0.01) * InpTrailingUSD;
      if(totalProfit >= dynamicTarget) {
         if(totalProfit > maxSeenProfit) maxSeenProfit = totalProfit;
         if(totalProfit < (maxSeenProfit - dynamicTrail)) { CloseAllAndReset(); return; }
      } else maxSeenProfit = 0;
   }

   // 3. [ENTRY] Breakout 100 Bars
   if(totalGroups == 0 && CountTotalPending() == 0) {
      double highest = iHigh(_Symbol, _Period, iHighest(_Symbol, _Period, MODE_HIGH, InpLookback, 1));
      double lowest  = iLow (_Symbol, _Period, iLowest (_Symbol, _Period, MODE_LOW,  InpLookback, 1));
      double ask     = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double bid     = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double dynLot  = NormalizeLot(AccountInfoDouble(ACCOUNT_EQUITY) * (InpRiskPercent / 100.0) / GetPipValueUSD());

      // --- Debug: แสดงทุกแท่งใหม่ ---
      static datetime lastBarTime = 0;
      datetime curBar = iTime(_Symbol, _Period, 0);
      if(InpDebugLog && curBar != lastBarTime) {
         lastBarTime = curBar;
         Print("[ENTRY CHECK] ask=", DoubleToString(ask,3),
               " bid=", DoubleToString(bid,3),
               " highest=", DoubleToString(highest,3),
               " lowest=", DoubleToString(lowest,3),
               " gap_up=", DoubleToString(ask-highest,3),
               " gap_dn=", DoubleToString(bid-lowest,3),
               " lot=", DoubleToString(dynLot,2));
      }

      if(ask > highest) {
         Print("[ENTRY] BUY breakout ask=", ask, " > highest=", highest);
         if(SplitTrade(dynLot, ORDER_TYPE_BUY, "Break_Buy")) {
            globalHighPrice = highest; globalLowPrice = lowest;
            TradePending(ORDER_TYPE_SELL_STOP, CalculateNextLot(dynLot, 1), lowest, "Hedge_S1");
            lastTradeTime = TimeCurrent();
         }
      }
      else if(bid < lowest) {
         Print("[ENTRY] SELL breakout bid=", bid, " < lowest=", lowest);
         if(SplitTrade(dynLot, ORDER_TYPE_SELL, "Break_Sell")) {
            globalHighPrice = highest; globalLowPrice = lowest;
            TradePending(ORDER_TYPE_BUY_STOP, CalculateNextLot(dynLot, 1), highest, "Hedge_B1");
            lastTradeTime = TimeCurrent();
         }
      }
   }

   // 4. [RECOVERY]
   // fix1: cB>=1 / cS>=1 guard ป้องกัน Race Condition
   if(totalGroups > 0 && totalGroups < InpMaxTotalTrades && totalProfit < maxSeenProfit) {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

      if(TimeCurrent() - lastTradeTime >= 30) {
         if(lT == POSITION_TYPE_SELL && ask >= globalHighPrice && cB <= cS && cB >= 1) {
            double nL = CalculateNextLot(lL, totalGroups);
            if(SplitTrade(nL, ORDER_TYPE_BUY, "Rec_B")) {
               DeleteAllPending();
               lastTradeTime = TimeCurrent();
               if(totalGroups + 1 < InpMaxTotalTrades)
                  TradePending(ORDER_TYPE_SELL_STOP, CalculateNextLot(nL, totalGroups+1), globalLowPrice, "Rec_SStop");
            }
         }
         else if(lT == POSITION_TYPE_BUY && bid <= globalLowPrice && cS <= cB && cS >= 1) {
            double nL = CalculateNextLot(lL, totalGroups);
            if(SplitTrade(nL, ORDER_TYPE_SELL, "Rec_S")) {
               DeleteAllPending();
               lastTradeTime = TimeCurrent();
               if(totalGroups + 1 < InpMaxTotalTrades)
                  TradePending(ORDER_TYPE_BUY_STOP, CalculateNextLot(nL, totalGroups+1), globalHighPrice, "Rec_BStop");
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Helper Functions                                                 |
//+------------------------------------------------------------------+
bool SplitTrade(double totalLot, ENUM_ORDER_TYPE type, string comment) {
   double maxBrokerLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double remaining    = totalLot;
   bool   success      = false;
   while(remaining > 0) {
      double lot = NormalizeLot(MathMin(remaining, maxBrokerLot));
      if(TradeMarket(type, lot, comment)) { remaining -= lot; success = true; }
      else break;
   }
   return success;
}

double CalculateNextLot(double currentLot, int count) {
   return NormalizeLot(currentLot * (count < 4 ? InpMultEarly : InpMultLate));
}

double NormalizeLot(double l) {
   double s = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(s <= 0) s = 0.01;
   return MathMin(InpMaxLotLimit, MathMax(MathRound(l/s)*s, SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN)));
}

// USD profit per 1 lot per 1 point move (broker/symbol/cent-account agnostic)
double GetPipValueUSD() {
   double tickVal  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0 || tickVal <= 0) return 10.0;
   string cur = AccountInfoString(ACCOUNT_CURRENCY);
   StringToUpper(cur);
   double factor = 1.0;
   if(StringFind(cur,"CENT")>=0 || StringFind(cur,"USC")>=0) factor = 0.01;
   return (tickVal / tickSize) * factor;
}

double GetStats(int &cB, int &cS, double &fP, double &lL, ENUM_POSITION_TYPE &lT, double &tL) {
   double p = 0; cB=0; cS=0; fP=0; lL=0; tL=0; ulong lastT=0;
   for(int i=0; i<PositionsTotal(); i++) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic &&
         PositionGetString(POSITION_SYMBOL) == _Symbol) {
         p  += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP)
             + PositionGetDouble(POSITION_COMMISSION);
         double v = PositionGetDouble(POSITION_VOLUME); tL += v;
         if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
            cB++; if(fP == 0) fP = PositionGetDouble(POSITION_PRICE_OPEN);
         } else cS++;
         if(t > lastT) { lastT=t; lL=v; lT=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE); }
      }
   }
   return p;
}

void CloseAllAndReset() {
   for(int i=PositionsTotal()-1; i>=0; i--) {
      ulong t = PositionGetTicket(i);
      if(PositionSelectByTicket(t) &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic &&
         PositionGetString(POSITION_SYMBOL) == _Symbol)
         ClosePosition(t);
   }
   DeleteAllPending();
   maxSeenProfit = 0;
}

void DeleteAllPending() {
   for(int i=OrdersTotal()-1; i>=0; i--) {
      ulong t = OrderGetTicket(i);
      if(OrderSelect(t) &&
         OrderGetInteger(ORDER_MAGIC) == InpMagic &&
         OrderGetString(ORDER_SYMBOL) == _Symbol)
         DeletePendingOrder(t);
   }
}

int CountTotalPending() {
   int c = 0;
   for(int i=0; i<OrdersTotal(); i++) {
      ulong t = OrderGetTicket(i);
      if(OrderSelect(t) &&
         OrderGetInteger(ORDER_MAGIC) == InpMagic &&
         OrderGetString(ORDER_SYMBOL) == _Symbol) c++;
   }
   return c;
}
//+------------------------------------------------------------------+
