//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2020, fxDreema  (//
//+------------------------------------------------------------------------------+//
#property copyright   "AUN EA FOREX"
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
#define PROJECT_ID "mt5-6614"
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
#define ON_TIMER_PERIOD 0.01 // Timer event period (in seconds)

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
input string _1_Symbol = "EURUSD";input string _2_Symbol = "GBPUSD";input string ____SPREAD_SETTING____ = "=====================";input double LOT_Divided = 1000000.0;input int LOT_Repeat = 3;input double Distance_Spread_Next_Trades = 0.002;input string ____CLOSE_SETTING____ = "=====================";input bool Close_All = true;input double Close_All_Profit_Percent = 0.03;input string ____DISPLAY_SETTING____ = "=====================";input bool Show_Count_Orders = true;input bool Show_High_Low_Spread = true;input ENUM_TIMEFRAMES Time_Frame_High_Low_Spread = PERIOD_H1;input string Comment_A = "A_FX_JOBOT_";input string Comment_B = "B_FX_JOBOT_";input bool A = true;input bool B = true;input int MagicStart = 39995; // Magic Number, kind of...
class c
{
		public:
	static string _1_Symbol;
	static string _2_Symbol;
	static string ____SPREAD_SETTING____;
	static double LOT_Divided;
	static int LOT_Repeat;
	static double Distance_Spread_Next_Trades;
	static string ____CLOSE_SETTING____;
	static bool Close_All;
	static double Close_All_Profit_Percent;
	static string ____DISPLAY_SETTING____;
	static bool Show_Count_Orders;
	static bool Show_High_Low_Spread;
	static ENUM_TIMEFRAMES Time_Frame_High_Low_Spread;
	static string Comment_A;
	static string Comment_B;
	static bool A;
	static bool B;
	static int MagicStart;
};
string c::_1_Symbol;
string c::_2_Symbol;
string c::____SPREAD_SETTING____;
double c::LOT_Divided;
int c::LOT_Repeat;
double c::Distance_Spread_Next_Trades;
string c::____CLOSE_SETTING____;
bool c::Close_All;
double c::Close_All_Profit_Percent;
string c::____DISPLAY_SETTING____;
bool c::Show_Count_Orders;
bool c::Show_High_Low_Spread;
ENUM_TIMEFRAMES c::Time_Frame_High_Low_Spread;
string c::Comment_A;
string c::Comment_B;
bool c::A;
bool c::B;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double SpreadX;
	static double XTI;
	static double XBR;
	static double SpreadNowA;
	static double SpreadNowB;
	static double DIF_expand;
	static double DIF_narrow;
	static int N;
	static int N1;
	static double LOTA;
	static int M;
	static int M1;
	static double LOTB;
	static double XTI2;
	static double XBR2;
	static double SpreadX2;
	static string CA;
	static string CB;
	static int NX;
	static int MX;
	static double ProAT;
	static double ProAB;
	static double ProSumA;
	static double LotSumProA;
	static double ProBT;
	static double ProBB;
	static double ProSumB;
	static color Bucket1;
	static color Bucket2;
	static color Bucket3;
	static color Bucket4;
	static color Bucket5;
	static color Bucket6;
	static color Bucket7;
	static color Bucket8;
	static color Bucket9;
	static color Bucket10;
	static color Bucket11;
	static color Bucket12;
	static int NT11;
	static int NB11;
	static int MT22;
	static int MB22;
	static double SPNAH;
	static double SPNAL;
	static double SPNBH;
	static double SPNBL;
	static double Lot_start;
	static double profit_percentX;
	static int passA;
	static int passB;
};
double v::SpreadX;
double v::XTI;
double v::XBR;
double v::SpreadNowA;
double v::SpreadNowB;
double v::DIF_expand;
double v::DIF_narrow;
int v::N;
int v::N1;
double v::LOTA;
int v::M;
int v::M1;
double v::LOTB;
double v::XTI2;
double v::XBR2;
double v::SpreadX2;
string v::CA;
string v::CB;
int v::NX;
int v::MX;
double v::ProAT;
double v::ProAB;
double v::ProSumA;
double v::LotSumProA;
double v::ProBT;
double v::ProBB;
double v::ProSumB;
color v::Bucket1;
color v::Bucket2;
color v::Bucket3;
color v::Bucket4;
color v::Bucket5;
color v::Bucket6;
color v::Bucket7;
color v::Bucket8;
color v::Bucket9;
color v::Bucket10;
color v::Bucket11;
color v::Bucket12;
int v::NT11;
int v::NB11;
int v::MT22;
int v::MB22;
double v::SPNAH;
double v::SPNAL;
double v::SPNBH;
double v::SPNBL;
double v::Lot_start;
double v::profit_percentX;
int v::passA;
int v::passB;




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
int FXD_BLOCKS_COUNT        = 144;
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
	c::_1_Symbol = _1_Symbol;
	c::_2_Symbol = _2_Symbol;
	c::____SPREAD_SETTING____ = ____SPREAD_SETTING____;
	c::LOT_Divided = LOT_Divided;
	c::LOT_Repeat = LOT_Repeat;
	c::Distance_Spread_Next_Trades = Distance_Spread_Next_Trades;
	c::____CLOSE_SETTING____ = ____CLOSE_SETTING____;
	c::Close_All = Close_All;
	c::Close_All_Profit_Percent = Close_All_Profit_Percent;
	c::____DISPLAY_SETTING____ = ____DISPLAY_SETTING____;
	c::Show_Count_Orders = Show_Count_Orders;
	c::Show_High_Low_Spread = Show_High_Low_Spread;
	c::Time_Frame_High_Low_Spread = Time_Frame_High_Low_Spread;
	c::Comment_A = Comment_A;
	c::Comment_B = Comment_B;
	c::A = A;
	c::B = B;
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

	v::SpreadX = 0.0;
	v::XTI = 0.0;
	v::XBR = 0.0;
	v::SpreadNowA = 0.0;
	v::SpreadNowB = 0.0;
	v::DIF_expand = 0.0;
	v::DIF_narrow = 0.0;
	v::N = 1;
	v::N1 = 0;
	v::LOTA = 0.0;
	v::M = 1;
	v::M1 = 0;
	v::LOTB = 0.0;
	v::XTI2 = 0.0;
	v::XBR2 = 0.0;
	v::SpreadX2 = 0.0;
	v::CA = "0";
	v::CB = "0";
	v::NX = 0;
	v::MX = 0;
	v::ProAT = 0.0;
	v::ProAB = 0.0;
	v::ProSumA = 0.0;
	v::LotSumProA = 0.0;
	v::ProBT = 0.0;
	v::ProBB = 0.0;
	v::ProSumB = 0.0;
	v::Bucket1 = Gold;
	v::Bucket2 = Aqua;
	v::Bucket3 = Linen;
	v::Bucket4 = Peru;
	v::Bucket5 = Maroon;
	v::Bucket6 = Indigo;
	v::Bucket7 = Tomato;
	v::Bucket8 = Coral;
	v::Bucket9 = Olive;
	v::Bucket10 = Teal;
	v::Bucket11 = Navy;
	v::Bucket12 = Crimson;
	v::NT11 = 0;
	v::NB11 = 0;
	v::MT22 = 0;
	v::MB22 = 0;
	v::SPNAH = 0.0;
	v::SPNAL = 0.0;
	v::SPNBH = 0.0;
	v::SPNBL = 0.0;
	v::Lot_start = 0.0;
	v::profit_percentX = 0.0;
	v::passA = 0;
	v::passB = 0;




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
	ArrayResize(_blocks_, 144);

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
	int blocks_to_run[] = {47};
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

	ExpirationDriver();
	OCODriver(); // Check and close OCO orders
	if (ENABLE_EVENT_TRADE) {OnTrade();}

	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {0,4,22,24,42,43,54,82,84,86,88,90,92,95,98,101,111,122,133,134,143};
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

// "No position" model
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

// "For each Position" model
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
		
		v::N = formula(compare, lo, ro);
		
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
		
		v::N1 = formula(compare, lo, ro);
		
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
		
		v::M = formula(compare, lo, ro);
		
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
		
		v::M1 = formula(compare, lo, ro);
		
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
		
		v::CA = formula(compare, lo, ro);
		
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
		
		v::CB = formula(compare, lo, ro);
		
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
		
		v::SpreadX = formula(compare, lo, ro);
		
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
		
		v::SpreadNowA = formula(compare, lo, ro);
		
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
		
		v::DIF_expand = formula(compare, lo, ro);
		
		_callback_(1);
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
		
		v::DIF_narrow = formula(compare, lo, ro);
		
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
		
		v::SpreadX2 = formula(compare, lo, ro);
		
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
		
		v::SpreadNowB = formula(compare, lo, ro);
		
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
		
		v::DIF_narrow = formula(compare, lo, ro);
		
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
		
		v::SpreadX2 = formula(compare, lo, ro);
		
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
		
		v::SpreadNowB = formula(compare, lo, ro);
		
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
		
		v::SpreadX = formula(compare, lo, ro);
		
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
		
		v::SpreadNowA = formula(compare, lo, ro);
		
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
		
		v::DIF_expand = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Bucket of Positions" model
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
		
		v::MX = formula(compare, lo, ro);
		
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
		
		v::NX = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Once a day" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_OnceAday: public BlockCalls
{
	public: /* Input Parameters */
	T1 ServerOrLocalTime;
	T2 HoursFilter;
	T3 CertainHour;
	T4 StartHour;
	T5 EndHour;
	/* Static Parameters */
	int day0;
	int year0;
	datetime skipUntil;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_OnceAday()
	{
		ServerOrLocalTime = (string)"server";
		HoursFilter = (string)"disabled";
		CertainHour = (string)"09:15";
		StartHour = (string)"01:00";
		EndHour = (string)"08:00";
		/* Static Parameters (initial value) */
		day0 =  0;
		year0 =  0;
		skipUntil =  0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// The following variable is used for a little bit of cache, to prevent TimeToStruct() from slowing down.
		// It seems that TimeCurrent(Time) is slower than TimeCurrent()
		
		
		int day       = 0;
		int year      = 0;
		bool next     = false;
		datetime time = 0;
		int mode_time = 0;
		
		     if (ServerOrLocalTime == "server") {time = TimeCurrent(); mode_time = 0;}
		else if (ServerOrLocalTime == "local")  {time = TimeLocal(); mode_time = 1;}
		else if (ServerOrLocalTime == "gmt")    {time = TimeGMT(); mode_time = 2;}
		
		if (time >= skipUntil)
		{
			MqlDateTime time_struct;
			TimeToStruct(time, time_struct);
		
			year = time_struct.year;
			day  = time_struct.day_of_year;
		
			if (day != day0 || year != year0)
			{
				if (HoursFilter == "disabled")
				{
					next = true;
				}
				else if (HoursFilter == "hour")
				{
					if (
							time >= TimeFromString(mode_time, CertainHour)
						&& time < TimeFromString(mode_time, CertainHour) + 60 // make it 60 seconds period
					)
					{
						next = true;
					}
				}
				else if (HoursFilter == "period")
				{
					if (
							time >= TimeFromString(mode_time, StartHour)
						&& time < TimeFromString(mode_time, EndHour)
					)
					{
						next = true;
					}
				}
			}
		}
		
		if (next == true)
		{
			day0      = day;
			year0     = year;
			skipUntil = (datetime)(MathFloor((time + 86400) / 86400.0) * 86400.0); // This calculation gives us 00:00 of the following day
		
			_callback_(1);
		}
		else
		{
			_callback_(0);
		}
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
		
		v::LOTA = formula(compare, lo, ro);
		
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
		
		v::LOTB = formula(compare, lo, ro);
		
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
		
		v::Lot_start = formula(compare, lo, ro);
		
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
		
		v::Lot_start = formula(compare, lo, ro);
		
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
		
		v::profit_percentX = formula(compare, lo, ro)/100;
		
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
		
		v::ProSumA = formula(compare, lo, ro);
		
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
		
		v::profit_percentX = formula(compare, lo, ro)/100;
		
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
		
		v::ProSumB = formula(compare, lo, ro);
		
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
		
		v::profit_percentX = formula(compare, lo, ro)/100;
		
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


//------------------------------------------------------------------------------------------------------------------------

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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
class MDLIC_bucket_bucket_15
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_15()
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
class MDLIC_bucket_bucket_16
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_16()
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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

// "Bucket" model
class MDLIC_bucket_bucket_17
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_17()
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
class MDLIC_bucket_bucket_18
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_18()
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
class MDLIC_bucket_bucket_19
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_19()
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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
class MDLIC_bucket_bucket_20
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_20()
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
			int ticket = tickets[i];
			
			if (pool == 0) {
				if (!LoadPosition(ticket)) {continue;}
			}
			else if (pool == 1) {
				if (!LoadOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
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


//------------------------------------------------------------------------------------------------------------------------

// Block 1 (If trade)
class Block0: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(0);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 2 (No trade)
class Block1: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "2";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {2};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "A";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[2].run(1);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 3 (No trade)
class Block2: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "A";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[108].run(2);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 4 (If trade)
class Block3: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[61].run(3);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 5 (If trade)
class Block4: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {5};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[5].run(4);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 6 (If trade)
class Block5: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {6,7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[6].run(5);
			_blocks_[7].run(5);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 7 (For each Trade)
class Block6: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(6);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 8 (For each Trade)
class Block7: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(7);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 9 (Modify Variables)
class Block8: public MDL_ModifyVariables<int,MDLIC_inloop_OrderOpenPrice,double,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.ModeVolume = SEL_CURRENT;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::XBR = _Value1_();
		v::LOTA = _Value2_();
	}
};

// Block 10 (Modify Variables)
class Block9: public MDL_ModifyVariables<int,MDLIC_inloop_OrderOpenPrice,double,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.ModeVolume = SEL_CURRENT;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::XTI = _Value1_();
		v::LOTA = _Value2_();
	}
};

// Block 11 (Buy now)
class Block10: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "11";
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
		Group = "A";
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
		Symbol = (string)c::_1_Symbol;
		VolumeSize = (double)v::Lot_start;
		MyComment = (string)c::Comment_A;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 12 (Sell now)
class Block11: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "12";
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
		Group = "A";
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
		Symbol = (string)c::_2_Symbol;
		VolumeSize = (double)v::Lot_start;
		MyComment = (string)c::Comment_A;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 13 (Condition)
class Block12: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "13";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIF_expand;

		double value = (double)Lo._execute_();
		value = value*100; // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = c::Distance_Spread_Next_Trades;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(12);
		}
	}
};

// Block 14 (Buy now)
class Block13: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "14";
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
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
		VolumeSize = (double)v::LOTA;
		MyComment = (string)v::CA;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 15 (Sell now)
class Block14: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "15";
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
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
		VolumeSize = (double)v::LOTA;
		MyComment = (string)v::CA;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 16 (No trade)
class Block15: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "16";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {16};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[16].run(15);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N1;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 17 (No trade)
class Block16: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "17";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {12};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[12].run(16);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N1;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 18 (Formula)
class Block17: public MDL_Formula_1<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "18";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::N;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(17);
		}
	}
};

// Block 19 (Comment)
class Block18: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_account_AccountEquity,double,string,MDLIC_account_AccountProfit,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "19";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Title = "buy Sym1 - sell Sym2";
		ObjY = 100;
		Label1 = "Count";
		Label2 = "DIF Spread";
		Label3 = "Ex Spread";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::NX;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::DIF_expand;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::SpreadX;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::SpreadX;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::XTI;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::XBR;

		return Value6._execute_();
	}
	virtual double _Value7_() {return Value7._execute_();}
	virtual double _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 100;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrTomato;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 20 (Formula)
class Block19: public MDL_Formula_2<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "20";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::N;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(19);
		}
	}
};

// Block 21 (Check profit (unrealized))
class Block20: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "21";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {21};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[21].run(20);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::profit_percentX;
	}
};

// Block 22 (Close positions)
class Block21: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[49].run(21);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 23 (If trade)
class Block22: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "23";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[23].run(22);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 24 (If trade)
class Block23: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {65};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[65].run(23);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 25 (If trade)
class Block24: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "25";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[25].run(24);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 26 (If trade)
class Block25: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "26";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {26,27};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[26].run(25);
			_blocks_[27].run(25);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 27 (For each Trade)
class Block26: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "27";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(26);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 28 (For each Trade)
class Block27: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "28";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(27);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 29 (Modify Variables)
class Block28: public MDL_ModifyVariables<int,MDLIC_inloop_OrderOpenPrice,double,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "29";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.ModeVolume = SEL_CURRENT;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::XBR2 = _Value1_();
		v::LOTB = _Value2_();
	}
};

// Block 30 (Modify Variables)
class Block29: public MDL_ModifyVariables<int,MDLIC_inloop_OrderOpenPrice,double,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "30";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.ModeVolume = SEL_CURRENT;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::XTI2 = _Value1_();
		v::LOTB = _Value2_();
	}
};

// Block 31 (Condition)
class Block30: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "31";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {35};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIF_narrow;

		double value = (double)Lo._execute_();
		value = value*100; // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = c::Distance_Spread_Next_Trades;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[35].run(30);
		}
	}
};

// Block 32 (Buy now)
class Block31: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "32";
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
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
		VolumeSize = (double)v::LOTB;
		MyComment = (string)v::CB;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 33 (Sell now)
class Block32: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "33";
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
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
		VolumeSize = (double)v::LOTB;
		MyComment = (string)v::CB;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 34 (No trade)
class Block33: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "34";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[34].run(33);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M1;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 35 (No trade)
class Block34: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "35";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[30].run(34);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M1;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 36 (Formula)
class Block35: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "36";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::M;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(35);
		}
	}
};

// Block 37 (Formula)
class Block36: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "37";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {33};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::M;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[33].run(36);
		}
	}
};

// Block 38 (No trade)
class Block37: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "38";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "B";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(37);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 39 (No trade)
class Block38: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "39";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {109};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "B";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[109].run(38);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 40 (Buy now)
class Block39: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "40";
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
		Group = "B";
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
		Symbol = (string)c::_2_Symbol;
		VolumeSize = (double)v::Lot_start;
		MyComment = (string)c::Comment_B;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 41 (Sell now)
class Block40: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "41";
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
		Group = "B";
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
		Symbol = (string)c::_1_Symbol;
		VolumeSize = (double)v::Lot_start;
		MyComment = (string)c::Comment_B;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 43 (Comment)
class Block41: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_account_AccountEquity,double,string,MDLIC_account_AccountProfit,double>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "43";
		_beforeExecuteEnabled = true;
		// Block input parameters
		Title = "buy Sym2 - sell Sym1";
		Label1 = "Count";
		Label2 = "DIF Spread";
		Label3 = "Ex Spread";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::MX;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::DIF_narrow;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::SpreadX2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::SpreadX2;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::XTI2;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::XBR2;

		return Value6._execute_();
	}
	virtual double _Value7_() {return Value7._execute_();}
	virtual double _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrAqua;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 45 (Condition)
class Block42: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "45";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Show_High_Low_Spread;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[67].run(42);
		}
	}
};

// Block 46 (Condition)
class Block43: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "46";


		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {50,52,55,58};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Show_Count_Orders;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(43);
			_blocks_[52].run(43);
			_blocks_[55].run(43);
			_blocks_[58].run(43);
		}
	}
};

// Block 47 (Formula)
class Block44: public MDL_Formula_5<MDLIC_text_text,string,string,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "47";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {139};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = c::Comment_A;

		return Lo._execute_();
	}
	virtual string _Ro_() {
		Ro.Text = v::N;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(44);
		}
	}
};

// Block 48 (Formula)
class Block45: public MDL_Formula_6<MDLIC_text_text,string,string,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "48";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = c::Comment_B;

		return Lo._execute_();
	}
	virtual string _Ro_() {
		Ro.Text = v::M;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[141].run(45);
		}
	}
};

// Block 62 (Modify chart colors)
class Block46: public MDL_ChartSetColors<color,color,color,color,color,color,color,color,color,color,color,color,color>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "62";
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
		ChartColorBarUp = (color)clrDeepSkyBlue;
		ChartColorBarDown = (color)clrRed;
		ChartColorBullCandle = (color)clrDeepSkyBlue;
		ChartColorBearCandle = (color)clrRed;
		ChartColorDojiCandle = (color)clrDeepSkyBlue;
		ChartColorVolumes = (color)clrLimeGreen;
		ChartColorBid = (color)clrLightSlateGray;
		ChartColorAsk = (color)clrOrangeRed;
		ChartColorLast = (color)clrLimeGreen;
		ChartColorStopLevels = (color)clrRed;
	}
};

// Block 63 (Pass)
class Block47: public MDL_Pass
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "63";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {46,48};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(47);
			_blocks_[48].run(47);
		}
	}
};

// Block 64 (Modify chart properties)
class Block48: public MDL_ChartSetProperties<int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "64";
		_beforeExecuteEnabled = true;
		// Block input parameters
		ChartShift = 1;
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

// Block 65 (Modify Variables)
class Block49: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "65";
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
		v::N = _Value1_();
		v::M = _Value2_();
	}
};

// Block 66 (If trade)
class Block50: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "66";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(50);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 67 (If trade)
class Block51: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "67";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {78};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[78].run(51);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 68 (If trade)
class Block52: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "68";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(52);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 69 (If trade)
class Block53: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "69";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[74].run(53);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 70 (Pass)
class Block54: public MDL_Pass
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "70";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {69,71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(54);
			_blocks_[71].run(54);
		}
	}
};

// Block 71 (No trade)
class Block55: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "71";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[56].run(55);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N1;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 72 (No trade)
class Block56: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "72";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {57};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[57].run(56);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N1;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 73 (Modify Variables)
class Block57: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "73";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {18};
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
			_blocks_[18].run(57);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NX = _Value1_();
	}
};

// Block 74 (No trade)
class Block58: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "74";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {59};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[59].run(58);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M1;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 75 (No trade)
class Block59: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "75";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {60};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(59);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M1;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 76 (Modify Variables)
class Block60: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "76";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {41};
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
			_blocks_[41].run(60);
		}
	}

	virtual void _beforeExecute_()
	{
		v::MX = _Value1_();
	}
};

// Block 77 (Formula)
class Block61: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "77";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {62};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XBR;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XTI;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[62].run(61);
		}
	}
};

// Block 78 (Formula)
class Block62: public MDL_Formula_8<MDLIC_prices_prices,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "78";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = c::_2_Symbol;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = c::_1_Symbol;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[63].run(62);
		}
	}
};

// Block 79 (Formula)
class Block63: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "79";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadX;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SpreadNowA;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(63);
		}
	}
};

// Block 80 (Formula)
class Block64: public MDL_Formula_10<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "80";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadNowB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SpreadX2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(64);
		}
	}
};

// Block 81 (Formula)
class Block65: public MDL_Formula_11<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "81";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {66};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XBR2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XTI2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[66].run(65);
		}
	}
};

// Block 82 (Formula)
class Block66: public MDL_Formula_12<MDLIC_prices_prices,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "82";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "BID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = c::_2_Symbol;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = c::_1_Symbol;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(66);
		}
	}
};

// Block 83 (Comment)
class Block67: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "83";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "(Jobot) FX Differential Martingale";
		Label1 = "A Spread NOW";
		Label2 = "A HIGH";
		Label3 = "A LOW";
		Label4 = "B Spread NOW";
		Label5 = "B HIGH";
		Label6 = "B LOW";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SpreadNowA;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::SPNAH;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::SPNAL;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::SpreadNowB;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::SPNBH;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::SPNBL;

		return Value6._execute_();
	}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjTitleFontColor = (color)clrAquamarine;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 122 (Formula)
class Block68: public MDL_Formula_13<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "122";

		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadNowB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SpreadX2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 123 (Formula)
class Block69: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "123";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XBR2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XTI2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(69);
		}
	}
};

// Block 124 (Formula)
class Block70: public MDL_Formula_15<MDLIC_prices_prices,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "124";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "BID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = c::_2_Symbol;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = c::_1_Symbol;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(70);
		}
	}
};

// Block 125 (Formula)
class Block71: public MDL_Formula_16<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "125";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {72};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XBR;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XTI;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[72].run(71);
		}
	}
};

// Block 126 (Formula)
class Block72: public MDL_Formula_17<MDLIC_prices_prices,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "126";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = c::_2_Symbol;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = c::_1_Symbol;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(72);
		}
	}
};

// Block 127 (Formula)
class Block73: public MDL_Formula_18<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "127";

		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadX;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SpreadNowA;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 132 (Bucket of Positions)
class Block74: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "132";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(74);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket11;
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 133 (Bucket of Positions)
class Block75: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "133";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(75);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket12;
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 134 (Modify Variables)
class Block76: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_1,double,int,MDLIC_bucket_bucket_2,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "134";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 0;
		Value2.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket11;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = v::Bucket12;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(76);
		}
	}

	virtual void _beforeExecute_()
	{
		v::MT22 = _Value1_();
		v::MB22 = _Value2_();
	}
};

// Block 135 (Formula)
class Block77: public MDL_Formula_19<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "135";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {41};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MT22;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::MB22;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[41].run(77);
		}
	}
};

// Block 136 (Bucket of Positions)
class Block78: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "136";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[79].run(78);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket9;
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 137 (Bucket of Positions)
class Block79: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "137";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(79);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket10;
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 138 (Modify Variables)
class Block80: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_3,double,int,MDLIC_bucket_bucket_4,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "138";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 0;
		Value2.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket9;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = v::Bucket10;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[81].run(80);
		}
	}

	virtual void _beforeExecute_()
	{
		v::NT11 = _Value1_();
		v::NB11 = _Value2_();
	}
};

// Block 139 (Formula)
class Block81: public MDL_Formula_20<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "139";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {18};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::NT11;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::NB11;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[18].run(81);
		}
	}
};

// Block 140 (Once a day)
class Block82: public MDL_OnceAday<string,string,string,string,string>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "140";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[83].run(82);
		}
	}
};

// Block 141 (Modify Variables)
class Block83: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "141";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SpreadNowA;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::SpreadNowA;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::SpreadNowB;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::SpreadNowB;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::SPNAH = _Value1_();
		v::SPNAL = _Value2_();
		v::SPNBH = _Value3_();
		v::SPNBL = _Value4_();
	}
};

// Block 142 (Condition)
class Block84: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "142";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadNowA;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SPNAH;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(84);
		}
	}
};

// Block 143 (Modify Variables)
class Block85: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "143";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SpreadNowA;

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
		v::SPNAH = _Value1_();
	}
};

// Block 144 (Condition)
class Block86: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "144";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadNowA;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SPNAL;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(86);
		}
	}
};

// Block 145 (Modify Variables)
class Block87: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "145";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SpreadNowA;

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
		v::SPNAL = _Value1_();
	}
};

// Block 146 (Condition)
class Block88: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "146";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadNowB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SPNBH;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[89].run(88);
		}
	}
};

// Block 147 (Modify Variables)
class Block89: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "147";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SpreadNowB;

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
		v::SPNBH = _Value1_();
	}
};

// Block 148 (Condition)
class Block90: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "148";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {91};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SpreadNowB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SPNBL;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[91].run(90);
		}
	}
};

// Block 149 (Modify Variables)
class Block91: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "149";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SpreadNowB;

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
		v::SPNBL = _Value1_();
	}
};

// Block 150 (Bucket of Positions)
class Block92: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "150";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {93};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[93].run(92);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrRed;
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 151 (Bucket of Positions)
class Block93: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "151";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[94].run(93);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrOrange;
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 152 (Modify Variables)
class Block94: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_5,double,int,MDLIC_bucket_bucket_6,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "152";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrRed;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrOrange;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::ProAT = _Value1_();
		v::ProAB = _Value2_();
	}
};

// Block 153 (Bucket of Positions)
class Block95: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "153";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(95);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrYellow;
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 154 (Bucket of Positions)
class Block96: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "154";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(96);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrLime;
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 155 (Modify Variables)
class Block97: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_7,double,int,MDLIC_bucket_bucket_8,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "155";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrYellow;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrLime;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::ProBT = _Value1_();
		v::ProBB = _Value2_();
	}
};

// Block 156 (Bucket of Positions)
class Block98: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "156";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "A";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(98);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket1;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 157 (Bucket of Positions)
class Block99: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "157";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "A";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(99);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket2;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 158 (Modify Variables)
class Block100: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_9,double,int,MDLIC_bucket_bucket_10,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "158";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket1;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = v::Bucket2;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::ProAT = _Value1_();
		v::ProAB = _Value2_();
	}
};

// Block 162 (Bucket of Positions)
class Block101: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "162";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "B";
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
		BucketID = (color)v::Bucket5;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 163 (Bucket of Positions)
class Block102: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "163";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "B";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(102);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket6;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 164 (Modify Variables)
class Block103: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_11,double,int,MDLIC_bucket_bucket_12,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "164";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket5;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = v::Bucket6;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		v::ProBT = _Value1_();
		v::ProBB = _Value2_();
	}
};

// Block 168 (Formula)
class Block104: public MDL_Formula_21<MDLIC_bucket_bucket_13,double,string,MDLIC_bucket_bucket_14,double>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {13,14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Attribute = 2;
		Lo.ReturnMode = 2;
		Ro.Attribute = 2;
		Ro.ReturnMode = 3;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.BucketID = v::Bucket9;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BucketID = v::Bucket9;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(104);
			_blocks_[14].run(104);
		}
	}
};

// Block 169 (Bucket of Positions)
class Block105: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "169";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(105);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket11;
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 170 (Bucket of Positions)
class Block106: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "170";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(106);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket9;
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 171 (Formula)
class Block107: public MDL_Formula_22<MDLIC_bucket_bucket_15,double,string,MDLIC_bucket_bucket_16,double>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "171";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {31,32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Attribute = 2;
		Lo.ReturnMode = 2;
		Ro.Attribute = 2;
		Ro.ReturnMode = 3;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.BucketID = v::Bucket11;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.BucketID = v::Bucket11;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[31].run(107);
			_blocks_[32].run(107);
		}
	}
};

// Block 172 (Formula)
class Block108: public MDL_Formula_23<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "172";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {10,11};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
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
		if (value == 1) {
			_blocks_[10].run(108);
			_blocks_[11].run(108);
		}
	}
};

// Block 173 (Formula)
class Block109: public MDL_Formula_24<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "173";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {39,40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
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
		if (value == 1) {
			_blocks_[39].run(109);
			_blocks_[40].run(109);
		}
	}
};

// Block 174 (Formula)
class Block110: public MDL_Formula_25<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "174";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {20};
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
			_blocks_[20].run(110);
		}
	}
};

// Block 175 (If trade)
class Block111: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "175";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {112};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(111);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 176 (If trade)
class Block112: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "176";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {118};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[118].run(112);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 177 (Close positions)
class Block113: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "177";
		_beforeExecuteEnabled = true;
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 178 (Close positions)
class Block114: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "178";
		_beforeExecuteEnabled = true;
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 179 (Modify Variables)
class Block115: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_17,double,int,MDLIC_bucket_bucket_18,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "179";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {116};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket9;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = v::Bucket10;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[116].run(115);
		}
	}

	virtual void _beforeExecute_()
	{
		v::ProAT = _Value1_();
		v::ProAB = _Value2_();
	}
};

// Block 180 (Formula)
class Block116: public MDL_Formula_26<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "180";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {120};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ProAT;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ProAB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[120].run(116);
		}
	}
};

// Block 181 (Condition)
class Block117: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "181";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {113,114,121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ProSumA;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::profit_percentX;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(117);
			_blocks_[114].run(117);
			_blocks_[121].run(117);
		}
	}
};

// Block 182 (Bucket of Positions)
class Block118: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "182";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(118);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket9;
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 183 (Bucket of Positions)
class Block119: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "183";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[115].run(119);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket10;
		Group = (string)v::N;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 184 (Formula)
class Block120: public MDL_Formula_27<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "184";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
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
			_blocks_[117].run(120);
		}
	}
};

// Block 185 (Modify Variables)
class Block121: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "185";
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
		v::N = _Value1_();
	}
};

// Block 186 (If trade)
class Block122: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "186";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[123].run(122);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 187 (If trade)
class Block123: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "187";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(123);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 188 (Close positions)
class Block124: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "188";
		_beforeExecuteEnabled = true;
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 189 (Close positions)
class Block125: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "189";
		_beforeExecuteEnabled = true;
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 190 (Modify Variables)
class Block126: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_19,double,int,MDLIC_bucket_bucket_20,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "190";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = v::Bucket11;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = v::Bucket12;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(126);
		}
	}

	virtual void _beforeExecute_()
	{
		v::ProBT = _Value1_();
		v::ProBB = _Value2_();
	}
};

// Block 191 (Formula)
class Block127: public MDL_Formula_28<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "191";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ProBT;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ProBB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(127);
		}
	}
};

// Block 192 (Condition)
class Block128: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "192";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {124,125,132};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ProSumB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::profit_percentX;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(128);
			_blocks_[125].run(128);
			_blocks_[132].run(128);
		}
	}
};

// Block 193 (Bucket of Positions)
class Block129: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "193";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(129);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket11;
		Group = (string)v::M;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 194 (Bucket of Positions)
class Block130: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "194";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {126};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[126].run(130);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)v::Bucket12;
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 195 (Formula)
class Block131: public MDL_Formula_29<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "195";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
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
			_blocks_[128].run(131);
		}
	}
};

// Block 196 (Modify Variables)
class Block132: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "196";
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
		v::M = _Value2_();
	}
};

// Block 197 (Condition)
class Block133: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "197";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::B;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(133);
		}
	}
};

// Block 198 (Condition)
class Block134: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "198";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {1};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::A;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[1].run(134);
		}
	}
};

// Block 201 (For each Position)
class Block135: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "201";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {136};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[136].run(135);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::N;
		Symbol = (string)c::_1_Symbol;
	}
};

// Block 202 (Modify Variables)
class Block136: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "202";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {13,14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
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
		if (value == 1) {
			_blocks_[13].run(136);
			_blocks_[14].run(136);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LOTA = _Value1_();
	}
};

// Block 205 (For each Position)
class Block137: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "205";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(137);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::M;
		Symbol = (string)c::_2_Symbol;
	}
};

// Block 206 (Modify Variables)
class Block138: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "206";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {31,32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
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
		if (value == 1) {
			_blocks_[31].run(138);
			_blocks_[32].run(138);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LOTB = _Value1_();
	}
};

// Block 207 (Counter: Count \"n\", then pass)
class Block139: public MDL_CountNtimes<int,int>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "207";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {135,140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[135].run(139);
		}
		else if (value == 1) {
			_blocks_[140].run(139);
		}
	}

	virtual void _beforeExecute_()
	{
		Counts = (int)c::LOT_Repeat;
	}
};

// Block 208 (Counter: Reset)
class Block140: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "208";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(140);
		}
	}
};

// Block 209 (Counter: Count \"n\", then pass)
class Block141: public MDL_CountNtimes<int,int>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "209";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {137,142};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CounterID = 2;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[137].run(141);
		}
		else if (value == 1) {
			_blocks_[142].run(141);
		}
	}

	virtual void _beforeExecute_()
	{
		Counts = (int)c::LOT_Repeat;
	}
};

// Block 210 (Counter: Reset)
class Block142: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "210";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ResetThisID = "2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[105].run(142);
		}
	}
};

// Block 211 (Condition)
class Block143: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "211";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Close_All;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[110].run(143);
		}
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

int Counter(int id, string cmd="", int set_passes=0)
{
	static int idx[]; // index list
   static int pl[]; // passes list
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
		if (HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_BUY)
		{
			return true;
		}
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
		if (HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_SELL)
		{
			return true;
		}
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

datetime TimeFromString(int mode_time, string stamp)
{
	datetime t = 0;

	     if (mode_time == 0) t = TimeCurrent();
	else if (mode_time == 1) t = TimeLocal();
	else if (mode_time == 2) t = TimeGMT();

	int stamplen = StringLen(stamp);

	if (stamplen < 9)
	{
		int thour    = TimeHour(t);
		int tminute  = TimeMinute(t);
		int tseconds = TimeSeconds(t);

		int hour   = (int)StringSubstr(stamp, 0, 2);
		int minute = (int)StringSubstr(stamp, 3, 2);
		int second = 0;

		if (stamplen > 5)
		{
			second = (int)StringSubstr(stamp, 6, 2);
		}

		datetime t1 = (datetime)(t - (thour-hour)*3600 - (tminute - minute)*60 - (tseconds-second));

		return t1;
	}

	return StringToTime(stamp);
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

double attrLotsInitial(long position_id=-1)
{
   if (position_id==-1) {
      position_id=PositionGetInteger(POSITION_IDENTIFIER);
   }
   double volume=0;
   
   // Search in history orders - the oldest one with the same POSITION_ID
   // is the right one.
   
   HistorySelect(PositionGetInteger(POSITION_TIME),TimeCurrent());
   int total=HistoryOrdersTotal();
   for (int pos=0; pos<total; pos++)
   {
      ulong ticket=HistoryOrderGetTicket(pos);
      if (position_id==HistoryOrderGetInteger(ticket,ORDER_POSITION_ID))
      {
         volume=HistoryOrderGetDouble(ticket, ORDER_VOLUME_INITIAL);
         break;  
      }
   }
   if (!PositionSelect(PositionGetString(POSITION_SYMBOL))) {return(-1);}
   return(volume);
}

//-----------------------------------------------------------------------

double attrLotsInitial(string symbol) {
   if (!PositionSelect(symbol)) {return(0);}
   long position_id=PositionGetInteger(POSITION_IDENTIFIER);
   return(attrLotsInitial(position_id));
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

/*<fxdreema:eNrtXVt32ziS/is6mZeZ2c4MARIg6d6ecyRZTjzr21pKd/pJh5Zomx1ZVFNUEu+c/PcFCJAiKVASaZC6IQ+JIkBA4fIVqgqFKufMPvvP/AyAs3cjfzp1R6HnT+fvfnbOALTO/uOdaeSjTqugs3ePnjsZv/t5fmaevTvvXbQ/XQ3o//DZu7m/CEYu/Q9pCPIvQyd4ckP+pf7u5x/eGSjfGhC1ZkStwfKtIVFrOGpNL9+aJWrNjlozyrdmrrQGyfC1qDlUvjksIs6KWsOSWjOj1sySrdFRYeFYWXtWhfZ0YXtstHb59qAmbI9tFKBVaBCIGoSQNQgqNCgcMWTAALBCg0jYIB+yXqFBS9gggwcwKjQoBIjOAAJQhQaFuxCyXQOwtAbZtgYVcKIbwiEj1mAFoOjCfajzVa6AFF28KJxBV0CKLtw2Ots2sAJSgLBBgy0KrIAUXbjKBts2sAJSsBDLmDEHaEhrkC9KFaRAYYNsH8IKSMHCOcR8USogxRA3yDY2rIAULNw2mO9DWxqFbNvoFZBiCrFssm2jV0CKKVxlk4luegWkmEL2ZbJto1dAiik8pEwuwFVAiilkXyZflApIMYXbxmTbRq+AFEu4yhZf5QpIsYSrbLFjVLfKi4biRWZQ1isAhU6W4BRlBBoVgALEkjXb10YV4Us4ZLpStMEKQLGE8qbO5tCoABRdCBSdU1gWKDqZLYHAGX3NDhUDVWnSEDfJ9raBqzSJxE0yDmGYVZrE4ib54lQ4WkxN3CLfkLa8FhmnRVqFYetQ2KTOiESgSpPiLcSFRQSrNCneQlxCRnqVJsXrzcGIqmBHICRHX7NjBlXBjkBMjr5mBw2qIpIVEMmgg6pARxdycsBprIIcfV2DVYAjluXZJscVzhpsi2eR8TRcCTZoHY1QliRqMhhiXVqD7LTBVRBjiBmawZusghhDzNDieaxy2hhi7mMw7oOrQMYQcx+urmKrSpNiVmEw1OAqqoxwR1psJs0qpw0Srzdi621WgQ0C4iYZEs0qpw0SH2CIIcesctog8RZCbAuZVbCDxFsIcWttFewg8dmA2AFmVsEOFsMR801UBTtYvDzc7mFWwY7YCgD46tjyWmQ0WlWwUyD8ccuCVQU7BacY5+hWFeyIrRVcnLR0eS0yfFsVLmDE24cbVKwquBFbVABvEctrkS9MFRNzwVLzhakCGrGUxs9uy5bXIjMJ2JVAI1ThIaPRroIZU6x6cuOUXQkz4rXhthq7Cmgs8anILV62IbFJdt7YVXBjiQ8HLmHYWB6VFmPldpXzxhIzXovxcrsKdCyxOMBNS3YV7FgFbI1fxGmV0CMWMbhVEmhV8GMVtMlvz7QqALLFK2QD3mYVBNkFezOeT0Nim/wqUquCIVu87ja/ItYqgUgsB9rcu0OrgiJbvOVtfq+rVYGRLQa7zS9OtSo4ssX83Y7v8DV5627z+1hQBUe2+EaWbyVQCUZCR5d44BVABDXhAkEtbtOo0iZcI1kDgOQ1ybcRwFWaROKRx0tuVmkTr5GEAbDkNcmBXsVTwDDFA+f8HWpVqCxok292CKq0KTaXmJwfiT0GSPXLm1979+XI5McQrIQgoWwIQUxmhctQsaEo6ilqsgqCQIFyGreJK8ymeOQaRyWsgiBQIMNS5vEjKniY+KMvzDPSMKhnJN1bENB+rMh5Mgz8SVSO6Hf22bsPgb+YXfvjuBNnMqGfEC9J+zcC7exd//XlwZ/E9SmF0Rf8P/3kP4Cs1OjsbAiGqe9IQ53F6/w26LsTSsX8zCAkk28I/RExlEDHm7oBLxt4oy/0I6F97M2dh4lLpunhTGNT5X4P3YD5gWpn//kR7Q5vnKaYNOnNh6PFPPRf4h9a8SyxCYyGMA/dF97PCxnaZMibISRcPt7O3Kk7vg3GbhDRDEjXMydwXlzSPWnd94NxVECmh7c486bTJalkLucjZxLP2NQPXpxJPKFzl7YV+kE0Dp2tWTwC6j26/Kwnn9li
z0MnXEQ/g3wj+VP/8ZFW1dj8jZ3QSSj7EVUJvZBRYtGxtcLASZaS/DaaFN4e+f3EfQxpc0Q9ijZH6M/ofxGmjZHyb44XxqMkc/3VCTy6SKklIXPlL8LZIpyn2/XId/R3gJHp8v9qtFnSzWgeTwYZMN3VzujLE9mN0/H7kT/xAw6Vv7Ttrn1xwbdrUkKm6C/xdnskG+r9N9d7eg7T80AXNgbDkGyjwFlSTHfug09X+/08fGVzxX7HfHm3RxMh6inGUA5P7YPDE5SEpxv/ePF042+JJ2jjDKCADk4UUfrOEQXXI4puNvZZOqR0BaklpMgmfQ+AXFRZ2omiytix1Lc7TBlK7KtN7KMWvtPEE5KAJ/IZfD07uzk4yQ8pSMmDFEJZTOFThRTeA0jt7pjCClP1YYrecpwmqMwiUJG13BpVhHLwE2ziqCKlhIQr35+dewF71R19Sbeh+82dh+9D/70/GZNPfE/Quv0v3iy1oW32be+rG7yufn3lvXhhWpwlo7tz5vPeNIaiVgO8TRnwRny4oROEAwqE2vGNtsM31S+Wn1F6Gt+Me7rzL/yg5Tqj59ZgK/gbprafal+3p2ndXh7+tOQi+lPABCg8fHof8AZGYO0HI9j6gD1aTmApTtAcJ8AaUpwgxwnsjZzgVz4Z8eUiAfznzj3/z6/OZEFL+JQkW5s0+c6bTsiuHEayJxVD7wJvFAtvmZ6i6SEEdW/v73vdweXtzZLCHxkaIJ8XQsPV7aCdJgKuEgGsLBG/+pPFi4gCGFNAWdeyFp3yfu9q2P1E6LoZxFDYTKaehVlEny6gD9CtRsqG0d9FhCHeQt7qtpkOQ0CHsQM6kIAO1Awd0jm2LYljk63mPb7+uuQ0u+fYWopjazVwbByPupUZ9gaenZXeoC7rcll7G88mWiViASDyPPsh+lOTChd56JVn2INLxbAVwz49hs2DjymO3RzHNjBSHDvNsYt97GIHvxVHhc1mM9I643sp34dH77s7zpb2vf9LVlL7h0bN4Vd+OJxTVTHWopY17735F44a9pZ12VBcRP0M/4FijZyV3bnByJ0m/oaaFvNyVtyhGEvViV0b6FyP02RKYC86HeYmRkdJu6Bzde+Env9p6oXxNBlslmLELyuduxMGkySuHi1/ebl+uiQ/95wJmdV5jgCLVbheTEJvNnm9nV7583naXQpq+Rp3gf+YtUJQDkPrtMdj2kWmEUaHnauQaSND6r1LICtowcwUF9EAdIiLB6vHVe7dr4QVJlvSmbDPrI0L78EvbANCWuWccMeXBzcIN0xsUq+gQxhRdOU8+IvRsxu4xc3hbMUrjxmR6O4DP8Gf9J+Mn9BPeDnXy6pFY4267rt/dpy5K+gQ8OLlUpBf66QrnPm1cCkgLyzqGseo+zSbuUFi1OLnEf15n/Bl2m/MOAx6DE3dfPGdN5tneAHdrUkhQ3MiIEa4QShe6Fy1wV2ONZCWxpO4UlPiTdTrTGqv2SGt63cstd80m1rTMZWbnC8u20Wi5c5UWF1wmCles+S2oGL/KjdDkC76slpjy077nUnud7uFpz2PJfe83dITDPa+p833HwZdLuyQ78+d17SQakVffvQXwTw/p7QRb7oI3XR9KjSSAsFwtHg4oSdW22IpiFI24HWSY0ijYj6RBdKv2WPZPSoInZf4Xl/TzpbbihZ2nel44l6e50dAy66d4IubYYN2+kf00yOV4fOHYlTFf5kRuEzD310nSDdh5cqvyTif0xVwrgKZ9XRxvn06/6mn9Skikx6ilcif/ZkqfZdM9zhTRV/Odv/ZewzTAkjEAOICOsD0MlOpISmMRpcpTf/0N9f9kinUU4XxbktWJf3LZNflZo11urL1MsVssMLiL96M0jTmXZMew4Dih2KDLFx/4s1mzpObcwq8fiUT+RJLqUzq5t8M2/G42kHgf+tS7aGzeOWYGk2CToRP+cqrjHcqOLpZu/G/7du1UFplleQYYkZjbU3ZYNf7AyOQUVR1VJOiCkoq
qppmaYy75RXVx+hPjddBAEpSVqFSVpWyqpRVpawqZVUpq0pZVcqqUlaVsqqU1SaVVSOtrFKnSi6sE2313h3XoazKeAROT2RC62loqxYb7Fbqqq6j/VRXHx+1namrhe/DDc7sr3w5Z7fB3hKdX14Q+mbOdCw+1Ei1v0eHLT/YRoTZOUGM3f/mQLmXQ5RONyKB/TlRApzpyB32Z4HrjIc3ZAaHKUfgFSrJ4v79PVhKfKOACHvfvDE7E5LtvW5VJHMOGW/dyc+7hMd6iXd4jbyDDeHN+M+TvJYBmLkoK2hPgkJcXJx323aVZ0zrkG1sb4gin5NnCPI9J8DSGMU92JQdStmhlB1K2aGUHUrZoZQdStmhlB1K2aGUHYpvMiInd3flLGEcs7ME2KmzBMo9otcwUM4SSKKOCpWOqnRUpaMqHVXpqEpHVTqq0lGVjqp0VKWj1qyjNu8jgY7aRwLs1keCBsrfTzV1l04SWEoQfcyjqR5YrheKOVnhVFVyip+jjK9piBnGqWZ7AeZ+4GpHYYopsEwFLKkpKvLYsk81/DcojFCqy3Xsy8cIL9a7sq58/yXXlW+bsEjiuYyaIkvnjP9YzMMsQgJ3vpjEcgQbpXweYMkRaC8IYBcT50Ac97IEr8d09uYES8uS8cZwSI+PlrUqkb7Vba8wnqiu8WkexHNI7Y5E4muR0wu03rfoIUU/w3gL3D780X12grC/ePjNm46Z+L8M2kuL/YDvYaq1E9zc9O6H95cfPg6Gn+7uevd8d5Oan9PJKthXv6+asci3EXUXPlMVCREfXD948pwUTUmNbjxndqQvDvwXsstibTVdMb6ESBxdqRpNKlw5D+5knursVzcYO1MnHlCmStIbXRnS3bkTfPkQMNMDp2xZOd2jxhsnFQq6gklh0okV9fHbsxcmF0y8ykrTZLBRx4BvpS7ZauGGaIMVOGQsJn3ewKljcmBc7/zyosUcozdFH6zPLXyFutjfufddQJukyIOA0cba33baaoxAWIme+iIRmowcHhpzC1KwgBQslRQWVnkLUkwBKaY4qKczGlFADtvs396fCy98rRDUM+7aEnRtbdX18tKrVNfyJRZb1mODyKbY+163zEIju77FCkez6Sw/m6nPVuqznfoMNNl+JikD7HoLngm0mnSgN8tLj48IN5lNVlM6kEwdiBn+b0ANShDUlBK0PlVgFtS6hY9YCYKFEV+Bvn16lfjqa8UiuKyeMQfG9cWWdZ+/7SOfe87oOes6kPopLexmUP6vWKVZ/q79Esv4/JdUlcsXp9wOQHIPnO2Xui/5U/d1eUas9Avj3yz7pJejGkHyLPp+OGNuCZ9jMtfQIB/3UtLIk4a6z+7oy6eUW9Bx3CtAxIfWYovV+utiSqT/CdEhx3/bLAtYRu46z8Anm1q+MDCXtWuWQs0HlOjVW/2CG3na//LWPW3TcN3ZnTf9UgdSpSSoJ2R2J/7cZbcVp5BlCfERt2b+PHqmPN8CtmYOtkjfExnewBZ8MErfwqfW6S0Q1necdhvs7KIQysplrxKaUq3dyuILnWo+U7jniezrc2mBKpF9jYACGjhVRElMZX99gOeUSmYvEVZAN3Du7vtUYYX3AFa7O6xUOvs6UXW6+ezhYSS0P/Y81hTiKqV9g4msAcQqp/0KMziMpPbJMXu8vEAltW+SF+i2ymq/wgtKprU347T2cB/SJHdUmmSVJrnpNMlQJbZvNE0y4dtA5UlO8Wxdq8SzB5eKZyuefZo8W1ep7Zvl2RBhxbPTPBvsIP/C1KG+Qyr/gkxGAmQ9iTji/AuWqeXcLvARJ2DQYengltcNBLfsqOCWKrilCm6pgluq4JYquKUKbqmCW6rgliq4pQpumQtu2dlNAgZdxiObvU3AoO00AYOF9jW05Q4zMOi6RCUVKCVVKalKSVVKqlJSlZKqlFSlpColVSmpSkmtWUltPAODrsuJ1bSnGRi03WZgsPV9TRS4wwwMuiEzUvz1AQaA0A0VKV5iCgYT
5cKpneoLQB3tB7J29rZWRwpYclMw5LBl6KcaC0LHzcYfvT6JHAzXdTABrMKPlgI1khaJYh/jj+qmAq78wMHXdQQO1k2F3FKhmXR41Mi1pIizVAA9QB3RUqKsPB0RaLnEQwCfajIx3d45qnanH9oKVFL1wxVcQXCquDK07b1vYvDIfx6Cl543fjic03ghyv1Gud8o9xvlfqPcb5T7jXK/Ue43yv1Gud8o95vY/YZL3fyb4Y7eihiaeitS11sRoOk5BwFbO/m3IgaQpK0Cpa0qbVVpq0pbVdqq0laVtqq0VaWtKm1VaatNaquNPxoxgHo0Ut+jEQAg2E99dYePRozC2Aa6xtdjkORZ1iIHghZRTGHrfYt66NDPidZw+/BH95momv3Fw2/edMyWZJkrghb7AQcK5ajkOLvp3Q/vLz98HAw/3d317vmoSM3PHK1o+dXvmayEUULghz8i4i58hmJCwwfXD548J0VSUqObmlgC4fafCydmI+lqsXZIWbMe8zdSgSgC7mSe6upXNxg7UyceTabKSs5hcih9CNiZwOlaVk73qPHGSYWCrmBSmHRiRX389uyFSZgIXmWlaTLYqGPAd1s3zne+JrR1BcElfurweYPoEpMD43rnlxctFuB0U6jr+sK7rlAXv+XrfRfQJinMNWS0sfY/wy0pqzHedTWC6gt8bTF64lDsW9CCBbRgqbTwVB5b0GIKaDHFUeSd0YiCcthm//b+XHjha4Uo8nHXlqBra6uulxaJUl3Ll4tkPKaNovBG4l3ve92SEc0lUDnLT/QZpz6bqc9W6rOd+gw02dcAKel4rVgFNZh79qDtjfP04yPCTbqqoUqByhFt0Z+4znTI/y3iQfR2ZlkDmkzTIYpL/9n/NvxIxjG8Ih+Wh9TW7yUINb/80vCDiT0JS24gWdzliMOSA8vKZdlFxxyX3MDNItnIIjmSyocpJ2gF480wxgrGW8DYyNpADHDMKK70RJGMPqS5NehfRQChW5UX06vHufMym7gt+ouUFbEt88ViSaooK0pRlU41Wt/jxW67DqOoery4HtO5V8fYREf8dtGwdgrpzl5B+roBSHfqgLSlIF0qkgCG+IgxjQuTAAEGarrD6cUCcxtNSFuavjsTh23GbFUy3W6+6tJKbqSrfgi4gMwuB64o/f2JE7qJ1R5liQg+zeJWqH3fdWf9L6+dWGY2c5XP/W/T3O3hyrgWkwm7oi5uN/cL1wmWv1jT9Ln/h7ep6SzJzKtonlyN0hl5IXPhutP4SiRFx6apy9RuM9dC3uxt4EyfXE51dkmunHlYREB2fJG7jfvVncy3uqGlzmEVOReGkh66sosyl9E/PxAORj0QeDrDEaW/NUqoLxeuz9gbdmY+Iq1BCyEuvG4tVInfsltl2M0JCXfO/FC2aIra9VvSzOrB9p7YrEfRnyZ3ZGHUSGDxuAURr4rdyyJm/rF9Pxh22zfnV71+5vC4nWbPXEifwidSasTzUm5JIHOwtheh3x+R3icFv4x30rJITxr1v91+vOpmS3GqlJxRV940a9BKl5NTaaXcTJXTwyiukPQAUarGnRt4/rif2tRFlCayRuy1lSYkdfIu+wGpCufufBR4M2ruydXSUrWixKDLM3FJiJVuihzSglm106OiHqCCOii9KBfedwAKxsvLU6Xy2ZyUsJ/W8lC+C/yZG4TefuQoXnNPKINjQj13qM8yo9/kUoVy4V/AqZ7sqFxieRan70a+6025ROUwEzNQusdNKVpUEvnjTSKPpUSQVUnkt04ib+F8YC4NnXQWeYxLxeciA3KYJJp7sllXXPT6onNhLMlocfl4vCHvLh+3Dc2FjawnBAD4RENzYXPHkII7CyOJTYWpOjF1smEksbXfx1SdmLIUpuRhCmpmTgKEp5q/A9v7fU7VKPrZClJ1Qso8VUiZWumLrDdsY1NTF1lFe1I3tFzWiRO9yTKBBC7PHy7eHJ6WbwIVg1tiYHvTQkp6YriC+4Cr3an6JlTAkhvc
fgVbpytG6eVuDZlT7s3nWq4NtZLXhrmrKXVlqK4MpfJd/biuDLV9vzI0Ma4p58hh3hiahjzB5xDTKZsqnbJMjcLWlEbBgYX2AVg7M8qaKpuyZIViBVqnq1DgKgrFtVIolEJx/AoFVgpFsz6IuZgxEILTViiaSpltJvHpyr5Xfy83eIyZBO2r86l6FIo6CVVYh8SmYlBseE6Xuxe3jzkGhVkpBgV9EjWjr6nmQ/aPAD8GX6Uk7j75TYeFOcdsA7P/LPfI5jSnUpBfkfZ2/39K0Q62of2tzEJPMYsb/1sdMWtMFeCiFL+ACBwzv7AbOvajJDbpg3CnZ38cbjmNtNphTWM7u99nzrSO+PymrWBdBta6dsxigKU1Bes8kDq7RnaZ2ODycB3HbJeOa0tTuC4Vjwqa2jEDGzQE7O3DyNeN6G2D678VzCCtqMM6oAwUlEtBeY8iNtQBZdikql5W3d0nVb2smWEXqnodsSgtqBhGubMfHLVQXyIflk6I/+u//Qc//Fvr4nPr3Ht8dAN3ShPPtq6dIPSmT3xRS2fHMpPsWFe9i0aTY1HM8exYL2RBp+6J58iibbV52qfWze1vNVyUl7OT5JJmYUrex8sPH+XfnNucrrub9scymbIQJekqO1W6bIquymTIoovYKVhEYzc6eiZhFqbk5RcRSZ6yzraLGF+MdvKLiGVTtO0ibpk9q2RA7TiPqLQUWpL7ly/rqDxaa/Joaek8WlrjebRWvCVsA5xoHi0AoTKtHoFplSZOh0q/2vCA28g5rx73ZSiAurKuHqR1NUKzrtBcDs3A0I4azYYysCoD63qeYSieUZJnHLX7JI0ZrtygD84NOoIyUlBeD2VoZ/OKAP24oYyVK7RyhV7PM7DiGSV5hn3cBgBTuUMfvjt0BG31LKoktKFx1OKAXmi3x/y7zmL0xQ3Z8UcTVo0mwe/uZOJ/I5uVlYHYg2+LGBCpxDUHFFqFQkeXElQumVBCszsKWTSIumFklL+Tk5V8kg225T+27vy5l6RA2xC0V8+9QkZ7ElsemchcDQ5BSy6iPwVIpIFJ/Mn4bTdsul4GqcBKUrAucQobw+luIrVEMNUVTHcEUx0ABVPdKBfOxWRAG0C4yU9Np6ChyzRk/whE2LJnNg2NceFNyFbu+tNxtO5ZH8d2GAbewyLMxIexuZ4cs4OUV8y9Gy6CqaBgy3gyfDY62dmA8majmC/u01yomDZHGtMmOqGM4wpqs++J9aCWi7evY+2kg9pQC3ejDh3x6VbGlvNftTh0xCdLXUacZXC2GviGusrZBPRcOFwD4KO23eBSGiGOJJ97d5wIPnZZffDmsHJsRKjBSh9sRh9cSQkIsab0Qd2sYGC9DZzpU0pB0RoDKtyhgdVUSN0RUnWgDKxAt6pYbm4GzJRSg+Wm6MTeU6vNTSc7E1C6DUvIFpXdRtltmrHbWMpu02gwYozydht04nYbu1m7TXy27d5uE58t9dptbuqx26gYhJuAbubsNvCoX+AY2tpkKnRx+27w1SXyzpVPVm3gvSTaW/R93PlHfxHMmeyzsjlZja4b0H1MK/JRaDY5g/iG7IdOEKbLwJkWh+roTcfpEisqkQ8OQ0YgPxqnZDpy2+NlKJI9RwdtmJLcclqc6HIvzYGG9sS28qC50NKbfGpugHJ6Gp3r92Y6LMqOo8Hk1SeL+XTHIVIkJ1N5A3V6hrrOxxrUmrKv+fNKzpK6qz0IEXOsqo8Bjlf1KQpGsts8LGbugQF9gnfSuo9R6Khs1BxgpF1WBfqXXBWoRFAvWjQK/Pn8mzcOn9+ljc3rJl42t4Cyghal7HkHINTlSd5kg89aN0wT74dEd3Fx3m3b0pWeknmzl0LRPopsKu+dsjXXKnCpTNoN25phlhtbOj5xecs4GHnrv2uTt64OQ94ylLy1GeGmjU9K3kJV5a0rJW8peevU5C2k5K1G5S0zl6NAyVt4V/JWZ2/sW50DsW9hJW9tRridu9Q3Le2o5S2zorzVacK+
1VHylpK39kneMpW81ai8ZSMlb2X5tXUw8lZt9q3Ogdi3LCVvbX78CnTtpOQtu6q8daXkLSVvnZq8ZSt5q9GYIwBkHbgs48RjjiCtzDvo5OWj6OEzIfwpfu58FDEKkKZePjfz8hkZWTXI0FTIOoBAGWjaqae4DaJzh4EJEFDw3BE8VeBXAk9YRdO5C/z2oKbABJnTufT7e1BzNILl+Ds1hSPIs8B9mgKlxh2xGoegCkHQpBqHUFaLQ9qJW82RXl5UZJGHy4uKh5gkAKno403FsNJzKfh0W0WbA8gog08ziYXdIDp3lxoAGQqcOwKnYWAFToQqKnKduhS5/AG9v7pcpy5dLssDlSanNLlmNDmkNLlGHaB0kHWPMOwTD6iA3ho9HJQRGskA2gd4MaeChzclMeYzqhpKnSMYLRU8HNiiKLmwKZju8oZOhQ7fFU6Roa7oALL27Yqu6Lw+wdu6NWxRqXtK3WtG3VOxw5t+75I7pk5d3cPwjeoeKilHdg5P3cMqxXdDYqRt5PGpKTESYP3t6h5uCqY7VPewumXfGU5VTjcaunPfLvKKzusTvNBbwxaVuqfUvUbUPaxSfDeq7tm5TFEAgxN/boetSqmidp2pEJZiuPEPpOWnOrjh63UmxWJpHa9uB+1ahHgZJrFjTouFs6K3bYBjToqF7Qp5kpnn2vKGA5TNk3yIPubYVtpvM9qvlXv+YZnKSAVM7Y2GZLuxZOa7sySb6kV/QxjVc3HNLPWgH5igUeHfXHU1AKck/e9u/M2I/51aOCRQ4v964cPKCh82OuqkuCaswrMg+eSMRoTIcNhm/3aciTMdiSyDUeNluMU/5QZepPwAjCJIDc+9r96YH+Y14ZdONwWwHw7nNNFvLSiGCsXrA4HZWcskNI4bxbpC8QGiWFcoXu9Oplk5GNvHDWNj/2D8d7kwhhaDcXfiz91hezIZ3gX+oxcO79xg5E5DWZgm1f4J2Aplcc1uwmes0xnr9HMt6DYUujdkW7Zw7vHRvsR5qQnehQ/REXdf2cI2h1jI40M0zkl5e0uIuHxkJrlbOs+1X87r2xnmZIDHomNrEZ6WLOaaGEk4Cx6M9iTUQ9vu2qsWuG2wU9nuhvcAVzv0yzSxAlZ9wDL3xUV6B8AqfAdrbQ+shi6T2C+inXvtTRehm96mhPr+xJvNnKdYrDVietpB4H/rJrMJIqPyuevO7rzpl1rQKuXRLKEzEqGbuZxCJS+n6nBQQ3zErdnWl1RG/tUsjbm8FwKmgS34YIiuqR6jPwWITi3Tm3Bt7R7XW5+XhwNsSwG7IWDjXNIdBWwObPsAHsTbJ/ognjvP5V5IAE09kVBPJBp7ImHa6olEo6GsjexJZYMTfxBvaZWcpCrnW0wON2n+Sm8ipVPrpaUWH2L9xUstrwcsTV1qlLIe2eZRPx+wQFPpXEGCIba3ywH6X5KdETiiV64RDyCtqyXDA/DY07rS9/YZBVMz8TGndbWgel2wGTkqTk1TCcnySZVNFf4CWHqFp3pCa8N+GXhrAKoKVLMjoFpQPdUDlnLjOx43Pku58ZXTeIEG0VGrvCXTyaSO0XX3K3VbsaHAig13QIe6XTji2wVLpVfZaaJMAAE48esFib6ghxilxFK+oBJ9QQHMPVGgjicn6gxqmXuArN1lsbRMBaw6gWWdLrDkeWPWf2IdjDempbwxm/LGjKTOnDsmUu6YBNn27pENj+39hGUrYDcFbN3QFLAFwLa1fYtEvy4y5ylGo7eS/NLLyVC5x5QttDlbqK0pW2ijucdgzmfL1k48GL0NGne17uyPq3WnOVfrWiI12ipSY0kbko2OOnyMDXfia91RvtbVMQyVr/U2OM47W2NwzM7Wtq5yLmyJH+XI2VSCeYhyYW+Q8uQEtlHqWUSh0WGvLL01wNRQMN0RTC2gXkbQrOPK4fpYHK5tpPTecnovWa+j9ri2cbnblpwFeWfe1qnzXHlcq1uGem4ZsLplaPaWwVxxuT7xiC62WckuiWiT
/sR1pkP+bxHEyBA6mRphsHCJLFTOMkl6/uUXyabJzXxnT+yQprJDls82gbSjtkJaO4JtW8F2W9haCralUz3hY0Yt1MBGXWivYnLrlI34s3MvcEfJDqS7yP3mzsP3of/en4zdeezXRev2v3izrEsW/bb31Q1eV7++8l68MA1qMvV3znzem47fpaVFucgkyyBJ7I4GTBNMDei7ifm+OaKCGsRuZupouc7oObF8bkY52NOEs92epnV7O7F7Qg2WM4wkqUXbm+wjpDlvOiF7cxh5hP/qTxYvhWcr3WaUeSxr0QH3e1fD7idyut4M1Ct1ZTPZH5sJgc1x2Uy0PbeZ5Hm3bZy2xQRqSJ4Q18TDoGMV4pAS4hoV4qLQQEqKy3MDXFGK6ygpTklxpyvFYSXFNXrzpekg526vnbgYV3jxFfvVdKlT0TyO/KHz9OX37sx1wsTQSaq4AfcgjI3MsrEiLeccpfYm9F7qx4kkWzJczvFZK/rQejd991MrfHanrZkz3yLZlLafjrHWRadrNRmpBGqFV0bMPQ7Q17BkFgfP3rzmDS0lugdMtkZE9oHsaLp8yY5OCF+7hXM+CxbckyhxO9jCdg08G9ayxW3FsyvzbMvOvWYA+FSZNtAqMO1adjTQFNMuwbRtLWssMS3tVLk2AI36qtDBc2eVxN9eOa1si3KVX2gLS6iV9+HX9yVzQg1+Kz+i9SVTEXrTJ0azGZPhjELvqzss2oG00Vng/+GOwuHUYXZJnZT/9d/+gx/+rXXxuXXuPT66gTsNPWfSunYC2glf+fSvw9dZvBvc7zM3COOrjRHZd8OJM31a8PBmpPnr/71C8XDJohP6AiL+udFKIRthy7ZszTKsdJWXyKJSVOXFefJGwzm9JeBzq9s2e+sCKTfw5h5Z5OHEewic4HX4FN/yZFBCn43FNSMoFdWjG4sIfMFw7pKZHcc3Oto/mOMKJWjme9NwGCz4zooChWqp7fQYUOSOz8hvNMBYWejzL0DkQVhQebW6xn4AC38g/sUPhvsFYcBfvSBcOBMyf/5szhnr1F9OXqp0SAce7X0GWzpntAmXTMeTOx29ChqhdXLlw8CdLC+fxFWc8ThThXxwv5KNOKd7Id5KYbyT7aR09DoiC0j2oOePo/0SF08p0IfzGdls42HE6zKsX19W4axqWUhfs4Uu2QBkzZ/9b0OPsKIR53GpJsh8PgXO7HnoBx6hxUkYLKkx8GcDv+OHEctm1wcxeAhivMBZDZY18mevQcwIKNran25avXbr4va+9zkBkDsfBd4s92vKDaMQgck39GKDcPd0teR4IgOeMnYHTH4pknJDW8oByfGRcVKzGOtOsYB5GBA2sZ5CxA9p/pPep/tP/fOYptT9qah3KLv3D527uHe61EPyp39332ufD/u9weDy5gP9ZpWWdXVlUEbh94voDzsSSCnVns+9r96YHs558lYqiGga+4uHibs9TWQfgYirMHM5PfHTKvwKDbnyFRJ0eo0Wbt8/qaSzhSKUnHt0647cYZ+h+oZIT8P4nnhltTb9QMb0oOgc0JiKR9eP7obu1W2/t2ErFVetfyfZPHolE8UFiMsI6jlqDKYHbE+LweR/NkNGqvGVV7crk7S2tozlY8c432A6W5Lzy/7dVfv3Deu3rnIDvIDs7T49mSI1eBiHP19Bo7ia5DXVeCcfydk1vCIfGNgEk1ZYUzJFmMq8L+7wgio5W9C1of4KdVQZ7t18uh4OLq97F/ft615/e0pp+Mve/eXt+fBjYs7v+i8vLn06L4bjslTG1qK12sOLz8N/33YIq87T0FlLQ0ceDZ0cDZQswR6OvpW7QWjnwp46cnv6sap0IsBNJGxzfV4lI10mg8clV92EZX0eXK52GH8vvbPOvbgz+r3UziKXvWjObvxvbbFUki6vr/POhs47NXR+fnlBdQpnOhZ3ni6vpfOpQ+OWF3cel8vt/OzdjRDDN3KkTsabScM3QHBisK9l9MNGY0Ris2DrJgWyJ+9a
OHnXkifvWjx51zVMXqdo8mRjzoj4JRR2xwqkd9e5L+guKpDanZUcP4IuM4VSu6U3UW3hXunKEnvSXXXEXXXkd3XzWcw+PstEAIWUuJ9rqf0gGrrdbw9Wu1qWSN0WvNlOYYeywW1GzfYXL22hZJaUST9Ir/yQtEyHVGBVSZXXMMWdwjXt1LOmncI17dS2pp01a1pDpzxqobDTpGyl08xN0bYKx4fYcz5pGq7pFsrqtv3nwsl2q6/pVpfSLX0j4k3dabZfY02/hqzh3rnBItstWtMtktItdS92At/PjRev6RjL6vhyOvae/GzH5pqOTVkdD/wXJ8x1bK3p2JK1s7p+wPPZJG3ba/q1ZfV7O/G+urH8xXmDJpS/loVy9vTA5QNetg3WdSyNZd04X19zHcN1HcthWmTpuoH3Mud4onQMRANOCqSqKTedor460vu6HkCx0sAK5PbVKeqrI7cv8mX/7qb9USg78BLZwgpt9qqww6taOuwUjrBTzwg7hSPsyB5h9FA1jN03BLbmVKlcMRtFl/DZoKsrsraokuwJp363beGE8xKpiKFtdgp768jrjXXnBK4T2bpN9jqLZ2hMm5lA4vIg9lRKRSD6OevrZbKeuVcefUGiseV45j5U1P3LNH5eiQjbJlS1/gIKxkS/Ok9/xV1sViiHVSm3NPw20mEJ0nUR6frWpAOQm3UM8sTjaDgZ4hHGRbTrJWg3RLQb2087gDnika3libdXZh6ZhcQbJYhHIuLR9hOfox1CDHK0Q3OFdl3TimhHJWjHItrx9rQbBl7ZNjniAUQgTz2M3rELqcclqDdF1JslZh5rOeotsDL3xsrcGxosot7cmvofWX8t/nR1C4fOrVwYf/w/Lr+eyQ==
:fxdreema>*/