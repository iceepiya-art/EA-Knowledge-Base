//+------------------------------------------------------------------+
//| SMC_Scanner.mqh — SMC Universal EA v3.0                         |
//| fix15: Scan() + CalcEntry() รับ ENUM_TIMEFRAMES tf               |
//|        → รองรับ HTF scan (H1/H4) และ LTF scan (M5/M1)          |
//|        default tf = PERIOD_CURRENT (backward compatible)         |
//| fix22: BOS-Retest mode — fallback เมื่อ W/M pattern ไม่เจอ      |
//|        InpUseBOSRetest=true → ใช้ BOS level + FVG แทน W/M neck  |
//|        + DIAG breakdown counters (swing/bos/wm/fvg/zone/ob)     |
//+------------------------------------------------------------------+
#ifndef SMC_SCANNER_MQH
#define SMC_SCANNER_MQH

#include <SMC_Universal\SMC_Defines.mqh>
#include <SMC_Universal\SMC_SymbolManager.mqh>

class CSMCScanner {
private:
   CSymbolManager* m_sm;
   int    m_swingLB, m_w23Tol, m_w23LB;
   int    m_fvgLB,   m_maxFVG, m_obLB, m_zoneBase;
   bool   m_reqTrend, m_reqSweep, m_strictCHoCH;
   bool   m_useBOSRetest;   // fix22
   int    m_sweepLB;         // fix25: SSL/BSL sweep lookback (default=obLB)

   double CalcATR(const double &h[], const double &l[], int sz) {
      double atr=0.0; int cnt=MathMin(14,sz-2);
      for(int i=1;i<=cnt;i++) atr+=h[i]-l[i];
      return (cnt>0)?atr/cnt:1.0;
   }

   void FindSwings(const double &h[], const double &l[], int sz,
                   int &shB[], double &shP[], int &nH,
                   int &slB[], double &slP[], int &nL) {
      ArrayResize(shB,0); ArrayResize(shP,0);
      ArrayResize(slB,0); ArrayResize(slP,0); nH=0; nL=0;
      for(int i=m_swingLB+1; i<sz-m_swingLB; i++) {
         bool isH=true, isL=true;
         for(int k=1;k<=m_swingLB;k++) {
            if(h[i]<=h[i-k]||h[i]<=h[i+k]) isH=false;
            if(l[i]>=l[i-k]||l[i]>=l[i+k]) isL=false;
         }
         if(isH){ArrayResize(shB,nH+1);ArrayResize(shP,nH+1);shB[nH]=i;shP[nH]=h[i];nH++;}
         if(isL){ArrayResize(slB,nL+1);ArrayResize(slP,nL+1);slB[nL]=i;slP[nL]=l[i];nL++;}
      }
   }

   bool CheckStrictTrend(bool isBull,
                          const double &shP[], int nH,
                          const double &slP[], int nL) {
      if(isBull) return (nH>=2&&shP[nH-1]>shP[nH-2]) && (nL>=2&&slP[nL-1]>slP[nL-2]);
      return         (nH>=2&&shP[nH-1]<shP[nH-2]) && (nL>=2&&slP[nL-1]<slP[nL-2]);
   }

   bool CheckLiqSweep(bool isBull,
                       const int &shB[], const double &shP[], int nH,
                       const int &slB[], const double &slP[], int nL,
                       const double &h[], const double &l[],
                       const double &c[], int sz) {
      int lb = m_sweepLB;   // fix25: configurable (default=obLB=150)
      if(!isBull) {
         for(int i=nH-1;i>=MathMax(0,nH-5);i--) {
            int sb=shB[i]; double bsl=shP[i];
            for(int b=1;b<MathMin(sb,lb);b++)
               if(h[b]>bsl && c[b]<bsl) return true;
         }
      } else {
         for(int i=nL-1;i>=MathMax(0,nL-5);i--) {
            int sb=slB[i]; double ssl=slP[i];
            for(int b=1;b<MathMin(sb,lb);b++)
               if(l[b]<ssl && c[b]>ssl) return true;
         }
      }
      return false;
   }

   bool FindW(const int &slB[], const double &slP[], int nL,
              const double &h[], const double &l[], const datetime &t[], int sz,
              double tolPx, PatternABC &pat) {
      int w23s=MathMax(0,sz-m_w23LB);
      int wB[]; double wP[]; int wn=0;
      ArrayResize(wB,0); ArrayResize(wP,0);
      for(int i=0;i<nL;i++)
         if(slB[i]>=w23s){ArrayResize(wB,wn+1);ArrayResize(wP,wn+1);wB[wn]=slB[i];wP[wn]=slP[i];wn++;}
      for(int j=wn-1;j>=1&&!pat.valid;j--)
         for(int i=j-1;i>=0&&!pat.valid;i--)
            if(MathAbs(wP[i]-wP[j])<=tolPx) {
               bool isW3=false;
               for(int k=i-1;k>=0&&!isW3;k--)
                  if(MathAbs(wP[k]-wP[i])<=tolPx&&MathAbs(wP[k]-wP[j])<=tolPx&&wB[k]<wB[i]) {
                     double neck=0; for(int b=wB[k];b<=wB[j];b++) neck=MathMax(neck,h[b]);
                     pat.valid=true;pat.isBull=true;pat.patType=PAT_W3;
                     pat.aPx=wP[k];pat.tA=t[wB[k]];pat.bPx=neck;pat.tB=t[wB[j]];
                     pat.cPx=wP[j];pat.tC=t[wB[j]];isW3=true;
                  }
               if(!isW3) {
                  double neck=0; for(int b=wB[i];b<=wB[j];b++) neck=MathMax(neck,h[b]);
                  pat.valid=true;pat.isBull=true;pat.patType=PAT_W2;
                  pat.aPx=wP[i];pat.tA=t[wB[i]];pat.bPx=neck;pat.tB=t[wB[j]];
                  pat.cPx=wP[j];pat.tC=t[wB[j]];
               }
            }
      return pat.valid;
   }

   bool FindM(const int &shB[], const double &shP[], int nH,
              const double &h[], const double &l[], const datetime &t[], int sz,
              double tolPx, PatternABC &pat) {
      int w23s=MathMax(0,sz-m_w23LB);
      int mB[]; double mP[]; int mn=0;
      ArrayResize(mB,0); ArrayResize(mP,0);
      for(int i=0;i<nH;i++)
         if(shB[i]>=w23s){ArrayResize(mB,mn+1);ArrayResize(mP,mn+1);mB[mn]=shB[i];mP[mn]=shP[i];mn++;}
      for(int j=mn-1;j>=1&&!pat.valid;j--)
         for(int i=j-1;i>=0&&!pat.valid;i--)
            if(MathAbs(mP[i]-mP[j])<=tolPx) {
               bool isM3=false;
               for(int k=i-1;k>=0&&!isM3;k--)
                  if(MathAbs(mP[k]-mP[i])<=tolPx&&MathAbs(mP[k]-mP[j])<=tolPx&&mB[k]<mB[i]) {
                     double neck=1e10; for(int b=mB[k];b<=mB[j];b++) neck=MathMin(neck,l[b]);
                     pat.valid=true;pat.isBull=false;pat.patType=PAT_M3;
                     pat.aPx=mP[k];pat.tA=t[mB[k]];pat.bPx=neck;pat.tB=t[mB[j]];
                     pat.cPx=mP[j];pat.tC=t[mB[j]];isM3=true;
                  }
               if(!isM3) {
                  double neck=1e10; for(int b=mB[i];b<=mB[j];b++) neck=MathMin(neck,l[b]);
                  pat.valid=true;pat.isBull=false;pat.patType=PAT_M2;
                  pat.aPx=mP[i];pat.tA=t[mB[i]];pat.bPx=neck;pat.tB=t[mB[j]];
                  pat.cPx=mP[j];pat.tC=t[mB[j]];
               }
            }
      return pat.valid;
   }

   double FindOBSL(bool isBull,
                   const int &shB[], const double &shP[], int nH,
                   const int &slB[], const double &slP[], int nL,
                   const double &h[], const double &l[],
                   const double &o[], const double &c[], int sz) {
      int obStart=MathMax(m_swingLB+1,sz-m_obLB);
      double obSL=0.0;
      if(isBull) {
         for(int i=nL-1;i>=0&&obSL==0;i--) {
            int sb=slB[i]; if(sb<obStart+2) continue;
            double bigBody=0; int bigBar=-1;
            for(int b=MathMax(obStart,sb-m_zoneBase*3);b<sb;b++)
               if(c[b]<o[b]){double bd=o[b]-c[b];if(bd>bigBody){bigBody=bd;bigBar=b;}}
            if(bigBar<0) continue;
            bool broken=false;
            for(int b=sb+1;b<sz;b++) if(c[b]<l[bigBar]){broken=true;break;}
            if(!broken) obSL=l[bigBar];
         }
         if(obSL<=0&&nL>=1) obSL=slP[nL-1];
      } else {
         for(int i=nH-1;i>=0&&obSL==0;i--) {
            int sb=shB[i]; if(sb<obStart+2) continue;
            double bigBody=0; int bigBar=-1;
            for(int b=MathMax(obStart,sb-m_zoneBase*3);b<sb;b++)
               if(c[b]>o[b]){double bd=c[b]-o[b];if(bd>bigBody){bigBody=bd;bigBar=b;}}
            if(bigBar<0) continue;
            bool broken=false;
            for(int b=sb+1;b<sz;b++) if(c[b]>h[bigBar]){broken=true;break;}
            if(!broken) obSL=h[bigBar];
         }
         if(obSL<=0&&nH>=1) obSL=shP[nH-1];
      }
      return obSL;
   }

   //--- fix22: BOS-Retest scan — fallback เมื่อ W/M ไม่เจอ
   // ใช้ BOS (structural break) level + FVG retest แทน W/M neckline
   bool ScanBOSRetest(const string sym, ZoneResult &res,
                      const int &shB[], const double &shP[], int nH,
                      const int &slB[], const double &slP[], int nL,
                      const double &h[], const double &l[],
                      const double &o[], const double &c[],
                      const datetime &t[], int sz, double atr) {
      if(nH < 2 || nL < 2) return false;

      // หา BOS ล่าสุด: HH = bull BOS, LL = bear BOS
      bool bullBOS = (shP[nH-1] > shP[nH-2]);  // ทำ HH
      bool bearBOS = (slP[nL-1] < slP[nL-2]);  // ทำ LL
      if(!bullBOS && !bearBOS) return false;

      // ถ้าเจอทั้งคู่ เลือก BOS ล่าสุด (bar index น้อยกว่า = ล่าสุดกว่า)
      bool bosIsBull;
      if(bullBOS && bearBOS)
         bosIsBull = (shB[nH-1] < slB[nL-1]);
      else
         bosIsBull = bullBOS;

      // คำนวณ impulse range และ zone
      double impulseHi, impulseLo;
      int    refBar;
      double bosLevel;
      if(bosIsBull) {
         bosLevel   = shP[nH-2];          // level ที่ถูก break
         impulseHi  = shP[nH-1];
         impulseLo  = (nL >= 1) ? slP[nL-1] : shP[nH-1] - atr * 5;
         refBar     = shB[nH-1];
      } else {
         bosLevel   = slP[nL-2];          // level ที่ถูก break
         impulseLo  = slP[nL-1];
         impulseHi  = (nH >= 1) ? shP[nH-1] : slP[nL-1] + atr * 5;
         refBar     = slB[nL-1];
      }

      double range = impulseHi - impulseLo;
      if(range <= atr * 0.5) return false;  // impulse เล็กเกินไป

      // Zone: 50–61.8% retracement ของ impulse
      double r500, r618;
      if(bosIsBull) {
         r500 = impulseHi - range * 0.5;
         r618 = impulseHi - range * 0.618;
      } else {
         r500 = impulseLo + range * 0.5;
         r618 = impulseLo + range * 0.618;
      }
      double zHi = bosIsBull ? r500 : r618;
      double zLo = bosIsBull ? r618 : r500;

      // หา FVG ใน zone หรือใกล้ BOS level
      double fvgHi = 0, fvgLo = 0;
      double prox  = atr * 1.5;  // wider proximity สำหรับ BOS-Retest
      int bCnt = 0, rCnt = 0;

      for(int i = 1; i < sz - 2 && (bCnt < m_maxFVG || rCnt < m_maxFVG); i++) {
         if(bosIsBull && bCnt < m_maxFVG && l[i] > h[i+2]) {
            double fH = l[i], fL = h[i+2];
            bool filled = false;
            for(int b = i-1; b >= 1; b--) if(l[b] <= fL) { filled=true; break; }
            if(!filled) {
               bool inZone  = (fL <= zHi && fH >= zLo);
               bool nearBOS = (fL <= bosLevel + prox && fH >= bosLevel - prox);
               if((inZone || nearBOS) && fvgHi == 0) { fvgHi = fH; fvgLo = fL; }
            }
            bCnt++;
         }
         if(!bosIsBull && rCnt < m_maxFVG && h[i] < l[i+2]) {
            double fH = l[i+2], fL = h[i];
            bool filled = false;
            for(int b = i-1; b >= 1; b--) if(h[b] >= fH) { filled=true; break; }
            if(!filled) {
               bool inZone  = (fH >= zLo && fL <= zHi);
               bool nearBOS = (fH >= bosLevel - prox && fL <= bosLevel + prox);
               if((inZone || nearBOS) && fvgHi == 0) { fvgHi = fH; fvgLo = fL; }
            }
            rCnt++;
         }
      }
      if(fvgHi <= 0 || fvgLo <= 0) { m_diagFailFVG++; return false; }

      // ราคาต้องอยู่ใน pull-back zone (ไม่ใช่ breakout ไปไกลแล้ว)
      double curC = c[1];
      bool approaching = bosIsBull ?
         (curC >= fvgLo && curC <= impulseHi) :
         (curC <= fvgHi && curC >= impulseLo);
      if(!approaching) { m_diagFailZone++; return false; }

      // direction check
      if( bosIsBull && curC < fvgLo) { m_diagFailZone++; return false; }
      if(!bosIsBull && curC > fvgHi) { m_diagFailZone++; return false; }

      // OB SL
      double obSL = FindOBSL(bosIsBull, shB, shP, nH, slB, slP, nL, h, l, o, c, sz);
      if(obSL <= 0) { m_diagFailOB++; return false; }

      res.valid     = true;
      res.isBull    = bosIsBull;
      res.zHi       = zHi;    res.zLo      = zLo;
      res.fvgHi     = fvgHi;  res.fvgLo    = fvgLo;
      res.obSL      = obSL;
      res.tZoneFrom = t[MathMin(refBar, sz-1)];
      return true;
   }

public:
   // fix22+fix23: DIAG breakdown counters (public สำหรับ main EA อ่านได้)
   int m_diagFailSwing;   // nH/nL < 2 หลัง FindSwings
   int m_diagFailData;    // fix23: CopyHigh/Low/Open/Close/Time fail
   int m_diagFailBOS;     // bosFound && chochFound = false
   int m_diagFailWM;      // W/M pattern ไม่เจอ
   int m_diagFailGate;    // fix23: strictCHoCH/reqTrend/reqSweep fail
   int m_diagFailAC;      // fix23: AC<=0 (zone range invalid)
   int m_diagFailFVG;     // FVG ไม่เจอหรือไม่ใน zone
   int m_diagFailZone;    // ราคาไม่อยู่ใน zone / wrong direction
   int m_diagFailOB;      // OB SL หาไม่เจอ
   int m_diagBOSRetestOK; // BOS-Retest สำเร็จ (นับแยก)

   void ResetDiag() {
      m_diagFailSwing=0; m_diagFailData=0; m_diagFailBOS=0;
      m_diagFailWM=0;    m_diagFailGate=0; m_diagFailAC=0;
      m_diagFailFVG=0;   m_diagFailZone=0; m_diagFailOB=0;
      m_diagBOSRetestOK=0;
   }

   CSMCScanner() {
      m_sm=NULL;
      SetParams(SWING_LB_DEF,W23_TOL_DEF,W23_LB_DEF,FVG_LB_DEF,MAX_FVG_DEF,OB_LB_DEF,ZONE_BASE_DEF);
      m_reqTrend=false; m_reqSweep=false; m_strictCHoCH=false;
      m_useBOSRetest=false;
      m_sweepLB=OB_LB_DEF;  // fix25: default = OB_LB_DEF (150)
      ResetDiag();
   }
   void SetSymbolManager(CSymbolManager* sm) { m_sm=sm; }
   void SetParams(int swingLB, int w23Tol, int w23LB, int fvgLB, int maxFVG, int obLB, int zoneBase,
                  bool reqTrend=false, bool reqSweep=false, bool strictCHoCH=false) {
      m_swingLB=swingLB; m_w23Tol=w23Tol; m_w23LB=w23LB;
      m_fvgLB=fvgLB; m_maxFVG=maxFVG; m_obLB=obLB; m_zoneBase=zoneBase;
      m_reqTrend=reqTrend; m_reqSweep=reqSweep; m_strictCHoCH=strictCHoCH;
   }
   void SetBOSRetest(bool v) { m_useBOSRetest = v; } // fix22
   void SetSweepLB(int lb)  { m_sweepLB = (lb>0)?lb:OB_LB_DEF; } // fix25

   //--- fix15: เพิ่ม tf parameter (default PERIOD_CURRENT = backward compatible)
   bool Scan(const string sym, ZoneResult &res, ENUM_TIMEFRAMES tf=PERIOD_CURRENT) {
      ZeroMemory(res); res.valid=false;

      int bars=iBars(sym,tf);
      if(bars<m_swingLB*2+20) { m_diagFailSwing++; return false; }

      int N=MathMin(bars,MathMax(m_w23LB,m_fvgLB)+m_swingLB+10);
      double h[],l[],o[],c[]; datetime t[];
      if(CopyHigh (sym,tf,0,N,h)<=0) { m_diagFailData++; return false; } // fix23
      if(CopyLow  (sym,tf,0,N,l)<=0) { m_diagFailData++; return false; }
      if(CopyOpen (sym,tf,0,N,o)<=0) { m_diagFailData++; return false; }
      if(CopyClose(sym,tf,0,N,c)<=0) { m_diagFailData++; return false; }
      if(CopyTime (sym,tf,0,N,t)<=0) { m_diagFailData++; return false; }
      ArraySetAsSeries(h,true);ArraySetAsSeries(l,true);
      ArraySetAsSeries(o,true);ArraySetAsSeries(c,true);ArraySetAsSeries(t,true);
      int sz=ArraySize(h);

      double atr=CalcATR(h,l,sz); if(atr<=0) atr=1.0;

      int shB[],slB[]; double shP[],slP[]; int nH=0,nL=0;
      FindSwings(h,l,sz,shB,shP,nH,slB,slP,nL);
      if(nH<2||nL<2) { m_diagFailSwing++; return false; }

      double lastBOS=0,lastCHoCH=0; bool bosFound=false,chochFound=false;
      double tolPx=atr*m_w23Tol/100.0;
      for(int i=nH-1;i>=1;i--) if(shP[i]>shP[i-1]){lastBOS=shP[i-1];bosFound=true;break;}
      for(int i=nL-1;i>=1;i--) if(slP[i]<slP[i-1]){lastCHoCH=slP[i-1];chochFound=true;break;}
      if(!bosFound&&!chochFound) { m_diagFailBOS++; return false; }

      PatternABC pat; ZeroMemory(pat);
      bool found=FindW(slB,slP,nL,h,l,t,sz,tolPx,pat);
      if(!found) found=FindM(shB,shP,nH,h,l,t,sz,tolPx,pat);

      if(!found||!pat.valid) {
         m_diagFailWM++;
         // fix22: BOS-Retest fallback
         if(m_useBOSRetest) {
            if(!ScanBOSRetest(sym, res, shB, shP, nH, slB, slP, nL, h, l, o, c, t, sz, atr))
               return false;
            // ยังต้องผ่าน gate filters
            if(m_reqTrend  && !CheckStrictTrend(res.isBull, shP, nH, slP, nL)) return false;
            if(m_reqSweep  && !CheckLiqSweep(res.isBull, shB, shP, nH, slB, slP, nL, h, l, c, sz)) return false;
            m_diagBOSRetestOK++;
            return true;
         }
         return false;
      }

      if(m_strictCHoCH) {
         if( pat.isBull&&!bosFound)   { m_diagFailGate++; return false; } // fix23
         if(!pat.isBull&&!chochFound) { m_diagFailGate++; return false; }
      }
      if(m_reqTrend && !CheckStrictTrend(pat.isBull,shP,nH,slP,nL)) { m_diagFailGate++; return false; }
      if(m_reqSweep && !CheckLiqSweep(pat.isBull,shB,shP,nH,slB,slP,nL,h,l,c,sz)) { m_diagFailGate++; return false; }

      double neckPx=pat.bPx,AC,r500,r618;
      if(pat.isBull){AC=neckPx-pat.aPx;r500=neckPx-AC*0.5;r618=neckPx-AC*0.618;}
      else          {AC=pat.aPx-neckPx;r500=neckPx+AC*0.5;r618=neckPx+AC*0.618;}
      if(AC<=0) { m_diagFailAC++; return false; } // fix23
      double zHi=pat.isBull?r500:r618, zLo=pat.isBull?r618:r500;

      double fvgHi=0,fvgLo=0,prox=atr*0.5; int bCnt=0,rCnt=0;
      for(int i=1;i<sz-2&&(bCnt<m_maxFVG||rCnt<m_maxFVG);i++) {
         if(bCnt<m_maxFVG&&l[i]>h[i+2]) {
            double fH=l[i],fL=h[i+2]; bool filled=false;
            for(int b=i-1;b>=1;b--) if(l[b]<=fL){filled=true;break;}
            if(!filled&&bosFound) {
               bool nr=(lastBOS>0&&fL<=lastBOS+prox&&fH>=lastBOS-prox);
               if(nr&&fvgHi==0&&fL<=zHi&&fH>=zLo){fvgHi=fH;fvgLo=fL;}
            }
            bCnt++;
         }
         if(rCnt<m_maxFVG&&h[i]<l[i+2]) {
            double fH=l[i+2],fL=h[i]; bool filled=false;
            for(int b=i-1;b>=1;b--) if(h[b]>=fH){filled=true;break;}
            if(!filled&&chochFound) {
               bool nr=(lastCHoCH>0&&fL<=lastCHoCH+prox&&fH>=lastCHoCH-prox);
               if(nr&&fvgHi==0&&fH>=zLo&&fL<=zHi){fvgHi=fH;fvgLo=fL;}
            }
            rCnt++;
         }
      }
      if(fvgHi<=0||fvgLo<=0) { m_diagFailFVG++; return false; }

      double curC=c[1];
      bool fvgInZone=(fvgLo<=zHi&&fvgHi>=zLo);
      bool cInZone=pat.isBull?(curC>=zLo&&curC<=zHi):(curC<=zHi&&curC>=zLo);
      if(!fvgInZone&&!cInZone) { m_diagFailZone++; return false; }
      if( pat.isBull&&curC<fvgLo) { m_diagFailZone++; return false; }
      if(!pat.isBull&&curC>fvgHi) { m_diagFailZone++; return false; }

      double obSL=FindOBSL(pat.isBull,shB,shP,nH,slB,slP,nL,h,l,o,c,sz);
      if(obSL<=0) { m_diagFailOB++; return false; }

      res.valid=true; res.isBull=pat.isBull;
      res.zHi=zHi; res.zLo=zLo;
      res.fvgHi=fvgHi; res.fvgLo=fvgLo;
      res.obSL=obSL; res.tZoneFrom=pat.tB;
      return true;
   }

   //--- fix15: เพิ่ม tf parameter
   static bool CalcEntry(const string sym, const ZoneResult &z, double atr,
                          double &entryPx, double &initSL, double &oneR, double &tp,
                          bool &isBull, double simTP_R,
                          ENUM_TIMEFRAMES tf=PERIOD_CURRENT) {
      isBull = z.isBull;
      double curC = iClose(sym, tf, 1);
      double distHi=MathAbs(curC-z.fvgHi), distLo=MathAbs(curC-z.fvgLo);
      entryPx=(distHi<=distLo)?z.fvgHi:z.fvgLo;
      initSL=isBull?z.obSL-atr*0.1:z.obSL+atr*0.1;
      oneR=MathAbs(entryPx-initSL);
      if(oneR<=atr*0.1) return false;
      if( isBull&&initSL>=entryPx) return false;
      if(!isBull&&initSL<=entryPx) return false;
      tp=isBull?entryPx+oneR*simTP_R:entryPx-oneR*simTP_R;
      return true;
   }
};

#endif
