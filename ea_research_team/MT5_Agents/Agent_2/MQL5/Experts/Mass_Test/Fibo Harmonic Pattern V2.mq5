//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2022, fxDreema  (//
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
#define PROJECT_ID "mt4-3904"
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
input double ZZ_Depth = 20.0;input double ZZ_Deviation = 0.0;input double ZZ_Backstep = 0.0;input double Lot_Divided = 1000000.0;input double Buffer_Pending = 10.0;input int Gartley_group_order = 1;input int Butterfly_group_order = 2;input int Crab_group_order = 3;input int Bat_group_order = 4;input int ABCD_group_order = 5;input double Profit_Percent = 1.0;input int MagicStart = 123456; // Magic Number, kind of...
class c
{
		public:
	static double ZZ_Depth;
	static double ZZ_Deviation;
	static double ZZ_Backstep;
	static double Lot_Divided;
	static double Buffer_Pending;
	static int Gartley_group_order;
	static int Butterfly_group_order;
	static int Crab_group_order;
	static int Bat_group_order;
	static int ABCD_group_order;
	static double Profit_Percent;
	static int MagicStart;
};
double c::ZZ_Depth;
double c::ZZ_Deviation;
double c::ZZ_Backstep;
double c::Lot_Divided;
double c::Buffer_Pending;
int c::Gartley_group_order;
int c::Butterfly_group_order;
int c::Crab_group_order;
int c::Bat_group_order;
int c::ABCD_group_order;
double c::Profit_Percent;
int c::MagicStart;


//--
// Variables (Global Variables)
class v
{
		public:
	static double X;
	static double A;
	static double B1;
	static double C;
	static double XA;
	static double AB1;
	static double BC1;
	static int Xbars;
	static int Abars;
	static int Bbars;
	static int Cbars;
	static double Entry_Buy_Crab;
	static double Entry_Sell_Crab;
	static string Pattern;
	static double SL_Level_Gartley;
	static double risk;
	static double TP1;
	static double TP2;
	static double TP_Level_Gartley;
	static bool Gartley;
	static bool Butterfly;
	static bool Crab;
	static bool Bat;
	static double TP_Level_Butterfly;
	static double TP_Level_Crab;
	static double TP_Level_Bat;
	static double Entry_Buy_Gartley;
	static double Entry_Buy_Butterfly1;
	static double Entry_Buy_Butterfly2;
	static double Entry_Buy_Bat;
	static double Entry_Sell_Gartley;
	static double Entry_Sell_Butterfly1;
	static double Entry_Sell_Butterfly2;
	static double Entry_Sell_Bat;
	static double SL_Level_Crab;
	static double SL_Level_Butterfly1;
	static double SL_Level_Bat;
	static double SL_Level_Butterfly2;
	static double Xgartley;
	static double Agartley;
	static double Bgartley;
	static double Cgartley;
	static double Xbutterfly;
	static double Abutterfly;
	static double Bbutterfly;
	static double Cbutterfly;
	static double Xcrab;
	static double Acrab;
	static double Bcrab;
	static double Ccrab;
	static double Xbat;
	static double Abat;
	static double Bbat;
	static double Cbat;
	static double B2;
	static double AB2;
	static double BC2;
	static double B;
	static bool ABCD;
	static double Entry_Buy_ABCD1;
	static double Entry_Sell_ABCD1;
	static double SL_Level_ABCD;
	static double Entry_Buy_ABCD2;
	static double Entry_Sell_ABCD2;
	static double TP_Level_ABCD;
	static double Cabcd;
	static double LOTT;
	static double PercentX;
};
double v::X;
double v::A;
double v::B1;
double v::C;
double v::XA;
double v::AB1;
double v::BC1;
int v::Xbars;
int v::Abars;
int v::Bbars;
int v::Cbars;
double v::Entry_Buy_Crab;
double v::Entry_Sell_Crab;
string v::Pattern;
double v::SL_Level_Gartley;
double v::risk;
double v::TP1;
double v::TP2;
double v::TP_Level_Gartley;
bool v::Gartley;
bool v::Butterfly;
bool v::Crab;
bool v::Bat;
double v::TP_Level_Butterfly;
double v::TP_Level_Crab;
double v::TP_Level_Bat;
double v::Entry_Buy_Gartley;
double v::Entry_Buy_Butterfly1;
double v::Entry_Buy_Butterfly2;
double v::Entry_Buy_Bat;
double v::Entry_Sell_Gartley;
double v::Entry_Sell_Butterfly1;
double v::Entry_Sell_Butterfly2;
double v::Entry_Sell_Bat;
double v::SL_Level_Crab;
double v::SL_Level_Butterfly1;
double v::SL_Level_Bat;
double v::SL_Level_Butterfly2;
double v::Xgartley;
double v::Agartley;
double v::Bgartley;
double v::Cgartley;
double v::Xbutterfly;
double v::Abutterfly;
double v::Bbutterfly;
double v::Cbutterfly;
double v::Xcrab;
double v::Acrab;
double v::Bcrab;
double v::Ccrab;
double v::Xbat;
double v::Abat;
double v::Bbat;
double v::Cbat;
double v::B2;
double v::AB2;
double v::BC2;
double v::B;
bool v::ABCD;
double v::Entry_Buy_ABCD1;
double v::Entry_Sell_ABCD1;
double v::SL_Level_ABCD;
double v::Entry_Buy_ABCD2;
double v::Entry_Sell_ABCD2;
double v::TP_Level_ABCD;
double v::Cabcd;
double v::LOTT;
double v::PercentX;




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
	c::ZZ_Depth = ZZ_Depth;
	c::ZZ_Deviation = ZZ_Deviation;
	c::ZZ_Backstep = ZZ_Backstep;
	c::Lot_Divided = Lot_Divided;
	c::Buffer_Pending = Buffer_Pending;
	c::Gartley_group_order = Gartley_group_order;
	c::Butterfly_group_order = Butterfly_group_order;
	c::Crab_group_order = Crab_group_order;
	c::Bat_group_order = Bat_group_order;
	c::ABCD_group_order = ABCD_group_order;
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

	v::X = 0.0;
	v::A = 0.0;
	v::B1 = 0.0;
	v::C = 0.0;
	v::XA = 0.0;
	v::AB1 = 0.0;
	v::BC1 = 0.0;
	v::Xbars = 0;
	v::Abars = 0;
	v::Bbars = 0;
	v::Cbars = 0;
	v::Entry_Buy_Crab = 0.0;
	v::Entry_Sell_Crab = 0.0;
	v::Pattern = "";
	v::SL_Level_Gartley = 0.0;
	v::risk = 0.0;
	v::TP1 = 0.0;
	v::TP2 = 0.0;
	v::TP_Level_Gartley = 0.0;
	v::Gartley = false;
	v::Butterfly = false;
	v::Crab = false;
	v::Bat = false;
	v::TP_Level_Butterfly = 0.0;
	v::TP_Level_Crab = 0.0;
	v::TP_Level_Bat = 0.0;
	v::Entry_Buy_Gartley = 0.0;
	v::Entry_Buy_Butterfly1 = 0.0;
	v::Entry_Buy_Butterfly2 = 0.0;
	v::Entry_Buy_Bat = 0.0;
	v::Entry_Sell_Gartley = 0.0;
	v::Entry_Sell_Butterfly1 = 0.0;
	v::Entry_Sell_Butterfly2 = 0.0;
	v::Entry_Sell_Bat = 0.0;
	v::SL_Level_Crab = 0.0;
	v::SL_Level_Butterfly1 = 0.0;
	v::SL_Level_Bat = 0.0;
	v::SL_Level_Butterfly2 = 0.0;
	v::Xgartley = 0.0;
	v::Agartley = 0.0;
	v::Bgartley = 0.0;
	v::Cgartley = 0.0;
	v::Xbutterfly = 0.0;
	v::Abutterfly = 0.0;
	v::Bbutterfly = 0.0;
	v::Cbutterfly = 0.0;
	v::Xcrab = 0.0;
	v::Acrab = 0.0;
	v::Bcrab = 0.0;
	v::Ccrab = 0.0;
	v::Xbat = 0.0;
	v::Abat = 0.0;
	v::Bbat = 0.0;
	v::Cbat = 0.0;
	v::B2 = 0.0;
	v::AB2 = 0.0;
	v::BC2 = 0.0;
	v::B = 0.0;
	v::ABCD = false;
	v::Entry_Buy_ABCD1 = 0.0;
	v::Entry_Sell_ABCD1 = 0.0;
	v::SL_Level_ABCD = 0.0;
	v::Entry_Buy_ABCD2 = 0.0;
	v::Entry_Sell_ABCD2 = 0.0;
	v::TP_Level_ABCD = 0.0;
	v::Cabcd = 0.0;
	v::LOTT = 0.0;
	v::PercentX = 0.0;




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
	int disabled_blocks_list[] = {123,124,218,219};
	for (int l = 0; l < ArraySize(disabled_blocks_list); l++) {
		_blocks_[disabled_blocks_list[l]].__disabled = true;
	}

	//-- run blocks
	int blocks_to_run[] = {141};
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
	int blocks_to_run[] = {5,218,221,224};
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

	//-- run blocks
	int blocks_to_run[] = {123};
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
		
		v::Entry_Buy_Gartley = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Draw Shape" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename _T8_,typename T9,typename _T9_,typename T10,typename _T10_,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27>
class MDL_ChartDrawShape: public BlockCalls
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
	T11 ObjX;
	T12 ObjY;
	T13 ObjFill;
	T14 ObjXsize;
	T15 ObjYsize;
	T16 ObjBorderType;
	T17 ObjBgColor;
	T18 ObjCorner;
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
	MDL_ChartDrawShape()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;
		ObjX = (int)10;
		ObjY = (int)10;
		ObjFill = (bool)false;
		ObjXsize = (int)100;
		ObjYsize = (int)100;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrSkyBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
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
		string ObjNamePrefix = "fxd_shape_";
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
					Print(__FUNCTION__,": failed to create shape object! Error code = ",GetLastError());
				}
		
				double p1=0, p2=0, p3=0;
				datetime t1=0, t2=0, t3=0;
		
				switch(ObjectType)
				{
					case OBJ_RECTANGLE_LABEL : {break;}
					case OBJ_RECTANGLE       : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_TRIANGLE        : {t1=1; p1=1; t2=1; p2=1; t3=1; p3=1; break;}
					case OBJ_ELLIPSE         : {t1=1; p1=1; t2=1; p2=1; t3=1; p3=1; break;}
				}
		
				if (t1 == 1) {t1 = _ObjTime1_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,t1);}
				if (t2 == 1) {t2 = _ObjTime2_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,1,t2);}
				if (t3 == 1) {t3 = _ObjTime3_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,2,t3);}
				if (p1 == 1) {p1 = _ObjPrice1_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,p1);}
				if (p2 == 1) {p2 = _ObjPrice2_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,1,p2);}
				if (p3 == 1) {p3 = _ObjPrice3_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,2,p3);}
		
				if (ObjectType==OBJ_RECTANGLE_LABEL) {
					ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,ObjX);
					ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);
					ObjectSetInteger(ObjChartID,name,OBJPROP_XSIZE,ObjXsize);
					ObjectSetInteger(ObjChartID,name,OBJPROP_YSIZE,ObjYsize);
					ObjectSetInteger(ObjChartID,name,OBJPROP_BGCOLOR,ObjBgColor);
					ObjectSetInteger(ObjChartID,name,OBJPROP_BORDER_TYPE,ObjBorderType);
					ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);
				}
				else
				{
					ObjectSetInteger(ObjChartID,name,OBJPROP_FILL,ObjFill);
				}
		
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
		
		v::Entry_Sell_Gartley = formula(compare, lo, ro);
		
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
		
		v::Xbars = formula(compare, lo, ro);
		
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
		
		v::Bbars = formula(compare, lo, ro);
		
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
		
		v::Abars = formula(compare, lo, ro);
		
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
		
		v::Cbars = formula(compare, lo, ro);
		
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
		
		v::Entry_Sell_Crab = formula(compare, lo, ro);
		
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
		
		v::Entry_Buy_Crab = formula(compare, lo, ro);
		
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
		
		v::Entry_Sell_Butterfly1 = formula(compare, lo, ro);
		
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
		
		v::Xbars = formula(compare, lo, ro);
		
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
		
		v::Bbars = formula(compare, lo, ro);
		
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
		
		v::Abars = formula(compare, lo, ro);
		
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
		
		v::Cbars = formula(compare, lo, ro);
		
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
		
		v::Entry_Buy_Butterfly2 = formula(compare, lo, ro);
		
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
		
		v::SL_Level_Crab = formula(compare, lo, ro);
		
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
		
		v::SL_Level_Crab = formula(compare, lo, ro);
		
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
		
		v::SL_Level_Butterfly2 = formula(compare, lo, ro);
		
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
		
		v::SL_Level_Butterfly2 = formula(compare, lo, ro);
		
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
		
		v::Entry_Buy_Bat = formula(compare, lo, ro);
		
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
		
		v::Entry_Sell_Bat = formula(compare, lo, ro);
		
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
		
		v::Entry_Sell_Butterfly2 = formula(compare, lo, ro);
		
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
		
		v::Entry_Buy_Butterfly1 = formula(compare, lo, ro);
		
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
		
		v::TP1 = formula(compare, lo, ro);
		
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
		
		v::TP2 = formula(compare, lo, ro);
		
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
		
		v::TP1 = formula(compare, lo, ro);
		
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
		
		v::TP2 = formula(compare, lo, ro);
		
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
		
		v::TP1 = formula(compare, lo, ro);
		
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
		
		v::TP2 = formula(compare, lo, ro);
		
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
		
		v::TP1 = formula(compare, lo, ro);
		
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
		
		v::TP1 = formula(compare, lo, ro);
		
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
		
		v::TP2 = formula(compare, lo, ro);
		
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
		
		v::TP1 = formula(compare, lo, ro);
		
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
		
		v::TP2 = formula(compare, lo, ro);
		
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
		
		v::TP2 = formula(compare, lo, ro);
		
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
		
		v::LOTT = formula(compare, lo, ro);
		
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
		
		v::PercentX = formula(compare, lo, ro)/100;
		
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
		
		v::PercentX = formula(compare, lo, ro)/100;
		
		_callback_(1);
	}
};


//------------------------------------------------------------------------------------------------------------------------

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

// "Accelerator Oscillator" model
class MDLIC_indicators_iAC
{
	public: /* Input Parameters */
	string Symbol;
	ENUM_TIMEFRAMES Period;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_indicators_iAC()
	{
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		return iAC(Symbol, Period, Shift + FXD_MORE_SHIFT);
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

// Block 1 (Bearish)
class Block0: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "1";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ModeZigZag = 1;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.ZigZagDeviation = c::ZZ_Deviation;
		Lo.ZigZagBackstep = c::ZZ_Backstep;
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
			_blocks_[9].run(0);
		}
	}
};

// Block 2 (Bullish)
class Block1: public MDL_Condition<MDLIC_iCustom_ZigZag,double,string,MDLIC_candles_candles,double,int>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "2";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {30};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ModeZigZag = 2;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.ZigZagDepth = c::ZZ_Depth;
		Lo.ZigZagDeviation = c::ZZ_Deviation;
		Lo.ZigZagBackstep = c::ZZ_Backstep;
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
			_blocks_[30].run(1);
		}
	}
};

// Block 3 (Formula)
class Block2: public MDL_Formula_1<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "3";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xgartley;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*21.4/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[98].run(2);
		}
	}
};

// Block 4 (Draw Shape)
class Block3: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "4";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {26};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "CrabBullish1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xcrab;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Acrab;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bcrab;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[26].run(3);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrAqua;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 5 (Draw Shape)
class Block4: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		ObjTime3.TimeCandleID = 0;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "GartleyBullish2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bgartley;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Cgartley;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Buy_Gartley;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[94].run(4);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 6 (Modify Variables)
class Block5: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "6";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {0,1};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.0;
		Value2.Value = 0.0;
		Value3.Value = 0.0;
		Value4.Value = 0.0;
		Value5.Value = 0.0;
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
			_blocks_[0].run(5);
			_blocks_[1].run(5);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbars = _Value1_();
		v::Abars = _Value2_();
		v::Bbars = _Value3_();
		v::Cbars = _Value4_();
	}
};

// Block 7 (Draw Shape)
class Block6: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "7";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "GartleyBear1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xgartley;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Agartley;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bgartley;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(6);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 8 (Formula)
class Block7: public MDL_Formula_2<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "8";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {96};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xgartley;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*21.4/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(7);
		}
	}
};

// Block 9 (Draw Shape)
class Block8: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "9";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {93};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "GartleyBear2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bgartley;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Cgartley;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Sell_Gartley;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[93].run(8);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 20 (Modify Variables)
class Block9: public MDL_ModifyVariables<int,MDLIC_iCustom_ZigZag,double,int,MDLIC_iCustom_ZigZag,double,int,MDLIC_iCustom_ZigZag,double,int,MDLIC_iCustom_ZigZag,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "20";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {10};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.ModeZigZag = 1;
		Value1.ZigZagReverseID = 2;
		Value2.ModeZigZag = 1;
		Value2.ZigZagReverseID = 1;
		Value3.ModeZigZag = 2;
		Value3.ZigZagReverseID = 1;
		Value4.ModeZigZag = 2;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ZigZagDepth = c::ZZ_Depth;
		Value1.ZigZagDeviation = c::ZZ_Deviation;
		Value1.ZigZagBackstep = c::ZZ_Backstep;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.ZigZagDepth = c::ZZ_Depth;
		Value2.ZigZagDeviation = c::ZZ_Deviation;
		Value2.ZigZagBackstep = c::ZZ_Backstep;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.ZigZagDepth = c::ZZ_Depth;
		Value3.ZigZagDeviation = c::ZZ_Deviation;
		Value3.ZigZagBackstep = c::ZZ_Backstep;
		Value3.Symbol = CurrentSymbol();
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.ZigZagDepth = c::ZZ_Depth;
		Value4.ZigZagDeviation = c::ZZ_Deviation;
		Value4.ZigZagBackstep = c::ZZ_Backstep;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[10].run(9);
		}
	}

	virtual void _beforeExecute_()
	{

		v::X = _Value1_();
		v::B1 = _Value2_();
		v::A = _Value3_();
		v::C = _Value4_();
	}
};

// Block 21 (Condition)
class Block10: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "21";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {12};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::X;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::B1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[12].run(10);
		}
	}
};

// Block 22 (Condition)
class Block11: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "22";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::C;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::A;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(11);
		}
	}
};

// Block 23 (Condition)
class Block12: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "23";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {11};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::B1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::C;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[11].run(12);
		}
	}
};

// Block 26 (Butterfly)
class Block13: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "26";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {14,15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Xbars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::X;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[14].run(13);
		}
		else if (value == 1) {
			_blocks_[15].run(13);
		}
	}
};

// Block 27 (Formula)
class Block14: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "27";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(14);
		}
	}
};

// Block 28 (Condition)
class Block15: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "28";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {16,17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Bbars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::B1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[16].run(15);
		}
		else if (value == 1) {
			_blocks_[17].run(15);
		}
	}
};

// Block 29 (Formula)
class Block16: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "29";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Bbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(16);
		}
	}
};

// Block 30 (Condition)
class Block17: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "30";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {18,19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Abars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::A;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[18].run(17);
		}
		else if (value == 1) {
			_blocks_[19].run(17);
		}
	}
};

// Block 31 (Formula)
class Block18: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "31";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Abars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(18);
		}
	}
};

// Block 32 (Condition)
class Block19: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "32";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {20,55};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Cbars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::C;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[20].run(19);
		}
		else if (value == 1) {
			_blocks_[55].run(19);
		}
	}
};

// Block 33 (Formula)
class Block20: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "33";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Cbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[19].run(20);
		}
	}
};

// Block 34 (Draw Shape)
class Block21: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "34";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "CrabBear1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xcrab;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Acrab;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bcrab;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[23].run(21);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrAqua;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 35 (Formula)
class Block22: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "35";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xcrab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(22);
		}
	}
};

// Block 36 (Draw Shape)
class Block23: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "36";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "CrabBear2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bcrab;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Ccrab;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Sell_Crab;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(23);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrAqua;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrAqua;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 37 (Draw Shape)
class Block24: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "37";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {4};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "GartleyBullish1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xgartley;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Agartley;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bgartley;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[4].run(24);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 38 (Formula)
class Block25: public MDL_Formula_8<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "38";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::X;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[45].run(25);
		}
	}
};

// Block 39 (Draw Shape)
class Block26: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "39";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {101};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "CrabBullish2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bcrab;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Ccrab;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Buy_Crab;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[101].run(26);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrAqua;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 51 (Draw Shape)
class Block27: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "51";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "ButterflyBear1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xbutterfly;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Abutterfly;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bbutterfly;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(27);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 52 (Formula)
class Block28: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "52";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {95};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*27/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[95].run(28);
		}
	}
};

// Block 53 (Draw Shape)
class Block29: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "53";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {91};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "ButterflyBear2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bbutterfly;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Cbutterfly;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Sell_Butterfly1;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[91].run(29);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 54 (Modify Variables)
class Block30: public MDL_ModifyVariables<int,MDLIC_iCustom_ZigZag,double,int,MDLIC_iCustom_ZigZag,double,int,MDLIC_iCustom_ZigZag,double,int,MDLIC_iCustom_ZigZag,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "54";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {31};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.ModeZigZag = 2;
		Value1.ZigZagReverseID = 2;
		Value2.ModeZigZag = 2;
		Value2.ZigZagReverseID = 1;
		Value3.ModeZigZag = 1;
		Value3.ZigZagReverseID = 1;
		Value4.ModeZigZag = 1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.ZigZagDepth = c::ZZ_Depth;
		Value1.ZigZagDeviation = c::ZZ_Deviation;
		Value1.ZigZagBackstep = c::ZZ_Backstep;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.ZigZagDepth = c::ZZ_Depth;
		Value2.ZigZagDeviation = c::ZZ_Deviation;
		Value2.ZigZagBackstep = c::ZZ_Backstep;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.ZigZagDepth = c::ZZ_Depth;
		Value3.ZigZagDeviation = c::ZZ_Deviation;
		Value3.ZigZagBackstep = c::ZZ_Backstep;
		Value3.Symbol = CurrentSymbol();
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.ZigZagDepth = c::ZZ_Depth;
		Value4.ZigZagDeviation = c::ZZ_Deviation;
		Value4.ZigZagBackstep = c::ZZ_Backstep;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[31].run(30);
		}
	}

	virtual void _beforeExecute_()
	{

		v::X = _Value1_();
		v::B1 = _Value2_();
		v::A = _Value3_();
		v::C = _Value4_();
	}
};

// Block 55 (Condition)
class Block31: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "55";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {33};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::A;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::C;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[33].run(31);
		}
	}
};

// Block 56 (Condition)
class Block32: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "56";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::B1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::X;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[34].run(32);
		}
	}
};

// Block 57 (Condition)
class Block33: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "57";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::C;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::B1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[32].run(33);
		}
	}
};

// Block 58 (Crab)
class Block34: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "58";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {35,36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Xbars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::X;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[35].run(34);
		}
		else if (value == 1) {
			_blocks_[36].run(34);
		}
	}
};

// Block 59 (Formula)
class Block35: public MDL_Formula_10<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "59";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[34].run(35);
		}
	}
};

// Block 60 (Condition)
class Block36: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "60";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {37,38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iLow";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Bbars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::B1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[37].run(36);
		}
		else if (value == 1) {
			_blocks_[38].run(36);
		}
	}
};

// Block 61 (Formula)
class Block37: public MDL_Formula_11<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "61";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {36};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Bbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[36].run(37);
		}
	}
};

// Block 62 (Condition)
class Block38: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "62";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {39,40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Abars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::A;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[39].run(38);
		}
		else if (value == 1) {
			_blocks_[40].run(38);
		}
	}
};

// Block 63 (Formula)
class Block39: public MDL_Formula_12<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "63";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {38};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Abars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(39);
		}
	}
};

// Block 64 (Condition)
class Block40: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "64";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {41,61};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.iOHLC = "iHigh";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.CandleID = v::Cbars;
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::C;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[41].run(40);
		}
		else if (value == 1) {
			_blocks_[61].run(40);
		}
	}
};

// Block 65 (Formula)
class Block41: public MDL_Formula_13<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "65";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Cbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[40].run(41);
		}
	}
};

// Block 66 (Draw Shape)
class Block42: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "66";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {44};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "ButterflyBullish1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xbutterfly;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Abutterfly;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bbutterfly;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[44].run(42);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 67 (Formula)
class Block43: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "67";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {48};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[48].run(43);
		}
	}
};

// Block 68 (Draw Shape)
class Block44: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "68";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		ObjTime3.TimeCandleID = 0;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "ButterflyBullish2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bbutterfly;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Cbutterfly;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Buy_Butterfly1;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(44);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlue;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 70 (Formula)
class Block45: public MDL_Formula_15<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "70";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xcrab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[110].run(45);
		}
	}
};

// Block 71 (Formula)
class Block46: public MDL_Formula_16<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "71";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {143};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xcrab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[143].run(46);
		}
	}
};

// Block 83 (Formula)
class Block47: public MDL_Formula_17<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "83";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {153};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[153].run(47);
		}
	}
};

// Block 84 (Formula)
class Block48: public MDL_Formula_18<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "84";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {152};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[152].run(48);
		}
	}
};

// Block 91 (Draw Shape)
class Block49: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "91";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "BatBullish2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xbat;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Abat;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bbat;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[51].run(49);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrMagenta;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 92 (Formula)
class Block50: public MDL_Formula_19<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "92";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbat;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*11.5/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(50);
		}
	}
};

// Block 93 (Draw Shape)
class Block51: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "93";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "BatBullish2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bbat;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Cbat;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Buy_Bat;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(51);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrMagenta;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 94 (Draw Shape)
class Block52: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "94";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "BatBear1";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Xbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Xbat;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Abars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::Abat;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {
		ObjTime3.TimeCandleID = v::Bbars;

		return ObjTime3._execute_();
	}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Bbat;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[54].run(52);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrBlue;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrMagenta;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 95 (Formula)
class Block53: public MDL_Formula_20<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "95";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbat;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*11.5/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[97].run(53);
		}
	}
};

// Block 96 (Draw Shape)
class Block54: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "96";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {103};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime2.ModeTime = 3;
		ObjTime3.ModeTime = 3;
		// Block input parameters
		ObjectUpdate = false;
		ObjName = "BatBear2";
		ObjFill = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {
		ObjTime1.TimeCandleID = v::Bbars;

		return ObjTime1._execute_();
	}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Bbat;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {
		ObjTime2.TimeCandleID = v::Cbars;

		return ObjTime2._execute_();
	}
	virtual double _ObjPrice2_() {
		ObjPrice2.Value = v::C;

		return ObjPrice2._execute_();
	}
	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}
	virtual double _ObjPrice3_() {
		ObjPrice3.Value = v::Entry_Sell_Bat;

		return ObjPrice3._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[103].run(54);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TRIANGLE;
		ObjBorderType = (int)BORDER_FLAT;
		ObjBgColor = (color)clrMagenta;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrMagenta;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 110 (Modify Variables)
class Block55: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "110";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {154};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.iOHLC = "iHigh";
		Value2.iOHLC = "iHigh";
		Value3.iOHLC = "iLow";
		Value4.iOHLC = "iLow";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CandleID = v::Xbars;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CandleID = v::Bbars;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CandleID = v::Cbars;
		Value3.Symbol = CurrentSymbol();
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CandleID = v::Abars;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = c::Lot_Divided;

		double value = (double)Value5._execute_();
		value = value/2; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[154].run(55);
		}
	}

	virtual void _beforeExecute_()
	{

		v::X = _Value1_();
		v::B1 = _Value2_();
		v::C = _Value3_();
		v::A = _Value4_();
		v::risk = _Value5_();
	}
};

// Block 111 (Gartley)
class Block56: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "111";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {58};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[58].run(56);
		}
	}
};

// Block 112 (Custom MQL code)
class Block57: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "112";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {113,114,115,116};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(57);
			_blocks_[114].run(57);
			_blocks_[115].run(57);
			_blocks_[116].run(57);
		}
	}

	virtual void _beforeExecute_()
	{

		v::XA = fabs(v::A-v::X);
v::AB1 = fabs(v::A-v::B1);
v::BC1 = fabs(v::C-v::B1);

v::AB2 = fabs(v::A-v::B2);
v::BC2 = fabs(v::C-v::B2);
	}
};

// Block 113 (Condition)
class Block58: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "113";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {59};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[59].run(58);
		}
	}
};

// Block 114 (Condition)
class Block59: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "114";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {60};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(59);
		}
	}
};

// Block 115 (Condition)
class Block60: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "115";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(60);
		}
	}
};

// Block 116 (Modify Variables)
class Block61: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "116";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.iOHLC = "iLow";
		Value2.iOHLC = "iLow";
		Value3.iOHLC = "iHigh";
		Value4.iOHLC = "iHigh";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CandleID = v::Xbars;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.CandleID = v::Bbars;
		Value2.Symbol = CurrentSymbol();
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.CandleID = v::Cbars;
		Value3.Symbol = CurrentSymbol();
		Value3.Period = CurrentTimeframe();

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.CandleID = v::Abars;
		Value4.Symbol = CurrentSymbol();
		Value4.Period = CurrentTimeframe();

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = c::Lot_Divided;

		double value = (double)Value5._execute_();
		value = value/2; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[155].run(61);
		}
	}

	virtual void _beforeExecute_()
	{

		v::X = _Value1_();
		v::B1 = _Value2_();
		v::C = _Value3_();
		v::A = _Value4_();
		v::risk = _Value5_();
	}
};

// Block 117 (Gartley)
class Block62: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "117";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[63].run(62);
		}
	}
};

// Block 118 (Condition)
class Block63: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "118";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(63);
		}
	}
};

// Block 119 (Condition)
class Block64: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "119";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {65};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[65].run(64);
		}
	}
};

// Block 120 (Condition)
class Block65: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "120";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(65);
		}
	}
};

// Block 121 (Butterfly)
class Block66: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "121";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XA;

		double value = (double)Lo._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[67].run(66);
		}
	}
};

// Block 122 (Condition)
class Block67: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "122";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {68};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XA;

		double value = (double)Lo._execute_();
		value = value*88.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(67);
		}
	}
};

// Block 123 (Condition)
class Block68: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "123";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(68);
		}
	}
};

// Block 124 (Condition)
class Block69: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "124";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {136};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[136].run(69);
		}
	}
};

// Block 125 (Butterfly)
class Block70: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "125";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[71].run(70);
		}
	}
};

// Block 126 (Condition)
class Block71: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "126";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {72};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*88.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[72].run(71);
		}
	}
};

// Block 127 (Condition)
class Block72: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "127";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(72);
		}
	}
};

// Block 128 (Condition)
class Block73: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "128";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {138};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[138].run(73);
		}
	}
};

// Block 129 (Crab)
class Block74: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "129";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(74);
		}
	}
};

// Block 130 (Condition)
class Block75: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "130";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(75);
		}
	}
};

// Block 131 (Condition)
class Block76: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "131";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(76);
		}
	}
};

// Block 132 (Condition)
class Block77: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "132";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(77);
		}
	}
};

// Block 133 (Crab)
class Block78: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "133";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[79].run(78);
		}
	}
};

// Block 134 (Condition)
class Block79: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "134";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(79);
		}
	}
};

// Block 135 (Condition)
class Block80: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "135";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[81].run(80);
		}
	}
};

// Block 136 (Condition)
class Block81: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "136";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[140].run(81);
		}
	}
};

// Block 137 (Custom MQL code)
class Block82: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "137";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {117,118,119,120};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(82);
			_blocks_[118].run(82);
			_blocks_[119].run(82);
			_blocks_[120].run(82);
		}
	}

	virtual void _beforeExecute_()
	{

		v::XA = fabs(v::A-v::X);
v::AB1 = fabs(v::A-v::B1);
v::BC1 = fabs(v::C-v::B1);

v::AB2 = fabs(v::A-v::B2);
v::BC2 = fabs(v::C-v::B2);
	}
};

// Block 138 (Bat)
class Block83: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "138";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {84};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[84].run(83);
		}
	}
};

// Block 139 (Condition)
class Block84: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "139";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*50/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(84);
		}
	}
};

// Block 140 (Condition)
class Block85: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "140";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {86};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[86].run(85);
		}
	}
};

// Block 141 (Condition)
class Block86: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "141";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {133};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[133].run(86);
		}
	}
};

// Block 142 (Bat)
class Block87: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "142";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(87);
		}
	}
};

// Block 143 (Condition)
class Block88: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "143";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {89};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*50/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[89].run(88);
		}
	}
};

// Block 144 (Condition)
class Block89: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "144";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[90].run(89);
		}
	}
};

// Block 145 (Condition)
class Block90: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "145";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {139};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[139].run(90);
		}
	}
};

// Block 146 (Draw Text)
class Block91: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "146";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Butterfly Bear";
		// Block input parameters
		ObjName = "ButterflyBearText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Sell_Butterfly1;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 147 (Draw Text)
class Block92: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "147";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Butterfly Bullish";
		// Block input parameters
		ObjName = "ButterflyBullishText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Buy_Butterfly1;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 148 (Draw Text)
class Block93: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "148";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Gartley Bear";
		// Block input parameters
		ObjName = "GartleyBearText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Sell_Gartley;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 149 (Draw Text)
class Block94: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "149";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Gartley Bullish";
		// Block input parameters
		ObjName = "GartleyBullishText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Buy_Gartley;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 150 (Formula)
class Block95: public MDL_Formula_21<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "150";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {47};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[47].run(95);
		}
	}
};

// Block 151 (Modify Variables)
class Block96: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "151";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {104};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value2.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::Xgartley;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[104].run(96);
		}
	}

	virtual void _beforeExecute_()
	{

		v::SL_Level_Gartley = _Value1_();
	}
};

// Block 152 (Modify Variables)
class Block97: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "152";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {106};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::Xbat;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[106].run(97);
		}
	}

	virtual void _beforeExecute_()
	{

		v::SL_Level_Bat = _Value1_();
	}
};

// Block 153 (Modify Variables)
class Block98: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "153";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {108};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::Xgartley;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[108].run(98);
		}
	}

	virtual void _beforeExecute_()
	{

		v::SL_Level_Gartley = _Value1_();
	}
};

// Block 154 (Formula)
class Block99: public MDL_Formula_22<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "154";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {43};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*27/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[43].run(99);
		}
	}
};

// Block 155 (Draw Text)
class Block100: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "155";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Crab Bear";
		// Block input parameters
		ObjName = "CrabBearText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Sell_Crab;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 156 (Draw Text)
class Block101: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "156";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Crab Bullish";
		// Block input parameters
		ObjName = "CrabBullishText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Buy_Crab;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 157 (Draw Text)
class Block102: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "157";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Bat Bullish";
		// Block input parameters
		ObjName = "BatBullishText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Buy_Bat;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 158 (Draw Text)
class Block103: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "158";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjText.Text = "Bat Bear";
		// Block input parameters
		ObjName = "BatBearText";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::Entry_Sell_Bat;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
	}
};

// Block 159 (Formula)
class Block104: public MDL_Formula_23<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "159";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xgartley;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[105].run(104);
		}
	}
};

// Block 160 (Formula)
class Block105: public MDL_Formula_24<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "160";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {128};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xgartley;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[128].run(105);
		}
	}
};

// Block 168 (Formula)
class Block106: public MDL_Formula_25<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbat;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(106);
		}
	}
};

// Block 169 (Formula)
class Block107: public MDL_Formula_26<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "169";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {127};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbat;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*95/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[127].run(107);
		}
	}
};

// Block 171 (Formula)
class Block108: public MDL_Formula_27<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "171";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {109};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xgartley;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[109].run(108);
		}
	}
};

// Block 172 (Formula)
class Block109: public MDL_Formula_28<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "172";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {129};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xgartley;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[129].run(109);
		}
	}
};

// Block 176 (Formula)
class Block110: public MDL_Formula_29<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "176";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xcrab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(110);
		}
	}
};

// Block 178 (Formula)
class Block111: public MDL_Formula_30<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "178";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {112};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbat;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[112].run(111);
		}
	}
};

// Block 179 (Formula)
class Block112: public MDL_Formula_31<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "179";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {132};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbat;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*95/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[132].run(112);
		}
	}
};

// Block 232 (Crab)
class Block113: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "232";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {161,74};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Crab;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[74].run(113);
			_blocks_[161].run(113);
		}
	}
};

// Block 233 (Bat)
class Block114: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "233";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {156,83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Bat;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[83].run(114);
			_blocks_[156].run(114);
		}
	}
};

// Block 234 (Butterfly)
class Block115: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "234";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {166,66};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Butterfly;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[66].run(115);
			_blocks_[166].run(115);
		}
	}
};

// Block 235 (Gartley)
class Block116: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "235";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {171,56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Gartley;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[56].run(116);
			_blocks_[171].run(116);
		}
	}
};

// Block 236 (Gartley)
class Block117: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "236";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {176,62};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Gartley;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[62].run(117);
			_blocks_[176].run(117);
		}
	}
};

// Block 237 (Butterfly)
class Block118: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "237";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {181,70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Butterfly;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[70].run(118);
			_blocks_[181].run(118);
		}
	}
};

// Block 238 (Crab)
class Block119: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "238";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {186,78};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Crab;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[78].run(119);
			_blocks_[186].run(119);
		}
	}
};

// Block 239 (Bat)
class Block120: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "239";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {191,87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::Bat;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(120);
			_blocks_[191].run(120);
		}
	}
};

// Block 240 (Modify Variables)
class Block121: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "240";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value3.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SL_Level_Butterfly2;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::TP2;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[125].run(121);
		}
	}

	virtual void _beforeExecute_()
	{

		v::SL_Level_Butterfly1 = _Value1_();
		v::TP1 = _Value2_();
	}
};

// Block 241 (Modify Variables)
class Block122: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "241";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value3.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::SL_Level_Butterfly2;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::TP2;

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[130].run(122);
		}
	}

	virtual void _beforeExecute_()
	{

		v::SL_Level_Butterfly1 = _Value1_();
		v::TP1 = _Value2_();
	}
};

// Block 242 (Pass)
class Block123: public MDL_Pass
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "242";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {124};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[124].run(123);
		}
	}
};

// Block 243 (Custom MQL code)
class Block124: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "243";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectsDeleteAll();
	}
};

// Block 244 (Condition)
class Block125: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "244";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {149};
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
	virtual double _Ro_() {
		Ro.Value = v::Entry_Sell_Butterfly1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[149].run(125);
		}
	}
};

// Block 245 (Condition)
class Block126: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "245";


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
	virtual double _Ro_() {
		Ro.Value = v::Entry_Sell_Crab;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[150].run(126);
		}
	}
};

// Block 246 (Condition)
class Block127: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "246";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {151};
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
	virtual double _Ro_() {
		Ro.Value = v::Entry_Sell_Bat;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[151].run(127);
		}
	}
};

// Block 247 (Condition)
class Block128: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "247";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {148};
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
	virtual double _Ro_() {
		Ro.Value = v::Entry_Sell_Gartley;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[148].run(128);
		}
	}
};

// Block 248 (Condition)
class Block129: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "248";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {147};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Entry_Buy_Gartley;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[147].run(129);
		}
	}
};

// Block 249 (Condition)
class Block130: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "249";


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
	virtual double _Ro_() {
		Ro.Value = v::Entry_Buy_Butterfly1;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[144].run(130);
		}
	}
};

// Block 250 (Condition)
class Block131: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "250";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {145};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Entry_Buy_Crab;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[145].run(131);
		}
	}
};

// Block 251 (Condition)
class Block132: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "251";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {146};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();
		Lo.Period = CurrentTimeframe();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Entry_Buy_Bat;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[146].run(132);
		}
	}
};

// Block 252 (Modify Variables)
class Block133: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "252";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(133);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbat = _Value1_();
		v::Abat = _Value2_();
		v::Bbat = _Value3_();
		v::Cbat = _Value4_();
	}
};

// Block 253 (Modify Variables)
class Block134: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "253";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[22].run(134);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xcrab = _Value1_();
		v::Acrab = _Value2_();
		v::Bcrab = _Value3_();
		v::Ccrab = _Value4_();
	}
};

// Block 254 (Modify Variables)
class Block135: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "254";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(135);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xgartley = _Value1_();
		v::Agartley = _Value2_();
		v::Bgartley = _Value3_();
		v::Cgartley = _Value4_();
	}
};

// Block 255 (Modify Variables)
class Block136: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "255";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(136);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbutterfly = _Value1_();
		v::Abutterfly = _Value2_();
		v::Bbutterfly = _Value3_();
		v::Cbutterfly = _Value4_();
	}
};

// Block 256 (Modify Variables)
class Block137: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "256";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {2};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[2].run(137);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xgartley = _Value1_();
		v::Agartley = _Value2_();
		v::Bgartley = _Value3_();
		v::Cgartley = _Value4_();
	}
};

// Block 257 (Modify Variables)
class Block138: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "257";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(138);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbutterfly = _Value1_();
		v::Abutterfly = _Value2_();
		v::Bbutterfly = _Value3_();
		v::Cbutterfly = _Value4_();
	}
};

// Block 258 (Modify Variables)
class Block139: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "258";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(139);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbat = _Value1_();
		v::Abat = _Value2_();
		v::Bbat = _Value3_();
		v::Cbat = _Value4_();
	}
};

// Block 259 (Modify Variables)
class Block140: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "259";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B1;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[25].run(140);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xcrab = _Value1_();
		v::Acrab = _Value2_();
		v::Bcrab = _Value3_();
		v::Ccrab = _Value4_();
	}
};

// Block 260 (Pass)
class Block141: public MDL_Pass
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "260";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {142};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[142].run(141);
		}
	}
};

// Block 261 (Modify Variables)
class Block142: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "261";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Boolean = false;
		Value2.Boolean = false;
		Value3.Boolean = false;
		Value4.Boolean = false;
	}

	public: /* Custom methods */
	virtual bool _Value1_() {return Value1._execute_();}
	virtual bool _Value2_() {return Value2._execute_();}
	virtual bool _Value3_() {return Value3._execute_();}
	virtual bool _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::Gartley = _Value1_();
		v::Butterfly = _Value2_();
		v::Crab = _Value3_();
		v::Bat = _Value4_();
	}
};

// Block 270 (Formula)
class Block143: public MDL_Formula_32<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "270";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {126};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xcrab;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[126].run(143);
		}
	}
};

// Block 271 (Custom MQL code)
class Block144: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "271";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {200};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[200].run(144);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Buy_Butterfly1 = NormalizeDouble(v::Entry_Buy_Butterfly1,Digits);
v::Entry_Buy_Butterfly2 = NormalizeDouble(v::Entry_Buy_Butterfly2,Digits);
	}
};

// Block 272 (Custom MQL code)
class Block145: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block145() {
		__block_number = 145;
		__block_user_number = "272";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {199};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[199].run(145);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Buy_Crab = NormalizeDouble(v::Entry_Buy_Crab,Digits);
	}
};

// Block 273 (Custom MQL code)
class Block146: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block146() {
		__block_number = 146;
		__block_user_number = "273";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {198};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[198].run(146);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Buy_Bat = NormalizeDouble(v::Entry_Buy_Bat,Digits);
	}
};

// Block 274 (Custom MQL code)
class Block147: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block147() {
		__block_number = 147;
		__block_user_number = "274";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {201};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[201].run(147);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Buy_Gartley = NormalizeDouble(v::Entry_Buy_Gartley,Digits);
	}
};

// Block 275 (Custom MQL code)
class Block148: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block148() {
		__block_number = 148;
		__block_user_number = "275";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {202};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[202].run(148);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Sell_Gartley = NormalizeDouble(v::Entry_Sell_Gartley,Digits);
	}
};

// Block 276 (Custom MQL code)
class Block149: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block149() {
		__block_number = 149;
		__block_user_number = "276";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {203};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[203].run(149);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Sell_Butterfly1 = NormalizeDouble(v::Entry_Sell_Butterfly1,Digits);
v::Entry_Sell_Butterfly2 = NormalizeDouble(v::Entry_Sell_Butterfly2,Digits);
	}
};

// Block 277 (Custom MQL code)
class Block150: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block150() {
		__block_number = 150;
		__block_user_number = "277";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {197};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[197].run(150);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Sell_Crab = NormalizeDouble(v::Entry_Sell_Crab,Digits);
	}
};

// Block 278 (Custom MQL code)
class Block151: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block151() {
		__block_number = 151;
		__block_user_number = "278";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {196};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[196].run(151);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Entry_Sell_Bat = NormalizeDouble(v::Entry_Sell_Bat,Digits);
	}
};

// Block 279 (Formula)
class Block152: public MDL_Formula_33<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block152() {
		__block_number = 152;
		__block_user_number = "279";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {122};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*21.4/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[122].run(152);
		}
	}
};

// Block 280 (Formula)
class Block153: public MDL_Formula_34<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block153() {
		__block_number = 153;
		__block_user_number = "280";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Xbutterfly;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*21.4/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[121].run(153);
		}
	}
};

// Block 281 (Modify Variables)
class Block154: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block154() {
		__block_number = 154;
		__block_user_number = "281";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {204};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CandleID = v::Bbars;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[204].run(154);
		}
	}

	virtual void _beforeExecute_()
	{

		v::B2 = _Value1_();
	}
};

// Block 282 (Modify Variables)
class Block155: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block155() {
		__block_number = 155;
		__block_user_number = "282";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {207};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.CandleID = v::Bbars;
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[207].run(155);
		}
	}

	virtual void _beforeExecute_()
	{

		v::B2 = _Value1_();
	}
};

// Block 283 (Bat)
class Block156: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block156() {
		__block_number = 156;
		__block_user_number = "283";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {157};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[157].run(156);
		}
	}
};

// Block 284 (Condition)
class Block157: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block157() {
		__block_number = 157;
		__block_user_number = "284";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {158};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*50/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[158].run(157);
		}
	}
};

// Block 285 (Condition)
class Block158: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block158() {
		__block_number = 158;
		__block_user_number = "285";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {159};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[159].run(158);
		}
	}
};

// Block 286 (Condition)
class Block159: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block159() {
		__block_number = 159;
		__block_user_number = "286";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {160};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[160].run(159);
		}
	}
};

// Block 287 (Modify Variables)
class Block160: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block160() {
		__block_number = 160;
		__block_user_number = "287";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(160);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbat = _Value1_();
		v::Abat = _Value2_();
		v::Bbat = _Value3_();
		v::Cbat = _Value4_();
	}
};

// Block 288 (Crab)
class Block161: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block161() {
		__block_number = 161;
		__block_user_number = "288";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {162};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[162].run(161);
		}
	}
};

// Block 289 (Condition)
class Block162: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block162() {
		__block_number = 162;
		__block_user_number = "289";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {163};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[163].run(162);
		}
	}
};

// Block 290 (Condition)
class Block163: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block163() {
		__block_number = 163;
		__block_user_number = "290";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {164};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[164].run(163);
		}
	}
};

// Block 291 (Condition)
class Block164: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block164() {
		__block_number = 164;
		__block_user_number = "291";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {165};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[165].run(164);
		}
	}
};

// Block 292 (Modify Variables)
class Block165: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block165() {
		__block_number = 165;
		__block_user_number = "292";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[22].run(165);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xcrab = _Value1_();
		v::Acrab = _Value2_();
		v::Bcrab = _Value3_();
		v::Ccrab = _Value4_();
	}
};

// Block 293 (Butterfly)
class Block166: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block166() {
		__block_number = 166;
		__block_user_number = "293";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {167};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XA;

		double value = (double)Lo._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[167].run(166);
		}
	}
};

// Block 294 (Condition)
class Block167: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block167() {
		__block_number = 167;
		__block_user_number = "294";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {168};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::XA;

		double value = (double)Lo._execute_();
		value = value*88.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[168].run(167);
		}
	}
};

// Block 295 (Condition)
class Block168: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block168() {
		__block_number = 168;
		__block_user_number = "295";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {169};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[169].run(168);
		}
	}
};

// Block 296 (Condition)
class Block169: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block169() {
		__block_number = 169;
		__block_user_number = "296";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {170};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[170].run(169);
		}
	}
};

// Block 297 (Modify Variables)
class Block170: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block170() {
		__block_number = 170;
		__block_user_number = "297";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(170);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbutterfly = _Value1_();
		v::Abutterfly = _Value2_();
		v::Bbutterfly = _Value3_();
		v::Cbutterfly = _Value4_();
	}
};

// Block 298 (Gartley)
class Block171: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block171() {
		__block_number = 171;
		__block_user_number = "298";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {172};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[172].run(171);
		}
	}
};

// Block 299 (Condition)
class Block172: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block172() {
		__block_number = 172;
		__block_user_number = "299";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {173};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[173].run(172);
		}
	}
};

// Block 300 (Condition)
class Block173: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block173() {
		__block_number = 173;
		__block_user_number = "300";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {174};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[174].run(173);
		}
	}
};

// Block 301 (Condition)
class Block174: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block174() {
		__block_number = 174;
		__block_user_number = "301";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {175};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*90/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[175].run(174);
		}
	}
};

// Block 302 (Modify Variables)
class Block175: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block175() {
		__block_number = 175;
		__block_user_number = "302";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(175);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xgartley = _Value1_();
		v::Agartley = _Value2_();
		v::Bgartley = _Value3_();
		v::Cgartley = _Value4_();
	}
};

// Block 303 (Gartley)
class Block176: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block176() {
		__block_number = 176;
		__block_user_number = "303";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {177};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[177].run(176);
		}
	}
};

// Block 304 (Condition)
class Block177: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block177() {
		__block_number = 177;
		__block_user_number = "304";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {178};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[178].run(177);
		}
	}
};

// Block 305 (Condition)
class Block178: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block178() {
		__block_number = 178;
		__block_user_number = "305";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {179};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[179].run(178);
		}
	}
};

// Block 306 (Condition)
class Block179: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block179() {
		__block_number = 179;
		__block_user_number = "306";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {180};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[180].run(179);
		}
	}
};

// Block 307 (Modify Variables)
class Block180: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block180() {
		__block_number = 180;
		__block_user_number = "307";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {2};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[2].run(180);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xgartley = _Value1_();
		v::Agartley = _Value2_();
		v::Bgartley = _Value3_();
		v::Cgartley = _Value4_();
	}
};

// Block 308 (Butterfly)
class Block181: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block181() {
		__block_number = 181;
		__block_user_number = "308";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {182};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*78.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[182].run(181);
		}
	}
};

// Block 309 (Condition)
class Block182: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block182() {
		__block_number = 182;
		__block_user_number = "309";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {183};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*88.6/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[183].run(182);
		}
	}
};

// Block 310 (Condition)
class Block183: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block183() {
		__block_number = 183;
		__block_user_number = "310";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {184};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[184].run(183);
		}
	}
};

// Block 311 (Condition)
class Block184: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block184() {
		__block_number = 184;
		__block_user_number = "311";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {185};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[185].run(184);
		}
	}
};

// Block 312 (Modify Variables)
class Block185: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block185() {
		__block_number = 185;
		__block_user_number = "312";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[99].run(185);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbutterfly = _Value1_();
		v::Abutterfly = _Value2_();
		v::Bbutterfly = _Value3_();
		v::Cbutterfly = _Value4_();
	}
};

// Block 313 (Crab)
class Block186: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block186() {
		__block_number = 186;
		__block_user_number = "313";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {187};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[187].run(186);
		}
	}
};

// Block 314 (Condition)
class Block187: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block187() {
		__block_number = 187;
		__block_user_number = "314";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {188};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*61.8/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[188].run(187);
		}
	}
};

// Block 315 (Condition)
class Block188: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block188() {
		__block_number = 188;
		__block_user_number = "315";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {189};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[189].run(188);
		}
	}
};

// Block 316 (Condition)
class Block189: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block189() {
		__block_number = 189;
		__block_user_number = "316";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {190};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[190].run(189);
		}
	}
};

// Block 317 (Modify Variables)
class Block190: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block190() {
		__block_number = 190;
		__block_user_number = "317";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {25};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[25].run(190);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xcrab = _Value1_();
		v::Acrab = _Value2_();
		v::Bcrab = _Value3_();
		v::Ccrab = _Value4_();
	}
};

// Block 318 (Bat)
class Block191: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block191() {
		__block_number = 191;
		__block_user_number = "318";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {192};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[192].run(191);
		}
	}
};

// Block 319 (Condition)
class Block192: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block192() {
		__block_number = 192;
		__block_user_number = "319";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {193};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::AB2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::XA;

		double value = (double)Ro._execute_();
		value = value*50/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[193].run(192);
		}
	}
};

// Block 320 (Condition)
class Block193: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block193() {
		__block_number = 193;
		__block_user_number = "320";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {194};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC1;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB1;

		double value = (double)Ro._execute_();
		value = value*38.2/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[194].run(193);
		}
	}
};

// Block 321 (Condition)
class Block194: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block194() {
		__block_number = 194;
		__block_user_number = "321";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {195};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::BC2;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::AB2;

		double value = (double)Ro._execute_();
		value = value*100/NormalizeDouble(100,0); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[195].run(194);
		}
	}
};

// Block 322 (Modify Variables)
class Block195: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block195() {
		__block_number = 195;
		__block_user_number = "322";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::X;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::A;

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::B2;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::C;

		return Value4._execute_();
	}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[50].run(195);
		}
	}

	virtual void _beforeExecute_()
	{

		v::Xbat = _Value1_();
		v::Abat = _Value2_();
		v::Bbat = _Value3_();
		v::Cbat = _Value4_();
	}
};

// Block 339 (Once per bar)
class Block196: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block196() {
		__block_number = 196;
		__block_user_number = "339";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {210};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[210].run(196);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 340 (Once per bar)
class Block197: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block197() {
		__block_number = 197;
		__block_user_number = "340";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {211};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[211].run(197);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 341 (Once per bar)
class Block198: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block198() {
		__block_number = 198;
		__block_user_number = "341";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {217};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[217].run(198);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 342 (Once per bar)
class Block199: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block199() {
		__block_number = 199;
		__block_user_number = "342";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {216};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[216].run(199);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 343 (Once per bar)
class Block200: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block200() {
		__block_number = 200;
		__block_user_number = "343";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {215};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[215].run(200);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 344 (Once per bar)
class Block201: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block201() {
		__block_number = 201;
		__block_user_number = "344";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {214};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[214].run(201);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 345 (Once per bar)
class Block202: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block202() {
		__block_number = 202;
		__block_user_number = "345";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {213};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[213].run(202);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 346 (Once per bar)
class Block203: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>
{

	public: /* Constructor */
	Block203() {
		__block_number = 203;
		__block_user_number = "346";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {212};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[212].run(203);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}
};

// Block 347 (Condition)
class Block204: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block204() {
		__block_number = 204;
		__block_user_number = "347";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {205};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Cbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Bbars;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[205].run(204);
		}
	}
};

// Block 348 (Condition)
class Block205: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block205() {
		__block_number = 205;
		__block_user_number = "348";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {206};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Bbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Abars;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[206].run(205);
		}
	}
};

// Block 349 (Condition)
class Block206: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block206() {
		__block_number = 206;
		__block_user_number = "349";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {57};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Abars;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Xbars;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[57].run(206);
		}
	}
};

// Block 350 (Condition)
class Block207: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block207() {
		__block_number = 207;
		__block_user_number = "350";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {208};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Cbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Bbars;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[208].run(207);
		}
	}
};

// Block 351 (Condition)
class Block208: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block208() {
		__block_number = 208;
		__block_user_number = "351";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {209};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Bbars;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Abars;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[209].run(208);
		}
	}
};

// Block 352 (Condition)
class Block209: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block209() {
		__block_number = 209;
		__block_user_number = "352";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {82};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::Abars;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::Xbars;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[82].run(209);
		}
	}
};

// Block 353 (Buy now)
class Block210: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block210() {
		__block_number = 210;
		__block_user_number = "353";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
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
		TakeProfitPercentSL = 200.0;
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Sell_Bat;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(210);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Bat_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 354 (Buy now)
class Block211: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iAC,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block211() {
		__block_number = 211;
		__block_user_number = "354";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {21};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Sell_Crab;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[21].run(211);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Crab_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 355 (Buy now)
class Block212: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block212() {
		__block_number = 212;
		__block_user_number = "355";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {27};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Sell_Butterfly1;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[27].run(212);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Butterfly_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 356 (Buy now)
class Block213: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block213() {
		__block_number = 213;
		__block_user_number = "356";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {6};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Sell_Gartley;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[6].run(213);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Gartley_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 357 (Sell now)
class Block214: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block214() {
		__block_number = 214;
		__block_user_number = "357";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {24};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Buy_Gartley;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[24].run(214);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Gartley_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 358 (Sell now)
class Block215: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block215() {
		__block_number = 215;
		__block_user_number = "358";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Buy_Butterfly1;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(215);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Butterfly_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 359 (Sell now)
class Block216: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block216() {
		__block_number = 216;
		__block_user_number = "359";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {3};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Buy_Crab;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[3].run(216);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Crab_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 360 (Sell now)
class Block217: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_value,double,MDLIC_indicators_iATR,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block217() {
		__block_number = 217;
		__block_user_number = "360";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {49};
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
	virtual double _dlStopLoss_() {
		dlStopLoss.EndBar = c::ZZ_Depth;
		dlStopLoss.Symbol = CurrentSymbol();
		dlStopLoss.Period = CurrentTimeframe();

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {
		ddStopLoss.Symbol = CurrentSymbol();
		ddStopLoss.Period = PERIOD_D1;

		return ddStopLoss._execute_();
	}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::Entry_Buy_Bat;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[49].run(217);
		}
	}

	virtual void _beforeExecute_()
	{

		Group = (string)c::Bat_group_order;
		Symbol = (string)CurrentSymbol();
		VolumeSize = (double)v::LOTT;
		VolumeRisk = (double)c::Lot_Divided;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 361 (Pass)
class Block218: public MDL_Pass
{

	public: /* Constructor */
	Block218() {
		__block_number = 218;
		__block_user_number = "361";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {219};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[219].run(218);
		}
	}
};

// Block 362 (Formula)
class Block219: public MDL_Formula_35<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block219() {
		__block_number = 219;
		__block_user_number = "362";

		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = c::Lot_Divided;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 363 (Check profit (unrealized))
class Block220: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block220() {
		__block_number = 220;
		__block_user_number = "363";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {222};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "buys";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[222].run(220);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::PercentX;
	}
};

// Block 364 (Formula)
class Block221: public MDL_Formula_36<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block221() {
		__block_number = 221;
		__block_user_number = "364";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {220};
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
			_blocks_[220].run(221);
		}
	}
};

// Block 365 (Close trades)
class Block222: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block222() {
		__block_number = 222;
		__block_user_number = "365";
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

		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 366 (Check profit (unrealized))
class Block223: public MDL_CheckUProfit<string,string,string,string,string,string,string,double,double,string,string,double,double>
{

	public: /* Constructor */
	Block223() {
		__block_number = 223;
		__block_user_number = "366";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {225};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		BuysOrSells = "sells";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[225].run(223);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ProfitAmount = (double)v::PercentX;
	}
};

// Block 367 (Formula)
class Block224: public MDL_Formula_37<MDLIC_account_AccountBalance,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block224() {
		__block_number = 224;
		__block_user_number = "367";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {223};
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
			_blocks_[223].run(224);
		}
	}
};

// Block 368 (Close trades)
class Block225: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block225() {
		__block_number = 225;
		__block_user_number = "368";
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

		Symbol = (string)CurrentSymbol();
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
		if (OrderSelect(prevTicket, SELECT_BY_TICKET, MODE_HISTORY)) {
			openPrice = OrderClosePrice();
		}
		
		bool success = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
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
		offset = TimeLocal() - TimeCurrent();
	}
	else if (time_src == 2) {
		TimeGMT(tm);
		offset = TimeGMT() - TimeCurrent();
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

int attrTicketPreviousSibling(int ticket)
{
	int ticket0 = OrderTicket();
	
	int retval = ticket;
	int ticket_parent = attrTicketParent(ticket);
	
	if (ticket_parent >= ticket) return ticket;
	
	// looking at the previous trades, searching for one that is sibling (it has the same parent)
	for (int i = ticket-1; i >= 1; i--)
	{		
		if (!OrderSelect(i, SELECT_BY_TICKET)) continue;
		//if (ticket == 3) {Print(i);}
		if (i == ticket_parent || attrTicketParent(i) == ticket_parent) {
			retval = i;
			break;
		}
	}
	
	bool success = OrderSelect(ticket0, SELECT_BY_TICKET);
		
	return retval;
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
