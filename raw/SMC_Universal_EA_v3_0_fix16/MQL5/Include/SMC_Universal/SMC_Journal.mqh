//+------------------------------------------------------------------+
//| SMC_Journal.mqh — SMC Universal EA v3.0                         |
//| Event log: memory buffer + CSV file                              |
//+------------------------------------------------------------------+
#ifndef SMC_JOURNAL_MQH
#define SMC_JOURNAL_MQH

#include <SMC_Universal\SMC_Defines.mqh>

class CSMCJournal {
private:
   JournalEntry m_log[];
   int          m_count;
   int          m_fh;
   bool         m_fileOk;

   string EvtName(ENUM_SMC_EVENT e) {
      switch(e) {
         case SMCEVT_OPEN:    return "OPEN";
         case SMCEVT_TRAIL:   return "TRAIL";
         case SMCEVT_CLOSE:   return "CLOSE";
         case SMCEVT_SKIP:    return "SKIP";
         case SMCEVT_CB:      return "CIRCUIT";
         case SMCEVT_NEWS:    return "NEWS";
         case SMCEVT_SESSION: return "SESSION";
         default:             return "UNKNOWN";
      }
   }

public:
   CSMCJournal() { m_count=0; m_fh=INVALID_HANDLE; m_fileOk=false; ArrayResize(m_log,JOURNAL_MAX); }
   ~CSMCJournal() { if(m_fh!=INVALID_HANDLE) FileClose(m_fh); }

   void Init() {
      m_fh = FileOpen(JOURNAL_FILE, FILE_WRITE|FILE_READ|FILE_CSV|FILE_ANSI, ',');
      if(m_fh != INVALID_HANDLE) {
         FileSeek(m_fh, 0, SEEK_END);
         if(FileTell(m_fh) == 0)
            FileWrite(m_fh, "Time","Event","Symbol","Description","PnL");
         m_fileOk = true;
         Print("[Journal] Opened: ", JOURNAL_FILE);
      } else {
         PrintFormat("[Journal] Cannot open file err=%d", GetLastError());
      }
   }

   void Log(ENUM_SMC_EVENT evt, const string sym, const string desc, double pnl=0.0) {
      // shift buffer ถ้าเต็ม
      if(m_count >= JOURNAL_MAX) {
         for(int k=0; k<JOURNAL_MAX-1; k++) m_log[k] = m_log[k+1];
         m_count = JOURNAL_MAX-1;
      }
      JournalEntry e;
      e.time        = TimeCurrent();
      e.eventType   = evt;
      e.symbol      = sym;
      e.description = desc;
      e.pnl         = pnl;
      m_log[m_count++] = e;

      PrintFormat("[SMC][%s] %s | %s | PnL=%.2f", EvtName(evt), sym, desc, pnl);

      if(m_fileOk && m_fh!=INVALID_HANDLE) {
         FileSeek(m_fh, 0, SEEK_END);
         FileWrite(m_fh,
            TimeToString(e.time, TIME_DATE|TIME_MINUTES),
            EvtName(evt), sym, desc,
            DoubleToString(pnl,2));
         FileFlush(m_fh);
      }
   }

   int          Count()         const { return m_count; }
   JournalEntry GetEntry(int i) const { return m_log[i]; }

   int GetRecent(JournalEntry &out[], int n) {
      int start = MathMax(0, m_count-n);
      int cnt   = m_count - start;
      ArrayResize(out, cnt);
      for(int i=0; i<cnt; i++) out[i] = m_log[m_count-1-i];
      return cnt;
   }

   double TotalPnL() {
      double s=0; for(int i=0;i<m_count;i++) s+=m_log[i].pnl; return s;
   }
   int CountByEvent(ENUM_SMC_EVENT evt) {
      int c=0; for(int i=0;i<m_count;i++) if(m_log[i].eventType==evt) c++; return c;
   }
};

#endif
