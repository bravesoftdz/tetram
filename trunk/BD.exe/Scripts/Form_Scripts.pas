unit Form_Scripts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, ImgList, StrUtils,
  uPSComponent, uPSDebugger, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, uPSDisassembly,
  Menus, SynEditTypes, ComCtrls, uPSCompiler, UScriptUtils, uPSUtils,
  uPSRuntime, VirtualTrees, StdCtrls, ExtCtrls, uPSComponent_StdCtrls,
  uPSComponent_Controls, uPSComponent_Forms, uPSComponent_DB, uPSComponent_RegExpr, LoadComplet,
  uPSComponent_COM, uPSComponent_Default, SynEditKeyCmds, uPSI_LoadComplet, uPSI_TypeRec,
  SynCompletionProposal, UBdtForms, IDHashMap;

type
  TSynDebugPlugin = class(TSynEditPlugin)
  private
    FDebug: TDebugInfos;
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer); override;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
  public
    constructor Create(AOwner: TCustomSynEdit; Debug: TDebugInfos); reintroduce;
  end;

  TfrmScripts = class(TbdtForm)
    SynPasSyn1: TSynPasSyn;
    lstDebugImages: TImageList;
    PSScriptDebugger1: TPSScriptDebugger;
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
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_ComObj1: TPSImport_ComObj;
    PSImport_DB1: TPSImport_DB;
    PSImport_Forms1: TPSImport_Forms;
    PSImport_Controls1: TPSImport_Controls;
    PSImport_StdCtrls1: TPSImport_StdCtrls;
    PSDllPlugin1: TPSDllPlugin;
    PopupMenu1: TPopupMenu;
    actFermer: TAction;
    actEnregistrer: TAction;
    actEnregistrerSous: TAction;
    Fermer1: TMenuItem;
    N6: TMenuItem;
    Enregistrer1: TMenuItem;
    Enregistrersous1: TMenuItem;
    PageControl2: TPageControl;
    tbEdition: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    vstMessages: TVirtualStringTree;
    TabSheet2: TTabSheet;
    vstSuivis: TVirtualStringTree;
    TabSheet3: TTabSheet;
    vstBreakpoints: TVirtualStringTree;
    TabSheet6: TTabSheet;
    Output: TMemo;
    pcScripts: TPageControl;
    tbScripts: TTabSheet;
    ListView1: TListView;
    actRunWithoutDebug: TAction;
    Excutersansdbuguer1: TMenuItem;
    SynEditParamShow: TSynCompletionProposal;
    SynEditAutoComplete: TSynCompletionProposal;
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
    procedure PSScriptDebugger1Execute(Sender: TPSScript);
    procedure actCompileExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure PSScriptDebugger1Compile(Sender: TPSScript);
    procedure PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1Idle(Sender: TObject);
    procedure PSScriptDebugger1AfterExecute(Sender: TPSScript);
    procedure PSScriptDebugger1LineInfo(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
    function PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean;
    procedure actStepOverExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actResetExecute(Sender: TObject);
    procedure actDecompileExecute(Sender: TObject);
    procedure actBreakpointExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddSuiviExecute(Sender: TObject);
    procedure actRunToCursorExecute(Sender: TObject);
    procedure vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstMessagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seScript1Change(Sender: TObject);
    procedure vstBreakpointsDblClick(Sender: TObject);
    procedure vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure seScript1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure actFermerExecute(Sender: TObject);
    procedure actEnregistrerExecute(Sender: TObject);
    procedure actEnregistrerSousExecute(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure seScript1ProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure actRunWithoutDebugExecute(Sender: TObject);
    procedure pcScriptsChange(Sender: TObject);
    procedure SynEditParamShowExecute(Kind: TSynCompletionType; Sender: TObject; var CurrentInput: string; var x, y: Integer; var CanExecute: Boolean);
    procedure SynEditAutoCompleteExecute(Kind: TSynCompletionType; Sender: TObject; var CurrentInput: string; var x, y: Integer; var CanExecute: Boolean);
    procedure seScript1KeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FActiveFile, FRunToCursorFile, FErrorFile: string;
    FDebugPlugin: TDebugInfos;
    FCompiled: Boolean;
    FPSImport_RegExpr: TPSImport_RegExpr;
    FPSImport_LoadComplet: TPSImport_LoadComplet;
    FPSImport_TypeRec: TPSImport_TypeRec;
    FProjetOuvert: Boolean;
    FForceClose: Boolean;
    FAlbumToImport: TAlbumComplet;

    fObjectList: TParamInfoArray;
    fTypeInfos: TIDHashMap;

    procedure SetResultat(const Chaine: string);
    function Compile: Boolean;
    function Execute: Boolean;
    function GetVariableValue(const VarName: string; Actif: Boolean): string;
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    function GetVar(const Name: string; out s: string): PIFVariant;
    procedure GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
    procedure GoToMessage(Msg: TMessageInfo);
    procedure GoToBreakpoint(Msg: TBreakpointInfo);
    procedure ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);

    function GetScriptName(Editor: TSynEdit): string;
    function GetScript(const Fichier: string): TSynEdit;
    function GetActiveScriptName: string;
    function GetActiveScript: TSynEdit;
    function CorrectScriptName(const Fichier: string): string;
    function TranslatePositionEx(out Proc, Position: Cardinal; Row: Cardinal; Fn: string): Boolean;
    procedure SetCompiled(const Value: Boolean);
    function GetProjet: string;
    procedure SetProjet(const Value: string);
    procedure LoadScript(const Fichier: string);
    procedure ClearPages;
    function GetScriptLines(const Fichier: string; out Output: string): Boolean;
    procedure SetProjetOuvert(const Value: Boolean);
    procedure RebuildLokalObjektList;
    procedure BuildLokalObjektList(Comp: TPSPascalCompiler);
    function FindParameter(LocLine: string; X: Integer; out Func: TParamInfoRecord; out ParamCount: Integer): Boolean;
    function GetLookUpString(Line: string; EndPos: Integer): string;
    function LookUpList(LookUp: string; var ParamInfo: TParamInfoRecord): Boolean; overload;
    function LookUpList(LookUp: Cardinal; var ParamInfo: TParamInfoRecord): Boolean; overload;
    procedure FillAutoComplete(var List: TParamInfoArray; Types: TInfoTypes; FromFather: Cardinal = 0; Typ: string = '');
  public
    { Déclarations publiques }
    property Compiled: Boolean read FCompiled write SetCompiled;
    property Projet: string read GetProjet write SetProjet;
    property ProjetOuvert: Boolean read FProjetOuvert write SetProjetOuvert;
  end;

var
  frmScripts: TfrmScripts;

implementation

{$R *.dfm}

uses
  Form_ScriptSearch, UScriptsFonctions, CommonConst, uPSPreProcessor,
  Procedures;

function AutoCompleteCompilerBeforeCleanUp(Sender: TPSPascalCompiler): Boolean;
var
  s: string;
begin
  with TPSScriptDebugger(Sender.ID) do
    if comp.GetOutput(s) then TfrmScripts(Owner).BuildLokalObjektList(Sender);
  Result := True;
end;

procedure TSynDebugPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer);
begin
  inherited;
end;

constructor TSynDebugPlugin.Create(AOwner: TCustomSynEdit; Debug: TDebugInfos);
begin
  inherited Create(AOwner);
  FDebug := Debug;
end;

procedure TSynDebugPlugin.LinesDeleted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := Pred(FDebug.Breakpoints.Count) downto 0 do
    if FDebug.Breakpoints[i].Line in [FirstLine..FirstLine + Count] then
      FDebug.Breakpoints.Delete(i)
    else if FDebug.Breakpoints[i].Line > Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Breakpoints[i].Line);
      FDebug.Breakpoints[i].Line := FDebug.Breakpoints[i].Line - Cardinal(Count);
    end;

  for i := Pred(FDebug.Messages.Count) downto 0 do
    if FDebug.Messages[i].Line in [FirstLine..FirstLine + Count] then
      FDebug.Messages.Delete(i)
    else if FDebug.Messages[i].Line > Cardinal(FirstLine) then
      FDebug.Messages[i].Line := FDebug.Messages[i].Line - Cardinal(Count);
end;

procedure TSynDebugPlugin.LinesInserted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FDebug.Breakpoints.Count - 1 do
    if FDebug.Breakpoints[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Breakpoints[i].Line);
      FDebug.Breakpoints[i].Line := FDebug.Breakpoints[i].Line + Cardinal(Count);
    end;
  for i := 0 to FDebug.Messages.Count - 1 do
    if FDebug.Messages[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Messages[i].Line);
      FDebug.Messages[i].Line := FDebug.Messages[i].Line + Cardinal(Count);
    end;
end;

procedure TfrmScripts.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE: if not PSScriptDebugger1.Running then
        inherited;
    else
      inherited;
  end;
end;

procedure TfrmScripts.SetResultat(const Chaine: string);
begin
  Output.Lines.Text := Chaine;
  if (PageControl1.ActivePage <> TTabSheet(vstSuivis.Parent)) or (FDebugPlugin.Watches.CountActive = 0) then
    PageControl1.ActivePage := TTabSheet(Output.Parent);
  Application.ProcessMessages;
end;

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
    ToggleBreakPoint(GetScriptName(TSynEdit(Sender)), Line, False);
end;

procedure TfrmScripts.seScript1GutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
  Script: string;
  Proc, Pos: Cardinal;
begin
  Script := GetScriptName(TSynEdit(Sender));
  IconIndex := -1;
  i := FDebugPlugin.Breakpoints.IndexOf(Script, aLine);
  if i <> -1 then
  begin
    if not PSScriptDebugger1.Running then
      if FDebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
    else
    begin
      if (Cardinal(aLine) = FActiveLine) and SameText(FActiveFile, Script) then
        IconIndex := imgGutterEXECLINEBP
      else if FDebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAKVALID
      else
        IconIndex := imgGutterBREAKDISABLED
    end;
  end
  else
  begin
    if (PSScriptDebugger1.Exec.DebugMode = dmPaused) and (Cardinal(aLine) = FActiveLine) and SameText(FActiveFile, Script) then
      IconIndex := imgGutterEXECLINE;
  end;

  if Compiled then
    if TranslatePositionEx(Proc, Pos, aLine, Script) then
      case IconIndex of
        -1: IconIndex := imgGutterCOMPLINE;
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
  Script: string;
  Proc, Pos: Cardinal;
begin
  Script := GetScriptName(TSynEdit(Sender));
  i := FDebugPlugin.Breakpoints.IndexOf(Script, Line);

  if (Cardinal(Line) = FActiveLine) and SameText(FActiveFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else if i <> -1 then
  begin
    Special := True;
    if FDebugPlugin.Breakpoints[i].Active then
    begin
      if Compiled and not TranslatePositionEx(Proc, Pos, Line, Script) then
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
  else if (FErrorLine > 0) and (Cardinal(Line) = FErrorLine) and SameText(FErrorFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := False;
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
    //    sbEditor.Panels[pnlEditorPos].Caption := Format('%d:%d', [EScript.CaretX, EScript.CaretY]);
    Editor := TSynEdit(TSynEdit(Sender));
    SB := TStatusBar(TTabSheet(Editor.Parent).Controls[1]);
    SB.Panels[0].Text := Format('%.3d : %.3d', [Editor.CaretY, Editor.CaretX]);
    if Editor.GetHighlighterAttriAtRowCol(Editor.CaretXY, Token, Attri) then
    begin
      SB.Panels[1].Text := Attri.Name;
    end
    else
      SB.Panels[1].Text := '';
  end;
  if (scModified in Changes) then
  begin
    //    FCurrentFile.Modified := EScript.Modified;
  end;
end;

procedure TfrmScripts.SearchFind1Execute(Sender: TObject);
var
  dummyReplace: string;
begin
  if GetActiveScript.SelAvail and (GetActiveScript.BlockBegin.Line = GetActiveScript.BlockEnd.Line) then
  begin
    FLastSearch := GetActiveScript.SelText;
    Include(FSearchOptions, ssoSelectedOnly);
  end
  else
  begin
    FLastSearch := GetActiveScript.WordAtCursor;
    Exclude(FSearchOptions, ssoSelectedOnly);
  end;

  if Sender = SearchFind1 then
  begin
    // chercher
    Exclude(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TForm2.Execute(FLastSearch, dummyReplace, FSearchOptions) then
      Exit;
  end
  else
  begin
    // remplacer
    Include(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TForm2.Execute(FLastSearch, FLastReplace, FSearchOptions) then
      Exit;
  end;

  SearchFindNext1Execute(Sender);
end;

procedure TfrmScripts.SearchFindNext1Execute(Sender: TObject);
begin
  if FLastSearch = '' then
    SearchFind1Execute(SearchFind1)
  else if GetActiveScript.SearchReplace(FLastSearch, FLastReplace, FSearchOptions) = 0 then
    ShowMessage('Texte non trouvé');
end;

procedure TfrmScripts.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  Editor: TSynEdit;
begin
  Editor := GetActiveScript;
  Handled := True;
  EditCut1.Enabled := Assigned(Editor) and Editor.SelAvail;
  EditCopy1.Enabled := Assigned(Editor) and Editor.SelAvail;
  EditPaste1.Enabled := Assigned(Editor) and Editor.CanPaste;
  EditUndo1.Enabled := Assigned(Editor) and Editor.CanUndo;
  EditRedo1.Enabled := Assigned(Editor) and Editor.CanRedo;
  actCompile.Enabled := FProjetOuvert;
  actRun.Enabled := FProjetOuvert;
  actRunWithoutDebug.Enabled := FProjetOuvert and not PSScriptDebugger1.Running;
  actFermer.Enabled := Assigned(Editor) and (GetActiveScriptName <> Projet);
  actEnregistrer.Enabled := Assigned(Editor);
  actEnregistrerSous.Enabled := Assigned(Editor);
end;

procedure TfrmScripts.EditCut1Execute(Sender: TObject);
begin
  GetActiveScript.CutToClipboard;
end;

procedure TfrmScripts.EditCopy1Execute(Sender: TObject);
begin
  GetActiveScript.CopyToClipboard;
end;

procedure TfrmScripts.EditPaste1Execute(Sender: TObject);
begin
  GetActiveScript.PasteFromClipboard;
end;

procedure TfrmScripts.EditSelectAll1Execute(Sender: TObject);
begin
  GetActiveScript.SelectAll;
end;

procedure TfrmScripts.EditUndo1Execute(Sender: TObject);
begin
  GetActiveScript.Undo;
end;

procedure TfrmScripts.EditRedo1Execute(Sender: TObject);
begin
  GetActiveScript.Redo;
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

procedure TfrmScripts.PSScriptDebugger1Execute(Sender: TPSScript);
var
  i: Integer;
begin
  PSScriptDebugger1.ClearBreakPoints;
  if PSScriptDebugger1.UseDebugInfo then
    for i := 0 to Pred(FDebugPlugin.Breakpoints.Count) do
      with FDebugPlugin.Breakpoints[i] do
        if Active then
          if Fichier = PSScriptDebugger1.MainFileName then
            PSScriptDebugger1.SetBreakPoint(Fichier, Line)
          else
            PSScriptDebugger1.SetBreakPoint(UpperCase(Fichier), Line);

  PSScriptDebugger1.SetVarToInstance('AlbumToImport', FAlbumToImport);
end;

procedure TfrmScripts.actCompileExecute(Sender: TObject);
begin
  if not PSScriptDebugger1.Running then
    Compile;
end;

procedure TfrmScripts.actRunExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Running then
  begin
    PSScriptDebugger1.Resume;
    FActiveLine := 0;
    FActiveFile := '';
    GetActiveScript.Refresh;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

function TfrmScripts.Execute: Boolean;
begin
  FAlbumToImport.Clear;
  Output.Clear;
  PageControl1.ActivePage := TTabSheet(vstSuivis.Parent);
  if PSScriptDebugger1.Execute then
  begin
    //    AddMessage('Succesfully Execute');
    FErrorLine := 0;
    Result := True;
  end
  else
  begin
    FErrorLine := PSScriptDebugger1.ExecErrorRow;
    FErrorFile := CorrectScriptName(PSScriptDebugger1.ExecErrorFileName);
    FDebugPlugin.Messages.AddRuntimeErrorMessage(
      FErrorFile,
      Format('%s (Bytecode %d:%d)', [PSScriptDebugger1.ExecErrorToString, PSScriptDebugger1.ExecErrorProcNo, PSScriptDebugger1.ExecErrorByteCodePosition]),
      PSScriptDebugger1.ExecErrorRow,
      PSScriptDebugger1.ExecErrorCol);
    GoToMessage(FDebugPlugin.Messages.Last);
    Result := False;
    try
      PSScriptDebugger1.Exec.RaiseCurrentException;
    except
      on e: EPSException do
        Application.HandleException(nil);
    else
      raise;
    end;
  end;
end;

procedure TfrmScripts.PSScriptDebugger1Compile(Sender: TPSScript);
begin
  PSScriptDebugger1.AddFunction(@GetPage, 'function GetPage(const url: string): string;');
  PSScriptDebugger1.AddMethod(Self, @TfrmScripts.SetResultat, 'procedure WriteToConsole(const Chaine: string);');
  PSScriptDebugger1.AddFunction(@Format, 'function Format(const Format: string; const Args: array of const): string;');
  PSScriptDebugger1.AddFunction(@findInfo, 'function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;');
  PSScriptDebugger1.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
  PSScriptDebugger1.AddFunction(@PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');

  PSScriptDebugger1.AddRegisteredVariable('AlbumToImport', 'TAlbumComplet');
end;

procedure TfrmScripts.PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
begin
  FActiveLine := Row;
  FActiveFile := CorrectScriptName(FileName);
  GoToPosition(GetScript(FActiveFile), FActiveLine, 1);
  FDebugPlugin.Watches.UpdateView;
end;

procedure TfrmScripts.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;
end;

procedure TfrmScripts.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  FActiveLine := 0;
  FActiveFile := '';
  FRunToCursor := 0;
  FRunToCursorFile := '';
  PSScriptDebugger1.ClearBreakPoints;
  if pcScripts.PageCount > 0 then GetActiveScript.Refresh;
  vstSuivis.Invalidate;
  PageControl1.ActivePage := TTabSheet(Output.Parent);
end;

procedure TfrmScripts.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
begin
  if (Row = FRunToCursor) and SameText(CorrectScriptName(FileName), FRunToCursorFile) and (PSScriptDebugger1.Exec.DebugMode = dmRun) then
    PSScriptDebugger1.Pause;

  if PSScriptDebugger1.Exec.DebugMode <> dmRun then
  begin
    FActiveLine := Row;
    FActiveFile := CorrectScriptName(FileName);
    GoToPosition(GetScript(FActiveFile), FActiveLine, 1);
    FDebugPlugin.Watches.UpdateView;
  end;
end;

function TfrmScripts.PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean;
begin
  Result := GetScriptLines(FileName, Output);
end;

procedure TfrmScripts.actStepOverExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Exec.Status = isRunning then
    PSScriptDebugger1.StepOver
  else
  begin
    if Compile then
    begin
      PSScriptDebugger1.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actStepIntoExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Exec.Status = isRunning then
    PSScriptDebugger1.StepInto
  else
  begin
    if Compile then
    begin
      PSScriptDebugger1.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actResetExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Exec.Status = isRunning then
    PSScriptDebugger1.Stop;
end;

function TfrmScripts.Compile: Boolean;
var
  i: Longint;
  Msg: TMessageInfo;
  Script: string;
begin
  GetScriptLines(Projet, Script);
  PSScriptDebugger1.Script.Text := Script;
  Result := PSScriptDebugger1.Compile;
  FDebugPlugin.Messages.Clear;
  Msg := nil;
  for i := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
    with PSScriptDebugger1.CompilerMessages[i] do
      if ClassType = TPSPascalCompilerWarning then
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmWarning, Row, Col)
      else if ClassType = TPSPascalCompilerHint then
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmHint, Row, Col)
      else if ClassType = TPSPascalCompilerError then
      begin
        Msg := FDebugPlugin.Messages[FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmError, Row, Col)]
      end
      else
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmUnknown, Row, Col);

  if Assigned(Msg) then GoToMessage(Msg);
  Compiled := Result;
end;

procedure TfrmScripts.actDecompileExecute(Sender: TObject);
var
  s: string;
begin
  if Compile then
  begin
    PSScriptDebugger1.GetCompiled(s);
    IFPS3DataToText(s, s);
    output.Lines.Text := s;
    PageControl1.ActivePage := TTabSheet(Output.Parent);
  end;
end;

procedure TfrmScripts.actBreakpointExecute(Sender: TObject);
begin
  ToggleBreakPoint(GetActiveScriptName, GetActiveScript.CaretY, False);
end;

procedure TfrmScripts.FormCreate(Sender: TObject);
var
  i: Integer;
  sr: TSearchRec;
begin
  FAlbumToImport := TAlbumComplet.Create;

  fTypeInfos := TIDHashMap.Create;

  Assert(not Assigned(PSScriptDebugger1.Comp.OnBeforeCleanup), 'PSScriptDebugger1.Comp.OnBeforeCleanup déjà utilisé');
  PSScriptDebugger1.Comp.OnBeforeCleanup := AutoCompleteCompilerBeforeCleanUp;

  FForceClose := False;
  PageControl1.ActivePageIndex := 0;
  FDebugPlugin := TDebugInfos.Create;
  FDebugPlugin.OnGetScript := GetScript;
  FDebugPlugin.Watches.View := vstSuivis;
  FDebugPlugin.Messages.View := vstMessages;
  FDebugPlugin.Breakpoints.View := vstBreakpoints;

  // force à reprendre les params de delphi s'il est installé sur la machine
  SynPasSyn1.UseUserSettings(0);

  FPSImport_RegExpr := TPSImport_RegExpr.Create(Self);
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_RegExpr;
  FPSImport_TypeRec := TPSImport_TypeRec.Create(Self);
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_TypeRec;
  FPSImport_LoadComplet := TPSImport_LoadComplet.Create(Self);
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_LoadComplet;

  i := FindFirst(Utilisateur.Options.RepertoireScripts + '\*.bds', faAnyFile, sr);
  if i = 0 then
  try
    while i = 0 do
    begin
      if (sr.Attr and faDirectory) = 0 then
        ListView1.Items.Add.Caption := ChangeFileExt(sr.Name, '');
      i := FindNext(sr);
    end;
  finally
    FindClose(sr);
  end;
  PageControl2.ActivePage := tbScripts;
end;

function TfrmScripts.GetVar(const Name: string; out s: string): PIFVariant;
var
  i: Longint;
  s1: string;
begin
  s := Uppercase(Name);
  if pos('.', s) > 0 then
  begin
    s1 := copy(s, 1, pos('.', s) - 1);
    delete(s, 1, pos('.', Name));
  end
  else
  begin
    s1 := s;
    s := '';
  end;
  Result := nil;
  with PSScriptDebugger1 do
  begin
    for i := 0 to Exec.CurrentProcVars.Count - 1 do
      if UpperCase(Exec.CurrentProcVars[i]) = s1 then
      begin
        Result := Exec.GetProcVar(i);
        break;
      end;
    if Result = nil then
    begin
      for i := 0 to Exec.CurrentProcParams.Count - 1 do
        if Uppercase(Exec.CurrentProcParams[i]) = s1 then
        begin
          Result := Exec.GetProcParam(i);
          break;
        end;
    end;
    if Result = nil then
    begin
      for i := 0 to Exec.GlobalVarNames.Count - 1 do
        if Uppercase(Exec.GlobalVarNames[i]) = s1 then
        begin
          Result := Exec.GetGlobalVar(i);
          break;
        end;
    end;
  end;
end;

function TfrmScripts.GetVariableValue(const VarName: string; Actif: Boolean): string;
var
  pv: PIFVariant;
  Prefix: string;
begin
  if Actif then
    if PSScriptDebugger1.Running then
    begin
      pv := GetVar(VarName, Prefix);
      if pv = nil then
        Result := '{Expression inconnue}'
      else
        Result := PSVariantToString(NewTPSVariantIFC(pv, False), Prefix);
    end
    else
      Result := '{Valeur inaccessible}'
  else
    Result := '<désactivé>';
end;

procedure TfrmScripts.actAddSuiviExecute(Sender: TObject);
begin
  FDebugPlugin.Watches.AddWatch(GetActiveScript.WordAtCursor);
end;

procedure TfrmScripts.actRunToCursorExecute(Sender: TObject);
begin
  FRunToCursor := GetActiveScript.CaretY;
  FRunToCursorFile := GetActiveScriptName;
  actRun.Execute;
end;

procedure TfrmScripts.vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  FDebugPlugin.Watches[Node.Index].Name := NewText;
  FDebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 0;
end;

procedure TfrmScripts.vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if FDebugPlugin.Watches[Node.Index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmScripts.vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FDebugPlugin.Watches[Node.Index].Active := Node.CheckState = csCheckedNormal;
  FDebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then
    Column := 0;
  with FDebugPlugin.Watches[Node.Index] do
    case Column of
      0: CellText := Name;
      1: CellText := GetVariableValue(Name, Active);
    end;
end;

procedure TfrmScripts.vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TfrmScripts.GoToMessage(Msg: TMessageInfo);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(Msg.Fichier);
  if not Assigned(Editor) then LoadScript(Msg.Fichier);
  GoToPosition(GetScript(Msg.Fichier), Msg.Line, Msg.Char);
  PageControl1.ActivePage := TTabSheet(vstMessages.Parent);
end;

procedure TfrmScripts.vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then
    Column := 0;
  with FDebugPlugin.Messages[Node.Index] do
    case Column of
      0:
        case Category of
          cmInfo: CellText := 'Information';
          cmCompileError: CellText := 'Compilation';
          cmRuntimeError: CellText := 'Exécution';
          else
            CellText := '';
        end;
      1: CellText := TypeMessage;
      2: CellText := Fichier;
      3: CellText := Text;
    end;
end;

procedure TfrmScripts.vstMessagesDblClick(Sender: TObject);
begin
  GoToMessage(FDebugPlugin.Messages.Current);
end;

procedure TfrmScripts.FormDestroy(Sender: TObject);
begin
  ClearPages;
  fTypeInfos.Free;
  FDebugPlugin.Free;
  FAlbumToImport.Free;
end;

procedure TfrmScripts.seScript1Change(Sender: TObject);
begin
  Compiled := False;
  TSynEdit(Sender).Tag := 1;
  if (FErrorLine > 0) then
  begin
    GetScript(FErrorFile).InvalidateLine(FErrorLine);
    GetScript(FErrorFile).InvalidateGutterLine(FErrorLine);
    FErrorLine := 0;
    FErrorFile := '';
  end;
end;

procedure TfrmScripts.vstBreakpointsDblClick(Sender: TObject);
begin
  GoToBreakpoint(FDebugPlugin.Breakpoints.Current);
end;

procedure TfrmScripts.GoToBreakpoint(Msg: TBreakpointInfo);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(Msg.Fichier);
  if not Assigned(Editor) then LoadScript(Msg.Fichier);
  GoToPosition(GetScript(Msg.Fichier), Msg.Line, 0);
  PageControl1.ActivePage := TTabSheet(vstBreakpoints.Parent);
end;

procedure TfrmScripts.GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
begin
  if not Assigned(Editor) then Exit;

  if (Line < Cardinal(Editor.TopLine + 2)) or (Line > Cardinal(Editor.TopLine + Editor.LinesInWindow - 2)) then
    Editor.TopLine := Line - Cardinal(Editor.LinesInWindow div 2);

  Editor.CaretY := Line;
  Editor.CaretX := Char;
  Editor.Invalidate; // Line et GutterLine sont insuffisants pour certains cas
  PageControl2.ActivePage := tbEdition;
  pcScripts.ActivePage := TTabSheet(Editor.Parent);
  if pcScripts.PageCount = 1 then pcScriptsChange(nil);
  Editor.SetFocus;
end;

procedure TfrmScripts.vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with FDebugPlugin.Breakpoints[Node.Index] do
    ToggleBreakPoint(Fichier, Line, True);
  FDebugPlugin.Breakpoints.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then
    Column := 0;
  with FDebugPlugin.Breakpoints[Node.Index] do
    case Column of
      0: CellText := 'Ligne ' + IntToStr(Line);
      1: CellText := Fichier;
    end;
end;

procedure TfrmScripts.vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if FDebugPlugin.Breakpoints[Node.Index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmScripts.vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TfrmScripts.ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(Script, Line);
  if i = -1 then // nouveau point d'arrêt
  begin
    FDebugPlugin.Breakpoints.AddBreakpoint(Script, Line);
    if PSScriptDebugger1.Running then
      if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.SetBreakPoint('', Line)
      else
        PSScriptDebugger1.SetBreakPoint(Script, Line);
  end
  else if Keep then // changement d'état du point d'arrêt
  begin
    FDebugPlugin.Breakpoints[i].Active := not FDebugPlugin.Breakpoints[i].Active;
    if PSScriptDebugger1.Running then
      if FDebugPlugin.Breakpoints[i].Active then
        if Script = PSScriptDebugger1.MainFileName then
          PSScriptDebugger1.SetBreakPoint('', Line)
        else
          PSScriptDebugger1.SetBreakPoint(Script, Line)
      else if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.ClearBreakPoint('', Line)
      else
        PSScriptDebugger1.ClearBreakPoint(Script, Line);
  end
  else
  begin // suppression du point d'arrêt
    FDebugPlugin.Breakpoints.Delete(i);
    if PSScriptDebugger1.Running then
      if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.ClearBreakPoint('', Line)
      else
        PSScriptDebugger1.ClearBreakPoint(Script, Line);
  end;
end;

procedure TfrmScripts.seScript1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  WordVar: string = '';
var
  pv: PIFVariant;
  Prefix: string;
  s: string;
begin
  if not PSScriptDebugger1.Running then
  begin
    WordVar := '';
    GetActiveScript.ShowHint := False;
    Exit;
  end;
  s := GetActiveScript.WordAtMouse;
  if s <> WordVar then
    Application.CancelHint;
  WordVar := s;

  pv := GetVar(WordVar, Prefix);
  if pv = nil then
  begin
    GetActiveScript.Hint := '';
    GetActiveScript.ShowHint := False;
  end
  else
  begin
    GetActiveScript.Hint := PSVariantToString(NewTPSVariantIFC(pv, False), Prefix);
    GetActiveScript.ShowHint := True;
  end;
end;

type
  PPositionData = ^TPositionData;
  TPositionData = packed record
    FileName: string;
    Position,
      Row,
      Col,
      SourcePosition: Cardinal;
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

function TfrmScripts.TranslatePositionEx(out Proc, Position: Cardinal; Row: Cardinal; Fn: string): Boolean;
var
  i, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  Result := True;
  Proc := 0;
  Position := 0;
  for i := 0 to TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs.Count - 1 do
  begin
    Result := False;
    fi := TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs[i];
    pt := fi^.FPositionTable;
    for j := 0 to pt.Count - 1 do
    begin
      r := pt[j];
      if not SameText(r^.FileName, Fn) then
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

procedure TfrmScripts.SetCompiled(const Value: Boolean);
var
  Editor: TSynEdit;
begin
  FCompiled := Value;
  Editor := GetActiveScript;
  if Assigned(Editor) then Editor.Invalidate;
end;

function TfrmScripts.CorrectScriptName(const Fichier: string): string;
begin
  if Fichier = '' then
    Result := Projet
  else
    Result := Fichier;
end;

function TfrmScripts.GetActiveScript: TSynEdit;
begin
  if pcScripts.PageCount = 0 then
    Result := nil
  else
    Result := TSynEdit(pcScripts.ActivePage.Controls[0]);
end;

function TfrmScripts.GetActiveScriptName: string;
begin
  if pcScripts.PageCount = 0 then
    Result := Projet
  else
    Result := pcScripts.ActivePage.Caption;
end;

function TfrmScripts.GetScript(const Fichier: string): TSynEdit;
var
  i: Integer;
  s: string;
begin
  if Fichier = '' then
    s := Projet
  else
    s := Fichier;
  for i := 0 to Pred(pcScripts.PageCount) do
    with pcScripts.Pages[i] do
      if SameText(Caption, s) then
      begin
        Result := TSynEdit(Controls[0]);
        Exit;
      end;
  Result := nil;
end;

function TfrmScripts.GetScriptName(Editor: TSynEdit): string;
begin
  if Assigned(Editor) then
    Result := TTabSheet(Editor.Parent).Caption
  else
    Result := Projet;
end;

function TfrmScripts.GetProjet: string;
begin
  Result := PSScriptDebugger1.MainFileName;
end;

procedure TfrmScripts.SetProjet(const Value: string);
begin
  ProjetOuvert := False;
  // doit etre fait avant le LoadScript
  PSScriptDebugger1.MainFileName := Value;
  LoadScript(Value);
  ProjetOuvert := True;
end;

procedure TfrmScripts.LoadScript(const Fichier: string);
var
  SB: TStatusBar;
  Editor: TSynEdit;
  Page: TTabSheet;
  Script: string;
  LockWindow: ILockWindow;
begin
  Editor := GetScript(Fichier);
  if not Assigned(Editor) then
  begin
    LockWindow := TLockWindow.Create(pcScripts);

    // doit être fait avant la création de page
    if not GetScriptLines(Fichier, Script) then
      raise Exception.Create('Impossible de trouver le fichier ' + Utilisateur.Options.RepertoireScripts + Fichier + '.bdu.');

    Page := TTabSheet.Create(pcScripts);
    Page.PageControl := pcScripts;
    Page.Caption := Fichier;
    Editor := TSynEdit.Create(Page);
    Editor.Parent := Page;
    Editor.Align := alClient;
    Editor.Color := clWhite;
    Editor.ActiveLineColor := 16314351;
    Editor.Font.Color := clWindowText;
    Editor.Font.Height := -13;
    Editor.Font.Name := 'Courier New';
    Editor.Font.Style := [];
    Editor.OnMouseMove := seScript1MouseMove;
    Editor.Gutter.AutoSize := True;
    Editor.Gutter.DigitCount := 3;
    Editor.Gutter.Font.Color := clWindowText;
    Editor.Gutter.Font.Height := -11;
    Editor.Gutter.Font.Name := 'Terminal';
    Editor.Gutter.Font.Style := [];
    Editor.Gutter.LeftOffset := 27;
    Editor.Gutter.ShowLineNumbers := True;
    Editor.Gutter.Width := 0;
    Editor.Highlighter := SynPasSyn1;
    Editor.Options := [eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing, eoGroupUndo, eoRightMouseMovesCursor, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];
    Editor.ScrollHintFormat := shfTopToBottom;
    Editor.SearchEngine := SynEditSearch1;
    Editor.TabWidth := 2;
    Editor.WantTabs := True;
    Editor.OnChange := seScript1Change;
    Editor.OnGutterClick := seScript1GutterClick;
    Editor.OnGutterPaint := seScript1GutterPaint;
    Editor.OnReplaceText := seScript1ReplaceText;
    Editor.OnSpecialLineColors := seScript1SpecialLineColors;
    Editor.OnStatusChange := seScript1StatusChange;
    Editor.OnProcessUserCommand := seScript1ProcessUserCommand;
    Editor.OnKeyPress := seScript1KeyPress;
    Editor.AddKey(ecUserFirst + 1, VK_RETURN, [ssCtrl]);

    TSynDebugPlugin.Create(Editor, FDebugPlugin);
    Editor.Lines.Text := Script;

    SB := TStatusBar.Create(Page);
    SB.Parent := Page;
    SB.Panels.Add.Width := 50;
    SB.Panels.Add.Width := 50;

    Page.Visible := True;
  end;
  GoToPosition(Editor, 1, 1);
end;

procedure TfrmScripts.ClearPages;
var
  i: Integer;
begin
  for i := 0 to Pred(pcScripts.PageCount) do
    actFermer.Execute;
end;

function TfrmScripts.GetScriptLines(const Fichier: string; out Output: string): Boolean;
var
  path: string;
  f: TFileStream;
  Editor: TSynEdit;
begin
  Editor := GetScript(Fichier);
  if Assigned(Editor) then
  begin
    Output := Editor.Lines.Text;
    Result := True;
    Exit;
  end;

  if Fichier = Projet then
    Path := Utilisateur.Options.RepertoireScripts + Fichier + '.bds'
  else
    Path := Utilisateur.Options.RepertoireScripts + Fichier + '.bdu';

  try
    F := TFileStream.Create(Path, fmOpenRead or fmShareDenyWrite);
  except
    Result := False;
    Exit;
  end;
  try
    SetLength(Output, f.Size);
    f.Read(Output[1], Length(Output));
  finally
    f.Free;
  end;
  Result := True;
end;

procedure TfrmScripts.actFermerExecute(Sender: TObject);
begin
  if not FForceClose and (GetActiveScriptName = Projet) then Exit;

  if GetActiveScript.Tag = 1 then
  begin
    case MessageDlg('Le fichier "' + GetActiveScriptName + '" a été modifié, voulez-vous l''enregistrer?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes: actEnregistrer.Execute;
      mrNo: ;
      mrCancel: Abort;
    end;
  end;
  pcScripts.ActivePage.Free;
end;

procedure TfrmScripts.actEnregistrerExecute(Sender: TObject);
begin
  GetActiveScript.Lines.SaveToFile(Utilisateur.Options.RepertoireScripts + GetActiveScriptName + '.bds');
  GetActiveScript.Tag := 0;
end;

procedure TfrmScripts.actEnregistrerSousExecute(Sender: TObject);
begin
  //
end;

procedure TfrmScripts.SetProjetOuvert(const Value: Boolean);
begin
  if not Value then
  begin
    FForceClose := True;
    try
      ClearPages;
      Compiled := False;
      FDebugPlugin.Messages.Clear;
      PSScriptDebugger1.MainFileName := '';
    finally
      FForceClose := False;
    end;
  end;
  FProjetOuvert := Value;
end;

procedure TfrmScripts.ListView1DblClick(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) then Exit;
  Projet := ListView1.Selected.Caption;
end;

procedure TfrmScripts.seScript1ProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command - ecUserFirst of
    1: LoadScript(GetActiveScript.WordAtCursor);
  end;
end;

procedure TfrmScripts.actRunWithoutDebugExecute(Sender: TObject);
begin
  PSScriptDebugger1.UseDebugInfo := False;
  try
    actRun.Execute;
  finally
    PSScriptDebugger1.UseDebugInfo := True;
  end;
end;

procedure TfrmScripts.pcScriptsChange(Sender: TObject);
begin
  //  à améliorer:
  //     - les params ne s'affichent pas
  //     - l'autocomplete ne s'affiche pas toujours
  //     - l'autocomplete choisi mal ce qui est affiché en fonction de la position dans le script
  SynEditAutoComplete.Editor := GetActiveScript;
  SynEditParamShow.Editor := GetActiveScript;
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
    Info.Name := 0;
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
    if (length(Info.OrgName) < 1) or (Info.OrgName[1] in ['!', ' ', '_']) then
    begin
      ClearInfoRec;
      exit;
    end;

    Info.Name := HashString(Info.OrgName);
    SetLength(fObjectList, Length(fObjectList) + 1);
    fObjectList[high(fObjectList)] := Info;
    ClearInfoRec;
  end;

  function TypHasField(Typ: TPSType): Boolean;
  begin
    result := (Typ is TPSClassType) or (Typ is TPSRecordType);
  end;

  procedure AddVar(Name: string; Typ: TPSType; InfoType: TInfoType = itVar); overload;
  begin
    Info.OrgName := Name;

    Info.OrgParams := ': ' + GetTypeName(Typ);
    Info.ReturnTyp := HashString(GetTypeName(Typ));
    Info.HasFields := TypHasField(Typ);
    Info.typ := itVar;
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
    Params: string;
  begin
    Info.OrgParams := GetParams(Parameters);
    Params := GetParams(Parameters, '"');

    Params := Copy(Params, Pos('(', Params) + 1, length(Params));
    Params := Copy(Params, 1, Pos(')', Params) - 1);
    Params := StringReplace(Params, ';', ',', [rfReplaceAll]);

    Info.Params := Params;
  end;

  procedure AddProcedure(Name: string; Parameters: TPSParametersDecl);
  begin
    Info.OrgName := Name;

    SetParams(Info, Parameters);

    if Parameters.Result = nil then
      info.Typ := itProcedure
    else
    begin
      info.Typ := itFunction;
      info.ReturnTyp := HashString(GetTypeName(Parameters.Result));
      Info.HasFields := TypHasField(Parameters.result);
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

    Info.OrgParams := ': ' + GetTypeName(con.FValue.FType);
    Info.ReturnTyp := HashString(GetTypeName(con.FValue.FType));
    Info.HasFields := TypHasField(con.FValue.FType);
    Info.Nr := Con.Value.ts32;
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

procedure TfrmScripts.RebuildLokalObjektList;
var
  Script: TStringList;
begin
  Script := TStringList.Create;
  try
    Script.Text := GetActiveScript.Text;
    Script[GetActiveScript.CaretXY.Line - 1] := '';

    PSScriptDebugger1.Script.Text := Script.Text;
    PSScriptDebugger1.Compile;
  finally
    Script.Free;
  end;
end;

function TfrmScripts.GetLookUpString(Line: string; EndPos: Integer): string;
const
  TSynValidIdentifierChars = TSynValidStringChars + ['.', ' ', '[', ']', '(', ')'];
var
  TmpX: Integer;
  ParenCount: Integer;
  WasSpace: Boolean;
  CanSpace: Boolean;
begin
  //we have a valid open paren, lets see what the word before it is
  TmpX := EndPos;
  ParenCount := 0;
  WasSpace := false;
  CanSpace := true;
  while (TmpX > 0) and ((Line[TmpX] in TSynValidIdentifierChars) or (ParenCount > 0)) do
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
          CanSpace := true;
          WasSpace := false;
        end;
      ' ':
        begin
          if not CanSpace then
            WasSpace := true;
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
    result := Copy(Line, TmpX + 1, EndPos - TmpX)
  else
    result := '';

end;

function TfrmScripts.FindParameter(LocLine: string; X: Integer; out Func: TParamInfoRecord; out ParamCount: Integer): Boolean;
var
  TmpX: Integer;
  StartX, ParenCounter: Integer;
  LookUp: string;
begin
  { TODO : grosse lacune, la fonction ne gère pas du tout si la parenthèse est dans une chaine ou non }

  //go back from the cursor and find the first open paren
  TmpX := X;
  if TmpX > length(locLine) then
    TmpX := length(locLine)
  else
    Dec(TmpX);

  result := False;
  ParamCount := 0;
  while (TmpX > 0) and not (result) do
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
      //We found a close, go till it's opening paren
      ParenCounter := 1;
      Dec(TmpX);
      while (TmpX > 0) and (ParenCounter > 0) do
      begin
        if LocLine[TmpX] = ')' then
          inc(ParenCounter)
        else if LocLine[TmpX] = '(' then
          dec(ParenCounter);

        dec(TmpX);
      end;
    end
    else if locLine[TmpX] = '(' then
    begin
      //we have a valid open paren, lets see what the word before it is
      StartX := TmpX;
      LookUp := GetLookUpString(locLine, tmpX - 1);
      if LookUp <> '' then
      begin
        result := LookupList(Lookup, Func);
        if not (Func.Typ in [itProcedure, itFunction, itType]) then
        begin
          result := false;
        end;
        if not (result) then
        begin
          TmpX := StartX;
          dec(TmpX);
        end;
      end;
    end
    else
      dec(TmpX)
  end;
end;

function TfrmScripts.LookUpList(LookUp: string; var ParamInfo: TParamInfoRecord): Boolean;
var
  Dummy: Integer;
  Hash: Cardinal;
  Parts: TStringArray;

  FindString: string;
  Parent: Cardinal;

  function FindEntry(LookUp: string; Parent: Cardinal; var ParamInfo: TParamInfoRecord): Boolean;
  var
    Dummy: Integer;
    Hash: Cardinal;
  begin
    Hash := HashString(LookUp);
    result := false;
    for Dummy := 0 to high(fObjectList) do
    begin
      if (fObjectList[Dummy].Name = Hash) and (fObjectList[Dummy].Father = Parent) then
      begin
        result := true;
        ParamInfo := fObjectList[Dummy];
        exit;
      end
    end;

    // Keinen passenden Eintrag gefunden. Vorfahren prüfen
    if LookUpList(Parent, ParamInfo) then
    begin
      if ParamInfo.SubType <> 0 then
      begin
        result := FindEntry(LookUp, ParamInfo.SubType, ParamInfo);
      end;
    end;
  end;

begin
  if Pos('.', LookUp) = 0 then
  begin
    // Einfacher Bezeichner wird gesucht
    Hash := HashString(Trim(LookUp));
    result := false;
    for Dummy := 0 to high(fObjectList) do
    begin
      if (fObjectList[Dummy].Name = Hash) and (fObjectList[Dummy].Father = 0) then
      begin
        result := true;
        ParamInfo := fObjectList[Dummy];
        exit;
      end
    end;
  end
  else
  begin
    // Verknüpfter bezeichner wird gesucht
    Parts := Explode('.', LookUp);
    Assert(length(Parts) > 0, 'Blub' + LookUp);
    result := false;
    Parent := 0;
    for Dummy := 0 to high(Parts) do
    begin
      FindString := Trim(Parts[Dummy]);
      if Pos('[', FindString) > 0 then
        FindString := Copy(FindString, 1, Pos('[', FindString) - 1);

      if Pos('(', FindString) > 0 then
        FindString := Copy(FindString, 1, Pos('(', FindString) - 1);

      if not FindEntry(FindString, Parent, ParamInfo) then
        exit;

      Parent := ParamInfo.ReturnTyp;
    end;
    result := true;
  end;
end;

function TfrmScripts.LookUpList(LookUp: Cardinal; var ParamInfo: TParamInfoRecord): Boolean;
var
  Dummy: Integer;
begin
  result := false;
  for Dummy := 0 to high(fObjectList) do
  begin
    if (fObjectList[Dummy].Name = LookUp) and (fObjectList[Dummy].Father = 0) then
    begin
      result := true;
      ParamInfo := fObjectList[Dummy];
      exit;
    end
  end;
end;

procedure TfrmScripts.SynEditParamShowExecute(Kind: TSynCompletionType; Sender: TObject; var CurrentInput: string; var x, y: Integer; var CanExecute: Boolean);
var
  ParamIndex: Integer;
  Info: TParamInfoRecord;
  Editor: TSynEdit;
begin
  RebuildLokalObjektList;

  Editor := GetActiveScript;
  CanExecute := FindParameter(Editor.LineText, Editor.CaretX, Info, ParamIndex);

  TSynCompletionProposal(Sender).ItemList.Clear;

  if CanExecute then
  begin
    TSynCompletionProposal(Sender).Form.CurrentIndex := ParamIndex;
    if Info.Params = '' then
      Info.Params := '"* Pas de paramètre *"';

    TSynCompletionProposal(Sender).ItemList.Add(Info.Params);
  end;
end;

procedure TfrmScripts.SynEditAutoCompleteExecute(Kind: TSynCompletionType; Sender: TObject; var CurrentInput: string; var x, y: Integer; var CanExecute: Boolean);
var
  Parser: TPSPascalParser;
  Token: TPSPasToken;
  Prev: TPSPasToken;
  PrevEnd: Integer;
  Types: TInfoTypes;
  tmpX: Integer;
  Father: Cardinal;
  Line: string;
  Info: TParamInfoRecord;
  ParamCount: Integer;
  Parts: TStringArray;
  Typ: string;
  Obj: string;
  Editor: TSynEdit;
  hasAssign: Boolean;
begin
  Editor := GetActiveScript;
  RebuildLokalObjektList;

  Line := Editor.LineText;

  Types := [itProcedure, itFunction, itVar];
  Parser := TPSPascalParser.Create;
  Parser.SetText(Line);

  Father := 0;
  Typ := '';

  CanExecute := false;

  Prev := CSTI_EOF;
  Token := CSTI_EOF;
  PrevEnd := -1;
  hasAssign := False;
  while (Parser.CurrTokenID <> CSTI_EOF) and (Parser.CurrTokenPos < Cardinal(Editor.CaretX - 1)) do
  begin
    Prev := Token;
    PrevEnd := Parser.CurrTokenPos + Cardinal(Length(Parser.OriginalToken));
    Token := Parser.CurrTokenID;
    // Tritt ein := oder ( auf, so wird ein Wert mit einem Rückgabewert erwartet
    // si un := ou ( alors, il est une valeur avec une valeur de retour prévu
    if (Token = CSTI_Assignment) and (Prev = CSTI_Identifier) then
    begin
      Types := [itFunction, itVar, itConstant {, itType}];
      if LookUpList(Copy(Editor.LineText, 1, Parser.CurrTokenPos), Info) then
        Typ := Copy(Info.OrgParams, 3, length(Info.OrgParams));
      hasAssign := True;
    end
    else if (Token = CSTI_OpenRound) then
    begin
      Types := [itFunction, itVar, itConstant {, itType}];
      hasAssign := True;
    end
    else if (Token = CSTI_SemiColon) then
    begin
      hasAssign := False;
      Typ := '';
    end;

    Parser.Next;
  end;

  Parser.Free;

  if Token = CSTI_String then Exit;

  if (PrevEnd < (Editor.CaretX - 1)) then
    Prev := Token;

  if Prev = CSTI_Colon then
    Types := [itType]
  else if Prev = CSTI_AddressOf then
  begin
    Types := [itProcedure, itFunction];
    Typ := '';
  end
  else if Prev = CSTI_Period then
  begin
    tmpX := Editor.CaretX - 1;
    if tmpX > Length(Line) then
      tmpX := Length(Line);

    while (tmpX > 0) and (Line[tmpX] <> '.') do
      dec(tmpX);

    dec(tmpX);

    Obj := GetLookUpString(Line, tmpX);

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

  if (Prev <> CSTI_AddressOf) and FindParameter(Editor.LineText, Editor.CaretX, Info, ParamCount) then
  begin
    Parts := Explode(',', Info.Params);
    if ParamCount <= high(Parts) then
    begin
      if Pos(':', Parts[ParamCount]) > 0 then
      begin
        Typ := Copy(Parts[ParamCount], Pos(':', Parts[ParamCount]) + 2, length(Parts[ParamCount]));
        Typ := Copy(Typ, 1, length(Typ) - 1);
      end
      else
        Typ := '';

      Exclude(Types, itProcedure);
    end;
  end;

  CanExecute := true;
  FillAutoComplete(fObjectList, Types, Father, Typ);
end;

procedure TfrmScripts.FillAutoComplete(var List: TParamInfoArray; Types: TInfoTypes; FromFather: Cardinal; Typ: string);
var
  Dummy: Integer;
  Text, sTyp: string;
  HashT: Cardinal;
  cl: TColor;
  Father: TParamInfoRecord;

  function CompareTypes(Typ1: Cardinal; Typ2: Cardinal): Boolean;
  var
    Type1, Type2: Integer;
    Info: TParamInfoRecord;
  begin
    if (Typ1 = 0) or (Typ2 = 0) then
    begin
      result := false;
      exit;
    end;

    if Typ1 = Typ2 then
    begin
      result := true;
      exit;
    end;

    Assert(fTypeInfos.FindKey(Typ1, Type1));
    Assert(fTypeInfos.FindKey(Typ2, Type2));
    result := BaseTypeCompatible(Type1, Type2);

    if result then
    begin
      // Prüfen, ob Records und Aufzählungen kompatibel sind
      if (Type1 = btEnum) or (Type1 = btRecord) then
      begin
        result := Typ1 = Typ2;
        exit;
      end;
    end;

    if not result then
    begin
      // Klassenkompatibilität prüfen
      if LookUpList(Typ2, Info) then
      begin
        while Info.SubType <> 0 do
        begin
          Assert(LookUpList(Info.SubType, Info));
          if Info.ReturnTyp = Typ1 then
          begin
            result := true;
            exit;
          end;
        end;
      end;
    end;
  end;

  function HasFieldReturnTyp(ReturnTyp: Cardinal; FatherTyp: Cardinal): Boolean;
  var
    Dummy: Integer;
  begin
    result := false;
    if (FatherTyp = 0) or (ReturnTyp = 0) then
      exit;

    for Dummy := 0 to high(List) do
    begin
      if List[Dummy].Typ = itConstructor then
        continue;

      if (List[Dummy].Father = FatherTyp) then
      begin
        if (CompareTypes(ReturnTyp, List[Dummy].ReturnTyp)) then
        begin
          result := true;
          exit;
        end;
        if List[Dummy].HasFields then
        begin
          if HasFieldReturnTyp(ReturnTyp, List[Dummy].Name) then
          begin
            result := true;
            exit;
          end;
        end;
      end;
      if List[Dummy].Name = FatherTyp then
      begin
        if List[Dummy].SubType <> 0 then
        begin
          if HasFieldReturnTyp(ReturnTyp, List[Dummy].SubType) then
          begin
            result := true;
            exit;
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
        if List[Dummy].Name = Father.SubType then
        begin
          FillAutoComplete(List, Types, List[Dummy].Name, Typ);
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
        if (Typ in Types) and
          (Father = FromFather) and
          ((HashT = 0) or
          (CompareTypes(HashT, ReturnTyp)) or
          (HashT = ReturnTyp) or
          HasFields
          ) then
        begin
          cl := clBlack;
          case Typ of
            itProcedure:
              begin
                Text := 'procedure ';
                cl := clTeal;
              end;
            itFunction:
              begin
                Text := 'function ';
                cl := clBlue;
              end;
            itType:
              begin
                Text := 'type ';
                cl := clTeal;
              end;
            itVar:
              begin
                Text := 'var ';
                cl := clMaroon;
              end;
            itConstant:
              begin
                Text := 'const ';
                cl := clGreen;
              end;
            itField:
              begin
                Text := 'property ';
                cl := clTeal;
              end;
            itConstructor:
              begin
                Text := 'constructor ';
                cl := clTeal;
              end;
            else
              Assert(false);
          end;
          sTyp := Text;

          if HasFields and (HashT <> 0) and (HashT <> ReturnTyp) then
          begin
            if HasFieldReturnTyp(HashT, ReturnTyp) then
              Text := '\color{' + ColorToString(cl) + '}' + Text + '\column{}\color{0}\style{+B}' + OrgName + '...\style{-B}'
            else
              continue;
          end
          else
          begin
            Text := '\color{' + ColorToString(cl) + '}' + Text + '\column{}\color{0}\style{+B}' + OrgName + '\style{-B}';
            if Typ <> itConstructor then Text := Text + OrgParams;
          end;

          sl1.AddObject(OrgName, Pointer(sl2.Count));
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

  if (SynEditAutoComplete.InsertList.Count = 0) and (Hasht <> 0) then
    FillAutoComplete(List, Types, FromFather);
end;

procedure TfrmScripts.seScript1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ' ') and ((GetKeyState(VK_CONTROL) < 0) or (GetKeyState(VK_SHIFT) < 0)) then
    Key := #0;
end;

end.

