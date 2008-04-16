unit UScriptUtils;

interface

uses
  SysUtils, Classes, Graphics, Types, StdCtrls, SynEdit, Controls, VirtualTrees, Contnrs, uPSCompiler, uPSUtils;

type
  TInfoType = (itProcedure, itFunction, itType, itVar, itConstant, itField, itConstructor);
  TInfoTypes = set of TInfoType;

  TParamInfoRecord = record
    Name: Cardinal;
    OrgName: string;
    Params: string;
    OrgParams: string;
    Father: Cardinal;
    Nr: Integer;
    ReturnTyp: Cardinal;
    Typ: TInfoType;
    HasFields: Boolean;
    SubType: Cardinal;
  end;

  TParamInfoArray = array of TParamInfoRecord;

  TDebugList = class(TObjectList)
  private
    FView: TVirtualStringTree;
    procedure SetView(const Value: TVirtualStringTree);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure UpdateView;
    procedure DeleteCurrent;
    property View: TVirtualStringTree read FView write SetView;
  end;

  TBreakpointInfo = class
  private
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    Line: Cardinal;
    Fichier: string;
    FEditor: TCustomSynEdit;
    destructor Destroy; override;
  published
    property Active: Boolean read FActive write SetActive;
  end;

  TCategoryMessage = (cmInfo, cmCompileError, cmRuntimeError);
  TTypeMessage = (tmUnknown, tmError, tmHint, tmWarning);

  TMessageInfo = class
    Fichier, TypeMessage, Text: string;
    Line, Char: Cardinal;
    Category: TCategoryMessage;
  end;

  TWatchInfo = class
    Name: string;
    Active: Boolean;
  end;

  TWatchList = class(TDebugList)
  private
    function GetInfo(Index: Integer): TWatchInfo;
    procedure PutInfo(Index: Integer; const Value: TWatchInfo);
  public
    property Items[Index: Integer]: TWatchInfo read GetInfo write PutInfo; default;
  published
    function IndexOfName(const VarName: string): Integer;
    function CountActive: Integer;
    procedure AddWatch(const VarName: string);
  end;

  TMessageList = class(TDebugList)
  private
    function GetInfo(Index: Integer): TMessageInfo;
    procedure PutInfo(Index: Integer; const Value: TMessageInfo);
  public
    property Items[Index: Integer]: TMessageInfo read GetInfo write PutInfo; default;
  published
    function AddCompileErrorMessage(const Fichier, Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
    function AddRuntimeErrorMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
    function AddInfoMessage(const Fichier, Text: string; Line: Cardinal = 0; Char: Cardinal = 0): Integer;
    function Current: TMessageInfo;
    function Last: TMessageInfo;
  end;

  TGetScript = function(const Fichier: string): TSynEdit of object;

  TBreakpointList = class(TDebugList)
  private
    FGetScript: TGetScript;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetInfo(Index: Integer): TBreakpointInfo;
    procedure PutInfo(Index: Integer; const Value: TBreakpointInfo);
  public
    function IndexOf(const Fichier: string; const ALine: Cardinal): Integer;
    function Exists(const Fichier: string; const ALine: Cardinal): Boolean;
    procedure AddBreakpoint(const Fichier: string; const ALine: Cardinal);
    function Toggle(const Fichier: string; const ALine: Cardinal): Boolean;
    property Items[Index: Integer]: TBreakpointInfo read GetInfo write PutInfo; default;
    function Current: TBreakpointInfo;

    property Editor: TGetScript read FGetScript write FGetScript;
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

  TStringArray = array of string;

procedure AddToTStrings(Strings: TStringArray; List: TStrings);
function Explode(Trenner: string; Text: string): TStringArray;
function GetTypeName(Typ: TPSType): string;
function GetParams(Decl: TPSParametersDecl; Delim: string = ''): string;
function BaseTypeCompatible(p1, p2: Integer): Boolean;
function HashString(const S: string): Cardinal;

implementation

{ TBreakpointList }

function TBreakpointList.IndexOf(const Fichier: string; const ALine: Cardinal): Integer;
begin
  Result := 0;
  while (Result < Count) and ((Items[Result].Line <> ALine) or not SameText(Items[Result].Fichier, Fichier)) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

function TBreakpointList.Exists(const Fichier: string; const ALine: Cardinal): Boolean;
begin
  Result := IndexOf(Fichier, ALine) <> -1;
end;

function TBreakpointList.GetInfo(Index: Integer): TBreakpointInfo;
begin
  Result := TBreakpointInfo(inherited Items[Index]);
end;

procedure TBreakpointList.PutInfo(Index: Integer; const Value: TBreakpointInfo);
begin
  Put(Index, Pointer(Value));
end;

function TBreakpointList.Toggle(const Fichier: string; const ALine: Cardinal): Boolean;
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

function TBreakpointList.Current: TBreakpointInfo;
begin
  Result := nil;
  if not Assigned(FView) or (FView.GetFirstSelected = nil) then Exit;
  Result := Items[FView.GetFirstSelected.Index];
end;

procedure TBreakpointList.AddBreakpoint(const Fichier: string; const ALine: Cardinal);
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

function CompareBreakpoint(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TBreakpointInfo(Item1).Fichier, TBreakpointInfo(Item2).Fichier);
  if Result = 0 then
    Result := TBreakpointInfo(Item1).Line - TBreakpointInfo(Item2).Line;
end;

procedure TBreakpointList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  case Action of
    lnAdded, lnExtracted:
      begin
        //Editor.InvalidateLine(TBreakpointInfo(Ptr).Line);
        //Editor.InvalidateGutterLine(TBreakpointInfo(Ptr).Line);
        // InvalidateLine et InvalidateGutterLine bizarrement insuffisants dans certains cas
        TBreakpointInfo(Ptr).FEditor.Invalidate;
      end;
    lnDeleted:
      ;
  end;
  if Action = lnAdded then
    Sort(CompareBreakpoint);
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

procedure TDebugList.Clear;
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

procedure TDebugList.DeleteCurrent;
begin
  if Assigned(FView) then
  begin
    Delete(FView.GetFirstSelected.Index);
    UpdateView;
  end;
end;

destructor TDebugList.Destroy;
begin
  SetView(nil);
  inherited;
end;

procedure TDebugList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  case Action of
    lnAdded, lnExtracted, lnDeleted: UpdateView;
  end;
end;

procedure TDebugList.SetView(const Value: TVirtualStringTree);
begin
  if Assigned(FView) then
    FView.RootNodeCount := 0;
  FView := Value;
  if Assigned(FView) then
    FView.RootNodeCount := Count;
end;

procedure TDebugList.UpdateView;
begin
  if not Assigned(FView) then Exit;
  FView.RootNodeCount := Count;
  FView.Invalidate;
end;

{ TWatchList }

procedure TWatchList.AddWatch(const VarName: string);
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
  i: Integer;
begin
  Result := 0;
  for i := 0 to Pred(Count) do
    if Items[i].Active then Inc(Result);
end;

function TWatchList.GetInfo(Index: Integer): TWatchInfo;
begin
  Result := TWatchInfo(inherited Items[Index]);
end;

function TWatchList.IndexOfName(const VarName: string): Integer;
begin
  Result := 0;
  while (Result < Count) and not SameText(TWatchInfo(Items[Result]).Name, VarName) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

procedure TWatchList.PutInfo(Index: Integer; const Value: TWatchInfo);
begin
  Put(Index, Pointer(Value));
end;

{ TMessageList }

function TMessageList.AddCompileErrorMessage(const Fichier, Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
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

function TMessageList.AddInfoMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
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

function TMessageList.AddRuntimeErrorMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
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

function TMessageList.Current: TMessageInfo;
begin
  Result := nil;
  if not Assigned(FView) or (FView.GetFirstSelected = nil) then Exit;
  Result := Items[FView.GetFirstSelected.Index];
end;

function TMessageList.GetInfo(Index: Integer): TMessageInfo;
begin
  Result := TMessageInfo(inherited Items[Index]);
end;

function TMessageList.Last: TMessageInfo;
begin
  Result := TMessageInfo(inherited Last);
end;

procedure TMessageList.PutInfo(Index: Integer; const Value: TMessageInfo);
begin
  Put(Index, Pointer(Value));
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

procedure AddToTStrings(Strings: TStringArray; List: TStrings);
var
  Dummy: Integer;
begin
  for Dummy := 0 to high(Strings) do
  begin
    List.Add(Strings[Dummy]);
  end;
end;

procedure Split(Trenner: string; Text: string; var Text1, Text2: string);
var
  EndPos: Integer;
begin
  EndPos := Pos(Trenner, Text);
  if EndPos = 0 then
    EndPos := Length(Text) + 1;

  Text1 := Copy(Text, 1, EndPos - 1);

  Text2 := Copy(Text, EndPos + length(Trenner), length(Text));
end;

function Explode(Trenner: string; Text: string): TStringArray;
begin
  result := nil;
  while Text <> '' do
  begin
    SetLength(result, length(result) + 1);
    Split(Trenner, Text, result[high(result)], Text);
  end;
end;

function HashString(const S: string): Cardinal;
const
  cLongBits = 32;
  cOneEight = 4;
  cThreeFourths = 24;
  cHighBits = $F0000000;
var
  I: Integer;
  P: PChar;
  Temp: Cardinal;
begin
  { TODO : I should really be processing 4 bytes at once... }
  Result := 0;
  P := PChar(UpperCase(S));

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

function GetTypeName(Typ: TPSType): string;
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

function GetParams(Decl: TPSParametersDecl; Delim: string = ''): string;
var
  Dummy: Integer;
begin
  Assert(Decl <> nil);
  result := '';
  if Decl.ParamCount > 0 then
  begin
    result := result + ' (';
    for Dummy := 0 to Decl.ParamCount - 1 do
    begin
      if Dummy <> 0 then
        result := result + '; ';

      result := result + Delim;

      if (Decl.Params[Dummy].Mode = pmOut) then
        result := result + 'out ';
      if (Decl.Params[Dummy].Mode = pmInOut) then
        result := result + 'var ';

      Result := result + Decl.Params[Dummy].OrgName;

      if Decl.Params[Dummy].aType <> nil then
        result := result + ': ' + GetTypeName(Decl.Params[Dummy].aType);

      result := result + Delim;
    end;
    result := result + ')';
  end;

  if Decl.Result <> nil then
    result := result + ': ' + GetTypeName(Decl.Result);
end;

function BaseTypeCompatible(p1, p2: Integer): Boolean;

  function IsIntType(b: TPSBaseType): Boolean;
  begin
    case b of
      btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF PS_NOINT64}, btS64{$ENDIF}: Result := True;
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
      btSingle, btDouble, btCurrency, btExtended, btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF PS_NOINT64}, btS64{$ENDIF}:
        Result := True;
    else
      Result := False;
    end;

  end;

begin
  if
    ((p1 = btProcPtr) and (p2 = p1)) or
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

