//+------------------------------------------------------------------+
//| SMC_TimeFilter.mqh — SMC Universal EA v3.0                      |
//| fix16: Window mode only (Block mode removed)                     |
//| fix20: เพิ่ม Session 3 (Asian 07:00-08:00)                       |
//+------------------------------------------------------------------+
#ifndef SMC_TIMEFILTER_MQH
#define SMC_TIMEFILTER_MQH

#include <SMC_Universal\SMC_Defines.mqh>

class CSMCTimeFilter {
private:
   bool  m_enabled;
   int   m_sess1S, m_sess1E;
   bool  m_sess2En;
   int   m_sess2S, m_sess2E;
   bool  m_sess3En;             // fix20: Session 3
   int   m_sess3S, m_sess3E;
   bool  m_blockFriday;
   int   m_fridayH;

   int CurHour() { MqlDateTime dt; TimeToStruct(TimeCurrent(),dt); return dt.hour; }
   int CurDow()  { MqlDateTime dt; TimeToStruct(TimeCurrent(),dt); return dt.day_of_week; }
   int CurHHMM() { MqlDateTime dt; TimeToStruct(TimeCurrent(),dt); return dt.hour*100+dt.min; }

   bool InWindow(int hhmm, int s, int e) {
      if(s<=e) return (hhmm>=s && hhmm<e);
      return (hhmm>=s || hhmm<e);
   }

public:
   CSMCTimeFilter() {
      m_enabled=true;
      m_sess1S=1400; m_sess1E=1500;
      m_sess2En=true; m_sess2S=2030; m_sess2E=2100;
      m_sess3En=false; m_sess3S=700; m_sess3E=800;   // fix20: Asian default off
      m_blockFriday=true; m_fridayH=20;
   }

   // fix20: เพิ่ม sess3 params
   void Configure(bool enabled,
                  int  sess1Start, int sess1End,
                  bool sess2Enable, int sess2Start, int sess2End,
                  bool blockFriday = true, int fridayH = 20,
                  bool sess3Enable = false,
                  int  sess3Start  = 700,
                  int  sess3End    = 800) {
      m_enabled     = enabled;
      m_sess1S      = sess1Start;  m_sess1E = sess1End;
      m_sess2En     = sess2Enable; m_sess2S = sess2Start; m_sess2E = sess2End;
      m_sess3En     = sess3Enable; m_sess3S = sess3Start; m_sess3E = sess3End;
      m_blockFriday = blockFriday; m_fridayH = fridayH;
   }

   bool IsAllowed() {
      if(!m_enabled) return true;
      int h=CurHour(), dow=CurDow(), hhmm=CurHHMM();
      if(dow==0 || dow==6) return false;
      if(m_blockFriday && dow==5 && h>=m_fridayH) return false;
      bool in1 = InWindow(hhmm, m_sess1S, m_sess1E);
      bool in2 = m_sess2En && InWindow(hhmm, m_sess2S, m_sess2E);
      bool in3 = m_sess3En && InWindow(hhmm, m_sess3S, m_sess3E);  // fix20
      return in1 || in2 || in3;
   }

   string StatusLabel() {
      if(!m_enabled) return "TF:OFF";
      int h=CurHour(), dow=CurDow(), hhmm=CurHHMM();
      if(dow==0||dow==6) return "WEEKEND";
      if(m_blockFriday&&dow==5&&h>=m_fridayH) return "FRI_CLOSE";
      if(InWindow(hhmm,m_sess1S,m_sess1E))  return "LDN";
      if(m_sess2En && InWindow(hhmm,m_sess2S,m_sess2E)) return "NY";
      if(m_sess3En && InWindow(hhmm,m_sess3S,m_sess3E)) return "ASIAN";  // fix20
      return StringFormat("OUT(%04d)",hhmm);
   }
};

#endif
