# -*- coding: utf-8 -*-
"""
FTMO Config Comparison — 6 configs, pick best
"""
import sys, io, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

HISTDATA_DIR   = Path(r"c:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\raw\HISTDATA_COM_MT_XAUUSD")
DATE_START     = "2025-04-17"
DATE_END       = "2026-04-17"
INITIAL_EQUITY = 50_000.0
RISK_PCT       = 0.01
FTMO_TARGET    =  0.10
FTMO_MAX_DAILY = -0.05
FTMO_MAX_TOTAL = -0.10
FTMO_MIN_DAYS  =  4
INTERNAL_DAILY = -0.02
INTERNAL_TOTAL = -0.08
PROFIT_LOCK    =  0.12
ATR_W = 14; SC_W = 100; HOLD = 30

CONFIGS = [
    # Best config from previous test + 10-year validation
    ("M30 RSI35 All3 [BEST]", "30min", 35, 65, [("Asian","07:00","08:00"),("London","14:00","15:00"),("NY_Open","20:30","21:00")]),
    ("M30 RSI35 All3 10yr",   "30min", 35, 65, [("Asian","07:00","08:00"),("London","14:00","15:00"),("NY_Open","20:30","21:00")]),
]

# ── INDICATORS ────────────────────────────────────────────────────────────────
def calc_sc100(returns):
    return pd.Series(np.sign(returns)).rolling(SC_W).apply(
        lambda x: (x[1:] != x[:-1]).sum() / (SC_W-1), raw=True).values

def calc_rsi(close, p=20):
    d = np.diff(close, prepend=np.nan)
    g = pd.Series(np.where(d>0,d,0.0)).ewm(com=p-1,min_periods=p).mean().values
    l = pd.Series(np.where(d<0,-d,0.0)).ewm(com=p-1,min_periods=p).mean().values
    return 100 - (100/(1+g/(l+1e-9)))

def build(df):
    c = df["CLOSE"].values
    r = np.diff(c,prepend=np.nan)/(c+1e-9)
    df["SC100"] = calc_sc100(r)
    df["ATR"]   = pd.Series(df["HIGH"].values-df["LOW"].values).rolling(ATR_W).mean().values
    df["RSI"]   = calc_rsi(c)
    df["SMA50"] = pd.Series(c).rolling(50).mean().values
    sc = df["SC100"].values
    df["REGIME"] = np.where(np.isnan(sc),"UNKNOWN",
                   np.where(sc<0.22,"CRASH",
                   np.where(sc<0.25,"TRENDING",
                   np.where(sc<=0.35,"WEAK","REVERTING"))))
    return df

def resample(df, rule):
    return df.resample(rule).agg({"OPEN":"first","HIGH":"max","LOW":"min","CLOSE":"last","TICKVOL":"sum"}).dropna()

# ── BACKTEST ──────────────────────────────────────────────────────────────────
def run(df_sess, rsi_os, rsi_ob, sl_m=0.5, tp_m=4.0):
    df = df_sess.dropna(subset=["ATR","SC100","RSI","SMA50"]).reset_index(drop=False)
    n  = len(df)
    if n < HOLD+10: return pd.DataFrame(), {}

    close=df["CLOSE"].values; high=df["HIGH"].values; low=df["LOW"].values
    atr=df["ATR"].values; rsi=df["RSI"].values; sma=df["SMA50"].values
    regime=df["REGIME"].values; times=pd.to_datetime(df["datetime"].values)
    sess_col=df["session"].values if "session" in df.columns else [""]*n

    equity=INITIAL_EQUITY; skip=0; log=[]; daily={}; active_days=set()
    passed=failed=False; reason=""

    for i in range(n-HOLD):
        if i < skip: continue
        pct = (equity-INITIAL_EQUITY)/INITIAL_EQUITY
        if pct >= PROFIT_LOCK and not passed: passed=True; reason=f"PASSED trade#{len(log)+1} {times[i].date()}"; break
        if pct <= FTMO_MAX_TOTAL: failed=True; reason=f"FAILED max-loss {times[i].date()}"; break
        d = times[i].date()
        if d not in daily: daily[d]={"start":equity,"pnl":0.0}
        day=daily[d]
        if day["pnl"]/INITIAL_EQUITY <= INTERNAL_DAILY: continue
        if day["pnl"]/day["start"] <= FTMO_MAX_DAILY: continue
        if pct <= INTERNAL_TOTAL: continue
        if regime[i]!="REVERTING": continue
        if np.isnan(atr[i]) or np.isnan(rsi[i]) or np.isnan(sma[i]) or atr[i]<=0: continue
        is_l = rsi[i]<rsi_os and close[i]<sma[i]
        is_s = rsi[i]>rsi_ob and close[i]>sma[i]
        if not(is_l or is_s): continue
        sl=atr[i]*sl_m; tp=atr[i]*tp_m
        risk=equity*RISK_PCT; reward=risk*(tp/sl)
        if (day["pnl"]-risk)/day["start"] < FTMO_MAX_DAILY: continue
        fh=high[i+1:i+1+HOLD]; fl=low[i+1:i+1+HOLD]
        if is_l:
            tp_b=np.where(fh>=close[i]+tp)[0]; sl_b=np.where(fl<=close[i]-sl)[0]
        else:
            tp_b=np.where(fl<=close[i]-tp)[0]; sl_b=np.where(fh>=close[i]+sl)[0]
        tp_i=tp_b[0] if len(tp_b) else HOLD+1
        sl_i=sl_b[0] if len(sl_b) else HOLD+1
        if   tp_i<sl_i: pnl=+reward; exit_b=i+1+tp_i; res="WIN"
        elif sl_i<tp_i: pnl=-risk;   exit_b=i+1+sl_i; res="LOSS"
        else: continue
        equity+=pnl; day["pnl"]+=pnl; skip=exit_b+1; active_days.add(str(d))
        log.append({"date":str(d),"time":times[i].strftime("%H:%M"),"session":sess_col[i],
                    "dir":"LONG" if is_l else "SHORT","pnl":round(pnl,2),
                    "result":res,"equity":round(equity,2)})

    tdf = pd.DataFrame(log)
    chall = {"passed":passed,"failed":failed,"reason":reason,"days":len(active_days)}
    return tdf, chall

# ── LOAD ─────────────────────────────────────────────────────────────────────
t0=time.time()
print("Loading data...")
files=[pd.read_csv(f,header=None,names=["DATE","TIME","OPEN","HIGH","LOW","CLOSE","TICKVOL"])
       for f in sorted(HISTDATA_DIR.glob("DAT_MT_XAUUSD_M1_*.csv"))]
raw=pd.concat(files,ignore_index=True)
raw["datetime"]=pd.to_datetime(raw["DATE"].astype(str)+" "+raw["TIME"].astype(str))
raw=raw.set_index("datetime").sort_index()[["OPEN","HIGH","LOW","CLOSE","TICKVOL"]].loc[DATE_START:DATE_END]
print(f"  {len(raw):,} bars  ({time.time()-t0:.1f}s)")

# ── RUN ALL CONFIGS ───────────────────────────────────────────────────────────
results=[]
equity_curves={}

for cfg_name, tf, rsi_os, rsi_ob, sessions in CONFIGS:
    df_tf = build(raw.copy() if tf=="1min" else resample(raw, tf))
    df_tf["time_str"]=df_tf.index.strftime("%H:%M")
    frames=[]
    for sname,t0s,t1s in sessions:
        sub=df_tf[(df_tf["time_str"]>=t0s)&(df_tf["time_str"]<=t1s)].copy()
        sub["session"]=sname; frames.append(sub)
    df_sess=pd.concat(frames).sort_index()

    tdf, chall = run(df_sess, rsi_os, rsi_ob)
    if len(tdf)==0:
        results.append({"Config":cfg_name,"Trades":0,"Net":0,"WR":0,"PF":0,"MaxDD":0,"Days":0,"Status":"NoTrades","Reason":""})
        continue

    wins  = (tdf["pnl"]>0).sum()
    wr    = wins/len(tdf)*100
    gp    = tdf[tdf["pnl"]>0]["pnl"].sum()
    gl    = tdf[tdf["pnl"]<0]["pnl"].abs().sum()
    pf    = gp/(gl+1e-9)
    net   = tdf["pnl"].sum()
    net_p = net/INITIAL_EQUITY*100
    max_dd= (tdf["equity"].cummax()-tdf["equity"]).max()
    dd_p  = max_dd/INITIAL_EQUITY*100
    max_daily = tdf.groupby("date")["pnl"].sum().min()
    max_d_p   = max_daily/INITIAL_EQUITY*100
    status = "PASS" if (chall["passed"] and not chall["failed"]) else ("FAIL" if chall["failed"] else "IN-PROG")

    # estimate months to pass (from monthly avg)
    tdf["month"]=pd.to_datetime(tdf["date"]).dt.to_period("M").astype(str)
    monthly_net = tdf.groupby("month")["pnl"].sum()
    avg_mo = monthly_net.mean() if len(monthly_net) else 0
    est_months = round(5000/avg_mo, 1) if avg_mo > 0 else 99

    results.append({
        "Config": cfg_name, "Trades": len(tdf),
        "Net_pct": round(net_p,1), "WR": round(wr,1), "PF": round(pf,2),
        "MaxDD_pct": round(dd_p,1), "MaxDaily_pct": round(max_d_p,1),
        "TradeDays": chall["days"], "Status": status,
        "Est_months": est_months,
        "Reason": chall["reason"]
    })
    equity_curves[cfg_name]=tdf["equity"].values

# ── PRINT ─────────────────────────────────────────────────────────────────────
sdf=pd.DataFrame(results)
print(f"\n{'='*80}")
print("CONFIG COMPARISON")
print('='*80)
print(sdf[["Config","Trades","Net_pct","WR","PF","MaxDD_pct","MaxDaily_pct","TradeDays","Status","Est_months"]].to_string(index=False))

print(f"\nDetails:")
for _, r in sdf.iterrows():
    if r.Reason: print(f"  {r.Config:<28} → {r.Reason}")

# Recommendation
passed = sdf[sdf["Status"]=="PASS"].copy()
if len(passed):
    best = passed.sort_values(["Est_months","MaxDD_pct"]).iloc[0]
    print(f"\n{'='*80}")
    print(f"RECOMMENDED: {best.Config}")
    print(f"  Trades={best.Trades}  Net={best.Net_pct}%  WR={best.WR}%  PF={best.PF}")
    print(f"  MaxDD={best.MaxDD_pct}%  MaxDaily={best.MaxDaily_pct}%  Est={best.Est_months} months")

# ── CHART ─────────────────────────────────────────────────────────────────────
fig, axes = plt.subplots(2, 3, figsize=(16,10))
fig.suptitle(f"FTMO Config Comparison | XAUUSD | {DATE_START} to {DATE_END}", fontsize=12, fontweight="bold")
axes=axes.flatten()

for idx, (cfg_name,*_) in enumerate(CONFIGS):
    ax=axes[idx]
    row=sdf[sdf["Config"]==cfg_name].iloc[0]
    if cfg_name in equity_curves:
        eq=equity_curves[cfg_name]
        color="green" if row.Status=="PASS" else ("red" if row.Status=="FAIL" else "orange")
        ax.plot(range(len(eq)), eq, linewidth=1.2, color=color)
        ax.axhline(INITIAL_EQUITY,            color="gray",  linestyle="--", alpha=0.5, linewidth=0.8)
        ax.axhline(INITIAL_EQUITY*1.10,       color="green", linestyle="--", alpha=0.6, linewidth=0.8)
        ax.axhline(INITIAL_EQUITY*0.90,       color="red",   linestyle="--", alpha=0.6, linewidth=0.8)
        ax.fill_between(range(len(eq)), INITIAL_EQUITY, eq,
                        where=np.array(eq)>=INITIAL_EQUITY, alpha=0.15, color="green")
        ax.fill_between(range(len(eq)), INITIAL_EQUITY, eq,
                        where=np.array(eq)<INITIAL_EQUITY,  alpha=0.15, color="red")
    status_color = "green" if row.Status=="PASS" else ("red" if row.Status=="FAIL" else "gray")
    ax.set_title(
        f"{cfg_name}\nT={row.Trades} WR={row.WR}% PF={row.PF} DD={row.MaxDD_pct}%\n"
        f"Est={row.Est_months}mo  [{row.Status}]",
        fontsize=8, color=status_color)
    ax.set_xlabel("Trade #", fontsize=7); ax.set_ylabel("Equity", fontsize=7)
    ax.tick_params(labelsize=7)

plt.tight_layout()
out=Path(r"c:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\ftmo_configs.png")
plt.savefig(out, dpi=150, bbox_inches="tight")
print(f"\nChart: {out}")
sdf.to_csv(Path(r"c:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\ftmo_configs.csv"), index=False)
print(f"Total: {time.time()-t0:.1f}s  Done.")
