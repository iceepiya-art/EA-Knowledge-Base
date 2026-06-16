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
#define PROJECT_ID "mt5-3261"
//--
// Point Format Rules
#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later
#define ENABLE_SPREAD_METER false
#define ENABLE_STATUS false
#define ENABLE_TEST_INDICATORS false
//--
// Events On/Off
#define ENABLE_EVENT_TICK 0 // enable "Tick" event
#define ENABLE_EVENT_TRADE 1 // enable "Trade" event
#define ENABLE_EVENT_TIMER 1 // enable "Timer" event
//--
// Virtual Stops
#define VIRTUAL_STOPS_ENABLED 0 // enable virtual stops
#define VIRTUAL_STOPS_TIMEOUT 0 // virtual stops timeout
#define USE_EMERGENCY_STOPS "no" // "yes" to use emergency (hard stops) when virtual stops are in use. "always" to use EMERGENCY_STOPS_ADD as emergency stops when there is no virtual stop.
#define EMERGENCY_STOPS_REL 0 // use 0 to disable hard stops when virtual stops are enabled. Use a value >=0 to automatically set hard stops with virtual. Example: if 2 is used, then hard stops will be 2 times bigger than virtual ones.
#define EMERGENCY_STOPS_ADD 0 // add pips to relative size of emergency stops (hard stops)
//--
// Settings for events
#define ON_TIMER_PERIOD 1 // Timer event period (in seconds)

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
input bool Is_This_Client_Port = true;input double Second = 1.0;input string BuyOPEN1 = "BuyOPEN1.csv";input string BuyCLOSE2 = "BuyCLOSE2.csv";input string BuyCLOSE3 = "BuyCLOSE3.csv";input string SellOPEN1 = "SellOPEN1.csv";input string SellCLOSE2 = "SellCLOSE2.csv";input string SellCLOSE3 = "SellCLOSE3.csv";input int MagicStart = 789565; // Magic Number, kind of...
class c
{
		public:
	static bool Is_This_Client_Port;
	static double Second;
	static string BuyOPEN1;
	static string BuyCLOSE2;
	static string BuyCLOSE3;
	static string SellOPEN1;
	static string SellCLOSE2;
	static string SellCLOSE3;
	static int MagicStart;
};
bool c::Is_This_Client_Port;
double c::Second;
string c::BuyOPEN1;
string c::BuyCLOSE2;
string c::BuyCLOSE3;
string c::SellOPEN1;
string c::SellCLOSE2;
string c::SellCLOSE3;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static string MasterOrClient;
	static double TicketM1;
	static double TypeM1;
	static double LotM1;
	static string SymbolM1;
	static double ActionM1;
	static double TicketM2;
	static double TypeM2;
	static double LotM2;
	static string SymbolM2;
	static double ActionM2;
	static double TicketM3;
	static double TypeM3;
	static double LotM3;
	static string SymbolM3;
	static double ActionM3;
	static double TicketS1;
	static double TypeS1;
	static double LotS1;
	static string SymbolS1;
	static double ActionS1;
	static double TicketS2;
	static double TypeS2;
	static double LotS2;
	static string SymbolS2;
	static double ActionS2;
	static double TicketS3;
	static double TypeS3;
	static double LotS3;
	static string SymbolS3;
	static double ActionS3;
};
string v::MasterOrClient;
double v::TicketM1;
double v::TypeM1;
double v::LotM1;
string v::SymbolM1;
double v::ActionM1;
double v::TicketM2;
double v::TypeM2;
double v::LotM2;
string v::SymbolM2;
double v::ActionM2;
double v::TicketM3;
double v::TypeM3;
double v::LotM3;
string v::SymbolM3;
double v::ActionM3;
double v::TicketS1;
double v::TypeS1;
double v::LotS1;
string v::SymbolS1;
double v::ActionS1;
double v::TicketS2;
double v::TypeS2;
double v::LotS2;
string v::SymbolS2;
double v::ActionS2;
double v::TicketS3;
double v::TypeS3;
double v::LotS3;
string v::SymbolS3;
double v::ActionS3;




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
int FXD_BLOCKS_COUNT        = 145;
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
	c::Is_This_Client_Port = Is_This_Client_Port;
	c::Second = Second;
	c::BuyOPEN1 = BuyOPEN1;
	c::BuyCLOSE2 = BuyCLOSE2;
	c::BuyCLOSE3 = BuyCLOSE3;
	c::SellOPEN1 = SellOPEN1;
	c::SellCLOSE2 = SellCLOSE2;
	c::SellCLOSE3 = SellCLOSE3;
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

	v::MasterOrClient = "";
	v::TicketM1 = 0.0;
	v::TypeM1 = 0.0;
	v::LotM1 = 0.0;
	v::SymbolM1 = "";
	v::ActionM1 = 0.0;
	v::TicketM2 = 0.0;
	v::TypeM2 = 0.0;
	v::LotM2 = 0.0;
	v::SymbolM2 = "";
	v::ActionM2 = 0.0;
	v::TicketM3 = 0.0;
	v::TypeM3 = 0.0;
	v::LotM3 = 0.0;
	v::SymbolM3 = "";
	v::ActionM3 = 0.0;
	v::TicketS1 = 0.0;
	v::TypeS1 = 0.0;
	v::LotS1 = 0.0;
	v::SymbolS1 = "";
	v::ActionS1 = 0.0;
	v::TicketS2 = 0.0;
	v::TypeS2 = 0.0;
	v::LotS2 = 0.0;
	v::SymbolS2 = "";
	v::ActionS2 = 0.0;
	v::TicketS3 = 0.0;
	v::TypeS3 = 0.0;
	v::LotS3 = 0.0;
	v::SymbolS3 = "";
	v::ActionS3 = 0.0;




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
	ArrayResize(_blocks_, 145);

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
	int blocks_to_run[] = {0};
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



	return;
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on trade events - open, close, modify //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTrade()
{
	OnTradeQueue(1);


if (OnTradeDetector()==false)
{
OnTradeQueue(-1);
return;
}
	//-- run blocks
	int blocks_to_run[] = {3,6,17,18,27,28};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	OnTradeQueue(-1);
}


//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on a period basis //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTimer()
{
	//-- run blocks
	int blocks_to_run[] = {5,19,36,51,53,55,59,63,81,101,105,112,114,116};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
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

// "Position created" model
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

// "Position closed" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7>
class MDL_eTrade_TradeClosed: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 CloseMode;
	T7 ClosePartialMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eTrade_TradeClosed()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		CloseMode = (string)"";
		ClosePartialMode = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool next = false;
		
		if (
			   (e_Reason() == "close" || e_Reason() == "decrement")
			&& e_attrType() < 2
			&& FilterEventTrade(GroupMode, Group, SymbolMode, Symbol, BuysOrSells)
		)
		{
			string close_type = "nosltp";
		
			double price_close = e_attrClosePrice();
			int type           = e_attrType();
		
			// at least in MQL5 the closing price can be beyond the stop price and that's why >= and <= are used
			     if (e_attrStopLoss() > 0.0 && ((type == 0 && price_close <= e_attrStopLoss()) || (type == 1 && price_close >= e_attrStopLoss()))) {close_type = "sl";}
			else if (e_attrTakeProfit() > 0.0 && ((type == 0 && price_close >= e_attrTakeProfit()) || (type == 1 && price_close <= e_attrTakeProfit()))) {close_type = "tp";}
		
			if (
				(
						(CloseMode == "")
					|| (CloseMode == close_type)
					|| (CloseMode == "sltp" && (close_type == "sl" || close_type == "tp"))
					|| (CloseMode == "exp" && e_ReasonDetail() == "expire")
				)
				&& (
					   (ClosePartialMode == 0)
					|| (ClosePartialMode == 1 && e_attrTicket() == attrTicketChild(e_attrTicket())) // fully closed
					|| (ClosePartialMode == 2 && e_attrTicket() != attrTicketChild(e_attrTicket())) // partially closed
				)
			)
			{next = true;}
		}
		
		if (next) {_callback_(1);} else {_callback_(0);}
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

// "Change Timer period" model
template<typename T1,typename T2,typename T3>
class MDL_eTimer_ChangePeriod: public BlockCalls
{
	public: /* Input Parameters */
	T1 SetHours;
	T2 SetMinutes;
	T3 SetSeconds;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eTimer_ChangePeriod()
	{
		SetHours = (double)0.0;
		SetMinutes = (double)1.0;
		SetSeconds = (double)0.0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		double time = (3600*SetHours) + (60*SetMinutes) + (SetSeconds);
		
		bool success = OnTimerSet(time);
		
		if (success == true) {_callback_(1);} else {_callback_(0);}
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

// "once per position/order" model
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

// "For each Closed Position" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10>
class MDL_LoopStartHistoryTrades: public BlockCalls
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
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopStartHistoryTrades()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		LoopDirection = (string)"newest-to-oldest";
		LoopSkip = (int)0;
		LoopEvery = (int)0;
		LoopLimit = (int)10;
		PassEnd = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int saved_type     = attrTypeInLoop();
		ulong saved_ticket = attrTicketInLoop(); // This ticket number will be reloaded at the end of this loop, so if we are in another overlapping loop - it will continue using it's last used ticket number
		
		int total = HistoryTradesTotal();
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
		
			if (HistoryTradeSelectByIndex(i, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				skip++;
		
				if (LoopSkip <= skip && (count < LoopLimit || LoopLimit == 0))
				{
					if (LoopEvery > 0)
					{
						every++;
		
						if (every < LoopEvery) {continue;} else {every = 0;}
					}
		
					count++;
					attrTypeInLoop(3);
					attrTicketInLoop(OrderTicket());
		
					_callback_(1);
		
					if (count == LoopLimit) break;
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

// "Comment (ugly)" model
template<typename T1,typename T2,typename T3,typename _T3_,typename T4,typename T5,typename _T5_,typename T6,typename T7,typename _T7_,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename _T11_,typename T12,typename T13,typename _T13_,typename T14,typename T15,typename _T15_,typename T16,typename T17,typename _T17_,typename T18,typename T19,typename _T19_,typename T20,typename T21,typename _T21_,typename T22,typename T23,typename _T23_,typename T24,typename T25,typename _T25_,typename T26,typename T27,typename _T27_,typename T28,typename T29,typename _T29_,typename T30,typename T31,typename _T31_,typename T32,typename T33,typename _T33_,typename T34,typename T35,typename _T35_,typename T36,typename T37,typename _T37_,typename T38,typename T39,typename _T39_,typename T40,typename T41,typename _T41_>
class MDL_CommentAdvanced: public BlockCalls
{
	public: /* Input Parameters */
	T1 CommentTitle;
	T2 CommentLabel1;
	T3 CommentValue1; virtual _T3_ _CommentValue1_(){return(_T3_)0;}
	T4 CommentLabel2;
	T5 CommentValue2; virtual _T5_ _CommentValue2_(){return(_T5_)0;}
	T6 CommentLabel3;
	T7 CommentValue3; virtual _T7_ _CommentValue3_(){return(_T7_)0;}
	T8 CommentLabel4;
	T9 CommentValue4; virtual _T9_ _CommentValue4_(){return(_T9_)0;}
	T10 CommentLabel5;
	T11 CommentValue5; virtual _T11_ _CommentValue5_(){return(_T11_)0;}
	T12 CommentLabel6;
	T13 CommentValue6; virtual _T13_ _CommentValue6_(){return(_T13_)0;}
	T14 CommentLabel7;
	T15 CommentValue7; virtual _T15_ _CommentValue7_(){return(_T15_)0;}
	T16 CommentLabel8;
	T17 CommentValue8; virtual _T17_ _CommentValue8_(){return(_T17_)0;}
	T18 CommentLabel9;
	T19 CommentValue9; virtual _T19_ _CommentValue9_(){return(_T19_)0;}
	T20 CommentLabel10;
	T21 CommentValue10; virtual _T21_ _CommentValue10_(){return(_T21_)0;}
	T22 CommentLabel11;
	T23 CommentValue11; virtual _T23_ _CommentValue11_(){return(_T23_)0;}
	T24 CommentLabel12;
	T25 CommentValue12; virtual _T25_ _CommentValue12_(){return(_T25_)0;}
	T26 CommentLabel13;
	T27 CommentValue13; virtual _T27_ _CommentValue13_(){return(_T27_)0;}
	T28 CommentLabel14;
	T29 CommentValue14; virtual _T29_ _CommentValue14_(){return(_T29_)0;}
	T30 CommentLabel15;
	T31 CommentValue15; virtual _T31_ _CommentValue15_(){return(_T31_)0;}
	T32 CommentLabel16;
	T33 CommentValue16; virtual _T33_ _CommentValue16_(){return(_T33_)0;}
	T34 CommentLabel17;
	T35 CommentValue17; virtual _T35_ _CommentValue17_(){return(_T35_)0;}
	T36 CommentLabel18;
	T37 CommentValue18; virtual _T37_ _CommentValue18_(){return(_T37_)0;}
	T38 CommentLabel19;
	T39 CommentValue19; virtual _T39_ _CommentValue19_(){return(_T39_)0;}
	T40 CommentLabel20;
	T41 CommentValue20; virtual _T41_ _CommentValue20_(){return(_T41_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CommentAdvanced()
	{
		CommentTitle = (string)"Comment Message";
		CommentLabel1 = (string)"";
		CommentLabel2 = (string)"";
		CommentLabel3 = (string)"";
		CommentLabel4 = (string)"";
		CommentLabel5 = (string)"";
		CommentLabel6 = (string)"";
		CommentLabel7 = (string)"";
		CommentLabel8 = (string)"";
		CommentLabel9 = (string)"";
		CommentLabel10 = (string)"";
		CommentLabel11 = (string)"";
		CommentLabel12 = (string)"";
		CommentLabel13 = (string)"";
		CommentLabel14 = (string)"";
		CommentLabel15 = (string)"";
		CommentLabel16 = (string)"";
		CommentLabel17 = (string)"";
		CommentLabel18 = (string)"";
		CommentLabel19 = (string)"";
		CommentLabel20 = (string)"";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (!MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_VISUAL_MODE))
		{
			string text = "";
		
			if (CommentLabel1 != "") text += "\n" + CommentLabel1 + ": " + (string)_CommentValue1_();
			if (CommentLabel2 != "") text += "\n" + CommentLabel2 + ": " + (string)_CommentValue2_();
			if (CommentLabel3 != "") text += "\n" + CommentLabel3 + ": " + (string)_CommentValue3_();
			if (CommentLabel4 != "") text += "\n" + CommentLabel4 + ": " + (string)_CommentValue4_();
			if (CommentLabel5 != "") text += "\n" + CommentLabel5 + ": " + (string)_CommentValue5_();
			if (CommentLabel6 != "") text += "\n" + CommentLabel6 + ": " + (string)_CommentValue6_();
			if (CommentLabel7 != "") text += "\n" + CommentLabel7 + ": " + (string)_CommentValue7_();
			if (CommentLabel8 != "") text += "\n" + CommentLabel8 + ": " + (string)_CommentValue8_();
			if (CommentLabel9 != "") text += "\n" + CommentLabel9 + ": " + (string)_CommentValue9_();
			if (CommentLabel10 != "") text += "\n" + CommentLabel10 + ": " + (string)_CommentValue10_();
			if (CommentLabel11 != "") text += "\n" + CommentLabel11 + ": " + (string)_CommentValue11_();
			if (CommentLabel12 != "") text += "\n" + CommentLabel12 + ": " + (string)_CommentValue12_();
			if (CommentLabel13 != "") text += "\n" + CommentLabel13 + ": " + (string)_CommentValue13_();
			if (CommentLabel14 != "") text += "\n" + CommentLabel14 + ": " + (string)_CommentValue14_();
			if (CommentLabel15 != "") text += "\n" + CommentLabel15 + ": " + (string)_CommentValue15_();
			if (CommentLabel16 != "") text += "\n" + CommentLabel16 + ": " + (string)_CommentValue16_();
			if (CommentLabel17 != "") text += "\n" + CommentLabel17 + ": " + (string)_CommentValue17_();
			if (CommentLabel18 != "") text += "\n" + CommentLabel18 + ": " + (string)_CommentValue18_();
			if (CommentLabel19 != "") text += "\n" + CommentLabel19 + ": " + (string)_CommentValue19_();
			if (CommentLabel20 != "") text += "\n" + CommentLabel20 + ": " + (string)_CommentValue20_();
		
			text = CommentTitle + "\n" + text;
		
			ChartSetString(0, CHART_COMMENT, text);
		}
		
		_callback_(1);
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


//------------------------------------------------------------------------------------------------------------------------

// "Ticket number" model
class MDLIC_eventTrade_e_attrTicket
{
	public: /* Input Parameters */
	int Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_eventTrade_e_attrTicket()
	{
		Mode = (int)0;
	}

	public: /* The main method */
	int _execute_()
	{
		int retval = e_attrTicket();
		
		if (Mode == 1)
		{
			retval = attrTicketParent(retval);
		}
		
		return retval;
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

// "Comment" model
class MDLIC_eventTrade_e_attrComment
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_eventTrade_e_attrComment()
	{
	}

	public: /* The main method */
	string _execute_()
	{
		return(e_attrComment());
	}
};

// "Ticket number" model
class MDLIC_inloop_OrderTicket
{
	public: /* Input Parameters */
	int Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderTicket()
	{
		Mode = (int)0;
	}

	public: /* The main method */
	ulong _execute_()
	{
		ulong retval = OrderTicket();
		
		if (Mode == 1)
		{
			retval = attrTicketParent(retval);
		}
		
		return retval;
	}
};

// "Market name" model
class MDLIC_inloop_OrderSymbol
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderSymbol()
	{
	}

	public: /* The main method */
	string _execute_()
	{
		return OrderSymbol();
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

// "Comment" model
class MDLIC_inloop_OrderComment
{
	virtual void _callback_(int r) {return;}

	public: /* The main method */
	string _execute_()
	{
		return OrderComment();
	}
};


//------------------------------------------------------------------------------------------------------------------------

// Block 1 (Pass)
class Block0: public MDL_Pass
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {1,22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[1].run(0);
			_blocks_[22].run(0);
		}
	}
};

// Block 2 (Modify chart properties)
class Block1: public MDL_ChartSetProperties<int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int>
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
		ChartOnForeground = 1;
		ChartShift = 0;
		ChartAutoScroll = 0;
		ChartShowOHLC = 0;
		ChartShowBidLine = 0;
		ChartShowAskLine = 0;
		ChartShowLastLine = 0;
		ChartShowPeriodSeparators = 0;
		ChartShowGrid = 0;
		ChartShowDescriptions = 0;
		ChartShowTradeLevels = 0;
		ChartShowDateScale = 0;
		ChartShowPriceScale = 0;
		ChartScaleFix11 = 1;
		ChartScaleFix = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[2].run(1);
		}
	}

	virtual void _beforeExecute_()
	{
		ChartShowVolumes = (int)CHART_VOLUME_HIDE;
	}
};

// Block 3 (Modify chart colors)
class Block2: public MDL_ChartSetColors<color,color,color,color,color,color,color,color,color,color,color,color,color>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		ChartColorBackground = (color)clrBlack;
		ChartColorForeground = (color)clrLightBlue;
		ChartColorGrid = (color)clrBlack;
		ChartColorBarUp = (color)clrBlack;
		ChartColorBarDown = (color)clrBlack;
		ChartColorBullCandle = (color)clrBlack;
		ChartColorBearCandle = (color)clrBlack;
		ChartColorDojiCandle = (color)clrBlack;
		ChartColorVolumes = (color)clrBlack;
		ChartColorBid = (color)clrBlack;
		ChartColorAsk = (color)clrBlack;
		ChartColorLast = (color)clrBlack;
		ChartColorStopLevels = (color)clrBlack;
	}
};

// Block 4 (Trade created)
class Block3: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {4};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[4].run(3);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 5 (Modify Variables)
class Block4: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual int _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(4);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM1 = _Value1_();
		v::SymbolM1 = _Value2_();
		v::LotM1 = _Value3_();
		v::TypeM1 = _Value4_();
		v::ActionM1 = _Value5_();
	}
};

// Block 6 (Custom MQL4 codere-read variables from file)
class Block5: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(5);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen(c::BuyOPEN1,FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,0);
	i++;
}

FileClose(handle);


v::TicketM1 = (double)strArr[0];
v::TypeM1 = (double)strArr[1];
v::LotM1 = (double)strArr[2];
v::SymbolM1 = (string)strArr[3];
v::ActionM1 = (double)strArr[4];
	}
};

// Block 7 (Trade created)
class Block6: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {142};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[142].run(6);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 8 (No trade)
class Block7: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {84};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(7);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketM1;
		Symbol = (string)v::SymbolM1;
	}
};

// Block 9 (Master Sell)
class Block8: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeS1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(8);
		}
	}
};

// Block 10 (Buy now)
class Block9: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
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
			_blocks_[128].run(9);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketS1;
		Symbol = (string)v::SymbolS1;
		VolumeSize = (double)v::LotS1;
		MyComment = (string)v::TicketS1;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 11 (Custom MQL4 codere-save variables into file)
class Block10: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "11";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM1);
	FileWrite(handle,v::TypeM1);
	FileWrite(handle,v::LotM1);
	FileWrite(handle,v::SymbolM1);
	FileWrite(handle,v::ActionM1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 12 (Modify Variables)
class Block11: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "12";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(11);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM1 = _Value1_();
		v::SymbolM1 = _Value2_();
		v::LotM1 = _Value3_();
		v::TypeM1 = _Value4_();
		v::ActionM1 = _Value5_();
	}
};

// Block 13 (Custom MQL4 codere-save variables into file)
class Block12: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "13";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM1);
	FileWrite(handle,v::TypeM1);
	FileWrite(handle,v::LotM1);
	FileWrite(handle,v::SymbolM1);
	FileWrite(handle,v::ActionM1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 14 (Modify Variables)
class Block13: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "14";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {12};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[12].run(13);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM1 = _Value1_();
		v::SymbolM1 = _Value2_();
		v::LotM1 = _Value3_();
		v::TypeM1 = _Value4_();
		v::ActionM1 = _Value5_();
	}
};

// Block 15 (Modify Variables)
class Block14: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "15";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Mode = 1;
		Value5.Value = 2.0;
	}

	public: /* Custom methods */
	virtual int _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[25].run(14);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM2 = _Value1_();
		v::SymbolM2 = _Value2_();
		v::LotM2 = _Value3_();
		v::TypeM2 = _Value4_();
		v::ActionM2 = _Value5_();
	}
};

// Block 16 (Open)
class Block15: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "16";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionM1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(15);
		}
	}
};

// Block 17 (Close)
class Block16: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "17";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionM2;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(16);
		}
	}
};

// Block 18 (Trade closed)
class Block17: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "18";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[14].run(17);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 19 (Trade closed)
class Block18: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "19";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {143};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[143].run(18);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 20 (If Client)
class Block19: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "20";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {23,24};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[23].run(19);
		}
		else if (value == 1) {
			_blocks_[24].run(19);
		}
	}
};

// Block 21 (If trade)
class Block20: public MDL_IfOpenedOrders<string,string,string,string,string>
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
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[21].run(20);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketS2;
		Symbol = (string)v::SymbolS2;
	}
};

// Block 22 (Close trades)
class Block21: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(21);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketS2;
		Symbol = (string)v::SymbolS2;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 23 (Counter: Pass once)
class Block22: public MDL_PassOnce<int>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "23";


		// Fill the list of outbound blocks
		int ___outbound_blocks[6] = {122,124,126,13,73,75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(22);
			_blocks_[73].run(22);
			_blocks_[75].run(22);
			_blocks_[122].run(22);
			_blocks_[124].run(22);
			_blocks_[126].run(22);
		}
	}
};

// Block 24 (Master)
class Block23: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Text = "MASTER";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(23);
		}
	}

	virtual void _beforeExecute_()
	{
		v::MasterOrClient = _Value1_();
	}
};

// Block 25 (CLIENT)
class Block24: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "25";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Text = "CLIENT";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(24);
		}
	}

	virtual void _beforeExecute_()
	{
		v::MasterOrClient = _Value1_();
	}
};

// Block 26 (If MASTER)
class Block25: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "26";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(25);
		}
	}
};

// Block 27 (Modify Variables)
class Block26: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrComment,string,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "27";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value5.Value = 3.0;
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(26);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM3 = _Value1_();
		v::SymbolM3 = _Value2_();
		v::LotM3 = _Value3_();
		v::TypeM3 = _Value4_();
		v::ActionM3 = _Value5_();
	}
};

// Block 28 (Trade closed)
class Block27: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "28";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {26};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[26].run(27);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 29 (Trade closed)
class Block28: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "29";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {144};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[144].run(28);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 30 (If Client)
class Block29: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "30";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[71].run(29);
		}
	}
};

// Block 31 (If Client)
class Block30: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "31";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {16};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[16].run(30);
		}
	}
};

// Block 32 (Close)
class Block31: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "32";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 3.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionM3;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(31);
		}
	}
};

// Block 33 (If Client)
class Block32: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "33";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {31};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[31].run(32);
		}
	}
};

// Block 34 (For each Trade)
class Block33: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
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
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[34].run(33);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)v::SymbolS3;
	}
};

// Block 35 (Check Ticket)
class Block34: public MDL_Condition<MDLIC_inloop_OrderTicket,ulong,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "35";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {35};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual ulong _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = v::TicketS3;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[35].run(34);
		}
	}
};

// Block 36 (close)
class Block35: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "36";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {132};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[132].run(35);
		}
	}

	virtual void _beforeExecute_()
	{
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 37 (Pass)
class Block36: public MDL_Pass
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "37";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(36);
		}
	}
};

// Block 38 (Change Timer period)
class Block37: public MDL_eTimer_ChangePeriod<double,double,double>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "38";
		_beforeExecuteEnabled = true;
		// Block input parameters
		SetMinutes = 0.0;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		SetSeconds = (double)c::Second;
	}
};

// Block 39 (Condition)
class Block38: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "39";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {39};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TicketM1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[39].run(38);
		}
	}
};

// Block 40 (Condition)
class Block39: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "40";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::TypeM1;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[40].run(39);
		}
	}
};

// Block 41 (Condition)
class Block40: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "41";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {41};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::ActionM1;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[41].run(40);
		}
	}
};

// Block 42 (If Client)
class Block41: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "42";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(41);
		}
	}
};

// Block 43 (Comment)
class Block42: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_text_text,string,string,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "43";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value6.Text = "";
		Value7.Text = "";
		Value8.Text = "";
		// Block input parameters
		ObjTitleFontSize = 10;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::TicketM1;

		return Value1._execute_();
	}
	virtual string _Value2_() {
		Value2.Text = v::TypeM1;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::LotM1;

		return Value3._execute_();
	}
	virtual string _Value4_() {
		Value4.Text = v::SymbolM1;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::ActionM1;

		return Value5._execute_();
	}
	virtual string _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(42);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjY = 24;
		Title = (string)v::MasterOrClient;
		ObjCorner = (int)CORNER_RIGHT_UPPER;
		ObjTitleFontColor = (color)clrGold;
		ObjLabelsFontColor = (color)clrDarkGray;
		ObjFontColor = (color)clrWhite;
	}
};

// Block 44 (Master Sell)
class Block43: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "44";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {20};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeS2;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(43);
		}
	}
};

// Block 45 (Master Sell)
class Block44: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "45";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {33};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeS3;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[33].run(44);
		}
	}
};

// Block 46 (If MASTER)
class Block45: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "46";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(45);
		}
	}
};

// Block 47 (Custom MQL4 codere-save variables into file)
class Block46: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "47";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM1);
	FileWrite(handle,v::TypeM1);
	FileWrite(handle,v::LotM1);
	FileWrite(handle,v::SymbolM1);
	FileWrite(handle,v::ActionM1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 48 (Modify Variables)
class Block47: public MDL_ModifyVariables<int,MDLIC_inloop_OrderTicket,ulong,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "48";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual ulong _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.ModeVolume = SEL_CURRENT;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(47);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM1 = _Value1_();
		v::SymbolM1 = _Value2_();
		v::LotM1 = _Value3_();
		v::TypeM1 = _Value4_();
		v::ActionM1 = _Value5_();
	}
};

// Block 49 (If MASTER)
class Block48: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "49";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[67].run(48);
		}
	}
};

// Block 50 (If Client)
class Block49: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "50";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(49);
		}
	}
};

// Block 51 (If MASTER)
class Block50: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "51";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(50);
		}
	}
};

// Block 52 (For each Position)
class Block51: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "52";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(51);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 53 (once per position/order)
class Block52: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "53";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {47};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[47].run(52);
		}
	}
};

// Block 54 (For each Closed Position)
class Block53: public MDL_LoopStartHistoryTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "54";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(53);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 55 (once per position/order)
class Block54: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "55";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {57};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[57].run(54);
		}
	}
};

// Block 56 (For each Closed Position)
class Block55: public MDL_LoopStartHistoryTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "56";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[56].run(55);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 57 (once per position/order)
class Block56: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "57";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {58};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[58].run(56);
		}
	}
};

// Block 58 (Modify Variables)
class Block57: public MDL_ModifyVariables<int,MDLIC_inloop_OrderTicket,ulong,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "58";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {48};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Mode = 1;
		Value5.Value = 2.0;
	}

	public: /* Custom methods */
	virtual ulong _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.ModeVolume = SEL_CURRENT;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[48].run(57);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM2 = _Value1_();
		v::SymbolM2 = _Value2_();
		v::LotM2 = _Value3_();
		v::TypeM2 = _Value4_();
		v::ActionM2 = _Value5_();
	}
};

// Block 59 (Modify Variables)
class Block58: public MDL_ModifyVariables<int,MDLIC_inloop_OrderComment,string,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "59";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value5.Value = 3.0;
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.ModeVolume = SEL_CURRENT;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[49].run(58);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM3 = _Value1_();
		v::SymbolM3 = _Value2_();
		v::LotM3 = _Value3_();
		v::TypeM3 = _Value4_();
		v::ActionM3 = _Value5_();
	}
};

// Block 60 (Custom MQL4 codere-read variables from file)
class Block59: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "60";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {60};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(59);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen(c::BuyCLOSE2,FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,0);
	i++;
}

FileClose(handle);


v::TicketM2 = (double)strArr[0];
v::TypeM2 = (double)strArr[1];
v::LotM2 = (double)strArr[2];
v::SymbolM2 = (string)strArr[3];
v::ActionM2 = (double)strArr[4];
	}
};

// Block 61 (Condition)
class Block60: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "61";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TicketM2;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[61].run(60);
		}
	}
};

// Block 62 (Condition)
class Block61: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "62";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {62};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::TypeM2;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[62].run(61);
		}
	}
};

// Block 63 (Condition)
class Block62: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "63";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::ActionM2;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[30].run(62);
		}
	}
};

// Block 64 (Custom MQL4 codere-read variables from file)
class Block63: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "64";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(63);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen(c::BuyCLOSE3,FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,0);
	i++;
}

FileClose(handle);


v::TicketM3 = (double)strArr[0];
v::TypeM3 = (double)strArr[1];
v::LotM3 = (double)strArr[2];
v::SymbolM3 = (string)strArr[3];
v::ActionM3 = (double)strArr[4];
	}
};

// Block 65 (Condition)
class Block64: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "65";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {65};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TicketM3;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[65].run(64);
		}
	}
};

// Block 66 (Condition)
class Block65: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "66";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {66};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::TypeM3;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[66].run(65);
		}
	}
};

// Block 67 (Condition)
class Block66: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "67";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::ActionM3;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[32].run(66);
		}
	}
};

// Block 68 (Custom MQL4 codere-save variables into file)
class Block67: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "68";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM2);
	FileWrite(handle,v::TypeM2);
	FileWrite(handle,v::LotM2);
	FileWrite(handle,v::SymbolM2);
	FileWrite(handle,v::ActionM2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 69 (Custom MQL4 codere-save variables into file)
class Block68: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "69";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM3);
	FileWrite(handle,v::TypeM3);
	FileWrite(handle,v::LotM3);
	FileWrite(handle,v::SymbolM3);
	FileWrite(handle,v::ActionM3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 70 (Custom MQL4 codere-save variables into file)
class Block69: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "70";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM1);
	FileWrite(handle,v::TypeM1);
	FileWrite(handle,v::LotM1);
	FileWrite(handle,v::SymbolM1);
	FileWrite(handle,v::ActionM1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 71 (Custom MQL4 codere-save variables into file)
class Block70: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "71";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM2);
	FileWrite(handle,v::TypeM2);
	FileWrite(handle,v::LotM2);
	FileWrite(handle,v::SymbolM2);
	FileWrite(handle,v::ActionM2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 72 (Custom MQL4 codere-save variables into file)
class Block71: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "72";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM3);
	FileWrite(handle,v::TypeM3);
	FileWrite(handle,v::LotM3);
	FileWrite(handle,v::SymbolM3);
	FileWrite(handle,v::ActionM3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 73 (Custom MQL4 codere-save variables into file)
class Block72: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "73";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM2);
	FileWrite(handle,v::TypeM2);
	FileWrite(handle,v::LotM2);
	FileWrite(handle,v::SymbolM2);
	FileWrite(handle,v::ActionM2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 74 (Modify Variables)
class Block73: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "74";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {72};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[72].run(73);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM2 = _Value1_();
		v::SymbolM2 = _Value2_();
		v::LotM2 = _Value3_();
		v::TypeM2 = _Value4_();
		v::ActionM2 = _Value5_();
	}
};

// Block 75 (Custom MQL4 codere-save variables into file)
class Block74: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "75";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM3);
	FileWrite(handle,v::TypeM3);
	FileWrite(handle,v::LotM3);
	FileWrite(handle,v::SymbolM3);
	FileWrite(handle,v::ActionM3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 76 (Modify Variables)
class Block75: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "76";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[74].run(75);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM3 = _Value1_();
		v::SymbolM3 = _Value2_();
		v::LotM3 = _Value3_();
		v::TypeM3 = _Value4_();
		v::ActionM3 = _Value5_();
	}
};

// Block 77 (Custom MQL4 codere-save variables into file)
class Block76: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "77";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM2);
	FileWrite(handle,v::TypeM2);
	FileWrite(handle,v::LotM2);
	FileWrite(handle,v::SymbolM2);
	FileWrite(handle,v::ActionM2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 78 (Modify Variables)
class Block77: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "78";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(77);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM2 = _Value1_();
		v::SymbolM2 = _Value2_();
		v::LotM2 = _Value3_();
		v::TypeM2 = _Value4_();
		v::ActionM2 = _Value5_();
	}
};

// Block 79 (Custom MQL4 codere-save variables into file)
class Block78: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "79";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::BuyCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM3);
	FileWrite(handle,v::TypeM3);
	FileWrite(handle,v::LotM3);
	FileWrite(handle,v::SymbolM3);
	FileWrite(handle,v::ActionM3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 80 (Modify Variables)
class Block79: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "80";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {78};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[78].run(79);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM3 = _Value1_();
		v::SymbolM3 = _Value2_();
		v::LotM3 = _Value3_();
		v::TypeM3 = _Value4_();
		v::ActionM3 = _Value5_();
	}
};

// Block 81 (Comment (ugly))
class Block80: public MDL_CommentAdvanced<string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "81";


		// IC input parameters
		CommentValue16.Value = 0.0;
		CommentValue17.Value = 0.0;
		CommentValue18.Value = 0.0;
		CommentValue19.Value = 0.0;
		CommentValue20.Value = 0.0;
		// Block input parameters
		CommentTitle = "Signal";
		CommentLabel1 = "Ticket1";
		CommentLabel2 = "Type1";
		CommentLabel3 = "Lot1";
		CommentLabel4 = "Symbol1";
		CommentLabel5 = "Action1";
		CommentLabel6 = "Ticket2";
		CommentLabel7 = "Type2";
		CommentLabel8 = "Lot2";
		CommentLabel9 = "Symbol2";
		CommentLabel10 = "Action2";
		CommentLabel11 = "Ticket3";
		CommentLabel12 = "Type3";
		CommentLabel13 = "Lot3";
		CommentLabel14 = "Symbol3";
		CommentLabel15 = "Action3";
	}

	public: /* Custom methods */
	virtual double _CommentValue1_() {
		CommentValue1.Value = v::TicketM1;

		return CommentValue1._execute_();
	}
	virtual double _CommentValue2_() {
		CommentValue2.Value = v::TypeM1;

		return CommentValue2._execute_();
	}
	virtual double _CommentValue3_() {
		CommentValue3.Value = v::LotM1;

		return CommentValue3._execute_();
	}
	virtual string _CommentValue4_() {
		CommentValue4.Text = v::SymbolM1;

		return CommentValue4._execute_();
	}
	virtual double _CommentValue5_() {
		CommentValue5.Value = v::ActionM1;

		return CommentValue5._execute_();
	}
	virtual double _CommentValue6_() {
		CommentValue6.Value = v::TicketM2;

		return CommentValue6._execute_();
	}
	virtual double _CommentValue7_() {
		CommentValue7.Value = v::TypeM2;

		return CommentValue7._execute_();
	}
	virtual double _CommentValue8_() {
		CommentValue8.Value = v::LotM2;

		return CommentValue8._execute_();
	}
	virtual string _CommentValue9_() {
		CommentValue9.Text = v::SymbolM2;

		return CommentValue9._execute_();
	}
	virtual double _CommentValue10_() {
		CommentValue10.Value = v::ActionM2;

		return CommentValue10._execute_();
	}
	virtual double _CommentValue11_() {
		CommentValue11.Value = v::TicketM3;

		return CommentValue11._execute_();
	}
	virtual double _CommentValue12_() {
		CommentValue12.Value = v::TypeM3;

		return CommentValue12._execute_();
	}
	virtual double _CommentValue13_() {
		CommentValue13.Value = v::LotM3;

		return CommentValue13._execute_();
	}
	virtual string _CommentValue14_() {
		CommentValue14.Text = v::SymbolM3;

		return CommentValue14._execute_();
	}
	virtual double _CommentValue15_() {
		CommentValue15.Value = v::ActionM3;

		return CommentValue15._execute_();
	}
	virtual double _CommentValue16_() {return CommentValue16._execute_();}
	virtual double _CommentValue17_() {return CommentValue17._execute_();}
	virtual double _CommentValue18_() {return CommentValue18._execute_();}
	virtual double _CommentValue19_() {return CommentValue19._execute_();}
	virtual double _CommentValue20_() {return CommentValue20._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 82 (Custom MQL4 codere-read variables from file)
class Block81: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "82";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(81);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen(c::SellOPEN1,FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,0);
	i++;
}

FileClose(handle);


v::TicketS1 = (double)strArr[0];
v::TypeS1 = (double)strArr[1];
v::LotS1 = (double)strArr[2];
v::SymbolS1 = (string)strArr[3];
v::ActionS1 = (double)strArr[4];
	}
};

// Block 83 (No trade)
class Block82: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "83";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(82);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketS1;
		Symbol = (string)v::SymbolS1;
	}
};

// Block 84 (Sell now)
class Block83: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "84";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {11};
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
			_blocks_[11].run(83);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketM1;
		Symbol = (string)v::SymbolM1;
		VolumeSize = (double)v::LotM1;
		MyComment = (string)v::TicketM1;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 85 (Master Buy)
class Block84: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "85";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[83].run(84);
		}
	}
};

// Block 86 (Open)
class Block85: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "86";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {82};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionS1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[82].run(85);
		}
	}
};

// Block 87 (Close)
class Block86: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "87";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionS2;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(86);
		}
	}
};

// Block 88 (If trade)
class Block87: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "88";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(87);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketM2;
		Symbol = (string)v::SymbolM2;
	}
};

// Block 89 (Close trades)
class Block88: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "89";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(88);
		}
	}

	virtual void _beforeExecute_()
	{
		Group = (string)v::TicketM2;
		Symbol = (string)v::SymbolM2;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 90 (If Client)
class Block89: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "90";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[86].run(89);
		}
	}
};

// Block 91 (Close)
class Block90: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "91";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 3.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionS3;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(90);
		}
	}
};

// Block 92 (If Client)
class Block91: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "92";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[90].run(91);
		}
	}
};

// Block 93 (For each Trade)
class Block92: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "93";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {93};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[93].run(92);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)v::SymbolM3;
	}
};

// Block 94 (Check Ticket)
class Block93: public MDL_Condition<MDLIC_inloop_OrderTicket,ulong,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "94";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual ulong _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = v::TicketM3;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[94].run(93);
		}
	}
};

// Block 95 (close)
class Block94: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "95";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[79].run(94);
		}
	}

	virtual void _beforeExecute_()
	{
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 96 (Condition)
class Block95: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "96";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TicketS1;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(95);
		}
	}
};

// Block 97 (Condition)
class Block96: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "97";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::TypeS1;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(96);
		}
	}
};

// Block 98 (Condition)
class Block97: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "98";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::ActionS1;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(97);
		}
	}
};

// Block 99 (If Client)
class Block98: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "99";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(98);
		}
	}
};

// Block 100 (Master Buy)
class Block99: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "100";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM2;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(99);
		}
	}
};

// Block 101 (Master Buy)
class Block100: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "101";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM3;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(100);
		}
	}
};

// Block 102 (Custom MQL4 codere-read variables from file)
class Block101: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "102";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(101);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen(c::SellCLOSE2,FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,0);
	i++;
}

FileClose(handle);


v::TicketS2 = (double)strArr[0];
v::TypeS2 = (double)strArr[1];
v::LotS2 = (double)strArr[2];
v::SymbolS2 = (string)strArr[3];
v::ActionS2 = (double)strArr[4];
	}
};

// Block 103 (Condition)
class Block102: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "103";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TicketS2;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(102);
		}
	}
};

// Block 104 (Condition)
class Block103: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "104";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::TypeS2;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(103);
		}
	}
};

// Block 105 (Condition)
class Block104: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "105";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::ActionS2;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[89].run(104);
		}
	}
};

// Block 106 (Custom MQL4 codere-read variables from file)
class Block105: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "106";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(105);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen(c::SellCLOSE3,FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,0);
	i++;
}

FileClose(handle);


v::TicketS3 = (double)strArr[0];
v::TypeS3 = (double)strArr[1];
v::LotS3 = (double)strArr[2];
v::SymbolS3 = (string)strArr[3];
v::ActionS3 = (double)strArr[4];
	}
};

// Block 107 (Condition)
class Block106: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "107";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TicketS3;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(106);
		}
	}
};

// Block 108 (Condition)
class Block107: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "108";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::TypeS3;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[108].run(107);
		}
	}
};

// Block 109 (Condition)
class Block108: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "109";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {91};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "0";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::ActionS3;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[91].run(108);
		}
	}
};

// Block 110 (If MASTER)
class Block109: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "110";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(109);
		}
	}
};

// Block 111 (If Client)
class Block110: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "111";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(110);
		}
	}
};

// Block 112 (If MASTER)
class Block111: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "112";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {133};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[133].run(111);
		}
	}
};

// Block 113 (For each Position)
class Block112: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "113";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(112);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 114 (once per position/order)
class Block113: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "114";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {118};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[118].run(113);
		}
	}
};

// Block 115 (For each Closed Position)
class Block114: public MDL_LoopStartHistoryTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "115";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
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

// Block 116 (once per position/order)
class Block115: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "116";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(115);
		}
	}
};

// Block 117 (For each Closed Position)
class Block116: public MDL_LoopStartHistoryTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "117";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
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

// Block 118 (once per position/order)
class Block117: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "118";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {120};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[120].run(117);
		}
	}
};

// Block 119 (Modify Variables)
class Block118: public MDL_ModifyVariables<int,MDLIC_inloop_OrderTicket,ulong,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "119";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value4.Value = 2.0;
	}

	public: /* Custom methods */
	virtual ulong _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.ModeVolume = SEL_CURRENT;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(118);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS1 = _Value1_();
		v::SymbolS1 = _Value2_();
		v::LotS1 = _Value3_();
		v::TypeS1 = _Value4_();
		v::ActionS1 = _Value5_();
	}
};

// Block 120 (Modify Variables)
class Block119: public MDL_ModifyVariables<int,MDLIC_inloop_OrderTicket,ulong,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "120";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {109};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Mode = 1;
		Value4.Value = 2.0;
		Value5.Value = 2.0;
	}

	public: /* Custom methods */
	virtual ulong _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.ModeVolume = SEL_CURRENT;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[109].run(119);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS2 = _Value1_();
		v::SymbolS2 = _Value2_();
		v::LotS2 = _Value3_();
		v::TypeS2 = _Value4_();
		v::ActionS2 = _Value5_();
	}
};

// Block 121 (Modify Variables)
class Block120: public MDL_ModifyVariables<int,MDLIC_inloop_OrderComment,string,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "121";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value4.Value = 2.0;
		Value5.Value = 3.0;
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.ModeVolume = SEL_CURRENT;

		return Value3._execute_();
	}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[110].run(120);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS3 = _Value1_();
		v::SymbolS3 = _Value2_();
		v::LotS3 = _Value3_();
		v::TypeS3 = _Value4_();
		v::ActionS3 = _Value5_();
	}
};

// Block 122 (Custom MQL4 codere-save variables into file)
class Block121: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "122";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS1);
	FileWrite(handle,v::TypeS1);
	FileWrite(handle,v::LotS1);
	FileWrite(handle,v::SymbolS1);
	FileWrite(handle,v::ActionS1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 123 (Modify Variables)
class Block122: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "123";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[121].run(122);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS1 = _Value1_();
		v::SymbolS1 = _Value2_();
		v::LotS1 = _Value3_();
		v::TypeS1 = _Value4_();
		v::ActionS1 = _Value5_();
	}
};

// Block 124 (Custom MQL4 codere-save variables into file)
class Block123: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "124";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS2);
	FileWrite(handle,v::TypeS2);
	FileWrite(handle,v::LotS2);
	FileWrite(handle,v::SymbolS2);
	FileWrite(handle,v::ActionS2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 125 (Modify Variables)
class Block124: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "125";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[123].run(124);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS2 = _Value1_();
		v::SymbolS2 = _Value2_();
		v::LotS2 = _Value3_();
		v::TypeS2 = _Value4_();
		v::ActionS2 = _Value5_();
	}
};

// Block 126 (Custom MQL4 codere-save variables into file)
class Block125: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "126";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS3);
	FileWrite(handle,v::TypeS3);
	FileWrite(handle,v::LotS3);
	FileWrite(handle,v::SymbolS3);
	FileWrite(handle,v::ActionS3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 127 (Modify Variables)
class Block126: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "127";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(126);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS3 = _Value1_();
		v::SymbolS3 = _Value2_();
		v::LotS3 = _Value3_();
		v::TypeS3 = _Value4_();
		v::ActionS3 = _Value5_();
	}
};

// Block 128 (Custom MQL4 codere-save variables into file)
class Block127: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "128";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS1);
	FileWrite(handle,v::TypeS1);
	FileWrite(handle,v::LotS1);
	FileWrite(handle,v::SymbolS1);
	FileWrite(handle,v::ActionS1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 129 (Modify Variables)
class Block128: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "129";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(128);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS1 = _Value1_();
		v::SymbolS1 = _Value2_();
		v::LotS1 = _Value3_();
		v::TypeS1 = _Value4_();
		v::ActionS1 = _Value5_();
	}
};

// Block 130 (Custom MQL4 codere-save variables into file)
class Block129: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "130";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS2);
	FileWrite(handle,v::TypeS2);
	FileWrite(handle,v::LotS2);
	FileWrite(handle,v::SymbolS2);
	FileWrite(handle,v::ActionS2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 131 (Modify Variables)
class Block130: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "131";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(130);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS2 = _Value1_();
		v::SymbolS2 = _Value2_();
		v::LotS2 = _Value3_();
		v::TypeS2 = _Value4_();
		v::ActionS2 = _Value5_();
	}
};

// Block 132 (Custom MQL4 codere-save variables into file)
class Block131: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "132";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS3);
	FileWrite(handle,v::TypeS3);
	FileWrite(handle,v::LotS3);
	FileWrite(handle,v::SymbolS3);
	FileWrite(handle,v::ActionS3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 133 (Modify Variables)
class Block132: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "133";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(132);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS3 = _Value1_();
		v::SymbolS3 = _Value2_();
		v::LotS3 = _Value3_();
		v::TypeS3 = _Value4_();
		v::ActionS3 = _Value5_();
	}
};

// Block 134 (Custom MQL4 codere-save variables into file)
class Block133: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "134";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS1);
	FileWrite(handle,v::TypeS1);
	FileWrite(handle,v::LotS1);
	FileWrite(handle,v::SymbolS1);
	FileWrite(handle,v::ActionS1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 135 (Custom MQL4 codere-save variables into file)
class Block134: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "135";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS2);
	FileWrite(handle,v::TypeS2);
	FileWrite(handle,v::LotS2);
	FileWrite(handle,v::SymbolS2);
	FileWrite(handle,v::ActionS2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 136 (Custom MQL4 codere-save variables into file)
class Block135: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "136";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS3);
	FileWrite(handle,v::TypeS3);
	FileWrite(handle,v::LotS3);
	FileWrite(handle,v::SymbolS3);
	FileWrite(handle,v::ActionS3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 137 (If MASTER)
class Block136: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "137";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(136);
		}
	}
};

// Block 138 (If Client)
class Block137: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "138";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[141].run(137);
		}
	}
};

// Block 139 (If MASTER)
class Block138: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "139";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {139};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Is_This_Client_Port;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(138);
		}
	}
};

// Block 140 (Custom MQL4 codere-save variables into file)
class Block139: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "140";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellOPEN1,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS1);
	FileWrite(handle,v::TypeS1);
	FileWrite(handle,v::LotS1);
	FileWrite(handle,v::SymbolS1);
	FileWrite(handle,v::ActionS1);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 141 (Custom MQL4 codere-save variables into file)
class Block140: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "141";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE2,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS2);
	FileWrite(handle,v::TypeS2);
	FileWrite(handle,v::LotS2);
	FileWrite(handle,v::SymbolS2);
	FileWrite(handle,v::ActionS2);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 142 (Custom MQL4 codere-save variables into file)
class Block141: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "142";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen(c::SellCLOSE3,FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketS3);
	FileWrite(handle,v::TypeS3);
	FileWrite(handle,v::LotS3);
	FileWrite(handle,v::SymbolS3);
	FileWrite(handle,v::ActionS3);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 143 (Modify Variables)
class Block142: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "143";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value4.Value = 2.0;
	}

	public: /* Custom methods */
	virtual int _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(142);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS1 = _Value1_();
		v::SymbolS1 = _Value2_();
		v::LotS1 = _Value3_();
		v::TypeS1 = _Value4_();
		v::ActionS1 = _Value5_();
	}
};

// Block 144 (Modify Variables)
class Block143: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "144";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {136};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Mode = 1;
		Value4.Value = 2.0;
		Value5.Value = 2.0;
	}

	public: /* Custom methods */
	virtual int _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[136].run(143);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS2 = _Value1_();
		v::SymbolS2 = _Value2_();
		v::LotS2 = _Value3_();
		v::TypeS2 = _Value4_();
		v::ActionS2 = _Value5_();
	}
};

// Block 145 (Modify Variables)
class Block144: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrComment,string,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "145";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value4.Value = 2.0;
		Value5.Value = 3.0;
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(144);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketS3 = _Value1_();
		v::SymbolS3 = _Value2_();
		v::LotS3 = _Value3_();
		v::TypeS3 = _Value4_();
		v::ActionS3 = _Value5_();
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

bool LoadHistoryOrder(int index, string selectby="select_by_pos")
{
	if (selectby == "select_by_pos")
	{
		ulong ticket  = HistoryOrderGetTicket(index);

		if (ticket > 0)
		{
			if (
				   HistoryOrderGetInteger(ticket,ORDER_TYPE) >= 2
				&& HistoryOrderSelect(ticket))
			{
				OrderTicket(ticket);

				LoadedType(4);

				return true;
			}
			else if (
				   HistoryOrderGetInteger(ticket,ORDER_TYPE) < 2
				&& HistoryOrderSelect(HistoryDealGetInteger(ticket, DEAL_POSITION_ID))
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
		if (HistoryOrderSelect(index))
		{
			HistoryDealSelect(index); // Select deal, it will be just one with pos=0
			HistoryDealGetTicket(0); // Load the one and only selected deal

			OrderTicket(index);

			if (HistoryOrderGetInteger(index, ORDER_TYPE) >= 2)
			{
				LoadedType(4);

				return true;
			}
			else
			{
				LoadedType(3);

				return true;
			}
		}
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

bool LoopedResume()
{
	ulong ticket  = attrTicketInLoop();
	int type      = attrTypeInLoop();

	if (ticket > 0 && ticket != OrderTicket())
	{
		     if (type == 1) return LoadPosition(ticket);
		else if (type == 2) return LoadOrder(ticket);
		else if (type == 3) return LoadHistoryOrder((int)ticket,"select_by_ticket");
	}

	return false;
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

ulong attrTicketChild(ulong ticket)
{
	// select the deals for this position only
	bool success = HistorySelectByPosition(ticket);
	
	if (success == false) {
		return ticket;
	}
	
	double parent_volume = HistoryDealGetDouble(ticket, DEAL_VOLUME);

	for (int index = HistoryDealsTotal()-1; index >= 0; index--)
	{
		ulong child_ticket = HistoryDealGetTicket(index);

		if (child_ticket)
		{
			double child_volume = HistoryDealGetDouble(child_ticket, DEAL_VOLUME);

			if (parent_volume == child_volume) {
				return ticket;
			}
			else {
				return child_ticket;
			}

			break;
		}
	}

	return ticket;
}

ulong attrTicketInLoop(ulong ticket=0)
{
	static ulong t;

	if (ticket > 0) {t = ticket;}

	return t;
}

ulong attrTicketParent(long ticket)
{
	ulong retval = 0;

	//-- check if trade is added to volume ----------------------------
	if (PositionSelectByTicket(ticket))
	{
		string comment = PositionGetString(POSITION_COMMENT);
		int p_pos      = StringFind(comment, "[p=");
		
		if (p_pos >= 0)
		{
			string p_tag = StringSubstr(comment,p_pos);
			p_tag        = StringSubstr(p_tag,0,StringFind(p_tag,"]")+1);
			retval       = StringToInteger(StringSubstr(p_tag,3,-1));
		}
	}

	if (retval == 0)
	{
		retval = (ulong)HistoryDealGetInteger(ticket, DEAL_POSITION_ID);
	}

	if (retval == 0)
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