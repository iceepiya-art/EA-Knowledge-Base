import subprocess
from pathlib import Path

metaeditor = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe")
mq5_file = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\TestRule_RSI.mq5")

mq5_code = """
#property copyright "Hermes"
#property version   "1.00"

input int InpRSIPeriod = 14;
input double InpLotSize = 0.1;

int handleRSI;
double rsiArr[];

int OnInit() {
   handleRSI = iRSI(_Symbol, _Period, InpRSIPeriod, PRICE_CLOSE);
   if(handleRSI == INVALID_HANDLE) return INIT_FAILED;
   ArraySetAsSeries(rsiArr, true);
   return INIT_SUCCEEDED;
}

void OnTick() {
   if(PositionsTotal() == 0) {
      if(CopyBuffer(handleRSI, 0, 0, 2, rsiArr) > 0) {
         if(rsiArr[1] < 30.0) {
            MqlTradeRequest req;
            MqlTradeResult res;
            ZeroMemory(req);
            ZeroMemory(res);
            req.action = TRADE_ACTION_DEAL;
            req.symbol = _Symbol;
            req.volume = InpLotSize;
            req.type = ORDER_TYPE_BUY;
            req.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            req.deviation = 10;
            req.magic = 1111;
            OrderSend(req, res);
         }
      }
   }
}
"""

mq5_file.write_text(mq5_code, encoding="utf-8")

cmd = [str(metaeditor), f"/compile:{mq5_file}", "/log"]
print("Compiling...")
res = subprocess.run(cmd, capture_output=True, text=True)
print("Exit code:", res.returncode)

log_file = mq5_file.with_suffix(".log")
if log_file.exists():
    print("Log content:\n", log_file.read_text(encoding="utf-16", errors="ignore"))
else:
    print("No log file found.")
