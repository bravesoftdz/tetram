unit ICUNumberFormatter;

interface

uses
  System.SysUtils, System.Classes, unum, uloc, utypes;

type
  IICUNumberFormatter = interface
    ['{C2ED51B4-E33B-4982-AA41-A329EE34BF10}']
    function Format(Value: Int32): string; overload;
    function Format(Value: Int64): string; overload;
    function Format(Value: Double): string; overload;
    function Format(Value: Double; CurrencyCode: string): string; overload;
    // function getAttribute(Attr: int): int;
    function GetErrorCode: UErrorCode;
    function GetErrorMessage: string;
    function GetLocale(aType: ULocDataLocaleType = ULOC_ACTUAL_LOCALE): string;
    function GetSymbol(Symbol: UNumberFormatSymbol): string;
    // function setSymbol(int $A ttr, string$ value): bool;
    // function getTextAttribute(int $A ttr): string;
    // function parseCurrency(string$ value, string & $C urrency[, int & $ position]): float;
    // function parse(string$ value[, int $ type [, int & $ position]]): mixed;
    // function setAttribute(int $A ttr, int $ value): bool;
    function GetPattern: string;
    procedure SetPattern(const Pattern: string);
    // function setTextAttribute(int $A ttr, string$ value): bool;
  end;

  TICUNumberFormatter = class(TInterfacedObject, IICUNumberFormatter)
  private
    FFormat: PUNumberFormat;
    FStatus: UErrorCode;
    FLocale: AnsiString;
    FPattern: string;
    FStyle: UNumberFormatStyle;

    procedure BuildFormatter;
    procedure ReleaseFormatter;

    function Format(Value: Int32): string; overload;
    function Format(Value: Int64): string; overload;
    function Format(Value: Double): string; overload;
    function Format(Value: Double; CurrencyCode: string): string; overload;

    function GetSymbol(Symbol: UNumberFormatSymbol): string;
    function GetCurrencyCode: AnsiString;
    function GetLocale(aType: ULocDataLocaleType = ULOC_ACTUAL_LOCALE): string;
    procedure SetLocale(const Value: AnsiString);
    procedure SetPattern(const Value: string);
    procedure SetStyle(const Value: UNumberFormatStyle);
    function GetPattern: string;

    function GetErrorCode: UErrorCode;
    function GetErrorMessage: string;
  public
    constructor Create(Locale: AnsiString; Style: UNumberFormatStyle; Pattern: string = '');
    destructor Destroy; override;

    property Locale: AnsiString read FLocale write SetLocale;
    property Style: UNumberFormatStyle read FStyle write SetStyle;
    property Pattern: string read GetPattern write SetPattern;

    property CurrencyCode: AnsiString read GetCurrencyCode;
  end;

implementation

uses
  icu_globals;

const
  DEFAULT_BUFFER_SIZE = 256;

  { TICUNumberFormat }

procedure TICUNumberFormatter.BuildFormatter;
var
  unumStatus: UErrorCode;
begin
  if not(IsICULoaded or LoadICU) then
    raise Exception.Create('Impossible de charger ICU');

  if FFormat <> nil then
    ReleaseFormatter;

  unumStatus := U_ZERO_ERROR;
  FFormat := UnumOpen(Style, nil, 0, PAnsiChar(Locale), nil, unumStatus);
end;

constructor TICUNumberFormatter.Create(Locale: AnsiString; Style: UNumberFormatStyle; Pattern: string = '');
begin
  FLocale := Locale;
  FStyle := Style;
  FPattern := Pattern;
  BuildFormatter;
end;

destructor TICUNumberFormatter.Destroy;
begin

  inherited;
end;

function TICUNumberFormatter.Format(Value: Double; CurrencyCode: string): string;
var
  buffer: WideString;
  bufNeeded: Int32;
begin
  FStatus := U_ZERO_ERROR;
  bufNeeded := DEFAULT_BUFFER_SIZE;
  SetLength(buffer, bufNeeded);
  bufNeeded := UnumFormatDoubleCurrency(FFormat, Value, @WideString(CurrencyCode)[1], @buffer[1], bufNeeded, nil, FStatus);
  if FStatus = U_BUFFER_OVERFLOW_ERROR then
  begin
    SetLength(buffer, bufNeeded);
    FStatus := U_ZERO_ERROR;
    bufNeeded := UnumFormatDoubleCurrency(FFormat, Value, @WideString(CurrencyCode)[1], @buffer[1], bufNeeded, nil, FStatus);
  end;

  SetLength(buffer, bufNeeded);
  Result := buffer;
end;

function TICUNumberFormatter.Format(Value: Double): string;
var
  buffer: WideString;
  bufNeeded: Int32;
begin
  FStatus := U_ZERO_ERROR;
  bufNeeded := DEFAULT_BUFFER_SIZE;
  SetLength(buffer, bufNeeded);
  bufNeeded := UnumFormatDouble(FFormat, Value, @buffer[1], bufNeeded, nil, FStatus);
  if FStatus = U_BUFFER_OVERFLOW_ERROR then
  begin
    SetLength(buffer, bufNeeded);
    FStatus := U_ZERO_ERROR;
    bufNeeded := UnumFormatDouble(FFormat, Value, @buffer[1], bufNeeded, nil, FStatus);
  end;

  SetLength(buffer, bufNeeded);
  Result := buffer;
end;

function TICUNumberFormatter.Format(Value: Int32): string;
var
  buffer: WideString;
  bufNeeded: Int32;
begin
  FStatus := U_ZERO_ERROR;
  bufNeeded := DEFAULT_BUFFER_SIZE;
  SetLength(buffer, bufNeeded);
  bufNeeded := UnumFormat(FFormat, Value, @buffer[1], bufNeeded, nil, FStatus);
  if FStatus = U_BUFFER_OVERFLOW_ERROR then
  begin
    SetLength(buffer, bufNeeded);
    FStatus := U_ZERO_ERROR;
    bufNeeded := UnumFormat(FFormat, Value, @buffer[1], bufNeeded, nil, FStatus);
  end;

  SetLength(buffer, bufNeeded);
  Result := buffer;
end;

function TICUNumberFormatter.Format(Value: Int64): string;
var
  buffer: WideString;
  bufNeeded: Int32;
begin
  FStatus := U_ZERO_ERROR;
  bufNeeded := DEFAULT_BUFFER_SIZE;
  SetLength(buffer, bufNeeded);
  bufNeeded := UnumFormatInt64(FFormat, Value, @buffer[1], bufNeeded, nil, FStatus);
  if FStatus = U_BUFFER_OVERFLOW_ERROR then
  begin
    SetLength(buffer, bufNeeded);
    FStatus := U_ZERO_ERROR;
    bufNeeded := UnumFormatInt64(FFormat, Value, @buffer[1], bufNeeded, nil, FStatus);
  end;

  SetLength(buffer, bufNeeded);
  Result := buffer;
end;

function TICUNumberFormatter.GetCurrencyCode: AnsiString;
begin
  Result := GetSymbol(UNUM_INTL_CURRENCY_SYMBOL);
end;

function TICUNumberFormatter.GetErrorCode: UErrorCode;
begin
  Result := FStatus;
end;

function TICUNumberFormatter.GetErrorMessage: string;
begin
  Result := u_errorName(FStatus);
end;

function TICUNumberFormatter.GetLocale(aType: ULocDataLocaleType): string;
begin
  FStatus := U_ZERO_ERROR;
  Result := UnumGetLocaleByType(FFormat, aType, FStatus);
end;

function TICUNumberFormatter.GetPattern: string;
begin
  Result := FPattern;
end;

procedure TICUNumberFormatter.ReleaseFormatter;
begin
  UnumClose(FFormat);
  FFormat := nil;
end;

procedure TICUNumberFormatter.SetLocale(const Value: AnsiString);
begin
  FLocale := Value;
  BuildFormatter;
end;

procedure TICUNumberFormatter.SetPattern(const Value: string);
begin
  FPattern := Value;
  BuildFormatter;
end;

procedure TICUNumberFormatter.SetStyle(const Value: UNumberFormatStyle);
begin
  FStyle := Value;
  BuildFormatter;
end;

function TICUNumberFormatter.GetSymbol(Symbol: UNumberFormatSymbol): string;
var
  buffer: WideString;
  bufNeeded: Int32;
begin
  FStatus := U_ZERO_ERROR;
  // à priori, le symbole le plus long est le code monétaire internationnal (3)
  // tous les autres sont à 1 (sauf pour UNUM_FORMAT_SYMBOL_COUNT mais il demande un traitement spécial)
  bufNeeded := 3;
  SetLength(buffer, bufNeeded);
  bufNeeded := UnumGetSymbol(FFormat, Symbol, @buffer[1], bufNeeded, FStatus);
  if FStatus = U_BUFFER_OVERFLOW_ERROR then
  begin
    SetLength(buffer, bufNeeded);
    FStatus := U_ZERO_ERROR;
    bufNeeded := UnumGetSymbol(FFormat, Symbol, @buffer[1], bufNeeded, FStatus);
  end;

  SetLength(buffer, bufNeeded);
  Result := buffer;
end;

initialization

finalization

UnloadICU;

end.
