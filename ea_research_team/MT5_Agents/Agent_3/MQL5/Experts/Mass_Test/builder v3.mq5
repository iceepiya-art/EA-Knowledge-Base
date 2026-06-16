//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2021, fxDreema  (//
//+------------------------------------------------------------------------------+//
#property copyright   "piyarobot"
#property link        "https://fxdreema.com"
#property description "https://www.facebook.com/RichmanMakeMoney"
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
#define PROJECT_ID "mt4-4310"
//--
// Point Format Rules
#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later
#define ENABLE_SPREAD_METER true
#define ENABLE_STATUS true
#define ENABLE_TEST_INDICATORS true
//--
// Events On/Off
#define ENABLE_EVENT_TICK 1 // enable "Tick" event
#define ENABLE_EVENT_TRADE 1 // enable "Trade" event
#define ENABLE_EVENT_TIMER 0 // enable "Timer" event
//--
// Virtual Stops
#define VIRTUAL_STOPS_ENABLED 1 // enable virtual stops
#define VIRTUAL_STOPS_TIMEOUT 0 // virtual stops timeout
#define USE_EMERGENCY_STOPS "no" // "yes" to use emergency (hard stops) when virtual stops are in use. "always" to use EMERGENCY_STOPS_ADD as emergency stops when there is no virtual stop.
#define EMERGENCY_STOPS_REL 0 // use 0 to disable hard stops when virtual stops are enabled. Use a value >=0 to automatically set hard stops with virtual. Example: if 2 is used, then hard stops will be 2 times bigger than virtual ones.
#define EMERGENCY_STOPS_ADD 0 // add pips to relative size of emergency stops (hard stops)
//--
// Settings for events
#define ON_TRADE_REALTIME 0 //
#define ON_TIMER_PERIOD 60 // Timer event period (in seconds)

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// System constants (predefined constants) //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
// Blocks Lookup Functions
string fxdBlocksLookupTable[];

#define TLOBJPROP_TIME1 801
#define OBJPROP_TL_PRICE_BY_SHIFT 802
#define OBJPROP_TL_SHIFT_BY_PRICE 803
#define OBJPROP_FIBOVALUE 804
#define OBJPROP_FIBOPRICEVALUE 805
#define OBJPROP_BARSHIFT1 807
#define OBJPROP_BARSHIFT2 808
#define OBJPROP_BARSHIFT3 809
#define SEL_CURRENT 0
#define SEL_INITIAL 1

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// Enumerations, Imports, Constants, Variables //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//





//--
// Constants (Input Parameters)
input string Comment = "PIYAROBOT";input double ZZ_Depth = 12.0;input ENUM_TIMEFRAMES Time_Frame = PERIOD_H1;input double Spread_Filter = 30.0;input double MAX_Slippage_PIP = 4.0;input double LOT_Divided = 100000.0;input double Nearby_PIP = 100.0;input double Martingale_Multiple = 1.2;input double Stop_Loss_Percent = 3.0;input bool System_1_MACD = True;input bool System_2_RSI = True;input bool System_3_Trendline = True;input double Macd_Center_Buy = -0.001;input double Macd_Center_Sell = 0.001;input double Close_All_Profit_Percent = 0.23;input double Break_Even_PIP = 300.0;input bool Terminate = false;input bool Line_Normal_Trade = false;input string Web = "https://notify-api.line.me/api/notify";input string Token = "YVL4jlTE0vX8SV8NxO29oU3K26M6YxaQoVaHnAj7dFi";input string Greeting = "Hello";input string ServerEND = "erver is not working !!!!";input int MagicStart = 23; // Magic Number, kind of...
class c
{
		public:
	static string Comment;
	static double ZZ_Depth;
	static ENUM_TIMEFRAMES Time_Frame;
	static double Spread_Filter;
	static double MAX_Slippage_PIP;
	static double LOT_Divided;
	static double Nearby_PIP;
	static double Martingale_Multiple;
	static double Stop_Loss_Percent;
	static bool System_1_MACD;
	static bool System_2_RSI;
	static bool System_3_Trendline;
	static double Macd_Center_Buy;
	static double Macd_Center_Sell;
	static double Close_All_Profit_Percent;
	static double Break_Even_PIP;
	static bool Terminate;
	static bool Line_Normal_Trade;
	static string Web;
	static string Token;
	static string Greeting;
	static string ServerEND;
	static int MagicStart;
};
string c::Comment;
double c::ZZ_Depth;
ENUM_TIMEFRAMES c::Time_Frame;
double c::Spread_Filter;
double c::MAX_Slippage_PIP;
double c::LOT_Divided;
double c::Nearby_PIP;
double c::Martingale_Multiple;
double c::Stop_Loss_Percent;
bool c::System_1_MACD;
bool c::System_2_RSI;
bool c::System_3_Trendline;
double c::Macd_Center_Buy;
double c::Macd_Center_Sell;
double c::Close_All_Profit_Percent;
double c::Break_Even_PIP;
bool c::Terminate;
bool c::Line_Normal_Trade;
string c::Web;
string c::Token;
string c::Greeting;
string c::ServerEND;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double LOTX;
	static double Percent_Cutloss;
	static double LOTB1;
	static double LOTS1;
	static double Near;
	static double ProfitPercent;
	static double Buy_count_no_last;
	static double Sell_count_no_last;
	static double Buy_Profit_no_Last;
	static double Sell_Profit_no_Last;
	static double LOTB2;
	static double LOTS2;
	static double mode;
	static int N_RSI_0_S;
	static int N_RSI_1_S;
	static int N_RSI_0_B;
	static int N_RSI_1_B;
	static double Near_RSI_B;
	static double Near_RSI_S;
	static int countb;
	static int counts;
	static double powb;
	static double pows;
	static double LOTBx;
	static double LOTSx;
	static double all_lotb;
	static double all_lots;
	static double avab;
	static double avas;
	static double tpb;
	static double tps;
	static string Market;
	static int accountx;
	static string message;
	static datetime now;
	static double lot;
	static double profit;
	static double openprice;
	static string Trades;
	static string symbol;
	static double LOT1;
	static double LOT2;
	static double LOTB3;
	static double LOTS3;
	static double LOTB4;
	static double LOTS4;
	static color Bucket_Buy;
	static int Bayb;
	static int Sum_Buy;
	static color Bucket_Sell;
	static int Sells;
	static int Sum_Sell;
	static double YNB1;
	static double YNS1;
	static double YMode;
	static double YNB0;
	static double YNS0;
};
double v::LOTX;
double v::Percent_Cutloss;
double v::LOTB1;
double v::LOTS1;
double v::Near;
double v::ProfitPercent;
double v::Buy_count_no_last;
double v::Sell_count_no_last;
double v::Buy_Profit_no_Last;
double v::Sell_Profit_no_Last;
double v::LOTB2;
double v::LOTS2;
double v::mode;
int v::N_RSI_0_S;
int v::N_RSI_1_S;
int v::N_RSI_0_B;
int v::N_RSI_1_B;
double v::Near_RSI_B;
double v::Near_RSI_S;
int v::countb;
int v::counts;
double v::powb;
double v::pows;
double v::LOTBx;
double v::LOTSx;
double v::all_lotb;
double v::all_lots;
double v::avab;
double v::avas;
double v::tpb;
double v::tps;
string v::Market;
int v::accountx;
string v::message;
datetime v::now;
double v::lot;
double v::profit;
double v::openprice;
string v::Trades;
string v::symbol;
double v::LOT1;
double v::LOT2;
double v::LOTB3;
double v::LOTS3;
double v::LOTB4;
double v::LOTS4;
color v::Bucket_Buy;
int v::Bayb;
int v::Sum_Buy;
color v::Bucket_Sell;
int v::Sells;
int v::Sum_Sell;
double v::YNB1;
double v::YNS1;
double v::YMode;
double v::YNB0;
double v::YNS0;



//--
// Externs (Global Variables)
input int inp3207_Ro_ZigZagDeviation = 0;
input int inp3207_Ro_ZigZagBackstep = 0;
class _externs
{
		public:
	static int inp3207_Ro_ZigZagDeviation;
	static int inp3207_Ro_ZigZagBackstep;
};
int _externs::inp3207_Ro_ZigZagDeviation;
int _externs::inp3207_Ro_ZigZagBackstep;



//VVVVVVVVVVVVVVVVVVVVVVVVV//
// System global variables //
//^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
int FXD_CURRENT_FUNCTION_ID = 0;
double FXD_MILS_INIT_END    = 0;
int FXD_TICKS_FROM_START    = 0;
int FXD_MORE_SHIFT          = 0;
bool FXD_DRAW_SPREAD_INFO   = false;
bool FXD_FIRST_TICK_PASSED  = false;
bool FXD_BREAK              = false;
bool FXD_CONTINUE           = false;
bool FXD_CHART_IS_OFFLINE   = false;
bool FXD_ONTIMER_TAKEN      = false;
bool FXD_ONTIMER_TAKEN_IN_MILLISECONDS = false;
double FXD_ONTIMER_TAKEN_TIME = 0;
bool USE_VIRTUAL_STOPS = VIRTUAL_STOPS_ENABLED;
string FXD_CURRENT_SYMBOL   = "";
int FXD_BLOCKS_COUNT        = 226;
datetime FXD_TICKSKIP_UNTIL = 0;

//- for use in OnChart() event
struct fxd_onchart
{
	int id;
	long lparam;
	double dparam;
	string sparam;
};
fxd_onchart FXD_ONCHART;

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
	c::Comment = Comment;
	c::ZZ_Depth = ZZ_Depth;
	c::Time_Frame = Time_Frame;
	c::Spread_Filter = Spread_Filter;
	c::MAX_Slippage_PIP = MAX_Slippage_PIP;
	c::LOT_Divided = LOT_Divided;
	c::Nearby_PIP = Nearby_PIP;
	c::Martingale_Multiple = Martingale_Multiple;
	c::Stop_Loss_Percent = Stop_Loss_Percent;
	c::System_1_MACD = System_1_MACD;
	c::System_2_RSI = System_2_RSI;
	c::System_3_Trendline = System_3_Trendline;
	c::Macd_Center_Buy = Macd_Center_Buy;
	c::Macd_Center_Sell = Macd_Center_Sell;
	c::Close_All_Profit_Percent = Close_All_Profit_Percent;
	c::Break_Even_PIP = Break_Even_PIP;
	c::Terminate = Terminate;
	c::Line_Normal_Trade = Line_Normal_Trade;
	c::Web = Web;
	c::Token = Token;
	c::Greeting = Greeting;
	c::ServerEND = ServerEND;
	c::MagicStart = MagicStart;




	// Initiate Externs
	_externs::inp3207_Ro_ZigZagDeviation = inp3207_Ro_ZigZagDeviation;
	_externs::inp3207_Ro_ZigZagBackstep = inp3207_Ro_ZigZagBackstep;



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

	v::LOTX = 0.0;
	v::Percent_Cutloss = 0.0;
	v::LOTB1 = 0.0;
	v::LOTS1 = 0.0;
	v::Near = 0.0;
	v::ProfitPercent = 0.0;
	v::Buy_count_no_last = 0.0;
	v::Sell_count_no_last = 0.0;
	v::Buy_Profit_no_Last = 0.0;
	v::Sell_Profit_no_Last = 0.0;
	v::LOTB2 = 0.0;
	v::LOTS2 = 0.0;
	v::mode = 0.0;
	v::N_RSI_0_S = 0;
	v::N_RSI_1_S = 0;
	v::N_RSI_0_B = 0;
	v::N_RSI_1_B = 0;
	v::Near_RSI_B = 0.0;
	v::Near_RSI_S = 0.0;
	v::countb = 0;
	v::counts = 0;
	v::powb = 0.0;
	v::pows = 0.0;
	v::LOTBx = 0.0;
	v::LOTSx = 0.0;
	v::all_lotb = 0.0;
	v::all_lots = 0.0;
	v::avab = 0.0;
	v::avas = 0.0;
	v::tpb = 0.0;
	v::tps = 0.0;
	v::Market = "";
	v::accountx = 0;
	v::message = "";
	v::now = 0;
	v::lot = 0.0;
	v::profit = 0.0;
	v::openprice = 0.0;
	v::Trades = "0";
	v::symbol = "0";
	v::LOT1 = 0.0;
	v::LOT2 = 0.0;
	v::LOTB3 = 0.0;
	v::LOTS3 = 0.0;
	v::LOTB4 = 0.0;
	v::LOTS4 = 0.0;
	v::Bucket_Buy = 0;
	v::Bayb = 0;
	v::Sum_Buy = 0;
	v::Bucket_Sell = 0;
	v::Sells = 0;
	v::Sum_Sell = 0;
	v::YNB1 = 0.0;
	v::YNS1 = 0.0;
	v::YMode = 0.0;
	v::YNB0 = 0.0;
	v::YNS0 = 0.0;




	Comment("");
	for (int i=ObjectsTotal(ChartID()); i>=0; i--)
	{
		string name = ObjectName(ChartID(), i);
		if (StringSubstr(name,0,8) == "fxd_cmnt") {ObjectDelete(ChartID(), name);}
	}
	ChartRedraw();



	//-- disable virtual stops in optimization, because graphical objects does not work
	// http://docs.mql4.com/runtime/testing
	if (MQLInfoInteger(MQL_OPTIMIZATION) || (MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE))) {
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

	//-- working with offline charts
	if (MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_EXPERT)
	{
		FXD_CHART_IS_OFFLINE = ChartGetInteger(0, CHART_IS_OFFLINE);
	}

	if (MQLInfoInteger(MQL_PROGRAM_TYPE) != PROGRAM_SCRIPT)
	{
		if (FXD_CHART_IS_OFFLINE == true || (ENABLE_EVENT_TRADE == 1 && ON_TRADE_REALTIME == 1))
		{
			FXD_ONTIMER_TAKEN = true;
			EventSetMillisecondTimer(1);
		}
		if (ENABLE_EVENT_TIMER) {
			OnTimerSet(ON_TIMER_PERIOD);
		}
	}


	//-- Initialize blocks classes
	ArrayResize(_blocks_, 226);

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
	int disabled_blocks_list[] = {206,207,208,209,210,211,212,213,214,215};
	for (int l = 0; l < ArraySize(disabled_blocks_list); l++) {
		_blocks_[disabled_blocks_list[l]].__disabled = true;
	}

	//-- run blocks
	int blocks_to_run[] = {1,136};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
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

	if (false) ExpirationWorker * expirationDummy = new ExpirationWorker();
	expirationWorker.Run();

	if (OrdersTotal()) // this makes things faster
	{
		OCODriver(); // Check and close OCO orders
	}

	if (ENABLE_EVENT_TRADE) {OnTrade();}

	FeedStatistics();


	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {2,6,24,27,57,78,79,96,97,175,176,187,188,189,201,203,208,212,215};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	return;
}



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on every tick, because it's not native for MQL4  //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTrade()
{
	// This is needed so that the OnTradeEventDetector class is added into the code
	if (false) OnTradeEventDetector * dummy = new OnTradeEventDetector();

	if (onTradeEventDetector.Start() == true)
	{
	//-- run blocks
	int blocks_to_run[] = {40,47,132,133,139,141,218,222,225};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}

	}

	onTradeEventDetector.End();

}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on a period basis //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTimer()
{
	//-- to simulate ticks in offline charts, Timer is used instead of infinite loop
	//-- the next function checks for changes in price and calls OnTick() manually
	if (FXD_CHART_IS_OFFLINE && RefreshRates()) {
		OnTick();
	}
	if (ON_TRADE_REALTIME == 1) {
		OnTrade();
	}

	static datetime t0 = 0;
	datetime t = 0;
	bool ok = false;

	if (FXD_ONTIMER_TAKEN)
	{
		if (FXD_ONTIMER_TAKEN_TIME > 0)
		{
			if (FXD_ONTIMER_TAKEN_IN_MILLISECONDS == true)
			{
				t = GetTickCount();
			}
			else
			{
				t = TimeLocal();
			}
			if ((t - t0) >= FXD_ONTIMER_TAKEN_TIME)
			{
				t0 = t;
				ok = true;
			}
		}

		if (ok == false) {
			return;
		}
	}

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

	//-- run blocks
	int blocks_to_run[] = {147};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


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
			case REASON_PROGRAM     : Print("Expert Advisor self terminated"); break;
			case REASON_REMOVE      : Print("Expert Advisor removed from the chart"); break;
			case REASON_RECOMPILE   : Print("Expert Advisor has been recompiled"); break;
			case REASON_CHARTCHANGE : Print("Symbol or chart period has been changed"); break;
			case REASON_CHARTCLOSE  : Print("Chart has been closed"); break;
			case REASON_PARAMETERS  : Print("Input parameters have been changed by a user"); break;
			case REASON_ACCOUNT     : Print("Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings"); break;
			case REASON_TEMPLATE    : Print("A new template has been applied"); break;
			case REASON_INITFAILED  : Print("OnInit() handler has returned a nonzero value"); break;
			case REASON_CLOSE       : Print("Terminal has been closed"); break;
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
// |	                                         Classes of blocks                                                    | //
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
		
		v::LOTX = formula(compare, lo, ro);
		
		_callback_(1);
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

// "If trade" model
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

// "Close trades" model
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
		
		v::Percent_Cutloss = formula(compare, lo, ro)/100;
		
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
		
		v::Percent_Cutloss = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Buy now" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename _T39_,typename T40,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename _T46_,typename T47,typename T48,typename T49,typename T50,typename T51,typename _T51_,typename T52,typename T53,typename T54>
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
	T12 mmTradesPool;
	T13 mmMgInitialLots;
	T14 mmMgMultiplyOnLoss;
	T15 mmMgMultiplyOnProfit;
	T16 mmMgAddLotsOnLoss;
	T17 mmMgAddLotsOnProfit;
	T18 mmMgResetOnLoss;
	T19 mmMgResetOnProfit;
	T20 mm1326InitialLots;
	T21 mm1326Reverse;
	T22 mmFiboInitialLots;
	T23 mmDalembertInitialLots;
	T24 mmDalembertReverse;
	T25 mmLabouchereInitialLots;
	T26 mmLabouchereList;
	T27 mmLabouchereReverse;
	T28 mmSeqBaseLots;
	T29 mmSeqOnLoss;
	T30 mmSeqOnProfit;
	T31 mmSeqReverse;
	T32 VolumeUpperLimit;
	T33 StopLossMode;
	T34 StopLossPips;
	T35 StopLossPercentPrice;
	T36 StopLossPercentTP;
	T37 dlStopLoss; virtual _T37_ _dlStopLoss_(){return(_T37_)0;}
	T38 dpStopLoss; virtual _T38_ _dpStopLoss_(){return(_T38_)0;}
	T39 ddStopLoss; virtual _T39_ _ddStopLoss_(){return(_T39_)0;}
	T40 TakeProfitMode;
	T41 TakeProfitPips;
	T42 TakeProfitPercentPrice;
	T43 TakeProfitPercentSL;
	T44 dlTakeProfit; virtual _T44_ _dlTakeProfit_(){return(_T44_)0;}
	T45 dpTakeProfit; virtual _T45_ _dpTakeProfit_(){return(_T45_)0;}
	T46 ddTakeProfit; virtual _T46_ _ddTakeProfit_(){return(_T46_)0;}
	T47 ExpMode;
	T48 ExpDays;
	T49 ExpHours;
	T50 ExpMinutes;
	T51 dExp; virtual _T51_ _dExp_(){return(_T51_)0;}
	T52 Slippage;
	T53 MyComment;
	T54 ArrowColorBuy;
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
		mmTradesPool = (int)0;
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
		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mmTradesPool, mm1326InitialLots, mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmTradesPool, mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmTradesPool, mmDalembertInitialLots, mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmTradesPool, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmTradesPool, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = BuyNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorBuy, exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Sell now" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename _T39_,typename T40,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename _T46_,typename T47,typename T48,typename T49,typename T50,typename T51,typename _T51_,typename T52,typename T53,typename T54>
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
	T12 mmTradesPool;
	T13 mmMgInitialLots;
	T14 mmMgMultiplyOnLoss;
	T15 mmMgMultiplyOnProfit;
	T16 mmMgAddLotsOnLoss;
	T17 mmMgAddLotsOnProfit;
	T18 mmMgResetOnLoss;
	T19 mmMgResetOnProfit;
	T20 mm1326InitialLots;
	T21 mm1326Reverse;
	T22 mmFiboInitialLots;
	T23 mmDalembertInitialLots;
	T24 mmDalembertReverse;
	T25 mmLabouchereInitialLots;
	T26 mmLabouchereList;
	T27 mmLabouchereReverse;
	T28 mmSeqBaseLots;
	T29 mmSeqOnLoss;
	T30 mmSeqOnProfit;
	T31 mmSeqReverse;
	T32 VolumeUpperLimit;
	T33 StopLossMode;
	T34 StopLossPips;
	T35 StopLossPercentPrice;
	T36 StopLossPercentTP;
	T37 dlStopLoss; virtual _T37_ _dlStopLoss_(){return(_T37_)0;}
	T38 dpStopLoss; virtual _T38_ _dpStopLoss_(){return(_T38_)0;}
	T39 ddStopLoss; virtual _T39_ _ddStopLoss_(){return(_T39_)0;}
	T40 TakeProfitMode;
	T41 TakeProfitPips;
	T42 TakeProfitPercentPrice;
	T43 TakeProfitPercentSL;
	T44 dlTakeProfit; virtual _T44_ _dlTakeProfit_(){return(_T44_)0;}
	T45 dpTakeProfit; virtual _T45_ _dpTakeProfit_(){return(_T45_)0;}
	T46 ddTakeProfit; virtual _T46_ _ddTakeProfit_(){return(_T46_)0;}
	T47 ExpMode;
	T48 ExpDays;
	T49 ExpHours;
	T50 ExpMinutes;
	T51 dExp; virtual _T51_ _dExp_(){return(_T51_)0;}
	T52 Slippage;
	T53 MyComment;
	T54 ArrowColorSell;
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
		mmTradesPool = (int)0;
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
		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mmTradesPool, mm1326InitialLots, mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmTradesPool, mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmTradesPool, mmDalembertInitialLots, mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmTradesPool, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmTradesPool, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = SellNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorSell, exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
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

// "For each Trade" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10>
class MDL_LoopStartTrades: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 LoopDirection;
	T7 LoopSkip;
	T8 LoopEvery;
	T9 LoopLimit;
	T10 PassEnd;
	/* Static Parameters */
	double trades[][2];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopStartTrades()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		LoopDirection = (string)"newest-to-oldest";
		LoopSkip = (int)0;
		LoopEvery = (int)0;
		LoopLimit = (int)0;
		PassEnd = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// used when sorting by profit
		
		int saved_type     = attrTypeInLoop();
		ulong saved_ticket = attrTicketInLoop(); // This ticket number will be reloaded at the end of this loop, so if we are in another overlapping loop - it will continue using it's last used ticket number
		
		int total = TradesTotal();
		int count = 0;
		int skip  = -1;
		int every = 0;
		
		bool get_from_array = false;
		
		int i_start = 0, i_stop = 0, i_inc = 0, i = 0;
		
		if (LoopDirection == "newest-to-oldest")
		{
			i_start = total-1;
			i_stop  = 0;
			i_inc   = -1;
		}
		else if (LoopDirection == "oldest-to-newest")
		{
		  	i_start = 0;
			i_stop  = total-1;
			i_inc   = 1;
		}
		else if (LoopDirection == "profitable-first" || LoopDirection == "profitable-last")
		{
			int last_index = -1;
			get_from_array = true;
			
			// Collect data
			ArrayResize(trades,0);
			int size = 0;
		
			for (int pos=0; pos < total; pos++)
			{
				if (!TradeSelectByIndex(pos, GroupMode, Group, SymbolMode, Symbol, BuysOrSells)) continue;
		
				size++;
				ArrayResize(trades,size);
		
				trades[size-1][0] = OrderProfit();
				trades[size-1][1] = (double)OrderTicket();
			}
		
			// Sort
			if (size > 0)
			{
				ArraySort(trades);
				last_index = size - 1;
			}
		
			// At this moment the array is sorted starting from the least profitable trade
		
			i_start = last_index;
			i_stop  = 0;
			i_inc   = -1;
			
			if (LoopDirection == "profitable-last")
			{
				i_start = 0;
				i_stop  = last_index;
				i_inc   = 1;
			}
		}
		
		i = i_start - i_inc;
		
		while (true)
		{
		  	if (i == i_stop) break;
		  	i = i + i_inc;
			
			// simulate break and continue functionality in loop blocks
			if (FXD_CONTINUE == true)
			{
				FXD_BREAK    = false;
				FXD_CONTINUE = false;
			}
			else if (FXD_BREAK == true)
			{
				FXD_BREAK    = false;
				FXD_CONTINUE = false;
				break;
			}
			
			if (get_from_array)
			{
				if (!TradeSelectByTicket((ulong)trades[i][1])) continue;
			}
			else
			{
				if (!TradeSelectByIndex(i, GroupMode, Group, SymbolMode, Symbol, BuysOrSells)) continue;
			}
		
			skip++;
		
			if (LoopSkip <= skip && (count < LoopLimit || LoopLimit == 0))
			{
				if (LoopEvery > 0)
				{
					every++;
		
					if (every < LoopEvery) {continue;} else {every = 0;}
				}
				
				count++;
				attrTypeInLoop(1);
				attrTicketInLoop(OrderTicket());
		
				_callback_(1);
				
				if (count == LoopLimit) break;
			}
			
			if (LoopDirection == "oldest-to-newest")
			{
				// if trade was closed meanwhile
				if (i_stop > TradesTotal()-1)
				{
					i_stop = TradesTotal()-1;
					i--;
				}
			}
		}
		
		attrTypeInLoop(saved_type);
		attrTicketInLoop(saved_ticket); // Reloading Ticket number from the overlapping loop (if any)
		
		FXD_BREAK    = false;
		FXD_CONTINUE = false;
		
		if (
			   (PassEnd == 0)
			|| (PassEnd == 1 && count > 0)
			|| (PassEnd == 2 && count == 0)
		) {
			_callback_(0);
		}
	}
};

// "Once per bar" model
template<typename T1,typename T2,typename T3>
class MDL_OncePerBar: public BlockCalls
{
	public: /* Input Parameters */
	T1 Symbol;
	T2 Period;
	T3 PassMaxTimes;
	/* Static Parameters */
	string tokens[];
	int passes[];
	datetime old_values[];
	datetime time[];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_OncePerBar()
	{
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		PassMaxTimes = (int)1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// this is static for speed reasons
		
		bool next    = false;
		string token = Symbol + IntegerToString(Period);
		int index    = ArraySearch(tokens, token);
		
		if (index == -1)
		{
			index = ArraySize(tokens);
			
			ArrayResize(tokens, index + 1);
			ArrayResize(old_values, index + 1);
			ArrayResize(passes, index + 1);
			
			tokens[index] = token;
			passes[index] = 0;
			old_values[index] = 0;
		}
		
		if (PassMaxTimes > 0)
		{
			CopyTime(Symbol, Period, 1, 1, time);
			datetime new_value = time[0];
		
			if (new_value > old_values[index])
			{
				passes[index]++;
		
				if (passes[index] >= PassMaxTimes)
				{
					old_values[index]  = new_value;
					passes[index] = 0;
				}
		
				next = true;
			}
		}
		
		if (next) {_callback_(1);} else {_callback_(0);}
	}
};

// "Spread Filter" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>
class MDL_Spreadfilter: public BlockCalls
{
	public: /* Input Parameters */
	T1 Symbol;
	T2 SpreadCompare;
	T3 SpreadFilterMode;
	T4 maxSpread;
	T5 AvgSpreadPeriodSeconds;
	T6 AvgSpreadAdjust;
	/* Static Parameters */
	datetime utctime_data[];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Spreadfilter()
	{
		Symbol = (string)CurrentSymbol();
		SpreadCompare = (string)"<";
		SpreadFilterMode = (string)"fixed";
		maxSpread = (double)5.0;
		AvgSpreadPeriodSeconds = (int)10;
		AvgSpreadAdjust = (double)0.0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// Array that holds UTC times
		static double	spreads_data[];   // Array that holds spreads
		static int		current_pos = -1; // Arrays are dynamic, this is the array index where the newest record is located
		static int		max_depth   = 50;	
		
		double compare_with_spread = 0;
		double current_spread      = SymbolInfoDouble(Symbol, SYMBOL_ASK)-SymbolInfoDouble(Symbol, SYMBOL_BID);
		int digits                 = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
		
		if (SpreadFilterMode != "average")
		{
			compare_with_spread = toDigits(maxSpread, Symbol);
		}
		else
		{
			bool debug   = false;
			datetime now = TimeCurrent();
			int first_unassigned_address = 0;
		
			// What is the current amount of spread values that can be holded?
			int array_size = ArraySize(utctime_data);
		
			// Increase that amount if it is too small
			if (array_size < max_depth * 2)
			{
				first_unassigned_address = array_size;
				array_size               = max_depth * 2;
		
				if (debug) Print("Spread filter (block #",__block_user_number,"). Increasing buffer size to ",array_size," elements");
		
				ArrayResize(utctime_data, array_size);
				ArrayResize(spreads_data, array_size);
				
				// pre-assign some values, otherwise the arrays contain random values and can confuse the results
				for (int i = first_unassigned_address; i < array_size; i++)
				{
					utctime_data[i] = 0;
					spreads_data[i] = 0;
				}
			}
		
			// Update the position of the current spread value
			current_pos = current_pos + 1;
		
			if (current_pos >= array_size)
			{
				current_pos = 0;
			}
		
			// Update the database information
			utctime_data[current_pos] = now;
			spreads_data[current_pos] = NormalizeDouble(current_spread, digits);
		
			datetime old_time     = now - AvgSpreadPeriodSeconds; // This is the oldest time index to calculate average spread for. In database, we don't need older spreads_data.
			int pos               = current_pos + 1; // Initial position before the loop
			double avg_spread     = 0; // Average spread calculated
			int ticks             = 0; // How many spread values we have in database for the needed time AvgSpreadTimePeriodSeconds
			datetime diff_reached = 0; // If we didn't reach the oldest time we need in the whole database, this is the time difference between now and the oldest time recorded.
		
			if (debug) Print("============ tick ",FXD_TICKS_FROM_START," ============");
			
			while(!IsStopped())
			{
				// Oldest spread record is located at the next smallest array element
				pos = pos - 1;
		
				if (pos < 0) {pos = array_size - 1;}
				
				// This is the oldest array element, which is actually the current one + 1
				int next_pos = current_pos + 1;
		
				if (next_pos >= array_size)
				{
					next_pos = array_size - 1;
				}
				
				// Time record is empty
				if (utctime_data[pos] == 0)
				{
					if (pos == next_pos) {break;} // End of database - exit;
		
					continue; // In case of fresh added empty values at the physical end of the array, we need to skip them
				}
				
				// Reached oldest point - exit before calculations
				if (utctime_data[pos] < old_time) {break;}
				
				// Calculations
				ticks++;
				avg_spread += spreads_data[pos];
		
				if (debug) Print(utctime_data[pos], " => ", toPips(spreads_data[pos], Symbol), " pips");
				
				// End of database reached - obviously the array is too small
				if (pos == next_pos)
				{
					diff_reached = now - utctime_data[pos]; // The time range available in the database
		
					if (diff_reached == 0) {break;}
		
					ticks = ticks * (int)(AvgSpreadPeriodSeconds / diff_reached);
		
					if (debug) Print("Spread Filter (block #", __block_user_number, "). Buffer size will be increased to ", IntegerToString(ticks*2), " elements");
		
					break;
				}
			}
			
			avg_spread = (ticks > 0) ? avg_spread / ticks : current_spread;
			avg_spread = NormalizeDouble(avg_spread, digits);
		
			if (ticks > max_depth) {max_depth = ticks;}
			
			compare_with_spread = avg_spread + toDigits(AvgSpreadAdjust, Symbol);
			
			if (debug) Print("For the last ", AvgSpreadPeriodSeconds, " seconds the average spread is ", toPips(avg_spread, Symbol), " pips. It is calculated from ", ticks, " array elements.");
		}
		
		current_spread      = NormalizeDouble(current_spread, digits);
		compare_with_spread = NormalizeDouble(compare_with_spread, digits);
		
		if (CompareValues(SpreadCompare, current_spread, compare_with_spread)) {_callback_(1);} else {_callback_(0);}
	}
};

// "No trade" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_NoOpenedOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_NoOpenedOrders()
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
		
		if (exist == false) {_callback_(1);} else {_callback_(0);}
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
		
		v::LOTB1 = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_5: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_5()
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
		
		v::LOTS1 = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "No trade nearby" model
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_6: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_6()
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
		
		v::Near = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_7: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_7()
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
		
		v::Near = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_8: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_8()
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
		
		v::ProfitPercent = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Bucket of Trades" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>
class MDL_BucketSelectOpened: public BlockCalls
{
	public: /* Input Parameters */
	T1 BucketID;
	T2 GroupMode;
	T3 Group;
	T4 SymbolMode;
	T5 Symbol;
	T6 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_BucketSelectOpened()
	{
		BucketID = (color)clrGray;
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int list[];
		double sortexp[];
		int s = 0;
		
		int i_start = TradesTotal()-1;
		int i_stop  = 0;
		int i_inc   = -1;
		
		int pool = 0;
		int i    = i_start - i_inc;
		
		while (true)
		{
			if (i == i_stop) {break;}
			i = i + i_inc;	
		
			if (TradeSelectByIndex(i, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				ArrayResize(list, s+1);
		
				list[s] = (int)OrderTicket();
				s++;
			}
		}
		
		BucketsOfOrders(BucketID, list, pool, true);
		
		if (s > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_9: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_9()
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
		
		v::Buy_Profit_no_Last = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "once per trade/order" model
template<typename T1>
class MDL_LoopOncePer: public BlockCalls
{
	public: /* Input Parameters */
	T1 AllowOldOrders;
	/* Static Parameters */
	int memory[];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopOncePer()
	{
		AllowOldOrders = (bool)false;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK==true) {return;}
		
		LoopedResume();
		
		
		
		bool next = false;
		
		if (AllowOldOrders || OrderOpenTime() >= TimeAtStart())
		{
		   int ticket = (int)attrTicketParent(OrderTicket());
		
		   if (InArray(memory, ticket) == false)
			{
		      ArrayEnsureValue(memory, ticket);
		      next = true;
		   }
		}
		
		if (next == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "close" model
template<typename T1,typename T2>
class MDL_LoopClose: public BlockCalls
{
	public: /* Input Parameters */
	T1 Slippage;
	T2 ArrowColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopClose()
	{
		Slippage = (ulong)4;
		ArrowColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK == true) {return;}
		
		LoopedResume();
		
		bool success = false;
		
		if (OrderType() < 2) {
		   success = CloseTrade(OrderTicket(), Slippage, ArrowColor);
		}
		else {
		   success = DeleteOrder(OrderTicket(), ArrowColor);
		}
		
		if (success == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_10: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_10()
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
		
		v::ProfitPercent = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_11: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_11()
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
		
		v::Sell_Profit_no_Last = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Comment" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename T18,typename T19,typename T20,typename _T20_,typename T21,typename T22,typename T23,typename T24,typename _T24_,typename T25,typename T26,typename T27,typename T28,typename _T28_,typename T29,typename T30,typename T31,typename T32,typename _T32_,typename T33,typename T34,typename T35,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename _T40_,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename T46>
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
	T17 FormatNumber1;
	T18 FormatTime1;
	T19 Label2;
	T20 Value2; virtual _T20_ _Value2_(){return(_T20_)0;}
	T21 FormatNumber2;
	T22 FormatTime2;
	T23 Label3;
	T24 Value3; virtual _T24_ _Value3_(){return(_T24_)0;}
	T25 FormatNumber3;
	T26 FormatTime3;
	T27 Label4;
	T28 Value4; virtual _T28_ _Value4_(){return(_T28_)0;}
	T29 FormatNumber4;
	T30 FormatTime4;
	T31 Label5;
	T32 Value5; virtual _T32_ _Value5_(){return(_T32_)0;}
	T33 FormatNumber5;
	T34 FormatTime5;
	T35 Label6;
	T36 Value6; virtual _T36_ _Value6_(){return(_T36_)0;}
	T37 FormatNumber6;
	T38 FormatTime6;
	T39 Label7;
	T40 Value7; virtual _T40_ _Value7_(){return(_T40_)0;}
	T41 FormatNumber7;
	T42 FormatTime7;
	T43 Label8;
	T44 Value8; virtual _T44_ _Value8_(){return(_T44_)0;}
	T45 FormatNumber8;
	T46 FormatTime8;
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
		FormatNumber1 = (int)EMPTY_VALUE;
		FormatTime1 = (int)EMPTY_VALUE;
		Label2 = (string)"";
		FormatNumber2 = (int)EMPTY_VALUE;
		FormatTime2 = (int)EMPTY_VALUE;
		Label3 = (string)"";
		FormatNumber3 = (int)EMPTY_VALUE;
		FormatTime3 = (int)EMPTY_VALUE;
		Label4 = (string)"";
		FormatNumber4 = (int)EMPTY_VALUE;
		FormatTime4 = (int)EMPTY_VALUE;
		Label5 = (string)"";
		FormatNumber5 = (int)EMPTY_VALUE;
		FormatTime5 = (int)EMPTY_VALUE;
		Label6 = (string)"";
		FormatNumber6 = (int)EMPTY_VALUE;
		FormatTime6 = (int)EMPTY_VALUE;
		Label7 = (string)"";
		FormatNumber7 = (int)EMPTY_VALUE;
		FormatTime7 = (int)EMPTY_VALUE;
		Label8 = (string)"";
		FormatNumber8 = (int)EMPTY_VALUE;
		FormatTime8 = (int)EMPTY_VALUE;
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
						case 1:
						{
							if (Label1 != "")
							{
								textlbl = Label1;
								text    = FormatValueForPrinting(_Value1_(), FormatNumber1, FormatTime1);
							}
		
							break;
						}
						case 2:
						{
							if (Label2 != "")
							{
								textlbl = Label2;
								text    = FormatValueForPrinting(_Value2_(), FormatNumber2, FormatTime2);
							}
		
							break;
						}
						case 3:
						{
							if (Label3 != "")
							{
								textlbl = Label3;
								text    = FormatValueForPrinting(_Value3_(), FormatNumber3, FormatTime3);
							}
		
							break;
						}
						case 4:
						{
							if (Label4 != "")
							{
								textlbl = Label4;
								text    = FormatValueForPrinting(_Value4_(), FormatNumber4, FormatTime4);
							}
		
							break;
						}
						case 5:
						{
							if (Label5 != "")
							{
								textlbl = Label5;
								text    = FormatValueForPrinting(_Value5_(), FormatNumber5, FormatTime5);
							}
		
							break;
						}
						case 6:
						{
							if (Label6 != "")
							{
								textlbl = Label6;
								text    = FormatValueForPrinting(_Value6_(), FormatNumber6, FormatTime6);
							}
		
							break;
						}
						case 7:
						{
							if (Label7 != "")
							{
								textlbl = Label7;
								text    = FormatValueForPrinting(_Value7_(), FormatNumber7, FormatTime7);
							}
		
							break;
						}
						case 8:
						{
							if (Label8 != "")
							{
								textlbl = Label8;
								text    = FormatValueForPrinting(_Value8_(), FormatNumber8, FormatTime8);
							}
		
							break;
						}
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
					if (ObjectFind(ObjChartID, name) < 0)
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_12: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_12()
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
		
		v::N_RSI_0_B = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_13: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_13()
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
		
		v::N_RSI_1_B = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_14: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_14()
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
		
		v::N_RSI_0_S = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_15: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_15()
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
		
		v::N_RSI_1_S = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "AND" model
class MDL_LogicalAND: public BlockCalls
{
	/* Static Parameters */
	int list[];
	int check[];
	int list_size;
	int old_tick;
	bool passed;
	virtual void _callback_(int r) {return;}

	public: /* The main method */
	virtual void _execute_()
	{
		bool go_to_next = false;
		
		if (!passed)
		{
			fxdGetInboundBlocks(__block_number, list);
		   list_size = ArraySize(list);
			passed = true;
		}
		
		if (list_size == 0)
		{
		   // This block is at the very top => pass everytime
		   go_to_next = true;
		}
		else
		{
		   // This block is child
		   int ticks = FXD_TICKS_FROM_START;
		   
			if (old_tick != ticks)
			{
				old_tick = ticks;
		      ArrayResize(check, 0); // reset
		   }
			
		   if (
				   ArraySearch(list, __parent_number) > -1
				&& ArraySearch(check, __parent_number) == -1
			)
			{
		      ArrayEnsureValue(check, __parent_number); // add current parent
				
		      if (list_size == ArraySize(check))
				{
					go_to_next = true;
				}
		   }
		   
		}
		
		if (go_to_next == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Draw Line" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename _T8_,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21>
class MDL_ChartDrawLine: public BlockCalls
{
	public: /* Input Parameters */
	T1 ObjectPerBar;
	T2 ObjectUpdate;
	T3 ObjName;
	T4 ObjectType;
	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}
	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}
	T7 ObjTime2; virtual _T7_ _ObjTime2_(){return(_T7_)0;}
	T8 ObjPrice2; virtual _T8_ _ObjPrice2_(){return(_T8_)0;}
	T9 ObjAngle;
	T10 ObjRay;
	T11 ObjRayLeft;
	T12 ObjRayRight;
	T13 ObjColor;
	T14 ObjStyle;
	T15 ObjWidth;
	T16 ObjBack;
	T17 ObjSelectable;
	T18 ObjSelected;
	T19 ObjHidden;
	T20 ObjZorder;
	T21 ObjChartSubWindow;
	/* Static Parameters */
	int count;
	datetime time0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDrawLine()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_VLINE;
		ObjAngle = (double)45.0;
		ObjRay = (bool)true;
		ObjRayLeft = (bool)false;
		ObjRayRight = (bool)false;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
		ObjWidth = (int)1;
		ObjBack = (bool)false;
		ObjSelectable = (bool)true;
		ObjSelected = (bool)false;
		ObjHidden = (bool)false;
		ObjZorder = (int)0;
		ObjChartSubWindow = (string)"";
		/* Static Parameters (initial value) */
		count =  0;
		time0 =  0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		string ObjNamePrefix = "fxd_line_";
		long ObjChartID      = 0;
		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);
		
		if (subwindow_id >= 0)
		{
			string name       = "";
			string name_base  = "";
			bool get_new_name = false;
			bool do_update    = true;
		
			if (ObjectPerBar == true)
			{
				datetime time = iTime(Symbol(),0,1);
		
				if (time0 < time)
				{
					time0        = time;
					get_new_name = true;
				}
				else
				{
					if (ObjectUpdate == false) {do_update = false;}
				}
			}
			else
			{
				if (ObjectUpdate == false) {get_new_name = true;}
			}
		
			if (do_update)
			{
				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}
		
				if (get_new_name == false)
				{
					name = name_base + IntegerToString(count);
				}
				else
				{
					while (true)
					{
						count++;
						name = name_base + IntegerToString(count);
		
						if (ObjectFind(ObjChartID,name) < 0) {break;}
					}
				}
		
				if (ObjName != "" && count == 0) {name = ObjName;}
		
				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,(ENUM_OBJECT)ObjectType,subwindow_id,0,0))
				{
					Print(__FUNCTION__,": failed to create line object! Error code = ",GetLastError());
				}
		
				double p1=0, p2=0;
				datetime t1=0, t2=0;
		
				switch(ObjectType)
				{
					case OBJ_VLINE        : {t1=1; break;}
					case OBJ_HLINE        : {p1=1; break;}
					case OBJ_TREND        : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_TRENDBYANGLE : {t1=1; p1=1; break;}
					case OBJ_CYCLES       : {t1=1; p1=1; t2=1; p2=1; break;}
				}
		
				if (t1 == 1) {t1 = _ObjTime1_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,t1);}
				if (t2 == 1) {t2 = _ObjTime2_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,1,t2);}
				if (p1 == 1) {p1 = _ObjPrice1_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,p1);}
				if (p2 == 1) {p2 = _ObjPrice2_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,1,p2);}
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);
				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);
		
				ObjectSetDouble(ObjChartID,name,OBJPROP_ANGLE,ObjAngle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY,ObjRay);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_LEFT,ObjRayLeft);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_RIGHT,ObjRayRight);
		
				ChartRedraw();
			}
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_16: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_16()
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
		
		v::Near_RSI_B = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_17: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_17()
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
		
		v::Near_RSI_S = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_18: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_18()
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
		
		v::LOTBx = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_19: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_19()
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
		
		v::LOTSx = formula(compare, lo, ro);
		
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_20: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_20()
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
		
		v::all_lotb = formula(compare, lo, ro)/10;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_21: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_21()
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
		
		v::avab = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_22: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_22()
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
		
		v::tpb = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Modify stops of trades" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename _T8_,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename _T15_,typename T16>
class MDL_ModifyOpened: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 OrderMinutes;
	T7 RelativeTo;
	T8 fRelativePrice; virtual _T8_ _fRelativePrice_(){return(_T8_)0;}
	T9 NewSLTPmode;
	T10 NewStopLoss;
	T11 NewStopLossPercent;
	T12 fNewStopLoss; virtual _T12_ _fNewStopLoss_(){return(_T12_)0;}
	T13 NewTakeProfit;
	T14 NewTakeProfitPercent;
	T15 fNewTakeProfit; virtual _T15_ _fNewTakeProfit_(){return(_T15_)0;}
	T16 LevelColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ModifyOpened()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		OrderMinutes = (int)0;
		RelativeTo = (string)"openprice";
		NewSLTPmode = (string)"fixed";
		NewStopLoss = (double)50.0;
		NewStopLossPercent = (double)50.0;
		NewTakeProfit = (double)50.0;
		NewTakeProfitPercent = (double)50.0;
		LevelColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				datetime time_diff = TimeCurrent() - OrderOpenTime();
		
				if (time_diff < 0) {time_diff = 0;} // this actually happens sometimes
		
				if (time_diff >= 60 * OrderMinutes)
				{
					string symbol = OrderSymbol();
		
					int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
					double oldSL = NormalizeDouble(attrStopLoss(), digits);
					double oldTP = NormalizeDouble(attrTakeProfit(), digits);
					double OP    = NormalizeDouble(OrderOpenPrice(), digits);
		
					//-- What is the reference price?
					double price = 0;
		
					if (RelativeTo == "openprice")
					{
						price = OP;
					}
					else if (RelativeTo == "customPrice")
					{
						price = _fRelativePrice_();
					}
					else
					{
						price = (OrderType() == 0) ? SymbolInfoDouble(symbol, SYMBOL_ASK) : SymbolInfoDouble(symbol, SYMBOL_BID);
					}
		
					//-- Calculate the new SL and TP
					double SL = 0;
					double TP = 0;
		
					if (NewSLTPmode == "fixed")
					{
						SL = toDigits(NewStopLoss, symbol);
						TP = toDigits(NewTakeProfit, symbol);
		
						if (OrderType() == 0)
						{
							if (SL != 0) {SL = price - SL;}
							if (TP != 0) {TP = price + TP;}
						}
						else
						{
							if (SL != 0) {SL = price + SL;}
							if (TP != 0) {TP = price - TP;}
						}
					}
					else if (NewSLTPmode == "percent")
					{
						if (OrderType() == 0)
						{
							SL = price - (((OP - oldSL) * NewStopLossPercent) / 100);
							TP = price + (((oldTP - OP) * NewTakeProfitPercent) / 100);
						}
						else
						{
							SL = price + (((oldSL - OP) * NewStopLossPercent) / 100);
							TP = price - (((OP - oldTP) * NewTakeProfitPercent) / 100);
						}
					}
					else if (NewSLTPmode == "function")
					{
						SL = _fNewStopLoss_();
						TP = _fNewTakeProfit_();
					}
		
					SL = NormalizeDouble(SL, digits);
					TP = NormalizeDouble(TP, digits);
		
					if (SL != oldSL || TP != oldTP)
					{
						ModifyStops(OrderTicket(), SL, TP, LevelColor);
					}
				}
			}
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_23: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_23()
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
		
		v::all_lots = formula(compare, lo, ro)/10;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_24: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_24()
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
		
		v::avas = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_25: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_25()
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
		
		v::tps = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Check trades count" model
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

// "Terminate" model
template<typename T1>
class MDL_Terminate: public BlockCalls
{
	public: /* Input Parameters */
	T1 Message;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Terminate()
	{
		Message = (string)"Program Terminated Itself";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (Message != "")
		{
		   MessageBox(Message, "Self-Terminate", MB_OK);
		}
		
		ExpertRemove();
		ChartRedraw(); // to remove the smile face
	}
};

// "Trade created" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_eTrade_TradeNew: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eTrade_TradeNew()
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
		if (
			   (e_Reason() == "new")
			&& (e_attrType() < 2)
			&& (FilterEventTrade(GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			)
		{_callback_(1);} else {_callback_(0);}
	}
};

// "Counter: Pass once" model
template<typename T1>
class MDL_PassOnce: public BlockCalls
{
	public: /* Input Parameters */
	T1 CounterID;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_PassOnce()
	{
		CounterID = (int)1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int passes = Counter(CounterID, "increment");
		
		if (passes == 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Counter: Reset" model
template<typename T1>
class MDL_CounterReset: public BlockCalls
{
	public: /* Input Parameters */
	T1 ResetThisID;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CounterReset()
	{
		ResetThisID = (string)"1";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		string list[];
		StringExplode(",", ResetThisID, list);
		int size = ArraySize(list);
		
		for (int i=0; i<size; i++)
		{
			list[i] = StringTrim(list[i]);
			Counter((int)StringToInteger(list[i]), "reset");
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_26: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_26()
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
		
		v::YNB1 = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_27: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_27()
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
		
		v::YNS1 = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_28: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_28()
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
		
		v::YNB0 = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_29: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_29()
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
		
		v::YNS0 = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Delete objects" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>
class MDL_ChartDeleteObjects: public BlockCalls
{
	public: /* Input Parameters */
	T1 NameStartsWith;
	T2 NameContains;
	T3 ObjColor;
	T4 SortMode;
	T5 MaxObjects;
	T6 SkipObjects;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDeleteObjects()
	{
		NameStartsWith = (string)"";
		NameContains = (string)"";
		ObjColor = (color)EMPTY_VALUE;
		SortMode = (string)"z-a";
		MaxObjects = (int)0;
		SkipObjects = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// TODO: Combine "a-z" and "z-a" loops into one loop
		// TODO: Fix the problem with "Any color" and the EMPTY_VALUE value
		
		int index         = 0;
		int total         = ObjectsTotal(0,-1,-1);
		int length        = 0;
		bool deleted      = false;
		int deleted_count = 0;
		int skipped_count = 0;
		string name       = "";
		
		if (SortMode == "a-z")
		{
			for (index=0; index<total; index++)
			{
				name = ObjectName(0,index);
		
				if (name != "")
				{
					if (MaxObjects > 0 && deleted_count >= MaxObjects) {break;}
		
					deleted = false;
		
					// ObjColor != clrBlack below is because in MQL5 when the value is EMPTY_VALUE, it is turned into clrBlack because of the data type
					if (ObjColor != EMPTY_VALUE && ObjColor != clrBlack && ObjectGetInteger(0, name, OBJPROP_COLOR) != ObjColor) {continue;}
		
					if (NameStartsWith == "" && NameContains == "")
					{
						if (SkipObjects > 0 && skipped_count < SkipObjects)
						{
							skipped_count++;
							continue;
						}
		
						if (ObjectDelete(0,name))
						{
							deleted_count++;
						}
					}
					else
					{
						if (NameStartsWith != "")
						{
							length = StringLen(NameStartsWith);
		
							if (StringSubstr(name,0,length) == NameStartsWith)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
		
						if (deleted == false && NameContains != "")
						{
							if (StringFind(name,NameContains,0) > -1)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
					}
				}
			}
		}
		else if (SortMode == "z-a")
		{
			for (index=total-1; index>=0; index--)
			{
				name = ObjectName(0,index);
		
				if (name != "")
				{
					if (MaxObjects > 0 && deleted_count >= MaxObjects) {break;}
		
					deleted = false;
		
					// ObjColor != clrBlack below is because in MQL5 when the value is EMPTY_VALUE, it is turned into clrBlack because of the data type
					if (ObjColor != EMPTY_VALUE && ObjColor != clrBlack && ObjectGetInteger(0, name, OBJPROP_COLOR) != ObjColor) {continue;}
		
					if (NameStartsWith == "" && NameContains == "")
					{
						if (SkipObjects > 0 && skipped_count < SkipObjects)
						{
							skipped_count++;
							continue;
						}
		
						if (ObjectDelete(0,name))
						{
							deleted_count++;
						}
					}
					else
					{
						if (NameStartsWith != "")
						{
							length = StringLen(NameStartsWith);
		
							if (StringSubstr(name,0,length) == NameStartsWith)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
		
						if (deleted == false && NameContains != "")
						{
							if (StringFind(name,NameContains,0) > -1)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
					}
				}
			}
		}
		
		if (deleted_count > 0)
		{
			ChartRedraw();
		}
		
		_callback_(1);
	}
};

// "Sell pending order" model
template<typename T1,typename T2,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename _T27_,typename T28,typename _T28_,typename T29,typename _T29_,typename T30,typename T31,typename T32,typename T33,typename T34,typename _T34_,typename T35,typename _T35_,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename T41,typename _T41_,typename T42,typename T43,typename T44,typename T45>
class MDL_SellPending: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 Price;
	T4 dPrice; virtual _T4_ _dPrice_(){return(_T4_)0;}
	T5 PriceOffset;
	T6 VolumeMode;
	T7 VolumeSize;
	T8 VolumeSizeRisk;
	T9 VolumeRisk;
	T10 VolumePercent;
	T11 VolumeBlockPercent;
	T12 dVolumeSize; virtual _T12_ _dVolumeSize_(){return(_T12_)0;}
	T13 FixedRatioUnitSize;
	T14 FixedRatioDelta;
	T15 mmMgInitialLots;
	T16 mmMgMultiplyOnLoss;
	T17 mmMgMultiplyOnProfit;
	T18 mmMgAddLotsOnLoss;
	T19 mmMgAddLotsOnProfit;
	T20 mmMgResetOnLoss;
	T21 mmMgResetOnProfit;
	T22 VolumeUpperLimit;
	T23 StopLossMode;
	T24 StopLossPips;
	T25 StopLossPercentPrice;
	T26 StopLossPercentTP;
	T27 dlStopLoss; virtual _T27_ _dlStopLoss_(){return(_T27_)0;}
	T28 dpStopLoss; virtual _T28_ _dpStopLoss_(){return(_T28_)0;}
	T29 ddStopLoss; virtual _T29_ _ddStopLoss_(){return(_T29_)0;}
	T30 TakeProfitMode;
	T31 TakeProfitPips;
	T32 TakeProfitPercentPrice;
	T33 TakeProfitPercentSL;
	T34 dlTakeProfit; virtual _T34_ _dlTakeProfit_(){return(_T34_)0;}
	T35 ddTakeProfit; virtual _T35_ _ddTakeProfit_(){return(_T35_)0;}
	T36 dpTakeProfit; virtual _T36_ _dpTakeProfit_(){return(_T36_)0;}
	T37 ExpMode;
	T38 ExpDays;
	T39 ExpHours;
	T40 ExpMinutes;
	T41 dExp; virtual _T41_ _dExp_(){return(_T41_)0;}
	T42 CreateOCO;
	T43 Slippage;
	T44 MyComment;
	T45 ArrowColorSell;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_SellPending()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		Price = (string)"bid";
		PriceOffset = (double)20.0;
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
		CreateOCO = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorSell = (color)clrRed;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- open price -------------------------------------------------------------
		double op = 0;
		
		     if (Price == "ask")     {op = SymbolAsk(Symbol);}
		else if (Price == "bid")     {op = SymbolBid(Symbol);}
		else if (Price == "mid")     {op = (SymbolAsk(Symbol)+SymbolBid(Symbol))/2;}
		else if (Price == "dynamic") {op = _dPrice_();}
		
		op = op - toDigits(PriceOffset, Symbol);
		
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = op + (op * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = op - (op * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP")
		{
			if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
			if (tpl > 0) {slp = toPips(MathAbs(op - tpl), Symbol)*StopLossPercentTP/100;}
		}
		
		if (TakeProfitMode == "percentSL")
		{
			if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
			if (sll > 0) {tpp = toPips(MathAbs(op - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots    = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {pre_sll = op;}
		
		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-op, Symbol);
		
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
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, 0, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		//-- expiration -------------------------------------------------------------
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = SellLater(Symbol,lots,op,sll,tpl,slp,tpp,Slippage,exp,(MagicStart+(int)Group),MyComment,ArrowColorSell,CreateOCO);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Buy pending order" model
template<typename T1,typename T2,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename _T27_,typename T28,typename _T28_,typename T29,typename _T29_,typename T30,typename T31,typename T32,typename T33,typename T34,typename _T34_,typename T35,typename _T35_,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename T41,typename _T41_,typename T42,typename T43,typename T44,typename T45>
class MDL_BuyPending: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 Price;
	T4 dPrice; virtual _T4_ _dPrice_(){return(_T4_)0;}
	T5 PriceOffset;
	T6 VolumeMode;
	T7 VolumeSize;
	T8 VolumeSizeRisk;
	T9 VolumeRisk;
	T10 VolumePercent;
	T11 VolumeBlockPercent;
	T12 dVolumeSize; virtual _T12_ _dVolumeSize_(){return(_T12_)0;}
	T13 FixedRatioUnitSize;
	T14 FixedRatioDelta;
	T15 mmMgInitialLots;
	T16 mmMgMultiplyOnLoss;
	T17 mmMgMultiplyOnProfit;
	T18 mmMgAddLotsOnLoss;
	T19 mmMgAddLotsOnProfit;
	T20 mmMgResetOnLoss;
	T21 mmMgResetOnProfit;
	T22 VolumeUpperLimit;
	T23 StopLossMode;
	T24 StopLossPips;
	T25 StopLossPercentPrice;
	T26 StopLossPercentTP;
	T27 dlStopLoss; virtual _T27_ _dlStopLoss_(){return(_T27_)0;}
	T28 dpStopLoss; virtual _T28_ _dpStopLoss_(){return(_T28_)0;}
	T29 ddStopLoss; virtual _T29_ _ddStopLoss_(){return(_T29_)0;}
	T30 TakeProfitMode;
	T31 TakeProfitPips;
	T32 TakeProfitPercentPrice;
	T33 TakeProfitPercentSL;
	T34 dlTakeProfit; virtual _T34_ _dlTakeProfit_(){return(_T34_)0;}
	T35 ddTakeProfit; virtual _T35_ _ddTakeProfit_(){return(_T35_)0;}
	T36 dpTakeProfit; virtual _T36_ _dpTakeProfit_(){return(_T36_)0;}
	T37 ExpMode;
	T38 ExpDays;
	T39 ExpHours;
	T40 ExpMinutes;
	T41 dExp; virtual _T41_ _dExp_(){return(_T41_)0;}
	T42 CreateOCO;
	T43 Slippage;
	T44 MyComment;
	T45 ArrowColorBuy;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_BuyPending()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		Price = (string)"ask";
		PriceOffset = (double)20.0;
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
		CreateOCO = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorBuy = (color)clrBlue;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- open price -------------------------------------------------------------
		double op = 0;
		
		     if (Price == "ask")     {op = SymbolAsk(Symbol);}
		else if (Price == "bid")     {op = SymbolBid(Symbol);}
		else if (Price == "mid")     {op = (SymbolAsk(Symbol)+SymbolBid(Symbol))/2;}
		else if (Price == "dynamic") {op = _dPrice_();}
		
		op = op + toDigits(PriceOffset, Symbol);
		
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = op - (op * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = op + (op * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP")
		{
			if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
			if (tpl > 0) {slp = toPips(MathAbs(op - tpl), Symbol)*StopLossPercentTP/100;}
		}
		
		if (TakeProfitMode == "percentSL")
		{
			if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
			if (sll > 0) {tpp = toPips(MathAbs(op - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots    = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {pre_sll = op;}
		
		double pre_sl_pips = toPips(op-(pre_sll-toDigits(slp,Symbol)), Symbol);
		
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
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, 0, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		//-- expiration -------------------------------------------------------------
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = BuyLater(Symbol,lots,op,sll,tpl,slp,tpp,Slippage,exp,(MagicStart+(int)Group),MyComment,ArrowColorBuy,CreateOCO);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Delete pending orders" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7>
class MDL_DeletePendingOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 LimitsOrStops;
	T7 ArrowColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_DeletePendingOrders()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		LimitsOrStops = (string)"both";
		ArrowColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		for (int index = OrdersTotal()-1; index >= 0; index--)
		{
			if (PendingOrderSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells, LimitsOrStops))
			{
				DeleteOrder(OrderTicket(), ArrowColor);
			}
		}
		
		_callback_(1);
	}
};

// "No pending order" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>
class MDL_NoPendingOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 LimitsOrStops;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_NoPendingOrders()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		LimitsOrStops = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool exist = false;
		
		for (int index = OrdersTotal()-1; index >= 0; index--)
		{
			if (PendingOrderSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells, LimitsOrStops))
			{
				exist = true;
				break;
			}
		}
		
		if (exist == false) {_callback_(1);} else {_callback_(0);}
	}
};

// "For each Pending Order" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11>
class MDL_LoopStartPendingOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 LimitsOrStops;
	T7 LoopDirection;
	T8 LoopSkip;
	T9 LoopEvery;
	T10 LoopLimit;
	T11 PassEnd;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopStartPendingOrders()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		LimitsOrStops = (string)"both";
		LoopDirection = (string)"newest-to-oldest";
		LoopSkip = (int)0;
		LoopEvery = (int)0;
		LoopLimit = (int)0;
		PassEnd = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int saved_type     = attrTypeInLoop();
		ulong saved_ticket = attrTicketInLoop(); // This ticket number will be reloaded at the end of this loop, so if we are in another overlapping loop - it will continue using it's last used ticket number
		
		int total = OrdersTotal();
		int count = 0;
		int skip  = -1;
		int every = 0;
		
		int i_start = 0, i_stop = 0, i_inc = 0, i = 0;
		
		if (LoopDirection == "newest-to-oldest")
		{
			i_start = total-1;
			i_stop  = 0;
			i_inc   = -1;
		}
		else if (LoopDirection == "oldest-to-newest")
		{
		  	i_start = 0;
			i_stop  = total-1;
			i_inc   = 1;
		}
		
		i = i_start - i_inc;
		
		while (true)
		{
		  	if (i == i_stop) break;
		  	i = i + i_inc;
			
			if (FXD_CONTINUE == true)
			{
				FXD_BREAK    = false;
				FXD_CONTINUE = false;
			}
			else if (FXD_BREAK == true)
			{
				FXD_BREAK    = false;
				FXD_CONTINUE = false;
				break;
			}
		
			if (PendingOrderSelectByIndex(i, GroupMode, Group, SymbolMode, Symbol, BuysOrSells, LimitsOrStops))
			{
				every++;
		
				if (every < LoopEvery) {continue;} else {every = 0;}
		
				skip++;
		
				if (LoopSkip <= skip && (count < LoopLimit || LoopLimit == 0))
				{
					count++;
					attrTypeInLoop(2);
					attrTicketInLoop(OrderTicket());
		
					_callback_(1);
		
					if (count == LoopLimit) break;
				}
			}
			
			if (LoopDirection == "oldest-to-newest")
			{
				// if order was closed meanwhile
				if (i_stop > OrdersTotal()-1)
				{
					i_stop = OrdersTotal()-1;
					i--;
				}
			}
		}
		
		attrTypeInLoop(saved_type);
		attrTicketInLoop(saved_ticket); // Reloading Ticket number from the overlapping loop (if any)
		
		FXD_BREAK    = false;
		FXD_CONTINUE = false;
		
		if (
			   (PassEnd == 0)
			|| (PassEnd == 1 && count > 0)
			|| (PassEnd == 2 && count == 0)
		) {
			_callback_(0);
		}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_30: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_30()
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
		
		v::ProfitPercent = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Break even point (each trade)" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11>
class MDL_BreakEvenPoint: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 OnProfitMode;
	T7 OnProfitPips;
	T8 OnProfitPercentSL;
	T9 OnProfitPercentTP;
	T10 BEoffsetMode;
	T11 BEPoffsetPips;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_BreakEvenPoint()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		OnProfitMode = (string)"fixed";
		OnProfitPips = (double)15.0;
		OnProfitPercentSL = (double)50.0;
		OnProfitPercentTP = (double)50.0;
		BEoffsetMode = (string)"none";
		BEPoffsetPips = (double)0.0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (!TradeSelectByIndex(index,GroupMode,Group, SymbolMode,Symbol, BuysOrSells)) {continue;}
			
			string symbol   = OrderSymbol();
			double distance = 0;
		
			     if (OnProfitMode == "fixed")     {distance = toDigits(OnProfitPips,symbol);}
			else if (OnProfitMode == "percentSL") {distance = MathAbs(OrderOpenPrice()-attrStopLoss())*OnProfitPercentSL/100;}
			else if (OnProfitMode == "percentTP") {distance = MathAbs(OrderOpenPrice()-attrTakeProfit())*OnProfitPercentTP/100;}
		
			if (
				   (OrderType() == 0 && (SymbolInfoDouble(symbol,SYMBOL_ASK)-OrderOpenPrice() > distance) && (attrStopLoss() < OrderOpenPrice()))
				|| (OrderType() == 1 && (OrderOpenPrice()-SymbolInfoDouble(symbol,SYMBOL_BID) > distance) && ((attrStopLoss() > OrderOpenPrice()) || attrStopLoss() == 0))
			)
			{
				double be_offset = 0;
		
				if (BEoffsetMode == "pips")
				{
					be_offset = toDigits(BEPoffsetPips,symbol);
		
					if (OrderType() == 1) {be_offset = be_offset*(-1);}
				}
		
				ModifyStops(OrderTicket(), OrderOpenPrice()+be_offset, attrTakeProfit());
			}
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_31: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_31()
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
		
		v::ProfitPercent = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Trailing stop (each trade)" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename _T14_,typename T15,typename _T15_,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename _T24_,typename T25,typename _T25_,typename T26,typename T27,typename T28,typename T29,typename _T29_,typename T30>
class MDL_TrailingStop2: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 TrailWhat;
	T7 TrailingReferencePrice;
	T8 TrailingStopMode;
	T9 tStopPips;
	T10 tStopMoney;
	T11 tStopMultiple;
	T12 tStopPercentTP;
	T13 tStopPercentProfit;
	T14 ftStop; virtual _T14_ _ftStop_(){return(_T14_)0;}
	T15 ftDigits; virtual _T15_ _ftDigits_(){return(_T15_)0;}
	T16 TrailingStepMode;
	T17 tStepPips;
	T18 tStepPercentTS;
	T19 TrailingStartMode;
	T20 tStartPips;
	T21 tStartPercentTS;
	T22 tStartPercentSL;
	T23 tStartPercentTP;
	T24 ftStart; virtual _T24_ _ftStart_(){return(_T24_)0;}
	T25 ftStartFraction; virtual _T25_ _ftStartFraction_(){return(_T25_)0;}
	T26 TrailingTPmode;
	T27 tTPpips;
	T28 tTPpercentTS;
	T29 ftTP; virtual _T29_ _ftTP_(){return(_T29_)0;}
	T30 LevelColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_TrailingStop2()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		TrailWhat = (int)1;
		TrailingReferencePrice = (int)0;
		TrailingStopMode = (string)"fixed";
		tStopPips = (double)40.0;
		tStopMoney = (double)10.0;
		tStopMultiple = (string)"20/5, 30/10";
		tStopPercentTP = (double)100.0;
		tStopPercentProfit = (double)50.0;
		TrailingStepMode = (string)"fixed";
		tStepPips = (double)1.0;
		tStepPercentTS = (double)10.0;
		TrailingStartMode = (string)"none";
		tStartPips = (double)10.0;
		tStartPercentTS = (double)100.0;
		tStartPercentSL = (double)10.0;
		tStartPercentTP = (double)10.0;
		TrailingTPmode = (string)"none";
		tTPpips = (double)20.0;
		tTPpercentTS = (double)200.0;
		LevelColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int total = TradesTotal();
		
		for (int index = 0; index < total; index++)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				string symbol     = OrderSymbol();
				double ask        = SymbolInfoDouble(symbol, SYMBOL_ASK);
				double bid        = SymbolInfoDouble(symbol, SYMBOL_BID);
				double stopslevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
				int digits        = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
				int polarity      = 1;   // 1 = buy, -1 = sell
				double askbid     = ask; // could be Ask or Bid
				double bidask     = bid; // the opposite of askbid
				double sltp       = 0;   // could be SL or TP
				double tpsl       = 0;   // the opposite of sltp
				double fsl        = 0;   // Freeze Level
				double limit      = 0;
				double t_stop     = 0;   // trailing STOP
				double t_start    = 0;   // trailing START
				double t_step     = 0;   // trailing STEP
				double t_opp      = 0;   // trailing Opposite (TP when trailing SL or SL when trailing TP)
		
				if (TrailWhat > 0) {
					sltp = attrStopLoss();
					tpsl = attrTakeProfit();
				}
				else {
					sltp = attrTakeProfit();
					tpsl = attrStopLoss();
				}
		
				if (OrderType() == 0) {
					polarity = 1;
		
					if (TrailingReferencePrice == 1)
					{
						askbid = bid;
						bidask = ask;
					}
				}
				else if (OrderType() == 1) {
					polarity = -1;
					askbid   = bid;
					bidask   = ask;
		
					if (TrailingReferencePrice == 1) {
						askbid = ask;
						bidask = bid;
					}
				}
		
				if (TrailingReferencePrice == 2) {
					askbid = (ask + bid) / 2;
					bidask = (ask + bid) / 2;
				}
		
				// Trailing Stop Size
				     if (TrailingStopMode == "fixed")         {t_stop = toDigits(tStopPips, symbol);} 
				else if (TrailingStopMode == "percentTP")     {t_stop = (MathAbs(OrderOpenPrice() - tpsl)) * (tStopPercentTP / 100);}
				else if (TrailingStopMode == "percentProfit") {t_stop = (MathAbs(askbid - OrderOpenPrice())) * (tStopPercentProfit / 100);}
				else if (TrailingStopMode == "dynamicSize")   {t_stop = toDigits(_ftStop_(), symbol);}
				else if (TrailingStopMode == "dynamicDigits") {t_stop = _ftDigits_();}
				else if (TrailingStopMode == "dynamic")
				{
					// TODO: ftStop is now used for both, dynamic and dynamicSize - separate it
					t_stop = _ftStop_();
					t_stop = (polarity == 1) ? ask - t_stop : t_stop - bid;
				}
				else if (TrailingStopMode == "money")
				{
					t_stop = tStopMoney;
		
					double lotsize   = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
					double tickvalue = (SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE) / SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE)) * SymbolInfoDouble(symbol, SYMBOL_POINT);
					t_stop = t_stop /  (OrderLots() * PipValue(symbol));
					// TODO: remove this toDigits(), the calculation should be made directly into digits
					t_stop = toDigits(t_stop / tickvalue, symbol);
				}
		
				// Trailing Start Level
				     if (TrailingStartMode == "none")             {t_start = -EMPTY_VALUE;}
				else if (TrailingStartMode == "zero")             {t_start = 0;}
				else if (TrailingStartMode == "fixed")            {t_start = toDigits(tStartPips, symbol);}
				else if (TrailingStartMode == "percentTS")        {t_start = t_stop * (tStartPercentTS / 100);}
				else if (TrailingStartMode == "percentTP")        {t_start = (MathAbs(OrderOpenPrice() - tpsl)) * (tStartPercentTP / 100);}
				else if (TrailingStartMode == "percentSL")        {t_start = (MathAbs(OrderOpenPrice() - sltp)) * (tStartPercentSL / 100);}
				else if (TrailingStartMode == "function")         {t_start = toDigits(_ftStart_(), symbol);}
				else if (TrailingStartMode == "functionFraction") {t_start = _ftStartFraction_();}
		
				// Trailing Step Size
				     if (TrailingStepMode == "fixed")     {t_step = toDigits(tStepPips, symbol);}
				else if (TrailingStepMode == "percentTS") {t_step = t_stop * (tStepPercentTS / 100);}
		
				// Trailing Opposite Size
				     if (TrailingTPmode == "none")      {t_opp = tpsl;}
				else if (TrailingTPmode == "clear")     {t_opp = 0;}
				else if (TrailingTPmode == "fixed")     {t_opp = TrailWhat * (OrderOpenPrice() + (polarity * toDigits(tTPpips, symbol)));}
				else if (TrailingTPmode == "percentTS") {t_opp = TrailWhat * (OrderOpenPrice() + (polarity * toDigits(t_stop * (tTPpercentTS / 100), symbol)));}
				else if (TrailingTPmode == "function")  {t_opp = _ftTP_();}
		
				// this mode is located here because it overrides Start, Stop and Step
				// the idea here is to use Start as target profits
				if (TrailingStopMode == "multiple")
				{
					bool next = false;
					string tmp1[];
					string tmp2[];
		
					StringExplode(",", tStopMultiple, tmp1);
		
					for (int i = ArraySize(tmp1)-1; i >= 0; i--)
					{
						StringExplode("/", tmp1[i], tmp2);
		
						if (ArraySize(tmp2) != 2) {continue;}
		
						// trailing start will be used as the treshold level
						double new_start = toDigits(StringToDouble(StringTrim(tmp2[0])), symbol);
		
						// the regular trailing start is bigger than this level -> skip
						if (new_start < t_start) {continue;}
		
						// check whether the current price<->op distance is bigger than some of the desired levels
						double diff = NormalizeDouble(askbid - OrderOpenPrice(), digits);
		
						if (polarity * TrailWhat * diff >= new_start)
						{
							// and setup parameters so SL will be moved
							t_start = new_start;
							t_stop  = polarity * TrailWhat * diff - toDigits(StringToDouble(StringTrim(tmp2[1])), symbol);
		
							next = true;
							break;
						}
					}
		
					if (next == false) {continue;}
				}
		
				stopslevel   = stopslevel * SymbolInfoDouble(symbol, SYMBOL_POINT);
		
				if (t_stop <= 0) {continue;}
		
				if (OrderType() == 0 && TrailWhat * (askbid - OrderOpenPrice()) > t_start)
				{
					if ((TrailWhat * (askbid - sltp) >= t_stop + t_step) || sltp == 0)
					{
						// consider minimum stop
						fsl   = MathAbs(askbid - t_stop);
						limit = bidask - stopslevel * TrailWhat;
		
						if (fsl > limit) {fsl = limit;}
		
						if (TrailWhat == 1) // trail SL
						{
							if (sltp == 0 || sltp < fsl) {
								ModifyStops(OrderTicket(), askbid - t_stop, t_opp, LevelColor);
							}
						}
						else { // trail TP
							if (sltp == 0 || sltp > fsl) {
								ModifyStops(OrderTicket(), t_opp, askbid + t_stop, LevelColor);
							}
						}
					}
				}
				else if (OrderType() == 1 && TrailWhat * (OrderOpenPrice() - askbid) > t_start)
				{
					if ((TrailWhat * (sltp - askbid) >= t_stop + t_step) || sltp == 0)
					{
						// consider minimum stop
						fsl   = MathAbs(askbid + t_stop);
						limit = bidask + stopslevel * TrailWhat;
		
						if (fsl < limit) {fsl = limit;}
		
						if (TrailWhat == 1)
						{ // trail SL
							if (sltp == 0 || sltp > fsl)
							{
								ModifyStops(OrderTicket(), askbid + t_stop, t_opp, LevelColor);
							}
						}
						else
						{ // trail TP
							if (sltp == 0 || sltp < fsl)
							{
								ModifyStops(OrderTicket(), t_opp, askbid - t_stop, LevelColor);
							}
						}
					}
				}
			}
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_32: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_32()
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
		
		v::ProfitPercent = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_33: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_33()
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
		
		v::ProfitPercent = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};


//------------------------------------------------------------------------------------------------------------------------

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

// "Volume size (lots)" model
class MDLIC_inloop_OrderVolume
{
	public: /* Input Parameters */
	int ModeVolume;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderVolume()
	{
		ModeVolume = (int)SEL_CURRENT;
	}

	public: /* The main method */
	double _execute_()
	{
		if (ModeVolume == SEL_CURRENT) {return OrderLots();}
		if (ModeVolume == SEL_INITIAL) {return attrLotsInitial();}
		
		return 0;
	}
};

// "MACD" model
class MDLIC_indicators_iMACD
{
	public: /* Input Parameters */
	int FastEMAperiod;
	int SlowEMAperiod;
	int SignalPeriod;
	ENUM_APPLIED_PRICE AppliedPrice;
	int Mode;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iMACD()
	{
		FastEMAperiod = (int)12;
		SlowEMAperiod = (int)26;
		SignalPeriod = (int)9;
		AppliedPrice = (ENUM_APPLIED_PRICE)PRICE_CLOSE;
		Mode = (int)0;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iMACD(Symbol, Period, FastEMAperiod, SlowEMAperiod, SignalPeriod, AppliedPrice, Mode, Shift + FXD_MORE_SHIFT);
	}
};

// "Candle" model
class MDLIC_candles_candles
{
	public: /* Input Parameters */
	string iOHLC;
	string ModeCandleFindBy;
	int CandleID;
	string TimeStamp;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_candles_candles()
	{
		iOHLC = (string)"iClose";
		ModeCandleFindBy = (string)"id";
		CandleID = (int)0;
		TimeStamp = (string)"00:00";
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}

	public: /* The main method */
	double _execute_()
	{
		int digits = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
		
		double O[];
		double H[];
		double L[];
		double C[]; 
		long cTickVolume[];
		long cRealVolume[];
		datetime T[];
		
		double retval = EMPTY_VALUE;
		
		// candle's id will change, so we don't want to mess with the variable CandleID;
		int cID = CandleID;
		
		if (ModeCandleFindBy == "time")
		{
			cID = iCandleID(Symbol, Period, StringToTimeEx(TimeStamp, "server"));
		}
		
		cID = cID + FXD_MORE_SHIFT;
		
		//-- the common levels ----------------------------------------------------
		if (iOHLC == "iOpen")
		{
			if (CopyOpen(Symbol,Period,cID,1,O) > -1) retval = O[0];
		}
		else if (iOHLC == "iHigh")
		{
			if (CopyHigh(Symbol,Period,cID,1,H) > -1) retval = H[0];
		}
		else if (iOHLC == "iLow")
		{
			if (CopyLow(Symbol,Period,cID,1,L) > -1) retval = L[0];
		}
		else if (iOHLC == "iClose")
		{
			if (CopyClose(Symbol,Period,cID,1,C) > -1) retval = C[0];
		}
		
		//-- non-price values  ----------------------------------------------------
		else if (iOHLC == "iVolume" || iOHLC == "iTickVolume")
		{
			if (CopyTickVolume(Symbol,Period,cID,1,cTickVolume) > -1) retval = (double)cTickVolume[0];
			
			return retval;
		}
		else if (iOHLC == "iRealVolume")
		{
			if (CopyRealVolume(Symbol,Period,cID,1,cRealVolume) > -1) retval = (double)cRealVolume[0];
			
			return retval;
		}
		else if (iOHLC == "iTime")
		{
			if (CopyTime(Symbol,Period,cID,1,T) > -1) retval = (double)T[0];
			
			return retval;
		}
		
		//-- simple calculations --------------------------------------------------
		else if (iOHLC == "iMedian")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
			)
			{
				retval = ((L[0]+H[0])/2);
			}
		}
		else if (iOHLC == "iTypical")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
			)
			{
				retval = ((L[0]+H[0]+C[0])/3);
			}
		}
		else if (iOHLC == "iAverage")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
			)
			{
				retval = ((L[0]+H[0]+C[0]+C[0])/4);
			}
		}
		
		//-- more complex levels --------------------------------------------------
		else if (iOHLC=="iTotal")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
			)
			{
				retval = toPips(MathAbs(H[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBody")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
			)
			{
				retval = toPips(MathAbs(C[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iUpperWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
			)
			{
				retval = (C[0] > O[0]) ? toPips(MathAbs(H[0]-C[0]),Symbol) : toPips(MathAbs(H[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iBottomWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
			)
			{
				retval = (C[0] > O[0]) ? toPips(MathAbs(O[0]-L[0]),Symbol) : toPips(MathAbs(C[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iGap")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID+1,1,C) > -1
			)
			{
				retval = toPips(MathAbs(O[0]-C[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullTotal")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((H[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullBody")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((C[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullUpperWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((H[0]-C[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullBottomWick")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((O[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearTotal")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((H[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearBody")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((O[0]-C[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearUpperWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((H[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearBottomWick")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((C[0]-L[0]),Symbol);
			}
		}
		
		return NormalizeDouble(retval, digits);
	}
};

// "Open Price" model
class MDLIC_inloop_OrderOpenPrice
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderOpenPrice()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return OrderOpenPrice();
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

// "Bucket" model
class MDLIC_bucket_bucket_1
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_1()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_2
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_2()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_3
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_3()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_4
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_4()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_5
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_5()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_6
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_6()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Equity" model
class MDLIC_account_AccountEquity
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountEquity()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2);
	}
};

// "Profit (Equity - Balance)" model
class MDLIC_account_AccountProfit
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountProfit()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return NormalizeDouble(AccountInfoDouble(ACCOUNT_PROFIT), 2);
	}
};

// "Drawdown" model
class MDLIC_statistics_Drawdown
{
	public: /* Input Parameters */
	string Mode;
	string Type;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_statistics_Drawdown()
	{
		Mode = (string)"absolute";
		Type = (string)"equity";
	}

	public: /* The main method */
	double _execute_()
	{
		return(Drawdown(Mode,Type));
	}
};

// "Longs count" model
class MDLIC_statistics_LongsCount
{
	public: /* Input Parameters */
	string Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_statistics_LongsCount()
	{
		Mode = (string)"total";
	}

	public: /* The main method */
	double _execute_()
	{
		return(LongsCount(Mode));
	}
};

// "Shorts count" model
class MDLIC_statistics_ShortsCount
{
	public: /* Input Parameters */
	string Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_statistics_ShortsCount()
	{
		Mode = (string)"total";
	}

	public: /* The main method */
	double _execute_()
	{
		return(ShortsCount(Mode));
	}
};

// "Trades count" model
class MDLIC_statistics_TradesCount
{
	public: /* Input Parameters */
	string Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_statistics_TradesCount()
	{
		Mode = (string)"total";
	}

	public: /* The main method */
	double _execute_()
	{
		return(TradesCount(Mode));
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

// "ZigZag" model
class MDLIC_iCustom_ZigZag
{
	public: /* Input Parameters */
	int ZigZagDepth;
	int ZigZagDeviation;
	int ZigZagBackstep;
	int ModeZigZag;
	int ZigZagReverseID;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_iCustom_ZigZag()
	{
		ZigZagDepth = (int)12;
		ZigZagDeviation = (int)5;
		ZigZagBackstep = (int)3;
		ModeZigZag = (int)0;
		ZigZagReverseID = (int)0;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		int sh        = Shift + FXD_MORE_SHIFT;
		int reverseID = (ZigZagReverseID >= 0) ? ZigZagReverseID : 0;
		
		double HH[]; ArrayResize(HH,0);
		double LL[]; ArrayResize(LL,0);
		
		double retval = 0;
		int size = 0;
		int revH = 0; // reverse id when detecting High
		int revL = 0; // reverse id when detecting Low
		
		int hhll     = 0; // 1 - High was set last; 2 - Low was set last
		double hh    = -EMPTY_VALUE;
		double ll    = EMPTY_VALUE;
		double last  = 0;
		double value = 0;
		
		
		
		while (true)
		{
			if (sh >= iBars(_Symbol,_Period))
			{
				     if (ModeZigZag == 0) {retval = value;}
				else if (ModeZigZag == 1 || ModeZigZag == 3) {retval = HH[ArraySize(HH)-1];}
				else if (ModeZigZag == 2 || ModeZigZag == 4) {retval = LL[ArraySize(LL)-1];}
		
				break;
			}
		
			value = iZigZag(Symbol, Period, ZigZagDepth, ZigZagDeviation, ZigZagBackstep, 0, sh);
		
			if (ModeZigZag == 0)
			{
				retval = value;
		
				break;
			}
		
			sh++;
		
			if (value > 0)
			{
				if (last > 0)
				{
					if (value > last)
					{
						if (hhll == 1 || hhll == 0)
						{
							size = ArraySize(LL);
							hhll = 2;
		
							if (
								   (ModeZigZag < 3) // High or Low
								|| (size == 0 || last<LL[size-1]) // HH or LL
								)
							{
								ArrayResize(LL,size+1);
								LL[size] = last;
								revL++;
		
								if ((ModeZigZag == 2 || ModeZigZag == 4) && revL > reverseID)
								{
									retval = last;
									break;
								}
							}
						}
						else
						{
							size = ArraySize(HH);
							ArrayResize(HH,size+1);
							HH[size] = last;
							hhll     = 1;
						}
					}
					else if (value < last)
					{
						if (hhll == 2 || hhll == 0)
						{
							size = ArraySize(HH);
							hhll = 1;
		
							if (
								   (ModeZigZag < 3) // High or Low
								|| (size == 0 || last > HH[size-1]) // HH or LL
								)
							{
								ArrayResize(HH,size+1);
								HH[size] = last;
								revH++;
		
								if ((ModeZigZag == 1 || ModeZigZag == 3) && revH > reverseID)
								{
									retval = last;
		
									break;
								}
							}
						}
						else
						{
							size = ArraySize(LL);
							ArrayResize(LL,size+1);
							LL[size] = last;
							hhll     = 2;  
						}
					}
				}
		
				last = value;
			}
		}
		
		return retval;
	}
};

// "Relative Strength Index" model
class MDLIC_indicators_iRSI
{
	public: /* Input Parameters */
	int RSIperiod;
	ENUM_APPLIED_PRICE AppliedPrice;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iRSI()
	{
		RSIperiod = (int)14;
		AppliedPrice = (ENUM_APPLIED_PRICE)PRICE_CLOSE;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iRSI(Symbol, Period, RSIperiod, AppliedPrice, Shift + FXD_MORE_SHIFT);
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_7
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_7()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_8
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_8()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_9
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_9()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_10
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_10()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Pips" model
class MDLIC_value_points
{
	public: /* Input Parameters */
	double Value;
	int ModeValue;
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_value_points()
	{
		Value = (double)10.0;
		ModeValue = (int)1;
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	double _execute_()
	{
		double retval = 0;
		
		     if (ModeValue == 0) {retval = Value;}
		else if (ModeValue == 1) {retval = Value*SymbolInfoDouble(Symbol,SYMBOL_POINT)*PipValue(Symbol);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_11
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_11()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_12
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_12()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Login number" model
class MDLIC_account_AccountNumber
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountNumber()
	{
	}

	public: /* The main method */
	long _execute_()
	{
		return (long)AccountInfoInteger(ACCOUNT_LOGIN);
	}
};

// "Market name" model
class MDLIC_eventTrade_e_attrSymbol
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_eventTrade_e_attrSymbol()
	{
	}

	public: /* The main method */
	string _execute_()
	{
		return(e_attrSymbol());
	}
};

// "Volume size (lots)" model
class MDLIC_eventTrade_e_attrLots
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_eventTrade_e_attrLots()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return e_attrLots();
	}
};

// "Boolean" model
class MDLIC_boolean_boolean
{
	public: /* Input Parameters */
	bool Boolean;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_boolean_boolean()
	{
		Boolean = (bool)true;
	}

	public: /* The main method */
	bool _execute_()
	{
		return Boolean;
	}
};

// "Attributes set 1 (numeric)" model
class MDLIC_objectattributes_OBJECT
{
	public: /* Input Parameters */
	string ObjSource;
	string Name;
	int Property;
	int FiboLevelID;
	double TLpriceLevel;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_objectattributes_OBJECT()
	{
		ObjSource = (string)"name";
		Name = (string)"my_object_name";
		Property = (int)OBJPROP_PRICE1;
		FiboLevelID = (int)0;
		TLpriceLevel = (double)1.2;
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		string name = Name;
		
		if (ObjSource == "objloop") {name = LoadedObjectName();}
		if (ObjectFind(0,name)<0) {return EMPTY_VALUE;}
		
		double retval = 0;
		int modifier  = 0;
		
		double Fibo100  = 0;
		double Fibo0    = 0;
		double FiboDiff = 0;
		
		     if (Property == OBJPROP_TIME1)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_TIME,0);}
		else if (Property == OBJPROP_TIME2)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_TIME,1);}
		else if (Property == OBJPROP_TIME3)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_TIME,2);}
		
		else if (Property == OBJPROP_PRICE1)  {retval = ObjectGetDouble(0,name,OBJPROP_PRICE,0);}
		else if (Property == OBJPROP_PRICE2)  {retval = ObjectGetDouble(0,name,OBJPROP_PRICE,1);}
		else if (Property == OBJPROP_PRICE3)  {retval = ObjectGetDouble(0,name,OBJPROP_PRICE,2);}
		
		else if (Property == OBJPROP_BARSHIFT1) {retval = iBarShift(Symbol(), Period(), (int)ObjectGetInteger(0,name,OBJPROP_TIME,0), true); if (retval==-1) {SkipThePass(true);}}
		else if (Property == OBJPROP_BARSHIFT2) {retval = iBarShift(Symbol(), Period(), (int)ObjectGetInteger(0,name,OBJPROP_TIME,1), true); if (retval==-1) {SkipThePass(true);}}
		else if (Property == OBJPROP_BARSHIFT3) {retval = iBarShift(Symbol(), Period(), (int)ObjectGetInteger(0,name,OBJPROP_TIME,2), true); if (retval==-1) {SkipThePass(true);}}
		
		else if (Property == OBJPROP_COLOR)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_COLOR);}
		else if (Property == OBJPROP_STYLE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_STYLE);}
		else if (Property == OBJPROP_WIDTH)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_WIDTH);}
		else if (Property == OBJPROP_BACK)       {retval = (int)ObjectGetInteger(0,name,OBJPROP_BACK);}
		else if (Property == OBJPROP_RAY_LEFT)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_RAY_LEFT);}
		else if (Property == OBJPROP_RAY_RIGHT)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_RAY_RIGHT);}
		else if (Property == OBJPROP_RAY)        {retval = (int)ObjectGetInteger(0,name,OBJPROP_RAY);}
		else if (Property == OBJPROP_ELLIPSE)    {retval = (int)ObjectGetInteger(0,name,OBJPROP_ELLIPSE);}
		else if (Property == OBJPROP_ARROWCODE)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_ARROWCODE);}
		else if (Property == OBJPROP_FONTSIZE)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_FONTSIZE);}
		else if (Property == OBJPROP_CORNER)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_CORNER);}
		else if (Property == OBJPROP_XDISTANCE)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_XDISTANCE);}
		else if (Property == OBJPROP_YDISTANCE)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_YDISTANCE);}
		else if (Property == OBJPROP_LEVELCOLOR) {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELCOLOR);}
		else if (Property == OBJPROP_LEVELSTYLE) {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELSTYLE);}
		else if (Property == OBJPROP_LEVELWIDTH) {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELWIDTH);}
		else if (Property == OBJPROP_ANCHOR)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_ANCHOR);}
		else if (Property == OBJPROP_DIRECTION)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_DIRECTION);}
		//else if (Property == OBJPROP_DEGREE)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_DEGREE);}
		//else if (Property == OBJPROP_DRAWLINES)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_DRAWLINES);}
		else if (Property == OBJPROP_STATE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_STATE);}
		else if (Property == OBJPROP_XSIZE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_XSIZE);}
		else if (Property == OBJPROP_YSIZE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_YSIZE);}
		else if (Property == OBJPROP_PERIOD)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_PERIOD);}
		else if (Property == OBJPROP_LEVELS)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELS);}
		
		else if (Property == OBJPROP_ANGLE)      {retval = ObjectGetDouble(0,name,OBJPROP_ANGLE);}
		else if (Property == OBJPROP_SCALE)      {retval = ObjectGetDouble(0,name,OBJPROP_SCALE);}
		else if (Property == OBJPROP_DEVIATION)  {retval = ObjectGetDouble(0,name,OBJPROP_DEVIATION);}
		
		else if (Property == OBJPROP_FIRSTLEVEL)        {retval = ObjectGetDouble(0,name,OBJPROP_LEVELVALUE,FiboLevelID);}
		else if (Property == OBJPROP_TL_PRICE_BY_SHIFT) {retval = ObjectGetValueByShift(name, Shift+FXD_MORE_SHIFT);}
		else if (Property == OBJPROP_TL_SHIFT_BY_PRICE) {retval = ObjectGetShiftByValue(name,TLpriceLevel);}
		
		else if (Property == OBJPROP_FIBOVALUE) {
		   Fibo100  = ObjectGetDouble(0,name,OBJPROP_PRICE,0);
			Fibo0    = ObjectGetDouble(0,name,OBJPROP_PRICE,1);
			FiboDiff = Fibo100 - Fibo0;
			retval=0;
			if (FiboDiff != 0) {retval = (SymbolInfoDouble(Symbol(),SYMBOL_BID)-Fibo0)/FiboDiff;}
		}
		else if (Property == OBJPROP_FIBOPRICEVALUE) {
			Fibo100  = ObjectGetDouble(0,name,OBJPROP_PRICE,0);
			Fibo0    = ObjectGetDouble(0,name,OBJPROP_PRICE,1);
			FiboDiff = Fibo100 - Fibo0;
			retval=(ObjectGetDouble(0,name,OBJPROP_LEVELVALUE,FiboLevelID)*(FiboDiff))+Fibo0;
		}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_13
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_13()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_14
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_14()
	{
		BucketID = (color)clrNONE;
		Attribute = (int)1;
		PriceMode = (int)0;
		ReturnMode = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		//-- various local variables
		double retval = 0;
		int normalize = -1;
		int i, size;
		double values[];
		
		//-- get collected tickets into an array
		int tickets[];
		int pool;
		size = BucketsOfOrders(BucketID, tickets, pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values, ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i], SELECT_BY_TICKET, pool)) {continue;}
			if (pool == MODE_TRADES && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*++z-1)) {continue;}
		   
		   switch (Attribute)
		  	{
			 	case 0: // COUNT
			  	{
				  	values[i] = 1;
				  	break;
			  	}
		   	case 1: // PROFIT
		   	{
					normalize = 2;
		   	   values[i] = OrderProfit()+OrderCommission()+OrderSwap();
				  	break;
		   	}
		   	case 2: // VOLUME_CURRENT
			   {
		   	   values[i] = OrderLots();
				  	break;
		   	}
		   	case 3: // VOLUME_INITIAL
		   	{
		   	   values[i] = attrLotsInitial();
				  	break;
		   	}
		   	case 4: // SL
			   {
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrStopLoss();
		   	   }
		      	if (PriceMode == 1)
		      	{
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()), OrderSymbol());
		      	}
		      	else if (PriceMode == 2)
		      	{
		      	   values[i] = MathAbs(OrderOpenPrice()-attrStopLoss());
		      	}
				  	break;
		   	}
		   	case 5: // TP
		   	{
		   	   if (PriceMode == 0)
		   	   {
		   	      values[i] = attrTakeProfit();
		   	   }
		   	   if (PriceMode == 1)
		   	   {
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()), OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(), normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(), normalize);
				  	break;
		   	}
			 	default :
			  	{
				  	break;
				}
			}
		}
		
		//-- Sum, Average, Min, Max
		
		double tmp = 0;
		
		switch(ReturnMode)
		{
		  //.. sum
		   case 0:
		   {
		      for (i=0; i<size; i++)
		      {
		         retval += values[i];
		      }
		      break;
		   }
			//.. average
		   case 1:
		   {
				double total = 0;
		      for (i=0; i<size; i++)
		      {
		         total += values[i];
		      }
		      retval = total/size;
		      break;
		   }
		  	//.. max
		   case 2:
		   {
		      retval = -EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp > retval) {retval = tmp;}
		      }
		      break;
			}
		  	//.. min
		   case 3:
		   {
		      retval = EMPTY_VALUE;
		      for (i=0; i<size; i++)
		      {
		         tmp = values[i];
		         if (tmp < retval) {retval = tmp;}
		      }
		      break;
		   }
		}
		
		if (normalize != -1) {retval = NormalizeDouble(retval, normalize);}
		
		return retval;
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

// Block 32 (Formula)
class Block0: public MDL_Formula_1<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "32";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::LOT_Divided;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 33 (Pass)
class Block1: public MDL_Pass
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "33";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {0};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[0].run(1);
		}
	}
};

// Block 188 (If trade)
class Block2: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "188";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {5};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[5].run(2);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 189 (Close trades)
class Block3: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "189";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {148};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[148].run(3);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 190 (Check profit (unrealized))
class Block4: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "190";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
		Compare = "<";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(4);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Percent_Cutloss;
	}
};

// Block 191 (Formula)
class Block5: public MDL_Formula_2<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "191";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {4};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Stop_Loss_Percent;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[4].run(5);
		}
	}
};

// Block 192 (If trade)
class Block6: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "192";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(6);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 193 (Close trades)
class Block7: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "193";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {148};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[148].run(7);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 194 (Check profit (unrealized))
class Block8: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "194";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
		Compare = "<";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(8);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Percent_Cutloss;
	}
};

// Block 195 (Formula)
class Block9: public MDL_Formula_3<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "195";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Stop_Loss_Percent;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(9);
		}
	}
};

// Block 196 (Buy now)
class Block10: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "196";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Group = "1";
		StopLossMode = "none";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(10);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTX;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		MyComment = (string)c::Comment;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 197 (Sell now)
class Block11: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "197";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Group = "1";
		StopLossMode = "none";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(11);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTX;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		MyComment = (string)c::Comment;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 198 (Modify Variables)
class Block12: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "198";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ModeVolume = SEL_CURRENT;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::LOTB1 = _Value1_();
	}
};

// Block 199 (For each Trade)
class Block13: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "199";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {12};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[12].run(13);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 200 (Modify Variables)
class Block14: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "200";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ModeVolume = SEL_CURRENT;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::LOTS1 = _Value1_();
	}
};

// Block 201 (For each Trade)
class Block15: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "201";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[14].run(15);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 202 (Once per bar)
class Block16: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "202";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {185};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[185].run(16);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 203 (Once per bar)
class Block17: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "203";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {186};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[186].run(17);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 204 (Spread Filter)
class Block18: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "204";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {16};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[16].run(18);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 205 (Spread Filter)
class Block19: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "205";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(19);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 232 (No trade)
class Block20: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "232";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[22].run(20);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 233 (No trade)
class Block21: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "233";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[23].run(21);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 242 (Condition)
class Block22: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "242";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {18};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Macd_Center_Buy;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[18].run(22);
		}
	}
};

// Block 243 (Condition)
class Block23: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "243";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Macd_Center_Sell;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(23);
		}
	}
};

// Block 244 (If trade)
class Block24: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "244";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[25].run(24);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 245 (For each Trade)
class Block25: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "245";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {26};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[26].run(25);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 246 (Condition)
class Block26: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "246";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(26);
		}
	}
};

// Block 247 (If trade)
class Block27: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "247";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(27);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 248 (For each Trade)
class Block28: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "248";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(28);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 249 (Condition)
class Block29: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "249";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {39};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[39].run(29);
		}
	}
};

// Block 250 (Buy now)
class Block30: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "250";
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
		// Block input parameters
		Group = "1";
		mmMgMultiplyOnLoss = 1.5;
		StopLossMode = "none";
		TakeProfitMode = "none";
		MyComment = "G1";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
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
		VolumeSize = (double)v::LOTB1;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 251 (Sell now)
class Block31: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "251";
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
		// Block input parameters
		Group = "1";
		mmMgMultiplyOnLoss = 1.5;
		StopLossMode = "none";
		TakeProfitMode = "none";
		TakeProfitPips = 28.0;
		MyComment = "G1";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
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
		VolumeSize = (double)v::LOTS1;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 252 (Formula)
class Block32: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "252";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {149};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Martingale_Multiple;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[149].run(32);
		}
	}
};

// Block 253 (Formula)
class Block33: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "253";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {150};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTS1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Martingale_Multiple;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[150].run(33);
		}
	}
};

// Block 254 (Spread Filter)
class Block34: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "254";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[32].run(34);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 255 (Spread Filter)
class Block35: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "255";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {33};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[33].run(35);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 294 (No trade nearby)
class Block36: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "294";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
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
			_blocks_[34].run(36);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near;
	}
};

// Block 295 (No trade nearby)
class Block37: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "295";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {35};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
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
			_blocks_[35].run(37);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near;
	}
};

// Block 296 (Formula)
class Block38: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "296";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Nearby_PIP;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(38);
		}
	}
};

// Block 297 (Formula)
class Block39: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "297";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Nearby_PIP;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(39);
		}
	}
};

// Block 430 (Formula)
class Block40: public MDL_Formula_8<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "430";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(40);
		}
	}
};

// Block 432 (For each Trade)
class Block41: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "432";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		LoopDirection = "profitable-last";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(41);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		LoopLimit = (int)v::Buy_count_no_last;
	}
};

// Block 434 (Bucket of Trades)
class Block42: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "434";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(42);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 435 (Formula)
class Block43: public MDL_Formula_9<MDLIC_bucket_bucket_1,double,string,MDLIC_bucket_bucket_2,double>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "435";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ReturnMode = 2;
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.BucketID = clrGray;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BucketID = clrGray;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(43);
		}
	}
};

// Block 436 (Condition)
class Block44: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "436";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {41};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Buy_Profit_no_Last;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ProfitPercent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[41].run(44);
		}
	}
};

// Block 437 (once per trade/order)
class Block45: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "437";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(45);
		}
	}
};

// Block 438 (close)
class Block46: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "438";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 439 (Formula)
class Block47: public MDL_Formula_10<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "439";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[49].run(47);
		}
	}
};

// Block 441 (For each Trade)
class Block48: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "441";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		LoopDirection = "profitable-last";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(48);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		LoopLimit = (int)v::Sell_count_no_last;
	}
};

// Block 443 (Bucket of Trades)
class Block49: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "443";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {55};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[55].run(49);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 444 (Formula)
class Block50: public MDL_Formula_11<MDLIC_bucket_bucket_3,double,string,MDLIC_bucket_bucket_4,double>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "444";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ReturnMode = 2;
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.BucketID = clrMagenta;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BucketID = clrMagenta;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(50);
		}
	}
};

// Block 445 (Condition)
class Block51: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "445";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {48};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Sell_Profit_no_Last;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ProfitPercent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[48].run(51);
		}
	}
};

// Block 446 (once per trade/order)
class Block52: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "446";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(52);
		}
	}
};

// Block 447 (close)
class Block53: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "447";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 448 (Modify Variables)
class Block54: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_5,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "448";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		double value = (double)Value1._execute_();
		value = value-1; // Adjust the value
		return value;
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(54);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Buy_count_no_last = _Value1_();
	}
};

// Block 449 (Modify Variables)
class Block55: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_6,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "449";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrMagenta;

		double value = (double)Value1._execute_();
		value = value-1; // Adjust the value
		return value;
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(55);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Sell_count_no_last = _Value1_();
	}
};

// Block 450 (money report)
class Block56: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_account_AccountBalance,double,int,int,string,MDLIC_account_AccountEquity,double,int,int,string,MDLIC_account_AccountProfit,double,int,int,string,MDLIC_statistics_Drawdown,double,int,int,string,MDLIC_statistics_LongsCount,double,int,int,string,MDLIC_statistics_ShortsCount,double,int,int,string,MDLIC_statistics_TradesCount,double,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "450";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value4.Mode = "relative";
		Value5.Mode = "now";
		Value6.Mode = "now";
		Value7.Mode = "now";
		// Block input parameters
		ObjTitleFont = "Verdana";
		ObjTitleFontSize = 10;
		ObjLabelsFontSize = 9;
		Label1 = "Balance";
		Label2 = "Equity";
		Label3 = "profit";
		Label4 = "Drawdown";
		Label5 = "BUY";
		Label6 = "SELL";
		Label7 = "Order";
		Label8 = "Cutloss%";
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}
	virtual double _Value6_() {return Value6._execute_();}
	virtual double _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {
		Value8.Text = v::Percent_Cutloss;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		Title = (string)c::Comment;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrWhite;
		ObjLabelsFontColor = (color)clrAqua;
		ObjFontColor = (color)clrGold;
		FormatNumber1 = (int)EMPTY_VALUE;
		FormatTime1 = (int)EMPTY_VALUE;
		FormatNumber2 = (int)EMPTY_VALUE;
		FormatTime2 = (int)EMPTY_VALUE;
		FormatNumber3 = (int)EMPTY_VALUE;
		FormatTime3 = (int)EMPTY_VALUE;
		FormatNumber4 = (int)EMPTY_VALUE;
		FormatTime4 = (int)EMPTY_VALUE;
		FormatNumber5 = (int)EMPTY_VALUE;
		FormatTime5 = (int)EMPTY_VALUE;
		FormatNumber6 = (int)EMPTY_VALUE;
		FormatTime6 = (int)EMPTY_VALUE;
		FormatNumber7 = (int)EMPTY_VALUE;
		FormatTime7 = (int)EMPTY_VALUE;
		FormatNumber8 = (int)EMPTY_VALUE;
		FormatTime8 = (int)EMPTY_VALUE;
	}
};

// Block 451 (Pass)
class Block57: public MDL_Pass
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "451";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[56].run(57);
		}
	}
};

// Block 459 (find candle low 0)
class Block58: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "459";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {59,73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Ro.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::N_RSI_0_B;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[59].run(58);
		}
		else if (value == 1) {
			_blocks_[73].run(58);
		}
	}
};

// Block 460 (Formula)
class Block59: public MDL_Formula_12<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "460";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::N_RSI_0_B;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 461 (ZZ Check up)
class Block60: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "461";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {72};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 1;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[72].run(60);
		}
	}
};

// Block 462 (find candle low 1)
class Block61: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "462";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {62,73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Lo.ZigZagReverseID = 1;
		Ro.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::N_RSI_1_B;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[62].run(61);
		}
		else if (value == 1) {
			_blocks_[73].run(61);
		}
	}
};

// Block 463 (Formula)
class Block62: public MDL_Formula_13<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "463";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::N_RSI_1_B;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 464 (RSI Higher low)
class Block63: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "464";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();
		Lo.Shift = v::N_RSI_1_B;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();
		Ro.Shift = v::N_RSI_0_B;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(63);
		}
	}
};

// Block 465 (Price Lower low)
class Block64: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "465";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {58,61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 2;
		Ro.ZigZagReverseID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[58].run(64);
			_blocks_[61].run(64);
		}
	}
};

// Block 466 (find candle high 0)
class Block65: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "466";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {66,74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Ro.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::N_RSI_0_S;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[66].run(65);
		}
		else if (value == 1) {
			_blocks_[74].run(65);
		}
	}
};

// Block 467 (Formula)
class Block66: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "467";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::N_RSI_0_S;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 468 (ZZ Check down)
class Block67: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "468";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 2;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(67);
		}
	}
};

// Block 469 (find candle high 1)
class Block68: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "469";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {69,74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Lo.ZigZagReverseID = 1;
		Ro.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::N_RSI_1_S;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[69].run(68);
		}
		else if (value == 1) {
			_blocks_[74].run(68);
		}
	}
};

// Block 470 (Formula)
class Block69: public MDL_Formula_15<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "470";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::N_RSI_1_S;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 471 (RSI Lower high)
class Block70: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "471";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();
		Lo.Shift = v::N_RSI_1_S;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();
		Ro.Shift = v::N_RSI_0_S;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(70);
		}
	}
};

// Block 472 (Price Higher high)
class Block71: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "472";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {65,68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 1;
		Ro.ZigZagReverseID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[65].run(71);
			_blocks_[68].run(71);
		}
	}
};

// Block 475 (Modify Variables)
class Block72: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "475";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::N_RSI_0_S = _Value1_();
		v::N_RSI_1_S = _Value2_();
		v::mode = _Value3_();
	}
};

// Block 476 (AND)
class Block73: public MDL_LogicalAND
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "476";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[63].run(73);
		}
	}
};

// Block 477 (AND)
class Block74: public MDL_LogicalAND
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "477";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(74);
		}
	}
};

// Block 478 (Modify Variables)
class Block75: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "478";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Value = 0.0;
		Value3.Value = 2.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::N_RSI_1_B = _Value1_();
		v::N_RSI_0_B = _Value2_();
		v::mode = _Value3_();
	}
};

// Block 479 (Draw Line)
class Block76: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_iCustom_ZigZag,double,MDLIC_value_time,datetime,MDLIC_iCustom_ZigZag,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "479";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjPrice1.ZigZagDepth = 4;
		ObjPrice1.ZigZagDeviation = 0;
		ObjPrice1.ZigZagBackstep = 0;
		ObjPrice1.ModeZigZag = 2;
		ObjTime2.ModeTime = 3;
		ObjPrice2.ZigZagDepth = 4;
		ObjPrice2.ZigZagDeviation = 0;
		ObjPrice2.ZigZagBackstep = 0;
		ObjPrice2.ModeZigZag = 2;
		ObjPrice2.ZigZagReverseID = 1;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::N_RSI_0_B;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::N_RSI_1_B;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[83].run(76);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TREND;
		ObjColor = (color)clrAqua;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 480 (Draw Line)
class Block77: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_iCustom_ZigZag,double,MDLIC_value_time,datetime,MDLIC_iCustom_ZigZag,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "480";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {82};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjPrice1.ZigZagDepth = 4;
		ObjPrice1.ZigZagDeviation = 0;
		ObjPrice1.ZigZagBackstep = 0;
		ObjPrice1.ModeZigZag = 1;
		ObjTime2.ModeTime = 3;
		ObjPrice2.ZigZagDepth = 4;
		ObjPrice2.ZigZagDeviation = 0;
		ObjPrice2.ZigZagBackstep = 0;
		ObjPrice2.ModeZigZag = 1;
		ObjPrice2.ZigZagReverseID = 1;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::N_RSI_0_S;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::N_RSI_1_S;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[82].run(77);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TREND;
		ObjColor = (color)clrOrangeRed;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 481 (Mode 1)
class Block78: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "481";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::mode;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(78);
		}
	}
};

// Block 482 (Mode 2)
class Block79: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "482";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::mode;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[71].run(79);
		}
	}
};

// Block 1181 (Spread Filter)
class Block80: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "1181";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(80);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 1182 (Spread Filter)
class Block81: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "1182";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[89].run(81);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 1209 (No trade)
class Block82: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "1209";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(82);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1210 (No trade)
class Block83: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "1210";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[81].run(83);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1278 (For each Trade)
class Block84: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "1278";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(84);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1279 (Modify Variables)
class Block85: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "1279";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ModeVolume = SEL_CURRENT;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::LOTB2 = _Value1_();
	}
};

// Block 1280 (For each Trade)
class Block86: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "1280";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(86);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1281 (Modify Variables)
class Block87: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "1281";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ModeVolume = SEL_CURRENT;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::LOTS2 = _Value1_();
	}
};

// Block 1840 (Once per bar)
class Block88: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "1840";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {183};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[183].run(88);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 1841 (Once per bar)
class Block89: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "1841";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {184};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[184].run(89);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 1862 (Buy now)
class Block90: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "1862";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {84};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Group = "2";
		StopLossMode = "none";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(90);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTX;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		MyComment = (string)c::Comment;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 1864 (Sell now)
class Block91: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "1864";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Group = "2";
		StopLossMode = "none";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[86].run(91);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTX;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		MyComment = (string)c::Comment;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 1865 (No trade nearby)
class Block92: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "1865";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {114};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
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
			_blocks_[114].run(92);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near_RSI_B;
	}
};

// Block 1866 (RSI)
class Block93: public MDL_Formula_16<MDLIC_indicators_iRSI,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "1866";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(93);
		}
	}
};

// Block 1867 (No trade nearby)
class Block94: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "1867";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
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
			_blocks_[115].run(94);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near_RSI_S;
	}
};

// Block 1868 (RSI)
class Block95: public MDL_Formula_17<MDLIC_value_value,double,string,MDLIC_indicators_iRSI,double>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "1868";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Value = 100.0;
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[94].run(95);
		}
	}
};

// Block 1877 (If trade)
class Block96: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "1877";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(96);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1880 (If trade)
class Block97: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "1880";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(97);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1899 (For each Trade)
class Block98: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "1899";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(98);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1900 (Condition)
class Block99: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "1900";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {93};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[93].run(99);
		}
	}
};

// Block 1903 (For each Trade)
class Block100: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "1903";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {101};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[101].run(100);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1904 (Condition)
class Block101: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "1904";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(101);
		}
	}
};

// Block 1907 (Buy now)
class Block102: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "1907";
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
		// Block input parameters
		Group = "2";
		mmMgMultiplyOnLoss = 1.5;
		StopLossMode = "none";
		TakeProfitMode = "none";
		MyComment = "G2";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
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
		VolumeSize = (double)v::LOTBx;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 1908 (Sell now)
class Block103: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "1908";
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
		// Block input parameters
		Group = "2";
		mmMgMultiplyOnLoss = 1.5;
		StopLossMode = "none";
		TakeProfitMode = "none";
		TakeProfitPips = 28.0;
		MyComment = "G2";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
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
		VolumeSize = (double)v::LOTSx;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 1909 (Formula)
class Block104: public MDL_Formula_18<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "1909";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::powb;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(104);
		}
	}
};

// Block 1910 (Formula)
class Block105: public MDL_Formula_19<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "1910";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTS2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::pows;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(105);
		}
	}
};

// Block 2321 (Bucket of Trades)
class Block106: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "2321";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(106);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrGreen;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 2322 (Modify Variables)
class Block107: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_7,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "2322";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {112};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGreen;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(107);
		}
	}

	virtual void _beforeExecute_()
	{

		v::countb = _Value1_();
	}
};

// Block 2323 (Bucket of Trades)
class Block108: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "2323";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {109};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[109].run(108);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrBlue;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 2324 (Modify Variables)
class Block109: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_8,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "2324";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrBlue;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(109);
		}
	}

	virtual void _beforeExecute_()
	{

		v::counts = _Value1_();
	}
};

// Block 2325 (Custom MQL code)
class Block110: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "2325";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(110);
		}
	}

	virtual void _beforeExecute_()
	{

		v::powb = MathPow(c::Martingale_Multiple, v::countb);
	}
};

// Block 2326 (Custom MQL code)
class Block111: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "2326";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[105].run(111);
		}
	}

	virtual void _beforeExecute_()
	{

		v::pows = MathPow(c::Martingale_Multiple, v::counts);
	}
};

// Block 2329 (Once per bar)
class Block112: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "2329";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[110].run(112);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)c::Time_Frame;
	}
};

// Block 2330 (Once per bar)
class Block113: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "2330";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(113);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)c::Time_Frame;
	}
};

// Block 2499 (Spread Filter)
class Block114: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "2499";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(114);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 2500 (Spread Filter)
class Block115: public MDL_Spreadfilter<string,string,string,double,int,double>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "2500";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[108].run(115);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		maxSpread = (double)c::Spread_Filter;
	}
};

// Block 2501 (If trade)
class Block116: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "2501";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[128].run(116);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2502 (Bucket of Trades)
class Block117: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "2502";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {118};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[118].run(117);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrGreen;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 2503 (Formula)
class Block118: public MDL_Formula_20<MDLIC_bucket_bucket_9,double,string,MDLIC_bucket_bucket_10,double>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "2503";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Attribute = 2;
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.BucketID = clrGreen;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BucketID = clrGreen;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(118);
		}
	}
};

// Block 2504 (Formula)
class Block119: public MDL_Formula_21<MDLIC_prices_prices,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "2504";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {120};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::all_lotb;
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[120].run(119);
		}
	}
};

// Block 2505 (Formula)
class Block120: public MDL_Formula_22<MDLIC_value_value,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "2505";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::avab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Break_Even_PIP;
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[121].run(120);
		}
	}
};

// Block 2506 (Modify stops of trades)
class Block121: public MDL_ModifyOpened<string,string,string,string,string,int,string,MDLIC_candles_candles,double,string,double,double,MDLIC_value_value,double,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "2506";
		_beforeExecuteEnabled = true;

		// IC input parameters
		fNewStopLoss.Value = 0.0;
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
		NewSLTPmode = "function";
	}

	public: /* Custom methods */
	virtual double _fRelativePrice_() {
		fRelativePrice.Symbol = CurrentSymbol();
		fRelativePrice.Period = CurrentTimeframe();

		return fRelativePrice._execute_();
	}
	virtual double _fNewStopLoss_() {return fNewStopLoss._execute_();}
	virtual double _fNewTakeProfit_() {
		fNewTakeProfit.Value = v::tpb;

		return fNewTakeProfit._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		LevelColor = (color)clrDeepPink;
	}
};

// Block 2507 (If trade)
class Block122: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "2507";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(122);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2508 (Bucket of Trades)
class Block123: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "2508";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {124};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(123);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrBlue;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 2509 (Formula)
class Block124: public MDL_Formula_23<MDLIC_bucket_bucket_11,double,string,MDLIC_bucket_bucket_12,double>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "2509";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Attribute = 2;
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.BucketID = clrBlue;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BucketID = clrBlue;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(124);
		}
	}
};

// Block 2510 (Formula)
class Block125: public MDL_Formula_24<MDLIC_prices_prices,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "2510";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {126};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::all_lots;
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[126].run(125);
		}
	}
};

// Block 2511 (Formula)
class Block126: public MDL_Formula_25<MDLIC_value_value,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "2511";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::avas;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Break_Even_PIP;
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(126);
		}
	}
};

// Block 2512 (Modify stops of trades)
class Block127: public MDL_ModifyOpened<string,string,string,string,string,int,string,MDLIC_candles_candles,double,string,double,double,MDLIC_value_value,double,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "2512";
		_beforeExecuteEnabled = true;

		// IC input parameters
		fNewStopLoss.Value = 0.0;
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
		NewSLTPmode = "function";
	}

	public: /* Custom methods */
	virtual double _fRelativePrice_() {
		fRelativePrice.Symbol = CurrentSymbol();
		fRelativePrice.Period = CurrentTimeframe();

		return fRelativePrice._execute_();
	}
	virtual double _fNewStopLoss_() {return fNewStopLoss._execute_();}
	virtual double _fNewTakeProfit_() {
		fNewTakeProfit.Value = v::tps;

		return fNewTakeProfit._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		LevelColor = (color)clrDeepPink;
	}
};

// Block 2513 (For each Trade)
class Block128: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "2513";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(128);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2514 (once per trade/order)
class Block129: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "2514";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(129);
		}
	}
};

// Block 2515 (For each Trade)
class Block130: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "2515";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(130);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2516 (once per trade/order)
class Block131: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "2516";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[123].run(131);
		}
	}
};

// Block 2517 (Check trades count)
class Block132: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "2517";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {116};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CompareCount = 0;
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[116].run(132);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2518 (Check trades count)
class Block133: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "2518";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {122};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CompareCount = 0;
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[122].run(133);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2519 (Terminate)
class Block134: public MDL_Terminate<string>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "2519";

	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 2607 (Custom MQL code)
class Block135: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "2607";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Authorization: Bearer "+c::Token+"\r\n	application/x-www-form-urlencoded\r\n";


ArrayResize(data,StringToCharArray("message="+c::Greeting,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 2608 (Pass)
class Block136: public MDL_Pass
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "2608";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(136);
		}
	}
};

// Block 2609 (Custom MQL code)
class Block137: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "2609";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Authorization: Bearer "+c::Token+"\r\n	application/x-www-form-urlencoded\r\n";


ArrayResize(data,StringToCharArray("message="+v::Trades,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 2611 (Custom MQL code)
class Block138: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "2611";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(138);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Trades = + v::accountx + ":BUY " + v::symbol + "= " + v::lot + " lot" + "\n" + "profit= " + v::profit + " USD" + "\n" + v::now;
	}
};

// Block 2612 (Trade created)
class Block139: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "2612";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {144};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[144].run(139);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2614 (Modify Variables)
class Block140: public MDL_ModifyVariables<int,MDLIC_account_AccountNumber,long,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_account_AccountProfit,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "2614";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual long _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(140);
		}
	}

	virtual void _beforeExecute_()
	{

		v::accountx = _Value1_();
		v::symbol = _Value2_();
		v::lot = _Value3_();
		v::profit = _Value4_();
	}
};

// Block 2615 (Trade created)
class Block141: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "2615";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {145};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[145].run(141);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 2617 (Modify Variables)
class Block142: public MDL_ModifyVariables<int,MDLIC_account_AccountNumber,long,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_account_AccountProfit,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "2617";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {143};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual long _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[143].run(142);
		}
	}

	virtual void _beforeExecute_()
	{

		v::accountx = _Value1_();
		v::symbol = _Value2_();
		v::lot = _Value3_();
		v::profit = _Value4_();
	}
};

// Block 2618 (Custom MQL code)
class Block143: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "2618";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(143);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Trades =+ v::accountx + ":SELL " + v::symbol + "= " + v::lot + " lot" + "\n" + "profit= " + v::profit + " USD" + "\n" + v::now;
	}
};

// Block 2619 (Condition)
class Block144: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "2619";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Line_Normal_Trade;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(144);
		}
	}
};

// Block 2620 (Condition)
class Block145: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block145() {
		__block_number = 145;
		__block_user_number = "2620";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {142};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Line_Normal_Trade;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[142].run(145);
		}
	}
};

// Block 2621 (Custom MQL code)
class Block146: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block146() {
		__block_number = 146;
		__block_user_number = "2621";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Authorization: Bearer "+c::Token+"\r\n	application/x-www-form-urlencoded\r\n";


ArrayResize(data,StringToCharArray("message="+c::ServerEND,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 2622 (Pass)
class Block147: public MDL_Pass
{

	public: /* Constructor */
	Block147() {
		__block_number = 147;
		__block_user_number = "2622";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {146};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[146].run(147);
		}
	}
};

// Block 2697 (Condition)
class Block148: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block148() {
		__block_number = 148;
		__block_user_number = "2697";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Terminate;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(148);
		}
	}
};

// Block 2837 (Once per bar)
class Block149: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block149() {
		__block_number = 149;
		__block_user_number = "2837";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[30].run(149);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 2838 (Once per bar)
class Block150: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block150() {
		__block_number = 150;
		__block_user_number = "2838";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {31};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[31].run(150);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 3179 (Condition)
class Block151: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block151() {
		__block_number = 151;
		__block_user_number = "3179";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {158};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 2;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[158].run(151);
		}
	}
};

// Block 3180 (Counter: Pass once)
class Block152: public MDL_PassOnce<int>
{

	public: /* Constructor */
	Block152() {
		__block_number = 152;
		__block_user_number = "3180";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {166};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CounterID = 5;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[166].run(152);
		}
	}
};

// Block 3181 (Counter: Reset)
class Block153: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block153() {
		__block_number = 153;
		__block_user_number = "3181";

		// Block input parameters
		ResetThisID = "6";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 3182 (Counter: Pass once)
class Block154: public MDL_PassOnce<int>
{

	public: /* Constructor */
	Block154() {
		__block_number = 154;
		__block_user_number = "3182";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {168};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CounterID = 6;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[168].run(154);
		}
	}
};

// Block 3183 (Counter: Reset)
class Block155: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block155() {
		__block_number = 155;
		__block_user_number = "3183";

		// Block input parameters
		ResetThisID = "5";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 3184 (Condition)
class Block156: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block156() {
		__block_number = 156;
		__block_user_number = "3184";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {157};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Lo.ZigZagReverseID = 1;
		Ro.iOHLC = "iHigh";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNB1;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[157].run(156);
		}
	}
};

// Block 3185 (Formula)
class Block157: public MDL_Formula_26<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block157() {
		__block_number = 157;
		__block_user_number = "3185";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 3186 (Modify Variables)
class Block158: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block158() {
		__block_number = 158;
		__block_user_number = "3186";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {153};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value2.Value = 0.0;
		Value3.Value = 0.0;
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
			_blocks_[153].run(158);
		}
	}

	virtual void _beforeExecute_()
	{

		v::YMode = _Value1_();
		v::YNS1 = _Value2_();
		v::YNS0 = _Value3_();
	}
};

// Block 3187 (Condition)
class Block159: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block159() {
		__block_number = 159;
		__block_user_number = "3187";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {156,169,174};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YMode;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[156].run(159);
			_blocks_[169].run(159);
			_blocks_[174].run(159);
		}
	}
};

// Block 3188 (Condition)
class Block160: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block160() {
		__block_number = 160;
		__block_user_number = "3188";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {161};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 1;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[161].run(160);
		}
	}
};

// Block 3189 (Modify Variables)
class Block161: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block161() {
		__block_number = 161;
		__block_user_number = "3189";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 2.0;
		Value2.Value = 0.0;
		Value3.Value = 0.0;
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
			_blocks_[155].run(161);
		}
	}

	virtual void _beforeExecute_()
	{

		v::YMode = _Value1_();
		v::YNB1 = _Value2_();
		v::YNB0 = _Value3_();
	}
};

// Block 3190 (Condition)
class Block162: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block162() {
		__block_number = 162;
		__block_user_number = "3190";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {163};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Lo.ZigZagReverseID = 1;
		Ro.iOHLC = "iLow";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNS1;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[163].run(162);
		}
	}
};

// Block 3191 (Formula)
class Block163: public MDL_Formula_27<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block163() {
		__block_number = 163;
		__block_user_number = "3191";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNS1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 3192 (Condition)
class Block164: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block164() {
		__block_number = 164;
		__block_user_number = "3192";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {162,171,173};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YMode;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[162].run(164);
			_blocks_[171].run(164);
			_blocks_[173].run(164);
		}
	}
};

// Block 3193 (Condition)
class Block165: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block165() {
		__block_number = 165;
		__block_user_number = "3193";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {177};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Lo.ZigZagReverseID = 1;
		Ro.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNB1;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[177].run(165);
		}
	}
};

// Block 3194 (Draw Line)
class Block166: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block166() {
		__block_number = 166;
		__block_user_number = "3194";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjPrice1.iOHLC = "iHigh";
		ObjPrice1.TimeStamp = "";
		ObjTime2.ModeTime = 3;
		ObjPrice2.iOHLC = "iHigh";
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "M";
		ObjRay = false;
		ObjRayLeft = true;
		ObjRayRight = true;
		ObjWidth = 3;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::YNB1;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.CandleID = v::YNB1;
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::YNB0;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.CandleID = v::YNB0;
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TREND;
		ObjColor = (color)clrOrangeRed;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 3195 (Condition)
class Block167: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block167() {
		__block_number = 167;
		__block_user_number = "3195";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {181};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Lo.ZigZagReverseID = 1;
		Ro.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNS1;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[181].run(167);
		}
	}
};

// Block 3196 (Draw Line)
class Block168: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block168() {
		__block_number = 168;
		__block_user_number = "3196";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjPrice1.iOHLC = "iLow";
		ObjPrice1.TimeStamp = "";
		ObjTime2.ModeTime = 3;
		ObjPrice2.iOHLC = "iLow";
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "F";
		ObjRay = false;
		ObjRayLeft = true;
		ObjRayRight = true;
		ObjWidth = 3;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::YNS1;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.CandleID = v::YNS1;
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::YNS0;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.CandleID = v::YNS0;
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TREND;
		ObjColor = (color)clrOrangeRed;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 3197 (Condition)
class Block169: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block169() {
		__block_number = 169;
		__block_user_number = "3197";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {170};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Ro.iOHLC = "iHigh";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNB0;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[170].run(169);
		}
	}
};

// Block 3198 (Formula)
class Block170: public MDL_Formula_28<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block170() {
		__block_number = 170;
		__block_user_number = "3198";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNB0;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 3199 (Condition)
class Block171: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block171() {
		__block_number = 171;
		__block_user_number = "3199";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {172};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Ro.iOHLC = "iLow";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNS0;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[172].run(171);
		}
	}
};

// Block 3200 (Formula)
class Block172: public MDL_Formula_29<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block172() {
		__block_number = 172;
		__block_user_number = "3200";

	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNS0;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 3201 (Condition)
class Block173: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block173() {
		__block_number = 173;
		__block_user_number = "3201";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {167};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Ro.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNS0;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[167].run(173);
		}
	}
};

// Block 3202 (Condition)
class Block174: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block174() {
		__block_number = 174;
		__block_user_number = "3202";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {165};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Ro.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.CandleID = v::YNB0;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[165].run(174);
		}
	}
};

// Block 3206 (Condition)
class Block175: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block175() {
		__block_number = 175;
		__block_user_number = "3206";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {159};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 1;
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 1;
		Ro.ZigZagReverseID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[159].run(175);
		}
	}
};

// Block 3207 (Condition)
class Block176: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block176() {
		__block_number = 176;
		__block_user_number = "3207";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {164};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ZigZagDeviation = 0;
		Lo.ZigZagBackstep = 0;
		Lo.ModeZigZag = 2;
		Ro.ModeZigZag = 2;
		Ro.ZigZagReverseID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::ZZ_Depth;
		Ro.ZigZagDeviation = _externs::inp3207_Ro_ZigZagDeviation;
		Ro.ZigZagBackstep = _externs::inp3207_Ro_ZigZagBackstep;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[164].run(176);
		}
	}
};

// Block 3208 (Condition)
class Block177: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block177() {
		__block_number = 177;
		__block_user_number = "3208";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {178};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[178].run(177);
		}
	}
};

// Block 3209 (Condition)
class Block178: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block178() {
		__block_number = 178;
		__block_user_number = "3209";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {179};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNB0;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[179].run(178);
		}
	}
};

// Block 3210 (Delete objects)
class Block179: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block179() {
		__block_number = 179;
		__block_user_number = "3210";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {152};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameStartsWith = "F";
		NameContains = "F";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[152].run(179);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)clrOrangeRed;
	}
};

// Block 3211 (Delete objects)
class Block180: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block180() {
		__block_number = 180;
		__block_user_number = "3211";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {154};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameStartsWith = "M";
		NameContains = "M";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[154].run(180);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)clrOrangeRed;
	}
};

// Block 3212 (Condition)
class Block181: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block181() {
		__block_number = 181;
		__block_user_number = "3212";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {182};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNS1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[182].run(181);
		}
	}
};

// Block 3213 (Condition)
class Block182: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block182() {
		__block_number = 182;
		__block_user_number = "3213";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {180};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::YNS0;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[180].run(182);
		}
	}
};

// Block 3214 (Condition)
class Block183: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_objectattributes_OBJECT,double,int>
{

	public: /* Constructor */
	Block183() {
		__block_number = 183;
		__block_user_number = "3214";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Name = "F";
		// Block input parameters
		compare = "x<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Property = OBJPROP_TL_PRICE_BY_SHIFT;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[90].run(183);
		}
	}
};

// Block 3218 (Condition)
class Block184: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_objectattributes_OBJECT,double,int>
{

	public: /* Constructor */
	Block184() {
		__block_number = 184;
		__block_user_number = "3218";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {91};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Name = "M";
		// Block input parameters
		compare = "x>";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Property = OBJPROP_TL_PRICE_BY_SHIFT;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[91].run(184);
		}
	}
};

// Block 3219 (Condition)
class Block185: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_objectattributes_OBJECT,double,int>
{

	public: /* Constructor */
	Block185() {
		__block_number = 185;
		__block_user_number = "3219";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Name = "F";
		// Block input parameters
		compare = "x<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Property = OBJPROP_TL_PRICE_BY_SHIFT;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(185);
		}
	}
};

// Block 3223 (Condition)
class Block186: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_objectattributes_OBJECT,double,int>
{

	public: /* Constructor */
	Block186() {
		__block_number = 186;
		__block_user_number = "3223";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {11};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Name = "M";
		// Block input parameters
		compare = "x>";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Property = OBJPROP_TL_PRICE_BY_SHIFT;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[11].run(186);
		}
	}
};

// Block 3224 (MACD)
class Block187: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block187() {
		__block_number = 187;
		__block_user_number = "3224";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {20,21};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::System_1_MACD;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(187);
			_blocks_[21].run(187);
		}
	}
};

// Block 3225 (TL)
class Block188: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block188() {
		__block_number = 188;
		__block_user_number = "3225";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {151,160};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::System_3_Trendline;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[151].run(188);
			_blocks_[160].run(188);
		}
	}
};

// Block 3226 (RSI)
class Block189: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block189() {
		__block_number = 189;
		__block_user_number = "3226";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {60,67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::System_2_RSI;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(189);
			_blocks_[67].run(189);
		}
	}
};

// Block 3299 (once per trade/order)
class Block190: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block190() {
		__block_number = 190;
		__block_user_number = "3299";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {196};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[196].run(190);
		}
	}
};

// Block 3302 (once per trade/order)
class Block191: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block191() {
		__block_number = 191;
		__block_user_number = "3302";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {197};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[197].run(191);
		}
	}
};

// Block 3321 (Sell pending order)
class Block192: public MDL_SellPending<string,string,string,MDLIC_iCustom_ZigZag,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>
{

	public: /* Constructor */
	Block192() {
		__block_number = 192;
		__block_user_number = "3321";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dPrice.ZigZagDeviation = 0;
		dPrice.ZigZagBackstep = 0;
		dPrice.ModeZigZag = 2;
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		ddTakeProfit.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Group = "3";
		Price = "dynamic";
		PriceOffset = 0.0;
		StopLossMode = "none";
		TakeProfitMode = "none";
		MyComment = "G3";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {
		dPrice.ZigZagDepth = c::ZZ_Depth;
		dPrice.Symbol = CurrentSymbol();
		dPrice.Period = CurrentTimeframe();

		return dPrice._execute_();
	}
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::Sum_Buy;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 3328 (Buy pending order)
class Block193: public MDL_BuyPending<string,string,string,MDLIC_iCustom_ZigZag,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>
{

	public: /* Constructor */
	Block193() {
		__block_number = 193;
		__block_user_number = "3328";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dPrice.ZigZagDeviation = 0;
		dPrice.ZigZagBackstep = 0;
		dPrice.ModeZigZag = 1;
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		ddTakeProfit.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Group = "3";
		Price = "dynamic";
		PriceOffset = 0.0;
		StopLossMode = "none";
		TakeProfitMode = "none";
		MyComment = "G3";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {
		dPrice.ZigZagDepth = c::ZZ_Depth;
		dPrice.Symbol = CurrentSymbol();
		dPrice.Period = CurrentTimeframe();

		return dPrice._execute_();
	}
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::Sum_Sell;
		Slippage = (ulong)c::MAX_Slippage_PIP;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 3364 (Delete pending orders)
class Block194: public MDL_DeletePendingOrders<string,string,string,string,string,string,color>
{

	public: /* Constructor */
	Block194() {
		__block_number = 194;
		__block_user_number = "3364";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
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

// Block 3367 (Delete pending orders)
class Block195: public MDL_DeletePendingOrders<string,string,string,string,string,string,color>
{

	public: /* Constructor */
	Block195() {
		__block_number = 195;
		__block_user_number = "3367";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
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

// Block 3374 (No pending order)
class Block196: public MDL_NoPendingOrders<string,string,string,string,string,string>
{

	public: /* Constructor */
	Block196() {
		__block_number = 196;
		__block_user_number = "3374";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {192,198};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[198].run(196);
		}
		else if (value == 1) {
			_blocks_[192].run(196);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3375 (No pending order)
class Block197: public MDL_NoPendingOrders<string,string,string,string,string,string>
{

	public: /* Constructor */
	Block197() {
		__block_number = 197;
		__block_user_number = "3375";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {193,199};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[199].run(197);
		}
		else if (value == 1) {
			_blocks_[193].run(197);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3378 (For each Pending Order)
class Block198: public MDL_LoopStartPendingOrders<string,string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block198() {
		__block_number = 198;
		__block_user_number = "3378";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {194};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[194].run(198);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3379 (For each Pending Order)
class Block199: public MDL_LoopStartPendingOrders<string,string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block199() {
		__block_number = 199;
		__block_user_number = "3379";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {195};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[195].run(199);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3491 (Bucket of Positions)
class Block200: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block200() {
		__block_number = 200;
		__block_user_number = "3491";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {202};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[202].run(200);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)v::Bucket_Buy;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 3492 (If trade)
class Block201: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block201() {
		__block_number = 201;
		__block_user_number = "3492";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {200};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[200].run(201);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3571 (Modify Variables)
class Block202: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_13,double,int,MDLIC_text_text,string,int,MDLIC_text_text,string,int,MDLIC_text_text,string,int,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block202() {
		__block_number = 202;
		__block_user_number = "3571";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {190};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket_Buy;

		double value = (double)Value1._execute_();
		value = value/1.2; // Adjust the value
		return value;
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual string _Value3_() {return Value3._execute_();}
	virtual string _Value4_() {return Value4._execute_();}
	virtual string _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[190].run(202);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Sum_Buy = _Value1_();
	}
};

// Block 3573 (If trade)
class Block203: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block203() {
		__block_number = 203;
		__block_user_number = "3573";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {204};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[204].run(203);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3664 (Bucket of Positions)
class Block204: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block204() {
		__block_number = 204;
		__block_user_number = "3664";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {205};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[205].run(204);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)v::Bucket_Sell;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 3679 (Modify Variables)
class Block205: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_14,double,int,MDLIC_text_text,string,int,MDLIC_text_text,string,int,MDLIC_text_text,string,int,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block205() {
		__block_number = 205;
		__block_user_number = "3679";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {191};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket_Sell;

		double value = (double)Value1._execute_();
		value = value/1.2; // Adjust the value
		return value;
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual string _Value3_() {return Value3._execute_();}
	virtual string _Value4_() {return Value4._execute_();}
	virtual string _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[191].run(205);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Sum_Sell = _Value1_();
	}
};

// Block 3680 (Check profit (unrealized))
class Block206: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block206() {
		__block_number = 206;
		__block_user_number = "3680";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {209};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[209].run(206);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::ProfitPercent;
	}
};

// Block 3681 (Formula)
class Block207: public MDL_Formula_30<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block207() {
		__block_number = 207;
		__block_user_number = "3681";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {206};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[206].run(207);
		}
	}
};

// Block 3688 (Trade created)
class Block208: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block208() {
		__block_number = 208;
		__block_user_number = "3688";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {207};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[207].run(208);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 3751 (Break even point (each trade))
class Block209: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block209() {
		__block_number = 209;
		__block_user_number = "3751";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
		OnProfitPips = 100.0;
		BEoffsetMode = "pips";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		BEPoffsetPips = (double)c::Break_Even_PIP;
	}
};

// Block 4127 (Check profit (unrealized))
class Block210: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block210() {
		__block_number = 210;
		__block_user_number = "4127";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {213};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[213].run(210);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::ProfitPercent;
	}
};

// Block 4128 (Formula)
class Block211: public MDL_Formula_31<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block211() {
		__block_number = 211;
		__block_user_number = "4128";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {210};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[210].run(211);
		}
	}
};

// Block 4135 (Trade created)
class Block212: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block212() {
		__block_number = 212;
		__block_user_number = "4135";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {211};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[211].run(212);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 4198 (Break even point (each trade))
class Block213: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block213() {
		__block_number = 213;
		__block_user_number = "4198";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
		OnProfitPips = 100.0;
		BEoffsetMode = "pips";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		BEPoffsetPips = (double)c::Break_Even_PIP;
	}
};

// Block 4199 (Trailing stop (each trade))
class Block214: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_indicators_iATR,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block214() {
		__block_number = 214;
		__block_user_number = "4199";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.StartBar = 1;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		Group = "3";
		TrailingStopMode = "dynamicDigits";
		tStopMoney = 0.5;
		TrailingStepMode = "percentTS";
		tStepPercentTS = 20.0;
		TrailingStartMode = "percentTS";
		tStartPercentTS = 200.0;
	}

	public: /* Custom methods */
	virtual double _ftStop_() {
		ftStop.Symbol = CurrentSymbol();
		ftStop.Period = CurrentTimeframe();

		return ftStop._execute_();
	}
	virtual double _ftDigits_() {
		ftDigits.Symbol = CurrentSymbol();
		ftDigits.Period = CurrentTimeframe();

		return ftDigits._execute_();
	}
	virtual double _ftStart_() {return ftStart._execute_();}
	virtual double _ftStartFraction_() {return ftStartFraction._execute_();}
	virtual double _ftTP_() {return ftTP._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		LevelColor = (color)clrDeepPink;
	}
};

// Block 4200 (If trade)
class Block215: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block215() {
		__block_number = 215;
		__block_user_number = "4200";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {214};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[214].run(215);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 4201 (Check profit (unrealized))
class Block216: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block216() {
		__block_number = 216;
		__block_user_number = "4201";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {219};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[219].run(216);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::ProfitPercent;
	}
};

// Block 4202 (Formula)
class Block217: public MDL_Formula_32<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block217() {
		__block_number = 217;
		__block_user_number = "4202";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {216};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[216].run(217);
		}
	}
};

// Block 4209 (Trade created)
class Block218: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block218() {
		__block_number = 218;
		__block_user_number = "4209";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {217};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[217].run(218);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 4272 (Break even point (each trade))
class Block219: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block219() {
		__block_number = 219;
		__block_user_number = "4272";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "3";
		BuysOrSells = "buys";
		OnProfitPips = 100.0;
		BEoffsetMode = "pips";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		BEPoffsetPips = (double)c::Break_Even_PIP;
	}
};

// Block 4648 (Check profit (unrealized))
class Block220: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block220() {
		__block_number = 220;
		__block_user_number = "4648";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {223};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[223].run(220);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::ProfitPercent;
	}
};

// Block 4649 (Formula)
class Block221: public MDL_Formula_33<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block221() {
		__block_number = 221;
		__block_user_number = "4649";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {220};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_Profit_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[220].run(221);
		}
	}
};

// Block 4656 (Trade created)
class Block222: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block222() {
		__block_number = 222;
		__block_user_number = "4656";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {221};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[221].run(222);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 4719 (Break even point (each trade))
class Block223: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block223() {
		__block_number = 223;
		__block_user_number = "4719";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "3";
		BuysOrSells = "sells";
		OnProfitPips = 100.0;
		BEoffsetMode = "pips";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		BEPoffsetPips = (double)c::Break_Even_PIP;
	}
};

// Block 4720 (Trailing stop (each trade))
class Block224: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_indicators_iATR,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block224() {
		__block_number = 224;
		__block_user_number = "4720";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.StartBar = 1;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		Group = "3";
		TrailingStopMode = "dynamicDigits";
		tStopMoney = 0.5;
		TrailingStepMode = "percentTS";
		tStepPercentTS = 20.0;
		TrailingStartMode = "percentTS";
		tStartPercentTS = 200.0;
	}

	public: /* Custom methods */
	virtual double _ftStop_() {
		ftStop.Symbol = CurrentSymbol();
		ftStop.Period = CurrentTimeframe();

		return ftStop._execute_();
	}
	virtual double _ftDigits_() {
		ftDigits.Symbol = CurrentSymbol();
		ftDigits.Period = CurrentTimeframe();

		return ftDigits._execute_();
	}
	virtual double _ftStart_() {return ftStart._execute_();}
	virtual double _ftStartFraction_() {return ftStartFraction._execute_();}
	virtual double _ftTP_() {return ftTP._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		LevelColor = (color)clrDeepPink;
	}
};

// Block 4721 (If trade)
class Block225: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block225() {
		__block_number = 225;
		__block_user_number = "4721";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {224};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "3";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[224].run(225);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};


/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                                   Functions                                                      | //
// |                                 System and Custom functions used in the program                                  | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/


double AccountBalanceAtStart()
{
	// This function MUST be run once at pogram's start
	static double memory = 0;

	if (memory == 0)
	{
		memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
	}

	return memory;
}

double AlignLots(string symbol, double lots, double lowerlots = 0.0, double upperlots = 0.0)
{
	double LotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
	double LotSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
	double MinLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
	double MaxLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

	if (LotStep > MinLots) MinLots = LotStep;

	if (lots == EMPTY_VALUE) {lots = 0.0;}

	lots = MathRound(lots / LotStep) * LotStep;

	if (lots < MinLots) {lots = MinLots;}
	if (lots > MaxLots) {lots = MaxLots;}

	if (lowerlots > 0.0)
	{
		lowerlots = MathRound(lowerlots / LotStep) * LotStep;
		if (lots < lowerlots) {lots = lowerlots;}
	}

	if (upperlots > 0.0)
	{
		upperlots = MathRound(upperlots / LotStep) * LotStep;
		if (lots > upperlots) {lots = upperlots;}
	}

	return lots;
}

double AlignStopLoss(
	string symbol,
	int type,
	double price,
	double slo = 0.0, // original sl, used when modifying
	double sll = 0.0,
	double slp = 0.0,
	bool consider_freezelevel = false
	)
{
	double sl = 0.0;

	if (MathAbs(sll) == EMPTY_VALUE) {sll = 0.0;}
	if (MathAbs(slp) == EMPTY_VALUE) {slp = 0.0;}

	if (sll == 0.0 && slp == 0.0)
	{
		return 0.0;
	}

	if (price <= 0.0)
	{
		Print(__FUNCTION__ + " error: No price entered");

		return -1;
	}

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	slp          = slp * PipValue(symbol) * point;

	//-- buy-sell identifier ---------------------------------------------
	int bs = 1;

	if (
		   type == OP_SELL
		|| type == OP_SELLSTOP
		|| type == OP_SELLLIMIT

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
	if (sll == 0.0 && slp != 0.0) {sll = price;}

	if (sll > 0.0) {sl = sll - slp * bs;}

	if (sl < 0.0)
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
	if (sl > 0.0 && sl != slo)
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
	double tpo = 0.0, // original tp, used when modifying
	double tpl = 0.0,
	double tpp = 0.0,
	bool consider_freezelevel = false
	)
{
	double tp = 0.0;
	
	if (MathAbs(tpl) == EMPTY_VALUE) {tpl = 0.0;}
	if (MathAbs(tpp) == EMPTY_VALUE) {tpp = 0.0;}

	if (tpl == 0.0 && tpp == 0.0)
	{
		return 0.0;
	}

	if (price <= 0.0)
	{
		Print(__FUNCTION__ + " error: No price entered");

		return -1;
	}

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	tpp          = tpp * PipValue(symbol) * point;
	
	//-- buy-sell identifier ---------------------------------------------
	int bs = 1;

	if (
		   type == OP_SELL
		|| type == OP_SELLSTOP
		|| type == OP_SELLLIMIT

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
	if (tpl == 0.0 && tpp != 0.0) {tpl = price;}

	if (tpl > 0.0) {tp = tpl + tpp * bs;}
	
	if (tp < 0.0)
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
	if (tp > 0.0 && tp != tpo)
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
	int index = -1;
	int size  = ArraySize(array);

	for (int i = 0; i < size; i++)
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
	int pool,
	double initialLots,
	bool reverse = false
) {  
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- 1-3-2-6 Logic
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (
			   (reverse == false && profitOrLoss == 1)
			|| (reverse == true && profitOrLoss == -1)
		) {
			double div = lots / initialLots;

			     if (div < 1.5) {lots = initialLots * 3;}
			else if (div < 2.5) {lots = initialLots * 6;}
			else if (div < 3.5) {lots = initialLots * 2;}
			else {lots = initialLots;}
		}
		else
		{
			lots = initialLots;
		}
	}

	return lots;
}

double BetDalembert(
	string group,
	string symbol,
	int pool,
	double initialLots,
	double reverse = false
) {  
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Dalembert Logic
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (
			   (reverse == 0 && profitOrLoss == 1)
			|| (reverse == 1 && profitOrLoss == -1)
		) {
			lots = lots - initialLots;
			if (lots < initialLots) {lots = initialLots;}
		}
		else
		{
			lots = lots + initialLots;
		}
	}

	return lots;
}

double BetFibonacci(
	string group,
	string symbol,
	int pool,
	double initialLots
) {
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Fibonacci Logic
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{  
		int fibo1 = 1;
		int fibo2 = 0;
		int fibo3 = 0;
		int fibo4 = 0;
		double div = lots / initialLots;

		if (div <= 0) {div = 1;}

		while (true)
		{
			fibo1 = fibo1 + fibo2;
			fibo3 = fibo2;
			fibo2 = fibo1 - fibo2;
			fibo4 = fibo2 - fibo3;

			if (fibo1 > NormalizeDouble(div, 2))
			{
				break;
			}
		}

		if (profitOrLoss == 1)
		{
			if (fibo4 <= 0) {fibo4 = 1;}
			lots = initialLots * fibo4;
		}
		else
		{
			lots = initialLots * fibo1;
		}
	}

	lots = NormalizeDouble(lots, 2);

	return lots;
}

double BetLabouchere(
	string group,
	string symbol,
	int pool,
	double initialLots,
	string listOfNumbers,
	double reverse = false
) {
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Labouchere Logic
	static string memGroup[];
	static string memList[];
	static long memTicket[];

	int startAgain = false;

	//- get the list of numbers as it is stored in the memory, or store it
	int id = ArraySearch(memGroup, group);

	if (id == -1)
	{
		startAgain = true;

		if (listOfNumbers == "") {listOfNumbers = "1";}

		id = ArraySize(memGroup);

		ArrayResize(memGroup, id+1, id+1);
		ArrayResize(memList, id+1, id+1);
		ArrayResize(memTicket, id+1, id+1);

		memGroup[id] = group;
		memList[id]  = listOfNumbers;
	}

	if (memTicket[id] == (long)OrderTicket())
	{
		// the last known ticket (memTicket[id]) should be different than OderTicket() normally
		// when failed to create a new trade - the last ticket remains the same
		// so we need to reset
		memList[id] = listOfNumbers;
	}

	memTicket[id] = (long)OrderTicket();

	//- now turn the string into integer array
	int list[];
	string listS[];

	StringExplode(",", memList[id], listS);
	ArrayResize(list, ArraySize(listS));

	for (int s = 0; s < ArraySize(listS); s++)
	{
		list[s] = (int)StringToInteger(StringTrim(listS[s]));  
	}

	//-- 
	int size = ArraySize(list);

	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		startAgain = true;
	}

	if (startAgain == true)
	{
		if (size == 1)
		{
			lots = initialLots * list[0];
		}
		else {
			lots = initialLots * (list[0] + list[size-1]);
		}
	}
	else 
	{
		if (
			   (reverse == 0 && profitOrLoss == 1)
			|| (reverse == 1 && profitOrLoss == -1)
		) {
			if (size == 1)
			{
				lots = initialLots * list[0];
				ArrayResize(list, 0);
			}
			else if (size == 2)
			{
				lots = initialLots * (list[0] + list[1]);
				ArrayResize(list, 0);
			}
			else if (size > 2)
			{
				lots = initialLots * (list[0] + list[size-1]);

				// Cancel the first and the last number in the list
				// shift array 1 step left
				for(int pos = 0; pos < size-1; pos++)
				{
					list[pos] = list[pos+1];
				}

				// remove last 2 elements	
				ArrayResize(list, ArraySize(list) - 2);	
			}

			if (lots < initialLots) {lots = initialLots;}
		}
		else
		{
			if (size > 1)
			{
				ArrayResize(list, size+1);

				list[size] = list[0] + list[size-1];
				lots       = initialLots * (list[0] + list[size]);
			}
			else {
				lots = initialLots * list[0];
			}

			if (lots < initialLots) {lots = initialLots;}
		}
	}

	Print("Labouchere (for group "
		+ (string)id
		+ ") current list of numbers:"
		+ StringImplode(",", list)
	);

	size=ArraySize(list);

	if (size == 0)
	{
		ArrayStripKey(memGroup, id);
		ArrayStripKey(memList, id);
		ArrayStripKey(memTicket, id);
	}
	else {
		memList[id] = StringImplode(",", list);
	}

	return lots;
}

double BetMartingale(
	string group,
	string symbol,
	int pool,
	double initialLots,
	double multiplyOnLoss,
	double multiplyOnProfit,
	double addOnLoss,
	double addOnProfit,
	int resetOnLoss,
	int resetOnProfit
) {
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, true);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss
	double consecutive  = info[2];

	//-- Martingale Logic
	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (profitOrLoss == 1)
		{
			if (resetOnProfit > 0 && consecutive >= resetOnProfit)
			{
				lots = initialLots;
			}
			else
			{
				if (multiplyOnProfit <= 0)
				{
					multiplyOnProfit = 1;
				}

				lots = (lots * multiplyOnProfit) + addOnProfit;
			}
		}
		else
		{
			if (resetOnLoss > 0 && consecutive >= resetOnLoss)
			{
				lots = initialLots;  
			}
			else
			{
				if (multiplyOnLoss <= 0)
				{
					multiplyOnLoss = 1;
				}

				lots = (lots * multiplyOnLoss) + addOnLoss;
			}
		}
	}

	return lots;
}

double BetSequence(
	string group,
	string symbol,
	int pool,
	double initialLots,
	string sequenceOnLoss,
	string sequenceOnProfit,
	bool reverse = false
) {  
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Sequence stuff
	static string memGroup[];
	static string memLossList[];
	static string memProfitList[];
	static long memTicket[];

	//- get the list of numbers as it is stored in the memory, or store it
	int id = ArraySearch(memGroup, group);

	if (id == -1)
	{
		if (sequenceOnLoss == "") {sequenceOnLoss = "1";}

		if (sequenceOnProfit == "") {sequenceOnProfit = "1";}

		id = ArraySize(memGroup);

		ArrayResize(memGroup, id+1, id+1);
		ArrayResize(memLossList, id+1, id+1);
		ArrayResize(memProfitList, id+1, id+1);
		ArrayResize(memTicket, id+1, id+1);

		memGroup[id]      = group;
		memLossList[id]   = sequenceOnLoss;
		memProfitList[id] = sequenceOnProfit;
	}

	bool lossReset   = false;
	bool profitReset = false;

	if (profitOrLoss == -1 && memLossList[id] == "")
	{
		lossReset         = true;
		memProfitList[id] = "";
	}

	if (profitOrLoss == 1 && memProfitList[id] == "")
	{
		profitReset     = true;
		memLossList[id] = "";
	}

	if (profitOrLoss == 1 || memLossList[id] == "")
	{
		memLossList[id] = sequenceOnLoss;

		if (lossReset) {
			memLossList[id] = "1," + memLossList[id];
		}
	}

	if (profitOrLoss == -1 || memProfitList[id] == "")
	{
		memProfitList[id] = sequenceOnProfit;

		if (profitReset) {
			memProfitList[id] = "1," + memProfitList[id];
		}
	}

	if (memTicket[id] == (long)OrderTicket())
	{
		// Normally the last known ticket (memTicket[id]) should be different than OderTicket()
		// when failed to create a new trade, the last ticket remains the same
		// so we need to reset
		memLossList[id]   = sequenceOnLoss;
		memProfitList[id] = sequenceOnProfit;
	}

	memTicket[id] = (long)OrderTicket();

	//- now turn the string into integer array
	int s = 0;
	double listLoss[];
	double listProfit[];
	string listS[];

	StringExplode(",", memLossList[id], listS);
	ArrayResize(listLoss, ArraySize(listS), ArraySize(listS));

	for (s = 0; s < ArraySize(listS); s++)
	{
		listLoss[s] = (double)StringToDouble(StringTrim(listS[s]));  
	}

	StringExplode(",", memProfitList[id], listS);
	ArrayResize(listProfit, ArraySize(listS), ArraySize(listS));

	for (s = 0; s < ArraySize(listS); s++)
	{
		listProfit[s] = (double)StringToDouble(StringTrim(listS[s]));  
	}

	//--
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (
			   (reverse == false && profitOrLoss ==1)
			|| (reverse == true && profitOrLoss == -1)
		) {
			lots = initialLots * listProfit[0];

			// shift array 1 step left
			int size = ArraySize(listProfit);

			for(int pos = 0; pos < size-1; pos++)
			{
				listProfit[pos] = listProfit[pos+1];
			}

			if (size > 0)
			{
				ArrayResize(listProfit, size-1, size-1);
				memProfitList[id] = StringImplode(",", listProfit);
			}
		}
		else
		{
			lots = initialLots * listLoss[0];

			// shift array 1 step left
			int size = ArraySize(listLoss);

			for(int pos = 0; pos < size-1; pos++)
			{
				listLoss[pos] = listLoss[pos+1];
			}

			if (size > 0)
			{
				ArrayResize(listLoss, size-1, size-1);
				memLossList[id] = StringImplode(",", listLoss);
			}
		}
	}

	return lots;
}

int BucketsOfOrders(color &label, int &list[], int &pool, bool set=false)
{
	static color mem_labels[];
	static string mem_tickets[];
	static int mem_pool[]; // 0 - trades, 1 - pending orders, 2 - history trades
	
	//-- cache, this will store only the last list that was set
	static int mem_tickets_last[];
	static color mem_label_last = clrNONE;
	static int mem_pool_last = 0;
	
  
	int size;
	
	//-- get data if the same data was asked before
	if (set == false && (label == clrNONE || label == mem_label_last))
	{
		ArrayResize(list, 0);
		ArrayCopy(list, mem_tickets_last);

	  	label = mem_label_last;
		pool = mem_pool_last;

		return ArraySize(list);
	}
	
	int idx = ArraySearch(mem_labels, label);
	
	//-- set
	if (set == true)
	{
		if (idx == -1)
		{
			size = ArraySize(mem_labels);

			ArrayResize(mem_labels, size+1);
			ArrayResize(mem_pool, size+1);
			ArrayResize(mem_tickets, size+1);
			
			mem_labels[size] = label;
			mem_pool[size]   = pool;
			idx              = size;
		}

		mem_tickets[idx] = StringImplode(",", list);
		mem_pool[idx]	  = pool;

		//-- cache, save this array in a temporary memory
		ArrayResize(mem_tickets_last, 0);
		ArrayCopy(mem_tickets_last, list);

		mem_label_last = label;
		mem_pool_last  = pool;
		
		return true;
	}

	if (idx == -1)
	{
		ArrayResize(list, 0);

		return 0;
	}
	
	//-- get data
	pool = mem_pool[idx];

	if (mem_tickets[idx] == "")
	{
		// because StringExplode returns one empty element for an empty string
		ArrayResize(list, 0);
	}
	else
	{
		StringExplode(",", mem_tickets[idx], list);
	}

	return ArraySize(list);
}

int BuyLater(
	string symbol,
	double lots,
	double price,
	double sll = 0, // SL level
	double tpl = 0, // TP level
	double slp = 0, // SL adjust in points
	double tpp = 0, // TP adjust in points
	double slippage = 0,
	datetime expiration = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	bool oco = false
	)
{
	double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
	int type = 0;

	     if (price == ask) {type = OP_BUY;}
	else if (price < ask)  {type = OP_BUYLIMIT;}
	else if (price > ask)  {type = OP_BUYSTOP;}
	
	return OrderCreate(
		symbol,
		type,
		lots,
		price,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration,
		oco
	);
}

int BuyNow(
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
		OP_BUY,
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
   
   if (error_code<0) {
      error_code=GetLastError();  
   }
   
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
      case 1: // No error returned
         RefreshRates();
         retval=1;
         break;
      case 4: //ERR_SERVER_BUSY
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         Sleep(1000);
         RefreshRates();
         retval=1;
         break;
      case 6: //ERR_NO_CONNECTION
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         while(!IsConnected()) {Sleep(100);}
         while(IsTradeContextBusy()) {Sleep(50);}
         RefreshRates();
         retval=1;
         break;
      case 128: //ERR_TRADE_TIMEOUT
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         RefreshRates();
         retval=1;
         break;
      case 129: //ERR_INVALID_PRICE
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case 130: //ERR_INVALID_STOPS
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case 135: //ERR_PRICE_CHANGED
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case 136: //ERR_OFF_QUOTES
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case 137: //ERR_BROKER_BUSY
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         Sleep(1000);
         retval=1;
         break;
      case 138: //ERR_REQUOTE
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case 142: //This code should be processed in the same way as error 128.
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         RefreshRates();
         retval=1;
         break;
      case 143: //This code should be processed in the same way as error 128.
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         RefreshRates();
         retval=1;
         break;
      /*case 145: //ERR_TRADE_MODIFY_DENIED
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Waiting for a new tick to retry.."));}
         while(RefreshRates()==false) {Sleep(1);}
         return(1);
      */
      case 146: //ERR_TRADE_CONTEXT_BUSY
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Retrying.."));}
         while(IsTradeContextBusy()) {Sleep(50);}
         RefreshRates();
         retval=1;
         break;
      //-- critical errors
      default:
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code)));}
         retval=2;
         break;
   }

   if (retval==0) {tryouts=0;}
   else if (retval==1) {
      tryouts++;
      if (tryouts>=10) {
         tryouts=0;
         retval=2;
      } else {
         Print("retry #"+(string)tryouts+" of 10");
      }
   }
   
   return(retval);
}

bool CloseTrade(ulong ticket, ulong slippage = 0, color arrowcolor = CLR_NONE)
{
	bool success = false;
	bool exists  = false;
	
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;

		if (OrderTicket() == ticket)
		{
			exists = true;
			break;
		}
	}

	if (exists == false)
	{
		return false;
	}

	while (true)
	{
		//-- wait if needed -----------------------------------------------
		WaitTradeContextIfBusy();

		//-- close --------------------------------------------------------
		success = OrderClose((int)ticket, OrderLots(), OrderClosePrice(), (int)(slippage * PipValue(OrderSymbol())), arrowcolor);

		if (success == true)
		{
			if (USE_VIRTUAL_STOPS) {
				VirtualStopsDriver("clear", ticket);
			}

			expirationWorker.RemoveExpiration(ticket);

			OnTrade();

			return true;
		}

		//-- errors -------------------------------------------------------
		int erraction = CheckForTradingError(GetLastError(), "Closing trade #" + (string)ticket + " error");

		switch(erraction)
		{
			case 0: break;    // no error
			case 1: continue; // overcomable error
			case 2: break;    // fatal error
		}

		break;
	}

	return false;
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

int Counter(int id, string cmd = "", int set_passes = 0)
{
	static int idx[]; // index list
	static int pl[];  // passes list
	int size    = 0;
	int passes  = 0;
	int cnt_idx = ArraySearch(idx, id);

	if (cnt_idx == -1)
	{
		// Counter not found
		size = ArraySize(idx);

		ArrayResize(idx, size + 1);
		ArrayResize(pl, size + 1);

		idx[size] = id;
		pl[size]  = 0;
		cnt_idx   = size;
	}

	passes = pl[cnt_idx];

	if (cmd != "")
	{
		if (cmd == "increment")
		{
			pl[cnt_idx] = pl[cnt_idx] + 1;
		}
		else if (cmd == "reset")
		{
			pl[cnt_idx] = 0;
		}
	}

	return passes;
}

string CurrentSymbol(string symbol = "")
{
   static string memory = "";

	// Set
   if (symbol != "")
	{
		memory = symbol;
	}
	// Get
	else if (memory == "")
	{
		memory = Symbol();
	}

   return memory;
}

ENUM_TIMEFRAMES CurrentTimeframe(ENUM_TIMEFRAMES timeframe = -1)
{
	static ENUM_TIMEFRAMES memory = 0;

   if (timeframe >= 0) {memory = timeframe;}

   return memory;
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

bool DeleteOrder(int ticket, color arrowcolor=clrNONE)
{
   bool success=false;
   if (!OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {return(false);}
   
   while(true)
   {
      //-- wait if needed -----------------------------------------------
      WaitTradeContextIfBusy();
      //-- delete -------------------------------------------------------
      success=OrderDelete(ticket,arrowcolor);
      if (success==true) {
         if (USE_VIRTUAL_STOPS) {
            VirtualStopsDriver("clear",ticket);
         }
         OnTrade();
         return(true);
      }
      //-- error check --------------------------------------------------
      int erraction=CheckForTradingError(GetLastError(), "Deleting order #"+(string)ticket+" error");
      switch(erraction)
      {
         case 0: break;    // no error
         case 1: continue; // overcomable error
         case 2: break;    // fatal error
      }
      break;
   }
   return(false);
}

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

double Drawdown(string mode="absolute", string type="equity") {
   if (
      (mode=="absolute" || mode=="relative" || mode=="maximal") &&
      (type=="equity" || type=="balance")
      )
   {
      return(GetStatistics("drawdown_"+type+"_"+mode));
   } return(-1);
}

double DynamicLots(string symbol, string mode="balance", double value=0, double sl=0, string align="align", double RJFR_initial_lots=0)
{
   double size=0;
   double LotStep=MarketInfo(symbol,MODE_LOTSTEP);
   double LotSize=MarketInfo(symbol,MODE_LOTSIZE);
   double MinLots=MarketInfo(symbol,MODE_MINLOT);
   double MaxLots=MarketInfo(symbol,MODE_MAXLOT);
   double TickValue=MarketInfo(symbol,MODE_TICKVALUE);
   double point=MarketInfo(symbol,MODE_POINT);
   double ticksize=MarketInfo(symbol,MODE_TICKSIZE);
   double margin_required=MarketInfo(symbol,MODE_MARGINREQUIRED);
   
   if (mode=="fixed" || mode=="lots")     {size=value;}
   else if (mode=="block-equity")      {size=(value/100)*AccountEquity()/margin_required;}
   else if (mode=="block-balance")     {size=(value/100)*AccountBalance()/margin_required;}
   else if (mode=="block-freemargin")  {size=(value/100)*AccountFreeMargin()/margin_required;}
   else if (mode=="equity")      {size=(value/100)*AccountEquity()/(LotSize*TickValue);}
   else if (mode=="balance")     {size=(value/100)*AccountBalance()/(LotSize*TickValue);}
   else if (mode=="freemargin")  {size=(value/100)*AccountFreeMargin()/(LotSize*TickValue);}
   else if (mode=="equityRisk")     {size=((value/100)*AccountEquity())/(sl*((TickValue/ticksize)*point)*PipValue(symbol));}
   else if (mode=="balanceRisk")    {size=((value/100)*AccountBalance())/(sl*((TickValue/ticksize)*point)*PipValue(symbol));}
   else if (mode=="freemarginRisk") {size=((value/100)*AccountFreeMargin())/(sl*((TickValue/ticksize)*point)*PipValue(symbol));}
   else if (mode=="fixedRisk")   {size=(value)/(sl*((TickValue/ticksize)*point)*PipValue(symbol));}
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
	
   size=MathRound(size/LotStep)*LotStep;
   
   static bool alert_min_lots=false;
   if (size<MinLots && alert_min_lots==false) {
      alert_min_lots=true;
      Alert("You want to trade ",size," lot, but your broker's minimum is ",MinLots," lot. The trade/order will continue with ",MinLots," lot instead of ",size," lot. The same rule will be applied for next trades/orders with desired lot size lower than the minimum. You will not see this message again until you restart the program.");
   }
   
   if (align=="align") {
      if (size<MinLots) {size=MinLots;}
      if (size>MaxLots) {size=MaxLots;}
   }
   
   return (size);
}

string ErrorMessage(int error_code=-1)
{
	string e = "";
	
	if (error_code < 0) {error_code = GetLastError();}
	
	switch(error_code)
	{
		//-- codes returned from trade server
		case 0:	return("");
		case 1:	e = "No error returned"; break;
		case 2:	e = "Common error"; break;
		case 3:	e = "Invalid trade parameters"; break;
		case 4:	e = "Trade server is busy"; break;
		case 5:	e = "Old version of the client terminal"; break;
		case 6:	e = "No connection with trade server"; break;
		case 7:	e = "Not enough rights"; break;
		case 8:	e = "Too frequent requests"; break;
		case 9:	e = "Malfunctional trade operation (never returned error)"; break;
		case 64:  e = "Account disabled"; break;
		case 65:  e = "Invalid account"; break;
		case 128: e = "Trade timeout"; break;
		case 129: e = "Invalid price"; break;
		case 130: e = "Invalid Sl or TP"; break;
		case 131: e = "Invalid trade volume"; break;
		case 132: e = "Market is closed"; break;
		case 133: e = "Trade is disabled"; break;
		case 134: e = "Not enough money"; break;
		case 135: e = "Price changed"; break;
		case 136: e = "Off quotes"; break;
		case 137: e = "Broker is busy (never returned error)"; break;
		case 138: e = "Requote"; break;
		case 139: e = "Order is locked"; break;
		case 140: e = "Only long trades allowed"; break;
		case 141: e = "Too many requests"; break;
		case 145: e = "Modification denied because order too close to market"; break;
		case 146: e = "Trade context is busy"; break;
		case 147: e = "Expirations are denied by broker"; break;
		case 148: e = "Amount of open and pending orders has reached the limit"; break;
		case 149: e = "Hedging is prohibited"; break;
		case 150: e = "Prohibited by FIFO rules"; break;
		
		//-- mql4 errors
		case 4000: e = "No error"; break;
		case 4001: e = "Wrong function pointer"; break;
		case 4002: e = "Array index is out of range"; break;
		case 4003: e = "No memory for function call stack"; break;
		case 4004: e = "Recursive stack overflow"; break;
		case 4005: e = "Not enough stack for parameter"; break;
		case 4006: e = "No memory for parameter string"; break;
		case 4007: e = "No memory for temp string"; break;
		case 4008: e = "Not initialized string"; break;
		case 4009: e = "Not initialized string in array"; break;
		case 4010: e = "No memory for array string"; break;
		case 4011: e = "Too long string"; break;
		case 4012: e = "Remainder from zero divide"; break;
		case 4013: e = "Zero divide"; break;
		case 4014: e = "Unknown command"; break;
		case 4015: e = "Wrong jump"; break;
		case 4016: e = "Not initialized array"; break;
		case 4017: e = "dll calls are not allowed"; break;
		case 4018: e = "Cannot load library"; break;
		case 4019: e = "Cannot call function"; break;
		case 4020: e = "Expert function calls are not allowed"; break;
		case 4021: e = "Not enough memory for temp string returned from function"; break;
		case 4022: e = "System is busy"; break;
		case 4050: e = "Invalid function parameters count"; break;
		case 4051: e = "Invalid function parameter value"; break;
		case 4052: e = "String function internal error"; break;
		case 4053: e = "Some array error"; break;
		case 4054: e = "Incorrect series array using"; break;
		case 4055: e = "Custom indicator error"; break;
		case 4056: e = "Arrays are incompatible"; break;
		case 4057: e = "Global variables processing error"; break;
		case 4058: e = "Global variable not found"; break;
		case 4059: e = "Function is not allowed in testing mode"; break;
		case 4060: e = "Function is not confirmed"; break;
		case 4061: e = "Send mail error"; break;
		case 4062: e = "String parameter expected"; break;
		case 4063: e = "Integer parameter expected"; break;
		case 4064: e = "Double parameter expected"; break;
		case 4065: e = "Array as parameter expected"; break;
		case 4066: e = "Requested history data in update state"; break;
		case 4099: e = "End of file"; break;
		case 4100: e = "Some file error"; break;
		case 4101: e = "Wrong file name"; break;
		case 4102: e = "Too many opened files"; break;
		case 4103: e = "Cannot open file"; break;
		case 4104: e = "Incompatible access to a file"; break;
		case 4105: e = "No order selected"; break;
		case 4106: e = "Unknown symbol"; break;
		case 4107: e = "Invalid price parameter for trade function"; break;
		case 4108: e = "Invalid ticket"; break;
		case 4109: e = "Trade is not allowed in the expert properties"; break;
		case 4110: e = "Longs are not allowed in the expert properties"; break;
		case 4111: e = "Shorts are not allowed in the expert properties"; break;
		
		//-- objects errors
		case 4200: e = "Object is already exist"; break;
		case 4201: e = "Unknown object property"; break;
		case 4202: e = "Object is not exist"; break;
		case 4203: e = "Unknown object type"; break;
		case 4204: e = "No object name"; break;
		case 4205: e = "Object coordinates error"; break;
		case 4206: e = "No specified subwindow"; break;
		case 4207: e = "Graphical object error"; break;  
		case 4210: e = "Unknown chart property"; break;
		case 4211: e = "Chart not found"; break;
		case 4212: e = "Chart subwindow not found"; break;
		case 4213: e = "Chart indicator not found"; break;
		case 4220: e = "Symbol select error"; break;
		case 4250: e = "Notification error"; break;
		case 4251: e = "Notification parameter error"; break;
		case 4252: e = "Notifications disabled"; break;
		case 4253: e = "Notification send too frequent"; break;
		
		//-- ftp errors
		case 4260: e = "FTP server is not specified"; break;
		case 4261: e = "FTP login is not specified"; break;
		case 4262: e = "FTP connection failed"; break;
		case 4263: e = "FTP connection closed"; break;
		case 4264: e = "FTP path not found on server"; break;
		case 4265: e = "File not found in the MQL4\\Files directory to send on FTP server"; break;
		case 4266: e = "Common error during FTP data transmission"; break;
		
		//-- filesystem errors
		case 5001: e = "Too many opened files"; break;
		case 5002: e = "Wrong file name"; break;
		case 5003: e = "Too long file name"; break;
		case 5004: e = "Cannot open file"; break;
		case 5005: e = "Text file buffer allocation error"; break;
		case 5006: e = "Cannot delete file"; break;
		case 5007: e = "Invalid file handle (file closed or was not opened)"; break;
		case 5008: e = "Wrong file handle (handle index is out of handle table)"; break;
		case 5009: e = "File must be opened with FILE_WRITE flag"; break;
		case 5010: e = "File must be opened with FILE_READ flag"; break;
		case 5011: e = "File must be opened with FILE_BIN flag"; break;
		case 5012: e = "File must be opened with FILE_TXT flag"; break;
		case 5013: e = "File must be opened with FILE_TXT or FILE_CSV flag"; break;
		case 5014: e = "File must be opened with FILE_CSV flag"; break;
		case 5015: e = "File read error"; break;
		case 5016: e = "File write error"; break;
		case 5017: e = "String size must be specified for binary file"; break;
		case 5018: e = "Incompatible file (for string arrays-TXT, for others-BIN)"; break;
		case 5019: e = "File is directory, not file"; break;
		case 5020: e = "File does not exist"; break;
		case 5021: e = "File cannot be rewritten"; break;
		case 5022: e = "Wrong directory name"; break;
		case 5023: e = "Directory does not exist"; break;
		case 5024: e = "Specified file is not directory"; break;
		case 5025: e = "Cannot delete directory"; break;
		case 5026: e = "Cannot clean directory"; break;
		
		//-- other errors
		case 5027: e = "Array resize error"; break;
		case 5028: e = "String resize error"; break;
		case 5029: e = "Structure contains strings or dynamic arrays"; break;
		
		//-- http request
		case 5200: e = "Invalid URL"; break;
		case 5201: e = "Failed to connect to specified URL"; break;
		case 5202: e = "Timeout exceeded"; break;
		case 5203: e = "HTTP request failed"; break;

		default:	e = "Unknown error";
	}

	e = StringConcatenate(e, " (", error_code, ")");
	
	return e;
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

class ExpirationWorker
{
private:
	struct CachedItems
	{
		long ticket;
		datetime expiration;
	};

	CachedItems cachedItems[];
	long chartID;
	string chartObjectPrefix;
	string chartObjectSuffix;

	template<typename T>
	void ArrayClone(T &dest[], T &src[])
	{
		int size = ArraySize(src);
		ArrayResize(dest, size);

		for (int i = 0; i < size; i++)
		{
			dest[i] = src[i];
		}
	}

	void InitialDiscovery()
	{
		ArrayResize(cachedItems, 0);

		int total = OrdersTotal();

		for (int index = 0; index <= total; index++)
		{
			long ticket = GetTicketByIndex(index);

			if (ticket == 0) continue;

			datetime expiration = GetExpirationFromObject(ticket);

			if (expiration > 0)
			{
				SetExpirationInCache(ticket, expiration);
			}
		}
	}

	long GetTicketByIndex(int index)
	{
		long ticket = 0;

		if (OrderSelect(index, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderType() <= OP_SELL) ticket = (long)OrderTicket();
		}

		return ticket;
	}

	datetime GetExpirationFromObject(long ticket)
	{
		datetime expiration = (datetime)0;
		
		string objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;

		if (ObjectFind(chartID, objectName) == chartID)
		{
			expiration = (datetime)ObjectGetInteger(chartID, objectName, OBJPROP_TIME);
		}

		return expiration;
	}

	bool RemoveExpirationObject(long ticket)
	{
		bool success      = false;
		string objectName = "";

		objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;
		success    = ObjectDelete(chartID, objectName);

		return success;
	}

	void RemoveExpirationFromCache(long ticket)
	{
		int size = ArraySize(cachedItems);
		CachedItems newItems[];
		int newSize = 0;
		bool itemRemoved = false;

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				itemRemoved = true;
			}
			else
			{
				newSize++;
				ArrayResize(newItems, newSize);
				newItems[newSize - 1].ticket     = cachedItems[i].ticket;
				newItems[newSize - 1].expiration = cachedItems[i].expiration;
			}
		}

		if (itemRemoved) ArrayClone(cachedItems, newItems);
	}

	void SetExpirationInCache(long ticket, datetime expiration)
	{
		bool alreadyExists = false;
		int size           = ArraySize(cachedItems);

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				cachedItems[i].expiration = expiration;
				alreadyExists = true;
				break;
			}
		}

		if (alreadyExists == false)
		{
			ArrayResize(cachedItems, size + 1);
			cachedItems[size].ticket     = ticket;
			cachedItems[size].expiration = expiration;
		}
	}

	bool SetExpirationInObject(long ticket, datetime expiration)
	{
		if (!OrderSelect((int)ticket, SELECT_BY_TICKET)) return false;

		string objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;
		double price      = OrderOpenPrice();

		if (ObjectFind(chartID, objectName) == chartID)
		{
			ObjectSetInteger(chartID, objectName, OBJPROP_TIME, expiration);
			ObjectSetDouble(chartID, objectName, OBJPROP_PRICE, price);
		}
		else
		{
			ObjectCreate(chartID, objectName, OBJ_ARROW, 0, expiration, price);
		}

		ObjectSetInteger(chartID, objectName, OBJPROP_ARROWCODE, 77);
		ObjectSetInteger(chartID, objectName, OBJPROP_HIDDEN, true);
		ObjectSetInteger(chartID, objectName, OBJPROP_ANCHOR, ANCHOR_TOP);
		ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrRed);
		ObjectSetInteger(chartID, objectName, OBJPROP_SELECTABLE, false);
		ObjectSetInteger(chartID, objectName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
		ObjectSetString(chartID, objectName, OBJPROP_TEXT, TimeToString(expiration));

		return true;
	}
	
	bool TradeExists(long ticket)
	{
		bool exists  = false;

		for (int i = 0; i < OrdersTotal(); i++)
		{
			if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;

			if (OrderTicket() == ticket)
			{
				exists = true;
				break;
			}
		}

		return exists;
	}

public:
	// Default constructor
	ExpirationWorker()
	{
		chartID           = 0;
		chartObjectPrefix = "#";
		chartObjectSuffix = " Expiration Marker";

		InitialDiscovery();
	}

	void SetExpiration(long ticket, datetime expiration)
	{
		if (expiration <= 0)
		{
			RemoveExpiration(ticket);
		}
		else
		{
			SetExpirationInObject(ticket, expiration);
			SetExpirationInCache(ticket, expiration);
		}
	}

	datetime GetExpiration(long ticket)
	{
		datetime expiration = (datetime)0;
		int size            = ArraySize(cachedItems);

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				expiration = cachedItems[i].expiration;
				break;
			}
		}

		return expiration;
	}

	void RemoveExpiration(long ticket)
	{
		RemoveExpirationObject(ticket);
		RemoveExpirationFromCache(ticket);
	}

	void Run()
	{
		int count = ArraySize(cachedItems);

		if (count > 0)
		{
			datetime timeNow = TimeCurrent();

			for (int i = 0; i < count; i++)
			{
				if (timeNow >= cachedItems[i].expiration)
				{
					long ticket           = cachedItems[i].ticket;
					bool removeExpiration = false;

					if (TradeExists(ticket))
					{
						if (CloseTrade(ticket))
						{
							Print("close #", ticket, " by expiration");
							removeExpiration = true;
						}
					}
					else
					{
						removeExpiration = true;
					}

					if (removeExpiration)
					{
						RemoveExpiration(ticket);

						// Removing expiration causes change in the size of the cache,
						// so reset of the size and one step back of the index is needed
						count = ArraySize(cachedItems);
						i--;
					}
				}
			}
		}
	}
};

ExpirationWorker expirationWorker;

bool FeedStatistics(){GetStatistics();return false;}

bool FilterEventTrade(string group_mode,string group,string market_mode="market",string market="",string BuysOrSells="both", string LimitsOrStops="")
{
	return FilterOrderBy(group_mode, group, market_mode, market, BuysOrSells, LimitsOrStops, 2, true);
}

bool FilterOrderBy(
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both",
	string LimitsOrStops = "both",
	int TradesOrders     = 0,
	bool onTrade         = false
) {
	// TradesOrders = 0 - trades only
	// TradesOrders = 1 - orders only
	// TradesOrders = 2 - trades and orders

	//-- db
	static string markets[];
	static string market0   = "-";
	static int markets_size = 0;
	
	static string groups[];
	static string group0   = "-";
	static int groups_size = 0;
	
	//-- local variables
	bool type_pass   = false;
	bool market_pass = false;
	bool group_pass  = false;
	
	int i, type, magic_number;
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

	if (TradesOrders == 0)
	{
		if (
				(BuysOrSells == "both"  && (type == OP_BUY || type == OP_SELL))
			|| (BuysOrSells == "buys"  && type == OP_BUY)
			|| (BuysOrSells == "sells" && type == OP_SELL)
			
			)
		{
			type_pass = true;
		}
	}
	// Pending orders
	else if (TradesOrders == 1)
	{
		if (
				(BuysOrSells == "both" && (type == OP_BUYLIMIT || type == OP_BUYSTOP || type == OP_SELLLIMIT || type == OP_SELLSTOP))
			||	(BuysOrSells == "buys" && (type == OP_BUYLIMIT || type == OP_BUYSTOP))
			|| (BuysOrSells == "sells" && (type == OP_SELLLIMIT || type == OP_SELLSTOP))
			)
		{
			if (
					(LimitsOrStops == "both" && (type == OP_BUYSTOP || type == OP_SELLSTOP || type == OP_BUYLIMIT || type == OP_SELLLIMIT))
				||	(LimitsOrStops == "stops" && (type == OP_BUYSTOP || type == OP_SELLSTOP))
				|| (LimitsOrStops == "limits" && (type == OP_BUYLIMIT || type == OP_SELLLIMIT))					
				)
			{
				type_pass = true;
			}
		}
	}
	//-- Trades and orders --------------------------------------------
	else
	{
		if (
				(BuysOrSells == "both")
			|| (BuysOrSells == "buys"  && (type == OP_BUY || type == OP_BUYLIMIT || type == OP_BUYSTOP))
			|| (BuysOrSells == "sells" && (type == OP_SELL || type == OP_SELLLIMIT || type == OP_SELLSTOP))
			)
		{
			type_pass = true;
		}
	}

	if (type_pass == false)
	{
		return false;
	}

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
				StringExplode(",", group,groups);
				groups_size = ArraySize(groups);

				for(i = 0; i < groups_size; i++)
				{
					groups[i] = StringTrimRight(groups[i]);
					groups[i] = StringTrimLeft(groups[i]);

					if (groups[i] == "") {groups[i] = "0";}
				}
			}
		
			for(i = 0; i < groups_size; i++)
			{
				if (magic_number == (MagicStart+(int)groups[i]))
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

	if (group_pass == false)
	{
		return false;
	}

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
					ArrayResize(markets, 1);
					markets[0] = Symbol();
				}
				else
				{
					StringExplode(",", market, markets);
					markets_size = ArraySize(markets);

					for(i = 0; i < markets_size; i++)
					{
						markets[i] = StringTrimRight(markets[i]);
						markets[i] = StringTrimLeft(markets[i]);

						if (markets[i] == "") {markets[i] = Symbol();}
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

	if (market_pass == false)
	{
		return false;
	}

	return true;
}

/**
* This overload works for numeric values and for boolean values
*/
template<typename T>
string FormatValueForPrinting(
	T value,
	int digits,
	int timeFormat
) {
	string outputValue = "";
	string typeName    = typename(value);

	if (typeName == "double" || typeName == "float")
	{
		if (digits >= -16 && digits <= 8)
		{
			if (value > -1.0 && value < 1.0)
			{
				/**
				* Find how many zeroes are after the point, but before the first non-zero digit.
				* For example 0.000195 has 3 zeroes
				* The function would return negative value for values bigger than 0
				*
				* @see https://stackoverflow.com/questions/31001901/how-can-i-count-the-number-of-zero-decimals-in-javascript/31002148#31002148
				*/
				int zeroesAfterPoint = (int)-MathFloor(MathLog10(MathAbs(value)) + 1);

				digits = zeroesAfterPoint + digits;
			}
			
			T normalizedValue  = NormalizeDouble(value, digits);
			outputValue = DoubleToString(normalizedValue, digits);
		}
		else
		{
			outputValue = (string)NormalizeDouble(value, 8);
		}
	}
	else {
		outputValue = IntegerToString((long)value);
	}

	return outputValue;
}

/**
* Bool overload
*/
string FormatValueForPrinting(
	bool value,
	int digits,
	int timeFormat
) {
	return (value) ? "true" : "false";
}

/**
* Datetime overload
*/
string FormatValueForPrinting(
	datetime value,
	int digits,
	int timeFormat
) {
	if (timeFormat == EMPTY_VALUE) timeFormat = TIME_DATE|TIME_MINUTES;
	return TimeToString(value, timeFormat);
}

/**
* String overload
*/
string FormatValueForPrinting(
	string value,
	int digits,
	int timeFormat
) {
	return value;
}

void GetBetTradesInfo(
	double &output[],
	string group,
	string symbol,
	int pool, // 0: try running trades first and then history trades, 1: try running only, 2: try history only
	bool findConsecutive = false
) {
	if (ArraySize(output) < 4)
	{
		ArrayResize(output, 4);
		ArrayInitialize(output, 0.0);
	}

	double lots         = output[0]; // will be the lot size of the first loaded trade
	double profitOrLoss = output[1]; // 0 is initial value, 1 is profit, -1 is loss
	double consecutive  = output[2]; // the number of consecutive profitable or losable trades
	double profit       = output[3]; // will be the profit of the first loaded trade
	bool historyTrades  = (pool == 2) ? true : false;
	
	int total = (historyTrades) ? HistoryTradesTotal() : TradesTotal();

	for (int pos = total - 1; pos >= 0; pos--)
	{
		if (
			   (!historyTrades && TradeSelectByIndex(pos, "group", group, "symbol", symbol))
			|| (historyTrades && HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
		) {
			if (
				(TimeCurrent() - OrderOpenTime() < 3) // skip for brand new trades
				||
				(
					// exclude expired pending orders
					!historyTrades
					&& OrderExpiration() > 0
					&& OrderExpiration() <= OrderCloseTime()
				)
			) {
				continue;
			}

			if (lots == 0.0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
			
			if (profit == 0.0)
			{
				// Consider a trade with zero profit as non existent
				continue;
			}

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profitOrLoss == 0)
			{
				// We enter here only for the first trade
				profitOrLoss = (profit < 0.0) ? -1 : 1;

				consecutive++;

				if (findConsecutive == false) break;
			}
			else
			{
				// For the trades after the first one, if its profit is the opposite of profitOrLoss, we need to break
				if (
					   (profitOrLoss > 0.0 && profit < 0.0)
					|| (profitOrLoss < 0.0 && profit > 0.0)
				) {
					break;
				}

				consecutive++;
			}
		}
	}

	output[0] = lots;
	output[1] = profitOrLoss;
	output[2] = consecutive;
	output[3] = profit;
	
	if (pool == 0 && (findConsecutive || profitOrLoss == 0))
	{
		// running trades tried, continue with the history trades
		pool = 2;
		GetBetTradesInfo(output, group, symbol, pool, findConsecutive);
	}
}

double GetStatistics(string get="") {
   
   if (false) {FeedStatistics();}
   //////
   // main static variables
   static datetime start_time=-1;
   static double initial_money=-1;
   static double total_net_profit=-1;
   
   int shorts_now_count=0;
   int longs_now_count=0;
   
   static int shorts_hist_count=0;
   static int longs_hist_count=0;
   
   static double longs_hist_profit=0;
   static double longs_hist_loss=0;
   static double shorts_hist_profit=0;
   static double shorts_hist_loss=0;
   static double longs_hist_profit_count=0;
   static double longs_hist_loss_count=0;
   static double shorts_hist_profit_count=0;
   static double shorts_hist_loss_count=0;
   
   static double largest_profit_trade=0;
   static double smallest_profit_trade=0;
   static double largest_loss_trade=0;
   static double smallest_loss_trade=0;
   static double profit_trades_count=0;
   static double loss_trades_count=0;
   static double average_profit_trade=0;
   static double average_loss_trade=0;
   
   static int consec_wins=0;
   static int consec_loss=0;
   static double last_profit=0;
   static bool consec_check_started=false;
   static int max_consec_wins=0;
   static int max_consec_loss=0;
   static double avg_consec_wins=0;
   static double avg_consec_loss=0;
   static int consec_profits_count=0;
   static int consec_losses_count=0;
   
   static double profit_factor=1;
   static double gross_profit=0;
   static double gross_loss=0;
   
   static double drawdown_abs=0;
   static double drawdown_rel=0;
   static double drawdown_max=0;
   static double maxpeak=0;
   static double minpeak=0;
   
   static double drawdown_balance_abs=0;
   static double drawdown_balance_rel=0;
   static double drawdown_balance_max=0;
   static double max_balance_peak=0;
   static double min_balance_peak=0;
   
   double profit_factor_live=0;
   double gross_profit_now=0;
   double gross_profit_live=0;
   double gross_loss_now=0;
   double gross_loss_live=0;
   //////
   
   //////
   // system static variables
   static int last_checked_trades_ticket=-1;
   static int last_checked_history_ticket=-1;
   static int orders_history_total=0;
   static int orders_history_total_checked=0; 
   static int orders_total=0;
   double retval=0;
   //////
   
   int pos=0;
   if (initial_money==-1) {initial_money=AccountEquity();}
   if (start_time==-1) {start_time=TimeCurrent();}
   total_net_profit=AccountEquity()-initial_money;
   
   if (OrdersHistoryTotal()!=orders_history_total)
   {
      orders_history_total=OrdersHistoryTotal();
      for (pos=OrdersHistoryTotal()-1; pos>=0; pos--)
      {
         if (OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY))
         {
            //if (OrderOpenTime()>=start_time) {
               if (orders_history_total > orders_history_total_checked)
               {
                  orders_history_total_checked++;
                  double PureProfit=OrderProfit()+OrderCommission()+OrderSwap();
                  if (PureProfit>largest_profit_trade) {largest_profit_trade=PureProfit;}
                  if (PureProfit<largest_loss_trade) {largest_loss_trade=PureProfit;}
                  if (PureProfit>0 && (PureProfit<smallest_profit_trade || smallest_profit_trade==0)) {smallest_profit_trade=PureProfit;}
                  if (PureProfit<0 && (PureProfit>smallest_loss_trade || smallest_loss_trade==0)) {smallest_loss_trade=PureProfit;}
               
                  if (OrderType()==OP_BUY) {longs_hist_count++;}
                  if (OrderType()==OP_SELL) {shorts_hist_count++;}
               
                  if (PureProfit>0)
                  {
                     if (OrderType()==OP_BUY) {longs_hist_profit_count++; longs_hist_profit=longs_hist_profit+PureProfit;}
                     if (OrderType()==OP_SELL) {shorts_hist_profit_count++; shorts_hist_profit=shorts_hist_profit+PureProfit;}
                     gross_profit=gross_profit+PureProfit;
                     profit_trades_count++;
                     average_profit_trade=gross_profit/profit_trades_count;
                     if (last_profit>0 || consec_check_started==false) {
                        consec_check_started=true; consec_wins++;
                     } else {consec_wins=1; consec_loss=0; consec_profits_count++;}
                    
                     if (consec_wins>max_consec_wins) {max_consec_wins=consec_wins;}
                     avg_consec_wins=profit_trades_count/(consec_profits_count+1);
                     last_profit=PureProfit;
                  }
                  else if (PureProfit<0)
                  {
                     if (OrderType()==OP_BUY) {longs_hist_loss_count++; longs_hist_loss=longs_hist_loss+PureProfit;}
                     if (OrderType()==OP_SELL) {shorts_hist_loss_count++; shorts_hist_loss=shorts_hist_loss+PureProfit;}
                     gross_loss=gross_loss+PureProfit;
                     loss_trades_count++;
                     average_loss_trade=gross_loss/loss_trades_count;
                     if (last_profit<0 || consec_check_started==false) {
                        consec_check_started=true; consec_loss++;
                     }
                     else {
                        consec_loss=1;
                        consec_wins=0;
                        consec_losses_count++;
                     }
                  
                     if (consec_loss>max_consec_loss) {
                        max_consec_loss=consec_loss;
                     }
                     avg_consec_loss=loss_trades_count/(consec_losses_count+1);
                     last_profit=PureProfit;
                  }
               }
            //} else {break;}
         }
      }
   }
   
   // Equity: Drawdown Maximum && Drawdown Relative
   if (AccountEquity()>maxpeak) {maxpeak=AccountEquity();}
   if ((maxpeak-AccountEquity())>drawdown_max) {drawdown_max=(maxpeak-AccountEquity()); drawdown_rel=NormalizeDouble((drawdown_max/maxpeak)*100,2);}
   
   // Equity: Drawdown Absolute
   if ((AccountEquity()<initial_money && (initial_money-AccountEquity())>drawdown_abs) || drawdown_abs==0) {drawdown_abs=(initial_money-AccountEquity());}
   
   // Balance: Drawdown Maximum && Drawdown Relative
   if (AccountBalance()>max_balance_peak) {max_balance_peak=AccountBalance();}
   if ((max_balance_peak-AccountBalance())>drawdown_balance_max) {drawdown_balance_max=(max_balance_peak-AccountBalance()); drawdown_balance_rel=NormalizeDouble((drawdown_balance_max/max_balance_peak)*100,2);}
   
   // Balance: Drawdown Absolute
   if ((AccountBalance()<initial_money && (initial_money-AccountBalance())>drawdown_balance_abs) || drawdown_balance_abs==0) {drawdown_balance_abs=(initial_money-AccountBalance());}
   
   if (get!="") {
   
      for (pos=OrdersTotal()-1; pos>=0; pos--)
      {
         if (OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
         {
            //if (OrderOpenTime()>=start_time) {
               if (OrderType()==OP_BUY) {longs_now_count++;}
               else if (OrderType()==OP_SELL) {shorts_now_count++;}
				  
               if (OrderProfit()+OrderCommission()+OrderSwap()>0) {
                  gross_profit_now=gross_profit_now+OrderProfit()+OrderCommission()+OrderSwap();
               }
               else if (OrderProfit()+OrderCommission()+OrderSwap()<0) {
                  gross_loss_now=gross_loss_now+OrderProfit()+OrderCommission()+OrderSwap();
               }
               if (OrderTicket()>last_checked_trades_ticket) {
                  last_checked_trades_ticket=OrderTicket();
               }
            //} else {break;}
         }
      }
      
      // Profit Factor
      if (gross_loss<0) {
         profit_factor=MathAbs(NormalizeDouble(gross_profit/gross_loss,2));
      }
      else {
         profit_factor=MathAbs(NormalizeDouble(gross_profit,2));
      }
      if (profit_factor==0) {profit_factor=1;}
      
      // Gross Profit / Loss (Live)
      gross_profit_live=gross_profit+gross_profit_now;
      gross_loss_live=gross_loss+gross_loss_now;
      
      // Profit Factor (Live)
      if ((gross_loss+gross_loss_now)<0) {
         profit_factor_live=MathAbs(NormalizeDouble(((gross_profit+gross_profit_now)/(gross_loss+gross_loss_now)),2));
      }
      else {
         profit_factor_live=MathAbs(NormalizeDouble((gross_profit+gross_profit_now),2));
      }
      if (profit_factor_live==0) {profit_factor_live=1;}
      
      // Total Trades
      int longs_total_count   =longs_hist_count+longs_now_count;
      int shorts_total_count  =shorts_hist_count+shorts_now_count;
      int trades_hist_count   =longs_hist_count+shorts_hist_count;
      int trades_now_count    =longs_now_count+shorts_now_count;
      int trades_total_count  =longs_total_count+shorts_total_count;
      
      if (get=="initial_money")        {return(initial_money);}
      //---
      if (get=="profit_factor_history"){return(profit_factor);}
      if (get=="profit_factor_total")  {return(profit_factor_live);}
      //---
      if (get=="gross_profit_history") {return(gross_profit);}
      if (get=="gross_profit_now")     {return(gross_profit_now);}
      if (get=="gross_profit_total")   {return(gross_profit_live);}
      //---
      if (get=="gross_loss_history")   {return(gross_loss);}
      if (get=="gross_loss_now")       {return(gross_loss_now);}
      if (get=="gross_loss_total")     {return(gross_loss_live);}
      //---
      if (get=="trades_count_history") {return(trades_hist_count);}
      if (get=="trades_count_now")     {return(trades_now_count);}
      if (get=="trades_count_total")   {return(trades_total_count);}
      //---
      if (get=="longs_count_history")  {return(longs_hist_count);}
      if (get=="longs_count_now")      {return(longs_now_count);}
      if (get=="longs_count_total")    {return(longs_total_count);}
      //---
      if (get=="shorts_count_history") {return(shorts_hist_count);}
      if (get=="shorts_count_now")     {return(shorts_now_count);}
      if (get=="shorts_count_total")   {return(shorts_total_count);}
      //---
      if (get=="drawdown_equity_relative") {return(drawdown_rel);}
      if (get=="drawdown_equity_absolute") {return(drawdown_abs);}
      if (get=="drawdown_equity_maximal")  {return(drawdown_max);}
      //---
      if (get=="drawdown_balance_relative") {return(drawdown_balance_rel);}
      if (get=="drawdown_balance_absolute") {return(drawdown_balance_abs);}
      if (get=="drawdown_balance_maximal")  {return(drawdown_balance_max);}
      //---
      if (get=="consec_wins_max" || get=="consec_wins_maximum" || get=="consec_wins_maximal") {return(max_consec_wins);}
      if (get=="consec_wins_avg" || get=="consec_wins_average") {return(avg_consec_wins);}
      //---
      //---
      if (get=="consec_losses_max" || get=="consec_losses_maximum" || get=="consec_losses_maximal") {return(max_consec_loss);}
      if (get=="consec_losses_avg" || get=="consec_losses_average") {return(avg_consec_loss);}
   }
   return(-1);
}

bool HistoryTradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (OrderSelect((int)index, SELECT_BY_POS, MODE_HISTORY) && OrderType() < 2)
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
	// both input parameters are dummy
	// they exist only to make the function compatible with MQL5-like code

	return OrdersHistoryTotal();
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

bool IsOrderTypeBuy()
{
	int type = OrderType();

	return (type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT);
}

bool IsOrderTypeSell()
{
	int type = OrderType();

	return (type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT);
}

string LoadedObjectName(string name="") {static string memory=""; if (name!="") {memory=name;} return(memory);}

double LongsCount(string mode="total") {
   if (mode=="") {mode="total";}
   if (mode=="history" || mode=="now" || mode=="total") {
      return(GetStatistics("longs_count_"+mode));
   } return(-1);
}

bool LoopedResume()
{
	ulong ticket  = attrTicketInLoop();
	int type      = attrTypeInLoop();

	if (ticket > 0 && ticket != OrderTicket())
	{
		     if (type == 1) return OrderSelect((int)ticket,SELECT_BY_TICKET);
		else if (type == 2) return OrderSelect((int)ticket,SELECT_BY_TICKET);
		else if (type == 3) return OrderSelect((int)ticket,MODE_HISTORY);
	}

	return false;
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
	long ticket,
	double op,
	double sll = 0,
	double tpl = 0,
	double slp = 0,
	double tpp = 0,
	datetime exp = 0,
	color clr = clrNONE,
	bool ontrade_event = true
) {
	int bs = 1;

	if (
		   OrderType() == OP_SELL
		|| OrderType() == OP_SELLSTOP
		|| OrderType() == OP_SELLLIMIT
	)
	{bs = -1;} // Positive when Buy, negative when Sell

	while (true)
	{
		uint time0 = GetTickCount();

		WaitTradeContextIfBusy();

		if (!OrderSelect((int)ticket, SELECT_BY_TICKET))
		{
			return false;
		}

		string symbol      = OrderSymbol();
		int type           = OrderType();
		double ask         = SymbolInfoDouble(symbol, SYMBOL_ASK);
		double bid         = SymbolInfoDouble(symbol, SYMBOL_BID);
		int digits         = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
		double point       = SymbolInfoDouble(symbol, SYMBOL_POINT);
		double stoplevel   = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
		double freezelevel = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (OrderType() < 2) {op = OrderOpenPrice();} else {op = NormalizeDouble(op,digits);}

		sll = NormalizeDouble(sll, digits);
		tpl = NormalizeDouble(tpl, digits);

		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)
		{
			break;
		}
		
		//-- OP -----------------------------------------------------------
		// https://book.mql4.com/appendix/limits
		if (type == OP_BUYLIMIT)
		{
			if (ask - op < stoplevel) {op = ask - stoplevel;}
			if (ask - op <= freezelevel) {op = ask - freezelevel - point;}
		}
		else if (type == OP_BUYSTOP)
		{
			if (op - ask < stoplevel) {op = ask + stoplevel;}
			if (op - ask <= freezelevel) {op = ask + freezelevel + point;}
		}
		else if (type == OP_SELLLIMIT)
		{
			if (op - bid < stoplevel) {op = bid + stoplevel;}
			if (op - bid <= freezelevel) {op = bid + freezelevel + point;}
		}
		else if (type == OP_SELLSTOP)
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
			sl = 0;
			tp = 0;

			double askbid = ask;
			if (bs < 0) {askbid = bid;}

			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					sl = vsl - EMERGENCY_STOPS_REL*MathAbs(askbid-vsl)*bs;

					if (sl <= 0) {sl = askbid;}

					sl = sl - toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;
				}
			}

			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					tp = vtp + EMERGENCY_STOPS_REL*MathAbs(vtp-askbid)*bs;

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

		if (
			   (OrderType() > 1 && op != NormalizeDouble(OrderOpenPrice(),digits))
			|| sl != NormalizeDouble(OrderStopLoss(),digits)
			|| tp != NormalizeDouble(OrderTakeProfit(),digits)
			|| exp != OrderExpirationTime()
		) {
			success = OrderModify((int)ticket, op, sl, tp, exp, clr);
		}

		//-- error check --------------------------------------------------
		int erraction = CheckForTradingError(GetLastError(), "Modify error");

		switch(erraction)
		{
			case 0: break;    // no error
			case 1: continue; // overcomable error
			case 2: break;    // fatal error
		}

		//-- finish work --------------------------------------------------
		if (success == true)
		{
			if (!IsTesting() && !IsVisualMode())
			{
				Print("Operation details: Speed " + (string)(GetTickCount()-time0) + " ms");
			}

			if (ontrade_event == true)
			{
				OrderModified(ticket);
				OnTrade();
			}

			if (OrderSelect((int)ticket,SELECT_BY_TICKET)) {}

			return true;
		}

		break;
	}

	return false;
}

bool ModifyStops(int ticket, double sl=-1, double tp=-1, color clr=clrNONE)
{
   return ModifyOrder(
		ticket,
		OrderOpenPrice(),
		sl,
		tp,
		0,
		0,
		OrderExpirationTime(),
		clr
	);
}

int OCODriver()
{
	static int last_known_ticket = 0;
   static int orders1[];
   static int orders2[];
   int i, size;
   
   int total = OrdersTotal();
   
   for (int pos=total-1; pos>=0; pos--)
   {
      if (OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
      {
         int ticket = OrderTicket();
         
         //-- end here if we reach the last known ticket
         if (ticket == last_known_ticket) {break;}
         
         //-- set the last known ticket, only if this is the first iteration
         if (pos == total-1) {
            last_known_ticket = ticket;
         }
         
         //-- we are searching for pending orders, skip trades
         if (OrderType() <= OP_SELL) {continue;}
         
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
      if (OrderSelect(orders1[i], SELECT_BY_TICKET, MODE_TRADES) == false || OrderType() <= OP_SELL)
      {
         if (OrderSelect(orders2[i], SELECT_BY_TICKET, MODE_TRADES)) {
            if (DeleteOrder(orders2[i],clrWhite))
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
      if (OrderSelect(orders2[i], SELECT_BY_TICKET, MODE_TRADES) == false || OrderType() <= OP_SELL)
      {
         if (OrderSelect(orders1[i], SELECT_BY_TICKET, MODE_TRADES)) {
            if (DeleteOrder(orders1[i],clrWhite))
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

double ObjectGetValueByShift(long ctart_id, string name, int shift)
{
	MqlRates rates[];
	CopyRates(NULL, PERIOD_CURRENT, shift, 1, rates);

	return ObjectGetValueByTime(ctart_id, name, rates[0].time, 0);
}

bool OnTimerSet(double seconds)
{
   if (FXD_ONTIMER_TAKEN)
   {
      if (seconds<=0) {
         FXD_ONTIMER_TAKEN_IN_MILLISECONDS = false;
         FXD_ONTIMER_TAKEN_TIME = 0;
      }
      else if (seconds < 1) {
         FXD_ONTIMER_TAKEN_IN_MILLISECONDS = true;
         FXD_ONTIMER_TAKEN_TIME = seconds*1000; 
      }
      else {
         FXD_ONTIMER_TAKEN_IN_MILLISECONDS = false;
         FXD_ONTIMER_TAKEN_TIME = seconds;
      }
      
      return true;
   }

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

class OnTradeEventDetector
{
private:
	//--- structures
	struct EventValues
	{
		// special fields
		string   reason,
		         detail;

		// order related fields
		long     magic,
		         ticket;
		int      type;
		datetime timeClose,
		         timeOpen,
		         timeExpiration;
		double   commission,
		         priceOpen,
		         priceClose,
		         profit,
		         stopLoss,
		         swap,
		         takeProfit,
		         volume;
		string   comment,
		         symbol;
	};
	
	struct Position
	{
		int type;
		long     magic,
		         ticket;
		datetime timeClose,
		         timeExpiration,
		         timeOpen;
		double   commission,
		         priceCurrent,
		         priceOpen,
		         profit,
		         stopLoss,
		         swap,
		         takeProfit,
		         volume;
		string   comment,
		         symbol;
	};

	struct PendingOrder
	{
		int type;
		long     magic,
		         ticket;
		datetime timeClose,
		         timeExpiration,
		         timeOpen;
		double   priceCurrent,
		         priceOpen,
		         stopLoss,
		         takeProfit,
		         volume;
		string   comment,
		         symbol;
	};
	
	struct PositionExpirationTimes
	{
		long ticket;
		datetime timeExpiration;
	};
	
	//--- variables and arrays
	bool debug;

	int eventValuesQueueIndex;
	EventValues eventValues[];

	PendingOrder previousPendingOrders[];
	PendingOrder pendingOrders[];

	Position previousPositions[];
	Position positions[];

	PositionExpirationTimes positionExpirationTimes[];

	//--- methods
	
	/**
	* Like ArrayCopy(), but for any type.
	*/
	template<typename T>
	void CopyList(T &dest[], T &src[])
	{
		int size = ArraySize(src);
		ArrayResize(dest, size);

		for (int i = 0; i < size; i++)
		{
			dest[i] = src[i];
		}
	}

	/**
	* Overloaded method 1 of 2
	*/
	int MakeListOf(PendingOrder &list[])
	{
		ArrayResize(list, 0);

		int count        = OrdersTotal();
		int howManyAdded = 0;

		for (int index = 0; index < count; index++)
		{
			if (OrderSelect(index, SELECT_BY_POS) == false) continue;
			if (OrderType() < OP_BUYLIMIT) continue;

			howManyAdded++;
			ArrayResize(list, howManyAdded);
			int i = howManyAdded - 1;

			// int
			list[i].type   = OrderType();
			list[i].magic  = OrderMagicNumber();
			list[i].ticket = OrderTicket();

			// datetime
			list[i].timeClose      = OrderCloseTime();
			list[i].timeExpiration = OrderExpiration();
			list[i].timeOpen       = OrderOpenTime();

			// double
			list[i].priceCurrent = OrderClosePrice();
			list[i].priceOpen    = OrderOpenPrice();
			list[i].stopLoss     = OrderStopLoss();
			list[i].takeProfit   = OrderTakeProfit();
			list[i].volume       = OrderLots();

			// string
			list[i].comment = OrderComment();
			list[i].symbol  = OrderSymbol();
		}

		return howManyAdded;
	}

	/**
	* Overloaded method 2 of 2
	*/
	int MakeListOf(Position &list[])
	{
		ArrayResize(list, 0);

		int count        = OrdersTotal();
		int howManyAdded = 0;

		for (int index = 0; index < count; index++)
		{
			if (OrderSelect(index, SELECT_BY_POS) == false) continue;
			if (OrderType() > OP_SELL) continue;

			howManyAdded++;
			ArrayResize(list, howManyAdded);
			int i = howManyAdded - 1;

			// int
			list[i].type   = OrderType();
			list[i].magic  = OrderMagicNumber();
			list[i].ticket = OrderTicket();

			// datetime
			list[i].timeClose      = OrderCloseTime();
			list[i].timeExpiration = (datetime)0;
			list[i].timeOpen       = OrderOpenTime();

			// double
			list[i].commission   = OrderCommission();
			list[i].priceCurrent = OrderClosePrice();
			list[i].priceOpen    = OrderOpenPrice();
			list[i].profit       = OrderProfit();
			list[i].stopLoss     = OrderStopLoss();
			list[i].swap         = OrderSwap();
			list[i].takeProfit   = OrderTakeProfit();
			list[i].volume       = OrderLots();

			// string
			list[i].comment = OrderComment();
			list[i].symbol  = OrderSymbol();
			
			// extract expiration
			list[i].timeExpiration = expirationWorker.GetExpiration(list[i].ticket);

			if (USE_VIRTUAL_STOPS)
			{
				list[i].stopLoss   = VirtualStopsDriver("get sl", list[i].ticket);
				list[i].takeProfit = VirtualStopsDriver("get tp", list[i].ticket);
			}
		}

		return howManyAdded;
	}

	/**
	* This method loops through 2 lists of items and finds a difference. This difference is the event.
	* "Items" are either pending orders or positions.
	*
	* Returns true if an event is detected or false if not.
	*/
	template<typename ITEMS_TYPE> 
	bool DetectEvent(ITEMS_TYPE &previousItems[], ITEMS_TYPE &currentItems[])
	{
		ITEMS_TYPE item;
		string reason   = "";
		string detail   = "";
		int countBefore = ArraySize(previousItems);
		int countNow    = ArraySize(currentItems);

		// New
		if (countBefore < countNow)
		{
			item   = currentItems[countNow - 1];
			reason = "new";
		}
		// Gone
		else if (countBefore > countNow)
		{
			item   = FindMissingItem(previousItems, currentItems);
			reason = "close";
		}
		// Same => check for modifications
		else if (countBefore == countNow && countNow > 0)
		{
			int count = ArraySize(currentItems);

			for (int index = 0; index < count; index++)
			{
				item = currentItems[index];
				ITEMS_TYPE previous = previousItems[index];
				ITEMS_TYPE current  = currentItems[index];

				if (previous.ticket != current.ticket)
				{
					// The order changes when a trade is closed partially - the original ticket is gone ane a new one is created at the end
					// That's why we are gonna check whether the parent of the last trade is the same as the previous trade
					current = currentItems[count - 1];

					if (previous.ticket == attrTicketParent(current.ticket))
					{
						item = current;
						reason = "decrement";
					}
					else
					{
						Print("Positions order mismatch");
					}

					break;
				}

				if (previous.volume != current.volume)
				{
					// Volume increment
					if (previous.volume < current.volume)
					{
						reason = "increment";

						break;
					}
					// Volume decrement
					else
					{
						reason = "decrement";

						break;
					}
				}

				// SL & TP modified
				if (
					   previous.stopLoss != current.stopLoss
					&& previous.takeProfit != current.takeProfit
				) {
					reason = "modify";
					detail = "sltp";

					break;
				}
				// SL modified
				else if (previous.stopLoss != current.stopLoss)
				{
					reason = "modify";
					detail = "sl";

					break;
				}
				// TP modified
				else if (previous.takeProfit != current.takeProfit)
				{
					reason = "modify";
					detail = "tp";

					break;
				}
				
				if (previous.timeExpiration != current.timeExpiration)
				{
					reason = "modify";
					detail = "expiration";

					break;
				}
			}
		}

		if (reason == "")
		{
			return false;
		}

		UpdateValues(item, reason, detail);

		return true;
	}
	
	/**
	* From the list of previous orders or positions, find the item that is missing
	* in the list of current orders or positions.
	*
	* Return the ticket number or 0 if nothing is found.
	*/
	template<typename T> 
	T FindMissingItem(T &previous[], T &current[])
	{
		int previousCount = ArraySize(previous);
		int currentCount  = ArraySize(current);
		T item;

		long ticket = 0;

		for (int i = 0; i < previousCount; i++)
		{
			bool found = false;

			for (int j = 0; j < currentCount; j++)
			{
				if (previous[i].ticket == current[j].ticket)
				{
					found = true;
					break;
				}
			}

			if (found == false)
			{
				item = previous[i];
				break;
			}
		}

		return item;
	}
	
	/**
	* Overloaded method 1 of 2
	*/
	void UpdateValues(Position &item, string reason, string detail)
	{
		long ticket        = item.ticket;
		datetime timeOpen  = item.timeOpen;
		datetime timeClose = item.timeClose;
		double priceOpen   = item.priceOpen;
		double priceClose  = item.priceCurrent;
		double profit      = item.profit;
		double swap        = item.swap;
		double commission  = item.commission;
		double volume      = item.volume;

		if (reason == "close" || reason == "decrement")
		{
			if (OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_HISTORY))
			{
				timeOpen   = OrderOpenTime();
				timeClose  = OrderCloseTime();
				priceOpen  = OrderOpenPrice();
				priceClose = OrderClosePrice();
				profit     = OrderProfit();
				swap       = OrderSwap();
				commission = OrderCommission();
				volume     = OrderLots();

				if (detail == "")
				{
					if (
						item.timeExpiration > 0
						&& item.timeExpiration <= timeClose
					) {
						detail = "expiration";
					}
				}

				if (detail == "")
				{
					string comment = OrderComment();

					// Try with comments, which works in the Tester, but it could not work in real
					     if (comment == "[tp]") detail = "tp";
					else if (comment == "[sl]") detail = "sl";

					// Try to detect close by SL or TP by the close price
					if (detail == "")
					{
						int type = item.type;

						double sl = OrderStopLoss();
						double tp = OrderTakeProfit();

						if (type == 0) // BUY
						{
							     if (sl > 0 && priceClose <= sl) detail = "sl";
							else if (tp > 0 && priceClose >= tp) detail = "tp";
						}
						else if (type == 1) // SELL
						{
							     if (sl > 0 && priceClose >= sl) detail = "sl";
							else if (tp > 0 && priceClose <= tp) detail = "tp";
						}
					}
				}
			}
		}

		int i = eventValuesQueueIndex;

		eventValues[i].reason = reason;
		eventValues[i].detail = detail;
 
		eventValues[i].priceClose     = priceClose;
		eventValues[i].timeClose      = timeClose;
		eventValues[i].comment        = item.comment;
		eventValues[i].commission     = commission;
		eventValues[i].timeExpiration = item.timeExpiration;
		eventValues[i].volume         = volume;
		eventValues[i].magic          = item.magic;
		eventValues[i].priceOpen      = priceOpen;
		eventValues[i].timeOpen       = timeOpen;
		eventValues[i].profit         = profit;
		eventValues[i].stopLoss       = item.stopLoss;
		eventValues[i].swap           = swap;
		eventValues[i].symbol         = item.symbol;
		eventValues[i].takeProfit     = item.takeProfit;
		eventValues[i].ticket         = ticket;
		eventValues[i].type           = item.type;

		if (debug)
		{
			PrintUpdatedValues();
		}
	}
	
	/**
	* Overloaded method 2 of 2
	*/
	void UpdateValues(PendingOrder &item, string reason, string detail)
	{
		int i = eventValuesQueueIndex;

		eventValues[i].reason = reason;
		eventValues[i].detail = detail;

		eventValues[i].priceClose     = item.priceCurrent;
		eventValues[i].timeClose      = item.timeClose;
		eventValues[i].comment        = item.comment;
		eventValues[i].commission     = 0.0;
		eventValues[i].timeExpiration = item.timeExpiration;
		eventValues[i].volume         = item.volume;
		eventValues[i].magic          = item.magic;
		eventValues[i].priceOpen      = item.priceOpen;
		eventValues[i].timeOpen       = item.timeOpen;
		eventValues[i].profit         = 0.0;
		eventValues[i].stopLoss       = item.stopLoss;
		eventValues[i].swap           = 0.0;
		eventValues[i].symbol         = item.symbol;
		eventValues[i].takeProfit     = item.takeProfit;
		eventValues[i].ticket         = item.ticket;
		eventValues[i].type           = item.type;

		if (debug)
		{
			PrintUpdatedValues();
		}
	}

	void PrintUpdatedValues()
	{
		Print(
			" <<<"
		);
		
		Print(
			" | reason: ", e_Reason(),
			" | detail: ", e_ReasonDetail(),
			" | ticket: ", e_attrTicket(),
			" | type: ", EnumToString((ENUM_ORDER_TYPE)e_attrType())
		);
		
		Print(
			" | openTime : ", e_attrOpenTime(),
			" | openPrice : ", e_attrOpenPrice()
		);
		
		Print(
			" | closeTime: ", e_attrCloseTime(),
			" | closePrice: ", e_attrClosePrice()
		);
		
		Print(
			" | volume: ", e_attrLots(),
			" | sl: ", e_attrStopLoss(),
			" | tp: ", e_attrTakeProfit(),
			" | profit: ", e_attrProfit(),
			" | swap: ", e_attrSwap(),
			" | exp: ", e_attrExpiration(),
			" | comment: ", e_attrComment()
		);
		
		Print(
			">>>"
		);
	}

	int AddEventValues()
	{
		eventValuesQueueIndex++;
		ArrayResize(eventValues, eventValuesQueueIndex + 1);

		return eventValuesQueueIndex;
	}

	int RemoveEventValues()
	{
		if (eventValuesQueueIndex == -1)
		{
			Print("Cannot remove event values, add them first. (in function ", __FUNCTION__, ")");
		}
		else
		{
			eventValuesQueueIndex--;
			ArrayResize(eventValues, eventValuesQueueIndex + 1);
		}

		return eventValuesQueueIndex;
	}

public:
	/**
	* Default constructor
	*/
	OnTradeEventDetector(void)
	{
		debug = false;
		eventValuesQueueIndex = -1;
	};

	bool Start()
	{
		AddEventValues();

		MakeListOf(positions);
		MakeListOf(pendingOrders);

		bool success = false;

		if (!success) success = DetectEvent(previousPositions, positions);

		if (!success) success = DetectEvent(previousPendingOrders, pendingOrders);

		CopyList(previousPositions, positions);
		CopyList(previousPendingOrders, pendingOrders);

		return success;
	}

	void End()
	{
		RemoveEventValues();
	}

	string EventValueReason() {return eventValues[eventValuesQueueIndex].reason;}
	string EventValueDetail() {return eventValues[eventValuesQueueIndex].detail;}

	int EventValueType() {return eventValues[eventValuesQueueIndex].type;}

	datetime EventValueTimeClose()      {return eventValues[eventValuesQueueIndex].timeClose;}
	datetime EventValueTimeOpen()       {return eventValues[eventValuesQueueIndex].timeOpen;}
	datetime EventValueTimeExpiration() {return eventValues[eventValuesQueueIndex].timeExpiration;}

	long EventValueMagic()  {return eventValues[eventValuesQueueIndex].magic;}
	long EventValueTicket() {return eventValues[eventValuesQueueIndex].ticket;}

	double EventValueCommission() {return eventValues[eventValuesQueueIndex].commission;}
	double EventValuePriceOpen()  {return eventValues[eventValuesQueueIndex].priceOpen;}
	double EventValuePriceClose() {return eventValues[eventValuesQueueIndex].priceClose;}
	double EventValueProfit()     {return eventValues[eventValuesQueueIndex].profit;}
	double EventValueStopLoss()   {return eventValues[eventValuesQueueIndex].stopLoss;}
	double EventValueSwap()       {return eventValues[eventValuesQueueIndex].swap;}
	double EventValueTakeProfit() {return eventValues[eventValuesQueueIndex].takeProfit;}
	double EventValueVolume()     {return eventValues[eventValuesQueueIndex].volume;}

	string EventValueComment() {return eventValues[eventValuesQueueIndex].comment;}
	string EventValueSymbol()  {return eventValues[eventValuesQueueIndex].symbol;}
};

OnTradeEventDetector onTradeEventDetector;

int OrderCreate(
	string   symbol     = "",
	int      type       = OP_BUY,
	double   lots       = 0,
	double   op         = 0,
	double   sll        = 0, // SL level
	double   tpl        = 0, // TO level
	double   slp        = 0, // SL adjust in points
	double   tpp        = 0, // TP adjust in points
	double   slippage   = 0,
	int      magic      = 0,
	string   comment    = "",
	color    arrowcolor = CLR_NONE,
	datetime expiration = 0,
	bool     oco        = false
	)
{
	uint time0 = GetTickCount(); // used to measure speed of execution of the order

	int ticket = -1;
	bool placeExpirationObject = false; // whether or not to create an object for expiration for trades

	// calculate buy/sell flag (1 when Buy or -1 when Sell)
	int bs = 1;

	if (
		   type == OP_SELL
		|| type == OP_SELLSTOP
		|| type == OP_SELLLIMIT
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

	//-- attempt to send trade/order -------------------------------------
	while (!IsStopped())
	{
		WaitTradeContextIfBusy();

		static bool not_allowed_message = false;

		if (
			   !MQLInfoInteger(MQL_TESTER)
			&& !MarketInfo(symbol, MODE_TRADEALLOWED)
		) {
			if (not_allowed_message == false)
			{
				Print("Market ("+symbol+") is closed");
			}

			not_allowed_message = true;

			return false;
		}

		not_allowed_message = false;

		digits   = (int)MarketInfo(symbol, MODE_DIGITS);
		ask      = MarketInfo(symbol, MODE_ASK);
		bid      = MarketInfo(symbol, MODE_BID);
		point    = MarketInfo(symbol, MODE_POINT);
		ticksize = MarketInfo(symbol, MODE_TICKSIZE);

		//- not enough money check: fix maximum possible lot by margin required, or quit
		if (type==OP_BUY || type==OP_SELL)
		{
			double LotStep          = MarketInfo(symbol,MODE_LOTSTEP);
			double MinLots          = MarketInfo(symbol,MODE_MINLOT);
			double margin_required  = MarketInfo(symbol,MODE_MARGINREQUIRED);
			static bool not_enough_message = false;

			if (margin_required != 0)
			{
				double max_size_by_margin = AccountFreeMargin() / margin_required;

				if (lots > max_size_by_margin)
				{
					double size_old = lots;
					lots = max_size_by_margin;

					if (lots < MinLots)
					{
						if (not_enough_message == false)
						{
							Print("Not enough money to trade :( The robot is still working, waiting for some funds to appear...");
						}

						not_enough_message = true;
						return false;
					}
					else
					{
						lots = MathFloor(lots / LotStep) * LotStep;

						Print("Not enough money to trade " + DoubleToString(size_old, 2)+", the volume to trade will be the maximum possible of " + DoubleToString(lots, 2));
					}
				}
			}

			not_enough_message = false;
		}

		// fix the comment, because it seems that the comment is deleted if its lenght is > 31 symbols
		if (StringLen(comment) > 31)
		{
			comment = StringSubstr(comment,0,31);
		}

		//- expiration for trades
		if (type == OP_BUY || type == OP_SELL)
		{
			if (expiration > 0)
			{
				//- bo broker?
				if (
					   StringLen(symbol) > 6
					&& StringSubstr(symbol, StringLen(symbol) - 2) == "bo"
				) {
					//- convert UNIX to seconds
					if (expiration > TimeCurrent()-100) {
						expiration = expiration - TimeCurrent();
					}

					comment = "BO exp:" + (string)expiration;
				}
				else
				{
					// The expiration in this case is a vertical line
					// Comment doesn't always work,
					// because it changes when the trade is partially closed
					placeExpirationObject = true;
				}
			}
		}

		if (type == OP_BUY || type == OP_SELL)
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
		vsl = 0; vtp = 0;

		sl = AlignStopLoss(symbol, type, op, 0, NormalizeDouble(sll, digits), slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol, type, op, 0, NormalizeDouble(tpl, digits), tpp);

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

		//-- fix expiration for pending orders ----------------------------
		if (expiration > 0 && type > OP_SELL)
		{
			if ((expiration - TimeCurrent()) < (11 * 60))
			{
				Print("Expiration time cannot be less than 11 minutes, so it was automatically modified to 11 minutes.");
				expiration = TimeCurrent() + (11 * 60);
			}
		}

		//-- fix prices by ticksize
		op = MathRound(op / ticksize) * ticksize;
		sl = MathRound(sl / ticksize) * ticksize;
		tp = MathRound(tp / ticksize) * ticksize;

		//-- send ---------------------------------------------------------
		ResetLastError();

		ticket = OrderSend(
			symbol,
			type,
			lots,
			op,
			(int)(slippage * PipValue(symbol)),
			sl,
			tp,
			comment,
			magic,
			expiration,
			arrowcolor
		);

		//-- error check --------------------------------------------------
		string msg_prefix = (type > OP_SELL) ? "New order error" : "New trade error";

		int erraction = CheckForTradingError(GetLastError(), msg_prefix);

		switch(erraction)
		{
			case 0: break;    // no error
			case 1: continue; // overcomable error
			case 2: break;    // fatal error
		}

		//-- finish work --------------------------------------------------
		if (ticket > 0)
		{
			if (USE_VIRTUAL_STOPS)
			{
				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));
			}

			//-- show some info
			double slip = 0;

			if (OrderSelect(ticket, SELECT_BY_TICKET))
			{
				if (placeExpirationObject)
				{
					expirationWorker.SetExpiration(ticket, expiration);
				}

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
				&&!MQLInfoInteger(MQL_OPTIMIZATION)
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

						ModifyOrder(ticket, OrderOpenPrice(), sl, tp, 0, 0, 0, CLR_NONE, false);
					}
				}
			}

			OnTrade();

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

		if (typeoco == OP_BUYSTOP)
		{
			typeoco = OP_SELLSTOP;
			op = bid - MathAbs(op - ask);
		}
		else if (typeoco == OP_BUYLIMIT)
		{
			typeoco = OP_SELLLIMIT;
			op = bid + MathAbs(op - ask);
		}
		else if (typeoco == OP_SELLSTOP)
		{
			typeoco = OP_BUYSTOP;
			op = ask + MathAbs(op - bid);
		}
		else if (typeoco == OP_SELLLIMIT)
		{
			typeoco = OP_BUYLIMIT;
			op = ask - MathAbs(op - bid);
		}

		if (typeoco == OP_BUYSTOP || typeoco == OP_BUYLIMIT)
		{
			sl = (sl > 0) ? op - sl : 0;
			tp = (tp > 0) ? op + tp : 0;
			arrowcolor = clrBlue;
		}
		else
		{
			sl = (sl > 0) ? op + sl : 0;
			tp = (tp > 0) ? op - tp : 0;
			arrowcolor = clrRed;
		}

		comment = "[oco:" + (string)ticket + "]";

		OrderCreate(symbol, typeoco, lots, op, sl, tp, 0, 0, slippage, magic, comment, arrowcolor, expiration, false);
	}

	return ticket;
}

/**
* This is a replacement for the system function.
* The difference is that this can also get the expiration for trades.
*/
datetime OrderExpiration(bool check_trade)
{
	datetime expiration = (datetime)0;

	if (OrderType() > OP_SELL)
	{
		expiration = OrderExpiration();
	}
	else if (check_trade)
	{
		expiration = (datetime)expirationWorker.GetExpiration(OrderTicket());
	}

	return expiration;
}

/**
* This is a replacement for the system function.
* The difference is that this can also get the expiration for trades.
*/
datetime OrderExpirationTime()
{
	datetime expiration = (datetime)0;

	if (OrderType() > OP_SELL)
	{
		expiration = OrderExpiration();
	}
	else
	{
		expiration = (datetime)expirationWorker.GetExpiration(OrderTicket());
	}

	return expiration;
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

bool PendingOrderSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both",
	string LimitsOrStops = "both"
)
{
	if (OrderSelect(index, SELECT_BY_POS, MODE_TRADES))
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells,
			LimitsOrStops,
			1)
		) {
			return true;
		}
	}

	return false;
}

bool PendingOrderSelectByTicket(ulong ticket)
{
	if (OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES) && OrderType() > 1)
	{
		return true;
	}

	return false;
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

int SellLater(
	string symbol,
	double lots,
	double price,
	double sll = 0, // SL level
	double tpl = 0, // TP level
	double slp = 0, // SL adjust in points
	double tpp = 0, // TP adjust in points
	double slippage = 0,
	datetime expiration = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	bool oco = false
	)
{
	double bid = SymbolInfoDouble(symbol,SYMBOL_BID);
	int type = 0;

		  if (price == bid) {type = OP_SELL;}
	else if (price < bid)  {type = OP_SELLSTOP;}
	else if (price > bid)  {type = OP_SELLLIMIT;}
	
	return OrderCreate(
		symbol,
		type,
		lots,
		price,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration,
		oco
	);
}

int SellNow(
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
		OP_SELL,
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

double ShortsCount(string mode="total") {
   if (mode=="") {mode="total";}
   if (mode=="history" || mode=="now" || mode=="total") {
      return(GetStatistics("shorts_count_"+mode));
   } return(-1);
}

bool SkipThePass(bool set=false)
{
   static int mem_fid=0;
   static bool mem=false;
   if (set==true) {
      mem=true;
      mem_fid=FXD_CURRENT_FUNCTION_ID;
   }
   else {
      if (mem_fid!=FXD_CURRENT_FUNCTION_ID) {
         mem=false; // reset
         return(false);
      }
      if (mem==true) {
         mem=false; // reset
         return(true);
      }
   }
   return(mem);
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
      retval = StringConcatenate(retval, (string)array[i], delimeter);
   }
	
   return StringSubstr(retval, 0, (StringLen(retval) - StringLen(delimeter)));
}

datetime StringToTimeEx(string str, string mode="server")
{
	// mode: server, local, gmt
	if (StringFind(str, " ") != -1) {
	   return StringToTime(str);
	}
	
	datetime now = 0;
	datetime retval = 0;
	
	if (mode == "server") {now = TimeCurrent();}
	else if (mode == "local") {now = TimeLocal();}
	else if (mode == "gmt") {now = TimeGMT();}
	
	return StringToTime((string)TimeYear(now)+"."+(string)TimeMonth(now)+"."+(string)TimeDay(now)+" "+str);
}

string StringTrim(string text)
{
   text = StringTrimRight(text);
   text = StringTrimLeft(text);
	
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

bool TradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (OrderSelect((int)index, SELECT_BY_POS, MODE_TRADES) && OrderType() < 2)
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells,
			"both",
			0)
		) {
			return true;
		}
	}

	return false;
}

bool TradeSelectByTicket(ulong ticket)
{
	if (OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES) && OrderType() < 2)
	{
		return true;
	}

	return false;
}

double TradesCount(string mode="total") {
   if (mode=="") {mode="total";}
   if (mode=="history" || mode=="now" || mode=="total") {
      return(GetStatistics("trades_count_"+mode));
   } return(-1);
}

int TradesTotal()
{
	return OrdersTotal();
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

void WaitTradeContextIfBusy()
{
	if(IsTradeContextBusy()) {
      while(true)
      {
         Sleep(1);
         if(!IsTradeContextBusy()) {
            RefreshRates();
            break;
         }
      }
   }
   return;
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

double attrLotsInitial()
{
   int ticket=OrderTicket();
   double retval=OrderLots();
   // When partially closing a trade, OrderLots() is modified to the
   // value of remaining lots after the partial close,
   // so, to get the whole value we need to sum all lots (when
   // partially closed multiple times)
   double second_lots=OrderLots();

   int T = OrderType();
   if (T!=OP_BUY && T!=OP_SELL) {return(0);}
   
   int M = OrderMagicNumber();
   string S = OrderSymbol();
   double OP = OrderOpenPrice();
   datetime OT = OrderOpenTime();
   double SL = OrderStopLoss();
   double TP = OrderTakeProfit();
   double L = OrderLots();
   
   int digits = (int)MarketInfo(S,MODE_DIGITS);       

   for (int i=OrdersHistoryTotal()-1; i>=0; i--) {
      if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) {
         // Searching for the match starting from newest trade
         // modify "retval" when match found, but end the loop
         // when the current trade is older than the one we search
         if (
            (OrderSymbol()==S)
            && (OrderMagicNumber()==M)
            && (NormalizeDouble(OrderOpenPrice(),digits)==NormalizeDouble(OP,digits))
            //&& (OrderLots()<L)
            && (OrderOpenTime()==OT)
            )
         {
            //Print("PartialExit Match from "+ticket+" found by ticket: "+OrderTicket());
            //Print("LOTS: "+OrderLots()+"+"+second_lots);
            retval=OrderLots()+second_lots;
            second_lots=OrderLots()+second_lots;
         }
         else if (OrderOpenTime()<OT) {
            // this trade is too old, break the loop here
            break;
         }
      }
   }
   // Reload the trade that we are working with
   int success = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
   return(retval); 
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

ulong attrTicketInLoop(ulong ticket=0)
{
	static ulong t;

	if (ticket > 0) {t = ticket;}

	return t;
}

long attrTicketParent(long ticket)
{
	int pos, total;
	long retval = 0;
	static long parents_idx[];
	static long parents[];

	//-- if parent ticket is known, return it ----------------------------
	int size = ArraySize(parents_idx);
	int idx  = -1;

	if (size > 0)
	{
		for (int i=size-1; i>=0; i--)
		{
			if (parents_idx[i] == ticket)
			{
				idx = i;
				break;
			}  
		}
	}

	if (idx >- 1)
	{
		retval = parents[idx];
	}
	else
	{
		if (!OrderSelect((int)ticket,SELECT_BY_TICKET))
		{
			retval = ticket;
		}

		//-- check if trade is added to volume ----------------------------
		if (retval == 0)
		{
			string comment = OrderComment();
			int p_pos      = StringFind(comment, "[p=");

			if (p_pos >= 0)
			{
				string p_tag = StringSubstr(comment,p_pos);
				p_tag        = StringSubstr(p_tag,0,StringFind(p_tag,"]")+1);
				retval       = (int)StringToInteger(StringSubstr(p_tag,3,-1));
			}
		}

		double OP   = OrderOpenPrice();
		datetime OT = OrderOpenTime();
		string S    = OrderSymbol();
		int M       = OrderMagicNumber();
		int T       = OrderType(); 
		double L    = OrderLots();
		int D       = (int)MarketInfo(S,MODE_DIGITS);

		//-- Check "from #Number" comment
		if (retval == 0)
		{
			total = OrdersTotal();
			long ticketTmp   = ticket;

			// Now start recursive search from trade to trade to find the parent one
			while (true)
			{
				if (!OrderSelect((int)ticketTmp, SELECT_BY_TICKET))
				{
					retval = ticket;
					break;
				}
						
				string comment = OrderComment();

				if (StringSubstr(comment, 0, 6) == "from #")
				{
					long ticketCurrent = (long)StringToInteger(StringSubstr(comment, 6));
					
					if (ticketTmp == ticketCurrent)
					{
						// eventually the most parent trade has its own ticket number in "from #Number", so stop here
						break;
					}
					else
					{
						// if the ticket number in "from #Number" is different, go to load that ticket number
						ticketTmp = ticketCurrent;
						continue;
					}
				}
				else
				{
					retval = ticketTmp;
					break;
				}
			}
		}

		//-- check if trade is partially closed (in trades) ---------------
		if (retval == 0)
		{
			total = OrdersTotal();

			for (pos=total-1; pos>=0; pos--)
			{
				if (OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
				{
					if (OrderOpenTime() < OT)
					{
						break;
					}

					if (
						OrderTicket() < ticket
						&& (OrderSymbol() == S)
						&& (OrderMagicNumber() == M)
						&& (OrderType() == T)
						&& (NormalizeDouble(OrderOpenPrice(),D) == NormalizeDouble(OP,D))
						&& (OrderOpenTime() == OT)
					)
					{
					
						retval = OrderTicket();
					}
				}
			}
		}

		//-- still nothing found - search in history trades now -----------
		if (retval == 0)
		{
			total = OrdersHistoryTotal();

			for (pos=total-1; pos>=0; pos--)
			{
				if (OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY))
				{
					if (OrderOpenTime() < OT)
					{
						break;
					}

					if (
						OrderTicket() < ticket
						&& (OrderSymbol() == S)
						&& (OrderMagicNumber() == M)
						&& (OrderType() == T)
						&& (NormalizeDouble(OrderOpenPrice(),D) == NormalizeDouble(OP,D))
						&& (OrderOpenTime() == OT)
					)
					{
						retval = OrderTicket();
					}
				}
			}
		}

		if (retval > 0)
		{
			size=ArraySize(parents_idx);
			ArrayResize(parents_idx,size+1);
			ArrayResize(parents,size+1);
			parents_idx[size] = ticket;
			parents[size]     = retval;
		}
	}

	if (!OrderSelect((int)ticket,SELECT_BY_TICKET))
	{
		retval = ticket;
	}

	if (retval <= 0)
	{
		retval = ticket;
	}

	return retval;
}

int attrTypeInLoop(int type=0)
{
	static int t;

	if (type > 0) {t = type;}

	return t;
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

string e_Reason() {return onTradeEventDetector.EventValueReason();}

string e_ReasonDetail() {return onTradeEventDetector.EventValueDetail();}

double e_attrClosePrice() {return onTradeEventDetector.EventValuePriceClose();}

datetime e_attrCloseTime() {return onTradeEventDetector.EventValueTimeClose();}

string e_attrComment() {return onTradeEventDetector.EventValueComment();}

datetime e_attrExpiration() {return onTradeEventDetector.EventValueTimeExpiration();}

double e_attrLots() {return onTradeEventDetector.EventValueVolume();}

int e_attrMagicNumber() {return (int)onTradeEventDetector.EventValueMagic();}

double e_attrOpenPrice() {return onTradeEventDetector.EventValuePriceOpen();}

datetime e_attrOpenTime() {return onTradeEventDetector.EventValueTimeOpen();}

double e_attrProfit() {return onTradeEventDetector.EventValueProfit();}

double e_attrStopLoss() {return onTradeEventDetector.EventValueStopLoss();}

double e_attrSwap() {return onTradeEventDetector.EventValueSwap();}

string e_attrSymbol() {return onTradeEventDetector.EventValueSymbol();}

double e_attrTakeProfit() {return onTradeEventDetector.EventValueTakeProfit();}

int e_attrTicket() {return (int)onTradeEventDetector.EventValueTicket();}

int e_attrType() {return onTradeEventDetector.EventValueType();}

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

void fxdGetInboundBlocks(int block_id, int &list[])
{
	if (block_id > -1 && ArraySize(_blocks_) > block_id) {
		ArrayCopy(list, _blocks_[block_id].__inbound_blocks);
	}
}

void fxdGetInboundBlocks(string block_string_id, int &list[])
{
	// first we need to get the numeric id of the block
	int block_id = ArraySearch(fxdBlocksLookupTable, block_string_id);

	if (block_id > -1 && ArraySize(_blocks_) > block_id) {
		ArrayCopy(list, _blocks_[block_id].__inbound_blocks);
	}
}

int iCandleID(string SYMBOL, ENUM_TIMEFRAMES TIMEFRAME, datetime time_stamp)
{
	bool TimeStampPrevDayShift = true;
	int CandleID               = 0;

	// get the time resolution of the desired period, in minutes
	int mins_tf  = TIMEFRAME;
	int mins_tf0 = 0;

	if (TIMEFRAME == PERIOD_CURRENT)
	{
		mins_tf = (int)PeriodSeconds(PERIOD_CURRENT) / 60;
	}

	// get the difference between now and the time we want, in minutes
	int days_adjust = 0;

	if (TimeStampPrevDayShift)
	{
		// automatically shift to the previous day
		if (time_stamp > TimeCurrent())
		{
			time_stamp = time_stamp - 86400;
		}

		// also shift weekdays
		while (true)
		{
			int dow = TimeDayOfWeek(time_stamp);

			if (dow > 0 && dow < 6) {break;}

			time_stamp = time_stamp - 86400;
			days_adjust++;
		}
	}

	int mins_diff = (int)(TimeCurrent() - time_stamp);
	mins_diff = mins_diff - days_adjust*86400;
	mins_diff = mins_diff / 60;

	// the difference is negative => quit here
	if (mins_diff < 0)
	{
		return (int)EMPTY_VALUE;
	}

	// now calculate the candle ID, it is relative to the current time
	if (mins_diff > 0)
	{
		CandleID = (int)MathCeil((double)mins_diff/(double)mins_tf);
	}

	// now, after all the shifting and in case of missing candles, the calculated candle id can be few candles early
	// so we will search for the right candle
	while(true)
	{
		if (iTime(SYMBOL, TIMEFRAME, CandleID) >= time_stamp) {break;}

		CandleID--;

		if (CandleID <= 0) {CandleID = 0; break;}
	}

	return CandleID;
}

double iZigZag(
	string symbol = NULL,
	ENUM_TIMEFRAMES timeframe = 0,
	int InpDepth = 12,
	int InpDeviation = 5,
	int InpBackstep = 3,
	int mode = 0,
	int shift = 0
)
{
	int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

	double value = iCustom(
		symbol,
		timeframe,
		"ZigZag",
		InpDepth,
		InpDeviation,
		InpBackstep,
		mode,
		shift
	);
	
	return NormalizeDouble(value, digits);
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