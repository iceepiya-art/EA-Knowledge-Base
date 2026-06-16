//+------------------------------------------------------------------+
//| SMC_MTFManager.mqh — SMC Universal EA v3.0                      |
//| Multi-Timeframe Manager (fix15)                                  |
//|                                                                  |
//| หน้าที่:                                                         |
//|   1. Cache HTF zone ต่อ symbol (อัปเดตเฉพาะเมื่อ HTF bar ใหม่) |
//|   2. ตรวจว่าราคาปัจจุบันอยู่ใน HTF zone หรือไม่                |
//|   3. ตรวจว่า LTF direction ตรงกับ HTF direction                 |
//|                                                                  |
//| Flow:                                                            |
//|   HTF (H1/H4): Trend + W/M + Zone + FVG → cache HTFZone        |
//|   LTF (M5/M1): ราคาต้อง อยู่ใน HTFZone + direction match       |
//|                จึงหา LTF entry (W/M + FVG ละเอียด)              |
//+------------------------------------------------------------------+
#ifndef SMC_MTFMANAGER_MQH
#define SMC_MTFMANAGER_MQH

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_SymbolManager.mqh>
#include <SMC_Universal\SMC_Scanner.mqh>

//--- ข้อมูล HTF cache ต่อ symbol
struct HTFCache {
   ZoneResult    zone;         // HTF zone result
   datetime      barTime;      // last HTF bar time (ใช้ detect new bar)
   bool          ready;        // zone valid และ refresh แล้ว
   string        symbol;
};

class CSMCMTFManager {
private:
   CSymbolManager* m_sm;
   CSMCScanner*    m_sc;

   ENUM_TIMEFRAMES m_htfTF;   // H1 หรือ H4
   ENUM_TIMEFRAMES m_ltfTF;   // M5 หรือ M1
   bool            m_enabled;

   HTFCache        m_cache[];  // 1 ต่อ symbol
   int             m_hATR[];   // ATR handle HTF ต่อ symbol

   //--- ATR จาก handle HTF (ใช้ใน CalcEntry LTF ถ้าต้องการ)
   double GetHTFATR(int si) {
      if(si<0||si>=ArraySize(m_hATR)) return 0.0;
      if(m_hATR[si]==INVALID_HANDLE)  return 0.0;
      double buf[1];
      if(CopyBuffer(m_hATR[si],0,1,1,buf)<1) return 0.0;
      return buf[0];
   }

public:
   CSMCMTFManager() {
      m_sm=NULL; m_sc=NULL; m_enabled=false;
      m_htfTF=PERIOD_H1; m_ltfTF=PERIOD_M5;
   }

   //--- เรียกจาก OnInit หลัง SymbolManager.Init()
   void Init(CSymbolManager* sm, CSMCScanner* sc,
             ENUM_TIMEFRAMES htf, ENUM_TIMEFRAMES ltf) {
      m_sm=sm; m_sc=sc; m_htfTF=htf; m_ltfTF=ltf; m_enabled=true;
      if(sm==NULL||sc==NULL) { m_enabled=false; return; }

      int n=sm.Count();
      ArrayResize(m_cache, n);
      ArrayResize(m_hATR,  n);
      ArrayInitialize(m_hATR, INVALID_HANDLE);

      for(int i=0;i<n;i++) {
         ZeroMemory(m_cache[i]);
         m_cache[i].symbol  = sm.GetSymbol(i);
         m_cache[i].ready   = false;
         m_cache[i].barTime = 0;
         m_hATR[i] = iATR(sm.GetSymbol(i), htf, 14);
         if(m_hATR[i]==INVALID_HANDLE)
            PrintFormat("[MTF] WARNING: ATR handle failed — %s HTF", sm.GetSymbol(i));
      }
      PrintFormat("[MTF] Init OK | HTF=%s LTF=%s | %d symbols",
                  EnumToString(htf), EnumToString(ltf), n);
   }

   void Deinit() {
      for(int i=0;i<ArraySize(m_hATR);i++)
         if(m_hATR[i]!=INVALID_HANDLE){IndicatorRelease(m_hATR[i]);m_hATR[i]=INVALID_HANDLE;}
      m_enabled=false;
   }

   //--- RefreshHTF: อัปเดต cache ถ้ามี HTF bar ใหม่
   //    ประหยัด resource — Scan HTF เฉพาะเมื่อ bar เปลี่ยน
   void RefreshHTF(int si, const string sym) {
      if(!m_enabled||m_sc==NULL) return;
      if(si<0||si>=ArraySize(m_cache)) return;

      datetime curHTFBar = iTime(sym, m_htfTF, 0);
      if(curHTFBar==m_cache[si].barTime && m_cache[si].ready) return;  // ยัง valid

      //--- Scan HTF
      ZoneResult htfZone;
      bool found = m_sc.Scan(sym, htfZone, m_htfTF);

      m_cache[si].zone    = htfZone;
      m_cache[si].barTime = curHTFBar;
      m_cache[si].ready   = found;

      if(found)
         PrintFormat("[MTF] %s HTF zone refreshed | %s | zHi=%.5f zLo=%.5f",
                     sym, htfZone.isBull?"BULL":"BEAR", htfZone.zHi, htfZone.zLo);
      // silent skip เมื่อไม่เจอ zone — ไม่ log ทุก bar
   }

   //--- IsHTFReady: HTF zone valid ไหม
   bool IsHTFReady(int si) {
      if(!m_enabled) return true;  // disabled → bypass
      if(si<0||si>=ArraySize(m_cache)) return false;
      return m_cache[si].ready;
   }

   //--- IsInHTFZone: ราคาอยู่ใน HTF zone หรือ FVG ไหม
   //    ตรวจ 3 ระดับ:
   //    1. อยู่ใน Zone 50-62% (กว้าง)
   //    2. อยู่ใน FVG (แคบ แต่ยังใช้ได้)
   //    3. ราคาใกล้ Zone boundary ±10% ของ zone width (buffer)
   bool IsInHTFZone(int si, double price) {
      if(!m_enabled) return true;
      if(si<0||si>=ArraySize(m_cache)||!m_cache[si].ready) return false;
      ZoneResult z = m_cache[si].zone;
      double zWidth = z.zHi - z.zLo;
      double buffer = zWidth * 0.1;
      bool inZone = (price >= z.zLo-buffer && price <= z.zHi+buffer);
      bool inFVG  = (z.fvgHi>0 && z.fvgLo>0 &&
                     price >= z.fvgLo && price <= z.fvgHi);
      return inZone || inFVG;
   }

   //--- DirectionMatch: LTF direction ต้องตรงกับ HTF
   bool DirectionMatch(int si, bool ltfBull) {
      if(!m_enabled) return true;
      if(si<0||si>=ArraySize(m_cache)||!m_cache[si].ready) return false;
      return (m_cache[si].zone.isBull == ltfBull);
   }

   //--- Getters
   bool            IsEnabled()       const { return m_enabled; }
   ENUM_TIMEFRAMES GetHTFPeriod()    const { return m_htfTF; }
   ENUM_TIMEFRAMES GetLTFPeriod()    const { return m_ltfTF; }
   ZoneResult      GetHTFZone(int si) {
      ZoneResult z; ZeroMemory(z);
      if(si>=0&&si<ArraySize(m_cache)) z=m_cache[si].zone;
      return z;
   }
   bool            IsHTFBull(int si) {
      if(si<0||si>=ArraySize(m_cache)) return false;
      return m_cache[si].zone.isBull;
   }
   datetime        GetHTFBarTime(int si) {
      if(si<0||si>=ArraySize(m_cache)) return 0;
      return m_cache[si].barTime;
   }
};

#endif
