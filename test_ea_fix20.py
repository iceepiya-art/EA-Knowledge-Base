# -*- coding: utf-8 -*-
"""
EA fix20 Simulator — mirrors SMC_Universal_EA v3.0 fix20 logic
Tests against HISTDATA_COM_MT_XAUUSD

Logic replicated:
  REVERTING regime (SC100 > 0.35):
    LONG  = RSI(20) < 35  AND  close < SMA(50)  AND  counter-beta1
    SHORT = RSI(20) > 65  AND  close > SMA(50)  AND  counter-beta1
  TRENDING regime (SC100 < 0.25):
    LONG  = beta1 > 0  (momentum follow)
    SHORT = beta1 < 0
  WEAK/CRASH → skip

Sessions: Asian 07:00-08:00 | London 14:00-15:00 | NY 20:30-21:00
Friday block: >= 20:00
FTMO Swing: no daily limit | Total DD stop 8%
Risk: 1% equity per trade | SL=0.5xATR | TP=4xATR (RR 8:1)
"""

import sys, io, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

# ── EA FIX20 PARAMETERS (ตรงกับ Input ใน EA) ─────────────────────────────────
HISTDATA_DIR   = Path(r"c:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\raw\HISTDATA_COM_MT_XAUUSD")
DATE_START     = "2016-01-01"
DATE_END       = "2026-04-17"
TF_RULE        = "30min"       # M30

# SC100 Regime Gate
SC100_BARS     = 100
BETA1_BARS     = 50
SC100_CRASH    = 0.22
SC100_TREND    = 0.25
SC100_REVERT   = 0.35
# AutoThreshold for M30: factor = 1 - 0.05*ln(30) = 0.830
AUTO_FACTOR    = 1.0 - 0.05 * np.log(30)
SC100_CRASH_M30  = round(SC100_CRASH  * AUTO_FACTOR, 3)
SC100_TREND_M30  = round(SC100_TREND  * AUTO_FACTOR, 3)
SC100_REVERT_M30 = round(SC100_REVERT * AUTO_FACTOR, 3)

# RSI+SMA Confirm (fix20)
RSI_PERIOD     = 20
SMA_PERIOD     = 50
RSI_OS         = 35.0
RSI_OB         = 65.0

# ATR
ATR_PERIOD     = 14
SL_MULT        = 0.5
TP_MULT        = 4.0
HOLD_BARS      = 30

# Money
INITIAL_EQUITY = 50_000.0
RISK_PCT       = 0.01

# FTMO Swing
SWING_MODE     = True           # ไม่มี daily limit
TOTAL_DD_STOP  = 0.08           # 8% internal stop
FTMO_TARGET    = 0.10           # 10%
FTMO_MAX_TOTAL = 0.10

# Sessions (HHMM)
SESSIONS = [
    ("Asian",   "07:00", "08:00"),
    ("London",  "14:00", "15:00"),
    ("NY_Open", "20:30", "21:00"),
]
FRIDAY_BLOCK_HOUR = 20

# ── INDICATORS ────────────────────────────────────────────────────────────────
def calc_sc100(returns, n=100):
    return pd.Series(np.sign(returns)).rolling(n).apply(
        lambda x: (x[1:] != x[:-1]).sum() / (n-1), raw=True).values

def calc_beta1(returns, n=50):
    def ols_slope(y):
        y = y[~np.isnan(y)]
        if len(y) < 5: return np.nan
        x = np.arange(len(y), dtype=float)
        xm, ym = x.mean(), y.mean()
        denom = ((x - xm)**2).sum()
        return ((x-xm)*(y-ym)).sum() / denom if denom > 1e-10 else 0.0
    return pd.Series(returns).rolling(n).apply(ols_slope, raw=True).values

def calc_rsi_wilder(close, period=20):
    delta = np.diff(close, prepend=np.nan)
    gain  = np.where(delta > 0, delta, 0.0)
    loss  = np.where(delta < 0, -delta, 0.0)
    ag = pd.Series(gain).ewm(com=period-1, min_periods=period).mean().values
    al = pd.Series(loss).ewm(com=period-1, min_periods=period).mean().values
    return 100 - (100 / (1 + ag / (al + 1e-9)))

def classify_regime(sc):
    if np.isnan(sc):           return "UNKNOWN"
    if sc < SC100_CRASH_M30:   return "CRASH"
    if sc < SC100_TREND_M30:   return "TRENDING"
    if sc < SC100_REVERT_M30:  return "WEAK"
    return "REVERTING"

def resample_ohlcv(df, rule):
    return df.resample(rule).agg(
        {"OPEN":"first","HIGH":"max","LOW":"min","CLOSE":"last","TICKVOL":"sum"}
    ).dropna()

def build_indicators(df):
    c = df["CLOSE"].values
    r = np.diff(c, prepend=np.nan) / (c + 1e-9)
    df["SC100"]  = calc_sc100(r, SC100_BARS)
    df["BETA1"]  = calc_beta1(r, BETA1_BARS)
    df["ATR"]    = pd.Series(df["HIGH"].values - df["LOW"].values).rolling(ATR_PERIOD).mean().values
    df["RSI"]    = calc_rsi_wilder(c, RSI_PERIOD)
    df["SMA50"]  = pd.Series(c).rolling(SMA_PERIOD).mean().values
    df["REGIME"] = [classify_regime(s) for s in df["SC100"].values]
    return df

def is_session_allowed(t):
    dow  = t.weekday()  # 0=Mon .. 4=Fri .. 6=Sun
    if dow >= 5: return False, ""
    if dow == 4 and t.hour >= FRIDAY_BLOCK_HOUR: return False, ""
    hhmm = t.hour * 100 + t.minute
    for name, s, e in SESSIONS:
        si = int(s.replace(":",""))
        ei = int(e.replace(":",""))
        if si <= hhmm < ei:
            return True, name
    return False, ""

# ── EA SIGNAL LOGIC (mirrors ScanAllSymbols + RegimeFilter) ──────────────────
def get_signal(regime, sc100, beta1, rsi, close, sma):
    if regime in ("UNKNOWN", "WEAK", "CRASH"):
        return None

    if regime == "TRENDING":
        # follow beta1 (SMC trend direction proxy)
        if np.isnan(beta1): return None
        return "LONG" if beta1 > 0 else "SHORT"

    if regime == "REVERTING":
        # counter-beta1 + RSI+SMA confirm (fix20)
        if np.isnan(beta1) or np.isnan(rsi) or np.isnan(sma): return None
        counter_long  = (beta1 < 0) and (rsi < RSI_OS)  and (close < sma)
        counter_short = (beta1 > 0) and (rsi > RSI_OB)  and (close > sma)
        if counter_long:  return "LONG"
        if counter_short: return "SHORT"
    return None

# ── BACKTEST (FTMO cycle simulation) ─────────────────────────────────────────
# Fixed risk = 1% of INITIAL_EQUITY per trade (not compound)
# Stops when equity >= +10% PASS or <= -10% FAIL (FTMO cycle logic)
FIXED_RISK = INITIAL_EQUITY * RISK_PCT          # $500 per trade
FIXED_WIN  = FIXED_RISK * (TP_MULT / SL_MULT)  # $4000 per win
FTMO_PASS_EQ = INITIAL_EQUITY * (1 + FTMO_TARGET)       # $55,000
FTMO_FAIL_EQ = INITIAL_EQUITY * (1 - FTMO_MAX_TOTAL)    # $45,000
DD_STOP_EQ   = INITIAL_EQUITY * (1 - TOTAL_DD_STOP)     # $46,000

def backtest(df_sess):
    df = df_sess.dropna(subset=["ATR","SC100","BETA1","RSI","SMA50"]).reset_index(drop=False)
    n  = len(df)
    if n < HOLD_BARS + 10: return pd.DataFrame()

    close  = df["CLOSE"].values
    high   = df["HIGH"].values
    low    = df["LOW"].values
    atr    = df["ATR"].values
    times  = pd.to_datetime(df["datetime"].values)

    equity     = INITIAL_EQUITY
    skip_until = 0
    log        = []
    cycle_num  = 1
    cycle_start_eq = INITIAL_EQUITY
    active_days = set()

    for i in range(n - HOLD_BARS):
        if i < skip_until: continue

        # Internal DD stop (8%) before FTMO 10% limit
        if equity <= DD_STOP_EQ:
            print(f"  [Cycle {cycle_num}] DD Stop at {times[i].date()} eq={equity:.0f} | resetting to new cycle")
            cycle_num += 1
            equity = INITIAL_EQUITY
            cycle_start_eq = INITIAL_EQUITY
            active_days = set()

        # FTMO target reached — PASS
        if equity >= FTMO_PASS_EQ:
            days_traded = len(active_days)
            print(f"  [Cycle {cycle_num}] PASS at {times[i].date()} eq={equity:.0f} trades={sum(1 for x in log if x['cycle']==cycle_num)} days={days_traded}")
            cycle_num += 1
            equity = INITIAL_EQUITY
            cycle_start_eq = INITIAL_EQUITY
            active_days = set()

        # Session + Friday filter
        ok, sess_name = is_session_allowed(times[i])
        if not ok: continue

        if atr[i] <= 0: continue

        sig = get_signal(
            df["REGIME"].values[i], df["SC100"].values[i], df["BETA1"].values[i],
            df["RSI"].values[i], close[i], df["SMA50"].values[i]
        )
        if sig is None: continue

        sl = atr[i] * SL_MULT
        tp = atr[i] * TP_MULT
        risk_usd   = FIXED_RISK   # always $500 — fixed not compound
        reward_usd = FIXED_WIN    # always $4000

        fut_h = high[i+1:i+1+HOLD_BARS]
        fut_l = low[i+1:i+1+HOLD_BARS]

        if sig == "LONG":
            tp_b = np.where(fut_h >= close[i] + tp)[0]
            sl_b = np.where(fut_l <= close[i] - sl)[0]
        else:
            tp_b = np.where(fut_l <= close[i] - tp)[0]
            sl_b = np.where(fut_h >= close[i] + sl)[0]

        tp_i = tp_b[0] if len(tp_b) else HOLD_BARS + 1
        sl_i = sl_b[0] if len(sl_b) else HOLD_BARS + 1

        if   tp_i < sl_i: pnl = +reward_usd; exit_b = i+1+tp_i; res = "WIN"
        elif sl_i < tp_i: pnl = -risk_usd;   exit_b = i+1+sl_i; res = "LOSS"
        else: continue

        equity    += pnl
        skip_until = exit_b + 1
        d = str(times[i].date())
        active_days.add(d)
        log.append({
            "date":    d,
            "time":    times[i].strftime("%H:%M"),
            "cycle":   cycle_num,
            "session": sess_name,
            "regime":  df["REGIME"].values[i],
            "dir":     sig,
            "rsi":     round(df["RSI"].values[i], 1),
            "beta1":   round(df["BETA1"].values[i] * 1e6, 2),
            "sc100":   round(df["SC100"].values[i], 3),
            "sl":      round(sl, 2),
            "tp":      round(tp, 2),
            "risk":    round(risk_usd, 2),
            "pnl":     round(pnl, 2),
            "result":  res,
            "cycle_eq": round(equity, 2),
        })

    return pd.DataFrame(log)

# ── LOAD ─────────────────────────────────────────────────────────────────────
t0 = time.time()
print(f"Loading {DATE_START} to {DATE_END}...")
files  = sorted(HISTDATA_DIR.glob("DAT_MT_XAUUSD_M1_*.csv"))
frames = [pd.read_csv(f, header=None,
          names=["DATE","TIME","OPEN","HIGH","LOW","CLOSE","TICKVOL"])
          for f in files]
raw = pd.concat(frames, ignore_index=True)
raw["datetime"] = pd.to_datetime(raw["DATE"].astype(str)+" "+raw["TIME"].astype(str))
raw = raw.set_index("datetime").sort_index()
raw = raw[["OPEN","HIGH","LOW","CLOSE","TICKVOL"]].loc[DATE_START:DATE_END].copy()
print(f"  {len(raw):,} M1 bars  ({time.time()-t0:.1f}s)")
print(f"  AutoThreshold M30: crash={SC100_CRASH_M30} trend={SC100_TREND_M30} revert={SC100_REVERT_M30}")
print(f"  RSI confirm: OS={RSI_OS} OB={RSI_OB} | SL={SL_MULT}xATR TP={TP_MULT}xATR RR={TP_MULT/SL_MULT:.0f}:1")

# ── BUILD M30 ─────────────────────────────────────────────────────────────────
print("\nBuilding M30 + indicators...")
df_m30 = build_indicators(resample_ohlcv(raw, TF_RULE))
df_m30["time_str"] = df_m30.index.strftime("%H:%M")

regime_dist = pd.Series([classify_regime(s) for s in df_m30["SC100"].dropna()]).value_counts()
print("  Regime distribution:")
for r, cnt in regime_dist.items():
    print(f"    {r:<12} {cnt:>6,}  ({cnt/regime_dist.sum()*100:.1f}%)")

# ── SESSION FILTER ────────────────────────────────────────────────────────────
frames_sess = []
for name, ts, te in SESSIONS:
    mask = (df_m30["time_str"] >= ts) & (df_m30["time_str"] < te)
    sub  = df_m30[mask].copy()
    sub["session"] = name
    frames_sess.append(sub)
    print(f"  {name} ({ts}-{te}): {mask.sum()} bars")

df_sess = pd.concat(frames_sess).sort_index().reset_index(drop=False)
print(f"  Total session bars: {len(df_sess)}")

# ── RUN ───────────────────────────────────────────────────────────────────────
print(f"\nRunning EA simulation...")
tdf = backtest(df_sess)

# ── RESULTS ───────────────────────────────────────────────────────────────────
print(f"\n{'='*60}")
print(f"EA fix20 RESULTS | {DATE_START} to {DATE_END}")
print(f"{'='*60}")

if len(tdf) == 0:
    print("No trades generated.")
else:
    wins   = (tdf["pnl"] > 0).sum()
    losses = len(tdf) - wins
    wr     = wins / len(tdf) * 100
    gp     = tdf[tdf["pnl"]>0]["pnl"].sum()
    gl     = tdf[tdf["pnl"]<0]["pnl"].abs().sum()
    pf     = gp / (gl + 1e-9)
    net    = tdf["pnl"].sum()
    years  = (pd.to_datetime(DATE_END) - pd.to_datetime(DATE_START)).days / 365.25

    # Per-cycle equity for DD calc (within each cycle, not cumulative)
    # Build cycle equity for the first cycle only
    c1 = tdf[tdf["cycle"]==1].copy()
    c1_eq = INITIAL_EQUITY + c1["pnl"].cumsum()
    max_dd_c1 = (c1_eq.cummax() - c1_eq).max() if len(c1) else 0
    dd_p      = max_dd_c1 / INITIAL_EQUITY * 100

    # FTMO cycle stats
    n_cycles = tdf["cycle"].max()
    cycle_results = []
    for cy, grp in tdf.groupby("cycle"):
        cy_eq  = INITIAL_EQUITY + grp["pnl"].cumsum()
        cy_max_eq = cy_eq.max()
        cy_min_eq = cy_eq.min()
        cy_final  = cy_eq.iloc[-1]
        cy_dd     = (cy_eq.cummax() - cy_eq).max()
        cy_days   = grp["date"].nunique()
        cy_passed = cy_max_eq >= FTMO_PASS_EQ
        cy_failed = cy_min_eq <= FTMO_FAIL_EQ
        cycle_results.append({
            "cycle": cy, "trades": len(grp), "days": cy_days,
            "wins": (grp["pnl"]>0).sum(), "final_eq": round(cy_final,0),
            "max_dd_pct": round(cy_dd/INITIAL_EQUITY*100,1),
            "passed": cy_passed, "failed": cy_failed
        })
    cdf = pd.DataFrame(cycle_results)

    n_pass = cdf["passed"].sum()
    n_fail = cdf["failed"].sum()
    avg_trades_pass = cdf[cdf["passed"]]["trades"].mean() if n_pass > 0 else 0
    avg_days_pass   = cdf[cdf["passed"]]["days"].mean()   if n_pass > 0 else 0

    print(f"  Period     : {years:.1f} years")
    print(f"  Trades total: {len(tdf)}  (Win={wins}, Loss={losses})")
    print(f"  Win Rate   : {wr:.1f}%")
    print(f"  Profit Factor: {pf:.2f}")
    print(f"  Fixed Risk  : ${FIXED_RISK:.0f}/trade | Win=${FIXED_WIN:.0f} | Loss=${FIXED_RISK:.0f}")
    print(f"  FTMO Cycles run: {n_cycles}")
    print(f"  PASS cycles  : {n_pass} ({n_pass/n_cycles*100:.0f}%)")
    print(f"  FAIL (DD hit): {n_fail} ({n_fail/n_cycles*100:.0f}%)")
    print(f"  Avg trades to PASS: {avg_trades_pass:.0f}")
    print(f"  Avg days to PASS  : {avg_days_pass:.0f}")
    print(f"  Cycle 1 Max DD   : ${max_dd_c1:,.0f}  ({dd_p:.1f}%)  {'OK' if dd_p < 10 else 'BREACH'}")

    print(f"\n  -- Per-Cycle Summary (first 20) --")
    print(f"  {'Cy':>3} {'Trades':>6} {'Days':>5} {'WR':>5} {'MaxDD%':>7} {'FinalEq':>10} {'Status':>7}")
    for _, r in cdf.head(20).iterrows():
        st = "PASS" if r["passed"] else ("DD" if r["failed"] else "open")
        wr_c = r["wins"]/r["trades"]*100 if r["trades"] > 0 else 0
        print(f"  {r['cycle']:>3} {r['trades']:>6} {r['days']:>5} {wr_c:>4.0f}% {r['max_dd_pct']:>6.1f}% ${r['final_eq']:>9,.0f} {st:>7}")

    tdf["month"] = pd.to_datetime(tdf["date"]).dt.to_period("M").astype(str)
    monthly = tdf.groupby("month")["pnl"].sum()
    avg_mo  = monthly.mean()
    est_mo  = round(INITIAL_EQUITY * FTMO_TARGET / avg_mo, 1) if avg_mo > 0 else 99
    print(f"\n  Avg monthly P&L (all cycles): ${avg_mo:,.0f}")
    print(f"  Est avg months to PASS: {avg_days_pass/22:.1f} months (from {avg_days_pass:.0f} trading days)")

    # Session breakdown
    print(f"\n  By Session:")
    for sess, grp in tdf.groupby("session"):
        w = (grp["pnl"]>0).sum()
        print(f"    {sess:<12} T={len(grp):>4}  WR={w/len(grp)*100:.0f}%  PnL=${grp['pnl'].sum():>10,.0f}")

    # Monthly P&L (truncated)
    print(f"\n  Monthly P&L (sample):")
    for m, v in list(monthly.items())[:36]:
        bar = "+" * int(max(v/500,0)) + "-" * int(max(-v/500,0))
        print(f"    {m}  ${v:>8,.0f}  {bar[:30]}")

    # ── CHART ─────────────────────────────────────────────────────────────────
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    fig.suptitle(
        f"SMC_Universal_EA fix20 | XAUUSD M30 | {DATE_START} to {DATE_END}\n"
        f"RSI({RSI_PERIOD}) OS={RSI_OS}/OB={RSI_OB} | SMA({SMA_PERIOD}) | SL={SL_MULT}xATR TP={TP_MULT}xATR | Swing mode",
        fontsize=11, fontweight="bold"
    )

    # 1. Cycle 1 equity curve
    ax = axes[0,0]
    eq = (INITIAL_EQUITY + c1["pnl"].cumsum()).values if len(c1) else np.array([INITIAL_EQUITY])
    ax.plot(range(len(eq)), eq, color="steelblue", linewidth=1)
    ax.axhline(INITIAL_EQUITY,           color="gray",  linestyle="--", alpha=0.5)
    ax.axhline(FTMO_PASS_EQ,             color="green", linestyle="--", alpha=0.7, linewidth=0.8, label="+10% PASS")
    ax.axhline(FTMO_FAIL_EQ,             color="red",   linestyle="--", alpha=0.7, linewidth=0.8, label="-10% FAIL")
    ax.axhline(DD_STOP_EQ,               color="orange",linestyle=":",  alpha=0.7, linewidth=0.8, label="-8% internal")
    ax.fill_between(range(len(eq)), INITIAL_EQUITY, eq,
                    where=np.array(eq)>=INITIAL_EQUITY, alpha=0.15, color="green")
    ax.fill_between(range(len(eq)), INITIAL_EQUITY, eq,
                    where=np.array(eq)<INITIAL_EQUITY,  alpha=0.15, color="red")
    ax.set_title(f"Cycle 1 Equity | PF={pf:.2f}  WR={wr:.1f}%  DD={dd_p:.1f}%", fontsize=9)
    ax.legend(fontsize=7); ax.set_ylabel("Equity ($)")

    # 2. Monthly P&L
    ax = axes[0,1]
    colors = ["green" if v>=0 else "red" for v in monthly.values]
    ax.bar(range(len(monthly)), monthly.values, color=colors, alpha=0.8)
    ax.axhline(0, color="black", linewidth=0.8)
    ax.axhline(INITIAL_EQUITY*FTMO_TARGET/12, color="green", linestyle="--",
               alpha=0.6, linewidth=0.8, label="Monthly target")
    ax.set_xticks(range(0, len(monthly), max(1, len(monthly)//12)))
    ax.set_xticklabels(list(monthly.index)[::max(1, len(monthly)//12)], rotation=45, fontsize=6)
    ax.set_title("Monthly P&L", fontsize=9); ax.legend(fontsize=7)

    # 3. Session P&L
    ax = axes[1,0]
    sess_pnl = tdf.groupby("session")["pnl"].sum()
    sess_wr  = tdf.groupby("session").apply(lambda x: (x["pnl"]>0).mean()*100)
    colors_s = ["green" if v>=0 else "red" for v in sess_pnl.values]
    bars = ax.bar(range(len(sess_pnl)), sess_pnl.values, color=colors_s, alpha=0.8)
    ax.set_xticks(range(len(sess_pnl)))
    ax.set_xticklabels(sess_pnl.index, fontsize=8)
    ax.axhline(0, color="black", linewidth=0.8)
    for xi, (s, v) in enumerate(sess_pnl.items()):
        ax.text(xi, v+(abs(v)*0.02+100), f"WR={sess_wr[s]:.0f}%", ha="center", fontsize=8)
    ax.set_title("Session P&L", fontsize=9)

    # 4. Cycle pass/fail bar chart
    ax = axes[1,1]
    cy_ids = cdf["cycle"].values
    cy_dd  = cdf["max_dd_pct"].values
    colors_cy = ["green" if p else ("red" if f else "gray")
                 for p, f in zip(cdf["passed"], cdf["failed"])]
    ax.bar(range(len(cy_ids)), cy_dd, color=colors_cy, alpha=0.8)
    ax.axhline(TOTAL_DD_STOP*100,  color="orange", linestyle=":", linewidth=1.2, label=f"Internal {TOTAL_DD_STOP*100:.0f}%")
    ax.axhline(FTMO_MAX_TOTAL*100, color="red",    linestyle="--",linewidth=1.5, label="FTMO 10%")
    ax.set_xlabel("Cycle #", fontsize=7); ax.set_ylabel("Max DD %", fontsize=7)
    ax.set_title(f"Cycle MaxDD | PASS={n_pass} FAIL={n_fail}/{n_cycles}", fontsize=9); ax.legend(fontsize=7)

    plt.tight_layout()
    out = Path(r"c:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\ea_fix20_result.png")
    plt.savefig(out, dpi=150, bbox_inches="tight")
    print(f"\nChart: {out}")

    out_csv = Path(r"c:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\ea_fix20_trades.csv")
    tdf.to_csv(out_csv, index=False)
    print(f"Trades: {out_csv}")

print(f"\nTotal time: {time.time()-t0:.1f}s | Done.")
