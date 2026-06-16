//+------------------------------------------------------------------+
//|                                        MT5_VPS_Sync_Bridge.mqh   |
//|                          For EA Knowledge Brain System (Local)   |
//+------------------------------------------------------------------+
#property copyright "EA Knowledge Base"
#property link      ""

//+------------------------------------------------------------------+
//| Function to log trade results to CSV for Google Drive Sync       |
//+------------------------------------------------------------------+
void LogTradeToVPS(double pnl, double equity)
  {
   // Define file name (inside the vps_data folder mapped to Google Drive)
   string filename = "vps_data\\\\trades_log.csv";
   
   // Open file for read/write. If it doesn't exist, it will be created.
   int handle = FileOpen(filename, FILE_WRITE | FILE_READ | FILE_CSV | FILE_ANSI, ",");
   
   if(handle != INVALID_HANDLE)
     {
      // Check if file is empty to write headers
      ulong size = FileSize(handle);
      if(size == 0)
        {
         FileWrite(handle, "time", "pnl", "equity");
        }
      
      // Move pointer to the end of the file to append
      FileSeek(handle, 0, SEEK_END);
      
      // Get current time formatted as yyyy-mm-dd hh:mi:ss
      string time_str = TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS);
      
      // Write the data
      FileWrite(handle, time_str, DoubleToString(pnl, 2), DoubleToString(equity, 2));
      
      // Close file
      FileClose(handle);
      
      Print("VPS Sync Bridge: Logged trade successfully to Google Drive folder.");
     }
   else
     {
      Print("VPS Sync Bridge: Failed to open file for writing. Error: ", GetLastError());
      Print("Did you create the 'vps_data' folder using mklink?");
     }
  }
