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
#define PROJECT_ID "mt5-2634"
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
input double Balance = 10000.0;
input string Token = "qxvnrf2UvRa0K9USKycA77voz0onKGrssfaQl65FPRx";
input string Greeting = "Trading Signal V1";
input string ServerEND = "Server is not working !!!!";
input double Risk_Percent = 0.5;
input ENUM_TIMEFRAMES Master_TF = PERIOD_H4;
input ENUM_TIMEFRAMES Second_TF = PERIOD_M15;
input ENUM_TIMEFRAMES Mini_TF = PERIOD_M15;
input int MAX_Order_Normal = 3;
input int MAX_Order_Hedge = 1;
input double Martingale_Normal = 2.0;
input int Near_percent = 20;
input double Trailing_Percent = 1.5;
input double TSP_Start = 1.5;
input double TSP_Step = 0.3;
input double TSM_Stop = 0.3;
input double Stop_Loss_Percent = 5.0;
input int MagicStart = 7200; // Magic Number, kind of...
class c
{
		public:
	static double Balance;
	static string Token;
	static string Greeting;
	static string ServerEND;
	static double Risk_Percent;
	static ENUM_TIMEFRAMES Master_TF;
	static ENUM_TIMEFRAMES Second_TF;
	static ENUM_TIMEFRAMES Mini_TF;
	static int MAX_Order_Normal;
	static int MAX_Order_Hedge;
	static double Martingale_Normal;
	static int Near_percent;
	static double Trailing_Percent;
	static double TSP_Start;
	static double TSP_Step;
	static double TSM_Stop;
	static double Stop_Loss_Percent;
	static int MagicStart;
};
double c::Balance;
string c::Token;
string c::Greeting;
string c::ServerEND;
double c::Risk_Percent;
ENUM_TIMEFRAMES c::Master_TF;
ENUM_TIMEFRAMES c::Second_TF;
ENUM_TIMEFRAMES c::Mini_TF;
int c::MAX_Order_Normal;
int c::MAX_Order_Hedge;
double c::Martingale_Normal;
int c::Near_percent;
double c::Trailing_Percent;
double c::TSP_Start;
double c::TSP_Step;
double c::TSM_Stop;
double c::Stop_Loss_Percent;
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
	static int Momentum_Master_TF;
	static int ADX_Master_TF;
	static int DIB_Master_TF;
	static int DIS_Master_TF;
	static int SUMDI_Master_TF;
	static int SUMDI2_Master_TF;
	static int DXMaster_TF;
	static double MA26_Master_TF;
	static double MA12_Master_TF;
	static double ATR26_Master_TF;
	static double MA12_MA26_Master_TF;
	static double EMA27_Master_TF;
	static ENUM_TIMEFRAMES TIMEFRAMES;
	static string Symbols;
	static string Messages;
	static datetime now;
	static double Profit;
	static int MACDV_Second_TF;
	static int ADX_Second_TF;
	static int DIB_Second_TF;
	static int DIS_Second_TF;
	static int SUMDI_Second_TF;
	static int SUMDI2_Second_TF;
	static int DXSecond_TF;
	static double MA26_Second_TF;
	static double MA12_Second_TF;
	static double ATR26_Second_TF;
	static double MA12_MA26_Second_TF;
	static double EMA27_Second_TF;
	static int MACDV_Mini_TF;
	static int ADX_Mini_TF;
	static int DIB_Mini_TF;
	static int DIS_Mini_TF;
	static int SUMDI_Mini_TF;
	static int SUMDI2_Mini_TF;
	static int DXMini_TF;
	static double MA26_Mini_TF;
	static double MA12_Mini_TF;
	static double ATR26_Mini_TF;
	static double MA12_MA26_Mini_TF;
	static double EMA27_Mini_TF;
	static int Counts_ALL;
	static int Counts_Buy;
	static int Counts_Sell;
	static double Near;
	static int countb;
	static int counts;
	static double LOTS2;
	static double LOTB2;
	static double LOTBx;
	static double LOTSx;
	static double lot_hedge_s;
	static double lot_hedge_b;
	static string Trend_Master_TF;
	static string Trend_Second_TF;
	static double Lot_Devide;
	static double TSP_Start;
	static double TSP_Step;
	static double TSM_Stop;
	static double Percent_Cutloss;
	static string Symbols_Cerrent_Buy;
	static string Symbols_Cerrent_Sell;
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
int v::Momentum_Master_TF;
int v::ADX_Master_TF;
int v::DIB_Master_TF;
int v::DIS_Master_TF;
int v::SUMDI_Master_TF;
int v::SUMDI2_Master_TF;
int v::DXMaster_TF;
double v::MA26_Master_TF;
double v::MA12_Master_TF;
double v::ATR26_Master_TF;
double v::MA12_MA26_Master_TF;
double v::EMA27_Master_TF;
ENUM_TIMEFRAMES v::TIMEFRAMES;
string v::Symbols;
string v::Messages;
datetime v::now;
double v::Profit;
int v::MACDV_Second_TF;
int v::ADX_Second_TF;
int v::DIB_Second_TF;
int v::DIS_Second_TF;
int v::SUMDI_Second_TF;
int v::SUMDI2_Second_TF;
int v::DXSecond_TF;
double v::MA26_Second_TF;
double v::MA12_Second_TF;
double v::ATR26_Second_TF;
double v::MA12_MA26_Second_TF;
double v::EMA27_Second_TF;
int v::MACDV_Mini_TF;
int v::ADX_Mini_TF;
int v::DIB_Mini_TF;
int v::DIS_Mini_TF;
int v::SUMDI_Mini_TF;
int v::SUMDI2_Mini_TF;
int v::DXMini_TF;
double v::MA26_Mini_TF;
double v::MA12_Mini_TF;
double v::ATR26_Mini_TF;
double v::MA12_MA26_Mini_TF;
double v::EMA27_Mini_TF;
int v::Counts_ALL;
int v::Counts_Buy;
int v::Counts_Sell;
double v::Near;
int v::countb;
int v::counts;
double v::LOTS2;
double v::LOTB2;
double v::LOTBx;
double v::LOTSx;
double v::lot_hedge_s;
double v::lot_hedge_b;
string v::Trend_Master_TF;
string v::Trend_Second_TF;
double v::Lot_Devide;
double v::TSP_Start;
double v::TSP_Step;
double v::TSM_Stop;
double v::Percent_Cutloss;
string v::Symbols_Cerrent_Buy;
string v::Symbols_Cerrent_Sell;




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
int FXD_BLOCKS_COUNT        = 232;
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
	c::Balance = Balance;
	c::Token = Token;
	c::Greeting = Greeting;
	c::ServerEND = ServerEND;
	c::Risk_Percent = Risk_Percent;
	c::Master_TF = Master_TF;
	c::Second_TF = Second_TF;
	c::Mini_TF = Mini_TF;
	c::MAX_Order_Normal = MAX_Order_Normal;
	c::MAX_Order_Hedge = MAX_Order_Hedge;
	c::Martingale_Normal = Martingale_Normal;
	c::Near_percent = Near_percent;
	c::Trailing_Percent = Trailing_Percent;
	c::TSP_Start = TSP_Start;
	c::TSP_Step = TSP_Step;
	c::TSM_Stop = TSM_Stop;
	c::Stop_Loss_Percent = Stop_Loss_Percent;
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
	v::Momentum_Master_TF = 0;
	v::ADX_Master_TF = 0;
	v::DIB_Master_TF = 0;
	v::DIS_Master_TF = 0;
	v::SUMDI_Master_TF = 0;
	v::SUMDI2_Master_TF = 0;
	v::DXMaster_TF = 0;
	v::MA26_Master_TF = 0.0;
	v::MA12_Master_TF = 0.0;
	v::ATR26_Master_TF = 0.0;
	v::MA12_MA26_Master_TF = 0.0;
	v::EMA27_Master_TF = 0.0;
	v::TIMEFRAMES = 0;
	v::Symbols = "0";
	v::Messages = "0";
	v::now = 0;
	v::Profit = 0.0;
	v::MACDV_Second_TF = 0;
	v::ADX_Second_TF = 0;
	v::DIB_Second_TF = 0;
	v::DIS_Second_TF = 0;
	v::SUMDI_Second_TF = 0;
	v::SUMDI2_Second_TF = 0;
	v::DXSecond_TF = 0;
	v::MA26_Second_TF = 0.0;
	v::MA12_Second_TF = 0.0;
	v::ATR26_Second_TF = 0.0;
	v::MA12_MA26_Second_TF = 0.0;
	v::EMA27_Second_TF = 0.0;
	v::MACDV_Mini_TF = 0;
	v::ADX_Mini_TF = 0;
	v::DIB_Mini_TF = 0;
	v::DIS_Mini_TF = 0;
	v::SUMDI_Mini_TF = 0;
	v::SUMDI2_Mini_TF = 0;
	v::DXMini_TF = 0;
	v::MA26_Mini_TF = 0.0;
	v::MA12_Mini_TF = 0.0;
	v::ATR26_Mini_TF = 0.0;
	v::MA12_MA26_Mini_TF = 0.0;
	v::EMA27_Mini_TF = 0.0;
	v::Counts_ALL = 0;
	v::Counts_Buy = 0;
	v::Counts_Sell = 0;
	v::Near = 0.0;
	v::countb = 0;
	v::counts = 0;
	v::LOTS2 = 0.0;
	v::LOTB2 = 0.0;
	v::LOTBx = 0.0;
	v::LOTSx = 0.0;
	v::lot_hedge_s = 0.0;
	v::lot_hedge_b = 0.0;
	v::Trend_Master_TF = "";
	v::Trend_Second_TF = "";
	v::Lot_Devide = 0.0;
	v::TSP_Start = 0.0;
	v::TSP_Step = 0.0;
	v::TSM_Stop = 0.0;
	v::Percent_Cutloss = 0.0;
	v::Symbols_Cerrent_Buy = "";
	v::Symbols_Cerrent_Sell = "";




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
	ArrayResize(_blocks_, 232);

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
	int blocks_to_run[] = {65};
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
	int blocks_to_run[] = {6,16,26,32,59,68,72,98,132,134,154,155,186,199,223};
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
		
		v::MA12_MA26_Second_TF = formula(compare, lo, ro);
		
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
		
		v::MACDV_Second_TF = formula(compare, lo, ro)*100;
		
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
		
		v::SUMDI_Second_TF = formula(compare, lo, ro);
		
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
		
		v::SUMDI2_Second_TF = formula(compare, lo, ro);
		
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
		
		v::MA12_MA26_Mini_TF = formula(compare, lo, ro);
		
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
		
		v::MACDV_Mini_TF = formula(compare, lo, ro)*100;
		
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
		
		v::SUMDI_Mini_TF = formula(compare, lo, ro);
		
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
		
		v::SUMDI2_Mini_TF = formula(compare, lo, ro);
		
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

// "Draw Arrow" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17>
class MDL_ChartDrawArrow: public BlockCalls
{
	public: /* Input Parameters */
	T1 ObjectPerBar;
	T2 ObjectUpdate;
	T3 ObjName;
	T4 ObjectType;
	T5 ObjArrowCode;
	T6 ObjTime1; virtual _T6_ _ObjTime1_(){return(_T6_)0;}
	T7 ObjPrice1; virtual _T7_ _ObjPrice1_(){return(_T7_)0;}
	T8 ObjAnchor;
	T9 ObjColor;
	T10 ObjStyle;
	T11 ObjWidth;
	T12 ObjBack;
	T13 ObjSelectable;
	T14 ObjSelected;
	T15 ObjHidden;
	T16 ObjZorder;
	T17 ObjChartSubWindow;
	/* Static Parameters */
	int count;
	datetime time0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDrawArrow()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_ARROW_UP;
		ObjArrowCode = (int)58;
		ObjAnchor = (int)ANCHOR_TOP;
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
		string ObjNamePrefix = "fxd_arrow_";
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
					Print(__FUNCTION__,": failed to create arrow object! Error code = ",GetLastError());
				}
		
				if (ObjectType == OBJ_ARROW) ObjectSetInteger(ObjChartID,name,OBJPROP_ARROWCODE,ObjArrowCode);
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,(long)_ObjTime1_());
				ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,(double)_ObjPrice1_());
				ObjectSetInteger(ObjChartID,name,OBJPROP_ANCHOR,ObjAnchor);
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
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
		
		v::LOTBx = formula(compare, lo, ro);
		
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
		
		v::LOTSx = formula(compare, lo, ro);
		
		_callback_(1);
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_35: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_35()
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
		
		v::lot_hedge_s = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_36: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_36()
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
		
		v::lot_hedge_b = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Counter: Pass "n" times" model
template<typename T1,typename T2>
class MDL_PassNtimes: public BlockCalls
{
	public: /* Input Parameters */
	T1 TimesToPass;
	T2 CounterID;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_PassNtimes()
	{
		TimesToPass = (int)3;
		CounterID = (int)1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int passes = Counter(CounterID, "increment");
		
		if (passes < TimesToPass) {_callback_(1);} else {_callback_(0);}
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_37: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_37()
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
		
		v::Near = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_38: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_38()
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
		
		v::Lot_Devide = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_39: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_39()
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
		
		v::Lot_Devide = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_40: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_40()
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
class MDL_Formula_41: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_41()
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_42: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_42()
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
		
		v::TSP_Start = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_43: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_43()
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
		
		v::TSP_Step = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_44: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_44()
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
		
		v::TSM_Stop = formula(compare, lo, ro)/100;
		
		_callback_(1);
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
		
				if (OrderSymbol() == _Symbol)
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
						double bid           = SymbolInfoDouble(_Symbol, SYMBOL_BID);
						double lot_size      = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
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
				
						if (money_loss_amount != money_loss_amount0 || time0 != iTime(_Symbol, 0, 0) || trades_count_changed == true)
						{
							time0              = iTime(_Symbol, 0, 0);
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

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_45: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_45()
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
class MDL_Formula_46: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_46()
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
				if (!LoadPendingOrder(ticket)) {continue;}
			}
			else if (pool == 2) {
				if (!LoadHistoryTrade(ticket,"select_by_ticket")) {continue;}
				if (LoadedType()!=3) {continue;}
			}
		
			if (pool == 0 && OrderCloseTime() > 0) {continue;}
		  	
			int z=1;
		  	if (!(z*+-2+z-1)) {continue;}
		   
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
		int ___outbound_blocks[6] = {11,12,13,14,212,9};
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
			_blocks_[212].run(8);
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
		int ___outbound_blocks[1] = {120};
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
			_blocks_[120].run(15);
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
		int ___outbound_blocks[1] = {121};
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
			_blocks_[121].run(17);
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
		int ___outbound_blocks[1] = {122};
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
			_blocks_[122].run(18);
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
		int ___outbound_blocks[1] = {123};
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
			_blocks_[123].run(19);
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
		int ___outbound_blocks[1] = {124};
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
			_blocks_[124].run(20);
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
		int ___outbound_blocks[1] = {125};
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
			_blocks_[125].run(21);
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
		int ___outbound_blocks[1] = {126};
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
			_blocks_[126].run(22);
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
		int ___outbound_blocks[1] = {127};
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
			_blocks_[127].run(23);
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
		int ___outbound_blocks[1] = {128};
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
			_blocks_[128].run(24);
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
		int ___outbound_blocks[1] = {129};
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
			_blocks_[129].run(25);
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
		int ___outbound_blocks[3] = {61,63,89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[61].run(26);
			_blocks_[63].run(26);
			_blocks_[89].run(26);
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
class Block39: public MDL_ModifyVariables<int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iATR,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iADXWilder,double>
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
		Value4.MAperiod = 27;
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
	virtual double _Value4_() {
		Value4.MAmethod = MODE_EMA;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = c::Master_TF;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Symbol = CurrentSymbol();
		Value5.Period = c::Master_TF;

		return Value5._execute_();
	}

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
		v::EMA27_Master_TF = _Value4_();
		v::ADX_Master_TF = _Value5_();
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
		int ___outbound_blocks[1] = {83};
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
			_blocks_[83].run(44);
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
		int ___outbound_blocks[1] = {91};
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
			_blocks_[91].run(45);
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
		int ___outbound_blocks[1] = {91};
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
			_blocks_[91].run(46);
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
		int ___outbound_blocks[1] = {93};
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
			_blocks_[93].run(48);
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
		int ___outbound_blocks[1] = {93};
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
			_blocks_[93].run(49);
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

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(50);
		}
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

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(53);
		}
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
		int ___outbound_blocks[1] = {213};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[213].run(56);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 32911 (Buy now)
class Block57: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_indicators_iATR,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
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
		StopLossMode = "none";
		TakeProfitMode = "none";
		TakeProfitPercentSL = 150.0;
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = PERIOD_D1;

		return dlStopLoss._execute_();
	}
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
			_blocks_[51].run(57);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::Lot_Devide;
		VolumeRisk = (double)c::Risk_Percent;
		mmMgInitialLots = (double)v::Lot_Devide;
		MyComment = (string)c::Greeting;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 32912 (Sell now)
class Block58: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
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
		StopLossMode = "none";
		TakeProfitMode = "none";
		TakeProfitPercentSL = 150.0;
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
			_blocks_[54].run(58);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::Lot_Devide;
		VolumeRisk = (double)c::Risk_Percent;
		mmMgInitialLots = (double)v::Lot_Devide;
		MyComment = (string)c::Greeting;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 32916 (1)
class Block59: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "32916";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {114,116,118,217};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[114].run(59);
			_blocks_[116].run(59);
			_blocks_[118].run(59);
			_blocks_[217].run(59);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 32938 (ATR&nbsp;)
class Block60: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_candles_candles,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
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
class Block61: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "52265";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {62};
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
			_blocks_[62].run(61);
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
class Block62: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "52266";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {231};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

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
		if (value == 1) {
			_blocks_[231].run(62);
		}
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
class Block63: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_account_AccountCompany,string,int,int,string,MDLIC_account_AccountLeverage,long,int,int,string,MDLIC_account_AccountBalance,double,int,int,string,MDLIC_account_AccountProfit,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "55230";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {60};
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
		Label8 = "NEAR";
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
	virtual double _Value8_() {
		Value8.Value = v::Near;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(63);
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
class Block64: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
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
class Block65: public MDL_Pass
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "55232";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {64,66,67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(65);
			_blocks_[66].run(65);
			_blocks_[67].run(65);
		}
	}
};

// Block 88147 (Modify chart colors)
class Block66: public MDL_ChartSetColors<color,color,color,color,color,color,color,color,color,color,color,color,color>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
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
class Block67: public MDL_ChartSetProperties<int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
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
class Block68: public MDL_Pass
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "88162";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {39,40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[39].run(68);
			_blocks_[40].run(68);
		}
	}
};

// Block 88163 (EMA)
class Block69: public MDL_Formula_23<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "88163";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {70};
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
			_blocks_[70].run(69);
		}
	}
};

// Block 88164 (MACD)
class Block70: public MDL_Formula_24<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
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
class Block71: public MDL_ModifyVariables<int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iATR,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iADXWilder,double>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "88179";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.MAperiod = 12;
		Value2.MAperiod = 26;
		Value3.ATRperiod = 26;
		Value4.MAperiod = 27;
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
	virtual double _Value4_() {
		Value4.MAmethod = MODE_EMA;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = c::Second_TF;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Symbol = CurrentSymbol();
		Value5.Period = c::Second_TF;

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(71);
		}
	}

	virtual void _beforeExecute_()
	{

		v::MA12_Second_TF = _Value1_();
		v::MA26_Second_TF = _Value2_();
		v::ATR26_Second_TF = _Value3_();
		v::EMA27_Second_TF = _Value4_();
		v::ADX_Second_TF = _Value5_();
	}
};

// Block 149354 (Second_TF)
class Block72: public MDL_Pass
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "149354";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {71,79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[71].run(72);
			_blocks_[79].run(72);
		}
	}
};

// Block 149355 (&lt;-50)
class Block73: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "149355";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {74,75};
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
			_blocks_[74].run(73);
			_blocks_[75].run(73);
		}
	}
};

// Block 179167 (&nbsp;x&gt;150)
class Block74: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "179167";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
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
			_blocks_[92].run(74);
		}
	}
};

// Block 179168 (&nbsp;x&gt;-150)
class Block75: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "179168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
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
			_blocks_[92].run(75);
		}
	}
};

// Block 179170 (&nbsp;x&gt;50)
class Block76: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "179170";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {77,78};
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
			_blocks_[77].run(76);
			_blocks_[78].run(76);
		}
	}
};

// Block 179191 (&nbsp;x&gt;150)
class Block77: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "179191";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
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
			_blocks_[94].run(77);
		}
	}
};

// Block 179192 (&nbsp;x&lt;150)
class Block78: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "179192";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
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
			_blocks_[94].run(78);
		}
	}
};

// Block 179195 (DI+ DI-)
class Block79: public MDL_ModifyVariables<int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "179195";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {80,81};
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
			_blocks_[80].run(79);
			_blocks_[81].run(79);
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
class Block80: public MDL_Formula_25<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "179196";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {82};
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
			_blocks_[82].run(80);
		}
	}
};

// Block 179197 (DI+ + DI-)
class Block81: public MDL_Formula_26<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "179197";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {82};
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
			_blocks_[82].run(81);
		}
	}
};

// Block 179198 (DX)
class Block82: public MDL_Formula_27<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
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
class Block83: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "331369";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {112};
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
			_blocks_[112].run(83);
		}
	}
};

// Block 337259 (DXMaster_TF&nbsp;&lt;&nbsp;)
class Block84: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "337259";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
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
			_blocks_[86].run(84);
		}
	}
};

// Block 343134 (Once per bar)
class Block85: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "343134";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {214};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[214].run(85);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 641595 (DXSecond_TF &lt;&nbsp;)
class Block86: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "641595";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {113};
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
			_blocks_[113].run(86);
		}
	}
};

// Block 647489 (No position)
class Block87: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "647489";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(87);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 647490 (No position)
class Block88: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
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
			_blocks_[56].run(88);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 647495 (Master_TF)
class Block89: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_indicators_iADXWilder,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_value_value,double,int,int>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "647495";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
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
		Label6 = "Trend_Master_TF";
		Label7 = "Trend_Second_TF";
		Label8 = "Cutloss";
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
	virtual string _Value6_() {
		Value6.Text = v::Trend_Master_TF;

		return Value6._execute_();
	}
	virtual string _Value7_() {
		Value7.Text = v::Trend_Second_TF;

		return Value7._execute_();
	}
	virtual double _Value8_() {
		Value8.Value = v::Percent_Cutloss;

		return Value8._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[90].run(89);
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
class Block90: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_indicators_iADXWilder,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "647496";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value6.Value = 0.0;
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
	virtual double _Value6_() {return Value6._execute_();}
	virtual string _Value7_() {return Value7._execute_();}
	virtual string _Value8_() {return Value8._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(90);
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
class Block91: public MDL_Pass
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "647497";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(91);
		}
	}
};

// Block 647498 (Pass)
class Block92: public MDL_Pass
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "647498";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(92);
		}
	}
};

// Block 647499 (Pass)
class Block93: public MDL_Pass
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "647499";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(93);
		}
	}
};

// Block 647500 (Pass)
class Block94: public MDL_Pass
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "647500";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(94);
		}
	}
};

// Block 647829 (EMA)
class Block95: public MDL_Formula_28<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "647829";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
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
			_blocks_[96].run(95);
		}
	}
};

// Block 647830 (MACD)
class Block96: public MDL_Formula_29<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
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
class Block97: public MDL_ModifyVariables<int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iATR,double,int,MDLIC_indicators_iMA,double,int,MDLIC_indicators_iADXWilder,double>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "647845";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.MAperiod = 12;
		Value2.MAperiod = 26;
		Value3.ATRperiod = 26;
		Value4.MAperiod = 27;
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
	virtual double _Value4_() {
		Value4.MAmethod = MODE_EMA;
		Value4.AppliedPrice = PRICE_CLOSE;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = c::Mini_TF;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Symbol = CurrentSymbol();
		Value5.Period = c::Mini_TF;

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(97);
		}
	}

	virtual void _beforeExecute_()
	{

		v::MA12_Mini_TF = _Value1_();
		v::MA26_Mini_TF = _Value2_();
		v::ATR26_Mini_TF = _Value3_();
		v::EMA27_Mini_TF = _Value4_();
		v::ADX_Mini_TF = _Value5_();
	}
};

// Block 709020 (Mini_TF)
class Block98: public MDL_Pass
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "709020";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {97,99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(98);
			_blocks_[99].run(98);
		}
	}
};

// Block 738861 (DI+ DI-)
class Block99: public MDL_ModifyVariables<int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iADXWilder,double,int,MDLIC_indicators_iATR,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "738861";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {100,101};
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
			_blocks_[100].run(99);
			_blocks_[101].run(99);
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
class Block100: public MDL_Formula_30<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "738862";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
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
			_blocks_[102].run(100);
		}
	}
};

// Block 738863 (DI+ + DI-)
class Block101: public MDL_Formula_31<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "738863";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
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
			_blocks_[102].run(101);
		}
	}
};

// Block 738864 (DX)
class Block102: public MDL_Formula_32<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
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
class Block103: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_indicators_iADXWilder,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_text_text,string,int,int,string,MDLIC_text_text,string,int,int>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "738865";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value6.Value = 0.0;
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
	virtual double _Value6_() {return Value6._execute_();}
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
class Block104: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "738866";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {105,106};
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
			_blocks_[105].run(104);
			_blocks_[106].run(104);
		}
	}
};

// Block 768678 (&nbsp;x&gt;150)
class Block105: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "768678";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
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
			_blocks_[110].run(105);
		}
	}
};

// Block 768679 (&nbsp;x&gt;-150)
class Block106: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "768679";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
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
			_blocks_[110].run(106);
		}
	}
};

// Block 768681 (&nbsp;x&gt;50)
class Block107: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "768681";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {108,109};
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
			_blocks_[108].run(107);
			_blocks_[109].run(107);
		}
	}
};

// Block 768702 (&nbsp;x&gt;150)
class Block108: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "768702";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
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
			_blocks_[111].run(108);
		}
	}
};

// Block 768703 (&nbsp;x&lt;150)
class Block109: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "768703";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
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
			_blocks_[111].run(109);
		}
	}
};

// Block 1237009 (Pass)
class Block110: public MDL_Pass
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "1237009";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(110);
		}
	}
};

// Block 1237011 (Pass)
class Block111: public MDL_Pass
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "1237011";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {84};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(111);
		}
	}
};

// Block 1237012 (DXMini_TF &lt;&nbsp;)
class Block112: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "1237012";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {200,202,88};
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
			_blocks_[88].run(112);
			_blocks_[200].run(112);
			_blocks_[202].run(112);
		}
	}
};

// Block 1547238 (DXMini_TF &lt;&nbsp;)
class Block113: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "1547238";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {204,206,87};
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
			_blocks_[87].run(113);
			_blocks_[204].run(113);
			_blocks_[206].run(113);
		}
	}
};

// Block 1547239 (Count ALL)
class Block114: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "1547239";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[115].run(114);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrGray;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1547240 (N)
class Block115: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_1,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
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
class Block116: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "1547243";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(116);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrMagenta;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1547244 (N)
class Block117: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_2,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
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
class Block118: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "1547245";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		SymbolMode = "all";
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

		BucketID = (color)clrRed;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 1547246 (N)
class Block119: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_3,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
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
class Block120: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
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
class Block121: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
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
class Block122: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
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
class Block123: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
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
class Block124: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
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
class Block125: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
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
class Block126: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
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
class Block127: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
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
class Block128: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
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
class Block129: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
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

// Block 75460951 (Draw Arrow)
class Block130: public MDL_ChartDrawArrow<bool,bool,string,ENUM_OBJECT,int,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "75460951";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.iOHLC = "iLow";
		ObjPrice1.ModeCandleFindBy = "TEL_Chat_ID";
		ObjPrice1.TimeStamp = "";
		// Block input parameters
		ObjWidth = 5;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_ARROW_UP;
		ObjAnchor = (int)ANCHOR_TOP;
		ObjColor = (color)clrAqua;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 75460952 (Draw Arrow)
class Block131: public MDL_ChartDrawArrow<bool,bool,string,ENUM_OBJECT,int,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "75460952";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.iOHLC = "iHigh";
		ObjPrice1.ModeCandleFindBy = "TEL_Chat_ID";
		ObjPrice1.TimeStamp = "";
		// Block input parameters
		ObjWidth = 5;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_ARROW_DOWN;
		ObjAnchor = (int)ANCHOR_BOTTOM;
		ObjColor = (color)clrOrangeRed;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 378721119 (If trade)
class Block132: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "378721119";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {146};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[146].run(132);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 378721120 (For each Trade)
class Block133: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "378721120";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {148};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[148].run(133);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 378721122 (If trade)
class Block134: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "378721122";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {147};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[147].run(134);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 378721123 (For each Trade)
class Block135: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "378721123";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {149};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[149].run(135);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 378721154 (Once per bar)
class Block136: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "378721154";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {139};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(136);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 379031392 (Buy now)
class Block137: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "379031392";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
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
		if (value == 1) {
			_blocks_[141].run(137);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTBx;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 379031393 (Sell now)
class Block138: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "379031393";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {143};
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
		if (value == 1) {
			_blocks_[143].run(138);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTSx;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 379031394 (Formula)
class Block139: public MDL_Formula_33<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "379031394";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
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
		Ro.Value = c::Martingale_Normal;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(139);
		}
	}
};

// Block 379031395 (Formula)
class Block140: public MDL_Formula_34<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "379031395";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
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
		Ro.Value = c::Martingale_Normal;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(140);
		}
	}
};

// Block 379031396 (Bucket of Trades)
class Block141: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "379031396";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {142};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[142].run(141);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrOrange;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031397 (Modify Variables)
class Block142: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_4,double,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "379031397";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrOrange;

		return Value1._execute_();
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::countb = _Value1_();
		v::Symbols_Cerrent_Buy = _Value2_();
	}
};

// Block 379031398 (Bucket of Trades)
class Block143: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "379031398";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {144};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[144].run(143);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrYellow;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031399 (Modify Variables)
class Block144: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_5,double,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "379031399";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Attribute = 0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrYellow;

		return Value1._execute_();
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::counts = _Value1_();
		v::Symbols_Cerrent_Sell = _Value2_();
	}
};

// Block 379031403 (Once per bar)
class Block145: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block145() {
		__block_number = 145;
		__block_user_number = "379031403";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(145);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 379031406 (Check trades count)
class Block146: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block146() {
		__block_number = 146;
		__block_user_number = "379031406";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {133};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Compare = "<";
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[133].run(146);
		}
	}

	virtual void _beforeExecute_()
	{

		CompareCount = (int)c::MAX_Order_Normal;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031407 (Check trades count)
class Block147: public MDL_CheckTradesCount<string,int,string,string,string,string,string>
{

	public: /* Constructor */
	Block147() {
		__block_number = 147;
		__block_user_number = "379031407";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		Compare = "<";
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(147);
		}
	}

	virtual void _beforeExecute_()
	{

		CompareCount = (int)c::MAX_Order_Normal;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031428 (Modify Variables)
class Block148: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block148() {
		__block_number = 148;
		__block_user_number = "379031428";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {152};
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
			_blocks_[152].run(148);
		}
	}

	virtual void _beforeExecute_()
	{

		v::LOTB2 = _Value1_();
	}
};

// Block 379031429 (Modify Variables)
class Block149: public MDL_ModifyVariables<int,MDLIC_inloop_OrderVolume,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block149() {
		__block_number = 149;
		__block_user_number = "379031429";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {153};
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
			_blocks_[153].run(149);
		}
	}

	virtual void _beforeExecute_()
	{

		v::LOTS2 = _Value1_();
	}
};

// Block 379031458 (No trade nearby)
class Block150: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block150() {
		__block_number = 150;
		__block_user_number = "379031458";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {136};
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
			_blocks_[136].run(150);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near;
	}
};

// Block 379031495 (No trade nearby)
class Block151: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block151() {
		__block_number = 151;
		__block_user_number = "379031495";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {145};
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
			_blocks_[145].run(151);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near;
	}
};

// Block 379031497 (Condition)
class Block152: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block152() {
		__block_number = 152;
		__block_user_number = "379031497";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {150};
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
			_blocks_[150].run(152);
		}
	}
};

// Block 379031498 (Condition)
class Block153: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block153() {
		__block_number = 153;
		__block_user_number = "379031498";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {151};
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
			_blocks_[151].run(153);
		}
	}
};

// Block 379031500 (Bucket of Trades)
class Block154: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block154() {
		__block_number = 154;
		__block_user_number = "379031500";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {211};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[211].run(154);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrOrange;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031504 (Bucket of Trades)
class Block155: public MDL_BucketSelectOpened<color,string,string,string,string,string>
{

	public: /* Constructor */
	Block155() {
		__block_number = 155;
		__block_user_number = "379031504";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {210};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[210].run(155);
		}
	}

	virtual void _beforeExecute_()
	{

		BucketID = (color)clrYellow;
		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031506 (Sell now)
class Block156: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block156() {
		__block_number = 156;
		__block_user_number = "379031506";
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
		MyComment = "Hedge";
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
		VolumeSize = (double)v::lot_hedge_s;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 379031509 (Buy now)
class Block157: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block157() {
		__block_number = 157;
		__block_user_number = "379031509";
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
		MyComment = "Hedge";
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
		VolumeSize = (double)v::lot_hedge_b;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 379031532 (For each Trade)
class Block158: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block158() {
		__block_number = 158;
		__block_user_number = "379031532";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {168};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "buys";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[168].run(158);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031534 (check type)
class Block159: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block159() {
		__block_number = 159;
		__block_user_number = "379031534";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {160};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[160].run(159);
		}
	}
};

// Block 379031535 (Formula)
class Block160: public MDL_Formula_35<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block160() {
		__block_number = 160;
		__block_user_number = "379031535";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {156};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::lot_hedge_s;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Counts_Buy;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[156].run(160);
		}
	}
};

// Block 379031536 (For each Trade)
class Block161: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block161() {
		__block_number = 161;
		__block_user_number = "379031536";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {169};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
		BuysOrSells = "sells";
		LoopLimit = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[169].run(161);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 379031538 (check type)
class Block162: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block162() {
		__block_number = 162;
		__block_user_number = "379031538";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {163};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CheckBuyOrSell = "sell";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[163].run(162);
		}
	}
};

// Block 379031539 (Formula)
class Block163: public MDL_Formula_36<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block163() {
		__block_number = 163;
		__block_user_number = "379031539";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {157};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::lot_hedge_b;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::counts;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[157].run(163);
		}
	}
};

// Block 379031542 (Counter: Pass \"n\" times)
class Block164: public MDL_PassNtimes<int,int>
{

	public: /* Constructor */
	Block164() {
		__block_number = 164;
		__block_user_number = "379031542";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {158};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[158].run(164);
		}
	}

	virtual void _beforeExecute_()
	{

		TimesToPass = (int)c::MAX_Order_Hedge;
	}
};

// Block 379031543 (Counter: Pass \"n\" times)
class Block165: public MDL_PassNtimes<int,int>
{

	public: /* Constructor */
	Block165() {
		__block_number = 165;
		__block_user_number = "379031543";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {161};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		CounterID = 2;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[161].run(165);
		}
	}

	virtual void _beforeExecute_()
	{

		TimesToPass = (int)c::MAX_Order_Hedge;
	}
};

// Block 379031544 (Counter: Reset)
class Block166: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block166() {
		__block_number = 166;
		__block_user_number = "379031544";

		// Block input parameters
		ResetThisID = "2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 379031545 (Counter: Reset)
class Block167: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block167() {
		__block_number = 167;
		__block_user_number = "379031545";

	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 379031546 (once per trade/order)
class Block168: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block168() {
		__block_number = 168;
		__block_user_number = "379031546";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {159};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[159].run(168);
		}
	}
};

// Block 379031547 (once per trade/order)
class Block169: public MDL_LoopOncePer<bool>
{

	public: /* Constructor */
	Block169() {
		__block_number = 169;
		__block_user_number = "379031547";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {162};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		AllowOldOrders = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[162].run(169);
		}
	}
};

// Block 379341888 (No trade nearby)
class Block170: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block170() {
		__block_number = 170;
		__block_user_number = "379341888";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {164,166};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
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
			_blocks_[164].run(170);
			_blocks_[166].run(170);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near;
	}
};

// Block 379341925 (No trade nearby)
class Block171: public MDL_NoNearbyRunning<string,string,string,string,string,MDLIC_value_time,datetime,MDLIC_value_time,datetime,string,MDLIC_prices_prices,double,string,double,double,int>
{

	public: /* Constructor */
	Block171() {
		__block_number = 171;
		__block_user_number = "379341925";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {165,167};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1";
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
			_blocks_[165].run(171);
			_blocks_[167].run(171);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		RangePips = (double)v::Near;
	}
};

// Block 379341927 (Condition)
class Block172: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block172() {
		__block_number = 172;
		__block_user_number = "379341927";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {170};
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
			_blocks_[170].run(172);
		}
	}
};

// Block 379341928 (Condition)
class Block173: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block173() {
		__block_number = 173;
		__block_user_number = "379341928";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {171};
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
			_blocks_[171].run(173);
		}
	}
};

// Block 379341939 (ADX)
class Block174: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block174() {
		__block_number = 174;
		__block_user_number = "379341939";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {175,177,179};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ADX_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[175].run(174);
			_blocks_[177].run(174);
			_blocks_[179].run(174);
		}
	}
};

// Block 379341940 (DI-)
class Block175: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block175() {
		__block_number = 175;
		__block_user_number = "379341940";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {176};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIS_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[176].run(175);
		}
	}
};

// Block 379341941 (Strong Up Trend)
class Block176: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block176() {
		__block_number = 176;
		__block_user_number = "379341941";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Strong Up Trend";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Master_TF = _Value1_();
	}
};

// Block 379341942 (DI+)
class Block177: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block177() {
		__block_number = 177;
		__block_user_number = "379341942";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {176};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[176].run(177);
		}
	}
};

// Block 379341943 (Up Trend Slow Down)
class Block178: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block178() {
		__block_number = 178;
		__block_user_number = "379341943";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Up Trend Slow Down";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Master_TF = _Value1_();
	}
};

// Block 379341944 (DI-)
class Block179: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block179() {
		__block_number = 179;
		__block_user_number = "379341944";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {178};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIS_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[178].run(179);
		}
	}
};

// Block 379341945 (ADX)
class Block180: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block180() {
		__block_number = 180;
		__block_user_number = "379341945";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {181,183,185};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ADX_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[181].run(180);
			_blocks_[183].run(180);
			_blocks_[185].run(180);
		}
	}
};

// Block 379341946 (DI+)
class Block181: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block181() {
		__block_number = 181;
		__block_user_number = "379341946";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {182};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Master_TF;

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

// Block 379341947 (Strong Down Trend)
class Block182: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block182() {
		__block_number = 182;
		__block_user_number = "379341947";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Strong Down Trend";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Master_TF = _Value1_();
	}
};

// Block 379341948 (DI-)
class Block183: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block183() {
		__block_number = 183;
		__block_user_number = "379341948";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {182};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIS_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[182].run(183);
		}
	}
};

// Block 379341949 (Down Trend Slow Down)
class Block184: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block184() {
		__block_number = 184;
		__block_user_number = "379341949";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Down Trend Slow Down";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Master_TF = _Value1_();
	}
};

// Block 379341950 (DI+)
class Block185: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block185() {
		__block_number = 185;
		__block_user_number = "379341950";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {184};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Master_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[184].run(185);
		}
	}
};

// Block 379341951 (Pass)
class Block186: public MDL_Pass
{

	public: /* Constructor */
	Block186() {
		__block_number = 186;
		__block_user_number = "379341951";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {174,180};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[174].run(186);
			_blocks_[180].run(186);
		}
	}
};

// Block 379341952 (ADX)
class Block187: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block187() {
		__block_number = 187;
		__block_user_number = "379341952";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {188,190,192};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ADX_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[188].run(187);
			_blocks_[190].run(187);
			_blocks_[192].run(187);
		}
	}
};

// Block 379341953 (DI-)
class Block188: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block188() {
		__block_number = 188;
		__block_user_number = "379341953";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {189};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIS_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[189].run(188);
		}
	}
};

// Block 379341954 (Strong Up Trend)
class Block189: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block189() {
		__block_number = 189;
		__block_user_number = "379341954";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Strong Up Trend";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Second_TF = _Value1_();
	}
};

// Block 379341955 (DI+)
class Block190: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block190() {
		__block_number = 190;
		__block_user_number = "379341955";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {189};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[189].run(190);
		}
	}
};

// Block 379341956 (Up Trend Slow Down)
class Block191: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block191() {
		__block_number = 191;
		__block_user_number = "379341956";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Up Trend Slow Down";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Second_TF = _Value1_();
	}
};

// Block 379341957 (DI-)
class Block192: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block192() {
		__block_number = 192;
		__block_user_number = "379341957";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {191};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIS_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[191].run(192);
		}
	}
};

// Block 379341958 (ADX)
class Block193: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block193() {
		__block_number = 193;
		__block_user_number = "379341958";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {194,196,198};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ADX_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[194].run(193);
			_blocks_[196].run(193);
			_blocks_[198].run(193);
		}
	}
};

// Block 379341959 (DI+)
class Block194: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block194() {
		__block_number = 194;
		__block_user_number = "379341959";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {195};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[195].run(194);
		}
	}
};

// Block 379341960 (Strong Down Trend)
class Block195: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block195() {
		__block_number = 195;
		__block_user_number = "379341960";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Strong Down Trend";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Second_TF = _Value1_();
	}
};

// Block 379341961 (DI-)
class Block196: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block196() {
		__block_number = 196;
		__block_user_number = "379341961";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {195};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 35.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIS_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[195].run(196);
		}
	}
};

// Block 379341962 (Down Trend Slow Down)
class Block197: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block197() {
		__block_number = 197;
		__block_user_number = "379341962";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Text = "Down Trend Slow Down";
	}

	public: /* Custom methods */
	virtual string _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Trend_Second_TF = _Value1_();
	}
};

// Block 379341963 (DI+)
class Block198: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block198() {
		__block_number = 198;
		__block_user_number = "379341963";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {197};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 15.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::DIB_Second_TF;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[197].run(198);
		}
	}
};

// Block 379341964 (Pass)
class Block199: public MDL_Pass
{

	public: /* Constructor */
	Block199() {
		__block_number = 199;
		__block_user_number = "379341964";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {187,193};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[187].run(199);
			_blocks_[193].run(199);
		}
	}
};

// Block 379341965 (Trend_Master_TF)
class Block200: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block200() {
		__block_number = 200;
		__block_user_number = "379341965";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {201};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Strong Up Trend";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Master_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[201].run(200);
		}
	}
};

// Block 379341985 (Trend_Second_TF)
class Block201: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block201() {
		__block_number = 201;
		__block_user_number = "379341985";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Strong Up Trend";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Second_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(201);
		}
	}
};

// Block 379341986 (Trend_Master_TF)
class Block202: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block202() {
		__block_number = 202;
		__block_user_number = "379341986";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {203};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Up Trend Slow Down";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Master_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[203].run(202);
		}
	}
};

// Block 379342006 (Trend_Second_TF)
class Block203: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block203() {
		__block_number = 203;
		__block_user_number = "379342006";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Up Trend Slow Down";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Second_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(203);
		}
	}
};

// Block 379342007 (Trend_Master_TF)
class Block204: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block204() {
		__block_number = 204;
		__block_user_number = "379342007";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {205};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Strong Down Trend";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Master_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[205].run(204);
		}
	}
};

// Block 379342027 (Trend_Second_TF)
class Block205: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block205() {
		__block_number = 205;
		__block_user_number = "379342027";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Strong Down Trend";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Second_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(205);
		}
	}
};

// Block 379342028 (Trend_Master_TF)
class Block206: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block206() {
		__block_number = 206;
		__block_user_number = "379342028";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {207};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Down Trend Slow Down";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Master_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[207].run(206);
		}
	}
};

// Block 379342048 (Trend_Second_TF)
class Block207: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block207() {
		__block_number = 207;
		__block_user_number = "379342048";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "Down Trend Slow Down";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Trend_Second_TF;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(207);
		}
	}
};

// Block 379342049 (Condition)
class Block208: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block208() {
		__block_number = 208;
		__block_user_number = "379342049";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {172};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::countb;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::MAX_Order_Normal;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[172].run(208);
		}
	}
};

// Block 379342050 (Condition)
class Block209: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block209() {
		__block_number = 209;
		__block_user_number = "379342050";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {173};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::counts;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::MAX_Order_Normal;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[173].run(209);
		}
	}
};

// Block 379342051 (Modify Variables)
class Block210: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_6,double,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block210() {
		__block_number = 210;
		__block_user_number = "379342051";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {230};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrYellow;

		return Value1._execute_();
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[230].run(210);
		}
	}

	virtual void _beforeExecute_()
	{

		v::lot_hedge_b = _Value1_();
		v::Symbols_Cerrent_Sell = _Value2_();
	}
};

// Block 379342052 (Modify Variables)
class Block211: public MDL_ModifyVariables<int,MDLIC_bucket_bucket_7,double,int,MDLIC_inloop_OrderSymbol,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block211() {
		__block_number = 211;
		__block_user_number = "379342052";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {229};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Attribute = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.BucketID = clrOrange;

		return Value1._execute_();
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[229].run(211);
		}
	}

	virtual void _beforeExecute_()
	{

		v::lot_hedge_s = _Value1_();
		v::Symbols_Cerrent_Buy = _Value2_();
	}
};

// Block 379342053 (NEAR)
class Block212: public MDL_Formula_37<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block212() {
		__block_number = 212;
		__block_user_number = "379342053";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {215};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::ATR_Daily;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Near_percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[215].run(212);
		}
	}
};

// Block 379342059 (Formula)
class Block213: public MDL_Formula_38<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block213() {
		__block_number = 213;
		__block_user_number = "379342059";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {57};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 100000.0;
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[57].run(213);
		}
	}
};

// Block 379342060 (Formula)
class Block214: public MDL_Formula_39<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block214() {
		__block_number = 214;
		__block_user_number = "379342060";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {58};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 100000.0;
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[58].run(214);
		}
	}
};

// Block 379342061 (Near_percent)
class Block215: public MDL_Formula_40<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block215() {
		__block_number = 215;
		__block_user_number = "379342061";


		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Near;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 379343480 (4)
class Block216: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block216() {
		__block_number = 216;
		__block_user_number = "379343480";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {218};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1,2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[218].run(216);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::Profit;
	}
};

// Block 379343482 (2)
class Block217: public MDL_Formula_41<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block217() {
		__block_number = 217;
		__block_user_number = "379343482";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {222};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Trailing_Percent;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[222].run(217);
		}
	}
};

// Block 379343488 (Formula)
class Block218: public MDL_Formula_42<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block218() {
		__block_number = 218;
		__block_user_number = "379343488";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {219};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::TSP_Start;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[219].run(218);
		}
	}
};

// Block 379343489 (Formula)
class Block219: public MDL_Formula_43<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block219() {
		__block_number = 219;
		__block_user_number = "379343489";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {220};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::TSP_Step;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[220].run(219);
		}
	}
};

// Block 379343490 (Formula)
class Block220: public MDL_Formula_44<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block220() {
		__block_number = 220;
		__block_user_number = "379343490";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {221};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::TSM_Stop;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[221].run(220);
		}
	}
};

// Block 379343491 (8)
class Block221: public MDL_TrailingMoneyLoss<string,string,string,string,string,string,double,double,MDLIC_value_value,double,string,double,double,string,double,double,MDLIC_value_value,double,ulong,color>
{

	public: /* Constructor */
	Block221() {
		__block_number = 221;
		__block_user_number = "379343491";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {227,228};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dtmMoneyAmount.Value = 20.0;
		ftStart.Value = 0.0;
		// Block input parameters
		GroupMode = "all";
		TrailingStartMode = "money";
	}

	public: /* Custom methods */
	virtual double _dtmMoneyAmount_() {return dtmMoneyAmount._execute_();}
	virtual double _ftStart_() {return ftStart._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[227].run(221);
			_blocks_[228].run(221);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		tmFixedMoney = (double)v::TSM_Stop;
		tmStepFixedMoney = (double)v::TSP_Step;
		tStartFixedMoney = (double)v::TSP_Start;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 379343492 (3)
class Block222: public MDL_Formula_45<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block222() {
		__block_number = 222;
		__block_user_number = "379343492";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {216};
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
			_blocks_[216].run(222);
		}
	}
};

// Block 379343493 (If trade)
class Block223: public MDL_IfOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block223() {
		__block_number = 223;
		__block_user_number = "379343493";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {226};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1,2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[226].run(223);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 379343494 (Close trades)
class Block224: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block224() {
		__block_number = 224;
		__block_user_number = "379343494";
		_beforeExecuteEnabled = true;
		// Block input parameters
		GroupMode = "all";
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

// Block 379343495 (Check profit (unrealized))
class Block225: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block225() {
		__block_number = 225;
		__block_user_number = "379343495";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {224};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		Group = "1,2";
		Compare = "<";
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
		ProfitAmount = (double)v::Percent_Cutloss;
	}
};

// Block 379343496 (Formula)
class Block226: public MDL_Formula_46<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block226() {
		__block_number = 226;
		__block_user_number = "379343496";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {225};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "*";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::Balance;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = c::Stop_Loss_Percent;

		double value = (double)Ro._execute_();
		value = value*-1; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[225].run(226);
		}
	}
};

// Block 379343497 (Counter: Reset)
class Block227: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block227() {
		__block_number = 227;
		__block_user_number = "379343497";

		// Block input parameters
		ResetThisID = "2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 379343498 (Counter: Reset)
class Block228: public MDL_CounterReset<string>
{

	public: /* Constructor */
	Block228() {
		__block_number = 228;
		__block_user_number = "379343498";

	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 379343499 (Condition)
class Block229: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_inloop_OrderSymbol,string,int>
{

	public: /* Constructor */
	Block229() {
		__block_number = 229;
		__block_user_number = "379343499";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {208};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Symbols_Cerrent_Buy;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[208].run(229);
		}
	}
};

// Block 379343500 (Condition)
class Block230: public MDL_Condition<MDLIC_text_text,string,string,MDLIC_inloop_OrderSymbol,string,int>
{

	public: /* Constructor */
	Block230() {
		__block_number = 230;
		__block_user_number = "379343500";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {209};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {
		Lo.Text = v::Symbols_Cerrent_Sell;

		return Lo._execute_();
	}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[209].run(230);
		}
	}
};

// Block 379343501 (Comment (ugly))
class Block231: public MDL_CommentAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block231() {
		__block_number = 231;
		__block_user_number = "379343501";


		// IC input parameters
		CommentValue3.Value = 0.0;
		CommentValue4.Value = 0.0;
		CommentValue5.Value = 0.0;
		CommentValue6.Value = 0.0;
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
		CommentTitle = "";
		CommentLabel1 = "Symbols_Cerrent_Buy";
		CommentLabel2 = "Symbols_Cerrent_Sell";
	}

	public: /* Custom methods */
	virtual string _CommentValue1_() {
		CommentValue1.Text = v::Symbols_Cerrent_Buy;

		return CommentValue1._execute_();
	}
	virtual string _CommentValue2_() {
		CommentValue2.Text = v::Symbols_Cerrent_Sell;

		return CommentValue2._execute_();
	}
	virtual double _CommentValue3_() {return CommentValue3._execute_();}
	virtual double _CommentValue4_() {return CommentValue4._execute_();}
	virtual double _CommentValue5_() {return CommentValue5._execute_();}
	virtual double _CommentValue6_() {return CommentValue6._execute_();}
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

bool IsOrderTypeStop() {
   if (LoadedType()==2) {
      if (
         OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP
         ||
         OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_STOP
      ) {return(true);}
   }
   if (LoadedType()==4) {
      if (
      HistoryOrderGetInteger(OrderTicket(),ORDER_TYPE)==ORDER_TYPE_BUY_STOP
      ||
      HistoryOrderGetInteger(OrderTicket(),ORDER_TYPE)==ORDER_TYPE_SELL_STOP
      ) {return(true);}
   }
   return(false);
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

bool LoopedResume()
{
	long ticket = attrTicketInLoop();
	int type    = attrTypeInLoop();

	if (ticket > 0 && ticket != OrderTicket())
	{
		     if (type == 1) return LoadPosition(ticket);
		else if (type == 2) return LoadPendingOrder(ticket);
		else if (type == 3) return LoadHistoryOrder((int)ticket, "select_by_ticket");
	}

	return false;
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

long attrTicketInLoop(long ticket = 0)
{
	static long t;

	if (ticket > 0) {t = ticket;}

	return t;
}

long attrTicketParent(long ticket)
{
	long retval = 0;

	if (PositionSelectByTicket(ticket))
	{
		//-- check if trade is added to volume
		string comment = PositionGetString(POSITION_COMMENT);
		int p_pos      = StringFind(comment, "[p=");
		
		if (p_pos >= 0)
		{
			string p_tag = StringSubstr(comment,p_pos);
			p_tag        = StringSubstr(p_tag,0,StringFind(p_tag,"]")+1);
			retval       = StringToInteger(StringSubstr(p_tag,3,-1));
		}

		if (retval == 0)
		{
			long positionID = PositionGetInteger(POSITION_IDENTIFIER);

			if (HistorySelectByPosition(positionID))
			{
				int total = HistoryDealsTotal();
				
				if (total > 0)
				{
					retval = (long)HistoryDealGetTicket(0);
				}
			}
		}
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
