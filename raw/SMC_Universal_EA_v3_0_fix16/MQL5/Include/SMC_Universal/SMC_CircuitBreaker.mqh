//+------------------------------------------------------------------+
//| SMC_CircuitBreaker.mqh — SMC Universal EA v3.0                  |
//| fix21: fully configurable challenge rules (broker-agnostic)     |
//|   challengeBalance → base balance for DD calc (0=auto)          |
//|   dailyLossLimit   → daily loss % (0 = Swing/no daily limit)    |
//|   totalBrokerLimit → broker's official max DD % (display only)  |
//|   internalDDStop   → internal halt before hitting broker limit  |
//+------------------------------------------------------------------+
#ifndef SMC_CIRCUITBREAKER_MQH
#define SMC_CIRCUITBREAKER_MQH

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_Journal.mqh>

class CSMCCircuitBreaker {
private:
   double        m_dayStartEquity;
   bool          m_tripped;
   int           m_tripDay;
   int           m_lastResetDay;
   CSMCJournal*  m_jn;

   // fix21: broker-agnostic challenge params
   double        m_challengeBalance;   // reference base (override or auto)
   double        m_dailyLossLimit;     // 0 = swing/no daily check; >0 = daily % limit
   double        m_totalBrokerLimit;   // broker's official max DD % (info only)
   double        m_internalDDStop;     // halt threshold before broker limit
   double        m_profitTarget;       // challenge profit target % (display)
   int           m_minTradeDays;       // min trading days required (display)

   int DayOfYear() { MqlDateTime dt; TimeToStruct(TimeCurrent(),dt); return dt.day_of_year; }
   int CurHour()   { MqlDateTime dt; TimeToStruct(TimeCurrent(),dt); return dt.hour; }

   void RecordDay() {
      m_dayStartEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      m_lastResetDay   = DayOfYear();
      if(m_dailyLossLimit <= 0) m_tripped = false; // Swing: reset daily
      PrintFormat("[CB] Day start equity=%.2f | %s | DailyLimit=%.1f%% | InternalStop=%.1f%%",
                  m_dayStartEquity,
                  m_dailyLossLimit<=0 ? "SWING" : "NORMAL",
                  m_dailyLossLimit, m_internalDDStop);
   }

public:
   CSMCCircuitBreaker() {
      m_dayStartEquity=0; m_tripped=false; m_tripDay=-1; m_lastResetDay=-1; m_jn=NULL;
      m_challengeBalance=0; m_dailyLossLimit=0; m_totalBrokerLimit=10.0;
      m_internalDDStop=8.0; m_profitTarget=10.0; m_minTradeDays=4;
   }

   // fix21: fully configurable init
   void Init(CSMCJournal* jn,
             double challengeBalance = 0,      // 0 = read from account at init
             double dailyLossLimit   = 0,      // 0 = Swing (no daily); e.g. 5.0 = Normal
             double totalBrokerLimit = 10.0,   // broker's official limit (FTMO=10)
             double internalDDStop   = 8.0,    // internal stop before hitting limit
             double profitTarget     = 10.0,   // target % (FTMO=10, E8=8)
             int    minTradeDays     = 4) {    // min days (FTMO=4)
      m_jn               = jn;
      m_dailyLossLimit   = dailyLossLimit >= 0 ? dailyLossLimit : 0;
      m_totalBrokerLimit = totalBrokerLimit > 0 ? totalBrokerLimit : 10.0;
      m_internalDDStop   = internalDDStop > 0 ? internalDDStop : 8.0;
      m_profitTarget     = profitTarget > 0 ? profitTarget : 10.0;
      m_minTradeDays     = minTradeDays > 0 ? minTradeDays : 4;

      double acctEq = AccountInfoDouble(ACCOUNT_EQUITY);
      m_challengeBalance = (challengeBalance > 0) ? challengeBalance : acctEq;

      RecordDay();
      PrintFormat("[CB] Init OK | Base=%.2f | %s | DailyLimit=%.1f%% | BrokerDD=%.1f%% | InternalStop=%.1f%% | Target=+%.1f%% | MinDays=%d",
                  m_challengeBalance,
                  m_dailyLossLimit<=0 ? "SWING" : "NORMAL",
                  m_dailyLossLimit, m_totalBrokerLimit, m_internalDDStop,
                  m_profitTarget, m_minTradeDays);
   }

   void Check() {
      if(CurHour()==CB_RESET_HOUR && DayOfYear()!=m_lastResetDay)
         { RecordDay(); return; }

      if(m_tripped) return;
      if(m_dayStartEquity <= 0) { RecordDay(); return; }

      double eq = AccountInfoDouble(ACCOUNT_EQUITY);

      // ── Internal DD Stop (all modes) ──────────────────────────────
      if(m_challengeBalance > 0) {
         double ddPct = (m_challengeBalance - eq) / m_challengeBalance * 100.0;
         if(ddPct >= m_internalDDStop) {
            m_tripped = true; m_tripDay = DayOfYear();
            string msg = StringFormat("INTERNAL DD STOP — DD=%.2f%% (limit=%.1f%%) eq=%.2f base=%.2f",
                                      ddPct, m_internalDDStop, eq, m_challengeBalance);
            Print("[CB] ", msg);
            if(m_jn!=NULL) m_jn.Log(SMCEVT_CB,"ALL",msg, eq-m_challengeBalance);
            return;
         }
      }

      // ── Daily Loss Check (Normal mode — dailyLossLimit > 0) ───────
      if(m_dailyLossLimit > 0) {
         double dayLoss = (m_dayStartEquity - eq) / m_dayStartEquity * 100.0;
         if(dayLoss >= m_dailyLossLimit) {
            m_tripped = true; m_tripDay = DayOfYear();
            string msg = StringFormat("DAILY LIMIT HIT — loss=%.1f%% (limit=%.1f%%) eq=%.2f",
                                      dayLoss, m_dailyLossLimit, eq);
            Print("[CB] ", msg);
            if(m_jn!=NULL) m_jn.Log(SMCEVT_CB,"ALL",msg, eq-m_dayStartEquity);
         }
      }
   }

   bool   IsTripped()           const { return m_tripped; }
   double DayStartEquity()      const { return m_dayStartEquity; }
   double ChallengeBalance()    const { return m_challengeBalance; }
   double ProfitTarget()        const { return m_profitTarget; }
   double TotalBrokerLimit()    const { return m_totalBrokerLimit; }
   double InternalDDStop()      const { return m_internalDDStop; }
   int    MinTradeDays()        const { return m_minTradeDays; }
   bool   IsSwingMode()         const { return m_dailyLossLimit <= 0; }

   double DailyLossPct() const {
      if(m_dayStartEquity<=0) return 0.0;
      return (m_dayStartEquity-AccountInfoDouble(ACCOUNT_EQUITY))/m_dayStartEquity*100.0;
   }
   double TotalDDPct() const {
      if(m_challengeBalance<=0) return 0.0;
      return (m_challengeBalance-AccountInfoDouble(ACCOUNT_EQUITY))/m_challengeBalance*100.0;
   }
   double ProfitPct() const {
      if(m_challengeBalance<=0) return 0.0;
      return (AccountInfoDouble(ACCOUNT_EQUITY)-m_challengeBalance)/m_challengeBalance*100.0;
   }
};

#endif
