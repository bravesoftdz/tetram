﻿unit _utypes;

{$I icu.inc}

interface

uses
  icu_globals, System.Math;

type
  // Date and Time data type.
  UDate = record
  private
    Value: Double;
  public
    class operator Implicit(Value: Double): UDate;
    class operator Implicit(Value: TDateTime): UDate;
    class operator Implicit(Value: UDate): Double;
    class operator Implicit(Value: UDate): TDateTime;
  end;

const
  U_MILLIS_PER_SECOND = 1000;
  U_MILLIS_PER_MINUTE = 60000;
  U_MILLIS_PER_HOUR = 3600000;
  U_MILLIS_PER_DAY = 86400000;
  U_DATE_MAX = MaxDouble;
  U_DATE_MIN = -U_DATE_MAX;

type
  // Error code to replace exception handling, so that the code is compatible with all C++ compilers, and to use the same mechanism for C and C++.
  PUErrorCode = ^UErrorCode;
  UErrorCode = (
    U_USING_FALLBACK_WARNING = -128,
    U_ERROR_WARNING_START = -128,
    U_USING_DEFAULT_WARNING = -127,
    U_SAFECLONE_ALLOCATED_WARNING = -126,
    U_STATE_OLD_WARNING = -125,
    U_STRING_NOT_TERMINATED_WARNING = -124,
    U_SORT_KEY_TOO_SHORT_WARNING = -123,
    U_AMBIGUOUS_ALIAS_WARNING = -122,
    U_DIFFERENT_UCA_VERSION = -121,
    U_PLUGIN_CHANGED_LEVEL_WARNING = -120,
    U_ERROR_WARNING_LIMIT,
    U_ZERO_ERROR = 0,
    U_ILLEGAL_ARGUMENT_ERROR = 1,
    U_MISSING_RESOURCE_ERROR = 2,
    U_INVALID_FORMAT_ERROR = 3,
    U_FILE_ACCESS_ERROR = 4,
    U_INTERNAL_PROGRAM_ERROR = 5,
    U_MESSAGE_PARSE_ERROR = 6,
    U_MEMORY_ALLOCATION_ERROR = 7,
    U_INDEX_OUTOFBOUNDS_ERROR = 8,
    U_PARSE_ERROR = 9,
    U_INVALID_CHAR_FOUND = 10,
    U_TRUNCATED_CHAR_FOUND = 11,
    U_ILLEGAL_CHAR_FOUND = 12,
    U_INVALID_TABLE_FORMAT = 13,
    U_INVALID_TABLE_FILE = 14,
    U_BUFFER_OVERFLOW_ERROR = 15,
    U_UNSUPPORTED_ERROR = 16,
    U_RESOURCE_TYPE_MISMATCH = 17,
    U_ILLEGAL_ESCAPE_SEQUENCE = 18,
    U_UNSUPPORTED_ESCAPE_SEQUENCE = 19,
    U_NO_SPACE_AVAILABLE = 20,
    U_CE_NOT_FOUND_ERROR = 21,
    U_PRIMARY_TOO_LONG_ERROR = 22,
    U_STATE_TOO_OLD_ERROR = 23,
    U_TOO_MANY_ALIASES_ERROR = 24,
    U_ENUM_OUT_OF_SYNC_ERROR = 25,
    U_INVARIANT_CONVERSION_ERROR = 26,
    U_INVALID_STATE_ERROR = 27,
    U_COLLATOR_VERSION_MISMATCH = 28,
    U_USELESS_COLLATOR_ERROR = 29,
    U_NO_WRITE_PERMISSION = 30,
    U_STANDARD_ERROR_LIMIT,

    // the error code range 0x10000 0x10100 are reserved for Transliterator
    U_BAD_VARIABLE_DEFINITION = $10000,
    U_PARSE_ERROR_START = $10000,
    U_MALFORMED_RULE,
    U_MALFORMED_SET,
    U_MALFORMED_SYMBOL_REFERENCE,
    U_MALFORMED_UNICODE_ESCAPE,
    U_MALFORMED_VARIABLE_DEFINITION,
    U_MALFORMED_VARIABLE_REFERENCE,
    U_MISMATCHED_SEGMENT_DELIMITERS,
    U_MISPLACED_ANCHOR_START,
    U_MISPLACED_CURSOR_OFFSET,
    U_MISPLACED_QUANTIFIER,
    U_MISSING_OPERATOR,
    U_MISSING_SEGMENT_CLOSE,
    U_MULTIPLE_ANTE_CONTEXTS,
    U_MULTIPLE_CURSORS,
    U_MULTIPLE_POST_CONTEXTS,
    U_TRAILING_BACKSLASH,
    U_UNDEFINED_SEGMENT_REFERENCE,
    U_UNDEFINED_VARIABLE,
    U_UNQUOTED_SPECIAL,
    U_UNTERMINATED_QUOTE,
    U_RULE_MASK_ERROR,
    U_MISPLACED_COMPOUND_FILTER,
    U_MULTIPLE_COMPOUND_FILTERS,
    U_INVALID_RBT_SYNTAX,
    U_INVALID_PROPERTY_PATTERN,
    U_MALFORMED_PRAGMA,
    U_UNCLOSED_SEGMENT,
    U_ILLEGAL_CHAR_IN_SEGMENT,
    U_VARIABLE_RANGE_EXHAUSTED,
    U_VARIABLE_RANGE_OVERLAP,
    U_ILLEGAL_CHARACTER,
    U_INTERNAL_TRANSLITERATOR_ERROR,
    U_INVALID_ID,
    U_INVALID_FUNCTION,
    U_PARSE_ERROR_LIMIT,

    // the error code range 0x10100 0x10200 are reserved for formatting API parsing error
    U_UNEXPECTED_TOKEN = $10100,
    U_FMT_PARSE_ERROR_START = $10100,
    U_MULTIPLE_DECIMAL_SEPARATORS,
    U_MULTIPLE_DECIMAL_SEPERATORS = U_MULTIPLE_DECIMAL_SEPARATORS,
    U_MULTIPLE_EXPONENTIAL_SYMBOLS,
    U_MALFORMED_EXPONENTIAL_PATTERN,
    U_MULTIPLE_PERCENT_SYMBOLS,
    U_MULTIPLE_PERMILL_SYMBOLS,
    U_MULTIPLE_PAD_SPECIFIERS,
    U_PATTERN_SYNTAX_ERROR,
    U_ILLEGAL_PAD_POSITION,
    U_UNMATCHED_BRACES,
    U_UNSUPPORTED_PROPERTY,
    U_UNSUPPORTED_ATTRIBUTE,
    U_ARGUMENT_TYPE_MISMATCH,
    U_DUPLICATE_KEYWORD,
    U_UNDEFINED_KEYWORD,
    U_DEFAULT_KEYWORD_MISSING,
    U_DECIMAL_NUMBER_SYNTAX_ERROR,
    U_FORMAT_INEXACT_ERROR,
    U_FMT_PARSE_ERROR_LIMIT,

    // the error code range 0x10200 0x102ff are reserved for Break Iterator related error
    U_BRK_INTERNAL_ERROR = $10200,
    U_BRK_ERROR_START = $10200,
    U_BRK_HEX_DIGITS_EXPECTED,
    U_BRK_SEMICOLON_EXPECTED,
    U_BRK_RULE_SYNTAX,
    U_BRK_UNCLOSED_SET,
    U_BRK_ASSIGN_ERROR,
    U_BRK_VARIABLE_REDFINITION,
    U_BRK_MISMATCHED_PAREN,
    U_BRK_NEW_LINE_IN_QUOTED_STRING,
    U_BRK_UNDEFINED_VARIABLE,
    U_BRK_INIT_ERROR,
    U_BRK_RULE_EMPTY_SET,
    U_BRK_UNRECOGNIZED_OPTION,
    U_BRK_MALFORMED_RULE_TAG,
    U_BRK_ERROR_LIMIT,

    // The error codes in the range 0x10300-0x103ff are reserved for regular expression related errrs
    U_REGEX_INTERNAL_ERROR = $10300,
    U_REGEX_ERROR_START = $10300,
    U_REGEX_RULE_SYNTAX,
    U_REGEX_INVALID_STATE,
    U_REGEX_BAD_ESCAPE_SEQUENCE,
    U_REGEX_PROPERTY_SYNTAX,
    U_REGEX_UNIMPLEMENTED,
    U_REGEX_MISMATCHED_PAREN,
    U_REGEX_NUMBER_TOO_BIG,
    U_REGEX_BAD_INTERVAL,
    U_REGEX_MAX_LT_MIN,
    U_REGEX_INVALID_BACK_REF,
    U_REGEX_INVALID_FLAG,
    U_REGEX_LOOK_BEHIND_LIMIT,
    U_REGEX_SET_CONTAINS_STRING,
    U_REGEX_OCTAL_TOO_BIG,
    U_REGEX_MISSING_CLOSE_BRACKET,
    U_REGEX_INVALID_RANGE,
    U_REGEX_STACK_OVERFLOW,
    U_REGEX_TIME_OUT,
    U_REGEX_STOPPED_BY_CALLER,
    U_REGEX_ERROR_LIMIT,

    // The error code in the range 0x10400-0x104ff are reserved for IDNA related error codes
    U_IDNA_PROHIBITED_ERROR = $10400,
    U_IDNA_ERROR_START = $10400,
    U_IDNA_UNASSIGNED_ERROR,
    U_IDNA_CHECK_BIDI_ERROR,
    U_IDNA_STD3_ASCII_RULES_ERROR,
    U_IDNA_ACE_PREFIX_ERROR,
    U_IDNA_VERIFICATION_ERROR,
    U_IDNA_LABEL_TOO_LONG_ERROR,
    U_IDNA_ZERO_LENGTH_LABEL_ERROR,
    U_IDNA_DOMAIN_NAME_TOO_LONG_ERROR,
    U_IDNA_ERROR_LIMIT,

    // Aliases for StringPrep
    U_STRINGPREP_PROHIBITED_ERROR = U_IDNA_PROHIBITED_ERROR,
    U_STRINGPREP_UNASSIGNED_ERROR = U_IDNA_UNASSIGNED_ERROR,
    U_STRINGPREP_CHECK_BIDI_ERROR = U_IDNA_CHECK_BIDI_ERROR,

    // The error code in the range 0x10500-0x105ff are reserved for Plugin related error codes
    U_PLUGIN_ERROR_START = $10500,
    U_PLUGIN_TOO_HIGH = $10500,
    U_PLUGIN_DIDNT_SET_LEVEL,
    U_PLUGIN_ERROR_LIMIT,
    U_ERROR_LIMIT =
    U_PLUGIN_ERROR_LIMIT);

function U_SUCCESS(code: UErrorCode): Boolean; inline;
function U_FAILURE(code: UErrorCode): Boolean; inline;
procedure ICUCheck(code: UErrorCode); inline;
procedure ResetErrorCode(var code: UErrorCode); inline;

{$IFDEF ICU_LINKONREQUEST}

type
  TUErrorNameFunc = function(code: UErrorCode): PAnsiChar; cdecl;

var
  u_errorName: TUErrorNameFunc = nil;
{$ELSE ~ICU_LINKONREQUEST}
function u_errorName(code: UErrorCode): PAnsiChar; cdecl;
{$ENDIF ~ICU_LINKONREQUEST}

const
  u_errorNameDefaultExportName = 'u_errorName' + ICU_DEFAULT_EXPORT_SUFFIX;

{$IFDEF ICU_LINKONREQUEST}

var
  u_errorNameExportName: string = u_errorNameDefaultExportName;
{$ENDIF ~ICU_LINKONREQUEST}

type
  TICUObject = class
  protected
    FStatus: UErrorCode;
  public
    function GetErrorCode: UErrorCode;
    function GetErrorMessage: AnsiString;
  end;

implementation

uses
  _umachine, Winapi.Windows, System.SysUtils;

function U_SUCCESS(code: UErrorCode): Boolean;
begin
  Result := (code <= U_ZERO_ERROR);
end;

function U_FAILURE(code: UErrorCode): Boolean;
begin
  Result := (code > U_ZERO_ERROR);
end;

procedure ICUCheck(code: UErrorCode);
begin
  if U_FAILURE(code) then
    raise Exception.Create(string(u_errorName(code)));
end;

procedure ResetErrorCode(var code: UErrorCode);
begin
  code := U_ZERO_ERROR;
end;

{ TICUObject }

function TICUObject.GetErrorCode: UErrorCode;
begin
  Result := FStatus;
end;

function TICUObject.GetErrorMessage: AnsiString;
begin
  Result := u_errorName(FStatus);
end;

{ UDate }

class operator UDate.Implicit(Value: TDateTime): UDate;
begin
  Result.Value := (Value - UnixDateDelta) * MSecsPerDay;
end;

class operator UDate.Implicit(Value: Double): UDate;
begin
  Result.Value := Value;
end;

class operator UDate.Implicit(Value: UDate): TDateTime;
begin
  Result := (Value.Value / MSecsPerDay) + UnixDateDelta;
end;

class operator UDate.Implicit(Value: UDate): Double;
begin
  Result := Value.Value;
end;

{$IFNDEF ICU_LINKONREQUEST}
function u_errorName; external ICU_DEFAULT_COMMON_MODULE_NAME name u_errorNameDefaultExportName;
{$ELSE ~ICU_LINKONREQUEST}

function LoadICU: Boolean;
begin
  @u_errorName := GetModuleSymbol(ICU_COMMON_LibraryHandle, u_errorNameExportName);
  Result := Assigned(@u_errorName);
end;

procedure UnloadICU;
begin
  @u_errorName := nil;
end;

initialization

RegisterLoadICUProc(LoadICU, UnloadICU);
{$ENDIF ~ICU_LINKONREQUEST}

end.
