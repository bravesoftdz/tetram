unit UfrmScripts;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, ImgList,
  StrUtils, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, Menus, SynEditTypes, ComCtrls, UScriptUtils, uPSUtils, VirtualTrees, StdCtrls,
  ExtCtrls, LoadComplet, SynEditKeyCmds, SynCompletionProposal, UBdtForms, IDHashMap, Generics.Collections, ToolWin, UfrmFond, uPSComponent,
  PngImageList, UdmScripts, UScriptList, UScriptDebug, UScriptEdition, uPSCompiler, UframBoutons, EditLabeled;

type
  TfrmScripts = class(TbdtForm)
    SynPasSyn1: TSynPasSyn;
    SynEditSearch1: TSynEditSearch;
    ActionList1: TActionList;
    EditCut1: TAction;
    EditCopy1: TAction;
    EditPaste1: TAction;
    EditSelectAll1: TAction;
    EditUndo1: TAction;
    SearchFind1: TAction;
    SearchFindNext1: TAction;
    MainMenu1: TMainMenu;
    Edition1: TMenuItem;
    Remplacer1: TMenuItem;
    Chercher1: TMenuItem;
    N2: TMenuItem;
    Coller1: TMenuItem;
    Copier1: TMenuItem;
    Couper1: TMenuItem;
    N3: TMenuItem;
    Dfaire1: TMenuItem;
    Copier2: TMenuItem;
    outslectionner1: TMenuItem;
    SearchReplace1: TAction;
    EditRedo1: TAction;
    Refaire1: TMenuItem;
    Chercher2: TMenuItem;
    actRun: TAction;
    actCompile: TAction;
    actStepOver: TAction;
    actStepInto: TAction;
    actReset: TAction;
    actDecompile: TAction;
    a1: TMenuItem;
    actBreakpoint: TAction;
    N4: TMenuItem;
    Basculerpointdarrt1: TMenuItem;
    actAddSuivi: TAction;
    actAddSuivi1: TMenuItem;
    actRunToCursor: TAction;
    Jusquaucurseur1: TMenuItem;
    PopupMenu1: TPopupMenu;
    actFermer: TAction;
    actEnregistrer: TAction;
    Fermer1: TMenuItem;
    N6: TMenuItem;
    Enregistrer1: TMenuItem;
    PageControl2: TPageControl;
    tbEdition: TTabSheet;
    ToolBar2: TToolBar;
    Splitter1: TSplitter;
    pcScripts: TPageControl;
    tbScripts: TTabSheet;
    actRunWithoutDebug: TAction;
    Excutersansdbuguer1: TMenuItem;
    SynEditParamShow: TSynCompletionProposal;
    SynEditAutoComplete: TSynCompletionProposal;
    actEdit: TAction;
    PopupMenu2: TPopupMenu;
    actCreerOption: TAction;
    actRetirerOption: TAction;
    Creruneoption1: TMenuItem;
    Retireruneoption1: TMenuItem;
    actModifierOption: TAction;
    Modifieruneoption1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Panel2: TPanel;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    lstDebugImages: TPngImageList;
    ToolButton7: TToolButton;
    actPause: TAction;
    framBoutons1: TframBoutons;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    vstMessages: TVirtualStringTree;
    TabSheet2: TTabSheet;
    vstSuivis: TVirtualStringTree;
    TabSheet3: TTabSheet;
    vstBreakpoints: TVirtualStringTree;
    TabSheet6: TTabSheet;
    mmConsole: TMemo;
    Splitter2: TSplitter;
    Panel3: TPageControl;
    TabSheet4: TTabSheet;
    ListBox1: TListBox;
    Panel4: TPanel;
    ListBox2: TListBox;
    Splitter3: TSplitter;
    ListView1: TListView;
    Label1: TLabel;
    Panel5: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    TabSheet5: TTabSheet;
    EditLabeled1: TEditLabeled;
    MemoLabeled1: TMemoLabeled;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EditLabeled2: TEditLabeled;
    EditLabeled3: TEditLabeled;
    Button1: TButton;
    Alias: TTabSheet;
    Memo2: TMemo;
    procedure seScript1GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure seScript1GutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure seScript1SpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure seScript1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure SearchFind1Execute(Sender: TObject);
    procedure SearchFindNext1Execute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure EditCut1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditUndo1Execute(Sender: TObject);
    procedure EditRedo1Execute(Sender: TObject);
    procedure seScript1ReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure actCompileExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actStepOverExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actResetExecute(Sender: TObject);
    procedure actDecompileExecute(Sender: TObject);
    procedure actBreakpointExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddSuiviExecute(Sender: TObject);
    procedure actRunToCursorExecute(Sender: TObject);
    procedure vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstMessagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seScript1Change(Sender: TObject);
    procedure vstBreakpointsDblClick(Sender: TObject);
    procedure vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure seScript1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure actFermerExecute(Sender: TObject);
    procedure actEnregistrerExecute(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure seScript1ProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure actRunWithoutDebugExecute(Sender: TObject);
    procedure pcScriptsChange(Sender: TObject);
    procedure seScript1KeyPress(Sender: TObject; var Key: Char);
    procedure PageControl2Change(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListBox1Data(Control: TWinControl; index: Integer; var Data: string);
    procedure ListBox1DblClick(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actCreerOptionExecute(Sender: TObject);
    procedure actRetirerOptionExecute(Sender: TObject);
    procedure actModifierOptionExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure mmConsoleChange(Sender: TObject);
    procedure SynEditParamShowExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer; var CanExecute: Boolean);
    procedure SynEditAutoCompleteExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer;
      var CanExecute: Boolean);
    procedure framBoutons1btnAnnulerClick(Sender: TObject);
    procedure EditLabeled1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FCompiled: Boolean;
    FProjetOuvert: Boolean;
    FForceClose: Boolean;

    fObjectList: TParamInfoArray;
    fTypeInfos: TIDHashMap;

    FCurrentScript, FProjetScript: TScriptEdition;
    FScriptList: TScriptListEdition;
    FOpenedScript: TObjectList<TScriptEdition>;
    FRefreshingDescription: Boolean;
{$REGION 'Exécution'}
    function Compile: Boolean;
    function Execute: Boolean;
    procedure PSScriptDebugger1AfterExecute(Sender: TPSScript);
    procedure PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1Idle(Sender: TObject);
    procedure PSScriptDebugger1LineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
{$ENDREGION}
    procedure WMSyscommand(var msg: TWmSysCommand);
    message WM_SYSCOMMAND;
{$REGION 'Débuggage'}
    procedure GoToPosition(Editor: TSynEdit; Line, Char: Cardinal); overload;
    procedure GoToPosition(Script: AnsiString; Line, Char: Cardinal); overload; inline;
    procedure GoToMessage(msg: TMessageInfo);
    procedure GoToBreakpoint(msg: TBreakpointInfo);
{$ENDREGION}
    function GetScript(const Script: AnsiString): TSynEdit;
    procedure SetCompiled(const Value: Boolean);
    function GetProjet: AnsiString;
    procedure SetProjet(const Value: AnsiString);
    procedure LoadScript(const Script: AnsiString);
    procedure RefreshOptions;
    procedure RefreshDescription(Script: TScriptEdition);
    function EditOption(Option: TOption): Boolean;
    procedure ClearPages;
    procedure SetProjetOuvert(const Value: Boolean);
    procedure LoadScripts;
{$REGION 'Auto completion'}
    procedure RebuildLokalObjektList;
    procedure BuildLokalObjektList(Comp: TPSPascalCompiler);
    function FindParameter(LocLine: AnsiString; X: Integer; out Func: TParamInfoRecord; out ParamCount: Integer): Boolean;
    function GetLookUpString(Line: AnsiString; EndPos: Integer): AnsiString;
    function LookUpList(LookUp: AnsiString; var ParamInfo: TParamInfoRecord): Boolean; overload;
    function LookUpList(LookUp: Cardinal; var ParamInfo: TParamInfoRecord): Boolean; overload;
    procedure FillAutoComplete(var List: TParamInfoArray; Types: TInfoTypes; FromFather: Cardinal = 0; Typ: AnsiString = '');
{$ENDREGION}
  public
    dmScripts: TdmScripts;
    property Compiled: Boolean read FCompiled write SetCompiled;
    property Projet: AnsiString read GetProjet write SetProjet;
    property ProjetOuvert: Boolean read FProjetOuvert write SetProjetOuvert;
  end;

var
  frmScripts: TfrmScripts;

implementation

{$R *.dfm}

uses AnsiStrings, UfrmScriptSearch, UScriptsFonctions, CommonConst, uPSPreProcessor, UIB, Procedures, BdtkRegEx, Commun, Divers,
  UScriptsHTMLFunctions, JclSimpleXML, UdmPrinc, UfrmScriptOption, UfrmScriptEditOption, uPSDebugger, uPSRuntime, UfrmScriptsUpdate;

type
  TMySynEdit = class(SynEdit.TSynEdit)
  published
    property BevelKind;
  end;

function TfrmScripts.GetScript(const Script: AnsiString): TSynEdit;
begin
  if Script = '' then
    Result := FScriptList.EditorByScriptName(Projet)
  else
    Result := FScriptList.EditorByScriptName(Script);
end;
{$REGION 'Auto completion'}

function AutoCompleteCompilerBeforeCleanUp(Sender: TPSPascalCompiler): Boolean;
var
  s: AnsiString;
begin
  with TPSScriptDebugger(Sender.ID) do
    if Comp.GetOutput(s) then
      TfrmScripts(Owner.Owner).BuildLokalObjektList(Sender);
  Result := True;
end;

procedure TfrmScripts.BuildLokalObjektList(Comp: TPSPascalCompiler);
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
    Info.name := 0;
    Info.OrgName := '';
    Info.Params := '';
    Info.OrgParams := '';
    Info.Father := 0;
    Info.ReturnTyp := 0;
    Info.HasFields := false;
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

    Info.name := HashString(Info.OrgName);
    SetLength(fObjectList, Length(fObjectList) + 1);
    fObjectList[ high(fObjectList)] := Info;
    ClearInfoRec;
  end;

  function TypHasField(Typ: TPSType): Boolean;
  begin
    Result := (Typ is TPSClassType) or (Typ is TPSRecordType);
  end;

  procedure AddVar(name: AnsiString; Typ: TPSType; InfoType: TInfoType = itVar); overload;
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
      AddVar(Vari.name, Vari.aType);
  end;

  procedure SetParams(var Info: TParamInfoRecord; Parameters: TPSParametersDecl);
  var
    Params: AnsiString;
  begin
    Info.OrgParams := GetParams(Parameters);
    Params := GetParams(Parameters, '"');

    Params := AnsiString(Copy(string(Params), AnsiStrings.AnsiPos('(', Params) + 1, Length(Params)));
    Params := AnsiString(Copy(string(Params), 1, AnsiStrings.AnsiPos(')', Params) - 1));
    Params := AnsiStrings.StringReplace(Params, ';', ',', [rfReplaceAll]);

    Info.Params := Params;
  end;

  procedure AddProcedure(name: AnsiString; Parameters: TPSParametersDecl);
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

procedure TfrmScripts.Button1Click(Sender: TObject);
begin
  with TfrmScriptsUpdate.Create(nil) do
    try
      dmScripts := Self.dmScripts;
      ShowModal;
    finally
      Free;
    end;
  LoadScripts;
end;

procedure TfrmScripts.RebuildLokalObjektList;
var
  Script: TStringList;
begin
  Script := TStringList.Create;
  try
    Script.Assign(FCurrentScript.Editor.Lines);
    Script[FCurrentScript.Editor.CaretXY.Line - 1] := '';

    dmScripts.PSScriptDebugger1.Script.Assign(Script);
    dmScripts.PSScriptDebugger1.Compile;
  finally
    Script.Free;
  end;
end;

function TfrmScripts.GetLookUpString(Line: AnsiString; EndPos: Integer): AnsiString;
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
  WasSpace := false;
  CanSpace := True;
  while (TmpX > 0) and (SynPasSyn1.IsIdentChar(WideChar(Line[TmpX])) or CharInSet(Line[TmpX], TSynValidIdentifierChars) or (ParenCount > 0)) do
  begin
    case Line[TmpX] of
      ')', ']': inc(ParenCount);
      '(', '[':
        begin
          if ParenCount = 0 then
            break;
          dec(ParenCount);
        end;
      '.':
        begin
          CanSpace := True;
          WasSpace := false;
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
          WasSpace := false;
          CanSpace := false;
        end;
      end;

    dec(TmpX);
  end;

  if ParenCount = 0 then
    Result := AnsiString(Copy(Line, TmpX + 1, EndPos - TmpX))
  else
    Result := '';

end;

function TfrmScripts.FindParameter(LocLine: AnsiString; X: Integer; out Func: TParamInfoRecord; out ParamCount: Integer): Boolean;
var
  TmpX: Integer;
  StartX, ParenCounter: Integer;
  LookUp: AnsiString;
begin
  { TODO : grosse lacune, la fonction ne gère pas du tout si la parenthèse est dans une chaine ou non }

  // go back from the cursor and find the first open paren
  TmpX := X;
  if TmpX > Length(LocLine) then
    TmpX := Length(LocLine)
  else
    dec(TmpX);

  Result := false;
  ParamCount := 0;
  while (TmpX > 0) and not(Result) do
  begin
    if LocLine[TmpX] = ';' then
      Exit
    else if LocLine[TmpX] = ',' then
    begin
      inc(ParamCount);
      dec(TmpX);
    end
    else if LocLine[TmpX] = ')' then
    begin
      // We found a close, go till it's opening paren
      ParenCounter := 1;
      dec(TmpX);
      while (TmpX > 0) and (ParenCounter > 0) do
      begin
        if LocLine[TmpX] = ')' then
          inc(ParenCounter)
        else if LocLine[TmpX] = '(' then
          dec(ParenCounter);

        dec(TmpX);
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
        dec(TmpX);
      end;
    end
    else
      dec(TmpX);
  end;
end;

function TfrmScripts.LookUpList(LookUp: AnsiString; var ParamInfo: TParamInfoRecord): Boolean;
var
  Dummy: Integer;
  Hash: Cardinal;
  Parts: TStringArray;
  FindString: AnsiString;
  Parent: Cardinal;

  function FindEntry(LookUp: AnsiString; Parent: Cardinal; var ParamInfo: TParamInfoRecord): Boolean;
  var
    Dummy: Integer;
    Hash: Cardinal;
  begin
    Hash := HashString(LookUp);
    Result := false;
    for Dummy := 0 to high(fObjectList) do
    begin
      if (fObjectList[Dummy].name = Hash) and (fObjectList[Dummy].Father = Parent) then
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
    Result := false;
    for Dummy := 0 to high(fObjectList) do
    begin
      if (fObjectList[Dummy].name = Hash) and (fObjectList[Dummy].Father = 0) then
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
    Result := false;
    Parent := 0;
    for Dummy := 0 to high(Parts) do
    begin
      FindString := Trim(Parts[Dummy]);
      if AnsiStrings.AnsiPos('[', FindString) > 0 then
        FindString := AnsiString(Copy(FindString, 1, AnsiStrings.AnsiPos('[', FindString) - 1));

      if AnsiStrings.AnsiPos('(', FindString) > 0 then
        FindString := AnsiString(Copy(FindString, 1, AnsiStrings.AnsiPos('(', FindString) - 1));

      if not FindEntry(FindString, Parent, ParamInfo) then
        Exit;

      Parent := ParamInfo.ReturnTyp;
    end;
    Result := True;
  end;
end;

function TfrmScripts.LookUpList(LookUp: Cardinal; var ParamInfo: TParamInfoRecord): Boolean;
var
  Dummy: Integer;
begin
  Result := false;
  for Dummy := 0 to high(fObjectList) do
  begin
    if (fObjectList[Dummy].name = LookUp) and (fObjectList[Dummy].Father = 0) then
    begin
      Result := True;
      ParamInfo := fObjectList[Dummy];
      Exit;
    end;
  end;
end;

procedure TfrmScripts.mmConsoleChange(Sender: TObject);
begin
  if (PageControl1.ActivePage <> TTabSheet(vstSuivis.Parent)) or (dmScripts.DebugPlugin.Watches.CountActive = 0) then
    PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  Application.ProcessMessages;
end;

procedure TfrmScripts.PageControl2Change(Sender: TObject);
begin
  if PageControl2.ActivePageIndex = 0 then
    ProjetOuvert := false;
  RefreshOptions;
  RefreshDescription(FProjetScript);
  Panel3.ActivePageIndex := 0;
end;

procedure TfrmScripts.SynEditAutoCompleteExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer;
  var CanExecute: Boolean);
var
  Parser: TPSPascalParser;
  Token: TPSPasToken;
  Prev: TPSPasToken;
  PrevEnd: Integer;
  Types: TInfoTypes;
  TmpX: Integer;
  Father: Cardinal;
  Line: AnsiString;
  Info: TParamInfoRecord;
  ParamCount: Integer;
  Parts: TStringArray;
  Typ: AnsiString;
  Obj: AnsiString;
  Editor: TSynEdit;
  hasAssign: Boolean;
begin
  Editor := FCurrentScript.Editor;
  RebuildLokalObjektList;

  Line := AnsiString(Editor.LineText);

  Types := [itProcedure, itFunction, itVar];
  Parser := TPSPascalParser.Create;
  try
    Parser.SetText(Line);

    Father := 0;
    Typ := '';

    CanExecute := false;

    Prev := CSTI_EOF;
    Token := CSTI_EOF;
    PrevEnd := -1;
    hasAssign := false;
    while (Parser.CurrTokenID <> CSTI_EOF) and (Parser.CurrTokenPos < Cardinal(Editor.CaretX - 1)) do
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
            if LookUpList(AnsiString(Copy(Editor.LineText, 1, Parser.CurrTokenPos)), Info) then
              Typ := AnsiString(Copy(Info.OrgParams, 3, Length(Info.OrgParams)));
            hasAssign := True;
          end;
        CSTI_OpenRound:
          begin
            Types := [itFunction, itVar, itConstant { , itType } ];
            hasAssign := True;
          end;
        CSTI_SemiColon:
          begin
            hasAssign := false;
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

  if (PrevEnd < (Editor.CaretX - 1)) then
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
        TmpX := Editor.CaretX - 1;
        if TmpX > Length(Line) then
          TmpX := Length(Line);

        while (TmpX > 0) and (Line[TmpX] <> '.') do
          dec(TmpX);

        dec(TmpX);

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

  if (Prev <> CSTI_AddressOf) and FindParameter(AnsiString(Editor.LineText), Editor.CaretX, Info, ParamCount) then
  begin
    Parts := Explode(',', Info.Params);
    if ParamCount <= high(Parts) then
    begin
      if AnsiStrings.AnsiPos(':', Parts[ParamCount]) > 0 then
      begin
        Typ := AnsiString(Copy(Parts[ParamCount], AnsiStrings.AnsiPos(':', Parts[ParamCount]) + 2, Length(Parts[ParamCount])));
        Typ := AnsiString(Copy(Typ, 1, Length(Typ) - 1));
      end
      else
        Typ := '';

      Exclude(Types, itProcedure);
    end;
  end;

  CanExecute := True;
  FillAutoComplete(fObjectList, Types, Father, Typ);
end;

procedure TfrmScripts.SynEditParamShowExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer;
  var CanExecute: Boolean);
var
  ParamIndex: Integer;
  Info: TParamInfoRecord;
  Editor: TSynEdit;
begin
  RebuildLokalObjektList;

  Editor := FCurrentScript.Editor;
  CanExecute := FindParameter(AnsiString(Editor.LineText), Editor.CaretX, Info, ParamIndex);

  TSynCompletionProposal(Sender).ItemList.Clear;

  if CanExecute then
  begin
    TSynCompletionProposal(Sender).Form.CurrentIndex := ParamIndex;
    if Info.Params = '' then
      Info.Params := '"* Pas de paramètre *"';

    TSynCompletionProposal(Sender).ItemList.Add(string(Info.Params));
  end;
end;

procedure TfrmScripts.FillAutoComplete(var List: TParamInfoArray; Types: TInfoTypes; FromFather: Cardinal; Typ: AnsiString);
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
      Result := false;
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
    Result := false;
    if (FatherTyp = 0) or (ReturnTyp = 0) then
      Exit;

    for Dummy := 0 to high(List) do
    begin
      if List[Dummy].Typ = itConstructor then
        continue;

      if (List[Dummy].Father = FatherTyp) then
      begin
        if (CompareTypes(ReturnTyp, List[Dummy].ReturnTyp)) then
        begin
          Result := True;
          Exit;
        end;
        if List[Dummy].HasFields then
        begin
          if HasFieldReturnTyp(ReturnTyp, List[Dummy].name) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
      if List[Dummy].name = FatherTyp then
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
  i: Integer;
begin
  SynEditAutoComplete.ClearList;
  SynEditAutoComplete.Columns[0].BiggestWord := '';
  if LookUpList(FromFather, Father) then
  begin
    if Father.SubType <> 0 then
    begin
      for Dummy := 0 to high(List) do
      begin
        if List[Dummy].name = Father.SubType then
        begin
          FillAutoComplete(List, Types, List[Dummy].name, Typ);
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
              Assert(false);
            end;
          sTyp := Text;

          if HasFields and (HashT <> 0) and (HashT <> ReturnTyp) then
          begin
            if HasFieldReturnTyp(HashT, ReturnTyp) then
              Text := '\color{' + ColorToString(Cl) + '}' + Text + '\column{}\color{0}\style{+B}' + string(OrgName) + '...\style{-B}'
            else
              continue;
          end
          else
          begin
            Text := '\color{' + ColorToString(Cl) + '}' + Text + '\column{}\color{0}\style{+B}' + string(OrgName) + '\style{-B}';
            if Typ <> itConstructor then
              Text := Text + string(OrgParams);
          end;

          sl1.AddObject(string(OrgName), Pointer(sl2.Count));
          sl2.Add(Text);
          if Length(sTyp) > Length(SynEditAutoComplete.Columns[0].BiggestWord) then
            SynEditAutoComplete.Columns[0].BiggestWord := sTyp;
        end;
      end;
    end;

    sl1.Sort;
    for i := 0 to Pred(sl1.Count) do
    begin
      SynEditAutoComplete.InsertList.Add(sl1[i]);
      SynEditAutoComplete.ItemList.Add(sl2[Integer(sl1.Objects[i])]);
    end;
  finally
    sl1.Free;
    sl2.Free;
  end;

  if (SynEditAutoComplete.InsertList.Count = 0) and (HashT <> 0) then
    FillAutoComplete(List, Types, FromFather);
end;
{$ENDREGION}
{$REGION 'Edition'}

const
  imgGutterBREAK = 0;
  imgGutterBREAKVALID = 1;
  imgGutterBREAKINVAL = 2;
  imgGutterCOMPLINE = 3;
  imgGutterEXECLINECL = 4;
  imgGutterEXECLINEBP = 5;
  imgGutterEXECLINE = 6;
  imgGutterBREAKDISABLED = 7;

procedure TfrmScripts.seScript1GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
begin
  if X <= TSynEdit(Sender).Gutter.LeftOffset then
    dmScripts.ToggleBreakPoint(FScriptList.ScriptName(TSynEdit(Sender)), Line, false);
end;

procedure TfrmScripts.seScript1GutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
  Script: AnsiString;
  Proc, Pos: Cardinal;
begin
  Script := FScriptList.ScriptName(TSynEdit(Sender));
  IconIndex := -1;
  i := dmScripts.DebugPlugin.Breakpoints.IndexOf(Script, aLine);
  if i <> -1 then
  begin
    if not dmScripts.Running then
      if dmScripts.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
      else
      begin
        if (Cardinal(aLine) = dmScripts.ActiveLine) and SameText(dmScripts.ActiveFile, Script) then
          IconIndex := imgGutterEXECLINEBP
        else if dmScripts.DebugPlugin.Breakpoints[i].Active then
          IconIndex := imgGutterBREAKVALID
        else
          IconIndex := imgGutterBREAKDISABLED;
      end;
  end
  else
  begin
    if (dmScripts.DebugMode = dmPaused) and (Cardinal(aLine) = dmScripts.ActiveLine) and SameText(dmScripts.ActiveFile, Script) then
      IconIndex := imgGutterEXECLINE;
  end;

  if Compiled then
    if dmScripts.TranslatePositionEx(Proc, Pos, aLine, Script) then
      case IconIndex of
        - 1: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKDISABLED: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAK: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKVALID: IconIndex := imgGutterCOMPLINE;
        imgGutterEXECLINE: IconIndex := imgGutterEXECLINECL;
      end
    else
      case IconIndex of
        imgGutterBREAK: IconIndex := imgGutterBREAKINVAL;
        imgGutterBREAKVALID: IconIndex := imgGutterBREAKINVAL;
      end;

  if IconIndex <> -1 then
    lstDebugImages.Draw(TSynEdit(Sender).Canvas, X, Y, IconIndex);
end;

procedure TfrmScripts.seScript1SpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  i: Integer;
  Script: AnsiString;
  Proc, Pos: Cardinal;
begin
  Script := FScriptList.ScriptName(TSynEdit(Sender));
  i := dmScripts.DebugPlugin.Breakpoints.IndexOf(Script, Line);

  if (Cardinal(Line) = dmScripts.ActiveLine) and SameText(dmScripts.ActiveFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else if i <> -1 then
  begin
    Special := True;
    if dmScripts.DebugPlugin.Breakpoints[i].Active then
    begin
      if Compiled and not dmScripts.TranslatePositionEx(Proc, Pos, Line, Script) then
      begin
        FG := clWhite;
        BG := clOlive;
      end
      else
      begin
        FG := clWhite;
        BG := clRed;
      end;
    end
    else
    begin
      FG := clRed;
      BG := clLime;
    end;
  end
  else if (dmScripts.ErrorLine > 0) and (Cardinal(Line) = dmScripts.ErrorLine) and SameText(dmScripts.ErrorFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := false;
end;

procedure TfrmScripts.seScript1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
  Attri: TSynHighlighterAttributes;
  Token: string;
  SB: TStatusBar;
  Editor: TSynEdit;
begin
  if (scCaretX in Changes) or (scCaretY in Changes) then
  begin
    Editor := TSynEdit(Sender);
    SB := FScriptList.InfoScript(Editor).SB;
    SB.Panels[0].Text := Format('%.3d : %.3d', [Editor.CaretY, Editor.CaretX]);
    if Editor.GetHighlighterAttriAtRowCol(Editor.CaretXY, Token, Attri) then
    begin
      SB.Panels[2].Text := Attri.name;
    end
    else
      SB.Panels[2].Text := '';
  end;
  if (scModified in Changes) then
  begin
    // FCurrentFile.Modified := EScript.Modified;
  end;
end;

procedure TfrmScripts.SearchFind1Execute(Sender: TObject);
var
  dummyReplace: string;
begin
  with FCurrentScript.Editor do
    if SelAvail and (BlockBegin.Line = BlockEnd.Line) then
    begin
      FLastSearch := SelText;
      Include(FSearchOptions, ssoSelectedOnly);
    end
    else
    begin
      FLastSearch := WordAtCursor;
      Exclude(FSearchOptions, ssoSelectedOnly);
    end;

  if Sender = SearchFind1 then
  begin
    // chercher
    Exclude(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TfrmScriptSearch.Execute(FLastSearch, dummyReplace, FSearchOptions) then
      Exit;
  end
  else
  begin
    // remplacer
    Include(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TfrmScriptSearch.Execute(FLastSearch, FLastReplace, FSearchOptions) then
      Exit;
  end;

  SearchFindNext1Execute(Sender);
end;

procedure TfrmScripts.SearchFindNext1Execute(Sender: TObject);
begin
  if FLastSearch = '' then
    SearchFind1Execute(SearchFind1)
  else if FCurrentScript.Editor.SearchReplace(FLastSearch, FLastReplace, FSearchOptions) = 0 then
    ShowMessage('Texte non trouvé');
end;

procedure TfrmScripts.EditCut1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.CutToClipboard;
end;

procedure TfrmScripts.EditLabeled1Change(Sender: TObject);
begin
  if FRefreshingDescription or not ProjetOuvert then
    Exit;
  if Sender = EditLabeled1 then
    FCurrentScript.ScriptInfos.Auteur := EditLabeled1.Text;
  if Sender = EditLabeled2 then
    FCurrentScript.ScriptInfos.ScriptVersion := EditLabeled2.Text;
  if Sender = EditLabeled3 then
    FCurrentScript.ScriptInfos.BDVersion := EditLabeled3.Text;
  if Sender = MemoLabeled1 then
    FCurrentScript.ScriptInfos.Description := MemoLabeled1.Text;
  if Sender = Memo2 then
    FCurrentScript.Alias.Assign(Memo2.Lines);
  FCurrentScript.Modifie := True;
end;

procedure TfrmScripts.EditCopy1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.CopyToClipboard;
end;

procedure TfrmScripts.EditPaste1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.PasteFromClipboard;
end;

procedure TfrmScripts.EditSelectAll1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.SelectAll;
end;

procedure TfrmScripts.EditUndo1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.Undo;
end;

procedure TfrmScripts.EditRedo1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.Redo;
end;

procedure TfrmScripts.seScript1ReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
begin
  case MessageDlg('Remplacer cette occurence ?', mtConfirmation, [mbYes, mbNo, mbCancel, mbYesToAll], 0) of
    mrYes: Action := raReplace;
    mrNo: Action := raSkip;
    mrCancel: Action := raCancel;
    mrYesToAll: Action := raReplaceAll;
  end;
end;

procedure TfrmScripts.seScript1Change(Sender: TObject);
var
  Script: TScriptEdition;
begin
  Compiled := false;
  Script := FScriptList.InfoScript(TSynEdit(Sender));
  Script.Modifie := True;

  if (dmScripts.ErrorLine > 0) then
  begin
    with FScriptList.EditorByScriptName(dmScripts.ErrorFile) do
    begin
      InvalidateLine(dmScripts.ErrorLine);
      InvalidateGutterLine(dmScripts.ErrorLine);
    end;
    dmScripts.ErrorLine := 0;
  end;
end;

procedure TfrmScripts.actFermerExecute(Sender: TObject);
begin
  if not FForceClose and (FCurrentScript.ScriptName = Projet) then
    Exit;

  if FCurrentScript.Modifie then
  begin
    case MessageDlg('L''unité "' + string(FCurrentScript.ScriptName) + '" a été modifiée, voulez-vous l''enregistrer?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes: actEnregistrer.Execute;
      mrNo: ;
      mrCancel: Abort;
    end;
  end;
  FOpenedScript.Delete(pcScripts.ActivePageIndex);
  pcScripts.ActivePage.Free;
  FCurrentScript.TabSheet := nil;
  FCurrentScript.Editor := nil;
  FCurrentScript.SB := nil;
  FCurrentScript.Modifie := false;
  FCurrentScript.Loaded := false;
  pcScriptsChange(nil);
end;

procedure TfrmScripts.actEditExecute(Sender: TObject);
begin
  Projet := AnsiString(ListView1.Selected.Caption);
end;

procedure TfrmScripts.actEnregistrerExecute(Sender: TObject);
begin
  with FOpenedScript[pcScripts.ActivePageIndex] do
  begin
    Code.Assign(Editor.Lines);
    Save;
  end;
end;

procedure TfrmScripts.ListBox1Data(Control: TWinControl; index: Integer; var Data: string);
begin
  Data := FProjetScript.Options[index].FLibelle + ': ' + FProjetScript.Options[index].FChooseValue;
end;

procedure TfrmScripts.ListBox1DblClick(Sender: TObject);
var
  Option: TOption;
begin
  if TListBox(Sender).ItemIndex = -1 then
    Exit;
  Option := FProjetScript.Options[TListBox(Sender).ItemIndex];

  with TfrmScriptOption.Create(nil) do
    try
      RadioGroup1.Caption := Option.FLibelle;
      RadioGroup1.Items.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
      RadioGroup1.ItemIndex := RadioGroup1.Items.IndexOf(Option.FChooseValue);
      RadioGroup1.Height := 21 + 20 * RadioGroup1.Items.Count;
      ClientHeight := RadioGroup1.Height + framBoutons1.Height + 4;
      if ShowModal = mrOk then
      begin
        Option.FChooseValue := RadioGroup1.Items[RadioGroup1.ItemIndex];

        with TUIBQuery.Create(nil) do
          try
            Transaction := GetTransaction(dmPrinc.UIBDataBase);
            SQL.Text := 'update or insert into options_scripts (script, nom_option, valeur) values (:script, :nom_option, :valeur)';
            Prepare(True);
            Params.AsString[0] := Copy(string(FProjetScript.ScriptName), 1, Params.SQLLen[0]);
            Params.AsString[1] := Copy(Option.FLibelle, 1, Params.SQLLen[1]);
            Params.AsString[2] := Copy(Option.FChooseValue, 1, Params.SQLLen[2]);
            Execute;
            Transaction.Commit;
          finally
            Transaction.Free;
            Free;
          end;

        RefreshOptions;
        RefreshDescription(FProjetScript);
      end;
    finally
      Free;
    end;
end;

procedure TfrmScripts.ListView1DblClick(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) then
    Exit;
  if actRunWithoutDebug.Enabled then
    actRunWithoutDebug.Execute
  else
    actEdit.Execute;
end;

procedure TfrmScripts.ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  Option: TOption;
begin
  if Selected and Assigned(Item) then
  begin
    FProjetScript := TScriptEdition(Item.Data);

    FProjetScript.Load;
    if FProjetScript.Options.Count > 0 then
      with TUIBQuery.Create(nil) do
        try
          Transaction := GetTransaction(dmPrinc.UIBDataBase);
          SQL.Text := 'select nom_option, valeur from options_scripts where script = :script';
          Prepare(True);
          Params.AsString[0] := Copy(string(FProjetScript.ScriptName), 1, Params.SQLLen[0]);
          Open;
          while not Eof do
          begin
            Option := FProjetScript.OptionByName(Fields.AsString[0]);
            if Assigned(Option) then
              Option.FChooseValue := Fields.AsString[1];
            Next;
          end;
        finally
          Transaction.Free;
          Free;
        end;
  end
  else
  begin
    // pour forcer la fermeture des onglets tant que le projet est potentiellement ouvert :
    // la destruction de la fenêtre déselectionne l'item du listview avant de commencer la chaine des Destroy
    // et donc les passage dans FormDestroy et ClearPages
    // la question à 100 balles est "pourquoi ça ne se produit que lorsqu'on a fair un actEnregistrer.Execute"
    // ou dans certains cas quand l'exécution du script à généré une erreur de script
    ProjetOuvert := false;

    FProjetScript := nil;
  end;
  RefreshOptions;
  RefreshDescription(FProjetScript);
end;

procedure TfrmScripts.seScript1ProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command - ecUserFirst of
    1: LoadScript(AnsiString(FCurrentScript.Editor.WordAtCursor));
  end;
end;

procedure TfrmScripts.pcScriptsChange(Sender: TObject);
begin
  if pcScripts.ActivePageIndex > -1 then
    FCurrentScript := FOpenedScript[pcScripts.ActivePageIndex]
  else
    FCurrentScript := nil;
  if Assigned(FCurrentScript) then
  begin
    SynEditAutoComplete.Editor := FCurrentScript.Editor;
    SynEditParamShow.Editor := FCurrentScript.Editor;
  end
  else
  begin
    SynEditAutoComplete.Editor := nil;
    SynEditParamShow.Editor := nil;
  end;
  TabSheet4.TabVisible := FCurrentScript = FProjetScript;
  RefreshDescription(FCurrentScript);
end;

procedure TfrmScripts.seScript1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ' ') and ((GetKeyState(VK_CONTROL) < 0) or (GetKeyState(VK_SHIFT) < 0)) then
    Key := #0;
end;
{$ENDREGION}

procedure TfrmScripts.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE: if not dmScripts.Running then
        inherited;
    else
      inherited;
    end;
end;

procedure TfrmScripts.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  Editor: TSynEdit;
begin
  if Assigned(FCurrentScript) then
    Editor := FCurrentScript.Editor
  else
    Editor := nil;
  Handled := True;
  actEdit.Enabled := Assigned(ListView1.Selected);

  EditCut1.Enabled := Assigned(Editor) and Editor.Focused and Editor.SelAvail;
  EditCopy1.Enabled := Assigned(Editor) and Editor.Focused and Editor.SelAvail;
  EditPaste1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanPaste;
  EditUndo1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanUndo;
  EditRedo1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanRedo;
  actCompile.Enabled := FProjetOuvert;
  actRun.Enabled := (actCompile.Enabled or actEdit.Enabled) and (not dmScripts.Running or (dmScripts.DebugMode = dmPaused));
  actRunWithoutDebug.Visible := dmScripts.AlbumToUpdate;
  actRunWithoutDebug.Enabled := actRunWithoutDebug.Visible and actRun.Enabled and not dmScripts.Running;
  actPause.Enabled := dmScripts.Running and (dmScripts.DebugMode = dmRun);
  actCreerOption.Visible := FProjetOuvert;
  actCreerOption.Enabled := FProjetOuvert;
  actRetirerOption.Visible := FProjetOuvert;
  actRetirerOption.Enabled := FProjetOuvert and (ListBox1.ItemIndex <> -1);
  actModifierOption.Visible := FProjetOuvert;
  actModifierOption.Enabled := FProjetOuvert and (ListBox1.ItemIndex <> -1);
  actFermer.Enabled := Assigned(Editor) and (FForceClose or (FCurrentScript <> FProjetScript));
  actEnregistrer.Enabled := Assigned(Editor);
  actReset.Enabled := dmScripts.Running and (dmScripts.DebugMode in [dmPaused]);
  actCompile.Enabled := not dmScripts.Running;

  // sinon les actions court-circuitent les raccouris sur les autres composants
  // mettre les actions enabled := False n'est pas suffisant
  if Assigned(Editor) and Editor.Focused then
  begin
    EditCut1.ShortCut := ShortCut(Ord('X'), [ssCtrl]);
    EditCopy1.ShortCut := ShortCut(Ord('C'), [ssCtrl]);
    EditPaste1.ShortCut := ShortCut(Ord('V'), [ssCtrl]);
    EditUndo1.ShortCut := ShortCut(Ord('Z'), [ssCtrl]);
    EditRedo1.ShortCut := ShortCut(Ord('Y'), [ssCtrl]);
    EditSelectAll1.ShortCut := ShortCut(Ord('A'), [ssCtrl]);
  end
  else
  begin
    EditCut1.ShortCut := 0;
    EditCopy1.ShortCut := 0;
    EditPaste1.ShortCut := 0;
    EditUndo1.ShortCut := 0;
    EditRedo1.ShortCut := 0;
    EditSelectAll1.ShortCut := 0;
  end;
end;

function TfrmScripts.GetProjet: AnsiString;
begin
  Result := FProjetScript.ScriptName;
end;

procedure TfrmScripts.SetProjet(const Value: AnsiString);
begin
  ProjetOuvert := false;
  LoadScript(Value);
  ProjetOuvert := True;
end;

procedure TfrmScripts.SetProjetOuvert(const Value: Boolean);
begin
  if not Value then
  begin
    FForceClose := True;
    try
      ClearPages;
      Compiled := false;
      dmScripts.DebugPlugin.Messages.Clear;
      dmScripts.PSScriptDebugger1.MainFileName := '';
    finally
      FForceClose := false;
    end;
  end;
  FProjetOuvert := Value;
  tbEdition.TabVisible := Value;
end;

procedure TfrmScripts.SetCompiled(const Value: Boolean);
begin
  FCompiled := Value;
  if Assigned(FCurrentScript) and Assigned(FCurrentScript.Editor) then
    FCurrentScript.Editor.Invalidate;
end;

procedure TfrmScripts.FormCreate(Sender: TObject);
begin
  if TGlobalVar.Utilisateur.Options.GrandesIconesBarre then
  begin
    ToolBar1.Images := frmFond.boutons_32x32_norm;
    ToolBar1.HotImages := frmFond.boutons_32x32_hot;
    ToolBar2.Images := frmFond.boutons_32x32_norm;
    ToolBar2.HotImages := frmFond.boutons_32x32_hot;
  end
  else
  begin
    ToolBar1.Images := frmFond.boutons_16x16_norm;
    ToolBar1.HotImages := frmFond.boutons_16x16_hot;
    ToolBar2.Images := frmFond.boutons_16x16_norm;
    ToolBar2.HotImages := frmFond.boutons_16x16_hot;
  end;

  FScriptList := TScriptListEdition.Create(TScriptEdition);
  FOpenedScript := TObjectList<TScriptEdition>.Create(false);
  dmScripts := TdmScripts.Create(Self); // !!! important de mettre self en owner
  dmScripts.ScriptList := FScriptList;
  dmScripts.Console := mmConsole.Lines;
  dmScripts.DebugPlugin.OnGetScript := GetScript;
  dmScripts.DebugPlugin.Watches.View := vstSuivis;
  dmScripts.DebugPlugin.Messages.View := vstMessages;
  dmScripts.DebugPlugin.Breakpoints.View := vstBreakpoints;
  dmScripts.OnAfterExecute := PSScriptDebugger1AfterExecute;
  dmScripts.OnBreakpoint := PSScriptDebugger1Breakpoint;
  dmScripts.OnLineInfo := PSScriptDebugger1LineInfo;
  dmScripts.OnIdle := PSScriptDebugger1Idle;

  fTypeInfos := TIDHashMap.Create;

  Assert(not Assigned(dmScripts.PSScriptDebugger1.Comp.OnBeforeCleanup), 'PSScriptDebugger1.Comp.OnBeforeCleanup déjà utilisé');
  dmScripts.PSScriptDebugger1.Comp.OnBeforeCleanup := AutoCompleteCompilerBeforeCleanUp;

  FForceClose := false;
  PageControl1.ActivePageIndex := 0;

  // force à reprendre les params de delphi s'il est installé sur la machine
  SynPasSyn1.UseUserSettings(0);

  LoadScripts;

  PageControl2.ActivePage := tbScripts;
  ProjetOuvert := false;
end;

procedure TfrmScripts.FormDestroy(Sender: TObject);
begin
  ProjetOuvert := false;
  ClearPages;
  fTypeInfos.Free;
  dmScripts.Free;
  FOpenedScript.Free;
  FScriptList.Free;
end;

procedure TfrmScripts.framBoutons1btnAnnulerClick(Sender: TObject);
begin
  framBoutons1.btnAnnulerClick(Sender);
  if not dmScripts.AlbumToUpdate then
    Release;
end;

procedure TfrmScripts.RefreshDescription(Script: TScriptEdition);
begin
  FRefreshingDescription := True;
  try
    if Assigned(Script) then
    begin
      Label5.Caption := Script.ScriptInfos.Auteur;
      EditLabeled1.Text := Script.ScriptInfos.Auteur;

      if Script.ScriptInfos.LastUpdate > 0 then
        Label6.Caption := DateTimeToStr(Script.ScriptInfos.LastUpdate)
      else
        Label6.Caption := '';

      Label8.Caption := Script.ScriptInfos.ScriptVersion;
      EditLabeled2.Text := Script.ScriptInfos.ScriptVersion;

      Label10.Caption := Script.ScriptInfos.BDVersion;
      EditLabeled3.Text := Script.ScriptInfos.BDVersion;

      Memo1.Lines.Text := Script.ScriptInfos.Description;
      MemoLabeled1.Text := Script.ScriptInfos.Description;

      Memo2.Lines.Assign(Script.Alias);
    end
    else
    begin
      Label5.Caption := '';
      Label6.Caption := '';
      Label8.Caption := '';
      Label10.Caption := '';
      Memo1.Lines.Clear;
    end;
  finally
    FRefreshingDescription := false;
  end;
end;

procedure TfrmScripts.RefreshOptions;
begin
  if Assigned(FProjetScript) then
    ListBox1.Count := FProjetScript.Options.Count
  else
    ListBox1.Count := 0;
  ListBox1.Invalidate;
  ListBox2.Count := ListBox1.Count;
  ListBox2.Invalidate;
end;

procedure TfrmScripts.LoadScript(const Script: AnsiString);
var
  LockWindow: ILockWindow;
  Info: TScriptEdition;
begin
  Info := FScriptList.InfoScriptByScriptName(Script);
  // doit être fait avant la création de page pour s'assurer de l'existence du fichier
  if not Assigned(Info) then
    raise Exception.Create('Impossible de trouver l''unité ' + string(Script) + '.');

  if not Assigned(Info.Editor) then
  begin
    LockWindow := TLockWindow.Create(pcScripts);

    FOpenedScript.Add(Info);

    Info.TabSheet := TTabSheet.Create(pcScripts);
    Info.TabSheet.PageControl := pcScripts;
    Info.TabSheet.Caption := string(Info.ScriptName);

    Info.Editor := TMySynEdit.Create(Info.TabSheet);
    Info.Editor.Parent := Info.TabSheet;
    Info.Editor.Align := alClient;
    Info.Editor.Color := clWhite;
    Info.Editor.ActiveLineColor := 16314351;
    Info.Editor.Font.Color := clWindowText;
    Info.Editor.Font.Height := -13;
    Info.Editor.Font.name := 'Courier New';
    Info.Editor.Font.Style := [];
    Info.Editor.OnMouseMove := seScript1MouseMove;
    Info.Editor.Gutter.AutoSize := True;
    Info.Editor.Gutter.DigitCount := 3;
    Info.Editor.Gutter.Font.Color := clWindowText;
    Info.Editor.Gutter.Font.Height := -11;
    Info.Editor.Gutter.Font.name := 'Terminal';
    Info.Editor.Gutter.Font.Style := [];
    Info.Editor.Gutter.LeftOffset := 27;
    Info.Editor.Gutter.ShowLineNumbers := True;
    Info.Editor.Gutter.Width := 0;
    Info.Editor.BorderStyle := bsNone;
    TMySynEdit(Info.Editor).BevelKind := bkTile;
    Info.Editor.Highlighter := SynPasSyn1;
    Info.Editor.Options := [eoAutoIndent, eoTabIndent, eoSmartTabs, eoAutoSizeMaxScrollWidth, eoDragDropEditing, eoGroupUndo,
      eoRightMouseMovesCursor, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];
    Info.Editor.ScrollHintFormat := shfTopToBottom;
    Info.Editor.SearchEngine := SynEditSearch1;
    Info.Editor.TabWidth := 2;
    Info.Editor.WantTabs := True;
    Info.Editor.OnChange := seScript1Change;
    Info.Editor.OnGutterClick := seScript1GutterClick;
    Info.Editor.OnGutterPaint := seScript1GutterPaint;
    Info.Editor.OnReplaceText := seScript1ReplaceText;
    Info.Editor.OnSpecialLineColors := seScript1SpecialLineColors;
    Info.Editor.OnStatusChange := seScript1StatusChange;
    Info.Editor.OnProcessUserCommand := seScript1ProcessUserCommand;
    Info.Editor.OnKeyPress := seScript1KeyPress;
    Info.Editor.AddKey(ecUserFirst + 1, VK_RETURN, [ssCtrl]);

    TSynDebugPlugin.Create(Info.Editor, dmScripts.DebugPlugin);
    // if not Info.Loaded then
    Info.Load; // on force le rechargement pour être sûr de bien avoir la dernière version
    Info.Editor.Lines.Assign(Info.Code);

    Info.SB := TStatusBar.Create(Info.TabSheet);
    Info.SB.Parent := Info.TabSheet;
    Info.SB.Panels.Add.Width := 50;
    Info.SB.Panels.Add.Width := 50;
    Info.SB.Panels.Add.Width := 50;

    Info.TabSheet.Visible := True;
  end;
  GoToPosition(Info.Editor, 1, 1);
end;

procedure TfrmScripts.LoadScripts;
var
  Script: TScript;
begin
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    FScriptList.LoadDir(TGlobalVar.Utilisateur.Options.RepertoireScripts);
    for Script in FScriptList do
      if Script.ScriptKind = skMain then
        with ListView1.Items.Add do
        begin
          Data := Script;
          Caption := string(Script.ScriptName);
        end;
  finally
    ListView1.Items.EndUpdate;
  end;
  ListView1.OnSelectItem(ListView1, nil, false);
end;

procedure TfrmScripts.ClearPages;
var
  i: Integer;
begin
  for i := 0 to Pred(pcScripts.PageCount) do
    actFermer.Execute;
end;
{$REGION 'Débuggage'}

procedure TfrmScripts.PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  GoToPosition(dmScripts.ActiveFile, dmScripts.ActiveLine, 0);
end;

procedure TfrmScripts.actStepOverExecute(Sender: TObject);
begin
  if dmScripts.PSScriptDebugger1.Exec.Status = isRunning then
    dmScripts.PSScriptDebugger1.StepOver
  else
  begin
    if Compile then
    begin
      dmScripts.PSScriptDebugger1.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actStepIntoExecute(Sender: TObject);
begin
  if dmScripts.PSScriptDebugger1.Exec.Status = isRunning then
    dmScripts.PSScriptDebugger1.StepInto
  else
  begin
    if Compile then
    begin
      dmScripts.PSScriptDebugger1.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actModifierOptionExecute(Sender: TObject);
begin
  if EditOption(FProjetScript.Options[ListBox1.ItemIndex]) then
    RefreshOptions;
end;

procedure TfrmScripts.actPauseExecute(Sender: TObject);
begin
  dmScripts.PSScriptDebugger1.Pause;
  GoToPosition(dmScripts.ActiveFile, dmScripts.ActiveLine, 1);
end;

procedure TfrmScripts.actResetExecute(Sender: TObject);
begin
  if dmScripts.PSScriptDebugger1.Exec.Status = isRunning then
    dmScripts.PSScriptDebugger1.Stop;
end;

procedure TfrmScripts.actRetirerOptionExecute(Sender: TObject);
begin
  FProjetScript.Options.Delete(ListBox1.ItemIndex);
  FProjetScript.Modifie := True;
  RefreshOptions;
end;

procedure TfrmScripts.actDecompileExecute(Sender: TObject);
begin
  if Compile then
  begin
    dmScripts.GetUncompiledCode(mmConsole.Lines);
    PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  end;
end;

procedure TfrmScripts.actBreakpointExecute(Sender: TObject);
begin
  dmScripts.ToggleBreakPoint(FCurrentScript.ScriptName, FCurrentScript.Editor.CaretY, false);
end;

procedure TfrmScripts.actAddSuiviExecute(Sender: TObject);
begin
  dmScripts.DebugPlugin.Watches.AddWatch(AnsiString(FCurrentScript.Editor.WordAtCursor));
end;

procedure TfrmScripts.actRunToCursorExecute(Sender: TObject);
begin
  dmScripts.RunToCursor := FCurrentScript.Editor.CaretY;
  dmScripts.RunToCursorFile := FCurrentScript.ScriptName;
  actRun.Execute;
end;

procedure TfrmScripts.vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: UnicodeString);
begin
  dmScripts.DebugPlugin.Watches[Node.index].name := AnsiString(NewText);
  dmScripts.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 0;
end;

procedure TfrmScripts.vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if dmScripts.DebugPlugin.Watches[Node.index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmScripts.vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  dmScripts.DebugPlugin.Watches[Node.index].Active := Node.CheckState = csCheckedNormal;
  dmScripts.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with dmScripts.DebugPlugin.Watches[Node.index] do
    case Column of
      0: CellText := string(name);
      1: CellText := string(dmScripts.GetVariableValue(name, Active));
    end;
end;

procedure TfrmScripts.vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TfrmScripts.GoToMessage(msg: TMessageInfo);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(msg.Fichier);
  if not Assigned(Editor) then
    LoadScript(msg.Fichier);
  GoToPosition(msg.Fichier, msg.Line, msg.Char);
  PageControl1.ActivePage := TTabSheet(vstMessages.Parent);
end;

procedure TfrmScripts.vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with dmScripts.DebugPlugin.Messages[Node.index] do
    case Column of
      0:
        case Category of
          cmInfo: CellText := 'Information';
          cmCompileError: CellText := 'Compilation';
          cmRuntimeError: CellText := 'Exécution';
          else
            CellText := '';
          end;
      1: CellText := string(TypeMessage);
      2: CellText := string(Fichier);
      3: CellText := string(Text);
    end;
end;

procedure TfrmScripts.vstMessagesDblClick(Sender: TObject);
begin
  GoToMessage(dmScripts.DebugPlugin.Messages.Current);
end;

procedure TfrmScripts.vstBreakpointsDblClick(Sender: TObject);
begin
  GoToBreakpoint(dmScripts.DebugPlugin.Breakpoints.Current);
end;

procedure TfrmScripts.GoToBreakpoint(msg: TBreakpointInfo);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(msg.Fichier);
  if not Assigned(Editor) then
    LoadScript(msg.Fichier);
  GoToPosition(msg.Fichier, msg.Line, 0);
  PageControl1.ActivePage := TTabSheet(vstBreakpoints.Parent);
end;

procedure TfrmScripts.GoToPosition(Script: AnsiString; Line, Char: Cardinal);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(Script);
  if not Assigned(Editor) then
  begin
    LoadScript(dmScripts.ActiveFile);
    Editor := GetScript(dmScripts.ActiveFile);
  end;
  GoToPosition(Editor, Line, Char);
end;

procedure TfrmScripts.GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
begin
  if not Assigned(Editor) then
    Exit;

  if (Line < Cardinal(Editor.TopLine + 2)) or (Line > Cardinal(Editor.TopLine + Editor.LinesInWindow - 2)) then
    Editor.TopLine := Line - Cardinal(Editor.LinesInWindow div 2);

  Editor.CaretY := Line;
  Editor.CaretX := Char;
  Editor.Invalidate; // Line et GutterLine sont insuffisants pour certains cas
  PageControl2.ActivePage := tbEdition;
  pcScripts.ActivePage := TTabSheet(Editor.Parent);
  pcScriptsChange(nil);
  Editor.SetFocus;
end;

procedure TfrmScripts.vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with dmScripts.DebugPlugin.Breakpoints[Node.index] do
    dmScripts.ToggleBreakPoint(Fichier, Line, True);
  dmScripts.DebugPlugin.Breakpoints.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with dmScripts.DebugPlugin.Breakpoints[Node.index] do
    case Column of
      0: CellText := 'Ligne ' + SysUtils.IntToStr(Line);
      1: CellText := string(Fichier);
    end;
end;

procedure TfrmScripts.vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if dmScripts.DebugPlugin.Breakpoints[Node.index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmScripts.vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TfrmScripts.seScript1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  WordVar: AnsiString = '';
var
  pv: PIFVariant;
  Prefix: AnsiString;
  s: AnsiString;
begin
  if not dmScripts.Running then
  begin
    WordVar := '';
    FCurrentScript.Editor.ShowHint := false;
    Exit;
  end;
  s := AnsiString(FCurrentScript.Editor.WordAtMouse);
  if s <> WordVar then
    Application.CancelHint;
  WordVar := s;

  pv := dmScripts.GetVar(WordVar, Prefix);
  if pv = nil then
  begin
    FCurrentScript.Editor.Hint := '';
    FCurrentScript.Editor.ShowHint := false;
  end
  else
  begin
    FCurrentScript.Editor.Hint := string(PSVariantToString(NewTPSVariantIFC(pv, false), Prefix));
    FCurrentScript.Editor.ShowHint := True;
  end;
end;
{$ENDREGION}
{$REGION 'Exécution'}

procedure TfrmScripts.actCompileExecute(Sender: TObject);
begin
  if not dmScripts.Running then
    Compile;
end;

function TfrmScripts.EditOption(Option: TOption): Boolean;
var
  s: string;
begin
  with TfrmScriptEditOption.Create(nil) do
    try
      EditLabeled1.Text := Option.FLibelle;
      MemoLabeled1.Lines.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
      EditLabeled2.Text := Option.FDefaultValue;

      Result := ShowModal = mrOk;
      if Result then
      begin
        Option.FLibelle := EditLabeled1.Text;
        s := MemoLabeled1.Lines.Text;
        while EndsText(sLineBreak, s) do
          Delete(s, Length(s) - Length(sLineBreak) + 1, Length(sLineBreak));
        s := StringReplace(s, sLineBreak, '|', [rfReplaceAll]);
        Option.FValues := s;
        Option.FDefaultValue := EditLabeled2.Text;

        FProjetScript.Modifie := True;
      end;
    finally
      Free;
    end;
end;

procedure TfrmScripts.actCreerOptionExecute(Sender: TObject);
var
  Option: TOption;
begin
  Option := TOption.Create;
  if EditOption(Option) then
  begin
    Option.FChooseValue := Option.FDefaultValue;
    FProjetScript.Options.Add(Option);
    RefreshOptions;
  end
  else
    Option.Free;
end;

procedure TfrmScripts.actRunExecute(Sender: TObject);
begin
  if dmScripts.Running then
  begin
    dmScripts.PSScriptDebugger1.Resume;
    dmScripts.ActiveLine := 0;
    dmScripts.ActiveFile := '';
    FCurrentScript.Editor.Refresh;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

function TfrmScripts.Execute: Boolean;
begin
  Result := dmScripts.Execute;
  if not Result then
  begin
    GoToMessage(dmScripts.DebugPlugin.Messages.Last);
    try
      dmScripts.PSScriptDebugger1.Exec.RaiseCurrentException;
    except
      on e: EPSException do
        Application.HandleException(nil);
      else
        raise ;
      end;
    end;
  end;

  procedure TfrmScripts.PSScriptDebugger1Idle(Sender: TObject);
  begin
    frmFond.MergeMenu(Menu);
  end;

  procedure TfrmScripts.PSScriptDebugger1AfterExecute(Sender: TPSScript);
  begin
    if pcScripts.PageCount > 0 then
      FCurrentScript.Editor.Refresh;
    PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
    frmFond.MergeMenu(Menu);
    if dmScripts.AlbumToUpdate then
      ModalResult := mrOk;
  end;

  procedure TfrmScripts.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
  begin
    if dmScripts.DebugMode in [dmPaused, dmStepInto] then
      GoToPosition(dmScripts.ActiveFile, dmScripts.ActiveLine, 1);
  end;

  function TfrmScripts.Compile: Boolean;
  var
    msg: TMessageInfo;
  begin
    Result := dmScripts.Compile(FProjetScript, msg);
    Compiled := Result;
    if Assigned(msg) then
      GoToMessage(msg);
  end;

  procedure TfrmScripts.actRunWithoutDebugExecute(Sender: TObject);
  begin
    dmScripts.PSScriptDebugger1.UseDebugInfo := false;
    try
      if Compile then
        Execute;
    finally
      dmScripts.PSScriptDebugger1.UseDebugInfo := True;
    end;
  end;
{$ENDREGION}

end.
