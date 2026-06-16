//+------------------------------------------------------------------+
//|                                                   CME_Levels.mqh |
//|                                            Master All-Terrain EA |
//+------------------------------------------------------------------+
#property strict

//--- Inputs for CME String
input string InpCmeDataString = ""; // CME Data String (GC~NQ)

class CCmeLevels
{
private:
    bool   m_is_tester;
    double m_settle;
    double m_sd1_up;
    double m_sd1_dn;
    double m_sd2_up;
    double m_sd2_dn;
    
    // Array of support/resistance psychological levels for backtest
    double m_psy_levels[];

public:
    CCmeLevels()
    {
        m_is_tester = (bool)MQLInfoInteger(MQL_TESTER);
        m_settle = 0;
        m_sd1_up = 0;
        m_sd1_dn = 0;
        m_sd2_up = 0;
        m_sd2_dn = 0;
    }
    
    void Init()
    {
        if(!m_is_tester && InpCmeDataString != "")
        {
            ParseCmeString(InpCmeDataString);
        }
    }
    
    //------------------------------------------------------------------
    // Is price near a CME Support? (For Buy conditions)
    //------------------------------------------------------------------
    bool IsNearCmeSupport(double current_price, double tolerance_points = 20.0)
    {
        double tol = tolerance_points * _Point;
        
        if(m_is_tester)
        {
            return IsNearPsychologicalLevel(current_price, tol);
        }
        else
        {
            if(m_settle == 0) return true; // If no data, don't block trades
            
            // Near Settle, -1SD, or -2SD
            if(MathAbs(current_price - m_settle) <= tol) return true;
            if(MathAbs(current_price - m_sd1_dn) <= tol) return true;
            if(MathAbs(current_price - m_sd2_dn) <= tol) return true;
            return false;
        }
    }
    
    //------------------------------------------------------------------
    // Is price near a CME Resistance? (For Sell conditions)
    //------------------------------------------------------------------
    bool IsNearCmeResistance(double current_price, double tolerance_points = 20.0)
    {
        double tol = tolerance_points * _Point;
        
        if(m_is_tester)
        {
            return IsNearPsychologicalLevel(current_price, tol);
        }
        else
        {
            if(m_settle == 0) return true; // If no data, don't block trades
            
            // Near Settle, +1SD, or +2SD
            if(MathAbs(current_price - m_settle) <= tol) return true;
            if(MathAbs(current_price - m_sd1_up) <= tol) return true;
            if(MathAbs(current_price - m_sd2_up) <= tol) return true;
            return false;
        }
    }

private:
    //------------------------------------------------------------------
    // Parse the PineScript String Format: settle|sd1|sd2|calls|puts|dte|skew|date
    //------------------------------------------------------------------
    void ParseCmeString(string data_str)
    {
        string assets[];
        StringSplit(data_str, '~', assets);
        
        string gc_data = (ArraySize(assets) > 0) ? assets[0] : "";
        if(gc_data == "") return;
        
        string parts[];
        StringSplit(gc_data, '|', parts);
        
        if(ArraySize(parts) >= 3)
        {
            m_settle = StringToDouble(parts[0]);
            double sd1 = StringToDouble(parts[1]);
            double sd2 = StringToDouble(parts[2]);
            
            m_sd1_up = m_settle + sd1;
            m_sd1_dn = m_settle - sd1;
            m_sd2_up = m_settle + sd2;
            m_sd2_dn = m_settle - sd2;
            
            PrintFormat("CME Parsed -> Settle: %.2f, 1SD: %.2f, 2SD: %.2f", m_settle, sd1, sd2);
        }
    }
    
    //------------------------------------------------------------------
    // Fallback for Backtesting: Psychological Levels (00, 25, 50, 75)
    //------------------------------------------------------------------
    bool IsNearPsychologicalLevel(double price, double tol)
    {
        // Example for XAUUSD: 2300, 2325, 2350, 2375
        // Round price to nearest 25
        double normalized = price / 25.0;
        double nearest_level = MathRound(normalized) * 25.0;
        
        return MathAbs(price - nearest_level) <= tol;
    }
};
//+------------------------------------------------------------------+
