#include <MT4Orders.mqh> // https://www.mql5.com/ru/code/16006
// #include <ProfitMeter.mqh> // https://www.mql5.com/en/blogs/post/719643
// #include <ind4to5.mqh>     // https://www.mql5.com/en/blogs/post/681230

#ifdef __MQL5__

#define Point _Point
#define Digits _Digits

double MarketInfo( const string Symb, const ENUM_SYMBOL_INFO_DOUBLE Property )  { return(SymbolInfoDouble(Symb, Property)); }
int    MarketInfo( const string Symb, const ENUM_SYMBOL_INFO_INTEGER Property ) { return((int)SymbolInfoInteger(Symb, Property)); }

// https://www.mql5.com/ru/forum/170952/page9#comment_4134898
double GetMarginRequired( const string Symb )
{
  MqlTick Tick;
  double MarginInit, MarginMain;

  return((SymbolInfoTick(Symb, Tick) && SymbolInfoMarginRate(Symb, ORDER_TYPE_BUY, MarginInit, MarginMain)) ? MarginInit * Tick.ask *
          SymbolInfoDouble(Symb, SYMBOL_TRADE_TICK_VALUE) / (SymbolInfoDouble(Symb, SYMBOL_TRADE_TICK_SIZE) * AccountInfoInteger(ACCOUNT_LEVERAGE)) : 0);
}

#define Bid SymbolInfoDouble(_Symbol, SYMBOL_BID)
#define Ask SymbolInfoDouble(_Symbol, SYMBOL_ASK)

#define False false
#define True  true

#define MODE_POINT       SYMBOL_POINT
#define MODE_DIGITS      SYMBOL_DIGITS
#define MODE_TICKSIZE    SYMBOL_TRADE_TICK_SIZE
#define MODE_ASK         SYMBOL_ASK
#define MODE_BID         SYMBOL_BID
#define MODE_TIME        SYMBOL_TIME
#define MODE_MINLOT      SYMBOL_VOLUME_MIN
#define MODE_MAXLOT      SYMBOL_VOLUME_MAX
#define MODE_LOTSTEP     SYMBOL_VOLUME_STEP
#define MODE_LOTSIZE     SYMBOL_TRADE_CONTRACT_SIZE
#define MODE_TICKVALUE   SYMBOL_TRADE_TICK_VALUE
#define MODE_STOPLEVEL   SYMBOL_TRADE_STOPS_LEVEL
#define MODE_SPREAD      SYMBOL_SPREAD
#define MODE_LOW         SYMBOL_LASTLOW
#define MODE_HIGH        SYMBOL_LASTHIGH
#define MODE_STARTING    SYMBOL_START_TIME
#define MODE_EXPIRATION  SYMBOL_EXPIRATION_TIME
#define MODE_FREEZELEVEL SYMBOL_TRADE_FREEZE_LEVEL
#define MODE_SWAPTYPE    SYMBOL_SWAP_MODE
#define MODE_SWAPLONG    SYMBOL_SWAP_LONG
#define MODE_SWAPSHORT   SYMBOL_SWAP_SHORT

#define MODE_MARGINMAINTENANCE SYMBOL_MARGIN_MAINTENANCE
#define MODE_MARGININIT        SYMBOL_MARGIN_INITIAL
#define MODE_MARGINCALCMODE    SYMBOL_TRADE_CALC_MODE
#define MODE_PROFITCALCMODE    SYMBOL_TRADE_CALC_MODE
#define MODE_MARGINHEDGED      SYMBOL_MARGIN_HEDGED

#define MODE_MARGINREQUIRED 32
#define MODE_TRADEALLOWED   22

double MarketInfo( const string Symb, const int Property )
{
  switch (Property)
  {
  case MODE_MARGINREQUIRED:
    return(GetMarginRequired(Symb));
  case MODE_TRADEALLOWED:
    return(IsTradeAllowed());
  }

  return(0);
}

#define StrToTime     StringToTime
#define TimeToStr     TimeToString
#define StrToInteger  StringToInteger
#define StrToDouble   StringToDouble
#define StringGetChar StringGetCharacter
#define DoubleToStr   DoubleToString
#define CharToStr     CharToString
#define WindowRedraw  ChartRedraw
#define CurTime       TimeCurrent
#define WindowPriceOnDropped ChartPriceOnDropped

string StringSetChar( const string &String_Var,const int iPos,const ushort Value )
{
  string Str = String_Var;

  StringSetCharacter(Str, iPos, Value);

  return(Str);
}

string StringConcatenate( const string Str1, const string Str2 )
{
  string Str;

  StringConcatenate(Str, Str1, Str2);

  return(Str);
}

#define MACROS(A, B)               \
  int Time##A( const datetime dt ) \
  {                                \
    MqlDateTime mdts;              \
                                   \
    TimeToStruct(dt, mdts);        \
                                   \
    return(mdts.B);                \
  }                                \
                                   \
  int A() { return(Time##A(TimeCurrent())); }

  MACROS(Day, day)
  MACROS(Month, mon)
  MACROS(Year, year)
  MACROS(DayOfYear, day_of_year)
  MACROS(DayOfWeek, day_of_week)
  MACROS(Hour, hour)
  MACROS(Minute, min)
#undef MACROS

// https://www.mql5.com/ru/articles/81
ENUM_TIMEFRAMES TFMigrate( const int tf )
{
 switch(tf)
   {
    case 0: return(PERIOD_CURRENT);
    case 1: return(PERIOD_M1);
    case 5: return(PERIOD_M5);
    case 15: return(PERIOD_M15);
    case 30: return(PERIOD_M30);
    case 60: return(PERIOD_H1);
    case 240: return(PERIOD_H4);
    case 1440: return(PERIOD_D1);
    case 10080: return(PERIOD_W1);
    case 43200: return(PERIOD_MN1);

    case 2: return(PERIOD_M2);
    case 3: return(PERIOD_M3);
    case 4: return(PERIOD_M4);
    case 6: return(PERIOD_M6);
    case 10: return(PERIOD_M10);
    case 12: return(PERIOD_M12);
    case 16385: return(PERIOD_H1);
    case 16386: return(PERIOD_H2);
    case 16387: return(PERIOD_H3);
    case 16388: return(PERIOD_H4);
    case 16390: return(PERIOD_H6);
    case 16392: return(PERIOD_H8);
    case 16396: return(PERIOD_H12);
    case 16408: return(PERIOD_D1);
    case 32769: return(PERIOD_W1);
    case 49153: return(PERIOD_MN1);
    default: return(PERIOD_CURRENT);
   }
}

int iBars( const string Symb, const int TF ) { return(iBars(Symb, TFMigrate(TF))); }
#define Bars (iBars(_Symbol, _Period))

#define MACROS(A, B) B A( const string Symb, const int TF, const int Shift ) { return(A(Symb, TFMigrate(TF), Shift)); }

  MACROS(iHigh, double)
  MACROS(iLow, double)
  MACROS(iOpen, double)
  MACROS(iClose, double)
  MACROS(iTime, datetime)
#undef MACROS

int iBarShift( const string Symb, const int TF, const datetime time, const bool Exact = false ) { return(iBarShift(Symb, TFMigrate(TF), time, Exact)); }

bool IsTesting()               { return((bool)MQLInfoInteger(MQL_TESTER)); }
bool IsVisualMode()            { return((bool)MQLInfoInteger(MQL_VISUAL_MODE)); }
bool IsExpertEnabled()         { return((bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)); }
bool IsLibrariesAllowed()      { return((bool)MQLInfoInteger(MQL_DLLS_ALLOWED)); }
bool IsDllsAllowed()           { return(TerminalInfoInteger(TERMINAL_DLLS_ALLOWED) &&
                                        MQLInfoInteger(MQL_DLLS_ALLOWED)); }
bool IsTradeContextBusy()      { return(false); }
bool IsTradeAllowed()          { return(MQLInfoInteger(MQL_TRADE_ALLOWED) &&
                                        TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) &&
                                        AccountInfoInteger(ACCOUNT_TRADE_ALLOWED)); }
bool RefreshRates()            { return(true); }
string WindowExpertName()      { return(MQLInfoString(MQL_PROGRAM_NAME)); }
double AccountEquity()         { return(AccountInfoDouble(ACCOUNT_EQUITY)); }
double AccountBalance()        { return(AccountInfoDouble(ACCOUNT_BALANCE)); }
double AccountProfit()         { return(AccountInfoDouble(ACCOUNT_PROFIT)); }
string AccountName()           { return(AccountInfoString(ACCOUNT_NAME)); }
string AccountServer()         { return(AccountInfoString(ACCOUNT_SERVER)); }
string AccountCompany()        { return(AccountInfoString(ACCOUNT_COMPANY)); }
string AccountCurrency()       { return(AccountInfoString(ACCOUNT_CURRENCY)); }
int AccountNumber()            { return((int)AccountInfoInteger(ACCOUNT_LOGIN)); }
int AccountLeverage()          { return((int)AccountInfoInteger(ACCOUNT_LEVERAGE)); }
double AccountFreeMargin()     { return(AccountInfoDouble(ACCOUNT_MARGIN_FREE)); }
double AccountCredit()         { return(AccountInfoDouble(ACCOUNT_CREDIT)); }
double AccountStopoutLevel()   {return(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));}
int AccountStopoutMode()       { return((int)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE)); }
double AccountFreeMarginMode() { return(-1); }
double AccountMargin()         { return(AccountInfoDouble(ACCOUNT_MARGIN)); }

double AccountFreeMarginCheck(const string Symb,const int Cmd,const double dVolume)
  {
   double Margin;

   return(OrderCalcMargin((ENUM_ORDER_TYPE)Cmd, Symb, dVolume,
          SymbolInfoDouble(Symb, (Cmd == ORDER_TYPE_BUY) ? SYMBOL_ASK : SYMBOL_BID),  Margin) ?
          AccountInfoDouble(ACCOUNT_MARGIN_FREE) - Margin : -1);
  }

// https://www.mql5.com/ru/articles/81
long WindowHandle( const string Symb, const int tf )
{
  ENUM_TIMEFRAMES timeframe=TFMigrate(tf);

  if (timeframe == PERIOD_CURRENT)
    timeframe = _Period;

  if ((Symb == _Symbol) && (timeframe == _Period))
    return(ChartID());

  long currChart,prevChart=ChartFirst();
  int i=0,limit=100;
  while(i<limit)
   {
    currChart=ChartNext(prevChart);
    if(currChart<0) break;
    if(ChartSymbol(currChart)==Symb
       && ChartPeriod(currChart)==timeframe)
       return((int)currChart);
    prevChart=currChart;
    i++;
   }
  return(0);
}

#define DEFINE_TIMESERIE(NAME, T)                \
  class CLASS##NAME                              \
  {                                              \
  public:                                        \
    T operator[]( const int iPos ) const         \
    {                                            \
      return(::i##NAME(_Symbol, _Period, iPos)); \
    }                                            \
  };                                             \
                                                 \
  CLASS##NAME NAME;

  DEFINE_TIMESERIE(Volume, long)
  DEFINE_TIMESERIE(Time, datetime)
  DEFINE_TIMESERIE(Open, double)
  DEFINE_TIMESERIE(High, double)
  DEFINE_TIMESERIE(Low, double)
  DEFINE_TIMESERIE(Close, double)
#undef DEFINE_TIMESERIE

#endif // __MQL5__
