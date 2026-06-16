//+------------------------------------------------------------------+
//| SMC_Defines.mqh — SMC Universal EA v3.0                         |
//| Constants, Enums, Structs                                        |
//| fix14: ZoneResult.isBull, TradeRecord.sumWinRR/sumLossRR added  |
//+------------------------------------------------------------------+
#ifndef SMC_DEFINES_MQH
#define SMC_DEFINES_MQH

#define EA_NAME          "SMC Universal EA v3.0"
#define EA_VERSION       "3.00"
#define EA_MAGIC         20250303

//--- Symbol list limits
#define MAX_SYMBOLS      30

//--- Symbol Preset strings
#define PRESET_MAJORS       "EURUSD,GBPUSD,USDJPY,USDCHF,USDCAD,AUDUSD,NZDUSD"
#define PRESET_GOLD_MAJORS  "XAUUSD,EURUSD,GBPUSD,USDJPY,USDCHF,USDCAD,AUDUSD"
#define PRESET_FOREX28      "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURAUD,EURNZD,EURCAD,EURCHF,EURJPY,GBPAUD,GBPNZD,GBPCAD,GBPCHF,GBPJPY,AUDNZD,AUDCAD,AUDCHF,AUDJPY,NZDCAD,NZDCHF,NZDJPY,CADCHF,CADJPY,CHFJPY"
#define PRESET_INDICES      "US30,US500,NAS100,GER40,UK100,JPN225"
#define PRESET_GOLD_IDX_S   "XAUUSD,XAGUSD,US30,US500,NAS100,GER40"
#define PRESET_CRYPTO_S     "BTCUSD,ETHUSD,XRPUSD,BNBUSD,SOLUSD"

//--- Symbol preset selector
enum ENUM_SYMBOL_PRESET {
   PRESET_CUSTOM      = 0,
   PRESET_FX_MAJORS   = 1,
   PRESET_FX_GOLD     = 2,
   PRESET_FX_28       = 3,
   PRESET_IDX         = 4,
   PRESET_GOLD_IDX    = 5,
   PRESET_CRYPTO      = 6,
};

//--- Position limits
#define MAX_POS_TOTAL    10

//--- Signal detection defaults
#define SWING_LB_DEF     5
#define W23_TOL_DEF      12
#define W23_LB_DEF       300
#define FVG_LB_DEF       300
#define MAX_FVG_DEF      3
#define OB_LB_DEF        150
#define ZONE_BASE_DEF    5

//--- Money management
#define RISK_PCT_DEF     1.0
#define MAX_SPREAD_DEF   50

//--- Trail / TP
#define TRAIL_START_DEF  1.5
#define TRAIL_STEP_DEF   0.5
#define SIM_TP_DEF       6.0

//--- Circuit breaker
#define CB_LOSS_PCT      3.0
#define CB_RESET_HOUR    0

//--- Cooldown
#define COOLDOWN_DEF     3

//--- Journal
#define JOURNAL_FILE     "SMC_Universal_Journal.csv"
#define JOURNAL_MAX      500

//--- Signal direction
enum ENUM_SMC_SIGNAL {
   SMC_NONE =  0,
   SMC_BUY  =  1,
   SMC_SELL = -1
};

//--- Trade state per symbol
enum ENUM_TRADE_STATE {
   TS_IDLE    = 0,
   TS_OPEN    = 1,
   TS_TRAIL   = 2,
   TS_CLOSED  = 3
};

//--- Journal events
enum ENUM_SMC_EVENT {
   SMCEVT_OPEN    = 0,
   SMCEVT_TRAIL   = 1,
   SMCEVT_CLOSE   = 2,
   SMCEVT_SKIP    = 3,
   SMCEVT_CB      = 4,
   SMCEVT_NEWS    = 5,
   SMCEVT_SESSION = 6
};

//--- Pattern type
enum ENUM_PATTERN {
   PAT_NONE = 0,
   PAT_W2   = 1,
   PAT_W3   = 2,
   PAT_M2   = 3,
   PAT_M3   = 4
};

//--- W/M Pattern ABC
struct PatternABC {
   bool           valid;
   bool           isBull;
   ENUM_PATTERN   patType;
   double         aPx, bPx, cPx;
   datetime       tA,  tB,  tC;
};

//--- Zone & FVG result from scanner
//    fix14: isBull field added (ไม่ต้องเดาใน CalcEntry อีกต่อไป)
struct ZoneResult {
   bool     valid;
   bool     isBull;      // FIX14: direction จาก W/M pattern โดยตรง
   double   zHi, zLo;
   double   fvgHi, fvgLo;
   double   obSL;
   datetime tZoneFrom;
};

//--- Per-symbol trade record
//    fix14: sumWinRR, sumLossRR สำหรับ avgWinRR/avgLossRR ที่ถูกต้อง
struct TradeRecord {
   string           symbol;
   bool             active;
   bool             isBull;
   ENUM_TRADE_STATE state;

   ulong          ticket;
   double         entryPx;
   double         slPx;
   double         tpPx;
   double         oneR;
   double         nextTrailAt;
   datetime       entryTime;

   double         fvgHi, fvgLo;
   double         zoneHi, zoneLo;

   int            wins, losses;
   double         totalPips;
   double         totalRR;
   double         totalPnL;
   double         sumWinRR;     // FIX14: สะสม RR ของ trade ที่ชนะ
   double         sumLossRR;    // FIX14: สะสม RR ของ trade ที่แพ้
   double         maxWinRR;
   double         maxLossRR;
   int            lastTradeBar;
};

//--- Global stats
struct TradeStats {
   int    totalTrades;
   int    wins;
   int    losses;
   double winRate;
   double totalRR;
   double avgRR;
   double avgWinRR;
   double avgLossRR;
   double profitFactor;
   double totalPips;
   double totalPnL;
};

struct JournalEntry {
   datetime       time;
   ENUM_SMC_EVENT eventType;
   string         symbol;
   string         description;
   double         pnl;
};

#endif
