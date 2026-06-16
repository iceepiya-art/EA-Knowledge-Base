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
#define PROJECT_ID "mt4-3186"
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
input double Percent = 0.0;input int MagicStart = 2953; // Magic Number, kind of...
class c
{
		public:
	static double Percent;
	static int MagicStart;
};
double c::Percent;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double Percent_Profit1;
	static double Percent_Profit2;
	static double Percent_Profit3;
	static double Percent_Cutloss;
	static double Commission_Point;
	static double Swap_Point;
	static double sum_swap_commission;
	static double all_lotb;
	static double all_lots;
	static double avab;
	static double avas;
	static double tpb;
	static double tps;
};
double v::Percent_Profit1;
double v::Percent_Profit2;
double v::Percent_Profit3;
double v::Percent_Cutloss;
double v::Commission_Point;
double v::Swap_Point;
double v::sum_swap_commission;
double v::all_lotb;
double v::all_lots;
double v::avab;
double v::avas;
double v::tpb;
double v::tps;




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
int FXD_BLOCKS_COUNT        = 71;
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
	c::Percent = Percent;
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

	v::Percent_Profit1 = 0.0;
	v::Percent_Profit2 = 0.0;
	v::Percent_Profit3 = 0.0;
	v::Percent_Cutloss = 0.0;
	v::Commission_Point = 0.0;
	v::Swap_Point = 0.0;
	v::sum_swap_commission = 0.0;
	v::all_lotb = 0.0;
	v::all_lots = 0.0;
	v::avab = 0.0;
	v::avas = 0.0;
	v::tpb = 0.0;
	v::tps = 0.0;




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

	if (ENABLE_EVENT_TRADE) OnTradeListener(); // to load initial database of orders


	//-- Initialize blocks classes
	ArrayResize(_blocks_, 71);

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
	int disabled_blocks_list[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70};
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

	if (OrdersTotal()) // this makes things faster
	{
		ExpirationDriver();
		OCODriver(); // Check and close OCO orders
	}
	if (ENABLE_EVENT_TRADE) {OnTradeListener();}


	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {0,2,4,8,12,15,21,38,39,40,42,45,47,48,51,53,55,57,58,60,63,65,66};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	return;
}



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on trade events - open, close, modify //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void EventTrade()
{


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

// "modify stops" model
template<typename T1,typename T2,typename _T2_,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename _T8_,typename T9,typename _T9_,typename T10,typename _T10_,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename _T17_,typename T18,typename _T18_,typename T19>
class MDL_LoopModifySLTP: public BlockCalls
{
	public: /* Input Parameters */
	T1 RelativeTo;
	T2 dPrice; virtual _T2_ _dPrice_(){return(_T2_)0;}
	T3 NewSLmode;
	T4 NewStopLoss;
	T5 NewStopLossPercentPrice;
	T6 NewStopLossPercent;
	T7 NewStopLossPercentTP;
	T8 fNewStopLoss; virtual _T8_ _fNewStopLoss_(){return(_T8_)0;}
	T9 dpNewStopLoss; virtual _T9_ _dpNewStopLoss_(){return(_T9_)0;}
	T10 ddNewStopLoss; virtual _T10_ _ddNewStopLoss_(){return(_T10_)0;}
	T11 NewTPmode;
	T12 NewTakeProfit;
	T13 NewTakeProfitPercentPrice;
	T14 NewTakeProfitPercent;
	T15 NewTakeProfitPercentSL;
	T16 fNewTakeProfit; virtual _T16_ _fNewTakeProfit_(){return(_T16_)0;}
	T17 dpNewTakeProfit; virtual _T17_ _dpNewTakeProfit_(){return(_T17_)0;}
	T18 ddNewTakeProfit; virtual _T18_ _ddNewTakeProfit_(){return(_T18_)0;}
	T19 LevelColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopModifySLTP()
	{
		RelativeTo = (string)"openprice";
		NewSLmode = (string)"fixed";
		NewStopLoss = (double)50.0;
		NewStopLossPercentPrice = (double)0.55;
		NewStopLossPercent = (double)50.0;
		NewStopLossPercentTP = (double)50.0;
		NewTPmode = (string)"fixed";
		NewTakeProfit = (double)50.0;
		NewTakeProfitPercentPrice = (double)0.55;
		NewTakeProfitPercent = (double)50.0;
		NewTakeProfitPercentSL = (double)50.0;
		LevelColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK == true) {return;}
		
		LoopedResume();
		
		string symbol = OrderSymbol();
		int digits    = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
		int polarity  = (IsOrderTypeBuy()) ? 1 : -1;
		double price  = (IsOrderTypeBuy()) ? SymbolAsk(symbol) : SymbolBid(symbol);
		
		//-- New Price level ------------------------------------------------------------------------------------------------------------------------     
		     if (RelativeTo == "openprice") {price = OrderOpenPrice();}
		else if (RelativeTo == "dynamic")   {price = _dPrice_();}
		else if (RelativeTo == "current-reverse")
		{
			price = (IsOrderTypeBuy()) ? SymbolBid(symbol) : SymbolAsk(symbol);
		}
		
		//-- Stop Loss and Take Profit --------------------------------------------------------------------------------------------------------------
		double oldSL = NormalizeDouble(attrStopLoss(), digits);
		double oldTP = NormalizeDouble(attrTakeProfit(), digits);
		double SL = oldSL;
		double TP = oldTP;
		
		     if (NewSLmode == "fixed")        {SL = (NewStopLoss == 0.0) ? 0.0 : price - (polarity * toDigits(NewStopLoss, symbol));}
		else if (NewSLmode == "percentPrice") {SL = (NewStopLossPercentPrice == 0.0) ? 0.0 : price - (polarity * price * NewStopLossPercentPrice / 100);}
		else if (NewSLmode == "percent")      {SL = (NewStopLossPercent == 0.0) ? 0.0 : price - (polarity * MathAbs(OrderOpenPrice()-oldSL)*NewStopLossPercent/100);}
		else if (NewSLmode == "percentTP")    {SL = (NewStopLossPercentTP == 0.0) ? 0.0 : price - (polarity * MathAbs(OrderOpenPrice()-oldTP)*NewStopLossPercentTP/100);}
		else if (NewSLmode == "function")     {SL = _fNewStopLoss_();}
		else if (NewSLmode == "dynamicPips")
		{
		   SL = toDigits(_dpNewStopLoss_(), symbol);
			SL = (SL == 0.0) ? 0.0 : price - (polarity * SL);
		}
		else if (NewSLmode == "dynamicDigits")
		{
			SL = _ddNewStopLoss_();
			SL = (SL == 0.0) ? 0.0 : price - (polarity * SL);
		}
		
		     if (NewTPmode == "fixed")        {TP = (NewTakeProfit == 0.0) ? 0.0 : price + (polarity * toDigits(NewTakeProfit, symbol));}
		else if (NewSLmode == "percentPrice") {TP = (NewTakeProfitPercentPrice == 0.0) ? 0.0 : price + (polarity * price * NewTakeProfitPercentPrice / 100);}
		else if (NewTPmode == "percent")      {TP = (NewTakeProfitPercent == 0.0) ? 0.0 : price + (polarity * MathAbs(OrderOpenPrice()-oldTP)*NewTakeProfitPercent/100);}
		else if (NewTPmode == "percentSL")    {TP = (NewTakeProfitPercentSL == 0.0) ? 0.0 : price + (polarity * MathAbs(OrderOpenPrice()-oldSL)*NewTakeProfitPercentSL/100);}
		else if (NewTPmode == "function")     {TP = _fNewTakeProfit_();}
		else if (NewTPmode == "dynamicPips")
		{
			TP = toDigits(_dpNewTakeProfit_(), symbol);
			TP = (TP == 0.0) ? 0.0 : price + (polarity * TP);
		}
		else if (NewTPmode == "dynamicDigits")
		{
			TP = _ddNewTakeProfit_();
			TP = (TP == 0.0) ? 0.0 : price + (polarity * TP);
		}
		
		//-- Send -----------------------------------------------------------------------------------------------------------------------------------
		bool success = false;
		
		if (SL != oldSL || TP != oldTP)
		{
		   success = ModifyOrder(OrderTicket(), OrderOpenPrice(), SL, TP, 0, 0, OrderExpiration(), LevelColor);
		}
		
		if (success == true) {_callback_(1);} else {_callback_(0);}
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
		
		v::Commission_Point = formula(compare, lo, ro)/10;
		
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
		
		v::Swap_Point = formula(compare, lo, ro)/10;
		
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
		
		v::sum_swap_commission = formula(compare, lo, ro);
		
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
		
		v::all_lotb = formula(compare, lo, ro)/10;
		
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
		
		v::avab = formula(compare, lo, ro);
		
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
		
		v::all_lots = formula(compare, lo, ro)/10;
		
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
		
		v::avas = formula(compare, lo, ro);
		
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
		
		v::tps = formula(compare, lo, ro);
		
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

// "Trailing money loss (group of trades)" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename T18>
class MDL_TrailingMoneyLoss: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 TrailingMoneyMode;
	T7 tmFixedMoney;
	T8 tmProfitPercent;
	T9 dtmMoneyAmount; virtual _T9_ _dtmMoneyAmount_(){return(_T9_)0;}
	T10 TrailingStepMode;
	T11 tmStepFixedMoney;
	T12 tmStepPercentTM;
	T13 TrailingStartMode;
	T14 tStartFixedMoney;
	T15 tStartPercentTM;
	T16 ftStart; virtual _T16_ _ftStart_(){return(_T16_)0;}
	T17 Slippage;
	T18 ArrowColor;
	/* Static Parameters */
	double max_profit;
	double money_loss_amount;
	double money_loss_amount0;
	bool money_loss_amount_calculated;
	datetime time0;
	int trades_count0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_TrailingMoneyLoss()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		TrailingMoneyMode = (string)"money";
		tmFixedMoney = (double)10.0;
		tmProfitPercent = (double)10.0;
		TrailingStepMode = (string)"money";
		tmStepFixedMoney = (double)1.0;
		tmStepPercentTM = (double)10.0;
		TrailingStartMode = (string)"none";
		tStartFixedMoney = (double)1.0;
		tStartPercentTM = (double)100.0;
		Slippage = (ulong)4;
		ArrowColor = (color)clrDeepPink;
		/* Static Parameters (initial value) */
		max_profit =  0;
		money_loss_amount =  0;
		money_loss_amount0 =  0;
		money_loss_amount_calculated =  false;
		time0 =  0;
		trades_count0 =  0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		double avg_load     = 0;
		double avg_lots     = 0; // Average sum of lots - it can be negative
		double group_profit = 0;
		int trades_count    = 0;
		
		double openprices[]; ArrayResize(openprices, 0);
		datetime opentimes[]; ArrayResize(opentimes, 0);
		ulong tickets[]; ArrayResize(tickets, 0);
		int size  = 0;
		int i     = 0;
		int index = 0;
		
		string name_general = "fxd_tml_" + (string)(__block_user_number) + "_";
		string name         = "";
		string text         = "";
		bool trades_count_changed = false;
		bool draw_objects         = true;
		
		//-- collect data from the currently running trades
		for (index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				if (OrderType() == 0)
				{
					avg_lots = avg_lots + OrderLots();
				}
				else
				{
					avg_lots = avg_lots - OrderLots();
				}
		
				avg_lots = NormalizeDouble(avg_lots, 2);
		
				if (OrderSymbol() == Symbol())
				{
					size = ArraySize(openprices);
					ArrayResize(openprices, size+1);
					ArrayResize(opentimes, size+1);
					ArrayResize(tickets, size+1);
		
					openprices[size] = OrderOpenPrice();
					opentimes[size]  = OrderOpenTime();
					tickets[size]    = OrderTicket();
				}
				else
				{
					draw_objects = false;  
				}
		
				group_profit += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
				trades_count++;
			}
		}
		
		//-- process existing trades
		if (trades_count0 != trades_count)
		{
			trades_count0        = trades_count;
			trades_count_changed = true;
		}
		
		if (group_profit > max_profit)
		{
			max_profit = group_profit;
		}
		
		if (trades_count == 0)
		{
			//-- reset
			max_profit                   = 0;
			money_loss_amount            = 0;
			money_loss_amount_calculated = false;
		}
		else
		{
			//- calculate trailing money loss
			double tm_amount = 0;
		
				  if (TrailingMoneyMode == "money")				    {tm_amount = tmFixedMoney;}
			else if (TrailingMoneyMode == "percentGroupProfit") {tm_amount = max_profit * tmProfitPercent / 100;}
			else if (TrailingMoneyMode == "dynamic")				 {tm_amount = _dtmMoneyAmount_();}
		
			//-- calculate trailing money step
			double tm_step=0;
		
				  if (TrailingStepMode == "money")	   {tm_step = tmStepFixedMoney;}
			else if (TrailingStepMode == "percentTM") {tm_step = tm_amount * tmStepPercentTM / 100;}
		
			//-- calculate trailing start level
			double tm_start=0;
		
				  if (TrailingStartMode == "none")		 {tm_start = -EMPTY_VALUE;}
			else if (TrailingStartMode == "zero")		 {tm_start = 0;}
			else if (TrailingStartMode == "percentTM") {tm_start = tm_amount * tStartPercentTM / 100;}
			else if (TrailingStartMode == "money")	    {tm_start = tStartFixedMoney;}
			else if (TrailingStartMode == "dynamic")	 {tm_start = _ftStart_();}
		
			//-- Do Trailing Money Loss
			if (money_loss_amount_calculated == false && max_profit > tm_start)
			{
				money_loss_amount            = max_profit - tm_amount;
				money_loss_amount_calculated = true;
			}
		
			if (money_loss_amount_calculated == true)
			{
				//-- attempt to move the "line"
				if (group_profit >= money_loss_amount + tm_amount + tm_step)
				{
					money_loss_amount = max_profit - tm_amount;
				}
				else if (group_profit <= money_loss_amount)
				{
					for (index = TradesTotal()-1; index >= 0; index--)
					{
						if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
						{
							CloseTrade(OrderTicket(), Slippage, ArrowColor);
						}
					}
		
					max_profit                   = 0;
					money_loss_amount            = 0;
					money_loss_amount_calculated = false;
		
					//-- clear old lines
					if (!MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_VISUAL_MODE))
					{
						int total       = ObjectsTotal(0, -1, -1);
						int name_length = StringLen(name_general);
		
						for (i = 0; i < total; i++)
						{
							if (StringSubstr(ObjectName(0, i), 0, name_length) == name_general)
							{
								ObjectDelete(0, ObjectName(0, i));  
							}
						}
		
						ChartRedraw();
					}
				}
				
				//-- draw/repaint objects
				if (draw_objects == true && (!MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_VISUAL_MODE)))
				{
					if (avg_lots == 0)
					{
						name = name_general + "lbl";
						ObjectSetString(0, name, OBJPROP_TEXT, DoubleToString(group_profit, 2) + " => " + DoubleToString(money_loss_amount, 2));
					}
					else
					{
						double bid           = SymbolInfoDouble(Symbol(), SYMBOL_BID);
						double lot_size      = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
						double tm_line_price = bid - ((group_profit - money_loss_amount) / (avg_lots * lot_size));
						
						//-- paint text, along with the mini stop line
						name = name_general + "lbl";
		
						if (ObjectFind(0, name) == -1)
						{
							ObjectCreate(0, name, OBJ_TEXT, 0, TimeCurrent(), 0);
							ObjectSetDouble(0, name, OBJPROP_ANGLE, 0);
							ObjectSetInteger(0, name, OBJPROP_BACK, false);
							ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
						}
		
						ObjectSetString(0, name, OBJPROP_TEXT, DoubleToString(group_profit, 2) + " => " + DoubleToString(money_loss_amount, 2));
				
						if (money_loss_amount != money_loss_amount0 || time0 != iTime(Symbol(), 0, 0) || trades_count_changed == true)
						{
							time0              = iTime(Symbol(), 0, 0);
							money_loss_amount0 = money_loss_amount;
		
							//-- update position of the text label
							ObjectSetDouble(0, name, OBJPROP_PRICE, 0, tm_line_price);
							ObjectSetInteger(0, name, OBJPROP_TIME, 0, TimeCurrent());
		
							//-- paint arrow - mini stop line
							name = name_general + "sl";
		
							if (ObjectFind(0, name) == -1)
							{
								ObjectCreate(0, name, OBJ_ARROW, 0, TimeCurrent(), 0);
								ObjectSetInteger(0, name, OBJPROP_ARROWCODE, 4);
								ObjectSetInteger(0, name, OBJPROP_BACK, false);
								ObjectSetInteger(0, name, OBJPROP_COLOR, clrRoyalBlue);
								ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
							}
		
							ObjectSetDouble(0, name, OBJPROP_PRICE, 0, tm_line_price);
							ObjectSetInteger(0, name, OBJPROP_TIME, 0, TimeCurrent());
		
							//-- paint trend lines connecting trades with the mini stop line
							size = ArraySize(openprices);
		
							for (i = 0; i < size; i++)
							{
								name = name_general + "" + (string)tickets[i];
		
								if (ObjectFind(0, name) == -1)
								{
									ObjectCreate (0, name, OBJ_TREND, 0, opentimes[i], openprices[i], TimeCurrent(), openprices[i]);
									ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
									ObjectSetInteger(0, name, OBJPROP_COLOR, clrRoyalBlue);
									ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
								}
		
								ObjectSetInteger(0, name, OBJPROP_TIME, 1, TimeCurrent());
								ObjectSetDouble(0, name, OBJPROP_PRICE, 1, tm_line_price);
							}
						}
					}
				}
			}
		}
		
		_callback_(1);
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
		
		v::start = formula(compare, lo, ro)/100;
		
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
		
		v::step = formula(compare, lo, ro)/100;
		
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
		
		v::stop = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};


//------------------------------------------------------------------------------------------------------------------------

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

// "Stop-Loss" model
class MDLIC_inloop_OrderStopLoss
{
	public: /* Input Parameters */
	string Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderStopLoss()
	{
		Mode = (string)"level";
	}

	public: /* The main method */
	double _execute_()
	{
		double retval = 0;
		int digits    = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		
		if (Mode == "level")
		{
		   retval = attrStopLoss();
		}
		else if (Mode == "fraction")
		{
		   if (attrStopLoss() > 0)
			{
		      retval = MathAbs(OrderOpenPrice()-attrStopLoss());
		   }
		}
		else if (Mode == "pips")
		{
			if (attrStopLoss() > 0)
			{
				double point = SymbolInfoDouble(OrderSymbol(), SYMBOL_POINT);
		
			   retval = MathAbs(OrderOpenPrice()-attrStopLoss())/(PipValue(OrderSymbol())*point);
			}
		}
		
		return NormalizeDouble(retval, digits);
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

// "Parabolic SAR" model
class MDLIC_indicators_iSAR
{
	public: /* Input Parameters */
	double Step;
	double Maximum;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iSAR()
	{
		Step = (double)0.02;
		Maximum = (double)0.2;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iSAR(Symbol, Period, Step, Maximum, Shift + FXD_MORE_SHIFT);
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

// "Commission" model
class MDLIC_inloop_OrderCommission
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderCommission()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return OrderCommission();
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

// "Swap" model
class MDLIC_inloop_OrderSwap
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderSwap()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return OrderSwap();
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

// Block 1 (Moving Average Close BUY)
class Block0: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {1};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		Ro.Shift = 1;
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
		Ro.MAmethod = MODE_EMA;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[1].run(0);
		}
	}
};

// Block 2 (Close trades)
class Block1: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "2";
		_beforeExecuteEnabled = true;
		// Block input parameters
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

// Block 3 (Moving Average Close SELL)
class Block2: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.CandleID = 1;
		Ro.Shift = 1;
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
		Ro.MAmethod = MODE_EMA;
		Ro.AppliedPrice = PRICE_CLOSE;
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(2);
		}
	}
};

// Block 4 (Close trades)
class Block3: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";
		_beforeExecuteEnabled = true;
		// Block input parameters
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

// Block 5 (Condition)
class Block4: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {5};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDepth = 5;
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
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[5].run(4);
		}
	}
};

// Block 6 (For each Trade)
class Block5: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {6};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[6].run(5);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 7 (Condition)
class Block6: public MDL_Condition<MDLIC_inloop_OrderStopLoss,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDepth = 5;
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 2;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(6);
		}
	}
};

// Block 8 (modify stops)
class Block7: public MDL_LoopModifySLTP<string,MDLIC_value_value,double,string,double,double,double,double,MDLIC_iCustom_ZigZag,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dPrice.Value = 0.0;
		fNewStopLoss.ZigZagDepth = 5;
		fNewStopLoss.ZigZagDeviation = 0;
		fNewStopLoss.ZigZagBackstep = 0;
		fNewStopLoss.ModeZigZag = 2;
		dpNewStopLoss.Value = 10.0;
		ddNewStopLoss.Value = 0.001;
		fNewTakeProfit.Value = 50.0;
		dpNewTakeProfit.Value = 10.0;
		ddNewTakeProfit.Value = 0.001;
		// Block input parameters
		NewSLmode = "function";
		NewTPmode = "none";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {return dPrice._execute_();}
	virtual double _fNewStopLoss_() {
		fNewStopLoss.Symbol = CurrentSymbol();
		fNewStopLoss.Period = CurrentTimeframe();

		return fNewStopLoss._execute_();
	}
	virtual double _dpNewStopLoss_() {return dpNewStopLoss._execute_();}
	virtual double _ddNewStopLoss_() {return ddNewStopLoss._execute_();}
	virtual double _fNewTakeProfit_() {return fNewTakeProfit._execute_();}
	virtual double _dpNewTakeProfit_() {return dpNewTakeProfit._execute_();}
	virtual double _ddNewTakeProfit_() {return ddNewTakeProfit._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		LevelColor = (color)clrDeepPink;
	}
};

// Block 9 (Condition)
class Block8: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDepth = 5;
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
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(8);
		}
	}
};

// Block 10 (For each Trade)
class Block9: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "10";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(9);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 11 (Condition)
class Block10: public MDL_Condition<MDLIC_inloop_OrderStopLoss,double,string,MDLIC_iCustom_ZigZag,double,int>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "11";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {11};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.ZigZagDepth = 5;
		Ro.ZigZagDeviation = 0;
		Ro.ZigZagBackstep = 0;
		Ro.ModeZigZag = 1;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();
		Ro.Period = CurrentTimeframe();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[11].run(10);
		}
	}
};

// Block 12 (modify stops)
class Block11: public MDL_LoopModifySLTP<string,MDLIC_value_value,double,string,double,double,double,double,MDLIC_iCustom_ZigZag,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "12";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dPrice.Value = 0.0;
		fNewStopLoss.ZigZagDepth = 5;
		fNewStopLoss.ZigZagDeviation = 0;
		fNewStopLoss.ZigZagBackstep = 0;
		fNewStopLoss.ModeZigZag = 1;
		dpNewStopLoss.Value = 10.0;
		ddNewStopLoss.Value = 0.001;
		fNewTakeProfit.Value = 50.0;
		dpNewTakeProfit.Value = 10.0;
		ddNewTakeProfit.Value = 0.001;
		// Block input parameters
		NewSLmode = "function";
		NewTPmode = "none";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {return dPrice._execute_();}
	virtual double _fNewStopLoss_() {
		fNewStopLoss.Symbol = CurrentSymbol();
		fNewStopLoss.Period = CurrentTimeframe();

		return fNewStopLoss._execute_();
	}
	virtual double _dpNewStopLoss_() {return dpNewStopLoss._execute_();}
	virtual double _ddNewStopLoss_() {return ddNewStopLoss._execute_();}
	virtual double _fNewTakeProfit_() {return fNewTakeProfit._execute_();}
	virtual double _dpNewTakeProfit_() {return dpNewTakeProfit._execute_();}
	virtual double _ddNewTakeProfit_() {return ddNewTakeProfit._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		LevelColor = (color)clrDeepPink;
	}
};

// Block 13 (If trade)
class Block12: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "13";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {16};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[16].run(12);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 14 (Break even point (each trade))
class Block13: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "14";
		_beforeExecuteEnabled = true;
		// Block input parameters
		BEoffsetMode = "pips";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		BEPoffsetPips = (double)v::sum_swap_commission;
	}
};

// Block 15 (Trailing stop (each trade))
class Block14: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_indicators_iSAR,double,MDLIC_value_points,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "15";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftDigits.Value = 40.0;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		TrailingStartMode = "fixed";
	}

	public: /* Custom methods */
	virtual double _ftStop_() {
		ftStop.Symbol = CurrentSymbol();
		ftStop.Period = CurrentTimeframe();

		return ftStop._execute_();
	}
	virtual double _ftDigits_() {
		ftDigits.Symbol = CurrentSymbol();

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

// Block 16 (If trade)
class Block15: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "16";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
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

// Block 17 (For each Trade)
class Block16: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
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
		Symbol = (string)CurrentSymbol();
	}
};

// Block 18 (Formula)
class Block17: public MDL_Formula_1<MDLIC_inloop_OrderCommission,double,string,MDLIC_inloop_OrderVolume,double>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "18";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {18};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.ModeVolume = SEL_CURRENT;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[18].run(17);
		}
	}
};

// Block 19 (Formula)
class Block18: public MDL_Formula_2<MDLIC_inloop_OrderSwap,double,string,MDLIC_inloop_OrderVolume,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "19";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.ModeVolume = SEL_CURRENT;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(18);
		}
	}
};

// Block 20 (Formula)
class Block19: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "20";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Commission_Point;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Swap_Point;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(19);
		}
	}
};

// Block 21 (Trailing stop (each trade))
class Block20: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_indicators_iSAR,double,MDLIC_value_points,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "21";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftDigits.Value = 40.0;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		TrailingStopMode = "multiple";
		tStopMultiple = "20/5, 30/10, 40/15, 50/20";
	}

	public: /* Custom methods */
	virtual double _ftStop_() {
		ftStop.Symbol = CurrentSymbol();
		ftStop.Period = CurrentTimeframe();

		return ftStop._execute_();
	}
	virtual double _ftDigits_() {
		ftDigits.Symbol = CurrentSymbol();

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

// Block 22 (If trade)
class Block21: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {20};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(21);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
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
		int ___outbound_blocks[1] = {34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[34].run(22);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 24 (Bucket of Trades)
class Block23: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {24};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[24].run(23);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 25 (Formula)
class Block24: public MDL_Formula_4<MDLIC_bucket_bucket_1,double,string,MDLIC_bucket_bucket_2,double>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "25";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Attribute = 2;
		// Block input parameters
		compare = "/";
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
			_blocks_[25].run(24);
		}
	}
};

// Block 26 (Formula)
class Block25: public MDL_Formula_5<MDLIC_prices_prices,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "26";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {26};
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
			_blocks_[26].run(25);
		}
	}
};

// Block 27 (Formula)
class Block26: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "27";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {27};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::avab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[27].run(26);
		}
	}
};

// Block 28 (Modify stops of trades)
class Block27: public MDL_ModifyOpened<string,string,string,string,string,int,string,MDLIC_candles_candles,double,string,double,double,MDLIC_value_value,double,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "28";
		_beforeExecuteEnabled = true;

		// IC input parameters
		fNewStopLoss.Value = 0.0;
		// Block input parameters
		Group = "1";
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

// Block 29 (If trade)
class Block28: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "29";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(28);
		}
	}

	virtual void _beforeExecute_()
	{
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
		int ___outbound_blocks[1] = {30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[30].run(29);
		}
	}

	virtual void _beforeExecute_()
	{
		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 31 (Formula)
class Block30: public MDL_Formula_7<MDLIC_bucket_bucket_3,double,string,MDLIC_bucket_bucket_4,double>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "31";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {31};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Attribute = 2;
		// Block input parameters
		compare = "/";
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
			_blocks_[31].run(30);
		}
	}
};

// Block 32 (Formula)
class Block31: public MDL_Formula_8<MDLIC_prices_prices,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "32";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {32};
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
			_blocks_[32].run(31);
		}
	}
};

// Block 33 (Formula)
class Block32: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_points,double>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "33";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {33};
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
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[33].run(32);
		}
	}
};

// Block 34 (Modify stops of trades)
class Block33: public MDL_ModifyOpened<string,string,string,string,string,int,string,MDLIC_candles_candles,double,string,double,double,MDLIC_value_value,double,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "34";
		_beforeExecuteEnabled = true;

		// IC input parameters
		fNewStopLoss.Value = 0.0;
		// Block input parameters
		Group = "1";
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

// Block 35 (For each Trade)
class Block34: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "35";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {35};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[35].run(34);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 36 (once per trade/order)
class Block35: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "36";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[23].run(35);
		}
	}
};

// Block 37 (For each Trade)
class Block36: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "37";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Group = "1";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(36);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 38 (once per trade/order)
class Block37: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "38";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(37);
		}
	}
};

// Block 39 (Check trades count)
class Block38: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "39";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CompareCount = 0;
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[22].run(38);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 40 (Check trades count)
class Block39: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "40";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CompareCount = 0;
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(39);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 41 (If trade)
class Block40: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "41";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {41};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[41].run(40);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 42 (Break even point (each trade))
class Block41: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "42";
		_beforeExecuteEnabled = true;
		// Block input parameters
		BEoffsetMode = "pips";
		BEPoffsetPips = 1.0;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 43 (If trade)
class Block42: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "43";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(42);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 44 (Trailing money loss (group of trades))
class Block43: public MDL_TrailingMoneyLoss<string,string,string,string,string,string,double,double,MDLIC_value_value,double,string,double,double,string,double,double,MDLIC_value_value,double,ulong,color>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "44";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dtmMoneyAmount.Value = 20.0;
		ftStart.Value = 0.0;
		// Block input parameters
		tmFixedMoney = 9.0;
		TrailingStartMode = "money";
		tStartFixedMoney = 10.0;
	}

	public: /* Custom methods */
	virtual double _dtmMoneyAmount_() {return dtmMoneyAmount._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 45 (Trailing stop (each trade))
class Block44: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_indicators_iSAR,double,MDLIC_value_points,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "45";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftDigits.Value = 40.0;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		TrailingStopMode = "money";
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

// Block 46 (If trade)
class Block45: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "46";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(45);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 47 (Trailing stop (group of trades))
class Block46: public MDL_TrailingStopAvgPrice<string,string,string,string,int,string,double,MDLIC_value_value,double,double,string,double,double,string,double,double,MDLIC_value_value,double,bool,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "47";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.Value = 40.0;
		ftStart.Value = 0.0;
		ftTP.Value = 40.0;
		// Block input parameters
		tStopPips = 20.0;
		TrailingStartMode = "fixed";
		tStartPips = 20.0;
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
		LevelColor = (color)clrDeepPink;
	}
};

// Block 48 (If trade)
class Block47: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "48";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(47);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 49 (No trade nearby)
class Block48: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "49";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {49};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		RangePips = 20.0;
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
			_blocks_[49].run(48);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 50 (Buy now)
class Block49: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "50";
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
		VolumeMode = "balance";
		VolumeSize = 0.01;
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
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 51 (Trailing stop (each trade))
class Block50: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_indicators_iSAR,double,MDLIC_value_points,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "51";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftDigits.Value = 40.0;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		TrailingStopMode = "percentTP";
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

// Block 52 (If trade)
class Block51: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "52";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(51);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 53 (Trailing stop (each trade))
class Block52: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_indicators_iSAR,double,MDLIC_value_points,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "53";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftDigits.Value = 40.0;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		TrailingStopMode = "percentProfit";
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

// Block 54 (If trade)
class Block53: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "54";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(53);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 55 (Trailing stop (each trade))
class Block54: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_points,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "55";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.StartBar = 1;
		ftDigits.Value = 40.0;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
		TrailingStopMode = "dynamic";
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

// Block 56 (If trade)
class Block55: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "56";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(55);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 57 (Trailing stop (each trade))
class Block56: public MDL_TrailingStop2<string,string,string,string,string,int,int,string,double,double,string,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_indicators_iATR,double,string,double,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "57";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.StartBar = 1;
		ftStart.Value = 0.0;
		ftStartFraction.Value = 0.001;
		ftTP.Value = 0.0;
		// Block input parameters
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

// Block 58 (If trade)
class Block57: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "58";
		_beforeExecuteEnabled = true;

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

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 59 (If trade)
class Block58: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "59";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {59};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[59].run(58);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 60 (Trailing money loss (group of trades))
class Block59: public MDL_TrailingMoneyLoss<string,string,string,string,string,string,double,double,MDLIC_value_value,double,string,double,double,string,double,double,MDLIC_value_value,double,ulong,color>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "60";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dtmMoneyAmount.Value = 20.0;
		ftStart.Value = 0.0;
		// Block input parameters
		TrailingMoneyMode = "percentGroupProfit";
		tmFixedMoney = 9.0;
		TrailingStepMode = "percentTM";
		TrailingStartMode = "money";
		tStartFixedMoney = 10.0;
	}

	public: /* Custom methods */
	virtual double _dtmMoneyAmount_() {return dtmMoneyAmount._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 61 (If trade)
class Block60: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "61";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[61].run(60);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 62 (Trailing money loss (group of trades))
class Block61: public MDL_TrailingMoneyLoss<string,string,string,string,string,string,double,double,MDLIC_value_value,double,string,double,double,string,double,double,MDLIC_value_value,double,ulong,color>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "62";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dtmMoneyAmount.Value = 20.0;
		ftStart.Value = 0.0;
		// Block input parameters
		TrailingMoneyMode = "dynamic";
		tmFixedMoney = 9.0;
		TrailingStepMode = "percentTM";
		TrailingStartMode = "percentTM";
		tStartFixedMoney = 10.0;
	}

	public: /* Custom methods */
	virtual double _dtmMoneyAmount_() {return dtmMoneyAmount._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 63 (Trailing stop (group of trades))
class Block62: public MDL_TrailingStopAvgPrice<string,string,string,string,int,string,double,MDLIC_iCustom_ZigZag,double,double,string,double,double,string,double,double,MDLIC_value_value,double,bool,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "63";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.ModeZigZag = 2;
		ftStart.Value = 0.0;
		ftTP.Value = 40.0;
		// Block input parameters
		TrailingStopMode = "function";
		tStopPips = 20.0;
		TrailingStartMode = "zero";
		tStartPips = 20.0;
	}

	public: /* Custom methods */
	virtual double _ftStop_() {
		ftStop.Symbol = CurrentSymbol();
		ftStop.Period = CurrentTimeframe();

		return ftStop._execute_();
	}
	virtual double _ftStart_() {return ftStart._execute_();}
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

// Block 64 (If trade)
class Block63: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "64";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {62};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[62].run(63);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 65 (Trailing stop (group of trades))
class Block64: public MDL_TrailingStopAvgPrice<string,string,string,string,int,string,double,MDLIC_iCustom_ZigZag,double,double,string,double,double,string,double,double,MDLIC_value_value,double,bool,string,double,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "65";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ftStop.ModeZigZag = 2;
		ftStart.Value = 0.0;
		ftTP.Value = 40.0;
		// Block input parameters
		TrailWhat = -1;
		tStopPips = 20.0;
		tStepPips = 99999999999999.0;
		tStepPercentTS = 100.0;
		tStartPips = 20.0;
	}

	public: /* Custom methods */
	virtual double _ftStop_() {
		ftStop.Symbol = CurrentSymbol();
		ftStop.Period = CurrentTimeframe();

		return ftStop._execute_();
	}
	virtual double _ftStart_() {return ftStart._execute_();}
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

// Block 66 (If trade)
class Block65: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "66";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(65);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 67 (If trade)
class Block66: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "67";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[67].run(66);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
	}
};

// Block 68 (Formula)
class Block67: public MDL_Formula_10<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "68";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::TSP_Start;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(67);
		}
	}
};

// Block 69 (Formula)
class Block68: public MDL_Formula_11<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "69";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::TSP_Step;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(68);
		}
	}
};

// Block 70 (Formula)
class Block69: public MDL_Formula_12<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "70";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::TSM_Stop;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(69);
		}
	}
};

// Block 71 (Trailing money loss (group of trades))
class Block70: public MDL_TrailingMoneyLoss<string,string,string,string,string,string,double,double,MDLIC_value_value,double,string,double,double,string,double,double,MDLIC_value_value,double,ulong,color>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "71";
		_beforeExecuteEnabled = true;

		// IC input parameters
		dtmMoneyAmount.Value = 20.0;
		ftStart.Value = 0.0;
		// Block input parameters
		TrailingStartMode = "money";
	}

	public: /* Custom methods */
	virtual double _dtmMoneyAmount_() {return dtmMoneyAmount._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		tmFixedMoney = (double)v::stop;
		tmStepFixedMoney = (double)v::step;
		tStartFixedMoney = (double)v::start;
		ArrowColor = (color)clrDeepPink;
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

	if (memory == 0) memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);

	return memory;
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
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

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

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
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
      if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

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

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
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
      if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

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

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
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
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

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

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
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
   StringExplode(",", mem_list[id], listS);
   ArrayResize(list, ArraySize(listS));
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
            ArrayResize(list, 0);
         }
         else if (size==2) {
            lots = initial_lots*(list[0]+list[1]);
            ArrayResize(list, 0);
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
            ArrayResize(list, size+1);
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
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

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
      if (TradeSelectByIndex(pos, "group", group, "symbol", symbol))
		{
			if (TimeCurrent() - OrderOpenTime() < 3) {continue;}
			if (OrderExpiration() > 0 && OrderExpiration() <= OrderCloseTime()) {continue;} // no expired po

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

				if (lots==0) {
					lots=OrderLots();
				}

				profit = OrderClosePrice()-OrderOpenPrice();
				profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
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

	if (!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
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

			RegisterEvent("trade");

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

void ExpirationDriver()
{
	static int last_checked_ticket;
	static int db_tickets[];
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
				WaitTradeContextIfBusy();

				if (!OrderSelect(db_tickets[i], SELECT_BY_TICKET, MODE_TRADES)) {continue;}
				if (OrderSymbol() != Symbol()) {continue;}
				
				if (TimeCurrent() >= db_expirations[i])
				{
					//-- trying to skip conflicts with the same functionality running from neighbour EA
					WaitTradeContextIfBusy();

					if (!OrderSelect(db_tickets[i],SELECT_BY_TICKET, MODE_TRADES)) {continue;}
					if (OrderCloseTime() > 0) {continue;}

					//-- closing the trade
					if (CloseTrade(OrderTicket())) 
					{
						print = "#" + (string)OrderTicket() + " was closed due to expiration";
						Print(print);
						last_checked_ticket = 0;
						do_reset = true;
						total    = OrdersTotal();
					}
				}
			}
		}
	}

	//-- check the ticket of the newest trade
	if (do_reset == false && total > 0)
	{
		if (OrderSelect(total-1, SELECT_BY_POS))
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
			if (!OrderSelect(pos, SELECT_BY_POS)) {continue;}
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
			|| exp != OrderExpiration()
		) {
			success = OrderModify(ticket, op, sl, tp, exp, clr);
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
				RegisterEvent("trade");
			}

			if (OrderSelect(ticket,SELECT_BY_TICKET)) {}

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
		OrderExpiration(),
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
	ArrayResize(tickets_now, 0);

	int total = OrdersTotal();

	// initial fill of the local DB
	if (loaded == false)
	{
		loaded = true;

		for (pos = total-1; pos >= 0; pos--)
		{
			if (OrderSelect(pos, SELECT_BY_POS, MODE_TRADES))
			{
				ArrayResize(memory_ti, tn+1);
				ArrayResize(memory_ty, tn+1);
				ArrayResize(memory_sl, tn+1);
				ArrayResize(memory_tp, tn+1);
				ArrayResize(memory_vl, tn+1);
				ArrayResize(memory_op, tn+1);
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
		if (OrderSelect(pos, SELECT_BY_POS, MODE_TRADES))
		{
			ArrayResize(tickets_now, tn+1);
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
				ArrayResize(memory_ti, size+1); memory_ti[size] = OrderTicket();
				ArrayResize(memory_ty, size+1); memory_ty[size] = OrderType();
				ArrayResize(memory_sl, size+1); memory_sl[size] = attrStopLoss();
				ArrayResize(memory_tp, size+1); memory_tp[size] = attrTakeProfit();
				ArrayResize(memory_vl, size+1); memory_vl[size] = OrderLots();
				ArrayResize(memory_op, size+1); memory_op[size] = OrderOpenPrice();

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
				if (OrderSelect(memory_ti[i], SELECT_BY_TICKET))
				{
					// This can happen more than once
					ArrayStripKey(memory_ti, i);
					ArrayStripKey(memory_ty, i);
					ArrayStripKey(memory_sl, i);
					ArrayStripKey(memory_tp, i);
					ArrayStripKey(memory_vl, i);
					ArrayStripKey(memory_op, i);

					e_reason = "close";
					e_detail = "";
					
					if (
						   StringFind(OrderComment(), "expiration") >= 0
						|| StringFind(OrderComment(), "[exp:") >= 0
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
		UpdateEventValues(e_reason, e_detail);
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
				//- convert UNIX to seconds
				if (expiration > TimeCurrent()-100) {
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
		int exp_pos    = StringFind(comment, "[exp:");

		if (exp_pos == -1) return 0;
		
		int exp_pos_end = StringFind(comment, "]", exp_pos);
		
		if (exp_pos_end <= 0) return 0;

		int expiration_seconds = (int)StringToInteger(StringSubstr(comment, exp_pos + 5, exp_pos_end - (exp_pos + 5)));

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

int TradesTotal()
{
	return OrdersTotal();
}

void UpdateEventValues(string e_reason = "",string e_detail = "")
{
	OnTradeQueue(1);
	e_Reason       (true, e_reason);
	e_ReasonDetail (true, e_detail);

	e_attrClosePrice  (true, OrderClosePrice());
	e_attrCloseTime   (true, OrderCloseTime());
	e_attrComment     (true, OrderComment());
	e_attrCommission  (true, OrderCommission());
	e_attrExpiration  (true, OrderExpiration());
	e_attrLots        (true, OrderLots());
	e_attrMagicNumber (true, OrderMagicNumber());
	e_attrOpenPrice   (true, OrderOpenPrice());
	e_attrOpenTime    (true, OrderOpenTime());
	e_attrProfit      (true, OrderProfit());
	e_attrStopLoss    (true, attrStopLoss());
	e_attrSwap        (true, OrderSwap());
	e_attrSymbol      (true, OrderSymbol());
	e_attrTakeProfit  (true, attrTakeProfit());
	e_attrTicket      (true, OrderTicket());
	e_attrType        (true, OrderType());
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

	if (!OrderSelect(ticket,SELECT_BY_TICKET)) {return ticket;}

	if (retval>0) {
		return retval;
	}
	else {
		return ticket;
	}
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
   static string mem[];
   int queue=OnTradeQueue()-1;
   if(set==true){
      ArrayResize(mem,queue+1);
      mem[queue]=inp;
   }
   return(mem[queue]);
}

string e_ReasonDetail(bool set=false, string inp="") {static string mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrClosePrice(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

datetime e_attrCloseTime(bool set=false, datetime inp=-1) {static datetime mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

string e_attrComment(bool set=false, string inp="") {static string mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrCommission(bool set=false, double inp=0) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

datetime e_attrExpiration(bool set=false, datetime inp=0) {static datetime mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrLots(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

int e_attrMagicNumber(bool set=false, int inp=-1) {static int mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrOpenPrice(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

datetime e_attrOpenTime(bool set=false, datetime inp=-1) {static datetime mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrProfit(bool set=false, double inp=0) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrStopLoss(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrSwap(bool set=false, double inp=0) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

string e_attrSymbol(bool set=false, string inp="") {static string mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

double e_attrTakeProfit(bool set=false, double inp=-1) {static double mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

int e_attrTicket(bool set=false, int inp=-1) {static int mem[];int queue=OnTradeQueue()-1;if(set==true){ArrayResize(mem,queue+1);mem[queue]=inp;}return(mem[queue]);}

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

int iCandleID(string SYMBOL, ENUM_TIMEFRAMES TIMEFRAME, datetime time_stamp)
{
   bool TimeStampPrevDayShift = true;
   int CandleID = 0;
   //== calculate candle ID
   //-- get the time resolution of the desired period, in minutes
   int mins_tf = TIMEFRAME;
   int mins_tf0 = 0;
   if (TIMEFRAME == PERIOD_CURRENT)
   {
      mins_tf = (int)PeriodSeconds(PERIOD_CURRENT) / 60;
   }
   
   //-- get the difference between now and the time we want, in minutes
   //int time_stamp = StrToTime(TimeStamp);
   int days_adjust = 0;
   if (TimeStampPrevDayShift)
   {
      //-- automatically shift to the previous day
      if (time_stamp > TimeCurrent())
      {
         time_stamp = time_stamp - 86400;
      }
      //-- also shift weekdays
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
   
   //-- the difference is negative => quit here
   if (mins_diff < 0) {return (int)EMPTY_VALUE;}
   
   //-- now calculate the candle ID, it is relative to the current time
   if (mins_diff > 0) {
      CandleID = (int)MathCeil((double)mins_diff/(double)mins_tf);
   }
   //Print(TimeToStr(TimeCurrent())+" "+TimeToStr(time_stamp) +" ::: " + mins_tf + " " + days_adjust + " " + (days_adjust*1440/mins_tf) + " " + CandleID);
   
   
   //-- now, after all the shifting and in case of missing candles, the calculated candle id can be few candles early
   // so we will search for the right candle
   while(true)
   {
      if (iTime(SYMBOL, TIMEFRAME, CandleID) >= time_stamp) {break;}
      
      CandleID--;
		
		if (CandleID <= 0) {CandleID = 0; break;}
   }
   
   return CandleID;
   
   /*
   // this method does the same, but it is slower
   
   if (0)
   {
      CandleID = 0;
      datetime t = StrToTime(TimeStamp);
      datetime now = TimeCurrent();
      datetime ctime;
      while(true)
      {
         ctime = iTime(SYMBOL, TIMEFRAME, CandleID);
         //
         if (ctime < t)
         {
            //-- if the time is still in the future, we will shift to a previous day
            if (t > now)
            {
               if (TimeStampPrevDayShift)
               {
                  //-- shift to the last day that is not sat/sun
                  while(true)
                  {
                     t = t - 86400;
                     int dow = TimeDayOfWeek(t);
                     if (dow > 0 && dow < 6) {break;}
                  }
                  continue;
               }
               return EMPTY_VALUE;
            }
            break;
         }
         CandleID++;
      }
   }
   
   */
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

/*<fxdreema:eNrtPcty40hyv0JrIhwznu5pVBWebO9G6Nnba6kli5rZmLkwIBKUMAIJGACl1k70YT/AJ9the32y9+AIn+wNH+S/0ae4XngDFECBFEVUx8RIQhWqKqsys/KFTLNv9H8J+gD0d0bubGaNQtudBTvvzb6s93+x+xL+DZEeSn9nYlvOeOd90Nf6OweHR7vfH1+Qv9T+TuDO/ZG1897uA/YgNP0rKyQP4Psv5GmzUVB+FJmMAhuOouRHUckoqOEoan4UjYwiNxxFy4+ik1GUhqMY+VGARIZRmx6SVBgHkHG0puMUThvQ49abjlPYY6CQcYym4xTwBtDDAo2xuHBcgJ4XaIrI+LX8QAYdqCkug8LRQ3r0oCk6w+LZU+ICTTEawsKKKBKBpkgN5cJA9PRBU7SGBYKHlOJBU7yGBXyEDI+aIjYqbDZie9QUs1GB0hClNNgUs1Hh1BCiAzXFbFigNURPDTbFbFQ4NURPDTbFbFQ8NXZtNMVsVKB+RKkfNsbsAtEiikewKWajAhtBlPphY8wugAYZaI0xu3j8bLMbY3aRsVGERE0xWy7QGqSsFjXFbLlAazKlNdQUs+WiGEP3CDXFbLmA2TKlNdQUs+UCHskUIVFTzJYLp6ZQhERNMVsp8COFckjUFLOVwi2iMDxqitlKYbMVttlNMVspbLbCRMemmK0UNlulmy03xWy1gNkqxWy5KWarhc1W6WbLjYXrwmardLPlppitFhibShmb3BSz1cKpqZSNyE0xWy2cmsZOrSlmawXGpmES+UKfXTru6Iaqaxog6hrBCAjI4DpV6ELfdZg2R57B/s6xS/6C/C+bzg3wQkbmbOxYwZD/JI9zI2h8yfbpb473+SLtfccNLDoG/uvEHVv79P0jezbeuyfP40nwaKzt4wHt398B5KfR37mwp9YgNKce+RtPIEl9SeITDO6nl65D/pD6O/zZmeXbLlu4jP86PP94ejDc//78/PAT3TyAu+6f4j/3Lz6eforfJTumEZCmnulbfG2f/5r/cl62L3h4DIg9MkPXD4b2yW7Jtuh8s092vXhdeAQg81M92Q2u7UnIYZb4CCe7Uyu8dqOdOTk9OBwesvEBfnvX8xzbGp/59ojtLn717Pzj/uFw//h0cPiMzcH7O0itBzyxYaRp5LtBcGePw+vkpS9s/Ggjhtbn0DfJdoDYmkDeGhZfM9hbpj2zfNIgEwQY3fCNGNuBeelYGIBLakrAG4iHtnxmkpD6v3yJz4fZGvBwNsbaeRC6U/KSxMZhdGGFETHdB6E15XNMMZo6Q3bE+PV9Fx8xsXrQZeIJMXqY+HQsfOQj1/XHQXaHPXs2YwuU2H4GI9OxeOPM9aemE21qYJGxCPIkqyerCc1wHsT4hodwZ+5kQkCS2I6MzdBMzoF2Ce2QzQJlQmm39uyqt3tr+eaV1aNU2Nv7/ke+CjwYhZ1PgF9wrAkXrckMCA/netQKoZDhcYc70w4jmPCm3Jq+TQ4itXC8M+489OZhkB7Yxs+iw8J/WvxPiQyLpxkFtDdld4RFXJqjmyvfnc/Gb0eu4/qcSL46OjrY3zU4gsYtGGm+itB/gpHm7Z1lX12H6Z0h1HKJD8ny3wbhPdshfMYhXv7sivzJ7UalTJHSLob2A16RR7gXXwBZYcSNPkS/cwwg58oIL3qB4ldEiWVkSZa/N78PTv2B5TgBx/pL/CSi91MCwIk9m4dWGtvwcgeO7Xn4jPl2yNESdn3fvduPN4oQnOMfWJZ3Zs9u2iY0+HxCIyukaHrqWZR8VktrCrsMI57LQIh+RzE/Ina85LkS/94GnZJzZYSJWeOYnetC2pSlLG0CtS3ilJ5HnLKqw0s5T5ykZUL/VZBo6ogqrwu2+jIiZlvKzLVComkg0fxaSDSvVqJB3ZRolAqJZnB4fPwk21RlpXsijbx5Ig3Bm+j3VyDTyEKmWYNMo+qKkGkKMo3yimQaaQNkml/96imZZp/S8PAn++on86pkW+Ig
B9bjwPLiS1yJNjdqurXN+PLk8JM5WPMexifMDrxMq8R2NZk9lkPiYc8tfLMFuW1tQeJJsfC2BB6Gvy2yWqWTUk1+yQv5JIA5PokkqQNijFrFCPGpbIJpBhFW7HoHts8CoyIeOrPurCB8G7pvXQdfgyGHjfQd3NjpNRns6SGm/vvi42N7amcUF7zjZ2YQHM7GO+mLu0ViVFuQexQOamj64UUsCKxL9gEp2QdUyD5gBbIPbj9y/Z5ljq57FOqnqRrkLDpI2RCq3j+UpP3DMvHniP6roG1CGy5xWD1D+NGWEX6gRAwXDka6IdUrBnhHj92gTAKKdirFNBx8+TpNhY6/eIVCBxRCR8TnNCF0NBY6ZNgFoUOvFDoYweKxzi0Hk+OtdeHyTXWxhu9Ftku88MiQWeALgGyWM7eG9P9V7AlD9UPUniboCmrCC/hk3Q2Op5yl4SEn81kikQDWnuKJeEEKHRWiTBum8pE1C2MzLD4j6TuFcSO9rGd2MKmsy8VZphM5gklmOYJ5NmSe+MzG3uItbI5nxIQv1Zl53PbMxFrwnSSBWlh+cRZhuUw45syKBHHSZt5YZ747sXNoqeRaF2A5R+FC3+yAsLzT4DiL6TLD9PSy2jko5cmDUjiKtD83qDX3uP25a6IJaTomAt26LMV6CxqTzDQmzHPsyf3gmLHMVcoTckOFqUUD8ZQC2cNb5QU1ZJCciiTr0mosxKChDDKZ6CNmB24qgyypGBnCKrz1VmGhoMVs1RAK2tPRejkFDRpdcG7Tz/U2zSyccW9voV0YSMIwvDbDMLEDC8NwTv4BQFiGhTt69YIHAELyaCx5yKATkgcUtmFhG95o9ilsw8I2LGzDm2IbBlAYh1dnHM5/rQhko6vGYVD5HZTyopFyLrl5W6Yp1A5NfZywuHyqFgavRErXybpZdH2N8LK88wSiDTEj7Br7BjMWrIs+Kr+IAeDlCYR/ETNjN2JqDRP7M/9wJNV+ZnuRoA6UCG/jxnJxo9ijRPTeO2TIdJJIUR6fi0hRe4dnrD1eAH4Ibvv9YD4dBnemhylmOrWDgMrTLRO93A7R7/mWeXN4a83OXJtJbpt0kYJ2LlJocEB7WNaZ9TwCau9ran+knOObp1mHlFfwFSiJL3NY8rpSNoKkTWAjxOXqm7bzu2sz4x8gWgltsGdYOZ1YvjUbWcnHtpFqqya9iBZXxojwDCFpSzEhOZb6Q/bWzLrPKgQoapo7oe058Re+UHqnvOkh6R2IlSI2eJpFESbDnMbEzJBuL9HnMAQT2qXcFZ7+uHmwe16iWqgcWwdc7af6nwSjb5vNz/Z0PuXLkr6Da1Psid0mPLCv7LBMsYaRxkRpvcy4LZeoa3LkpicHnTYqgUrsW6BbZZDHWoA8Vow8seVEjhr4wQ+y+KOlhzb98huS4R9uTd+PUnTyvCk9fgqx8h3i67NqgLNMu8awDre3os3W2GwlnvHIN7k1b416tJwcSKnRBW8I3iMvOQgYCxnkee4UIDsFYhKhO7ueLVy7LaCF79wIJ01zaLhqCUZ9hv8URN8TtSjZpJgMNRI0E2uMrFBD7AdCpgFqd0wHqjAd1DMd5JJmINBZw4G2od+gRoaDtcUa8cdrCDXSRKjROr9BLQQRilgjUPkRGFoUawSzsUb7KXNYkX1EAQO1woowmO8WRRXp2Zl/cJ35tFJQjlzYSS+yjYPD41qh1pXbSsfG52mOf54zfoMPm6v2+LFvBVj9p0MTZOr3k+0Zcmtcy3ykhS8zNEpQ07ljvpJbPrvgp/wD+awS8oYIxJOJrjOlsIUonpiojWWImiwzE0B4Z3qCnDPkjCg5k41ZESEbgpCbEbIsbTMhQ2kpQl4ipEViDq7iTdWM1r9dROtLhP3JbFlpimuHwhP0T8ibSDXrcfJBSdD5YjpH+YAXbavpHHTR20YQOuUna83hRkIdUw63Nz0Z/8B/KdI7KNxvwv3W3P2WjrIV3jfhfdtk7xsEHfO+SRvnfUNKzqmgCfcb
L4jYDfcbhML9Vssony/10V33G2wnrj1d+KHFFLAtk8erDGxH9e6oFwh+z942Smlq+ddHLeVUv5CGKmPfVf5sbz66sUL2uaJGxbAPvnnPVYYtIrA2gsjj7cKrtUbhemo7vFAgOUFuBmzPnfQu6tV0ACB3e2lg7ZSnaIpWpLzWXMdL0KCylMkaEUIg+z9kP6osJgtpmKirR7YTEod06gP/JMxjNwx9+3IeWrk6VdRkFdFxSsA8t8K5PytpaMX39TIww1ZhbsGpBqjV3XScoeOGl62zQkWY2huJD1qpsrqZNvUl2JO6LHuimS2CIfuxwPAZm7/xO7uDv+EHQNCXkW+CJU2sngXO8nYRZ1nCTAuomTJDiC2ZbJ/pldMYe7g122cNqmANjViDDreaNWhrcrbrzKnNULpF//pyzhkgbQqlq5TSQ699QtcEoTcjdE3ZZkKvLnygboCtrbxqZDor0+LMWzTjTtSlKgVXZ7IlR3m/jhMHYoPMYDXyfdVI5bWSfGdPpHuqk8JpRbmZdDJ+xMk3zDnaRg57SPHentyvxyRW5RtNlzuVKsqdpr9MbOnTCxiDz5IXEYNZzSKoQDKyBjNDXbtAuXIX6BL3kbGBrp8kzXPLFGgI3097vh+UIyhlCePNdvh+kNTE90OT7zr+iXmF70Tz5fw/q6IyJAkH0BocQPnswBqSOu8AQmCdDqAiIXfDCdQC3JvtCGqfJQJhBGokS2j6Nlt7EVynI2iPUe0qHEHfrtgRFGycI6h91gAFa2jEGnS0zfZhhNbuCApe2v27kY6g9gkdCUJvRujbLQPIm+gIyhRYE54g4QnaBk9QsGmeICRvjycIvD5PUL7wn6EowhPUR0o7OfhWF5mwhQU/URvpakUWviWz8KmbUk/vBZPwocqgZJZsCw+76zju3amTcneSVAY+uWZbpoY2MscCRg2nJBsIW9EqKQFkKaGVq00i/UdWz7N8dqe9o2fXPMRBVTcEv9deqQlpm3iZbXv5aiRyyq7xNiOZHTLUDkVKWaRv0G2mi9vsObdZPpOJqkldvc0qg/SobUwjRaXTBvpfRwYC/ngfwxDmjF/b88E5aiOqDzfuX1ujG3bjJBu2HXF9xIBIweM2kt4oAvApgTJLgrKhdCxFSr44uSxtBSmuKvZPlgQtrogW89ehIkldp0XQmaReMngvknrV0Yq0QqENTeloVi8Zimq8rVfjje+BNom7pYx9ouxurQyZqrypBTleNEWm3J3i9rIobl/zG6+ciVGTu5oiU64O19I34jJNpQ+nqepTC5lGqetpburpEblg43T2eFQjzv89LYvSScpGj8MpfW93ylSWNop/xHmzl8q6noCmkuWT1gJ4IAEvnX79pHb14+wkLCN5ZpIFSdRPslnY155FHY8wcGzPM68ii4QcvbHr++7dukKe5DZCnvI4HgXKrcs5JFV8Ab+gNm8bHBul4O5RZOw5GPLe15TDJJFPNUrz5iJsgRB88MEpXSyAkuZrDaqf0IogSmX5EwJJqvyJKHiypQVP8PCZCheNi57AxbdufvylKp9AUflEVD5Zl3zTRiDna6p8Ajau8gmJ5szUc1CFdIOPTu2OWUcVZp1aZh01lzqku5VP5Mo4UQiXII/2hPsFYnuu0lxGbIdPystLmWhkqcZ9W1Um8QVq5mXcSGWiI6xXNG/9oh+k3yJb4eksjgKNwxNfg2hWF1nWK5y1EJdM4hjTBLl7e5Xo2t2R0RAoyGjNrVC5QBZdyGn4+PTuyGm6kNPqud/UXIZF0NlYlsoIaIA2wUarsGwCoOQOlaI7NMQdyq7QCCqylAveJ/3lPU1T4M79rF13Uf4CspOkMZf3AKRHPDF9nvEtAtBIv0R+mxBCyqxG413cqYcFjln4o2X66SH0XDuWBtn+RB3UXIcDM/3lUmH832CwI4kPZhYZz0BzU2QWme8ysPB2jzNdULLbsbU2bpT5zpIGAmCagQAl1Uihy7SmX/2dZd1kGlGqEcNd+SIBOijZ
NDZnkoujrJnBWtp8Y3tkSWM+MxGRTYfk0PjyJcZfKPBX4O9rxN9oR/bMIHGBkcRVc9/nkQwkbixp3bwqS9xjc27OrvKRiLiJPi4qsIi3JH4COi8182d7nLlBnJdziW8/pSeFOqOdbz8/uZ8wzl7en89nM6xjrDOKsaZ7v5WPACikTAzszSjAT0uDMBeMtdFGu5TYtBJ9San8EEdB/EBqWefwzx9cZz6Ns9BqBFLHnPHrKm4f2L+3Et9xbJ5KGs/t4CYbXxy/GzURm0viPWdtqWCrrFOcNe8R2kn1wfuJoo0dp1fWgvGGer+fdA/qJNfvZ2t8bmJ+8v3MDst2Rkl3OrAcRgoZy9t0enL1Eb9um84xT/WZWoDOOvDggvvTWRzsw7MHE4NMtkcSORALCxrrszsekykyg8SXbaZDZozMUs+ZWa4wgpZprloDQFCtBhZFXc6tW8zirOwFF41xZF+6lWOQaJDp9ABzveml5YdPbGzcr2JCSFd0bF6689G15VvVw6nZjsd2ECdUBm/gG/RGfqO8UZO9TrpWwUqnHlh/R27rkgkBb06OAr+N8FRq5u3So4C8sWpqNaK67z3P8uMMChGvgCSChOVXOynaXtPNqZs6yYSWy98WixGUbpT4s4Zct0K8DB5p7LSd5w3UsNmOvVZnzYK0aN5xq/Om2dQTURBxRrqy4850KB44zDQvOHKjpCMLUUntECSH3nKGvDrHTub1Wp633sGTmcctz1zv6DENHn6OTUl4tR8u9rlkgJ/nVB+dPox1nvSekkEK6g4RDHGDULRfs6IN165opz2ia9a0k/Qo1fHkRHm9xxs55VJqCpQkzHxvfp/UEN9zGmdceVIHVVr4+pzWYrn/5N69VGB5lWNPaj/rkEZh7c0YsIuVTzmrfAJlRU470FD7lCRdKqZsftJp95xkQwbx0Y/C5EN0BXQxgjwVo3smoshFFLmIIhdR5CKK/FmREQoQUeQvHEVOyo+LKPKCtR12JjpJgSI6qVZ0kgFFFDmnDtRF+Z+6zPPStlAChBIglAChBAglYHkBBAkl4IWVAACQJLSAopwjd0cLkIUWULOoji4JNYCRRycTyeCtHt/PzKk9euXyP7kzeAjwsUtqsBz57vTC3a8sTKnyk6bi1Z7p54Tjw9mYP0wXuCWbf+F+sMKnROnnFZwU6oBQB4Q6sBXqgMgs8+LqANKFU6BE3ulOahlFpJapqQ7ISHgFOHloXfUKcH0gEj+FVvA6tIKc/2P3osz/EbF23OrFCyGgyGtzdQjVQagOQnWoI7VoQnV4adUhX21EqA5UNupOtiNFZDuqm+3IEKoDJw+jO+RhCPKoRR5yLjBVk7uaDEyVXmktHqKJckmULiL1hfp2VeZJaUonojrPplfnob+okSniVVfoWUJh2KwKPSgnA+mtpXx8zeqC2p1Kv6qo9FtPHiLFq4Q8RKkDvlJ5KBs6JGSg5WSg0omEHLQU84XvRZXCF5eBNCQJGajI5dErK1VCnI3zWZyWdKlqJeTs9iklDn+yr34yr0r4jUGPDa+G9TiwPLbeJBeQkrTd2mYqC6oSTcKa9/C5B/y7rjjPosTiHZPp4/w/8bA8nVycP0lanyt0s+qu4Nd+b/muKLsiyq68pxxLlF3ZnLIrci5/sKi7Qq/V7nzTpIpvmmq6WnLhvgrsqiNSVTZM6MRrfbvaAnlC5FyvyImXZGT+VQugqZjOBRJonKBXSKCdl0AVIYFukASqyaLyX8kd253PaFTxGc1yzq0OS6Bad6hDE9SxVF1MQ+4sdVTGUSMu0B27Jd804d/M0Yi4SYe77OdeUvIo70OmQC+sljBypxgjItfdX3Fx8Nxtp0oFkcpH/f7F4GzIJfIF66ncSzouPjpz/PM8iFKAv+PivkqF77kT8gXd9vsBm6plCm8hFhxPcITJce6Yr4SyswtuRtjGhnj+JhNdL2aZr0PYi4jX2H7ihWni5WaOFdKuxmmXzNQy6RqCdJuQLpDkbaZdTeoQ
7Z4Mma10PbTrtk67miRotxntGtI20y54pfGSma8dSqIlDWK/jmnoVUZNFj7oKImYxPOD+JZf8ccjRjRXpHiI2MkqJgu2OHZSei2xk7lknADIInaSEQnesBBvL4NNi5ZLMlncWsMqIiCDer77szUKhzNe5JBkBPj669+e7p1efPNN7+J89+Pxx08feoMfBxeHJ4P8W+G9FyGh9dmzOBchG4fxfohlv6u5GRd8P/nbYzku7myGeF2+ZZKqhaTgmq7qMsL/N4Cc7oLpx57cV3WZmlf2aBizLzwHNBTqZYaEGdmBjXFg6NiXvunfD+NrLkOkpFBi1JNSclU/gnf21PKHQVJcMP60jKyGppsc+nOOdohQnpTCtYlP2Ma4TzOCsJdDlz8A5OoGFZ2L3SX2Aqx8ofyNL4zXzAPMo20/nJvOkNymESgzN9m6VCst2UkJg5E72TEyhIU348qaje5LBiF9cu1D33LyFSrzXcxxtkIl/sW6xfdQMEx5hcMIfY24dXQ/wscXpezhDI80zwgXGAYexrTxkPLXTCQoSrpwFpfNFBVa+PjxiV+7d8Mke1C+APaVb3rXQ9e38VqSaAjiUnS9C3fPDel9wb+Q5ZSDycX2486c0dMLy7v3I/6AmclvXSw4xVRjBSPf9nJvEQZJr7z4CVE28E2S7hZfhxjQWZioYBqNoGDCE0+MGt/o6TZ2ZWIunyL5sTu/TBJXlS9O4UJBcqxfvhRZNGAcVoknHDK5DhQXVdqpxdWVzQDrLAOufBmozjLQCpexPw8dXqi6ehlxp3aXgV8mJVjtgKD18Izw2pJ1lPZqdyFEIbozvcol5NrbnRwTTjCfDgMywSgGtGQVVR1bXQ4eynScoeOGl8UlZBpXNG2waNq2URDzWfPWLIE0bljBdEHVdG1DR8QbrwS46Hn7kwUVkwVt3zb4qYkFACYcS0QsI253PUsw/R0tvoLLxeV0mqv32e/akcEmv7PHxMpBKixIbNXXXNjHMonOVbdYMZLxBfv48G+PD//7+PCPjw//9Pjw58eHf398+K/Hh/95fPh7+h9+8g+9j1nRowg+eXSQfoSFQ70MRr02jAAiPQslrd+YBlI2CkAiKQ+kCgiQf3p8+O/Hhz/S/yKA/+8P7EnvwL3rXVxbrn/fi/VEYpP9y9ll4L1vALJRBrJRH2Sg5kAGEswDjUABaLkAtEIKbWOUu+kRAbX3+PAHeqT/+vjwz48PD/iXHt2S/8TH3WP3FQah922PXBwN4AVSAeB03s2nIYZKDpM1PQcuLEFkNQ8u1FMaPjm53mGcRa539vGsCUigFCRQHyQV5IlTXQomJQ8TzdTac0iIZxOAYClAsDZAsqzmkVLOI6UiFSBStAIlKllKjHHwj72Ls94JVqIxqKZj9Shl/gdG2h4poJ78Rcy5TSBHpZCjJiwoB7piFMgRFs9SK8NPSo6cGv+FQv4nymwx4/1zE6DkUqDk2kCphpyFSS2QnK4XQdLyIKUCd3vUaN9LPrqvCYpSCopSHzPV3PGoBUqj637idIBeAKUhz1BLAVGX5xmKXuQZRgESRc1BgqRSPkhj3psfj1YKldYAKikLlS4vB1WBu3NVj5huTz3PDezQ6sVO1JrQ6aXQ6cufGQASWAo8sAC8VBKzmnAZpXAZy58aQMpyxwbzcLEPf3o0wL933PAeg6WyBpSeAZgKlgJMLhzY7sV57+sMdFEW52+aQFgqesAGokcOwMJlBaUSrSAPnk5cW5bZ+4rNXHfxpWIGhA3upbxSU+DmiJ5Xjpvnl59OsB9x88SIWBeaUtEBouWh0STQEjQHqaQ+NaEpvWhhg4tWy2GWVqQcrUSmXcgSGDQXWCjiXK6xugVL712oLg8XMqSl4EIFuJ7H60qvXlj/6tWNHGCK9LQaiQB6v8BzmqGl3g/cfN5QrPiSdQ5wF3ANV2EtL9mX/wcicOBu
:fxdreema>*/