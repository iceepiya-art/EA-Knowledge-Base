//+------------------------------------------------------------------+
//| SMC_RegimeFilter.mqh — SC₁₀₀ Regime Gate                        |
//| fix17: SC₁₀₀ + β₁ regime classification                         |
//| fix18: per-symbol arrays                                         |
//| fix19: AutoThreshold(tf)                                         |
//| fix20: RSI(20)+SMA(50) confirm สำหรับ REVERTING regime           |
//|   InpUseRSIConfirm=true → REVERTING entry ต้องผ่าน RSI filter    |
//|   LONG:  RSI < rsiOS  AND  close < SMA   (oversold + below MA)  |
//|   SHORT: RSI > rsiOB  AND  close > SMA   (overbought + above MA) |
//+------------------------------------------------------------------+
#ifndef SMC_REGIME_FILTER_MQH
#define SMC_REGIME_FILTER_MQH

enum ENUM_REGIME {
   REGIME_CRASH     = 0,
   REGIME_TRENDING  = 1,
   REGIME_WEAK      = 2,
   REGIME_REVERTING = 3
};

class CSMCRegimeFilter {
private:
   bool         m_enabled;
   int          m_maxSyms;
   int          m_sc100Bars;
   int          m_beta1Bars;
   double       m_threshTrend;
   double       m_threshRevert;
   double       m_threshCrash;

   // fix20: RSI+SMA confirm params
   bool         m_useRSIConfirm;
   int          m_rsiPeriod;     // default 20
   int          m_smaPeriod;     // default 50
   double       m_rsiOS;         // oversold  threshold (default 35)
   double       m_rsiOB;         // overbought threshold (default 65)

   // per-symbol state
   ENUM_REGIME  m_regimes[];
   double       m_sc100s[];
   double       m_beta1s[];
   datetime     m_lastUpdates[];

   //--- SC₁₀₀
   double CalcSC100(const string sym) {
      double cls[];
      ArraySetAsSeries(cls, true);
      int need = m_sc100Bars + 1;
      if(CopyClose(sym, PERIOD_M1, 0, need, cls) < need) return -1.0;
      int changes = 0;
      double prevSign = 0;
      for(int i = m_sc100Bars - 1; i >= 0; i--) {
         double r = cls[i] - cls[i+1];
         double s = (r > 0) ? 1.0 : (r < 0 ? -1.0 : 0.0);
         if(s != 0) {
            if(prevSign != 0 && s != prevSign) changes++;
            prevSign = s;
         }
      }
      return (double)changes / m_sc100Bars;
   }

   //--- β₁ OLS slope
   double CalcBeta1(const string sym) {
      double cls[];
      ArraySetAsSeries(cls, true);
      int need = m_beta1Bars + 1;
      if(CopyClose(sym, PERIOD_M1, 0, need, cls) < need) return 0.0;
      double ret[];
      ArrayResize(ret, m_beta1Bars);
      for(int i = 0; i < m_beta1Bars; i++) ret[i] = cls[i] - cls[i+1];
      double sx=0, sy=0, sxy=0, sx2=0;
      int n = m_beta1Bars;
      for(int i = 0; i < n; i++) {
         sx += i; sy += ret[i]; sxy += i*ret[i]; sx2 += (double)i*i;
      }
      double denom = n*sx2 - sx*sx;
      if(MathAbs(denom) < 1e-10) return 0.0;
      return (n*sxy - sx*sy) / denom;
   }

   //--- fix20: RSI (Wilder EMA) บน trading TF
   double CalcRSI(const string sym, ENUM_TIMEFRAMES tf) {
      int need = m_rsiPeriod * 3 + 1;
      double cls[];
      ArraySetAsSeries(cls, true);
      if(CopyClose(sym, tf, 0, need, cls) < need) return 50.0;

      double gain = 0, loss = 0;
      // seed ด้วย simple avg ก่อน
      for(int i = need-2; i >= need-1-m_rsiPeriod; i--) {
         double d = cls[i] - cls[i+1];
         if(d > 0) gain += d; else loss -= d;
      }
      gain /= m_rsiPeriod;
      loss /= m_rsiPeriod;

      // Wilder smooth ต่อ
      for(int i = need-1-m_rsiPeriod-1; i >= 0; i--) {
         double d = cls[i] - cls[i+1];
         double g = (d > 0) ? d : 0.0;
         double l = (d < 0) ? -d : 0.0;
         gain = (gain*(m_rsiPeriod-1) + g) / m_rsiPeriod;
         loss = (loss*(m_rsiPeriod-1) + l) / m_rsiPeriod;
      }
      if(loss < 1e-10) return 100.0;
      return 100.0 - (100.0 / (1.0 + gain/loss));
   }

   //--- fix20: SMA บน trading TF
   double CalcSMA(const string sym, ENUM_TIMEFRAMES tf) {
      double cls[];
      ArraySetAsSeries(cls, true);
      if(CopyClose(sym, tf, 0, m_smaPeriod, cls) < m_smaPeriod) return 0.0;
      double sum = 0;
      for(int i = 0; i < m_smaPeriod; i++) sum += cls[i];
      return sum / m_smaPeriod;
   }

public:
   CSMCRegimeFilter() {
      m_enabled=false; m_maxSyms=0;
      m_sc100Bars=100; m_beta1Bars=50;
      m_threshTrend=0.25; m_threshRevert=0.35; m_threshCrash=0.22;
      m_useRSIConfirm=true; m_rsiPeriod=20; m_smaPeriod=50;
      m_rsiOS=35.0; m_rsiOB=65.0;
   }

   void Init(bool enabled,
             double threshTrend  = 0.25,
             double threshRevert = 0.35,
             double threshCrash  = 0.22,
             int    sc100Bars    = 100,
             int    beta1Bars    = 50,
             bool   useRSIConfirm = true,
             int    rsiPeriod    = 20,
             int    smaPeriod    = 50,
             double rsiOS        = 35.0,
             double rsiOB        = 65.0) {
      m_enabled        = enabled;
      m_threshTrend    = threshTrend;
      m_threshRevert   = threshRevert;
      m_threshCrash    = threshCrash;
      m_sc100Bars      = sc100Bars;
      m_beta1Bars      = beta1Bars;
      m_useRSIConfirm  = useRSIConfirm;
      m_rsiPeriod      = rsiPeriod;
      m_smaPeriod      = smaPeriod;
      m_rsiOS          = rsiOS;
      m_rsiOB          = rsiOB;
   }

   //--- fix19: scale thresholds ตาม TF
   void AutoThreshold(ENUM_TIMEFRAMES tf) {
      int mins = (int)(PeriodSeconds(tf) / 60);
      if(mins < 1) mins = 1;
      double factor = 1.0 - 0.05 * MathLog((double)mins);
      factor = MathMax(0.55, MathMin(1.0, factor));
      m_threshCrash  = NormalizeDouble(0.22 * factor, 3);
      m_threshTrend  = NormalizeDouble(0.25 * factor, 3);
      m_threshRevert = NormalizeDouble(0.35 * factor, 3);
      PrintFormat("[RegimeFilter] AutoThreshold TF=%s factor=%.3f → crash=%.3f trend=%.3f revert=%.3f",
                  EnumToString(tf), factor, m_threshCrash, m_threshTrend, m_threshRevert);
   }

   void InitSymbols(int n) {
      m_maxSyms = n;
      ArrayResize(m_regimes,     n);
      ArrayResize(m_sc100s,      n);
      ArrayResize(m_beta1s,      n);
      ArrayResize(m_lastUpdates, n);
      for(int i = 0; i < n; i++) {
         m_regimes[i]=REGIME_WEAK; m_sc100s[i]=0.30;
         m_beta1s[i]=0.0; m_lastUpdates[i]=0;
      }
   }

   void Update(int si, const string sym) {
      if(!m_enabled || si < 0 || si >= m_maxSyms) {
         if(si >= 0 && si < m_maxSyms) m_regimes[si] = REGIME_TRENDING;
         return;
      }
      datetime barM1 = iTime(sym, PERIOD_M1, 0);
      if(barM1 == m_lastUpdates[si] && m_sc100s[si] > 0) return;

      double sc = CalcSC100(sym);
      double b1 = CalcBeta1(sym);
      if(sc < 0) return;

      m_sc100s[si]      = sc;
      m_beta1s[si]      = b1;
      m_lastUpdates[si] = barM1;

      if(sc < m_threshCrash)       m_regimes[si] = REGIME_CRASH;
      else if(sc < m_threshTrend)  m_regimes[si] = REGIME_TRENDING;
      else if(sc < m_threshRevert) m_regimes[si] = REGIME_WEAK;
      else                         m_regimes[si] = REGIME_REVERTING;
   }

   //--- fix20: IsAllowed รับ sym + tf สำหรับ RSI confirm
   bool IsAllowed(int si, bool isBullSignal,
                  const string sym="", ENUM_TIMEFRAMES tf=PERIOD_CURRENT) {
      if(!m_enabled) return true;
      if(si < 0 || si >= m_maxSyms) return false;

      switch(m_regimes[si]) {
         case REGIME_CRASH:
         case REGIME_WEAK:
            return false;

         case REGIME_TRENDING:
            // NinjaThai: follow β₁ direction
            return isBullSignal == (m_beta1s[si] > 0);

         case REGIME_REVERTING: {
            // fix20: counter-β₁ (NinjaThai CHoCH) + RSI confirm
            bool dirOK = (isBullSignal != (m_beta1s[si] > 0));
            if(!dirOK) return false;

            // RSI+SMA confirm (ถ้าเปิดใช้งานและมีข้อมูล sym)
            if(m_useRSIConfirm && StringLen(sym) > 0) {
               double rsi   = CalcRSI(sym, tf);
               double sma   = CalcSMA(sym, tf);
               double price = iClose(sym, tf, 0);
               if(sma <= 0 || price <= 0) return true; // ข้อมูลไม่พอ — ผ่านไปก่อน

               if(isBullSignal)
                  return (rsi < m_rsiOS && price < sma);   // oversold + ราคาต่ำกว่า MA
               else
                  return (rsi > m_rsiOB && price > sma);   // overbought + ราคาสูงกว่า MA
            }
            return true;
         }
      }
      return false;
   }

   ENUM_REGIME GetRegime(int si) const { return (si>=0&&si<m_maxSyms)?m_regimes[si]:REGIME_WEAK; }
   double      GetSC100(int si)  const { return (si>=0&&si<m_maxSyms)?m_sc100s[si]:0; }
   double      GetBeta1(int si)  const { return (si>=0&&si<m_maxSyms)?m_beta1s[si]:0; }

   string ThresholdStr() const {
      return StringFormat("crash=%.3f trend=%.3f revert=%.3f rsi=%g/%g",
                          m_threshCrash, m_threshTrend, m_threshRevert, m_rsiOS, m_rsiOB);
   }
   string RegimeStr(int si) const {
      if(si<0||si>=m_maxSyms) return "?";
      switch(m_regimes[si]) {
         case REGIME_CRASH:     return "CRASH";
         case REGIME_TRENDING:  return "TREND";
         case REGIME_WEAK:      return "WEAK";
         case REGIME_REVERTING: return "REVERT";
      }
      return "?";
   }
};
#endif
