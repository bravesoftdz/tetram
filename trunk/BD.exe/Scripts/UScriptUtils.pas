unit UScriptUtils;

interface

uses
  SysUtils, Classes, Graphics, Types, StdCtrls, SynEdit, Controls, VirtualTrees, Contnrs, uPSCompiler, uPSUtils,
  Generics.Collections, Generics.Defaults;

type
  TInfoType = (itProcedure, itFunction, itType, itVar, itConstant, itField, itConstructor);
  TInfoTypes = set of TInfoType;

  TParamInfoRecord = record
    Name: Cardinal;
    OrgName: AnsiString;
    Params: AnsiString;
    OrgParams: AnsiString;
    Father: Cardinal;
    Nr: Integer;
    ReturnTyp: Cardinal;
    Typ: TInfoType;
    HasFields: Boolean;
    SubType: Cardinal;
  end;

  TParamInfoArray = array of TParamInfoRecord;
  TGetScript = function(const Fichier: AnsiString): TSynEdit of object;

  TDebugList<T: class> = class(TObjectList<T>)
  private
    // 27/08/2011: si on met cette variable et la propriété qui va avec dans TBreakpointList,
    // on se paye un écrasement de mémoire entre FGetScript et FView
    // merci Delphi XE !!!
    FGetScript: TGetScript;
    FView: TVirtualStringTree;
    procedure SetView(const Value: TVirtualStringTree);
  protected
    procedure Notify(const Value: T; Action: TCollectionNotification); override;
  public
    destructor Destroy; override;
    procedure Clear; reintroduce;
    procedure UpdateView;
    procedure DeleteCurrent;
    function Current: T;
    function Last: T;
    property View: TVirtualStringTree read FView write SetView;
    property Editor: TGetScript read FGetScript write FGetScript;
  end;

  TBreakpointInfo = class
  private
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    Line: Cardinal;
    Fichier: AnsiString;
    FEditor: TCustomSynEdit;
    destructor Destroy; override;
    property Active: Boolean read FActive write SetActive;
  end;

  TCategoryMessage = (cmInfo, cmCompileError, cmRuntimeError);
  TTypeMessage = (tmUnknown, tmError, tmHint, tmWarning);

  TMessageInfo = class
    Fichier, TypeMessage, Text: AnsiString;
    Line, Char: Cardinal;
    Category: TCategoryMessage;
  end;

  TWatchInfo = class
    Name: AnsiString;
    Active: Boolean;
  end;

  TWatchList = class(TDebugList<TWatchInfo>)
  public
    function IndexOfName(const VarName: AnsiString): Integer;
    function CountActive: Integer;
    procedure AddWatch(const VarName: AnsiString);
  end;

  TMessageList = class(TDebugList<TMessageInfo>)
  public
    function AddCompileErrorMessage(const Fichier, Text: AnsiString; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
    function AddRuntimeErrorMessage(const Fichier, Text: AnsiString; Line, Char: Cardinal): Integer;
    function AddInfoMessage(const Fichier, Text: AnsiString; Line: Cardinal = 0; Char: Cardinal = 0): Integer;
  end;

  TBreakpointList = class(TDebugList<TBreakpointInfo>)
  protected
    procedure Notify(const Value: TBreakpointInfo; Action: TCollectionNotification); override;
  public
    function IndexOf(const Fichier: AnsiString; const ALine: Cardinal): Integer;
    function Exists(const Fichier: AnsiString; const ALine: Cardinal): Boolean;
    procedure AddBreakpoint(const Fichier: AnsiString; const ALine: Cardinal);
    function Toggle(const Fichier: AnsiString; const ALine: Cardinal): Boolean;
  end;

  TDebugInfos = class
  private
    FCurrentLine: Integer;
    FCursorLine: Integer;
    FErrorLine: Integer;

    FBreakpointsList: TBreakpointList;
    FWatchesList: TWatchList;
    FMessagesList: TMessageList;
    function GetScript: TGetScript;
    procedure SetScript(const Value: TGetScript);

  public
    constructor Create;
    destructor Destroy; override;

    property CurrentLine: Integer read FCurrentLine write FCurrentLine;
    property CursorLine: Integer read FCursorLine write FCursorLine;
    property ErrorLine: Integer read FErrorLine write FErrorLine;

    property Breakpoints: TBreakpointList read FBreakpointsList;
    property Watches: TWatchList read FWatchesList;
    property Messages: TMessageList read FMessagesList;

    property OnGetScript: TGetScript read GetScript write SetScript;
  end;

  TStringArray = array of AnsiString;

procedure AddToTStrings(const Strings: TStringArray; List: TStrings);
function Explode(const Trenner: AnsiString; Text: AnsiString): TStringArray;
function GetTypeName(Typ: TPSType): AnsiString;
function GetParams(Decl: TPSParametersDecl; const Delim: AnsiString = ''): AnsiString;
function BaseTypeCompatible(p1, p2: Integer): Boolean;
function HashString(const S: AnsiString): Cardinal;

implementation

uses
  AnsiStrings;

{ TBreakpointList }

function TBreakpointList.IndexOf(const Fichier: AnsiString; const ALine: Cardinal): Integer;
begin
  Result := 0;
  while (Result < Count) and ((Items[Result].Line <> ALine) or not AnsiSameText(Items[Result].Fichier, Fichier)) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

function TBreakpointList.Exists(const Fichier: AnsiString; const ALine: Cardinal): Boolean;
begin
  Result := IndexOf(Fichier, ALine) <> -1;
end;

function TBreakpointList.Toggle(const Fichier: AnsiString; const ALine: Cardinal): Boolean;
var
  i: Integer;
begin
  i := IndexOf(Fichier, ALine);
  if i = -1 then
  begin
    AddBreakpoint(Fichier, ALine);
    Result := True;
  end
  else
  begin
    Delete(i);
    Result := False;
  end;
end;

procedure TBreakpointList.AddBreakpoint(const Fichier: AnsiString; const ALine: Cardinal);
var
  BP: TBreakpointInfo;
begin
  if (IndexOf(Fichier, ALine) = -1) then
  begin
    BP := TBreakpointInfo.Create;
    BP.FEditor := FGetScript(Fichier);
    BP.Line := ALine;
    BP.Fichier := Fichier;
    BP.Active := True;
    Add(BP);
  end;
end;

procedure TBreakpointList.Notify(const Value: TBreakpointInfo; Action: TCollectionNotification);
var
  Editor: TCustomSynEdit;
begin
  inherited;
  case Action of
    cnAdded, cnExtracted:
    begin
      //Editor.InvalidateLine(TBreakpointInfo(Ptr).Line);
      //Editor.InvalidateGutterLine(TBreakpointInfo(Ptr).Line);
      // InvalidateLine et InvalidateGutterLine bizarrement insuffisants dans certains cas
      Editor := FGetScript(Value.Fichier);
      if Assigned(Editor) then Editor.Invalidate;
    end;
    cnRemoved:
      ;
  end;
  if Action = cnAdded then
    Sort(TComparer<TBreakpointInfo>.Construct(
      function(const Left, Right: TBreakpointInfo): Integer
      begin
        Result := CompareText(Left.Fichier, Right.Fichier);
        if Result = 0 then
          Result := Left.Line - Right.Line;
      end
    ));
end;

{ TDebugInfos }

constructor TDebugInfos.Create;
begin
  inherited;
  FBreakpointsList := TBreakpointList.Create(True);
  FWatchesList := TWatchList.Create(True);
  FMessagesList := TMessageList.Create(True);
end;

destructor TDebugInfos.Destroy;
begin
  FBreakpointsList.Free;
  FWatchesList.Free;
  FMessagesList.Free;
  inherited;
end;

function TDebugInfos.GetScript: TGetScript;
begin
  Result := FBreakpointsList.FGetScript;
end;

procedure TDebugInfos.SetScript(const Value: TGetScript);
begin
  FBreakpointsList.FGetScript := Value;
end;

{ TDebugList }

procedure TDebugList<T>.Clear;
begin
  if Assigned(FView) then
    FView.BeginUpdate;
  try
    inherited;
  finally
    UpdateView;
    if Assigned(FView) then
      FView.EndUpdate;
  end;
end;

function TDebugList<T>.Current: T;
begin
  Result := nil;
  if not Assigned(FView) or (FView.GetFirstSelected = nil) then
    Exit;
  Result := Items[FView.GetFirstSelected.Index];
end;

procedure TDebugList<T>.DeleteCurrent;
begin
  if Assigned(FView) then
  begin
    Delete(FView.GetFirstSelected.Index);
    UpdateView;
  end;
end;

destructor TDebugList<T>.Destroy;
begin
  SetView(nil);
  inherited;
end;

function TDebugList<T>.Last: T;
begin
  if Count > 0 then
    Result := Items[Count - 1]
  else
    Result := nil;
end;

procedure TDebugList<T>.Notify(const Value: T; Action: TCollectionNotification);
begin
  inherited;
  case Action of
    cnAdded, cnExtracted, cnRemoved: UpdateView;
  end;
end;

procedure TDebugList<T>.SetView(const Value: TVirtualStringTree);
begin
  if Assigned(FView) then
    FView.RootNodeCount := 0;
  FView := Value;
  if Assigned(FView) then
    FView.RootNodeCount := Count;
end;

procedure TDebugList<T>.UpdateView;
begin
  if not Assigned(FView) then
    Exit;
  FView.RootNodeCount := Count;
  FView.Invalidate;
end;

{ TWatchList }

procedure TWatchList.AddWatch(const VarName: AnsiString);
var
  Watch: TWatchInfo;
begin
  if (VarName <> '') and (IndexOfName(VarName) = -1) then
  begin
    Watch := TWatchInfo.Create;
    Watch.Name := VarName;
    Watch.Active := True;
    Add(Watch);
  end;
end;

function TWatchList.CountActive: Integer;
var
  Watch: TWatchInfo;
begin
  Result := 0;
  for Watch in Self do
    if Watch.Active then
      Inc(Result);
end;

function TWatchList.IndexOfName(const VarName: AnsiString): Integer;
begin
  Result := 0;
  while (Result < Count) and not SameText(Items[Result].Name, VarName) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

{ TMessageList }

function TMessageList.AddCompileErrorMessage(const Fichier, Text: AnsiString; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create;
  Result := Add(Msg);
  case TypeMessage of
    tmError: Msg.TypeMessage := 'Erreur';
    tmWarning: Msg.TypeMessage := 'Avertissement';
    tmHint: Msg.TypeMessage := 'Conseil';
  end;
  Msg.Fichier := Fichier;
  Msg.Text := Text;
  Msg.Line := Line;
  Msg.Char := Char;
  Msg.Category := cmCompileError;
end;

function TMessageList.AddInfoMessage(const Fichier, Text: AnsiString; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create;
  Result := Add(Msg);
  Msg.TypeMessage := 'Information';
  Msg.Fichier := Fichier;
  Msg.Text := Text;
  Msg.Line := Line;
  Msg.Char := Char;
  Msg.Category := cmInfo;
end;

function TMessageList.AddRuntimeErrorMessage(const Fichier, Text: AnsiString; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create;
  Result := Add(Msg);
  Msg.TypeMessage := 'Erreur';
  Msg.Fichier := Fichier;
  Msg.Text := Text;
  Msg.Line := Line;
  Msg.Char := Char;
  Msg.Category := cmRuntimeError;
end;

{ TBreakpointInfo }

destructor TBreakpointInfo.Destroy;
begin
  FEditor.InvalidateGutterLine(Line);
  FEditor.InvalidateLine(Line);
  inherited;
end;

procedure TBreakpointInfo.SetActive(const Value: Boolean);
begin
  FActive := Value;
  FEditor.InvalidateLine(Line);
  FEditor.InvalidateGutterLine(Line);
end;

procedure AddToTStrings(const Strings: TStringArray; List: TStrings);
var
  Dummy: Integer;
begin
  for Dummy := 0 to high(Strings) do
  begin
    List.Add(string(Strings[Dummy]));
  end;
end;

procedure Split(const Trenner, Text: AnsiString; var Text1, Text2: AnsiString);
var
  EndPos: Integer;
begin
  EndPos := Pos(Trenner, Text);
  if EndPos = 0 then
    EndPos := Length(Text) + 1;

  Text1 := Copy(Text, 1, EndPos - 1);

  Text2 := Copy(Text, EndPos + length(Trenner), length(Text));
end;

function Explode(const Trenner: AnsiString; Text: AnsiString): TStringArray;
begin
  result := nil;
  while Text <> '' do
  begin
    SetLength(result, length(result) + 1);
    Split(Trenner, Text, result[high(result)], Text);
  end;
end;

function HashString(const S: AnsiString): Cardinal;
const
  cLongBits = 32;
  cOneEight = 4;
  cThreeFourths = 24;
  cHighBits = $F0000000;
var
  I: Integer;
  P: PAnsiChar;
  Temp: Cardinal;
begin
  { TODO : I should really be processing 4 bytes at once... }
  Result := 0;
  P := PAnsiChar(AnsiUpperCase(S));

  I := Length(S);
  while I > 0 do
  begin
    Result := (Result shl cOneEight) + Ord(P^);
    Temp := Result and cHighBits;
    if Temp <> 0 then
      Result := (Result xor (Temp shr cThreeFourths)) and (not cHighBits);
    Dec(I);
    Inc(P);
  end;
end;

function GetTypeName(Typ: TPSType): AnsiString;
begin
  if Typ.OriginalName <> '' then
    result := Typ.OriginalName
  else
  begin
    if Typ.ClassType = TPSArrayType then
      result := 'array of ' + GetTypeName(TPSArrayType(Typ).ArrayTypeNo)
    else if Typ.ClassType = TPSRecordType then
      result := 'record'
    else if Typ.ClassType = TPSEnumType then
      result := 'enum';
  end;
end;

function GetParams(Decl: TPSParametersDecl; const Delim: AnsiString = ''): AnsiString;
var
  Dummy: Integer;
begin
  Assert(Decl <> nil);
  Result := '';
  if Decl.ParamCount > 0 then
  begin
    Result := Result + ' (';
    for Dummy := 0 to Decl.ParamCount - 1 do
    begin
      if Dummy <> 0 then
        Result := Result + '; ';

      Result := Result + Delim;

      if (Decl.Params[Dummy].Mode = pmOut) then
        Result := Result + 'out ';
      if (Decl.Params[Dummy].Mode = pmInOut) then
        Result := Result + 'var ';

      Result := Result + Decl.Params[Dummy].OrgName;

      if Decl.Params[Dummy].aType <> nil then
        Result := Result + ': ' + GetTypeName(Decl.Params[Dummy].aType);

      Result := Result + Delim;
    end;
    Result := Result + ')';
  end;

  if Decl.Result <> nil then
    Result := Result + ': ' + GetTypeName(Decl.Result);
end;

function BaseTypeCompatible(p1, p2: Integer): Boolean;

  function IsIntType(b: TPSBaseType): Boolean;
  begin
    case b of
      btU8, btS8, btU16, btS16, btU32, btS32
{$IFNDEF PS_NOINT64}
        , btS64
{$ENDIF}
        : Result := True;
      else
        Result := False;
    end;
  end;

  function IsRealType(b: TPSBaseType): Boolean;
  begin
    case b of
      btSingle, btDouble, btCurrency, btExtended: Result := True;
      else
        Result := False;
    end;
  end;

  function IsIntRealType(b: TPSBaseType): Boolean;
  begin
    case b of
      btSingle, btDouble, btCurrency, btExtended, btU8, btS8, btU16, btS16, btU32, btS32
{$IFNDEF PS_NOINT64}
        , btS64
{$ENDIF}
        :
        Result := True;
      else
        Result := False;
    end;

  end;

begin
  if ((p1 = btProcPtr) and (p2 = p1)) or
    (p1 = btPointer) or
    (p2 = btPointer) or
    ((p1 = btNotificationVariant) or (p1 = btVariant)) or
    ((p2 = btNotificationVariant) or (p2 = btVariant)) or
    (IsIntType(p1) and IsIntType(p2)) or
    (IsRealType(p1) and IsIntRealType(p2)) or
    (((p1 = btPchar) or (p1 = btString)) and ((p2 = btString) or (p2 = btPchar))) or
    (((p1 = btPchar) or (p1 = btString)) and (p2 = btChar)) or
    ((p1 = btChar) and (p2 = btChar)) or
    ((p1 = btSet) and (p2 = btSet)) or
{$IFNDEF PS_NOWIDESTRING}
    ((p1 = btWideChar) and (p2 = btChar)) or
    ((p1 = btWideChar) and (p2 = btWideChar)) or
    ((p1 = btWidestring) and (p2 = btChar)) or
    ((p1 = btWidestring) and (p2 = btWideChar)) or
    ((p1 = btWidestring) and ((p2 = btString) or (p2 = btPchar))) or
    ((p1 = btWidestring) and (p2 = btWidestring)) or
    (((p1 = btPchar) or (p1 = btString)) and (p2 = btWideString)) or
    (((p1 = btPchar) or (p1 = btString)) and (p2 = btWidechar)) or
    (((p1 = btPchar) or (p1 = btString)) and (p2 = btchar)) or
{$ENDIF}
    ((p1 = btRecord) and (p2 = btrecord)) or
    ((p1 = btEnum) and (p2 = btEnum)) then
    Result := True
  else
    Result := False;
end;

end.

