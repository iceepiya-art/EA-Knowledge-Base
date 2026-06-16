//+------------------------------------------------------------------+
//| SMC_NewsFilter.mqh — SMC Universal EA v3.0                      |
//| High-impact news filter via MT5 CalendarValueHistory()           |
//| (ported from MMF_NewsFilter v3.11)                               |
//+------------------------------------------------------------------+
#ifndef SMC_NEWSFILTER_MQH
#define SMC_NEWSFILTER_MQH

#include <SMC_Universal\SMC_Defines.mqh>

#define SMC_NEWS_CACHE_H   24
#define SMC_NEWS_MAX       200

struct SMCNewsEvent {
   datetime time;
   string   currency;
   string   name;
};

class CSMCNewsFilter {
private:
   SMCNewsEvent m_ev[];
   int          m_cnt;
   datetime     m_cacheFrom, m_cacheTo;
   bool         m_calAvail;
   int          m_blockMin;

   void PairToCurrencies(const string pair, string &c1, string &c2) {
      c1=""; c2="";
      if(StringLen(pair)>=6) { c1=StringSubstr(pair,0,3); c2=StringSubstr(pair,3,3); }
   }

   bool LoadCalendar(datetime from, datetime to) {
      MqlCalendarValue vals[];
      int cnt = CalendarValueHistory(vals, from, to, NULL, NULL);
      if(cnt<0) return false;
      m_cnt=0;
      ArrayResize(m_ev, SMC_NEWS_MAX);
      for(int i=0; i<cnt&&m_cnt<SMC_NEWS_MAX; i++) {
         MqlCalendarEvent ev;
         if(!CalendarEventById(vals[i].event_id,ev)) continue;
         if(ev.importance!=CALENDAR_IMPORTANCE_HIGH) continue;
         MqlCalendarCountry country;
         if(!CalendarCountryById(ev.country_id,country)) continue;
         m_ev[m_cnt].time     = vals[i].time;
         m_ev[m_cnt].currency = country.currency;
         m_ev[m_cnt].name     = ev.name;
         m_cnt++;
      }
      return true;
   }

public:
   bool m_warnedUnavail;
   CSMCNewsFilter() { m_cnt=0; m_cacheFrom=0; m_cacheTo=0; m_calAvail=false; m_blockMin=30; m_warnedUnavail=false; }

   void SetBlockMin(int min) { m_blockMin=(min>0)?min:30; }

   void Refresh() {
      datetime now   = TimeCurrent();
      datetime from  = now;
      datetime to    = now + SMC_NEWS_CACHE_H*3600;
      if(now>=m_cacheFrom && now<m_cacheTo) return; // ยังใช้ cache ได้
      m_calAvail = LoadCalendar(from, to);
      if(m_calAvail) { m_cacheFrom=from; m_cacheTo=to; m_warnedUnavail=false; }
      else if(!m_warnedUnavail) {
         Print("[NF] MT5 calendar unavailable — news filter disabled");
         m_warnedUnavail=true; // print แค่ครั้งแรกครั้งเดียว
      }
   }

   //--- ตรวจว่า pair นี้มีข่าว high-impact ใกล้ๆ ไหม
   bool IsBlocked(const string pair) {
      if(!m_calAvail || m_cnt==0) return false;
      string c1,c2;
      PairToCurrencies(pair,c1,c2);
      datetime now = TimeCurrent();
      datetime win = m_blockMin*60;
      for(int i=0;i<m_cnt;i++) {
         if(m_ev[i].currency!=c1 && m_ev[i].currency!=c2) continue;
         long diff = MathAbs((long)(m_ev[i].time-now));
         if(diff<=(long)win) return true;
      }
      return false;
   }

   bool IsAvailable() const { return m_calAvail; }
   int  EventCount()  const { return m_cnt; }
};

#endif
