//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2020, fxDreema  (//
//+------------------------------------------------------------------------------+//
#property copyright   "Jobot"
#property link        "https://fxdreema.com"
#property description ""
#property version     "1.0"
#property strict

/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                       INPUT PARAMETERS, GLOBAL VARIABLES, CONSTANTS, IMPORTS and INCLUDES                        | //
// |                      System and Custom variables and other definitions used in the project                       | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// System constants (project settings) //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
#define PROJECT_ID "mt5-2971"
//--
// Point Format Rules
#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later
#define ENABLE_SPREAD_METER true
#define ENABLE_STATUS true
#define ENABLE_TEST_INDICATORS true
//--
// Events On/Off
#define ENABLE_EVENT_TICK 1 // enable "Tick" event
#define ENABLE_EVENT_TRADE 0 // enable "Trade" event
#define ENABLE_EVENT_TIMER 0 // enable "Timer" event
//--
// Virtual Stops
#define VIRTUAL_STOPS_ENABLED 0 // enable virtual stops
#define VIRTUAL_STOPS_TIMEOUT 0 // virtual stops timeout
#define USE_EMERGENCY_STOPS "no" // "yes" to use emergency (hard stops) when virtual stops are in use. "always" to use EMERGENCY_STOPS_ADD as emergency stops when there is no virtual stop.
#define EMERGENCY_STOPS_REL 0 // use 0 to disable hard stops when virtual stops are enabled. Use a value >=0 to automatically set hard stops with virtual. Example: if 2 is used, then hard stops will be 2 times bigger than virtual ones.
#define EMERGENCY_STOPS_ADD 0 // add pips to relative size of emergency stops (hard stops)
//--
// Settings for events
#define ON_TIMER_PERIOD 60 // Timer event period (in seconds)

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// System constants (predefined constants) //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
#define TLOBJPROP_TIME1 801
#define OBJPROP_TL_PRICE_BY_SHIFT 802
#define OBJPROP_TL_SHIFT_BY_PRICE 803
#define OBJPROP_FIBOVALUE 804
#define OBJPROP_FIBOPRICEVALUE 805
#define OBJPROP_FIRSTLEVEL 806
#define OBJPROP_TIME1 807
#define OBJPROP_TIME2 808
#define OBJPROP_TIME3 809
#define OBJPROP_PRICE1 810
#define OBJPROP_PRICE2 811
#define OBJPROP_PRICE3 812
#define OBJPROP_BARSHIFT1 813
#define OBJPROP_BARSHIFT2 814
#define OBJPROP_BARSHIFT3 815
#define SEL_CURRENT 0
#define SEL_INITIAL 1

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// Enumerations, Imports, Constants, Variables //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//





//--
// Constants (Input Parameters)
input double CCI_Indicators = 500.0;input double Strong = 8.0;input double Weak = 1.0;input int Candle = 1;input int Max_Symbol = 9999999;input string USD = "Click FALSE when there is Red News on that day";input bool USD_Monday = true;input bool USD_Tuesday = true;input bool USD_Wednesday = true;input bool USD_Thursday = true;input bool USD_Friday = true;input string EUR = "Click FALSE when there is Red News on that day";input bool EUR_Monday = true;input bool EUR_Tuesday = true;input bool EUR_Wednesday = true;input bool EUR_Thursday = true;input bool EUR_Friday = true;input string GBP = "Click FALSE when there is Red News on that day";input bool GBP_Monday = true;input bool GBP_Tuesday = true;input bool GBP_Wednesday = true;input bool GBP_Thursday = true;input bool GBP_Friday = true;input string JPY = "Click FALSE when there is Red News on that day";input bool JPY_Monday = true;input bool JPY_Tuesday = true;input bool JPY_Wednesday = true;input bool JPY_Thursday = true;input bool JPY_Friday = true;input string CAD = "Click FALSE when there is Red News on that day";input bool CAD_Monday = true;input bool CAD_Tuesday = true;input bool CAD_Wednesday = true;input bool CAD_Thursday = true;input bool CAD_Friday = true;input string AUD = "Click FALSE when there is Red News on that day";input bool AUD_Monday = true;input bool AUD_Tuesday = true;input bool AUD_Wednesday = true;input bool AUD_Thursday = true;input bool AUD_Friday = true;input string NZD = "Click FALSE when there is Red News on that day";input bool NZD_Monday = true;input bool NZD_Tuesday = true;input bool NZD_Wednesday = true;input bool NZD_Thursday = true;input bool NZD_Friday = true;input string CHF = "Click FALSE when there is Red News on that day";input bool CHF_Monday = true;input bool CHF_Tuesday = true;input bool CHF_Wednesday = true;input bool CHF_Thursday = true;input bool CHF_Friday = true;input string SWISSQBOT = "==========================================";input double LOT_Divided_by = 100000.0;input double SL = 0.0;input double TP = 0.0;input double ATR_Period = 21.0;input double ATR_Multiply = 10.0;input ENUM_TIMEFRAMES ATR_Timeframe = PERIOD_H1;input double Profit_Percent = 0.25;input int MagicStart = 9999; // Magic Number, kind of...
class c
{
		public:
	static double CCI_Indicators;
	static double Strong;
	static double Weak;
	static int Candle;
	static int Max_Symbol;
	static string USD;
	static bool USD_Monday;
	static bool USD_Tuesday;
	static bool USD_Wednesday;
	static bool USD_Thursday;
	static bool USD_Friday;
	static string EUR;
	static bool EUR_Monday;
	static bool EUR_Tuesday;
	static bool EUR_Wednesday;
	static bool EUR_Thursday;
	static bool EUR_Friday;
	static string GBP;
	static bool GBP_Monday;
	static bool GBP_Tuesday;
	static bool GBP_Wednesday;
	static bool GBP_Thursday;
	static bool GBP_Friday;
	static string JPY;
	static bool JPY_Monday;
	static bool JPY_Tuesday;
	static bool JPY_Wednesday;
	static bool JPY_Thursday;
	static bool JPY_Friday;
	static string CAD;
	static bool CAD_Monday;
	static bool CAD_Tuesday;
	static bool CAD_Wednesday;
	static bool CAD_Thursday;
	static bool CAD_Friday;
	static string AUD;
	static bool AUD_Monday;
	static bool AUD_Tuesday;
	static bool AUD_Wednesday;
	static bool AUD_Thursday;
	static bool AUD_Friday;
	static string NZD;
	static bool NZD_Monday;
	static bool NZD_Tuesday;
	static bool NZD_Wednesday;
	static bool NZD_Thursday;
	static bool NZD_Friday;
	static string CHF;
	static bool CHF_Monday;
	static bool CHF_Tuesday;
	static bool CHF_Wednesday;
	static bool CHF_Thursday;
	static bool CHF_Friday;
	static string SWISSQBOT;
	static double LOT_Divided_by;
	static double SL;
	static double TP;
	static double ATR_Period;
	static double ATR_Multiply;
	static ENUM_TIMEFRAMES ATR_Timeframe;
	static double Profit_Percent;
	static int MagicStart;
};
double c::CCI_Indicators;
double c::Strong;
double c::Weak;
int c::Candle;
int c::Max_Symbol;
string c::USD;
bool c::USD_Monday;
bool c::USD_Tuesday;
bool c::USD_Wednesday;
bool c::USD_Thursday;
bool c::USD_Friday;
string c::EUR;
bool c::EUR_Monday;
bool c::EUR_Tuesday;
bool c::EUR_Wednesday;
bool c::EUR_Thursday;
bool c::EUR_Friday;
string c::GBP;
bool c::GBP_Monday;
bool c::GBP_Tuesday;
bool c::GBP_Wednesday;
bool c::GBP_Thursday;
bool c::GBP_Friday;
string c::JPY;
bool c::JPY_Monday;
bool c::JPY_Tuesday;
bool c::JPY_Wednesday;
bool c::JPY_Thursday;
bool c::JPY_Friday;
string c::CAD;
bool c::CAD_Monday;
bool c::CAD_Tuesday;
bool c::CAD_Wednesday;
bool c::CAD_Thursday;
bool c::CAD_Friday;
string c::AUD;
bool c::AUD_Monday;
bool c::AUD_Tuesday;
bool c::AUD_Wednesday;
bool c::AUD_Thursday;
bool c::AUD_Friday;
string c::NZD;
bool c::NZD_Monday;
bool c::NZD_Tuesday;
bool c::NZD_Wednesday;
bool c::NZD_Thursday;
bool c::NZD_Friday;
string c::CHF;
bool c::CHF_Monday;
bool c::CHF_Tuesday;
bool c::CHF_Wednesday;
bool c::CHF_Thursday;
bool c::CHF_Friday;
string c::SWISSQBOT;
double c::LOT_Divided_by;
double c::SL;
double c::TP;
double c::ATR_Period;
double c::ATR_Multiply;
ENUM_TIMEFRAMES c::ATR_Timeframe;
double c::Profit_Percent;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double USDR9;
	static double JPYR9;
	static double AUDR9;
	static double CADR9;
	static double CHFR9;
	static double GBPR9;
	static double EURR9;
	static double NZDR9;
	static string MAIN_BUY;
	static string MAIN_SELL;
	static int AUDCAD_m;
	static int AUDCHF_m;
	static int AUDJPY_m;
	static int AUDNZD_m;
	static int AUDUSD_m;
	static int CADCHF_m;
	static int CADJPY_m;
	static int CHFJPY_m;
	static int EURAUD_m;
	static int EURCAD_m;
	static int EURCHF_m;
	static int EURGBP_m;
	static int EURJPY_m;
	static int EURNZD_m;
	static int EURUSD_m;
	static int GBPAUD_m;
	static int GBPCAD_m;
	static int GBPCHF_m;
	static int GBPJPY_m;
	static int GBPNZD_m;
	static int GBPUSD_m;
	static int NZDCAD_m;
	static int NZDCHF_m;
	static int NZDJPY_m;
	static int NZDUSD_m;
	static int USDCAD_m;
	static int USDCHF_m;
	static int USDJPY_m;
	static int USD55;
	static int JPY55;
	static int AUD55;
	static int EUR55;
	static int CHF55;
	static int CAD55;
	static int GBP55;
	static int NZD55;
	static double USD11;
	static double JPY11;
	static double AUD11;
	static double EUR11;
	static double CHF11;
	static double CAD11;
	static double NZD11;
	static double GBP11;
	static int AUDCAD_1x;
	static int AUDCHF_1x;
	static int AUDJPY_1x;
	static int AUDNZD_1x;
	static int AUDUSD_1x;
	static int CADCHF_1x;
	static int CADJPY_1x;
	static int CHFJPY_1x;
	static int EURAUD_1x;
	static int EURCAD_1x;
	static int EURCHF_1x;
	static int EURGBP_1x;
	static int EURJPY_1x;
	static int EURNZD_1x;
	static int EURUSD_1x;
	static int GBPAUD_1x;
	static int GBPCAD_1x;
	static int GBPCHF_1x;
	static int GBPJPY_1x;
	static int GBPNZD_1x;
	static int GBPUSD_1x;
	static int NZDCAD_1x;
	static int NZDCHF_1x;
	static int NZDJPY_1x;
	static int NZDUSD_1x;
	static int USDCAD_1x;
	static int USDCHF_1x;
	static int USDJPY_1x;
	static double USD1;
	static double USD2;
	static double USD3;
	static double USD4;
	static double USD5;
	static double USD6;
	static double USD7;
	static double JPY1;
	static double JPY2;
	static double JPY3;
	static double JPY4;
	static double JPY5;
	static double JPY6;
	static double JPY7;
	static double EUR1;
	static double EUR2;
	static double EUR3;
	static double EUR4;
	static double EUR5;
	static double EUR6;
	static double EUR7;
	static double GBP1;
	static double GBP2;
	static double GBP3;
	static double GBP4;
	static double GBP5;
	static double GBP6;
	static double GBP7;
	static double CAD1;
	static double CAD2;
	static double CAD3;
	static double CAD4;
	static double CAD5;
	static double CAD6;
	static double CAD7;
	static double AUD1;
	static double AUD2;
	static double AUD3;
	static double AUD4;
	static double AUD5;
	static double AUD6;
	static double AUD7;
	static double NZD1;
	static double NZD2;
	static double NZD3;
	static double NZD4;
	static double NZD5;
	static double NZD6;
	static double NZD7;
	static double CHF1;
	static double CHF2;
	static double CHF3;
	static double CHF4;
	static double CHF5;
	static double CHF6;
	static double CHF7;
	static double Percentx;
	static double ATR_near;
	static double lotxxx;
};
double v::USDR9;
double v::JPYR9;
double v::AUDR9;
double v::CADR9;
double v::CHFR9;
double v::GBPR9;
double v::EURR9;
double v::NZDR9;
string v::MAIN_BUY;
string v::MAIN_SELL;
int v::AUDCAD_m;
int v::AUDCHF_m;
int v::AUDJPY_m;
int v::AUDNZD_m;
int v::AUDUSD_m;
int v::CADCHF_m;
int v::CADJPY_m;
int v::CHFJPY_m;
int v::EURAUD_m;
int v::EURCAD_m;
int v::EURCHF_m;
int v::EURGBP_m;
int v::EURJPY_m;
int v::EURNZD_m;
int v::EURUSD_m;
int v::GBPAUD_m;
int v::GBPCAD_m;
int v::GBPCHF_m;
int v::GBPJPY_m;
int v::GBPNZD_m;
int v::GBPUSD_m;
int v::NZDCAD_m;
int v::NZDCHF_m;
int v::NZDJPY_m;
int v::NZDUSD_m;
int v::USDCAD_m;
int v::USDCHF_m;
int v::USDJPY_m;
int v::USD55;
int v::JPY55;
int v::AUD55;
int v::EUR55;
int v::CHF55;
int v::CAD55;
int v::GBP55;
int v::NZD55;
double v::USD11;
double v::JPY11;
double v::AUD11;
double v::EUR11;
double v::CHF11;
double v::CAD11;
double v::NZD11;
double v::GBP11;
int v::AUDCAD_1x;
int v::AUDCHF_1x;
int v::AUDJPY_1x;
int v::AUDNZD_1x;
int v::AUDUSD_1x;
int v::CADCHF_1x;
int v::CADJPY_1x;
int v::CHFJPY_1x;
int v::EURAUD_1x;
int v::EURCAD_1x;
int v::EURCHF_1x;
int v::EURGBP_1x;
int v::EURJPY_1x;
int v::EURNZD_1x;
int v::EURUSD_1x;
int v::GBPAUD_1x;
int v::GBPCAD_1x;
int v::GBPCHF_1x;
int v::GBPJPY_1x;
int v::GBPNZD_1x;
int v::GBPUSD_1x;
int v::NZDCAD_1x;
int v::NZDCHF_1x;
int v::NZDJPY_1x;
int v::NZDUSD_1x;
int v::USDCAD_1x;
int v::USDCHF_1x;
int v::USDJPY_1x;
double v::USD1;
double v::USD2;
double v::USD3;
double v::USD4;
double v::USD5;
double v::USD6;
double v::USD7;
double v::JPY1;
double v::JPY2;
double v::JPY3;
double v::JPY4;
double v::JPY5;
double v::JPY6;
double v::JPY7;
double v::EUR1;
double v::EUR2;
double v::EUR3;
double v::EUR4;
double v::EUR5;
double v::EUR6;
double v::EUR7;
double v::GBP1;
double v::GBP2;
double v::GBP3;
double v::GBP4;
double v::GBP5;
double v::GBP6;
double v::GBP7;
double v::CAD1;
double v::CAD2;
double v::CAD3;
double v::CAD4;
double v::CAD5;
double v::CAD6;
double v::CAD7;
double v::AUD1;
double v::AUD2;
double v::AUD3;
double v::AUD4;
double v::AUD5;
double v::AUD6;
double v::AUD7;
double v::NZD1;
double v::NZD2;
double v::NZD3;
double v::NZD4;
double v::NZD5;
double v::NZD6;
double v::NZD7;
double v::CHF1;
double v::CHF2;
double v::CHF3;
double v::CHF4;
double v::CHF5;
double v::CHF6;
double v::CHF7;
double v::Percentx;
double v::ATR_near;
double v::lotxxx;




//VVVVVVVVVVVVVVVVVVVVVVVVV//
// System global variables //
//^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
// Blocks Lookup Functions
string fxdBlocksLookupTable[];

int FXD_CURRENT_FUNCTION_ID = 0;
double FXD_MILS_INIT_END    = 0;
int FXD_TICKS_FROM_START    = 0;
int FXD_MORE_SHIFT          = 0;
bool FXD_DRAW_SPREAD_INFO   = false;
bool FXD_FIRST_TICK_PASSED  = false;
bool FXD_BREAK              = false;
bool FXD_CONTINUE           = false;
bool USE_VIRTUAL_STOPS = VIRTUAL_STOPS_ENABLED;
string FXD_CURRENT_SYMBOL   = "";
int FXD_BLOCKS_COUNT        = 455;
datetime FXD_TICKSKIP_UNTIL = 0;

int FXD_ICUSTOM_HANDLES_IDS[]; // only used in MQL5
string FXD_ICUSTOM_HANDLES_KEYS[]; // only used in MQL5

//- for use in OnChart() event
struct fxd_onchart
{
	int id;
	long lparam;
	double dparam;
	string sparam;
};
fxd_onchart FXD_ONCHART;

//VVVVVVVVVVVVVVVVVVV//
// System structures //
//^^^^^^^^^^^^^^^^^^^//
struct position
{
	long    position_id;
	long     type,
	         magic;
	datetime time;
	double   volume,
	         price_open,
	         sl,
	         tp,
	         price_current,
	         comission,
	         swap,
	         profit;
	string   symbol,
	         comment;
};
struct order
{
	datetime time_setup,
	         time_expiration,
	         time_done;
	long     type,
	         state,
	         type_filling,
	         type_time,
	         magic,
	         position_id;
	ulong    ticket;
	double   volume_initial,
	         volume_current,
	         price_open,
	         sl,
	         tp,
	         price_current,
	         price_stoplimit;
	string   symbol,
	         comment;
};

position  EGV_PositionsList[];
position  EGV_PositionsList0[];
order     EGV_OrderList[];
order     EGV_OrderList0[];

/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                                 EVENT FUNCTIONS                                                  | //
// |                           These are the main functions that controls the whole project                           | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed once when the program starts //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
int OnInit()
{

	// Initiate Constants
	c::CCI_Indicators = CCI_Indicators;
	c::Strong = Strong;
	c::Weak = Weak;
	c::Candle = Candle;
	c::Max_Symbol = Max_Symbol;
	c::USD = USD;
	c::USD_Monday = USD_Monday;
	c::USD_Tuesday = USD_Tuesday;
	c::USD_Wednesday = USD_Wednesday;
	c::USD_Thursday = USD_Thursday;
	c::USD_Friday = USD_Friday;
	c::EUR = EUR;
	c::EUR_Monday = EUR_Monday;
	c::EUR_Tuesday = EUR_Tuesday;
	c::EUR_Wednesday = EUR_Wednesday;
	c::EUR_Thursday = EUR_Thursday;
	c::EUR_Friday = EUR_Friday;
	c::GBP = GBP;
	c::GBP_Monday = GBP_Monday;
	c::GBP_Tuesday = GBP_Tuesday;
	c::GBP_Wednesday = GBP_Wednesday;
	c::GBP_Thursday = GBP_Thursday;
	c::GBP_Friday = GBP_Friday;
	c::JPY = JPY;
	c::JPY_Monday = JPY_Monday;
	c::JPY_Tuesday = JPY_Tuesday;
	c::JPY_Wednesday = JPY_Wednesday;
	c::JPY_Thursday = JPY_Thursday;
	c::JPY_Friday = JPY_Friday;
	c::CAD = CAD;
	c::CAD_Monday = CAD_Monday;
	c::CAD_Tuesday = CAD_Tuesday;
	c::CAD_Wednesday = CAD_Wednesday;
	c::CAD_Thursday = CAD_Thursday;
	c::CAD_Friday = CAD_Friday;
	c::AUD = AUD;
	c::AUD_Monday = AUD_Monday;
	c::AUD_Tuesday = AUD_Tuesday;
	c::AUD_Wednesday = AUD_Wednesday;
	c::AUD_Thursday = AUD_Thursday;
	c::AUD_Friday = AUD_Friday;
	c::NZD = NZD;
	c::NZD_Monday = NZD_Monday;
	c::NZD_Tuesday = NZD_Tuesday;
	c::NZD_Wednesday = NZD_Wednesday;
	c::NZD_Thursday = NZD_Thursday;
	c::NZD_Friday = NZD_Friday;
	c::CHF = CHF;
	c::CHF_Monday = CHF_Monday;
	c::CHF_Tuesday = CHF_Tuesday;
	c::CHF_Wednesday = CHF_Wednesday;
	c::CHF_Thursday = CHF_Thursday;
	c::CHF_Friday = CHF_Friday;
	c::SWISSQBOT = SWISSQBOT;
	c::LOT_Divided_by = LOT_Divided_by;
	c::SL = SL;
	c::TP = TP;
	c::ATR_Period = ATR_Period;
	c::ATR_Multiply = ATR_Multiply;
	c::ATR_Timeframe = ATR_Timeframe;
	c::Profit_Percent = Profit_Percent;
	c::MagicStart = MagicStart;




	// do or do not not initilialize on reload
	if (UninitializeReason() != 0)
	{
		if (UninitializeReason() == REASON_CHARTCHANGE)
		{
			// if the symbol is the same, do not reload, otherwise continue below
			if (FXD_CURRENT_SYMBOL == Symbol()) {return INIT_SUCCEEDED;}
		}
		else
		{
			return INIT_SUCCEEDED;
		}
	}
	FXD_CURRENT_SYMBOL = Symbol();

	CurrentSymbol(FXD_CURRENT_SYMBOL); // CurrentSymbol() has internal memory that should be set from here when the symboll is changed
	CurrentTimeframe(PERIOD_CURRENT);

	v::USDR9 = 0.0;
	v::JPYR9 = 0.0;
	v::AUDR9 = 0.0;
	v::CADR9 = 0.0;
	v::CHFR9 = 0.0;
	v::GBPR9 = 0.0;
	v::EURR9 = 0.0;
	v::NZDR9 = 0.0;
	v::MAIN_BUY = "0";
	v::MAIN_SELL = "0";
	v::AUDCAD_m = 0;
	v::AUDCHF_m = 0;
	v::AUDJPY_m = 0;
	v::AUDNZD_m = 0;
	v::AUDUSD_m = 0;
	v::CADCHF_m = 0;
	v::CADJPY_m = 0;
	v::CHFJPY_m = 0;
	v::EURAUD_m = 0;
	v::EURCAD_m = 0;
	v::EURCHF_m = 0;
	v::EURGBP_m = 0;
	v::EURJPY_m = 0;
	v::EURNZD_m = 0;
	v::EURUSD_m = 0;
	v::GBPAUD_m = 0;
	v::GBPCAD_m = 0;
	v::GBPCHF_m = 0;
	v::GBPJPY_m = 0;
	v::GBPNZD_m = 0;
	v::GBPUSD_m = 0;
	v::NZDCAD_m = 0;
	v::NZDCHF_m = 0;
	v::NZDJPY_m = 0;
	v::NZDUSD_m = 0;
	v::USDCAD_m = 0;
	v::USDCHF_m = 0;
	v::USDJPY_m = 0;
	v::USD55 = 0;
	v::JPY55 = 0;
	v::AUD55 = 0;
	v::EUR55 = 0;
	v::CHF55 = 0;
	v::CAD55 = 0;
	v::GBP55 = 0;
	v::NZD55 = 0;
	v::USD11 = 0.0;
	v::JPY11 = 0.0;
	v::AUD11 = 0.0;
	v::EUR11 = 0.0;
	v::CHF11 = 0.0;
	v::CAD11 = 0.0;
	v::NZD11 = 0.0;
	v::GBP11 = 0.0;
	v::AUDCAD_1x = 0;
	v::AUDCHF_1x = 0;
	v::AUDJPY_1x = 0;
	v::AUDNZD_1x = 0;
	v::AUDUSD_1x = 0;
	v::CADCHF_1x = 0;
	v::CADJPY_1x = 0;
	v::CHFJPY_1x = 0;
	v::EURAUD_1x = 0;
	v::EURCAD_1x = 0;
	v::EURCHF_1x = 0;
	v::EURGBP_1x = 0;
	v::EURJPY_1x = 0;
	v::EURNZD_1x = 0;
	v::EURUSD_1x = 0;
	v::GBPAUD_1x = 0;
	v::GBPCAD_1x = 0;
	v::GBPCHF_1x = 0;
	v::GBPJPY_1x = 0;
	v::GBPNZD_1x = 0;
	v::GBPUSD_1x = 0;
	v::NZDCAD_1x = 0;
	v::NZDCHF_1x = 0;
	v::NZDJPY_1x = 0;
	v::NZDUSD_1x = 0;
	v::USDCAD_1x = 0;
	v::USDCHF_1x = 0;
	v::USDJPY_1x = 0;
	v::USD1 = 0.0;
	v::USD2 = 0.0;
	v::USD3 = 0.0;
	v::USD4 = 0.0;
	v::USD5 = 0.0;
	v::USD6 = 0.0;
	v::USD7 = 0.0;
	v::JPY1 = 0.0;
	v::JPY2 = 0.0;
	v::JPY3 = 0.0;
	v::JPY4 = 0.0;
	v::JPY5 = 0.0;
	v::JPY6 = 0.0;
	v::JPY7 = 0.0;
	v::EUR1 = 0.0;
	v::EUR2 = 0.0;
	v::EUR3 = 0.0;
	v::EUR4 = 0.0;
	v::EUR5 = 0.0;
	v::EUR6 = 0.0;
	v::EUR7 = 0.0;
	v::GBP1 = 0.0;
	v::GBP2 = 0.0;
	v::GBP3 = 0.0;
	v::GBP4 = 0.0;
	v::GBP5 = 0.0;
	v::GBP6 = 0.0;
	v::GBP7 = 0.0;
	v::CAD1 = 0.0;
	v::CAD2 = 0.0;
	v::CAD3 = 0.0;
	v::CAD4 = 0.0;
	v::CAD5 = 0.0;
	v::CAD6 = 0.0;
	v::CAD7 = 0.0;
	v::AUD1 = 0.0;
	v::AUD2 = 0.0;
	v::AUD3 = 0.0;
	v::AUD4 = 0.0;
	v::AUD5 = 0.0;
	v::AUD6 = 0.0;
	v::AUD7 = 0.0;
	v::NZD1 = 0.0;
	v::NZD2 = 0.0;
	v::NZD3 = 0.0;
	v::NZD4 = 0.0;
	v::NZD5 = 0.0;
	v::NZD6 = 0.0;
	v::NZD7 = 0.0;
	v::CHF1 = 0.0;
	v::CHF2 = 0.0;
	v::CHF3 = 0.0;
	v::CHF4 = 0.0;
	v::CHF5 = 0.0;
	v::CHF6 = 0.0;
	v::CHF7 = 0.0;
	v::Percentx = 0.0;
	v::ATR_near = 0.0;
	v::lotxxx = 0.0;




	Comment("");
	for (int i=ObjectsTotal(ChartID()); i>=0; i--)
	{
		string name = ObjectName(ChartID(), i);
		if (StringSubstr(name,0,8) == "fxd_cmnt") {ObjectDelete(ChartID(), name);}
	}
	ChartRedraw();



	// This is needed for OnTrade event
	BuildPositionsList(EGV_PositionsList0);
	BuildOrdersList(EGV_OrderList0);

	//-- disable virtual stops in optimization, because graphical objects does not work
	// http://docs.mql4.com/runtime/testing
	if (MQLInfoInteger(MQL_OPTIMIZATION)) {
		USE_VIRTUAL_STOPS = false;
	}

	//-- set initial local and server time
	TimeAtStart("set");

	//-- set initial balance
	AccountBalanceAtStart();

	//-- draw the initial spread info meter
	if (ENABLE_SPREAD_METER == false) {
		FXD_DRAW_SPREAD_INFO = false;
	}
	else {
		FXD_DRAW_SPREAD_INFO = !(MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE));
	}
	if (FXD_DRAW_SPREAD_INFO) DrawSpreadInfo();

	//-- draw initial status
	if (ENABLE_STATUS) DrawStatus("waiting for tick...");

	//-- draw indicators after test
	TesterHideIndicators(!ENABLE_TEST_INDICATORS);

	if (ENABLE_EVENT_TIMER) {
		OnTimerSet(ON_TIMER_PERIOD);
	}


	//-- Initialize blocks classes
	ArrayResize(_blocks_, 455);

	_blocks_[0] = new Block0();
	_blocks_[1] = new Block1();
	_blocks_[2] = new Block2();
	_blocks_[3] = new Block3();
	_blocks_[4] = new Block4();
	_blocks_[5] = new Block5();
	_blocks_[6] = new Block6();
	_blocks_[7] = new Block7();
	_blocks_[8] = new Block8();
	_blocks_[9] = new Block9();
	_blocks_[10] = new Block10();
	_blocks_[11] = new Block11();
	_blocks_[12] = new Block12();
	_blocks_[13] = new Block13();
	_blocks_[14] = new Block14();
	_blocks_[15] = new Block15();
	_blocks_[16] = new Block16();
	_blocks_[17] = new Block17();
	_blocks_[18] = new Block18();
	_blocks_[19] = new Block19();
	_blocks_[20] = new Block20();
	_blocks_[21] = new Block21();
	_blocks_[22] = new Block22();
	_blocks_[23] = new Block23();
	_blocks_[24] = new Block24();
	_blocks_[25] = new Block25();
	_blocks_[26] = new Block26();
	_blocks_[27] = new Block27();
	_blocks_[28] = new Block28();
	_blocks_[29] = new Block29();
	_blocks_[30] = new Block30();
	_blocks_[31] = new Block31();
	_blocks_[32] = new Block32();
	_blocks_[33] = new Block33();
	_blocks_[34] = new Block34();
	_blocks_[35] = new Block35();
	_blocks_[36] = new Block36();
	_blocks_[37] = new Block37();
	_blocks_[38] = new Block38();
	_blocks_[39] = new Block39();
	_blocks_[40] = new Block40();
	_blocks_[41] = new Block41();
	_blocks_[42] = new Block42();
	_blocks_[43] = new Block43();
	_blocks_[44] = new Block44();
	_blocks_[45] = new Block45();
	_blocks_[46] = new Block46();
	_blocks_[47] = new Block47();
	_blocks_[48] = new Block48();
	_blocks_[49] = new Block49();
	_blocks_[50] = new Block50();
	_blocks_[51] = new Block51();
	_blocks_[52] = new Block52();
	_blocks_[53] = new Block53();
	_blocks_[54] = new Block54();
	_blocks_[55] = new Block55();
	_blocks_[56] = new Block56();
	_blocks_[57] = new Block57();
	_blocks_[58] = new Block58();
	_blocks_[59] = new Block59();
	_blocks_[60] = new Block60();
	_blocks_[61] = new Block61();
	_blocks_[62] = new Block62();
	_blocks_[63] = new Block63();
	_blocks_[64] = new Block64();
	_blocks_[65] = new Block65();
	_blocks_[66] = new Block66();
	_blocks_[67] = new Block67();
	_blocks_[68] = new Block68();
	_blocks_[69] = new Block69();
	_blocks_[70] = new Block70();
	_blocks_[71] = new Block71();
	_blocks_[72] = new Block72();
	_blocks_[73] = new Block73();
	_blocks_[74] = new Block74();
	_blocks_[75] = new Block75();
	_blocks_[76] = new Block76();
	_blocks_[77] = new Block77();
	_blocks_[78] = new Block78();
	_blocks_[79] = new Block79();
	_blocks_[80] = new Block80();
	_blocks_[81] = new Block81();
	_blocks_[82] = new Block82();
	_blocks_[83] = new Block83();
	_blocks_[84] = new Block84();
	_blocks_[85] = new Block85();
	_blocks_[86] = new Block86();
	_blocks_[87] = new Block87();
	_blocks_[88] = new Block88();
	_blocks_[89] = new Block89();
	_blocks_[90] = new Block90();
	_blocks_[91] = new Block91();
	_blocks_[92] = new Block92();
	_blocks_[93] = new Block93();
	_blocks_[94] = new Block94();
	_blocks_[95] = new Block95();
	_blocks_[96] = new Block96();
	_blocks_[97] = new Block97();
	_blocks_[98] = new Block98();
	_blocks_[99] = new Block99();
	_blocks_[100] = new Block100();
	_blocks_[101] = new Block101();
	_blocks_[102] = new Block102();
	_blocks_[103] = new Block103();
	_blocks_[104] = new Block104();
	_blocks_[105] = new Block105();
	_blocks_[106] = new Block106();
	_blocks_[107] = new Block107();
	_blocks_[108] = new Block108();
	_blocks_[109] = new Block109();
	_blocks_[110] = new Block110();
	_blocks_[111] = new Block111();
	_blocks_[112] = new Block112();
	_blocks_[113] = new Block113();
	_blocks_[114] = new Block114();
	_blocks_[115] = new Block115();
	_blocks_[116] = new Block116();
	_blocks_[117] = new Block117();
	_blocks_[118] = new Block118();
	_blocks_[119] = new Block119();
	_blocks_[120] = new Block120();
	_blocks_[121] = new Block121();
	_blocks_[122] = new Block122();
	_blocks_[123] = new Block123();
	_blocks_[124] = new Block124();
	_blocks_[125] = new Block125();
	_blocks_[126] = new Block126();
	_blocks_[127] = new Block127();
	_blocks_[128] = new Block128();
	_blocks_[129] = new Block129();
	_blocks_[130] = new Block130();
	_blocks_[131] = new Block131();
	_blocks_[132] = new Block132();
	_blocks_[133] = new Block133();
	_blocks_[134] = new Block134();
	_blocks_[135] = new Block135();
	_blocks_[136] = new Block136();
	_blocks_[137] = new Block137();
	_blocks_[138] = new Block138();
	_blocks_[139] = new Block139();
	_blocks_[140] = new Block140();
	_blocks_[141] = new Block141();
	_blocks_[142] = new Block142();
	_blocks_[143] = new Block143();
	_blocks_[144] = new Block144();
	_blocks_[145] = new Block145();
	_blocks_[146] = new Block146();
	_blocks_[147] = new Block147();
	_blocks_[148] = new Block148();
	_blocks_[149] = new Block149();
	_blocks_[150] = new Block150();
	_blocks_[151] = new Block151();
	_blocks_[152] = new Block152();
	_blocks_[153] = new Block153();
	_blocks_[154] = new Block154();
	_blocks_[155] = new Block155();
	_blocks_[156] = new Block156();
	_blocks_[157] = new Block157();
	_blocks_[158] = new Block158();
	_blocks_[159] = new Block159();
	_blocks_[160] = new Block160();
	_blocks_[161] = new Block161();
	_blocks_[162] = new Block162();
	_blocks_[163] = new Block163();
	_blocks_[164] = new Block164();
	_blocks_[165] = new Block165();
	_blocks_[166] = new Block166();
	_blocks_[167] = new Block167();
	_blocks_[168] = new Block168();
	_blocks_[169] = new Block169();
	_blocks_[170] = new Block170();
	_blocks_[171] = new Block171();
	_blocks_[172] = new Block172();
	_blocks_[173] = new Block173();
	_blocks_[174] = new Block174();
	_blocks_[175] = new Block175();
	_blocks_[176] = new Block176();
	_blocks_[177] = new Block177();
	_blocks_[178] = new Block178();
	_blocks_[179] = new Block179();
	_blocks_[180] = new Block180();
	_blocks_[181] = new Block181();
	_blocks_[182] = new Block182();
	_blocks_[183] = new Block183();
	_blocks_[184] = new Block184();
	_blocks_[185] = new Block185();
	_blocks_[186] = new Block186();
	_blocks_[187] = new Block187();
	_blocks_[188] = new Block188();
	_blocks_[189] = new Block189();
	_blocks_[190] = new Block190();
	_blocks_[191] = new Block191();
	_blocks_[192] = new Block192();
	_blocks_[193] = new Block193();
	_blocks_[194] = new Block194();
	_blocks_[195] = new Block195();
	_blocks_[196] = new Block196();
	_blocks_[197] = new Block197();
	_blocks_[198] = new Block198();
	_blocks_[199] = new Block199();
	_blocks_[200] = new Block200();
	_blocks_[201] = new Block201();
	_blocks_[202] = new Block202();
	_blocks_[203] = new Block203();
	_blocks_[204] = new Block204();
	_blocks_[205] = new Block205();
	_blocks_[206] = new Block206();
	_blocks_[207] = new Block207();
	_blocks_[208] = new Block208();
	_blocks_[209] = new Block209();
	_blocks_[210] = new Block210();
	_blocks_[211] = new Block211();
	_blocks_[212] = new Block212();
	_blocks_[213] = new Block213();
	_blocks_[214] = new Block214();
	_blocks_[215] = new Block215();
	_blocks_[216] = new Block216();
	_blocks_[217] = new Block217();
	_blocks_[218] = new Block218();
	_blocks_[219] = new Block219();
	_blocks_[220] = new Block220();
	_blocks_[221] = new Block221();
	_blocks_[222] = new Block222();
	_blocks_[223] = new Block223();
	_blocks_[224] = new Block224();
	_blocks_[225] = new Block225();
	_blocks_[226] = new Block226();
	_blocks_[227] = new Block227();
	_blocks_[228] = new Block228();
	_blocks_[229] = new Block229();
	_blocks_[230] = new Block230();
	_blocks_[231] = new Block231();
	_blocks_[232] = new Block232();
	_blocks_[233] = new Block233();
	_blocks_[234] = new Block234();
	_blocks_[235] = new Block235();
	_blocks_[236] = new Block236();
	_blocks_[237] = new Block237();
	_blocks_[238] = new Block238();
	_blocks_[239] = new Block239();
	_blocks_[240] = new Block240();
	_blocks_[241] = new Block241();
	_blocks_[242] = new Block242();
	_blocks_[243] = new Block243();
	_blocks_[244] = new Block244();
	_blocks_[245] = new Block245();
	_blocks_[246] = new Block246();
	_blocks_[247] = new Block247();
	_blocks_[248] = new Block248();
	_blocks_[249] = new Block249();
	_blocks_[250] = new Block250();
	_blocks_[251] = new Block251();
	_blocks_[252] = new Block252();
	_blocks_[253] = new Block253();
	_blocks_[254] = new Block254();
	_blocks_[255] = new Block255();
	_blocks_[256] = new Block256();
	_blocks_[257] = new Block257();
	_blocks_[258] = new Block258();
	_blocks_[259] = new Block259();
	_blocks_[260] = new Block260();
	_blocks_[261] = new Block261();
	_blocks_[262] = new Block262();
	_blocks_[263] = new Block263();
	_blocks_[264] = new Block264();
	_blocks_[265] = new Block265();
	_blocks_[266] = new Block266();
	_blocks_[267] = new Block267();
	_blocks_[268] = new Block268();
	_blocks_[269] = new Block269();
	_blocks_[270] = new Block270();
	_blocks_[271] = new Block271();
	_blocks_[272] = new Block272();
	_blocks_[273] = new Block273();
	_blocks_[274] = new Block274();
	_blocks_[275] = new Block275();
	_blocks_[276] = new Block276();
	_blocks_[277] = new Block277();
	_blocks_[278] = new Block278();
	_blocks_[279] = new Block279();
	_blocks_[280] = new Block280();
	_blocks_[281] = new Block281();
	_blocks_[282] = new Block282();
	_blocks_[283] = new Block283();
	_blocks_[284] = new Block284();
	_blocks_[285] = new Block285();
	_blocks_[286] = new Block286();
	_blocks_[287] = new Block287();
	_blocks_[288] = new Block288();
	_blocks_[289] = new Block289();
	_blocks_[290] = new Block290();
	_blocks_[291] = new Block291();
	_blocks_[292] = new Block292();
	_blocks_[293] = new Block293();
	_blocks_[294] = new Block294();
	_blocks_[295] = new Block295();
	_blocks_[296] = new Block296();
	_blocks_[297] = new Block297();
	_blocks_[298] = new Block298();
	_blocks_[299] = new Block299();
	_blocks_[300] = new Block300();
	_blocks_[301] = new Block301();
	_blocks_[302] = new Block302();
	_blocks_[303] = new Block303();
	_blocks_[304] = new Block304();
	_blocks_[305] = new Block305();
	_blocks_[306] = new Block306();
	_blocks_[307] = new Block307();
	_blocks_[308] = new Block308();
	_blocks_[309] = new Block309();
	_blocks_[310] = new Block310();
	_blocks_[311] = new Block311();
	_blocks_[312] = new Block312();
	_blocks_[313] = new Block313();
	_blocks_[314] = new Block314();
	_blocks_[315] = new Block315();
	_blocks_[316] = new Block316();
	_blocks_[317] = new Block317();
	_blocks_[318] = new Block318();
	_blocks_[319] = new Block319();
	_blocks_[320] = new Block320();
	_blocks_[321] = new Block321();
	_blocks_[322] = new Block322();
	_blocks_[323] = new Block323();
	_blocks_[324] = new Block324();
	_blocks_[325] = new Block325();
	_blocks_[326] = new Block326();
	_blocks_[327] = new Block327();
	_blocks_[328] = new Block328();
	_blocks_[329] = new Block329();
	_blocks_[330] = new Block330();
	_blocks_[331] = new Block331();
	_blocks_[332] = new Block332();
	_blocks_[333] = new Block333();
	_blocks_[334] = new Block334();
	_blocks_[335] = new Block335();
	_blocks_[336] = new Block336();
	_blocks_[337] = new Block337();
	_blocks_[338] = new Block338();
	_blocks_[339] = new Block339();
	_blocks_[340] = new Block340();
	_blocks_[341] = new Block341();
	_blocks_[342] = new Block342();
	_blocks_[343] = new Block343();
	_blocks_[344] = new Block344();
	_blocks_[345] = new Block345();
	_blocks_[346] = new Block346();
	_blocks_[347] = new Block347();
	_blocks_[348] = new Block348();
	_blocks_[349] = new Block349();
	_blocks_[350] = new Block350();
	_blocks_[351] = new Block351();
	_blocks_[352] = new Block352();
	_blocks_[353] = new Block353();
	_blocks_[354] = new Block354();
	_blocks_[355] = new Block355();
	_blocks_[356] = new Block356();
	_blocks_[357] = new Block357();
	_blocks_[358] = new Block358();
	_blocks_[359] = new Block359();
	_blocks_[360] = new Block360();
	_blocks_[361] = new Block361();
	_blocks_[362] = new Block362();
	_blocks_[363] = new Block363();
	_blocks_[364] = new Block364();
	_blocks_[365] = new Block365();
	_blocks_[366] = new Block366();
	_blocks_[367] = new Block367();
	_blocks_[368] = new Block368();
	_blocks_[369] = new Block369();
	_blocks_[370] = new Block370();
	_blocks_[371] = new Block371();
	_blocks_[372] = new Block372();
	_blocks_[373] = new Block373();
	_blocks_[374] = new Block374();
	_blocks_[375] = new Block375();
	_blocks_[376] = new Block376();
	_blocks_[377] = new Block377();
	_blocks_[378] = new Block378();
	_blocks_[379] = new Block379();
	_blocks_[380] = new Block380();
	_blocks_[381] = new Block381();
	_blocks_[382] = new Block382();
	_blocks_[383] = new Block383();
	_blocks_[384] = new Block384();
	_blocks_[385] = new Block385();
	_blocks_[386] = new Block386();
	_blocks_[387] = new Block387();
	_blocks_[388] = new Block388();
	_blocks_[389] = new Block389();
	_blocks_[390] = new Block390();
	_blocks_[391] = new Block391();
	_blocks_[392] = new Block392();
	_blocks_[393] = new Block393();
	_blocks_[394] = new Block394();
	_blocks_[395] = new Block395();
	_blocks_[396] = new Block396();
	_blocks_[397] = new Block397();
	_blocks_[398] = new Block398();
	_blocks_[399] = new Block399();
	_blocks_[400] = new Block400();
	_blocks_[401] = new Block401();
	_blocks_[402] = new Block402();
	_blocks_[403] = new Block403();
	_blocks_[404] = new Block404();
	_blocks_[405] = new Block405();
	_blocks_[406] = new Block406();
	_blocks_[407] = new Block407();
	_blocks_[408] = new Block408();
	_blocks_[409] = new Block409();
	_blocks_[410] = new Block410();
	_blocks_[411] = new Block411();
	_blocks_[412] = new Block412();
	_blocks_[413] = new Block413();
	_blocks_[414] = new Block414();
	_blocks_[415] = new Block415();
	_blocks_[416] = new Block416();
	_blocks_[417] = new Block417();
	_blocks_[418] = new Block418();
	_blocks_[419] = new Block419();
	_blocks_[420] = new Block420();
	_blocks_[421] = new Block421();
	_blocks_[422] = new Block422();
	_blocks_[423] = new Block423();
	_blocks_[424] = new Block424();
	_blocks_[425] = new Block425();
	_blocks_[426] = new Block426();
	_blocks_[427] = new Block427();
	_blocks_[428] = new Block428();
	_blocks_[429] = new Block429();
	_blocks_[430] = new Block430();
	_blocks_[431] = new Block431();
	_blocks_[432] = new Block432();
	_blocks_[433] = new Block433();
	_blocks_[434] = new Block434();
	_blocks_[435] = new Block435();
	_blocks_[436] = new Block436();
	_blocks_[437] = new Block437();
	_blocks_[438] = new Block438();
	_blocks_[439] = new Block439();
	_blocks_[440] = new Block440();
	_blocks_[441] = new Block441();
	_blocks_[442] = new Block442();
	_blocks_[443] = new Block443();
	_blocks_[444] = new Block444();
	_blocks_[445] = new Block445();
	_blocks_[446] = new Block446();
	_blocks_[447] = new Block447();
	_blocks_[448] = new Block448();
	_blocks_[449] = new Block449();
	_blocks_[450] = new Block450();
	_blocks_[451] = new Block451();
	_blocks_[452] = new Block452();
	_blocks_[453] = new Block453();
	_blocks_[454] = new Block454();

	// fill the lookup table
	ArrayResize(fxdBlocksLookupTable, ArraySize(_blocks_));
	for (int i=0; i<ArraySize(_blocks_); i++)
	{
		fxdBlocksLookupTable[i] = _blocks_[i].__block_user_number;
	}

	// fill the list of inbound blocks for each BlockCalls instance
	for (int i=0; i<ArraySize(_blocks_); i++)
	{
		_blocks_[i].__announceThisBlock();
	}

	// List of initially disabled blocks
	int disabled_blocks_list[] = {};
	for (int l = 0; l < ArraySize(disabled_blocks_list); l++) {
		_blocks_[disabled_blocks_list[l]].__disabled = true;
	}



	FXD_MILS_INIT_END     = (double)GetTickCount();
	FXD_FIRST_TICK_PASSED = false; // reset is needed when changing inputs

	return(INIT_SUCCEEDED);
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on every incoming tick //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTick()
{
	FXD_TICKS_FROM_START++;

	if (ENABLE_STATUS && FXD_TICKS_FROM_START == 1) DrawStatus("working");

	//-- special system actions
	if (FXD_DRAW_SPREAD_INFO) DrawSpreadInfo();
	TicksData(""); // Collect ticks (if needed)
	TicksPerSecond(false, true); // Collect ticks per second
	if (USE_VIRTUAL_STOPS) {VirtualStopsDriver();}

	ExpirationDriver();
	OCODriver(); // Check and close OCO orders
	if (ENABLE_EVENT_TRADE) {OnTrade();}

	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {8,9,24,25,26,27,30,31,32,33,34,35,36,37,38,39,52,53,54,55,58,59,60,61,62,63,64,65,66,67,80,81,82,83,86,87,88,89,90,91,92,93,94,95,108,109,110,111,114,115,116,117,118,119,120,121,122,123,136,137,138,139,142,143,144,145,146,147,148,149,150,151,164,165,166,167,170,171,172,173,174,175,176,177,178,179,192,193,194,195,198,199,200,201,202,203,204,205,206,207,220,221,222,223,226,227,228,229,230,231,232,233,234,235,446,453};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	return;
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on trade events - open, close, modify //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTrade()
{
	OnTradeQueue(1);


	OnTradeQueue(-1);
}


//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on a period basis //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTimer()
{

}


//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed when chart event happens //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnChartEvent(
	const int id,         // Event ID
	const long& lparam,   // Parameter of type long event
	const double& dparam, // Parameter of type double event
	const string& sparam  // Parameter of type string events
)
{
	//-- write parameter to the system global variables
	FXD_ONCHART.id     = id;
	FXD_ONCHART.lparam = lparam;
	FXD_ONCHART.dparam = dparam;
	FXD_ONCHART.sparam = sparam;


	return;
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed once when the program ends //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnDeinit(const int reason)
{
	int reson = UninitializeReason();
	if (reson == REASON_CHARTCHANGE || reson == REASON_PARAMETERS || reason == REASON_TEMPLATE) {return;}

	//-- if Timer was set, kill it here
	EventKillTimer();

	if (ENABLE_STATUS) DrawStatus("stopped");
	if (ENABLE_SPREAD_METER) DrawSpreadInfo();



	if (MQLInfoInteger(MQL_TESTER)) {
		Print("Backtested in "+DoubleToString((GetTickCount()-FXD_MILS_INIT_END)/1000, 2)+" seconds");
		double tc = GetTickCount()-FXD_MILS_INIT_END;
		if (tc > 0)
		{
			Print("Average ticks per second: "+DoubleToString(FXD_TICKS_FROM_START/tc, 0));
		}
	}

	if (MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_EXPERT)
	{
		switch(UninitializeReason())
		{
			case REASON_PROGRAM		: Print("Expert Advisor self terminated"); break;
			case REASON_REMOVE		: Print("Expert Advisor removed from the chart"); break;
			case REASON_RECOMPILE	: Print("Expert Advisor has been recompiled"); break;
			case REASON_CHARTCHANGE	: Print("Symbol or chart period has been changed"); break;
			case REASON_CHARTCLOSE	: Print("Chart has been closed"); break;
			case REASON_PARAMETERS	: Print("Input parameters have been changed by a user"); break;
			case REASON_ACCOUNT		: Print("Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings"); break;
			case REASON_TEMPLATE		: Print("A new template has been applied"); break;
			case REASON_INITFAILED	: Print("OnInit() handler has returned a nonzero value"); break;
			case REASON_CLOSE			: Print("Terminal has been closed"); break;
		}
	}

	// delete dynamic pointers
	for (int i=0; i<ArraySize(_blocks_); i++)
	{
		delete _blocks_[i];
		_blocks_[i] = NULL;
	}
	ArrayResize(_blocks_, 0);

	return;
}

/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                             Classes of blocks                                                    | //
// |              Classes that contain the actual code of the blocks and their input parameters as well               | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/

/**
	The base class for all block calls
   */
class BlockCalls
{
	public:
		bool __disabled; // whether or not the block is disabled

		string __block_user_number;
        int __block_number;
		int __block_waiting;
		int __parent_number;
		int __inbound_blocks[];
		int __outbound_blocks[];

		void __addInboundBlock(int id = 0) {
			int size = ArraySize(__inbound_blocks);
			for (int i = 0; i < size; i++) {
				if (__inbound_blocks[i] == id) {
					return;
				}
			}
			ArrayResize(__inbound_blocks, size + 1);
			__inbound_blocks[size] = id;
		}

		void BlockCalls() {
			__disabled          = false;
			__block_user_number = "";
			__block_number      = 0;
			__block_waiting     = 0;
			__parent_number     = 0;
		}

		/**
		   Announce this block to the list of inbound connections of all the blocks to which this block is connected to
		   */
		void __announceThisBlock()
		{
		   // add the current block number to the list of inbound blocks
		   // for each outbound block that is provided
			for (int i = 0; i < ArraySize(__outbound_blocks); i++)
			{
				int block = __outbound_blocks[i]; // outbound block number
				int size  = ArraySize(_blocks_[block].__inbound_blocks); // the size of its inbound list

				// skip if the current block was already added
				for (int j = 0; j < size; j++) {
					if (_blocks_[block].__inbound_blocks[j] == __block_number)
					{
						return;
					}
				}

				// add the current block number to the list of inbound blocks of the other block
				ArrayResize(_blocks_[block].__inbound_blocks, size + 1);
				_blocks_[block].__inbound_blocks[size] = __block_number;
			}
		}

		// this is here, because it is used in the "run" function
		virtual void _execute_() = 0;

		/**
			In the derived class this method should be used to set dynamic parameters or other stuff before the main execute.
			This method is automatically called within the main "run" method below, before the execution of the main class.
			*/
		virtual void _beforeExecute_() {return;};
		bool _beforeExecuteEnabled; // for speed

		/**
			Same as _beforeExecute_, but to work after the execute method.
			*/
		virtual void _afterExecute_() {return;};
		bool _afterExecuteEnabled; // for speed

		/**
			This is the method that is used to run the block
			*/
		virtual void run(int _parent_=0) {
			__parent_number = _parent_;
			if (__disabled || FXD_BREAK) {return;}
			FXD_CURRENT_FUNCTION_ID = __block_number;

			if (_beforeExecuteEnabled) {_beforeExecute_();}
			_execute_();
			if (_afterExecuteEnabled) {_afterExecute_();}

			if (__block_waiting && FXD_CURRENT_FUNCTION_ID == __block_number) {fxdWait.Accumulate(FXD_CURRENT_FUNCTION_ID);}
		}
};

BlockCalls *_blocks_[];


// "Weekday filter" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8>
class MDL_WeekdayFilter: public BlockCalls
{
	public: /* Input Parameters */
	T1 ServerOrLocalTime;
	T2 tradeMonday;
	T3 tradeTuesday;
	T4 tradeWednesday;
	T5 tradeThursday;
	T6 tradeFriday;
	T7 tradeSaturday;
	T8 tradeSunday;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_WeekdayFilter()
	{
		ServerOrLocalTime = (string)"server";
		tradeMonday = (bool)true;
		tradeTuesday = (bool)true;
		tradeWednesday = (bool)true;
		tradeThursday = (bool)true;
		tradeFriday = (bool)true;
		tradeSaturday = (bool)false;
		tradeSunday = (bool)false;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int day = 0;
		
		     if (ServerOrLocalTime == "server") {day = TimeDayOfWeek(TimeCurrent());}
		else if (ServerOrLocalTime == "local")  {day = TimeDayOfWeek(TimeLocal());}
		else if (ServerOrLocalTime == "gmt")    {day = TimeDayOfWeek(TimeGMT());}
		
		if (
			   (tradeMonday    && day == 1)
			|| (tradeTuesday   && day == 2)
			|| (tradeWednesday && day == 3)
			|| (tradeThursday  && day == 4)
			|| (tradeFriday    && day == 5)
			|| (tradeSaturday  && day == 6)
			|| (tradeSunday    && day == 0)
			)
		{
		   _callback_(1);
		}
		else
		{
		   _callback_(0);
		}
	}
};

// "Check positions count" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7>
class MDL_CheckTradesCount: public BlockCalls
{
	public: /* Input Parameters */
	T1 Compare;
	T2 CompareCount;
	T3 GroupMode;
	T4 Group;
	T5 SymbolMode;
	T6 Symbol;
	T7 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CheckTradesCount()
	{
		Compare = (string)">";
		CompareCount = (int)3;
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int count = 0;
		
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				count++;
			}
		}
		
		if (compare(Compare, count, CompareCount)) {_callback_(1);} else {_callback_(0);}
	}
};

// "Modify Variables" model
template<typename T1,typename T2,typename _T2_,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename _T6_,typename T7,typename T8,typename _T8_,typename T9,typename T10,typename _T10_>
class MDL_ModifyVariables: public BlockCalls
{
	public: /* Input Parameters */
	T1 Variable1;
	T2 Value1; virtual _T2_ _Value1_(){return(_T2_)0;}
	T3 Variable2;
	T4 Value2; virtual _T4_ _Value2_(){return(_T4_)0;}
	T5 Variable3;
	T6 Value3; virtual _T6_ _Value3_(){return(_T6_)0;}
	T7 Variable4;
	T8 Value4; virtual _T8_ _Value4_(){return(_T8_)0;}
	T9 Variable5;
	T10 Value5; virtual _T10_ _Value5_(){return(_T10_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ModifyVariables()
	{
		Variable1 = (int)0;
		Variable2 = (int)0;
		Variable3 = (int)0;
		Variable4 = (int)0;
		Variable5 = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// nothing here, because the actual code is generated in the generator
		// _Value1_()
		// _Value2_()
		// _Value3_()
		// _Value4_()
		// _Value5_()
		_callback_(1);
	}
};

// "Custom MQL code" model
template<typename T1>
class MDL_CustomCode: public BlockCalls
{
	public: /* Input Parameters */
	T1 SourceCode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CustomCode()
	{
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//_SourceCode_()
		
		_callback_(1);
	}
};

// "Comment" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename T18,typename _T18_,typename T19,typename T20,typename _T20_,typename T21,typename T22,typename _T22_,typename T23,typename T24,typename _T24_,typename T25,typename T26,typename _T26_,typename T27,typename T28,typename _T28_,typename T29,typename T30,typename _T30_>
class MDL_CommentEx: public BlockCalls
{
	public: /* Input Parameters */
	T1 Title;
	T2 ObjChartSubWindow;
	T3 ObjCorner;
	T4 ObjX;
	T5 ObjY;
	T6 ObjTitleFont;
	T7 ObjTitleFontColor;
	T8 ObjTitleFontSize;
	T9 ObjLabelsFont;
	T10 ObjLabelsFontColor;
	T11 ObjLabelsFontSize;
	T12 ObjFont;
	T13 ObjFontColor;
	T14 ObjFontSize;
	T15 Label1;
	T16 Value1; virtual _T16_ _Value1_(){return(_T16_)0;}
	T17 Label2;
	T18 Value2; virtual _T18_ _Value2_(){return(_T18_)0;}
	T19 Label3;
	T20 Value3; virtual _T20_ _Value3_(){return(_T20_)0;}
	T21 Label4;
	T22 Value4; virtual _T22_ _Value4_(){return(_T22_)0;}
	T23 Label5;
	T24 Value5; virtual _T24_ _Value5_(){return(_T24_)0;}
	T25 Label6;
	T26 Value6; virtual _T26_ _Value6_(){return(_T26_)0;}
	T27 Label7;
	T28 Value7; virtual _T28_ _Value7_(){return(_T28_)0;}
	T29 Label8;
	T30 Value8; virtual _T30_ _Value8_(){return(_T30_)0;}
	/* Static Parameters */
	bool initialized;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CommentEx()
	{
		Title = (string)"Comment Message";
		ObjChartSubWindow = (string)"";
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjX = (int)5;
		ObjY = (int)24;
		ObjTitleFont = (string)"Georgia";
		ObjTitleFontColor = (color)clrGold;
		ObjTitleFontSize = (int)13;
		ObjLabelsFont = (string)"Verdana";
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjLabelsFontSize = (int)10;
		ObjFont = (string)"Verdana";
		ObjFontColor = (color)clrWhite;
		ObjFontSize = (int)10;
		Label1 = (string)"";
		Label2 = (string)"";
		Label3 = (string)"";
		Label4 = (string)"";
		Label5 = (string)"";
		Label6 = (string)"";
		Label7 = (string)"";
		Label8 = (string)"";
		/* Static Parameters (initial value) */
		initialized =  false;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (!MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_VISUAL_MODE))
		{
			
		
			long ObjChartID = 0;
			int ObjAnchor   = ANCHOR_LEFT;
		
			if (ObjCorner == CORNER_RIGHT_UPPER || ObjCorner == CORNER_RIGHT_LOWER)
			{
				ObjAnchor = ANCHOR_RIGHT;
			}
		
			string namebase = "fxd_cmnt_" + __block_user_number;
		
			int subwindow = WindowFindVisible(ObjChartID, ObjChartSubWindow);
		
			if (subwindow >= 0)
			{
				//-- draw comment title
				if ((string)Title != "")
				{
					string nametitle = namebase;
		
					if(ObjectFind(ObjChartID, nametitle) < 0)
					{
						if (!ObjectCreate(ObjChartID, nametitle, OBJ_LABEL, subwindow, 0, 0, 0, 0))
						{
							Print(__FUNCTION__, ": failed to create text object! Error code = ", GetLastError());
						}
						else
						{
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_FONTSIZE, (int)(ObjTitleFontSize));
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_COLOR, ObjTitleFontColor);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_BACK, 0);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_SELECTABLE, 1);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_SELECTED, 0);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_HIDDEN, 1);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_CORNER, ObjCorner);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_ANCHOR, ObjAnchor);
		
							ObjectSetString(ObjChartID, nametitle, OBJPROP_FONT, ObjTitleFont);
		
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_XDISTANCE, ObjX);
							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_YDISTANCE, ObjY);
						}
					}
					else
					{
						ObjX = (int)ObjectGetInteger(ObjChartID, nametitle, OBJPROP_XDISTANCE);
						ObjY = (int)ObjectGetInteger(ObjChartID, nametitle, OBJPROP_YDISTANCE);
					}
		
					ObjectSetString(ObjChartID, nametitle, OBJPROP_TEXT, (string)Title);
		
					ObjY = (int)(ObjY + ObjTitleFontSize / 3);
				}
		
				//-- draw comment rows
				for (int i = 1; i <= 8; i++)
				{
					string text    = "";
					string textlbl = "";
		
					switch(i)
					{
						case 1: if (Label1 != "") {textlbl = Label1; text = (string)(_Value1_());} break;
						case 2: if (Label2 != "") {textlbl = Label2; text = (string)(_Value2_());} break;
						case 3: if (Label3 != "") {textlbl = Label3; text = (string)(_Value3_());} break;
						case 4: if (Label4 != "") {textlbl = Label4; text = (string)(_Value4_());} break;
						case 5: if (Label5 != "") {textlbl = Label5; text = (string)(_Value5_());} break;
						case 6: if (Label6 != "") {textlbl = Label6; text = (string)(_Value6_());} break;
						case 7: if (Label7 != "") {textlbl = Label7; text = (string)(_Value7_());} break;
						case 8: if (Label8 != "") {textlbl = Label8; text = (string)(_Value8_());} break;
				   }
		
					string name    = namebase + "_" + (string)i;
					string namelbl = name + "_l";
		
					if (textlbl == "")
					{
						if (!initialized)
						{
							//-- pre-delete
							ObjectDelete(ObjChartID, namelbl);
							ObjectDelete(ObjChartID, name);
						}
		
						continue;
					}
		
					//-- draw initial objects
					if(ObjectFind(ObjChartID, name) < 0)
					{
						if (textlbl == "")
						{
							continue;
						}
		
						if (ObjectCreate(ObjChartID, namelbl, OBJ_LABEL, subwindow, 0, 0, 0, 0))
						{
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_CORNER, ObjCorner);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_ANCHOR, ObjAnchor);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_BACK, 0);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_SELECTABLE, 0);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_SELECTED, 0);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_HIDDEN, 1);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_FONTSIZE, ObjLabelsFontSize);
							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_COLOR, ObjLabelsFontColor);
							ObjectSetString(ObjChartID, namelbl, OBJPROP_FONT, ObjLabelsFont);
						}
						else
						{
							Print(__FUNCTION__, ": failed to create text object! Error code = ", GetLastError());
						}
		
						if (ObjectCreate(ObjChartID, name, OBJ_LABEL, subwindow, 0, 0, 0, 0))
						{
							ObjectSetInteger(ObjChartID, name, OBJPROP_CORNER, ObjCorner);
							ObjectSetInteger(ObjChartID, name, OBJPROP_ANCHOR, ObjAnchor);
							ObjectSetInteger(ObjChartID, name, OBJPROP_BACK, 0);
							ObjectSetInteger(ObjChartID, name, OBJPROP_SELECTABLE, 0);
							ObjectSetInteger(ObjChartID, name, OBJPROP_SELECTED, 0);
							ObjectSetInteger(ObjChartID, name, OBJPROP_HIDDEN, 1);
							ObjectSetInteger(ObjChartID, name, OBJPROP_FONTSIZE, ObjFontSize);
							ObjectSetInteger(ObjChartID, name, OBJPROP_COLOR, ObjFontColor);
							ObjectSetString(ObjChartID, name, OBJPROP_FONT, ObjFont);
						}
						else
						{
							Print(__FUNCTION__, ": failed to create text object! Error code = ", GetLastError());
						}
					}
					else
					{
						if (textlbl == "")
						{
							ObjectDelete(ObjChartID, namelbl);
							ObjectDelete(ObjChartID, name);
							continue;
						}
					}
		
					ObjY  = (int)(ObjY + ObjFontSize + ObjFontSize/2);
		
					//-- update label objects
					ObjectSetInteger(ObjChartID, namelbl, OBJPROP_XDISTANCE, ObjX);
					ObjectSetInteger(ObjChartID, namelbl, OBJPROP_YDISTANCE, ObjY);
					ObjectSetString(ObjChartID, namelbl, OBJPROP_TEXT, (string)textlbl);
		
					//-- update value objects
					int x        = 0;
					int xsizelbl = (int)ObjectGetInteger(ObjChartID, namelbl, OBJPROP_XSIZE);
		
					if (xsizelbl == 0) {
						//-- when the object is newly created, it returns 0 for XSIZE and YSIZE, so here we will trick it somehow
						xsizelbl = (int)(StringLen((string)textlbl) * ObjFontSize / 1.5 + ObjFontSize / 2);
					}
		
					x = ObjX + (xsizelbl + ObjFontSize/2);
		
					ObjectSetInteger(ObjChartID, name, OBJPROP_XDISTANCE, x);
					ObjectSetInteger(ObjChartID, name, OBJPROP_YDISTANCE, ObjY);
					ObjectSetString(ObjChartID, name, OBJPROP_TEXT, (string)text);
				}
				
				ChartRedraw();
			}
		
			initialized = true;
		}
		
		_callback_(1);
	}
};

// "Condition" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_,typename T4>
class MDL_Condition: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	T4 crosswidth;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Condition()
	{
		compare = (string)">";
		crosswidth = (int)1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool output1 = false, output2 = false; // output 1 and output 2
		int crossover = 0;
		
		if (compare == "x>" || compare == "x<") {crossover = 1;}
		
		for (int i = 0; i <= crossover; i++)
		{
			// i=0 - normal pass, i=1 - crossover pass
		
			// Left operand of the condition
			FXD_MORE_SHIFT = i * crosswidth;
			_T1_ lo = _Lo_();
			if (MathAbs(lo) == EMPTY_VALUE) {return;}
		
			// Right operand of the condition
			FXD_MORE_SHIFT = i * crosswidth;
			_T3_ ro = _Ro_();
			if (MathAbs(ro) == EMPTY_VALUE) {return;}
		
			// Conditions
			if (CompareValues(compare, lo, ro))
			{
				if (i == 0)
				{
					output1 = true;
				}
			}
			else
			{
				if (i == 0)
				{
					output2 = true;
				}
				else
				{
					output2 = false;
				}
			}
		
			if (crossover == 1)
			{
				if (CompareValues(compare, ro, lo))
				{
					if (i == 0)
					{
						output2 = true;
					}
				}
				else
				{
					if (i == 1)
					{
						output1 = false;
					}
				}
			}
		}
		
		FXD_MORE_SHIFT = 0; // reset
		
			  if (output1 == true) {_callback_(1);}
		else if (output2 == true) {_callback_(0);}
	}
};

// "Set "Current Market" for next blocks" model
template<typename T1>
class MDL_SetCurrentSymbol2: public BlockCalls
{
	public: /* Input Parameters */
	T1 ListOfSymbols;
	/* Static Parameters */
	string symbols0;
	string symbols[];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_SetCurrentSymbol2()
	{
		ListOfSymbols = (string)"EURUSD,GBPUSD,AUDUSD";
		/* Static Parameters (initial value) */
		symbols0 =  "";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int i,s,size;
		
		//-- explode and correct symbols list, then check for existence
		if (ListOfSymbols != symbols0)
		{
			string symbols_tmp[];
		
			//- explode
			symbols0 = ListOfSymbols;
			StringExplode(",", ListOfSymbols, symbols_tmp);
		
			//- trim
			size = ArraySize(symbols_tmp);
		
			for (i=0; i<size; i++) {
				symbols_tmp[i] = StringTrim(symbols_tmp[i]);
			}
		
			//- check for existence
			string symbols_all[];
			SymbolsList(symbols_all, false);
		
			s = 0;
			ArrayResize(symbols, size);
		
			for (i=0; i<size; i++)
			{
				//- exclude non-existing symbol
				if (ArraySearch(symbols_all, symbols_tmp[i]) == -1)
				{
					Alert("Symbol " + symbols_tmp[i] + " does not exists and will be excluded from the list in block #" + __block_user_number);
					continue;
				}
		
				symbols[s] = symbols_tmp[i];
				s++;
			}
		
			ArrayResize(symbols, s);
		}
		
		// Create a loop
		size = ArraySize(symbols);
		
		for (i=0; i<size; i++)
		{
			CurrentSymbol(symbols[i]);
			_callback_(1);
		}
		
		CurrentSymbol(Symbol()); // Reset the current symbol
		_callback_(0);
	}
};

// "Buy now" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename _T36_,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename T40,typename T41,typename T42,typename T43,typename _T43_,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename T47,typename T48,typename T49,typename T50,typename _T50_,typename T51,typename T52,typename T53>
class MDL_BuyNow: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 VolumeMode;
	T4 VolumeSize;
	T5 VolumeSizeRisk;
	T6 VolumeRisk;
	T7 VolumePercent;
	T8 VolumeBlockPercent;
	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;}
	T10 FixedRatioUnitSize;
	T11 FixedRatioDelta;
	T12 mmMgInitialLots;
	T13 mmMgMultiplyOnLoss;
	T14 mmMgMultiplyOnProfit;
	T15 mmMgAddLotsOnLoss;
	T16 mmMgAddLotsOnProfit;
	T17 mmMgResetOnLoss;
	T18 mmMgResetOnProfit;
	T19 mm1326InitialLots;
	T20 mm1326Reverse;
	T21 mmFiboInitialLots;
	T22 mmDalembertInitialLots;
	T23 mmDalembertReverse;
	T24 mmLabouchereInitialLots;
	T25 mmLabouchereList;
	T26 mmLabouchereReverse;
	T27 mmSeqBaseLots;
	T28 mmSeqOnLoss;
	T29 mmSeqOnProfit;
	T30 mmSeqReverse;
	T31 VolumeUpperLimit;
	T32 StopLossMode;
	T33 StopLossPips;
	T34 StopLossPercentPrice;
	T35 StopLossPercentTP;
	T36 dlStopLoss; virtual _T36_ _dlStopLoss_(){return(_T36_)0;}
	T37 dpStopLoss; virtual _T37_ _dpStopLoss_(){return(_T37_)0;}
	T38 ddStopLoss; virtual _T38_ _ddStopLoss_(){return(_T38_)0;}
	T39 TakeProfitMode;
	T40 TakeProfitPips;
	T41 TakeProfitPercentPrice;
	T42 TakeProfitPercentSL;
	T43 dlTakeProfit; virtual _T43_ _dlTakeProfit_(){return(_T43_)0;}
	T44 dpTakeProfit; virtual _T44_ _dpTakeProfit_(){return(_T44_)0;}
	T45 ddTakeProfit; virtual _T45_ _ddTakeProfit_(){return(_T45_)0;}
	T46 ExpMode;
	T47 ExpDays;
	T48 ExpHours;
	T49 ExpMinutes;
	T50 dExp; virtual _T50_ _dExp_(){return(_T50_)0;}
	T51 Slippage;
	T52 MyComment;
	T53 ArrowColorBuy;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_BuyNow()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		VolumeMode = (string)"fixed";
		VolumeSize = (double)0.1;
		VolumeSizeRisk = (double)50.0;
		VolumeRisk = (double)2.5;
		VolumePercent = (double)100.0;
		VolumeBlockPercent = (double)3.0;
		FixedRatioUnitSize = (double)0.01;
		FixedRatioDelta = (double)20.0;
		mmMgInitialLots = (double)0.1;
		mmMgMultiplyOnLoss = (double)2.0;
		mmMgMultiplyOnProfit = (double)1.0;
		mmMgAddLotsOnLoss = (double)0.0;
		mmMgAddLotsOnProfit = (double)0.0;
		mmMgResetOnLoss = (int)0;
		mmMgResetOnProfit = (int)1;
		mm1326InitialLots = (double)0.1;
		mm1326Reverse = (bool)false;
		mmFiboInitialLots = (double)0.1;
		mmDalembertInitialLots = (double)0.1;
		mmDalembertReverse = (bool)false;
		mmLabouchereInitialLots = (double)0.1;
		mmLabouchereList = (string)"1,2,3,4,5,6";
		mmLabouchereReverse = (bool)false;
		mmSeqBaseLots = (double)0.1;
		mmSeqOnLoss = (string)"3,2,6";
		mmSeqOnProfit = (string)"1";
		mmSeqReverse = (bool)false;
		VolumeUpperLimit = (double)0.0;
		StopLossMode = (string)"fixed";
		StopLossPips = (double)50.0;
		StopLossPercentPrice = (double)0.55;
		StopLossPercentTP = (double)100.0;
		TakeProfitMode = (string)"fixed";
		TakeProfitPips = (double)50.0;
		TakeProfitPercentPrice = (double)0.55;
		TakeProfitPercentSL = (double)100.0;
		ExpMode = (string)"GTC";
		ExpDays = (int)0;
		ExpHours = (int)1;
		ExpMinutes = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorBuy = (color)clrBlue;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = SymbolAsk(Symbol) - (SymbolAsk(Symbol) * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = SymbolAsk(Symbol) + (SymbolAsk(Symbol) * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP") {
		   if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
		   if (tpl > 0) {slp = toPips(MathAbs(SymbolAsk(Symbol) - tpl), Symbol)*StopLossPercentTP/100;}
		}
		if (TakeProfitMode == "percentSL") {
		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
		   if (sll > 0) {tpp = toPips(MathAbs(SymbolAsk(Symbol) - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {
			pre_sll = SymbolAsk(Symbol);
		}
		
		double pre_sl_pips = toPips(SymbolAsk(Symbol)-(pre_sll-toDigits(slp,Symbol)), Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mm1326InitialLots, mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmDalembertInitialLots, mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = BuyNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorBuy, exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Sell now" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename _T36_,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename T40,typename T41,typename T42,typename T43,typename _T43_,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename T47,typename T48,typename T49,typename T50,typename _T50_,typename T51,typename T52,typename T53>
class MDL_SellNow: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 VolumeMode;
	T4 VolumeSize;
	T5 VolumeSizeRisk;
	T6 VolumeRisk;
	T7 VolumePercent;
	T8 VolumeBlockPercent;
	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;}
	T10 FixedRatioUnitSize;
	T11 FixedRatioDelta;
	T12 mmMgInitialLots;
	T13 mmMgMultiplyOnLoss;
	T14 mmMgMultiplyOnProfit;
	T15 mmMgAddLotsOnLoss;
	T16 mmMgAddLotsOnProfit;
	T17 mmMgResetOnLoss;
	T18 mmMgResetOnProfit;
	T19 mm1326InitialLots;
	T20 mm1326Reverse;
	T21 mmFiboInitialLots;
	T22 mmDalembertInitialLots;
	T23 mmDalembertReverse;
	T24 mmLabouchereInitialLots;
	T25 mmLabouchereList;
	T26 mmLabouchereReverse;
	T27 mmSeqBaseLots;
	T28 mmSeqOnLoss;
	T29 mmSeqOnProfit;
	T30 mmSeqReverse;
	T31 VolumeUpperLimit;
	T32 StopLossMode;
	T33 StopLossPips;
	T34 StopLossPercentPrice;
	T35 StopLossPercentTP;
	T36 dlStopLoss; virtual _T36_ _dlStopLoss_(){return(_T36_)0;}
	T37 dpStopLoss; virtual _T37_ _dpStopLoss_(){return(_T37_)0;}
	T38 ddStopLoss; virtual _T38_ _ddStopLoss_(){return(_T38_)0;}
	T39 TakeProfitMode;
	T40 TakeProfitPips;
	T41 TakeProfitPercentPrice;
	T42 TakeProfitPercentSL;
	T43 dlTakeProfit; virtual _T43_ _dlTakeProfit_(){return(_T43_)0;}
	T44 dpTakeProfit; virtual _T44_ _dpTakeProfit_(){return(_T44_)0;}
	T45 ddTakeProfit; virtual _T45_ _ddTakeProfit_(){return(_T45_)0;}
	T46 ExpMode;
	T47 ExpDays;
	T48 ExpHours;
	T49 ExpMinutes;
	T50 dExp; virtual _T50_ _dExp_(){return(_T50_)0;}
	T51 Slippage;
	T52 MyComment;
	T53 ArrowColorSell;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_SellNow()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		VolumeMode = (string)"fixed";
		VolumeSize = (double)0.1;
		VolumeSizeRisk = (double)50.0;
		VolumeRisk = (double)2.5;
		VolumePercent = (double)100.0;
		VolumeBlockPercent = (double)3.0;
		FixedRatioUnitSize = (double)0.01;
		FixedRatioDelta = (double)20.0;
		mmMgInitialLots = (double)0.1;
		mmMgMultiplyOnLoss = (double)2.0;
		mmMgMultiplyOnProfit = (double)1.0;
		mmMgAddLotsOnLoss = (double)0.0;
		mmMgAddLotsOnProfit = (double)0.0;
		mmMgResetOnLoss = (int)0;
		mmMgResetOnProfit = (int)1;
		mm1326InitialLots = (double)0.1;
		mm1326Reverse = (bool)false;
		mmFiboInitialLots = (double)0.1;
		mmDalembertInitialLots = (double)0.1;
		mmDalembertReverse = (bool)false;
		mmLabouchereInitialLots = (double)0.1;
		mmLabouchereList = (string)"1,2,3,4,5,6";
		mmLabouchereReverse = (bool)false;
		mmSeqBaseLots = (double)0.1;
		mmSeqOnLoss = (string)"3,2,6";
		mmSeqOnProfit = (string)"1";
		mmSeqReverse = (bool)false;
		VolumeUpperLimit = (double)0.0;
		StopLossMode = (string)"fixed";
		StopLossPips = (double)50.0;
		StopLossPercentPrice = (double)0.55;
		StopLossPercentTP = (double)100.0;
		TakeProfitMode = (string)"fixed";
		TakeProfitPips = (double)50.0;
		TakeProfitPercentPrice = (double)0.55;
		TakeProfitPercentSL = (double)100.0;
		ExpMode = (string)"GTC";
		ExpDays = (int)0;
		ExpHours = (int)1;
		ExpMinutes = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorSell = (color)clrRed;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = SymbolBid(Symbol) + (SymbolBid(Symbol) * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = SymbolBid(Symbol) - (SymbolBid(Symbol) * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP") {
		   if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
		   if (tpl > 0) {slp = toPips(MathAbs(SymbolBid(Symbol) - tpl), Symbol)*StopLossPercentTP/100;}
		}
		if (TakeProfitMode == "percentSL") {
		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
		   if (sll > 0) {tpp = toPips(MathAbs(SymbolBid(Symbol) - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {
			pre_sll = SymbolBid(Symbol);
		}
		
		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-SymbolBid(Symbol), Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mm1326InitialLots, mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmDalembertInitialLots, mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = SellNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorSell, exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Pass" model
class MDL_Pass: public BlockCalls
{
	virtual void _callback_(int r) {return;}

	public: /* The main method */
	virtual void _execute_()
	{
		_callback_(1);
	}
};

// "No position nearby" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13>
class MDL_NoNearbyRunning: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 Time1; virtual _T6_ _Time1_(){return(_T6_)0;}
	T7 Time2; virtual _T7_ _Time2_(){return(_T7_)0;}
	T8 ModeBasePrice;
	T9 BasePrice; virtual _T9_ _BasePrice_(){return(_T9_)0;}
	T10 ModeRange;
	T11 RangePips;
	T12 RangeFraction;
	T13 RangePosition;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_NoNearbyRunning()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		ModeBasePrice = (string)"current";
		ModeRange = (string)"pips";
		RangePips = (double)10.0;
		RangeFraction = (double)0.0010;
		RangePosition = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int next               = true;
		double price           = 0;
		bool use_current_price = (ModeBasePrice == "current");
		
		// prepare the time filters
		datetime t1 = _Time1_();
		datetime t2 = _Time2_();
		
		if (t1 >= TimeCurrent()) t1 = 0;
		
		if (!use_current_price)
		{
			price = _BasePrice_();
		}
		
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				// filter by time
				if ((t1 < t2 && OrderOpenTime() < t1) || OrderOpenTime() > t2)
				{
					continue;
				}
		
				// what is the distance?
				double distance = RangeFraction;
		
				if (ModeRange == "pips") {distance = toDigits(RangePips, Symbol);}
		
				// checking the position
				if (OrderType() == 0) // buy?
				{
					if (use_current_price) {price = SymbolInfoDouble(Symbol, SYMBOL_ASK);}
		
					switch (RangePosition)
					{
						case 0: if (price <= (OrderOpenPrice() + distance/2) && price >= (OrderOpenPrice() - distance/2)) {next = false;} break;
						case 1: if (price <= OrderOpenPrice() + distance && price >= OrderOpenPrice()) {next = false;} break;
						case 2: if (price <= OrderOpenPrice() && price >= OrderOpenPrice() - distance) {next = false;} break;
					}
				}
				else
				{
					if (use_current_price) {price = SymbolInfoDouble(Symbol, SYMBOL_BID);}
		
					switch (RangePosition)
					{
						case 0: if (price <= (OrderOpenPrice() + distance/2) && price >= (OrderOpenPrice() - distance/2)) {next = false;} break;
						case 1: if (price <= OrderOpenPrice() && price >= OrderOpenPrice() - distance) {next = false;} break;
						case 2: if (price <= OrderOpenPrice() + distance && price >= OrderOpenPrice()) {next = false;} break;
					}
				}
		
				if (next == false) {break;}
			}
		}
		
		if (next == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "If position" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_IfOpenedOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_IfOpenedOrders()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool exist = false;
		
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				exist = true;
				break;
			}
		}
		
		if (exist == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Check profit (unrealized)" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13>
class MDL_CheckUProfit: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 EachProfitMode;
	T7 EachCompare;
	T8 EachProfitAmount;
	T9 EachProfitAmountPips;
	T10 ProfitMode;
	T11 Compare;
	T12 ProfitAmount;
	T13 ProfitAmountPips;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CheckUProfit()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		EachProfitMode = (string)"";
		EachCompare = (string)">";
		EachProfitAmount = (double)0.0;
		EachProfitAmountPips = (double)10.0;
		ProfitMode = (string)"money";
		Compare = (string)">";
		ProfitAmount = (double)0.0;
		ProfitAmountPips = (double)10.0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		double avg_price    = 0;
		double avg_load     = 0;
		double avg_lots     = 0;
		double profit_money = 0;
		double profit_pips  = 0;
		double pips_sum     = 0;
		int trades_count    = 0;
		
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				double trade_profit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
		
				if (EachProfitMode == "money")
				{
					if (compare(EachCompare, trade_profit, EachProfitAmount)) {/* do nothing */} else {continue;}
				}
				else if (EachProfitMode == "pips")
				{
					double individual_profit = toPips(OrderClosePrice() - OrderOpenPrice(), OrderSymbol());
					
					if (OrderType() == 1) {individual_profit = -1 * individual_profit;}
					
					if (compare(EachCompare, individual_profit, EachProfitAmountPips)) {/* do nothing*/} else {continue;}
				}
		
				profit_money += trade_profit;
		
				if (IsOrderTypeBuy() == true)
				{
					pips_sum += toPips(OrderClosePrice()-OrderOpenPrice(), OrderSymbol());
					avg_load += OrderOpenPrice() * OrderLots();
					avg_lots += OrderLots();
				}
				else
				{
					pips_sum += toPips(OrderOpenPrice()-OrderClosePrice(), OrderSymbol());
					avg_load -= OrderOpenPrice() * OrderLots();
					avg_lots -= OrderLots();
				}
		
				trades_count++;
			}
		}
		
		if (ProfitMode == "money" || ProfitMode == "pips")
		{
			avg_price = 0;
		
			if (avg_lots != 0)
			{
				avg_price = (avg_load / avg_lots);
			}
		
			if (avg_price != 0)
			{
				if (avg_lots > 0)
				{
					profit_pips = SymbolInfoDouble(Symbol, SYMBOL_BID) - avg_price;
				}
				else
				{
					profit_pips = avg_price - SymbolInfoDouble(Symbol, SYMBOL_ASK);
				}
		
				profit_pips = toPips(profit_pips, Symbol);
			}
		}
		
		if (
			   (ProfitMode == "money"    && (CompareValues(Compare, profit_money, ProfitAmount)))
			|| (ProfitMode == "pips"     && (CompareValues(Compare, profit_pips, ProfitAmountPips)))
			|| (ProfitMode == "pips-sum" && (CompareValues(Compare, pips_sum, ProfitAmountPips)))
			) {_callback_(1);} else {_callback_(0);}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_1: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_1()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::Percentx = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Close positions" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8>
class MDL_CloseOpened: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 OrderMinutes;
	T7 Slippage;
	T8 ArrowColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CloseOpened()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		OrderMinutes = (int)0;
		Slippage = (ulong)4;
		ArrowColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int closed_count = 0;
		bool finished    = false;
		
		while (finished == false)
		{
			int count = 0;
		
			for (int index = TradesTotal()-1; index >= 0; index--)
			{
				if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
				{
					datetime time_diff = TimeCurrent() - OrderOpenTime();
		
					if (time_diff < 0) {time_diff = 0;} // this actually happens sometimes
		
					if (time_diff >= 60 * OrderMinutes)
					{
						if (CloseTrade(OrderTicket(), Slippage, ArrowColor))
						{
							closed_count++;
						}
		
						count++;
					}
				}
			}
		
			if (count == 0) {finished = true;}
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_2: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_2()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::ATR_near = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_3: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_3()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::ATR_near = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_4: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_4()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::lotxxx = formula(compare, lo, ro);
		
		_callback_(1);
	}
};


//------------------------------------------------------------------------------------------------------------------------

// "Commodity Channel Index" model
class MDLIC_indicators_iCCI
{
	public: /* Input Parameters */
	int CCIperiod;
	ENUM_APPLIED_PRICE AppliedPrice;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iCCI()
	{
		CCIperiod = (int)14;
		AppliedPrice = (ENUM_APPLIED_PRICE)PRICE_CLOSE;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iCCI(Symbol, Period, CCIperiod, AppliedPrice, Shift + FXD_MORE_SHIFT);
	}
};

// "Text" model
class MDLIC_text_text
{
	public: /* Input Parameters */
	string Text;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_text_text()
	{
		Text = (string)"sample text";
	}

	public: /* The main method */
	string _execute_()
	{
		return Text;
	}
};

// "Numeric" model
class MDLIC_value_value
{
	public: /* Input Parameters */
	double Value;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_value_value()
	{
		Value = (double)1.0;
	}

	public: /* The main method */
	double _execute_()
	{
		return Value;
	}
};

// "Lowest Price (Candles period)" model
class MDLIC_prices_LowestFromToCandles
{
	public: /* Input Parameters */
	int StartBar;
	int EndBar;
	int WhatToGet;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_prices_LowestFromToCandles()
	{
		StartBar = (int)0;
		EndBar = (int)10;
		WhatToGet = (int)1;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}

	public: /* The main method */
	double _execute_()
	{
		return LowestFromTo(Symbol,Period,StartBar,EndBar,WhatToGet);
	}
};

// "Time" model
class MDLIC_value_time
{
	public: /* Input Parameters */
	int ModeTime;
	int TimeSource;
	string TimeStamp;
	int TimeCandleID;
	string TimeMarket;
	ENUM_TIMEFRAMES TimeCandleTimeframe;
	int TimeComponentYear;
	int TimeComponentMonth;
	double TimeComponentDay;
	double TimeComponentHour;
	double TimeComponentMinute;
	int TimeComponentSecond;
	int ModeTimeShift;
	int TimeShiftYears;
	int TimeShiftMonths;
	int TimeShiftWeeks;
	double TimeShiftDays;
	double TimeShiftHours;
	double TimeShiftMinutes;
	int TimeShiftSeconds;
	bool TimeSkipWeekdays;
	/* Static Parameters */
	datetime retval;
	datetime retval0;
	int ModeTime0;
	int smodeshift;
	int years0;
	int months0;
	datetime Time[];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_value_time()
	{
		ModeTime = (int)0;
		TimeSource = (int)0;
		TimeStamp = (string)"00:00";
		TimeCandleID = (int)1;
		TimeMarket = (string)"";
		TimeCandleTimeframe = (ENUM_TIMEFRAMES)0;
		TimeComponentYear = (int)0;
		TimeComponentMonth = (int)0;
		TimeComponentDay = (double)0.0;
		TimeComponentHour = (double)12.0;
		TimeComponentMinute = (double)0.0;
		TimeComponentSecond = (int)0;
		ModeTimeShift = (int)0;
		TimeShiftYears = (int)0;
		TimeShiftMonths = (int)0;
		TimeShiftWeeks = (int)0;
		TimeShiftDays = (double)0.0;
		TimeShiftHours = (double)0.0;
		TimeShiftMinutes = (double)0.0;
		TimeShiftSeconds = (int)0;
		TimeSkipWeekdays = (bool)false;
		/* Static Parameters (initial value) */
		retval =  0;
		retval0 =  0;
		ModeTime0 =  0;
		smodeshift =  0;
		years0 =  0;
		months0 =  0;
	}

	public: /* The main method */
	datetime _execute_()
	{
		// this is static for speed reasons
		
		if (TimeMarket == "") TimeMarket = Symbol();
		
		if (ModeTime == 0)
		{
			     if (TimeSource == 0) {retval = TimeCurrent();}
			else if (TimeSource == 1) {retval = TimeLocal();}
			else if (TimeSource == 2) {retval = TimeGMT();}
		}
		else if (ModeTime == 1)
		{
			retval  = StringToTime(TimeStamp);
			retval0 = retval;
		}
		else if (ModeTime==2)
		{
			retval = TimeFromComponents(TimeSource, TimeComponentYear, TimeComponentMonth, TimeComponentDay, TimeComponentHour, TimeComponentMinute, TimeComponentSecond);
		}
		else if (ModeTime == 3)
		{
			ArraySetAsSeries(Time,true);
			CopyTime(TimeMarket,TimeCandleTimeframe,TimeCandleID,1,Time);
			retval = Time[0];
		}
		
		if (ModeTimeShift > 0)
		{
			int sh = 1;
		
			if (ModeTimeShift == 1) {sh = -1;}
		
			if (
				   ModeTimeShift != smodeshift
				|| TimeShiftYears != years0
				|| TimeShiftMonths != months0
			)
			{
				years0  = TimeShiftYears;
				months0 = TimeShiftMonths;
		
				if (TimeShiftYears > 0 || TimeShiftMonths > 0)
				{
					int year = 0, month = 0, week = 0, day = 0, hour = 0, minute = 0, second = 0;
		
					if (ModeTime == 3)
					{
						year   = TimeComponentYear;
						month  = TimeComponentYear;
						day    = (int)MathFloor(TimeComponentDay);
						hour   = (int)(MathFloor(TimeComponentHour) + (24 * (TimeComponentDay - MathFloor(TimeComponentDay))));
						minute = (int)(MathFloor(TimeComponentMinute) + (60 * (TimeComponentHour - MathFloor(TimeComponentHour))));
						second = (int)(TimeComponentSecond + (60 * (TimeComponentMinute - MathFloor(TimeComponentMinute))));
					}
					else {
						year   = TimeYear(retval);
						month  = TimeMonth(retval);
						day    = TimeDay(retval);
						hour   = TimeHour(retval);
						minute = TimeMinute(retval);
						second = TimeSeconds(retval);
					}
		
					year  = year + TimeShiftYears * sh;
					month = month + TimeShiftMonths * sh;
		
					     if (month < 0) {month = 12 - month;}
					else if (month > 12) {month = month - 12;}
		
					retval = StringToTime(IntegerToString(year)+"."+IntegerToString(month)+"."+IntegerToString(day)+" "+IntegerToString(hour)+":"+IntegerToString(minute)+":"+IntegerToString(second));
				}
			}
		
			retval = retval + (sh * ((604800 * TimeShiftWeeks) + SecondsFromComponents(TimeShiftDays, TimeShiftHours, TimeShiftMinutes, TimeShiftSeconds)));
		
			if (TimeSkipWeekdays == true)
			{
				int weekday = TimeDayOfWeek(retval);
		
				if (sh > 0) { // forward
					     if (weekday == 0) {retval = retval + 86400;}
					else if (weekday == 6) {retval = retval + 172800;}
				}
				else if (sh < 0) { // back
					     if (weekday == 0) {retval = retval - 172800;}
					else if (weekday == 6) {retval = retval - 86400;}
				}
			}
		}
		
		smodeshift = ModeTimeShift;
		ModeTime0  = ModeTime;
		
		return (datetime)retval;
	}
};

// "Highest Price (Candles period)" model
class MDLIC_prices_HighestFromToCandles
{
	public: /* Input Parameters */
	int StartBar;
	int EndBar;
	int WhatToGet;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_prices_HighestFromToCandles()
	{
		StartBar = (int)0;
		EndBar = (int)10;
		WhatToGet = (int)1;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}

	public: /* The main method */
	double _execute_()
	{
		return HighestFromTo(Symbol,Period,StartBar,EndBar,WhatToGet);
	}
};

// "Ask, Bid, Mid" model
class MDLIC_prices_prices
{
	public: /* Input Parameters */
	string Price;
	int TickID;
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_prices_prices()
	{
		Price = (string)"ASK";
		TickID = (int)0;
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	double _execute_()
	{
		int digits = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
		
		double retval = 0;
		int tID       = TickID + FXD_MORE_SHIFT;
		
		     if (Price == "ASK")      {retval = TicksData(Symbol,SYMBOL_ASK,tID);}
		else if (Price == "BID")      {retval = TicksData(Symbol,SYMBOL_BID,tID);}
		else if (Price == "MID")      {retval = ((TicksData(Symbol,SYMBOL_ASK,tID)+TicksData(Symbol,SYMBOL_BID,tID))/2);}
		else if (Price == "BIDHIGH")  {retval = SymbolInfoDouble(Symbol,SYMBOL_BIDHIGH);}
		else if (Price == "BIDLOW")   {retval = SymbolInfoDouble(Symbol,SYMBOL_BIDLOW);}
		else if (Price == "ASKHIGH")  {retval = SymbolInfoDouble(Symbol,SYMBOL_ASKHIGH);}
		else if (Price == "ASKLOW")   {retval = SymbolInfoDouble(Symbol,SYMBOL_ASKLOW);}
		else if (Price == "LAST")     {retval = SymbolInfoDouble(Symbol,SYMBOL_LAST);}
		else if (Price == "LASTHIGH") {retval = SymbolInfoDouble(Symbol,SYMBOL_LASTHIGH);}
		else if (Price == "LASTLOW")  {retval = SymbolInfoDouble(Symbol,SYMBOL_LASTLOW);}
		
		return NormalizeDouble(retval, digits);
	}
};

// "Balance" model
class MDLIC_account_AccountBalance
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountBalance()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
	}
};

// "Average True Range" model
class MDLIC_indicators_iATR
{
	public: /* Input Parameters */
	int ATRperiod;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iATR()
	{
		ATRperiod = (int)14;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iATR(Symbol, Period, ATRperiod, Shift + FXD_MORE_SHIFT);
	}
};


//------------------------------------------------------------------------------------------------------------------------

// Block 1 (USD Weekday filter)
class Block0: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {257,259,285,286,311,312,333,334,337,338,351,352,363,364};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[257].run(0);
			_blocks_[259].run(0);
			_blocks_[285].run(0);
			_blocks_[286].run(0);
			_blocks_[311].run(0);
			_blocks_[312].run(0);
			_blocks_[333].run(0);
			_blocks_[334].run(0);
			_blocks_[337].run(0);
			_blocks_[338].run(0);
			_blocks_[351].run(0);
			_blocks_[352].run(0);
			_blocks_[363].run(0);
			_blocks_[364].run(0);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::USD_Monday;
		tradeTuesday = (bool)c::USD_Tuesday;
		tradeWednesday = (bool)c::USD_Wednesday;
		tradeThursday = (bool)c::USD_Thursday;
		tradeFriday = (bool)c::USD_Friday;
	}
};

// Block 2 (GBP Weekday filter)
class Block1: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "2";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {257,259,261,289,290,331,332,349,350,361,362,365,366,371};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[257].run(1);
			_blocks_[259].run(1);
			_blocks_[261].run(1);
			_blocks_[289].run(1);
			_blocks_[290].run(1);
			_blocks_[331].run(1);
			_blocks_[332].run(1);
			_blocks_[349].run(1);
			_blocks_[350].run(1);
			_blocks_[361].run(1);
			_blocks_[362].run(1);
			_blocks_[365].run(1);
			_blocks_[366].run(1);
			_blocks_[371].run(1);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::GBP_Monday;
		tradeTuesday = (bool)c::GBP_Tuesday;
		tradeWednesday = (bool)c::GBP_Wednesday;
		tradeThursday = (bool)c::GBP_Thursday;
		tradeFriday = (bool)c::GBP_Friday;
	}
};

// Block 3 (EUR Weekday filter)
class Block2: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {261,263,265,285,286,291,292,293,294,347,348,359,360,371};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[261].run(2);
			_blocks_[263].run(2);
			_blocks_[265].run(2);
			_blocks_[285].run(2);
			_blocks_[286].run(2);
			_blocks_[291].run(2);
			_blocks_[292].run(2);
			_blocks_[293].run(2);
			_blocks_[294].run(2);
			_blocks_[347].run(2);
			_blocks_[348].run(2);
			_blocks_[359].run(2);
			_blocks_[360].run(2);
			_blocks_[371].run(2);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::EUR_Monday;
		tradeTuesday = (bool)c::EUR_Tuesday;
		tradeWednesday = (bool)c::EUR_Wednesday;
		tradeThursday = (bool)c::EUR_Thursday;
		tradeFriday = (bool)c::EUR_Friday;
	}
};

// Block 4 (AUD Weekday filter)
class Block3: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {263,265,267,269,289,290,335,336,337,338,339,340,341,342};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[263].run(3);
			_blocks_[265].run(3);
			_blocks_[267].run(3);
			_blocks_[269].run(3);
			_blocks_[289].run(3);
			_blocks_[290].run(3);
			_blocks_[335].run(3);
			_blocks_[336].run(3);
			_blocks_[337].run(3);
			_blocks_[338].run(3);
			_blocks_[339].run(3);
			_blocks_[340].run(3);
			_blocks_[341].run(3);
			_blocks_[342].run(3);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::AUD_Monday;
		tradeTuesday = (bool)c::AUD_Tuesday;
		tradeWednesday = (bool)c::AUD_Wednesday;
		tradeThursday = (bool)c::AUD_Thursday;
		tradeFriday = (bool)c::AUD_Friday;
	}
};

// Block 5 (JPY Weekday filter)
class Block4: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {267,269,271,273,291,292,311,312,343,344,355,356,365,366};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[267].run(4);
			_blocks_[269].run(4);
			_blocks_[271].run(4);
			_blocks_[273].run(4);
			_blocks_[291].run(4);
			_blocks_[292].run(4);
			_blocks_[311].run(4);
			_blocks_[312].run(4);
			_blocks_[343].run(4);
			_blocks_[344].run(4);
			_blocks_[355].run(4);
			_blocks_[356].run(4);
			_blocks_[365].run(4);
			_blocks_[366].run(4);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::JPY_Monday;
		tradeTuesday = (bool)c::JPY_Tuesday;
		tradeWednesday = (bool)c::JPY_Wednesday;
		tradeThursday = (bool)c::JPY_Thursday;
		tradeFriday = (bool)c::JPY_Friday;
	}
};

// Block 6 (CAD Weekday filter)
class Block5: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {271,273,275,277,293,294,331,332,333,334,335,336,353,354};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[271].run(5);
			_blocks_[273].run(5);
			_blocks_[275].run(5);
			_blocks_[277].run(5);
			_blocks_[293].run(5);
			_blocks_[294].run(5);
			_blocks_[331].run(5);
			_blocks_[332].run(5);
			_blocks_[333].run(5);
			_blocks_[334].run(5);
			_blocks_[335].run(5);
			_blocks_[336].run(5);
			_blocks_[353].run(5);
			_blocks_[354].run(5);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::CAD_Monday;
		tradeTuesday = (bool)c::CAD_Tuesday;
		tradeWednesday = (bool)c::CAD_Wednesday;
		tradeThursday = (bool)c::CAD_Thursday;
		tradeFriday = (bool)c::CAD_Friday;
	}
};

// Block 7 (NZD Weekday filter)
class Block6: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {275,277,279,281,339,340,343,344,347,348,349,350,351,352};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[275].run(6);
			_blocks_[277].run(6);
			_blocks_[279].run(6);
			_blocks_[281].run(6);
			_blocks_[339].run(6);
			_blocks_[340].run(6);
			_blocks_[343].run(6);
			_blocks_[344].run(6);
			_blocks_[347].run(6);
			_blocks_[348].run(6);
			_blocks_[349].run(6);
			_blocks_[350].run(6);
			_blocks_[351].run(6);
			_blocks_[352].run(6);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::NZD_Monday;
		tradeTuesday = (bool)c::NZD_Tuesday;
		tradeWednesday = (bool)c::NZD_Wednesday;
		tradeThursday = (bool)c::NZD_Thursday;
		tradeFriday = (bool)c::NZD_Friday;
	}
};

// Block 8 (CHF Weekday filter)
class Block7: public MDL_WeekdayFilter<string,bool,bool,bool,bool,bool,bool,bool>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[14] = {279,281,341,342,353,354,355,356,359,360,361,362,363,364};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[279].run(7);
			_blocks_[281].run(7);
			_blocks_[341].run(7);
			_blocks_[342].run(7);
			_blocks_[353].run(7);
			_blocks_[354].run(7);
			_blocks_[355].run(7);
			_blocks_[356].run(7);
			_blocks_[359].run(7);
			_blocks_[360].run(7);
			_blocks_[361].run(7);
			_blocks_[362].run(7);
			_blocks_[363].run(7);
			_blocks_[364].run(7);
		}
	}

	virtual void _beforeExecute_()
	{
		tradeMonday = (bool)c::CHF_Monday;
		tradeTuesday = (bool)c::CHF_Tuesday;
		tradeWednesday = (bool)c::CHF_Wednesday;
		tradeThursday = (bool)c::CHF_Thursday;
		tradeFriday = (bool)c::CHF_Friday;
	}
};

// Block 9 (Check trades count)
class Block8: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[8] = {0,1,2,3,4,5,6,7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Compare = "<";
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[0].run(8);
			_blocks_[1].run(8);
			_blocks_[2].run(8);
			_blocks_[3].run(8);
			_blocks_[4].run(8);
			_blocks_[5].run(8);
			_blocks_[6].run(8);
			_blocks_[7].run(8);
		}
	}

	virtual void _beforeExecute_()
	{
		CompareCount = (int)c::Max_Symbol;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 10 (Modify Variables)
class Block9: public MDL_ModifyVariables<int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Symbol = "AUDCAD";
		Value1.Shift = 1;
		Value2.Symbol = "AUDCHF";
		Value2.Shift = 1;
		Value3.Symbol = "AUDJPY";
		Value3.Shift = 1;
		Value4.Symbol = "AUDNZD";
		Value4.Shift = 1;
		Value5.Symbol = "AUDUSD";
		Value5.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CCIperiod = c::CCI_Indicators;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CCIperiod = c::CCI_Indicators;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CCIperiod = c::CCI_Indicators;
		Value3.AppliedPrice = PRICE_CLOSE;
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CCIperiod = c::CCI_Indicators;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.CCIperiod = c::CCI_Indicators;
		Value5.AppliedPrice = PRICE_CLOSE;
		Value5.Period = CurrentTimeframe();

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(9);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUDCAD_m = _Value1_();
		v::AUDCHF_m = _Value2_();
		v::AUDJPY_m = _Value3_();
		v::AUDNZD_m = _Value4_();
		v::AUDUSD_m = _Value5_();
	}
};

// Block 11 (Modify Variables)
class Block10: public MDL_ModifyVariables<int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "11";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {11};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Symbol = "CADCHF";
		Value1.Shift = 1;
		Value2.Symbol = "CADJPY";
		Value2.Shift = 1;
		Value3.Symbol = "CHFJPY";
		Value3.Shift = 1;
		Value4.Symbol = "EURAUD";
		Value4.Shift = 1;
		Value5.Symbol = "EURCAD";
		Value5.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CCIperiod = c::CCI_Indicators;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CCIperiod = c::CCI_Indicators;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CCIperiod = c::CCI_Indicators;
		Value3.AppliedPrice = PRICE_CLOSE;
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CCIperiod = c::CCI_Indicators;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.CCIperiod = c::CCI_Indicators;
		Value5.AppliedPrice = PRICE_CLOSE;
		Value5.Period = CurrentTimeframe();

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[11].run(10);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CADCHF_m = _Value1_();
		v::CADJPY_m = _Value2_();
		v::CHFJPY_m = _Value3_();
		v::EURAUD_m = _Value4_();
		v::EURCAD_m = _Value5_();
	}
};

// Block 12 (Modify Variables)
class Block11: public MDL_ModifyVariables<int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "12";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {12};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Symbol = "EURCHF";
		Value1.Shift = 1;
		Value2.Symbol = "EURGBP";
		Value2.Shift = 1;
		Value3.Symbol = "EURJPY";
		Value3.Shift = 1;
		Value4.Symbol = "EURNZD";
		Value4.Shift = 1;
		Value5.Symbol = "EURUSD";
		Value5.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CCIperiod = c::CCI_Indicators;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CCIperiod = c::CCI_Indicators;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CCIperiod = c::CCI_Indicators;
		Value3.AppliedPrice = PRICE_CLOSE;
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CCIperiod = c::CCI_Indicators;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.CCIperiod = c::CCI_Indicators;
		Value5.AppliedPrice = PRICE_CLOSE;
		Value5.Period = CurrentTimeframe();

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[12].run(11);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EURCHF_m = _Value1_();
		v::EURGBP_m = _Value2_();
		v::EURJPY_m = _Value3_();
		v::EURNZD_m = _Value4_();
		v::EURUSD_m = _Value5_();
	}
};

// Block 13 (Modify Variables)
class Block12: public MDL_ModifyVariables<int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "13";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Symbol = "GBPAUD";
		Value1.Shift = 1;
		Value2.Symbol = "GBPCAD";
		Value2.Shift = 1;
		Value3.Symbol = "GBPCHF";
		Value3.Shift = 1;
		Value4.Symbol = "GBPJPY";
		Value4.Shift = 1;
		Value5.Symbol = "GBPNZD";
		Value5.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CCIperiod = c::CCI_Indicators;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CCIperiod = c::CCI_Indicators;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CCIperiod = c::CCI_Indicators;
		Value3.AppliedPrice = PRICE_CLOSE;
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CCIperiod = c::CCI_Indicators;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.CCIperiod = c::CCI_Indicators;
		Value5.AppliedPrice = PRICE_CLOSE;
		Value5.Period = CurrentTimeframe();

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(12);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBPAUD_m = _Value1_();
		v::GBPCAD_m = _Value2_();
		v::GBPCHF_m = _Value3_();
		v::GBPJPY_m = _Value4_();
		v::GBPNZD_m = _Value5_();
	}
};

// Block 14 (Modify Variables)
class Block13: public MDL_ModifyVariables<int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "14";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Symbol = "GBPUSD";
		Value1.Shift = 1;
		Value2.Symbol = "NZDCAD";
		Value2.Shift = 1;
		Value3.Symbol = "NZDCHF";
		Value3.Shift = 1;
		Value4.Symbol = "NZDJPY";
		Value4.Shift = 1;
		Value5.Symbol = "NZDUSD";
		Value5.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CCIperiod = c::CCI_Indicators;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CCIperiod = c::CCI_Indicators;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CCIperiod = c::CCI_Indicators;
		Value3.AppliedPrice = PRICE_CLOSE;
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CCIperiod = c::CCI_Indicators;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.CCIperiod = c::CCI_Indicators;
		Value5.AppliedPrice = PRICE_CLOSE;
		Value5.Period = CurrentTimeframe();

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[14].run(13);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBPUSD_m = _Value1_();
		v::NZDCAD_m = _Value2_();
		v::NZDCHF_m = _Value3_();
		v::NZDJPY_m = _Value4_();
		v::NZDUSD_m = _Value5_();
	}
};

// Block 15 (Modify Variables)
class Block14: public MDL_ModifyVariables<int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_indicators_iCCI,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "15";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Symbol = "USDCAD";
		Value1.Shift = 1;
		Value2.Symbol = "USDCHF";
		Value2.Shift = 1;
		Value3.Symbol = "USDJPY";
		Value3.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CCIperiod = c::CCI_Indicators;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CCIperiod = c::CCI_Indicators;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CCIperiod = c::CCI_Indicators;
		Value3.AppliedPrice = PRICE_CLOSE;
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual string _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(14);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USDCAD_m = _Value1_();
		v::USDCHF_m = _Value2_();
		v::USDJPY_m = _Value3_();
	}
};

// Block 16 (Custom MQL4 code)
class Block15: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "16";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {16};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[16].run(15);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD55 = (v::USDJPY_m + v::USDCHF_m + v::USDCAD_m - v::AUDUSD_m - v::EURUSD_m - v::GBPUSD_m - v::NZDUSD_m)/7 ;
	}
};

// Block 17 (Custom MQL4 code)
class Block16: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "17";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(16);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY55 = (- v::CHFJPY_m - v::CADJPY_m - v::AUDJPY_m - v::EURJPY_m - v::GBPJPY_m - v::NZDJPY_m - v::USDJPY_m)/7 ;
	}
};

// Block 18 (Custom MQL4 code)
class Block17: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "18";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(17);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF55 = (v::CHFJPY_m - v::USDCHF_m - v::CADCHF_m - v::AUDCHF_m - v::EURCHF_m - v::GBPCHF_m - v::NZDCHF_m)/7 ;
	}
};

// Block 19 (Comment)
class Block18: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "19";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {256};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Title = "CURRENCY STRENGTH";
		ObjTitleFontSize = 10;
		Label1 = "USD";
		Label2 = "JPY";
		Label3 = "AUD";
		Label4 = "EUR";
		Label5 = "CHF";
		Label6 = "CAD";
		Label7 = "GBP";
		Label8 = "NZD";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::USD55;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::JPY55;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::AUD55;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::EUR55;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::CHF55;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::CAD55;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::GBP55;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::NZD55;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[256].run(18);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrGold;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 20 (Custom MQL4 code)
class Block19: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "20";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {20};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(19);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD55 = (v::CADJPY_m - v::USDCAD_m + v::CADCHF_m - v::AUDCAD_m - v::EURCAD_m - v::GBPCAD_m - v::NZDCAD_m)/7 ;
	}
};

// Block 21 (Custom MQL4 code)
class Block20: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "21";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {21};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[21].run(20);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR55 = (v::EURJPY_m + v::EURUSD_m + v::EURCHF_m + v::EURAUD_m + v::EURCAD_m + v::EURGBP_m + v::EURNZD_m)/7 ;
	}
};

// Block 22 (Custom MQL4 code)
class Block21: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[22].run(21);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP55 = (v::GBPJPY_m + v::GBPUSD_m + v::GBPCHF_m + v::GBPAUD_m + v::GBPCAD_m - v::EURGBP_m + v::GBPNZD_m)/7 ;
	}
};

// Block 23 (Custom MQL4 code)
class Block22: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "23";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[23].run(22);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD55 = (v::AUDJPY_m + v::AUDUSD_m + v::AUDCHF_m - v::GBPAUD_m + v::AUDCAD_m - v::EURAUD_m + v::AUDNZD_m)/7 ;
	}
};

// Block 24 (Custom MQL4 code)
class Block23: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {18,367};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[18].run(23);
			_blocks_[367].run(23);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD55 = (v::NZDJPY_m + v::NZDUSD_m + v::NZDCHF_m - v::GBPNZD_m + v::NZDCAD_m - v::EURNZD_m - v::AUDNZD_m)/7 ;
	}
};

// Block 27 (USD)
class Block24: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "27";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(24);
		}
	}
};

// Block 28 (USD)
class Block25: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "28";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[40].run(25);
		}
	}
};

// Block 29 (USD)
class Block26: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "29";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(26);
		}
	}
};

// Block 30 (USD)
class Block27: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "30";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {41};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[41].run(27);
		}
	}
};

// Block 31 (Modify Variables)
class Block28: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "31";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(28);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD1 = _Value1_();
	}
};

// Block 32 (Modify Variables)
class Block29: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "32";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(29);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD1 = _Value1_();
	}
};

// Block 33 (USD)
class Block30: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "33";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(30);
		}
	}
};

// Block 34 (USD)
class Block31: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "34";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(31);
		}
	}
};

// Block 35 (USD)
class Block32: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "35";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(32);
		}
	}
};

// Block 36 (USD)
class Block33: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "36";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(33);
		}
	}
};

// Block 37 (USD)
class Block34: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "37";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(34);
		}
	}
};

// Block 38 (USD)
class Block35: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "38";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {48};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[48].run(35);
		}
	}
};

// Block 39 (USD)
class Block36: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "39";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {47};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[47].run(36);
		}
	}
};

// Block 40 (USD)
class Block37: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "40";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[49].run(37);
		}
	}
};

// Block 41 (USD)
class Block38: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "41";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(38);
		}
	}
};

// Block 42 (USD)
class Block39: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "42";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(39);
		}
	}
};

// Block 43 (Modify Variables)
class Block40: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "43";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(40);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD2 = _Value1_();
	}
};

// Block 44 (Modify Variables)
class Block41: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "44";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(41);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD2 = _Value1_();
	}
};

// Block 45 (Modify Variables)
class Block42: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "45";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(42);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD3 = _Value1_();
	}
};

// Block 46 (Modify Variables)
class Block43: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "46";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(43);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD3 = _Value1_();
	}
};

// Block 47 (Modify Variables)
class Block44: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "47";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(44);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD4 = _Value1_();
	}
};

// Block 48 (Modify Variables)
class Block45: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "48";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(45);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD4 = _Value1_();
	}
};

// Block 49 (Modify Variables)
class Block46: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "49";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(46);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD5 = _Value1_();
	}
};

// Block 50 (Modify Variables)
class Block47: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "50";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(47);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD5 = _Value1_();
	}
};

// Block 51 (Modify Variables)
class Block48: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "51";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(48);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD6 = _Value1_();
	}
};

// Block 52 (Modify Variables)
class Block49: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "52";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(49);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD6 = _Value1_();
	}
};

// Block 53 (Modify Variables)
class Block50: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "53";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(50);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD7 = _Value1_();
	}
};

// Block 54 (Modify Variables)
class Block51: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "54";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(51);
		}
	}

	virtual void _beforeExecute_()
	{
		v::USD7 = _Value1_();
	}
};

// Block 55 (JPY)
class Block52: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "55";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[56].run(52);
		}
	}
};

// Block 56 (USD)
class Block53: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "56";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(53);
		}
	}
};

// Block 57 (USD)
class Block54: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "57";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {57};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[57].run(54);
		}
	}
};

// Block 58 (USD)
class Block55: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "58";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(55);
		}
	}
};

// Block 59 (Modify Variables)
class Block56: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "59";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(56);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY1 = _Value1_();
	}
};

// Block 60 (Modify Variables)
class Block57: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "60";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(57);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY1 = _Value1_();
	}
};

// Block 61 (USD)
class Block58: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "61";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(58);
		}
	}
};

// Block 62 (USD)
class Block59: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "62";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {72};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[72].run(59);
		}
	}
};

// Block 63 (USD)
class Block60: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "63";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[71].run(60);
		}
	}
};

// Block 64 (USD)
class Block61: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "64";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(61);
		}
	}
};

// Block 65 (USD)
class Block62: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "65";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[74].run(62);
		}
	}
};

// Block 66 (USD)
class Block63: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "66";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(63);
		}
	}
};

// Block 67 (USD)
class Block64: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "67";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(64);
		}
	}
};

// Block 68 (USD)
class Block65: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "68";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(65);
		}
	}
};

// Block 69 (USD)
class Block66: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "69";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {78};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[78].run(66);
		}
	}
};

// Block 70 (USD)
class Block67: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "70";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPY55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[79].run(67);
		}
	}
};

// Block 71 (Modify Variables)
class Block68: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "71";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(68);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY2 = _Value1_();
	}
};

// Block 72 (Modify Variables)
class Block69: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "72";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(69);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY2 = _Value1_();
	}
};

// Block 73 (Modify Variables)
class Block70: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "73";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(70);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY3 = _Value1_();
	}
};

// Block 74 (Modify Variables)
class Block71: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "74";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(71);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY3 = _Value1_();
	}
};

// Block 75 (Modify Variables)
class Block72: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "75";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(72);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY4 = _Value1_();
	}
};

// Block 76 (Modify Variables)
class Block73: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "76";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(73);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY4 = _Value1_();
	}
};

// Block 77 (Modify Variables)
class Block74: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "77";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(74);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY5 = _Value1_();
	}
};

// Block 78 (Modify Variables)
class Block75: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "78";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(75);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY5 = _Value1_();
	}
};

// Block 79 (Modify Variables)
class Block76: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "79";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(76);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY6 = _Value1_();
	}
};

// Block 80 (Modify Variables)
class Block77: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "80";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(77);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY6 = _Value1_();
	}
};

// Block 81 (Modify Variables)
class Block78: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "81";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(78);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY7 = _Value1_();
	}
};

// Block 82 (Modify Variables)
class Block79: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "82";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(79);
		}
	}

	virtual void _beforeExecute_()
	{
		v::JPY7 = _Value1_();
	}
};

// Block 83 (AUD)
class Block80: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "83";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {84};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(80);
		}
	}
};

// Block 84 (USD)
class Block81: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "84";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(81);
		}
	}
};

// Block 85 (USD)
class Block82: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "85";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(82);
		}
	}
};

// Block 86 (USD)
class Block83: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "86";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(83);
		}
	}
};

// Block 87 (Modify Variables)
class Block84: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "87";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(84);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD1 = _Value1_();
	}
};

// Block 88 (Modify Variables)
class Block85: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "88";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(85);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD1 = _Value1_();
	}
};

// Block 89 (USD)
class Block86: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "89";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(86);
		}
	}
};

// Block 90 (USD)
class Block87: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "90";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(87);
		}
	}
};

// Block 91 (USD)
class Block88: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "91";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(88);
		}
	}
};

// Block 92 (USD)
class Block89: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "92";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {101};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[101].run(89);
		}
	}
};

// Block 93 (USD)
class Block90: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "93";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(90);
		}
	}
};

// Block 94 (USD)
class Block91: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "94";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(91);
		}
	}
};

// Block 95 (USD)
class Block92: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "95";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(92);
		}
	}
};

// Block 96 (USD)
class Block93: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "96";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[105].run(93);
		}
	}
};

// Block 97 (USD)
class Block94: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "97";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(94);
		}
	}
};

// Block 98 (USD)
class Block95: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "98";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(95);
		}
	}
};

// Block 99 (Modify Variables)
class Block96: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "99";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(96);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD2 = _Value1_();
	}
};

// Block 100 (Modify Variables)
class Block97: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "100";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(97);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD2 = _Value1_();
	}
};

// Block 101 (Modify Variables)
class Block98: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "101";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(98);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD3 = _Value1_();
	}
};

// Block 102 (Modify Variables)
class Block99: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "102";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(99);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD3 = _Value1_();
	}
};

// Block 103 (Modify Variables)
class Block100: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "103";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(100);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD4 = _Value1_();
	}
};

// Block 104 (Modify Variables)
class Block101: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "104";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(101);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD4 = _Value1_();
	}
};

// Block 105 (Modify Variables)
class Block102: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "105";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(102);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD5 = _Value1_();
	}
};

// Block 106 (Modify Variables)
class Block103: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "106";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(103);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD5 = _Value1_();
	}
};

// Block 107 (Modify Variables)
class Block104: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "107";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(104);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD6 = _Value1_();
	}
};

// Block 108 (Modify Variables)
class Block105: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "108";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(105);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD6 = _Value1_();
	}
};

// Block 109 (Modify Variables)
class Block106: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "109";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(106);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD7 = _Value1_();
	}
};

// Block 110 (Modify Variables)
class Block107: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "110";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(107);
		}
	}

	virtual void _beforeExecute_()
	{
		v::AUD7 = _Value1_();
	}
};

// Block 111 (EUR)
class Block108: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "111";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {112};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(108);
		}
	}
};

// Block 112 (USD)
class Block109: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "112";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {124};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(109);
		}
	}
};

// Block 113 (USD)
class Block110: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "113";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(110);
		}
	}
};

// Block 114 (USD)
class Block111: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "114";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(111);
		}
	}
};

// Block 115 (Modify Variables)
class Block112: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "115";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(112);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR1 = _Value1_();
	}
};

// Block 116 (Modify Variables)
class Block113: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "116";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(113);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR1 = _Value1_();
	}
};

// Block 117 (USD)
class Block114: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "117";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {126};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[126].run(114);
		}
	}
};

// Block 118 (USD)
class Block115: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "118";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[128].run(115);
		}
	}
};

// Block 119 (USD)
class Block116: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "119";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(116);
		}
	}
};

// Block 120 (USD)
class Block117: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "120";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(117);
		}
	}
};

// Block 121 (USD)
class Block118: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "121";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(118);
		}
	}
};

// Block 122 (USD)
class Block119: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "122";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {132};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[132].run(119);
		}
	}
};

// Block 123 (USD)
class Block120: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "123";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(120);
		}
	}
};

// Block 124 (USD)
class Block121: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "124";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {133};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[133].run(121);
		}
	}
};

// Block 125 (USD)
class Block122: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "125";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(122);
		}
	}
};

// Block 126 (USD)
class Block123: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "126";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EUR55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(123);
		}
	}
};

// Block 127 (Modify Variables)
class Block124: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "127";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(124);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR2 = _Value1_();
	}
};

// Block 128 (Modify Variables)
class Block125: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "128";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(125);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR2 = _Value1_();
	}
};

// Block 129 (Modify Variables)
class Block126: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "129";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(126);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR3 = _Value1_();
	}
};

// Block 130 (Modify Variables)
class Block127: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "130";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(127);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR3 = _Value1_();
	}
};

// Block 131 (Modify Variables)
class Block128: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "131";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(128);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR4 = _Value1_();
	}
};

// Block 132 (Modify Variables)
class Block129: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "132";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(129);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR4 = _Value1_();
	}
};

// Block 133 (Modify Variables)
class Block130: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "133";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(130);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR5 = _Value1_();
	}
};

// Block 134 (Modify Variables)
class Block131: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "134";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(131);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR5 = _Value1_();
	}
};

// Block 135 (Modify Variables)
class Block132: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "135";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(132);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR6 = _Value1_();
	}
};

// Block 136 (Modify Variables)
class Block133: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "136";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(133);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR6 = _Value1_();
	}
};

// Block 137 (Modify Variables)
class Block134: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "137";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(134);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR7 = _Value1_();
	}
};

// Block 138 (Modify Variables)
class Block135: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "138";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(135);
		}
	}

	virtual void _beforeExecute_()
	{
		v::EUR7 = _Value1_();
	}
};

// Block 139 (GBP)
class Block136: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "139";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(136);
		}
	}
};

// Block 140 (USD)
class Block137: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "140";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {152};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[152].run(137);
		}
	}
};

// Block 141 (USD)
class Block138: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "141";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[141].run(138);
		}
	}
};

// Block 142 (USD)
class Block139: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "142";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {153};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[153].run(139);
		}
	}
};

// Block 143 (Modify Variables)
class Block140: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "143";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(140);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP1 = _Value1_();
	}
};

// Block 144 (Modify Variables)
class Block141: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "144";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(141);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP1 = _Value1_();
	}
};

// Block 145 (USD)
class Block142: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "145";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {154};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[154].run(142);
		}
	}
};

// Block 146 (USD)
class Block143: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "146";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {156};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[156].run(143);
		}
	}
};

// Block 147 (USD)
class Block144: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "147";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[155].run(144);
		}
	}
};

// Block 148 (USD)
class Block145: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block145() {
		__block_number = 145;
		__block_user_number = "148";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {157};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[157].run(145);
		}
	}
};

// Block 149 (USD)
class Block146: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block146() {
		__block_number = 146;
		__block_user_number = "149";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {158};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[158].run(146);
		}
	}
};

// Block 150 (USD)
class Block147: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block147() {
		__block_number = 147;
		__block_user_number = "150";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {160};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[160].run(147);
		}
	}
};

// Block 151 (USD)
class Block148: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block148() {
		__block_number = 148;
		__block_user_number = "151";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {159};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[159].run(148);
		}
	}
};

// Block 152 (USD)
class Block149: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block149() {
		__block_number = 149;
		__block_user_number = "152";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {161};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[161].run(149);
		}
	}
};

// Block 153 (USD)
class Block150: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block150() {
		__block_number = 150;
		__block_user_number = "153";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {162};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[162].run(150);
		}
	}
};

// Block 154 (USD)
class Block151: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block151() {
		__block_number = 151;
		__block_user_number = "154";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {163};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBP55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[163].run(151);
		}
	}
};

// Block 155 (Modify Variables)
class Block152: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block152() {
		__block_number = 152;
		__block_user_number = "155";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(152);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP2 = _Value1_();
	}
};

// Block 156 (Modify Variables)
class Block153: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block153() {
		__block_number = 153;
		__block_user_number = "156";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(153);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP2 = _Value1_();
	}
};

// Block 157 (Modify Variables)
class Block154: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block154() {
		__block_number = 154;
		__block_user_number = "157";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(154);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP3 = _Value1_();
	}
};

// Block 158 (Modify Variables)
class Block155: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block155() {
		__block_number = 155;
		__block_user_number = "158";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(155);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP3 = _Value1_();
	}
};

// Block 159 (Modify Variables)
class Block156: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block156() {
		__block_number = 156;
		__block_user_number = "159";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(156);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP4 = _Value1_();
	}
};

// Block 160 (Modify Variables)
class Block157: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block157() {
		__block_number = 157;
		__block_user_number = "160";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(157);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP4 = _Value1_();
	}
};

// Block 161 (Modify Variables)
class Block158: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block158() {
		__block_number = 158;
		__block_user_number = "161";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(158);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP5 = _Value1_();
	}
};

// Block 162 (Modify Variables)
class Block159: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block159() {
		__block_number = 159;
		__block_user_number = "162";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(159);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP5 = _Value1_();
	}
};

// Block 163 (Modify Variables)
class Block160: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block160() {
		__block_number = 160;
		__block_user_number = "163";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(160);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP6 = _Value1_();
	}
};

// Block 164 (Modify Variables)
class Block161: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block161() {
		__block_number = 161;
		__block_user_number = "164";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(161);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP6 = _Value1_();
	}
};

// Block 165 (Modify Variables)
class Block162: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block162() {
		__block_number = 162;
		__block_user_number = "165";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(162);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP7 = _Value1_();
	}
};

// Block 166 (Modify Variables)
class Block163: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block163() {
		__block_number = 163;
		__block_user_number = "166";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(163);
		}
	}

	virtual void _beforeExecute_()
	{
		v::GBP7 = _Value1_();
	}
};

// Block 167 (CHF)
class Block164: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block164() {
		__block_number = 164;
		__block_user_number = "167";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {168};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[168].run(164);
		}
	}
};

// Block 168 (USD)
class Block165: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block165() {
		__block_number = 165;
		__block_user_number = "168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {180};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[180].run(165);
		}
	}
};

// Block 169 (USD)
class Block166: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block166() {
		__block_number = 166;
		__block_user_number = "169";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {169};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[169].run(166);
		}
	}
};

// Block 170 (USD)
class Block167: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block167() {
		__block_number = 167;
		__block_user_number = "170";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {181};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[181].run(167);
		}
	}
};

// Block 171 (Modify Variables)
class Block168: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block168() {
		__block_number = 168;
		__block_user_number = "171";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(168);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF1 = _Value1_();
	}
};

// Block 172 (Modify Variables)
class Block169: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block169() {
		__block_number = 169;
		__block_user_number = "172";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(169);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF1 = _Value1_();
	}
};

// Block 173 (USD)
class Block170: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block170() {
		__block_number = 170;
		__block_user_number = "173";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {182};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[182].run(170);
		}
	}
};

// Block 174 (USD)
class Block171: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block171() {
		__block_number = 171;
		__block_user_number = "174";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {184};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[184].run(171);
		}
	}
};

// Block 175 (USD)
class Block172: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block172() {
		__block_number = 172;
		__block_user_number = "175";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {183};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[183].run(172);
		}
	}
};

// Block 176 (USD)
class Block173: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block173() {
		__block_number = 173;
		__block_user_number = "176";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {185};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[185].run(173);
		}
	}
};

// Block 177 (USD)
class Block174: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block174() {
		__block_number = 174;
		__block_user_number = "177";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {186};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[186].run(174);
		}
	}
};

// Block 178 (USD)
class Block175: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block175() {
		__block_number = 175;
		__block_user_number = "178";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {188};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[188].run(175);
		}
	}
};

// Block 179 (USD)
class Block176: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block176() {
		__block_number = 176;
		__block_user_number = "179";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {187};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[187].run(176);
		}
	}
};

// Block 180 (USD)
class Block177: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block177() {
		__block_number = 177;
		__block_user_number = "180";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {189};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[189].run(177);
		}
	}
};

// Block 181 (USD)
class Block178: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block178() {
		__block_number = 178;
		__block_user_number = "181";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {190};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[190].run(178);
		}
	}
};

// Block 182 (USD)
class Block179: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block179() {
		__block_number = 179;
		__block_user_number = "182";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {191};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHF55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[191].run(179);
		}
	}
};

// Block 183 (Modify Variables)
class Block180: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block180() {
		__block_number = 180;
		__block_user_number = "183";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(180);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF2 = _Value1_();
	}
};

// Block 184 (Modify Variables)
class Block181: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block181() {
		__block_number = 181;
		__block_user_number = "184";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(181);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF2 = _Value1_();
	}
};

// Block 185 (Modify Variables)
class Block182: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block182() {
		__block_number = 182;
		__block_user_number = "185";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(182);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF3 = _Value1_();
	}
};

// Block 186 (Modify Variables)
class Block183: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block183() {
		__block_number = 183;
		__block_user_number = "186";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(183);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF3 = _Value1_();
	}
};

// Block 187 (Modify Variables)
class Block184: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block184() {
		__block_number = 184;
		__block_user_number = "187";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(184);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF4 = _Value1_();
	}
};

// Block 188 (Modify Variables)
class Block185: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block185() {
		__block_number = 185;
		__block_user_number = "188";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(185);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF4 = _Value1_();
	}
};

// Block 189 (Modify Variables)
class Block186: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block186() {
		__block_number = 186;
		__block_user_number = "189";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(186);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF5 = _Value1_();
	}
};

// Block 190 (Modify Variables)
class Block187: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block187() {
		__block_number = 187;
		__block_user_number = "190";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(187);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF5 = _Value1_();
	}
};

// Block 191 (Modify Variables)
class Block188: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block188() {
		__block_number = 188;
		__block_user_number = "191";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(188);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF6 = _Value1_();
	}
};

// Block 192 (Modify Variables)
class Block189: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block189() {
		__block_number = 189;
		__block_user_number = "192";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(189);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF6 = _Value1_();
	}
};

// Block 193 (Modify Variables)
class Block190: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block190() {
		__block_number = 190;
		__block_user_number = "193";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(190);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF7 = _Value1_();
	}
};

// Block 194 (Modify Variables)
class Block191: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block191() {
		__block_number = 191;
		__block_user_number = "194";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(191);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CHF7 = _Value1_();
	}
};

// Block 195 (CAD)
class Block192: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block192() {
		__block_number = 192;
		__block_user_number = "195";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {196};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[196].run(192);
		}
	}
};

// Block 196 (USD)
class Block193: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block193() {
		__block_number = 193;
		__block_user_number = "196";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {208};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[208].run(193);
		}
	}
};

// Block 197 (USD)
class Block194: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block194() {
		__block_number = 194;
		__block_user_number = "197";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {197};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[197].run(194);
		}
	}
};

// Block 198 (USD)
class Block195: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block195() {
		__block_number = 195;
		__block_user_number = "198";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {209};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[209].run(195);
		}
	}
};

// Block 199 (Modify Variables)
class Block196: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block196() {
		__block_number = 196;
		__block_user_number = "199";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(196);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD1 = _Value1_();
	}
};

// Block 200 (Modify Variables)
class Block197: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block197() {
		__block_number = 197;
		__block_user_number = "200";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(197);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD1 = _Value1_();
	}
};

// Block 201 (USD)
class Block198: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block198() {
		__block_number = 198;
		__block_user_number = "201";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {210};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[210].run(198);
		}
	}
};

// Block 202 (USD)
class Block199: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block199() {
		__block_number = 199;
		__block_user_number = "202";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {212};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[212].run(199);
		}
	}
};

// Block 203 (USD)
class Block200: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block200() {
		__block_number = 200;
		__block_user_number = "203";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {211};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[211].run(200);
		}
	}
};

// Block 204 (USD)
class Block201: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block201() {
		__block_number = 201;
		__block_user_number = "204";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {213};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[213].run(201);
		}
	}
};

// Block 205 (USD)
class Block202: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block202() {
		__block_number = 202;
		__block_user_number = "205";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {214};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[214].run(202);
		}
	}
};

// Block 206 (USD)
class Block203: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block203() {
		__block_number = 203;
		__block_user_number = "206";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {216};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[216].run(203);
		}
	}
};

// Block 207 (USD)
class Block204: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block204() {
		__block_number = 204;
		__block_user_number = "207";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {215};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[215].run(204);
		}
	}
};

// Block 208 (USD)
class Block205: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block205() {
		__block_number = 205;
		__block_user_number = "208";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {217};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[217].run(205);
		}
	}
};

// Block 209 (USD)
class Block206: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block206() {
		__block_number = 206;
		__block_user_number = "209";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {218};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[218].run(206);
		}
	}
};

// Block 210 (USD)
class Block207: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block207() {
		__block_number = 207;
		__block_user_number = "210";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {219};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CAD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[219].run(207);
		}
	}
};

// Block 211 (Modify Variables)
class Block208: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block208() {
		__block_number = 208;
		__block_user_number = "211";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(208);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD2 = _Value1_();
	}
};

// Block 212 (Modify Variables)
class Block209: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block209() {
		__block_number = 209;
		__block_user_number = "212";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(209);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD2 = _Value1_();
	}
};

// Block 213 (Modify Variables)
class Block210: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block210() {
		__block_number = 210;
		__block_user_number = "213";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(210);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD3 = _Value1_();
	}
};

// Block 214 (Modify Variables)
class Block211: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block211() {
		__block_number = 211;
		__block_user_number = "214";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(211);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD3 = _Value1_();
	}
};

// Block 215 (Modify Variables)
class Block212: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block212() {
		__block_number = 212;
		__block_user_number = "215";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(212);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD4 = _Value1_();
	}
};

// Block 216 (Modify Variables)
class Block213: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block213() {
		__block_number = 213;
		__block_user_number = "216";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(213);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD4 = _Value1_();
	}
};

// Block 217 (Modify Variables)
class Block214: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block214() {
		__block_number = 214;
		__block_user_number = "217";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(214);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD5 = _Value1_();
	}
};

// Block 218 (Modify Variables)
class Block215: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block215() {
		__block_number = 215;
		__block_user_number = "218";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(215);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD5 = _Value1_();
	}
};

// Block 219 (Modify Variables)
class Block216: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block216() {
		__block_number = 216;
		__block_user_number = "219";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(216);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD6 = _Value1_();
	}
};

// Block 220 (Modify Variables)
class Block217: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block217() {
		__block_number = 217;
		__block_user_number = "220";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(217);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD6 = _Value1_();
	}
};

// Block 221 (Modify Variables)
class Block218: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block218() {
		__block_number = 218;
		__block_user_number = "221";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(218);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD7 = _Value1_();
	}
};

// Block 222 (Modify Variables)
class Block219: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block219() {
		__block_number = 219;
		__block_user_number = "222";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(219);
		}
	}

	virtual void _beforeExecute_()
	{
		v::CAD7 = _Value1_();
	}
};

// Block 223 (NZD)
class Block220: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block220() {
		__block_number = 220;
		__block_user_number = "223";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {224};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[224].run(220);
		}
	}
};

// Block 224 (USD)
class Block221: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block221() {
		__block_number = 221;
		__block_user_number = "224";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {236};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[236].run(221);
		}
	}
};

// Block 225 (USD)
class Block222: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block222() {
		__block_number = 222;
		__block_user_number = "225";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {225};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::JPY55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[225].run(222);
		}
	}
};

// Block 226 (USD)
class Block223: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block223() {
		__block_number = 223;
		__block_user_number = "226";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {237};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AUD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[237].run(223);
		}
	}
};

// Block 227 (Modify Variables)
class Block224: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block224() {
		__block_number = 224;
		__block_user_number = "227";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(224);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD1 = _Value1_();
	}
};

// Block 228 (Modify Variables)
class Block225: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block225() {
		__block_number = 225;
		__block_user_number = "228";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(225);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD1 = _Value1_();
	}
};

// Block 229 (USD)
class Block226: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block226() {
		__block_number = 226;
		__block_user_number = "229";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {238};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[238].run(226);
		}
	}
};

// Block 230 (USD)
class Block227: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block227() {
		__block_number = 227;
		__block_user_number = "230";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {240};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[240].run(227);
		}
	}
};

// Block 231 (USD)
class Block228: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block228() {
		__block_number = 228;
		__block_user_number = "231";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {239};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::EUR55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[239].run(228);
		}
	}
};

// Block 232 (USD)
class Block229: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block229() {
		__block_number = 229;
		__block_user_number = "232";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {241};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CHF55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[241].run(229);
		}
	}
};

// Block 233 (USD)
class Block230: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block230() {
		__block_number = 230;
		__block_user_number = "233";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {242};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[242].run(230);
		}
	}
};

// Block 234 (USD)
class Block231: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block231() {
		__block_number = 231;
		__block_user_number = "234";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {244};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[244].run(231);
		}
	}
};

// Block 235 (USD)
class Block232: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block232() {
		__block_number = 232;
		__block_user_number = "235";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {243};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::CAD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[243].run(232);
		}
	}
};

// Block 236 (USD)
class Block233: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block233() {
		__block_number = 233;
		__block_user_number = "236";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {245};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::GBP55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[245].run(233);
		}
	}
};

// Block 237 (USD)
class Block234: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block234() {
		__block_number = 234;
		__block_user_number = "237";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {246};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[246].run(234);
		}
	}
};

// Block 238 (USD)
class Block235: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block235() {
		__block_number = 235;
		__block_user_number = "238";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {247};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USD55;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NZD55;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[247].run(235);
		}
	}
};

// Block 239 (Modify Variables)
class Block236: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block236() {
		__block_number = 236;
		__block_user_number = "239";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(236);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD2 = _Value1_();
	}
};

// Block 240 (Modify Variables)
class Block237: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block237() {
		__block_number = 237;
		__block_user_number = "240";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(237);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD2 = _Value1_();
	}
};

// Block 241 (Modify Variables)
class Block238: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block238() {
		__block_number = 238;
		__block_user_number = "241";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(238);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD3 = _Value1_();
	}
};

// Block 242 (Modify Variables)
class Block239: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block239() {
		__block_number = 239;
		__block_user_number = "242";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(239);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD3 = _Value1_();
	}
};

// Block 243 (Modify Variables)
class Block240: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block240() {
		__block_number = 240;
		__block_user_number = "243";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(240);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD4 = _Value1_();
	}
};

// Block 244 (Modify Variables)
class Block241: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block241() {
		__block_number = 241;
		__block_user_number = "244";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(241);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD4 = _Value1_();
	}
};

// Block 245 (Modify Variables)
class Block242: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block242() {
		__block_number = 242;
		__block_user_number = "245";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(242);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD5 = _Value1_();
	}
};

// Block 246 (Modify Variables)
class Block243: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block243() {
		__block_number = 243;
		__block_user_number = "246";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(243);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD5 = _Value1_();
	}
};

// Block 247 (Modify Variables)
class Block244: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block244() {
		__block_number = 244;
		__block_user_number = "247";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(244);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD6 = _Value1_();
	}
};

// Block 248 (Modify Variables)
class Block245: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block245() {
		__block_number = 245;
		__block_user_number = "248";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(245);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD6 = _Value1_();
	}
};

// Block 249 (Modify Variables)
class Block246: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block246() {
		__block_number = 246;
		__block_user_number = "249";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(246);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD7 = _Value1_();
	}
};

// Block 250 (Modify Variables)
class Block247: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block247() {
		__block_number = 247;
		__block_user_number = "250";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[255].run(247);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NZD7 = _Value1_();
	}
};

// Block 251 (Custom MQL4 code)
class Block248: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block248() {
		__block_number = 248;
		__block_user_number = "251";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::USDR9 = (v::USD1 + v::USD2 + v::USD3 + v::USD4 + v::USD5 + v::USD6 + v::USD7)+1 ;
	}
};

// Block 252 (Custom MQL4 code)
class Block249: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block249() {
		__block_number = 249;
		__block_user_number = "252";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::JPYR9 = (v::JPY1 + v::JPY2 + v::JPY3 + v::JPY4 + v::JPY5 + v::JPY6 + v::JPY7)+1 ;
	}
};

// Block 253 (Custom MQL4 code)
class Block250: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block250() {
		__block_number = 250;
		__block_user_number = "253";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::AUDR9 = (v::AUD1 + v::AUD2 + v::AUD3 + v::AUD4 + v::AUD5 + v::AUD6 + v::AUD7)+1 ;
	}
};

// Block 254 (Custom MQL4 code)
class Block251: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block251() {
		__block_number = 251;
		__block_user_number = "254";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::EURR9 = (v::EUR1 + v::EUR2 + v::EUR3 + v::EUR4 + v::EUR5 + v::EUR6 + v::EUR7)+1 ;
	}
};

// Block 255 (Custom MQL4 code)
class Block252: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block252() {
		__block_number = 252;
		__block_user_number = "255";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::GBPR9 = (v::GBP1 + v::GBP2 + v::GBP3 + v::GBP4 + v::GBP5 + v::GBP6 + v::GBP7)+1 ;
	}
};

// Block 256 (Custom MQL4 code)
class Block253: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block253() {
		__block_number = 253;
		__block_user_number = "256";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::CHFR9 = (v::CHF1 + v::CHF2 + v::CHF3 + v::CHF4 + v::CHF5 + v::CHF6 + v::CHF7)+1 ;
	}
};

// Block 257 (Custom MQL4 code)
class Block254: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block254() {
		__block_number = 254;
		__block_user_number = "257";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::CADR9 = (v::CAD1 + v::CAD2 + v::CAD3 + v::CAD4 + v::CAD5 + v::CAD6 + v::CAD7)+1 ;
	}
};

// Block 258 (Custom MQL4 code)
class Block255: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block255() {
		__block_number = 255;
		__block_user_number = "258";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::NZDR9 = (v::NZD1 + v::NZD2 + v::NZD3 + v::NZD4 + v::NZD5 + v::NZD6 + v::NZD7)+1 ;
	}
};

// Block 259 (Comment)
class Block256: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block256() {
		__block_number = 256;
		__block_user_number = "259";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Title = "RANKING";
		ObjY = 170;
		ObjTitleFontSize = 15;
		ObjFontSize = 15;
		Label1 = "USD";
		Label2 = "JPY";
		Label3 = "AUD";
		Label4 = "EUR";
		Label5 = "CHF";
		Label6 = "CAD";
		Label7 = "GBP";
		Label8 = "NZD";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::USDR9;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::JPYR9;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::AUDR9;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::EURR9;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::CHFR9;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::CADR9;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::GBPR9;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::NZDR9;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 170;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrGold;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 260 (USD W)
class Block257: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block257() {
		__block_number = 257;
		__block_user_number = "260";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {258};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[258].run(257);
		}
	}
};

// Block 261 (GBP S)
class Block258: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block258() {
		__block_number = 258;
		__block_user_number = "261";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {373};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[373].run(258);
		}
	}
};

// Block 264 (USD S)
class Block259: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block259() {
		__block_number = 259;
		__block_user_number = "264";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {260};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[260].run(259);
		}
	}
};

// Block 265 (GBP W)
class Block260: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block260() {
		__block_number = 260;
		__block_user_number = "265";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {401};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[401].run(260);
		}
	}
};

// Block 268 (EUR S)
class Block261: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block261() {
		__block_number = 261;
		__block_user_number = "268";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {262};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[262].run(261);
		}
	}
};

// Block 269 (GBP W)
class Block262: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block262() {
		__block_number = 262;
		__block_user_number = "269";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {374};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[374].run(262);
		}
	}
};

// Block 270 (EUR W)
class Block263: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block263() {
		__block_number = 263;
		__block_user_number = "270";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {264};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[264].run(263);
		}
	}
};

// Block 271 (AUD S)
class Block264: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block264() {
		__block_number = 264;
		__block_user_number = "271";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {403};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[403].run(264);
		}
	}
};

// Block 274 (EUR S)
class Block265: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block265() {
		__block_number = 265;
		__block_user_number = "274";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {266};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[266].run(265);
		}
	}
};

// Block 275 (AUD W)
class Block266: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block266() {
		__block_number = 266;
		__block_user_number = "275";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {375};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[375].run(266);
		}
	}
};

// Block 276 (JPY W)
class Block267: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block267() {
		__block_number = 267;
		__block_user_number = "276";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {268};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[268].run(267);
		}
	}
};

// Block 277 (AUD S)
class Block268: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block268() {
		__block_number = 268;
		__block_user_number = "277";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {376};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[376].run(268);
		}
	}
};

// Block 280 (JPY S)
class Block269: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block269() {
		__block_number = 269;
		__block_user_number = "280";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {270};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[270].run(269);
		}
	}
};

// Block 281 (AUD W)
class Block270: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block270() {
		__block_number = 270;
		__block_user_number = "281";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {404};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[404].run(270);
		}
	}
};

// Block 282 (JPY W)
class Block271: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block271() {
		__block_number = 271;
		__block_user_number = "282";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {272};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[272].run(271);
		}
	}
};

// Block 283 (CAD S)
class Block272: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block272() {
		__block_number = 272;
		__block_user_number = "283";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {377};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[377].run(272);
		}
	}
};

// Block 286 (JPY S)
class Block273: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block273() {
		__block_number = 273;
		__block_user_number = "286";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {274};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[274].run(273);
		}
	}
};

// Block 287 (CAD W)
class Block274: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block274() {
		__block_number = 274;
		__block_user_number = "287";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {405};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[405].run(274);
		}
	}
};

// Block 288 (NZD W)
class Block275: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block275() {
		__block_number = 275;
		__block_user_number = "288";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {276};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[276].run(275);
		}
	}
};

// Block 289 (CAD S)
class Block276: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block276() {
		__block_number = 276;
		__block_user_number = "289";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {406};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[406].run(276);
		}
	}
};

// Block 292 (NZD S)
class Block277: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block277() {
		__block_number = 277;
		__block_user_number = "292";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {278};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[278].run(277);
		}
	}
};

// Block 293 (CAD W)
class Block278: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block278() {
		__block_number = 278;
		__block_user_number = "293";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {378};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[378].run(278);
		}
	}
};

// Block 294 (NZD W)
class Block279: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block279() {
		__block_number = 279;
		__block_user_number = "294";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {280};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[280].run(279);
		}
	}
};

// Block 295 (CHF S)
class Block280: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block280() {
		__block_number = 280;
		__block_user_number = "295";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {407};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[407].run(280);
		}
	}
};

// Block 298 (NZD S)
class Block281: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block281() {
		__block_number = 281;
		__block_user_number = "298";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {282};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[282].run(281);
		}
	}
};

// Block 299 (CHF W)
class Block282: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block282() {
		__block_number = 282;
		__block_user_number = "299";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {379};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[379].run(282);
		}
	}
};

// Block 300 (USD W)
class Block283: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block283() {
		__block_number = 283;
		__block_user_number = "300";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {380};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[380].run(283);
		}
	}
};

// Block 301 (USD S)
class Block284: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block284() {
		__block_number = 284;
		__block_user_number = "301";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {408};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[408].run(284);
		}
	}
};

// Block 302 (EUR W)
class Block285: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block285() {
		__block_number = 285;
		__block_user_number = "302";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {284};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[284].run(285);
		}
	}
};

// Block 303 (EUR S)
class Block286: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block286() {
		__block_number = 286;
		__block_user_number = "303";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {283};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[283].run(286);
		}
	}
};

// Block 304 (GBP S)
class Block287: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block287() {
		__block_number = 287;
		__block_user_number = "304";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {381};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[381].run(287);
		}
	}
};

// Block 305 (GBP W)
class Block288: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block288() {
		__block_number = 288;
		__block_user_number = "305";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {409};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[409].run(288);
		}
	}
};

// Block 306 (AUD S)
class Block289: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block289() {
		__block_number = 289;
		__block_user_number = "306";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {288};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[288].run(289);
		}
	}
};

// Block 307 (AUD W)
class Block290: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block290() {
		__block_number = 290;
		__block_user_number = "307";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {287};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[287].run(290);
		}
	}
};

// Block 308 (EUR W)
class Block291: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block291() {
		__block_number = 291;
		__block_user_number = "308";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {300};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[300].run(291);
		}
	}
};

// Block 309 (EUR S)
class Block292: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block292() {
		__block_number = 292;
		__block_user_number = "309";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {299};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[299].run(292);
		}
	}
};

// Block 310 (EUR W)
class Block293: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block293() {
		__block_number = 293;
		__block_user_number = "310";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {329};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[329].run(293);
		}
	}
};

// Block 311 (EUR S)
class Block294: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block294() {
		__block_number = 294;
		__block_user_number = "311";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {330};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[330].run(294);
		}
	}
};

// Block 312 (EUR W)
class Block295: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block295() {
		__block_number = 295;
		__block_user_number = "312";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {421};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[421].run(295);
		}
	}
};

// Block 313 (EUR S)
class Block296: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block296() {
		__block_number = 296;
		__block_user_number = "313";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {393};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[393].run(296);
		}
	}
};

// Block 314 (EUR W)
class Block297: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block297() {
		__block_number = 297;
		__block_user_number = "314";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {432};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[432].run(297);
		}
	}
};

// Block 315 (EUR S)
class Block298: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block298() {
		__block_number = 298;
		__block_user_number = "315";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {397};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[397].run(298);
		}
	}
};

// Block 316 (JPY W)
class Block299: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block299() {
		__block_number = 299;
		__block_user_number = "316";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {382};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[382].run(299);
		}
	}
};

// Block 317 (JPY S)
class Block300: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block300() {
		__block_number = 300;
		__block_user_number = "317";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {410};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[410].run(300);
		}
	}
};

// Block 318 (JPY W)
class Block301: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block301() {
		__block_number = 301;
		__block_user_number = "318";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {384};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[384].run(301);
		}
	}
};

// Block 319 (JPY S)
class Block302: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block302() {
		__block_number = 302;
		__block_user_number = "319";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {412};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[412].run(302);
		}
	}
};

// Block 320 (JPY W)
class Block303: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block303() {
		__block_number = 303;
		__block_user_number = "320";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {387};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[387].run(303);
		}
	}
};

// Block 321 (JPY S)
class Block304: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block304() {
		__block_number = 304;
		__block_user_number = "321";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {415};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[415].run(304);
		}
	}
};

// Block 322 (JPY W)
class Block305: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block305() {
		__block_number = 305;
		__block_user_number = "322";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {390};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[390].run(305);
		}
	}
};

// Block 323 (JPY S)
class Block306: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block306() {
		__block_number = 306;
		__block_user_number = "323";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {418};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[418].run(306);
		}
	}
};

// Block 324 (JPY W)
class Block307: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block307() {
		__block_number = 307;
		__block_user_number = "324";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {391};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[391].run(307);
		}
	}
};

// Block 325 (JPY S)
class Block308: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block308() {
		__block_number = 308;
		__block_user_number = "325";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {419};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::JPYR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[419].run(308);
		}
	}
};

// Block 326 (USD W)
class Block309: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block309() {
		__block_number = 309;
		__block_user_number = "326";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {386};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[386].run(309);
		}
	}
};

// Block 327 (USD S)
class Block310: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block310() {
		__block_number = 310;
		__block_user_number = "327";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {414};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[414].run(310);
		}
	}
};

// Block 328 (USD W)
class Block311: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block311() {
		__block_number = 311;
		__block_user_number = "328";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {308};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[308].run(311);
		}
	}
};

// Block 329 (USD S)
class Block312: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block312() {
		__block_number = 312;
		__block_user_number = "329";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {307};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[307].run(312);
		}
	}
};

// Block 330 (USD W)
class Block313: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block313() {
		__block_number = 313;
		__block_user_number = "330";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {430};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[430].run(313);
		}
	}
};

// Block 331 (USD S)
class Block314: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block314() {
		__block_number = 314;
		__block_user_number = "331";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {395};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[395].run(314);
		}
	}
};

// Block 332 (USD W)
class Block315: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block315() {
		__block_number = 315;
		__block_user_number = "332";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {398};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[398].run(315);
		}
	}
};

// Block 333 (USD S)
class Block316: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block316() {
		__block_number = 316;
		__block_user_number = "333";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {423};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[423].run(316);
		}
	}
};

// Block 334 (USD W)
class Block317: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block317() {
		__block_number = 317;
		__block_user_number = "334";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {425};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[425].run(317);
		}
	}
};

// Block 335 (USD S)
class Block318: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block318() {
		__block_number = 318;
		__block_user_number = "335";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {400};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::USDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[400].run(318);
		}
	}
};

// Block 336 (GBP S)
class Block319: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block319() {
		__block_number = 319;
		__block_user_number = "336";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {392};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[392].run(319);
		}
	}
};

// Block 337 (GBP W)
class Block320: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block320() {
		__block_number = 320;
		__block_user_number = "337";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {420};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[420].run(320);
		}
	}
};

// Block 338 (GBP S)
class Block321: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block321() {
		__block_number = 321;
		__block_user_number = "338";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {396};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[396].run(321);
		}
	}
};

// Block 339 (GBP W)
class Block322: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block322() {
		__block_number = 322;
		__block_user_number = "339";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {431};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[431].run(322);
		}
	}
};

// Block 340 (GBP S)
class Block323: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block323() {
		__block_number = 323;
		__block_user_number = "340";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {399};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[399].run(323);
		}
	}
};

// Block 341 (GBP W)
class Block324: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block324() {
		__block_number = 324;
		__block_user_number = "341";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {424};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[424].run(324);
		}
	}
};

// Block 342 (CAD S)
class Block325: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block325() {
		__block_number = 325;
		__block_user_number = "342";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {411};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[411].run(325);
		}
	}
};

// Block 343 (CAD W)
class Block326: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block326() {
		__block_number = 326;
		__block_user_number = "343";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {383};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[383].run(326);
		}
	}
};

// Block 344 (CAD S)
class Block327: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block327() {
		__block_number = 327;
		__block_user_number = "344";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {385};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[385].run(327);
		}
	}
};

// Block 345 (CAD W)
class Block328: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block328() {
		__block_number = 328;
		__block_user_number = "345";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {413};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[413].run(328);
		}
	}
};

// Block 346 (CAD S)
class Block329: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block329() {
		__block_number = 329;
		__block_user_number = "346";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {416};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[416].run(329);
		}
	}
};

// Block 347 (CAD W)
class Block330: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block330() {
		__block_number = 330;
		__block_user_number = "347";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {388};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[388].run(330);
		}
	}
};

// Block 348 (CAD S)
class Block331: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block331() {
		__block_number = 331;
		__block_user_number = "348";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {320};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[320].run(331);
		}
	}
};

// Block 349 (CAD W)
class Block332: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block332() {
		__block_number = 332;
		__block_user_number = "349";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {319};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[319].run(332);
		}
	}
};

// Block 350 (CAD S)
class Block333: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block333() {
		__block_number = 333;
		__block_user_number = "350";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {313};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[313].run(333);
		}
	}
};

// Block 351 (CAD W)
class Block334: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block334() {
		__block_number = 334;
		__block_user_number = "351";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {314};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CADR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[314].run(334);
		}
	}
};

// Block 352 (AUD S)
class Block335: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block335() {
		__block_number = 335;
		__block_user_number = "352";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {326};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[326].run(335);
		}
	}
};

// Block 353 (AUD W)
class Block336: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block336() {
		__block_number = 336;
		__block_user_number = "353";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {325};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[325].run(336);
		}
	}
};

// Block 354 (AUD S)
class Block337: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block337() {
		__block_number = 337;
		__block_user_number = "354";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {309};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[309].run(337);
		}
	}
};

// Block 355 (AUD W)
class Block338: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block338() {
		__block_number = 338;
		__block_user_number = "355";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {310};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[310].run(338);
		}
	}
};

// Block 356 (AUD S)
class Block339: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block339() {
		__block_number = 339;
		__block_user_number = "356";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {345};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[345].run(339);
		}
	}
};

// Block 357 (AUD W)
class Block340: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block340() {
		__block_number = 340;
		__block_user_number = "357";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {346};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[346].run(340);
		}
	}
};

// Block 358 (AUD S)
class Block341: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block341() {
		__block_number = 341;
		__block_user_number = "358";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {358};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[358].run(341);
		}
	}
};

// Block 359 (AUD W)
class Block342: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block342() {
		__block_number = 342;
		__block_user_number = "359";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {357};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AUDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[357].run(342);
		}
	}
};

// Block 360 (NZD W)
class Block343: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block343() {
		__block_number = 343;
		__block_user_number = "360";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {302};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[302].run(343);
		}
	}
};

// Block 361 (NZD S)
class Block344: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block344() {
		__block_number = 344;
		__block_user_number = "361";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {301};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[301].run(344);
		}
	}
};

// Block 362 (NZD W)
class Block345: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block345() {
		__block_number = 345;
		__block_user_number = "362";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {389};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[389].run(345);
		}
	}
};

// Block 363 (NZD S)
class Block346: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block346() {
		__block_number = 346;
		__block_user_number = "363";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {417};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[417].run(346);
		}
	}
};

// Block 364 (NZD W)
class Block347: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block347() {
		__block_number = 347;
		__block_user_number = "364";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {296};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[296].run(347);
		}
	}
};

// Block 365 (NZD S)
class Block348: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block348() {
		__block_number = 348;
		__block_user_number = "365";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {295};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[295].run(348);
		}
	}
};

// Block 366 (NZD W)
class Block349: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block349() {
		__block_number = 349;
		__block_user_number = "366";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {321};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[321].run(349);
		}
	}
};

// Block 367 (NZD S)
class Block350: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block350() {
		__block_number = 350;
		__block_user_number = "367";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {322};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[322].run(350);
		}
	}
};

// Block 368 (NZD W)
class Block351: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block351() {
		__block_number = 351;
		__block_user_number = "368";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {316};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[316].run(351);
		}
	}
};

// Block 369 (NZD S)
class Block352: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block352() {
		__block_number = 352;
		__block_user_number = "369";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {315};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NZDR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[315].run(352);
		}
	}
};

// Block 370 (CHF S)
class Block353: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block353() {
		__block_number = 353;
		__block_user_number = "370";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {328};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[328].run(353);
		}
	}
};

// Block 371 (CHF W)
class Block354: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block354() {
		__block_number = 354;
		__block_user_number = "371";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {327};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[327].run(354);
		}
	}
};

// Block 372 (CHF S)
class Block355: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block355() {
		__block_number = 355;
		__block_user_number = "372";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {305};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[305].run(355);
		}
	}
};

// Block 373 (CHF W)
class Block356: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block356() {
		__block_number = 356;
		__block_user_number = "373";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {306};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[306].run(356);
		}
	}
};

// Block 374 (CHF S)
class Block357: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block357() {
		__block_number = 357;
		__block_user_number = "374";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {422};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[422].run(357);
		}
	}
};

// Block 375 (CHF W)
class Block358: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block358() {
		__block_number = 358;
		__block_user_number = "375";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {394};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[394].run(358);
		}
	}
};

// Block 376 (CHF S)
class Block359: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block359() {
		__block_number = 359;
		__block_user_number = "376";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {297};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[297].run(359);
		}
	}
};

// Block 377 (CHF W)
class Block360: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block360() {
		__block_number = 360;
		__block_user_number = "377";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {298};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[298].run(360);
		}
	}
};

// Block 378 (CHF S)
class Block361: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block361() {
		__block_number = 361;
		__block_user_number = "378";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {324};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[324].run(361);
		}
	}
};

// Block 379 (CHF W)
class Block362: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block362() {
		__block_number = 362;
		__block_user_number = "379";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {323};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[323].run(362);
		}
	}
};

// Block 380 (CHF S)
class Block363: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block363() {
		__block_number = 363;
		__block_user_number = "380";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {317};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[317].run(363);
		}
	}
};

// Block 381 (CHF W)
class Block364: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block364() {
		__block_number = 364;
		__block_user_number = "381";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {318};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::CHFR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[318].run(364);
		}
	}
};

// Block 382 (GBP S)
class Block365: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block365() {
		__block_number = 365;
		__block_user_number = "382";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {303};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[303].run(365);
		}
	}
};

// Block 383 (GBP W)
class Block366: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block366() {
		__block_number = 366;
		__block_user_number = "383";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {304};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[304].run(366);
		}
	}
};

// Block 453 (Comment)
class Block367: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block367() {
		__block_number = 367;
		__block_user_number = "453";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {368};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Title = "CCI";
		ObjFontSize = 8;
		Label1 = "AUDCAD";
		Label2 = "AUDCHF";
		Label3 = "AUDJPY";
		Label4 = "AUDNZD";
		Label5 = "AUDUSD";
		Label6 = "CADCHF";
		Label7 = "CADJPY";
		Label8 = "CHFJPY";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::AUDCAD_m;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::AUDCHF_m;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::AUDJPY_m;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::AUDNZD_m;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::AUDUSD_m;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::CADCHF_m;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::CADJPY_m;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::CHFJPY_m;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[368].run(367);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjTitleFontColor = (color)clrAqua;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 454 (Comment)
class Block368: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block368() {
		__block_number = 368;
		__block_user_number = "454";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {369};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Title = "";
		ObjY = 120;
		ObjTitleFontSize = 0;
		ObjFontSize = 8;
		Label1 = "EURAUD";
		Label2 = "EURCAD";
		Label3 = "EURCHF";
		Label4 = "EURGBP";
		Label5 = "EURJPY";
		Label6 = "EURNZD";
		Label7 = "EURUSD";
		Label8 = "GBPAUD";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::EURAUD_m;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::EURCAD_m;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::EURCHF_m;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::EURGBP_m;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::EURJPY_m;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::EURNZD_m;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::EURUSD_m;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::GBPAUD_m;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[369].run(368);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 120;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjTitleFontColor = (color)clrAqua;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 455 (Comment)
class Block369: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block369() {
		__block_number = 369;
		__block_user_number = "455";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {370};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Title = "";
		ObjY = 216;
		ObjTitleFontSize = 0;
		ObjFontSize = 8;
		Label1 = "GBPCAD";
		Label2 = "GBPCHF";
		Label3 = "GBPJPY";
		Label4 = "GBPNZD";
		Label5 = "GBPUSD";
		Label6 = "NZDCAD";
		Label7 = "NZDCHF";
		Label8 = "NZDJPY";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::GBPCAD_m;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::GBPCHF_m;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::GBPJPY_m;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::GBPNZD_m;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::GBPUSD_m;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::NZDCAD_m;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::NZDCHF_m;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::NZDJPY_m;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[370].run(369);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 216;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjTitleFontColor = (color)clrAqua;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 456 (Comment)
class Block370: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block370() {
		__block_number = 370;
		__block_user_number = "456";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Title = "";
		ObjY = 312;
		ObjTitleFontSize = 0;
		ObjFontSize = 8;
		Label1 = "NZDUSD";
		Label2 = "USDCAD";
		Label3 = "USDCHF";
		Label4 = "USDJPY";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::NZDUSD_m;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::USDCAD_m;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::USDCHF_m;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::USDJPY_m;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}
	virtual double _Value6_() {return Value6._execute_();}
	virtual double _Value7_() {return Value7._execute_();}
	virtual double _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 312;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjTitleFontColor = (color)clrAqua;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 477 (EUR W)
class Block371: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block371() {
		__block_number = 371;
		__block_user_number = "477";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {372};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::EURR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Weak;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[372].run(371);
		}
	}
};

// Block 478 (GBP S)
class Block372: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block372() {
		__block_number = 372;
		__block_user_number = "478";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {402};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::GBPR9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Strong;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[402].run(372);
		}
	}
};

// Block 955 (Set \"Current Market\" for next blocks)
class Block373: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block373() {
		__block_number = 373;
		__block_user_number = "955";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(373);
		}
	}
};

// Block 956 (Set \"Current Market\" for next blocks)
class Block374: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block374() {
		__block_number = 374;
		__block_user_number = "956";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURGBP";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(374);
		}
	}
};

// Block 957 (Set \"Current Market\" for next blocks)
class Block375: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block375() {
		__block_number = 375;
		__block_user_number = "957";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURAUD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(375);
		}
	}
};

// Block 958 (Set \"Current Market\" for next blocks)
class Block376: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block376() {
		__block_number = 376;
		__block_user_number = "958";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(376);
		}
	}
};

// Block 959 (Set \"Current Market\" for next blocks)
class Block377: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block377() {
		__block_number = 377;
		__block_user_number = "959";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "CADJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(377);
		}
	}
};

// Block 960 (Set \"Current Market\" for next blocks)
class Block378: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block378() {
		__block_number = 378;
		__block_user_number = "960";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(378);
		}
	}
};

// Block 961 (Set \"Current Market\" for next blocks)
class Block379: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block379() {
		__block_number = 379;
		__block_user_number = "961";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {441};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[441].run(379);
		}
	}
};

// Block 962 (Set \"Current Market\" for next blocks)
class Block380: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block380() {
		__block_number = 380;
		__block_user_number = "962";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {439};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[439].run(380);
		}
	}
};

// Block 963 (Set \"Current Market\" for next blocks)
class Block381: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block381() {
		__block_number = 381;
		__block_user_number = "963";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {439};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPAUD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[439].run(381);
		}
	}
};

// Block 964 (Set \"Current Market\" for next blocks)
class Block382: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block382() {
		__block_number = 382;
		__block_user_number = "964";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {439};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[439].run(382);
		}
	}
};

// Block 965 (Set \"Current Market\" for next blocks)
class Block383: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block383() {
		__block_number = 383;
		__block_user_number = "965";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {439};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[439].run(383);
		}
	}
};

// Block 966 (Set \"Current Market\" for next blocks)
class Block384: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block384() {
		__block_number = 384;
		__block_user_number = "966";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {439};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[439].run(384);
		}
	}
};

// Block 967 (Set \"Current Market\" for next blocks)
class Block385: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block385() {
		__block_number = 385;
		__block_user_number = "967";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {439};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "CADCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[439].run(385);
		}
	}
};

// Block 968 (Set \"Current Market\" for next blocks)
class Block386: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block386() {
		__block_number = 386;
		__block_user_number = "968";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {437};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[437].run(386);
		}
	}
};

// Block 969 (Set \"Current Market\" for next blocks)
class Block387: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block387() {
		__block_number = 387;
		__block_user_number = "969";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {437};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[437].run(387);
		}
	}
};

// Block 970 (Set \"Current Market\" for next blocks)
class Block388: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block388() {
		__block_number = 388;
		__block_user_number = "970";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {437};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[437].run(388);
		}
	}
};

// Block 971 (Set \"Current Market\" for next blocks)
class Block389: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block389() {
		__block_number = 389;
		__block_user_number = "971";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {437};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDNZD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[437].run(389);
		}
	}
};

// Block 972 (Set \"Current Market\" for next blocks)
class Block390: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block390() {
		__block_number = 390;
		__block_user_number = "972";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {437};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "CHFJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[437].run(390);
		}
	}
};

// Block 973 (Set \"Current Market\" for next blocks)
class Block391: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block391() {
		__block_number = 391;
		__block_user_number = "973";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {435};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "USDJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[435].run(391);
		}
	}
};

// Block 974 (Set \"Current Market\" for next blocks)
class Block392: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block392() {
		__block_number = 392;
		__block_user_number = "974";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {435};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[435].run(392);
		}
	}
};

// Block 975 (Set \"Current Market\" for next blocks)
class Block393: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block393() {
		__block_number = 393;
		__block_user_number = "975";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {435};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURNZD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[435].run(393);
		}
	}
};

// Block 976 (Set \"Current Market\" for next blocks)
class Block394: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block394() {
		__block_number = 394;
		__block_user_number = "976";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {435};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[435].run(394);
		}
	}
};

// Block 977 (Set \"Current Market\" for next blocks)
class Block395: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block395() {
		__block_number = 395;
		__block_user_number = "977";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {433};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "USDCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[433].run(395);
		}
	}
};

// Block 978 (Set \"Current Market\" for next blocks)
class Block396: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block396() {
		__block_number = 396;
		__block_user_number = "978";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {433};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPNZD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[433].run(396);
		}
	}
};

// Block 979 (Set \"Current Market\" for next blocks)
class Block397: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block397() {
		__block_number = 397;
		__block_user_number = "979";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {433};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[433].run(397);
		}
	}
};

// Block 980 (Set \"Current Market\" for next blocks)
class Block398: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block398() {
		__block_number = 398;
		__block_user_number = "980";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {428};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[428].run(398);
		}
	}
};

// Block 981 (Set \"Current Market\" for next blocks)
class Block399: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block399() {
		__block_number = 399;
		__block_user_number = "981";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {428};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[428].run(399);
		}
	}
};

// Block 982 (Set \"Current Market\" for next blocks)
class Block400: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block400() {
		__block_number = 400;
		__block_user_number = "982";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {428};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "USDCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[428].run(400);
		}
	}
};

// Block 983 (Set \"Current Market\" for next blocks)
class Block401: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block401() {
		__block_number = 401;
		__block_user_number = "983";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(401);
		}
	}
};

// Block 984 (Set \"Current Market\" for next blocks)
class Block402: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block402() {
		__block_number = 402;
		__block_user_number = "984";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURGBP";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(402);
		}
	}
};

// Block 985 (Set \"Current Market\" for next blocks)
class Block403: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block403() {
		__block_number = 403;
		__block_user_number = "985";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURAUD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(403);
		}
	}
};

// Block 986 (Set \"Current Market\" for next blocks)
class Block404: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block404() {
		__block_number = 404;
		__block_user_number = "986";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(404);
		}
	}
};

// Block 987 (Set \"Current Market\" for next blocks)
class Block405: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block405() {
		__block_number = 405;
		__block_user_number = "987";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "CADJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(405);
		}
	}
};

// Block 988 (Set \"Current Market\" for next blocks)
class Block406: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block406() {
		__block_number = 406;
		__block_user_number = "988";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(406);
		}
	}
};

// Block 989 (Set \"Current Market\" for next blocks)
class Block407: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block407() {
		__block_number = 407;
		__block_user_number = "989";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {442};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[442].run(407);
		}
	}
};

// Block 990 (Set \"Current Market\" for next blocks)
class Block408: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block408() {
		__block_number = 408;
		__block_user_number = "990";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {440};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[440].run(408);
		}
	}
};

// Block 991 (Set \"Current Market\" for next blocks)
class Block409: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block409() {
		__block_number = 409;
		__block_user_number = "991";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {440};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPAUD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[440].run(409);
		}
	}
};

// Block 992 (Set \"Current Market\" for next blocks)
class Block410: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block410() {
		__block_number = 410;
		__block_user_number = "992";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {440};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[440].run(410);
		}
	}
};

// Block 993 (Set \"Current Market\" for next blocks)
class Block411: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block411() {
		__block_number = 411;
		__block_user_number = "993";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {440};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[440].run(411);
		}
	}
};

// Block 994 (Set \"Current Market\" for next blocks)
class Block412: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block412() {
		__block_number = 412;
		__block_user_number = "994";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {440};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[440].run(412);
		}
	}
};

// Block 995 (Set \"Current Market\" for next blocks)
class Block413: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block413() {
		__block_number = 413;
		__block_user_number = "995";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {440};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "CADCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[440].run(413);
		}
	}
};

// Block 996 (Set \"Current Market\" for next blocks)
class Block414: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block414() {
		__block_number = 414;
		__block_user_number = "996";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {438};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[438].run(414);
		}
	}
};

// Block 997 (Set \"Current Market\" for next blocks)
class Block415: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block415() {
		__block_number = 415;
		__block_user_number = "997";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {438};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[438].run(415);
		}
	}
};

// Block 998 (Set \"Current Market\" for next blocks)
class Block416: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block416() {
		__block_number = 416;
		__block_user_number = "998";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {438};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[438].run(416);
		}
	}
};

// Block 999 (Set \"Current Market\" for next blocks)
class Block417: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block417() {
		__block_number = 417;
		__block_user_number = "999";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {438};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDNZD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[438].run(417);
		}
	}
};

// Block 1000 (Set \"Current Market\" for next blocks)
class Block418: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block418() {
		__block_number = 418;
		__block_user_number = "1000";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {438};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "CHFJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[438].run(418);
		}
	}
};

// Block 1001 (Set \"Current Market\" for next blocks)
class Block419: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block419() {
		__block_number = 419;
		__block_user_number = "1001";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {436};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "USDJPY";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[436].run(419);
		}
	}
};

// Block 1002 (Set \"Current Market\" for next blocks)
class Block420: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block420() {
		__block_number = 420;
		__block_user_number = "1002";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {436};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[436].run(420);
		}
	}
};

// Block 1003 (Set \"Current Market\" for next blocks)
class Block421: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block421() {
		__block_number = 421;
		__block_user_number = "1003";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {436};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURNZD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[436].run(421);
		}
	}
};

// Block 1004 (Set \"Current Market\" for next blocks)
class Block422: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block422() {
		__block_number = 422;
		__block_user_number = "1004";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {436};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "AUDCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[436].run(422);
		}
	}
};

// Block 1005 (Set \"Current Market\" for next blocks)
class Block423: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block423() {
		__block_number = 423;
		__block_user_number = "1005";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {429};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "NZDUSD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[429].run(423);
		}
	}
};

// Block 1006 (Set \"Current Market\" for next blocks)
class Block424: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block424() {
		__block_number = 424;
		__block_user_number = "1006";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {429};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[429].run(424);
		}
	}
};

// Block 1007 (Set \"Current Market\" for next blocks)
class Block425: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block425() {
		__block_number = 425;
		__block_user_number = "1007";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {429};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[429].run(425);
		}
	}
};

// Block 1008 (Buy now)
class Block426: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block426() {
		__block_number = 426;
		__block_user_number = "1008";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		double value = (double)dlStopLoss._execute_();
		value = value-toDigits(10,CurrentSymbol()); // Adjust the value
		return value;
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::lotxxx;
		StopLossPips = (double)c::SL;
		TakeProfitPips = (double)c::TP;
		TakeProfitPercentSL = (double)c::TP;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 1009 (Sell now)
class Block427: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block427() {
		__block_number = 427;
		__block_user_number = "1009";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		double value = (double)dlStopLoss._execute_();
		value = value+toDigits(10,CurrentSymbol()); // Adjust the value
		return value;
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::lotxxx;
		StopLossPips = (double)c::SL;
		TakeProfitPips = (double)c::TP;
		TakeProfitPercentSL = (double)c::TP;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 1012 (Pass)
class Block428: public MDL_Pass
{

	public: /* Constructor */
	Block428() {
		__block_number = 428;
		__block_user_number = "1012";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {443};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[443].run(428);
		}
	}
};

// Block 1013 (Pass)
class Block429: public MDL_Pass
{

	public: /* Constructor */
	Block429() {
		__block_number = 429;
		__block_user_number = "1013";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {444};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[444].run(429);
		}
	}
};

// Block 1014 (Set \"Current Market\" for next blocks)
class Block430: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block430() {
		__block_number = 430;
		__block_user_number = "1014";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {434};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "USDCAD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[434].run(430);
		}
	}
};

// Block 1015 (Set \"Current Market\" for next blocks)
class Block431: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block431() {
		__block_number = 431;
		__block_user_number = "1015";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {434};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "GBPNZD";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[434].run(431);
		}
	}
};

// Block 1016 (Set \"Current Market\" for next blocks)
class Block432: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block432() {
		__block_number = 432;
		__block_user_number = "1016";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {434};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ListOfSymbols = "EURCHF";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[434].run(432);
		}
	}
};

// Block 1017 (Pass)
class Block433: public MDL_Pass
{

	public: /* Constructor */
	Block433() {
		__block_number = 433;
		__block_user_number = "1017";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {443};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[443].run(433);
		}
	}
};

// Block 1018 (Pass)
class Block434: public MDL_Pass
{

	public: /* Constructor */
	Block434() {
		__block_number = 434;
		__block_user_number = "1018";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {444};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[444].run(434);
		}
	}
};

// Block 1019 (Pass)
class Block435: public MDL_Pass
{

	public: /* Constructor */
	Block435() {
		__block_number = 435;
		__block_user_number = "1019";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {443};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[443].run(435);
		}
	}
};

// Block 1020 (Pass)
class Block436: public MDL_Pass
{

	public: /* Constructor */
	Block436() {
		__block_number = 436;
		__block_user_number = "1020";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {444};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[444].run(436);
		}
	}
};

// Block 1021 (Pass)
class Block437: public MDL_Pass
{

	public: /* Constructor */
	Block437() {
		__block_number = 437;
		__block_user_number = "1021";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {443};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[443].run(437);
		}
	}
};

// Block 1022 (Pass)
class Block438: public MDL_Pass
{

	public: /* Constructor */
	Block438() {
		__block_number = 438;
		__block_user_number = "1022";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {444};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[444].run(438);
		}
	}
};

// Block 1023 (Pass)
class Block439: public MDL_Pass
{

	public: /* Constructor */
	Block439() {
		__block_number = 439;
		__block_user_number = "1023";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {443};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[443].run(439);
		}
	}
};

// Block 1024 (Pass)
class Block440: public MDL_Pass
{

	public: /* Constructor */
	Block440() {
		__block_number = 440;
		__block_user_number = "1024";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {444};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[444].run(440);
		}
	}
};

// Block 1025 (Pass)
class Block441: public MDL_Pass
{

	public: /* Constructor */
	Block441() {
		__block_number = 441;
		__block_user_number = "1025";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {443};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[443].run(441);
		}
	}
};

// Block 1026 (Pass)
class Block442: public MDL_Pass
{

	public: /* Constructor */
	Block442() {
		__block_number = 442;
		__block_user_number = "1026";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {444};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[444].run(442);
		}
	}
};

// Block 1029 (Pass)
class Block443: public MDL_Pass
{

	public: /* Constructor */
	Block443() {
		__block_number = 443;
		__block_user_number = "1029";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {450};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[450].run(443);
		}
	}
};

// Block 1030 (Pass)
class Block444: public MDL_Pass
{

	public: /* Constructor */
	Block444() {
		__block_number = 444;
		__block_user_number = "1030";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {452};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[452].run(444);
		}
	}
};

// Block 1033 (No position nearby)
class Block445: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block445() {
		__block_number = 445;
		__block_user_number = "1033";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {427};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
		ModeRange = "fraction";
	}

	public: /* Custom methods */
	virtual datetime _Time1_() {return Time1._execute_();}
	virtual datetime _Time2_() {return Time2._execute_();}
	virtual double _BasePrice_() {
		BasePrice.Symbol = CurrentSymbol();

		return BasePrice._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[427].run(445);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		RangeFraction = (double)v::ATR_near;
	}
};

// Block 1035 (If position)
class Block446: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block446() {
		__block_number = 446;
		__block_user_number = "1035";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {448};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[448].run(446);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1036 (Check profit (unrealized))
class Block447: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block447() {
		__block_number = 447;
		__block_user_number = "1036";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {449};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[449].run(447);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Percentx;
	}
};

// Block 1037 (Formula)
class Block448: public MDL_Formula_1<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block448() {
		__block_number = 448;
		__block_user_number = "1037";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {447};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[447].run(448);
		}
	}
};

// Block 1038 (Close positions)
class Block449: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block449() {
		__block_number = 449;
		__block_user_number = "1038";
		_beforeExecuteEnabled = true;
		// Block input parameters
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 1039 (Formula)
class Block450: public MDL_Formula_2<MDLIC_indicators_iATR,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block450() {
		__block_number = 450;
		__block_user_number = "1039";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {445};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ATRperiod = c::ATR_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::ATR_Timeframe;

		double value = (double)Lo._execute_();
		value = value*2; // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = c::ATR_Multiply;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[445].run(450);
		}
	}
};

// Block 1040 (No position nearby)
class Block451: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block451() {
		__block_number = 451;
		__block_user_number = "1040";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {426};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
		ModeRange = "fraction";
	}

	public: /* Custom methods */
	virtual datetime _Time1_() {return Time1._execute_();}
	virtual datetime _Time2_() {return Time2._execute_();}
	virtual double _BasePrice_() {
		BasePrice.Symbol = CurrentSymbol();

		return BasePrice._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[426].run(451);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		RangeFraction = (double)v::ATR_near;
	}
};

// Block 1046 (Formula)
class Block452: public MDL_Formula_3<MDLIC_indicators_iATR,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block452() {
		__block_number = 452;
		__block_user_number = "1046";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {451};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ATRperiod = c::ATR_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::ATR_Timeframe;

		double value = (double)Lo._execute_();
		value = value*2; // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = c::ATR_Multiply;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[451].run(452);
		}
	}
};

// Block 1047 (Pass)
class Block453: public MDL_Pass
{

	public: /* Constructor */
	Block453() {
		__block_number = 453;
		__block_user_number = "1047";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {454};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[454].run(453);
		}
	}
};

// Block 1048 (Formula)
class Block454: public MDL_Formula_4<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block454() {
		__block_number = 454;
		__block_user_number = "1048";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::LOT_Divided_by;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};


/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                                   Functions                                                      | //
// |                                 System and Custom functions used in the program                                  | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/


double AccountBalance()
{
	return NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
}

double AccountBalanceAtStart()
{
   // This function MUST be run once at pogram's start
	static double memory = 0;

	if (memory == 0) memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);

	return memory;
}

double AccountEquity()
{
	return AccountInfoDouble(ACCOUNT_EQUITY);
}

double AccountFreeMargin()
{
	return AccountInfoDouble(ACCOUNT_FREEMARGIN);
}

double AlignLots(string symbol, double lots, double lowerlots=0, double upperlots=0)
{
	double LotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
	double LotSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
	double MinLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
	double MaxLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

	if (LotStep > MinLots) MinLots = LotStep;

	if (lots == EMPTY_VALUE) {lots = 0;}

	lots = MathRound(lots/LotStep)*LotStep;

	if (lots < MinLots) {lots = MinLots;}
	if (lots > MaxLots) {lots = MaxLots;}

	if (lowerlots > 0)
	{
		lowerlots = MathRound(lowerlots/LotStep)*LotStep;
		if (lots < lowerlots) {lots = lowerlots;}
	}

	if (upperlots > 0)
	{
		upperlots = MathRound(upperlots/LotStep)*LotStep;
		if (lots > upperlots) {lots = upperlots;}
	}

	return lots;
}

double AlignStopLoss(
	string symbol,
	int type,
	double price,
	double slo=0, // original sl, used when modifying
	double sll=0,
	double slp=0,
	bool consider_freezelevel=false
	)
{
	double sl = 0;
	
	if (MathAbs(sll) == EMPTY_VALUE) {sll = 0;}
	if (MathAbs(slp) == EMPTY_VALUE) {slp = 0;}

	if (sll == 0 && slp == 0)
	{
		return 0;
	}

	if (price <= 0)
	{
		Print("AlignStopLoss() error: No price entered");

		return(-1);
	}

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	slp          = slp * PipValue(symbol) * point;

	//-- buy-sell identifier ---------------------------------------------
	int bs = 1;

	if (
		   type == ORDER_TYPE_SELL
		|| type == ORDER_TYPE_SELL_STOP
		|| type == ORDER_TYPE_SELL_LIMIT
		|| type == ORDER_TYPE_SELL_STOP_LIMIT
		)
	{
		bs = -1;
	}

	//-- prices that will be used ----------------------------------------
	double askbid = price;
	double bidask = price;

	if (type < 2)
	{
		double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
		double bid = SymbolInfoDouble(symbol, SYMBOL_BID);

		askbid = ask;
		bidask = bid;

		if (bs < 0)
		{
		  askbid = bid;
		  bidask = ask;
		}
	}

	//-- build sl level -------------------------------------------------- 
	if (sll == 0 && slp != 0) {sll = price;}

	if (sll > 0) {sl = sll - slp * bs;}

	if (sl < 0)
	{
		return -1;
	}

	sl  = NormalizeDouble(sl, digits);
	slo = NormalizeDouble(slo, digits);

	if (sl == slo)
	{
		return sl;
	}

	//-- build limit levels ----------------------------------------------
	double minstops = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);

	if (consider_freezelevel == true)
	{
		double freezelevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (freezelevel > minstops) {minstops = freezelevel;}
	}

	minstops = NormalizeDouble(minstops * point,digits);

	double sllimit = bidask - minstops * bs; // SL min price level

	//-- check and align sl, print errors --------------------------------
	//-- do not do it when the stop is the same as the original
	if (sl > 0 && sl != slo)
	{
		if ((bs > 0 && sl > askbid) || (bs < 0 && sl < askbid))
		{
			string abstr = "";

			if (bs > 0) {abstr = "Bid";} else {abstr = "Ask";}

			Print(
				"Error: Invalid SL requested (",
				DoubleToStr(sl, digits),
				" for ", abstr, " price ",
				bidask,
				")"
			);

			return -1;
		}
		else if ((bs > 0 && sl > sllimit) || (bs < 0 && sl < sllimit))
		{
			if (USE_VIRTUAL_STOPS)
			{
				return sl;
			}

			Print(
				"Warning: Too short SL requested (",
				DoubleToStr(sl, digits),
				" or ",
				DoubleToStr(MathAbs(sl - askbid) / point, 0),
				" points), minimum will be taken (",
				DoubleToStr(sllimit, digits),
				" or ",
				DoubleToStr(MathAbs(askbid - sllimit) / point, 0),
				" points)"
			);

			sl = sllimit;

			return sl;
		}
	}

	// align by the ticksize
	double ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
	sl = MathRound(sl / ticksize) * ticksize;

	return sl;
}

double AlignTakeProfit(
	string symbol,
	int type,
	double price,
	double tpo = 0, // original tp, used when modifying
	double tpl = 0,
	double tpp = 0,
	bool consider_freezelevel = false
	)
{
	double tp=0;
	
	if (MathAbs(tpl) == EMPTY_VALUE) {tpl = 0;}
	if (MathAbs(tpp) == EMPTY_VALUE) {tpp = 0;}

	if (tpl == 0 && tpp == 0)
	{
		return 0;
	}

	if (price <= 0)
	{
		Print("AlignTakeProfit() error: No price entered");

		return -1;
	}

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	tpp          = tpp * PipValue(symbol) * point;
	
	//-- buy-sell identifier ---------------------------------------------
	int bs = 1;

	if (
		   type == ORDER_TYPE_SELL
		|| type == ORDER_TYPE_SELL_STOP
		|| type == ORDER_TYPE_SELL_LIMIT
		|| type == ORDER_TYPE_SELL_STOP_LIMIT
		)
	{
		bs = -1;
	}
	
	//-- prices that will be used ----------------------------------------
	double askbid = price;
	double bidask = price;
	
	if (type < 2)
	{
		double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
		double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
		
		askbid = ask;
		bidask = bid;

		if (bs < 0)
		{
		  askbid = bid;
		  bidask = ask;
		}
	}
	
	//-- build tp level --------------------------------------------------- 
	if (tpl == 0 && tpp != 0) {tpl = price;}

	if (tpl > 0) {tp = tpl + tpp * bs;}
	
	if (tp < 0)
	{
		return -1;
	}

	tp  = NormalizeDouble(tp, digits);
	tpo = NormalizeDouble(tpo, digits);

	if (tp == tpo)
	{
		return tp;
	}
	
	//-- build limit levels ----------------------------------------------
	double minstops = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);

	if (consider_freezelevel == true)
	{
		double freezelevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (freezelevel > minstops) {minstops = freezelevel;}
	}

	minstops = NormalizeDouble(minstops * point,digits);
	
	double tplimit = bidask + minstops * bs; // TP min price level
	
	//-- check and align tp, print errors --------------------------------
	//-- do not do it when the stop is the same as the original
	if (tp > 0 && tp != tpo)
	{
		if ((bs > 0 && tp < bidask) || (bs < 0 && tp > bidask))
		{
			string abstr = "";

			if (bs > 0) {abstr = "Bid";} else {abstr = "Ask";}

			Print(
				"Error: Invalid TP requested (",
				DoubleToStr(tp, digits),
				" for ", abstr, " price ",
				bidask,
				")"
			);

			return -1;
		}
		else if ((bs > 0 && tp < tplimit) || (bs < 0 && tp > tplimit))
		{
			if (USE_VIRTUAL_STOPS)
			{
				return tp;
			}

			Print(
				"Warning: Too short TP requested (",
				DoubleToStr(tp, digits),
				" or ",
				DoubleToStr(MathAbs(tp - askbid) / point, 0),
				" points), minimum will be taken (",
				DoubleToStr(tplimit, digits),
				" or ",
				DoubleToStr(MathAbs(askbid - tplimit) / point, 0),
				" points)"
			);

			tp = tplimit;

			return tp;
		}
	}
	
	// align by the ticksize
	double ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
	tp = MathRound(tp / ticksize) * ticksize;
	
	return tp;
}

template<typename T>
bool ArrayEnsureValue(T &array[], T value)
{
	int size   = ArraySize(array);
	
	if (size > 0)
	{
		if (InArray(array, value))
		{
			// value found -> exit
			return false; // no value added
		}
	}
	
	// value does not exists -> add it
	ArrayResize(array, size+1);
	array[size] = value;
		
	return true; // value added
}

template<typename T>
int ArraySearch(T &array[], T value)
{
	static int index;    
	static int size;
	
	index = -1;
	size  = ArraySize(array);

	for (int i=0; i<size; i++)
	{
		if (array[i] == value)
		{
			index = i;
			break;
		}  
	}

   return index;
}

template<typename T>
bool ArrayStripKey(T &array[], int key)
{
	int x    = 0;
	int size = ArraySize(array);
	
	for (int i=0; i<size; i++)
	{
		if (i != key)
		{
			array[x] = array[i];
			x++;
		}
	}
		
	if (x < size)
	{
		ArrayResize(array, x);
		
		return true; // stripped
	}
	
	return false; // not stripped
}

template<typename T>
bool ArrayStripValue(T &array[], T value)
{
	int x    = 0;
	int size = ArraySize(array);
	
	for (int i=0; i<size; i++)
	{
		if (array[i] != value)
		{
			array[x] = array[i];
			x++;
		}
	}
	
	if (x < size)
	{
		ArrayResize(array, x);
		
		return true; // stripped
	}
	
	return false; // not stripped
}

double Bet1326(
	string group,
	string symbol,
	double initial_lots,
	bool reverse = false
) {  
	int pos            = 0;
	int total          = 0;
	double lots        = 0;
	double profit      = 0;
	int profit_or_loss = 0; // 0 - unknown, 1 - profit, -1 - loss
   
   //-- try to get last lot size from running trades
	total = TradesTotal();
	
	for (pos = total - 1; pos >= 0; pos--)
	{
		if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profit == 0)
			{
				return lots;
			}

			if (profit<0) {profit_or_loss=-1;}
			else {profit_or_loss=1;}

			break;
		}
	}
   
   //-- if no running trade was found, search in history trades
   if (lots==0)
   {
      total = HistoryTradesTotal();

		for (pos = total - 1; pos >= 0; pos--)
      {
			if (HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
				if (OrderType() == 0) {profit = -1*profit;}
				if (profit == 0) {
					return(lots);
				}

				if (profit<0) {profit_or_loss=-1;}
				else {profit_or_loss=1;}

				break;
			}
      }
   }
   
   //--
   if (initial_lots < SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN)) {
      initial_lots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);  
   }

   if (lots==0) {lots = initial_lots;}
   else
   {
      if ((reverse==false && profit_or_loss==1) || (reverse==true && profit_or_loss==-1))
      {
         double div = lots/initial_lots;
         
         if (div < 1.5) {lots = initial_lots*3;}
         else if (div < 2.5) {lots = initial_lots*6;}
         else if (div < 3.5) {lots = initial_lots*2;}
         else {lots = initial_lots;}
      }
      else {
         lots = initial_lots;
      }
   }
   
   return lots;
}

double BetDalembert(
	string group,
	string symbol,
	double initial_lots,
	double reverse = false
) {  
	int pos            = 0;
	int total          = 0;
	double lots        = 0;
	double profit      = 0;
	int profit_or_loss = 0; // 0 - unknown, 1 - profit, -1 - loss
   
   //-- try to get last lot size from running trades
	total = TradesTotal();
	
	for (pos = total - 1; pos >= 0; pos--)
	{
		if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profit == 0)
			{
				return lots;
			}

			if (profit<0) {profit_or_loss=-1;}
			else {profit_or_loss=1;}

			break;
		}
	}
   
   //-- if no running trade was found, search in history trades
   if (lots==0)
   {
      total = HistoryTradesTotal();

		for (pos = total - 1; pos >= 0; pos--)
      {
			if (HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
				if (OrderType() == 0) {profit = -1*profit;}
				if (profit == 0) {
					return(lots);
				}

				if (profit<0) {profit_or_loss=-1;}
				else {profit_or_loss=1;}

				break;
			}
      }
   }
   
   //--
   if (initial_lots < SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN)) {
      initial_lots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);  
   }

   if (lots==0) {lots = initial_lots;}
   else
   {
      if ((reverse==0 && profit_or_loss==1) || (reverse==1 && profit_or_loss==-1))
      {
         lots = lots - initial_lots;
         if (lots < initial_lots) {lots = initial_lots;}
      }
      else {
         lots = lots + initial_lots;
      }
   }
   
   return lots;
}

double BetFibonacci(
   string group,
   string symbol,
   double initial_lots
) {
	int pos            = 0;
	int total          = 0;
	double lots        = 0;
	double profit      = 0;
	int profit_or_loss = 0; // 0 - unknown, 1 - profit, -1 - loss
   
   //-- try to get last lot size from running trades
	total = TradesTotal();
	
	for (pos = total - 1; pos >= 0; pos--)
	{
		if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profit == 0)
			{
				return lots;
			}

			if (profit<0) {profit_or_loss=-1;}
			else {profit_or_loss=1;}

			break;
		}
	}
   
   //-- if no running trade was found, search in history trades
   if (lots==0)
   {
      total = HistoryTradesTotal();

		for (pos = total - 1; pos >= 0; pos--)
      {
			if (HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
				if (OrderType() == 0) {profit = -1*profit;}
				if (profit == 0) {
					return(lots);
				}

				if (profit<0) {profit_or_loss=-1;}
				else {profit_or_loss=1;}

				break;
			}
      }
   }
   
   //--
   if (initial_lots < SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN)) {
      initial_lots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);  
   }

   if (lots==0) {lots = initial_lots;}
   else
   {  
      int fibo1=1, fibo2=0, fibo3=0, fibo4=0;
      double div = lots/initial_lots;
      
      if (div<=0) {div=1;}

      while(true)
      {
         fibo1=fibo1+fibo2;
         fibo3=fibo2;
         fibo2=fibo1-fibo2;
         fibo4=fibo2-fibo3;
         if (fibo1 > NormalizeDouble(div, 2)) {break;}
      }
      //Print("("+fibo1 + "+" + fibo2+"+"+fibo3+") > "+div);
      if (profit_or_loss==1)
      {
         if (fibo4<=0) {fibo4=1;}
         //Print("Profit "+lots+"*"+fibo4);
         lots=initial_lots*(fibo4);
      }
      else {
         //Print("Loss "+lots+"*"+fibo1+"+"+fibo2);
         lots=initial_lots*(fibo1);
      }
   }
   
   lots=NormalizeDouble(lots, 2);
   return lots;
}

double BetLabouchere(
	string group,
	string symbol,
	double initial_lots,
	string list_of_numbers,
	double reverse = false
) {
	int pos            = 0;
	int total          = 0;
	double lots        = 0;
	double profit      = 0;
	int profit_or_loss = 0; // 0 - unknown, 1 - profit, -1 - loss
   
   //-- try to get last lot size from running trades
	total = TradesTotal();
	
	for (pos = total - 1; pos >= 0; pos--)
	{
		if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profit == 0)
			{
				return lots;
			}

			if (profit<0) {profit_or_loss=-1;}
			else {profit_or_loss=1;}

			break;
		}
	}
   
   //-- if no running trade was found, search in history trades
   if (lots==0)
   {
      total = HistoryTradesTotal();

		for (pos = total - 1; pos >= 0; pos--)
      {
			if (HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
				if (OrderType() == 0) {profit = -1*profit;}
				if (profit == 0) {
					return(lots);
				}

				if (profit<0) {profit_or_loss=-1;}
				else {profit_or_loss=1;}

				break;
			}
      }
   }
   
   //-- Labouchere stuff
   static string mem_group[];
   static string mem_list[];
   static int mem_ticket[];
   int start_again=false;
   
   //- get the list of numbers as it is stored in the memory, or store it
   int id=ArraySearch(mem_group, group);
   if (id == -1) {
      start_again=true;
      if (list_of_numbers=="") {list_of_numbers="1";}
      id = ArraySize(mem_group);
      ArrayResize(mem_group, id+1, id+1);
      ArrayResize(mem_list, id+1, id+1);
      ArrayResize(mem_ticket, id+1, id+1);
      mem_group[id]=group;
      mem_list[id]=list_of_numbers;
   }

   if (mem_ticket[id]==(int)OrderTicket()) {
      // the last known ticket (mem_ticket[id]) should be different than OderTicket() normally
      // when failed to create a new trade - the last ticket remains the same
      // so we need to reset
      mem_list[id]=list_of_numbers;
   }
   mem_ticket[id]=(int)OrderTicket();
   
   //- now turn the string into integer array
   int list[];
   string listS[];
   StringExplode(",", mem_list[id], listS);
   ArrayResize(list, ArraySize(listS), ArraySize(listS));
   for (int s=0; s<ArraySize(listS); s++) {
      list[s]=(int)StringToInteger(StringTrim(listS[s]));  
   }

   //-- 
   int size = ArraySize(list);

   if (initial_lots < SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN)) {
      initial_lots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);  
   }

   if (lots==0) {
      start_again=true;
   }
   
   if (start_again==true)
   {
      if (size==1) {
         lots = initial_lots*list[0];
      } else {
         lots = initial_lots*(list[0]+list[size-1]);
      }
   }
   else 
   {
      if ((reverse==0 && profit_or_loss==1) || (reverse==1 && profit_or_loss==-1))
      {
         if (size==1) {
            lots=initial_lots*list[0];
            ArrayResize(list, 0, 0);
         }
         else if (size==2) {
            lots = initial_lots*(list[0]+list[1]);
            ArrayResize(list, 0, 0);
         }
         else if (size>2) {
            lots = initial_lots*(list[0]+list[size-1]);
            // Cancel first and last numbers in our list
            // shift array 1 step left
            for(pos=0; pos<size-1; pos++) {
               list[pos]=list[pos+1];
            }
            ArrayResize(list,ArraySize(list)-2, ArraySize(list)-2); // remove last 2 elements   	
         }
         if (lots < initial_lots) {lots = initial_lots;}
      }
      else {
         if (size>1)
         {
            ArrayResize(list, size+1, size+1);
            list[size]=list[0]+list[size-1];
            lots = initial_lots*(list[0]+list[size]);
         } else {
            lots = initial_lots*list[0];
         }
         if (lots < initial_lots) {lots = initial_lots;}
      }

   }
   
   Print("Labouchere (for group "+(string)id+") current list of numbers:"+StringImplode(",", list));
   size=ArraySize(list);
   if (size==0) {
      ArrayStripKey(mem_group, id);
      ArrayStripKey(mem_list, id);
      ArrayStripKey(mem_ticket, id);
   } else {
      mem_list[id]=StringImplode(",", list);
   }

   return lots;
}

double BetMartingale(
	string group,
	string symbol,
	double initial_lots,
	double multiply_on_loss,
	double multiply_on_profit,
	double add_on_loss,
	double add_on_profit,
	int reset_on_loss,
	int reset_on_profit
) {
	int pos            = 0;
	int total          = 0;
	double lots        = 0;
	double profit      = 0;
	int profit_or_loss = 0; // 0 - unknown, 1 - profit, -1 - loss
	int in_a_row       = 0;

	//-- try to get last lot size from running trades
	total = TradesTotal();
	
	for (pos = total - 1; pos >= 0; pos--)
	{
		if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profit == 0)
			{
				return lots;
			}

			if (profit_or_loss == 0)
			{
				if (profit < 0)
				{
					profit_or_loss = -1;
				}
				else
				{
					profit_or_loss = 1;
				}
			}
			else
			{
				if (
					(profit_or_loss == 1 && profit < 0)
					|| (profit_or_loss == -1 && profit >= 0)
				) {
					break;
				}
			}

			in_a_row++;
		}
	}

	//-- if no running trade was found, search in history trades
	if (lots == 0)
	{
		total = HistoryTradesTotal();

		for (pos = total - 1; pos >= 0; pos--)
		{
			if (HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

				if (OrderType() == 1)
				{
					profit = -1 * profit;
				}
				
				if (profit == 0)
				{
					return lots;
				}

				if (profit_or_loss == 0)
				{
					if (profit < 0)
					{
						profit_or_loss = -1;
					}
					else
					{
						profit_or_loss = 1;
					}
				}
				else {
					if (
						(profit_or_loss == 1 && profit < 0)
						|| (profit_or_loss == -1 && profit >= 0)
					) {
						break;
					}
				}

				in_a_row++;
			}
		}
	}

	// Martingale stuff
	if (lots == 0)
	{
		lots = initial_lots;
	}
	else
	{
		if (profit_or_loss == 1)
		{
			if (reset_on_profit > 0 && in_a_row >= reset_on_profit)
			{
				lots = initial_lots;
			}
			else
			{
				if (multiply_on_profit <= 0)
				{
					multiply_on_profit = 1;
				}

				lots = (lots * multiply_on_profit) + add_on_profit;
			}
		}
		else
		{
			if (reset_on_loss > 0 && in_a_row >= reset_on_loss)
			{
				lots = initial_lots;  
			}
			else
			{
				if (multiply_on_loss <= 0)
				{
					multiply_on_loss = 1;
				}

				lots = (lots * multiply_on_loss) + add_on_loss;
			}
		}
	}

	return lots;
}

double BetSequence(
	string group,
	string symbol,
	double initial_lots,
	string sequence_on_loss,
	string sequence_on_profit,
	bool reverse = false
) {
	int pos            = 0;
	int total          = 0;
	double lots        = 0;
	double profit      = 0;
	int profit_or_loss = 0; // 0 - unknown, 1 - profit, -1 - loss
	int size           = 0;
   
   //-- try to get last lot size from running trades
	total = TradesTotal();
	
	for (pos = total - 1; pos >= 0; pos--)
	{
		if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profit == 0)
			{
				return lots;
			}

			if (profit<0) {profit_or_loss=-1;}
			else {profit_or_loss=1;}

			break;
		}
	}
   
   //-- if no running trade was found, search in history trades
   if (lots==0)
   {
      total = HistoryTradesTotal();

		for (pos = total - 1; pos >= 0; pos--)
      {
			if (HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
				if (OrderType() == 0) {profit = -1*profit;}
				if (profit == 0) {
					return(lots);
				}

				if (profit<0) {profit_or_loss=-1;}
				else {profit_or_loss=1;}

				break;
			}
      }
   }
   
   //-- Sequence stuff
   static string mem_group[];
   static string mem_list_loss[];
   static string mem_list_profit[];
   static int mem_ticket[];
   
   //- get the list of numbers as it is stored in the memory, or store it
   int id=ArraySearch(mem_group, group);
   if (id == -1)
   {
      if (sequence_on_loss=="") {sequence_on_loss="1";}
      if (sequence_on_profit=="") {sequence_on_profit="1";}
      id = ArraySize(mem_group);
      ArrayResize(mem_group, id+1, id+1);
      ArrayResize(mem_list_loss, id+1, id+1);
      ArrayResize(mem_list_profit, id+1, id+1);
      ArrayResize(mem_ticket, id+1, id+1);
      mem_group[id]        =group;
      mem_list_loss[id]    =sequence_on_loss;
      mem_list_profit[id]  =sequence_on_profit;
   }
   
   bool loss_reset=false;
   bool profit_reset=false;
   if (profit_or_loss==-1 && mem_list_loss[id]=="") {
      loss_reset=true;
      mem_list_profit[id]="";
   }
   if (profit_or_loss==1 && mem_list_profit[id]=="") {
      profit_reset=true;
      mem_list_loss[id]="";
   }
   
   if (profit_or_loss==1 || mem_list_loss[id]=="") {
      mem_list_loss[id]=sequence_on_loss;
      if (loss_reset) {mem_list_loss[id]="1,"+mem_list_loss[id];}
      
   }
   if (profit_or_loss==-1 ||mem_list_profit[id]=="") {
      mem_list_profit[id]=sequence_on_profit;
      if (profit_reset) {mem_list_profit[id]="1,"+mem_list_profit[id];}
   }
   
   if (mem_ticket[id]==(int)OrderTicket()) {
      // the last known ticket (mem_ticket[id]) should be different than OderTicket() normally
      // when failed to create a new trade - the last ticket remains the same
      // so we need to reset
      mem_list_loss[id]=sequence_on_loss;
      mem_list_profit[id]=sequence_on_profit;
   }
   mem_ticket[id]=(int)OrderTicket();
   
   //- now turn the string into integer array
   int s=0;
   double list_loss[];
   double list_profit[];
   string listS[];
   StringExplode(",", mem_list_loss[id], listS);
   ArrayResize(list_loss, ArraySize(listS), ArraySize(listS));
   for (s=0; s<ArraySize(listS); s++) {
      list_loss[s]=(double)StringToDouble(StringTrim(listS[s]));  
   }
   StringExplode(",", mem_list_profit[id], listS);
   ArrayResize(list_profit, ArraySize(listS), ArraySize(listS));
   for (s=0; s<ArraySize(listS); s++) {
      list_profit[s]=(double)StringToDouble(StringTrim(listS[s]));  
   }

   //--
   if (initial_lots < SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN)) {
      initial_lots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);  
   }

   if (lots==0) {lots = initial_lots;}
   else
   {
      if ((reverse==false && profit_or_loss==1) || (reverse==true && profit_or_loss==-1))
      {
         lots = initial_lots*list_profit[0];
         // shift array 1 step left
         size=ArraySize(list_profit);
         for(pos=0; pos<size-1; pos++) {
            list_profit[pos]=list_profit[pos+1];
         }
         if (size>0) {
            ArrayResize(list_profit, size-1, size-1);
            mem_list_profit[id]=StringImplode(",", list_profit);
         }
         // reset the opposite sequence
         //mem_list_loss[id]="";
      }
      else {
         
         lots = initial_lots*list_loss[0];
         // shift array 1 step left
         size=ArraySize(list_loss);
         for(pos=0; pos<size-1; pos++) {
            list_loss[pos]=list_loss[pos+1];
         }
         if (size>0) {
            ArrayResize(list_loss, size-1, size-1);
            mem_list_loss[id]=StringImplode(",", list_loss);
         }
         // reset the opposite sequence
         //mem_list_profit[id]="";
      }
   }
   
   return lots;
}

int BuildOrdersList(order &list[])
{
	int last_error = 0;
	int total      = OrdersTotal();

	int temp_value = (int)MathMax(total,1);
	ArrayResize(list, temp_value);

	int orders_count = 0;

	for (int i=total-1; i>=0; i--)
	{
		if (OrderGetTicket(i))
		{
			list[i].ticket          = OrderGetTicket(i);
			list[i].time_setup      = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
			list[i].time_expiration = (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
			list[i].time_done       = (datetime)OrderGetInteger(ORDER_TIME_DONE);
			list[i].type            = OrderGetInteger(ORDER_TYPE);

			list[i].state           = OrderGetInteger(ORDER_STATE);
			list[i].type_filling    = OrderGetInteger(ORDER_TYPE_FILLING);
			list[i].type_time       = OrderGetInteger(ORDER_TYPE_TIME);
			list[i].magic           = OrderGetInteger(ORDER_MAGIC);
			list[i].position_id     = OrderGetInteger(ORDER_POSITION_ID);

			list[i].volume_initial  = OrderGetDouble(ORDER_VOLUME_INITIAL);
			list[i].volume_current  = OrderGetDouble(ORDER_VOLUME_CURRENT);
			list[i].price_open      = OrderGetDouble(ORDER_PRICE_OPEN);
			list[i].sl              = OrderGetDouble(ORDER_SL);
			list[i].tp              = OrderGetDouble(ORDER_TP);
			list[i].price_current   = OrderGetDouble(ORDER_PRICE_CURRENT);
			list[i].price_stoplimit = OrderGetDouble(ORDER_PRICE_STOPLIMIT);

			list[i].symbol          = OrderGetString(ORDER_SYMBOL);
			list[i].comment         = OrderGetString(ORDER_COMMENT);

			orders_count++;
		}
		else
		{
			last_error = GetLastError();
			Print("BuildOrdersList() - Error #", last_error);
		}
	}

	temp_value = (int)MathMax(orders_count,1);
	ArrayResize(list, temp_value);

	return orders_count;
}

int BuildPositionsList(position &list[])
{
	int last_error=0;
	int total=PositionsTotal();
  
	ArrayResize(list, total);

	int positions_count=0;

	for(int i=total-1; i>=0; i--)
	{
		if(PositionSelectByTicket(PositionGetTicket(i)))
		{
			// If the position is found, then put its info to the array
			list[i].position_id   = PositionGetInteger(POSITION_IDENTIFIER);
			list[i].type          = PositionGetInteger(POSITION_TYPE);
			list[i].time          = (datetime)PositionGetInteger(POSITION_TIME);
			list[i].magic         = PositionGetInteger(POSITION_MAGIC);
			list[i].volume        = PositionGetDouble(POSITION_VOLUME);
			list[i].price_open    = PositionGetDouble(POSITION_PRICE_OPEN);
			list[i].sl            = PositionGetDouble(POSITION_SL);
			list[i].tp            = PositionGetDouble(POSITION_TP);
			list[i].price_current = PositionGetDouble(POSITION_PRICE_CURRENT);
			list[i].comission     = PositionGetDouble(POSITION_COMMISSION);
			list[i].swap          = PositionGetDouble(POSITION_SWAP);
			list[i].profit        = PositionGetDouble(POSITION_PROFIT);
			list[i].symbol        = PositionGetString(POSITION_SYMBOL);
			list[i].comment       = PositionGetString(POSITION_COMMENT);

			positions_count++;
		}
	}

	ArrayResize(list, positions_count);

   return positions_count;
}

long BuyNow(
	string symbol,
	double lots,
	double sll,
	double tpl,
	double slp,
	double tpp,
	double slippage = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	datetime expiration = 0
	)
{
	return OrderCreate(
		symbol,
		POSITION_TYPE_BUY,
		lots,
		0,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration
	);
}

int CheckForTradingError(int error_code=-1, string msg_prefix="")
{
   // return 0 -> no error
   // return 1 -> overcomable error
   // return 2 -> fatal error
   
   int retval=0;
   static int tryouts=0;
   
   //-- error check -----------------------------------------------------
   switch(error_code)
   {
      //-- no error
      case 0:
         retval=0;
         break;
      //-- overcomable errors
      case TRADE_RETCODE_REQUOTE:
      case TRADE_RETCODE_REJECT:
      case TRADE_RETCODE_ERROR:
      case TRADE_RETCODE_TIMEOUT:
      case TRADE_RETCODE_INVALID_VOLUME:
      case TRADE_RETCODE_INVALID_PRICE:
      case TRADE_RETCODE_INVALID_STOPS:
      case TRADE_RETCODE_INVALID_EXPIRATION:
      case TRADE_RETCODE_PRICE_CHANGED:
      case TRADE_RETCODE_PRICE_OFF:
      case TRADE_RETCODE_TOO_MANY_REQUESTS:
      case TRADE_RETCODE_NO_CHANGES:
      case TRADE_RETCODE_CONNECTION:
         retval=1;
         break;
      //-- critical errors
      default:
         retval=2;
         break;
   }
   
   if (error_code > 0)
   {
      string msg = "";
      if (retval == 1)
      {
         StringConcatenate(msg, msg_prefix,": ",ErrorMessage(error_code),". Retrying in 5 seconds..");
         Sleep(500); 
      }
      else if (retval == 2)
      {
         StringConcatenate(msg, msg_prefix,": ",ErrorMessage(error_code));
      }
      Print(msg);
   }
   
   if (retval==0)
   {
      tryouts=0;
   }
   else if (retval==1)
   {
      tryouts++;
      if (tryouts>=10)
      {
         tryouts=0;
         retval=2;
      }
      else
      {
         Print("retry #"+(string)tryouts+" of 10");
      }
   }
   
   return(retval);
}

bool CloseTrade(ulong ticket, ulong deviation = 0, color clr = clrNONE)
{
	while(true)
	{
		bool success = false;

		if (!PositionSelectByTicket(ticket))
		{
			return false;
		}

		string symbol = PositionGetString(POSITION_SYMBOL);
		long magic    = PositionGetInteger(POSITION_MAGIC);
		double volume = PositionGetDouble(POSITION_VOLUME);

		// With some CFD we can open position with the max volume more than once,
		// so we get a position that has volume bigger than the maximum.
		// Then we cannot close that position, because the volume is too high.
		// For that reason here we will close it in parts.
		double max_volume  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
		double part_volume = (volume > max_volume) ? max_volume : volume;

		//-- close --------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			//--- prepare request for close BUY position
			request.type  = ORDER_TYPE_SELL;
			request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
		}
		else
		{
			//--- prepare request for close SELL position
			request.type  = ORDER_TYPE_BUY;
			request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
		}

		request.action    = TRADE_ACTION_DEAL;
		request.symbol    = symbol;
		request.volume    = part_volume;
		request.magic     = magic;
		request.deviation = (int)(deviation * PipValue(symbol));

		// for hedging mode
		request.position  = ticket;

		// filling type
		if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
			request.type_filling = ORDER_FILLING_FOK;
		else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
			request.type_filling = ORDER_FILLING_IOC;
		else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
			request.type_filling = ORDER_FILLING_RETURN;
		else
			request.type_filling = ORDER_FILLING_RETURN;

		success = OrderSend(request, result);

		//-- error check --------------------------------------------------
		if (!success || (result.retcode != TRADE_RETCODE_DONE && result.retcode != TRADE_RETCODE_PLACED && result.retcode != TRADE_RETCODE_DONE_PARTIAL))
		{
			string errmsgpfx = "Closing position/trade error";

			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return false;
		}
		
		//-- finish work --------------------------------------------------
		if (result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
		{
			// we are closing the position in parts?
			if (volume != part_volume)
			{
				continue; // continue the "while" loop, so that the whole volume could be closed
			}

			while (true)
			{
			  	if (MQLInfoInteger(MQL_TESTER) || !PositionSelectByTicket(ticket))
				{
					break;
				}

				Sleep(10);
			}
		}

		if (success == true)
		{
			if (USE_VIRTUAL_STOPS)
			{
				VirtualStopsDriver("clear", ticket);
			}
		}
		
		break;
	}
	
	OnTrade();

	return true;
}

template<typename DT1, typename DT2>
bool CompareValues(string sign, DT1 v1, DT2 v2)
{
	     if (sign == ">") return(v1 > v2);
	else if (sign == "<") return(v1 < v2);
	else if (sign == ">=") return(v1 >= v2);
	else if (sign == "<=") return(v1 <= v2);
	else if (sign == "==") return(v1 == v2);
	else if (sign == "!=") return(v1 != v2);
	else if (sign == "x>") return(v1 > v2);
	else if (sign == "x<") return(v1 < v2);

	return false;
}

string CurrentSymbol(string symbol="")
{
   static string memory="";
   if (symbol!="") {memory=symbol;} else
   if (memory=="") {memory=Symbol();}
   return(memory);
}

ENUM_TIMEFRAMES CurrentTimeframe(ENUM_TIMEFRAMES tf=-1)
{
   static ENUM_TIMEFRAMES memory=0;
   if (tf>=0) {memory=tf;}
   return(memory);
}

double CustomPoint(string symbol)
{
	static string symbols[];
	static double points[];
	static string last_symbol = "-";
	static double last_point  = 0;
	static int last_i         = 0;
	static int size           = 0;

	//-- variant A) use the cache for the last used symbol
	if (symbol == last_symbol)
	{
		return last_point;
	}

	//-- variant B) search in the array cache
	int i			= last_i;
	int start_i	= i;
	bool found	= false;

	if (size > 0)
	{
		while (true)
		{
			if (symbols[i] == symbol)
			{
				last_symbol	= symbol;
				last_point	= points[i];
				last_i		= i;

				return last_point;
			}

			i++;

			if (i >= size)
			{
				i = 0;
			}
			if (i == start_i) {break;}
		}
	}

	//-- variant C) add this symbol to the cache
	i		= size;
	size	= size + 1;

	ArrayResize(symbols, size);
	ArrayResize(points, size);

	symbols[i]	= symbol;
	points[i]	= 0;
	last_symbol	= symbol;
	last_i		= i;

	//-- unserialize rules from FXD_POINT_FORMAT_RULES
	string rules[];
	StringExplode(",", POINT_FORMAT_RULES, rules);

	int rules_count = ArraySize(rules);

	if (rules_count > 0)
	{
		string rule[];

		for (int r = 0; r < rules_count; r++)
		{
			StringExplode("=", rules[r], rule);

			//-- a single rule must contain 2 parts, [0] from and [1] to
			if (ArraySize(rule) != 2) {continue;}

			double from = StringToDouble(rule[0]);
			double to	= StringToDouble(rule[1]);

			//-- "to" must be a positive number, different than 0
			if (to <= 0) {continue;}

			//-- "from" can be a number or a string
			// a) string
			if (from == 0 && StringLen(rule[0]) > 0)
			{
				string s_from = rule[0];
				int pos       = StringFind(s_from, "?");

				if (pos < 0) // ? not found
				{
					if (StringFind(symbol, s_from) == 0) {points[i] = to;}
				}
				else if (pos == 0) // ? is the first symbol => match the second symbol
				{
					if (StringFind(symbol, StringSubstr(s_from, 1), 3) == 3)
					{
						points[i] = to;
					}
				}
				else if (pos > 0) // ? is the second symbol => match the first symbol
				{
					if (StringFind(symbol, StringSubstr(s_from, 0, pos)) == 0)
					{
						points[i] = to;
					}
				}
			}

			// b) number
			if (from == 0) {continue;}

			if (SymbolInfoDouble(symbol, SYMBOL_POINT) == from)
			{
				points[i] = to;
			}
		}
	}

	if (points[i] == 0)
	{
		points[i] = SymbolInfoDouble(symbol, SYMBOL_POINT);
	}

	last_point = points[i];

	return last_point;
}

bool DeleteOrder(ulong ticket, color arrowcolor=clrNONE)
{
   while(true)
   {
      MqlTradeRequest request;
      MqlTradeResult result;
      MqlTradeCheckResult check_result;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(check_result);
   
      request.order=ticket;
      request.action=TRADE_ACTION_REMOVE;
      request.comment="Pending order canceled";
   
      if (!OrderCheck(request,check_result))  {
         Print("OrderCheck() failed: "+(string)check_result.comment+" ("+(string)check_result.retcode+")");
         return false;
      }
      
      bool success = OrderSend(request,result);
      
      //-- error check --------------------------------------------------
      if (!success || result.retcode!=TRADE_RETCODE_DONE)
      {
         string errmsgpfx="Delete order error";
         int erraction=CheckForTradingError(result.retcode, errmsgpfx);
         switch(erraction)
         {
            case 0: break;    // no error
            case 1: continue; // overcomable error
            case 2: break;    // fatal error
         }
         return(false);
      }
      
      //-- finish work --------------------------------------------------
      if (result.retcode==TRADE_RETCODE_DONE)
      {
         //== Wait until MT5 updates it's cache
         int w;
         for (w=0; w<5000; w++)
         {
            if (!OrderSelect(ticket)) {break;}
            Sleep(1);
         }
         if (w==5000) {
            Print("Check error: Delete order");  
         }
         if (OrderSelect(ticket)) {
            Print("Something went wrong with the order");
            return false;
         }
      }
		
		if (success==true) {
         if (USE_VIRTUAL_STOPS) {
            VirtualStopsDriver("clear",ticket);
         }
         //RegisterEvent("trade");
         //return(true);
      }
		
      break;
   }
   OnTrade();
   return(true);
}

string DoubleToStr(double d, int dig){return(DoubleToString(d,dig));}

void DrawSpreadInfo()
{
   static bool allow_draw = true;
   if (allow_draw==false) {return;}
   if (MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE)) {allow_draw=false;} // Allowed to draw only once in testing mode

   static bool passed         = false;
   static double max_spread   = 0;
   static double min_spread   = EMPTY_VALUE;
   static double avg_spread   = 0;
   static double avg_add      = 0;
   static double avg_cnt      = 0;

   double custom_point = CustomPoint(Symbol());
   double current_spread = 0;
   if (custom_point > 0) {
      current_spread = (SymbolInfoDouble(Symbol(),SYMBOL_ASK)-SymbolInfoDouble(Symbol(),SYMBOL_BID))/custom_point;
   }
   if (current_spread > max_spread) {max_spread = current_spread;}
   if (current_spread < min_spread) {min_spread = current_spread;}
   
   avg_cnt++;
   avg_add     = avg_add + current_spread;
   avg_spread  = avg_add / avg_cnt;

   int x=0; int y=0;
   string name;

   // create objects
   if (passed == false)
   {
      passed=true;
      
      name="fxd_spread_current_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+1);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 18);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "Spread:");
      }
      name="fxd_spread_max_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+17);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrangeRed);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "max:");
      }
      name="fxd_spread_avg_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+9);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "avg:");
      }
      name="fxd_spread_min_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "min:");
      }
      name="fxd_spread_current";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+93);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 18);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
      name="fxd_spread_max";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+17);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrangeRed);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
      name="fxd_spread_avg";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+9);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
      name="fxd_spread_min";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
   }
   
   ObjectSetString(0, "fxd_spread_current", OBJPROP_TEXT, DoubleToStr(current_spread,2));
   ObjectSetString(0, "fxd_spread_max", OBJPROP_TEXT, DoubleToStr(max_spread,2));
   ObjectSetString(0, "fxd_spread_avg", OBJPROP_TEXT, DoubleToStr(avg_spread,2));
   ObjectSetString(0, "fxd_spread_min", OBJPROP_TEXT, DoubleToStr(min_spread,2));
}

string DrawStatus(string text="")
{
   static string memory;
   if (text=="") {
      return(memory);
   }
   
   static bool passed = false;
   int x=210; int y=0;
   string name;

   //-- draw the objects once
   if (passed == false)
   {
      passed = true;
      name="fxd_status_title";
      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0,name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y+17);
      ObjectSetString(0,name, OBJPROP_TEXT, "Status");
      ObjectSetString(0,name, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0,name, OBJPROP_FONTSIZE, 7);
      ObjectSetInteger(0,name, OBJPROP_COLOR, clrGray);
      
      name="fxd_status_text";
      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0,name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x+2);
      ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y+1);
      ObjectSetString(0,name, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0,name, OBJPROP_FONTSIZE, 12);
      ObjectSetInteger(0,name, OBJPROP_COLOR, clrAqua);
   }

   //-- update the text when needed
   if (text != memory) {
      memory=text;
      ObjectSetString(0,"fxd_status_text", OBJPROP_TEXT, text);
   }
   
   return(text);
}

double DynamicLots(string symbol, string mode="balance", double value=0, double sl=0, string align="align")
{
   double size=0;
   double LotStep=SymbolLotStep(symbol);
   double LotSize=SymbolLotSize(symbol);
   double MinLots=SymbolMinLot(symbol);
   double MaxLots=SymbolMaxLot(symbol);
   double TickValue=SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);
   double margin_required=0;
   bool ocm = OrderCalcMargin(ORDER_TYPE_BUY,symbol,1,ask(symbol),margin_required); // This is the MODE_MARGINREQUIRED analog in MQL5
   //if (value>MaxLots) {value=value/LotSize;} // Money-to-Lot conversion
   
        if (mode=="fixed" || mode=="lots") {size=value;}
   else if (mode=="block-equity")     {size=(value/100)*AccountEquity()/margin_required;}
   else if (mode=="block-balance")    {size=(value/100)*AccountBalance()/margin_required;}
   else if (mode=="block-freemargin") {size=(value/100)*AccountFreeMargin()/margin_required;}
   else if (mode=="equity")     {size=(value/100)*AccountEquity()/(LotSize*TickValue);}
   else if (mode=="balance")    {size=(value/100)*AccountBalance()/(LotSize*TickValue);}
   else if (mode=="freemargin") {size=(value/100)*AccountFreeMargin()/(LotSize*TickValue);}
   else if (mode=="equityRisk") {size=((value/100)*AccountEquity())/(sl*TickValue*PipValue(symbol));}
   else if (mode=="balanceRisk"){size=((value/100)*AccountBalance())/(sl*TickValue*PipValue(symbol));}
   else if (mode=="freemarginRisk") {size=((value/100)*AccountFreeMargin())/(sl*TickValue*PipValue(symbol));}
   else if (mode=="fixedRisk")   {size=(value)/(sl*TickValue*PipValue(symbol));}
   else if (mode=="fixedRatio" || mode=="RJFR") { 
      /////
      // Ryan Jones Fixed Ratio MM static data
      static double RJFR_start_lots=0;
      static double RJFR_delta=0;
      static double RJFR_units=1;
      static double RJFR_target_lower=0;
      static double RJFR_target_upper=0;
      /////
      
      if (RJFR_start_lots<=0) {RJFR_start_lots=value;}
      if (RJFR_start_lots<MinLots) {RJFR_start_lots=MinLots;}
      if (RJFR_delta<=0) {RJFR_delta=sl;}
      if (RJFR_target_upper<=0) {
         RJFR_target_upper=AccountEquity()+(RJFR_units*RJFR_delta);
         Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Upper Target Equity=>",RJFR_target_upper);
      }
      if (AccountEquity()>=RJFR_target_upper)
      {
         while(true) {
            Print("Fixed Ratio MM going up to ",(RJFR_start_lots*(RJFR_units+1))," lots: Equity is above Upper Target Equity (",AccountEquity(),">=",RJFR_target_upper,")");
            RJFR_units++;
            RJFR_target_lower=RJFR_target_upper;
            RJFR_target_upper=RJFR_target_upper+(RJFR_units*RJFR_delta);
            Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Lower Target Equity=>",RJFR_target_lower,"; Upper Target Equity=>",RJFR_target_upper);
            if (AccountEquity()<RJFR_target_upper) {break;}
         }
      }
      else if (AccountEquity()<=RJFR_target_lower)
      {
         while(true) {
         if (AccountEquity()>RJFR_target_lower) {break;}
            if (RJFR_units>1) {         
               Print("Fixed Ratio MM going down to ",(RJFR_start_lots*(RJFR_units-1))," lots: Equity is below Lower Target Equity | ", AccountEquity()," <= ",RJFR_target_lower,")");
               RJFR_target_upper=RJFR_target_lower;
               RJFR_target_lower=RJFR_target_lower-((RJFR_units-1)*RJFR_delta);
               RJFR_units--;
               Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Lower Target Equity=>",RJFR_target_lower,"; Upper Target Equity=>",RJFR_target_upper);
            } else {break;}
         }
      }
      size=RJFR_start_lots*RJFR_units;
   }
		
	if (size==EMPTY_VALUE) {size=0;}
   
   static bool alert_min_lots=false;
   if (size<MinLots && alert_min_lots==false) {alert_min_lots=true;
      Alert("You want to trade ",size," lot, but your broker's minimum is ",MinLots," lot. The trade/order will continue with ",MinLots," lot instead of ",size," lot. The same rule will be applied for next trades/orders with desired lot size lower than the minimum. You will not see this message again until you restart the program.");
   }

   size=MathRound(size/LotStep)*LotStep;
   
   if (align=="align") {
      if (size<MinLots) {size=MinLots;}
      if (size>MaxLots) {size=MaxLots;}
   }
   
   return (size);
}

string ErrorMessage(int error_code=-1)
{
	string e = "";
	if (error_code<0) {error_code=GetLastError();}
	

	switch(error_code)
	{
		//--- success
		case 0: return("The operation completed successfully");
		
		//--- Runtime
		case 4001: e = "Unexpected internal error"; break;
		case 4002: e = "Wrong parameter in the inner call of the client terminal function"; break;
		case 4003: e = "Wrong parameter when calling the system function"; break;
		case 4004: e = "Not enough memory to perform the system function"; break;
		case 4005: e = "The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes"; break;
		case 4006: e = "Array of a wrong type, wrong size, or a damaged object of a dynamic array"; break;
		case 4007: e = "Not enough memory for the relocation of an array, or an attempt to change the size of a static array"; break;
		case 4008: e = "Not enough memory for the relocation of string"; break;
		case 4009: e = "Not initialized string"; break;
		case 4010: e = "Invalid date and/or time"; break;
		case 4011: e = "Requested array size exceeds 2 GB"; break;
		case 4012: e = "Wrong pointer"; break;
		case 4013: e = "Wrong type of pointer"; break;
		case 4014: e = "System function is not allowed to call"; break;
		case 4015: e = "The names of the dynamic and the static resource match"; break;
		case 4016: e = "Resource with this name has not been found in EX5"; break;
		case 4017: e = "Unsupported resource type or its size exceeds 16 Mb"; break;
		case 4018: e = "The resource name exceeds 63 characters"; break;
		
		//-- Charts
		case 4101: e = "Wrong chart ID"; break;
		case 4102: e = "Chart does not respond"; break;
		case 4103: e = "Chart not found"; break;
		case 4104: e = "No Expert Advisor in the chart that could handle the event"; break;
		case 4105: e = "Chart opening error"; break;
		case 4106: e = "Failed to change chart symbol and period"; break;
		case 4107: e = "Wrong parameter for timer"; break;
		case 4108: e = "Failed to create timer"; break;
		case 4109: e = "Wrong chart property ID"; break;
		case 4110: e = "Error creating screenshots"; break;
		case 4111: e = "Error navigating through chart"; break;
		case 4112: e = "Error applying template"; break;
		case 4113: e = "Subwindow containing the indicator was not found"; break;
		case 4114: e = "Error adding an indicator to chart"; break;
		case 4115: e = "Error deleting an indicator from the chart"; break;
		case 4116: e = "Indicator not found on the specified chart"; break;

		//-- Graphical Objects
		case 4201: e = "Error working with a graphical object"; break;
		case 4202: e = "Graphical object was not found"; break;
		case 4203: e = "Wrong ID of a graphical object property"; break;
		case 4204: e = "Unable to get date corresponding to the value"; break;
		case 4205: e = "Unable to get value corresponding to the date"; break;

		//-- Market Info
		case 4301: e = "Unknown symbol"; break;
		case 4302: e = "Symbol is not selected in MarketWatch"; break;
		case 4303: e = "Wrong identifier of a symbol property"; break;
		case 4304: e = "Time of the last tick is not known (no ticks)"; break;
		case 4305: e = "Error adding or deleting a symbol in MarketWatch"; break;

		//-- History Access
		case 4401: e = "Requested history not found"; break;
		case 4402: e = "Wrong ID of the history property"; break;

		//-- Global Variables
		case 4501: e = "Global variable of the client terminal is not found"; break;
		case 4502: e = "Global variable of the client terminal with the same name already exists"; break;
		case 4510: e = "Email sending failed"; break;
		case 4511: e = "Sound playing failed"; break;
		case 4512: e = "Wrong identifier of the program property"; break;
		case 4513: e = "Wrong identifier of the terminal property"; break;
		case 4514: e = "File sending via ftp failed"; break;
		case 4515: e = "Failed to send a notification"; break;
		case 4516: e = "Invalid parameter for sending a notification - an empty string or NULL has been passed to the SendNotification() function"; break;
		case 4517: e = "Wrong settings of notifications in the terminal (ID is not specified or permission is not set)"; break;
		case 4518: e = "Too frequent sending of notifications"; break;

		//-- Custom Indicator Buffers
		case 4601: e = "Not enough memory for the distribution of indicator buffers"; break;
		case 4602: e = "Wrong indicator buffer index"; break;

		//-- Custom Indicator Properties
		case 4603: e = "Wrong ID of the custom indicator property"; break;

		//-- Account
		case 4701: e = "Wrong account property ID"; break;
		case 4751: e = "Wrong trade property ID"; break;
		case 4752: e = "Trading by Expert Advisors prohibited"; break;
		case 4753: e = "Position not found"; break;
		case 4754: e = "Order not found"; break;
		case 4755: e = "Deal not found"; break;
		case 4756: e = "Trade request sending failed"; break;

		//-- Indicators
		case 4801: e = "Unknown symbol"; break;
		case 4802: e = "Indicator cannot be created"; break;
		case 4803: e = "Not enough memory to add the indicator"; break;
		case 4804: e = "The indicator cannot be applied to another indicator"; break;
		case 4805: e = "Error applying an indicator to chart"; break;
		case 4806: e = "Requested data not found"; break;
		case 4807: e = "Wrong indicator handle"; break;
		case 4808: e = "Wrong number of parameters when creating an indicator"; break;
		case 4809: e = "No parameters when creating an indicator"; break;
		case 4810: e = "The first parameter in the array must be the name of the custom indicator"; break;
		case 4811: e = "Invalid parameter type in the array when creating an indicator"; break;
		case 4812: e = "Wrong index of the requested indicator buffer"; break;

		//-- Depth of Market
		case 4901: e = "Depth Of Market can not be added"; break;
		case 4902: e = "Depth Of Market can not be removed"; break;
		case 4903: e = "The data from Depth Of Market can not be obtained"; break;
		case 4904: e = "Error in subscribing to receive new data from Depth Of Market"; break;

		//-- File Operations
		case 5001: e = "More than 64 files cannot be opened at the same time"; break;
		case 5002: e = "Invalid file name"; break;
		case 5003: e = "Too long file name"; break;
		case 5004: e = "File opening error"; break;
		case 5005: e = "Not enough memory for cache to read"; break;
		case 5006: e = "File deleting error"; break;
		case 5007: e = "A file with this handle was closed, or was not opening at all"; break;
		case 5008: e = "Wrong file handle"; break;
		case 5009: e = "The file must be opened for writing"; break;
		case 5010: e = "The file must be opened for reading"; break;
		case 5011: e = "The file must be opened as a binary one"; break;
		case 5012: e = "The file must be opened as a text"; break;
		case 5013: e = "The file must be opened as a text or CSV"; break;
		case 5014: e = "The file must be opened as CSV"; break;
		case 5015: e = "File reading error"; break;
		case 5016: e = "String size must be specified, because the file is opened as binary"; break;
		case 5017: e = "A text file must be for string arrays, for other arrays - binary"; break;
		case 5018: e = "This is not a file, this is a directory"; break;
		case 5019: e = "File does not exist"; break;
		case 5020: e = "File can not be rewritten"; break;
		case 5021: e = "Wrong directory name"; break;
		case 5022: e = "Directory does not exist"; break;
		case 5023: e = "This is a file, not a directory"; break;
		case 5024: e = "The directory cannot be removed"; break;
		case 5025: e = "Failed to clear the directory (probably one or more files are blocked and removal operation failed)"; break;
		case 5026: e = "Failed to write a resource to a file"; break;

		//-- String Casting
		case 5030: e = "No date in the string"; break;
		case 5031: e = "Wrong date in the string"; break;
		case 5032: e = "Wrong time in the string"; break;
		case 5033: e = "Error converting string to date"; break;
		case 5034: e = "Not enough memory for the string"; break;
		case 5035: e = "The string length is less than expected"; break;
		case 5036: e = "Too large number, more than ULONG_MAX"; break;
		case 5037: e = "Invalid format string"; break;
		case 5038: e = "Amount of format specifiers more than the parameters"; break;
		case 5039: e = "Amount of parameters more than the format specifiers"; break;
		case 5040: e = "Damaged parameter of string type"; break;
		case 5041: e = "Position outside the string"; break;
		case 5042: e = "0 added to the string end, a useless operation"; break;
		case 5043: e = "Unknown data type when converting to a string"; break;
		case 5044: e = "Damaged string object"; break;

		//-- Operations with Arrays
		case 5050: e = "Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only"; break;
		case 5051: e = "The receiving array is declared as AS_SERIES, and it is of insufficient size"; break;
		case 5052: e = "Too small array, the starting position is outside the array"; break;
		case 5053: e = "An array of zero length"; break;
		case 5054: e = "Must be a numeric array"; break;
		case 5055: e = "Must be a one-dimensional array"; break;
		case 5056: e = "Timeseries cannot be used"; break;
		case 5057: e = "Must be an array of type double"; break;
		case 5058: e = "Must be an array of type float"; break;
		case 5059: e = "Must be an array of type long"; break;
		case 5060: e = "Must be an array of type int"; break;
		case 5061: e = "Must be an array of type short"; break;
		case 5062: e = "Must be an array of type char"; break;
		
		//-- Operations with OpenCL
		case 5100: e = "OpenCL functions are not supported on this computer"; break;
		case 5101: e = "Internal error occurred when running OpenCL"; break;
		case 5102: e = "Invalid OpenCL handle"; break;
		case 5103: e = "Error creating the OpenCL context"; break;
		case 5104: e = "Failed to create a run queue in OpenCL"; break;
		case 5105: e = "Error occurred when compiling an OpenCL program"; break;
		case 5106: e = "Too long kernel name (OpenCL kernel)"; break;
		case 5107: e = "Error creating an OpenCL kernel"; break;
		case 5108: e = "Error occurred when setting parameters for the OpenCL kernel"; break;
		case 5109: e = "OpenCL program runtime error"; break;
		case 5110: e = "Invalid size of the OpenCL buffer"; break;
		case 5111: e = "Invalid offset in the OpenCL buffer"; break;
		case 5112: e = "Failed to create an OpenCL buffer"; break;
		
		//-- Operations with WebRequest
		case 5200: e = "Invalid URL"; break;
		case 5201: e = "Failed to connect to specified URL"; break;
		case 5202: e = "Timeout exceeded"; break;
		case 5203: e = "HTTP request failed"; break;

		//-- trading errors
		case 10004: e = "Requote occured"; break;
		case 10006: e = "Order is not accepted by the server"; break;
		case 10007: e = "Request canceled by trader"; break;
		case 10010: e = "Only part of the request was completed"; break;
		case 10011: e = "Request processing error"; break;
		case 10012: e = "Request canceled by timeout"; break;
		case 10013: e = "Invalid request"; break;
		case 10014: e = "Invalid volume"; break;
		case 10015: e = "Invalid price"; break;
		case 10016: e = "Invalid SL or TP"; break;
		case 10017: e = "Trading is disabled"; break;
		case 10018: e = "Market is closed"; break;
		case 10019: e = "Not enough money to trade"; break;
		case 10020: e = "Prices changed"; break;
		case 10021: e = "There are no quotes to process the request"; break;
		case 10022: e = "Invalid expiration date in the order request"; break;
		case 10023: e = "Order state changed"; break;
		case 10024: e = "Too frequent requests"; break;
		case 10025: e = "No changes in request"; break;
		case 10026: e = "Autotrading is disabled by the server"; break;
		case 10027: e = "Autotrading is disabled by the client terminal"; break;
		case 10028: e = "Request locked for processing"; break;
		case 10029: e = "Order or trade frozen"; break;
		case 10030: e = "Invalid order filling type"; break;
		case 10031: e = "No connection with the trade server"; break;
		case 10032: e = "Operation is allowed only for live accounts"; break;
		case 10033: e = "The number of pending orders has reached the limit"; break;
		case 10034: e = "The volume of orders and trades for the symbol has reached the limit"; break;
		case 10035: e = "Incorrect or prohibited order type"; break;
		case 10036: e = "Position with the specified POSITION_IDENTIFIER has already been closed"; break;
		case 10038: e = "A close volume exceeds the current position volume"; break;
		case 10039: e = "A close order already exists for a specified position"; break;
		//-- User-Defined Errors
		case 65536: e = "User defined errors"; break;
		default:	e = "Unknown error";
	}

	StringConcatenate(e, e," (",error_code,")");
	
	return e;
}

void ExpirationDriver()
{
	static ulong last_checked_ticket;
	static ulong db_tickets[];
	static datetime db_expirations[];

	int total    = OrdersTotal();
	int size     = 0;
	int do_reset = false;
	string print;
	int i;

	//-- check expirations and close trades
	size = ArraySize(db_tickets);

	if (size > 0)
	{
		if (total==0)
		{
			ArrayResize(db_tickets, 0);
			ArrayResize(db_expirations, 0);
		}
		else
		{
			for (i = 0; i < size; i++)
			{


				if (!LoadPosition(db_tickets[i])) {continue;}
				if (OrderSymbol() != Symbol()) {continue;}

				if (TimeCurrent() >= db_expirations[i])
				{
					//-- trying to skip conflicts with the same functionality running from neighbour EA


					if (!LoadPosition(db_tickets[i])) {continue;}
					if (OrderCloseTime() > 0) {continue;}

					//-- closing the trade
					if (CloseTrade(OrderTicket())) 
					{
						print = "#" + (string)OrderTicket() + " was closed due to expiration";
						Print(print);
						last_checked_ticket = 0;
						do_reset = true;
						total	 = OrdersTotal();
					}
				}
			}
		}
	}

	//-- check the ticket of the newest trade
	if (do_reset == false && total > 0)
	{
		if (LoadPosition(PositionGetTicket(total-1)))
		{
			if (OrderTicket() != last_checked_ticket)
			{
				do_reset = true;
			}
		}
	}

	//-- rebuild the database of trades with expirations
	if (do_reset == true)
	{
		ArrayResize(db_tickets, 0);
		ArrayResize(db_expirations, 0);

		for (int pos = 0; pos < total; pos++)
		{
			if (!LoadPosition(PositionGetTicket(pos))) {continue;}
			last_checked_ticket = OrderTicket();

			string comment = OrderComment();
			int exp_pos_begin = StringFind(comment, "[exp:");

			if (exp_pos_begin >= 0)
			{
				exp_pos_begin = exp_pos_begin + 5;
				int exp_pos_end = StringFind(comment, "]", exp_pos_begin);
				if (exp_pos_end == -1) {continue;}
				
				size = ArraySize(db_tickets);
				ArrayResize(db_tickets, size+1);
				ArrayResize(db_expirations, size+1);

				db_tickets[size]     = OrderTicket();
				db_expirations[size] = (datetime)((int)OrderOpenTime() + (int)StringToInteger(StringSubstr(comment, exp_pos_begin, exp_pos_end)));
			}
		}
	}
}

datetime ExpirationTime(string mode="GTC",int days=0, int hours=0, int minutes=0, datetime custom=0)
{
	datetime now        = TimeCurrent();
   datetime expiration = now;

	     if (mode == "GTC" || mode == "") {expiration = 0;}
	else if (mode == "today")             {expiration = (datetime)(MathFloor((now + 86400.0) / 86400.0) * 86400.0);}
	else if (mode == "specified")
	{
		expiration = 0;

		if ((days + hours + minutes) > 0)
		{
			expiration = now + (86400 * days) + (3600 * hours) + (60 * minutes);
		}
	}
	else
	{
		if (custom <= now)
		{
			if (custom < 31557600)
			{
				custom = now + custom;
			}
			else
			{
				custom = 0;
			}
		}

		expiration = custom;
	}

	return expiration;
}

ENUM_ORDER_TYPE_TIME ExpirationTypeByTime(string symbol, datetime expiration)
{
	datetime now                   = TimeCurrent();
	ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC;

	// Detect Type Time
	if (expiration == 0 || expiration <= now)
	{
		type_time = ORDER_TIME_GTC;
	}
	else if (expiration == (datetime)(MathFloor((now + 86400.0) / 86400.0) * 86400.0))
	{
		type_time = ORDER_TIME_DAY;
	}
	else
	{
		type_time = ORDER_TIME_SPECIFIED;
	}

	// What if certain Type Time is not allowed?
	if (type_time == ORDER_TIME_GTC && !IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_GTC))
	{
		type_time = ORDER_TIME_DAY;
	}
	
	if (type_time == ORDER_TIME_DAY && !IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_DAY))
	{
		type_time = ORDER_TIME_SPECIFIED;
	}

	// Return Type Time
	return type_time;
}

bool FilterOrderBy(
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both",
	string LimitsOrStops = "",
	int unused           = 0, // for MQL4 compatibility
	bool onTrade         = false
) {
	//-- db
	static string markets[];
	static string market0	= "-";
	static int markets_size = 0;
	
	static string groups[];
	static string group0	  = "-";
	static int groups_size = 0;
	
	//-- local variables
	bool type_pass	  = false;
	bool market_pass = false;
	bool group_pass  = false;

	int i;
	long type;
	ulong magic_number;
	string symbol;
	
	// Trades
	if (onTrade == false)
	{
		type         = OrderType();
		magic_number = OrderMagicNumber();
		symbol       = OrderSymbol();
	}
	else
	{
		type         = e_attrType();
		magic_number = e_attrMagicNumber();
		symbol       = e_attrSymbol();
	}
	
	// Trades && History trades
	if (LimitsOrStops == "")
	{
		if (
				(BuysOrSells == "both"  && (type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL))
			|| (BuysOrSells == "buys"  && type == ORDER_TYPE_BUY)
			|| (BuysOrSells == "sells" && type == ORDER_TYPE_SELL)
			)
		{
			type_pass = true;
		}
	}
	// Pending orders
	else
	{
		if (
				(BuysOrSells == "both" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP))
			||	(BuysOrSells == "buys" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP))
			|| (BuysOrSells == "sells" && (type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP))
			)
		{
			if (
					(LimitsOrStops == "both" && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))
				||	(LimitsOrStops == "stops" && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP))
				|| (LimitsOrStops == "limits" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))	
				)
			{
				type_pass = true;
			}
		}
	}
	if (type_pass == false) {return false;}
	
	//-- check group
	if (group_mode == "group")
	{
		if (group == "")
		{
			if (magic_number == MagicStart)
			{
				group_pass = true;
			}
		}
		else
		{
			if (group0 != group)
			{
				group0 = group;
				StringExplode(",", group, groups);
				groups_size = ArraySize(groups);

				for(i = 0; i < groups_size; i++)
				{
					groups[i] = StringTrim(groups[i]);

					if (groups[i] == "")
					{
						groups[i] = "0";
					}
				}
			}

			for(i = 0; i < groups_size; i++)
			{
				if (magic_number == (MagicStart + (int)groups[i]))
				{
					group_pass = true;

					break;
				}
			}
		}
	}
	else if (group_mode == "all" || (group_mode == "manual" && magic_number == 0))
	{
		group_pass = true;  
	}

	if (group_pass == false) {return false;}
	
	// check market
	if (market_mode == "all")
	{
		market_pass = true;
	}
	else
	{
		if (symbol == market)
		{
			market_pass = true;
		}
		else
		{
			if (market0 != market)
			{
				market0 = market;

				if (market == "")
				{
					markets_size = 1;
					ArrayResize(markets,1);
					markets[0] = Symbol();
				}
				else
				{
					StringExplode(",", market, markets);
					markets_size = ArraySize(markets);

					for(i = 0; i < markets_size; i++)
					{
						markets[i] = StringTrim(markets[i]);

						if (markets[i] == "")
						{
							markets[i] = Symbol();
						}
					}
				}
			}

			for(i = 0; i < markets_size; i++)
			{
				if (symbol == markets[i])
				{
					market_pass = true;

					break;
				}
			}
		}
	}

	if (market_pass == false) {return false;}
 
	return(true);
}

double HighestFromTo(string symbol, ENUM_TIMEFRAMES timeframe, datetime time1, datetime time2, int what_to_get=0)
{
	static datetime HighestTime = 0;
	static double HighestID     = 0.0;

	double retval     = 0.0;
	double HighestVal = 0;

	if (HighestTime == 0) {HighestTime = TimeCurrent();}

	//-- Time mode ---------------------------------------------------------------------
	if (time1 > 1000000)
	{
		double CandleHigh = 0.0;
		int x1            = iBarShift(symbol, timeframe, time1, false);
		int x2            = iBarShift(symbol, timeframe, time2, false);

		if (x1 < x2)
		{
			x1 = iBarShift(symbol, timeframe, (time1 - 86400), false);
		}

		if (x1 < 0 || x2 < 0)
		{
			return -1;
		}

		for (int i = x2; i <= x1; i++)
		{
			CandleHigh = iHigh(symbol, timeframe, i);

			if (CandleHigh > HighestVal)
			{
				HighestVal  = CandleHigh;
				HighestTime = iTime(symbol, timeframe, i);
				HighestID   = i;
			}
		}
	}
	//-- Bars mode ---------------------------------------------------------------------
	else
	{
		int shift = 0;

		if (time1 == time2)
		{
			shift = (int)time1;
		}
		else
		{
			int totalbars = iBars(symbol, timeframe) - 1;

			if (time2 > totalbars || time2 == 0)
			{
				time2 = totalbars;
			}

			shift = iHighest(symbol, timeframe, MODE_HIGH, (int)(time2-time1)+1, (int)time1);
		}

		HighestVal  = iHigh(symbol, timeframe, shift);
		HighestTime = iTime(symbol, timeframe, shift);
		HighestID   = shift;
	}

	retval = HighestVal;

	if (what_to_get == 2)
	{
		retval = (double)HighestTime;
	}
	else if (what_to_get == 0)
	{
		retval = HighestID;
	}

	retval = NormalizeDouble(retval, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));

	return retval;
}

bool HistoryTradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (LoadHistoryTrade(index, "select_by_pos") && LoadedType() == 3)
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells)
		) {
			return true;
		}
	}

	return false;
}

int HistoryTradesTotal(datetime from_date=0, datetime to_date=0)
{
	if (to_date == 0) {to_date = TimeCurrent() + 1;}
	
	HistorySelect(from_date, to_date);
	
	SelectedHistoryFromTime(from_date);
	SelectedHistoryToTime(to_date);
	
	return HistoryDealsTotal();
}

template<typename T>
bool InArray(T &array[], T value)
{
	int size = ArraySize(array);

	if (size > 0)
	{
		for (int i = 0; i < size; i++)
		{
			if (array[i] == value)
			{
				return true;
			}
		}
	}

	return false;
}

//+------------------------------------------------------------------+
//| Checks if the specified expiration mode is allowed               |
//+------------------------------------------------------------------+
bool IsExpirationTypeAllowed(string symbol,int exp_type)
  {
//--- Obtain the value of the property that describes allowed expiration modes
   int expiration=(int)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_MODE);
//--- Return true, if mode exp_type is allowed
   return((expiration&exp_type)==exp_type);
  }

bool IsFillingTypeAllowed(string symbol,int fill_type)
{
//--- Obtain the value of the property that describes allowed filling modes
   int filling=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);
//--- Return true, if mode fill_type is allowed
   return((filling & fill_type)==fill_type);
}

bool IsOrderTypeBuy()
{
	int loadedType = LoadedType();

	if (loadedType == 1)
	{
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			return true;
		}
	}
	else if (loadedType == 3)
	{
		return (OrderType() == ORDER_TYPE_BUY);
	}
	else if (loadedType == 4)
	{
		if (
			HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT
			|| HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_BUY_STOP
		) {
			return true;
		}
	}
	else if (
		OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT
		|| OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP
	) {
		return true;
	}

	return false;
}

bool IsOrderTypeSell()
{
	int loadedType = LoadedType();

	if (loadedType == 1)
	{
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
		{
			return true;
		}
	}
	else if (loadedType == 3)
	{
		return (OrderType() == ORDER_TYPE_SELL);
	}
	else if (loadedType == 4)
	{
		if (
			HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT
			|| HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_SELL_STOP
		) {
			return true;
		}
	}
	else if (
		OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT
		|| OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP
	) {
		return true;
	}

	return false;
}

bool LoadHistoryTrade(int index, string selectby="select_by_pos")
{
	if (selectby == "select_by_pos")
	{
		ulong ticket  = HistoryDealGetTicket(index);

		if (ticket > 0)
		{
			if (
				   //HistoryDealSelect(ticket) - commented, because it breaks HistorySelect()
				   HistoryDealGetInteger(ticket, DEAL_TYPE) < 2
				&& (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT
				)
			{
				OrderTicket(ticket);

				LoadedType(3);

				return true;
			}
		}
	}

	if (selectby == "select_by_ticket")
	{
		if (HistoryDealSelect(index))
		{
			OrderTicket(index);

			if (HistoryDealGetInteger(index, DEAL_TYPE) < 2)
			{
				LoadedType(3);

				return true;
			}
		}
	}

	return false;
}

bool LoadOrder(string symbol)
{
	// THIS FUNCTION NOW PROBABLY DOESNT WORK
   bool success = PositionSelect(symbol);
	
   if (success) {
		LoadedType(1);
		OrderTicket((long)PositionGetInteger(POSITION_IDENTIFIER));
	}
	
   return success;
}
bool LoadOrder(ulong ticket)
{
   bool success = OrderSelect(ticket);
	
   if (success) {
		LoadedType(2);
		OrderTicket(ticket);
	}
	
   return success;
}

bool LoadPosition(ulong ticket)
{
   bool success = PositionSelectByTicket(ticket);
	
   if (success) {
		LoadedType(1);
		OrderTicket(ticket);
	}
	
   return success;
}

int LoadedType(int type=0)
{
	// 1 - position
	// 2 - pending order
	// 3 - history position
	// 4 - history pending order

	static int memory;

	if (type > 0) {memory = type;}

	return memory;
}

double LowestFromTo(string symbol, ENUM_TIMEFRAMES timeframe, datetime time1, datetime time2, int what_to_get=0)
{
	static datetime LowestTime = 0;
	static double LowestID     = 0.0;

	double retval    = 0.0;
	double LowestVal = 0.0;

	if (LowestTime == 0) {LowestTime = TimeCurrent();}

	//-- Time mode ---------------------------------------------------------------------
	if (time1 > 1000000)
	{
		double CandleLow = 0.0;
		int x1           = iBarShift(symbol, timeframe, time1, false);
		int x2           = iBarShift(symbol, timeframe, time2, false);

		if (x1 < x2)
		{
			x1 = iBarShift(symbol, timeframe, (time1 - 86400), false);
		}

		if (x1 < 0 || x2 < 0)
		{
			return -1;
		}

		for (int i = x2; i <= x1; i++)
		{
			CandleLow = iLow(symbol, timeframe, i);

			if (CandleLow < LowestVal || LowestVal == 0)
			{
				LowestVal  = CandleLow;
				LowestTime = iTime(symbol, timeframe, i);
				LowestID   = i;
			}
		}
	}
	//-- Bars mode ---------------------------------------------------------------------
	else
	{
		int shift = 0;

		if (time1 == time2)
		{
			shift = (int)time1;
		}
		else
		{
			int totalbars = iBars(symbol, timeframe) - 1;

			if (time2 > totalbars || time2 == 0)
			{
				time2 = totalbars;
			}

			shift = iLowest(symbol, timeframe, MODE_LOW, (int)((time2-time1)+1), (int)time1);
		}

		LowestVal  = iLow(symbol, timeframe, shift);
		LowestTime = iTime(symbol, timeframe, shift);
		LowestID   = shift;
	}

	retval = LowestVal;

	if (what_to_get == 2)
	{
		retval = (double)LowestTime;
	}
	else if (what_to_get == 0)
	{
		retval = LowestID;
	}
	
	retval = NormalizeDouble(retval, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));

	return retval;
}

bool ModifyOrder(
	ulong ticket,
	double op,
	double sll = 0,
	double tpl = 0,
	double slp = 0,
	double tpp = 0,
	datetime exp = 0,
	color clr = clrNONE
) {
	int bs = 1;

	if (LoadedType() == 1)
	{
		if (OrderType() == POSITION_TYPE_SELL)
		{bs = -1;} // Positive when Buy, negative when Sell
	}
	else
	{
		if (
				OrderType() == ORDER_TYPE_SELL
			|| OrderType() == ORDER_TYPE_SELL_STOP
			|| OrderType() == ORDER_TYPE_SELL_LIMIT
		)
		{bs = -1;} // Positive when Buy, negative when Sell
	}

	while (true)
	{
		uint time0 = GetTickCount();
		
		if (LoadedType() == 1)
		{
			if (!PositionSelectByTicket(ticket)) {return false;}
		}
		else
		{
			if (!OrderSelect(ticket)) {return false;}
		}

		string symbol      = OrderSymbol();
		int type           = OrderType();
		int digits         = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
		double ask         = SymbolInfoDouble(symbol,SYMBOL_ASK);
		double bid         = SymbolInfoDouble(symbol,SYMBOL_BID);
		double point       = SymbolInfoDouble(symbol,SYMBOL_POINT);
		double stoplevel   = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
		double freezelevel = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (OrderType() < 2) {op = OrderOpenPrice();} else {op = NormalizeDouble(op,digits);}
		
		sll = NormalizeDouble(sll,digits);
		tpl = NormalizeDouble(tpl,digits);

		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)
		{
			break;
		}

		//-- OP -----------------------------------------------------------
		// https://book.mql4.com/appendix/limits
		if (type == ORDER_TYPE_BUY_LIMIT)
		{
			if (ask - op < stoplevel) {op = ask - stoplevel;}
			if (ask - op <= freezelevel) {op = ask - freezelevel - point;}
		}
		else if (type == ORDER_TYPE_BUY_STOP)
		{
			if (op - ask < stoplevel) {op = ask + stoplevel;}
			if (op - ask <= freezelevel) {op = ask + freezelevel + point;}
		}
		else if (type == ORDER_TYPE_SELL_LIMIT)
		{
			if (op - bid < stoplevel) {op = bid + stoplevel;}
			if (op - bid <= freezelevel) {op = bid + freezelevel + point;}
		}
		else if (type == ORDER_TYPE_SELL_STOP)
		{
			if (bid - op < stoplevel) {op = bid - stoplevel;}
			if (bid - op < freezelevel) {op = bid - freezelevel - point;}
		}

		op = NormalizeDouble(op, digits);

		//-- SL and TP ----------------------------------------------------
		double sl = 0, tp = 0, vsl = 0, vtp = 0;

		sl = AlignStopLoss(symbol, type, op, attrStopLoss(), sll, slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol, type, op, attrTakeProfit(), tpl, tpp);

		if (tp < 0) {break;}

		if (USE_VIRTUAL_STOPS)
		{
			//-- virtual SL and TP --------------------------------------------
			vsl = sl;
			vtp = tp;
			sl  = 0;
			tp  = 0;

			double askbid = ask;

			if (bs < 0) {askbid = bid;}

			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					sl = vsl - EMERGENCY_STOPS_REL*MathAbs(askbid-vsl)*bs;

					if (sl <= 0) {sl = askbid;}
					sl = sl-toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;
				}
			}

			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL>0 || EMERGENCY_STOPS_ADD>0)
				{
					tp=vtp+EMERGENCY_STOPS_REL*MathAbs(vtp-askbid)*bs;

					if (tp <= 0) {tp = askbid;}

					tp = tp + toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;
				}
			}

			vsl = NormalizeDouble(vsl,digits);
			vtp = NormalizeDouble(vtp,digits);
		}

		sl = NormalizeDouble(sl,digits);
		tp = NormalizeDouble(tp,digits);

		//-- modify -------------------------------------------------------
		ResetLastError();
		
		if (USE_VIRTUAL_STOPS)
		{
			if (vsl != attrStopLoss() || vtp != attrTakeProfit())
			{
				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));
			}
		}
		
		bool success = false;
		
		// check if needed to modify
		if (LoadedType() == 1)
		{
			if (
				   sl == NormalizeDouble(PositionGetDouble(POSITION_SL),digits)
				&& tp == NormalizeDouble(PositionGetDouble(POSITION_TP),digits)
			) {
				return true;
			}
		}
		else
		{
			if (
				   op == NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),digits)
				&& sl == NormalizeDouble(OrderGetDouble(ORDER_SL),digits)
				&& tp == NormalizeDouble(OrderGetDouble(ORDER_TP),digits)
				&& exp == OrderGetInteger(ORDER_TIME_EXPIRATION)
			) {
				return true;
			}
		}

		// prepare to modify
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		// modify
		if (LoadedType() == 1)
		{
			// in case of position, only sl and tp are going to be modified
			request.action   = TRADE_ACTION_SLTP;
			request.symbol   = symbol;
			request.position = PositionGetInteger(POSITION_TICKET);
			request.magic    = PositionGetInteger(POSITION_MAGIC);
			request.comment  = PositionGetString(POSITION_COMMENT);
		}
		else
		{
			// in case of pending order
			request.action     = TRADE_ACTION_MODIFY;
			request.order      = ticket;
			request.price      = op;
			request.volume     = OrderGetDouble(ORDER_VOLUME_CURRENT);
			request.magic      = OrderGetInteger(ORDER_MAGIC);
			request.type_time  = ExpirationTypeByTime(symbol, exp);
			request.expiration = exp;
			request.comment    = OrderGetString(ORDER_COMMENT);

			//-- filling type
			uint filling = (uint)SymbolInfoInteger(request.symbol,SYMBOL_FILLING_MODE);

			if (filling == SYMBOL_FILLING_FOK)
			{
				request.type_filling = ORDER_FILLING_FOK;
			}
			else if (filling == SYMBOL_FILLING_IOC)
			{
				request.type_filling = ORDER_FILLING_IOC;
			}
		}
		
		request.sl = sl;
		request.tp = tp;

		if (!OrderCheck(request,check_result))
		{
			Print("OrderCheck() failed: " + (string)check_result.comment + " (" + (string)check_result.retcode + ")");

			return false;
		}

		success = OrderSend(request, result);

		//-- error check --------------------------------------------------
		if (result.retcode != TRADE_RETCODE_DONE)
		{
			string errmsgpfx = "Modify error";
			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return false;
		}

		//-- finish work --------------------------------------------------
		if (result.retcode == TRADE_RETCODE_DONE)
		{
			//== Wait until MT5 updates its cache
			int w;

			for (w = 0; w < 5000; w++)
			{
				if (((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)) && (sl == NormalizeDouble(OrderStopLoss(), digits) && tp == NormalizeDouble(OrderTakeProfit(), digits)))
				{
					break;
				}

				Sleep(1);
			}

			if (w == 5000)
			{
				Print("Check error: Modify order stops");  
			}

			if (!((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)) || (sl != NormalizeDouble(OrderStopLoss(), digits) || tp != NormalizeDouble(OrderTakeProfit(), digits)))
			{
				Print("Something went wrong when trying to modify the stops");

				return false;
			}

			if (!(((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket))))
			{
				return false;
			}

			OrderModified((int)ticket);
		}

		break;
	}

	OnTrade();

	return true;
}

int OCODriver()
{
   static ulong last_known_ticket = 0;
   static ulong orders1[];
   static ulong orders2[];
   int i, size;
   
   int total = OrdersTotal();
   
   for (int pos=total-1; pos>=0; pos--)
   {
      if (LoadOrder(OrderGetTicket(pos)))
      {
         ulong ticket = OrderTicket();
         
         //-- end here if we reach the last known ticket
         if (ticket == last_known_ticket) {break;}
         
         //-- set the last known ticket, only if this is the first iteration
         if (pos == total-1) {
            last_known_ticket = ticket;
         }
         
         //-- we are searching for pending orders, skip trades
         if (OrderType() <= ORDER_TYPE_SELL) {continue;}
         
         //--
         if (StringSubstr(OrderComment(), 0, 5) == "[oco:")
         {
            int ticket_oco = StrToInteger(StringSubstr(OrderComment(), 5, StringLen(OrderComment())-1)); 
            
            bool found = false;
            size = ArraySize(orders2);
            for (i=0; i<size; i++)
            {
               if (orders2[i] == ticket_oco) {
                  found = true;
                  break;
               }
            }
            
            if (found == false) {
               ArrayResize(orders1, size+1);
               ArrayResize(orders2, size+1);
               orders1[size] = ticket_oco;
               orders2[size] = ticket;
            }
         }
      }
   }
   
   size = ArraySize(orders1);
   int dbremove = false;
   for (i=size-1; i>=0; i--)
   {
      if (LoadOrder(orders1[i]) == false || OrderType() <= ORDER_TYPE_SELL)
      {
         if (LoadOrder(orders2[i])) {
            if (DeleteOrder(orders2[i]))
            {
               dbremove = true;
            }
         }
         else {
            dbremove = true;
         }
         
         if (dbremove == true)
         {
            ArrayStripKey(orders1, i);
            ArrayStripKey(orders2, i);
         }
      }
   }
   
   size = ArraySize(orders2);
   dbremove = false;
   for (i=size-1; i>=0; i--)
   {
      if (LoadOrder(orders2[i]) == false || OrderType() <= ORDER_TYPE_SELL)
      {
         if (LoadOrder(orders1[i])) {
            if (DeleteOrder(orders1[i]))
            {
               dbremove = true;
            }
         }
         else {
            dbremove = true;
         }
         
         if (dbremove == true)
         {
            ArrayStripKey(orders1, i);
            ArrayStripKey(orders2, i);
         }
      }
   }
   
   return true;
}

bool OnTimerSet(double seconds)
{
   if (seconds<=0) {
      EventKillTimer();
   }
   else if (seconds < 1) {
      return (EventSetMillisecondTimer((int)(seconds*1000)));  
   }
   else {
      return (EventSetTimer((int)seconds));
   }
   
   return true;
}

bool OnTradeDetector() {

	static int lastOrdersTotal    = -1;    // Number of orders at the time of previous OnTrade() call
	static int lastPositionsTotal = -1; // Number of positions at the time of previous OnTrade() call

	int i          = 0;
	ulong ticket   = 0;
	int last_error = 0;
	long state     = 0;
	bool event     = false;
	int positions_count = BuildPositionsList(EGV_PositionsList);
	int orders_count    = BuildOrdersList(EGV_OrderList);
	int orders_total    = OrdersTotal();
	int positions_total = PositionsTotal();
	bool debug = false;
	
	// initial values for the static variables
	if (lastOrdersTotal == -1) {lastOrdersTotal = orders_total;}
	if (lastPositionsTotal == -1) {lastPositionsTotal = positions_total;}

	HistorySelect(0, TimeCurrent()+1);

	//== Pending order created?
	if (lastOrdersTotal < orders_total)
	{
		// Select the last order
		ticket = OrderGetTicket(orders_total-1);

		bool success = OrderSelect(ticket);

		if (
				OrderSelect(ticket)
			&& OrderGetInteger(ORDER_TYPE) > 1
			&& OrderGetInteger(ORDER_STATE) == ORDER_STATE_PLACED
		) {
			// Event: New pending order created
			if (debug) Print("Pending order type ",(int)OrderGetInteger(ORDER_TYPE)," #", ticket," accepted!");
			UpdateEventValues(EGV_OrderList[orders_total-1],"new","");
			event = true;
		}
	}
	//== Pending order gone?
	else if (lastOrdersTotal > orders_total)
	{
		// Select the order that is missing in the new list
		int size  = ArraySize(EGV_OrderList);
		int size0 = ArraySize(EGV_OrderList0);

		for (i = size0 - 1; i >= 0; i--)
		{
			bool found = false;
			ticket     = EGV_OrderList0[i].ticket;

			for (int j = size-1; j >= 0; j--)
			{
				if (ticket == EGV_OrderList[j].ticket)
				{
					found = true;

					break;
				}
			}

			if (found == false)
			{
				break;
			}
		}

		if (i < 0) {i = 0;}

		// Now load that order
		HistoryOrderSelect(ticket);
		state = HistoryOrderGetInteger(ticket, ORDER_STATE);
		
		// sometimes we land here even when a trade is closed,
		// so we want to check whether the selected order is a pending order
		long type = HistoryOrderGetInteger(ticket, ORDER_TYPE);

		if (type > 1)
		{
			if (state == 0 && GetLastError() == ERR_TRADE_ORDER_NOT_FOUND)
			{
				state = 2;
			}

			//Print("Last order ticket = ",ticket, "| state = ",state, "| GetLastError= ",GetLastError());

			// If order is not found, generate an error
			ResetLastError();
			last_error = GetLastError();

			if (last_error > 0)
			{
				if (debug) Print("Error #",last_error," Order ",ticket," was not found!");
			}

			ResetLastError();

			if (state == ORDER_STATE_CANCELED)
			{
				if (debug) Print("Order #", ticket, " has been cancelled.");
				UpdateEventValues(EGV_OrderList0[i], "close", "");
				event = true;
			}
			else if (state == ORDER_STATE_EXPIRED)
			{
				if (debug) Print("Order #", ticket, " expired.");
				UpdateEventValues(EGV_OrderList0[i], "close", "expire");
				event = true;
			}
			else
			// If order is fully executed, analyze the last deal
			if (state == ORDER_STATE_FILLED)
			{
				ulong deal_ticket = HistoryDealGetTicket(HistoryDealsTotal()-1);
				long deal_type    = HistoryDealGetInteger(deal_ticket, DEAL_TYPE); // 0 - BUY, 1 - SELL
				string text       = "";

				switch((int)HistoryDealGetInteger(deal_ticket, DEAL_ENTRY))
				{
					// Entering the market
					case DEAL_ENTRY_IN:

							  if (deal_type == DEAL_TYPE_BUY) {text = "Buy";}
						else if (deal_type == DEAL_TYPE_SELL) {text = "Sell";}

						if (debug) Print(" Order #",HistoryDealGetInteger(deal_ticket, DEAL_ORDER), " invoked deal #", deal_ticket);

						if (PositionSelect(HistoryDealGetString(deal_ticket, DEAL_SYMBOL)))
						{ 
							// Position has just been opened
							if (PositionGetDouble(POSITION_VOLUME) == HistoryDealGetDouble(deal_ticket, DEAL_VOLUME))
							{
								if (debug) Print(text, " position has been opened on pair ", HistoryDealGetString(deal_ticket, DEAL_SYMBOL));
								UpdateEventValues(deal_ticket, "new", "fromorder");
								event = true;
							}
							// Position has been incremented
							else if (PositionGetDouble(POSITION_VOLUME) > HistoryDealGetDouble(deal_ticket,DEAL_VOLUME))
							{
								if (debug) Print(text, " position has incremented on pair ", HistoryDealGetString(deal_ticket, DEAL_SYMBOL));
								UpdateEventValues(deal_ticket, "increment", "fromorder");
								event = true;
							}
							// Position has been decremented
							else if (PositionGetDouble(POSITION_VOLUME) < HistoryDealGetDouble(deal_ticket,DEAL_VOLUME))
							{
								if (debug) Print(text, " position has decremented on pair ", HistoryDealGetString(deal_ticket, DEAL_SYMBOL));
								UpdateEventValues(deal_ticket, "decrement", "fromorder");
								event = true;
							}
						}
					break;

					// Exiting the market
					case DEAL_ENTRY_OUT:

							  if (deal_type == DEAL_TYPE_BUY) {text = "Sell";}
						else if (deal_type == DEAL_TYPE_SELL) {text = "Buy";}

						if (debug) Print(HistoryDealGetInteger(deal_ticket, DEAL_ORDER)," order invoked deal #",deal_ticket);

						// If position, we tried to close, is still present, then we have closed only part of it
						if (PositionSelect(HistoryDealGetString(deal_ticket, DEAL_SYMBOL)) == true)
						{
							if (debug) Print("Part of ",text," position has been closed on pair ",HistoryDealGetString(deal_ticket, DEAL_SYMBOL)," with profit = ",HistoryDealGetDouble(deal_ticket, DEAL_PROFIT));
							UpdateEventValues(deal_ticket,"closepart","fromorder");
							event = true;
						}
						else
						// If position is not found, then it is fully closed
						{
							if (debug) Print(text," position has been closed on pair ",HistoryDealGetString(deal_ticket, DEAL_SYMBOL)," with profit = ",HistoryDealGetDouble(deal_ticket, DEAL_PROFIT));
							UpdateEventValues(deal_ticket,"close","fromorder");
							event = true;
						}
					break;

					// Reverse
					case DEAL_ENTRY_INOUT:

						if (debug) Print(HistoryDealGetInteger(deal_ticket, DEAL_ORDER)," order invoked deal #",deal_ticket);

						switch((int)deal_type)
						{
							case 0:
								if (debug) Print("Sell is reversed to Buy on pair ", HistoryDealGetString(deal_ticket, DEAL_SYMBOL), " resulting profit = ", HistoryDealGetDouble(deal_ticket, DEAL_PROFIT)); 
							break;

							case 1:
								if (debug) Print("Buy is reversed to Sell on pair ", HistoryDealGetString(deal_ticket, DEAL_SYMBOL), " resulting profit = ", HistoryDealGetDouble(deal_ticket, DEAL_PROFIT)); 
							break;

							default:
								if (debug) Print("Unprocessed code of type: ", deal_type);
							break;
						}

						UpdateEventValues(deal_ticket, "reverse", "fromorder");
						event = true;
					break;

					// Indicates the state record
					case DEAL_ENTRY_STATE:
						//Print("Unprocessed code of direction: ",HistoryDealGetInteger(deal_ticket,DEAL_TYPE));
					break;
				}
			}
		}
	}

	//== New position created?
	if (lastPositionsTotal < positions_total)
	{
		ulong deal_ticket = HistoryDealGetTicket(HistoryDealsTotal()-1);
		// New position opened
		UpdateEventValues(deal_ticket,"new","");
		event = true;
	}
	//== Position gone?
	else if (lastPositionsTotal > positions_total)
	{
		ulong deal_ticket = HistoryDealGetTicket(HistoryDealsTotal()-1);
		// Position closed
		string e_detail = "";

		if (StringFind(HistoryDealGetString(HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID), DEAL_COMMENT), "[exp:") >= 0)
		{
			e_detail = "expire";
		}

		UpdateEventValues(deal_ticket,"close",e_detail);
		
		// TODO: I commented out the row below because it gives 'array out of tange" in this example: https://fxdreema.com/builder/shared/dgyi9EqR
		//e_attrMagicNumber(true, EGV_PositionsList0[i].magic); // for some reason magic number can be get only once in the normal way
		event = true;
	}

	if ((lastPositionsTotal == positions_total) && (lastOrdersTotal == orders_total))
	{  
		for (i=0; i<positions_count; i++)
		{
			// Position reverse
			if (EGV_PositionsList0[i].type != EGV_PositionsList[i].type)
			{
				Print(EGV_PositionsList[i].symbol+" volume reversed from "+ (string)EGV_PositionsList0[i].type +" to "+ (string)EGV_PositionsList[i].type);
				UpdateEventValues(EGV_PositionsList[i],"reverse","");
				event = true;
			}

			// Position modified SL and/or TP
			if ((EGV_PositionsList0[i].sl != EGV_PositionsList[i].sl) && (EGV_PositionsList0[i].tp != EGV_PositionsList[i].tp))
			{
				if (debug) Print(EGV_PositionsList[i].symbol+" Stop Loss changed from "+ (string)EGV_PositionsList0[i].sl +" to "+ (string)EGV_PositionsList[i].sl);
				if (debug) Print(EGV_PositionsList[i].symbol+" Take Profit changed from "+ (string)EGV_PositionsList0[i].tp +" to "+ (string)EGV_PositionsList[i].tp);
				UpdateEventValues(EGV_PositionsList[i],"modify","sltp");
				event = true;
			}
			else
			{
				if (EGV_PositionsList0[i].sl != EGV_PositionsList[i].sl)
				{
					if (debug) Print(EGV_PositionsList[i].symbol+" Stop Loss changed from "+ (string)EGV_PositionsList0[i].sl +" to "+ (string)EGV_PositionsList[i].sl);
					UpdateEventValues(EGV_PositionsList[i],"modify","sl");
					event = true;
				}

				if (EGV_PositionsList0[i].tp != EGV_PositionsList[i].tp)
				{
					if (debug) Print(EGV_PositionsList[i].symbol+" Take Profit changed from "+ (string)EGV_PositionsList0[i].tp +" to "+ (string)EGV_PositionsList[i].tp);
					UpdateEventValues(EGV_PositionsList[i],"modify","tp");
					event = true;
				}
			}

			// Check position increment/decrement
			if (EGV_PositionsList0[i].volume < EGV_PositionsList[i].volume)
			{
				if (debug) Print(EGV_PositionsList[i].symbol+" volume incremented from "+ (string)EGV_PositionsList0[i].volume +" to "+ (string)EGV_PositionsList[i].volume);
				UpdateEventValues(EGV_PositionsList[i],"increment","");
				event = true;
			}
			else if (EGV_PositionsList0[i].volume > EGV_PositionsList[i].volume)
			{
				if (debug) Print(EGV_PositionsList[i].symbol+" volume decremented from "+ (string)EGV_PositionsList0[i].volume +" to "+ (string)EGV_PositionsList[i].volume);
				UpdateEventValues(EGV_PositionsList[i],"decrement","");
				event = true;
			}
		}

		for (i = 0; i < orders_count; i++)
		{
			if (EGV_OrderList0[i].price_open != EGV_OrderList[i].price_open)
			{
				if (debug) Print("Order "+(string)EGV_OrderList[i].ticket+" has changed Open Price from "+ (string)EGV_OrderList0[i].price_open +" to "+ (string)EGV_OrderList[i].price_open);
				UpdateEventValues(EGV_OrderList[i],"modify","move");
				event = true;
			}
			else if ((EGV_OrderList0[i].sl != EGV_OrderList[i].sl) && (EGV_OrderList0[i].tp != EGV_OrderList[i].tp))
			{
				if (debug) Print("Order "+(string)EGV_OrderList[i].ticket+" has changed Stop Loss from "+ (string)EGV_OrderList0[i].sl +" to "+ (string)EGV_OrderList[i].sl);
				if (debug) Print("Order "+(string)EGV_OrderList[i].ticket+" has changed Take Profit from "+ (string)EGV_OrderList0[i].tp +" to "+ (string)EGV_OrderList[i].tp);
				UpdateEventValues(EGV_OrderList[i],"modify","sltp");
				event = true;
			}
			else
			{
				if (EGV_OrderList0[i].sl != EGV_OrderList[i].sl)
				{
					if (debug) Print("Order "+(string)EGV_OrderList[i].ticket+" has changed Stop Loss from "+ (string)EGV_OrderList0[i].sl +" to "+ (string)EGV_OrderList[i].sl);
					UpdateEventValues(EGV_OrderList[i],"modify","sl");
					event = true;
				}

				if (EGV_OrderList0[i].tp != EGV_OrderList[i].tp)
				{
					if (debug) Print("Order "+(string)EGV_OrderList[i].ticket+" has changed Take Profit from "+ (string)EGV_OrderList0[i].tp +" to "+ (string)EGV_OrderList[i].tp);
					UpdateEventValues(EGV_OrderList[i],"modify","tp");
					event = true;
				}
			}

			if (EGV_OrderList0[i].time_expiration != EGV_OrderList[i].time_expiration)
			{
				if (debug) Print("Order "+(string)EGV_OrderList[i].time_expiration+" has changed Expiration from "+ (string)EGV_OrderList0[i].time_expiration +" to "+ (string)EGV_OrderList[i].time_expiration);
				UpdateEventValues(EGV_OrderList[i],"modify","expiration");
				event = true;
			}
		}
	}

	BuildPositionsList(EGV_PositionsList0);
	BuildOrdersList(EGV_OrderList0);
	lastOrdersTotal    = orders_total;
	lastPositionsTotal = PositionsTotal();

	return event;
}

int OnTradeQueue(int queue=0)
{
	static int mem=0;
   mem=mem+queue;
   return(mem);
}

double OrderClosePrice()
{
	int type = LoadedType();

	if (type == 1)
	{
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			return SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID);
		}
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
		{
			return SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);
		}
	}
	if (type == 3) {return HistoryDealGetDouble(OrderTicket(), DEAL_PRICE);}
	if (type == 4) {return HistoryDealGetDouble(OrderTicket(), DEAL_PRICE);}

	return(OrderGetDouble(ORDER_PRICE_CURRENT));
}

datetime OrderCloseTime()
{
	int type = LoadedType();

	if (type == 1)
	{
		return 0;
	}

	if (type == 3)
	{
		return (datetime)HistoryDealGetInteger(OrderTicket(),DEAL_TIME);
	}

	if (type == 4)
	{
		return (datetime)HistoryOrderGetInteger(OrderTicket(),ORDER_TIME_DONE);
	}
	
	return (datetime)OrderGetInteger(ORDER_TIME_DONE);
}

string OrderComment()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetString(POSITION_COMMENT);}
	if (type == 3) {return HistoryOrderGetString(HistoryDealGetInteger(OrderTicket(), DEAL_POSITION_ID), ORDER_COMMENT);}
	if (type == 4) {return HistoryOrderGetString(OrderTicket(), ORDER_COMMENT);}

	return OrderGetString(ORDER_COMMENT);
}

double OrderCommission()
{
	int type = LoadedType();

	if (type == 1){return PositionGetDouble(POSITION_COMMISSION);}
	if (type == 3){return HistoryDealGetDouble(OrderTicket(),DEAL_COMMISSION);}
	if (type == 4){return 0;}

	return 0;
}

long OrderCreate(
	string   symbol     = "",
	int      type       = ORDER_TYPE_BUY,
	double   lots       = 0,
	double   op         = 0,
	double   sll        = 0,
	double   tpl        = 0,
	double   slp        = 0,
	double   tpp        = 0,
	double   slippage   = 0,
	ulong    magic      = 0,
	string   comment    = NULL,
	color    arrowcolor = clrNONE,
	datetime expiration = 0,
	bool     oco        = false
	)
{
	OnTrade(); // When position is closed by sl or tp, this event is not fired (by MetaTrader) until the end of the tick, and if a new position is opened, it will be missed. 

	uint time0 = GetTickCount(); // used to measure speed of execution of the order

	bool closing = false;
	double lots0 = 0;
	long type0   = type;

	if (
		   (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
		&& (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
		)
	{
		if (PositionSelect(symbol))
		{
			if ((int)PositionGetInteger(POSITION_TYPE) != type)
			{
				closing = true;
			}

			lots0 = NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5);
			type0 = PositionGetInteger(POSITION_TYPE);
		}
	}

	ulong ticket = -1;

	// calculate buy/sell flag (1 when Buy or -1 when Sell)
	int bs = 1;

	if (
		   type == ORDER_TYPE_SELL
		|| type == ORDER_TYPE_SELL_STOP
		|| type == ORDER_TYPE_SELL_LIMIT
	)
	{
		bs = -1;
	}

	if (symbol == "") {symbol = Symbol();}

	lots = AlignLots(symbol, lots);

	int digits = 0;
	double ask = 0, bid = 0, point = 0, ticksize = 0;
	double sl = 0, tp = 0;
	double vsl = 0, vtp = 0;
	bool successed = false;

	//-- attempts to send position/order ---------------------------------
	while (true)
	{
		digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
		ask      = SymbolInfoDouble(symbol, SYMBOL_ASK);
		bid      = SymbolInfoDouble(symbol, SYMBOL_BID);
		point    = SymbolInfoDouble(symbol, SYMBOL_POINT);
		ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);

		//- not enough money check: fix maximum possible lot by margin required, or quit
		if ((type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL) && closing == false)
		{
			double LotStep         = SymbolLotStep(symbol);
			double MinLots         = SymbolMinLot(symbol);
			double margin_required = 0;
			bool ocm               = OrderCalcMargin((ENUM_ORDER_TYPE)type, symbol, 1, SymbolInfoDouble(symbol, SYMBOL_ASK), margin_required);
			static bool not_enough_message = false;

			if (margin_required != 0)
			{
				double max_size_by_margin = AccountFreeMargin() / margin_required;
			
				if (lots > max_size_by_margin)
				{
					double lots_old = lots;
					lots = max_size_by_margin;

					if (lots < MinLots)
					{
						if (not_enough_message == false)
						{
							Print("Not enough money to trade :( The robot is still working, waiting for some funds to appear...");
						}

						not_enough_message = true;

						return -1;
					}
					else
					{
						lots = MathFloor(lots / LotStep) * LotStep;
						Print("Not enough money to trade " + DoubleToString(lots_old, 2) + ", the volume to trade will be the maximum possible of " + DoubleToString(lots, 2));
					}
				}
			}

			not_enough_message = false;
		}

		// fix the comment, because it seems that the comment is deleted if its lenght is > 31 symbols
		if (StringLen(comment) > 31)
		{
			comment = StringSubstr(comment, 0, 31);
		}

		//- expiration for trades
		if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
		{
			if (expiration > 0)
			{
				//- convert UNIX to seconds
				if (expiration > TimeCurrent()-100)
				{
					expiration = expiration - TimeCurrent();
				}
				
				//- bo broker?
				if (
					   StringLen(symbol) > 6
					&& StringSubstr(symbol, StringLen(symbol) - 2) == "bo"
				) {
					comment = "BO exp:" + (string)expiration;
				}
				else
				{
					string expiration_str = "[exp:" + IntegerToString(expiration) + "]";
					int expiration_len    = StringLen(expiration_str);
					int comment_len       = StringLen(comment);

					if (comment_len > (27 - expiration_len))
					{
						comment = StringSubstr(comment, 0, (27 - expiration_len));
					}

					comment = comment + expiration_str;
				}
			}
		}

		if (type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL)
		{
			op = (bs > 0) ? ask : bid;
		}

		op  = NormalizeDouble(op, digits);
		sll = NormalizeDouble(sll, digits);
		tpl = NormalizeDouble(tpl, digits);

		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)
		{
			break;
		}

		//-- SL and TP ----------------------------------------------------
		vsl = 0;
		vtp = 0;

		sl = AlignStopLoss(symbol, type, op, 0, NormalizeDouble(sll,digits), slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol, type, op, 0, NormalizeDouble(tpl,digits), tpp);

		if (tp < 0) {break;}

		if (USE_VIRTUAL_STOPS)
		{
			//-- virtual SL and TP --------------------------------------------
			vsl = sl;
			vtp = tp;
			sl = 0;
			tp = 0;
			
			double askbid = (bs > 0) ? ask : bid;
			
			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					sl = vsl - EMERGENCY_STOPS_REL * MathAbs(askbid - vsl) * bs;

					if (sl <= 0) {sl = askbid;}

					sl = sl - toDigits(EMERGENCY_STOPS_ADD, symbol) * bs;
				}
			}

			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					tp = vtp + EMERGENCY_STOPS_REL * MathAbs(vtp - askbid) * bs;

					if (tp <= 0) {tp = askbid;}

					tp = tp + toDigits(EMERGENCY_STOPS_ADD, symbol) * bs;
				}
			}

			vsl = NormalizeDouble(vsl, digits);
			vtp = NormalizeDouble(vtp, digits);
		}

		sl = NormalizeDouble(sl, digits);
		tp = NormalizeDouble(tp, digits);

		//-- send ---------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		ENUM_SYMBOL_TRADE_EXECUTION exec = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol,SYMBOL_TRADE_EXEMODE);

		//-- fix prices by ticksize
		op = MathRound(op / ticksize) * ticksize;
		sl = MathRound(sl / ticksize) * ticksize;
		tp = MathRound(tp / ticksize) * ticksize;

		request.symbol     = symbol;
		request.type       = (ENUM_ORDER_TYPE)type;
		request.volume     = lots;
		request.price      = op;
		request.deviation  = (ulong)(slippage * PipValue(symbol));
		request.sl         = sl;
		request.tp         = tp;
		request.comment    = comment;
		request.magic      = magic;
		request.type_time  = ExpirationTypeByTime(symbol, expiration);
		request.expiration = expiration;

		//-- request action
		if (type > ORDER_TYPE_SELL)
		{
			request.action = TRADE_ACTION_PENDING;
		}
		else
		{
			request.action = TRADE_ACTION_DEAL;
		}
		//-- filling type
		
		// check ORDER_FILLING_RETURN for pending orders only 
		if (type > ORDER_TYPE_SELL)
		{
			if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN))
				request.type_filling = ORDER_FILLING_RETURN;
			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_FOK))
				request.type_filling = ORDER_FILLING_FOK;
			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_IOC))
				request.type_filling = ORDER_FILLING_IOC;
		}
		else
		{
			// in case of positions I would check for SYMBOL_FILLING_ and then set ORDER_FILLING_
			// this is because it appears that IsFillingTypeAllowed() works correct with SYMBOL_FILLING_, but then the position works correctly with ORDER_FILLING_
			// FOK and IOC integer values are not the same for ORDER and SYMBOL

			if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
				request.type_filling = ORDER_FILLING_FOK;
			else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
				request.type_filling = ORDER_FILLING_IOC;
			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
				request.type_filling = ORDER_FILLING_RETURN;
			else
				request.type_filling = ORDER_FILLING_RETURN;
		}

		if (!OrderCheck(request,check_result))
		{
			Print("OrderCheck() failed: ", (string)check_result.comment, " (", (string)check_result.retcode, ")");

			return -1;
		}

		bool success = OrderSend(request, result);

		//-- check security flag ------------------------------------------
		if (successed == true)
		{
			Print("The program will be removed because of suspicious attempt to create a new position");
			ExpertRemove();
			Sleep(10000);

			break;
		}

		if (success) {successed = true;}

		//-- error check --------------------------------------------------
		if (
			   success == false
			|| (
				   result.retcode != TRADE_RETCODE_DONE
				&& result.retcode != TRADE_RETCODE_PLACED
				&& result.retcode != TRADE_RETCODE_DONE_PARTIAL
			)
		)
		{
			string errmsgpfx = (type > ORDER_TYPE_SELL) ? "New pending order error" : "New position error";

			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch (erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return -1;
		}

		//-- finish work --------------------------------------------------
		if (
			   result.retcode == TRADE_RETCODE_DONE
			|| result.retcode == TRADE_RETCODE_PLACED
			|| result.retcode == TRADE_RETCODE_DONE_PARTIAL
		) {
			ticket = result.order;
			//== Whatever was created, we need to wait until MT5 updates it's cache

			//-- Synchronize: Position
			if (type <= ORDER_TYPE_SELL)
			{
				if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
				{
					if (closing == false)
					{
						//- new position: 2 situations here - new position or add to position
						//- ... because of that we will check the lot size instead of PositionSelect
						while (true)
						{
							if (PositionSelect(symbol) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}
							Sleep(10);
						}
					}
					else
					{
						//- closing position: full
						if (lots0 == NormalizeDouble(result.volume, 5))
						{
							while (true)
							{
								if (!PositionSelect(symbol)) {break;}
								Sleep(10);
							}
						}
						//- closing position: partial
						else if (lots0 > NormalizeDouble(result.volume, 5))
						{
							while (true)
							{
								if (PositionSelect(symbol) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}
								Sleep(10);
							}
						}
						else if (lots0 < NormalizeDouble(result.volume, 5))
						{
						//-- position reverse
							while (true)
							{
								if (PositionSelect(symbol) && (type0 != PositionGetInteger(POSITION_TYPE))) {break;}
								Sleep(10);
							}
						}
					}
				}
				else if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
				{
					if (closing == false)
					{
						while (true)
						{
							if (PositionSelectByTicket(ticket)) {break;}
							Sleep(10);
						}
					}
				}
			}
			//-- Synchronize: Order
			else
			{
				while (true)
				{
					if (LoadOrder(result.order)) {break;}
					Sleep(10);
				}
			}

			//-- fix arrow color (it works only in visual mode)
			// TODO: this piece of code slows down the backtest for some reason
			if (0 && MQLInfoInteger(MQL_VISUAL_MODE) && arrowcolor != CLR_NONE)
			{
				if (type <= ORDER_TYPE_SELL)
				{
					uint t0 = GetTickCount();
					ENUM_OBJECT objType = (type==POSITION_TYPE_BUY) ? OBJ_ARROW_BUY : OBJ_ARROW_SELL;

					// wait for the object to be created (MQL5 is async even here)
					while(true)
					{
						int total        = ObjectsTotal(0,0,objType);
						string name      = ObjectName(0,total-1,0,objType);
						datetime objTime = (datetime)ObjectGetInteger(0,name,OBJPROP_TIME);

						if (objTime > TimeCurrent()-1)
						{
							if (StringFind(name, "#" + IntegerToString(ticket) + " ") == 0)
							{
								ObjectSetInteger(0,name,OBJPROP_COLOR,arrowcolor);
							}

							break;
						}

						if (GetTickCount() - t0 > 1000) break;
					}
				}
				else
				{
					// Pending orders don't have arrows
				}
			}
		}

		if (ticket > 0)
		{
			if (USE_VIRTUAL_STOPS)
			{
				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));
			}

			//-- show some info
			double slip = 0;

			if (LoadPosition(ticket))
			{
				if (
					   !MQLInfoInteger(MQL_TESTER)
					&& !MQLInfoInteger(MQL_VISUAL_MODE)
					&& !MQLInfoInteger(MQL_OPTIMIZATION)
				) {
					slip = OrderOpenPrice() - op;

					Print(
						"Operation details: Speed ",
						(GetTickCount() - time0),
						" ms | Slippage ",
						DoubleToStr(toPips(slip, symbol), 1),
						" pips"
					);
				}
			}
			
			//-- fix stops in case of slippage
			if (
				   !MQLInfoInteger(MQL_TESTER)
				&& !MQLInfoInteger(MQL_VISUAL_MODE)
				&& !MQLInfoInteger(MQL_OPTIMIZATION)
			) {

				slip = NormalizeDouble(OrderOpenPrice(), digits) - NormalizeDouble(op, digits);

				if (slip != 0 && (OrderStopLoss() != 0 || OrderTakeProfit() != 0))
				{
					Print("Correcting stops because of slippage...");

					sl = OrderStopLoss();
					tp = OrderTakeProfit();

					if (sl != 0 || tp != 0)
					{
						if (sl != 0) {sl = NormalizeDouble(OrderStopLoss() + slip, digits);}
						if (tp != 0) {tp = NormalizeDouble(OrderTakeProfit() + slip, digits);}

						ModifyOrder(ticket, OrderOpenPrice(), sl, tp, 0, 0);
					}
				}
			}

			//RegisterEvent("trade");

			break;
		}

		break;
	}

	if (oco == true && ticket > 0)
	{
		if (USE_VIRTUAL_STOPS)
		{
			sl = vsl;
			tp = vtp;
		}

		sl = (sl > 0) ? NormalizeDouble(MathAbs(op-sl), digits) : 0;
		tp = (tp > 0) ? NormalizeDouble(MathAbs(op-tp), digits) : 0;
		
		int typeoco = type;

		if (typeoco == ORDER_TYPE_BUY_STOP)
		{
			typeoco = ORDER_TYPE_SELL_STOP;
			op = bid - MathAbs(op-ask);
		}
		else if (typeoco == ORDER_TYPE_BUY_LIMIT)
		{
			typeoco = ORDER_TYPE_SELL_LIMIT;
			op = bid + MathAbs(op-ask);
		}
		else if (typeoco == ORDER_TYPE_SELL_STOP)
		{
			typeoco = ORDER_TYPE_BUY_STOP;
			op = ask + MathAbs(op-bid);
		}
		else if (typeoco == ORDER_TYPE_SELL_LIMIT)
		{
			typeoco = ORDER_TYPE_BUY_LIMIT;
			op = ask - MathAbs(op-bid);
		}

		if (typeoco == ORDER_TYPE_BUY_STOP || typeoco == ORDER_TYPE_BUY_LIMIT)
		{
			sl = (sl > 0) ? op - sl : 0;
			tp = (tp > 0) ? op + tp : 0;
		}
		else {
			sl = (sl > 0) ? op + sl : 0;
			tp = (tp > 0) ? op - tp : 0;
		}

		comment = "[oco:" + (string)ticket + "]";

		OrderCreate(
			symbol,
			typeoco,
			lots,
			op,
			sl,
			tp,
			0,
			0,
			slippage,
			magic,
			comment,
			arrowcolor,
			expiration,
			false
		);
	}

	OnTrade();

	return (long)ticket;
}

double OrderLots()
{
	int type    = LoadedType();
	double lots = 0;

	     if (type == 1) {lots = PositionGetDouble(POSITION_VOLUME);}
	else if (type == 3) {lots = HistoryDealGetDouble(OrderTicket(),DEAL_VOLUME);}
	else if (type == 4) {lots = HistoryOrderGetDouble(OrderTicket(),ORDER_VOLUME_INITIAL);}
	else                {lots = OrderGetDouble(ORDER_VOLUME_CURRENT);}

	return NormalizeDouble(lots, 2);
}

int OrderMagicNumber()
{
	int type = LoadedType();

	if (type == 1) {return (int)PositionGetInteger(POSITION_MAGIC);}
	if (type == 3) {return (int)HistoryOrderGetInteger(HistoryDealGetInteger(OrderTicket(),DEAL_POSITION_ID),ORDER_MAGIC);}
	if (type == 4) {return (int)HistoryOrderGetInteger(OrderTicket(),ORDER_MAGIC);}

	return (int)OrderGetInteger(ORDER_MAGIC);
}

bool OrderModified(ulong ticket = 0, string action = "set")
{
	static ulong memory[];

	if (ticket == 0)
	{
		ticket = OrderTicket();
		action = "get";
	}
	else if (ticket > 0 && action != "clear")
	{
		action = "set";
	}

	bool modified_status = InArray(memory, ticket);
	
	if (action == "get")
	{
		return modified_status;
	}
	else if (action == "set")
	{
		ArrayEnsureValue(memory, ticket);

		return true;
	}
	else if (action == "clear")
	{
		ArrayStripValue(memory, ticket);

		return true;
	}

	return false;
}

double OrderOpenPrice()
{
	double op  = 0.0;
	int type   = LoadedType();
	int digits = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);

	if (type == 1)
	{
		op = PositionGetDouble(POSITION_PRICE_OPEN);
	}
	else if (type == 3)
	{
		// In most brokers we can get the "in" order and get the open price from it,
		// but in Admiral Markets this returns 0. So we search for the "in" deal.
		ulong outDealTicket = OrderTicket();
		ulong positionID    = HistoryDealGetInteger(outDealTicket, DEAL_POSITION_ID);
		
		if (HistorySelectByPosition(positionID))
		{
			int dealsTotal = HistoryDealsTotal();
	
			for (int index = dealsTotal - 1; index >= 0; index--)
			{
				ulong dealTicket = HistoryDealGetTicket(index);
	
				if (HistoryDealGetInteger(dealTicket, DEAL_ENTRY) == DEAL_ENTRY_IN)
				{
					op = HistoryDealGetDouble(dealTicket, DEAL_PRICE);
	
					break;
				}
			}
		}

		// Restore previously selected history
		HistorySelect(SelectedHistoryFromTime(), SelectedHistoryToTime());
	}
	else if (type == 4)
	{
		op = HistoryOrderGetDouble(OrderTicket(), ORDER_PRICE_OPEN);
	}
   else
   {
   	op = OrderGetDouble(ORDER_PRICE_OPEN);
   }

	return NormalizeDouble(op, digits);
}

datetime OrderOpenTime()
{
	datetime time = 0;
	int type      = LoadedType();

	if (type == 1)
	{
		time = (datetime)PositionGetInteger(POSITION_TIME);
	}
	//if (type == 3) {return HistoryOrderGetInteger(HistoryDealGetInteger(OrderTicket(),DEAL_POSITION_ID),ORDER_TIME_SETUP);}
	else if (type == 3)
	{
		ulong outDealTicket = OrderTicket();
		ulong positionID    = HistoryDealGetInteger(outDealTicket, DEAL_POSITION_ID);

		if (HistorySelectByPosition(positionID))
		{
			int dealsTotal = HistoryDealsTotal();
	
			for (int index = dealsTotal - 1; index >= 0; index--)
			{
				ulong dealTicket = HistoryDealGetTicket(index);
	
				if (HistoryDealGetInteger(dealTicket, DEAL_ENTRY) == DEAL_ENTRY_IN)
				{
					time = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);
	
					break;
				}
			}
		}

		// Restore previously selected history
		HistorySelect(SelectedHistoryFromTime(), SelectedHistoryToTime());
	}
	else if (type == 4)
	{
		time = (datetime)HistoryOrderGetInteger(OrderTicket(),ORDER_TIME_SETUP);
	}
	else
	{
		time = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
	}
	
	return time;
}

double OrderProfit()
{
	int type = LoadedType();

   if (type == 1) {return PositionGetDouble(POSITION_PROFIT);}
   if (type == 3) {return HistoryDealGetDouble(OrderTicket(),DEAL_PROFIT);}
   if (type == 4) {return 0;}
	
	return 0;
}

double OrderStopLoss()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_SL);}
	if (type == 3) {return HistoryOrderGetDouble(HistoryDealGetInteger(OrderTicket(),DEAL_POSITION_ID),ORDER_SL);}
	if (type == 4) {return HistoryOrderGetDouble(OrderTicket(),ORDER_SL);}

	return OrderGetDouble(ORDER_SL);
}

double OrderSwap()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_SWAP);}
	if (type == 3) {return HistoryDealGetDouble(OrderTicket(),DEAL_SWAP);}
	if (type == 4) {return 0;}

	return 0;
}

string OrderSymbol()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetString(POSITION_SYMBOL);}
	if (type == 3) {return HistoryDealGetString(OrderTicket(),DEAL_SYMBOL);}
	if (type == 4) {return HistoryOrderGetString(OrderTicket(),ORDER_SYMBOL);}

	return OrderGetString(ORDER_SYMBOL);
}

double OrderTakeProfit()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_TP);}
	if (type == 3) {return HistoryOrderGetDouble(HistoryDealGetInteger(OrderTicket(),DEAL_POSITION_ID),ORDER_TP);}
	if (type == 4) {return HistoryOrderGetDouble(OrderTicket(),ORDER_TP);}

	return OrderGetDouble(ORDER_TP);
}

ulong OrderTicket(ulong ticket = 0)
{
	static ulong memory = 0;
	
	if (ticket > 0) {memory = ticket;}
	
	return memory;
}

int OrderType()
{
	int type = LoadedType();

	if (type == 1) {return (int)PositionGetInteger(POSITION_TYPE);}
	if (type == 2) {return (int)OrderGetInteger(ORDER_TYPE);}
	if (type == 3)
	{
		int OT = (int)HistoryDealGetInteger(OrderTicket(),DEAL_TYPE);
		if (OT == 1) {return 0;}
		if (OT == 0) {return 1;}

		return OT;
	}
	if (type == 4) {return (int)HistoryOrderGetInteger(OrderTicket(),ORDER_TYPE);}

	return (int)OrderGetInteger(ORDER_TYPE);
}

bool PendingOrderSelectByTicket(ulong ticket)
{
	bool success = OrderSelect(ticket);

	if (success) {
		LoadedType(2);
		OrderTicket(ticket);
	}

	return success;
}

double PipValue(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return CustomPoint(symbol) / SymbolInfoDouble(symbol, SYMBOL_POINT);
}

int SecondsFromComponents(double days, double hours, double minutes, int seconds)
{
	int retval =
		86400 * (int)MathFloor(days)
		+ 3600 * (int)(MathFloor(hours) + (24 * (days - MathFloor(days))))
		+ 60 * (int)(MathFloor(minutes) + (60 * (hours - MathFloor(hours))))
		+ (int)((double)seconds + (60 * (minutes - MathFloor(minutes))));

	return retval;
}

datetime SelectedHistoryFromTime(datetime setTime = -1)
{
	static datetime time;
	
	if (setTime > -1)
	{
		time = setTime;
	}
	
	return time;
}

datetime SelectedHistoryToTime(datetime setTime = -1)
{
	static datetime time;
	
	if (setTime > -1)
	{
		time = setTime;
	}
	
	return time;
}

long SellNow(
	string symbol,
	double lots,
	double sll,
	double tpl,
	double slp,
	double tpp,
	double slippage = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	datetime expiration = 0
	)
{
	return OrderCreate(
		symbol,
		POSITION_TYPE_SELL,
		lots,
		0,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration
	);
}

int StrToInteger(string value)
{
	return (int)StringToInteger(value);
}

template<typename T>
void StringExplode(string delimiter, string inputString, T &output[])
{
	int begin   = 0;
	int end     = 0;
	int element = 0;
	int length  = StringLen(inputString);
	int length_delimiter = StringLen(delimiter);
	T empty_val  = (typename(T) == "string") ? (T)"" : (T)0;

	if (length > 0)
	{
		while (true)
		{
			end = StringFind(inputString, delimiter, begin);

			ArrayResize(output, element + 1);
			output[element] = empty_val;
	
			if (end != -1)
			{
				if (end > begin)
				{
					output[element] = (T)StringSubstr(inputString, begin, end - begin);
				}
			}
			else
			{
				output[element] = (T)StringSubstr(inputString, begin, length - begin);
				break;
			}
			
			begin = end + 1 + (length_delimiter - 1);
			element++;
		}
	}
	else
	{
		ArrayResize(output, 1);
		output[element] = empty_val;
	}
}

template<typename T>
string StringImplode(string delimeter, T &array[])
{
   string retval = "";
	int size      = ArraySize(array);

   for (int i = 0; i < size; i++)
	{
      StringConcatenate(retval, retval, (string)array[i], delimeter);
   }

   return StringSubstr(retval, 0, (StringLen(retval) - StringLen(delimeter)));
}

string StringTrim(string text)
{
	StringTrimRight(text);
	StringTrimLeft(text);

	return text;
}

double SymbolAsk(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_ASK);
}

double SymbolBid(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_BID);
}

int SymbolDigits(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
}

double SymbolLotSize(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
}

double SymbolLotStep(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
}

double SymbolMaxLot(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
}

double SymbolMinLot(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
}

int SymbolsList(string &symbols[], bool selected)
{
	static string memory[];
	static int symbols_count;
	static bool do_read = true;

	//-- read all symbols once, or read them every time if selected==true
	if (do_read == true || selected == true)
	{
		do_read = false;

		symbols_count = SymbolsTotal(selected);

		int s = 0;

		for(int i = 0; i < symbols_count; i++)
		{
			string symbol = SymbolName(i, selected);

			if (StringLen(symbol) > 0 /* add another condition here if needed */)
			{
				ArrayResize(memory, s+1);
				memory[s] = symbol;
				s++;
			}
		}

		symbols_count = s;
	}

	ArrayCopy(symbols,memory);

	return symbols_count;
}

double TicksData(string symbol = "", int type = 0, int shift = 0)
{
	static bool collecting_ticks = false;
	static string symbols[];
	static int zero_sid[];
	static double memoryASK[][100];
	static double memoryBID[][100];

	int sid = 0, size = 0, i = 0, id = 0;
	double ask = 0, bid = 0, retval = 0;
	bool exists = false;

	if (ArraySize(symbols) == 0)
	{
		ArrayResize(symbols, 1);
		ArrayResize(zero_sid, 1);
		ArrayResize(memoryASK, 1);
		ArrayResize(memoryBID, 1);

		symbols[0] = _Symbol;
	}

	if (type > 0 && shift > 0)
	{
		collecting_ticks = true;
	}

	if (collecting_ticks == false)
	{
		if (type > 0 && shift == 0)
		{
			// going to get ticks
		}
		else
		{
			return 0;
		}
	}

	if (symbol == "") symbol = _Symbol;

	if (type == 0)
	{
		exists = false;
		size   = ArraySize(symbols);

		if (size == 0) {ArrayResize(symbols, 1);}

		for (i=0; i<size; i++)
		{
			if (symbols[i] == symbol)
			{
				exists = true;
				sid    = i;
				break;
			}
		}

		if (exists == false)
		{
			int newsize = ArraySize(symbols) + 1;

			ArrayResize(symbols, newsize);
			symbols[newsize-1] = symbol;

			ArrayResize(zero_sid, newsize);
			ArrayResize(memoryASK, newsize);
			ArrayResize(memoryBID, newsize);

			sid=newsize;
		}

		if (sid >= 0)
		{
			ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
			bid = SymbolInfoDouble(symbol, SYMBOL_BID);

			if (bid == 0 && MQLInfoInteger(MQL_TESTER))
			{
				Print("Ticks data collector error: " + symbol + " cannot be backtested. Only the current symbol can be backtested. The EA will be terminated.");
				ExpertRemove();
			}

			if (
				   symbol == _Symbol
				|| ask != memoryASK[sid][0]
				|| bid != memoryBID[sid][0]
			)
			{
				memoryASK[sid][zero_sid[sid]] = ask;
				memoryBID[sid][zero_sid[sid]] = bid;
				zero_sid[sid]                 = zero_sid[sid] + 1;

				if (zero_sid[sid] == 100)
				{
					zero_sid[sid] = 0;
				}
			}
		}
	}
	else
	{
		if (shift <= 0)
		{
			if (type == SYMBOL_ASK)
			{
				return SymbolInfoDouble(symbol, SYMBOL_ASK);
			}
			else if (type == SYMBOL_BID)
			{
				return SymbolInfoDouble(symbol, SYMBOL_BID); 
			}
			else
			{
				double mid = ((SymbolInfoDouble(symbol, SYMBOL_ASK) + SymbolInfoDouble(symbol, SYMBOL_BID)) / 2);

				return mid;
			}
		}
		else
		{
			size = ArraySize(symbols);

			for (i = 0; i < size; i++)
			{
				if (symbols[i] == symbol)
				{
					sid = i;
				}
			}

			if (shift < 100)
			{
				id = zero_sid[sid] - shift - 1;

				if(id < 0) {id = id + 100;}

				if (type == SYMBOL_ASK)
				{
					retval = memoryASK[sid][id];

					if (retval == 0)
					{
						retval = SymbolInfoDouble(symbol, SYMBOL_ASK);
					}
				}
				else if (type == SYMBOL_BID)
				{
					retval = memoryBID[sid][id];

					if (retval == 0)
					{
						retval = SymbolInfoDouble(symbol, SYMBOL_BID);
					}
				}
			}
		}
	}

	return retval;
}

int TicksPerSecond(bool get_max = false, bool set = false)
{
	static datetime time0 = 0;
	static int ticks      = 0;
	static int tps        = 0;
	static int tpsmax     = 0;

	datetime time1 = TimeLocal();

	if (set == true)
	{
		if (time1 > time0)
		{
			if (time1 - time0 > 1)
			{
				tps = 0;
			}
			else
			{
				tps = ticks;
			}

			time0 = time1;
			ticks = 0;
		}

		ticks++;

		if (tps > tpsmax) {tpsmax = tps;}
	}

	if (get_max)
	{
		return tpsmax;
	}

	return tps;
}

datetime TimeAtStart(string cmd = "server")
{
	static datetime local  = 0;
	static datetime server = 0;

	if (cmd == "local")
	{
		return local;
	}
	else if (cmd == "server")
	{
		return server;
	}
	else if (cmd == "set")
	{
		local  = TimeLocal();
		server = TimeCurrent();
	}

	return 0;
}

int TimeDay(datetime time)
{
	MqlDateTime tm;
   TimeToStruct(time,tm);
   return(tm.day);
}

int TimeDayOfWeek(datetime time)
{
   MqlDateTime tm;
   TimeToStruct(time,tm);
   return(tm.day_of_week);
}

datetime TimeFromComponents(
	int time_src = 0,
	int    y = 0,
	int    m = 0,
	double d = 0,
	double h = 0,
	double i = 0,
	int    s = 0
) {
	MqlDateTime tm;

	     if (time_src == 0) {TimeCurrent(tm);}
	else if (time_src == 1) {TimeLocal(tm);}
	else if (time_src == 2) {TimeGMT(tm);}

	if (y > 0)
	{
		if (y < 100) {y = 2000 + y;}
		tm.year = y;
	}
	if (m > 0) {tm.mon = m;}
	if (d > 0) {tm.day = (int)MathFloor(d);}

	tm.hour = (int)(MathFloor(h) + (24 * (d - MathFloor(d))));
	tm.min  = (int)(MathFloor(i) + (60 * (h - MathFloor(h))));
	tm.sec  = (int)((double)s + (60 * (i - MathFloor(i))));

	return StructToTime(tm);
}

int TimeHour(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.hour;
}

int TimeMinute(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);
	
	return tm.min;
}

int TimeMonth(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.mon;
}

int TimeSeconds(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.sec;
}

int TimeYear(datetime time)
{
   MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.year;
}

bool TradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (LoadPosition(PositionGetTicket(index)))
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells)
			)
		{
			return true;
		}
	}

	return false;
}

bool TradeSelectByTicket(ulong ticket)
{
	if (LoadPosition(ticket) && OrderType() < 2)
	{
		return true;
	}

	return false;
}

int TradesTotal()
{
	return PositionsTotal();
}

// TODO: Virtual SL and TP in MQL5

void UpdateEventValues(ulong deal_ticket, string e_reason = "", string e_detail = "")
{
	e_Reason       (true, e_reason);
	e_ReasonDetail (true, e_detail);

	e_attrClosePrice (true, HistoryDealGetDouble(deal_ticket, DEAL_PRICE));
	e_attrCloseTime  (true, 0);
	e_attrComment    (true, HistoryDealGetString(deal_ticket, DEAL_COMMENT));
	e_attrCommission (true, HistoryDealGetDouble(deal_ticket, DEAL_COMMISSION));
	e_attrExpiration (true, 0);
	e_attrLots       (true, HistoryDealGetDouble(deal_ticket, DEAL_VOLUME));
	e_attrMagicNumber(true, HistoryOrderGetInteger(HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID), ORDER_MAGIC));
	e_attrOpenPrice  (true, HistoryDealGetDouble(deal_ticket, DEAL_PRICE));
	e_attrOpenTime   (true, HistoryDealGetInteger(deal_ticket, DEAL_TIME));
	e_attrProfit     (true, HistoryDealGetDouble(deal_ticket, DEAL_PROFIT));
	e_attrStopLoss   (true, HistoryOrderGetDouble(HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID), ORDER_SL));
	e_attrSwap       (true, HistoryDealGetDouble(deal_ticket, DEAL_SWAP));
	e_attrSymbol     (true, HistoryDealGetString(deal_ticket, DEAL_SYMBOL));
	e_attrTakeProfit (true, HistoryOrderGetDouble(HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID), ORDER_TP));
	e_attrTicket     (true, HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID));

	int type = (int)HistoryDealGetInteger(deal_ticket, DEAL_TYPE);

	if (e_reason == "close")
	{
		     if (type == 0) {type = 1;}
		else if (type == 1) {type = 0;}
	}

	e_attrType(true, type);
}
void UpdateEventValues(position &data, string e_reason = "", string e_detail = "")
{
	e_Reason       (true, e_reason);
	e_ReasonDetail (true, e_detail);

	e_attrClosePrice (true, data.price_current);
	e_attrCloseTime  (true, 0);
	e_attrComment    (true, data.comment);
	e_attrCommission (true, data.comission);
	e_attrExpiration (true, 0);
	e_attrLots       (true, data.volume);
	e_attrMagicNumber(true, data.magic);
	e_attrOpenPrice  (true, data.price_open);
	e_attrOpenTime   (true, data.time);
	e_attrProfit     (true, data.profit);
	e_attrStopLoss   (true, data.sl);
	e_attrSwap       (true, data.swap);
	e_attrSymbol     (true, data.symbol);
	e_attrTakeProfit (true, data.tp);
	e_attrTicket     (true, data.position_id);

	if (e_reason == "close")
	{
		     if (data.type == 0) {data.type = 1;}
		else if (data.type == 1) {data.type = 0;}
	}

	e_attrType       (true, (int)data.type);
}
void UpdateEventValues(order &data, string e_reason = "", string e_detail = "")
{
	e_Reason       (true, e_reason);
	e_ReasonDetail (true, e_detail);

	e_attrClosePrice (true, data.price_current);
	e_attrCloseTime  (true, data.time_done);
	e_attrComment    (true, data.comment);
	e_attrCommission (true, 0);
	e_attrExpiration (true, data.time_expiration);
	e_attrLots       (true, data.volume_current);
	e_attrMagicNumber(true, data.magic);
	e_attrOpenPrice  (true, data.price_open);
	e_attrOpenTime   (true, data.time_setup);
	e_attrProfit     (true, 0);
	e_attrStopLoss   (true, data.sl);
	e_attrSwap       (true, 0);
	e_attrSymbol     (true, data.symbol);
	e_attrTakeProfit (true, data.tp);
	e_attrTicket     (true, data.ticket);
	e_attrType       (true, (int)data.type);
}

double VirtualStopsDriver(
	string command = "",
	ulong ti       = 0,
	double sl      = 0,
	double tp      = 0,
	double slp     = 0,
	double tpp     = 0
)
{
	static bool initialized     = false;
	static string name          = "";
	static string loop_name[2]  = {"sl", "tp"};
	static color  loop_color[2] = {DeepPink, DodgerBlue};
	static double loop_price[2] = {0, 0};
	static ulong mem_to_ti[]; // tickets
	static int mem_to[];      // timeouts
	static bool trade_pass = false;
	int i = 0;

	// Are Virtual Stops even enabled?
	if (!USE_VIRTUAL_STOPS)
	{
		return 0;
	}
	
	if (initialized == false || command == "initialize")
	{
		initialized = true;
	}

	// Listen
	if (command == "" || command == "listen")
	{
		int total     = ObjectsTotal(0, -1, OBJ_HLINE);
		int length    = 0;
		color clr     = clrNONE;
		int sltp      = 0;
		ulong ticket  = 0;
		double level  = 0;
		double askbid = 0;
		int polarity  = 0;
		string symbol = "";

		for (i = total - 1; i >= 0; i--)
		{
			name = ObjectName(0, i, -1, OBJ_HLINE); // for example: #1 sl

			if (StringSubstr(name, 0, 1) != "#")
			{
				continue;
			}

			length = StringLen(name);

			if (length < 5)
			{
				continue;
			}

			clr = (color)ObjectGetInteger(0, name, OBJPROP_COLOR);

			if (clr != loop_color[0] && clr != loop_color[1])
			{
				continue;
			}

			string last_symbols = StringSubstr(name, length-2, 2);

			if (last_symbols == "sl")
			{
				sltp = -1;
			}
			else if (last_symbols == "tp")
			{
				sltp = 1;
			}
			else
			{
				continue;	
			}

			ulong ticket0 = StringToInteger(StringSubstr(name, 1, length - 4));

			// prevent loading the same ticket number twice in a row
			if (ticket0 != ticket)
			{
				ticket = ticket0;

				if (TradeSelectByTicket(ticket))
				{
					symbol     = OrderSymbol();
					polarity   = (OrderType() == 0) ? 1 : -1;
					askbid   = (OrderType() == 0) ? SymbolInfoDouble(symbol, SYMBOL_BID) : SymbolInfoDouble(symbol, SYMBOL_ASK);
					
					trade_pass = true;
				}
				else
				{
					trade_pass = false;
				}
			}

			if (trade_pass)
			{
				level    = ObjectGetDouble(0, name, OBJPROP_PRICE, 0);

				if (level > 0)
				{
					// polarize levels
					double level_p  = polarity * level;
					double askbid_p = polarity * askbid;

					if (
						   (sltp == -1 && (level_p - askbid_p) >= 0) // sl
						|| (sltp == 1 && (askbid_p - level_p) >= 0)  // tp
					)
					{
						//-- Virtual Stops SL Timeout
						if (
							   (VIRTUAL_STOPS_TIMEOUT > 0)
							&& (sltp == -1 && (level_p - askbid_p) >= 0) // sl
						)
						{
							// start timeout?
							int index = ArraySearch(mem_to_ti, ticket);

							if (index < 0)
							{
								int size = ArraySize(mem_to_ti);
								ArrayResize(mem_to_ti, size+1);
								ArrayResize(mem_to, size+1);
								mem_to_ti[size] = ticket;
								mem_to[size]    = (int)TimeLocal();

								Print(
									"#",
									ticket,
									" timeout of ",
									VIRTUAL_STOPS_TIMEOUT,
									" seconds started"
								);

								return 0;
							}
							else
							{
								if (TimeLocal() - mem_to[index] <= VIRTUAL_STOPS_TIMEOUT)
								{
									return 0;
								}
							}
						}

						if (CloseTrade(ticket))
						{
							// check this before deleting the lines
							//OnTradeListener();

							// delete objects
							ObjectDelete(0, "#" + (string)ticket + " sl");
							ObjectDelete(0, "#" + (string)ticket + " tp");
						}
					}
					else
					{
						if (VIRTUAL_STOPS_TIMEOUT > 0)
						{
							i = ArraySearch(mem_to_ti, ticket);

							if (i >= 0)
							{
								ArrayStripKey(mem_to_ti, i);
								ArrayStripKey(mem_to, i);
							}
						}
					}
				}
			}
			else if (
					!PendingOrderSelectByTicket(ticket)
				|| OrderCloseTime() > 0 // in case the order has been closed
			)
			{
				ObjectDelete(0, name);
			}
			else
			{
				PendingOrderSelectByTicket(ticket);
			}
		}
	}
	// Get SL or TP
	else if (
		ti > 0
		&& (
			   command == "get sl"
			|| command == "get tp"
		)
	)
	{
		double value = 0;

		name = "#" + IntegerToString(ti) + " " + StringSubstr(command, 4, 2);

		if (ObjectFind(0, name) > -1)
		{
			value = ObjectGetDouble(0, name, OBJPROP_PRICE, 0);
		}

		return value;
	}
	// Set SL and TP
	else if (
		ti > 0
		&& (
			   command == "set"
			|| command == "modify"
			|| command == "clear"
			|| command == "partial"
		)
	)
	{
		loop_price[0] = sl;
		loop_price[1] = tp;

		for (i = 0; i < 2; i++)
		{
			name = "#" + IntegerToString(ti) + " " + loop_name[i];
			
			if (loop_price[i] > 0)
			{
				// 1) create a new line
				if (ObjectFind(0, name) == -1)
				{
						 ObjectCreate(0, name, OBJ_HLINE, 0, 0, loop_price[i]);
					ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
					ObjectSetInteger(0, name, OBJPROP_COLOR, loop_color[i]);
					ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
					ObjectSetString(0, name, OBJPROP_TEXT, name + " (virtual)");
				}
				// 2) modify existing line
				else
				{
					ObjectSetDouble(0, name, OBJPROP_PRICE, 0, loop_price[i]);
				}
			}
			else
			{
				// 3) delete existing line
				ObjectDelete(0, name);
			}
		}

		// print message
		if (command == "set" || command == "modify")
		{
			Print(
				command,
				" #",
				IntegerToString(ti),
				": virtual sl ",
				DoubleToStr(sl, (int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS)),
				" tp ",
				DoubleToStr(tp,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS))
			);
		}

		return 1;
	}

	return 1;
}

int WindowFindVisible(long chart_id, string term)
{
   //-- the search term can be chart name, such as Force(13), or subwindow index
   if (term == "" || term == "0") {return 0;}
   
   int subwindow = (int)StringToInteger(term);
   
   if (subwindow == 0 && StringLen(term) > 1)
   {
      subwindow = ChartWindowFind(chart_id, term);
   }
   
   if (subwindow > 0 && !ChartGetInteger(chart_id, CHART_WINDOW_IS_VISIBLE, subwindow))
   {
      return -1;  
   }
   
   return subwindow;
}

double ask(string symbol = NULL)
{
	return SymbolInfoDouble(symbol, SYMBOL_ASK);
}

double attrStopLoss()
{
	if (USE_VIRTUAL_STOPS)
	{
		return VirtualStopsDriver("get sl", OrderTicket());
	}

	return OrderStopLoss();
}

double attrTakeProfit()
{
	if (USE_VIRTUAL_STOPS)
	{
		return VirtualStopsDriver("get tp", OrderTicket());
	}

   return OrderTakeProfit();
}

template<typename DT1, typename DT2>
bool compare(string sign, DT1 v1, DT2 v2)
{
	     if (sign == ">") return(v1 > v2);
	else if (sign == "<") return(v1 < v2);
	else if (sign == ">=") return(v1 >= v2);
	else if (sign == "<=") return(v1 <= v2);
	else if (sign == "==") return(v1 == v2);
	else if (sign == "!=") return(v1 != v2);
	else if (sign == "x>") return(v1 > v2);
	else if (sign == "x<") return(v1 < v2);

	return false;
}

string e_Reason(bool set=false, string inp="") {
   static string mem[250];
   int queue=OnTradeQueue()-1;
   if(set==true){
      mem[queue]=inp;
   }
   return(mem[queue]);
}

string e_ReasonDetail(bool set=false, string inp="") {static string mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrClosePrice(bool set=false, double inp=-1) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

datetime e_attrCloseTime(bool set=false, datetime inp=-1) {static datetime mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

string e_attrComment(bool set=false, string inp="") {static string mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrCommission(bool set=false, double inp=0) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

datetime e_attrExpiration(bool set=false, datetime inp=0) {static datetime mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrLots(bool set=false, double inp=-1) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

ulong e_attrMagicNumber(bool set=false, ulong inp=-1) {static ulong mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrOpenPrice(bool set=false, double inp=-1) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

datetime e_attrOpenTime(bool set=false,datetime inp=-1) {static datetime mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrProfit(bool set=false, double inp=0) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrStopLoss(bool set=false, double inp=-1) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrSwap(bool set=false, double inp=0) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

string e_attrSymbol(bool set=false, string inp="") {static string mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

double e_attrTakeProfit(bool set=false, double inp=-1) {static double mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

ulong e_attrTicket(bool set=false, ulong inp=-1) {static ulong mem[250];int queue=OnTradeQueue()-1;if(set==true){mem[queue]=inp;}return(mem[queue]);}

int e_attrType(bool set=false, int inp=-1)
{
	static int mem[250];
	int queue = OnTradeQueue()-1;

	if (set == true)
	{
		mem[queue] = inp;
	}
	
	return mem[queue] ;
}

template<typename DT1, typename DT2>
double formula(string sign, DT1 v1, DT2 v2)
{
	     if (sign == "+") return(v1 + v2);
	else if (sign == "-") return(v1 - v2);
	else if (sign == "*") return(v1 * v2);
	else if (sign == "/") return(v1 / v2);

	return false;
}

string formula(string sign, string v1, string v2)
{
	if (sign == "+") return(v1 + v2);
	else {
		double _v1 = StringToDouble(v1);
		double _v2 = StringToDouble(v2);
		
		     if (sign == "-") return DoubleToString(_v1 - _v2);
		else if (sign == "*") return DoubleToString(_v1 * _v2);
		else if (sign == "/") return DoubleToString(_v1 / _v2);
	}

	return v1 + v2;
}

double formula(string sign, string v1, double v2)
{
	     if (sign == "+") return StringToDouble(v1) + v2;
	else if (sign == "-") return StringToDouble(v1) - v2;
	else if (sign == "*") return StringToDouble(v1) * v2;
	else if (sign == "/") return StringToDouble(v1) / v2;

	return StringToDouble(v1) + v2;
}

double formula(string sign, double v1, string v2)
{
	if (sign == "+") return (v1 + StringToDouble(v2));
	else if (sign == "-") return v1 - StringToDouble(v2);
	else if (sign == "*") return v1 * StringToDouble(v2);
	else if (sign == "/") return v1 / StringToDouble(v2);

	return v1 + StringToDouble(v2);
}

double fxdCustomIndicator(int handle, int mode=0, int shift=0)
{
	static double buffer[1];

	if (handle < 0)
	{
		Print("Error: Indicator not handled. (handle=",handle," | error code=",GetLastError(),")");
		return 0;
	}

	int tryouts = 0;

	while (true)
	{
		if (BarsCalculated(handle) > 0) break;
		else
		{
			tryouts++;

			if (MQLInfoInteger(MQL_TESTER))
			{
				Sleep(10);
			}
			else
			{
				if (tryouts > 100)
				{
					Print("Error: Custom indicator could not load (handle=",handle," | error code=",GetLastError(),")");

					break;
				}

				Sleep(50);
			}
		}
	}

	int success = CopyBuffer(handle,mode,shift,1,buffer);

	if (success < 0)
	{
		Print("Error: Cannot get value from a custom indicator. (handle=",handle," | error code=",GetLastError(),")");
		return 0;
	}

	//ArraySetAsSeries(buffer,true);

	return buffer[0];
}

double iATR( 
	string             symbol,
	ENUM_TIMEFRAMES    timeframe,
	int                ma_period,
	int                shift
)
{
	int handle = iATR(symbol, timeframe, ma_period);
	double val = fxdCustomIndicator(handle, 0, shift);

	return NormalizeDouble(val, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));
}

double  iCCI( 
	string             symbol,
	ENUM_TIMEFRAMES    timeframe,
	int                ma_period,
	ENUM_APPLIED_PRICE applied_price,
	int                shift
)
{
	int handle = iCCI(symbol, timeframe, ma_period, applied_price);
	double val = fxdCustomIndicator(handle, 0, shift);

	return NormalizeDouble(val, 2);
}

double toDigits(double pips, string symbol)
{
	if (symbol == "") symbol = Symbol();

	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

	return NormalizeDouble(pips * PipValue(symbol) * point, digits);
}

double toPips(double digits, string symbol)
{
	if (symbol == "") symbol = Symbol();

   return digits / (PipValue(symbol) * SymbolInfoDouble(symbol, SYMBOL_POINT));
}






class FxdWaiting
{
	private:
		int beginning_id;
		ushort bank  [][2][20]; // 2 banks, 20 possible parallel waiting blocks per chain of blocks
		ushort state [][2];     // second dimention values: 0 - count of the blocks put on hold, 1 - current bank id

	public:
		void Initialize(int count)
		{
			ArrayResize(bank, count);
			ArrayResize(state, count);
		}

		bool Run(int id = 0)
		{
			beginning_id = id;

			int range = ArrayRange(state, 0);
			if (range < id+1) {
				ArrayResize(bank, id+1);
				ArrayResize(state, id+1);

				// set values to 0, otherwise they have random values
				for (int ii = range; ii < id+1; ii++)
				{
				   state[ii][0] = 0;
				   state[ii][1] = 0;
				}
			}

			// are there blocks put on hold?
			int count = state[id][0];
			int bank_id = state[id][1];

			// if no block are put on hold -> escape
			if (count == 0) {return false;}
			else
			{
				state[id][0] = 0; // null the count
				state[id][1] = (bank_id) ? 0 : 1; // switch to the other bank
			}

			//== now we will run the blocks put on hold

			for (int i = 0; i < count; i++)
			{
				int block_to_run = bank[id][bank_id][i];
				_blocks_[block_to_run].run();
			}

			return true;
		}

		void Accumulate(int block_id = 0)
		{
			int count   = ++state[beginning_id][0];
			int bank_id = state[beginning_id][1];

			bank[beginning_id][bank_id][count-1] = (ushort)block_id;
		}
};
FxdWaiting fxdWait;



//+------------------------------------------------------------------+
//| END                                                              |
//| Created with fxDreema EA Builder           https://fxdreema.com/ |
//+------------------------------------------------------------------+

/*<fxdreema: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
:fxdreema>*/