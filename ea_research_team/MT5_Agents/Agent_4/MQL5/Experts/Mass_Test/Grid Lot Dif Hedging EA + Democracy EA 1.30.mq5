//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2025, fxDreema  (//
//+------------------------------------------------------------------------------+//
#property copyright   ""
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
#define PROJECT_ID "mt4-8606"
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
input ENUM_TIMEFRAMES BIG_TF = PERIOD_D1;
input ENUM_TIMEFRAMES MEDIUM_TF = PERIOD_H4;
input ENUM_TIMEFRAMES SMALL_TF = PERIOD_H1;
input double _1_STO_K = 5.0;
input double _1_STO_D = 2.0;
input double _1_STO_Slow = 2.0;
input double _2_MACD_Fast = 12.0;
input double _2_MACD_Slow = 26.0;
input double _2_MACD_Signal = 9.0;
input double _3_RSI_Period = 14.0;
input double _4_BB_Period = 20.0;
input double _4_BB_Dev = 1.0;
input double Percent_Action = 70.0;
input double Lot_percent = 10.0;
input double NEAR = 40.0;
input double Near_PIP_2 = 30.0;
input double open_hg_All_percent = 30.0;
input double Martingale = 1.5;
input string Comment = "corejj";
input double Cut_Loss_Percent = 100.0;
input double Lot_Repetition = 1.0;
input double Close_All_when_profit_money = 1.0;
input double Close_All_when_profit_percent = 0.1;
input double Close_All_when_profit_PIP = 10.0;
input double Lot_Martingale_2 = 1.5;
input double MAX_Slippage_PIP = 4.0;
input double sl = 30.0;
input int MagicStart = 8942; // Magic Number, kind of...
class c
{
		public:
	static ENUM_TIMEFRAMES BIG_TF;
	static ENUM_TIMEFRAMES MEDIUM_TF;
	static ENUM_TIMEFRAMES SMALL_TF;
	static double _1_STO_K;
	static double _1_STO_D;
	static double _1_STO_Slow;
	static double _2_MACD_Fast;
	static double _2_MACD_Slow;
	static double _2_MACD_Signal;
	static double _3_RSI_Period;
	static double _4_BB_Period;
	static double _4_BB_Dev;
	static double Percent_Action;
	static double Lot_percent;
	static double NEAR;
	static double Near_PIP_2;
	static double open_hg_All_percent;
	static double Martingale;
	static string Comment;
	static double Cut_Loss_Percent;
	static double Lot_Repetition;
	static double Close_All_when_profit_money;
	static double Close_All_when_profit_percent;
	static double Close_All_when_profit_PIP;
	static double Lot_Martingale_2;
	static double MAX_Slippage_PIP;
	static double sl;
	static int MagicStart;
};
ENUM_TIMEFRAMES c::BIG_TF;
ENUM_TIMEFRAMES c::MEDIUM_TF;
ENUM_TIMEFRAMES c::SMALL_TF;
double c::_1_STO_K;
double c::_1_STO_D;
double c::_1_STO_Slow;
double c::_2_MACD_Fast;
double c::_2_MACD_Slow;
double c::_2_MACD_Signal;
double c::_3_RSI_Period;
double c::_4_BB_Period;
double c::_4_BB_Dev;
double c::Percent_Action;
double c::Lot_percent;
double c::NEAR;
double c::Near_PIP_2;
double c::open_hg_All_percent;
double c::Martingale;
string c::Comment;
double c::Cut_Loss_Percent;
double c::Lot_Repetition;
double c::Close_All_when_profit_money;
double c::Close_All_when_profit_percent;
double c::Close_All_when_profit_PIP;
double c::Lot_Martingale_2;
double c::MAX_Slippage_PIP;
double c::sl;
int c::MagicStart;


//--
// Variables (Global Variables)









































class v
{
		public:
	static double B1;
	static double B2;
	static double B3;
	static double B4;
	static double B5;
	static double B6;
	static double B7;
	static double B8;
	static double B9;
	static double B10;
	static double B11;
	static double B12;
	static double B13;
	static double B14;
	static double B15;
	static double S1;
	static double S2;
	static double S3;
	static double S4;
	static double S5;
	static double S6;
	static double S7;
	static double S8;
	static double S9;
	static double S10;
	static double S11;
	static double S12;
	static double S13;
	static double S14;
	static double S15;
	static int SELLX;
	static int BUYX;
	static double LOTB;
	static double LOTB_1;
	static double LOTS;
	static double LOTS_1;
	static double Percent;
	static double LOTBx;
	static double Repeat;
	static double H_L;
	static double cheak_money;
};
double v::B1;
double v::B2;
double v::B3;
double v::B4;
double v::B5;
double v::B6;
double v::B7;
double v::B8;
double v::B9;
double v::B10;
double v::B11;
double v::B12;
double v::B13;
double v::B14;
double v::B15;
double v::S1;
double v::S2;
double v::S3;
double v::S4;
double v::S5;
double v::S6;
double v::S7;
double v::S8;
double v::S9;
double v::S10;
double v::S11;
double v::S12;
double v::S13;
double v::S14;
double v::S15;
int v::SELLX;
int v::BUYX;
double v::LOTB;
double v::LOTB_1;
double v::LOTS;
double v::LOTS_1;
double v::Percent;
double v::LOTBx;
double v::Repeat;
double v::H_L;
double v::cheak_money;



//--
// Externs (Global Variables)
input string inp628_Compare = ">";
class _externs
{
		public:
	static string inp628_Compare;
};
string _externs::inp628_Compare;



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
int FXD_BLOCKS_COUNT        = 167;
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
	c::BIG_TF = BIG_TF;
	c::MEDIUM_TF = MEDIUM_TF;
	c::SMALL_TF = SMALL_TF;
	c::_1_STO_K = _1_STO_K;
	c::_1_STO_D = _1_STO_D;
	c::_1_STO_Slow = _1_STO_Slow;
	c::_2_MACD_Fast = _2_MACD_Fast;
	c::_2_MACD_Slow = _2_MACD_Slow;
	c::_2_MACD_Signal = _2_MACD_Signal;
	c::_3_RSI_Period = _3_RSI_Period;
	c::_4_BB_Period = _4_BB_Period;
	c::_4_BB_Dev = _4_BB_Dev;
	c::Percent_Action = Percent_Action;
	c::Lot_percent = Lot_percent;
	c::NEAR = NEAR;
	c::Near_PIP_2 = Near_PIP_2;
	c::open_hg_All_percent = open_hg_All_percent;
	c::Martingale = Martingale;
	c::Comment = Comment;
	c::Cut_Loss_Percent = Cut_Loss_Percent;
	c::Lot_Repetition = Lot_Repetition;
	c::Close_All_when_profit_money = Close_All_when_profit_money;
	c::Close_All_when_profit_percent = Close_All_when_profit_percent;
	c::Close_All_when_profit_PIP = Close_All_when_profit_PIP;
	c::Lot_Martingale_2 = Lot_Martingale_2;
	c::MAX_Slippage_PIP = MAX_Slippage_PIP;
	c::sl = sl;
	c::MagicStart = MagicStart;




	// Initiate Externs
	_externs::inp628_Compare = inp628_Compare;



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

	v::B1 = 0.0;
	v::B2 = 0.0;
	v::B3 = 0.0;
	v::B4 = 0.0;
	v::B5 = 0.0;
	v::B6 = 0.0;
	v::B7 = 0.0;
	v::B8 = 0.0;
	v::B9 = 0.0;
	v::B10 = 0.0;
	v::B11 = 0.0;
	v::B12 = 0.0;
	v::B13 = 0.0;
	v::B14 = 0.0;
	v::B15 = 0.0;
	v::S1 = 0.0;
	v::S2 = 0.0;
	v::S3 = 0.0;
	v::S4 = 0.0;
	v::S5 = 0.0;
	v::S6 = 0.0;
	v::S7 = 0.0;
	v::S8 = 0.0;
	v::S9 = 0.0;
	v::S10 = 0.0;
	v::S11 = 0.0;
	v::S12 = 0.0;
	v::S13 = 0.0;
	v::S14 = 0.0;
	v::S15 = 0.0;
	v::SELLX = 0;
	v::BUYX = 0;
	v::LOTB = 0.0;
	v::LOTB_1 = 0.0;
	v::LOTS = 0.0;
	v::LOTS_1 = 0.0;
	v::Percent = 0.0;
	v::LOTBx = 0.0;
	v::Repeat = 0.0;
	v::H_L = 0.0;
	v::cheak_money = 0.0;




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
	ArrayResize(_blocks_, 167);

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

	//-- run blocks
	int blocks_to_run[] = {164};
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


	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,90,91,93,96,101,105,118,120,126,128,133,145,149,154,160,162};
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
	if (reson == REASON_CHARTCHANGE || reson == REASON_PARAMETERS || reason == REASON_TEMPLATE || reason == REASON_ACCOUNT ) {return;}

	//-- if Timer was set, kill it here
	EventKillTimer();

	if (ENABLE_STATUS) DrawStatus("stopped");
	if (ENABLE_SPREAD_METER) DrawSpreadInfo();
	ChartSetString(0, CHART_COMMENT, "");



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
			// Sometimes CopyTime doesn't work properly. It happens when the history data is broken or something.
			// Then, CopyTime can't read any candles. It happens withing few candles only, but it's a problem that
			// I don't know how to fix. However, iTime() seems to work fine.
			datetime new_value = iTime(Symbol, Period, 1);
			
			if (new_value == 0) {
				Print("Failed to get the time from candle 1 on symbol ", Symbol, " and timeframe ", EnumToString((ENUM_TIMEFRAMES)Period), ". The history data needs to be fixed.");
			}
		
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
		
		v::LOTB = formula(compare, lo, ro);
		
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
		
		v::LOTS = formula(compare, lo, ro);
		
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

// "Trailing stop (group of trades)" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename _T8_,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename T18,typename T19,typename T20,typename T21,typename _T21_,typename T22>
class MDL_TrailingStopAvgPrice: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 Symbol;
	T4 BuysOrSells;
	T5 TrailWhat;
	T6 TrailingStopMode;
	T7 tStopPips;
	T8 ftStop; virtual _T8_ _ftStop_(){return(_T8_)0;}
	T9 tStopMoney;
	T10 TrailingStepMode;
	T11 tStepPips;
	T12 tStepPercentTS;
	T13 TrailingStartMode;
	T14 tStartPips;
	T15 tStartPercentTS;
	T16 ftStart; virtual _T16_ _ftStart_(){return(_T16_)0;}
	T17 resetOnTrade;
	T18 TrailingTPmode;
	T19 tTPpips;
	T20 tTPpercentTS;
	T21 ftTP; virtual _T21_ _ftTP_(){return(_T21_)0;}
	T22 LevelColor;
	/* Static Parameters */
	double avg_lots0;
	double group_stop;
	string change_detect0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_TrailingStopAvgPrice()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		TrailWhat = (int)1;
		TrailingStopMode = (string)"fixed";
		tStopPips = (double)40.0;
		tStopMoney = (double)10.0;
		TrailingStepMode = (string)"fixed";
		tStepPips = (double)1.0;
		tStepPercentTS = (double)10.0;
		TrailingStartMode = (string)"none";
		tStartPips = (double)10.0;
		tStartPercentTS = (double)100.0;
		resetOnTrade = (bool)true;
		TrailingTPmode = (string)"none";
		tTPpips = (double)20.0;
		tTPpercentTS = (double)200.0;
		LevelColor = (color)clrDeepPink;
		/* Static Parameters (initial value) */
		avg_lots0 =  0;
		group_stop =  0;
		change_detect0 =  "";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int index        = 0;
		double avg_price = 0;
		double avg_load  = 0;
		double avg_lots  = 0; // Average sum of lots - it can be negative
		double profit    = 0;
		double askbid    = 0;
		double bidask    = 0;
		int trades_count = 0; // Count of Trades to work with
		bool resetSL     = false;
		ulong tickets[]; ArrayResize(tickets, 0); // Array with tickets to modify
		
		string change_detect         = "";
		
		int total = TradesTotal();
		
		//-- collect group data from trades
		for (index = 0; index < total; index++)
		{
			if (!TradeSelectByIndex(index, GroupMode, Group, "symbol", Symbol, BuysOrSells)) {continue;}
			
			if (OrderType() == 0)
			{
				avg_load = avg_load + (OrderOpenPrice() * OrderLots());
				avg_lots = avg_lots + OrderLots();
			}
			else
			{
				avg_load = avg_load - (OrderOpenPrice() * OrderLots());
				avg_lots = avg_lots - OrderLots();
			}
			
			ArrayEnsureValue(tickets, (ulong)OrderTicket());
		
			profit        = profit + NormalizeDouble(OrderProfit() + OrderCommission() + OrderSwap(), 2);
			change_detect = (string)OrderTicket() + change_detect;
			trades_count++;
		}
		
		avg_price = 0;
		
		if (avg_lots != 0)
		{
			avg_price = avg_load / avg_lots;
		}
		
		//-- check and set flag for reset (when new trade or when trade is gone)
		if (change_detect0 != change_detect)
		{
			if (trades_count == 0)
			{
				avg_lots0  = 0;
				group_stop = 0;
			}
			else
			{
				group_stop = 0;
		
				if (resetOnTrade == true)
				{
					avg_lots0 = avg_lots;
					resetSL   = true;
				}
			}
		
			change_detect0 = change_detect;
		}
		
		//-- do trailing stop
		if (avg_lots != 0)
		{
			int polarity = 0;
		
			if (avg_lots > 0)
			{
				polarity = 1;
				askbid   = SymbolAsk(Symbol);
				bidask   = SymbolBid(Symbol);
			}
			else
			{
				polarity = -1;
				askbid   = SymbolBid(Symbol);
				bidask   = SymbolAsk(Symbol);
			}
		
			// Trailing Stop Size
			double t_stop = 0;
		
			     if (TrailingStopMode == "fixed")       {t_stop = tStopPips;}
			else if (TrailingStopMode == "dynamicSize") {t_stop = _ftStop_();}
			else if (TrailingStopMode == "function")
			{
				t_stop = _ftStop_();
				t_stop = toPips(MathAbs(askbid-t_stop), Symbol);
			}
			else if (TrailingStopMode == "money")
			{
				double tick_value = SymbolInfoDouble(Symbol, SYMBOL_TRADE_TICK_VALUE);
				double tick_size  = SymbolInfoDouble(Symbol, SYMBOL_TRADE_TICK_SIZE);
				double point      = SymbolInfoDouble(Symbol, SYMBOL_POINT);
		
				double tickvalue = ((tick_value / tick_size) * point);
		
				t_stop = tStopMoney;
				t_stop = t_stop /  ((MathAbs(avg_lots) * PipValue(Symbol)));
				t_stop = t_stop / tickvalue;
			}
		
			// Trailing Start Level
			double t_start = 0;
		
			     if (TrailingStartMode == "none")      {t_start = -EMPTY_VALUE;}
			else if (TrailingStartMode == "zero")      {t_start = 0;}
			else if (TrailingStartMode == "fixed")     {t_start = tStartPips;}
			else if (TrailingStartMode == "percentTS") {t_start = t_stop * (tStartPercentTS / 100);}
			else if (TrailingStartMode == "function")  {t_start = _ftStart_();}
		
			// Trailing Step Size
			double t_step = 0;
		
			     if (TrailingStepMode == "fixed")      {t_step = tStepPips;}
			else if (TrailingStepMode == "percentTS")  {t_step = t_stop * (tStepPercentTS / 100);}
		
			// Trailing Take Profit
			double t_opp = -1;
		
			     if (TrailingTPmode == "none")         {t_opp = -1;}
			else if (TrailingTPmode == "clear")        {t_opp = 0;}
			else if (TrailingTPmode == "fixed")        {t_opp = MathAbs(toPips(avg_price - group_stop, Symbol));}
			else if (TrailingTPmode == "percentTS")    {t_opp = MathAbs(toPips(avg_price - t_stop, Symbol)) * (tTPpercentTS/100);}
			else if (TrailingTPmode == "function")     {t_opp = _ftTP_();}
		
			bool go_modify = false;
		
			if (polarity == 1 && TrailWhat * (askbid - avg_price) > toDigits(t_start, Symbol))
			{
				if ((TrailWhat * (askbid - group_stop) >= toDigits(t_stop + t_step, Symbol)) || group_stop==0 || resetSL == true)
				{
					group_stop = (askbid - TrailWhat * toDigits(t_stop, Symbol));
					go_modify  = true;
				}
			}
			else if (polarity == -1 && TrailWhat * (avg_price - askbid) > toDigits(t_start, Symbol))
			{
				if ((TrailWhat * (group_stop - askbid) >= toDigits(t_stop + t_step, Symbol)) || group_stop == 0 || resetSL == true)
				{
					group_stop = (askbid + TrailWhat * toDigits(t_stop, Symbol));
					go_modify  = true;
				}
			}
		
			if (go_modify==true)
			{
				for (index = ArraySize(tickets) - 1; index >= 0; index--)
				{
					if (TradeSelectByTicket(tickets[index]))
					{
						bool success = true;
						
						// calculate the future stop and the limit
						double stopslevel = (double)SymbolInfoInteger(OrderSymbol(), SYMBOL_TRADE_STOPS_LEVEL);
						stopslevel        = toDigits(stopslevel / PipValue(OrderSymbol()), OrderSymbol());
						double fsl        = MathAbs(group_stop); // future SL
						double limit      = 0;
						
						if (OrderType() == 0)
						{
							limit = bidask - stopslevel * TrailWhat;
							if (fsl > limit) {fsl = limit;}
						}
						else
						{
							limit = bidask + stopslevel * TrailWhat;
							if (fsl < limit) {fsl = limit;}
						}
		
						// trail SL
						if (TrailWhat == 1)
						{
							if (t_opp < 0) {t_opp = attrTakeProfit();}
							
							// consider limits
							if (
								   attrStopLoss() == 0
								|| (OrderType() == 0 && (attrStopLoss() < fsl || resetSL == true))
								|| (OrderType() == 1 && (attrStopLoss() > fsl || resetSL == true))
							)
							{
								success = ModifyStops(OrderTicket(), group_stop, t_opp, LevelColor);
							}
						}
						// trail TP
						else
						{
							if (t_opp < 0) {t_opp = attrStopLoss();}
							
							// consider limits
							if (
								   attrTakeProfit() == 0
								|| (OrderType() == 0 && (attrTakeProfit() > fsl || resetSL == true))
								|| (OrderType() == 1 && (attrTakeProfit() < fsl || resetSL == true))
							)
							{
								success = ModifyStops(OrderTicket(), t_opp, group_stop, LevelColor);
							}
						}
					}
				}
			}
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
		double avgPrice    = 0;
		double avgLoad     = 0;
		double avgLots     = 0;
		double profitMoney = 0;
		double profitPips  = 0;
		double pipsSum     = 0;
		int tradesCount    = 0;
		
		for (int index = TradesTotal()-1; index >= 0; index--) {
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells)) {
				double OrderOpenPrice = OrderChildOpenPrice();
				double tradeProfit    = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
		
				// Filter out individual trades
				if (EachProfitMode == "money") {
					if (compare(EachCompare, tradeProfit, EachProfitAmount)) {/* do nothing */} else {continue;}
				}
				else if (EachProfitMode == "pips") {
					double individual_profit = toPips(OrderClosePrice() - OrderOpenPrice, OrderSymbol());
		
					if (OrderType() == 1) {individual_profit = -1 * individual_profit;}
		
					if (compare(EachCompare, individual_profit, EachProfitAmountPips)) {/* do nothing*/} else {continue;}
				}
		
				profitMoney += tradeProfit;
		
				if (ProfitMode == "pips" || ProfitMode == "pips-sum") {
					if (IsOrderTypeBuy()) {
						pipsSum += toPips(OrderClosePrice() - OrderOpenPrice, OrderSymbol());
						avgLoad += OrderOpenPrice * OrderLots();
						avgLots += OrderLots();
					}
					else {
						pipsSum += toPips(OrderOpenPrice - OrderClosePrice(), OrderSymbol());
						avgLoad -= OrderOpenPrice * OrderLots();
						avgLots -= OrderLots();
					}
				}
		
				tradesCount += 1;
			}
		}
		
		if (ProfitMode == "pips") {
			avgPrice = 0;
		
			if (avgLots != 0) {
				avgPrice = (avgLoad / avgLots);
			}
		
			if (avgPrice != 0) {
				if (avgLots > 0) {
					profitPips = SymbolInfoDouble(Symbol, SYMBOL_BID) - avgPrice;
				}
				else {
					profitPips = avgPrice - SymbolInfoDouble(Symbol, SYMBOL_ASK);
				}
		
				profitPips = toPips(profitPips, Symbol);
			}
		}
		
		if (
			   (ProfitMode == "money"    && (CompareValues(Compare, profitMoney, ProfitAmount)))
			|| (ProfitMode == "pips"     && (CompareValues(Compare, profitPips, ProfitAmountPips)))
			|| (ProfitMode == "pips-sum" && (CompareValues(Compare, pipsSum, ProfitAmountPips)))
		) {
			_callback_(1);
		}
		else {
			_callback_(0);
		}
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
		
		v::LOTB_1 = formula(compare, lo, ro)/100000;
		
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
		
		v::LOTS_1 = formula(compare, lo, ro)/100000;
		
		_callback_(1);
	}
};

// "check type" model
template<typename T1,typename T2>
class MDL_LoopCheckType: public BlockCalls
{
	public: /* Input Parameters */
	T1 CheckBuyOrSell;
	T2 CheckLimitOrStop;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopCheckType()
	{
		CheckBuyOrSell = (string)"buy";
		CheckLimitOrStop = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK == true) {return;}
		
		LoopedResume();
		
		if (
			   (CheckBuyOrSell == "both" || (CheckBuyOrSell == "buy" && IsOrderTypeBuy()) || (CheckBuyOrSell == "sell" && IsOrderTypeSell()))
			&& (CheckLimitOrStop == "both" || (CheckLimitOrStop == "buy" && IsOrderTypeStop()) || (CheckLimitOrStop == "sell" && IsOrderTypeStop()))
		) {_callback_(1);} else {_callback_(0);}
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
		
		v::LOTBx = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Counter: Count "n", then pass" model
template<typename T1,typename T2>
class MDL_CountNtimes: public BlockCalls
{
	public: /* Input Parameters */
	T1 Counts;
	T2 CounterID;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CountNtimes()
	{
		Counts = (int)3;
		CounterID = (int)1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int passes = Counter(CounterID, "increment");
		
		if (passes >= Counts) {_callback_(1);} else {_callback_(0);}
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
		
		v::Repeat = formula(compare, lo, ro);
		
		_callback_(1);
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
		
		v::Percent = formula(compare, lo, ro)/100;
		
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
		
		v::cheak_money = formula(compare, lo, ro)/100;
		
		_callback_(1);
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
		
		v::cheak_money = formula(compare, lo, ro)/100;
		
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

// "Modify chart properties" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18>
class MDL_ChartSetProperties: public BlockCalls
{
	public: /* Input Parameters */
	T1 ChartMode;
	T2 ChartOnForeground;
	T3 ChartShift;
	T4 ChartAutoScroll;
	T5 ChartScale;
	T6 ChartShowOHLC;
	T7 ChartShowBidLine;
	T8 ChartShowAskLine;
	T9 ChartShowLastLine;
	T10 ChartShowPeriodSeparators;
	T11 ChartShowGrid;
	T12 ChartShowVolumes;
	T13 ChartShowDescriptions;
	T14 ChartShowTradeLevels;
	T15 ChartShowDateScale;
	T16 ChartShowPriceScale;
	T17 ChartScaleFix11;
	T18 ChartScaleFix;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartSetProperties()
	{
		ChartMode = (int)-1;
		ChartOnForeground = (int)-1;
		ChartShift = (int)-1;
		ChartAutoScroll = (int)-1;
		ChartScale = (int)-1;
		ChartShowOHLC = (int)-1;
		ChartShowBidLine = (int)-1;
		ChartShowAskLine = (int)-1;
		ChartShowLastLine = (int)-1;
		ChartShowPeriodSeparators = (int)-1;
		ChartShowGrid = (int)-1;
		ChartShowVolumes = (int)-1;
		ChartShowDescriptions = (int)-1;
		ChartShowTradeLevels = (int)-1;
		ChartShowDateScale = (int)-1;
		ChartShowPriceScale = (int)-1;
		ChartScaleFix11 = (int)-1;
		ChartScaleFix = (int)-1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		ResetLastError();
		
		if (ChartMode!=-1) {
		   if(!ChartSetInteger(0,CHART_MODE,ChartMode)) {Print("Unable to set chart mode. Error code: ",GetLastError());}
		}
		
		//-- chart positioning
		if (ChartOnForeground!=-1) {
		   if(!ChartSetInteger(0,CHART_FOREGROUND,ChartOnForeground)) {Print("Unable to set chart foreground mode. Error code: ",GetLastError());}
		}
		if (ChartShift!=-1) {
		   if(!ChartSetInteger(0,CHART_SHIFT,ChartShift)) {Print("Unable to set chart shift mode. Error code: ",GetLastError());}
		}
		if (ChartAutoScroll!=-1) {
		   if(!ChartSetInteger(0,CHART_AUTOSCROLL,ChartAutoScroll)) {Print("Unable to set chart autoscroll mode. Error code: ",GetLastError());}
		}
		
		//-- chart scale
		if (ChartScale!=-1) {
		   if(!ChartSetInteger(0,CHART_SCALE,ChartScale)) {Print("Unable to set chart scale mode. Error code: ",GetLastError());}
		}
		
		//-- chart elements
		if (ChartShowOHLC!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_OHLC,ChartShowOHLC)) {Print("Unable to set chart OHLC mode. Error code: ",GetLastError());}
		}
		if (ChartShowBidLine!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_BID_LINE,ChartShowBidLine)) {Print("Unable to set chart Bid price line mode. Error code: ",GetLastError());}
		}
		if (ChartShowAskLine!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_ASK_LINE,ChartShowAskLine)) {Print("Unable to set chart Ask price line mode. Error code: ",GetLastError());}
		}
		if (ChartShowLastLine!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_LAST_LINE,ChartShowLastLine)) {Print("Unable to set chart last price line mode. Error code: ",GetLastError());}
		}
		if (ChartShowPeriodSeparators!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,ChartShowPeriodSeparators)) {Print("Unable to set chart period separators mode. Error code: ",GetLastError());}
		}
		if (ChartShowGrid!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_GRID,ChartShowGrid)) {Print("Unable to set chart grid mode. Error code: ",GetLastError());}
		}
		if (ChartShowVolumes!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_VOLUMES,ChartShowVolumes)) {Print("Unable to set chart volumes mode. Error code: ",GetLastError());}
		}
		if (ChartShowDescriptions!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,ChartShowDescriptions)) {Print("Unable to set chart object descriptions mode. Error code: ",GetLastError());}
		}
		if (ChartShowTradeLevels!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,ChartShowTradeLevels)) {Print("Unable to set chart trade levels mode. Error code: ",GetLastError());}
		}
		if (ChartShowDateScale!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_DATE_SCALE,ChartShowDateScale)) {Print("Unable to set chart date scale mode. Error code: ",GetLastError());}
		}
		if (ChartShowPriceScale!=-1) {
		   if(!ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,ChartShowPriceScale)) {Print("Unable to set chart price scale mode. Error code: ",GetLastError());}
		}
		
		// scale fix
		if (ChartScaleFix!=-1) {
		   if(!ChartSetInteger(0,CHART_SCALEFIX,ChartScaleFix)) {Print("Unable to set scale fix One to One. Error code: ",GetLastError());}
		}
		else {
			if (ChartScaleFix11!=-1) {
		   	if(!ChartSetInteger(0,CHART_SCALEFIX_11,ChartScaleFix11)) {Print("Unable to set scale fix One to One. Error code: ",GetLastError());}
			}
		}
		
		ChartRedraw();
		
		_callback_(1);
	}
};

// "Modify chart colors" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13>
class MDL_ChartSetColors: public BlockCalls
{
	public: /* Input Parameters */
	T1 ChartColorBackground;
	T2 ChartColorForeground;
	T3 ChartColorGrid;
	T4 ChartColorBarUp;
	T5 ChartColorBarDown;
	T6 ChartColorBullCandle;
	T7 ChartColorBearCandle;
	T8 ChartColorDojiCandle;
	T9 ChartColorVolumes;
	T10 ChartColorBid;
	T11 ChartColorAsk;
	T12 ChartColorLast;
	T13 ChartColorStopLevels;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartSetColors()
	{
		ChartColorBackground = (color)clrBlack;
		ChartColorForeground = (color)clrWhite;
		ChartColorGrid = (color)clrLightSlateGray;
		ChartColorBarUp = (color)clrLime;
		ChartColorBarDown = (color)clrLime;
		ChartColorBullCandle = (color)clrBlack;
		ChartColorBearCandle = (color)clrWhite;
		ChartColorDojiCandle = (color)clrLime;
		ChartColorVolumes = (color)clrLimeGreen;
		ChartColorBid = (color)clrLightSlateGray;
		ChartColorAsk = (color)clrRed;
		ChartColorLast = (color)clrLimeGreen;
		ChartColorStopLevels = (color)clrRed;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		ResetLastError();
		
		if (ChartColorBackground!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_BACKGROUND,ChartColorBackground)) {Print("Unable to set chart background color. Error code: ",GetLastError());}
		}
		if (ChartColorForeground!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_FOREGROUND,ChartColorForeground)) {Print("Unable to set chart foreground color. Error code: ",GetLastError());}
		}
		if (ChartColorGrid!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_GRID,ChartColorGrid)) {Print("Unable to set chart grid color. Error code: ",GetLastError());}
		}
		if (ChartColorBarUp!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_CHART_UP,ChartColorBarUp)) {Print("Unable to set chart bar up color. Error code: ",GetLastError());}
		}
		if (ChartColorBarDown!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_CHART_DOWN,ChartColorBarDown)) {Print("Unable to set chart bar down color. Error code: ",GetLastError());}
		}
		if (ChartColorBullCandle!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,ChartColorBullCandle)) {Print("Unable to set chart bull candle color. Error code: ",GetLastError());}
		}
		if (ChartColorBearCandle!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,ChartColorBearCandle)) {Print("Unable to set chart bear candle color. Error code: ",GetLastError());}
		}
		if (ChartColorDojiCandle!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_CHART_LINE,ChartColorDojiCandle)) {Print("Unable to set chart doji candle color. Error code: ",GetLastError());}
		}
		if (ChartColorVolumes!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_VOLUME,ChartColorVolumes)) {Print("Unable to set chart volumes color. Error code: ",GetLastError());}
		}
		if (ChartColorBid!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_BID,ChartColorBid)) {Print("Unable to set chart Bid line color. Error code: ",GetLastError());}
		}
		if (ChartColorAsk!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_ASK,ChartColorAsk)) {Print("Unable to set chart Ask line color. Error code: ",GetLastError());}
		}
		if (ChartColorLast!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_LAST,ChartColorLast)) {Print("Unable to set chart last price line color. Error code: ",GetLastError());}
		}
		if (ChartColorStopLevels!=clrNONE) {
		   if(!ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,ChartColorStopLevels)) {Print("Unable to set chart stop levels color. Error code: ",GetLastError());}
		}
		
		ChartRedraw();
		
		_callback_(1);
	}
};


//------------------------------------------------------------------------------------------------------------------------

// "Stochastic Oscillator" model
class MDLIC_indicators_iStochastic
{
	public: /* Input Parameters */
	int Kperiod;
	int Dperiod;
	int Slowing;
	ENUM_MA_METHOD MAmethod;
	ENUM_STO_PRICE PriceField;
	int Mode;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iStochastic()
	{
		Kperiod = (int)5;
		Dperiod = (int)3;
		Slowing = (int)3;
		MAmethod = (ENUM_MA_METHOD)MODE_SMA;
		PriceField = (ENUM_STO_PRICE)STO_LOWHIGH;
		Mode = (int)0;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iStochastic(Symbol, Period, Kperiod, Dperiod, Slowing, MAmethod, PriceField, Mode, Shift + FXD_MORE_SHIFT);
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

// "Bollinger Bands" model
class MDLIC_indicators_iBands
{
	public: /* Input Parameters */
	int BandsPeriod;
	int BandsShift;
	double Deviation;
	ENUM_APPLIED_PRICE AppliedPrice;
	int mode;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iBands()
	{
		BandsPeriod = (int)20;
		BandsShift = (int)0;
		Deviation = (double)2.0;
		AppliedPrice = (ENUM_APPLIED_PRICE)PRICE_CLOSE;
		mode = (int)0;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iBands(Symbol, Period, BandsPeriod, Deviation, BandsShift, AppliedPrice, mode, Shift + FXD_MORE_SHIFT);
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
	datetime TimeValue;
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
		TimeValue = (datetime)0;
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
	}

	public: /* The main method */
	datetime _execute_()
	{
		// this is static for speed reasons
		
		if (TimeMarket == "") TimeMarket = Symbol();
		
		if (ModeTime == 0)
		{
			     if (TimeSource == 0) {retval = TimeCurrent();}
			else if (TimeSource == 1) {retval = TimeLocal() + (TimeCurrent() - TimeLocal());}
			else if (TimeSource == 2) {retval = TimeGMT() + (TimeCurrent() - TimeGMT());}
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
		else if (ModeTime == 4)
		{
			retval = TimeValue;
		}
		
		if (ModeTimeShift > 0)
		{
			int sh = 1;
		
			if (ModeTimeShift == 1) {sh = -1;}
		
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


//------------------------------------------------------------------------------------------------------------------------

// Block 1 (STO DAY)
class Block0: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {17,18};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Mode = 1;
		Ro.Shift = 1;
		// Block input parameters
		compare = "x>";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[18].run(0);
		}
		else if (value == 1) {
			_blocks_[17].run(0);
		}
	}
};

// Block 2 (MACD Slope UP)
class Block1: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_indicators_iMACD,double,int>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "2";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {19,20};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.FastEMAperiod = c::_2_MACD_Fast;
		Lo.SlowEMAperiod = c::_2_MACD_Slow;
		Lo.SignalPeriod = c::_2_MACD_Signal;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.FastEMAperiod = c::_2_MACD_Fast;
		Ro.SlowEMAperiod = c::_2_MACD_Slow;
		Ro.SignalPeriod = c::_2_MACD_Signal;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[20].run(1);
		}
		else if (value == 1) {
			_blocks_[19].run(1);
		}
	}
};

// Block 3 (RSI)
class Block2: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {21,22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.RSIperiod = c::_3_RSI_Period;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.RSIperiod = c::_3_RSI_Period;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[22].run(2);
		}
		else if (value == 1) {
			_blocks_[21].run(2);
		}
	}
};

// Block 4 (STO DAY)
class Block3: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {15,16};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Mode = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[16].run(3);
		}
		else if (value == 1) {
			_blocks_[15].run(3);
		}
	}
};

// Block 5 (BB)
class Block4: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iBands,double,int>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {23,24};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.mode = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BandsPeriod = c::_4_BB_Period;
		Ro.Deviation = c::_4_BB_Dev;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[24].run(4);
		}
		else if (value == 1) {
			_blocks_[23].run(4);
		}
	}
};

// Block 6 (STO H4)
class Block5: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {27,28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Mode = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[28].run(5);
		}
		else if (value == 1) {
			_blocks_[27].run(5);
		}
	}
};

// Block 7 (MACD Slope UP)
class Block6: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_indicators_iMACD,double,int>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {29,30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.FastEMAperiod = c::_2_MACD_Fast;
		Lo.SlowEMAperiod = c::_2_MACD_Slow;
		Lo.SignalPeriod = c::_2_MACD_Signal;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.FastEMAperiod = c::_2_MACD_Fast;
		Ro.SlowEMAperiod = c::_2_MACD_Slow;
		Ro.SignalPeriod = c::_2_MACD_Signal;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[30].run(6);
		}
		else if (value == 1) {
			_blocks_[29].run(6);
		}
	}
};

// Block 8 (RSI)
class Block7: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {31,32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.RSIperiod = c::_3_RSI_Period;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.RSIperiod = c::_3_RSI_Period;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[32].run(7);
		}
		else if (value == 1) {
			_blocks_[31].run(7);
		}
	}
};

// Block 9 (STO H4)
class Block8: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {25,26};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Mode = 1;
		Ro.Shift = 1;
		// Block input parameters
		compare = "x>";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[26].run(8);
		}
		else if (value == 1) {
			_blocks_[25].run(8);
		}
	}
};

// Block 10 (BB)
class Block9: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iBands,double,int>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {33,34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.mode = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BandsPeriod = c::_4_BB_Period;
		Ro.Deviation = c::_4_BB_Dev;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[34].run(9);
		}
		else if (value == 1) {
			_blocks_[33].run(9);
		}
	}
};

// Block 11 (STO H1)
class Block10: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "11";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {37,38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Mode = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[38].run(10);
		}
		else if (value == 1) {
			_blocks_[37].run(10);
		}
	}
};

// Block 12 (MACD Slope UP)
class Block11: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_indicators_iMACD,double,int>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "12";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {39,40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.FastEMAperiod = c::_2_MACD_Fast;
		Lo.SlowEMAperiod = c::_2_MACD_Slow;
		Lo.SignalPeriod = c::_2_MACD_Signal;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.FastEMAperiod = c::_2_MACD_Fast;
		Ro.SlowEMAperiod = c::_2_MACD_Slow;
		Ro.SignalPeriod = c::_2_MACD_Signal;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[40].run(11);
		}
		else if (value == 1) {
			_blocks_[39].run(11);
		}
	}
};

// Block 13 (RSI)
class Block12: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "13";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {41,42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.RSIperiod = c::_3_RSI_Period;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.RSIperiod = c::_3_RSI_Period;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[42].run(12);
		}
		else if (value == 1) {
			_blocks_[41].run(12);
		}
	}
};

// Block 14 (STO H1)
class Block13: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "14";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {35,36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Mode = 1;
		Ro.Shift = 1;
		// Block input parameters
		compare = "x>";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[36].run(13);
		}
		else if (value == 1) {
			_blocks_[35].run(13);
		}
	}
};

// Block 15 (BB)
class Block14: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iBands,double,int>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "15";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {43,44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.mode = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BandsPeriod = c::_4_BB_Period;
		Ro.Deviation = c::_4_BB_Dev;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[44].run(14);
		}
		else if (value == 1) {
			_blocks_[43].run(14);
		}
	}
};

// Block 16 (1)
class Block15: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "16";
		_beforeExecuteEnabled = true;
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

		v::B1 = _Value1_();
	}
};

// Block 17 (0)
class Block16: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "17";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B1 = _Value1_();
	}
};

// Block 18 (1)
class Block17: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "18";
		_beforeExecuteEnabled = true;
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

		v::B2 = _Value1_();
	}
};

// Block 19 (0)
class Block18: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "19";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B2 = _Value1_();
	}
};

// Block 20 (1)
class Block19: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "20";
		_beforeExecuteEnabled = true;
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

		v::B3 = _Value1_();
	}
};

// Block 21 (0)
class Block20: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "21";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B3 = _Value1_();
	}
};

// Block 22 (1)
class Block21: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;
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

		v::B4 = _Value1_();
	}
};

// Block 23 (0)
class Block22: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "23";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B4 = _Value1_();
	}
};

// Block 24 (1)
class Block23: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;
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

		v::B5 = _Value1_();
	}
};

// Block 25 (0)
class Block24: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "25";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B5 = _Value1_();
	}
};

// Block 26 (1)
class Block25: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "26";
		_beforeExecuteEnabled = true;
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

		v::B6 = _Value1_();
	}
};

// Block 27 (0)
class Block26: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "27";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B6 = _Value1_();
	}
};

// Block 28 (1)
class Block27: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "28";
		_beforeExecuteEnabled = true;
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

		v::B7 = _Value1_();
	}
};

// Block 29 (0)
class Block28: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "29";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B7 = _Value1_();
	}
};

// Block 30 (1)
class Block29: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "30";
		_beforeExecuteEnabled = true;
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

		v::B8 = _Value1_();
	}
};

// Block 31 (0)
class Block30: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "31";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B8 = _Value1_();
	}
};

// Block 32 (1)
class Block31: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "32";
		_beforeExecuteEnabled = true;
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

		v::B9 = _Value1_();
	}
};

// Block 33 (0)
class Block32: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "33";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B9 = _Value1_();
	}
};

// Block 34 (1)
class Block33: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "34";
		_beforeExecuteEnabled = true;
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

		v::B10 = _Value1_();
	}
};

// Block 35 (0)
class Block34: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "35";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B10 = _Value1_();
	}
};

// Block 36 (1)
class Block35: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "36";
		_beforeExecuteEnabled = true;
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

		v::B11 = _Value1_();
	}
};

// Block 37 (0)
class Block36: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "37";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B11 = _Value1_();
	}
};

// Block 38 (1)
class Block37: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "38";
		_beforeExecuteEnabled = true;
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

		v::B12 = _Value1_();
	}
};

// Block 39 (0)
class Block38: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "39";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B12 = _Value1_();
	}
};

// Block 40 (1)
class Block39: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "40";
		_beforeExecuteEnabled = true;
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

		v::B13 = _Value1_();
	}
};

// Block 41 (0)
class Block40: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "41";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B13 = _Value1_();
	}
};

// Block 42 (1)
class Block41: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "42";
		_beforeExecuteEnabled = true;
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

		v::B14 = _Value1_();
	}
};

// Block 43 (0)
class Block42: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "43";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B14 = _Value1_();
	}
};

// Block 44 (1)
class Block43: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "44";
		_beforeExecuteEnabled = true;
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

		v::B15 = _Value1_();
	}
};

// Block 45 (0)
class Block44: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "45";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::B15 = _Value1_();
	}
};

// Block 47 (STO DAY)
class Block45: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "47";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {62,63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Mode = 1;
		Ro.Shift = 1;
		// Block input parameters
		compare = "x<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[63].run(45);
		}
		else if (value == 1) {
			_blocks_[62].run(45);
		}
	}
};

// Block 48 (MACD Slope UP)
class Block46: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_indicators_iMACD,double,int>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "48";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {64,65};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.FastEMAperiod = c::_2_MACD_Fast;
		Lo.SlowEMAperiod = c::_2_MACD_Slow;
		Lo.SignalPeriod = c::_2_MACD_Signal;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.FastEMAperiod = c::_2_MACD_Fast;
		Ro.SlowEMAperiod = c::_2_MACD_Slow;
		Ro.SignalPeriod = c::_2_MACD_Signal;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[65].run(46);
		}
		else if (value == 1) {
			_blocks_[64].run(46);
		}
	}
};

// Block 49 (RSI)
class Block47: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "49";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {66,67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.RSIperiod = c::_3_RSI_Period;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.RSIperiod = c::_3_RSI_Period;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[67].run(47);
		}
		else if (value == 1) {
			_blocks_[66].run(47);
		}
	}
};

// Block 50 (STO DAY)
class Block48: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "50";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {60,61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Mode = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[61].run(48);
		}
		else if (value == 1) {
			_blocks_[60].run(48);
		}
	}
};

// Block 51 (BB)
class Block49: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iBands,double,int>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "51";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {68,69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.mode = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::BIG_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BandsPeriod = c::_4_BB_Period;
		Ro.Deviation = c::_4_BB_Dev;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::BIG_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[69].run(49);
		}
		else if (value == 1) {
			_blocks_[68].run(49);
		}
	}
};

// Block 52 (STO H4)
class Block50: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "52";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {72,73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Mode = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[73].run(50);
		}
		else if (value == 1) {
			_blocks_[72].run(50);
		}
	}
};

// Block 53 (MACD Slope UP)
class Block51: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_indicators_iMACD,double,int>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "53";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {74,75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.FastEMAperiod = c::_2_MACD_Fast;
		Lo.SlowEMAperiod = c::_2_MACD_Slow;
		Lo.SignalPeriod = c::_2_MACD_Signal;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.FastEMAperiod = c::_2_MACD_Fast;
		Ro.SlowEMAperiod = c::_2_MACD_Slow;
		Ro.SignalPeriod = c::_2_MACD_Signal;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[75].run(51);
		}
		else if (value == 1) {
			_blocks_[74].run(51);
		}
	}
};

// Block 54 (RSI)
class Block52: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "54";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {76,77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.RSIperiod = c::_3_RSI_Period;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.RSIperiod = c::_3_RSI_Period;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[77].run(52);
		}
		else if (value == 1) {
			_blocks_[76].run(52);
		}
	}
};

// Block 55 (STO H4)
class Block53: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "55";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {70,71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Mode = 1;
		Ro.Shift = 1;
		// Block input parameters
		compare = "x<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[71].run(53);
		}
		else if (value == 1) {
			_blocks_[70].run(53);
		}
	}
};

// Block 56 (BB)
class Block54: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iBands,double,int>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "56";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {78,79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.mode = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::MEDIUM_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BandsPeriod = c::_4_BB_Period;
		Ro.Deviation = c::_4_BB_Dev;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::MEDIUM_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[79].run(54);
		}
		else if (value == 1) {
			_blocks_[78].run(54);
		}
	}
};

// Block 57 (STO H1)
class Block55: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "57";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {82,83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Mode = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[83].run(55);
		}
		else if (value == 1) {
			_blocks_[82].run(55);
		}
	}
};

// Block 58 (MACD Slope UP)
class Block56: public MDL_Condition<MDLIC_indicators_iMACD,double,string,MDLIC_indicators_iMACD,double,int>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "58";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {84,85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.FastEMAperiod = c::_2_MACD_Fast;
		Lo.SlowEMAperiod = c::_2_MACD_Slow;
		Lo.SignalPeriod = c::_2_MACD_Signal;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.FastEMAperiod = c::_2_MACD_Fast;
		Ro.SlowEMAperiod = c::_2_MACD_Slow;
		Ro.SignalPeriod = c::_2_MACD_Signal;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[85].run(56);
		}
		else if (value == 1) {
			_blocks_[84].run(56);
		}
	}
};

// Block 59 (RSI)
class Block57: public MDL_Condition<MDLIC_indicators_iRSI,double,string,MDLIC_indicators_iRSI,double,int>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "59";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {86,87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Shift = 2;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.RSIperiod = c::_3_RSI_Period;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.RSIperiod = c::_3_RSI_Period;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[87].run(57);
		}
		else if (value == 1) {
			_blocks_[86].run(57);
		}
	}
};

// Block 60 (STO H1)
class Block58: public MDL_Condition<MDLIC_indicators_iStochastic,double,string,MDLIC_indicators_iStochastic,double,int>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "60";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {80,81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Shift = 1;
		Ro.Mode = 1;
		Ro.Shift = 1;
		// Block input parameters
		compare = "x<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Kperiod = c::_1_STO_K;
		Lo.Dperiod = c::_1_STO_D;
		Lo.Slowing = c::_1_STO_Slow;
		Lo.MAmethod = MODE_SMA;
		Lo.PriceField = STO_LOWHIGH;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Kperiod = c::_1_STO_K;
		Ro.Dperiod = c::_1_STO_D;
		Ro.Slowing = c::_1_STO_Slow;
		Ro.MAmethod = MODE_SMA;
		Ro.PriceField = STO_LOWHIGH;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[81].run(58);
		}
		else if (value == 1) {
			_blocks_[80].run(58);
		}
	}
};

// Block 61 (BB)
class Block59: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iBands,double,int>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "61";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {88,89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.mode = 2;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::SMALL_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BandsPeriod = c::_4_BB_Period;
		Ro.Deviation = c::_4_BB_Dev;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::SMALL_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[89].run(59);
		}
		else if (value == 1) {
			_blocks_[88].run(59);
		}
	}
};

// Block 62 (1)
class Block60: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "62";
		_beforeExecuteEnabled = true;
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

		v::S1 = _Value1_();
	}
};

// Block 63 (0)
class Block61: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "63";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S1 = _Value1_();
	}
};

// Block 64 (1)
class Block62: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "64";
		_beforeExecuteEnabled = true;
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

		v::S2 = _Value1_();
	}
};

// Block 65 (0)
class Block63: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "65";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S2 = _Value1_();
	}
};

// Block 66 (1)
class Block64: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "66";
		_beforeExecuteEnabled = true;
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

		v::S3 = _Value1_();
	}
};

// Block 67 (0)
class Block65: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "67";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S3 = _Value1_();
	}
};

// Block 68 (1)
class Block66: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "68";
		_beforeExecuteEnabled = true;
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

		v::S4 = _Value1_();
	}
};

// Block 69 (0)
class Block67: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "69";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S4 = _Value1_();
	}
};

// Block 70 (1)
class Block68: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "70";
		_beforeExecuteEnabled = true;
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

		v::S5 = _Value1_();
	}
};

// Block 71 (0)
class Block69: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "71";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S5 = _Value1_();
	}
};

// Block 72 (1)
class Block70: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "72";
		_beforeExecuteEnabled = true;
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

		v::S6 = _Value1_();
	}
};

// Block 73 (0)
class Block71: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "73";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S6 = _Value1_();
	}
};

// Block 74 (1)
class Block72: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "74";
		_beforeExecuteEnabled = true;
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

		v::S7 = _Value1_();
	}
};

// Block 75 (0)
class Block73: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "75";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S7 = _Value1_();
	}
};

// Block 76 (1)
class Block74: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "76";
		_beforeExecuteEnabled = true;
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

		v::S8 = _Value1_();
	}
};

// Block 77 (0)
class Block75: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "77";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S8 = _Value1_();
	}
};

// Block 78 (1)
class Block76: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "78";
		_beforeExecuteEnabled = true;
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

		v::S9 = _Value1_();
	}
};

// Block 79 (0)
class Block77: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "79";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S9 = _Value1_();
	}
};

// Block 80 (1)
class Block78: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "80";
		_beforeExecuteEnabled = true;
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

		v::S10 = _Value1_();
	}
};

// Block 81 (0)
class Block79: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "81";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S10 = _Value1_();
	}
};

// Block 82 (1)
class Block80: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "82";
		_beforeExecuteEnabled = true;
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

		v::S11 = _Value1_();
	}
};

// Block 83 (0)
class Block81: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "83";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S11 = _Value1_();
	}
};

// Block 84 (1)
class Block82: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "84";
		_beforeExecuteEnabled = true;
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

		v::S12 = _Value1_();
	}
};

// Block 85 (0)
class Block83: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "85";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S12 = _Value1_();
	}
};

// Block 86 (1)
class Block84: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "86";
		_beforeExecuteEnabled = true;
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

		v::S13 = _Value1_();
	}
};

// Block 87 (0)
class Block85: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "87";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S13 = _Value1_();
	}
};

// Block 88 (1)
class Block86: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "88";
		_beforeExecuteEnabled = true;
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

		v::S14 = _Value1_();
	}
};

// Block 89 (0)
class Block87: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "89";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S14 = _Value1_();
	}
};

// Block 90 (1)
class Block88: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "90";
		_beforeExecuteEnabled = true;
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

		v::S15 = _Value1_();
	}
};

// Block 91 (0)
class Block89: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "91";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::S15 = _Value1_();
	}
};

// Block 92 (Custom MQL code)
class Block90: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "92";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(90);
		}
	}

	virtual void _beforeExecute_()
	{

		v::BUYX = (v::B1+v::B2+v::B3+v::B4+v::B5+v::B6+v::B7+v::B8+v::B9+v::B10+v::B11+v::B12+v::B13+v::B14+v::B15)/15 *100;
	}
};

// Block 93 (Custom MQL code)
class Block91: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "93";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(91);
		}
	}

	virtual void _beforeExecute_()
	{

		v::SELLX = (v::S1+v::S2+v::S3+v::S4+v::S5+v::S6+v::S7+v::S8+v::S9+v::S10+v::S11+v::S12+v::S13+v::S14+v::S15)/15 *100;
	}
};

// Block 94 (Comment)
class Block92: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "94";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value4.Text = "";
		Value5.Text = "";
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "DEMOCRACY EA";
		ObjTitleFontSize = 20;
		ObjLabelsFontSize = 20;
		ObjFontSize = 20;
		Label1 = "% BUY";
		Label2 = "% SELL";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::BUYX;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::SELLX;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual string _Value4_() {return Value4._execute_();}
	virtual string _Value5_() {return Value5._execute_();}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrGold;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
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

// Block 102 (Condition)
class Block93: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "102";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BUYX;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Percent_Action;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(93);
		}
	}
};

// Block 104 (Buy now)
class Block94: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "104";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {114};
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
		VolumeMode = "balance";
		StopLossMode = "none";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::_1_STO_K;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[114].run(94);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)c::Lot_percent;
		VolumePercent = (double)c::Lot_percent;
		mmFiboInitialLots = (double)c::Lot_percent;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 105 (Once per bar)
class Block95: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "105";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[94].run(95);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 107 (Condition)
class Block96: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "107";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = ">=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SELLX;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Percent_Action;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(96);
		}
	}
};

// Block 110 (Once per bar)
class Block97: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "110";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(97);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 112 (Sell now)
class Block98: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "112";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {116};
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
		VolumeMode = "balance";
		StopLossMode = "none";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::_1_STO_K;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[116].run(98);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)c::Lot_percent;
		VolumePercent = (double)c::Lot_percent;
		mmFiboInitialLots = (double)c::Lot_percent;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 163 (No trade)
class Block99: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "163";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(99);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 164 (No trade)
class Block100: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "164";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {132};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[132].run(100);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 165 (If trade)
class Block101: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "165";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(101);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 166 (For each Trade)
class Block102: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "166";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(102);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 167 (Condition)
class Block103: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "167";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
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
			_blocks_[104].run(103);
		}
	}
};

// Block 168 (No trade nearby)
class Block104: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "168";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {109};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
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
			_blocks_[109].run(104);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)c::NEAR;
	}
};

// Block 169 (If trade)
class Block105: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "169";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(105);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 170 (For each Trade)
class Block106: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "170";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(106);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 171 (Condition)
class Block107: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "171";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
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
			_blocks_[108].run(107);
		}
	}
};

// Block 172 (No trade nearby)
class Block108: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "172";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
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
			_blocks_[110].run(108);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)c::NEAR;
	}
};

// Block 173 (Once per bar)
class Block109: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "173";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {112};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(109);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 174 (Once per bar)
class Block110: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "174";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(110);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 183 (Buy now)
class Block111: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "183";
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
		VolumeSize = (double)v::LOTB;
		MyComment = (string)c::Comment;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 185 (Formula)
class Block112: public MDL_Formula_1<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "185";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Martingale;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[123].run(112);
		}
	}
};

// Block 186 (Formula)
class Block113: public MDL_Formula_2<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "186";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {124};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Martingale;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(113);
		}
	}
};

// Block 187 (For each Trade)
class Block114: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "187";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[115].run(114);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 188 (Modify Variables)
class Block115: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "188";
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

		v::LOTB = _Value1_();
	}
};

// Block 189 (For each Trade)
class Block116: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "189";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(116);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 190 (Modify Variables)
class Block117: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "190";
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

		v::LOTS = _Value1_();
	}
};

// Block 258 (If trade)
class Block118: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "258";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(118);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 259 (Break even point (each trade))
class Block119: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "259";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "2";
		BuysOrSells = "sells";
		OnProfitPips = 5.0;
		BEoffsetMode = "pips";
		BEPoffsetPips = 3.0;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 260 (If trade)
class Block120: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "260";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[121].run(120);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 261 (Break even point (each trade))
class Block121: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "261";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "2";
		BuysOrSells = "buys";
		OnProfitPips = 5.0;
		BEoffsetMode = "pips";
		BEPoffsetPips = 3.0;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 380 (Sell now)
class Block122: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "380";
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
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTS;
		MyComment = (string)c::Comment;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 610 (Check trades count)
class Block123: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "610";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Compare = "<";
		CompareCount = 10;
		Group = "2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(123);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 611 (Check trades count)
class Block124: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "611";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {122};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Compare = "<";
		CompareCount = 10;
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[122].run(124);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 624 (Trailing stop (group of trades))
class Block125: public MDL_TrailingStopAvgPrice<string,string,string,string,int,string,double,MDLIC_value_value,double,double,string,double,double,string,double,double,MDLIC_value_value,double,bool,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "624";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.Value = 40.0;
		ftStart.Value = 0.0;
		ftTP.Value = 40.0;
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
		tStopPips = 5.0;
		tStepPips = 3.0;
		TrailingStartMode = "fixed";
	}

	public: /* Custom methods */
	virtual double _ftStop_() {return ftStop._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}
	virtual double _ftTP_() {return ftTP._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		tStartPips = (double)c::Close_All_when_profit_percent;
		LevelColor = (color)clrDeepPink;
	}
};

// Block 625 (If trade)
class Block126: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "625";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(126);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 626 (Trailing stop (group of trades))
class Block127: public MDL_TrailingStopAvgPrice<string,string,string,string,int,string,double,MDLIC_value_value,double,double,string,double,double,string,double,double,MDLIC_value_value,double,bool,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "626";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.Value = 40.0;
		ftStart.Value = 0.0;
		ftTP.Value = 40.0;
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
		tStopPips = 5.0;
		tStepPips = 3.0;
		TrailingStartMode = "fixed";
	}

	public: /* Custom methods */
	virtual double _ftStop_() {return ftStop._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}
	virtual double _ftTP_() {return ftTP._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		tStartPips = (double)c::Close_All_when_profit_percent;
		LevelColor = (color)clrDeepPink;
	}
};

// Block 627 (If trade)
class Block128: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "627";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(128);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 628 (Check profit (unrealized))
class Block129: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "628";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(129);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Compare = (string)_externs::inp628_Compare;
		ProfitAmount = (double)c::Close_All_when_profit_percent;
	}
};

// Block 629 (Check profit (unrealized))
class Block130: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "629";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(130);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)c::Close_All_when_profit_percent;
	}
};

// Block 835 (Formula)
class Block131: public MDL_Formula_3<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "835";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Lot_percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(131);
		}
	}
};

// Block 836 (Formula)
class Block132: public MDL_Formula_4<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "836";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Lot_percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(132);
		}
	}
};

// Block 837 (If trade)
class Block133: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "837";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(133);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 838 (Condition)
class Block134: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "838";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {143};
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
			_blocks_[143].run(134);
		}
	}
};

// Block 839 (Condition)
class Block135: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "839";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {144};
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
			_blocks_[144].run(135);
		}
	}
};

// Block 840 (Buy now)
class Block136: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "840";
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
		MyComment = (string)c::Comment;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 841 (Sell now)
class Block137: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "841";
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
		MyComment = (string)c::Comment;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 843 (For each Trade)
class Block138: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "843";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {139,140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(138);
			_blocks_[140].run(138);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 844 (check type)
class Block139: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "844";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(139);
		}
	}
};

// Block 845 (check type)
class Block140: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "845";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CheckBuyOrSell = "sell";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(140);
		}
	}
};

// Block 846 (once per trade/order)
class Block141: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "846";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(141);
		}
	}
};

// Block 847 (once per trade/order)
class Block142: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "847";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {136};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[136].run(142);
		}
	}
};

// Block 848 (No trade nearby)
class Block143: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "848";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
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
			_blocks_[141].run(143);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)c::Near_PIP_2;
		RangeFraction = (double)v::H_L;
	}
};

// Block 855 (No trade nearby)
class Block144: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "855";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {142};
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
			_blocks_[142].run(144);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)c::Near_PIP_2;
	}
};

// Block 856 (For each Trade)
class Block145: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block145() {
		__block_number = 145;
		__block_user_number = "856";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {147};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		LoopDirection = "oldest-to-newest";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[147].run(145);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 857 (Modify Variables)
class Block146: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block146() {
		__block_number = 146;
		__block_user_number = "857";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ModeVolume = SEL_INITIAL;

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

		v::LOTBx = _Value1_();
	}
};

// Block 858 (once per trade/order)
class Block147: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block147() {
		__block_number = 147;
		__block_user_number = "858";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {146};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[146].run(147);
		}
	}
};

// Block 859 (Formula)
class Block148: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block148() {
		__block_number = 148;
		__block_user_number = "859";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {152};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LOTBx;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Lot_Martingale_2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[152].run(148);
		}
	}
};

// Block 873 (For each Trade)
class Block149: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block149() {
		__block_number = 149;
		__block_user_number = "873";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {150};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "2";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[150].run(149);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 874 (once per trade/order)
class Block150: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block150() {
		__block_number = 150;
		__block_user_number = "874";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {153};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[153].run(150);
		}
	}
};

// Block 875 (Counter: Count \"n\", then pass)
class Block151: public MDL_CountNtimes<int,int>
{

	public: /* Constructor */
	Block151() {
		__block_number = 151;
		__block_user_number = "875";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {148};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[148].run(151);
		}
	}

	virtual void _beforeExecute_()
	{

		Counts = (int)v::Repeat;
	}
};

// Block 876 (Counter: Reset)
class Block152: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block152() {
		__block_number = 152;
		__block_user_number = "876";

	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 877 (Formula)
class Block153: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block153() {
		__block_number = 153;
		__block_user_number = "877";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {151};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Lot_Repetition;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[151].run(153);
		}
	}
};

// Block 878 (If trade)
class Block154: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block154() {
		__block_number = 154;
		__block_user_number = "878";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {157,158,159};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[157].run(154);
			_blocks_[158].run(154);
			_blocks_[159].run(154);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 879 (Close trades)
class Block155: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block155() {
		__block_number = 155;
		__block_user_number = "879";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Group = "1,2";
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

// Block 880 (Check profit (unrealized))
class Block156: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block156() {
		__block_number = 156;
		__block_user_number = "880";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		Compare = ">=";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[155].run(156);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Percent;
	}
};

// Block 881 (Formula)
class Block157: public MDL_Formula_7<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block157() {
		__block_number = 157;
		__block_user_number = "881";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {156};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Close_All_when_profit_percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[156].run(157);
		}
	}
};

// Block 882 (Check profit (unrealized))
class Block158: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block158() {
		__block_number = 158;
		__block_user_number = "882";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		Compare = ">=";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[155].run(158);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)c::Close_All_when_profit_money;
	}
};

// Block 883 (Check profit (unrealized))
class Block159: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block159() {
		__block_number = 159;
		__block_user_number = "883";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1,2";
		ProfitMode = "pips";
		Compare = ">=";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[155].run(159);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Percent;
		ProfitAmountPips = (double)c::Close_All_when_profit_PIP;
	}
};

// Block 884 (Formula)
class Block160: public MDL_Formula_8<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block160() {
		__block_number = 160;
		__block_user_number = "884";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {161};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::open_hg_All_percent;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[161].run(160);
		}
	}
};

// Block 885 (Check profit (unrealized))
class Block161: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block161() {
		__block_number = 161;
		__block_user_number = "885";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {139};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		Compare = "<=";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(161);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::cheak_money;
	}
};

// Block 886 (Formula)
class Block162: public MDL_Formula_9<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block162() {
		__block_number = 162;
		__block_user_number = "886";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {163};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::open_hg_All_percent;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[163].run(162);
		}
	}
};

// Block 887 (Check profit (unrealized))
class Block163: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block163() {
		__block_number = 163;
		__block_user_number = "887";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		Compare = "<=";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(163);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::cheak_money;
	}
};

// Block 888 (Pass)
class Block164: public MDL_Pass
{

	public: /* Constructor */
	Block164() {
		__block_number = 164;
		__block_user_number = "888";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {165,166};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[165].run(164);
			_blocks_[166].run(164);
		}
	}
};

// Block 889 (Modify chart properties)
class Block165: public MDL_ChartSetProperties<int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int>
{

	public: /* Constructor */
	Block165() {
		__block_number = 165;
		__block_user_number = "889";
		_beforeExecuteEnabled = true;
		// Block input parameters
		ChartShift = 1;
		ChartAutoScroll = 1;
		ChartScale = 2;
		ChartShowBidLine = 1;
		ChartShowAskLine = 1;
		ChartShowGrid = 0;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ChartMode = (int)CHART_CANDLES;
	}
};

// Block 890 (Modify chart colors)
class Block166: public MDL_ChartSetColors<color,color,color,color,color,color,color,color,color,color,color,color,color>
{

	public: /* Constructor */
	Block166() {
		__block_number = 166;
		__block_user_number = "890";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ChartColorBackground = (color)clrBlack;
		ChartColorForeground = (color)clrWhite;
		ChartColorGrid = (color)clrLightSlateGray;
		ChartColorBarUp = (color)clrMediumBlue;
		ChartColorBarDown = (color)clrRed;
		ChartColorBullCandle = (color)clrMediumBlue;
		ChartColorBearCandle = (color)clrRed;
		ChartColorDojiCandle = (color)clrMediumBlue;
		ChartColorVolumes = (color)clrLimeGreen;
		ChartColorBid = (color)clrLightSlateGray;
		ChartColorAsk = (color)clrRed;
		ChartColorLast = (color)clrLimeGreen;
		ChartColorStopLevels = (color)clrRed;
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
			size = size - 2;
			
			if (size < 0) {
				size = 0;
			}
			
			if (size == 0) {
				// Set the initial list of numbers
				StringExplode(",", listOfNumbers, listS);
				ArrayResize(list, ArraySize(listS));
			
				for (int s = 0; s < ArraySize(listS); s++)
				{
					list[s] = (int)StringToInteger(StringTrim(listS[s]));  
				}
				
				size = ArraySize(list);
			}
			else {
				// Cancel the first and the last number in the list
				// shift array 1 step left
				for (int pos = 0; pos < ArraySize(list) - 1; pos++) {
					list[pos] = list[pos+1];
				}
				
				ArrayResize(list, size);
			}
			
			int rightNum = (size > 1) ? list[size - 1] : 0;
			lots = initialLots * (list[0] + rightNum);

			if (lots < initialLots) {lots = initialLots;}
		}
		else
		{
			size = size + 1;
			ArrayResize(list, size);
			
			int rightNum = (size > 2) ? list[size - 2] : 0;

			list[size - 1] = list[0] + rightNum;
			lots       = initialLots * (list[0] + list[size - 1]);

			if (lots < initialLots) {lots = initialLots;}
		}
	}

	Print("Labouchere (for group "
		+ (string)id
		+ ") current list of numbers: "
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

bool DeleteOrder(ulong ticket, color arrowcolor=clrNONE)
{
   bool success=false;
   if (!OrderSelect((int)ticket,SELECT_BY_TICKET,MODE_TRADES)) {return(false);}
   
   while(true)
   {
      //-- wait if needed -----------------------------------------------
      WaitTradeContextIfBusy();
      //-- delete -------------------------------------------------------
      success=OrderDelete((int)ticket,arrowcolor);
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
		int orderType;
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
				if (OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES)) {
					SetExpirationInCache(OrderType(), ticket, expiration);
				}
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
				newItems[newSize - 1].orderType  = cachedItems[i].orderType;
				newItems[newSize - 1].ticket     = cachedItems[i].ticket;
				newItems[newSize - 1].expiration = cachedItems[i].expiration;
			}
		}

		if (itemRemoved) ArrayClone(cachedItems, newItems);
	}

	void SetExpirationInCache(int orderType, long ticket, datetime expiration)
	{
		bool alreadyExists = false;
		int size           = ArraySize(cachedItems);

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				cachedItems[i].orderType  = orderType;
				cachedItems[i].expiration = expiration;
				alreadyExists = true;
				break;
			}
		}

		if (alreadyExists == false)
		{
			ArrayResize(cachedItems, size + 1);
			cachedItems[size].orderType  = orderType;
			cachedItems[size].ticket     = ticket;
			cachedItems[size].expiration = expiration;
		}
	}

	bool SetExpirationInObject(int orderType, long ticket, datetime expiration)
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

			if (OrderType() > OP_SELL) continue;

			if (OrderTicket() == ticket)
			{
				exists = true;
				break;
			}
		}

		return exists;
	}

	bool PendingOrderExists(long ticket)
	{
		bool exists  = false;

		for (int i = 0; i < OrdersTotal(); i++)
		{
			if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
			
			if (OrderType() <= OP_SELL || OrderType() > OP_SELLSTOP) continue; 

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
			int orderType = OrderType();

			SetExpirationInObject(orderType, ticket, expiration);
			SetExpirationInCache(orderType, ticket, expiration);
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
					int orderType         = cachedItems[i].orderType;
					long ticket           = cachedItems[i].ticket;
					bool removeExpiration = false;

					if (orderType < 2 && TradeExists(ticket))
					{
						if (CloseTrade(ticket))
						{
							Print("close #", ticket, " by expiration");
							removeExpiration = true;
						}
					}
					else if (orderType >= 2 && PendingOrderExists(ticket))
					{
						if (DeleteOrder(ticket))
						{
							Print("delete #", ticket, " by expiration");
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
	// TradesOrders = 2 - trades and orders - INCOMPLETE, DO NOT USE!

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
	if (
		timeFormat == (int)EMPTY_VALUE
		|| timeFormat == EMPTY_VALUE
	) timeFormat = TIME_DATE|TIME_MINUTES;
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
				((pool == 0 || pool == 1) && TimeCurrent() - OrderOpenTime() < 3) // skip for brand new trades
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

bool IsOrderTypeStop()
{
	int type = OrderType();

	return (type == OP_BUYSTOP || type == OP_SELLSTOP);
}

bool LoopedResume()
{
	ulong ticket  = attrTicketInLoop();
	int type      = attrTypeInLoop();

	if (ticket > 0 && ticket != OrderTicket()) {
		     if (type == 1) return OrderSelect((int)ticket, SELECT_BY_TICKET);
		else if (type == 2) return OrderSelect((int)ticket, SELECT_BY_TICKET);
		else if (type == 3) return OrderSelect((int)ticket, MODE_HISTORY);
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
	
	// Because we can have multiple new events at once, the idea is
	// to run the detector repeatedly until no new event is detected.
	// When this variable is true, it means that the event detection
	// is repeated. It should stop repeating when no new event is detected.
	bool isRepeat;

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

		// closed
		if (reason == "") {
			for (int index = 0; index < countBefore; index++) {
				item = FindMissingItem(previousItems, currentItems);

				if (item.ticket > 0) {
					DeleteItem(previousItems, item);
					reason = "close";

					break;
				}
			}
		}

		// new
		if (reason == "") {
			for (int index = 0; index < countNow; index++) {
				item = FindMissingItem(currentItems, previousItems);

				if (item.ticket > 0) {
					if (
						item.type < 2 // it's a running trade
						&& item.ticket != attrTicketParent(item.ticket)
					) {
						// In MQL4: When a trade is closed partially, the ticket changes.
						// The original (parent) trade is closed and a new one is created,
						// with a different ticket.
						reason = "decrement";
					}
					else {
						reason = "new";
					}

					PushItem(previousItems, item);

					break;
				}
			}
		}

		// modified
		if (reason == "") {
			if (countBefore != countNow) {
				Print("OnTrade event detector: Uncovered situation reached");
			}

			for (int index = 0; index < countNow; index++) {
				int previousIndex = -1;

				ITEMS_TYPE current = currentItems[index];
				ITEMS_TYPE previous;
				previous.ticket = 0;

				for (int j = 0; j < countBefore; j++) {
					if (current.ticket == previousItems[j].ticket) {
						previousIndex = j;
						previous = previousItems[j];

						break;
					}
				}

				if (current.ticket != previous.ticket) {
					Print("OnTrade event detector: Uncovered situation reached (2)");
				}

				if (previous.volume < current.volume) {
					previousItems[previousIndex].volume = current.volume;
					item = previousItems[previousIndex];

					reason = "increment";

					break;
				}

				if (previous.volume > current.volume) {
					previousItems[previousIndex].volume = current.volume;
					item = previousItems[previousIndex];

					reason = "decrement";

					break;
				}

				if (
					previous.stopLoss != current.stopLoss
					&& previous.takeProfit != current.takeProfit
				) {
					previousItems[previousIndex].stopLoss = current.stopLoss;
					previousItems[previousIndex].takeProfit = current.takeProfit;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "sltp";

					break;
				}
				// SL modified
				else if (previous.stopLoss != current.stopLoss) {
					previousItems[previousIndex].stopLoss = current.stopLoss;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "sl";

					break;
				}
				// TP modified
				else if (previous.takeProfit != current.takeProfit) {
					previousItems[previousIndex].takeProfit = current.takeProfit;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "tp";

					break;
				}

				if (previous.timeExpiration != current.timeExpiration) {
					previousItems[previousIndex].timeExpiration = current.timeExpiration;
					item = previousItems[previousIndex];

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
	* From the source list of orders or positions, find the item that is missing
	* in the target list of orders or positions. The searching is by the item's ticket.
	*
	* If all items from the source list exist in the target list, return an empty item with ticket 0.
	* If for some item in source list there is no item in the target list, return that source item.
	*/
	template<typename T> 
	T FindMissingItem(T &source[], T &target[])
	{
		int sourceCount = ArraySize(source);
		int targetCount  = ArraySize(target);
		T item;
		item.ticket = 0;

		long ticket = 0;

		for (int i = 0; i < sourceCount; i++)
		{
			bool found = false;

			for (int j = 0; j < targetCount; j++)
			{
				if (source[i].ticket == target[j].ticket)
				{
					found = true;
					break;
				}
			}

			if (found == false)
			{
				item = source[i];
				break;
			}
		}

		return item;
	}

	/**
	* From the list of previous orders or positions, find and remove the
	* provided item.
	*/
	template<typename T> 
	bool DeleteItem(T &list[], T &item)
	{
		int listCount = ArraySize(list);
		bool removed = false;

		for (int i = 0; i < listCount; i++)
		{
			if (list[i].ticket == item.ticket) {
				ArrayStripKey(list, i);
				removed = true;

				break;
			}
		}

		return removed;
	}

	/**
	* Push a new item in the list
	*/
	template<typename T> 
	void PushItem(T &list[], T &item)
	{
		int listCount = ArraySize(list);

		ArrayResize(list, listCount + 1);

		list[listCount] = item;
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
		isRepeat = false;
		eventValuesQueueIndex = -1;
	};

	bool Start()
	{
		AddEventValues();

		if (isRepeat == false) {
			MakeListOf(pendingOrders);
			MakeListOf(positions);
		}

		bool success = false;

		if (!success) success = DetectEvent(previousPendingOrders, pendingOrders);

		if (!success) success = DetectEvent(previousPositions, positions);

		//CopyList(previousPendingOrders, pendingOrders);
		//CopyList(previousPositions, positions);

		isRepeat = success; // Repeat until no success

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

/**
* When a trade is a child, its Open Price is the same as the Open Price of the most parent trade.
* This function will return the actual Open Price of this parent trade, which would be the Close
* Price of the previous child trade, or the parent trade if this is the only child, or itself if
* it's the trade is not a child.
*/
double OrderChildOpenPrice() {
	int ticket     = OrderTicket();
	int prevTicket = attrTicketPreviousSibling(ticket);

	double openPrice = 0;

	if (ticket == prevTicket) {
		openPrice = OrderOpenPrice();
	}
	else {
		double prevClosePrice = 0;
		datetime prevCloseTime = 0;
		
		if (OrderSelect(prevTicket, SELECT_BY_TICKET, MODE_HISTORY)) {
			prevClosePrice = OrderClosePrice();
			prevCloseTime = OrderCloseTime();
		}
		
		bool success = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
		
		openPrice = (prevCloseTime > 0)
			? prevClosePrice    // partial close
			: OrderOpenPrice(); // added to volume
	}
	
	return openPrice;
}

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
		datetime expirationTmp = 0;

		if (expiration > 0 && type > OP_SELL)
		{
			if ((expiration - TimeCurrent()) < (11 * 60))
			{
				Print("Expiration time cannot be less than 11 minutes, so it was automatically modified to 11 minutes. The pending order will be deleted sooner by a virtual expiration.");
				placeExpirationObject = true;
				expirationTmp = expiration;
				expiration = TimeCurrent() + (11 * 60);
			}
		}
		else if (expiration > 0 && type <= OP_SELL)
		{
			expirationTmp = expiration;
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
		
		if (placeExpirationObject) {
			expiration = expirationTmp;
		}

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
	int offset = 0;

	if (mode == "server") {offset = 0;}
	else if (mode == "local") {offset = (int)(TimeLocal() - TimeCurrent());}
	else if (mode == "gmt") {offset = (int)(TimeGMT() - TimeCurrent());}

	datetime time = StringToTime(str) - offset;

	return time;
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
	int offset = 0;

	if (time_src == 0) {
		TimeCurrent(tm);
	}
	else if (time_src == 1) {
		TimeLocal(tm); 
		offset = (int)(TimeLocal() - TimeCurrent());
	}
	else if (time_src == 2) {
		TimeGMT(tm);
		offset = (int)(TimeGMT() - TimeCurrent());
	}

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
	
	datetime time = StructToTime(tm) - offset;

	return time;
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
	// Only running trades allowed
	if (OrderType() != OP_BUY && OrderType() != OP_SELL) {
		return 0.0;
	}

	int ticket = OrderTicket();
	double retval = 0.0;

	//-- return cached value if possible
	static long cacheTickets[];
	static double cacheValues[];

	int size = ArraySize(cacheTickets);
	int idx  = -1;

	for (int i = size-1; i >= 0; i--) {
		if (cacheTickets[i] == ticket) {
			return cacheValues[i];
		}  
	}

	/**
	* When added to volume, we rely on the [p=X] tags in the
	* comments.
	*/

	string comment = OrderComment();
	int tagPos     = StringFind(comment, "[p=");

	if (tagPos >= 0) {
		string tag = StringSubstr(comment, tagPos);
		tag        = StringSubstr(tag, 0, StringFind(tag, "]") + 1);
		int initialTicket = (int)StringToInteger(StringSubstr(tag, 3, -1));

		if (initialTicket == ticket) {
			retval = OrderLots();
		}
		else {
			for (int pos = OrdersTotal() - 1; pos >= 0; pos--) {
				if (!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)) {
					break;
				}

				if (OrderTicket() == initialTicket) {
					retval = OrderLots();
	
					break;
				}
			}

			if (retval == 0.0) {
				for (int pos = OrdersHistoryTotal() - 1; pos >= 0; pos--) {
					if (!OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)) {
						break;
					}
	
					if (OrderTicket() == initialTicket) {
						retval = OrderLots();
	
						break;
					}
				}
			}
		}
	}

	/**
	* In MQL4 after partially closing a trade, its OrderLots()
	* strarts returning the remaining lots, not the initial.
	* That's why we need to calculate the initial lots as
	* the sum of all lots.
	*/

	if (retval == 0.0) {
	   int T = OrderType();
	   int M = OrderMagicNumber();
	   string S = OrderSymbol();
	   double OP = OrderOpenPrice();
	   datetime OT = OrderOpenTime();
	   int digits = (int)MarketInfo(S,MODE_DIGITS);    

		retval = OrderLots();

	   for (int i = OrdersHistoryTotal()-1; i>=0; i--) {
	      if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
	      	break;
	      }

	      if (OrderOpenTime() < OT) {
            break;
         }

         if (
         	(OrderMagicNumber() == M)
         	&& (OrderTicket() < ticket)
         	&& (OrderType() == T)
         	&& (OrderOpenTime() == OT)
         	&& (NormalizeDouble(OrderOpenPrice(), digits) == NormalizeDouble(OP, digits))
            && (OrderSymbol() == S)
            )
         {
            retval += OrderLots();
         }
	   }
	}

	if (retval > 0) {
		size = ArraySize(cacheTickets);
		ArrayResize(cacheTickets, size + 1);
		ArrayResize(cacheValues, size + 1);
		cacheTickets[size] = ticket;
		cacheValues[size]  = retval;
	}

   // Load the original trade again
   int success = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);

   return retval;
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
	int pos = 0;
	int total = 0;
	long retval = 0;
	static long cacheTickets[];
	static long cacheValues[];

	//-- return cached value if possible
	int size = ArraySize(cacheTickets);
	int idx  = -1;

	for (int i = size-1; i >= 0; i--) {
		if (cacheTickets[i] == ticket) {
			return cacheValues[i];
		}  
	}

	if (!OrderSelect((int)ticket, SELECT_BY_TICKET)) {
		retval = ticket;
	}

	//-- check if trade is added to volume
	if (retval == 0) {
		string comment = OrderComment();
		int tagPos     = StringFind(comment, "[p=");

		if (tagPos >= 0) {
			string tag = StringSubstr(comment, tagPos);
			tag        = StringSubstr(tag, 0, StringFind(tag, "]") + 1);
			retval     = (int)StringToInteger(StringSubstr(tag, 3, -1));
		}
	}

	double OP   = OrderOpenPrice();
	datetime OT = OrderOpenTime();
	string S    = OrderSymbol();
	int M       = OrderMagicNumber();
	int T       = OrderType(); 
	double L    = OrderLots();
	int D       = (int)MarketInfo(S, MODE_DIGITS);

	//-- check if trade is partially closed
	if (retval == 0) {
		total = OrdersHistoryTotal();

		for (pos = total-1; pos >= 0; pos--) {
			if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)) {
				if (OrderOpenTime() < OT) {
					break;
				}

				if (
					(OrderMagicNumber() == M)
					&& (OrderTicket() < ticket)
					&& (OrderType() == T)
					&& (OrderOpenTime() == OT)
					&& (NormalizeDouble(OrderOpenPrice(), D) == NormalizeDouble(OP, D))
					&& (OrderSymbol() == S)
				) {
					retval = OrderTicket();
				}
			}
		}
	}

	if (retval > 0) {
		size = ArraySize(cacheTickets);
		ArrayResize(cacheTickets, size + 1);
		ArrayResize(cacheValues,size + 1);
		cacheTickets[size] = ticket;
		cacheValues[size]  = retval;
	}

	// Load the original trade again
	if (!OrderSelect((int)ticket,SELECT_BY_TICKET)) {
		retval = ticket;
	}

	if (retval <= 0) {
		retval = ticket;
	}

	return retval;
}

ulong attrTicketPreviousSibling(ulong ticket)
{
	ulong retval = 0;
	static ulong cacheTickets[];
	static ulong cacheValues[];

	//-- return cached value if possible
	int size = ArraySize(cacheTickets);
	int idx  = -1;

	for (int i = size-1; i >= 0; i--) {
		if (cacheTickets[i] == ticket) {
			return cacheValues[i];
		}  
	}

	if (!OrderSelect((int)ticket, SELECT_BY_TICKET)) {
		retval = ticket;
	}

	if (retval == 0) {
		// 1. Get the parent trade
		long parentTicket = attrTicketParent(ticket);

		for (int pos = OrdersTotal() - 1; pos >= 0; pos--) {
			if (!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)) {
				break;
			}

			if ((ulong)OrderTicket() >= ticket) {
				continue;
			}

			if (attrTicketParent(OrderTicket()) == parentTicket) {
				retval = OrderTicket();

				break;
			}
		}

		// when partially closed, look in the history trades also
		if (retval == 0) {
			for (int pos = OrdersHistoryTotal() - 1; pos >= 0; pos--) {
				if (!OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)) {
					break;
				}

				if ((ulong)OrderTicket() >= ticket) {
					continue;
				}

				if (attrTicketParent(OrderTicket()) == parentTicket) {
					retval = OrderTicket();

					break;
				}
			}
		}

		// No sibling ticket found, then the sibling ticket
		// is the original ticket
		if (retval == 0.0) retval = ticket;
	}

	if (retval > 0) {
		size = ArraySize(cacheTickets);
		ArrayResize(cacheTickets, size + 1);
		ArrayResize(cacheValues,size + 1);
		cacheTickets[size] = ticket;
		cacheValues[size]  = retval;
	}

	// Load the original trade again
	if (!OrderSelect((int)ticket,SELECT_BY_TICKET)) {
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
