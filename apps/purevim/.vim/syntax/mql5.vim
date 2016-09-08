" Vim syntax file
" Language: mql5
" Original Author: Vaclav Vobornik <git@vobornik.eu>
" Maintainer: Alex Kwiatkowski <alex+git@rival-studios.com>
" Last Change: 2015 Jul 29
" Used Bram Moolenaar syntax for C as a source.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" A bunch of useful keywords
syn keyword mql5Statement break return continue
syn keyword mql5Label case default const
syn keyword mql5Conditional if else switch
syn keyword mql5Repeat while for
syn keyword mql5OO new delete class struct
syn keyword mql5Todo contained TODO FIXME XXX

" It's easy to accidentally add a space after a backslash that was intended
" for line continuation.  Some compilers allow it, which makes it
" unpredicatable and should be avoided.
syn match mql5BadContinuation contained "\\\s\+$"

" mql5CommentGroup allows adding matches for special things in comments
syn cluster mql5CommentGroup contains=mql5Todo,mql5BadContinuation

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match mql5Special display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match mql5Special display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif
if exists("c_no_mql5Format")
  syn region mql5String  start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=mql5Special,@Spell
  " mql5CppString: same as mql5String, but ends at end of line
  syn region mql5CppString start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=mql5Special,@Spell
else
  if !exists("c_no_c99") " ISO C99
    syn match mql5Format  display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match mql5Format  display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match mql5Format  display "%%" contained
  syn region mql5String  start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=mql5Special,mql5Format,@Spell
  " mql5CppString: same as mql5String, but ends at end of line
  syn region mql5CppString start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=mql5Special,mql5Format,@Spell
endif

syn match mql5Character "L\='[^\\]'"
syn match mql5Character "L'[^']*'" contains=mql5Special
if exists("c_gnu")
  syn match mql5SpecialError "L\='\\[^'\"?\\abefnrtv]'"
  syn match mql5SpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match mql5SpecialError "L\='\\[^'\"?\\abfnrtv]'"
  syn match mql5SpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match mql5SpecialCharacter display "L\='\\\o\{1,3}'"
syn match mql5SpecialCharacter display "'\\x\x\{1,2}'"
syn match mql5SpecialCharacter display "L'\\x\x\+'"

"when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match mql5SpaceError display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match mql5SpaceError display " \+\t"me=e-1
  endif
endif

" This should be before mql5ErrInParen to avoid problems with #define ({ xxx })
if exists("c_curly_error")
  syntax match mql5CurlyError "}"
  syntax region mql5Block  start="{" end="}" contains=ALLBUT,mql5CurlyError,@mql5ParenGroup,mql5ErrInParen,mql5CppParen,mql5ErrInBracket,mql5CppBracket,mql5CppString,@Spell fold
else
  syntax region mql5Block  start="{" end="}" transparent fold
endif

"catch errors caused by wrong parenthesis and brackets
" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster mql5ParenGroup contains=mql5ParenError,mql5Included,mql5Special,mql5CommentSkip,mql5CommentString,mql5Comment2String,@mql5CommentGroup,mql5CommentStartError,mql5UserCont,mql5UserLabel,mql5BitField,mql5OctalZero,mql5CppOut,mql5CppOut2,mql5CppSkip,mql5Format,mql5Number,mql5Float,mql5Octal,mql5OctalError,mql5NumbersCom
if exists("c_no_curly_error")
  syn region mql5Paren  transparent start='(' end=')' contains=ALLBUT,@mql5ParenGroup,mql5CppParen,mql5CppString,@Spell
  " mql5CppParen: same as mql5Paren but ends at end-of-line; used in mql5Define
  syn region mql5CppParen transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@mql5ParenGroup,mql5Paren,mql5String,@Spell
  syn match mql5ParenError display ")"
  syn match mql5ErrInParen display contained "^[{}]\|^<%\|^%>"
elseif exists("c_no_bracket_error")
  syn region mql5Paren  transparent start='(' end=')' contains=ALLBUT,@mql5ParenGroup,mql5CppParen,mql5CppString,@Spell
  " mql5CppParen: same as mql5Paren but ends at end-of-line; used in mql5Define
  syn region mql5CppParen transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@mql5ParenGroup,mql5Paren,mql5String,@Spell
  syn match mql5ParenError display ")"
  syn match mql5ErrInParen display contained "[{}]\|<%\|%>"
else
  syn region mql5Paren  transparent start='(' end=')' contains=ALLBUT,@mql5ParenGroup,mql5CppParen,mql5ErrInBracket,mql5CppBracket,mql5CppString,@Spell
  " mql5CppParen: same as mql5Paren but ends at end-of-line; used in mql5Define
  syn region mql5CppParen transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@mql5ParenGroup,mql5ErrInBracket,mql5Paren,mql5Bracket,mql5String,@Spell
  syn match mql5ParenError display "[\])]"
  syn match mql5ErrInParen display contained "[\]{}]\|<%\|%>"
  syn region mql5Bracket transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@mql5ParenGroup,mql5ErrInParen,mql5CppParen,mql5CppBracket,mql5CppString,@Spell
  " mql5CppBracket: same as mql5Paren but ends at end-of-line; used in mql5Define
  syn region mql5CppBracket transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@mql5ParenGroup,mql5ErrInParen,mql5Paren,mql5Bracket,mql5String,@Spell
  syn match mql5ErrInBracket display contained "[);{}]\|<%\|%>"
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match mql5Numbers display transparent "\<\d\|\.\d" contains=mql5Number,mql5Float,mql5OctalError,mql5Octal
" Same, but without octal error (for comments)
syn match mql5NumbersCom display contained transparent "\<\d\|\.\d" contains=mql5Number,mql5Float,mql5Octal
syn match mql5Number  display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match mql5Number  display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match mql5Octal  display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=mql5OctalZero
syn match mql5OctalZero display contained "\<0"
syn match mql5Float  display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match mql5Float  display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match mql5Float  display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match mql5Float  display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match mql5Float  display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match mql5Float  display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match mql5OctalError display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain mql5String, mql5Character and mql5Number.
  " But a "*/" inside a mql5String in a mql5Comment DOES end the comment!  So we
  " need to use a special type of mql5String: mql5CommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match mql5CommentSkip contained "^\s*\*\($\|\s\+\)"
  syntax region mql5CommentString contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=mql5Special,mql5CommentSkip
  syntax region mql5Comment2String contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=mql5Special
  syntax region  mql5CommentL start="//" skip="\\$" end="$" keepend contains=@mql5CommentGroup,mql5Comment2String,mql5Character,mql5NumbersCom,mql5SpaceError,@Spell
  if exists("c_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syntax region mql5Comment matchgroup=mql5CommentStart start="/\*" end="\*/" contains=@mql5CommentGroup,mql5CommentStartError,mql5CommentString,mql5Character,mql5NumbersCom,mql5SpaceError,@Spell extend
  else
    syntax region mql5Comment matchgroup=mql5CommentStart start="/\*" end="\*/" contains=@mql5CommentGroup,mql5CommentStartError,mql5CommentString,mql5Character,mql5NumbersCom,mql5SpaceError,@Spell fold extend
  endif
else
  syn region mql5CommentL start="//" skip="\\$" end="$" keepend contains=@mql5CommentGroup,mql5SpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region mql5Comment matchgroup=mql5CommentStart start="/\*" end="\*/" contains=@mql5CommentGroup,mql5CommentStartError,mql5SpaceError,@Spell extend
  else
    syn region mql5Comment matchgroup=mql5CommentStart start="/\*" end="\*/" contains=@mql5CommentGroup,mql5CommentStartError,mql5SpaceError,@Spell fold extend
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match mql5CommentError display "\*/"
syntax match mql5CommentStartError display "/\*"me=e-1 contained

syn keyword mql5Operator false true
syn match       mql5Operator       "\(&&\|||\|==\|!=\|<\|>\|<=\|>=\)"

syn match       mql5Define         "#import"
syn match       mql5Define         "#define"
syn match       mql5Define         "#property\s\+\(copyright\|link\|stacksize\|library\|indicator_chart_window\|indicator_separate_window\|indicator_buffers\|indicator_minimum\|indicator_maximum\|indicator_color[1-8]\|indicator_width[1-8]\|indicator_style[1-8]\|indicator_level[1-8]\|indicator_levelcolor\|indicator_levelwidth\|indicator_levelstyle\|show_confirm\|show_inputs\)\(\s\+\|$\)"

syn keyword mql5Type    bool color datetime double long ulong int uint string void
syn keyword mql5Class   CAccountInfo CExpert CExpertBase CExpertSignal CExpertTrailing CExpertMoney CSymbolInfo COrderInfo CHistoryOrderInfo CPositionInfo CDealInfo CTrade CTerminalInfo

syn keyword mql5Structure extern static virtual

syn keyword     mql5Constant       ANCHOR_LEFT_UPPER ANCHOR_LEFT ANCHOR_LEFT_LOWER ANCHOR_LOWER ANCHOR_RIGHT_LOWER ANCHOR_RIGHT ANCHOR_RIGHT_UPPER ANCHOR_UPPER ANCHOR_CENTER
syn keyword     mql5Constant       MODE_OPEN MODE_LOW MODE_HIGH MODE_CLOSE MODE_VOLUME MODE_TIME
syn keyword     mql5Constant       PERIOD_M1 PERIOD_M5 PERIOD_M15 PERIOD_M30 PERIOD_H1 PERIOD_H4 PERIOD_D1 PERIOD_W1 PERIOD_MN1
syn keyword     mql5Constant       OP_BUY OP_SELL OP_BUYLIMIT OP_SELLLIMIT OP_BUYSTOP OP_SELLSTOP
syn keyword     mql5Constant       SELECT_BY_POS SELECT_BY_TICKET MODE_TRADES MODE_HISTORY
syn keyword     mql5Constant       PRICE_CLOSE PRICE_OPEN PRICE_HIGH PRICE_LOW PRICE_MEDIAN PRICE_TYPICAL PRICE_WEIGHTED
syn keyword     mql5Constant       MODE_ASCEND MODE_DESCEND
syn keyword     mql5Constant       TIME_DATE TIME_MINUTES TIME_SECONDS
syn keyword     mql5Constant       FILE_BIN FILE_CSV FILE_READ FILE_WRITE
syn keyword     mql5Constant       CHAR_VALUE SHORT_VALUE LONG_VALUE FLOAT_VALUE DOUBLE_VALUE
syn keyword     mql5Constant       SEEK_CUR SEEK_SET SEEK_END
syn keyword     mql5Constant       MODE_GATORJAW MODE_GATORTEETH MODE_GATORLIPS
syn keyword     mql5Constant       CHART_BAR CHART_CANDLE CHART_LINE CHART_WIDTH_IN_BARS CHART_WIDTH_IN_PIXELS CHART_HEIGHT_IN_PIXELS CHART_PRICE_MAX CHART_PRICE_MIN
syn keyword     mql5Constant       MODE_LOW MODE_HIGH MODE_TIME MODE_BID MODE_ASK MODE_POINT MODE_DIGITS MODE_SPREAD MODE_STOPLEVEL MODE_LOTSIZE MODE_TICKVALUE MODE_TICKSIZE MODE_SWAPLONG MODE_SWAPSHORT MODE_STARTING MODE_EXPIRATION MODE_TRADEALLOWED MODE_MINLOT MODE_LOTSTEP MODE_MAXLOT MODE_SWAPTYPE MODE_PROFITCALCMODE MODE_MARGINCALCMODE MODE_MARGININIT MODE_MARGINMAINTENANCE MODE_MARGINHEDGED MODE_MARGINREQUIRED MODE_FREEZELEVEL
syn keyword     mql5Constant       DRAW_LINE DRAW_SECTION DRAW_HISTOGRAM DRAW_ARROW DRAW_ZIGZAG DRAW_NONE
syn keyword     mql5Constant       STYLE_SOLID STYLE_DASH STYLE_DOT STYLE_DASHDOT STYLE_DASHDOTDOT
syn keyword     mql5Constant       SYMBOL_THUMBSUP SYMBOL_THUMBSDOWN SYMBOL_ARROWUP SYMBOL_ARROWDOWN SYMBOL_STOPSIGN SYMBOL_CHECKSIGN
syn keyword     mql5Constant       SYMBOL_LEFTPRICE SYMBOL_RIGHTPRICE
syn keyword     mql5Constant       Black  DarkGreen  DarkSlateGray  Olive  Green  Teal  Navy  Purple Maroon  Indigo  MidnightBlue  DarkBlue  DarkOliveGreen  SaddleBrown  ForestGreen  OliveDrab SeaGreen  DarkGoldenrod  DarkSlateBlue  Sienna  MediumBlue  Brown  DarkTurquoise  DimGray LightSeaGreen  DarkViolet  FireBrick  MediumVioletRed  MediumSeaGreen  Chocolate  Crimson  SteelBlue Goldenrod  MediumSpringGreen  LawnGreen  CadetBlue  DarkOrchid  YellowGreen  LimeGreen  OrangeRed DarkOrange  Orange  Gold  Yellow  Chartreuse  Lime  SpringGreen  Aqua DeepSkyBlue  Blue  Magenta  Red  Gray  SlateGray  Peru  BlueViolet LightSlateGray  DeepPink  MediumTurquoise  DodgerBlue  Turquoise  RoyalBlue  SlateBlue  DarkKhaki IndianRed  MediumOrchid  GreenYellow  MediumAquamarine  DarkSeaGreen  Tomato  RosyBrown  Orchid MediumPurple  PaleVioletRed  Coral  CornflowerBlue  DarkGray  SandyBrown  MediumSlateBlue  Tan DarkSalmon  BurlyWood  HotPink  Salmon  Violet  LightCoral  SkyBlue  LightSalmon Plum  Khaki  LightGreen  Aquamarine  Silver  LightSkyBlue  LightSteelBlue  LightBlue PaleGreen  Thistle  PowderBlue  PaleGoldenrod  PaleTurquoise  LightGray  Wheat  NavajoWhite Moccasin  LightPink  Gainsboro  PeachPuff  Pink  Bisque  LightGoldenrod  BlanchedAlmond LemonChiffon  Beige  AntiqueWhite  PapayaWhip  Cornsilk  LightYellow  LightCyan  Linen Lavender  MistyRose  OldLace  WhiteSmoke  Seashell  Ivory  Honeydew  AliceBlue LavenderBlush  MintCream  Snow  White    
syn keyword     mql5Constant       MODE_MAIN MODE_SIGNAL MODE_PLUSDI MODE_MINUSDI MODE_UPPER MODE_LOWER
syn keyword     mql5Constant       MODE_TENKANSEN MODE_KIJUNSEN MODE_SENKOUSPANA MODE_SENKOUSPANB MODE_CHINKOUSPAN
syn keyword     mql5Constant       MODE_SMA MODE_EMA MODE_SMMA MODE_LWMA
syn keyword     mql5Constant       IDOK IDCANCEL IDABORT IDRETRY IDIGNORE IDYES IDNO IDTRYAGAIN IDCONTINUE
syn keyword     mql5Constant       MB_OK MB_OKCANCEL MB_ABORTRETRYIGNORE MB_YESNOCANCEL MB_YESNO MB_RETRYCANCEL MB_CANCELTRYCONTINUE
syn keyword     mql5Constant       MB_ICONSTOP MB_ICONERROR MB_ICONHAND MB_ICONQUESTION MB_ICONEXCLAMATION MB_ICONWARNING MB_ICONINFORMATION MB_ICONASTERISK
syn keyword     mql5Constant       MB_DEFBUTTON1 MB_DEFBUTTON2 MB_DEFBUTTON3 MB_DEFBUTTON4
syn keyword     mql5Constant       OBJ_VLINE OBJ_HLINE OBJ_TREND OBJ_TRENDBYANGLE OBJ_REGRESSION OBJ_CHANNEL OBJ_STDDEVCHANNEL OBJ_GANNLINE OBJ_GANNFAN OBJ_GANNGRID OBJ_FIBO OBJ_FIBOTIMES OBJ_FIBOFAN OBJ_FIBOARC OBJ_EXPANSION OBJ_FIBOCHANNEL OBJ_RECTANGLE OBJ_TRIANGLE OBJ_ELLIPSE OBJ_PITCHFORK OBJ_CYCLES OBJ_TEXT OBJ_ARROW OBJ_LABEL
syn keyword     mql5Constant       OBJPROP_ANCHOR OBJPROP_TIME1 OBJPROP_PRICE1 OBJPROP_TIME2 OBJPROP_PRICE2 OBJPROP_TIME3 OBJPROP_PRICE3 OBJPROP_COLOR OBJPROP_STYLE OBJPROP_WIDTH OBJPROP_BACK OBJPROP_RAY OBJPROP_ELLIPSE OBJPROP_SCALE OBJPROP_ANGLE OBJPROP_ARROWCODE OBJPROP_TIMEFRAMES OBJPROP_DEVIATION OBJPROP_FONT OBJPROP_FONTSIZE OBJPROP_CORNER OBJPROP_TEXT OBJPROP_XDISTANCE OBJPROP_YDISTANCE OBJPROP_FIBOLEVELS OBJPROP_LEVELCOLOR OBJPROP_LEVELSTYLE OBJPROP_LEVELWIDTH 
syn match       mql5Constant       "OBJPROP_FIRSTLEVEL[0-9]\([^a-z0-9A-Z]\|$\)"
syn match       mql5Constant       "OBJPROP_FIRSTLEVEL[1-2][0-9]\([^a-z0-9A-Z]\|$\)"
syn match       mql5Constant       "OBJPROP_FIRSTLEVEL3[01]\([^a-z0-9A-Z]\|$\)"
syn keyword     mql5Constant       OBJ_PERIOD_M1 OBJ_PERIOD_M5 OBJ_PERIOD_M15 OBJ_PERIOD_M30 OBJ_PERIOD_H1 OBJ_PERIOD_H4 OBJ_PERIOD_D1 OBJ_PERIOD_W1 OBJ_PERIOD_MN1 OBJ_ALL_PERIODS NULL EMPTY
syn keyword     mql5Constant       REASON_REMOVE REASON_RECOMPILE REASON_CHARTCHANGE REASON_CHARTCLOSE REASON_PARAMETERS REASON_ACCOUNT
syn keyword     mql5Constant       NULL EMPTY EMPTY_VALUE CLR_NONE WHOLE_ARRAY
syn keyword     mql5Constant       ERR_NO_ERROR ERR_NO_RESULT ERR_COMMON_ERROR ERR_INVALID_TRADE_PARAMETERS ERR_SERVER_BUSY ERR_OLD_VERSION ERR_NO_CONNECTION ERR_NOT_ENOUGH_RIGHTS ERR_TOO_FREQUENT_REQUESTS ERR_MALFUNCTIONAL_TRADE ERR_ACCOUNT_DISABLED ERR_INVALID_ACCOUNT ERR_TRADE_TIMEOUT ERR_INVALID_PRICE ERR_INVALID_STOPS ERR_INVALID_TRADE_VOLUME ERR_MARKET_CLOSED ERR_TRADE_DISABLED ERR_NOT_ENOUGH_MONEY ERR_PRICE_CHANGED ERR_OFF_QUOTES ERR_BROKER_BUSY ERR_REQUOTE ERR_ORDER_LOCKED ERR_LONG_POSITIONS_ONLY_ALLOWED ERR_TOO_MANY_REQUESTS ERR_TRADE_MODIFY_DENIED ERR_TRADE_CONTEXT_BUSY ERR_TRADE_EXPIRATION_DENIED ERR_TRADE_TOO_MANY_ORDERS ERR_TRADE_HEDGE_PROHIBITED ERR_TRADE_PROHIBITED_BY_FIFO
syn keyword     mql5Constant       ERR_NO_MQLERROR ERR_WRONG_FUNCTION_POINTER ERR_ARRAY_INDEX_OUT_OF_RANGE ERR_NO_MEMORY_FOR_CALL_STACK ERR_RECURSIVE_STACK_OVERFLOW ERR_NOT_ENOUGH_STACK_FOR_PARAM ERR_NO_MEMORY_FOR_PARAM_STRING ERR_NO_MEMORY_FOR_TEMP_STRING ERR_NOT_INITIALIZED_STRING ERR_NOT_INITIALIZED_ARRAYSTRING ERR_NO_MEMORY_FOR_ARRAYSTRING ERR_TOO_LONG_STRING ERR_REMAINDER_FROM_ZERO_DIVIDE ERR_ZERO_DIVIDE ERR_UNKNOWN_COMMAND ERR_WRONG_JUMP ERR_NOT_INITIALIZED_ARRAY ERR_DLL_CALLS_NOT_ALLOWED ERR_CANNOT_LOAD_LIBRARY ERR_CANNOT_CALL_FUNCTION ERR_EXTERNAL_CALLS_NOT_ALLOWED ERR_NO_MEMORY_FOR_RETURNED_STR ERR_SYSTEM_BUSY ERR_INVALID_FUNCTION_PARAMSCNT ERR_INVALID_FUNCTION_PARAMVALUE ERR_STRING_FUNCTION_INTERNAL ERR_SOME_ARRAY_ERROR ERR_INCORRECT_SERIESARRAY_USING ERR_CUSTOM_INDICATOR_ERROR ERR_INCOMPATIBLE_ARRAYS ERR_GLOBAL_VARIABLES_PROCESSING ERR_GLOBAL_VARIABLE_NOT_FOUND ERR_FUNC_NOT_ALLOWED_IN_TESTING ERR_FUNCTION_NOT_CONFIRMED ERR_SEND_MAIL_ERROR ERR_STRING_PARAMETER_EXPECTED ERR_INTEGER_PARAMETER_EXPECTED ERR_DOUBLE_PARAMETER_EXPECTED ERR_ARRAY_AS_PARAMETER_EXPECTED ERR_HISTORY_WILL_UPDATED ERR_TRADE_ERROR ERR_END_OF_FILE ERR_SOME_FILE_ERROR ERR_WRONG_FILE_NAME ERR_TOO_MANY_OPENED_FILES ERR_CANNOT_OPEN_FILE ERR_INCOMPATIBLE_FILEACCESS ERR_NO_ORDER_SELECTED ERR_UNKNOWN_SYMBOL ERR_INVALID_PRICE_PARAM ERR_INVALID_TICKET ERR_TRADE_NOT_ALLOWED ERR_LONGS_NOT_ALLOWED ERR_SHORTS_NOT_ALLOWED ERR_OBJECT_ALREADY_EXISTS ERR_UNKNOWN_OBJECT_PROPERTY ERR_OBJECT_DOES_NOT_EXIST ERR_UNKNOWN_OBJECT_TYPE ERR_NO_OBJECT_NAME ERR_OBJECT_COORDINATES_ERROR ERR_NO_SPECIFIED_SUBWINDOW ERR_SOME_OBJECT_ERROR
syn keyword     mql5Constant       ENUM_LINE_STYLE
syn keyword     mql5Variable       Ask Bars Bid Digits Point 
syn keyword     mql5Series         Close High Low Open Time Volume
syn keyword     mql5Function       AccountBalance AccountCredit AccountCompany AccountCurrency AccountEquity AccountFreeMargin AccountFreeMarginCheck AccountFreeMarginMode AccountLeverage AccountMargin AccountName AccountNumber AccountProfit AccountServer AccountStopoutLevel AccountStopoutMode
syn keyword     mql5Function       ArrayBsearch ArrayCopy ArrayCopyRates ArrayCopySeries ArrayDimension ArrayGetAsSeries ArrayInitialize ArrayIsSeries ArrayMaximum ArrayMinimum ArrayRange ArrayResize ArraySetAsSeries ArraySize ArraySort
syn keyword     mql5Function       GetLastError IsConnected IsDemo IsDllsAllowed IsExpertEnabled IsLibrariesAllowed IsOptimization IsStopped IsTesting IsTradeAllowed IsTradeContextBusy IsVisualMode UninitializeReason
syn keyword     mql5Function       TerminalCompany TerminalName TerminalPath
syn keyword     mql5Function       Alert Comment GetTickCount MarketInfo MessageBox PlaySound Print SendFTP SendMail SendNotification Sleep
syn keyword     mql5Function       CharToString CharDoubleToString IntegerToString TimeToString
syn keyword     mql5Function       StringToDouble StringToInteger StringToTime
syn keyword     mql5Function       NormalizeDouble
syn keyword     mql5Function       IndicatorBuffers IndicatorCounted IndicatorDigits IndicatorShortName SetIndexArrow SetIndexBuffer SetIndexDrawBegin SetIndexEmptyValue SetIndexLabel SetIndexShift SetIndexStyle SetLevelStyle SetLevelValue
syn keyword     mql5Function       Day DayOfWeek DayOfYear Hour Minute Month Seconds TimeCurrent TimeDay TimeDayOfWeek TimeDayOfYear TimeHour TimeLocal TimeMinute TimeMonth TimeSeconds TimeYear Year
syn keyword     mql5Function       FileClose FileDelete FileFlush FileIsEnding FileIsLineEnding FileOpen FileOpenHistory FileReadArray FileReadDouble FileReadInteger FileReadNumber FileReadString FileSeek FileSize FileTell FileWrite FileWriteArray FileWriteDouble FileWriteInteger FileWriteString
syn keyword     mql5Function       GlobalVariableCheck GlobalVariableDel GlobalVariableGet GlobalVariableName GlobalVariableSet GlobalVariableSetOnCondition GlobalVariablesDeleteAll GlobalVariablesTotal
syn keyword     mql5Function       MathAbs MathArccos MathArcsin MathArctan MathCeil MathCos MathExp MathFloor MathLog MathMax MathMin MathMod MathPow MathRand MathRound MathSin MathSqrt MathSrand MathTan
syn keyword     mql5Function       ObjectCreate ObjectDelete ObjectDescription ObjectFind ObjectGet ObjectGetFiboDescription ObjectGetShiftByValue ObjectGetValueByShift ObjectMove ObjectName ObjectsDeleteAll ObjectSet ObjectSetFiboDescription ObjectSetInteger ObjectSetString ObjectSetText ObjectsTotal ObjectType 
syn keyword     mql5Function       StringConcatenate StringFind StringGetChar StringLen StringSetChar StringSubstr StringTrimLeft StringTrimRight
syn keyword     mql5Function       iAC iAD iAlligator iADX iATR iAO iBearsPower iBands iBandsOnArray iBullsPower iCCI iCCIOnArray iCustom iDeMarker iEnvelopes iEnvelopesOnArray iForce iFractals iGator iIchimoku iBWMFI iMomentum iMomentumOnArray iMFI iMA iMAOnArray iOsMA iMACD iOBV iSAR iRSI iRSIOnArray iRVI iStdDev iStdDevOnArray iStochastic iWPR
syn keyword     mql5Function       iBars iBarShift iClose iHigh iHighest iLow iLowest iOpen iTime iVolume
syn keyword     mql5Function       OrderClose OrderCloseBy OrderClosePrice OrderCloseTime OrderComment OrderCommission OrderDelete OrderExpiration OrderLots OrderMagimql5Number OrderModify OrderOpenPrice OrderOpenTime OrderPrint OrderProfit OrderSelect OrderSend OrdersHistoryTotal OrderStopLoss OrdersTotal OrderSwap OrderSymbol OrderTakeProfit OrderTicket OrderType
syn keyword     mql5Function       PositionsTotal
syn keyword     mql5Function       HideTestIndicators Period RefreshRates Symbol WindowBarsPerChart WindowExpertName WindowFind WindowFirstVisibleBar WindowHandle WindowIsVisible WindowOnDropped WindowPriceMax WindowPriceMin WindowPriceOnDropped WindowRedraw WindowScreenShot WindowTimeOnDropped WindowsTotal WindowXOnDropped WindowYOnDropped
syn keyword     mql5Obsolete      BarsPerWindow ClientTerminalName CurTime CompanyName FirstVisibleBar Highest HistoryTotal LocalTime Lowest ObjectsRedraw PriceOnDropped ScreenShot ServerAddress TimeOnDropped       

" Accept %: for # (C99)
syn region      mql5PreCondit      start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$"  keepend contains=mql5Comment,mql5CommentL,mql5CppString,mql5Character,mql5CppParen,mql5ParenError,mql5Numbers,mql5CommentError,mql5SpaceError
syn match mql5PreCondit display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  if !exists("c_no_if0_fold")
    syn region mql5CppOut  start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=mql5CppOut2 fold
  else
    syn region mql5CppOut  start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=mql5CppOut2
  endif
  syn region mql5CppOut2 contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=mql5SpaceError,mql5CppSkip
  syn region mql5CppSkip contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=mql5SpaceError,mql5CppSkip
endif
syn region mql5Included display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match mql5Included display contained "<[^>]*>"
syn match mql5Include display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=mql5Included
"syn match mql5LineSkip "\\$"
syn cluster mql5PreProcGroup contains=mql5PreCondit,mql5Included,mql5Include,mql5Define,mql5ErrInParen,mql5ErrInBracket,mql5UserLabel,mql5Special,mql5OctalZero,mql5CppOut,mql5CppOut2,mql5CppSkip,mql5Format,mql5Number,mql5Float,mql5Octal,mql5OctalError,mql5NumbersCom,mql5String,mql5CommentSkip,mql5CommentString,mql5Comment2String,@mql5CommentGroup,mql5CommentStartError,mql5Paren,mql5Bracket,mql5Multi
syn region mql5Define  start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@mql5PreProcGroup,@Spell
syn region mql5PreProc start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@mql5PreProcGroup,@Spell

" Highlight User Labels
syn cluster mql5MultiGroup contains=mql5Included,mql5Special,mql5CommentSkip,mql5CommentString,mql5Comment2String,@mql5CommentGroup,mql5CommentStartError,mql5UserCont,mql5UserLabel,mql5BitField,mql5OctalZero,mql5CppOut,mql5CppOut2,mql5CppSkip,mql5Format,mql5Number,mql5Float,mql5Octal,mql5OctalError,mql5NumbersCom,mql5CppParen,mql5CppBracket,mql5CppString
syn region mql5Multi  transparent start='?' skip='::' end=':' contains=ALLBUT,@mql5MultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster mql5LabelGroup contains=mql5UserLabel
syn match mql5UserCont display "^\s*\I\i*\s*:$" contains=@mql5LabelGroup
syn match mql5UserCont display ";\s*\I\i*\s*:$" contains=@mql5LabelGroup
syn match mql5UserCont display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@mql5LabelGroup
syn match mql5UserCont display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@mql5LabelGroup

syn match mql5UserLabel display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match mql5BitField display "^\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=mql5Type
syn match mql5BitField display ";\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=mql5Type

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50 " #if 0 constructs can be long
  else
    let b:c_minlines = 15 " mostly for () constructs
  endif
endif
if exists("c_curly_error")
  syn sync fromstart
else
  exec "syn sync ccomment mql5Comment minlines=" . b:c_minlines
endif

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link mql5Format mql5Special
hi def link mql5CppString mql5String
hi def link mql5CommentL mql5Comment
hi def link mql5CommentStart mql5Comment
hi def link mql5Label Label
hi def link mql5OO Label
hi def link mql5UserLabel Label
hi def link mql5Conditional Conditional
hi def link mql5Repeat Repeat
hi def link mql5Character Character
hi def link mql5SpecialCharacter mql5Special
hi def link mql5Number Number
hi def link mql5Octal Number
hi def link mql5OctalZero PreProc " link this to Error if you want
hi def link mql5Float Float
hi def link mql5OctalError mql5Error
hi def link mql5ParenError mql5Error
hi def link mql5ErrInParen mql5Error
hi def link mql5ErrInBracket mql5Error
hi def link mql5CommentError mql5Error
hi def link mql5CommentStartError mql5Error
hi def link mql5SpaceError mql5Error
hi def link mql5SpecialError mql5Error
hi def link mql5CurlyError mql5Error
hi def link mql5Operator Operator
hi def link mql5Structure Structure
hi def link mql5StorageClass StorageClass
hi def link mql5Include Include
hi def link mql5PreProc PreProc
hi def link mql5Define Macro
hi def link mql5Included mql5String
hi def link mql5Error Error
hi def link mql5Statement Statement
hi def link mql5PreCondit PreCondit
hi def link mql5Type Type
hi def link mql5Class Type
hi def link mql5Constant Constant
hi def link mql5Variable Constant
hi def link mql5Series Constant
hi def link mql5Function Structure
hi def link mql5Obsolete Error
hi def link mql5CommentString mql5String
hi def link mql5Comment2String mql5String
hi def link mql5CommentSkip mql5Comment
hi def link mql5String String
hi def link mql5Comment Comment
hi def link mql5Special SpecialChar
hi def link mql5Todo Todo
hi def link mql5BadContinuation Error
hi def link mql5CppSkip mql5CppOut
hi def link mql5CppOut2 mql5CppOut
hi def link mql5CppOut Comment

let b:current_syntax = "c"

" vim: ts=8
