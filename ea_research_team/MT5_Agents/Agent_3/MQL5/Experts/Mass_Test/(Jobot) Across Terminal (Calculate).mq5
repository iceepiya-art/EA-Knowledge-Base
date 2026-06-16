#define OP_BUY 0
#define OP_SELL 1
#define OP_BUYLIMIT 2
#define OP_SELLLIMIT 3
#define OP_BUYSTOP 4
#define OP_SELLSTOP 5
#define MODE_OPEN 0
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_CLOSE 3
#define MODE_VOLUME 4
#define MODE_TIME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1
#define LONG_VALUE 4
#define FLOAT_VALUE 4
#define DOUBLE_VALUE 8
#define CHART_BAR 0
#define CHART_CANDLE 1
#define MODE_ASCEND 1
#define MODE_DESCEND 2
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
#define MODE_CLOSEBY_ALLOWED 34
#define EMPTY -1
#define MODE_MAIN 0
#define MODE_SIGNAL 1
#define MODE_PLUSDI 1
#define MODE_MINUSDI 2
#define MODE_UPPER 1
#define MODE_LOWER 2
#define MODE_GATORJAW 1
#define MODE_GATORTEETH 2
#define MODE_GATORLIPS 3
#define MODE_TENKANSEN 1
#define MODE_KIJUNSEN 2
#define MODE_SENKOUSPANA 3
#define MODE_SENKOUSPANB 4
#define MODE_CHIKOUSPAN 5
#define MODE_CHINKOUSPAN 5
#define OBJPROP_TIME1 2000
#define OBJPROP_PRICE1 2001
#define OBJPROP_TIME2 2002
#define OBJPROP_PRICE2 2003
#define OBJPROP_TIME3 2004
#define OBJPROP_PRICE3 2005
#define OBJPROP_FIBOLEVELS 2006

//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2020, fxDreema  (//
//+------------------------------------------------------------------------------+//
#property copyright   "Jobot "
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
#define PROJECT_ID "mt4-1861"
//--
// Point Format Rules
#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later
#define ENABLE_SPREAD_METER true
#define ENABLE_STATUS true
#define ENABLE_TEST_INDICATORS true
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
#define ON_TRADE_REALTIME 0 //
#define ON_TIMER_PERIOD 0.01 // Timer event period (in seconds)

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
input bool MASTER = true;input string Comment = "Jobot";input int MagicStart = 789565; // Magic Number, kind of...
class c
{
		public:
	static bool MASTER;
	static string Comment;
	static int MagicStart;
};
bool c::MASTER;
string c::Comment;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double LotMasterB;
	static double LotMasterS;
	static double LotClientB;
	static double LotClientS;
	static double LotDiffSB;
	static double LotDiffBS;
	static double TicketM;
	static double TypeM;
	static double LotM;
	static string SymbolM;
	static double ActionM;
	static int NB;
	static int NS;
	static string MasterOrClient;
	static int BUY;
	static int SELL;
	static string CommentX;
};
double v::LotMasterB;
double v::LotMasterS;
double v::LotClientB;
double v::LotClientS;
double v::LotDiffSB;
double v::LotDiffBS;
double v::TicketM;
double v::TypeM;
double v::LotM;
string v::SymbolM;
double v::ActionM;
int v::NB;
int v::NS;
string v::MasterOrClient;
int v::BUY;
int v::SELL;
string v::CommentX;




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
int FXD_BLOCKS_COUNT        = 129;
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
	c::MASTER = MASTER;
	c::Comment = Comment;
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

	v::LotMasterB = 0.0;
	v::LotMasterS = 0.0;
	v::LotClientB = 0.0;
	v::LotClientS = 0.0;
	v::LotDiffSB = 0.0;
	v::LotDiffBS = 0.0;
	v::TicketM = 0.0;
	v::TypeM = 0.0;
	v::LotM = 0.01;
	v::SymbolM = "";
	v::ActionM = 0.0;
	v::NB = 0;
	v::NS = 0;
	v::MasterOrClient = "";
	v::BUY = 0;
	v::SELL = 0;
	v::CommentX = "";




	Comment("");
	for (int i=ObjectsTotal(ChartID()); i>=0; i--)
	{
		string name = ObjectName(ChartID(),i);
		if (StringSubstr(name,0,8) == "fxd_cmnt") {ObjectDelete(ChartID(),name);}
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
		FXD_CHART_IS_OFFLINE = ChartGetInteger(0,CHART_IS_OFFLINE);
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

	if (ENABLE_EVENT_TRADE) OnTradeListener(); // to load initial database of orders


	//-- Initialize blocks classes
	ArrayResize(_blocks_,129);

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

	// fill the lookup table
	ArrayResize(fxdBlocksLookupTable,ArraySize(_blocks_));
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
	TicksPerSecond(false,true); // Collect ticks per second
	if (USE_VIRTUAL_STOPS) {VirtualStopsDriver();}

	if (OrdersTotal(true)) // this makes things faster
	{
		ExpirationDriver();
		OCODriver(); // Check and close OCO orders
	}
	if (ENABLE_EVENT_TRADE) {OnTradeListener();}


	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}



	return;
}



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on trade events - open, close, modify //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void EventTrade()
{
	//-- run blocks
	int blocks_to_run[] = {15,25};
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
	//-- to simulate ticks in offline charts, Timer is used instead of infinite loop
	//-- the next function checks for changes in price and calls OnTick() manually
	if (FXD_CHART_IS_OFFLINE && RefreshRates()) {
		OnTick();
	}
	if (ON_TRADE_REALTIME == 1) {
		OnTradeListener();
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
	//-- run blocks
	int blocks_to_run[] = {27,31,59,93,94};
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
		Print("Backtested in "+DoubleToString((GetTickCount()-FXD_MILS_INIT_END)/1000,2)+" seconds");
		double tc = GetTickCount()-FXD_MILS_INIT_END;
		if (tc > 0)
		{
			Print("Average ticks per second: "+DoubleToString(FXD_TICKS_FROM_START/tc,0));
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
	ArrayResize(_blocks_,0);

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
			ArrayResize(__inbound_blocks,size + 1);
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
				ArrayResize(_blocks_[block].__inbound_blocks,size + 1);
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
			&& (FilterEventTrade(GroupMode,Group,SymbolMode,Symbol,BuysOrSells))
			)
		{_callback_(1);} else {_callback_(0);}
	}
};

// "Trade closed" model
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
			&& FilterEventTrade(GroupMode,Group,SymbolMode,Symbol,BuysOrSells)
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

// "Condition" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_,typename T4>
class MDL_Condition: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
			if (CompareValues(compare,lo,ro))
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
				if (CompareValues(compare,ro,lo))
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
	T2 Value1; virtual _T2_ _Value1_(){return(_T2_)0;
return 0;
}
	T3 Variable2;
	T4 Value2; virtual _T4_ _Value2_(){return(_T4_)0;
return 0;
}
	T5 Variable3;
	T6 Value3; virtual _T6_ _Value3_(){return(_T6_)0;
return 0;
}
	T7 Variable4;
	T8 Value4; virtual _T8_ _Value4_(){return(_T8_)0;
return 0;
}
	T9 Variable5;
	T10 Value5; virtual _T10_ _Value5_(){return(_T10_)0;
return 0;
}
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
		
			if (TradeSelectByIndex(i,GroupMode,Group,SymbolMode,Symbol,BuysOrSells))
			{
				ArrayResize(list,s+1);
		
				list[s] = (int)OrderTicket();
				s++;
			}
		}
		
		BucketsOfOrders(BucketID,list,pool,true);
		
		if (s > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Comment (ugly)" model
template<typename T1,typename T2,typename T3,typename _T3_,typename T4,typename T5,typename _T5_,typename T6,typename T7,typename _T7_,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename _T11_,typename T12,typename T13,typename _T13_,typename T14,typename T15,typename _T15_,typename T16,typename T17,typename _T17_,typename T18,typename T19,typename _T19_,typename T20,typename T21,typename _T21_,typename T22,typename T23,typename _T23_,typename T24,typename T25,typename _T25_,typename T26,typename T27,typename _T27_,typename T28,typename T29,typename _T29_,typename T30,typename T31,typename _T31_,typename T32,typename T33,typename _T33_,typename T34,typename T35,typename _T35_,typename T36,typename T37,typename _T37_,typename T38,typename T39,typename _T39_,typename T40,typename T41,typename _T41_>
class MDL_CommentAdvanced: public BlockCalls
{
	public: /* Input Parameters */
	T1 CommentTitle;
	T2 CommentLabel1;
	T3 CommentValue1; virtual _T3_ _CommentValue1_(){return(_T3_)0;
return 0;
}
	T4 CommentLabel2;
	T5 CommentValue2; virtual _T5_ _CommentValue2_(){return(_T5_)0;
return 0;
}
	T6 CommentLabel3;
	T7 CommentValue3; virtual _T7_ _CommentValue3_(){return(_T7_)0;
return 0;
}
	T8 CommentLabel4;
	T9 CommentValue4; virtual _T9_ _CommentValue4_(){return(_T9_)0;
return 0;
}
	T10 CommentLabel5;
	T11 CommentValue5; virtual _T11_ _CommentValue5_(){return(_T11_)0;
return 0;
}
	T12 CommentLabel6;
	T13 CommentValue6; virtual _T13_ _CommentValue6_(){return(_T13_)0;
return 0;
}
	T14 CommentLabel7;
	T15 CommentValue7; virtual _T15_ _CommentValue7_(){return(_T15_)0;
return 0;
}
	T16 CommentLabel8;
	T17 CommentValue8; virtual _T17_ _CommentValue8_(){return(_T17_)0;
return 0;
}
	T18 CommentLabel9;
	T19 CommentValue9; virtual _T19_ _CommentValue9_(){return(_T19_)0;
return 0;
}
	T20 CommentLabel10;
	T21 CommentValue10; virtual _T21_ _CommentValue10_(){return(_T21_)0;
return 0;
}
	T22 CommentLabel11;
	T23 CommentValue11; virtual _T23_ _CommentValue11_(){return(_T23_)0;
return 0;
}
	T24 CommentLabel12;
	T25 CommentValue12; virtual _T25_ _CommentValue12_(){return(_T25_)0;
return 0;
}
	T26 CommentLabel13;
	T27 CommentValue13; virtual _T27_ _CommentValue13_(){return(_T27_)0;
return 0;
}
	T28 CommentLabel14;
	T29 CommentValue14; virtual _T29_ _CommentValue14_(){return(_T29_)0;
return 0;
}
	T30 CommentLabel15;
	T31 CommentValue15; virtual _T31_ _CommentValue15_(){return(_T31_)0;
return 0;
}
	T32 CommentLabel16;
	T33 CommentValue16; virtual _T33_ _CommentValue16_(){return(_T33_)0;
return 0;
}
	T34 CommentLabel17;
	T35 CommentValue17; virtual _T35_ _CommentValue17_(){return(_T35_)0;
return 0;
}
	T36 CommentLabel18;
	T37 CommentValue18; virtual _T37_ _CommentValue18_(){return(_T37_)0;
return 0;
}
	T38 CommentLabel19;
	T39 CommentValue19; virtual _T39_ _CommentValue19_(){return(_T39_)0;
return 0;
}
	T40 CommentLabel20;
	T41 CommentValue20; virtual _T41_ _CommentValue20_(){return(_T41_)0;
return 0;
}
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
		
			ChartSetString(0,CHART_COMMENT,text);
		}
		
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
	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;
return 0;
}
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
	T36 dlStopLoss; virtual _T36_ _dlStopLoss_(){return(_T36_)0;
return 0;
}
	T37 dpStopLoss; virtual _T37_ _dpStopLoss_(){return(_T37_)0;
return 0;
}
	T38 ddStopLoss; virtual _T38_ _ddStopLoss_(){return(_T38_)0;
return 0;
}
	T39 TakeProfitMode;
	T40 TakeProfitPips;
	T41 TakeProfitPercentPrice;
	T42 TakeProfitPercentSL;
	T43 dlTakeProfit; virtual _T43_ _dlTakeProfit_(){return(_T43_)0;
return 0;
}
	T44 dpTakeProfit; virtual _T44_ _dpTakeProfit_(){return(_T44_)0;
return 0;
}
	T45 ddTakeProfit; virtual _T45_ _ddTakeProfit_(){return(_T45_)0;
return 0;
}
	T46 ExpMode;
	T47 ExpDays;
	T48 ExpHours;
	T49 ExpMinutes;
	T50 dExp; virtual _T50_ _dExp_(){return(_T50_)0;
return 0;
}
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
		   if (tpl > 0) {slp = toPips(MathAbs(SymbolAsk(Symbol) - tpl),Symbol)*StopLossPercentTP/100;}
		}
		if (TakeProfitMode == "percentSL") {
		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
		   if (sll > 0) {tpp = toPips(MathAbs(SymbolAsk(Symbol) - sll),Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {
			pre_sll = SymbolAsk(Symbol);
		}
		
		double pre_sl_pips = toPips(SymbolAsk(Symbol)-(pre_sll-toDigits(slp,Symbol)),Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol,VolumeMode,VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol,VolumeMode,VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol,VolumeMode,VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol,VolumeMode,VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol,VolumeMode,VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol,VolumeMode,VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol,VolumeMode,VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol,VolumeMode,VolumeRisk,pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol,VolumeMode,VolumeRisk,pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol,VolumeMode,VolumeRisk,pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol,VolumeMode,VolumeSizeRisk,pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol,VolumeMode,FixedRatioUnitSize,FixedRatioDelta);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		else if (VolumeMode == "1326")             {lots = Bet1326(Group,Symbol,mm1326InitialLots,mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group,Symbol,mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group,Symbol,mmDalembertInitialLots,mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group,Symbol,mmLabouchereInitialLots,mmLabouchereList,mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group,Symbol,mmMgInitialLots,mmMgMultiplyOnLoss,mmMgMultiplyOnProfit,mmMgAddLotsOnLoss,mmMgAddLotsOnProfit,mmMgResetOnLoss,mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group,Symbol,mmSeqBaseLots,mmSeqOnLoss,mmSeqOnProfit,mmSeqReverse);}
		
		lots = AlignLots(Symbol,lots,0,VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = BuyNow(Symbol,lots,sll,tpl,slp,tpp,Slippage,(MagicStart+(int)Group),MyComment,ArrowColorBuy,exp);
		
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
	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;
return 0;
}
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
	T36 dlStopLoss; virtual _T36_ _dlStopLoss_(){return(_T36_)0;
return 0;
}
	T37 dpStopLoss; virtual _T37_ _dpStopLoss_(){return(_T37_)0;
return 0;
}
	T38 ddStopLoss; virtual _T38_ _ddStopLoss_(){return(_T38_)0;
return 0;
}
	T39 TakeProfitMode;
	T40 TakeProfitPips;
	T41 TakeProfitPercentPrice;
	T42 TakeProfitPercentSL;
	T43 dlTakeProfit; virtual _T43_ _dlTakeProfit_(){return(_T43_)0;
return 0;
}
	T44 dpTakeProfit; virtual _T44_ _dpTakeProfit_(){return(_T44_)0;
return 0;
}
	T45 ddTakeProfit; virtual _T45_ _ddTakeProfit_(){return(_T45_)0;
return 0;
}
	T46 ExpMode;
	T47 ExpDays;
	T48 ExpHours;
	T49 ExpMinutes;
	T50 dExp; virtual _T50_ _dExp_(){return(_T50_)0;
return 0;
}
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
		   if (tpl > 0) {slp = toPips(MathAbs(SymbolBid(Symbol) - tpl),Symbol)*StopLossPercentTP/100;}
		}
		if (TakeProfitMode == "percentSL") {
		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
		   if (sll > 0) {tpp = toPips(MathAbs(SymbolBid(Symbol) - sll),Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {
			pre_sll = SymbolBid(Symbol);
		}
		
		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-SymbolBid(Symbol),Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol,VolumeMode,VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol,VolumeMode,VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol,VolumeMode,VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol,VolumeMode,VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol,VolumeMode,VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol,VolumeMode,VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol,VolumeMode,VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol,VolumeMode,VolumeRisk,pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol,VolumeMode,VolumeRisk,pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol,VolumeMode,VolumeRisk,pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol,VolumeMode,VolumeSizeRisk,pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol,VolumeMode,FixedRatioUnitSize,FixedRatioDelta);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		else if (VolumeMode == "1326")             {lots = Bet1326(Group,Symbol,mm1326InitialLots,mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group,Symbol,mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group,Symbol,mmDalembertInitialLots,mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group,Symbol,mmLabouchereInitialLots,mmLabouchereList,mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group,Symbol,mmMgInitialLots,mmMgMultiplyOnLoss,mmMgMultiplyOnProfit,mmMgAddLotsOnLoss,mmMgAddLotsOnProfit,mmMgResetOnLoss,mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group,Symbol,mmSeqBaseLots,mmSeqOnLoss,mmSeqOnProfit,mmSeqReverse);}
		
		lots = AlignLots(Symbol,lots,0,VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = SellNow(Symbol,lots,sll,tpl,slp,tpp,Slippage,(MagicStart+(int)Group),MyComment,ArrowColorSell,exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
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
	T16 Value1; virtual _T16_ _Value1_(){return(_T16_)0;
return 0;
}
	T17 Label2;
	T18 Value2; virtual _T18_ _Value2_(){return(_T18_)0;
return 0;
}
	T19 Label3;
	T20 Value3; virtual _T20_ _Value3_(){return(_T20_)0;
return 0;
}
	T21 Label4;
	T22 Value4; virtual _T22_ _Value4_(){return(_T22_)0;
return 0;
}
	T23 Label5;
	T24 Value5; virtual _T24_ _Value5_(){return(_T24_)0;
return 0;
}
	T25 Label6;
	T26 Value6; virtual _T26_ _Value6_(){return(_T26_)0;
return 0;
}
	T27 Label7;
	T28 Value7; virtual _T28_ _Value7_(){return(_T28_)0;
return 0;
}
	T29 Label8;
	T30 Value8; virtual _T30_ _Value8_(){return(_T30_)0;
return 0;
}
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
		
			int subwindow = WindowFindVisible(ObjChartID,ObjChartSubWindow);
		
			if (subwindow >= 0)
			{
				//-- draw comment title
				if ((string)Title != "")
				{
					string nametitle = namebase;
		
					if(ObjectFind(ObjChartID,nametitle) < 0)
					{
						if (!ObjectCreate(ObjChartID,(ENUM_OBJECT)nametitle,OBJ_LABEL,subwindow,0,0,0,0))
						{
							Print(__FUNCTION__,": failed to create text object! Error code = ",GetLastError());
						}
						else
						{
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_FONTSIZE,(int)(ObjTitleFontSize));
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_COLOR,ObjTitleFontColor);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_BACK,0);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_SELECTABLE,1);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_SELECTED,0);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_HIDDEN,1);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_CORNER,ObjCorner);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_ANCHOR,ObjAnchor);
		
							ObjectSetString(ObjChartID,nametitle,OBJPROP_FONT,ObjTitleFont);
		
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_XDISTANCE,ObjX);
							ObjectSetInteger(ObjChartID,nametitle,OBJPROP_YDISTANCE,ObjY);
						}
					}
					else
					{
						ObjX = (int)ObjectGetInteger(ObjChartID,nametitle,OBJPROP_XDISTANCE);
						ObjY = (int)ObjectGetInteger(ObjChartID,nametitle,OBJPROP_YDISTANCE);
					}
		
					ObjectSetString(ObjChartID,nametitle,OBJPROP_TEXT,(string)Title);
		
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
							ObjectDelete(ObjChartID,namelbl);
							ObjectDelete(ObjChartID,name);
						}
		
						continue;
					}
		
					//-- draw initial objects
					if(ObjectFind(ObjChartID,name) < 0)
					{
						if (textlbl == "")
						{
							continue;
						}
		
						if (ObjectCreate(ObjChartID,(ENUM_OBJECT)namelbl,OBJ_LABEL,subwindow,0,0,0,0))
						{
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_CORNER,ObjCorner);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_ANCHOR,ObjAnchor);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_BACK,0);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_SELECTABLE,0);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_SELECTED,0);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_HIDDEN,1);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_FONTSIZE,ObjLabelsFontSize);
							ObjectSetInteger(ObjChartID,namelbl,OBJPROP_COLOR,ObjLabelsFontColor);
							ObjectSetString(ObjChartID,namelbl,OBJPROP_FONT,ObjLabelsFont);
						}
						else
						{
							Print(__FUNCTION__,": failed to create text object! Error code = ",GetLastError());
						}
		
						if (ObjectCreate(ObjChartID,(ENUM_OBJECT)name,OBJ_LABEL,subwindow,0,0,0,0))
						{
							ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);
							ObjectSetInteger(ObjChartID,name,OBJPROP_ANCHOR,ObjAnchor);
							ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,0);
							ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,0);
							ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,0);
							ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,1);
							ObjectSetInteger(ObjChartID,name,OBJPROP_FONTSIZE,ObjFontSize);
							ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjFontColor);
							ObjectSetString(ObjChartID,name,OBJPROP_FONT,ObjFont);
						}
						else
						{
							Print(__FUNCTION__,": failed to create text object! Error code = ",GetLastError());
						}
					}
					else
					{
						if (textlbl == "")
						{
							ObjectDelete(ObjChartID,namelbl);
							ObjectDelete(ObjChartID,name);
							continue;
						}
					}
		
					ObjY  = (int)(ObjY + ObjFontSize + ObjFontSize/2);
		
					//-- update label objects
					ObjectSetInteger(ObjChartID,namelbl,OBJPROP_XDISTANCE,ObjX);
					ObjectSetInteger(ObjChartID,namelbl,OBJPROP_YDISTANCE,ObjY);
					ObjectSetString(ObjChartID,namelbl,OBJPROP_TEXT,(string)textlbl);
		
					//-- update value objects
					int x        = 0;
					int xsizelbl = (int)ObjectGetInteger(ObjChartID,namelbl,OBJPROP_XSIZE);
		
					if (xsizelbl == 0) {
						//-- when the object is newly created, it returns 0 for XSIZE and YSIZE, so here we will trick it somehow
						xsizelbl = (int)(StringLen((string)textlbl) * ObjFontSize / 1.5 + ObjFontSize / 2);
					}
		
					x = ObjX + (xsizelbl + ObjFontSize/2);
		
					ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,x);
					ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);
					ObjectSetString(ObjChartID,name,OBJPROP_TEXT,(string)text);
				}
				
				ChartRedraw();
			}
		
			initialized = true;
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
		int passes = Counter(CounterID,"increment");
		
		if (passes == 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "OR" model
class MDL_LogicalOR: public BlockCalls
{
	/* Static Parameters */
	int old_tick;
	virtual void _callback_(int r) {return;}

	public: /* The main method */
	virtual void _execute_()
	{
		int tickID = FXD_TICKS_FROM_START;
		
		if (old_tick != tickID)
		{
			old_tick = tickID;
		
		   _callback_(1);
		}
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
		StringExplode(",",ResetThisID,list);
		int size = ArraySize(list);
		
		for (int i=0; i<size; i++)
		{
			list[i] = StringTrim(list[i]);
			Counter((int)StringToInteger(list[i]),"reset");
		}
		
		_callback_(1);
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
			if (TradeSelectByIndex(index,GroupMode,Group,SymbolMode,Symbol,BuysOrSells))
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
class MDL_Formula_1: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::NB = formula(compare,lo,ro)+0.001;
		
		_callback_(1);
	}
};

// "Loop (pass "n" times)" model
template<typename T1>
class MDL_Loop: public BlockCalls
{
	public: /* Input Parameters */
	T1 Cycles;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Loop()
	{
		Cycles = (int)3;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		for (int i = 1; i <= Cycles; i++)
		{
			_callback_(1);
		}
		
		_callback_(0);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_2: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::NS = formula(compare,lo,ro)+0.001;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_3: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffSB = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_4: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffBS = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_5: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffSB = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_6: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffBS = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_7: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffSB = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_8: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffBS = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_9: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffSB = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_10: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::LotDiffBS = formula(compare,lo,ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_11: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::NB = formula(compare,lo,ro)+0.001;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_12: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::NS = formula(compare,lo,ro)+0.001;
		
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
				if (!TradeSelectByIndex(pos,GroupMode,Group,SymbolMode,Symbol,BuysOrSells)) continue;
		
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
				if (!TradeSelectByIndex(i,GroupMode,Group,SymbolMode,Symbol,BuysOrSells)) continue;
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
		   success = CloseTrade(OrderTicket(),Slippage,ArrowColor);
		}
		else {
		   success = DeleteOrder(OrderTicket(),ArrowColor);
		}
		
		if (success == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_13: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::NB = formula(compare,lo,ro)+0.001;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_14: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;
return 0;
}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;
return 0;
}
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
		
		v::NS = formula(compare,lo,ro)+0.001;
		
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
		
		   if (InArray(memory,ticket) == false)
			{
		      ArrayEnsureValue(memory,ticket);
		      next = true;
		   }
		}
		
		if (next == true) {_callback_(1);} else {_callback_(0);}
	}
};


//------------------------------------------------------------------------------------------------------------------------

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

// "Group" model
class MDLIC_eventTrade_e_attrGroup
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_eventTrade_e_attrGroup()
	{
	}

	public: /* The main method */
	int _execute_()
	{
		return((int)e_attrGroup());
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
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
			retval = TimeFromComponents(TimeSource,TimeComponentYear,TimeComponentMonth,TimeComponentDay,TimeComponentHour,TimeComponentMinute,TimeComponentSecond);
		}
		else if (ModeTime == 3)
		{
			ArraySetAsSeries(Time,true);
			CopyTime(TimeMarket,TimeCandleTimeframe,TimeCandleID,1,Time);
			retval = iTime(_Symbol,_Period,0);
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
		
			retval = retval + (sh * ((604800 * TimeShiftWeeks) + SecondsFromComponents(TimeShiftDays,TimeShiftHours,TimeShiftMinutes,TimeShiftSeconds)));
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_21
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_21()
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_22
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_22()
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_23
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_23()
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
	}
};

// "Bucket" model
class MDLIC_bucket_bucket_24
{
	public: /* Input Parameters */
	color BucketID;
	int Attribute;
	int PriceMode;
	int ReturnMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_bucket_bucket_24()
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
		size = BucketsOfOrders(BucketID,tickets,pool);
		
		//-- but if the bucket is empty -> quit
		if (size == 0) {
			if (Attribute == 0) {return 0;}
			return EMPTY_VALUE;
		}
		
		ArrayResize(values,ArraySize(tickets));
		
		for (i=0; i<size; i++)
		{
		   if (!OrderSelect(tickets[i],SELECT_BY_TICKET,pool)) {continue;}
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
		      	   values[i] = toPips(MathAbs(OrderOpenPrice()-attrStopLoss()),OrderSymbol());
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
		   	      values[i] = toPips(MathAbs(OrderOpenPrice()-attrTakeProfit()),OrderSymbol());
		   	   }
		   	   else if (PriceMode == 2)
		   	   {
		   	      values[i] = MathAbs(OrderOpenPrice()-attrTakeProfit());
		   	   }
				  	break;
		   	}
		   	case 6: // PRICE_OPEN
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderOpenPrice(),normalize);
				  	break;
		   	}
		   	case 7: // PRICE_CURRENT
		   	{
					normalize = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);
		   	   values[i] = NormalizeDouble(OrderClosePrice(),normalize);
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
		
		if (normalize != -1) {retval = NormalizeDouble(retval,normalize);}
		
		return retval;
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
		return iMA(Symbol,(ENUM_TIMEFRAMES)Period,MAperiod,MAshift,(ENUM_MA_METHOD)MAmethod,(ENUM_APPLIED_PRICE)AppliedPrice,Shift + FXD_MORE_SHIFT);
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
		int ___outbound_blocks[4] = {1,10,57,9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[1].run(0);
			_blocks_[9].run(0);
			_blocks_[10].run(0);
			_blocks_[57].run(0);
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
		ChartOnForeground = 0;
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
		ChartColorForeground = (color)clrWhite;
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
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(3);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 5 (Trade created)
class Block4: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {18};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[18].run(4);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 6 (Trade closed)
class Block5: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(5);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 7 (Trade closed)
class Block6: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {20};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(6);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 8 (Trade closed)
class Block7: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {21};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[21].run(7);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 9 (Trade closed)
class Block8: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[22].run(8);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 10 (Master)
class Block9: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {11};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[11].run(9);
		}
	}
};

// Block 11 (Client)
class Block10: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "11";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[14].run(10);
		}
	}
};

// Block 12 (Modify Variables)
class Block11: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
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
		if (value == 1) {
			_blocks_[12].run(11);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotMasterB = _Value1_();
		v::LotMasterS = _Value2_();
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
		int handle = FileOpen("M_1.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::LotMasterB);
	FileWrite(handle,v::LotMasterS);

}
else {}

FileClose(handle);
	}
};

// Block 14 (Custom MQL4 codere-save variables into file)
class Block13: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "14";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen("C_1.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::LotClientB);
	FileWrite(handle,v::LotClientS);

}
else {}

FileClose(handle);
	}
};

// Block 15 (Modify Variables)
class Block14: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "15";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

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
		if (value == 1) {
			_blocks_[13].run(14);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotClientB = _Value1_();
		v::LotClientS = _Value2_();
	}
};

// Block 16 (Master)
class Block15: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "16";


		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {3,4,5,6};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(15);
			_blocks_[4].run(15);
			_blocks_[5].run(15);
			_blocks_[6].run(15);
		}
	}
};

// Block 17 (Custom MQL4 codere-save variables into file)
class Block16: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "17";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen("Order.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM);
	FileWrite(handle,v::TypeM);
	FileWrite(handle,v::LotM);
	FileWrite(handle,v::SymbolM);
	FileWrite(handle,v::ActionM);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 18 (Modify Variables)
class Block17: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "18";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {16,77};
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
			_blocks_[16].run(17);
			_blocks_[77].run(17);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 19 (Modify Variables)
class Block18: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "19";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {16,78};
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
			_blocks_[16].run(18);
			_blocks_[78].run(18);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 20 (Modify Variables)
class Block19: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "20";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {16,77,91};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
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
			_blocks_[16].run(19);
			_blocks_[77].run(19);
			_blocks_[91].run(19);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 21 (Modify Variables)
class Block20: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrTicket,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "21";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {16,78,92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
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
			_blocks_[16].run(20);
			_blocks_[78].run(20);
			_blocks_[92].run(20);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 22 (Modify Variables)
class Block21: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrGroup,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {16,80,89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value5.Value = 3.0;
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
			_blocks_[16].run(21);
			_blocks_[80].run(21);
			_blocks_[89].run(21);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 23 (Modify Variables)
class Block22: public MDL_ModifyVariables<int,MDLIC_eventTrade_e_attrGroup,int,int,MDLIC_eventTrade_e_attrSymbol,string,int,MDLIC_eventTrade_e_attrLots,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "23";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {16,81,90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value4.Value = 2.0;
		Value5.Value = 3.0;
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
			_blocks_[16].run(22);
			_blocks_[81].run(22);
			_blocks_[90].run(22);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 24 (Trade created)
class Block23: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(23);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 25 (Trade created)
class Block24: public MDL_eTrade_TradeNew<string,string,string,string,string>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "25";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[81].run(24);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 26 (Client)
class Block25: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "26";


		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {23,24,7,8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(25);
			_blocks_[8].run(25);
			_blocks_[23].run(25);
			_blocks_[24].run(25);
		}
	}
};

// Block 27 (Custom MQL4 codere-read variables from file)
class Block26: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "27";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(26);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[2];

int handle = FileOpen("C_1.csv",FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,-1);
	i++;
}

FileClose(handle);


v::LotClientB = (double)strArr[0];
v::LotClientS = (double)strArr[1];
	}
};

// Block 28 (Master)
class Block27: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "28";


		// Fill the list of outbound blocks
		int ___outbound_blocks[6] = {26,28,29,36,67,68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[26].run(27);
			_blocks_[28].run(27);
			_blocks_[29].run(27);
			_blocks_[36].run(27);
			_blocks_[67].run(27);
			_blocks_[68].run(27);
		}
	}
};

// Block 29 (Bucket of Trades)
class Block28: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "29";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[30].run(28);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 30 (Bucket of Trades)
class Block29: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "30";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(29);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 31 (Modify Variables)
class Block30: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_1,double,int,MDLIC_bucket_bucket_2,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "31";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

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
		v::LotMasterB = _Value1_();
	}
};

// Block 32 (Client)
class Block31: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "32";


		// Fill the list of outbound blocks
		int ___outbound_blocks[6] = {32,33,35,37,65,66};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[32].run(31);
			_blocks_[33].run(31);
			_blocks_[35].run(31);
			_blocks_[37].run(31);
			_blocks_[65].run(31);
			_blocks_[66].run(31);
		}
	}
};

// Block 33 (Bucket of Trades)
class Block32: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "33";
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
			_blocks_[34].run(32);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 34 (Bucket of Trades)
class Block33: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "34";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(33);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 35 (Modify Variables)
class Block34: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_3,double,int,MDLIC_bucket_bucket_4,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "35";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

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
		v::LotClientB = _Value1_();
	}
};

// Block 36 (Custom MQL4 codere-read variables from file)
class Block35: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "36";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(35);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[2];

int handle = FileOpen("M_1.csv",FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,-1);
	i++;
}

FileClose(handle);


v::LotMasterB = (double)strArr[0];
v::LotMasterS = (double)strArr[1];
	}
};

// Block 37 (Comment (ugly))
class Block36: public MDL_CommentAdvanced<string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "37";


		// IC input parameters
		CommentValue7.Value = 0.0;
		CommentValue8.Value = 0.0;
		CommentValue9.Value = 0.0;
		CommentValue10.Value = 0.0;
		CommentValue11.Value = 0.0;
		CommentValue12.Value = 0.0;
		CommentValue13.Value = 0.0;
		CommentValue14.Value = 0.0;
		CommentValue15.Value = 0.0;
		CommentValue16.Value = 0.0;
		CommentValue17.Value = 0.0;
		CommentValue18.Value = 0.0;
		CommentValue19.Value = 0.0;
		CommentValue20.Value = 0.0;
		// Block input parameters
		CommentTitle = "Master";
		CommentLabel1 = "Buy Master";
		CommentLabel2 = "Buy Client";
		CommentLabel3 = "Sell Master";
		CommentLabel4 = "Sell Client";
		CommentLabel5 = "BS Dif";
		CommentLabel6 = "SB Dif";
	}

	public: /* Custom methods */
	virtual double _CommentValue1_() {
		CommentValue1.Value = v::LotMasterB;

		return CommentValue1._execute_();
	}
	virtual double _CommentValue2_() {
		CommentValue2.Value = v::LotClientB;

		return CommentValue2._execute_();
	}
	virtual double _CommentValue3_() {
		CommentValue3.Value = v::LotMasterS;

		return CommentValue3._execute_();
	}
	virtual double _CommentValue4_() {
		CommentValue4.Value = v::LotClientS;

		return CommentValue4._execute_();
	}
	virtual double _CommentValue5_() {
		CommentValue5.Value = v::LotDiffBS;

		return CommentValue5._execute_();
	}
	virtual double _CommentValue6_() {
		CommentValue6.Value = v::LotDiffSB;

		return CommentValue6._execute_();
	}
	virtual double _CommentValue7_() {return CommentValue7._execute_();}
	virtual double _CommentValue8_() {return CommentValue8._execute_();}
	virtual double _CommentValue9_() {return CommentValue9._execute_();}
	virtual double _CommentValue10_() {return CommentValue10._execute_();}
	virtual double _CommentValue11_() {return CommentValue11._execute_();}
	virtual double _CommentValue12_() {return CommentValue12._execute_();}
	virtual double _CommentValue13_() {return CommentValue13._execute_();}
	virtual double _CommentValue14_() {return CommentValue14._execute_();}
	virtual double _CommentValue15_() {return CommentValue15._execute_();}
	virtual double _CommentValue16_() {return CommentValue16._execute_();}
	virtual double _CommentValue17_() {return CommentValue17._execute_();}
	virtual double _CommentValue18_() {return CommentValue18._execute_();}
	virtual double _CommentValue19_() {return CommentValue19._execute_();}
	virtual double _CommentValue20_() {return CommentValue20._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 38 (Comment (ugly))
class Block37: public MDL_CommentAdvanced<string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "38";


		// IC input parameters
		CommentValue7.Value = 0.0;
		CommentValue8.Value = 0.0;
		CommentValue9.Value = 0.0;
		CommentValue10.Value = 0.0;
		CommentValue11.Value = 0.0;
		CommentValue12.Value = 0.0;
		CommentValue13.Value = 0.0;
		CommentValue14.Value = 0.0;
		CommentValue15.Value = 0.0;
		CommentValue16.Value = 0.0;
		CommentValue17.Value = 0.0;
		CommentValue18.Value = 0.0;
		CommentValue19.Value = 0.0;
		CommentValue20.Value = 0.0;
		// Block input parameters
		CommentTitle = "Client";
		CommentLabel1 = "Buy Master";
		CommentLabel2 = "Buy Client";
		CommentLabel3 = "Sell Master";
		CommentLabel4 = "Sell Client";
		CommentLabel5 = "BS Dif";
		CommentLabel6 = "SB Dif";
	}

	public: /* Custom methods */
	virtual double _CommentValue1_() {
		CommentValue1.Value = v::LotMasterB;

		return CommentValue1._execute_();
	}
	virtual double _CommentValue2_() {
		CommentValue2.Value = v::LotClientB;

		return CommentValue2._execute_();
	}
	virtual double _CommentValue3_() {
		CommentValue3.Value = v::LotMasterS;

		return CommentValue3._execute_();
	}
	virtual double _CommentValue4_() {
		CommentValue4.Value = v::LotClientS;

		return CommentValue4._execute_();
	}
	virtual double _CommentValue5_() {
		CommentValue5.Value = v::LotDiffBS;

		return CommentValue5._execute_();
	}
	virtual double _CommentValue6_() {
		CommentValue6.Value = v::LotDiffSB;

		return CommentValue6._execute_();
	}
	virtual double _CommentValue7_() {return CommentValue7._execute_();}
	virtual double _CommentValue8_() {return CommentValue8._execute_();}
	virtual double _CommentValue9_() {return CommentValue9._execute_();}
	virtual double _CommentValue10_() {return CommentValue10._execute_();}
	virtual double _CommentValue11_() {return CommentValue11._execute_();}
	virtual double _CommentValue12_() {return CommentValue12._execute_();}
	virtual double _CommentValue13_() {return CommentValue13._execute_();}
	virtual double _CommentValue14_() {return CommentValue14._execute_();}
	virtual double _CommentValue15_() {return CommentValue15._execute_();}
	virtual double _CommentValue16_() {return CommentValue16._execute_();}
	virtual double _CommentValue17_() {return CommentValue17._execute_();}
	virtual double _CommentValue18_() {return CommentValue18._execute_();}
	virtual double _CommentValue19_() {return CommentValue19._execute_();}
	virtual double _CommentValue20_() {return CommentValue20._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 39 (Custom MQL4 codere-read variables from file)
class Block38: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "39";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {47,48,49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[47].run(38);
			_blocks_[48].run(38);
			_blocks_[49].run(38);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[5];

int handle = FileOpen("Order.csv",FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,-1);
	i++;
}

FileClose(handle);


v::TicketM = (double)strArr[0];
v::TypeM = (double)strArr[1];
v::LotM = (double)strArr[2];
v::SymbolM = (string)strArr[3];
v::ActionM = (double)strArr[4];
	}
};

// Block 40 (Master BUY)
class Block39: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "40";


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
		Lo.Value = v::TypeM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[71].run(39);
		}
	}
};

// Block 41 (Buy now)
class Block40: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
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
		Symbol = (string)v::SymbolM;
		VolumeSize = (double)v::LotM;
		MyComment = (string)v::TicketM;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 42 (Sell now)
class Block41: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "42";
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
		Symbol = (string)v::SymbolM;
		VolumeSize = (double)v::LotM;
		MyComment = (string)v::TicketM;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 43 (Modify Variables)
class Block42: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "43";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.01;
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
			_blocks_[64].run(42);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 44 (Master SELL)
class Block43: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "44";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(43);
		}
	}
};

// Block 45 (Open)
class Block44: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "45";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {62};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[62].run(44);
		}
	}
};

// Block 46 (Close)
class Block45: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "46";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[105].run(45);
		}
	}
};

// Block 47 (Close)
class Block46: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "47";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {114};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 3.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ActionM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[114].run(46);
		}
	}
};

// Block 48 (Client)
class Block47: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "48";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(47);
		}
	}
};

// Block 49 (Client)
class Block48: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "49";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(48);
		}
	}
};

// Block 50 (MASTER)
class Block49: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "50";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(49);
		}
	}
};

// Block 51 (Modify Variables)
class Block50: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_5,double,int,MDLIC_bucket_bucket_6,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "51";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

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
		v::LotMasterS = _Value2_();
	}
};

// Block 52 (Modify Variables)
class Block51: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_7,double,int,MDLIC_bucket_bucket_8,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "52";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

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
		v::LotClientS = _Value2_();
	}
};

// Block 53 (Modify Variables)
class Block52: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_bucket_bucket_9,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "53";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

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
		v::LotClientB = _Value1_();
	}
};

// Block 54 (Modify Variables)
class Block53: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_10,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "54";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Value = 0.0;
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
		v::LotClientS = _Value2_();
	}
};

// Block 55 (Modify Variables)
class Block54: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_bucket_bucket_11,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "55";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

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
		v::LotMasterB = _Value1_();
	}
};

// Block 56 (Modify Variables)
class Block55: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_12,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "56";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Value = 0.0;
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
		v::LotMasterS = _Value2_();
	}
};

// Block 57 (Custom MQL4 codere-save variables into file)
class Block56: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "57";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen("Order.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM);
	FileWrite(handle,v::TypeM);
	FileWrite(handle,v::LotM);
	FileWrite(handle,v::SymbolM);
	FileWrite(handle,v::ActionM);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 58 (Modify Variables)
class Block57: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "58";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Text = "";
		Value3.Value = 0.01;
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
			_blocks_[56].run(57);
		}
	}

	virtual void _beforeExecute_()
	{
		v::TicketM = _Value1_();
		v::SymbolM = _Value2_();
		v::LotM = _Value3_();
		v::TypeM = _Value4_();
		v::ActionM = _Value5_();
	}
};

// Block 59 (Comment)
class Block58: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "59";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value8.Text = "";
		// Block input parameters
		ObjTitleFontSize = 15;
		ObjLabelsFontSize = 8;
		ObjFontSize = 8;
		Label1 = "Ticket";
		Label2 = "Type";
		Label3 = "Lot";
		Label4 = "Symbol";
		Label5 = "Action";
		Label6 = "NB";
		Label7 = "NS";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::TicketM;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::TypeM;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::LotM;

		return Value3._execute_();
	}
	virtual string _Value4_() {
		Value4.Text = v::SymbolM;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::ActionM;

		return Value5._execute_();
	}
	virtual double _Value6_() {
		Value6.Value = v::NB;

		return Value6._execute_();
	}
	virtual double _Value7_() {
		Value7.Value = v::NS;

		return Value7._execute_();
	}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
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

// Block 60 (If Client)
class Block59: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "60";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {60,61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::MASTER;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[61].run(59);
		}
		else if (value == 1) {
			_blocks_[60].run(59);
		}
	}
};

// Block 61 (Master)
class Block60: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "61";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {58};
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
			_blocks_[58].run(60);
		}
	}

	virtual void _beforeExecute_()
	{
		v::MasterOrClient = _Value1_();
	}
};

// Block 62 (CLIENT)
class Block61: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "62";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {58};
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
			_blocks_[58].run(61);
		}
	}

	virtual void _beforeExecute_()
	{
		v::MasterOrClient = _Value1_();
	}
};

// Block 63 (Counter: Pass once)
class Block62: public MDL_PassOnce<int>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "63";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {39,43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[39].run(62);
			_blocks_[43].run(62);
		}
	}
};

// Block 66 (OR)
class Block63: public MDL_LogicalOR
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "66";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(63);
		}
	}
};

// Block 67 (Counter: Reset)
class Block64: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "67";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(64);
		}
	}
};

// Block 68 (No trade)
class Block65: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "68";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(65);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 69 (No trade)
class Block66: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "69";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(66);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 70 (No trade)
class Block67: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "70";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(67);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 71 (No trade)
class Block68: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "71";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {55};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[55].run(68);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 72 (Custom MQL4 codere-save variables into file)
class Block69: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "72";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(69);
		}
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen("M_1.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::LotMasterB);
	FileWrite(handle,v::LotMasterS);

}
else {  }

FileClose(handle);
	}
};

// Block 73 (Custom MQL4 codere-save variables into file)
class Block70: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "73";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(70);
		}
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen("C_1.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::LotClientB);
	FileWrite(handle,v::LotClientS);

}
else { }

FileClose(handle);
	}
};

// Block 74 (Formula)
class Block71: public MDL_Formula_1<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "74";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {72};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotDiffSB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotM;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[72].run(71);
		}
	}
};

// Block 75 (Loop (pass \"n\" times))
class Block72: public MDL_Loop<int>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "75";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {40,42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[42].run(72);
		}
		else if (value == 1) {
			_blocks_[40].run(72);
		}
	}

	virtual void _beforeExecute_()
	{
		Cycles = (int)v::NB;
	}
};

// Block 76 (Formula)
class Block73: public MDL_Formula_2<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "76";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotDiffBS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotM;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[74].run(73);
		}
	}
};

// Block 77 (Loop (pass \"n\" times))
class Block74: public MDL_Loop<int>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "77";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {41,42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[42].run(74);
		}
		else if (value == 1) {
			_blocks_[41].run(74);
		}
	}

	virtual void _beforeExecute_()
	{
		Cycles = (int)v::NS;
	}
};

// Block 78 (Custom MQL4 codere-read variables from file)
class Block75: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "78";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(75);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[2];

int handle = FileOpen("C_1.csv",FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,-1);
	i++;
}

FileClose(handle);


v::LotClientB = (double)strArr[0];
v::LotClientS = (double)strArr[1];
	}
};

// Block 79 (Custom MQL4 codere-read variables from file)
class Block76: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "79";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {101};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[101].run(76);
		}
	}

	virtual void _beforeExecute_()
	{
		string strArr[2];

int handle = FileOpen("M_1.csv",FILE_READ|FILE_COMMON,0,CP_UTF8); 


FileSeek(handle,0,SEEK_SET);
int i=0;
while(!FileIsEnding(handle))
{
	if(i>ArraySize(strArr)) { Comment("error: increase size of strArr"); GetLastError(); }
	strArr[i] = FileReadString(handle,-1);
	i++;
}

FileClose(handle);


v::LotMasterB = (double)strArr[0];
v::LotMasterS = (double)strArr[1];
	}
};

// Block 80 (Bucket of Trades)
class Block77: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "80";
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
			_blocks_[79].run(77);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 81 (Bucket of Trades)
class Block78: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "81";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[83].run(78);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 82 (Modify Variables)
class Block79: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_13,double,int,MDLIC_bucket_bucket_14,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "82";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(79);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotMasterB = _Value1_();
	}
};

// Block 83 (Bucket of Trades)
class Block80: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "83";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {82};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[82].run(80);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 84 (Bucket of Trades)
class Block81: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "84";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {84};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(81);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 85 (Modify Variables)
class Block82: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_15,double,int,MDLIC_bucket_bucket_16,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "85";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(82);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotClientB = _Value1_();
	}
};

// Block 86 (Modify Variables)
class Block83: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_17,double,int,MDLIC_bucket_bucket_18,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "86";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(83);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotMasterS = _Value2_();
	}
};

// Block 87 (Modify Variables)
class Block84: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_19,double,int,MDLIC_bucket_bucket_20,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "87";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrGray;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(84);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotClientS = _Value2_();
	}
};

// Block 88 (Modify Variables)
class Block85: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_bucket_bucket_21,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "88";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(85);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotClientB = _Value1_();
	}
};

// Block 89 (Modify Variables)
class Block86: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_22,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "89";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Value = 0.0;
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
		if (value == 1) {
			_blocks_[70].run(86);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotClientS = _Value2_();
	}
};

// Block 90 (Modify Variables)
class Block87: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_bucket_bucket_23,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "90";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {
		Value2.BucketID = clrMagenta;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(87);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotMasterB = _Value1_();
	}
};

// Block 91 (Modify Variables)
class Block88: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_24,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "91";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
		Value2.Value = 0.0;
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
		if (value == 1) {
			_blocks_[69].run(88);
		}
	}

	virtual void _beforeExecute_()
	{
		v::LotMasterS = _Value2_();
	}
};

// Block 92 (No trade)
class Block89: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "92";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(89);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 93 (No trade)
class Block90: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "93";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[86].run(90);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 94 (No trade)
class Block91: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "94";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(91);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 95 (No trade)
class Block92: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "95";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(92);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 98 (Condition)
class Block93: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "98";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {126,63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientS;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[63].run(93);
			_blocks_[126].run(93);
		}
	}
};

// Block 99 (Condition)
class Block94: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "99";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {126,63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[63].run(94);
			_blocks_[126].run(94);
		}
	}
};

// Block 100 (Formula)
class Block95: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "100";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(95);
		}
	}
};

// Block 101 (Formula)
class Block96: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "101";

		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientS;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 102 (Formula)
class Block97: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "102";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(97);
		}
	}
};

// Block 103 (Formula)
class Block98: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "103";

		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientS;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 104 (Formula)
class Block99: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "104";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(99);
		}
	}
};

// Block 105 (Formula)
class Block100: public MDL_Formula_8<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "105";

		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientS;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 106 (Formula)
class Block101: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "106";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientB;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(101);
		}
	}
};

// Block 107 (Formula)
class Block102: public MDL_Formula_10<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "107";

		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotMasterB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotClientS;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 114 (Master BUY)
class Block103: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "114";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(103);
		}
	}
};

// Block 115 (Master SELL)
class Block104: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "115";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(104);
		}
	}
};

// Block 116 (Counter: Pass once)
class Block105: public MDL_PassOnce<int>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "116";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {103,104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CounterID = 2;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(105);
			_blocks_[104].run(105);
		}
	}
};

// Block 117 (Formula)
class Block106: public MDL_Formula_11<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "117";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotDiffSB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotM;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[108].run(106);
		}
	}
};

// Block 118 (Formula)
class Block107: public MDL_Formula_12<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "118";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotDiffBS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotM;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[110].run(107);
		}
	}
};

// Block 119 (For each Trade)
class Block108: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "119";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
		LoopDirection = "profitable-first";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(108);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)v::SymbolM;
		LoopLimit = (int)v::NB;
	}
};

// Block 120 (close)
class Block109: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "120";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(109);
		}
	}

	virtual void _beforeExecute_()
	{
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 121 (For each Trade)
class Block110: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "121";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
		LoopDirection = "profitable-first";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[128].run(110);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)v::SymbolM;
		LoopLimit = (int)v::NS;
	}
};

// Block 122 (close)
class Block111: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "122";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(111);
		}
	}

	virtual void _beforeExecute_()
	{
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 123 (Master BUY)
class Block112: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "123";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM;

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

// Block 124 (Master SELL)
class Block113: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "124";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {116};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::TypeM;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[116].run(113);
		}
	}
};

// Block 125 (Counter: Pass once)
class Block114: public MDL_PassOnce<int>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "125";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {112,113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CounterID = 3;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(114);
			_blocks_[113].run(114);
		}
	}
};

// Block 126 (Formula)
class Block115: public MDL_Formula_13<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "126";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotDiffBS;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotM;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(115);
		}
	}
};

// Block 127 (Formula)
class Block116: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "127";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::LotDiffSB;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::LotM;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(116);
		}
	}
};

// Block 128 (For each Trade)
class Block117: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "128";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
		LoopDirection = "profitable-first";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[123].run(117);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)v::SymbolM;
		LoopLimit = (int)v::NB;
	}
};

// Block 129 (close)
class Block118: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "129";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(118);
		}
	}

	virtual void _beforeExecute_()
	{
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 130 (For each Trade)
class Block119: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "130";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {124};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
		LoopDirection = "profitable-first";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(119);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)v::SymbolM;
		LoopLimit = (int)v::NS;
	}
};

// Block 131 (close)
class Block120: public MDL_LoopClose<ulong,color>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "131";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(120);
		}
	}

	virtual void _beforeExecute_()
	{
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 132 (once per trade/order)
class Block121: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "132";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {109};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[109].run(121);
		}
	}
};

// Block 133 (once per trade/order)
class Block122: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "133";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(122);
		}
	}
};

// Block 134 (once per trade/order)
class Block123: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "134";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {118};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[118].run(123);
		}
	}
};

// Block 135 (once per trade/order)
class Block124: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "135";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {120};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[120].run(124);
		}
	}
};

// Block 136 (Custom MQL4 codere-save variables into file)
class Block125: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "136";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		int handle = FileOpen("Order.csv",FILE_WRITE|FILE_COMMON,0,CP_UTF8); 

if(handle!=INVALID_HANDLE)
{
	FileSeek(handle,0,SEEK_SET);

	FileWrite(handle,v::TicketM);
	FileWrite(handle,v::TypeM);
	FileWrite(handle,v::LotM);
	FileWrite(handle,v::SymbolM);
	FileWrite(handle,v::ActionM);

}
else { Comment("error"); GetLastError(); }

FileClose(handle);
	}
};

// Block 137 (Counter: Reset)
class Block126: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "137";

	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 138 (Condition)
class Block127: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_indicators_iMA,double,int>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "138";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.MAperiod = 5;
		Ro.MAperiod = 20;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.MAmethod = MODE_SMA;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.MAmethod = MODE_SMA;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[121].run(127);
		}
	}
};

// Block 139 (Condition)
class Block128: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_indicators_iMA,double,int>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "139";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {122};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.MAperiod = 5;
		Ro.MAperiod = 20;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.MAmethod = MODE_SMA;
		Lo.AppliedPrice = PRICE_CLOSE;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.MAmethod = MODE_SMA;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[122].run(128);
		}
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

	if (memory == 0) memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE),2);

	return memory;
}

double AlignLots(string symbol, double lots, double lowerlots=0, double upperlots=0)
{
	double LotStep = SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
	double LotSize = SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE);
	double MinLots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
	double MaxLots = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);

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
	double slo = 0, // original sl, used when modifying
	double sll = 0,
	double slp = 0,
	bool consider_freezelevel = false
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

	double point = SymbolInfoDouble(symbol,SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
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
		double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
		double bid = SymbolInfoDouble(symbol,SYMBOL_BID);
		
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

	sl  = NormalizeDouble(sl,digits);
	slo = NormalizeDouble(slo,digits);

	if (sl == slo)
	{
		return sl;
	}

	//-- build limit levels ----------------------------------------------
	double minstops = (double)SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);

	if (consider_freezelevel == true)
	{
		double freezelevel = (double)SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL);

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

			Print("Error: Invalid SL requested (",DoubleToStr(sl,digits)," for ",abstr," price ",bidask,")");

			return -1;
		}
		else if ((bs > 0 && sl > sllimit) || (bs < 0 && sl < sllimit))
		{
			if (USE_VIRTUAL_STOPS)
			{
				return sl;
			}

			Print("Warning: Too short SL requested (",DoubleToStr(sl,digits)," or ",DoubleToStr(MathAbs(sl - askbid) / point,0)," points), minimum will be taken (",DoubleToStr(sllimit,digits)," or ",DoubleToStr(MathAbs(askbid - sllimit) / point,0)," points)");

			sl = sllimit;

			return sl;
		}
	}

	// align by the ticksize
	double ticksize = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
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

	double point = SymbolInfoDouble(symbol,SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
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
		double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
		double bid = SymbolInfoDouble(symbol,SYMBOL_BID);
		
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

	tp  = NormalizeDouble(tp,digits);
	tpo = NormalizeDouble(tpo,digits);

	if (tp == tpo)
	{
		return tp;
	}
	
	//-- build limit levels ----------------------------------------------
	double minstops = (double)SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);

	if (consider_freezelevel == true)
	{
		double freezelevel = (double)SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL);

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

			Print("Error: Invalid TP requested (",DoubleToStr(tp,digits)," for ",abstr," price ",bidask,")");

			return -1;
		}
		else if ((bs > 0 && tp < tplimit) || (bs < 0 && tp > tplimit))
		{
			if (USE_VIRTUAL_STOPS)
			{
				return tp;
			}

			Print("Warning: Too short TP requested (",DoubleToStr(tp,digits)," or ",DoubleToStr(MathAbs(tp - askbid) / point,0)," points), minimum will be taken (",DoubleToStr(tplimit,digits)," or ",DoubleToStr(MathAbs(askbid - tplimit) / point,0)," points)");

			tp = tplimit;

			return tp;
		}
	}
	
	// align by the ticksize
	double ticksize = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
	tp = MathRound(tp / ticksize) * ticksize;
	
	return tp;
}

template<typename T>
bool ArrayEnsureValue(T &array[], T value)
{
	int size   = ArraySize(array);
	
	if (size > 0)
	{
		if (InArray(array,value))
		{
			// value found -> exit
			return false; // no value added
		}
	}
	
	// value does not exists -> add it
	ArrayResize(array,size+1);
	array[size] = value;
		
	return true; // value added

	return 0;
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
		ArrayResize(array,x);
		
		return true; // stripped
	}
	
	return false; // not stripped

	return 0;
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
		ArrayResize(array,x);
		
		return true; // stripped
	}
	
	return false; // not stripped

	return 0;
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
      if (TradeSelectByIndex(pos,"group",group,"symbol",symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

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
         if (HistoryTradeSelectByIndex(pos,"group",group,"symbol",symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));
				if (IsOrderTypeSell()) {profit = -1*profit;}
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
   if (initial_lots < MarketInfo(symbol,MODE_MINLOT)) {
      initial_lots = MarketInfo(symbol,MODE_MINLOT);  
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
      if (TradeSelectByIndex(pos,"group",group,"symbol",symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

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
         if (HistoryTradeSelectByIndex(pos,"group",group,"symbol",symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));
				if (IsOrderTypeSell()) {profit = -1*profit;}
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
   if (initial_lots < MarketInfo(symbol,MODE_MINLOT)) {
      initial_lots = MarketInfo(symbol,MODE_MINLOT);  
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
      if (TradeSelectByIndex(pos,"group",group,"symbol",symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

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
         if (HistoryTradeSelectByIndex(pos,"group",group,"symbol",symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));
				if (IsOrderTypeSell()) {profit = -1*profit;}
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
   if (initial_lots < MarketInfo(symbol,MODE_MINLOT)) {
      initial_lots = MarketInfo(symbol,MODE_MINLOT);  
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
         if (fibo1 > NormalizeDouble(div,2)) {break;}
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
   
   lots=NormalizeDouble(lots,2);
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
      if (TradeSelectByIndex(pos,"group",group,"symbol",symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

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
         if (HistoryTradeSelectByIndex(pos,"group",group,"symbol",symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));
				if (IsOrderTypeSell()) {profit = -1*profit;}
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
   int id=ArraySearch(mem_group,group);
   if (id == -1) {
      start_again=true;
      if (list_of_numbers=="") {list_of_numbers="1";}
      id = ArraySize(mem_group);
      ArrayResize(mem_group,id+1,id+1);
      ArrayResize(mem_list,id+1,id+1);
      ArrayResize(mem_ticket,id+1,id+1);
      mem_group[id]=group;
      mem_list[id]=list_of_numbers;
   }
   
   if (mem_ticket[id]==OrderTicket()) {
      // the last known ticket (mem_ticket[id]) should be different than OderTicket() normally
      // when failed to create a new trade - the last ticket remains the same
      // so we need to reset
      mem_list[id]=list_of_numbers;
   }
   mem_ticket[id]=OrderTicket();
   
   //- now turn the string into integer array
   int list[];
   string listS[];
   StringExplode(",",mem_list[id],listS);
   ArrayResize(list,ArraySize(listS));
   for (int s=0; s<ArraySize(listS); s++) {
      list[s]=(int)StringToInteger(StringTrim(listS[s]));  
   }

   //-- 
   int size = ArraySize(list);

   if (initial_lots < MarketInfo(symbol,MODE_MINLOT)) {
      initial_lots = MarketInfo(symbol,MODE_MINLOT);  
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
            ArrayResize(list,0);
         }
         else if (size==2) {
            lots = initial_lots*(list[0]+list[1]);
            ArrayResize(list,0);
         }
         else if (size>2) {
            lots = initial_lots*(list[0]+list[size-1]);
            // Cancel first and last numbers in our list
            // shift array 1 step left
            for(pos=0; pos<size-1; pos++) {
               list[pos]=list[pos+1];
            }
            ArrayResize(list,ArraySize(list)-2); // remove last 2 elements		
         }
         if (lots < initial_lots) {lots = initial_lots;}
      }
      else {
         if (size>1)
         {
            ArrayResize(list,size+1);
            list[size]=list[0]+list[size-1];
            lots = initial_lots*(list[0]+list[size]);
         } else {
            lots = initial_lots*list[0];
         }
         if (lots < initial_lots) {lots = initial_lots;}
      }

   }
   
   Print("Labouchere (for group "+(string)id+") current list of numbers:"+StringImplode(",",list));
   size=ArraySize(list);
   if (size==0) {
      ArrayStripKey(mem_group,id);
      ArrayStripKey(mem_list,id);
      ArrayStripKey(mem_ticket,id);
   } else {
      mem_list[id]=StringImplode(",",list);
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
		if (TradeSelectByIndex(pos,"group",group,"symbol",symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

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
			if (HistoryTradeSelectByIndex(pos,"group",group,"symbol",symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots == 0)
				{
					lots = OrderLots();
				}

				profit = OrderClosePrice() - OrderOpenPrice();
				profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

				if (IsOrderTypeSell()) {profit = -1*profit;}
				
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
      if (TradeSelectByIndex(pos,"group",group,"symbol",symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

			if (lots == 0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));

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
         if (HistoryTradeSelectByIndex(pos,"group",group,"symbol",symbol))
			{
				if (TimeCurrent() - OrderOpenTime() < 3) {continue;}

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit,SymbolDigits(OrderSymbol()));
				if (IsOrderTypeSell()) {profit = -1*profit;}
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
   int id=ArraySearch(mem_group,group);
   if (id == -1)
   {
      if (sequence_on_loss=="") {sequence_on_loss="1";}
      if (sequence_on_profit=="") {sequence_on_profit="1";}
      id = ArraySize(mem_group);
      ArrayResize(mem_group,id+1,id+1);
      ArrayResize(mem_list_loss,id+1,id+1);
      ArrayResize(mem_list_profit,id+1,id+1);
      ArrayResize(mem_ticket,id+1,id+1);
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
   
   if (mem_ticket[id]==OrderTicket()) {
      // the last known ticket (mem_ticket[id]) should be different than OderTicket() normally
      // when failed to create a new trade - the last ticket remains the same
      // so we need to reset
      mem_list_loss[id]=sequence_on_loss;
      mem_list_profit[id]=sequence_on_profit;
   }
   mem_ticket[id]=OrderTicket();
   
   //- now turn the string into integer array
   int s=0;
   double list_loss[];
   double list_profit[];
   string listS[];
   StringExplode(",",mem_list_loss[id],listS);
   ArrayResize(list_loss,ArraySize(listS),ArraySize(listS));
   for (s=0; s<ArraySize(listS); s++) {
      list_loss[s]=(double)StringToDouble(StringTrim(listS[s]));  
   }
   StringExplode(",",mem_list_profit[id],listS);
   ArrayResize(list_profit,ArraySize(listS),ArraySize(listS));
   for (s=0; s<ArraySize(listS); s++) {
      list_profit[s]=(double)StringToDouble(StringTrim(listS[s]));  
   }

   //--
   if (initial_lots < MarketInfo(symbol,MODE_MINLOT)) {
      initial_lots = MarketInfo(symbol,MODE_MINLOT);  
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
            ArrayResize(list_profit,size-1,size-1);
            mem_list_profit[id]=StringImplode(",",list_profit);
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
            ArrayResize(list_loss,size-1,size-1);
            mem_list_loss[id]=StringImplode(",",list_loss);
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
		ArrayResize(list,0);
		ArrayCopy(list,mem_tickets_last);

	  	label = mem_label_last;
		pool = mem_pool_last;

		return ArraySize(list);
	}
	
	int idx = ArraySearch(mem_labels,label);
	
	//-- set
	if (set == true)
	{
		if (idx == -1)
		{
			size = ArraySize(mem_labels);

			ArrayResize(mem_labels,size+1);
			ArrayResize(mem_pool,size+1);
			ArrayResize(mem_tickets,size+1);
			
			mem_labels[size] = label;
			mem_pool[size]   = pool;
			idx              = size;
		}

		mem_tickets[idx] = StringImplode(",",list);
		mem_pool[idx]	  = pool;

		//-- cache, save this array in a temporary memory
		ArrayResize(mem_tickets_last,0);
		ArrayCopy(mem_tickets_last,list);

		mem_label_last = label;
		mem_pool_last  = pool;
		
		return true;
	}

	if (idx == -1)
	{
		ArrayResize(list,0);

		return 0;
	}
	
	//-- get data
	pool = mem_pool[idx];

	if (mem_tickets[idx] == "")
	{
		// because StringExplode returns one empty element for an empty string
		ArrayResize(list,0);
	}
	else
	{
		StringExplode(",",mem_tickets[idx],list);
	}

	return ArraySize(list);
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
	return OrderCreate(symbol,OP_BUY,lots,0,sll,tpl,slp,tpp,slippage,magic,comment,arrowcolor,expiration);
}

int CheckForTradingError(int error_code=-1, string msg_prefix="")
{
   // return 0 -> no error
   // return 1 -> overcomable error
   // return 2 -> fatal error
   
   if (error_code<ERR_SUCCESS) {
      error_code=GetLastError();  
   }
   
   int retval=0;
   static int tryouts=0;
   
   //-- error check -----------------------------------------------------
   switch(error_code)
   {
      //-- no error
      case ERR_SUCCESS:
         retval=0;
         break;
      //-- overcomable errors
      case ERR_SUCCESS: // No error returned
         RefreshRates();
         retval=1;
         break;
      case TRADE_RETCODE_ERROR: //ERR_SERVER_BUSY
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         Sleep(1000);
         RefreshRates();
         retval=1;
         break;
      case TRADE_RETCODE_CONNECTION: //ERR_NO_CONNECTION
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         while(!IsConnected()) {Sleep(100);}
         while(IsTradeContextBusy()) {Sleep(50);}
         RefreshRates();
         retval=1;
         break;
      case TRADE_RETCODE_TIMEOUT: //ERR_TRADE_TIMEOUT
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         RefreshRates();
         retval=1;
         break;
      case TRADE_RETCODE_INVALID_PRICE: //ERR_INVALID_PRICE
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case TRADE_RETCODE_INVALID_STOPS: //ERR_INVALID_STOPS
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case TRADE_RETCODE_PRICE_CHANGED: //ERR_PRICE_CHANGED
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case TRADE_RETCODE_PRICE_OFF: //ERR_OFF_QUOTES
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case TRADE_RETCODE_ERROR: //ERR_BROKER_BUSY
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         Sleep(1000);
         retval=1;
         break;
      case TRADE_RETCODE_REQUOTE: //ERR_REQUOTE
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Waiting for a new tick to retry.."));}
         if (!IsTesting()) {while(RefreshRates()==false) {Sleep(1);}}
         retval=1;
         break;
      case 142: //This code should be processed in the same way as error 128.
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         RefreshRates();
         retval=1;
         break;
      case 143: //This code should be processed in the same way as error 128.
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         RefreshRates();
         retval=1;
         break;
      /*case 145: //ERR_TRADE_MODIFY_DENIED
         if (msg_prefix!="") {Print(StringConcatenate(msg_prefix,": ",ErrorMessage(error_code),". Waiting for a new tick to retry.."));}
         while(RefreshRates()==false) {Sleep(1);}
         return(1);
      */
      case ERR_SUCCESS: //ERR_TRADE_CONTEXT_BUSY
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code))+(string)(". Retrying.."));}
         while(IsTradeContextBusy()) {Sleep(50);}
         RefreshRates();
         retval=1;
         break;
      //-- critical errors
      default:
         if (msg_prefix!="") {Print((string)(msg_prefix)+(string)(": ")+(string)(ErrorMessage(error_code)));}
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

	if (!OrderSelect((int)ticket,SELECT_BY_TICKET,MODE_TRADES))
	{
		return false;
	}

	while (true)
	{
		//-- wait if needed -----------------------------------------------
		WaitTradeContextIfBusy();

		//-- close --------------------------------------------------------
		success = OrderClose((int)ticket,OrderLots(),OrderClosePrice(),(int)(slippage * PipValue(OrderSymbol())),arrowcolor);

		if (success == true)
		{
			if (USE_VIRTUAL_STOPS) {
				VirtualStopsDriver("clear",ticket);
			}

			RegisterEvent("trade");

			return true;
		}

		//-- errors -------------------------------------------------------
		int erraction = CheckForTradingError(GetLastError(),"Closing trade #" + (string)ticket + " error");

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

int Counter(int id, string cmd="", int set_passes=0)
{
	static int idx[]; // index list
   static int pl[]; // passes list
   int size    = 0;
   int passes  = 0;
   int cnt_idx = ArraySearch(idx,id);
   
   if (cnt_idx == -1)
   {
      // Counter not found
      size = ArraySize(idx);
      ArrayResize(idx,size + 1);
      ArrayResize(pl,size + 1);
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

	ArrayResize(symbols,size);
	ArrayResize(points,size);

	symbols[i]	= symbol;
	points[i]	= 0;
	last_symbol	= symbol;
	last_i		= i;

	//-- unserialize rules from FXD_POINT_FORMAT_RULES
	string rules[];
	StringExplode(",",POINT_FORMAT_RULES,rules);

	int rules_count = ArraySize(rules);

	if (rules_count > 0)
	{
		string rule[];

		for (int r = 0; r < rules_count; r++)
		{
			StringExplode("=",rules[r],rule);

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
				int pos       = StringFind(s_from,"?");

				if (pos < 0) // ? not found
				{
					if (StringFind(symbol,s_from) == 0) {points[i] = to;}
				}
				else if (pos == 0) // ? is the first symbol => match the second symbol
				{
					if (StringFind(symbol,StringSubstr(s_from,1),3) == 3)
					{
						points[i] = to;
					}
				}
				else if (pos > 0) // ? is the second symbol => match the first symbol
				{
					if (StringFind(symbol,StringSubstr(s_from,0,((pos!=0)?pos:-1))) == 0)
					{
						points[i] = to;
					}
				}
			}

			// b) number
			if (from == 0) {continue;}

			if (SymbolInfoDouble(symbol,SYMBOL_POINT) == from)
			{
				points[i] = to;
			}
		}
	}

	if (points[i] == 0)
	{
		points[i] = SymbolInfoDouble(symbol,SYMBOL_POINT);
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
         RegisterEvent("trade");
         return(true);
      }
      //-- error check --------------------------------------------------
      int erraction=CheckForTradingError(GetLastError(),"Deleting order #"+(string)ticket+" error");
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
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+1);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+1);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,18);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrDarkOrange);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"Spread:");
      }
      name="fxd_spread_max_label";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+148);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+17);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrOrangeRed);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"max:");
      }
      name="fxd_spread_avg_label";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+148);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+9);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrDarkOrange);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"avg:");
      }
      name="fxd_spread_min_label";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+148);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+1);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrGold);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"min:");
      }
      name="fxd_spread_current";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+93);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+1);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,18);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrDarkOrange);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"0");
      }
      name="fxd_spread_max";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+173);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+17);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrOrangeRed);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"0");
      }
      name="fxd_spread_avg";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+173);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+9);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrDarkOrange);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"0");
      }
      name="fxd_spread_min";
      if (ObjectFind(0,name)==-1) {
         ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+173);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+1);
         ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrGold);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial");
         ObjectSetString(0,name,OBJPROP_TEXT,"0");
      }
   }
   
   ObjectSetString(0,"fxd_spread_current",OBJPROP_TEXT,DoubleToStr(current_spread,2));
   ObjectSetString(0,"fxd_spread_max",OBJPROP_TEXT,DoubleToStr(max_spread,2));
   ObjectSetString(0,"fxd_spread_avg",OBJPROP_TEXT,DoubleToStr(avg_spread,2));
   ObjectSetString(0,"fxd_spread_min",OBJPROP_TEXT,DoubleToStr(min_spread,2));
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
      ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+17);
      ObjectSetString(0,name,OBJPROP_TEXT,"Status");
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrGray);
      
      name="fxd_status_text";
      ObjectCreate(0,(ENUM_OBJECT)name,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x+2);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y+1);
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,12);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrAqua);
   }

   //-- update the text when needed
   if (text != memory) {
      memory=text;
      ObjectSetString(0,"fxd_status_text",OBJPROP_TEXT,text);
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
               Print("Fixed Ratio MM going down to ",(RJFR_start_lots*(RJFR_units-1))," lots: Equity is below Lower Target Equity | ",AccountEquity()," <= ",RJFR_target_lower,")");
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
	
	if (error_code < ERR_SUCCESS) {error_code = GetLastError();}
	
	switch(error_code)
	{
		//-- codes returned from trade server
		case ERR_SUCCESS:	return("");
		case ERR_SUCCESS:	e = "No error returned"; break;
		case ERR_INTERNAL_ERROR:	e = "Common error"; break;
		case TRADE_RETCODE_INVALID:	e = "Invalid trade parameters"; break;
		case TRADE_RETCODE_ERROR:	e = "Trade server is busy"; break;
		case ERR_INTERNAL_ERROR:	e = "Old version of the client terminal"; break;
		case TRADE_RETCODE_CONNECTION:	e = "No connection with trade server"; break;
		case TRADE_RETCODE_REJECT:	e = "Not enough rights"; break;
		case TRADE_RETCODE_TOO_MANY_REQUESTS:	e = "Too frequent requests"; break;
		case TRADE_RETCODE_ERROR:	e = "Malfunctional trade operation (never returned error)"; break;
		case ERR_TRADE_DISABLED:  e = "Account disabled"; break;
		case ERR_TRADE_DISABLED:  e = "Invalid account"; break;
		case TRADE_RETCODE_TIMEOUT: e = "Trade timeout"; break;
		case TRADE_RETCODE_INVALID_PRICE: e = "Invalid price"; break;
		case TRADE_RETCODE_INVALID_STOPS: e = "Invalid Sl or TP"; break;
		case TRADE_RETCODE_INVALID_VOLUME: e = "Invalid trade volume"; break;
		case TRADE_RETCODE_MARKET_CLOSED: e = "Market is closed"; break;
		case TRADE_RETCODE_CLIENT_DISABLES_AT: e = "Trade is disabled"; break;
		case TRADE_RETCODE_NO_MONEY: e = "Not enough money"; break;
		case TRADE_RETCODE_PRICE_CHANGED: e = "Price changed"; break;
		case TRADE_RETCODE_PRICE_OFF: e = "Off quotes"; break;
		case TRADE_RETCODE_ERROR: e = "Broker is busy (never returned error)"; break;
		case TRADE_RETCODE_REQUOTE: e = "Requote"; break;
		case TRADE_RETCODE_LOCKED: e = "Order is locked"; break;
		case ERR_INTERNAL_ERROR: e = "Only long trades allowed"; break;
		case TRADE_RETCODE_TOO_MANY_REQUESTS: e = "Too many requests"; break;
		case TRADE_RETCODE_REJECT: e = "Modification denied because order too close to market"; break;
		case ERR_SUCCESS: e = "Trade context is busy"; break;
		case TRADE_RETCODE_REJECT: e = "Expirations are denied by broker"; break;
		case TRADE_RETCODE_LIMIT_ORDERS: e = "Amount of open and pending orders has reached the limit"; break;
		case ERR_SUCCESS: e = "Hedging is prohibited"; break;
		case ERR_SUCCESS: e = "Prohibited by FIFO rules"; break;
		
		//-- mql4 errors
		case ERR_SUCCESS: e = "No error"; break;
		case ERR_INVALID_POINTER: e = "Wrong function pointer"; break;
		case ERR_INTERNAL_ERROR: e = "Array index is out of range"; break;
		case ERR_NOT_ENOUGH_MEMORY: e = "No memory for function call stack"; break;
		case ERR_INTERNAL_ERROR: e = "Recursive stack overflow"; break;
		case ERR_INTERNAL_ERROR: e = "Not enough stack for parameter"; break;
		case ERR_STRING_RESIZE_ERROR: e = "No memory for parameter string"; break;
		case ERR_STRING_RESIZE_ERROR: e = "No memory for temp string"; break;
		case ERR_NOTINITIALIZED_STRING: e = "Not initialized string"; break;
		case ERR_NOTINITIALIZED_STRING: e = "Not initialized string in array"; break;
		case ERR_STRING_OUT_OF_MEMORY: e = "No memory for array string"; break;
		case ERR_STRING_TOO_BIGNUMBER: e = "Too long string"; break;
		case ERR_INTERNAL_ERROR: e = "Remainder from zero divide"; break;
		case ERR_INTERNAL_ERROR: e = "Zero divide"; break;
		case ERR_INTERNAL_ERROR: e = "Unknown command"; break;
		case ERR_INTERNAL_ERROR: e = "Wrong jump"; break;
		case ERR_INVALID_ARRAY: e = "Not initialized array"; break;
		case ERR_INTERNAL_ERROR: e = "dll calls are not allowed"; break;
		case ERR_INTERNAL_ERROR: e = "Cannot load library"; break;
		case ERR_FUNCTION_NOT_ALLOWED: e = "Cannot call function"; break;
		case ERR_INTERNAL_ERROR: e = "Expert function calls are not allowed"; break;
		case ERR_STRING_OUT_OF_MEMORY: e = "Not enough memory for temp string returned from function"; break;
		case ERR_INTERNAL_ERROR: e = "System is busy"; break;
		case ERR_INVALID_PARAMETER: e = "Invalid function parameters count"; break;
		case ERR_INVALID_PARAMETER: e = "Invalid function parameter value"; break;
		case ERR_WRONG_INTERNAL_PARAMETER: e = "String function internal error"; break;
		case ERR_INVALID_ARRAY: e = "Some array error"; break;
		case ERR_SERIES_ARRAY: e = "Incorrect series array using"; break;
		case ERR_INDICATOR_CANNOT_CREATE: e = "Custom indicator error"; break;
		case ERR_INCOMPATIBLE_ARRAYS: e = "Arrays are incompatible"; break;
		case ERR_GLOBALVARIABLE_NOT_FOUND: e = "Global variables processing error"; break;
		case ERR_GLOBALVARIABLE_NOT_FOUND: e = "Global variable not found"; break;
		case ERR_FUNCTION_NOT_ALLOWED: e = "Function is not allowed in testing mode"; break;
		case ERR_FUNCTION_NOT_ALLOWED: e = "Function is not confirmed"; break;
		case ERR_MAIL_SEND_FAILED: e = "Send mail error"; break;
		case ERR_INVALID_PARAMETER: e = "String parameter expected"; break;
		case ERR_INVALID_PARAMETER: e = "Integer parameter expected"; break;
		case ERR_INVALID_PARAMETER: e = "Double parameter expected"; break;
		case ERR_INVALID_PARAMETER: e = "Array as parameter expected"; break;
		case ERR_INTERNAL_ERROR: e = "Requested history data in update state"; break;
		case ERR_FILE_ENDOFFILE: e = "End of file"; break;
		case ERR_CANNOT_OPEN_FILE: e = "Some file error"; break;
		case ERR_WRONG_FILENAME: e = "Wrong file name"; break;
		case ERR_TOO_MANY_FILES: e = "Too many opened files"; break;
		case ERR_CANNOT_OPEN_FILE: e = "Cannot open file"; break;
		case ERR_INCOMPATIBLE_FILE: e = "Incompatible access to a file"; break;
		case ERR_TRADE_ORDER_NOT_FOUND: e = "No order selected"; break;
		case ERR_MARKET_UNKNOWN_SYMBOL: e = "Unknown symbol"; break;
		case TRADE_RETCODE_INVALID_PRICE: e = "Invalid price parameter for trade function"; break;
		case TRADE_RETCODE_INVALID: e = "Invalid ticket"; break;
		case TRADE_RETCODE_CLIENT_DISABLES_AT: e = "Trade is not allowed in the expert properties"; break;
		case TRADE_RETCODE_CLIENT_DISABLES_AT: e = "Longs are not allowed in the expert properties"; break;
		case TRADE_RETCODE_CLIENT_DISABLES_AT: e = "Shorts are not allowed in the expert properties"; break;
		
		//-- objects errors
		case ERR_OBJECT_ERROR: e = "Object is already exist"; break;
		case ERR_OBJECT_WRONG_PROPERTY: e = "Unknown object property"; break;
		case ERR_OBJECT_NOT_FOUND: e = "Object is not exist"; break;
		case ERR_OBJECT_ERROR: e = "Unknown object type"; break;
		case ERR_OBJECT_ERROR: e = "No object name"; break;
		case ERR_OBJECT_ERROR: e = "Object coordinates error"; break;
		case ERR_CHART_WINDOW_NOT_FOUND: e = "No specified subwindow"; break;
		case ERR_OBJECT_ERROR: e = "Graphical object error"; break;  
		case ERR_CHART_WRONG_PROPERTY: e = "Unknown chart property"; break;
		case ERR_CHART_NOT_FOUND: e = "Chart not found"; break;
		case ERR_CHART_WINDOW_NOT_FOUND: e = "Chart subwindow not found"; break;
		case ERR_CHART_INDICATOR_NOT_FOUND: e = "Chart indicator not found"; break;
		case ERR_CHART_CANNOT_CHANGE: e = "Symbol select error"; break;
		case ERR_NOTIFICATION_SEND_FAILED: e = "Notification error"; break;
		case ERR_NOTIFICATION_WRONG_PARAMETER: e = "Notification parameter error"; break;
		case ERR_NOTIFICATION_WRONG_SETTINGS: e = "Notifications disabled"; break;
		case ERR_NOTIFICATION_TOO_FREQUENT: e = "Notification send too frequent"; break;
		
		//-- ftp errors
		case ERR_FTP_NOSERVER: e = "FTP server is not specified"; break;
		case ERR_FTP_NOLOGIN: e = "FTP login is not specified"; break;
		case ERR_FTP_CONNECT_FAILED: e = "FTP connection failed"; break;
		case ERR_FTP_CLOSED: e = "FTP connection closed"; break;
		case ERR_FTP_CHANGEDIR: e = "FTP path not found on server"; break;
		case ERR_FTP_FILE_ERROR: e = "File not found in the MQL4\\Files directory to send on FTP server"; break;
		case ERR_FTP_SEND_FAILED: e = "Common error during FTP data transmission"; break;
		
		//-- filesystem errors
		case ERR_TOO_MANY_FILES: e = "Too many opened files"; break;
		case ERR_WRONG_FILENAME: e = "Wrong file name"; break;
		case ERR_TOO_LONG_FILENAME: e = "Too long file name"; break;
		case ERR_CANNOT_OPEN_FILE: e = "Cannot open file"; break;
		case ERR_FILE_CACHEBUFFER_ERROR: e = "Text file buffer allocation error"; break;
		case ERR_CANNOT_DELETE_FILE: e = "Cannot delete file"; break;
		case ERR_INVALID_FILEHANDLE: e = "Invalid file handle (file closed or was not opened)"; break;
		case ERR_WRONG_FILEHANDLE: e = "Wrong file handle (handle index is out of handle table)"; break;
		case ERR_FILE_NOTTOWRITE: e = "File must be opened with FILE_WRITE flag"; break;
		case ERR_FILE_NOTTOREAD: e = "File must be opened with FILE_READ flag"; break;
		case ERR_FILE_NOTBIN: e = "File must be opened with FILE_BIN flag"; break;
		case ERR_FILE_NOTTXT: e = "File must be opened with FILE_TXT flag"; break;
		case ERR_FILE_NOTTXTORCSV: e = "File must be opened with FILE_TXT or FILE_CSV flag"; break;
		case ERR_FILE_NOTCSV: e = "File must be opened with FILE_CSV flag"; break;
		case ERR_FILE_READERROR: e = "File read error"; break;
		case ERR_FILE_WRITEERROR: e = "File write error"; break;
		case ERR_FILE_BINSTRINGSIZE: e = "String size must be specified for binary file"; break;
		case ERR_INCOMPATIBLE_FILE: e = "Incompatible file (for string arrays-TXT, for others-BIN)"; break;
		case ERR_FILE_IS_DIRECTORY: e = "File is directory, not file"; break;
		case ERR_FILE_NOT_EXIST: e = "File does not exist"; break;
		case ERR_FILE_CANNOT_REWRITE: e = "File cannot be rewritten"; break;
		case ERR_WRONG_DIRECTORYNAME: e = "Wrong directory name"; break;
		case ERR_DIRECTORY_NOT_EXIST: e = "Directory does not exist"; break;
		case ERR_FILE_ISNOT_DIRECTORY: e = "Specified file is not directory"; break;
		case ERR_CANNOT_DELETE_DIRECTORY: e = "Cannot delete directory"; break;
		case ERR_CANNOT_CLEAN_DIRECTORY: e = "Cannot clean directory"; break;
		
		//-- other errors
		case ERR_ARRAY_RESIZE_ERROR: e = "Array resize error"; break;
		case ERR_STRING_RESIZE_ERROR: e = "String resize error"; break;
		case ERR_STRUCT_WITHOBJECTS_ORCLASS: e = "Structure contains strings or dynamic arrays"; break;
		
		//-- http request
		case ERR_WEBREQUEST_INVALID_ADDRESS: e = "Invalid URL"; break;
		case ERR_WEBREQUEST_CONNECT_FAILED: e = "Failed to connect to specified URL"; break;
		case ERR_WEBREQUEST_TIMEOUT: e = "Timeout exceeded"; break;
		case ERR_WEBREQUEST_REQUEST_FAILED: e = "HTTP request failed"; break;

		default:	e = "Unknown error";
	}

	e = (string)(e)+(string)(" (")+(string)(error_code)+(string)(")");
	
	return e;
}

void ExpirationDriver()
{
	static int last_checked_ticket;
	static int db_tickets[];
	static datetime db_expirations[];

	int total    = OrdersTotal(true);
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
			ArrayResize(db_tickets,0);
			ArrayResize(db_expirations,0);
		}
		else
		{
			for (i = 0; i < size; i++)
			{
				WaitTradeContextIfBusy();

				if (!OrderSelect(db_tickets[i],SELECT_BY_TICKET,MODE_TRADES)) {continue;}
				if (OrderSymbol() != Symbol()) {continue;}
				
				if (TimeCurrent() >= db_expirations[i])
				{
					//-- trying to skip conflicts with the same functionality running from neighbour EA
					WaitTradeContextIfBusy();

					if (!OrderSelect(db_tickets[i],SELECT_BY_TICKET,MODE_TRADES)) {continue;}
					if (OrderCloseTime() > 0) {continue;}

					//-- closing the trade
					if (CloseTrade(OrderTicket())) 
					{
						print = "#" + (string)OrderTicket() + " was closed due to expiration";
						Print(print);
						last_checked_ticket = 0;
						do_reset = true;
						total    = OrdersTotal(true);
					}
				}
			}
		}
	}

	//-- check the ticket of the newest trade
	if (do_reset == false && total > 0)
	{
		if (OrderSelect(total-1,SELECT_BY_POS))
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
		ArrayResize(db_tickets,0);
		ArrayResize(db_expirations,0);

		for (int pos = 0; pos < total; pos++)
		{
			if (!OrderSelect(pos,SELECT_BY_POS)) {continue;}
			last_checked_ticket = OrderTicket();

			string comment = OrderComment();
			int exp_pos_begin = StringFind(comment,"[exp:");

			if (exp_pos_begin >= 0)
			{
				exp_pos_begin = exp_pos_begin + 5;
				int exp_pos_end = StringFind(comment,"]",exp_pos_begin);
				if (exp_pos_end == -1) {continue;}
				
				size = ArraySize(db_tickets);
				ArrayResize(db_tickets,size+1);
				ArrayResize(db_expirations,size+1);

				db_tickets[size]     = OrderTicket();
				db_expirations[size] = (datetime)((int)OrderOpenTime() + (int)StringToInteger(StringSubstr(comment,exp_pos_begin,((exp_pos_end!=0)?exp_pos_end:-1))));
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

bool FilterEventTrade(string group_mode,string group,string market_mode="market",string market="",string BuysOrSells="both", string LimitsOrStops="")
{
	return FilterOrderBy(group_mode,group,market_mode,market,BuysOrSells,LimitsOrStops,2,true);
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
				StringExplode(",",group,groups);
				groups_size = ArraySize(groups);

				for(i = 0; i < groups_size; i++)
				{
					groups[i] = StringTrimRight(groups[i],0);
					groups[i] = StringTrimLeft(groups[i],0);

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
					ArrayResize(markets,1);
					markets[0] = Symbol();
				}
				else
				{
					StringExplode(",",market,markets);
					markets_size = ArraySize(markets);

					for(i = 0; i < markets_size; i++)
					{
						markets[i] = StringTrimRight(markets[i],0);
						markets[i] = StringTrimLeft(markets[i],0);

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

bool HistoryTradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (OrderSelect((int)index,SELECT_BY_POS,MODE_HISTORY) && OrderType() < 2)
	{
		if (FilterOrderBy(group_mode,group,market_mode,market,BuysOrSells)
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

bool IsOrderTypeSell()
{
	int type = OrderType();

	return (type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT);
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

bool ModifyOrder(
	int ticket,
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

		if (!OrderSelect(ticket,SELECT_BY_TICKET))
		{
			return false;
		}

		string symbol      = OrderSymbol();
		int type           = OrderType();
		double ask         = SymbolInfoDouble(symbol,SYMBOL_ASK);
		double bid         = SymbolInfoDouble(symbol,SYMBOL_BID);
		int digits         = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
		double point       = SymbolInfoDouble(symbol,SYMBOL_POINT);
		double stoplevel   = point * SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
		double freezelevel = point * SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL);

		if (OrderType() < 2) {op = OrderOpenPrice();} else {op = NormalizeDouble(op,digits);}

		sll = NormalizeDouble(sll,digits);
		tpl = NormalizeDouble(tpl,digits);

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

		op = NormalizeDouble(op,digits);

		//-- SL and TP ----------------------------------------------------
		double sl = 0, tp = 0, vsl = 0, vtp = 0;

		sl = AlignStopLoss(symbol,type,op,attrStopLoss(),sll,slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol,type,op,attrTakeProfit(),tpl,tpp);

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
				VirtualStopsDriver("set",ticket,vsl,vtp,toPips(MathAbs(op-vsl),symbol),toPips(MathAbs(vtp-op),symbol));
			}
		}

		bool success = false;

		if (
			   (OrderType() > 1 && op != NormalizeDouble(OrderOpenPrice(),digits))
			|| sl != NormalizeDouble(OrderStopLoss(),digits)
			|| tp != NormalizeDouble(OrderTakeProfit(),digits)
			|| exp != OrderExpiration()
		) {
			success = OrderModify(ticket,op,sl,tp,exp,clr);
		}

		//-- error check --------------------------------------------------
		int erraction = CheckForTradingError(GetLastError(),"Modify error");

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
				RegisterEvent("trade");
			}

			if (OrderSelect(ticket,SELECT_BY_TICKET)) {}

			return true;
		}

		break;
	}

	return false;
}

int OCODriver()
{
	static int last_known_ticket = 0;
   static int orders1[];
   static int orders2[];
   int i, size;
   
   int total = OrdersTotal(true);
   
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
         if (StringSubstr(OrderComment(),0,5) == "[oco:")
         {
            int ticket_oco = StrToInteger(StringSubstr(OrderComment(),5,((StringLen(OrderComment())-1!=0)?StringLen(OrderComment())-1:-1))); 
            
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
               ArrayResize(orders1,size+1);
               ArrayResize(orders2,size+1);
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
      if (OrderSelect(orders1[i],SELECT_BY_TICKET,MODE_TRADES) == false || OrderType() <= OP_SELL)
      {
         if (OrderSelect(orders2[i],SELECT_BY_TICKET,MODE_TRADES)) {
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
            ArrayStripKey(orders1,i);
            ArrayStripKey(orders2,i);
         }
      }
   }
   
   size = ArraySize(orders2);
   dbremove = false;
   for (i=size-1; i>=0; i--)
   {
      if (OrderSelect(orders2[i],SELECT_BY_TICKET,MODE_TRADES) == false || OrderType() <= OP_SELL)
      {
         if (OrderSelect(orders1[i],SELECT_BY_TICKET,MODE_TRADES)) {
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
            ArrayStripKey(orders1,i);
            ArrayStripKey(orders2,i);
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

void OnTradeListener()
{
	static datetime start_time = -1;
	static int    memory_ti[]; // memory of tickets
	static int    memory_ty[]; // memory of types
	static double memory_sl[];
	static double memory_tp[];
	static double memory_vl[];
	static double memory_op[];
	static bool loaded = false;

	if (!ENABLE_EVENT_TRADE) {return;}

	int tn          = 0;  // ticket now (index)
	int ti          = -1; // ticket
	int ty          = -1; // type
	int size        = -1;
	int pos         = 0;
	string e_reason = "";
	string e_detail = "";
	int i = -1, j = -1, k = -1;
	int tickets_now[];
	

	if (start_time == -1) {start_time = TimeCurrent();}

	//-- TRADES AND ORDERS
	ArrayResize(tickets_now,0);

	int total = OrdersTotal(true);

	// initial fill of the local DB
	if (loaded == false)
	{
		loaded = true;

		for (pos = total-1; pos >= 0; pos--)
		{
			if (OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
			{
				ArrayResize(memory_ti,tn+1);
				ArrayResize(memory_ty,tn+1);
				ArrayResize(memory_sl,tn+1);
				ArrayResize(memory_tp,tn+1);
				ArrayResize(memory_vl,tn+1);
				ArrayResize(memory_op,tn+1);
				memory_ti[tn] = OrderTicket();
				memory_ty[tn] = OrderType();
				memory_sl[tn] = attrStopLoss();
				memory_tp[tn] = attrTakeProfit();
				memory_vl[tn] = OrderLots();
				memory_op[tn] = OrderOpenPrice();

				tn++;
			}
		}

		return;
	}

	tn = 0;

	bool pending_opens = false;

	for (pos = total-1; pos >= 0; pos--)
	{
		if (OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
		{
			ArrayResize(tickets_now,tn+1);
			tickets_now[tn] = OrderTicket();
			tn++;

			// Trades and Orders
			i    = -1;
			ti   = -1;
			ty   = -1;
			size = ArraySize(memory_ti);

			if (size > 0)
			{
				for (i = 0; i < size; i++)
				{
					if (memory_ti[i] == OrderTicket())
					{
						if (memory_ty[i] == OrderType())
						{
							ty = OrderType();
						}
						else
						{
							pending_opens = true;
						}

						ti = OrderTicket();

						break;
				  }
			  }
			}

			// Order become a trade
			if (ti > 0 && ty < 0)
			{
				memory_ti[i] = OrderTicket();
				memory_ty[i] = OrderType();

				memory_sl[i] = attrStopLoss();
				memory_tp[i] = attrTakeProfit();
				memory_vl[i] = OrderLots();
				memory_op[i] = OrderOpenPrice();

				e_reason = "new";
				e_detail = "";

				break;
			}

			// New trade/order opened
			else if (ti < 0 && ty < 0)
			{
				ArrayResize(memory_ti,size+1); memory_ti[size] = OrderTicket();
				ArrayResize(memory_ty,size+1); memory_ty[size] = OrderType();
				ArrayResize(memory_sl,size+1); memory_sl[size] = attrStopLoss();
				ArrayResize(memory_tp,size+1); memory_tp[size] = attrTakeProfit();
				ArrayResize(memory_vl,size+1); memory_vl[size] = OrderLots();
				ArrayResize(memory_op,size+1); memory_op[size] = OrderOpenPrice();

				e_reason = "new";
				e_detail = "";

				break;
			}

			// Check for Lots, SL or TP modification
			else if (ty >= 0 && i > -1)
			{
				if (memory_vl[i] != OrderLots())
				{
					memory_vl[i] = OrderLots();
					e_reason = "modify";
					e_detail = "lots";

					break;
				}
				else if (memory_op[i] != OrderOpenPrice())
				{
					memory_op[i] = OrderOpenPrice();
					memory_sl[i] = attrStopLoss();
					memory_tp[i] = attrTakeProfit();
					e_reason = "modify";
					e_detail = "move";

					break;
				}
				else
				{
					if (memory_sl[i] != attrStopLoss() && memory_tp[i] != attrTakeProfit())
					{
						memory_sl[i] = attrStopLoss();
						memory_tp[i] = attrTakeProfit();
						e_reason = "modify";
						e_detail = "sltp";

						break;
					}
					else if (memory_sl[i] != attrStopLoss())
					{
						memory_sl[i] = attrStopLoss();
						e_reason = "modify";
						e_detail = "sl";

						break;
					}
				  	else if (memory_tp[i] != attrTakeProfit())
				  	{
				  		memory_tp[i] = attrTakeProfit();
				  		e_reason = "modify";
				  		e_detail = "tp";

						break;
				  	}
				}
			}
		}
	}

	// Check for closed orders/trades
	bool missing = true;

	if (
		   e_reason == ""
		&& pending_opens == false
		&& ArraySize(tickets_now) < ArraySize(memory_ti)
	)
	{
		// for each ticket in the memory check if trade exists now
		for(i = ArraySize(memory_ti)-1; i >= 0; i--)
		{
			for(j = 0; j < ArraySize(tickets_now); j++)
			{
				if (memory_ti[i] == tickets_now[j])
				{
					missing = false;

					break;
				}
			}

			if (missing == true)
			{
				if (OrderSelect(memory_ti[i],SELECT_BY_TICKET))
				{
					// This can happen more than once
					ArrayStripKey(memory_ti,i);
					ArrayStripKey(memory_ty,i);
					ArrayStripKey(memory_sl,i);
					ArrayStripKey(memory_tp,i);
					ArrayStripKey(memory_vl,i);
					ArrayStripKey(memory_op,i);

					e_reason = "close";
					e_detail = "";
					
					if (
						   StringFind(OrderComment(),"expiration") >= 0
						|| StringFind(OrderComment(),"[exp:") >= 0
					)
					{
						e_detail = "expire";
					}

					// remove virtual stops lines
					if (USE_VIRTUAL_STOPS)
					{
						ObjectDelete("#" + (string)OrderTicket() + " sl");
						ObjectDelete("#" + (string)OrderTicket() + " tp");
					}

					break;
				}
			}

			missing = true;
		}
	}

	if (e_reason != "")
	{
		UpdateEventValues(e_reason,e_detail);
		EventTrade();
		OnTradeListener();
	}
	
	return;
}

int OnTradeQueue(int queue=0)
{
   static int mem=0;
   mem=mem+queue;
   return(mem);
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

	lots = AlignLots(symbol,lots);

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
			&& !MarketInfo(symbol,MODE_TRADEALLOWED)
		) {
			if (not_allowed_message == false)
			{
				Print("Market ("+symbol+") is closed");
			}

			not_allowed_message = true;

			return false;
		}

		not_allowed_message = false;
		
		digits   = (int)MarketInfo(symbol,MODE_DIGITS);
		ask      = MarketInfo(symbol,MODE_ASK);
		bid      = MarketInfo(symbol,MODE_BID);
		point    = MarketInfo(symbol,MODE_POINT);
		ticksize = MarketInfo(symbol,MODE_TICKSIZE);
		
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

						Print("Not enough money to trade " + DoubleToString(size_old,2)+", the volume to trade will be the maximum possible of " + DoubleToString(lots,2));
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
				//- convert UNIX to seconds
				if (expiration > TimeCurrent()-100) {
					expiration = expiration - TimeCurrent();
				}
				
				//- bo broker?
				if (
					   StringLen(symbol) > 6
					&& StringSubstr(symbol,StringLen(symbol) - 2) == "bo"
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
						comment = StringSubstr(comment,0,(((27 - expiration_len)!=0)?(27 - expiration_len):-1));
					}

					comment = comment + expiration_str;
				}
			}
		}

		if (type == OP_BUY || type == OP_SELL)
		{
			op = (bs > 0) ? ask : bid;
		}

		op  = NormalizeDouble(op,digits);
		sll = NormalizeDouble(sll,digits);
		tpl = NormalizeDouble(tpl,digits);

		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)
		{
			break;
		}

		//-- SL and TP ----------------------------------------------------
		vsl = 0; vtp = 0;
		
		sl = AlignStopLoss(symbol,type,op,0,NormalizeDouble(sll,digits),slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol,type,op,0,NormalizeDouble(tpl,digits),tpp);

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

					sl = sl - toDigits(EMERGENCY_STOPS_ADD,symbol) * bs;
				}
			}

			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					tp = vtp + EMERGENCY_STOPS_REL * MathAbs(vtp - askbid) * bs;

					if (tp <= 0) {tp = askbid;}

					tp = tp + toDigits(EMERGENCY_STOPS_ADD,symbol) * bs;
				}
			}

			vsl = NormalizeDouble(vsl,digits);
			vtp = NormalizeDouble(vtp,digits);
		}

		sl = NormalizeDouble(sl,digits);
		tp = NormalizeDouble(tp,digits);

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

		ticket = OrderSend(symbol,type,lots,op,(int)(slippage * PipValue(symbol)),sl,tp,comment,magic,expiration,arrowcolor);

		//-- error check --------------------------------------------------
		string msg_prefix = (type > OP_SELL) ? "New order error" : "New trade error";

		int erraction = CheckForTradingError(GetLastError(),msg_prefix);

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
				VirtualStopsDriver("set",ticket,vsl,vtp,toPips(MathAbs(op-vsl),symbol),toPips(MathAbs(vtp-op),symbol));
			}
			
			//-- show some info
			double slip = 0;

			if (OrderSelect(ticket,SELECT_BY_TICKET))
			{
				if (
					   !MQLInfoInteger(MQL_TESTER)
					&& !MQLInfoInteger(MQL_VISUAL_MODE)
					&& !MQLInfoInteger(MQL_OPTIMIZATION)
				) {
					slip = OrderOpenPrice() - op;

					Print("Operation details: Speed ",(GetTickCount() - time0)," ms | Slippage ",DoubleToStr(toPips(slip,symbol),1)," pips");
				}
			}

			//-- fix stops in case of slippage
			if (
				   !MQLInfoInteger(MQL_TESTER)
				&& !MQLInfoInteger(MQL_VISUAL_MODE)
				&&!MQLInfoInteger(MQL_OPTIMIZATION)
			) {
				slip = NormalizeDouble(OrderOpenPrice(),digits) - NormalizeDouble(op,digits);

				if (slip != 0 && (OrderStopLoss() != 0 || OrderTakeProfit() != 0))
				{
					Print("Correcting stops because of slippage...");

					sl = OrderStopLoss();
					tp = OrderTakeProfit();

					if (sl != 0 || tp != 0)
					{
						if (sl != 0) {sl = NormalizeDouble(OrderStopLoss() + slip,digits);}
						if (tp != 0) {tp = NormalizeDouble(OrderTakeProfit() + slip,digits);}

						ModifyOrder(ticket,OrderOpenPrice(),sl,tp,0,0,0,CLR_NONE,false);
					}
				}
			}

			RegisterEvent("trade");

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

		sl = (sl > 0) ? NormalizeDouble(MathAbs(op-sl),digits) : 0;
		tp = (tp > 0) ? NormalizeDouble(MathAbs(op-tp),digits) : 0;

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

		OrderCreate(symbol,typeoco,lots,op,sl,tp,0,0,slippage,magic,comment,arrowcolor,expiration,false);
	}

	return ticket;
}

/**
This is a replacement for the system function.
The difference is that this checks the expiration for trades.
*/
datetime OrderExpiration(bool check_trade)
{
	if (OrderType() > 1)
	{
		return OrderExpiration();
	}
	else if (check_trade)
	{
		string comment = OrderComment();
		int exp_pos    = StringFind(comment,"[exp:");

		if (exp_pos == -1) return 0;
		
		int exp_pos_end = StringFind(comment,"]",exp_pos);
		
		if (exp_pos_end <= 0) return 0;

		int expiration_seconds = (int)StringToInteger(StringSubstr(comment,exp_pos + 5,((exp_pos_end - (exp_pos + 5)!=0)?exp_pos_end - (exp_pos + 5):-1)));

		return (datetime)((int)OrderOpenTime() + expiration_seconds);
	}
	
	return 0;
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

	bool modified_status = InArray(memory,ticket);
	
	if (action == "get")
	{
		return modified_status;
	}
	else if (action == "set")
	{
		ArrayEnsureValue(memory,ticket);

		return true;
	}
	else if (action == "clear")
	{
		ArrayStripValue(memory,ticket);

		return true;
	}

	return false;
}

bool PendingOrderSelectByTicket(ulong ticket)
{
	if (OrderSelect((int)ticket,SELECT_BY_TICKET,MODE_TRADES) && OrderType() > 1)
	{
		return true;
	}

	return false;
}

double PipValue(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return CustomPoint(symbol) / SymbolInfoDouble(symbol,SYMBOL_POINT);
}

// Collect events, if any
void RegisterEvent(string command="")
{
   int ticket=OrderTicket();
	OnTradeListener();
   ticket=OrderSelect(ticket,SELECT_BY_TICKET);
   return;
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
	return OrderCreate(symbol,OP_SELL,lots,0,sll,tpl,slp,tpp,slippage,magic,comment,arrowcolor,expiration);
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
			end = StringFind(inputString,delimiter,begin);

			ArrayResize(output,element + 1);
			output[element] = empty_val;
	
			if (end != -1)
			{
				if (end > begin)
				{
					output[element] = (T)StringSubstr(inputString,begin,((end - begin!=0)?end - begin:-1));
				}
			}
			else
			{
				output[element] = (T)StringSubstr(inputString,begin,((length - begin!=0)?length - begin:-1));
				break;
			}
			
			begin = end + 1 + (length_delimiter - 1);
			element++;
		}
	}
	else
	{
		ArrayResize(output,1);
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
      retval = (string)(retval)+(string)((string)array[i])+(string)(delimeter);
   }
	
   return StringSubstr(retval,0,(((StringLen(retval) - StringLen(delimeter))!=0)?(StringLen(retval) - StringLen(delimeter)):-1));
}

string StringTrim(string text)
{
   text = StringTrimRight(text,0);
   text = StringTrimLeft(text,0);
	
	return text;
}

double SymbolAsk(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol,SYMBOL_ASK);
}

double SymbolBid(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol,SYMBOL_BID);
}

int SymbolDigits(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
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
		ArrayResize(symbols,1);
		ArrayResize(zero_sid,1);
		ArrayResize(memoryASK,1);
		ArrayResize(memoryBID,1);

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

		if (size == 0) {ArrayResize(symbols,1);}

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

			ArrayResize(symbols,newsize);
			symbols[newsize-1] = symbol;

			ArrayResize(zero_sid,newsize);
			ArrayResize(memoryASK,newsize);
			ArrayResize(memoryBID,newsize);

			sid=newsize;
		}

		if (sid >= 0)
		{
			ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
			bid = SymbolInfoDouble(symbol,SYMBOL_BID);

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
				return SymbolInfoDouble(symbol,SYMBOL_ASK);
			}
			else if (type == SYMBOL_BID)
			{
				return SymbolInfoDouble(symbol,SYMBOL_BID); 
			}
			else
			{
				double mid = ((SymbolInfoDouble(symbol,SYMBOL_ASK) + SymbolInfoDouble(symbol,SYMBOL_BID)) / 2);

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
						retval = SymbolInfoDouble(symbol,SYMBOL_ASK);
					}
				}
				else if (type == SYMBOL_BID)
				{
					retval = memoryBID[sid][id];

					if (retval == 0)
					{
						retval = SymbolInfoDouble(symbol,SYMBOL_BID);
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
	if (OrderSelect((int)index,SELECT_BY_POS,MODE_TRADES) && OrderType() < 2)
	{
		if (FilterOrderBy(group_mode,group,market_mode,market,BuysOrSells,"both",0)
		) {
			return true;
		}
	}

	return false;
}

bool TradeSelectByTicket(ulong ticket)
{
	if (OrderSelect((int)ticket,SELECT_BY_TICKET,MODE_TRADES) && OrderType() < 2)
	{
		return true;
	}

	return false;
}

int TradesTotal()
{
	return OrdersTotal(true);
}

void UpdateEventValues(string e_reason = "",string e_detail = "")
{
	OnTradeQueue(1);
	e_Reason       (true,e_reason);
	e_ReasonDetail (true,e_detail);

	e_attrClosePrice  (true,OrderClosePrice());
	e_attrCloseTime   (true,OrderCloseTime());
	e_attrComment     (true,OrderComment());
	e_attrCommission  (true,OrderCommission());
	e_attrExpiration  (true,OrderExpiration());
	e_attrLots        (true,OrderLots());
	e_attrMagicNumber (true,OrderMagicNumber());
	e_attrOpenPrice   (true,OrderOpenPrice());
	e_attrOpenTime    (true,OrderOpenTime());
	e_attrProfit      (true,OrderProfit());
	e_attrStopLoss    (true,attrStopLoss());
	e_attrSwap        (true,OrderSwap());
	e_attrSymbol      (true,OrderSymbol());
	e_attrTakeProfit  (true,attrTakeProfit());
	e_attrTicket      (true,OrderTicket());
	e_attrType        (true,OrderType());
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
		int total     = ObjectsTotal(0,-1,OBJ_HLINE);
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
			name = ObjectName(0,i,-1,OBJ_HLINE); // for example: #1 sl

			if (StringSubstr(name,0,1) != "#")
			{
				continue;
			}

			length = StringLen(name);

			if (length < 5)
			{
				continue;
			}

			clr = (color)ObjectGetInteger(0,name,OBJPROP_COLOR);

			if (clr != loop_color[0] && clr != loop_color[1])
			{
				continue;
			}

			string last_symbols = StringSubstr(name,length-2,2);

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

			ulong ticket0 = StringToInteger(StringSubstr(name,1,((length - 4!=0)?length - 4:-1)));

			// prevent loading the same ticket number twice in a row
			if (ticket0 != ticket)
			{
				ticket = ticket0;

				if (TradeSelectByTicket(ticket))
				{
					symbol     = OrderSymbol();
					polarity   = (OrderType() == 0) ? 1 : -1;
					askbid   = (OrderType() == 0) ? SymbolInfoDouble(symbol,SYMBOL_BID) : SymbolInfoDouble(symbol,SYMBOL_ASK);
					
					trade_pass = true;
				}
				else
				{
					trade_pass = false;
				}
			}

			if (trade_pass)
			{
				level    = ObjectGetDouble(0,name,OBJPROP_PRICE,0);

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
							int index = ArraySearch(mem_to_ti,ticket);

							if (index < 0)
							{
								int size = ArraySize(mem_to_ti);
								ArrayResize(mem_to_ti,size+1);
								ArrayResize(mem_to,size+1);
								mem_to_ti[size] = ticket;
								mem_to[size]    = (int)TimeLocal();

								Print("#",ticket," timeout of ",VIRTUAL_STOPS_TIMEOUT," seconds started");

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
							ObjectDelete(0,"#" + (string)ticket + " sl");
							ObjectDelete(0,"#" + (string)ticket + " tp");
						}
					}
					else
					{
						if (VIRTUAL_STOPS_TIMEOUT > 0)
						{
							i = ArraySearch(mem_to_ti,ticket);

							if (i >= 0)
							{
								ArrayStripKey(mem_to_ti,i);
								ArrayStripKey(mem_to,i);
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
				ObjectDelete(0,name);
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

		name = "#" + IntegerToString(ti) + " " + StringSubstr(command,4,2);

		if (ObjectFind(0,name) > -1)
		{
			value = ObjectGetDouble(0,name,OBJPROP_PRICE,0);
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
				if (ObjectFind(0,name) == -1)
				{
						 ObjectCreate(0,(ENUM_OBJECT)name,OBJ_HLINE,0,0,loop_price[i]);
					ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
					ObjectSetInteger(0,name,OBJPROP_COLOR,loop_color[i]);
					ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DOT);
					ObjectSetString(0,name,OBJPROP_TEXT,name + " (virtual)");
				}
				// 2) modify existing line
				else
				{
					ObjectSetDouble(0,name,OBJPROP_PRICE,0,loop_price[i]);
				}
			}
			else
			{
				// 3) delete existing line
				ObjectDelete(0,name);
			}
		}

		// print message
		if (command == "set" || command == "modify")
		{
			Print(command," #",IntegerToString(ti),": virtual sl ",DoubleToStr(sl,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS))," tp ",DoubleToStr(tp,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS)));
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
      subwindow = ChartWindowFind(chart_id,term);
   }
   
   if (subwindow > 0 && !ChartGetInteger(chart_id,CHART_WINDOW_IS_VISIBLE,subwindow))
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
   int success = OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
   return(retval); 
}

double attrStopLoss()
{
	if (USE_VIRTUAL_STOPS)
	{
		return VirtualStopsDriver("get sl",OrderTicket());
	}

	return OrderStopLoss();
}

double attrTakeProfit()
{
	if (USE_VIRTUAL_STOPS)
	{
		return VirtualStopsDriver("get tp",OrderTicket());
	}

   return OrderTakeProfit();
}

int attrTicketChild(int ticket)
{
   int pos, total, retval=0;

   if (!OrderSelect(ticket,SELECT_BY_TICKET)) {retval=ticket;}
   
   /*
   //-- check if trade is added to volume ----------------------------
   if (retval==0) {
      int p_pos=StringFind(OrderComment(), "[p=");
      if (p_pos >= 0) {
         string ptag=StringSubstr(OrderComment(),p_pos);
         ptag=StringSubstr(ptag,0,StringFind(ptag,"]")+1);
         retval=StrToInteger(StringSubstr(ptag,3,-1));
      }
   }
   */
	double OP   = 0;
   datetime OT = 0;
   string S    = "";
   int M       = 0;
   int T       = 0; 
   double L    = 0;
   int D       = 0;
	
   //-- check if trade is partially closed (in trades) ---------------
   if (retval==0) {
      OP = OrderOpenPrice();
      OT = OrderOpenTime();
      S  = OrderSymbol();
      M  = OrderMagicNumber();
      T  = OrderType(); 
      L  = OrderLots();
      D  = (int)MarketInfo(S,MODE_DIGITS);
      
      total=OrdersTotal(true);
      for (pos=total-1; pos>=0; pos--) {
         if (OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
         {
            if (OrderOpenTime()<OT) {
               break;
            }
            if (
               OrderTicket()!=ticket
               && (OrderSymbol()==S)
               && (OrderMagicNumber()==M)
               && (OrderType()==T)
               && (NormalizeDouble(OrderOpenPrice(),D)==NormalizeDouble(OP,D))
               && (OrderOpenTime()==OT)
               )
            {
               retval=OrderTicket();
               break;
            }
         }
      }
   }
   //-- still nothing found - search in history trades now -----------
   if (retval==0) {
      total=OrdersHistoryTotal();
      for (pos=total-1; pos>=0; pos--) {
         if (OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY))
         {
            if (OrderOpenTime()<OT) {
               break;
            }
            if (
               OrderTicket()!=ticket
               && (OrderSymbol()==S)
               && (OrderMagicNumber()==M)
               && (OrderType()==T)
               && (NormalizeDouble(OrderOpenPrice(),D)==NormalizeDouble(OP,D))
               && (OrderOpenTime()==OT)
               )
            {
               retval=OrderTicket();
               break;
            }
         }
      }
   }
   
   if (retval<ticket) {retval=0;}

  if (!OrderSelect(ticket,SELECT_BY_TICKET)) {return ticket;}
   if (retval>0) {
      return(retval);
   }
   else {
      return(ticket);
   }

   return 0;
}

ulong attrTicketInLoop(ulong ticket=0)
{
	static ulong t;

	if (ticket > 0) {t = ticket;}

	return t;
}

int attrTicketParent(int ticket)
{
	int pos, total, retval=0;
	static int parents_idx[];
	static int parents[];

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
		if (!OrderSelect(ticket,SELECT_BY_TICKET)) {retval=ticket;}

		//-- check if trade is added to volume ----------------------------
		if (retval == 0)
		{
			string comment = OrderComment();
			int p_pos      = StringFind(comment,"[p=");

			if (p_pos >= 0)
			{
				string p_tag = StringSubstr(comment,p_pos);
				p_tag        = StringSubstr(p_tag,0,((StringFind(p_tag,"]")+1!=0)?StringFind(p_tag,"]")+1:-1));
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

		//-- check if trade is partially closed (in trades) ---------------
		if (retval == 0)
		{
			total = OrdersTotal(true);

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

	if (!OrderSelect(ticket,SELECT_BY_TICKET)) {return ticket;}

	if (retval>0) {
		return retval;
	}
	else {
		return ticket;
	}

	return 0;
}

int attrTypeInLoop(int type=0)
{
	static int t;

	if (type > 0) {t = type;}

	return t;
}

string e_Reason(bool set=false, string inp="") {
   static string mem[];
   int queue=OnTradeQueue()-1;
   if(set==true){
      ArrayResize(mem,queue+1);
      mem[queue]=inp;
   }
   return(mem[queue]);
}

string e_ReasonDetail(bool set=false, string inp="") {static string mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return "";
}

double e_attrClosePrice(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

datetime e_attrCloseTime(bool set=false, datetime inp=-1) {static datetime mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

string e_attrComment(bool set=false, string inp="") {static string mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return "";
}

double e_attrCommission(bool set=false, double inp=0) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

datetime e_attrExpiration(bool set=false, datetime inp=0) {static datetime mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

int e_attrGroup()
{
   return(e_attrMagicNumber()-MagicStart);
}

double e_attrLots(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

int e_attrMagicNumber(bool set=false, int inp=-1) {static int mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

double e_attrOpenPrice(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

datetime e_attrOpenTime(bool set=false, datetime inp=-1) {static datetime mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

double e_attrProfit(bool set=false, double inp=0) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

double e_attrStopLoss(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

double e_attrSwap(bool set=false, double inp=0) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

string e_attrSymbol(bool set=false, string inp="") {static string mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return "";
}

double e_attrTakeProfit(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

int e_attrTicket(bool set=false, int inp=-1) {static int mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);
return 0;
}

int e_attrType(bool set=false, int inp=-1)
{
	static int mem[];
	int queue = OnTradeQueue()-1;

	if (set == true)
	{
		ArrayResize(mem,queue+1);
		mem[queue] = inp;
	}
	
	return mem[queue];
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

	int digits   = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
	double point = SymbolInfoDouble(symbol,SYMBOL_POINT);

	return NormalizeDouble(pips * PipValue(symbol) * point,digits);
}

double toPips(double digits, string symbol)
{
	if (symbol == "") symbol = Symbol();

   return digits / (PipValue(symbol) * SymbolInfoDouble(symbol,SYMBOL_POINT));
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
			ArrayResize(bank,count);
			ArrayResize(state,count);
		}

		bool Run(int id = 0)
		{
			beginning_id = id;

			int range = ArrayRange(state,0);
			if (range < id+1) {
				ArrayResize(bank,id+1);
				ArrayResize(state,id+1);

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

/*<fxdreema:eNrtXety47aS/n38FIr3j6cyySEAXu2dVPkiJ97j21qemU1tpVS0RNk8I4takpqJNzvvss+yT7a4kSIpiDJpUJZMzI/EEqBG4/J1oxsNtLvv7P8V7QOwvzsIJhNvEPvBJNo9cPeBru//5e9r+E9Eqhj7uyPfGw93D6J9a3/3pHt6+PH8lnwy93ejYBYOPPIBEwL8y9gN772Yfwl3D777+6A6NSiihig1WJEaxLxpC+TIt4w7VIMeFNJj/Ok16AEhPYPSM2rQM4T0dErPlDG3fFAxOUsWOUDJ2TV6a4oWCxs8RxY5NnZAq0HPEXbXYgRBDYJ2GUFYfT50IT2b0UPV6YlXn8Po6dXpmSJ6kC0/YFSnZwnpsfUHasBDOB+Qy74a+BAuGMikC6gBEKiVLZgaEIGghCCsgREIywjWwAgZreUEa6gQKF6ETMpAJI0gkzOwhhKB4mXIYAdraBEknBTEtbApjaDJCFrVCerCLut8UmogRRdCT+cc1kCKIYSeztYh0qSNIRPWCMhaNohzCKURZOIa1UGKcFIQk9dIlzaGDHqoDlKE0gaxdYjqIEW4bAze5RpIQUIdb/AdcA2kGMJZNviycSRtCg22rvUaQDHFBJk41GsAxYRlBIVAwZXPLj91b8T0hHNssinRa+BkCUG2aPQaODGFKgrxHtfAiS7cGZrcbjJlyRqLyRq9Bk4sMfAYknVbGod8UmpoFEu8rpmKMqRpFJMhz6gDFLFoYLNs1NAoplABGExeG0hal9nCNnRZNiOfE0MWPSZcDVPKZpPZLYSeJYseH78aKDGFClTnM+xII8gEg1kDJbpQMFjcpVIDJZZQI1tM0pg1UGIJpbXFFo1ZAyW6mEO2qk29ssKzhNJfZ3LBNKrTs8roSdMmkI9gHW0ilDMWw51ZAyeWcFlbDHhmDZwgscHDCFqaNIKsyxaQRdDgzscaONGFY2iyWbZq4MQWigabbeSsGtrEFnJoM9Fg1VAntnDPYDMkWzWQYgtFg83HsAZSHCFBh89yDaQ4QmHjsH2XVQMpjhDLNlvYdg2kOOJZZtCzpfmFbTaGdg2k2GLxxRa2jWS5wm3u+a+DFLOMwxpIcbQygjWQ4oAygpYsZ67DNiK2LcuZ6zBpYzuyfK8O08uONO+ww8bQAbLGkCPFgbLGkC9sB8kaQ5vNsqPLGkObT0odnSIUsBYnWEenWGUEayDFtssI1kCK7ZQRrKNThByaJj9rrKNUnFKKVbGCyDHvIljo1/y8TIN1aEIxTX7GpaE6NHUxTYPT1OvQNMU0+dGZVsdXvIQkPy7U6tgtlpgkPyHV6lgujphkspDq2C62mGRysl5H0xglUhLUOayHeomYBKAOfoB4wnl0BwBQIs2k53XwA8T4SQMV6uBHEIhCv+axBaCOD3lJ1/nKrHx+n/RRRJOHLFQ+wyc/Fu8x9GQl2XXYFCMoiVyofJJPfwzL2Kx8lk9JiiedH20DCCTSTPisAyLBHot+zVcSrAMiKAYRTIJz6oAIilc85CCqfLSfMCSgyU9pQZ3TfV1MkodIAFgLRE7p6qwDIgRKSdY5kRH7NTkq6xzyL/Fs8i0CqgMgJN5xJVFUqA6A0BIAJXzWApBYxvHDeYDqAAgtASUX76gOgJB4V8zP/AGqo4aQWMihZCXV2MeZS3DOZVydk39nyQxxEYccKVZLlqReRwuBJTS51NRrgWhJ1/mC12tpISCmmYRL1gERWtJ3IuS+04K7cTD4wiK+oUMivslwQEDasWlQeBwGY1qu7f+Ff+KwL11/4oWEnL6/ezbxKWVcf+hH7t3Yw6zd7WuMPe/P2AsnGQp4mn1cgbREyflRfzCL4uAx+ZGdcMUYJp16imLvkbfxGAy9cd8f8tav3Siix464rakbuo8ebg+TDIJwSAu0/V1OZupPJnPe8DBGA3fs8cJJED66Y0oJ/yLyCK04CDOME0ZiN57RryCfiWASjEakNxpjZ+jGbtrqd1ol9mPWSoZb
TAv/jvaQ08KFY28UE1KOweYpDqbko24QQrj8m0sGmnGPB+6rG/pktDMs4jEIZvF0FkdZuj7+Lvkd/uilH7/TZgYRrU3XFiBLwh18uQ+D2WT40yAYByFfZ/8yoP922dDlShD9R8cO4MWJ18dP3zz//iHOjgTQ5+upj1dF6M75BnhR3OEJ88KfoviJjRb7HQvzFy5IYJMv8UAcP7hhfIGXBZciP4FkQdCSq8lpEHqsR/yAWkvmmVboPfijOFdi8JLDWRz0BrjBsfiHyfqZN4pSmsG3q9/Oj3O/MzOFR/7wHINoaflh9GWh3MqUn7tRXKwAjUyFay/0g2Evs5AzlLJs/hr6w6VsfArGs0cvRdjxb4c3t/1PV+cfL7r9385OurRZkPnBiRcNQn/KL5JkeNMylW5Dd+ide1+9cZ4tO0vIjb10gNMaTraHoT8QVDGys3Pq/8kuVSSRZfOu8+J5oVzxBl8u3ubj4cXXYTD1wtj3Gpd2BlMDyaiwniR/o8zfeuZvIzuKL5aUEE8SBrQ/euoMSP8701zvS6UnsvLi09A2Q3yORtaIRQFnxSces39pSHCipYKT8poC8pjwcpRyzdfhYBwejfGXOezSqnlpyqp+fvBjhkI9WzURLQV6KUR50+HHqaiWVah1EnybrOTuaDYeH7uTIRuL8qqeGz6z6knwT39p1TyjGYlZrIdyrYuHJlcHKwFRndwYE0Wwkv8eBsNc3uaqypV6SILU0+dSjzK/Lfs7opxyUmuQcl8usRwtJ7GIO7SdIktfJrIMvtX7FXM5TbZ6uCcu25kZvCSzHsgs954e74LxYnUzKcrWx705mj1FV2HPGzOY4E7c4W+EEMEt0k1MHYzoEjCC2/coA33630vvW9MgQc/bFkgBEuKj2xmEHt4GDldCyMzrfGDLQhB4GYKGuuuSbq8NQcZGIYgsL/a3ZAgZCkKyIQSBwtBuejFeiCHrVbUQ83WMg8hLaCU/Mvn313jT4btpU8wilow8U45Zm0Ue5X3YNPj06matFCDCFIhpNyvZr+3FobVROJzrss0AoqWA2CwQDaQpIKZvsSiFuASHtsJhszgESC9oRL2tQHSURixBoqOQ2DASDU1TSJw/ACaEok4PV/Z3z4O0n3yFMp/DXRCMPXfS5/9P/PEZCvQ3uFdH8xrEnI/DmTfY37847N12b9Jz6Kubm+7x7dnV5Zw7NtiD4BGvseR4+sMH/seNiC1AZmw88/r0v8tYwsx/SsrT49TlPJCiQRhE0Td/GD/kjlnLRl1mhIn2colABFswGfrkQHtLziEwgQsXdydcCWi7aGpqmwHn09OT40OnDpwFkLUJdHx3ck8+Jk/ttRu62uZDF7QVusdj35vEq91EekEVO63A7vJoMI1vgT/x/qbRPl/398+DmEnEIz6uFAxgXXDKcAVFXPWyXMFX4ArlUUCpoHXtEzJ86AI+9FfgwxDwYayHD8liFMo5KGNhDZ/momSzQtC0TAiaJsk4MtNgjly3y12G+f0U3JTQXQP/Y4+4FUN37+i/poyk5SFolGPigqDx6sdJ8C4J/PMnceeBxlp1PnRO/bF3NfUme7sXffDzIPq6+/707Lzb/3xzdtv9H/rn8dXFxdXle+398XX/4+2p/e6gs7Pjj/YYjR8+nF1+Ojw/O+n/dnh5ct59t/PXzt8I1Z7nfeF18G973e4/+r3u7buDHVb8OfRjLymf6w9cXlLcIz//vuONI6/z1/edHVKTuhB4TVIsO+IKyAi5ItKI/jiZiW0Ip7cSpjsX/36udwaY9X+9C38JvZ8i96vXSUHWwSsq6Iz8lLmSXVUewAiINlWvEGX/Qk+GWOSUQleXCN3j14Uu21EvhS4rfhXo6gq60qALC84MBI22YteoayRxpGyYkcQBqowkZSQ1YyQZykhao5GEgKaspKy4NtVR0nr80S85XAamOktaAeuG7t1ttD/aqmgmIbTcTLoibb2aoXTrD7548YXQSrp9mnoXS10fwgIeWyIs
O6R55i6yFlfnOHh8xLu8vV0vDPEU4Q7+6sXkbluXfN7Dn6sYZS9CuqWsMmlWmVWI3dKt1npU7IpWmUbtHw7LFSYZcb54XzF+WOyS13fjOGQ/XaaCdbp1q22dMe44yleYZkLu5hFmyyTnM00yKz1MW2GZkXcKFtjAv4texoTOf04mi8jJjbDL+PxwSbsZJtqLhLLdChutgbcUpBxkWS030Rwlu5XsrisoYdtlt6Nk9xplN9SU8M49IKYp4a2E9xvaeMN1Cm+oKeG9zsMRsyi8tXYLb6CEtxLeb2jnvV7hDZTwXqfXBCjhnRPesEnhDQVyKb3lXF8wKUGtdtmEJbRWQQ2VoF6joAbF23MQttxHgpSkVpJ6S7fU65XUSEnqdUpq3VGSOiep2/FGMlSPJEt/4RVoQD3fw1HUkneSoXooWT6MgKlgxGGkri5om391AZrqLZ1yRMNivJvRgrsLsPLdBcshcxL6k/sO/t9hGP4n/ONgZ+dZt75vuocnJXcZdkqvK5AW/A/awc63B1xt7wdS+Szq4vU4uU+uAtBLD/5oz/8FM+Y+9fz/9vYYl+/eLdwv2O/4EyLvI68T4YqdYMR7JL548DfeXf8P3sMbzx326Eik/JKbDv6PPx7sLLmnsDO/X4uJ7A2DGV5I7zhhDY/j/KbrYjn4o+ymg//I/q4sGNRNh4WbDnhRDDM3HUYhrvOsmw564e0I0Nr759BWFxrXtyuoDX5bXWhc8RZMAdCt2BQsjXQ3+XdHM+LzPzvh7AzG4a9Y3fLV8BKrmS60xFaW5H6qDQ5Jb0mzwcLseoOY7Ire7lvSZtJZspeipspq565dsKPRhlwZNizDOj0VuXZP6b8lOCOLMSB5uV+StFOrgj+qRsbhhXuPt43uK2FwpfOqLgiRpkDYPAhh8SFZZCgUgoafmUVEb5GJ6rP/CbaVq/Ut2TFjSxO3l9uE8fWLeTyMsW6/m8W5s1v8PU2cXczUgP9/48WzcCIoeOZZfOExICiv44uCbpM6r16G2uSXoV6kgt5uAK22gU9DFTaEUGt3/CyC6nhl8x0pCKrjlVVxB4XjlTY8DYWQ8qQc0GFQRlzjRpxViJIDQBlxSFeulBSFukJh8yh0kELhAgqbfoxauVKUK0W5UrbAlWIoV8oaXSkLO0Kn5b4Us9lotwsV7VaMduNnIUuj3XjOpHVFuyFTRbtJi3YDWjF3rNbWcDe0NI5WZ6IFEucexeOtMAqJ7OR4hXP3zhunahlbhx1hNZmZWfBYaAtnl2Ue1wK3MMvt3CNY5BbK5jZjHlTgFiUNE5u7ZHBRM4Pbq8iunmN3+ejqzYxuVXYNvraPep0TfyRiVNLeFaWM4nZGR1X5NBOfzNEyPs0m+OxVXa1W1n4qcGit7YilwJRdwpT9Wkw5JUw5a2NKLwhyLcuVXhDf2quxBcrYAq/GFixjC74aW6iMLfRqbOllbOmvxpZRxpbxamyZZWyZr8aWVcaW9Wps2WVs2a/GllPG1qtJeVgm5eGapLxUW5n+gaxdOQ47PhyHw6/uZND8gRHUXvbUib9vZv62Ml49O/O3k/mbvqqQfgDZDzD7IestBFl3ITCyH8zsh2z7IMsAyHIANbkOx/ki7uzN7sdP71Y/fag3lP3rhT6CEf5nmGu8Eo/sWt4AoWmnvAHKG6C8AcoboLwByhugvAHKG6C8AcoboLwByhvwGt4AW3kDlDfgud4Aq/DQZHu9AU7FqCPdMItRR0ZJ1FExZbiKO+JPkouDjuiz2OJ4I2KUL5aQiC8e1k8K2cQkhQgX8netF3+p40L5IUyOCmGSFsJkwbzL0jTbGsGka7XumVbfuGDWQPZ1+le+XAo3/3KprrXycikhzHyknaOPvz8jn8dCMGIbrpjqS58pMRAf9OI9tdxFtMXcGeSbT8F49phe68A0Rv6f3jBfSvR+8o32M8ikvSDAmNe58aMvHLaGlieRFOHBhD8biaeOlV17eEvEfNv4O6Bpyf0zVnxEFn6mTpoD
Av8xzDIoQUwg2sFVgsImN2jwKN24GGQfJ36cDBDxof+sgfk1m6TSiTdmyx8zx2xGUv74eHF/hn/uu+MkH0iGAZtVuJiNY386frqanAdRlJVl2Nop1LgOg5Ef5+57WKzO4XBImsgRYXw4hQo5GjlWbzwMSAEFK1e8jAeAoLm8syipcuN9xWIqXYzuOPLmNE79u2ApDZJ45vHxBEuuxzsvjFcMbFpvSYOQcoSN/GA2ePBCbzk5M1/x3I/iZPWB9/A9eq+/N96b87GeV13WV9p0z/uvI7yXFjQIePF8KvCvEW7KzP1aOBWQFy5r2kxQ93E69cJz/9GPsx4O/PMelrqk3URk6ERFTLxi8bU/jXKygKzWtJChmd4oS3FjGMlEF6rdXhdEA6Y0HCeV1vmI53AqtdV8l8raHUptNyumyn1dt+4Xj60i0XTnKixOOMwVl0y5I6jYOy+MECSTPq+2tmkn7U4lt/u8iSctDyW3/Lypxxjs/pm9Cv/r7THf4+DvT9yn7AbSpl/+FszCqDimhIg/mcVetj7ZDOICQXe0pDsx3kCLepNsfghnt7xO1j1KvmMelmyJwwti93HKBZ6m7c+XFSk8pj4Ffmc20wNSduGG/MJtIgad7I/IXyOyvy4qRVoFWzUYLpP4d88NsyTsQvkF7udDtoJZqHDC7i4nxUX6ZPw5/NhhWspk2gKdiaLuz1XpeXi4h7kqaD7avQd/FOeMKZ2PLCkgHcxOMzAyhbR3UcFXnpZ+9rwvUeEQNy1MVls6K9lfpquuMGqs0YWllytmnRUWf/GnhKchb1pnLyUxbOCJ64396dS9T8ZS54vs4ok7xMQ580ivDsMw+HZMDIOj2dP8YvoRRad8P74OJPjx6dsIT5fBtxZkLbNYKNOEdXZFrrLiC/BOQ7nKQEUrVNNsjUm34p3bEf3XwPsPuJehN4gzxipUxqoyVpWxqoxVZawqY1UZq8pYVcaqMlaVsbo1xqqeNVbJDQS+RcfW6o03bMRYhRKMVYtdl2iHtWrzuyHPMVeRtZB+RdsMc3U00l7fXEUV3y1cAEzZo4WNhKIW3xBctJhLnhPEP47xOPXJf5bxQ0QXL67+qJ+VpsiQ/7bf87YFxef9bDZjSTCK9Gf+tIrP/PH54iFljbz4p63zxT8dHbzVF/8aFuP1XvwrynPdMlr95J+utzOsbQuST+p6O8PaQBrW1uuen1dPQdmSuDZjTcClTs68ylXYXYldo5XYxcXkzsXqfHpmHrO204a8sbrZWshuQxS52UrIkuuG5H7Q6q1z4TFb226FmrVai1m0BZi1FGbL73wUEtfaTitAa6ucgFsAXlvlBKy2S25FTkDdUeDdAvA6CrzVtstaG0xcQ2s9eLfAO2VobQXvfJWs2DcXLkvboBXoBdXO8ws519qTeXCegDHzSKnKQ6jyEL6RPIQGUHkI1xiVAAteGqi1OyjBgEoPVdRDmdenlR5Seuit6CGo9NAa9ZBTeO2t7flwDdRwXva1hDirNOlKLbwxtYCUWlhrmvS8WkBmy9WCrsyTZsyTpvWhUglvViXoSiWs01JAmlIJWZVg1LUUMinklKWgLAWlFuSqBUOphXWqhaJWaPk5hqkMhWbO05WhoDRCTY1gKo2wzqNtZCiVkFUJVsVkVwjhTj0zs9Xnm7PbbklqK3/Es0D98OHs8tPh+dlJ/7fDy5PzLs1YVZr3ihV/Dv04yST1nj/jQrJNLZaRa/7CEiLjhQX8CRZhGb8URfj4vuONI28hjZY4W5Yw/ZXwFSY8neT5x1oSRcIlpLeWcCpyv3qZhFN4/QbPSzgFCncedOERZBsSThm2elxJPa7U+seVXiKY7QP1ttL6tnqgYP3rqOU+4aUX2ZDG5+Q2GXDyFDW7m4Dxx2zgq3B+04gst6u7fx4/uGHcm9199idD9njh3GQnxUHIQUOeHsUAu+ze9G/Ofv3ttv/x+ppde9Bpzf/gaDTmX/2ePF2uJ2+m4i8pf6cBYwLz8KsXhPe+
m2EprXGcGVfiaqCPDLJ5yVZLnlEnb5imb8TjCjQvdJRp6pMXDt2Jm/QmVyVti8wabuzEDb+kvg2rUDl92X5/1+a0cfmSlmBamLZh0yY+P/hxek+fVylSxl1lWbf5B6aKG9DE/KmA7MOjy4V8whXkc03UjXz3SoXnvRKGEH94GGtk+QrZZvykSQxWs6MvZFMo0ccVNytkXf3kLGZmWMGSwblgCrkBfVzpzYmEK5Pj9zJ3aGVK4chkDDHSz+DFSnjJeQwtqbz0nsmLLfCR2Y3vc2W7x2Td66XGeffPpjdLoInc9SCTux5kcteDQu56SblzMk9Kl2+wjEJ8LtTamjPeVPeMt+CesdnOe8aY5bNR55nvBAADFFKst+GmsVnxpjFgzptFy6hkZ11R0eZuh8sNmmn6dE6dVr7V00rzbV3E1dZ3Wmkmrwg/IyVhMSeh3m7HlQk3UTgfn591L2+VcFbCeWOEM1TCuf4zWimcV5wHI00J56xwRqUBJNRcmk3wqskmOpO98CXcv8Mfr90oupoMtiXcgR6qsLHd7xDeOwFnfkUEVH4BO9aGvOJonx4d26frdNosDYdtwPUg5zXv8+Dex6vs6mZL1ig5v7p5xoXO/JI0bGNT/Ije3fBunUtyRTgeILHNeBRvH/yoMYFK/zAtCXn8SFe5iKJsb4tk1TOSNWV8RSKngs1mbMq+YP1idWmgmMF3BDRnfCbVq8vyUgqyydP4U3ZGyavT5ZY5EZ0fjyY/AeSqwVN0RfNdJsk072Ykr6ZsoS4joAczdxmQ+FlvSONnG99vo+edUElKbXkZdPDKGa7el9gFvzPclKfhD51j53StAHI2DUBkdbG/ZSPIUQiShiDH0BSCKIIsrS0qyNIUgKQBCIAigIy2Agi0RgVZQCFIGoKgYSgEMQTBihfrIDSWXqy76INXu1Y3fxNk6f05dkc6dxuu0mU3At9keVWGL1S33aTddoOFdNQmMlp6281CleGrL4Xv8evClz/+uQy+/C20HHzXhl6k0CvvriqEBfjC1sJ36ZOISHKaTJRe7DjxR6PeUaVIXNze3+UG4j73nsnSEacU8QS7w3/i5cnX3I/az5qWXCMKvWg2jvkU88sRsvfkEl7Pww2cYhzPxu6WiIQ8wytCxAqnDcRy3ZATM9vWNElRuimajVJlTKI3ngbzK6GooUUp4e0unQieYLotp7eAsdvZm5Lwgt3JbifGoxe9q+xJAaC1UQaW+Tqq6KjXQlXUk496U6miMqQjs12qyKquihpYlJZSRc9VRQgtqCKjrarIrvrYl+WQiQv9yX0H/+8wDP8T/nGws/MsP8dN9/CkxM2xU+rJIC34H7SDnW8PuNreD6TyWdSdDDEriUOC+kP80Z7/C2bMfSLPH+wxLt+9W3iQax8b0oPQcyOvE+GKnWDEeyR+qetvvLv+H7yHN5477NGRSPklDhX/xx8PdpZ4S3bmvhdMZG8YzPDiescJa3gc586XxXLwRyP+Flv5W4r+Frwohhl/yyjEdWp5Sy2trW+DWU6zguVCCZaiYOFnMksFCz+UWZtgcZRgkSZYACzEwlmwrZLFXhrJs/pZ6Q0M86kLL1tGmE86WJhdbxCzcIWmYaZXfw9F1otxrLNEINNxX/1iXCF+Ttc3xGdlWIa1GLzAHkUg/5YgkixG+uzZC0wGG1TB32JajU2MFKoNQqBA2DwIIVAoXEAhbDidz9tM46DyB6kr/pt5xb+2ClIJqNf5hHBhQ2iAdt/1t5Eyxg7oMKh9YOP7QKBphY2gYaiNoK7MsRSGuoLhGmAIChmTFAzx0qudXpWfByp7TNljyh57A/aYyue61nyuTl4XGS1P6WKrhK4NJXRVekjpoW3SQyqL7FqzyALlGMzpIUvpoYp6iAd+Kj2k9NBb0kOW0kPrTHFZdM613iCyG3bMrSVPsfKTKb3wxvSCrfTCOvVC8dKbAfV26wVHGSjNGChNK0SlE96sTnCUTlinTtALN/XbrhMcreGgamUr
KFtB6YXKesHRlF5Yo15AdkEtAKPdagEoU6GZM3VlKiiVUFMlAKUS1nntpeg9artKgNuWTqQ20GTcL1PJEBIvbPFBAUNvaTYEB21dPpHaEEIKQvIgpNuGghCDkN4aJaQrBElDkK4VAKS3NSOPY7RHBxkKQdIQZCw8C9VaBC2NrtIlP2Wuz98On5+1PPstc9z0Dx/kPmae4ShzMF7CET09CYMo+uYP44dcpu4VL+TJzOLt2BKyeDskG3bG5bgFrzIWWS7P3V1Im2NoGwLw09OT40NH0gvmeFJjzP7knnwkYHZeC8y9jQPz0XaA2VFgXp1GHBotBDPQtHVlGXkZmnGDP70qmCtkG5kjYJ5nhExGPt2X5NQOQJNw/P2WE44YeiFJs/GW840ADbwWsI82Ddi99QH7qNcAsIECdhVgI/C2gQ2Vxn4jGhsqYJenM9DapbKRUtlvRGUjhexKyH7rOltXOnujdHbdAzIykwrZZVHhVt6NZutvG9iGUtkbpbLrA9tQwK4CbEd728A2lcZ+IxpbJeJeEW1cOPmyDeNNI9tSKvuNqGxLIbsSsh3wppEN9DVFpjgMR7dPU++iakzKB9kxKfzC5iZHobC5aWMICiHMhH/n6OPvKxFrGnnAAm1Tkhg2G4UCjHYiF2wDco12IhekyO11z89Xx49ZLYXu8lQC/HbEMWYJDyN/HIaqK+lrVIKNhz9eu1F0NRlsSwp5koSKD+5+h/DeCTjz5WHLhXsJjrkhC9U+PTq213kvAYC12YIoNb0SP0c1U/DvcnWPPTdNZdmA+MOP2s+aBhYsQYMagpcNRFAAZQGW7ycLT7cB8La9tsB+HTwf9VqI5wbiJoCt8Fy6ybRbhufVz+/m7t7itu+TG7cvvH1L6uJVzquvusnOJMJ5EExP/NAbpHYOWV5hMPJjMhc/jfwwSh7xInV7X/xp/i0u8m33qxc+LX597j/6BXVKh55s/LqT4W72+R+ZF4iIpAMybhCRh5Ror2M3jOdZRF/7IaVCwlTpDynpFN4dzx08dG6fdXHY1M0Cyi1nM3box11NO+6+SupUAJfeVIL8u97Yn07d+0TF6smaOAzD4NtxKpMAfR7vxPOm1/7kSyN4gZqcG3cELsfjINoWi5SsioTd8iVu5W1QgMyGjiZAdUU2IP1dnxEKwWYruflrE6+g5Xpr1HIQKC23Pi1nL9imtqG0HIRbpOXglmk5kAfKWjWe7RQ1nqW1VuMhdVC/qcd9EKmD+t+fc4Glncd9UFcn9RsLXV2d1D/jpB7osKXYNaoe1SP5Ln5oqKP6Zx/VA6Sps/pk02iqs72tPavnBqO5q873yreVoF0HfFAF4GzvgT0HtaVAvWK/iVoGalud2m/CqT201XnG+s4zAHAWDjQ0daABnS060HDUsf2K/SksnmJorT3FQJo6t9+Ic3ukKT23Rj2nA3VwL5AGYHv0HAJKz61Y4/qCnmttfBqCpccGhO7heBx8uxpn8v1g5kbumAx1E+tXRuAJGSqygMkpwjXjZQuWMNRI/YHXmXohy0P0dzpvqyMui4de8p5cBC92Qqx7RaONW9FIreiqK9o2ijIaGK1d0frGrWhdreiqKxoAq3DzA+qotUva2JwlzdhRy7nickaOU1zOsLXLufydDOr9CWbhwDtO8ogi3B9/Ence3Mlw7HU+dE79sUfyau7t0gX/8yD6uvv+9Oy82/98c3bb/R/65/HVxcXV5Xvt/fF1/+Ptqf3uoLOz44/2GJUfPpxdfjo8Pzvp/3Z4eXLefbfz187fCN2e533hdfBve93uP/q97u27gx1W/Dn0Yy8pv/UHX7z4AhcKyki8nrCEHHUKC7gXS1h2SJ1VpGzn+46Hgd35q3McPD56k3hv18OGc7iLO/irF5+7Udwln/fw5+87O4QSNU05JUKhGT0nI6aBHv/SHyezvwVyQbcSpjsX/36udwaY9X+9C38JvZ8i96vXSTHdwas46Iz88TPeJtELVoop9C83eig6oP8k
ywaxjCuXGFa5xMCM3Hh4HG8f/CiN2APNLHIZZ/ykszwGjvK9LaF7eiZ0L2W80l0Pw9mQ8/71R+2hZ6b+1fMBNaTLk6E/oJPZ9y8OBTE1Nid6cYg3Jn6QnDEYvLMXh9GDP4rnJw+8Ml5qD0ESRnpxddLt9xh50o/D6XTse8Pr0B+kscXXN2fHWK+eX/W6y3J04++uszwkIRW9hIPMGY8ozIdW9gf9st6btAb+LiE0r0IpLEQs/ZKLWJI0wJgCu9zcwhGuHOOfymn6q/7iz+RaKPaByvK68oFNu2CR4FFrQeg/cpQYVmJYieGmxTDfLquE289IuG0X3Pfysvttrij+Tr/AIxL7k3vGu5Ww4w5i/6vXX7oSCfVpGPzTG8T9CV4G1AbHTf/f/+79W3AXxO86h3SBd2698NGfuOPO3rE7HszGbuy9+2/2uEWWRvw0TdaG9ycWLXESKEQM+f4Yszzj0Qp4LImFn/QeLwHMZujh/9GJM2xo6gYElmGhbBW8mv3R07Iqj+49hnlEwm04F5btGCbVG5AE1PuRjye9P/bvQjd86qexUznQAGdekyJrWT2y0MhI9iMPj/AwCQTWfmbx8oSjaeBP4n444ysNkfAcLbO8RiEB8nCfBtkzIRwH/AtA1eySyovVNfYDuPQH4l98Z2JgFnn9r34Yz9wxHsBgGnGVMAnmg5cp7ZOOUywwFJMxIyQ8PBz33mTwJCBC6hTK+6E3zop9URV3mNMMZFS9r94kjshiSNZS7A++pARY6eBpgCcw0W88KooUTwjw+9EUr7Zhn4q+3IVcNK/CJde8EJLh88i90H70EHzrZ9VIhoRFwvLc6UM/CElODDeVt7jGbTC9DY6CmEpwdosvQQ+GjB+mlefBcINg+hQmggEvQQrNTgodLxqE/rTwMyIVaaxP+g1m6iuW8tlqqZ7CPZ1k5J5JdH3vtnuzuL3IFDFFhmV3gnoa9MSjCZcyZvB7LcnEhTMv2eRwL+xio9myhVapigmx7Ht+uwYfQyY9i+oAWIn3PJtmZWGfVSgX8TUMZnfzC8Wr+UqD8HLEeysa7zXTeJqpaUnjmUxOTTXeW9G47J7T+LP0Mlex6XxpQw0f9coaPpLdY4tsBujRixB1aZnURskOhL3BUGxyXiK1QZ2hZbG9tEBGc6nqZ+OaRlILxjUTZf1yaZaIckyXn20J20zLpA4tbuFSgBX+9UJT7PyxZjs9cTs9me0Qc4+J1auQCRmxiV2sI3MiMfP0wZhiu8n38nqLO8LetxAAI3n4QlZbdqrE/2OxvVyhvLFkwsbFO728oZduhHhQ/HNMpWdZBd//Hy6ZAJk=
:fxdreema>*/


//== fxDreema MQL4 to MQL5 Converter ==//

//-- Global Variables
int FXD_SELECTED_TYPE = 0; // Indicates what is selected by OrderSelect(), 1 for trade, 2 for pending order, 3 for history trade
ulong FXD_SELECTED_TICKET = 0; // The ticket number selected by OrderSelect()
bool FXD_ONCALCULATE_FAIL = false; // Flag that causes OnCalculate() to return nothing if some indicator is used and failed to load, which means that indicator calculations must be repeated


//-- Functions
bool OrderSelect(int index, int select, int pool=0)
{
	// SELECT_BY_POS is 0, SELECT_BY_TICKET is 1
	// MODE_TRADES is 0, MODE_HISTORY is 1
	
	//Print("-=-=-=-= selecting pos " + index);
	
	bool selected = false;
	FXD_SELECTED_TICKET = 0;
	FXD_SELECTED_TYPE   = 0;
	
	//-- SELECT_BY_POS -----------------------------
	if (select == 0)
	{
		// MODE_TRADES (trades + pending orders)
		if (pool == 0)
		{
			int total_trades = PositionsTotal();
			int total_orders = OrdersTotal();
			
			if (total_trades == 0 && total_orders == 0) {
				// this should produce error
				FXD_SELECTED_TICKET = PositionGetTicket(index);
				FXD_SELECTED_TYPE = 1;
			}
			else if (total_trades > 0 && total_orders == 0) {
				// only trades exist
				FXD_SELECTED_TICKET = PositionGetTicket(index);
				FXD_SELECTED_TYPE = 1;
			}
			else if (total_trades == 0 && total_orders > 0) {
				// only pending orders exist
				FXD_SELECTED_TICKET = OrderGetTicket(index);
				FXD_SELECTED_TYPE = 2;
			}
			else {
				// trades and pending orders => merge them and then select
				int total = total_trades + total_orders;
				int next_position = 0;
				int next_order    = 0;

				ulong ticket_trade = 0;
				ulong ticket_order = 0;
				
				int chosen_type = 0; // 1 = trade; 2 = pending
				
				int idx = 0;
				
				if (index > total/2)
				{
					// newest to oldest
					
					next_position = total_trades-1;
					next_order    = total_orders-1;
					idx           = total-1;
					
					for (int i=total-1; i>=0; i--)
					{
						ticket_trade = 0;
						ticket_order = 0;
						
						if (next_order < total_orders)
							ticket_order = OrderGetTicket(next_order);
						
						if (next_position < total_trades)
							ticket_trade = PositionGetTicket(next_position);

						if (ticket_trade > ticket_order) {
							chosen_type = 1;
							next_position--;
						}
						else {
							chosen_type = 2;
							next_order--;
						}
						
						if (idx == index)
						{
							if (chosen_type == 2) {
								FXD_SELECTED_TICKET = OrderGetTicket(next_order+1);
							}
							else {
								// already selected
								FXD_SELECTED_TICKET = ticket_trade;
							}
	
							break;
						}
						
						idx--;
					}
				}
				else
				{
					// oldest to newest
					for (int i=0; i<total; i++)
					{
						ticket_trade = 0;
						ticket_order = 0;
						
						if (next_order < total_orders)
							ticket_order = OrderGetTicket(next_order);
						
						if (next_position < total_trades)
							ticket_trade = PositionGetTicket(next_position);
						
						if (ticket_trade == 0) ticket_trade = 18446744073709551615;
						if (ticket_order == 0) ticket_order = 18446744073709551615;
						
						if (ticket_trade <= ticket_order) {
							chosen_type = 1;
							next_position++;
						}
						else {
							chosen_type = 2;
							next_order++;
						}
						
						if (idx == index)
						{
							if (chosen_type == 2) {
								FXD_SELECTED_TICKET = OrderGetTicket(next_order-1);
							}
							else {
								// already selected
								FXD_SELECTED_TICKET = ticket_trade;
							}
	
							break;
						}
						
						idx++;
					}
				}
				
				FXD_SELECTED_TYPE = chosen_type;
			}
			
			selected = FXD_SELECTED_TICKET > 0;
		}
	}
	// SELECT_BY_TICKET ----------------------------
	else {
		if (pool == 0)
		{
			// we don't know what we are selecting, so try trades and orders
			selected = PositionSelectByTicket((ulong)index);
			if (selected == false) {
				selected = OrderSelect((ulong)index);
			}
			if (selected) {
				FXD_SELECTED_TICKET = index;
			}
		}
		else {
			selected = true;
		}
	}
	
	if (selected) ResetLastError();
	
	return selected;
}

string OrderComment()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetString(POSITION_COMMENT);
	if (FXD_SELECTED_TYPE == 2) return OrderGetString(ORDER_COMMENT);
	
	return "";
}

double OrderOpenPrice()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_PRICE_OPEN);
	if (FXD_SELECTED_TYPE == 2) return OrderGetDouble(ORDER_PRICE_OPEN);
	
	return -1;
}

datetime OrderOpenTime()
{
	if (FXD_SELECTED_TYPE == 1) return (datetime)PositionGetInteger(POSITION_TIME);
	if (FXD_SELECTED_TYPE == 2) return (datetime)OrderGetInteger(ORDER_TIME_SETUP);
	
	return 0;
}

string OrderSymbol()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetString(POSITION_SYMBOL);
	if (FXD_SELECTED_TYPE == 2) return OrderGetString(ORDER_SYMBOL);
	
	return _Symbol;
}

int OrderMagicNumber()
{
	if (FXD_SELECTED_TYPE == 1) return (int)PositionGetInteger(POSITION_MAGIC);
	if (FXD_SELECTED_TYPE == 2) return (int)OrderGetInteger(ORDER_MAGIC);
	
	return 0.0;
}

int OrderType()
{
	if (FXD_SELECTED_TYPE == 1) return (int)PositionGetInteger(POSITION_TYPE);
	if (FXD_SELECTED_TYPE == 2) return (int)OrderGetInteger(ORDER_TYPE);
	
	return -1;
}

double OrderLots()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_VOLUME);
	if (FXD_SELECTED_TYPE == 2) return OrderGetDouble(ORDER_VOLUME_CURRENT);
	
	return 0.0;
}

double MarketInfo(string symbol, int type)
{
	switch(type)
	{
		case 1://MODE_LOW:
			return(SymbolInfoDouble(symbol,SYMBOL_LASTLOW));
		case 2://MODE_HIGH:
			return(SymbolInfoDouble(symbol,SYMBOL_LASTHIGH));
		case 5://MODE_TIME:
			return((double)SymbolInfoInteger(symbol,SYMBOL_TIME));
		case 9: {//MODE_BID:
		   MqlTick last_tick; 
		   SymbolInfoTick(symbol, last_tick);
			return(last_tick.bid);
		}
		case 10:{//MODE_ASK:
			MqlTick last_tick;
		   SymbolInfoTick(symbol, last_tick);
			return(last_tick.ask);
		}
		case 11://MODE_POINT:
			return(SymbolInfoDouble(symbol,SYMBOL_POINT));
		case 12://MODE_DIGITS:
			return((double)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
		case 13://MODE_SPREAD:
			return((double)SymbolInfoInteger(symbol,SYMBOL_SPREAD));
		case 14://MODE_STOPLEVEL:
			return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL));
		case 15://MODE_LOTSIZE:
			return(SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE));
		case 16://MODE_TICKVALUE:
			return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE));
		case 17://MODE_TICKSIZE:
			return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE));
		case 18://MODE_SWAPLONG:
			return(SymbolInfoDouble(symbol,SYMBOL_SWAP_LONG));
		case 19://MODE_SWAPSHORT:
			return(SymbolInfoDouble(symbol,SYMBOL_SWAP_SHORT));
		case 20://MODE_STARTING:
			return((double)SymbolInfoInteger(symbol,SYMBOL_START_TIME));
		case 21://MODE_EXPIRATION:
			return((double)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_TIME));
		case 22://MODE_TRADEALLOWED:
			return(SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) != SYMBOL_TRADE_MODE_DISABLED);
		case 23://MODE_MINLOT:
			return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN));
		case 24://MODE_LOTSTEP:
			return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP));
		case 25://MODE_MAXLOT:
			return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
		case 26://MODE_SWAPTYPE:
			return((double)SymbolInfoInteger(symbol,SYMBOL_SWAP_MODE));
		case 27://MODE_PROFITCALCMODE:
			return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_CALC_MODE));
		case 28://MODE_MARGINCALCMODE:
			return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_CALC_MODE));
		case 29://MODE_MARGININIT:
			return((double)SymbolInfoDouble(symbol,SYMBOL_MARGIN_INITIAL));
		case 30://MODE_MARGINMAINTENANCE:
			return((double)SymbolInfoDouble(symbol,SYMBOL_MARGIN_MAINTENANCE));
		case 31://MODE_MARGINHEDGED:
			return((double)SymbolInfoDouble(symbol,SYMBOL_MARGIN_HEDGED));
		case 32:{//MODE_MARGINREQUIRED:
		   //double freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
		   double margin = 0.0;
		   if (OrderCalcMargin(0, symbol, 1, SymbolInfoDouble(symbol, SYMBOL_ASK), margin))
			   return(margin);
			else
			   return(0);
		}
		case 33://MODE_FREEZELEVEL:
			return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL));
		case 34://MODE_CLOSEBY_ALLOWED:
			return(0);

		default: return(0);
	}

	return(0);
}

int OrdersTotal(bool dummy)
{	
	return PositionsTotal() + OrdersTotal();
}

int OrderTicket()
{
	// FXD_SELECTED_TICKET is a global variable and is set by OrderSelect()
	return (int)FXD_SELECTED_TICKET;
}

int OrdersHistoryTotal() // HistoryTotal()
{
	HistorySelect(0,TimeCurrent());
	return HistoryDealsTotal();
}

double OrderTakeProfit()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_TP);
	if (FXD_SELECTED_TYPE == 2) return OrderGetDouble(ORDER_TP);
	
	return 0.0;
}

double OrderStopLoss()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_SL);
	if (FXD_SELECTED_TYPE == 2) return OrderGetDouble(ORDER_SL);
	
	return 0.0;
}

bool IsTradeContextBusy()
{
	return false;
}

bool RefreshRates()
{
	return true;
}

int ObjectsTotal(int type=EMPTY, int window=-1)
{
	return(ObjectsTotal(0, window, type));
}

string ObjectName(int index)
{
	return ObjectName(0, index);
}

bool ObjectDelete(string name)
{
	return ObjectDelete(0, name);
}

datetime OrderCloseTime()
{
	if (FXD_SELECTED_TYPE == 2) return (datetime)OrderGetInteger(ORDER_TIME_DONE);
	
	return 0;
}

int ObjectFind(string name)
{
	return ObjectFind(0, name);
}

bool ObjectCreate(string name,
                  ENUM_OBJECT type,
                  int window,
                  datetime time1,
                  double price1,
                  datetime time2=0,
                  double price2=0,
                  datetime time3=0,
                  double price3=0)
{
	return(ObjectCreate(0,name,type,window,time1,price1,time2,price2,time3,price3));
}

string DoubleToStr(double value, int digits=8)
{
	return DoubleToString(value, digits);
}

double OrderClosePrice()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_PRICE_CURRENT);
	if (FXD_SELECTED_TYPE == 2) return OrderGetDouble(ORDER_PRICE_CURRENT);
	
	return -1;
}

double OrderCommission()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_COMMISSION);
	
	return 0.0;
}

datetime OrderExpiration()
{
	if (FXD_SELECTED_TYPE == 2) return (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
	
	return 0.0;
}

double OrderProfit()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_PROFIT);
	
	return 0.0;
}

double OrderSwap()
{
	if (FXD_SELECTED_TYPE == 1) return PositionGetDouble(POSITION_SWAP);

	return 0.0;
}

string StringTrimRight(string string_var, bool dummy)
{
	// dummy parameter is used to overload the system function
	StringTrimRight(string_var);
	return string_var;
}

string StringTrimLeft(string string_var, bool dummy)
{
	// dummy parameter is used to overload the system function
	StringTrimLeft(string_var);
	return string_var;
}

double AccountFreeMargin()
{
	return AccountInfoDouble(ACCOUNT_MARGIN_FREE);
}

int OrderSend(
	string   symbol,              // symbol 
	int      cmd,                 // operation 
	double   volume,              // volume 
	double   price,               // price 
	int      slippage,            // slippage 
	double   sl,                  // stop loss 
	double   tp,                  // take profit 
	string   comment=NULL,        // comment 
	int      magic=0,             // magic number 
	datetime expiration=0,        // pending order expiration 
	color    arrow_color=clrNONE  // color
	)
{
	int digits = 0;
	int type   = cmd;
	double ask=0, bid=0, point=0, ticksize=0, lotstep=0;
	ulong ticket=-1;
	bool successed = false;
	ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC;
	
	//-- pre-fixing ------------------------------------------------------
	if (cmd == 0 || cmd == 1) {
		expiration = 0;
	}

	if (expiration <= 0) {
		if (fxd_IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_GTC))
		{
			type_time = ORDER_TIME_GTC;
			expiration = 0;
		}
		else
		{
			type_time = ORDER_TIME_DAY;
			expiration = 0;
		}
	}
	else {
		type_time = ORDER_TIME_SPECIFIED;
	}
	
	//-- we need this to prevent false-synchronous behaviour of MQL5 -----
	bool closing = false;
	double lots0 = 0;
	long type0   = type;

	if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
	{
		if (PositionSelect(symbol))
		{
			if ((int)PositionGetInteger(POSITION_TYPE) != type) {
				closing = true;
			}
			lots0 = NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5);
			type0 = PositionGetInteger(POSITION_TYPE);
		}
	}

	//-- attempts to send position/order ---------------------------------
	while(true)
	{
		digits   = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
		ask      = SymbolInfoDouble(symbol,SYMBOL_ASK);
		bid      = SymbolInfoDouble(symbol,SYMBOL_BID);
		point    = SymbolInfoDouble(symbol,SYMBOL_POINT);
		ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
		lotstep  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

		//-- fixing -------------------------------------------------------
		volume = MathFloor(volume/lotstep)*lotstep; // MQL4's OrderSend rounds to floor
		sl = NormalizeDouble(sl, digits);
		tp = NormalizeDouble(tp, digits);
		price = NormalizeDouble(price, digits);

		//-- send ---------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);
		
		request.symbol     = symbol;
		request.type       = (ENUM_ORDER_TYPE)type;
		request.volume     = volume;
		request.price      = price;
		request.deviation  = (ulong)slippage;
		request.sl         = sl;
		request.tp         = tp;
		request.comment    = comment;
		request.magic      = magic;
		request.type_time  = type_time;
		request.expiration = expiration;

		//-- request action
		if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
			request.action = TRADE_ACTION_DEAL;
		else
			request.action = TRADE_ACTION_PENDING;

		//-- filling type

		// check ORDER_FILLING_RETURN for pending orders only 
		if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
		{
			// in case of positions I would check for SYMBOL_FILLING_ and then set ORDER_FILLING_
			// this is because it appears that fxd_IsFillingTypeAllowed() works correct with SYMBOL_FILLING_, but then the position works correctly with ORDER_FILLING_
			// FOK and IOC integer values are not the same for ORDER and SYMBOL
			
			if (fxd_IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
				request.type_filling = ORDER_FILLING_FOK;
			else if (fxd_IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
				request.type_filling = ORDER_FILLING_IOC;
			else if (fxd_IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
				request.type_filling = ORDER_FILLING_RETURN;
		}
		else
		{
			if (fxd_IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN))
				request.type_filling = ORDER_FILLING_RETURN;
			else if (fxd_IsFillingTypeAllowed(symbol, ORDER_FILLING_FOK))
				request.type_filling = ORDER_FILLING_FOK;
			else if (fxd_IsFillingTypeAllowed(symbol, ORDER_FILLING_IOC))
				request.type_filling = ORDER_FILLING_IOC;
		}
		
		bool success = OrderSend(request, result);
		
		//-- check security flag ------------------------------------------
		if (successed == true) {
			Print("The program will be removed because of suspicious attempt to create new positions");
			ExpertRemove(); Sleep(10000); break;
		}
		if (success) {successed = true;}

		//-- error check --------------------------------------------------
		if (!success || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED && result.retcode!=TRADE_RETCODE_DONE_PARTIAL))
		{
			string errmsgpfx="New position error";
			if (type>ORDER_TYPE_SELL) {
				errmsgpfx="New pending order error";
			}
			int erraction=fxd_CheckForTradingError(result.retcode, errmsgpfx);
			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}
			return false;
		}

		//-- finish work --------------------------------------------------
		if (result.retcode==TRADE_RETCODE_DONE || result.retcode==TRADE_RETCODE_PLACED || result.retcode==TRADE_RETCODE_DONE_PARTIAL)
		{
			ticket = result.order;
			//== Whatever was created, we need to wait until MT5 updates it's cache

			//-- Synchronize: Position
			if (type<=ORDER_TYPE_SELL)
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
					if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
					{
						if (PositionSelectByTicket(ticket)) {break;}
					}
					else {
						if (OrderSelect(ticket)) {break;}
				  	}
					Sleep(10);
				}
			}
		}
		break;
	}

	if (ticket > 0) {
		// In MQL4 OrderSend() selects the order
		FXD_SELECTED_TICKET = ticket;
		FXD_SELECTED_TYPE   = (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL) ? 1 : 2; // 1 for trade, 2 for pending order
		ResetLastError();
	}

	return (int)ticket;
}

long StrToInteger(string value)
{
	return StringToInteger(value);
}

bool OrderModify(
	int        ticket,      // ticket
	double     price,       // close price
	double     sl,          // stop loss
	double     tp,          // take profit
	datetime   expiration,  // expiration
	color      arrow_color=clrNONE  // color
	)
{
	bool is_trade = true;
	
	string symbol = "";
	long magic    = 0;

   if (PositionSelectByTicket(ticket))
   {
   	symbol = PositionGetString(POSITION_SYMBOL);
   }
   else if (OrderSelect(ticket))
   {
   	is_trade = false;
   	
   	symbol = OrderGetString(ORDER_SYMBOL);
   }
   else {
   	return false;
   }
   
   ResetLastError();
   
   //-- pre-fixing ---------------------------------------------------
   int digits    = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   
   sl = NormalizeDouble(sl, digits);
   tp = NormalizeDouble(tp, digits);
   price = NormalizeDouble(price, digits);

	while(true)
	{
	   //-- close --------------------------------------------------------
		MqlTradeRequest request;
	   MqlTradeResult result;
	   ZeroMemory(request);
	   ZeroMemory(result);
		
		if (is_trade)
		{
			if (
		         sl == NormalizeDouble(PositionGetDouble(POSITION_SL),digits)
		      && tp == NormalizeDouble(PositionGetDouble(POSITION_TP),digits)
		   ) {
		      return true;
		   }
	
			request.action   = TRADE_ACTION_SLTP;
			request.symbol   = symbol;
			request.position = PositionGetInteger(POSITION_TICKET);
			request.magic    = PositionGetInteger(POSITION_MAGIC);
			request.comment  = PositionGetString(POSITION_COMMENT);
		}
		else
		{
			//-- check if needed to modify ------------------------------------
		   if (
		         price == NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),digits)
		      && sl == NormalizeDouble(OrderGetDouble(ORDER_SL),digits)
		      && tp == NormalizeDouble(OrderGetDouble(ORDER_TP),digits)
		      && expiration == OrderGetInteger(ORDER_TIME_EXPIRATION)
		   ) {
		      return true;
		   }
	
			request.action   = TRADE_ACTION_MODIFY;
			request.order    = OrderGetInteger(ORDER_TICKET);
			request.price    = price;
			request.volume   = OrderGetDouble(ORDER_VOLUME_CURRENT);
			request.magic    = OrderGetInteger(ORDER_MAGIC);
			request.type_time  = ORDER_TIME_SPECIFIED;
			request.expiration = expiration;
			request.comment    = OrderGetString(ORDER_COMMENT);
			
			//-- filling type
	   	uint filling=(uint)SymbolInfoInteger(request.symbol,SYMBOL_FILLING_MODE);
	   	if (filling==SYMBOL_FILLING_FOK) {
	      	request.type_filling=ORDER_FILLING_FOK;
	   	}
	   	else if (filling==SYMBOL_FILLING_IOC) {
	      	request.type_filling=ORDER_FILLING_IOC;
	   	}
		}
		
		request.sl     =sl;
		request.tp     =tp;
	
		int success = OrderSend(request, result);
		
		//-- error check --------------------------------------------------
	   if (!success || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED && result.retcode!=TRADE_RETCODE_DONE_PARTIAL))
	   {
	      string errmsgpfx="Modify error";
         int erraction=fxd_CheckForTradingError(result.retcode, errmsgpfx);
         switch(erraction)
         {
            case 0: break;    // no error
            case 1: continue; // overcomable error
            case 2: break;    // fatal error
         }
         return false;
	   }
		
		//-- finish work --------------------------------------------------
	   if (result.retcode==TRADE_RETCODE_DONE || result.retcode==TRADE_RETCODE_PLACED || result.retcode==TRADE_RETCODE_DONE_PARTIAL)
	   {
			while (true)
			{
				if (is_trade)
				{
					if (!PositionSelectByTicket(ticket)) {break;}
				}
				else {
					if (!OrderSelect(ticket)) {break;}
			  	}
				Sleep(10);
			}
		}
		
		break;
	}

	ResetLastError();

   return true;
}

bool IsTesting()
{
	return MQLInfoInteger(MQL_TESTER);
}

bool IsVisualMode()
{
	return MQLInfoInteger(MQL_VISUAL_MODE);
}

double AccountEquity()
{
	return AccountInfoDouble(ACCOUNT_EQUITY);
}

double AccountBalance()
{
	return AccountInfoDouble(ACCOUNT_BALANCE);
}

bool OrderDelete(
	int        ticket,
	color      arrow_color=clrNONE
	)
{
   if (!OrderSelect(ticket))
   	return false;
   	
   string symbol = OrderGetString(ORDER_SYMBOL);

	while(true)
	{
	   //-- close --------------------------------------------------------
		MqlTradeRequest request;
	   MqlTradeResult result;
	   ZeroMemory(request);
	   ZeroMemory(result);
		
		request.action = TRADE_ACTION_REMOVE;
		request.order  = ticket;
	
		// filling type
		if (fxd_IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
	      request.type_filling = ORDER_FILLING_FOK;
		else if (fxd_IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
			request.type_filling = ORDER_FILLING_IOC;
		else if (fxd_IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
			request.type_filling = ORDER_FILLING_RETURN;
	
		int success = OrderSend(request, result);
	
		//-- error check --------------------------------------------------
	   if (!success || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED && result.retcode!=TRADE_RETCODE_DONE_PARTIAL))
	   {
	      string errmsgpfx = "Closing order error";

         int erraction=fxd_CheckForTradingError(result.retcode, errmsgpfx);
         switch(erraction)
         {
            case 0: break;    // no error
            case 1: continue; // overcomable error
            case 2: break;    // fatal error
         }
         return false;
	   }
	
		//-- finish work --------------------------------------------------
	   if (result.retcode==TRADE_RETCODE_DONE || result.retcode==TRADE_RETCODE_PLACED || result.retcode==TRADE_RETCODE_DONE_PARTIAL)
	   {
			while (true)
			{
				if (!OrderSelect(ticket)) {break;}
				Sleep(10);
			}
		}

		break;
	}

	ResetLastError();

   return true;
}

bool OrderClose(
	int        ticket,      // ticket 
	double     lots,        // volume 
	double     price,       // close price 
	int        slippage,    // slippage 
	color      arrow_color=clrNONE  // color 
	)
{
	if (!PositionSelectByTicket(ticket)) return false;

	double lots0 = NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5);
	//long type0 = PositionGetInteger(POSITION_TYPE);
	string symbol  = PositionGetString(POSITION_SYMBOL);
	double lotstep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

	while(true)
   {
		//-- fixing -------------------------------------------------------
		lots = MathFloor(lots/lotstep)*lotstep;

		//-- close --------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		ZeroMemory(request);
		ZeroMemory(result);
	
		//if (lots <= 0) PositionGetDouble(POSITION_VOLUME)
		request.price     = price;
	
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			request.type  = ORDER_TYPE_SELL;
			//request.price = SymbolInfoDouble(symbol,SYMBOL_BID);
		}
		else
		{
			request.type  = ORDER_TYPE_BUY;
			//request.price = SymbolInfoDouble(symbol,SYMBOL_ASK);
		}
	
		request.action    = TRADE_ACTION_DEAL;
		request.position  = PositionGetInteger(POSITION_TICKET);
		request.symbol    = symbol;
		request.volume    = lots;
		request.magic     = PositionGetInteger(POSITION_MAGIC);
		request.deviation = (ulong)(slippage);
	
		// filling type
		if (fxd_IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
			request.type_filling = ORDER_FILLING_FOK;
		else if (fxd_IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
			request.type_filling = ORDER_FILLING_IOC;
		else if (fxd_IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
			request.type_filling = ORDER_FILLING_RETURN;
	
		int success = OrderSend(request, result);
		
		//-- error check --------------------------------------------------
		if (!success || (result.retcode!=TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED && result.retcode!=TRADE_RETCODE_DONE_PARTIAL))
		{
			string errmsgpfx = "Closing trade error";

			int erraction=fxd_CheckForTradingError(result.retcode, errmsgpfx);
			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}
			return false;
		}
		
		//-- finish work --------------------------------------------------
		if (result.retcode==TRADE_RETCODE_DONE || result.retcode==TRADE_RETCODE_PLACED || result.retcode==TRADE_RETCODE_DONE_PARTIAL)
		{
			/*
			while (true)
			{
				if (!PositionSelectByTicket(ticket)) {break;}
				Sleep(10);
			}
			*/

			//- closing: full
			if (lots0 == NormalizeDouble(result.volume, 5))
			{
				while (true)
				{
					if (!PositionSelectByTicket(ticket)) {break;}
					Sleep(10);
				}
			}
			//- closing: partial
			else if (lots0 > NormalizeDouble(result.volume, 5))
			{
				while (true)
				{
					if (PositionSelectByTicket(ticket) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}
					Sleep(10);
				}
			}
		}
		
		break;
	}

	ResetLastError();

	return true;
}

bool IsConnected()
{
	return TerminalInfoInteger(TERMINAL_CONNECTED);
}

double  iMA( 
	string             symbol,
	ENUM_TIMEFRAMES    timeframe,
	int                ma_period,
	int                ma_shift,
	ENUM_MA_METHOD     ma_method,
	ENUM_APPLIED_PRICE applied_price,
	int                shift
)
{
	applied_price++; // Fix, because all ENUM_APPLIED_PRICE in MQL5 are +1
	int handle = iMA(symbol, timeframe, ma_period, ma_shift, ma_method, applied_price);

	return fxd_Indicator(handle, 0, shift);
}

int TimeYear(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.year);
}

int TimeMonth(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.mon);
}

int TimeDay(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.day);
}

int TimeHour(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.hour);
}

int TimeMinute(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.min);
}

int TimeSeconds(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.sec);
}

int TimeDayOfWeek(datetime date)
{
	MqlDateTime tm;
	TimeToStruct(date,tm);
	return(tm.day_of_week);
}

template<typename T>
int ArraySort_000(T &array[], int count=WHOLE_ARRAY, int start=0, int direction=1)
{
   // What is the idea here:
   // 1) We copy part of the array that needs to be sorted and store this in temporary array
   // 2) We sort that temporary array
   // 3) Over the previously copied part of the original array we put the values of the sorted array
   
   if (count == WHOLE_ARRAY && start == 0 && direction == 1) {
      return ArraySort(array);
   }
   
   if (count <= 0) {count = WHOLE_ARRAY;}
   
   int size = ArraySize(array);
   
   T array0[];
   int size0 = ArrayCopy(array0, array, 0, start, count);

   if (direction > 1) {
      ArraySetAsSeries(array0, true);
   }
   
   int ret = ArraySort(array0);
   
   for (int i=start; i<start+size0; i++)
   {
      array[i] = array0[i-start];
   }

   // In MQL4's documentation is written that ArraySort return either true or false, which is incorrect
   // What ArraySort really returns is how many elements were sorted or -1 on error
   
   return ret;
}

// the second parameter should not have default value

int ArraySort(double &array[], int count, int start=0, int direction=1)
{
   return ArraySort_000(array, count, start, direction);
}

int ArraySort(float &array[], int count, int start=0, int direction=1)
{
   return ArraySort_000(array, count, start, direction);
}

int ArraySort(long &array[], int count, int start=0, int direction=1)
{
   return ArraySort_000(array, count, start, direction);
}

int ArraySort(int &array[], int count, int start=0, int direction=1)
{
   return ArraySort_000(array, count, start, direction);
}

int ArraySort(short &array[], int count, int start=0, int direction=1)
{
   return ArraySort_000(array, count, start, direction);
}

int ArraySort(char &array[], int count, int start=0, int direction=1)
{
   return ArraySort_000(array, count, start, direction);
}

bool fxd_IsExpirationTypeAllowed(string symbol,int exp_type)
{
	int expiration=(int)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_MODE);
	return((expiration&exp_type)==exp_type);
}

bool fxd_IsFillingTypeAllowed(string symbol,int fill_type)
{
	int filling=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);
	return((filling & fill_type)==fill_type);
}

int fxd_CheckForTradingError(int error_code=-1, string msg_prefix="")
{
	// return 0 -> no error
	// return 1 -> overcomable error
	// return 2 -> fatal error
	
	static int tryout = 0;
	int tryouts = 5;   // How many times to retry
	int delay   = 1000; // Time delay between retries, in milliseconds
	int retval  = 0;

	//-- error check -----------------------------------------------------
	switch(error_code)
	{
		//-- no error
		case 0:
			retval = 0;
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
         retval = 1;
         break;
      //-- critical errors
      default:
         retval = 2;
         break;
   }
   
   if (error_code > 0)
   {
      if (retval == 1)
      {
         Print(msg_prefix,": ",(error_code),". Retrying in ",(delay)," milliseconds..");
         Sleep(delay); 
      }
      else if (retval == 2)
      {
         Print(msg_prefix,": ",(error_code));
      }
   }
   
   if (retval == 0)
   {
      tryout = 0;
   }
   else if (retval == 1)
   {
      tryout++;

      if (tryout > tryouts)
      {
         tryout = 0;
         retval  = 2;
      }
      else
      {
         Print("retry #", tryout, " of ", tryouts);
      }
   }

	return(retval);
}

double fxd_Indicator(int handle, int mode=0, int shift=0)
{
	static double buffer[1];
	
	ResetLastError(); 
	
	if (handle < 0)
	{
		Print("Error: Indicator not handled (handle=",handle," | error code=",_LastError,")");
		
		FXD_ONCALCULATE_FAIL = true;
		
		return EMPTY_VALUE;
	}

	for (int i=0; i<100; i++)
	{
		if (BarsCalculated(handle) > 0)
		{
			break;
		}

		// Sleep doesn't work for indicators, so we exit here
		if (MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_INDICATOR)
		{
			FXD_ONCALCULATE_FAIL = true;

			return EMPTY_VALUE;
		}

		Sleep(50);
	}

	int copied = CopyBuffer(handle,mode,shift,1,buffer);

	if (copied > 0) {
		return buffer[0];
	}

	//Print("Error: Cannot get indicator value (handle=",handle," | shift=",shift," | error code=",_LastError,")");
	FXD_ONCALCULATE_FAIL = true;

	return EMPTY_VALUE;
}

//== fxDreema MQL4 to MQL5 Converter ==//