unit UdmPascalScript;

interface

uses
  System.SysUtils, Winapi.Windows, Forms, System.Classes, Vcl.Graphics,
  uPSComponent, uPSComponent_COM, uPSComponent_Default, UScriptList, UScriptUtils, LoadComplet,
  IDHashMap, uPSUtils,
  LoadCompletImport, uPSRuntime, uPSCompiler, uPSDebugger, uPSI_BdtkRegEx, uPSI_BdtkObjects, uPSI_superobject, UMasterEngine, UScriptEngineIntf, UScriptEditor,
  SynCompletionProposal,
  SynEditHighlighter, SynHighlighterPas;

type
  TPascalScriptEngineFactory = class(TEngineFactory)
  private
    FMasterEngine: IMasterEngine;
  public
    constructor Create(MasterEngine: IMasterEngine); override;
    destructor Destroy; override;
    function GetInstance: IEngineInterface; override;
  end;

  TdmPascalScript = class;

  TPSScriptDebugger = class(uPSComponent.TPSScriptDebugger)
    DM: TdmPascalScript;
  end;

  TInfoType = (itProcedure, itFunction, itType, itVar, itConstant, itField, itConstructor);
  TInfoTypes = set of TInfoType;

  TParamInfoRecord = record
    Name: Cardinal;
    OrgName: TbtString;
    Params: TbtString;
    OrgParams: TbtString;
    Father: Cardinal;
    Nr: Integer;
    ReturnTyp: Cardinal;
    Typ: TInfoType;
    HasFields: Boolean;
    SubType: Cardinal;
  end;

  TParamInfoArray = array of TParamInfoRecord;

  TdmPascalScript = class(TInterfacedObject, IEngineInterface)
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_ComObj1: TPSImport_ComObj;
    PSDllPlugin1: TPSDllPlugin;
    PSScriptDebugger1: TPSScriptDebugger;
    SynPasSyn1: TSynPasSyn;
    function PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: TbtString; var FileName, Output: TbtString): Boolean;
    procedure PSScriptDebugger1Compile(Sender: TPSScript);
    procedure PSScriptDebugger1Execute(Sender: TPSScript);
    procedure PSScriptDebugger1AfterExecute(Sender: TPSScript);
    procedure PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: TbtString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1LineInfo(Sender: TObject; const FileName: TbtString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1Idle(Sender: TObject);
  private
    fObjectList: TParamInfoArray;
    fTypeInfos: TIDHashMap;

    procedure RebuildLokalObjektList(CurrentEditor: TScriptEditor);
    procedure BuildLokalObjektList(Comp: TPSPascalCompiler);
    function FindParameter(LocLine: TbtString; X: Integer; out Func: TParamInfoRecord; out ParamCount: Integer): Boolean;
    function GetLookUpString(Line: TbtString; EndPos: Integer): TbtString;
    function LookUpList(LookUp: TbtString; var ParamInfo: TParamInfoRecord): Boolean; overload;
    function LookUpList(LookUp: Cardinal; var ParamInfo: TParamInfoRecord): Boolean; overload;
    procedure FillAutoComplete(Proposal, Code: TStrings; var List: TParamInfoArray; Types: TInfoTypes; FromFather: Cardinal = 0; Typ: TbtString = '');
  strict private
    FMasterEngine: IMasterEngine;
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FActiveUnitName, FRunToCursorFile, FErrorUnitName: string;
    FListTypesImages: TStringList;
    FOnBreakpoint: TPSOnLineInfo;
    FOnLineInfo: TPSOnLineInfo;
    FOnIdle: TNotifyEvent;
    FPSImport_RegExpr: TPSImport_BdtkRegEx;
    FPSImport_BdtkObjects: TPSImport_BdtkObjects;
    FPSImport_superobject: TPSImport_superobject;
    FRunningScript: TScript;

    function GetNewEditor(AOwner: TComponent): TScriptEditor;
    function isTokenIdentifier(TokenType: Integer): Boolean;

    procedure SetRunToCursorFile(const Value: string);
    function GetRunning: Boolean;
    function GetDebugMode: TDebugMode;
    function CorrectScriptName(const Script: AnsiString): AnsiString;
    procedure WriteToFile(const Chaine, FileName: string);

    function GetActiveLine: Cardinal;
    procedure SetActiveLine(const Value: Cardinal);
    function GetActiveUnitName: string;
    procedure SetActiveUnitName(const Value: string);
    function GetErrorUnitName: string;
    procedure SetErrorUnitName(const Value: string);
    function GetErrorLine: Cardinal;
    procedure SetErrorLine(const Value: Cardinal);
  public
    frmScripts: TForm;

    constructor Create(MasterEngine: IMasterEngine);
    destructor Destroy; override;

    function Compile(Script: TScript; out Msg: IMessageInfo): Boolean; overload;
    function Execute: Boolean;
    function GetSpecialMainUnitName: string;

    function GetExecutableLines(const AUnitName: string): TLineNumbers;
    function TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
    procedure GetUncompiledCode(Lines: TStrings);
    procedure setRunTo(Position: Integer; const FileName: string);
    procedure WriteToConsole(const Chaine: string);
    function GetVar(const Name: TbtString; out s: AnsiString): PIFVariant;
    function GetVariableValue(const VarName: string): string;
    function GetWatchValue(const VarName: string): string;
    function GetCompletionProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor): Boolean;
    function GetParametersProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor; out BestProposal: Integer): Boolean;

    property ActiveLine: Cardinal read GetActiveLine write SetActiveLine;
    property ActiveUnitName: string read GetActiveUnitName write SetActiveUnitName;
    property RunToCursor: Cardinal read FRunToCursor write FRunToCursor;
    property RunToCursorFile: string read FRunToCursorFile write SetRunToCursorFile;
    property ErrorLine: Cardinal read GetErrorLine write SetErrorLine;
    property ErrorUnitName: string read GetErrorUnitName write SetErrorUnitName;
    property Running: Boolean read GetRunning;
    property DebugMode: TDebugMode read GetDebugMode;

    procedure ResetBreakpoints;

    property OnBreakpoint: TPSOnLineInfo read FOnBreakpoint write FOnBreakpoint;
    property OnLineInfo: TPSOnLineInfo read FOnLineInfo write FOnLineInfo;
    property OnIdle: TNotifyEvent read FOnIdle write FOnIdle;

    function GetUseDebugInfo: Boolean;
    procedure SetUseDebugInfo(Value: Boolean);

    procedure AssignScript(Script: TStrings);

    function Run: Boolean;
    procedure Pause;
    procedure StepInto;
    procedure StepOver;
    procedure Resume;
    procedure Stop;
  end;

  TStringArray = array of TbtString;

procedure AddToTStrings(const Strings: TStringArray; List: TStrings);
function Explode(const Trenner: TbtString; Text: TbtString): TStringArray;
function GetTypeName(Typ: TPSType): TbtString;
function GetParams(Decl: TPSParametersDecl; const Delim: TbtString = ''): TbtString;
function BaseTypeCompatible(p1, p2: Integer): Boolean;
function HashString(const s: TbtString): Cardinal;

implementation

uses AnsiStrings, Procedures, UfrmScripts, Divers, UScriptsFonctions, UScriptsHTMLFunctions, Dialogs, StrUtils, uPSDisassembly,
  UPascalScriptEditor;

procedure AddToTStrings(const Strings: TStringArray; List: TStrings);
var
  Dummy: Integer;
begin
  for Dummy := 0 to high(Strings) do
  begin
    List.Add(string(Strings[Dummy]));
  end;
end;

procedure Split(const Trenner, Text: TbtString; var Text1, Text2: TbtString);
var
  EndPos: Integer;
begin
  EndPos := Pos(Trenner, Text);
  if EndPos = 0 then
    EndPos := Length(Text) + 1;

  Text1 := Copy(Text, 1, EndPos - 1);

  Text2 := Copy(Text, EndPos + Length(Trenner), Length(Text));
end;

function Explode(const Trenner: TbtString; Text: TbtString): TStringArray;
begin
  Result := nil;
  while Text <> '' do
  begin
    SetLength(Result, Length(Result) + 1);
    Split(Trenner, Text, Result[high(Result)], Text);
  end;
end;

function HashString(const s: TbtString): Cardinal;
const
  cLongBits = 32;
  cOneEight = 4;
  cThreeFourths = 24;
  cHighBits = $F0000000;
var
  I: Integer;
  P: ^tbtchar;
  Temp: Cardinal;
begin
  { TODO : I should really be processing 4 bytes at once... }
  Result := 0;
  P := Pointer(UpperCase(s));

  I := Length(s);
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

function GetTypeName(Typ: TPSType): TbtString;
begin
  if Typ.OriginalName <> '' then
    Result := Typ.OriginalName
  else
  begin
    if Typ.ClassType = TPSArrayType then
      Result := 'array of ' + GetTypeName(TPSArrayType(Typ).ArrayTypeNo)
    else if Typ.ClassType = TPSRecordType then
      Result := 'record'
    else if Typ.ClassType = TPSEnumType then
      Result := 'enum';
  end;
end;

function GetParams(Decl: TPSParametersDecl; const Delim: TbtString = ''): TbtString;
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
        :
        Result := True;
    else
      Result := False;
    end;
  end;

  function IsRealType(b: TPSBaseType): Boolean;
  begin
    case b of
      btSingle, btDouble, btCurrency, btExtended:
        Result := True;
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
  if ((p1 = btProcPtr) and (p2 = p1)) or (p1 = btPointer) or (p2 = btPointer) or ((p1 = btNotificationVariant) or (p1 = btVariant)) or
    ((p2 = btNotificationVariant) or (p2 = btVariant)) or (IsIntType(p1) and IsIntType(p2)) or (IsRealType(p1) and IsIntRealType(p2)) or
    (((p1 = btPchar) or (p1 = btString)) and ((p2 = btString) or (p2 = btPchar))) or (((p1 = btPchar) or (p1 = btString)) and (p2 = btChar)) or
    ((p1 = btChar) and (p2 = btChar)) or ((p1 = btSet) and (p2 = btSet)) or
{$IFNDEF PS_NOWIDESTRING}
    ((p1 = btWideChar) and (p2 = btChar)) or ((p1 = btWideChar) and (p2 = btWideChar)) or ((p1 = btWidestring) and (p2 = btChar)) or
    ((p1 = btWidestring) and (p2 = btWideChar)) or ((p1 = btWidestring) and ((p2 = btString) or (p2 = btPchar))) or ((p1 = btWidestring) and (p2 = btWidestring)
    ) or (((p1 = btPchar) or (p1 = btString)) and (p2 = btWidestring)) or (((p1 = btPchar) or (p1 = btString)) and (p2 = btWideChar)) or
    (((p1 = btPchar) or (p1 = btString)) and (p2 = btChar)) or
{$ENDIF}
    ((p1 = btRecord) and (p2 = btRecord)) or ((p1 = btEnum) and (p2 = btEnum)) then
    Result := True
  else
    Result := False;
end;

type
  PPositionData = ^TPositionData;

  TPositionData = packed record
    FileName: AnsiString;
    Position, Row, Col, SourcePosition: Cardinal;
  end;

  PFunctionInfo = ^TFunctionInfo;

  TFunctionInfo = packed record
    Func: TPSProcRec;
    FParamNames: TIfStringList;
    FVariableNames: TIfStringList;
    FPositionTable: TIfList;
  end;

  TCrackPSDebugExec = class(TPSDebugExec)
  end;

function AutoCompleteCompilerBeforeCleanUp(Sender: TPSPascalCompiler): Boolean;
var
  s: TbtString;
begin
  with TPSScriptDebugger(Sender.ID) do
    if Comp.GetOutput(s) then
      DM.BuildLokalObjektList(Sender);
  Result := True;
end;

function TdmPascalScript.CorrectScriptName(const Script: AnsiString): AnsiString;
begin
  if Script = '' then
    Result := PSScriptDebugger1.MainFileName
  else
    Result := Script;
end;

constructor TdmPascalScript.Create(MasterEngine: IMasterEngine);
begin
  FMasterEngine := MasterEngine;

  FListTypesImages := TStringList.Create;
  LoadStrings(6, FListTypesImages);

  PSImport_DateUtils1 := TPSImport_DateUtils.Create(nil);
  PSImport_Classes1 := TPSImport_Classes.Create(nil);
  PSImport_Classes1.EnableStreams := True;
  PSImport_Classes1.EnableClasses := True;
  PSImport_ComObj1 := TPSImport_ComObj.Create(nil);
  PSDllPlugin1 := TPSDllPlugin.Create(nil);

  FPSImport_RegExpr := TPSImport_BdtkRegEx.Create(nil);
  FPSImport_BdtkObjects := TPSImport_BdtkObjects.Create(nil);
  FPSImport_BdtkObjects.MasterEngine := FMasterEngine;
  FPSImport_superobject := TPSImport_superobject.Create(nil);

  PSScriptDebugger1 := TPSScriptDebugger.Create(nil);
  PSScriptDebugger1.CompilerOptions := [icAllowUnit, icBooleanShortCircuit];
  PSScriptDebugger1.OnCompile := PSScriptDebugger1Compile;
  PSScriptDebugger1.OnExecute := PSScriptDebugger1Execute;
  PSScriptDebugger1.OnAfterExecute := PSScriptDebugger1AfterExecute;
  PSScriptDebugger1.MainFileName := 'Main';
  PSScriptDebugger1.UsePreProcessor := True;
  PSScriptDebugger1.OnNeedFile := PSScriptDebugger1NeedFile;
  PSScriptDebugger1.OnFindUnknownFile := PSScriptDebugger1NeedFile;
  PSScriptDebugger1.OnIdle := PSScriptDebugger1Idle;
  PSScriptDebugger1.OnLineInfo := PSScriptDebugger1LineInfo;
  PSScriptDebugger1.OnBreakpoint := PSScriptDebugger1Breakpoint;
  PSScriptDebugger1.DM := Self;
  PSScriptDebugger1.Comp.OnBeforeCleanup := AutoCompleteCompilerBeforeCleanUp;
  fTypeInfos := TIDHashMap.Create;

  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSImport_DateUtils1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSImport_Classes1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSDllPlugin1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSImport_ComObj1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_RegExpr;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_BdtkObjects;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_superobject;

  SynPasSyn1 := TSynPasSyn.Create(nil);
  SynPasSyn1.PackageSource := False;
  // force à reprendre les params de delphi s'il est installé sur la machine
  SynPasSyn1.UseUserSettings(0);
end;

destructor TdmPascalScript.Destroy;
begin
  SynPasSyn1.Free;
  PSScriptDebugger1.Free;
  FPSImport_RegExpr.Free;
  FPSImport_BdtkObjects.Free;
  FPSImport_superobject.Free;
  PSImport_DateUtils1.Free;
  PSImport_Classes1.Free;
  PSImport_ComObj1.Free;
  PSDllPlugin1.Free;

  FListTypesImages.Free;
  fTypeInfos.Free;

  FMasterEngine := nil;

  inherited;
end;

function TdmPascalScript.GetRunning: Boolean;
begin
  Result := PSScriptDebugger1.Running;
end;

function TdmPascalScript.GetActiveUnitName: string;
begin
  Result := FActiveUnitName;
end;

function TdmPascalScript.GetCompletionProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor): Boolean;
var
  Parser: TPSPascalParser;
  Types: TInfoTypes;
  Line: TbtString;
  Token: TPSPasToken;
  Prev: TPSPasToken;
  PrevEnd: Integer;
  TmpX: Integer;
  Father: Cardinal;
  Info: TParamInfoRecord;
  ParamCount: Integer;
  Parts: TStringArray;
  Typ: TbtString;
  Obj: TbtString;
  hasAssign: Boolean;
begin
  RebuildLokalObjektList(CurrentEditor);

  Line := TbtString(CurrentEditor.LineText);

  Types := [itProcedure, itFunction, itVar];
  Parser := TPSPascalParser.Create;
  try
    Parser.SetText(Line);

    Father := 0;
    Typ := '';

    Result := False;

    Prev := CSTI_EOF;
    Token := CSTI_EOF;
    PrevEnd := -1;
    hasAssign := False;
    while (Parser.CurrTokenID <> CSTI_EOF) and (Parser.CurrTokenPos < Cardinal(CurrentEditor.CaretX - 1)) do
    begin
      Prev := Token;
      PrevEnd := Parser.CurrTokenPos + Cardinal(Length(Parser.OriginalToken));
      Token := Parser.CurrTokenID;
      // Tritt ein := oder ( auf, so wird ein Wert mit einem Rückgabewert erwartet
      // si un := ou ( alors, ça devient une valeur avec une valeur de retour prévu
      case Token of
        CSTI_Assignment:
          if (Prev = CSTI_Identifier) then
          begin
            Types := [itFunction, itVar, itConstant { , itType } ];
            if LookUpList(TbtString(Copy(CurrentEditor.LineText, 1, Parser.CurrTokenPos)), Info) then
              Typ := TbtString(Copy(Info.OrgParams, 3, Length(Info.OrgParams)));
            hasAssign := True;
          end;
        CSTI_OpenRound:
          begin
            Types := [itFunction, itVar, itConstant { , itType } ];
            hasAssign := True;
          end;
        CSTI_SemiColon:
          begin
            hasAssign := False;
            Typ := '';
          end;
      end;

      Parser.Next;
    end;
  finally
    Parser.Free;
  end;

  if Token = CSTI_String then
    Exit;

  if (PrevEnd < (CurrentEditor.CaretX - 1)) then
    Prev := Token;

  case Prev of
    CSTI_Colon:
      Types := [itType];
    CSTI_AddressOf:
      begin
        Types := [itProcedure, itFunction];
        Typ := '';
      end;
    CSTI_Period:
      begin
        TmpX := CurrentEditor.CaretX - 1;
        if TmpX > Length(Line) then
          TmpX := Length(Line);

        while (TmpX > 0) and (Line[TmpX] <> '.') do
          Dec(TmpX);

        Dec(TmpX);

        Obj := GetLookUpString(Line, TmpX);

        if LookUpList(LowerCase(Obj), Info) then
        begin
          Father := Info.ReturnTyp;
          if Info.OrgParams = '' then
            Types := [itConstructor]
          else if hasAssign then
            Types := [itField, itFunction]
          else
            Types := [itField, itProcedure, itFunction];
        end;
      end;
  else
  end;

  if (Prev <> CSTI_AddressOf) and FindParameter(TbtString(CurrentEditor.LineText), CurrentEditor.CaretX, Info, ParamCount) then
  begin
    Parts := Explode(',', Info.Params);
    if ParamCount <= high(Parts) then
    begin
      if AnsiStrings.AnsiPos(':', Parts[ParamCount]) > 0 then
      begin
        Typ := TbtString(Copy(Parts[ParamCount], AnsiStrings.AnsiPos(':', Parts[ParamCount]) + 2, Length(Parts[ParamCount])));
        Typ := TbtString(Copy(Typ, 1, Length(Typ) - 1));
      end
      else
        Typ := '';

      Exclude(Types, itProcedure);
    end;
  end;

  Result := True;
  FillAutoComplete(Proposal, Code, fObjectList, Types, Father, Typ);
end;

function TdmPascalScript.GetActiveLine: Cardinal;
begin
  Result := FActiveLine;
end;

function TdmPascalScript.GetDebugMode: TDebugMode;
begin
  Result := UScriptEngineIntf.TDebugMode(PSScriptDebugger1.Exec.DebugMode);
end;

function TdmPascalScript.GetNewEditor(AOwner: TComponent): TScriptEditor;
begin
  Result := TPascalScriptEditor.Create(AOwner);
  Result.Highlighter := SynPasSyn1;
end;

function TdmPascalScript.GetParametersProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor; out BestProposal: Integer): Boolean;
var
  ParamIndex: Integer;
  Info: TParamInfoRecord;
begin
  RebuildLokalObjektList(CurrentEditor);

  Result := FindParameter(TbtString(CurrentEditor.LineText), CurrentEditor.CaretX, Info, ParamIndex);

  if Result then
  begin
    BestProposal := ParamIndex;
    if Info.Params = '' then
      Info.Params := '"* Pas de paramètre *"';

    Proposal.Add(string(Info.Params));
  end;
end;

function TdmPascalScript.GetErrorUnitName: string;
begin
  Result := FErrorUnitName;
end;

function TdmPascalScript.GetErrorLine: Cardinal;
begin
  Result := FErrorLine;
end;

function TdmPascalScript.GetExecutableLines(const AUnitName: string): TLineNumbers;
begin
  // Result := [];
end;

function TdmPascalScript.GetLookUpString(Line: TbtString; EndPos: Integer): TbtString;
const
  TSynValidIdentifierChars = ['.', ' ', '[', ']', '(', ')'];
var
  TmpX: Integer;
  ParenCount: Integer;
  WasSpace: Boolean;
  CanSpace: Boolean;
begin
  // we have a valid open paren, lets see what the word before it is
  TmpX := EndPos;
  ParenCount := 0;
  WasSpace := False;
  CanSpace := True;
  while (TmpX > 0) and (SynPasSyn1.IsIdentChar(WideChar(Line[TmpX])) or CharInSet(Line[TmpX], TSynValidIdentifierChars) or (ParenCount > 0)) do
  begin
    case Line[TmpX] of
      ')', ']':
        Inc(ParenCount);
      '(', '[':
        begin
          if ParenCount = 0 then
            break;
          Dec(ParenCount);
        end;
      '.':
        begin
          CanSpace := True;
          WasSpace := False;
        end;
      ' ':
        begin
          if not CanSpace then
            WasSpace := True;
        end;
    else
      begin
        if WasSpace then
          break;
        WasSpace := False;
        CanSpace := False;
      end;
    end;

    Dec(TmpX);
  end;

  if ParenCount = 0 then
    Result := TbtString(Copy(Line, TmpX + 1, EndPos - TmpX))
  else
    Result := '';
end;

function TdmPascalScript.GetSpecialMainUnitName: string;
begin
  Result := string(PSScriptDebugger1.MainFileName);
end;

procedure TdmPascalScript.Pause;
begin
  PSScriptDebugger1.Pause;
end;

procedure TdmPascalScript.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  ActiveLine := 0;
  ActiveUnitName := '';
  RunToCursor := 0;
  RunToCursorFile := '';
  PSScriptDebugger1.ClearBreakPoints;
  FMasterEngine.DebugPlugin.Watches.UpdateView;

  FMasterEngine.AfterExecute;
end;

procedure TdmPascalScript.PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: TbtString; Position, Row, Col: Cardinal);
begin
  ActiveLine := Row;
  ActiveUnitName := string(FileName);

  FMasterEngine.OnBreakPoint;

  if Assigned(FOnBreakpoint) then
    FOnBreakpoint(Sender, AnsiString(ActiveUnitName), Position, ActiveLine, Col);
end;

procedure TdmPascalScript.PSScriptDebugger1Compile(Sender: TPSScript);
var
  I: Integer;
begin
  for I := 0 to Pred(FListTypesImages.Count) do
    PSScriptDebugger1.Comp.AddConstantN('cti' + AnsiStrings.StringReplace(AnsiString(SansAccents(FListTypesImages.ValueFromIndex[I])), ' ', '_', [rfReplaceAll]
      ), 'integer').SetInt(StrToInt(AnsiString(FListTypesImages.Names[I])));

  PSScriptDebugger1.AddMethod(Self, @TdmPascalScript.WriteToConsole, 'procedure WriteToConsole(const Chaine: string);');
  PSScriptDebugger1.AddMethod(Self, @TdmPascalScript.WriteToFile, 'procedure WriteToFile(const Chaine, FileName: string);');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.OptionValue, 'function GetOptionValue(const OptionName, Default: string): string;');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.OptionValueIndex, 'function GetOptionValueIndex(const OptionName: string; Default: Integer): Integer;');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.CheckOptionValue, 'function CheckOptionValue(const OptionName, Value: string): Boolean;');

  PSScriptDebugger1.AddFunction(@GetPage, 'function GetPage(const url: string; UTF8: Boolean): string;');
  PSScriptDebugger1.AddFunction(@GetPageWithHeaders, 'function GetPageWithHeaders(const url: string; UTF8: Boolean): string;');
  PSScriptDebugger1.Comp.AddTypeS('RAttachement', 'record Nom, Valeur: string; IsFichier: Boolean; end');
  PSScriptDebugger1.AddFunction(@PostPage, 'function PostPage(const url: string; const Pieces: array of RAttachement; UTF8: Boolean): string;');
  PSScriptDebugger1.AddFunction(@PostPageWithHeaders,
    'function PostPageWithHeaders(const url: string; const Pieces: array of RAttachement; UTF8: Boolean): string;');
  PSScriptDebugger1.AddFunction(@findInfo, 'function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;');
  PSScriptDebugger1.AddFunction(@MakeAuteur, 'function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;');
  PSScriptDebugger1.AddFunction(@MakeUnivers, 'function MakeUnivers(const Nom: string): TUnivers;');
  PSScriptDebugger1.AddFunction(@AskSearchEntry, 'function AskSearchEntry(const Labels: array of string; var Search: string; var Index: Integer): Boolean');
  PSScriptDebugger1.AddFunction(@CombineURL, 'function CombineURL(const Root, URL: string): string;');
  PSScriptDebugger1.AddFunction(@HTMLDecode, 'function HTMLDecode(const Chaine: string): string;');
  PSScriptDebugger1.AddFunction(@HTMLText, 'function HTMLText(const Chaine: string): string;');

  PSScriptDebugger1.AddFunction(@ScriptChangeFileExt, 'function ChangeFileExt(const URL, Extension: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptChangeFilePath, 'function ChangeFilePath(const URL, Path: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFilePath, 'function ExtractFilePath(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileDir, 'function ExtractFileDir(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileName, 'function ExtractFileName(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileExt, 'function ExtractFileExt(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptIncludeTrailingPathDelimiter, 'function IncludeTrailingPathDelimiter(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExcludeTrailingPathDelimiter, 'function ExcludeTrailingPathDelimiter(const URL: string): string;');

  PSScriptDebugger1.AddFunction(@System.SysUtils.Format, 'function Format(const Format: string; const Args: array of const): string;');

  PSScriptDebugger1.AddFunction(@System.SysUtils.SameText, 'function SameText(const S1, S2: string): Boolean;');
  PSScriptDebugger1.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
  PSScriptDebugger1.AddFunction(@StrUtils.PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');

  PSScriptDebugger1.Comp.AddTypeS('TReplaceFlag', '(rfReplaceAll, rfIgnoreCase)');
  PSScriptDebugger1.Comp.AddTypeS('TReplaceFlags', 'set of TReplaceFlag');
  PSScriptDebugger1.AddFunction(@System.SysUtils.StringReplace,
    'function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;');
  PSScriptDebugger1.AddFunction(@ScriptStrToFloatDef, 'function StrToFloatDef(const S: string; const Default: Extended): Extended;');

  PSScriptDebugger1.AddRegisteredVariable('AlbumToImport', 'TAlbumComplet');
end;

procedure TdmPascalScript.PSScriptDebugger1Execute(Sender: TPSScript);
begin
  ResetBreakpoints;
  Sender.SetVarToInstance('AlbumToImport', FMasterEngine.AlbumToImport);
end;

procedure TdmPascalScript.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;

  if Assigned(FOnIdle) then
    FOnIdle(Sender);
end;

procedure TdmPascalScript.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: TbtString; Position, Row, Col: Cardinal);
begin
  ActiveLine := Row;
  ActiveUnitName := string(FileName);

  if (ActiveLine = RunToCursor) and SameText(ActiveUnitName, RunToCursorFile) and (PSScriptDebugger1.Exec.DebugMode = uPSDebugger.dmRun) then
    PSScriptDebugger1.Pause;

  if PSScriptDebugger1.Exec.DebugMode in [uPSDebugger.dmPaused, uPSDebugger.dmStepInto] then
    FMasterEngine.OnBreakPoint;

  if Assigned(FOnLineInfo) then
    FOnLineInfo(Sender, AnsiString(ActiveUnitName), Position, ActiveLine, Col);
end;

function TdmPascalScript.PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: TbtString; var FileName, Output: TbtString): Boolean;
var
  tmp: TStringList;
begin
  tmp := TStringList.Create;
  try
    Result := FMasterEngine.GetScriptLines(string(FileName), tmp, [skMain, skUnit]);
    Output := TbtString(tmp.Text);
  finally
    tmp.Free;
  end;
end;

procedure TdmPascalScript.Resume;
begin
  PSScriptDebugger1.Resume;
end;

function TdmPascalScript.Run: Boolean;
begin
  Result := PSScriptDebugger1.Execute;
end;

procedure TdmPascalScript.SetActiveUnitName(const Value: string);
begin
  FActiveUnitName := string(CorrectScriptName(AnsiString(Value)));
end;

procedure TdmPascalScript.SetActiveLine(const Value: Cardinal);
begin
  FActiveLine := Value;
end;

procedure TdmPascalScript.SetErrorUnitName(const Value: string);
begin
  FErrorUnitName := string(CorrectScriptName(AnsiString(Value)));
end;

procedure TdmPascalScript.SetErrorLine(const Value: Cardinal);
begin
  FErrorLine := Value;
end;

procedure TdmPascalScript.setRunTo(Position: Integer; const FileName: string);
begin
  RunToCursor := Position;;
  RunToCursorFile := FileName;
end;

procedure TdmPascalScript.SetRunToCursorFile(const Value: string);
begin
  FRunToCursorFile := string(CorrectScriptName(AnsiString(Value)));
end;

procedure TdmPascalScript.SetUseDebugInfo(Value: Boolean);
begin
  PSScriptDebugger1.UseDebugInfo := Value;
end;

procedure TdmPascalScript.StepInto;
begin
  PSScriptDebugger1.StepInto;
end;

procedure TdmPascalScript.StepOver;
begin
  PSScriptDebugger1.StepOver;
end;

procedure TdmPascalScript.Stop;
begin
  PSScriptDebugger1.Stop;
end;

function TdmPascalScript.TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
var
  I, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  Result := True;
  Proc := 0;
  Position := 0;
  for I := 0 to TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs.Count - 1 do
  begin
    Result := False;
    fi := TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs[I];
    pt := fi^.FPositionTable;
    for j := 0 to pt.Count - 1 do
    begin
      r := pt[j];
      if not SameText(string(r^.FileName), Fn) then
        Continue;
      if r^.Row = Row then
      begin
        Proc := TCrackPSDebugExec(PSScriptDebugger1.Exec).FProcs.IndexOf(fi^.Func);
        Position := r^.Position;
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TdmPascalScript.GetUncompiledCode(Lines: TStrings);
var
  s: AnsiString;
  Script: string;
  I, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  PSScriptDebugger1.GetCompiled(s);
  IFPS3DataToText(s, Script);
  Lines.Text := Script;

  Lines.Add('[DEBUG DATA]');
  for I := 0 to TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs.Count - 1 do
  begin
    fi := TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs[I];
    pt := fi^.FPositionTable;
    if fi^.Func is TPSExternalProcRec then
      with TPSExternalProcRec(fi^.Func) do
        Lines.Add(Format('ExternalProc: %s %s', [name, Decl]))
    else if fi^.Func is TPSInternalProcRec then
      with TPSInternalProcRec(fi^.Func) do
        Lines.Add(Format('InternalProc: %s %s', [ExportName, ExportDecl]))
    else
      Lines.Add('unknown proc');

    for j := 0 to pt.Count - 1 do
    begin
      r := pt[j];
      Lines.Add(Format('%s: P=%d, RxC=%dx%d, SP=%d', [r^.FileName, r^.Position, r^.Row, r^.Col, r^.SourcePosition]));
    end;
  end;
end;

function TdmPascalScript.GetUseDebugInfo: Boolean;
begin
  Result := PSScriptDebugger1.UseDebugInfo;
end;

procedure TdmPascalScript.WriteToFile(const Chaine, FileName: string);
var
  Buffer, Preamble: TBytes;
  fs: TFileStream;
begin
  Buffer := TEncoding.default.GetBytes(Chaine);
  Preamble := TEncoding.default.GetPreamble;

  if FileExists(FileName) then
    fs := TFileStream.Create(FileName, fmOpenWrite)
  else
    fs := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  try
    fs.Size := 0;

    if Length(Preamble) > 0 then
      fs.WriteBuffer(Preamble[0], Length(Preamble));
    fs.WriteBuffer(Buffer[0], Length(Buffer));
  finally
    fs.Free;
  end;
end;

procedure TdmPascalScript.WriteToConsole(const Chaine: string);
begin
  FMasterEngine.WriteToConsole(Chaine);
end;

function TdmPascalScript.GetVar(const Name: TbtString; out s: AnsiString): PIFVariant;
var
  I: LongInt;
  s1: AnsiString;
begin
  s := UpperCase(name);
  if AnsiStrings.AnsiPos('.', s) > 0 then
  begin
    s1 := AnsiString(Copy(string(s), 1, AnsiStrings.AnsiPos('.', s) - 1));
    delete(s, 1, AnsiStrings.AnsiPos('.', name));
  end
  else
  begin
    s1 := s;
    s := '';
  end;
  Result := nil;
  with PSScriptDebugger1 do
  begin
    for I := 0 to Exec.CurrentProcVars.Count - 1 do
      if UpperCase(Exec.CurrentProcVars[I]) = s1 then
      begin
        Result := Exec.GetProcVar(I);
        break;
      end;
    if Result = nil then
    begin
      for I := 0 to Exec.CurrentProcParams.Count - 1 do
        if UpperCase(Exec.CurrentProcParams[I]) = s1 then
        begin
          Result := Exec.GetProcParam(I);
          break;
        end;
    end;
    if Result = nil then
    begin
      for I := 0 to Exec.GlobalVarNames.Count - 1 do
        if UpperCase(Exec.GlobalVarNames[I]) = s1 then
        begin
          Result := Exec.GetGlobalVar(I);
          break;
        end;
    end;
  end;
end;

function TdmPascalScript.GetVariableValue(const VarName: string): string;
var
  pv: PIFVariant;
  Prefix: AnsiString;
begin
  if PSScriptDebugger1.Running then
  begin
    pv := GetVar(TbtString(VarName), Prefix);
    if pv = nil then
      Result := '{Expression inconnue}'
    else
      Result := string(PSVariantToString(NewTPSVariantIFC(pv, False), Prefix));
  end
  else
    Result := '{Valeur inaccessible}'
end;

function TdmPascalScript.GetWatchValue(const VarName: string): string;
begin
  Result := GetVariableValue(VarName);
end;

function TdmPascalScript.isTokenIdentifier(TokenType: Integer): Boolean;
begin
  Result := TtkTokenKind(TokenType) = tkIdentifier;
end;

function TdmPascalScript.LookUpList(LookUp: Cardinal; var ParamInfo: TParamInfoRecord): Boolean;
var
  Dummy: Integer;
begin
  Result := False;
  for Dummy := 0 to high(fObjectList) do
  begin
    if (fObjectList[Dummy].Name = LookUp) and (fObjectList[Dummy].Father = 0) then
    begin
      Result := True;
      ParamInfo := fObjectList[Dummy];
      Exit;
    end;
  end;
end;

function TdmPascalScript.LookUpList(LookUp: TbtString; var ParamInfo: TParamInfoRecord): Boolean;
var
  Dummy: Integer;
  Hash: Cardinal;
  Parts: TStringArray;
  FindString: TbtString;
  Parent: Cardinal;

  function FindEntry(LookUp: TbtString; Parent: Cardinal; var ParamInfo: TParamInfoRecord): Boolean;
  var
    Dummy: Integer;
    Hash: Cardinal;
  begin
    Hash := HashString(LookUp);
    Result := False;
    for Dummy := 0 to high(fObjectList) do
    begin
      if (fObjectList[Dummy].Name = Hash) and (fObjectList[Dummy].Father = Parent) then
      begin
        Result := True;
        ParamInfo := fObjectList[Dummy];
        Exit;
      end;
    end;

    // Keinen passenden Eintrag gefunden. Vorfahren prüfen
    if LookUpList(Parent, ParamInfo) then
    begin
      if ParamInfo.SubType <> 0 then
      begin
        Result := FindEntry(LookUp, ParamInfo.SubType, ParamInfo);
      end;
    end;
  end;

begin
  if AnsiStrings.AnsiPos('.', LookUp) = 0 then
  begin
    // Einfacher Bezeichner wird gesucht
    Hash := HashString(Trim(LookUp));
    Result := False;
    for Dummy := 0 to high(fObjectList) do
    begin
      if (fObjectList[Dummy].Name = Hash) and (fObjectList[Dummy].Father = 0) then
      begin
        Result := True;
        ParamInfo := fObjectList[Dummy];
        Exit;
      end;
    end;
  end
  else
  begin
    // Verknüpfter bezeichner wird gesucht
    Parts := Explode('.', LookUp);
    Assert(Length(Parts) > 0, 'Blub' + LookUp);
    Result := False;
    Parent := 0;
    for Dummy := 0 to high(Parts) do
    begin
      FindString := Trim(Parts[Dummy]);
      if AnsiStrings.AnsiPos('[', FindString) > 0 then
        FindString := TbtString(Copy(FindString, 1, AnsiStrings.AnsiPos('[', FindString) - 1));

      if AnsiStrings.AnsiPos('(', FindString) > 0 then
        FindString := TbtString(Copy(FindString, 1, AnsiStrings.AnsiPos('(', FindString) - 1));

      if not FindEntry(FindString, Parent, ParamInfo) then
        Exit;

      Parent := ParamInfo.ReturnTyp;
    end;
    Result := True;
  end;
end;

procedure TdmPascalScript.AssignScript(Script: TStrings);
begin
  PSScriptDebugger1.Script.Assign(Script);
end;

procedure TdmPascalScript.BuildLokalObjektList(Comp: TPSPascalCompiler);
var
  Dummy: Integer;
  VDummy: Integer;
  Info: TParamInfoRecord;
  Typ: TPSType;
  RegProc: TPSRegProc;
  Proc: TPSProcedure;
  ProcInt: TPSInternalProcedure;
  con: TPSConstant;
  Father: Cardinal;

  procedure ClearInfoRec;
  begin
    Info.Name := 0;
    Info.OrgName := '';
    Info.Params := '';
    Info.OrgParams := '';
    Info.Father := 0;
    Info.ReturnTyp := 0;
    Info.HasFields := False;
    Info.SubType := 0;
  end;

  procedure AddTypeInfo(Hash: Cardinal; BaseType: Integer);
  begin
    fTypeInfos.InsertID(Hash, BaseType);
  end;

  procedure AddInfo(var Info: TParamInfoRecord);
  begin
    if (Length(Info.OrgName) < 1) or CharInSet(Info.OrgName[1], ['!', ' ', '_']) then
    begin
      ClearInfoRec;
      Exit;
    end;

    Info.Name := HashString(Info.OrgName);
    SetLength(fObjectList, Length(fObjectList) + 1);
    fObjectList[high(fObjectList)] := Info;
    ClearInfoRec;
  end;

  function TypHasField(Typ: TPSType): Boolean;
  begin
    Result := (Typ is TPSClassType) or (Typ is TPSRecordType);
  end;

  procedure AddVar(Name: TbtString; Typ: TPSType; InfoType: TInfoType = itVar); overload;
  begin
    Info.OrgName := name;

    Info.OrgParams := ': ' + GetTypeName(Typ);
    Info.ReturnTyp := HashString(GetTypeName(Typ));
    Info.HasFields := TypHasField(Typ);
    Info.Typ := itVar;
    AddInfo(Info);
  end;

  procedure AddVar(Vari: TPSVar); overload;
  begin
    if Vari.ClassType = TPSVar then
      AddVar(Vari.OrgName, Vari.aType)
    else
      AddVar(Vari.Name, Vari.aType);
  end;

  procedure SetParams(var Info: TParamInfoRecord; Parameters: TPSParametersDecl);
  var
    Params: TbtString;
  begin
    Info.OrgParams := GetParams(Parameters);
    Params := GetParams(Parameters, '"');

    Params := TbtString(Copy(string(Params), AnsiStrings.AnsiPos('(', Params) + 1, Length(Params)));
    Params := TbtString(Copy(string(Params), 1, AnsiStrings.AnsiPos(')', Params) - 1));
    Params := AnsiStrings.StringReplace(Params, ';', ',', [rfReplaceAll]);

    Info.Params := Params;
  end;

  procedure AddProcedure(Name: TbtString; Parameters: TPSParametersDecl);
  begin
    Info.OrgName := name;

    SetParams(Info, Parameters);

    if Parameters.Result = nil then
      Info.Typ := itProcedure
    else
    begin
      Info.Typ := itFunction;
      Info.ReturnTyp := HashString(GetTypeName(Parameters.Result));
      Info.HasFields := TypHasField(Parameters.Result);
    end;

    AddInfo(Info);
  end;

begin
  SetLength(fObjectList, 0);
  fTypeInfos.ClearList;
  ClearInfoRec;
  // Lokale Variablen
  for Dummy := 1 to Comp.GetProcCount - 1 do
  begin
    Proc := Comp.GetProc(Dummy);
    if Proc is TPSInternalProcedure then
    begin
      ProcInt := TPSInternalProcedure(Proc);
      for VDummy := 0 to ProcInt.ProcVars.Count - 1 do
      begin
        AddVar(TPSVar(ProcInt.ProcVars[VDummy]));
      end;
    end;
  end;

  // Parameter der letzten Funktion (Es wird davon ausgegangen, dass der Cursor
  // in der letzten Funktion steht und somit nur diese Paramter sichtbar sind)
  Proc := Comp.GetProc(Comp.GetProcCount - 1);
  if Proc is TPSInternalProcedure then
  begin
    ProcInt := TPSInternalProcedure(Proc);
    if ProcInt.Decl <> nil then
    begin
      for Dummy := 0 to ProcInt.Decl.ParamCount - 1 do
        AddVar(ProcInt.Decl.Params[Dummy].OrgName, ProcInt.Decl.Params[Dummy].aType);

      if ProcInt.Decl.Result <> nil then
        AddVar('result', ProcInt.Decl.Result);
    end;
  end;

  // Globale Variablen
  for Dummy := 0 to Comp.GetVarCount - 1 do
    AddVar(Comp.GetVar(Dummy));

  // Eigene Funktionen
  // Bei 1 beginnen (0 = main_proc)
  for Dummy := 1 to Comp.GetProcCount - 1 do
  begin
    Proc := Comp.GetProc(Dummy);
    if Proc is TPSInternalProcedure then
    begin
      ProcInt := TPSInternalProcedure(Proc);
      AddProcedure(ProcInt.OriginalName, ProcInt.Decl);
    end;
  end;

  // registrierte Funktionen
  for Dummy := 0 to Comp.GetRegProcCount - 1 do
  begin
    RegProc := Comp.GetRegProc(Dummy);
    if RegProc.NameHash > 0 then // on exclut les property helpers
      AddProcedure(RegProc.OrgName, RegProc.Decl);
  end;

  // Konstanten
  for Dummy := 0 to Comp.GetConstCount - 1 do
  begin
    con := TPSConstant(Comp.GetConst(Dummy));

    Info.OrgName := con.OrgName;

    Info.OrgParams := ': ' + GetTypeName(con.Value.FType);
    Info.ReturnTyp := HashString(GetTypeName(con.Value.FType));
    Info.HasFields := TypHasField(con.Value.FType);
    Info.Nr := con.Value.ts32;
    Info.Typ := itConstant;
    AddInfo(Info);
  end;

  // Typen übernehmen
  for Dummy := 0 to Comp.GetTypeCount - 1 do
  begin
    Typ := Comp.GetType(Dummy);

    Info.OrgName := Typ.OriginalName;

    Info.ReturnTyp := HashString(Typ.OriginalName);
    Info.Params := '"CastValue"';
    Info.Typ := itType;

    if Typ.OriginalName <> '' then
      AddTypeInfo(Info.ReturnTyp, Typ.BaseType);

    if Typ is TPSSetType then
      Info.SubType := HashString(TPSSetType(Typ).SetType.OriginalName)
    else if Typ is TPSArrayType then
      Info.SubType := HashString(TPSArrayType(Typ).ArrayTypeNo.OriginalName)
    else if Typ is TPSClassType then
    begin
      if TPSClassType(Typ).Cl.ClassInheritsFrom <> nil then
        Info.SubType := HashString(TPSClassType(Typ).Cl.ClassInheritsFrom.aType.OriginalName);
    end;

    AddInfo(Info);

    Father := HashString(Typ.OriginalName);

    if Typ is TPSRecordType then
    begin
      for VDummy := 0 to TPSRecordType(Typ).RecValCount - 1 do
      begin
        ClearInfoRec;
        with TPSRecordType(Typ).RecVal(VDummy) do
        begin
          Info.OrgName := FieldOrgName;

          Info.OrgParams := ': ' + GetTypeName(aType);
          Info.Typ := itField;
          Info.Father := Father;
          if aType.OriginalName <> '' then
            Info.ReturnTyp := HashString(aType.OriginalName)
          else
          begin
            if aType.ClassType = TPSArrayType then
            begin
              if TPSArrayType(TPSRecordType(Typ).RecVal(VDummy).aType).ArrayTypeNo <> nil then
                Info.ReturnTyp := HashString(GetTypeName(TPSArrayType(TPSRecordType(Typ).RecVal(VDummy).aType).ArrayTypeNo));
            end;
          end;
          Info.Nr := VDummy;
          AddInfo(Info);
        end;
      end;
    end;

    if Typ is TPSClassType then
    begin
      for VDummy := 0 to TPSClassType(Typ).Cl.Count - 1 do
      begin
        ClearInfoRec;
        with TPSClassType(Typ).Cl.Items[VDummy] do
        begin
          Info.OrgName := OrgName;
          Info.Father := Father;

          SetParams(Info, Decl);

          if Decl.Result <> nil then
            Info.ReturnTyp := HashString(GetTypeName(Decl.Result));

          if ClassType = TPSDelphiClassItemProperty then
            Info.Typ := itField
          else if ClassType = TPSDelphiClassItemConstructor then
            Info.Typ := itConstructor
          else
          begin
            if Decl.Result = nil then
              Info.Typ := itProcedure
            else
              Info.Typ := itFunction;
          end;
          AddInfo(Info);
        end;
      end;
    end;
  end;
end;

function TdmPascalScript.Compile(Script: TScript; out Msg: IMessageInfo): Boolean;
var
  I: LongInt;
begin
  FRunningScript := Script;
  // PSScriptDebugger1.MainFileName := TbtString(FRunningScript.ScriptUnitName);
  FMasterEngine.GetScriptLines(FRunningScript, PSScriptDebugger1.Script);
  Result := PSScriptDebugger1.Compile;
  FMasterEngine.DebugPlugin.Messages.Clear;
  Msg := nil;
  for I := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
    with PSScriptDebugger1.CompilerMessages[I] do
      if ClassType = TPSPascalCompilerWarning then
        FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmWarning, Row, Col)
      else if ClassType = TPSPascalCompilerHint then
        FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmHint, Row, Col)
      else if ClassType = TPSPascalCompilerError then
      begin
        Msg := FMasterEngine.DebugPlugin.Messages[FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString),
          tmError, Row, Col)];
      end
      else
        FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmUnknown, Row, Col);
end;

function TdmPascalScript.Execute: Boolean;
begin
  FMasterEngine.AlbumToImport.Clear;
  if Assigned(FMasterEngine.Console) then
    FMasterEngine.Console.Clear;
  if PSScriptDebugger1.Execute then
  begin
    ErrorLine := 0;
    Result := True;
  end
  else
  begin
    ErrorLine := PSScriptDebugger1.ExecErrorRow;
    ErrorUnitName := string(PSScriptDebugger1.ExecErrorFileName);
    FMasterEngine.DebugPlugin.Messages.AddRuntimeErrorMessage(ErrorUnitName,
      Format('%s (Bytecode %d:%d)', [PSScriptDebugger1.ExecErrorToString, PSScriptDebugger1.ExecErrorProcNo, PSScriptDebugger1.ExecErrorByteCodePosition]),
      PSScriptDebugger1.ExecErrorRow, PSScriptDebugger1.ExecErrorCol);
    Result := False;
  end;
end;

procedure TdmPascalScript.FillAutoComplete(Proposal, Code: TStrings; var List: TParamInfoArray; Types: TInfoTypes; FromFather: Cardinal; Typ: TbtString);
var
  Dummy: Integer;
  Text, sTyp: string;
  HashT: Cardinal;
  Cl: TColor;
  Father: TParamInfoRecord;

  function CompareTypes(Typ1: Cardinal; Typ2: Cardinal): Boolean;
  var
    Type1, Type2: Integer;
    Info: TParamInfoRecord;
  begin
    if (Typ1 = 0) or (Typ2 = 0) then
    begin
      Result := False;
      Exit;
    end;

    if Typ1 = Typ2 then
    begin
      Result := True;
      Exit;
    end;

    Assert(fTypeInfos.FindKey(Typ1, Type1));
    Assert(fTypeInfos.FindKey(Typ2, Type2));
    Result := BaseTypeCompatible(Type1, Type2);

    if Result then
    begin
      // Prüfen, ob Records und Aufzählungen kompatibel sind
      if (Type1 = btEnum) or (Type1 = btRecord) then
      begin
        Result := Typ1 = Typ2;
        Exit;
      end;
    end;

    if not Result then
    begin
      // Klassenkompatibilität prüfen
      if LookUpList(Typ2, Info) then
      begin
        while Info.SubType <> 0 do
        begin
          Assert(LookUpList(Info.SubType, Info));
          if Info.ReturnTyp = Typ1 then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;

  function HasFieldReturnTyp(ReturnTyp: Cardinal; FatherTyp: Cardinal): Boolean;
  var
    Dummy: Integer;
  begin
    Result := False;
    if (FatherTyp = 0) or (ReturnTyp = 0) then
      Exit;

    for Dummy := 0 to high(List) do
    begin
      if List[Dummy].Typ = itConstructor then
        Continue;

      if (List[Dummy].Father = FatherTyp) then
      begin
        if (CompareTypes(ReturnTyp, List[Dummy].ReturnTyp)) then
        begin
          Result := True;
          Exit;
        end;
        if List[Dummy].HasFields then
        begin
          if HasFieldReturnTyp(ReturnTyp, List[Dummy].Name) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
      if List[Dummy].Name = FatherTyp then
      begin
        if List[Dummy].SubType <> 0 then
        begin
          if HasFieldReturnTyp(ReturnTyp, List[Dummy].SubType) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;

var
  sl1, sl2: TStringList;
  I: Integer;
begin
  if LookUpList(FromFather, Father) then
  begin
    if Father.SubType <> 0 then
    begin
      for Dummy := 0 to high(List) do
      begin
        if List[Dummy].Name = Father.SubType then
        begin
          FillAutoComplete(Proposal, Code, List, Types, List[Dummy].Name, Typ);
          break;
        end;
      end;
    end;
  end;
  HashT := HashString(Typ);

  sl1 := TStringList.Create;
  sl2 := TStringList.Create;

  try

    for Dummy := 0 to high(List) do
    begin
      with List[Dummy] do
      begin
        if (Typ in Types) and (Father = FromFather) and ((HashT = 0) or (CompareTypes(HashT, ReturnTyp)) or (HashT = ReturnTyp) or HasFields) then
        begin
          Cl := clBlack;
          case Typ of
            itProcedure:
              begin
                Text := 'procedure ';
                Cl := clTeal;
              end;
            itFunction:
              begin
                Text := 'function ';
                Cl := clBlue;
              end;
            itType:
              begin
                Text := 'type ';
                Cl := clTeal;
              end;
            itVar:
              begin
                Text := 'var ';
                Cl := clMaroon;
              end;
            itConstant:
              begin
                Text := 'const ';
                Cl := clGreen;
              end;
            itField:
              begin
                Text := 'property ';
                Cl := clTeal;
              end;
            itConstructor:
              begin
                Text := 'constructor ';
                Cl := clTeal;
              end;
          else
            Assert(False);
          end;
          sTyp := Text;

          if HasFields and (HashT <> 0) and (HashT <> ReturnTyp) then
          begin
            if HasFieldReturnTyp(HashT, ReturnTyp) then
              Text := '\color{' + ColorToString(Cl) + '}' + Text + '\column{}\color{0}\style{+B}' + string(OrgName) + '...\style{-B}'
            else
              Continue;
          end
          else
          begin
            Text := '\color{' + ColorToString(Cl) + '}' + Text + '\column{}\color{0}\style{+B}' + string(OrgName) + '\style{-B}';
            if Typ <> itConstructor then
              Text := Text + string(OrgParams);
          end;

          sl1.AddObject(string(OrgName), Pointer(sl2.Count));
          sl2.Add(Text);
        end;
      end;
    end;

    sl1.Sort;
    for I := 0 to Pred(sl1.Count) do
    begin
      Code.Add(sl1[I]);
      Proposal.Add(sl2[Integer(sl1.Objects[I])]);
    end;
  finally
    sl1.Free;
    sl2.Free;
  end;

  if (Proposal.Count = 0) and (HashT <> 0) then
    FillAutoComplete(Proposal, Code, List, Types, FromFather);
end;

function TdmPascalScript.FindParameter(LocLine: TbtString; X: Integer; out Func: TParamInfoRecord; out ParamCount: Integer): Boolean;
var
  TmpX: Integer;
  StartX, ParenCounter: Integer;
  LookUp: TbtString;
begin
  { TODO : grosse lacune, la fonction ne gère pas du tout si la parenthèse est dans une chaine ou non }

  // go back from the cursor and find the first open paren
  TmpX := X;
  if TmpX > Length(LocLine) then
    TmpX := Length(LocLine)
  else
    Dec(TmpX);

  Result := False;
  ParamCount := 0;
  while (TmpX > 0) and not(Result) do
  begin
    if LocLine[TmpX] = ';' then
      Exit
    else if LocLine[TmpX] = ',' then
    begin
      Inc(ParamCount);
      Dec(TmpX);
    end
    else if LocLine[TmpX] = ')' then
    begin
      // We found a close, go till it's opening paren
      ParenCounter := 1;
      Dec(TmpX);
      while (TmpX > 0) and (ParenCounter > 0) do
      begin
        if LocLine[TmpX] = ')' then
          Inc(ParenCounter)
        else if LocLine[TmpX] = '(' then
          Dec(ParenCounter);

        Dec(TmpX);
      end;
    end
    else if LocLine[TmpX] = '(' then
    begin
      // we have a valid open paren, lets see what the word before it is
      StartX := TmpX;
      LookUp := GetLookUpString(LocLine, TmpX - 1);
      if LookUp = '' then
        Exit;
      Result := LookUpList(LookUp, Func) and (Func.Typ in [itProcedure, itFunction, itType]);
      if not Result then
      begin
        TmpX := StartX;
        Dec(TmpX);
      end;
    end
    else
      Dec(TmpX);
  end;
end;

procedure TdmPascalScript.RebuildLokalObjektList(CurrentEditor: TScriptEditor);
begin
  PSScriptDebugger1.Script.Assign(CurrentEditor.Lines);
  PSScriptDebugger1.Script[CurrentEditor.CaretXY.Line - 1] := '';
  PSScriptDebugger1.Compile;
end;

procedure TdmPascalScript.ResetBreakpoints;
var
  bp: IBreakpointInfo;
begin
  PSScriptDebugger1.ClearBreakPoints;
  if PSScriptDebugger1.UseDebugInfo then
    for bp in FMasterEngine.DebugPlugin.Breakpoints do
      if bp.Active then
        PSScriptDebugger1.SetBreakPoint(TbtString(bp.Script.ScriptUnitName), bp.Line);
end;

{ TPascalScriptEngineFactory }

constructor TPascalScriptEngineFactory.Create(MasterEngine: IMasterEngine);
begin
  inherited;
  FMasterEngine := MasterEngine;
end;

destructor TPascalScriptEngineFactory.Destroy;
begin
  FMasterEngine := nil;
  inherited;
end;

function TPascalScriptEngineFactory.GetInstance: IEngineInterface;
begin
  Result := TdmPascalScript.Create(FMasterEngine);
end;

initialization

RegisterEngineScript(sePascalScript, TPascalScriptEngineFactory);

end.
