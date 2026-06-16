//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2022, fxDreema  (//
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
#define PROJECT_ID "mt5-9077"
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
input string Symbol = "";
input string Token = "qxvnrf2UvRa0K9USKycA77voz0onKGrssfaQl65FPRx";
input string Greeting = "Trading Signal V1";
input string ServerEND = "Server is not working !!!!";
input double Risk_Percent = 0.5;
input ENUM_TIMEFRAMES Master_TF = PERIOD_H4;
input ENUM_TIMEFRAMES Second_TF = PERIOD_M15;
input ENUM_TIMEFRAMES Mini_TF = PERIOD_M15;
input double Zigzag_Period = 6.0;
input int MagicStart = 7200; // Magic Number, kind of...
class c
{
		public:
	static string Symbol;
	static string Token;
	static string Greeting;
	static string ServerEND;
	static double Risk_Percent;
	static ENUM_TIMEFRAMES Master_TF;
	static ENUM_TIMEFRAMES Second_TF;
	static ENUM_TIMEFRAMES Mini_TF;
	static double Zigzag_Period;
	static int MagicStart;
};
string c::Symbol;
string c::Token;
string c::Greeting;
string c::ServerEND;
double c::Risk_Percent;
ENUM_TIMEFRAMES c::Master_TF;
ENUM_TIMEFRAMES c::Second_TF;
ENUM_TIMEFRAMES c::Mini_TF;
double c::Zigzag_Period;
int c::MagicStart;


//--
// Variables (Global Variables)
























































class v
{
		public:
	static double Moneypertick;
	static double ATR_Daily;
	static double Price_Close_Day;
	static double ATR_50_Percent;
	static double ATR_70_Percent;
	static double ATR_80_Percent;
	static double ATR_90_Percent;
	static double ATR_100_Percent;
	static double Price_ATRb_50;
	static double Price_ATRb_70;
	static double Price_ATRb_80;
	static double Price_ATRb_90;
	static double Price_ATRb_100;
	static double Price_ATRs_50;
	static double Price_ATRs_70;
	static double Price_ATRs_80;
	static double Price_ATRs_90;
	static double Price_ATRs_100;
	static int MACDV_Master_TF;
	static int DIB_Master_TF;
	static int DIS_Master_TF;
	static int SUMDI_Master_TF;
	static int SUMDI2_Master_TF;
	static int DXMaster_TF;
	static double MA26_Master_TF;
	static double MA12_Master_TF;
	static double ATR26_Master_TF;
	static double MA12_MA26_Master_TF;
	static ENUM_TIMEFRAMES TIMEFRAMES;
	static string Symbols;
	static string Messages;
	static datetime now;
	static double Profit;
	static int MACDV_Second_TF;
	static int DIB_Second_TF;
	static int DIS_Second_TF;
	static int SUMDI_Second_TF;
	static int SUMDI2_Second_TF;
	static int DXSecond_TF;
	static double MA26_Second_TF;
	static double MA12_Second_TF;
	static double ATR26_Second_TF;
	static double MA12_MA26_Second_TF;
	static int MACDV_Mini_TF;
	static int DIB_Mini_TF;
	static int DIS_Mini_TF;
	static int SUMDI_Mini_TF;
	static int SUMDI2_Mini_TF;
	static int DXMini_TF;
	static double MA26_Mini_TF;
	static double MA12_Mini_TF;
	static double ATR26_Mini_TF;
	static double MA12_MA26_Mini_TF;
	static int Counts_ALL;
	static int Counts_Buy;
	static int Counts_Sell;
};
double v::Moneypertick;
double v::ATR_Daily;
double v::Price_Close_Day;
double v::ATR_50_Percent;
double v::ATR_70_Percent;
double v::ATR_80_Percent;
double v::ATR_90_Percent;
double v::ATR_100_Percent;
double v::Price_ATRb_50;
double v::Price_ATRb_70;
double v::Price_ATRb_80;
double v::Price_ATRb_90;
double v::Price_ATRb_100;
double v::Price_ATRs_50;
double v::Price_ATRs_70;
double v::Price_ATRs_80;
double v::Price_ATRs_90;
double v::Price_ATRs_100;
int v::MACDV_Master_TF;
int v::DIB_Master_TF;
int v::DIS_Master_TF;
int v::SUMDI_Master_TF;
int v::SUMDI2_Master_TF;
int v::DXMaster_TF;
double v::MA26_Master_TF;
double v::MA12_Master_TF;
double v::ATR26_Master_TF;
double v::MA12_MA26_Master_TF;
ENUM_TIMEFRAMES v::TIMEFRAMES;
string v::Symbols;
string v::Messages;
datetime v::now;
double v::Profit;
int v::MACDV_Second_TF;
int v::DIB_Second_TF;
int v::DIS_Second_TF;
int v::SUMDI_Second_TF;
int v::SUMDI2_Second_TF;
int v::DXSecond_TF;
double v::MA26_Second_TF;
double v::MA12_Second_TF;
double v::ATR26_Second_TF;
double v::MA12_MA26_Second_TF;
int v::MACDV_Mini_TF;
int v::DIB_Mini_TF;
int v::DIS_Mini_TF;
int v::SUMDI_Mini_TF;
int v::SUMDI2_Mini_TF;
int v::DXMini_TF;
double v::MA26_Mini_TF;
double v::MA12_Mini_TF;
double v::ATR26_Mini_TF;
double v::MA12_MA26_Mini_TF;
int v::Counts_ALL;
int v::Counts_Buy;
int v::Counts_Sell;




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
int FXD_BLOCKS_COUNT        = 142;
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
	c::Symbol = Symbol;
	c::Token = Token;
	c::Greeting = Greeting;
	c::ServerEND = ServerEND;
	c::Risk_Percent = Risk_Percent;
	c::Master_TF = Master_TF;
	c::Second_TF = Second_TF;
	c::Mini_TF = Mini_TF;
	c::Zigzag_Period = Zigzag_Period;
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

	v::Moneypertick = 0.0;
	v::ATR_Daily = 0.0;
	v::Price_Close_Day = 0.0;
	v::ATR_50_Percent = 0.0;
	v::ATR_70_Percent = 0.0;
	v::ATR_80_Percent = 0.0;
	v::ATR_90_Percent = 0.0;
	v::ATR_100_Percent = 0.0;
	v::Price_ATRb_50 = 0.0;
	v::Price_ATRb_70 = 0.0;
	v::Price_ATRb_80 = 0.0;
	v::Price_ATRb_90 = 0.0;
	v::Price_ATRb_100 = 0.0;
	v::Price_ATRs_50 = 0.0;
	v::Price_ATRs_70 = 0.0;
	v::Price_ATRs_80 = 0.0;
	v::Price_ATRs_90 = 0.0;
	v::Price_ATRs_100 = 0.0;
	v::MACDV_Master_TF = 0;
	v::DIB_Master_TF = 0;
	v::DIS_Master_TF = 0;
	v::SUMDI_Master_TF = 0;
	v::SUMDI2_Master_TF = 0;
	v::DXMaster_TF = 0;
	v::MA26_Master_TF = 0.0;
	v::MA12_Master_TF = 0.0;
	v::ATR26_Master_TF = 0.0;
	v::MA12_MA26_Master_TF = 0.0;
	v::TIMEFRAMES = 0;
	v::Symbols = "0";
	v::Messages = "0";
	v::now = 0;
	v::Profit = 0.0;
	v::MACDV_Second_TF = 0;
	v::DIB_Second_TF = 0;
	v::DIS_Second_TF = 0;
	v::SUMDI_Second_TF = 0;
	v::SUMDI2_Second_TF = 0;
	v::DXSecond_TF = 0;
	v::MA26_Second_TF = 0.0;
	v::MA12_Second_TF = 0.0;
	v::ATR26_Second_TF = 0.0;
	v::MA12_MA26_Second_TF = 0.0;
	v::MACDV_Mini_TF = 0;
	v::DIB_Mini_TF = 0;
	v::DIS_Mini_TF = 0;
	v::SUMDI_Mini_TF = 0;
	v::SUMDI2_Mini_TF = 0;
	v::DXMini_TF = 0;
	v::MA26_Mini_TF = 0.0;
	v::MA12_Mini_TF = 0.0;
	v::ATR26_Mini_TF = 0.0;
	v::MA12_MA26_Mini_TF = 0.0;
	v::Counts_ALL = 0;
	v::Counts_Buy = 0;
	v::Counts_Sell = 0;




	Comment("");
	for (int i=ObjectsTotal(ChartID()); i>=0; i--)
	{
		string name = ObjectName(ChartID(), i);
		if (StringSubstr(name,0,8) == "fxd_cmnt") {ObjectDelete(ChartID(), name);}
	}
	ChartRedraw();



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
	ArrayResize(_blocks_, 142);

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
	int disabled_blocks_list[] = {58,59};
	for (int l = 0; l < ArraySize(disabled_blocks_list); l++) {
		_blocks_[disabled_blocks_list[l]].__disabled = true;
	}

	//-- run blocks
	int blocks_to_run[] = {69};
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

	OCODriver(); // Check and close OCO orders

	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {16,26,57,63,72,76,102};
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
	// This is needed so that the OnTradeEventDetector class is added into the code
	if (false) OnTradeEventDetector * dummy = new OnTradeEventDetector();

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
	if (reson == REASON_CHARTCHANGE || reson == REASON_PARAMETERS || reason == REASON_TEMPLATE || reason == REASON_ACCOUNT) {return;}

	//-- if Timer was set, kill it here
	EventKillTimer();

	if (ENABLE_STATUS) DrawStatus("stopped");
	if (ENABLE_SPREAD_METER) DrawSpreadInfo();

	//-- run blocks
	int blocks_to_run[] = {1};
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
		
		v::Moneypertick = formula(compare, lo, ro);
		
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
		
		v::ATR_Daily = formula(compare, lo, ro);
		
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
		
		v::ATR_50_Percent = formula(compare, lo, ro)/100;
		
		_callback_(1);
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
		
		v::ATR_70_Percent = formula(compare, lo, ro)/100;
		
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
		
		v::ATR_80_Percent = formula(compare, lo, ro)/100;
		
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
		
		v::ATR_90_Percent = formula(compare, lo, ro)/100;
		
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
		
		v::ATR_100_Percent = formula(compare, lo, ro)/100;
		
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
		
		v::Price_ATRb_50 = formula(compare, lo, ro);
		
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
		
		v::Price_ATRb_70 = formula(compare, lo, ro);
		
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
		
		v::Price_ATRb_80 = formula(compare, lo, ro);
		
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
		
		v::Price_ATRb_90 = formula(compare, lo, ro);
		
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
		
		v::Price_ATRb_100 = formula(compare, lo, ro);
		
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
		
		v::Price_ATRs_50 = formula(compare, lo, ro)*-1;
		
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
		
		v::Price_ATRs_70 = formula(compare, lo, ro)*-1;
		
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
		
		v::Price_ATRs_80 = formula(compare, lo, ro)*-1;
		
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
		
		v::Price_ATRs_90 = formula(compare, lo, ro)*-1;
		
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
		
		v::Price_ATRs_100 = formula(compare, lo, ro)*-1;
		
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
		
		v::MA12_MA26_Master_TF = formula(compare, lo, ro);
		
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
		
		v::MACDV_Master_TF = formula(compare, lo, ro)*100;
		
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
		
		v::SUMDI_Master_TF = formula(compare, lo, ro);
		
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
		
		v::SUMDI2_Master_TF = formula(compare, lo, ro);
		
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
		
		v::DXMaster_TF = formula(compare, lo, ro)*100;
		
		_callback_(1);
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
		
		v::Profit = formula(compare, lo, ro);
		
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
		
		v::MA12_MA26_Second_TF = formula(compare, lo, ro);
		
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
		
		v::MACDV_Second_TF = formula(compare, lo, ro)*100;
		
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
		
		v::SUMDI_Second_TF = formula(compare, lo, ro);
		
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
		
		v::SUMDI2_Second_TF = formula(compare, lo, ro);
		
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
		
		v::DXSecond_TF = formula(compare, lo, ro)*100;
		
		_callback_(1);
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
		
		v::MA12_MA26_Mini_TF = formula(compare, lo, ro);
		
		_callback_(1);
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
		
		v::MACDV_Mini_TF = formula(compare, lo, ro)*100;
		
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
		
		v::SUMDI_Mini_TF = formula(compare, lo, ro);
		
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
		
		v::SUMDI2_Mini_TF = formula(compare, lo, ro);
		
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
		
		v::DXMini_TF = formula(compare, lo, ro)*100;
		
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
class MDL_Formula_34: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_34()
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
		
		v::Profit = formula(compare, lo, ro)/100;
		
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


//------------------------------------------------------------------------------------------------------------------------

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

// "Money per tick" model
class MDLIC_market_tickvalue
{
	public: /* Input Parameters */
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_market_tickvalue()
	{
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	double _execute_()
	{
		return NormalizeDouble(SymbolInfoDouble(Symbol, SYMBOL_TRADE_TICK_VALUE), 8);
	}
};

// "Point size" model
class MDLIC_market_point
{
	public: /* Input Parameters */
	int ModePoint;
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_market_point()
	{
		ModePoint = (int)0;
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	double _execute_()
	{
		switch (ModePoint)
		{
		   case 0: return SymbolInfoDouble(Symbol, SYMBOL_POINT);
		   case 1: return CustomPoint(Symbol);
		}
		
		return 0;
	}
};

// "Moving Average" model
class MDLIC_indicators_iMA
{
	public: /* Input Parameters */
	int MAperiod;
	int MAshift;
	ENUM_MA_METHOD MAmethod;
	ENUM_APPLIED_PRICE AppliedPrice;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iMA()
	{
		MAperiod = (int)14;
		MAshift = (int)0;
		MAmethod = (ENUM_MA_METHOD)MODE_SMA;
		AppliedPrice = (ENUM_APPLIED_PRICE)PRICE_CLOSE;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iMA(Symbol, Period, MAperiod, MAshift, MAmethod, AppliedPrice, Shift + FXD_MORE_SHIFT);
	}
};

// "Average Directional Index by Welles Wilder" model
class MDLIC_indicators_iADXWilder
{
	public: /* Input Parameters */
	int ADXperiod;
	int ADXmode;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iADXWilder()
	{
		ADXperiod = (int)14;
		ADXmode = (int)0;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		double value = fxdCustomIndicator(iADXWilder(Symbol,Period,ADXperiod),ADXmode,Shift+FXD_MORE_SHIFT);
		
		return NormalizeDouble(value, 2);
	}
};

// "Name: Symbol (Market)" model
class MDLIC_market_Symbol
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_market_Symbol()
	{
	}

	public: /* The main method */
	string _execute_()
	{
		return CurrentSymbol();
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

// "Name: Broker" model
class MDLIC_account_AccountCompany
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountCompany()
	{
	}

	public: /* The main method */
	string _execute_()
	{
		return AccountInfoString(ACCOUNT_COMPANY);
	}
};

// "Leverage" model
class MDLIC_account_AccountLeverage
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountLeverage()
	{
	}

	public: /* The main method */
	long _execute_()
	{
		return (long)AccountInfoInteger(ACCOUNT_LEVERAGE);
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
				if (!LoadPendingOrder(ticket)) {continue;}
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
				if (!LoadPendingOrder(ticket)) {continue;}
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
				if (!LoadPendingOrder(ticket)) {continue;}
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


//------------------------------------------------------------------------------------------------------------------------

// Block 3 (Custom MQL code)
class Block0: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "3";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Content-Type: application/x-www-form-urlencoded\r\n"+"Authorization: Bearer "+c::Token+"\r\n";


ArrayResize(data,StringToCharArray("message="+c::ServerEND,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 4 (Pass)
class Block1: public MDL_Pass
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "4";


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

// Block 6 (&lt;-50)
class Block2: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "6";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {45,46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -50;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(2);
			_blocks_[46].run(2);
		}
	}
};

// Block 9 (Pass)
class Block3: public MDL_Pass
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "9";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {2};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[2].run(3);
		}
	}
};

// Block 32 (&lt;50)
class Block4: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "32";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRs_50;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(4);
		}
	}
};

// Block 33 (&lt;70)
class Block5: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "33";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRs_70;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(5);
		}
	}
};

// Block 70 (Pass)
class Block6: public MDL_Pass
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "70";


		// Fill the list of outbound blocks
		int ___outbound_blocks[5] = {27,28,29,4,5};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[4].run(6);
			_blocks_[5].run(6);
			_blocks_[27].run(6);
			_blocks_[28].run(6);
			_blocks_[29].run(6);
		}
	}
};

// Block 10624 (Moneypertick)
class Block7: public MDL_Formula_1<MDLIC_indicators_iATR,double,string,MDLIC_market_tickvalue,double>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "10624";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = PERIOD_D1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(7);
		}
	}
};

// Block 10626 (ATR)
class Block8: public MDL_Formula_2<MDLIC_indicators_iATR,double,string,MDLIC_market_point,double>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "10626";


		// Fill the list of outbound blocks
		int ___outbound_blocks[5] = {11,12,13,14,9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = PERIOD_D1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(8);
			_blocks_[11].run(8);
			_blocks_[12].run(8);
			_blocks_[13].run(8);
			_blocks_[14].run(8);
		}
	}
};

// Block 10628 (ATR 50%)
class Block9: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10628";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {15,21};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 50.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Moneypertick;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(9);
			_blocks_[21].run(9);
		}
	}
};

// Block 10630 (Price_Close_Day)
class Block10: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "10630";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.CandleID = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = PERIOD_D1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(10);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Price_Close_Day = _Value1_();
	}
};

// Block 10631 (ATR 70%)
class Block11: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "10631";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {17,22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 70.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Moneypertick;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(11);
			_blocks_[22].run(11);
		}
	}
};

// Block 10632 (ATR 80%)
class Block12: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "10632";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {18,23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 80.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Moneypertick;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[18].run(12);
			_blocks_[23].run(12);
		}
	}
};

// Block 10635 (ATR 90%)
class Block13: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "10635";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {19,24};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 90.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Moneypertick;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(13);
			_blocks_[24].run(13);
		}
	}
};

// Block 10636 (ATR 100%)
class Block14: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "10636";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {20,25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 100.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Moneypertick;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(14);
			_blocks_[25].run(14);
		}
	}
};

// Block 10637 (Price_ATRb_50)
class Block15: public MDL_Formula_8<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "10637";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {124};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_50_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(15);
		}
	}
};

// Block 10638 (Once a day)
class Block16: public MDL_OnceAday<string,string,string,string,string>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "10638";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(16);
		}
	}
};

// Block 10639 (Price_ATRb_70)
class Block17: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "10639";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_70_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(17);
		}
	}
};

// Block 10640 (Price_ATRb_80)
class Block18: public MDL_Formula_10<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "10640";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {126};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_80_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[126].run(18);
		}
	}
};

// Block 10641 (Price_ATRb_90)
class Block19: public MDL_Formula_11<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "10641";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_90_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(19);
		}
	}
};

// Block 10642 (Price_ATRb_100)
class Block20: public MDL_Formula_12<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "10642";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_100_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[128].run(20);
		}
	}
};

// Block 10643 (Price_ATRs_50)
class Block21: public MDL_Formula_13<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "10643";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_50_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(21);
		}
	}
};

// Block 10645 (Price_ATRs_70)
class Block22: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "10645";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_70_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(22);
		}
	}
};

// Block 10646 (Price_ATRs_80)
class Block23: public MDL_Formula_15<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "10646";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_80_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(23);
		}
	}
};

// Block 10647 (Price_ATRs_90)
class Block24: public MDL_Formula_16<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "10647";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {132};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_90_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[132].run(24);
		}
	}
};

// Block 10648 (Price_ATRs_100)
class Block25: public MDL_Formula_17<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "10648";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {133};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_100_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_Close_Day;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[133].run(25);
		}
	}
};

// Block 13496 (Pass)
class Block26: public MDL_Pass
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "13496";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {65,67,93};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[65].run(26);
			_blocks_[67].run(26);
			_blocks_[93].run(26);
		}
	}
};

// Block 13497 (&lt;80)
class Block27: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "13497";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRs_80;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(27);
		}
	}
};

// Block 13499 (&lt;90)
class Block28: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "13499";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRs_90;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(28);
		}
	}
};

// Block 13500 (&lt;100)
class Block29: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "13500";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRs_100;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(29);
		}
	}
};

// Block 13501 (&gt;50)
class Block30: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "13501";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRb_50;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(30);
		}
	}
};

// Block 13502 (&gt;70)
class Block31: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "13502";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRb_70;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(31);
		}
	}
};

// Block 13539 (Pass)
class Block32: public MDL_Pass
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "13539";


		// Fill the list of outbound blocks
		int ___outbound_blocks[5] = {30,31,33,34,35};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[30].run(32);
			_blocks_[31].run(32);
			_blocks_[33].run(32);
			_blocks_[34].run(32);
			_blocks_[35].run(32);
		}
	}
};

// Block 26966 (&gt;80)
class Block33: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "26966";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRb_80;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(33);
		}
	}
};

// Block 26968 (&gt;90)
class Block34: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "26968";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRb_90;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(34);
		}
	}
};

// Block 26969 (&gt;100)
class Block35: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "26969";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Price_ATRb_100;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(35);
		}
	}
};

// Block 26970 (Pass)
class Block36: public MDL_Pass
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "26970";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {47};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[47].run(36);
		}
	}
};

// Block 26971 (EMA)
class Block37: public MDL_Formula_18<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "26971";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MA12_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::MA26_Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(37);
		}
	}
};

// Block 26972 (MACD)
class Block38: public MDL_Formula_19<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "26972";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MA12_MA26_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ATR26_Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 26987 (MACD)
class Block39: public MDL_ModifyVariables<int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "26987";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.MAperiod = 12;
		Value2.MAperiod = 26;
		Value3.ATRperiod = 26;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.MAmethod = MODE_EMA;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = c::Master_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.MAmethod = MODE_EMA;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = c::Master_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Master_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(39);
		}
	}

	virtual void _beforeExecute_()
	{

		v::MA12_Master_TF = _Value1_();
		v::MA26_Master_TF = _Value2_();
		v::ATR26_Master_TF = _Value3_();
	}
};

// Block 27024 (DI+ DI-)
class Block40: public MDL_ModifyVariables<int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "27024";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {41,42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.ADXmode = 1;
		Value2.ADXmode = 2;
		Value3.ATRperiod = 26;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = c::Master_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Symbol = CurrentSymbol();
		Value2.Period = c::Master_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Master_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[41].run(40);
			_blocks_[42].run(40);
		}
	}

	virtual void _beforeExecute_()
	{

		v::DIB_Master_TF = _Value1_();
		v::DIS_Master_TF = _Value2_();
		v::ATR26_Master_TF = _Value3_();
	}
};

// Block 27025 (DI+ - DI-)
class Block41: public MDL_Formula_20<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "27025";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::DIS_Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(41);
		}
	}
};

// Block 27026 (DI+ + DI-)
class Block42: public MDL_Formula_21<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "27026";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::DIS_Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(42);
		}
	}
};

// Block 27027 (DX)
class Block43: public MDL_Formula_22<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "27027";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SUMDI_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SUMDI2_Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 27033 (DXMaster_TF&nbsp;&lt;&nbsp;)
class Block44: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "27033";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -40;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DXMaster_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(44);
		}
	}
};

// Block 29818 (&nbsp;x&gt;150)
class Block45: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "29818";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -150;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(45);
		}
	}
};

// Block 29819 (&nbsp;x&gt;-150)
class Block46: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "29819";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -150;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(46);
		}
	}
};

// Block 29821 (&nbsp;x&gt;50)
class Block47: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "29821";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {48,49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 50.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[48].run(47);
			_blocks_[49].run(47);
		}
	}
};

// Block 29842 (&nbsp;x&gt;150)
class Block48: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "29842";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 150.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(48);
		}
	}
};

// Block 29843 (&nbsp;x&lt;150)
class Block49: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "29843";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 150.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(49);
		}
	}
};

// Block 32901 (Custom MQL code)
class Block50: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "32901";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Content-Type: application/x-www-form-urlencoded\r\n"+"Authorization: Bearer "+c::Token+"\r\n";


ArrayResize(data,StringToCharArray("message="+v::Messages,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 32902 (Modify Variables)
class Block51: public MDL_ModifyVariables<int,MDLIC_market_Symbol,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_time,datetime,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "32902";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.Value = v::MACDV_Master_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::DXMaster_TF;

		return Value3._execute_();
	}
	virtual datetime _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(51);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Symbols = _Value1_();
		v::MACDV_Master_TF = _Value2_();
		v::DXMaster_TF = _Value3_();
		v::now = _Value4_();
	}
};

// Block 32903 (Custom MQL code)
class Block52: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "32903";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(52);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Messages = "\n" + "Symbols = " + v::Symbols + "\n" + "MACDV_Master_TF = " + v::MACDV_Master_TF + "\n" + "DXMaster_TF = " + v::DXMaster_TF+ "\n" + "Now = " + v::now ;
	}
};

// Block 32905 (Custom MQL code)
class Block53: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "32905";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Content-Type: application/x-www-form-urlencoded\r\n"+"Authorization: Bearer "+c::Token+"\r\n";


ArrayResize(data,StringToCharArray("message="+v::Messages,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 32906 (Modify Variables)
class Block54: public MDL_ModifyVariables<int,MDLIC_market_Symbol,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_time,datetime,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "32906";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {55};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.Value = v::MACDV_Master_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::DXMaster_TF;

		return Value3._execute_();
	}
	virtual datetime _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[55].run(54);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Symbols = _Value1_();
		v::MACDV_Master_TF = _Value2_();
		v::DXMaster_TF = _Value3_();
		v::now = _Value4_();
	}
};

// Block 32907 (Custom MQL code)
class Block55: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "32907";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(55);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Messages = "\n" + "Symbols = " + v::Symbols + "\n" + "MACDV_Master_TF = " + v::MACDV_Master_TF + "\n" + "DXMaster_TF = " + v::DXMaster_TF+ "\n" + "Now = " + v::now ;
	}
};

// Block 32908 (Once per bar)
class Block56: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "32908";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {51,58};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(56);
			_blocks_[58].run(56);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 32909 (Symbol)
class Block57: public MDL_SetCurrentSymbol2<string>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "32909";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {135,136};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(57);
			_blocks_[136].run(57);
		}
	}

	virtual void _beforeExecute_()
	{

		ListOfSymbols = (string)c::Symbol;
	}
};

// Block 32911 (Buy now)
class Block58: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "32911";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		VolumeMode = "freemarginRisk";
		StopLossMode = "dynamicDigits";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(58);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeRisk = (double)c::Risk_Percent;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 32912 (Sell now)
class Block59: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "32912";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		VolumeMode = "freemarginRisk";
		StopLossMode = "dynamicDigits";
		TakeProfitMode = "none";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {return dlStopLoss._execute_();}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(59);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeRisk = (double)c::Risk_Percent;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 32913 (2)
class Block60: public MDL_Formula_23<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "32913";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Risk_Percent;

		double value = (double)Ro._execute_();
		value = value*1.5; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(60);
		}
	}
};

// Block 32914 (3)
class Block61: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "32914";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {62};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[62].run(61);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Profit;
	}
};

// Block 32915 (4)
class Block62: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "32915";
		_beforeExecuteEnabled = true;
		// Block input parameters
		GroupMode = "all";
		Group = "1,2,3,4";
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

// Block 32916 (1)
class Block63: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "32916";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {118,120,122,60};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(63);
			_blocks_[118].run(63);
			_blocks_[120].run(63);
			_blocks_[122].run(63);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 32938 (ATR&nbsp;)
class Block64: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_candles_candles,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "32938";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.CandleID = 1;
		// Block input parameters
		Title = "ATR DAY";
		ObjY = 150;
		ObjTitleFontSize = 9;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "Price Close Day";
		Label2 = "ATR_Daily";
		Label3 = "Moneypertick";
		Label4 = "ATR 50%";
		Label5 = "ATR 65%";
		Label6 = "ATR 80%";
		Label7 = "ATR 90%";
		Label8 = "ATR 100%";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::ATR_Daily;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::Moneypertick;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::ATR_50_Percent;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::ATR_70_Percent;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::ATR_80_Percent;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::ATR_90_Percent;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::ATR_100_Percent;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 150;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 52265 (ZONE SELL)
class Block65: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "52265";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {66};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "ZONE SELL";
		ObjY = 300;
		ObjTitleFontSize = 9;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "50%";
		Label2 = "70%";
		Label3 = "80%";
		Label4 = "90%";
		Label5 = "100%";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::Price_ATRb_50;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::Price_ATRb_70;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::Price_ATRb_80;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::Price_ATRb_90;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::Price_ATRb_100;

		return Value5._execute_();
	}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[66].run(65);
		}
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 300;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 52266 (ZONE BUY)
class Block66: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "52266";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "ZONE BUY";
		ObjY = 400;
		ObjTitleFontSize = 9;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "50%";
		Label2 = "70%";
		Label3 = "80%";
		Label4 = "90%";
		Label5 = "100%";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::Price_ATRs_50;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::Price_ATRs_70;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::Price_ATRs_80;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::Price_ATRs_90;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::Price_ATRs_100;

		return Value5._execute_();
	}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 400;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 55230 (Acc)
class Block67: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_account_AccountCompany,string,int,int,string,MDLIC_account_AccountLeverage,long,int,int,string,MDLIC_account_AccountBalance,double,int,int,string,MDLIC_account_AccountProfit,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "55230";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Title = "ACCOUNT.";
		ObjY = 23;
		ObjTitleFontSize = 9;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "Broker";
		Label2 = "Leverage";
		Label3 = "Balance";
		Label4 = "Profit";
		Label5 = "Counts_ALL";
		Label6 = "Counts_Buy";
		Label7 = "Counts_Sell";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual long _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {
		Value5.Value = v::Counts_ALL;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::Counts_Buy;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::Counts_Sell;

		return Value7._execute_();
	}
	virtual double _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(67);
		}
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 23;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 55231 (Custom MQL code)
class Block68: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "55231";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string headers;
char data[], result[];

headers="Content-Type: application/x-www-form-urlencoded\r\n"+"Authorization: Bearer "+c::Token+"\r\n";


ArrayResize(data,StringToCharArray("message="+c::Greeting,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
	}
};

// Block 55232 (Pass)
class Block69: public MDL_Pass
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "55232";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {68,70,71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(69);
			_blocks_[70].run(69);
			_blocks_[71].run(69);
		}
	}
};

// Block 88147 (Modify chart colors)
class Block70: public MDL_ChartSetColors<color,color,color,color,color,color,color,color,color,color,color,color,color>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "88147";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ChartColorBackground = (color)clrWhite;
		ChartColorForeground = (color)clrBlack;
		ChartColorGrid = (color)clrLightSlateGray;
		ChartColorBarUp = (color)clrDodgerBlue;
		ChartColorBarDown = (color)clrOrangeRed;
		ChartColorBullCandle = (color)clrDodgerBlue;
		ChartColorBearCandle = (color)clrOrangeRed;
		ChartColorDojiCandle = (color)clrLime;
		ChartColorVolumes = (color)clrLimeGreen;
		ChartColorBid = (color)clrLightSlateGray;
		ChartColorAsk = (color)clrRed;
		ChartColorLast = (color)clrLimeGreen;
		ChartColorStopLevels = (color)clrRed;
	}
};

// Block 88148 (Modify chart properties)
class Block71: public MDL_ChartSetProperties<int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "88148";
		_beforeExecuteEnabled = true;
		// Block input parameters
		ChartShift = 1;
		ChartShowOHLC = 1;
		ChartShowBidLine = 1;
		ChartShowAskLine = 1;
		ChartShowLastLine = 1;
		ChartShowPeriodSeparators = 1;
		ChartShowGrid = 0;
		ChartShowDescriptions = 0;
		ChartShowTradeLevels = 1;
		ChartShowDateScale = 1;
		ChartShowPriceScale = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ChartMode = (int)CHART_CANDLES;
		ChartShowVolumes = (int)CHART_VOLUME_HIDE;
	}
};

// Block 88162 (Master_TF)
class Block72: public MDL_Pass
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "88162";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {39,40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[39].run(72);
			_blocks_[40].run(72);
		}
	}
};

// Block 88163 (EMA)
class Block73: public MDL_Formula_24<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "88163";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MA12_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::MA26_Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[74].run(73);
		}
	}
};

// Block 88164 (MACD)
class Block74: public MDL_Formula_25<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "88164";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MA12_MA26_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ATR26_Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 88179 (MACD)
class Block75: public MDL_ModifyVariables<int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "88179";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.MAperiod = 12;
		Value2.MAperiod = 26;
		Value3.ATRperiod = 26;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.MAmethod = MODE_EMA;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = c::Second_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.MAmethod = MODE_EMA;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = c::Second_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Second_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(75);
		}
	}

	virtual void _beforeExecute_()
	{

		v::MA12_Second_TF = _Value1_();
		v::MA26_Second_TF = _Value2_();
		v::ATR26_Second_TF = _Value3_();
	}
};

// Block 149354 (Second_TF)
class Block76: public MDL_Pass
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "149354";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {75,83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(76);
			_blocks_[83].run(76);
		}
	}
};

// Block 149355 (&lt;-50)
class Block77: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "149355";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {78,79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -50;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[78].run(77);
			_blocks_[79].run(77);
		}
	}
};

// Block 179167 (&nbsp;x&gt;150)
class Block78: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "179167";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -150;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(78);
		}
	}
};

// Block 179168 (&nbsp;x&gt;-150)
class Block79: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "179168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -150;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(79);
		}
	}
};

// Block 179170 (&nbsp;x&gt;50)
class Block80: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "179170";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {81,82};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 50.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[81].run(80);
			_blocks_[82].run(80);
		}
	}
};

// Block 179191 (&nbsp;x&gt;150)
class Block81: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "179191";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 150.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(81);
		}
	}
};

// Block 179192 (&nbsp;x&lt;150)
class Block82: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "179192";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 150.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(82);
		}
	}
};

// Block 179195 (DI+ DI-)
class Block83: public MDL_ModifyVariables<int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "179195";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {84,85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.ADXmode = 1;
		Value2.ADXmode = 2;
		Value3.ATRperiod = 26;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = c::Second_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Symbol = CurrentSymbol();
		Value2.Period = c::Second_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Second_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(83);
			_blocks_[85].run(83);
		}
	}

	virtual void _beforeExecute_()
	{

		v::DIB_Second_TF = _Value1_();
		v::DIS_Second_TF = _Value2_();
		v::ATR26_Second_TF = _Value3_();
	}
};

// Block 179196 (DI+ - DI-)
class Block84: public MDL_Formula_26<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "179196";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::DIS_Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[86].run(84);
		}
	}
};

// Block 179197 (DI+ + DI-)
class Block85: public MDL_Formula_27<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "179197";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::DIS_Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[86].run(85);
		}
	}
};

// Block 179198 (DX)
class Block86: public MDL_Formula_28<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "179198";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SUMDI_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SUMDI2_Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 331369 (DXSecond_TF &lt;&nbsp;)
class Block87: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "331369";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {116};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -40;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DXSecond_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[116].run(87);
		}
	}
};

// Block 337259 (DXMaster_TF&nbsp;&lt;&nbsp;)
class Block88: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "337259";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 40.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DXMaster_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[90].run(88);
		}
	}
};

// Block 343134 (Once per bar)
class Block89: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "343134";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {54,59};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(89);
			_blocks_[59].run(89);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 641595 (DXSecond_TF &lt;&nbsp;)
class Block90: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "641595";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 40.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DXSecond_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(90);
		}
	}
};

// Block 647489 (No position)
class Block91: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "647489";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[89].run(91);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 647490 (No position)
class Block92: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "647490";
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
			_blocks_[56].run(92);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 647495 (Master_TF)
class Block93: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_indicators_iADXWilder,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "647495";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "Master_TF";
		ObjY = 500;
		ObjTitleFontSize = 9;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "MACDV";
		Label2 = "DX";
		Label3 = "ADX";
		Label4 = "DI+";
		Label5 = "DI-";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::MACDV_Master_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::DXMaster_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Master_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::DIB_Master_TF;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::DIS_Master_TF;

		return Value5._execute_();
	}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[94].run(93);
		}
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 500;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 647496 (Second_TF)
class Block94: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_indicators_iADXWilder,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "647496";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "Second_TF";
		ObjX = 102;
		ObjY = 500;
		ObjTitleFontSize = 9;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "MACDV";
		Label2 = "DX";
		Label3 = "ADX";
		Label4 = "DI+";
		Label5 = "DI-";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::MACDV_Second_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::DXSecond_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Second_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::DIB_Second_TF;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::DIS_Second_TF;

		return Value5._execute_();
	}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(94);
		}
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 500;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 647497 (Pass)
class Block95: public MDL_Pass
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "647497";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(95);
		}
	}
};

// Block 647498 (Pass)
class Block96: public MDL_Pass
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "647498";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[108].run(96);
		}
	}
};

// Block 647499 (Pass)
class Block97: public MDL_Pass
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "647499";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(97);
		}
	}
};

// Block 647500 (Pass)
class Block98: public MDL_Pass
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "647500";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(98);
		}
	}
};

// Block 647829 (EMA)
class Block99: public MDL_Formula_29<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "647829";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MA12_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::MA26_Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(99);
		}
	}
};

// Block 647830 (MACD)
class Block100: public MDL_Formula_30<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "647830";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MA12_MA26_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::ATR26_Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 647845 (MACD)
class Block101: public MDL_ModifyVariables<int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "647845";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.MAperiod = 12;
		Value2.MAperiod = 26;
		Value3.ATRperiod = 26;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.MAmethod = MODE_EMA;
		Value1.AppliedPrice = PRICE_CLOSE;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = c::Mini_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.MAmethod = MODE_EMA;
		Value2.AppliedPrice = PRICE_CLOSE;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = c::Mini_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Mini_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(101);
		}
	}

	virtual void _beforeExecute_()
	{

		v::MA12_Mini_TF = _Value1_();
		v::MA26_Mini_TF = _Value2_();
		v::ATR26_Mini_TF = _Value3_();
	}
};

// Block 709020 (Mini_TF)
class Block102: public MDL_Pass
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "709020";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {101,103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[101].run(102);
			_blocks_[103].run(102);
		}
	}
};

// Block 738861 (DI+ DI-)
class Block103: public MDL_ModifyVariables<int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "738861";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {104,105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.ADXmode = 1;
		Value2.ADXmode = 2;
		Value3.ATRperiod = 26;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = c::Mini_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Symbol = CurrentSymbol();
		Value2.Period = c::Mini_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Mini_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(103);
			_blocks_[105].run(103);
		}
	}

	virtual void _beforeExecute_()
	{

		v::DIB_Mini_TF = _Value1_();
		v::DIS_Mini_TF = _Value2_();
		v::ATR26_Mini_TF = _Value3_();
	}
};

// Block 738862 (DI+ - DI-)
class Block104: public MDL_Formula_31<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "738862";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::DIS_Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(104);
		}
	}
};

// Block 738863 (DI+ + DI-)
class Block105: public MDL_Formula_32<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "738863";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::DIS_Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(105);
		}
	}
};

// Block 738864 (DX)
class Block106: public MDL_Formula_33<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "738864";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::SUMDI_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::SUMDI2_Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 738865 (Mini_TF)
class Block107: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_indicators_iADXWilder,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "738865";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		Title = "Mini_TF";
		ObjX = 205;
		ObjY = 500;
		ObjTitleFontSize = 8;
		ObjLabelsFontSize = 7;
		ObjFontSize = 8;
		Label1 = "MACDV";
		Label2 = "DX";
		Label3 = "ADX";
		Label4 = "DI+";
		Label5 = "DI-";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::MACDV_Mini_TF;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::DXSecond_TF;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Symbol = CurrentSymbol();
		Value3.Period = c::Mini_TF;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::DIB_Mini_TF;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::DIS_Mini_TF;

		return Value5._execute_();
	}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		/* Inputs, modified into the code must be set here every time */
		ObjY = 500;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrBlack;
		ObjLabelsFontColor = (color)clrNavy;
		ObjFontColor = (color)clrGreen;
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

// Block 738866 (&lt;-50)
class Block108: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "738866";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {109,110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -50;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[109].run(108);
			_blocks_[110].run(108);
		}
	}
};

// Block 768678 (&nbsp;x&gt;150)
class Block109: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "768678";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {114};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -150;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[114].run(109);
		}
	}
};

// Block 768679 (&nbsp;x&gt;-150)
class Block110: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "768679";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {114};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -150;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[114].run(110);
		}
	}
};

// Block 768681 (&nbsp;x&gt;50)
class Block111: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "768681";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {112,113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 50.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(111);
			_blocks_[113].run(111);
		}
	}
};

// Block 768702 (&nbsp;x&gt;150)
class Block112: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "768702";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 150.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[115].run(112);
		}
	}
};

// Block 768703 (&nbsp;x&lt;150)
class Block113: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "768703";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 150.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::MACDV_Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[115].run(113);
		}
	}
};

// Block 1237009 (Pass)
class Block114: public MDL_Pass
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "1237009";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(114);
		}
	}
};

// Block 1237011 (Pass)
class Block115: public MDL_Pass
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "1237011";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(115);
		}
	}
};

// Block 1237012 (DXMini_TF &lt;&nbsp;)
class Block116: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "1237012";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = -40;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DXMini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(116);
		}
	}
};

// Block 1547238 (DXMini_TF &lt;&nbsp;)
class Block117: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "1547238";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {91};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 40.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DXMini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[91].run(117);
		}
	}
};

// Block 1547239 (Count ALL)
class Block118: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "1547239";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(118);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1547240 (N)
class Block119: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_1,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "1547240";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

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

		v::Counts_ALL = _Value1_();
	}
};

// Block 1547243 (Count BUY)
class Block120: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "1547243";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
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

		BucketID = (color)clrBlue;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1547244 (N)
class Block121: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_2,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "1547244";
		_beforeExecuteEnabled = true;

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
	}

	virtual void _beforeExecute_()
	{

		v::Counts_Buy = _Value1_();
	}
};

// Block 1547245 (Count SELL)
class Block122: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "1547245";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
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

		BucketID = (color)clrRed;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1547246 (N)
class Block123: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_3,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "1547246";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrRed;

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

		v::Counts_Sell = _Value1_();
	}
};

// Block 1547247 (R1)
class Block124: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "1547247";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "R1";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRb_50;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547248 (R2)
class Block125: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "1547248";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "R2";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRb_70;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547249 (R3)
class Block126: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "1547249";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "R3";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRb_80;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547250 (R4)
class Block127: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "1547250";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "R4";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRb_90;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547251 (R5)
class Block128: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "1547251";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "R5";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRb_100;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547252 (S1)
class Block129: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "1547252";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "S1";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRs_50;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrGreen;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547253 (S2)
class Block130: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "1547253";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "S2";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRs_70;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrGreen;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547254 (S3)
class Block131: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "1547254";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "S3";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRs_80;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrGreen;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547255 (S4)
class Block132: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "1547255";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "S4";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRs_90;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrGreen;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547256 (S5)
class Block133: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "1547256";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "S5";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Price_ATRs_100;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)clrGreen;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 1547257 (2.1)
class Block134: public MDL_Formula_34<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "1547257";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Profit;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Counts_ALL;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[61].run(134);
		}
	}
};

// Block 1547268 (H0 &gt; H1)
class Block135: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "1547268";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
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
		Lo.ZigZagDepth = c::Zigzag_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::Zigzag_Period;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(135);
		}
	}
};

// Block 1547269 (L0 &lt; L1)
class Block136: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "1547269";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {139};
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
		Lo.ZigZagDepth = c::Zigzag_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::Zigzag_Period;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::Master_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(136);
		}
	}
};

// Block 1547273 (AND)
class Block137: public MDL_LogicalAND
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "1547273";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {32,6};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[6].run(137);
			_blocks_[32].run(137);
		}
	}
};

// Block 74844714 (H0 &gt; H1)
class Block138: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "74844714";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
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
		Lo.ZigZagDepth = c::Zigzag_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::Zigzag_Period;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(138);
		}
	}
};

// Block 74844715 (L0 &lt; L1)
class Block139: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "74844715";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
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
		Lo.ZigZagDepth = c::Zigzag_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::Zigzag_Period;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::Second_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[141].run(139);
		}
	}
};

// Block 74844716 (H0 &gt; H1)
class Block140: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "74844716";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
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
		Lo.ZigZagDepth = c::Zigzag_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::Zigzag_Period;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(140);
		}
	}
};

// Block 74844717 (L0 &lt; L1)
class Block141: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "74844717";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
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
		Lo.ZigZagDepth = c::Zigzag_Period;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = c::Mini_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.ZigZagDepth = c::Zigzag_Period;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = c::Mini_TF;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(141);
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

	if (memory == 0)
	{
		memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
	}

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

			expirationWorker.RemoveExpiration(ticket);
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

		int total = PositionsTotal();

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
		return (long)PositionGetTicket(index);
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
		if (!PositionSelectByTicket(ticket)) return false;

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

		for (int i = 0; i < PositionsTotal(); i++)
		{
			long positionTicket = (long)PositionGetTicket(i);

			if (!positionTicket) continue;

			if (positionTicket == ticket)
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

bool LoadPendingOrder(long ticket)
{
	bool success = false;

   if (OrderSelect(ticket))
	{
		// The order could be from any type, so check the type
		// and allow only true pending orders.
		ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);

		if (
			   type == ORDER_TYPE_BUY_LIMIT
			|| type == ORDER_TYPE_SELL_LIMIT
			|| type == ORDER_TYPE_BUY_STOP
			|| type == ORDER_TYPE_SELL_STOP
		) {
			LoadedType(2);
			OrderTicket(ticket);
			success = true;
		}
	}

   return success;
}

bool LoadPosition(long ticket)
{
   bool success = false;

   if (PositionSelectByTicket(ticket))
	{
		LoadedType(1);
		OrderTicket(ticket);
		success = true;
	}

   return success;
}

int LoadedType(int type = 0)
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
	long ticket,
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
				&& exp == OrderExpirationTime()
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

			if (!((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)))
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
	static long last_known_ticket = 0;
	static long orders1[];
	static long orders2[];
	int i, size;

	int total = OrdersTotal();

	for (int pos=total-1; pos>=0; pos--)
	{
		if (LoadPendingOrder(OrderGetTicket(pos)))
		{
			long ticket = OrderTicket();

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

	for (i = size - 1; i >= 0; i--)
	{
		if (LoadPendingOrder(orders1[i]) == false || OrderType() <= ORDER_TYPE_SELL)
		{
			if (LoadPendingOrder(orders2[i])) {
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
		if (LoadPendingOrder(orders2[i]) == false || OrderType() <= ORDER_TYPE_SELL)
		{
			if (LoadPendingOrder(orders1[i])) {
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
		ENUM_POSITION_TYPE type;
		ENUM_POSITION_REASON reason;
		long     positionId,
		         magic,
		         ticket,
		         timeMs,
		         timeUpdateMs;
		datetime time,
					timeExpiration,
		         timeUpdate;
		double   priceCurrent,
		         priceOpen,
		         profit,
		         stopLoss,
		         swap,
		         takeProfit,
		         volume;
		string   externalId,
		         comment,
		         symbol;
	};

	struct PendingOrder
	{
		ENUM_ORDER_TYPE type;
		ENUM_ORDER_STATE state;
		ENUM_ORDER_TYPE_FILLING typeFilling;
		ENUM_ORDER_TYPE_TIME typeTime;
		ENUM_ORDER_REASON reason;
		long     magic,
		         positionId,
		         positionById,
		         ticket,
		         timeSetupMs,
		         timeDoneMs;
		datetime timeDone,
		         timeExpiration,
		         timeSetup;
		double   priceCurrent,
		         priceOpen,
		         priceStopLimit,
		         stopLoss,
		         takeProfit,
		         volume,
		         volumeInitial;
		string   externalId,
		         comment,
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
			if (OrderGetTicket(index) <= 0) continue;

			howManyAdded++;
			ArrayResize(list, howManyAdded);
			int i = howManyAdded - 1;

			// enum types
			list[i].type        = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
			list[i].state       = (ENUM_ORDER_STATE)OrderGetInteger(ORDER_STATE);
			list[i].typeFilling = (ENUM_ORDER_TYPE_FILLING)OrderGetInteger(ORDER_TYPE_FILLING);
			list[i].typeTime    = (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
			list[i].reason      = (ENUM_ORDER_REASON)OrderGetInteger(ORDER_REASON);

			// long
			list[i].magic        = (long)OrderGetInteger(ORDER_MAGIC);
			list[i].positionId   = (long)OrderGetInteger(ORDER_POSITION_ID);
			list[i].positionById = (long)OrderGetInteger(ORDER_POSITION_BY_ID);
			list[i].ticket       = (long)OrderGetInteger(ORDER_TICKET);
			list[i].timeSetupMs  = (long)OrderGetInteger(ORDER_TIME_SETUP_MSC);
			list[i].timeDoneMs   = (long)OrderGetInteger(ORDER_TIME_DONE_MSC);

			// datetime
			list[i].timeDone       = (datetime)OrderGetInteger(ORDER_TIME_DONE);
			list[i].timeExpiration = (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
			list[i].timeSetup      = (datetime)OrderGetInteger(ORDER_TIME_SETUP);

			// double
			list[i].priceCurrent   = OrderGetDouble(ORDER_PRICE_CURRENT);
			list[i].priceOpen      = OrderGetDouble(ORDER_PRICE_OPEN);
			list[i].priceStopLimit = OrderGetDouble(ORDER_PRICE_STOPLIMIT);
			list[i].stopLoss       = OrderGetDouble(ORDER_SL);
			list[i].takeProfit     = OrderGetDouble(ORDER_TP);
			list[i].volume         = OrderGetDouble(ORDER_VOLUME_CURRENT);
			list[i].volumeInitial  = OrderGetDouble(ORDER_VOLUME_INITIAL);

			// string
			list[i].externalId = OrderGetString(ORDER_EXTERNAL_ID);
			list[i].comment    = OrderGetString(ORDER_COMMENT);
			list[i].symbol     = OrderGetString(ORDER_SYMBOL);
		}

		return howManyAdded;
	}

	/**
	* Overloaded method 2 of 2
	*/
	int MakeListOf(Position &list[])
	{
		ArrayResize(list, 0);

		int count        = PositionsTotal();
		int howManyAdded = 0;

		for (int index = 0; index < count; index++)
		{
			if (PositionGetTicket(index) <= 0) continue;

			howManyAdded++;
			ArrayResize(list, howManyAdded);
			int i = howManyAdded - 1;

			// enum types
			list[i].type   = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
			list[i].reason = (ENUM_POSITION_REASON)PositionGetInteger(POSITION_REASON);

			// long
			list[i].positionId   = (long)PositionGetInteger(POSITION_IDENTIFIER);
			list[i].magic        = (long)PositionGetInteger(POSITION_MAGIC);
			list[i].ticket       = (long)PositionGetInteger(POSITION_TICKET);
			list[i].timeMs       = (long)PositionGetInteger(POSITION_TIME_MSC);
			list[i].timeUpdateMs = (long)PositionGetInteger(POSITION_TIME_UPDATE_MSC);

			// datetime
			list[i].time           = (datetime)PositionGetInteger(POSITION_TIME);
			list[i].timeExpiration = (datetime)0;
			list[i].timeUpdate     = (datetime)PositionGetInteger(POSITION_TIME_UPDATE);

			// double
			list[i].priceCurrent = PositionGetDouble(POSITION_PRICE_CURRENT);
			list[i].priceOpen    = PositionGetDouble(POSITION_PRICE_OPEN);
			list[i].profit       = PositionGetDouble(POSITION_PROFIT);
			list[i].stopLoss     = PositionGetDouble(POSITION_SL);
			list[i].swap         = PositionGetDouble(POSITION_SWAP);
			list[i].takeProfit   = PositionGetDouble(POSITION_TP);
			list[i].volume       = PositionGetDouble(POSITION_VOLUME);

			// string
			list[i].externalId = PositionGetString(POSITION_EXTERNAL_ID);
			list[i].comment    = PositionGetString(POSITION_COMMENT);
			list[i].symbol     = PositionGetString(POSITION_SYMBOL);

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
					// Type => volume modified
					if (previous.positionId == current.positionId)
					{
						reason = "reverse";
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
		datetime timeOpen  = item.time;
		datetime timeClose = (datetime)0;
		double priceOpen   = item.priceOpen;
		double priceClose  = item.priceCurrent;
		double profit      = item.profit;
		double swap        = item.swap;
		double commission  = 0.0;
		double volume      = item.volume;

		if (reason == "close" || reason == "decrement")
		{
			if (HistorySelectByPosition(item.positionId))
			{
				int total = HistoryDealsTotal();

				if (total > 0)
				{
					long firstTicket = (long)HistoryDealGetTicket(0);
					long lastTicket  = (long)HistoryDealGetTicket(total - 1);

					// Ticket is the ticket of the previous deal, the one before the last one
					ticket = (long)HistoryDealGetTicket(total - 2);

					// Open Time and Open Price - get them from the very first deal
					priceOpen = HistoryDealGetDouble(firstTicket, DEAL_PRICE);
					timeOpen  = (datetime)HistoryDealGetInteger(firstTicket, DEAL_TIME);

					// Close Time - get it from the very last deal
					timeClose  = (datetime)HistoryDealGetInteger(lastTicket, DEAL_TIME);
					priceClose = HistoryDealGetDouble(lastTicket, DEAL_PRICE);

					profit     = HistoryDealGetDouble(lastTicket, DEAL_PROFIT);
					swap       = HistoryDealGetDouble(lastTicket, DEAL_SWAP);
					commission = HistoryDealGetDouble(lastTicket, DEAL_COMMISSION);

					volume = HistoryDealGetDouble(lastTicket, DEAL_VOLUME);

					// Find why the position has been closed
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
						ENUM_DEAL_REASON dealReason = (ENUM_DEAL_REASON)HistoryDealGetInteger(lastTicket, DEAL_REASON);
	
						switch (dealReason)
						{
							case DEAL_REASON_SL: detail = "sl"; break;
							case DEAL_REASON_TP: detail = "tp"; break;
							case DEAL_REASON_SO: detail = "so"; break;
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
		datetime timeExpiration = item.timeExpiration;

		// When the lifetime of the order is ORDER_TIME_DAY,
		// the expiration (ORDER_TIME_EXPIRATION) equals to the time of opening.
		// Here we fix this.
		if (item.typeTime == ORDER_TIME_DAY)
		{
			timeExpiration = (datetime)(MathFloor(((double)item.timeSetup + 86400.0) / 86400.0) * 86400.0);
		}

		int i = eventValuesQueueIndex;

		eventValues[i].reason = reason;
		eventValues[i].detail = detail;

		eventValues[i].priceClose     = item.priceCurrent;
		eventValues[i].timeClose      = item.timeDone;
		eventValues[i].comment        = item.comment;
		eventValues[i].commission     = 0.0;
		eventValues[i].timeExpiration = timeExpiration;
		eventValues[i].volume         = item.volume;
		eventValues[i].magic          = item.magic;
		eventValues[i].priceOpen      = item.priceOpen;
		eventValues[i].timeOpen       = item.timeSetup;
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
			" <<<\n",
			" | reason: ", e_Reason(),
			" | detail: ", e_ReasonDetail(),
			" | ticket: ", e_attrTicket(),
			" | type: ", EnumToString((ENUM_ORDER_TYPE)e_attrType()),
			"\n",
			" | openTime : ", e_attrOpenTime(),
			" | openPrice : ", e_attrOpenPrice(),
			"\n",
			" | closeTime: ", e_attrCloseTime(),
			" | closePrice: ", e_attrClosePrice(),
			"\n",
			" | volume: ", e_attrLots(),
			" | sl: ", e_attrStopLoss(),
			" | tp: ", e_attrTakeProfit(),
			" | profit: ", e_attrProfit(),
			" | swap: ", e_attrSwap(),
			" | exp: ", e_attrExpiration(),
			" | comment: ", e_attrComment(),
			"\n >>>"
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

/**
* When a trade is a child, its Open Price is the same as the Open Price of the most parent trade.
* This function will return the actual Open Price of this parent trade, which would be the Close
* Price of the previous child trade, or the parent trade if this is the only child, or itself if
* it's the trade is not a child.
*/
double OrderChildOpenPrice() {
	long ticket = PositionGetInteger(POSITION_TICKET);
	long positionID = PositionGetInteger(POSITION_IDENTIFIER);

	HistorySelectByPosition(positionID);

	double openPrice = 0;
	int total = HistoryDealsTotal();

	if (total > 0) {
		double orderClosePrice = HistoryDealGetDouble(HistoryDealGetTicket(total -1), DEAL_PRICE);
		openPrice = orderClosePrice;
	}

	PositionSelectByTicket(ticket);

	return openPrice;
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
	
	bool placeExpirationObject = false; // whether or not to create an object for expiration for trades

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
				//- bo broker?
				if (
					   StringLen(symbol) > 6
					&& StringSubstr(symbol, StringLen(symbol) - 2) == "bo"
				) {
					//- convert UNIX to seconds
					if (expiration > TimeCurrent()-100)
					{
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
					if (LoadPendingOrder(result.order)) {break;}
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

datetime OrderExpiration()
{
	return OrderExpirationTime();
}

datetime OrderExpirationTime()
{
	int LoadedType = LoadedType();

	if (LoadedType == 1) return expirationWorker.GetExpiration(PositionGetInteger(POSITION_TICKET));
	if (LoadedType == 2) return (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);

	return 0;
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

long OrderTicket(long ticket = 0)
{
	static long memory = 0;

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

long e_attrMagicNumber() {return onTradeEventDetector.EventValueMagic();}

double e_attrOpenPrice() {return onTradeEventDetector.EventValuePriceOpen();}

datetime e_attrOpenTime() {return onTradeEventDetector.EventValueTimeOpen();}

double e_attrProfit() {return onTradeEventDetector.EventValueProfit();}

double e_attrStopLoss() {return onTradeEventDetector.EventValueStopLoss();}

double e_attrSwap() {return onTradeEventDetector.EventValueSwap();}

string e_attrSymbol() {return onTradeEventDetector.EventValueSymbol();}

double e_attrTakeProfit() {return onTradeEventDetector.EventValueTakeProfit();}

long e_attrTicket() {return onTradeEventDetector.EventValueTicket();}

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

double iMA( 
	string             symbol,
	ENUM_TIMEFRAMES    timeframe,
	int                ma_period,
	int                ma_shift,
	ENUM_MA_METHOD     ma_method,
	ENUM_APPLIED_PRICE applied_price,
	int                shift
)
{
	int handle = iMA(symbol, timeframe, ma_period, ma_shift, ma_method, applied_price);
	double val = fxdCustomIndicator(handle, 0, shift);

	return NormalizeDouble(val, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));
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
	// iCustom always creates new handle, even if the input parameters are always the same
	// That's why some caching is needed.
	static string memory[][3];

	int digits = 0;
	int handle = INVALID_HANDLE;
	
	string marker = symbol + IntegerToString(timeframe) + IntegerToString(InpDepth) + IntegerToString(InpDeviation) + IntegerToString(InpBackstep);
	int size = ArrayRange(memory, 0);

	for (int i = size-1; i >= 0; i--)
	{
		if (memory[i][0] == marker)
		{
			handle = (int)StringToInteger(memory[i][1]);
			digits = (int)StringToInteger(memory[i][2]);

			break;
		}
	}
	
	if (handle == INVALID_HANDLE)
	{
		digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

		handle = iCustom(
			symbol,
			timeframe,
			"Examples\\ZigZag",
			InpDepth,
			InpDeviation,
			InpBackstep
		);
		
		ArrayResize(memory, size+1);
		
		memory[size][0] = marker;
		memory[size][1] = IntegerToString(handle);
		memory[size][2] = IntegerToString(digits);
	}

	double value = fxdCustomIndicator(handle, mode, shift);
	
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
