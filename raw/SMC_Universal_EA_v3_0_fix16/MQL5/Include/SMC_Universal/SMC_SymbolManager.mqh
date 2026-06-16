//+------------------------------------------------------------------+
//| SMC_SymbolManager.mqh — SMC Universal EA v3.0                   |
//| Parse input symbol list, SymbolSelect, cache indicator handles   |
//| รองรับ Forex, XAUUSD, Index, Crypto ทุก asset                   |
//+------------------------------------------------------------------+
#ifndef SMC_SYMBOLMANAGER_MQH
#define SMC_SYMBOLMANAGER_MQH

#include <SMC_Universal\SMC_Defines.mqh>

class CSymbolManager {
private:
   string   m_syms[];       // รายชื่อ symbols ที่ active
   int      m_count;        // จำนวน symbols จริง

   //--- cached indicator handles per symbol (เปิดครั้งเดียวใน Init)
   int      m_hATR[];       // ATR Current TF (14) สำหรับ lot calc
   bool     m_ready;

   //--- pip size helper — universal ทุก asset
   double PipSize(const string sym) {
      double pt = SymbolInfoDouble(sym, SYMBOL_POINT);
      int    dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      // 5-digit Forex / JPY / Crypto → 1 pip = 10 points
      // 2-digit XAUUSD / indices → 1 pip = 10 points
      return (dg == 3 || dg == 5) ? pt * 10.0 : pt;
   }

   //--- แยก string "EURUSD,GBPUSD, XAUUSD" → array (trim spaces)
   int ParseSymbols(const string raw, string &out[]) {
      ArrayResize(out, MAX_SYMBOLS);
      int cnt  = 0;
      string s = raw;
      StringTrimRight(s); StringTrimLeft(s);
      if(StringLen(s) == 0) return 0;

      int start = 0;
      for(int i = 0; i <= StringLen(s); i++) {
         ushort ch = (i < StringLen(s)) ? StringGetCharacter(s, i) : ',';
         if(ch == ',' || ch == ';' || ch == ' ') {
            if(i > start) {
               string tok = StringSubstr(s, start, i-start);
               StringTrimLeft(tok); StringTrimRight(tok);
               StringToUpper(tok);
               if(StringLen(tok) > 0 && cnt < MAX_SYMBOLS)
                  out[cnt++] = tok;
            }
            start = i+1;
         }
      }
      ArrayResize(out, cnt);
      return cnt;
   }

   //--- Auto-detect suffix: กรอก "XAUUSD" → หา "XAUUSD.iux" ใน Market Watch
   //    คืน symbol name จริงที่ broker ใช้ หรือ "" ถ้าหาไม่เจอ
   string ResolveSuffix(const string baseName) {
      int baseLen = StringLen(baseName);
      string best = "";

      // Strategy: scan ทุก symbol ที่ broker มี (ทั้ง Market Watch + hidden)
      // ใช้ SymbolsTotal(false) = ทั้งหมด, (true) = เฉพาะ Market Watch
      // loop false ก่อนเพราะครอบคลุมกว่า — ไม่ต้อง add เข้า MW ก่อน

      int total = SymbolsTotal(false);
      for(int i = 0; i < total; i++) {
         string sym = SymbolName(i, false);
         if(StringLen(sym) < baseLen) continue;
         // ต้องขึ้นต้นด้วย baseName และตัวถัดไปต้องเป็น . หรือ จบพอดี
         // เพื่อไม่ให้ EURUSD match กับ EURUSDM หรือ EURUSD500
         if(StringSubstr(sym, 0, baseLen) != baseName) continue;
         if(StringLen(sym) > baseLen) {
            ushort nextCh = StringGetCharacter(sym, baseLen);
            // ยอมรับ suffix ที่ขึ้นด้วย . หรือตัวพิมพ์เล็ก หรือตัวเลข
            if(nextCh != '.' && !(nextCh>='a' && nextCh<='z') &&
               !(nextCh>='0' && nextCh<='9') && nextCh != '+' && nextCh != '-')
               continue;
         }
         // เลือก symbol ที่สั้นที่สุด (suffix น้อยที่สุด = ใกล้เคียง base มากสุด)
         if(best == "" || StringLen(sym) < StringLen(best))
            best = sym;
      }

      if(best != "") {
         PrintFormat("[SM] ResolveSuffix: %s → %s (from %d broker symbols)",
                     baseName, best, total);
         return best;
      }

      // Fallback: ลอง Market Watch เท่านั้น
      total = SymbolsTotal(true);
      for(int i = 0; i < total; i++) {
         string sym = SymbolName(i, true);
         if(StringLen(sym) < baseLen) continue;
         if(StringSubstr(sym, 0, baseLen) != baseName) continue;
         if(best == "" || StringLen(sym) < StringLen(best))
            best = sym;
      }
      if(best != "")
         PrintFormat("[SM] ResolveSuffix (MW): %s → %s", baseName, best);

      return best;
   }

public:
   CSymbolManager() { m_count=0; m_ready=false; }

   //--- เรียกจาก OnInit — parse input string + SymbolSelect + เปิด handles
   bool Init(const string symbolListInput) {
      string parsed[];
      int n = ParseSymbols(symbolListInput, parsed);
      if(n == 0) {
         Print("[SM] ERROR: no valid symbols in input");
         return false;
      }

      ArrayResize(m_syms,  MAX_SYMBOLS);
      ArrayResize(m_hATR,  MAX_SYMBOLS);
      ArrayInitialize(m_hATR, INVALID_HANDLE);
      m_count = 0;

      for(int i=0; i<n; i++) {
         string base = parsed[i];

         //--- Auto-detect suffix (เช่น XAUUSD → XAUUSD.iux)
         string sym = ResolveSuffix(base);
         if(sym == "") {
            PrintFormat("[SM] WARNING: symbol not found — %s (skip)", base);
            continue;
         }
         if(sym != base)
            PrintFormat("[SM] Suffix resolved: %s → %s", base, sym);

         //--- เพิ่มเข้า Market Watch (retry 3 ครั้ง — บาง broker ช้า)
         bool selected = false;
         for(int retry = 0; retry < 3; retry++) {
            if(SymbolSelect(sym, true)) { selected = true; break; }
            Sleep(200);
         }
         if(!selected) {
            // ลอง subscribe ผ่าน SymbolInfoInteger ก่อนแล้ว select อีกครั้ง
            int dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
            SymbolSelect(sym, true);
            selected = (dg > 0);
         }
         if(!selected) {
            PrintFormat("[SM] WARNING: SymbolSelect failed — %s (skip)", sym);
            continue;
         }

         //--- เปิด ATR handle (PERIOD_CURRENT — EA ทำงานบน TF ที่ attach)
         m_hATR[m_count] = iATR(sym, PERIOD_CURRENT, 14);
         if(m_hATR[m_count] == INVALID_HANDLE)
            PrintFormat("[SM] WARNING: ATR handle failed — %s", sym);

         m_syms[m_count] = sym;
         m_count++;
         PrintFormat("[SM] Registered: %s (idx=%d)", sym, m_count-1);
      }

      m_ready = (m_count > 0);
      PrintFormat("[SM] Init complete — %d symbols active", m_count);
      return m_ready;
   }

   void Deinit() {
      for(int i=0; i<m_count; i++) {
         if(m_hATR[i] != INVALID_HANDLE) {
            IndicatorRelease(m_hATR[i]);
            m_hATR[i] = INVALID_HANDLE;
         }
      }
      m_ready = false;
   }

   //--- Getters
   int          Count()        const { return m_count; }
   bool         IsReady()      const { return m_ready; }
   string       GetSymbol(int i) const { return (i>=0&&i<m_count)?m_syms[i]:""; }
   int          GetATRHandle(int i) const { return (i>=0&&i<m_count)?m_hATR[i]:INVALID_HANDLE; }

   int IndexOf(const string sym) const {
      for(int i=0;i<m_count;i++) if(m_syms[i]==sym) return i;
      return -1;
   }

   //--- ATR ใน price units (closed bar[1]) สำหรับ lot calc
   double GetATR(int idx) {
      if(idx<0||idx>=m_count) return 0.0;
      if(m_hATR[idx]==INVALID_HANDLE) return 0.0;
      double buf[1];
      if(CopyBuffer(m_hATR[idx], 0, 1, 1, buf) < 1) return 0.0;
      return buf[0];
   }

   //--- pip value per 1 lot ใน account currency (universal)
   double PipValuePerLot(const string sym) {
      double tickVal  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
      double tickSize = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
      double pt       = SymbolInfoDouble(sym, SYMBOL_POINT);
      if(tickVal<=0||tickSize<=0||pt<=0) return 0.0;
      return (tickVal / tickSize) * PipSize(sym);
   }

   double GetPipSize(const string sym) { return PipSize(sym); }

   //--- normalize lot ตาม broker
   double NormLot(const string sym, double raw) {
      double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
      double mn   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
      double mx   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
      if(step<=0) step=0.01;
      raw = MathFloor(raw/step)*step;
      return NormalizeDouble(MathMax(mn,MathMin(mx,raw)),2);
   }
};

#endif
