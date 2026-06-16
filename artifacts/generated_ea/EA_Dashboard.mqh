//+------------------------------------------------------------------+
//|                                                 EA_Dashboard.mqh |
//|                                            Master All-Terrain EA |
//+------------------------------------------------------------------+
#property copyright "Master EA Brain"
#property link      ""
#property strict

//--- Secret to low CPU: Use standard objects instead of CCanvas
//--- Secret to low RAM: Update via OnTimer (1 sec) instead of OnTick

class CEaDashboard
{
private:
    string m_prefix;
    int    m_x;
    int    m_y;
    
    // UI Colors (Dark mode with neon accents)
    color  m_bg_color;
    color  m_border_color;
    color  m_text_color;
    color  m_accent_cyan;
    color  m_accent_purple;

public:
    CEaDashboard() : m_prefix("MasterEA_UI_"), m_x(20), m_y(20)
    {
        m_bg_color = clrBlack; // Deep dark
        m_border_color = clrDimGray;
        m_text_color = clrWhite;
        m_accent_cyan = C'0,255,255';
        m_accent_purple = C'191,0,255';
    }
    
    ~CEaDashboard()
    {
        RemoveAll();
    }
    
    //------------------------------------------------------------------
    // Initialize Dashboard UI Objects
    //------------------------------------------------------------------
    void Init()
    {
        RemoveAll(); // Clean up old objects just in case
        
        // Main Background Panel
        CreateRect(m_prefix + "BG", m_x, m_y, 350, 360, m_bg_color, m_border_color);
        
        // Header
        CreateLabel(m_prefix + "Header", m_x + 15, m_y + 15, "MASTER ALL-TERRAIN EA", 11, "Arial Bold", m_accent_cyan);
        
        // --- Column 1: Account & Performance ---
        CreateLabel(m_prefix + "LblBal", m_x + 15, m_y + 45, "Balance:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblEq", m_x + 15, m_y + 65, "Equity:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblDProfit", m_x + 15, m_y + 85, "Daily Profit:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblWProfit", m_x + 15, m_y + 105, "Weekly Profit:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblWinRate", m_x + 15, m_y + 125, "Win Rate:", 9, "Arial", m_border_color);
        
        CreateLabel(m_prefix + "ValBal", m_x + 90, m_y + 45, "$0.00", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValEq", m_x + 90, m_y + 65, "$0.00", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValDProfit", m_x + 90, m_y + 85, "$0.00", 9, "Arial Bold", clrLimeGreen);
        CreateLabel(m_prefix + "ValWProfit", m_x + 90, m_y + 105, "$0.00", 9, "Arial Bold", clrLimeGreen);
        CreateLabel(m_prefix + "ValWinRate", m_x + 90, m_y + 125, "0.0%", 9, "Arial Bold", m_text_color);

        // --- Column 2: Trading Engine ---
        CreateLabel(m_prefix + "LblMode", m_x + 180, m_y + 45, "Regime:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblSpread", m_x + 180, m_y + 65, "Spread:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblDD", m_x + 180, m_y + 85, "Max DD:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblBuyLot", m_x + 180, m_y + 105, "Buy Lots:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblSellLot", m_x + 180, m_y + 125, "Sell Lots:", 9, "Arial", m_border_color);
        
        CreateLabel(m_prefix + "ValMode", m_x + 240, m_y + 45, "INITIALIZING", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValSpread", m_x + 240, m_y + 65, "0", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValDD", m_x + 240, m_y + 85, "0.0%", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValBuyLot", m_x + 240, m_y + 105, "0.00", 9, "Arial Bold", clrDeepSkyBlue);
        CreateLabel(m_prefix + "ValSellLot", m_x + 240, m_y + 125, "0.00", 9, "Arial Bold", clrTomato);
        
        // --- Bottom Row: Technical Indicators ---
        CreateRect(m_prefix + "Line", m_x + 15, m_y + 155, 320, 1, m_border_color, m_border_color);
        CreateLabel(m_prefix + "LblIndi", m_x + 15, m_y + 165, "INTERNAL ENGINE STATUS", 8, "Arial", m_border_color);
        
        CreateLabel(m_prefix + "LblTrend", m_x + 15, m_y + 185, "Trend (ADX):", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblVol", m_x + 15, m_y + 205, "Volatility (ATR):", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblRSI", m_x + 180, m_y + 185, "Momentum (RSI):", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblTime", m_x + 180, m_y + 205, "Broker Time:", 9, "Arial", m_border_color);
        
        CreateLabel(m_prefix + "ValTrend", m_x + 90, m_y + 185, "STRONG", 9, "Arial Bold", clrLimeGreen);
        CreateLabel(m_prefix + "ValVol", m_x + 90, m_y + 205, "NORMAL", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValRSI", m_x + 265, m_y + 185, "54.2 (NEUTRAL)", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValTime", m_x + 265, m_y + 205, "00:00:00", 9, "Arial Bold", m_text_color);
        
        // --- Bottom Row 2: Active AI Logic ---
        CreateRect(m_prefix + "Line2", m_x + 15, m_y + 235, 320, 1, m_border_color, m_border_color);
        CreateLabel(m_prefix + "LblLogic", m_x + 15, m_y + 245, "ACTIVE AI LOGIC", 8, "Arial", m_accent_purple);
        
        CreateLabel(m_prefix + "LblEntryRule", m_x + 15, m_y + 265, "Entry Rule:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblFilterRule", m_x + 15, m_y + 285, "Filter Rule:", 9, "Arial", m_border_color);
        CreateLabel(m_prefix + "LblRiskRule", m_x + 15, m_y + 305, "Risk/Exit:", 9, "Arial", m_border_color);
        
        CreateLabel(m_prefix + "ValEntryRule", m_x + 90, m_y + 265, "Breakout + RSI Divergence", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValFilterRule", m_x + 90, m_y + 285, "London/NY Session Only", 9, "Arial Bold", m_text_color);
        CreateLabel(m_prefix + "ValRiskRule", m_x + 90, m_y + 305, "ATR Trailing Stop", 9, "Arial Bold", m_text_color);
        
        ChartRedraw();
    }
    
    //------------------------------------------------------------------
    // Update Dashboard (Call inside OnTimer, NOT OnTick!)
    //------------------------------------------------------------------
    void Update(string mode, double profit, double drawdown, int spread, string entryRule, string filterRule, string riskRule)
    {
        // 1. Update Mode
        color modeColor = m_text_color;
        if(mode == "TREND MODE") modeColor = m_accent_cyan;
        else if(mode == "SIDEWAY MODE") modeColor = m_accent_purple;
        else if(mode == "NEWS MODE") modeColor = clrRed;
        
        ObjectSetString(0, m_prefix + "ValMode", OBJPROP_TEXT, mode);
        ObjectSetInteger(0, m_prefix + "ValMode", OBJPROP_COLOR, modeColor);
        
        // 2. Update Profit
        string profitStr = StringFormat("$%.2f", profit);
        color profitColor = (profit >= 0) ? clrLimeGreen : clrTomato;
        ObjectSetString(0, m_prefix + "ValProfit", OBJPROP_TEXT, profitStr);
        ObjectSetInteger(0, m_prefix + "ValProfit", OBJPROP_COLOR, profitColor);
        
        // 3. Update Drawdown
        string ddStr = StringFormat("%.1f%%", drawdown);
        color ddColor = (drawdown < 10) ? clrLimeGreen : (drawdown < 20) ? clrGold : clrTomato;
        ObjectSetString(0, m_prefix + "ValDD", OBJPROP_TEXT, ddStr);
        ObjectSetInteger(0, m_prefix + "ValDD", OBJPROP_COLOR, ddColor);
        
        // 4. Update Spread
        ObjectSetString(0, m_prefix + "ValSpread", OBJPROP_TEXT, IntegerToString(spread));
        
        // 5. Update Active Logic
        if(entryRule != "") ObjectSetString(0, m_prefix + "ValEntryRule", OBJPROP_TEXT, entryRule);
        if(filterRule != "") ObjectSetString(0, m_prefix + "ValFilterRule", OBJPROP_TEXT, filterRule);
        if(riskRule != "") ObjectSetString(0, m_prefix + "ValRiskRule", OBJPROP_TEXT, riskRule);
        
        ChartRedraw(); // Single redraw for extreme optimization
    }

private:
    void CreateRect(string name, int x, int y, int w, int h, color bg, color border)
    {
        ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
        ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
        ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
        ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, name, OBJPROP_COLOR, border);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
    }
    
    void CreateLabel(string name, int x, int y, string text, int size, string font, color clr)
    {
        ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
        ObjectSetString(0, name, OBJPROP_TEXT, text);
        ObjectSetString(0, name, OBJPROP_FONT, font);
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, size);
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
    }
    
    void RemoveAll()
    {
        int total = ObjectsTotal(0, 0, -1);
        for(int i = total - 1; i >= 0; i--)
        {
            string name = ObjectName(0, i, 0, -1);
            if(StringFind(name, m_prefix) == 0)
            {
                ObjectDelete(0, name);
            }
        }
        ChartRedraw();
    }
};
//+------------------------------------------------------------------+
