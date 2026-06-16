//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2020, fxDreema  (//
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
#define PROJECT_ID "mt5-6558"
//--
// Point Format Rules
#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later
#define ENABLE_SPREAD_METER false
#define ENABLE_STATUS false
#define ENABLE_TEST_INDICATORS false
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
input string Symbol1 = "AUDUSD";input string Symbol2 = "AUDCHF";input double Graph_level100 = 0.701;input double Graph_level0 = 0.7;input double Graph_Adjust = 0.7;input int MagicStart = 6558; // Magic Number, kind of...
class c
{
		public:
	static string Symbol1;
	static string Symbol2;
	static double Graph_level100;
	static double Graph_level0;
	static double Graph_Adjust;
	static int MagicStart;
};
string c::Symbol1;
string c::Symbol2;
double c::Graph_level100;
double c::Graph_level0;
double c::Graph_Adjust;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double DIF;
	static string DIFx;
	static double Plot;
};
double v::DIF;
string v::DIFx;
double v::Plot;




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
int FXD_BLOCKS_COUNT        = 12;
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
	c::Symbol1 = Symbol1;
	c::Symbol2 = Symbol2;
	c::Graph_level100 = Graph_level100;
	c::Graph_level0 = Graph_level0;
	c::Graph_Adjust = Graph_Adjust;
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

	v::DIF = 0.0;
	v::DIFx = "";
	v::Plot = 0.0;




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
	ArrayResize(_blocks_, 12);

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
	int blocks_to_run[] = {5};
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
	int blocks_to_run[] = {0};
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
		
		v::DIF = formula(compare, lo, ro);
		
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
		
		v::Plot = formula(compare, lo, ro);
		
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

// "Log message" model
template<typename T1>
class MDL_PrintMessage: public BlockCalls
{
	public: /* Input Parameters */
	T1 PrintText;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_PrintMessage()
	{
		PrintText = (string)"Enter your text here";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		Print(PrintText);
		
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

// "Draw Text" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21>
class MDL_ChartDrawText: public BlockCalls
{
	public: /* Input Parameters */
	T1 ObjectPerBar;
	T2 ObjectUpdate;
	T3 ObjName;
	T4 ObjectType;
	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}
	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}
	T7 ObjX;
	T8 ObjY;
	T9 ObjText; virtual _T9_ _ObjText_(){return(_T9_)0;}
	T10 ObjFont;
	T11 ObjFontSize;
	T12 ObjAngle;
	T13 ObjCorner;
	T14 ObjAnchor;
	T15 ObjColor;
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
	MDL_ChartDrawText()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjX = (int)0;
		ObjY = (int)0;
		ObjFont = (string)"Arial";
		ObjFontSize = (int)10;
		ObjAngle = (double)0.0;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
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
		string ObjNamePrefix = "fxd_text_";
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
					Print(__FUNCTION__,": failed to create text object! Error code = ",GetLastError());
				}
				
				double p1=0, p2=0;
				datetime t1=0, t2=0;
		
				if (ObjectType == OBJ_TEXT)
				{
					ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,(long)_ObjTime1_());
					ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,(double)_ObjPrice1_());
				}
				else
				{
					ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,ObjX);
					ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);
				}
		
				ObjectSetString(ObjChartID,name,OBJPROP_TEXT,(string)(_ObjText_()));
				ObjectSetString(ObjChartID,name,OBJPROP_FONT,ObjFont);
				ObjectSetInteger(ObjChartID,name,OBJPROP_FONTSIZE,ObjFontSize);
				ObjectSetDouble(ObjChartID,name,OBJPROP_ANGLE,ObjAngle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ANCHOR,ObjAnchor);
		
				//ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				//ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);
				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);
		
				ChartRedraw();
			}
		}
		
		_callback_(1);
	}
};

// "Draw Fibonacci" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename _T8_,typename T9,typename _T9_,typename T10,typename _T10_,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27>
class MDL_ChartDrawFibonacci: public BlockCalls
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
	T9 ObjTime3; virtual _T9_ _ObjTime3_(){return(_T9_)0;}
	T10 ObjPrice3; virtual _T10_ _ObjPrice3_(){return(_T10_)0;}
	T11 ObjRayLeft;
	T12 ObjRayRight;
	T13 ObjFullElipse;
	T14 ObjScale;
	T15 ObjLevels;
	T16 ObjLevelColor;
	T17 ObjLevelStyle;
	T18 ObjLevelWidth;
	T19 ObjColor;
	T20 ObjStyle;
	T21 ObjWidth;
	T22 ObjBack;
	T23 ObjSelectable;
	T24 ObjSelected;
	T25 ObjHidden;
	T26 ObjZorder;
	T27 ObjChartSubWindow;
	/* Static Parameters */
	int count;
	datetime time0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDrawFibonacci()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_FIBO;
		ObjRayLeft = (bool)false;
		ObjRayRight = (bool)false;
		ObjFullElipse = (bool)false;
		ObjScale = (double)1.0;
		ObjLevels = (string)"";
		ObjLevelColor = (color)clrYellow;
		ObjLevelStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
		ObjLevelWidth = (int)1;
		ObjColor = (color)clrGray;
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
		string ObjNamePrefix = "fxd_fibo_";
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
					Print(__FUNCTION__,": failed to create fibonacci object! Error code = ",GetLastError());
				}
		
				double p1=0, p2=0, p3=0;
				datetime t1=0, t2=0, t3=0;
		
				switch(ObjectType)
				{
					case OBJ_FIBO        : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_FIBOTIMES   : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_FIBOFAN     : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_FIBOARC     : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_FIBOCHANNEL : {t1=1; p1=1; t2=1; p2=1; t3=1; p3=1; break;}
					case OBJ_EXPANSION   : {t1=1; p1=1; t2=1; p2=1; t3=1; p3=1; break;}
				}
		
				if (t1 == 1) {t1 = _ObjTime1_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,t1);}
				if (t2 == 1) {t2 = _ObjTime2_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,1,t2);}
				if (t3 == 1) {t3 = _ObjTime3_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,2,t3);}
				if (p1 == 1) {p1 = _ObjPrice1_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,p1);}
				if (p2 == 1) {p2 = _ObjPrice2_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,1,p2);}
				if (p3 == 1) {p3 = _ObjPrice3_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,2,p3);}
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);
				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_LEFT,ObjRayLeft);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_RIGHT,ObjRayRight);
				ObjectSetDouble(ObjChartID,name,OBJPROP_SCALE,ObjScale);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ELLIPSE,ObjFullElipse);
		
				ObjLevels = StringTrim(ObjLevels);
		
				if (ObjLevels != "")
				{
					int i, levels;
					double levl;
					string values[];
		
					StringExplode(",", ObjLevels, values);
					levels = ArraySize(values);
		
					ObjectSetInteger(ObjChartID, name, OBJPROP_LEVELS, levels);
		
					for (i=0; i<levels; i++)
					{
						levl = StrToDouble(StringTrim(values[i]));
						
						ObjectSetDouble(ObjChartID,name,OBJPROP_LEVELVALUE,i,(double)levl/100);
						ObjectSetString(ObjChartID,name,OBJPROP_LEVELTEXT,i,DoubleToString(levl,1));
					}
		
					//-- these parameters does not work per-level anyway, so it's enough to set them for the last level only
					ObjectSetInteger(ObjChartID,name,OBJPROP_LEVELCOLOR,i,ObjLevelColor);
					ObjectSetInteger(ObjChartID,name,OBJPROP_LEVELSTYLE,i,ObjLevelStyle);
					ObjectSetInteger(ObjChartID,name,OBJPROP_LEVELWIDTH,i,ObjLevelWidth);
				}
				else
				{
					ObjectSetInteger(ObjChartID,name,OBJPROP_LEVELCOLOR,1,ObjLevelColor);
					ObjectSetInteger(ObjChartID,name,OBJPROP_LEVELSTYLE,1,ObjLevelStyle);
					ObjectSetInteger(ObjChartID,name,OBJPROP_LEVELWIDTH,1,ObjLevelWidth);
				}
		
				ChartRedraw();
			}
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
		
		v::DIFx = formula(compare, lo, ro);
		
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


//------------------------------------------------------------------------------------------------------------------------

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


//------------------------------------------------------------------------------------------------------------------------

// Block 1 (Formula)
class Block0: public MDL_Formula_1<MDLIC_prices_prices,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = c::Symbol1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = c::Symbol2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(0);
		}
	}
};

// Block 2 (Formula)
class Block1: public MDL_Formula_2<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "2";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {2};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Graph_Adjust;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[2].run(1);
		}
	}
};

// Block 3 (Once per bar)
class Block2: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(2);
		}
	}

	virtual void _beforeExecute_()
	{
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 4 (Log message)
class Block3: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {6};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[6].run(3);
		}
	}

	virtual void _beforeExecute_()
	{
		PrintText = (string)v::DIFx;
	}
};

// Block 5 (Modify chart properties)
class Block4: public MDL_ChartSetProperties<int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {11,7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ChartOnForeground = 0;
		ChartScale = 0;
		ChartShowLastLine = 0;
		ChartShowPeriodSeparators = 0;
		ChartShowGrid = 0;
		ChartShowTradeLevels = 0;
		ChartShowDateScale = 1;
		ChartShowPriceScale = 0;
		ChartScaleFix11 = 1;
		ChartScaleFix = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(4);
			_blocks_[11].run(4);
		}
	}

	virtual void _beforeExecute_()
	{
		ChartMode = (int)CHART_LINE;
		ChartShowVolumes = (int)CHART_VOLUME_HIDE;
	}
};

// Block 6 (Modify chart colors)
class Block5: public MDL_ChartSetColors<color,color,color,color,color,color,color,color,color,color,color,color,color>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {4};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[4].run(5);
		}
	}

	virtual void _beforeExecute_()
	{
		ChartColorBackground = (color)clrWhite;
		ChartColorForeground = (color)clrBlack;
		ChartColorGrid = (color)clrWhite;
		ChartColorBarUp = (color)clrWhite;
		ChartColorBarDown = (color)clrWhite;
		ChartColorBullCandle = (color)clrWhite;
		ChartColorBearCandle = (color)clrWhite;
		ChartColorDojiCandle = (color)clrWhite;
		ChartColorVolumes = (color)clrWhite;
		ChartColorBid = (color)clrWhite;
		ChartColorAsk = (color)clrWhite;
		ChartColorLast = (color)clrWhite;
		ChartColorStopLevels = (color)clrWhite;
	}
};

// Block 8 (Draw Text)
class Block6: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "8";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "o";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Plot;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		ObjName = (string)v::DIFx;
		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_CENTER;
		ObjColor = (color)clrMediumBlue;
	}
};

// Block 9 (Draw Fibonacci)
class Block7: public MDL_ChartDrawFibonacci<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,bool,bool,bool,double,string,color,ENUM_LINE_STYLE,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "9";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 100;
		ObjTime3.ModeTime = 3;
		ObjTime3.TimeCandleID = 20;
		ObjPrice3.CandleID = 20;
		ObjPrice3.TimeStamp = "";
		// Block input parameters
		ObjRayLeft = true;
		ObjRayRight = true;
		ObjLevels = "0,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,5000,5100,5200,5300,5400,5500,5600,5700,5800,5900,6000,6100,6200,6300,6400,6500,6600,6700,6800,6900,7000,7100,7200,7300,7400,7500,7600,7700,7800,7900,8000,8100,8200,8300,8400,8500,8600,8700,8800,8900,9000,9100,9200,9300,9400,9500,9600,9700,9800,9900,10000";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = c::Graph_level100;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = c::Graph_level0;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Symbol = CurrentSymbol();
		ObjPrice3.Period = CurrentTimeframe();

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(7);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjLevels = "0,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,5000,5100,5200,5300,5400,5500,5600,5700,5800,5900,6000,6100,6200,6300,6400,6500,6600,6700,6800,6900,7000,7100,7200,7300,7400,7500,7600,7700,7800,7900,8000,8100,8200,8300,8400,8500,8600,8700,8800,8900,9000,9100,9200,9300,9400,9500,9600,9700,9800,9900,10000";
		ObjectType = (ENUM_OBJECT)OBJ_FIBO;
		ObjLevelColor = (color)clrDodgerBlue;
		ObjLevelStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
		ObjColor = (color)clrDeepSkyBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 11 (Formula)
class Block8: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_market_point,double>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "11";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIF;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = c::Symbol1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(8);
		}
	}
};

// Block 12 (Draw Text)
class Block9: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "12";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.TimeStamp = "";
		ObjText.Text = "Correlation";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "cor";
		ObjX = 20;
		ObjY = 20;
		ObjFontSize = 20;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{
		ObjectType = (ENUM_OBJECT)OBJ_LABEL;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrMediumBlue;
	}
};

// Block 13 (Custom MQL code)
class Block10: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "13";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {1};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[1].run(10);
		}
	}

	virtual void _beforeExecute_()
	{
		v::DIFx = DoubleToString(v::DIFx,2);
	}
};

// Block 14 (Draw Fibonacci)
class Block11: public MDL_ChartDrawFibonacci<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,bool,bool,bool,double,string,color,ENUM_LINE_STYLE,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "14";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 100;
		ObjTime3.ModeTime = 3;
		ObjTime3.TimeCandleID = 20;
		ObjPrice3.CandleID = 20;
		ObjPrice3.TimeStamp = "";
		// Block input parameters
		ObjRayLeft = true;
		ObjRayRight = true;
		ObjLevels = "-4000,-3900,-3800,-3700,-3600,-3500,-3400,-3300,-3200,-3100,-3000,-2900,-2800,-2700,-2600,-2500,-2400,-2300,-2200,-2100,-2000,-1900,-1800,-1700,-1600,-1500,-1400,-1300,-1200,-1100,-1000,-900,-800,-700,-600,-500,-400,-300,-200,-100";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = c::Graph_level100;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = c::Graph_level0;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Symbol = CurrentSymbol();
		ObjPrice3.Period = CurrentTimeframe();

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[9].run(11);
		}
	}

	virtual void _beforeExecute_()
	{
		/* Inputs, modified into the code must be set here every time */
		ObjLevels = "-4000,-3900,-3800,-3700,-3600,-3500,-3400,-3300,-3200,-3100,-3000,-2900,-2800,-2700,-2600,-2500,-2400,-2300,-2200,-2100,-2000,-1900,-1800,-1700,-1600,-1500,-1400,-1300,-1200,-1100,-1000,-900,-800,-700,-600,-500,-400,-300,-200,-100";
		ObjectType = (ENUM_OBJECT)OBJ_FIBO;
		ObjLevelColor = (color)clrTomato;
		ObjLevelStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
		ObjColor = (color)clrTomato;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
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

bool IsFillingTypeAllowed(string symbol,int fill_type)
{
//--- Obtain the value of the property that describes allowed filling modes
   int filling=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);
//--- Return true, if mode fill_type is allowed
   return((filling & fill_type)==fill_type);
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

string OrderSymbol()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetString(POSITION_SYMBOL);}
	if (type == 3) {return HistoryDealGetString(OrderTicket(),DEAL_SYMBOL);}
	if (type == 4) {return HistoryOrderGetString(OrderTicket(),ORDER_SYMBOL);}

	return OrderGetString(ORDER_SYMBOL);
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

double StrToDouble(string s)
{
	return StringToDouble(s);
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
	StringTrimRight(text);
	StringTrimLeft(text);

	return text;
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

bool TradeSelectByTicket(ulong ticket)
{
	if (LoadPosition(ticket) && OrderType() < 2)
	{
		return true;
	}

	return false;
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

/*<fxdreema:eNrtHGtz4zbur2TSL3dzVU9PW/LOfUjspEnPeTR2drv9olFkOuFGljySvNlcJ//9AJDUy7KzTp12H95ZOzYJgCAIgCAIK+h1e39kPcPo7YdJHLMw50mc7b8JsOkP3tPhk4UQTm9/ylk02X+TAcr+4Oj44Ho4xm+d3n6WLNKQ4RegY8nGPEhvWS4b7f03T7xnbE6t00bNIWrm5tTsNmouUbM2p+a0UfOImr05NWOJmgmNBpFzNidntjFnEbXO5tS8VuZMItfdkJycVgs9wZ77AnqtSifY87axsDiG1GH9BezZK8X3RO03URLeC7Mz0ezQUEwDB3HJMPM0iaibBgbcYYLfTPmNEw+G1dufpzxkmS/+YGMD35aMXyIA9gPOwei/kr0xD+9PB/hF7+3LttHj7CaJiD40hr2eaDBUS//i6uqoPz69OC/wcFJdHHc2D1IlU03O+urv5txcyzmwbtjlyD77lKdBwTFQDSYfFlleHyll2SLK5ZePvd7g9BhoZT1PEAp4zFLstQWjcnYTngU3EQMJ3ICfJZHBaCwV/lfv/fFUFZF0EECSZ34ILCQzhegqBWKKh+wxy9lMjjNLJizyudLT4ySdLaKAiMJXWKJgxmBYoJok6SSrT23OYVcoWAT5Z2EQMdkZA6mgkHDGkFaepBX+kZc8yBdZIUIgkcTJdLr/hhNJkMkkyINyCQgk57kYpc4wkANUmqckB+gRm+ZIzdB1oRZ5MsfvXQeJAcBDwHM1A5DfxyDlKPgKmzBKssjnizyrEubQpvDgKyu+PtEwYVaapIFGHIT3t2myiCdamERJKtn/YTp1XV3fF+IremBBf6C/8GEKSqI9MH57l1flAL5g/waWhKValj8KeYg+sflt7iEMnH20YD69t1iZWqK3qh8mYCiN3szg/7XO4DdnBCVsgBH/nAbzO/+gsMLXsuQuWfJllOSvYMrmzpTXmrLn1CzZdPRv2JSttaZc28jKxbxkKU+EOsF8Lo+uTi8Gfv8a7OCcQhAc8DLIsrPg05jPxI4q9pCtK7O1BWVGpbuIQwbTOgzSr0ShUcbI9N6cpXs3gu21au3W1doytqXWxp9T6xudma71ErVudbCC43Uqb69SeWrzKMqL8zFQLF0xbEGfXkF77W1oryk5PmNZFtyyr0V/DQwTbvdmJdcbqW/ni/HK06nT+QvV11mpvq7U3/5dkOZnoCJFiHJycDX2h6fnR0o5COQihi2RiUlJpvUCBQFGd3yqDoyaOHQ5sutgkSejEIaO6v0FqtKmgqhVEE0eLk6G/Tpep9J7yCdDsK/VAAfZ/TJAtwIwDLJcQSgGTKcCIHawUUWxV3D6c8rrsqny8TaJFmp76yoxv70YXp8d+SenA5I2LFWJMGBZmPK5zHNVuDf1CtQ4DSZsyD6yqM6XW6UU5KwqYyEDrzpFPKsuL4NTXaBj/klkQwoKVqP7ua37NOb5C52fsw3nV8iE5ZdpAnthzssFeS0X6Ig0iZIMHojKz1bls1357FQl+afdpwkLBSbOp497Ic5/b16b/fqzqlH3pcaXE+F2p47+F/rSzkpfKk6yyir7yMthwbU6Mkbpuzues5oBE2jdrwrQwygQcQIyW4IqB9OgV9ipHDq9nrdBdRtQg+Qhfpa7w0UU9YN4ErHnQVmQfiboIPnAV4LWGa34zSacVRu9XTQ1GNgL2mBqMsbt4Fn+R2ANpdOtgW7d9XW24frs0vXRBLKvJfLzGq4rLLhf77aseorN+169lrvKa4lGOhnefGBhXh5oYaQ8XZQHR+q+nsMysUZ3l3rPQYGapx95UCbU8eNcmfnF4S/++Oi3sfp68wHP/EZL3k1Xebecz1rTbmpOGLuOJYw64yM2to2qdyW6tCPqyIPZXK6CrvdEpgQni53CMYkkfTXMxb6zIL1n1VSc4VWR8NM0DWb1MKorQZLZPIlZnL9nQtCKhNvoP4N53lUBOg2AQfBY7W7SP4FpV65uKkwWI/B4kdeZ
bIKMGIh70ox1lbSLaL/otKVksQMnWHUkuEEVnTS7Wm8V9R1j97VOq9IJ816JiJPOWoQmxqT5ruwWc23tvudzZGkiR8artCDKmEgle6TCFDwbW8kduyKJLZK5a7PYNg39W3UJRNP7apMwUJGeaLIHzOfQ4ecyedHGGwpYdgPJ5PnMOox2DESkqA7AuUZKFLJrxP9X3DbqpR84iG+jpqVCcz9J5SZKUcHF1fnRlT88Oh7715eXR1cl4EEc3klnivdt5/2Tiyu/f3Q+FkCupBaVMLBln7EJX8wOo6o3O5SRV7nSAhy6RiwCd4bbRdNNGpV+NmmiCw5P+GTC4va+38l7N50Gckyb9uLmHY8nyUN1Q9hucsndRpChYq1BGjwUavOKMYa9+dFqGzEJiAlnuKemuMkFgW0432kg4q0MRLrbDkSUD18VgRyfHl7sIpBdBLKLQFpur93q7XWEZ1xD15/Z+EtDMr9cQ7Iw4NiZ0s6Unjcl8xUKQciUPt+QrC/XkKDJ3NnRzo6et6M2JcZwk9QCDgPib4smd6UtcXX5ByPzfpRkhWGhzIV6HcPR6PBRLm2RBG5V2Kamt5VgblC5stqOZeh5FTwOmVCJ5dMidF6p4LraK86ax4soOor4XMy4emIUPmLpPk+IvUxK2x4Q0n+ELe9HE14WvGx4OfDqwKsLLxdenk4w8IaQBoIaCGsgsIHQBoIbCG8gguEJivBGtBHDRAwTMUzEMBHDRAwTMUxPjA9viGERO4hhIYaFGBZiWIhhIYblCW7hDTFsxLBpBohhI4aNGDZi2Ihhe2Ju8IYYDmI4iOHQpBHDQQwHMRzEcDwhCXhDjA5idBCjgxgdkhNidBCjgxgdT8gN3hCjixhdxOgiRhcxuiRaxOgiRtcTUoY3xHARw0UMFzFcxHARw6XVQAzXE2sCb4jhIYaHGB5ieIjhIYaHGB4toFpBvaI9pAbNbMcgmdzC2Sqq6RlBjtRhDVVzNH4/PPJHF0N5/qjAveMT4YOV0jXTKrYYiLH56P7xsNwnUWHXjCEglqh/9QmZP3Hr423zwhvTFcf8JomDMOTfaFYGdY/SMrWJPnNJ1KjeNL7XWyLD+OKrtP+9rkobPs0oCPXnCY/b0tmWrHfCuOFSwSjbfumvR7ZSuf0a5YLFL5d2pdufm5lFZ/Dtlm4b5ub3wLUNd5P8K05Wcr2UgvVECnZ4cHg03OVgdwfebz8H+zcceFfp+auddyu30cVhu3IdXbRt8z4aa2WTNGVRgCWyW76aNl/narpbXE3XAb+L6+mXnoYKB7a7n97+/bRhN85Ane/1gtqw1v7WB5dXRBJ9+WsJC1oweN/7z94gWYBoxskoT3l8+w9s/dH855vXCOu39SO2PiGruXwNpaCOYnrv7NfhXig5X6vdnU49xvc6X4Zyh/Tvr1Rue1d+sQv9d6H/rvxiV36xM6Vd+cWu/GJnR7vyi135xauVX5h4OtSohkGjcgaNKhs0KnLQqN5Bo9IHjaogNCqI0Kg2QqMyCY0qJjQqntCojkKjkgqNqis0KrTQqOZCo/ILjSoxNCrK0Kg+Q6NSDY2qNjQq4NColkOjsg6NKjw0KvbQqO5DoxIQjapBNEIlTEIkPEKzJW80CEGvrDvwKIs1TmZwFHytkoPmGLtig5ckFexdtcGrVxuY7q7aoIyzQEg5j2+rKQi8Lw9z/pH5q1Qbic7TBHMKfiwjGvxhNv5ebq9yGbCn6gsq8LlMQnTQFvDpB0WiHXTYj4L4diEfLQMDnv06dNTkMd/hhymTaQ/Txu3M1DW9A//HerfnGD2n85Nrmr/XUGb0s+XPRZkFtzz0QSlTtSN1HMdVDwX5yDMOGuFH/CYN0kcfl3G+ZJAYLylIstpVcKiEsBGnflYGGSCqjq64oSoKP11IJbTUE3aV5k1TdBGTnv6TrhsCGd0vNRjqAbptwMvgukAwVyK0YzwJt7LI4ETA03wRRCC8ZK6mEiel6Cq9FLqTmQgrR4khCQbCuGVx
+NhCBGEa/T4oWjNQbYIEk3qgCh9gP4vzDBWj2EJkIpgIiN7wMYTlm8vgR/o27I7RJ/jZHDRx4pMrbQbCCkR6tsrjbFB8DJYfVvwuefBhO+Hh8rNsQJ63dFhKUg68lPdqADFO5uPkMMlpbxDOXlkWmBNPC2Dp02mDmj+mNZ8hraN8sE2lBz0lj+8rLVgeA/tFFazY+WCOca6er0KgRb2OfAJrsb9V+8TuCH694g0yytmvZ86RRz+JcnA9uB4NiJ2CurlmZHObI/dPjgvv20wTNTlog2njZEL3F5/PCZ5Rf+rqRlF3Uj9kL7GxBLENJixiosGCet7mahbKJ3JukYWn5Z2b9l2LroiW2VHt22BC2K8IJUQxWXO0omMbWqgM0Rb7buto6gfsW5ucCL8C8H31qKhwEBjsPf0f7B+OWA==
:fxdreema>*/