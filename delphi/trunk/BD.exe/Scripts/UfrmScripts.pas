unit UfrmScripts;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, SynEditHighlighter, SynEdit, ImgList,
  StrUtils, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, Menus, SynEditTypes, ComCtrls, UScriptUtils, VirtualTrees, StdCtrls,
  ExtCtrls, LoadComplet, SynEditKeyCmds, UBdtForms, Generics.Collections, ToolWin, UfrmFond, UScriptEditor,
  PngImageList, UScriptEngineIntf, UScriptList, UframBoutons, EditLabeled,
  System.Actions, SynCompletionProposal, SynEditPlugins, SynMacroRecorder,
  dwsDebugger, UframWatches, UframBreakpoints, UframMessages, UframScriptInfos;

const
  ecOpenFileUnderCursor = ecUserFirst;
  ecToggleDeclImpl = ecUserFirst + 1;

type
  TfrmScripts = class;

  TLineChangedState = (csOriginal, csModified, csSaved);

  TEditorPage = class(TWinControl)
  private
    FScript: TScript;
    FTabSheet: TTabSheet;
    FModifie: Boolean;
    FEditor: TScriptEditor;
    FSB: TStatusBar;
    FMasterEngine: IMasterEngine;
    FfrmScripts: TfrmScripts;
    FExecutableLines: TBits;
    FLineChangedState: array of TLineChangedState;
    procedure SetModifie(const Value: Boolean);
  public
    procedure DoOnEditorChange(ASender: TObject);
    procedure SynEditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure SynEditGutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure SynEditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure SynEditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure SynEditorCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);

    procedure UpdateStatusBarPanels;

    procedure ShowExecutableLines;
    procedure ClearExecutableLines;
    procedure InitExecutableLines;
    function IsExecutableLine(aLine: Integer): Boolean; inline;

    procedure ClearLineChangeStates;
    procedure InitLineChangeStates;
    function GetLineChangeState(aLine: Integer): TLineChangedState; inline;

    procedure GotoLineNumber;
    procedure OpenFileUnderCursor;

    constructor Create(AOwner: TPageControl; AfrmScripts: TfrmScripts; AScript: TScript); reintroduce;
    destructor Destroy; override;
  published
    property frmScripts: TfrmScripts read FfrmScripts;
    property MasterEngine: IMasterEngine read FMasterEngine;

    property Script: TScript read FScript;
    property TabSheet: TTabSheet read FTabSheet write FTabSheet;
    property Editor: TScriptEditor read FEditor write FEditor;
    property SB: TStatusBar read FSB write FSB;
    property Modifie: Boolean read FModifie write SetModifie;
  end;

  TEditorPagesList = class(TObjectList<TEditorPage>)
  public
    function EditorByUnitName(const Script: string): TScriptEditor;
  end;

  TfrmScripts = class(TbdtForm)
    SynEditSearch: TSynEditSearch;
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
    actEdit: TAction;
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
    tabMessages: TTabSheet;
    tabWatches: TTabSheet;
    tabBreakpoints: TTabSheet;
    tabConsole: TTabSheet;
    mmConsole: TMemo;
    Splitter2: TSplitter;
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
    Button1: TButton;
    SynMacroRecorder: TSynMacroRecorder;
    SynCodeCompletion: TSynCompletionProposal;
    SynParameters: TSynCompletionProposal;
    dwsDebugger: TdwsDebugger;
    framWatches1: TframWatches;
    framBreakpoints1: TframBreakpoints;
    framMessages1: TframMessages;
    framScriptInfos1: TframScriptInfos;
    procedure SearchFind1Execute(Sender: TObject);
    procedure SearchFindNext1Execute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure EditCut1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditUndo1Execute(Sender: TObject);
    procedure EditRedo1Execute(Sender: TObject);
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
    procedure vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstMessagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seScript1Change(Sender: TObject);
    procedure vstBreakpointsDblClick(Sender: TObject);
    procedure actFermerExecute(Sender: TObject);
    procedure actEnregistrerExecute(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure actRunWithoutDebugExecute(Sender: TObject);
    procedure pcScriptsChange(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure actEditExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure mmConsoleChange(Sender: TObject);
    procedure framBoutons1btnAnnulerClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SynCodeCompletionShow(Sender: TObject);
    procedure SynCodeCompletionExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer; var CanExecute: Boolean);
    procedure SynParametersExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer; var CanExecute: Boolean);
    procedure framMessages1vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FCompiled: Boolean;
    FProjetOuvert: Boolean;
    FForceClose: Boolean;

    FCurrentPage: TEditorPage;
    FOpenedScript: TEditorPagesList;
    FRefreshingDescription: Boolean;
    FMasterEngine: IMasterEngine;
{$REGION 'Exécution'}
    function Compile: Boolean;
    function Execute: Boolean;
    procedure PSScriptDebugger1Idle(Sender: TObject);
{$ENDREGION}
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
{$REGION 'Débuggage'}
    procedure GoToPosition(Editor: TSynEdit; Line, Char: Cardinal); overload;
    procedure GoToPosition(ScriptUnitName: string; Line, Char: Cardinal); overload; inline;
    procedure GoToMessage(msg: IMessageInfo);
    procedure GoToBreakpoint(msg: IBreakpointInfo);
{$ENDREGION}
    function GetPageFromUnitName(const UnitName: string): TEditorPage;
    function GetPageForScript(const Script: TScript): TEditorPage;

    function GetScriptEditor(const UnitName: string): TScriptEditor;
    procedure SetCompiled(const Value: Boolean);
    function GetProjet: string;
    procedure SetProjet(const Value: string);
    procedure LoadScript(const UnitName: string);
    procedure RefreshOptions;
    procedure RefreshDescription(Script: TScript);
    procedure ClearPages;
    procedure SetProjetOuvert(const Value: Boolean);
    procedure LoadScripts;
    procedure AfterExecute;

    procedure ShowExecutableLines;
    procedure ClearExecutableLines;
    procedure ClearLinesChangedState;

    procedure OnBreakPoint;
    procedure SetMasterEngine(const Value: IMasterEngine);
  public
    property MasterEngine: IMasterEngine read FMasterEngine write SetMasterEngine;
    property Compiled: Boolean read FCompiled write SetCompiled;
    property Projet: string read GetProjet write SetProjet;
    property ProjetOuvert: Boolean read FProjetOuvert write SetProjetOuvert;
  end;

var
  frmScripts: TfrmScripts;

implementation

{$R *.dfm}

uses
  UfrmScriptSearch, UScriptsFonctions, CommonConst, UIB, Procedures, BdtkRegEx, Commun, Divers,
  UScriptsHTMLFunctions, JclSimpleXML, UdmPrinc, UfrmScriptOption, UfrmScriptEditOption, UfrmScriptsUpdate,
  UdmPascalScript, SynHighlighterDWS, UfrmScriptGotoLine, UMasterEngine;

const
  imgGutterBREAK = 0;
  imgGutterBREAKVALID = 1;
  imgGutterBREAKINVAL = 2;
  imgGutterCOMPLINE = 3;
  imgGutterEXECLINECL = 4;
  imgGutterEXECLINEBP = 5;
  imgGutterEXECLINE = 6;
  imgGutterBREAKDISABLED = 7;

function TfrmScripts.GetScriptEditor(const UnitName: string): TScriptEditor;
begin
  if (UnitName = '') or (UnitName = MasterEngine.Engine.GetSpecialMainUnitName) then
    Result := FOpenedScript.EditorByUnitName(Projet)
  else
    Result := FOpenedScript.EditorByUnitName(UnitName);
end;

procedure TfrmScripts.Button1Click(Sender: TObject);
begin
  with TfrmScriptsUpdate.Create(nil) do
    try
      MasterEngine := Self.MasterEngine;
      ShowModal;
    finally
      Free;
    end;
  LoadScripts;
end;

procedure TfrmScripts.mmConsoleChange(Sender: TObject);
begin
  if (PageControl1.ActivePage <> tabWatches) or (MasterEngine.DebugPlugin.Watches.CountActive = 0) then
    PageControl1.ActivePage := tabConsole;
  Application.ProcessMessages;
end;

procedure TfrmScripts.PageControl2Change(Sender: TObject);
begin
  if PageControl2.ActivePageIndex = 0 then
    ProjetOuvert := False;
  RefreshOptions;
  RefreshDescription(MasterEngine.ProjectScript);
  framScriptInfos1.Panel3.ActivePageIndex := 0;
end;

{$REGION 'Edition'}

procedure TfrmScripts.SearchFind1Execute(Sender: TObject);
var
  dummyReplace: string;
begin
  with FCurrentPage.Editor do
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
  else if FCurrentPage.Editor.SearchReplace(FLastSearch, FLastReplace, FSearchOptions) = 0 then
    ShowMessage('Texte non trouvé');
end;

procedure TfrmScripts.EditCut1Execute(Sender: TObject);
begin
  FCurrentPage.Editor.CutToClipboard;
end;

procedure TfrmScripts.EditCopy1Execute(Sender: TObject);
begin
  FCurrentPage.Editor.CopyToClipboard;
end;

procedure TfrmScripts.EditPaste1Execute(Sender: TObject);
begin
  FCurrentPage.Editor.PasteFromClipboard;
end;

procedure TfrmScripts.EditSelectAll1Execute(Sender: TObject);
begin
  FCurrentPage.Editor.SelectAll;
end;

procedure TfrmScripts.EditUndo1Execute(Sender: TObject);
begin
  FCurrentPage.Editor.Undo;
end;

procedure TfrmScripts.EditRedo1Execute(Sender: TObject);
begin
  FCurrentPage.Editor.Redo;
end;

procedure TfrmScripts.seScript1Change(Sender: TObject);
var
  Editor: TScriptEditor;
begin
  Compiled := False;

  if (MasterEngine.Engine.ErrorLine > 0) then
  begin
    Editor := FOpenedScript.EditorByUnitName(MasterEngine.Engine.ErrorUnitName);
    if Editor <> nil then
    begin
      Editor.InvalidateLine(MasterEngine.Engine.ErrorLine);
      Editor.InvalidateGutterLine(MasterEngine.Engine.ErrorLine);
    end;
    MasterEngine.Engine.ErrorLine := 0;
  end;
end;

procedure TfrmScripts.actFermerExecute(Sender: TObject);
begin
  if not FForceClose and (FCurrentPage.Script.ScriptUnitName = Projet) then
    Exit;

  if FCurrentPage.Modifie then
  begin
    case MessageDlg('L''unité "' + string(FCurrentPage.Script.ScriptUnitName) + '" a été modifiée, voulez-vous l''enregistrer?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        actEnregistrer.Execute;
      mrNo:
        ;
      mrCancel:
        Abort;
    end;
  end;
  FOpenedScript.Delete(pcScripts.ActivePageIndex);
  pcScripts.ActivePage.Free;
  // FCurrentPage.TabSheet := nil;
  // FCurrentPage.Editor := nil;
  // FCurrentPage.SB := nil;
  // FCurrentPage.Modifie := False;
  // FCurrentPage.Script.Loaded := False;
  pcScriptsChange(nil);
end;

procedure TfrmScripts.actEditExecute(Sender: TObject);
begin
  Projet := ListView1.Selected.Caption;
end;

procedure TfrmScripts.actEnregistrerExecute(Sender: TObject);
begin
  with FOpenedScript[pcScripts.ActivePageIndex] do
  begin
    Script.Code.Assign(Editor.Lines);
    Script.Save;
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
  Script: TScript;
  qry: TUIBQuery;
begin
  if Selected and Assigned(Item) then
  begin
    Script := TScript(Item.Data);
    Script.Load;
    MasterEngine.SelectProjectScript(Script);

    if MasterEngine.ProjectScript.Options.Count > 0 then
    begin
      qry := TUIBQuery.Create(nil);
      try
        qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
        qry.SQL.Text := 'select nom_option, valeur from options_scripts where script = :script';
        qry.Prepare(True);
        qry.Params.AsString[0] := Copy(string(MasterEngine.ProjectScript.ScriptUnitName), 1, qry.Params.MaxStrLen[0]);
        qry.Open;
        while not qry.Eof do
        begin
          Option := MasterEngine.ProjectScript.OptionByName(qry.Fields.AsString[0]);
          if Assigned(Option) then
            Option.ChooseValue := qry.Fields.AsString[1];
          qry.Next;
        end;
      finally
        qry.Transaction.Free;
        qry.Free;
      end;
    end;
  end
  else
  begin
    // pour forcer la fermeture des onglets tant que le projet est potentiellement ouvert :
    // la destruction de la fenêtre déselectionne l'item du listview avant de commencer la chaine des Destroy
    // et donc les passage dans FormDestroy et ClearPages
    // la question à 100 balles est "pourquoi ça ne se produit que lorsqu'on a fait un actEnregistrer.Execute"
    // ou dans certains cas quand l'exécution du script à généré une erreur de script
    ProjetOuvert := False;
    MasterEngine.TypeEngine := seNone;
  end;
  RefreshOptions;
  RefreshDescription(MasterEngine.ProjectScript);
end;

procedure TfrmScripts.pcScriptsChange(Sender: TObject);
begin
  if pcScripts.ActivePageIndex > -1 then
  begin
    FCurrentPage := FOpenedScript[pcScripts.ActivePageIndex];
    FCurrentPage.InitExecutableLines;
    FCurrentPage.ShowExecutableLines;
    framScriptInfos1.TabSheet4.TabVisible := (FCurrentPage.Script = MasterEngine.ProjectScript);
    RefreshDescription(FCurrentPage.Script);
  end
  else
  begin
    FCurrentPage := nil;
    framScriptInfos1.TabSheet4.TabVisible := False;
    RefreshDescription(nil);
  end
end;
{$ENDREGION}

procedure TfrmScripts.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE:
      if not MasterEngine.Engine.Running then
        inherited;
  else
    inherited;
  end;
end;

procedure TfrmScripts.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  Editor: TSynEdit;
begin
  if Assigned(FCurrentPage) then
  begin
    FCurrentPage.UpdateStatusBarPanels;
    Editor := FCurrentPage.Editor;
  end
  else
    Editor := nil;
  Handled := True;
  actEdit.Enabled := Assigned(ListView1.Selected);

  EditCut1.Enabled := Assigned(Editor) and Editor.Focused and Editor.SelAvail;
  EditCopy1.Enabled := Assigned(Editor) and Editor.Focused and Editor.SelAvail;
  EditPaste1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanPaste;
  EditUndo1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanUndo;
  EditRedo1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanRedo;
  actRun.Enabled := (FProjetOuvert or actEdit.Enabled) and ((MasterEngine.Engine = nil) or not MasterEngine.Engine.Running or
    (MasterEngine.Engine.DebugMode = UScriptEngineIntf.dmPaused));
  actRunWithoutDebug.Visible := MasterEngine.AlbumToUpdate;
  actRunWithoutDebug.Enabled := actRunWithoutDebug.Visible and actRun.Enabled and not MasterEngine.Engine.Running;
  actPause.Enabled := (MasterEngine.Engine <> nil) and MasterEngine.Engine.Running and (MasterEngine.Engine.DebugMode = UScriptEngineIntf.dmRun);
  actFermer.Enabled := Assigned(Editor) and (FForceClose or (FCurrentPage.Script <> MasterEngine.ProjectScript));
  actEnregistrer.Enabled := Assigned(Editor);
  actReset.Enabled := (MasterEngine.Engine <> nil) and MasterEngine.Engine.Running and (MasterEngine.Engine.DebugMode in [UScriptEngineIntf.dmPaused]);
  actCompile.Enabled := (MasterEngine.Engine <> nil) and not MasterEngine.Engine.Running;

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

function TfrmScripts.GetPageForScript(const Script: TScript): TEditorPage;
begin
  for Result in FOpenedScript do
    if Script = Result.Script then
      Exit;
  Result := nil;
end;

function TfrmScripts.GetPageFromUnitName(const UnitName: string): TEditorPage;
begin
  for Result in FOpenedScript do
    if UnitName = Result.Script.ScriptUnitName then
      Exit;
  Result := nil;
end;

function TfrmScripts.GetProjet: string;
begin
  Result := MasterEngine.ProjectScript.ScriptUnitName;
end;

procedure TfrmScripts.SetProjet(const Value: string);
begin
  ProjetOuvert := False;
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
      Compiled := False;
      MasterEngine.DebugPlugin.Messages.Clear;
    finally
      FForceClose := False;
    end;
  end;
  FProjetOuvert := Value;
  tbEdition.TabVisible := Value;
end;

procedure TfrmScripts.SetCompiled(const Value: Boolean);
begin
  FCompiled := Value;
  MasterEngine.Compiled := Value;
  if Assigned(FCurrentPage) and Assigned(FCurrentPage.Editor) then
  begin
    FCurrentPage.ClearExecutableLines;
    FCurrentPage.Editor.Invalidate;
  end;
end;

procedure TfrmScripts.SetMasterEngine(const Value: IMasterEngine);
begin
  FMasterEngine := Value;
  framWatches1.MasterEngine := FMasterEngine;
  framBreakpoints1.MasterEngine := FMasterEngine;
  framMessages1.MasterEngine := FMasterEngine;
  framScriptInfos1.MasterEngine := FMasterEngine;
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

  FOpenedScript := TEditorPagesList.Create;
  MasterEngine := TMasterEngine.Create;
  MasterEngine.Console := mmConsole.Lines;
  MasterEngine.DebugPlugin.OnGetScriptEditor := GetScriptEditor;
  MasterEngine.OnAfterExecute := AfterExecute;
  MasterEngine.OnBreakPoint := OnBreakPoint;
  // MasterEngine.OnIdle := PSScriptDebugger1Idle;

  FForceClose := False;
  PageControl1.ActivePageIndex := 0;

  LoadScripts;

  PageControl2.ActivePage := tbScripts;
  ProjetOuvert := False;
end;

procedure TfrmScripts.FormDestroy(Sender: TObject);
begin
  ProjetOuvert := False;
  MasterEngine.TypeEngine := seNone;
  ClearPages;
  FOpenedScript.Free;
  MasterEngine.Console := nil;
  MasterEngine.DebugPlugin.OnGetScriptEditor := nil;
  MasterEngine := nil;
end;

procedure TfrmScripts.framBoutons1btnAnnulerClick(Sender: TObject);
begin
  framBoutons1.btnAnnulerClick(Sender);
  if not MasterEngine.AlbumToUpdate then
    Release;
end;

procedure TfrmScripts.framMessages1vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  framMessages1.vstMessagesGetText(Sender, Node, Column, TextType, CellText);

end;

procedure TfrmScripts.RefreshDescription(Script: TScript);
begin
  FRefreshingDescription := True;
  try
    if Assigned(Script) then
    begin
      Label5.Caption := Script.ScriptInfos.Auteur;
      if Script.ScriptInfos.LastUpdate > 0 then
        Label6.Caption := DateTimeToStr(Script.ScriptInfos.LastUpdate)
      else
        Label6.Caption := '';
      Label8.Caption := Script.ScriptInfos.ScriptVersion;
      Label10.Caption := Script.ScriptInfos.BDVersion;
      Memo1.Lines.Text := Script.ScriptInfos.Description;

      framScriptInfos1.RefreshDescription;
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
    FRefreshingDescription := False;
  end;
end;

procedure TfrmScripts.RefreshOptions;
begin
  framScriptInfos1.RefreshOptions;
  ListBox2.Count := 0;
  ListBox2.Invalidate;
end;

procedure TfrmScripts.LoadScript(const UnitName: string);
var
  LockWindow: ILockWindow;
  Page: TEditorPage;
  Script: TScript;
begin
  if (UnitName = MasterEngine.Engine.GetSpecialMainUnitName) then
    Script := MasterEngine.ProjectScript
  else
    Script := MasterEngine.ScriptList.InfoScriptByUnitName(UnitName);
  // doit être fait avant la création de page pour s'assurer de l'existence du fichier
  if not Assigned(Script) then
    raise Exception.Create('Impossible de trouver l''unité ' + string(UnitName) + '.');

  Page := GetPageForScript(Script);
  if not Assigned(Page) then
  begin
    // if not Info.Loaded then
    Script.Load; // on force le rechargement pour être sûr de bien avoir la dernière version
    LockWindow := TLockWindow.Create(pcScripts);
    Page := TEditorPage.Create(pcScripts, Self, Script);
    FOpenedScript.Add(Page);
  end;
  GoToPosition(Page.Editor, 1, 1);
end;

procedure TfrmScripts.LoadScripts;
var
  Script: TScript;
begin
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    MasterEngine.ScriptList.LoadDir(RepScripts);
    for Script in MasterEngine.ScriptList do
      if Script.ScriptKind = skMain then
        with ListView1.Items.Add do
        begin
          Data := Script;
          Caption := string(Script.ScriptUnitName);
        end;
  finally
    ListView1.Items.EndUpdate;
  end;
  ListView1.OnSelectItem(ListView1, nil, False);
end;

procedure TfrmScripts.ClearPages;
var
  i: Integer;
begin
  for i := 0 to Pred(pcScripts.PageCount) do
    actFermer.Execute;
end;
{$REGION 'Débuggage'}

procedure TfrmScripts.actStepOverExecute(Sender: TObject);
begin
  // if MasterEngine.PSScriptDebugger1.Exec.Status = isRunning then
  if MasterEngine.Engine.Running then
    MasterEngine.Engine.StepOver
  else
  begin
    if Compile then
    begin
      MasterEngine.Engine.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actStepIntoExecute(Sender: TObject);
begin
  if MasterEngine.Engine.Running then
    MasterEngine.Engine.StepInto
  else
  begin
    if Compile then
    begin
      MasterEngine.Engine.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actPauseExecute(Sender: TObject);
begin
  MasterEngine.Engine.Pause;
  GoToPosition(MasterEngine.Engine.ActiveUnitName, MasterEngine.Engine.ActiveLine, 1);
end;

procedure TfrmScripts.actResetExecute(Sender: TObject);
begin
  if MasterEngine.Engine.Running then
    MasterEngine.Engine.Stop;
end;

procedure TfrmScripts.actDecompileExecute(Sender: TObject);
begin
  if Compile then
  begin
    MasterEngine.Engine.GetUncompiledCode(mmConsole.Lines);
    PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  end;
end;

procedure TfrmScripts.actBreakpointExecute(Sender: TObject);
begin
  MasterEngine.ToggleBreakPoint(FCurrentPage.Script.ScriptUnitName, FCurrentPage.Editor.CaretY, False);
end;

procedure TfrmScripts.actAddSuiviExecute(Sender: TObject);
begin
  MasterEngine.DebugPlugin.Watches.AddWatch(FCurrentPage.Editor.WordAtCursor);
end;

procedure TfrmScripts.actRunToCursorExecute(Sender: TObject);
begin
  MasterEngine.Engine.setRunTo(FCurrentPage.Editor.CaretY, FCurrentPage.Script.ScriptUnitName);
  actRun.Execute;
end;

procedure TfrmScripts.vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  MasterEngine.DebugPlugin.Watches[Node.index].Active := Node.CheckState = csCheckedNormal;
  MasterEngine.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.GoToMessage(msg: IMessageInfo);
var
  Editor: TSynEdit;
begin
  if msg = nil then
    Exit;

  Editor := GetScriptEditor(msg.ScriptUnitName);
  if not Assigned(Editor) then
    LoadScript(msg.ScriptUnitName);
  GoToPosition(msg.ScriptUnitName, msg.Line, msg.Char);
  PageControl1.ActivePage := tabMessages;
end;

procedure TfrmScripts.vstMessagesDblClick(Sender: TObject);
begin
  GoToMessage(MasterEngine.DebugPlugin.Messages.Current);
end;

procedure TfrmScripts.vstBreakpointsDblClick(Sender: TObject);
begin
  GoToBreakpoint(MasterEngine.DebugPlugin.Breakpoints.Current);
end;

procedure TfrmScripts.GoToBreakpoint(msg: IBreakpointInfo);
var
  Editor: TSynEdit;
begin
  Editor := GetScriptEditor(msg.ScriptUnitName);
  if not Assigned(Editor) then
    LoadScript(msg.ScriptUnitName);
  GoToPosition(msg.ScriptUnitName, msg.Line, 0);
  PageControl1.ActivePage := tabBreakpoints;
end;

procedure TfrmScripts.GoToPosition(ScriptUnitName: string; Line, Char: Cardinal);
var
  Editor: TSynEdit;
begin
  Editor := GetScriptEditor(ScriptUnitName);
  if not Assigned(Editor) then
  begin
    // pas besoin de convertir ActiveUnitName puisque si Script = GetMainSpecialName, GetScriptEditor aura forcément trouvé l'editeur du projet
    LoadScript(MasterEngine.Engine.ActiveUnitName);
    Editor := GetScriptEditor(MasterEngine.Engine.ActiveUnitName);
  end;
  GoToPosition(Editor, Line, Char);
end;

procedure TfrmScripts.GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
begin
  if not Assigned(Editor) then
    Exit;

  if (Line < Cardinal(Editor.TopLine + 2)) or (Line > Cardinal(Editor.TopLine + Editor.LinesInWindow - 2)) then
    Editor.TopLine := Line - Cardinal(Editor.LinesInWindow div 2);

  PageControl2.ActivePage := tbEdition;
  pcScripts.ActivePage := TTabSheet(Editor.Parent);
  pcScriptsChange(nil);
  Editor.SetFocus;
  Editor.CaretY := Line;
  Editor.CaretX := Char;
  Editor.Invalidate; // Line et GutterLine sont insuffisants pour certains cas
end;

{$ENDREGION}
{$REGION 'Exécution'}

procedure TfrmScripts.actCompileExecute(Sender: TObject);
begin
  if not MasterEngine.Engine.Running then
    Compile;
end;

procedure TfrmScripts.actRunExecute(Sender: TObject);
begin
  if MasterEngine.Engine.Running then
  begin
    MasterEngine.Engine.ActiveLine := 0;
    MasterEngine.Engine.ActiveUnitName := '';
    FCurrentPage.Editor.Refresh;
    MasterEngine.Engine.Resume;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

function TfrmScripts.Execute: Boolean;
begin
  MasterEngine.AlbumToImport.Clear;
  mmConsole.Clear;
  Result := MasterEngine.Engine.Run;
  if (MasterEngine.DebugPlugin.Messages.ItemCount > 0) then
    GoToMessage(MasterEngine.DebugPlugin.Messages.Last);
  if not Result then
  begin
    (*
      try
      MasterEngine.PSScriptDebugger1.Exec.RaiseCurrentException;
      except
      on e: EPSException do
      Application.HandleException(nil);
      else
      raise;
      end;
    *)
  end;
end;

procedure TfrmScripts.PSScriptDebugger1Idle(Sender: TObject);
begin
  frmFond.MergeMenu(Menu);
end;

procedure TfrmScripts.AfterExecute;
begin
  if pcScripts.PageCount > 0 then
    FCurrentPage.Editor.Refresh;
  PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  frmFond.MergeMenu(Menu);
  if MasterEngine.AlbumToUpdate then
    ModalResult := mrOk;
end;

function TfrmScripts.Compile: Boolean;
var
  msg: IMessageInfo;
begin
  Result := MasterEngine.Engine.Compile(MasterEngine.ProjectScript, msg);
  Compiled := Result;
  if Assigned(msg) then
    GoToMessage(msg);
  ShowExecutableLines;
end;

procedure TfrmScripts.actRunWithoutDebugExecute(Sender: TObject);
begin
  MasterEngine.Engine.UseDebugInfo := False;
  try
    if Compile then
      Execute;
  finally
    MasterEngine.Engine.UseDebugInfo := True;
  end;
end;
{$ENDREGION}

procedure TfrmScripts.ClearExecutableLines;
var
  Page: TEditorPage;
begin
  for Page in FOpenedScript do
    Page.ClearExecutableLines;
end;

procedure TfrmScripts.ClearLinesChangedState;
var
  Page: TEditorPage;
begin
  for Page in FOpenedScript do
    Page.ClearLineChangeStates;
end;

procedure TfrmScripts.ShowExecutableLines;
var
  // LineNumbers: TLineNumbers;
  // i: Integer;
  Page: TEditorPage;
begin
  for Page in FOpenedScript do
    Page.ShowExecutableLines;

  // ClearExecutableLines;
  // if Compiled then
  // begin
  // if PageControl1.ActivePageIndex = 0 then
  // LineNumbers := MasterEngine.Engine.GetExecutableLines(MasterEngine.Engine.GetSpecialMainUnitName)
  // else
  // LineNumbers := MasterEngine.Engine.GetExecutableLines(FCurrentPage.Script.ScriptUnitName);
  // for i := 0 to Length(LineNumbers) - 1 do
  // FCurrentPage.FExecutableLines[LineNumbers[i]] := True;
  // end;
  // FCurrentPage.Editor.InvalidateGutter;
end;

procedure TfrmScripts.SynCodeCompletionExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer; var CanExecute: Boolean);
var
  Proposal: TSynCompletionProposal;
begin
  CanExecute := False;

  // use this handler only in case the kind is set to ctCode!
  Assert(Kind = ctCode);
  Assert(Sender is TSynCompletionProposal);

  // check the proposal type
  Proposal := TSynCompletionProposal(Sender);
  Proposal.InsertList.Clear;
  Proposal.ItemList.Clear;

  if Assigned(Proposal.Form) then
  begin
    Proposal.Form.DoubleBuffered := True;
    Proposal.Resizeable := True;
    Proposal.Form.Resizeable := True;
    Proposal.Form.BorderStyle := bsSizeToolWin;
  end;

  CanExecute := MasterEngine.Engine.GetCompletionProposal(Proposal.ItemList, Proposal.InsertList, FCurrentPage.Editor);

  if Proposal.InsertList.Count <> Proposal.ItemList.Count then
    Proposal.InsertList.Assign(Proposal.ItemList);
end;

procedure TfrmScripts.SynCodeCompletionShow(Sender: TObject);
var
  CompletionProposalForm: TSynBaseCompletionProposalForm;
begin
  inherited;

  if (Sender <> nil) and (Sender is TSynBaseCompletionProposalForm) then
  begin
    CompletionProposalForm := TSynBaseCompletionProposalForm(Sender);
    try
      CompletionProposalForm.DoubleBuffered := True;

      if CompletionProposalForm.Height > 300 then
        CompletionProposalForm.Height := 300
    except
      on Exception do;
    end;
  end;
end;

procedure TfrmScripts.SynParametersExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string; var X, Y: Integer; var CanExecute: Boolean);
var
  Proposal: TSynCompletionProposal;
  BestProposal: Integer;
begin
  CanExecute := False;

  // use this handler only in case the kind is set to ctCode!
  Assert(Kind = ctParams);
  Assert(Sender is TSynCompletionProposal);

  // check the proposal type
  Proposal := TSynCompletionProposal(Sender);
  Proposal.InsertList.Clear;
  Proposal.ItemList.Clear;

  CanExecute := MasterEngine.Engine.GetParametersProposal(Proposal.ItemList, Proposal.InsertList, FCurrentPage.Editor, BestProposal);

  if Proposal.InsertList.Count <> Proposal.ItemList.Count then
    Proposal.InsertList.Assign(Proposal.ItemList);

  if CanExecute then
    TSynCompletionProposal(Sender).Form.CurrentIndex := BestProposal;
end;

procedure TfrmScripts.OnBreakPoint;
var
  i: Integer;
begin
  framWatches1.Invalidate;

  i := FMasterEngine.DebugPlugin.Breakpoints.IndexOf(MasterEngine.Engine.ActiveUnitName, MasterEngine.Engine.ActiveLine);
  if i > -1 then
    GoToBreakpoint(FMasterEngine.DebugPlugin.Breakpoints[i])
  else
    GoToPosition(MasterEngine.Engine.ActiveUnitName, MasterEngine.Engine.ActiveLine, 0);
end;

{ TEditorPageSynEditPlugin }

type
  TEditorPageSynEditPlugin = class(TSynEditPlugin)
  protected
    FPage: TEditorPage;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
    procedure PaintTransient(ACanvas: TCanvas; ATransientType: TTransientType); override;
  public
    constructor Create(APage: TEditorPage);
  end;

constructor TEditorPageSynEditPlugin.Create(APage: TEditorPage);
begin
  inherited Create(APage.Editor);
  FPage := APage;
end;

procedure TEditorPageSynEditPlugin.LinesInserted(FirstLine, Count: Integer);
var
  i, iLineCount: Integer;
  bp: IBreakpointInfo;
  mi: IMessageInfo;
begin
  // Track the executable lines
  iLineCount := FPage.Editor.Lines.Count;
  FPage.FExecutableLines.Size := iLineCount;
  for i := iLineCount - 1 downto FirstLine + Count do
    FPage.FExecutableLines[i] := FPage.FExecutableLines[i - Count];
  for i := FirstLine + Count - 1 downto FirstLine do
    FPage.FExecutableLines[i] := False;

  SetLength(FPage.FLineChangedState, iLineCount);
  for i := iLineCount - 1 downto FirstLine + Count do
    FPage.FLineChangedState[i] := FPage.FLineChangedState[i - Count];
  for i := FirstLine + Count - 1 downto FirstLine - 1 do
    FPage.FLineChangedState[i] := csModified;

  // Track the breakpoint lines in the debugger
  with FPage.MasterEngine.DebugPlugin do
  begin
    for bp in Breakpoints do
      if bp.ScriptUnitName = FPage.Script.ScriptUnitName then
        if bp.Line >= Cardinal(FirstLine) then
          bp.Line := bp.Line + Cardinal(Count);

    for mi in Messages do
      if mi.ScriptUnitName = FPage.Script.ScriptUnitName then
        if mi.Line >= Cardinal(FirstLine) then
          mi.Line := mi.Line + Cardinal(Count);
  end;

  // Redraw the gutter for updated icons.
  FPage.Editor.InvalidateGutter;
end;

procedure TEditorPageSynEditPlugin.PaintTransient(ACanvas: TCanvas; ATransientType: TTransientType);
var
  Pt: TPoint;
  Rct: TRect;
  MouseBufferCoord: TBufferCoord;
  Attri: TSynHighlighterAttributes;
  TokenType, Start: Integer;
  TokenName: String;
  OldFont: TFont;
begin
  // only handle after transient
  if ATransientType <> ttAfter then
    Exit;

  // only continue if [CTRL] is pressed
  if not(ssCtrl in KeyboardStateToShiftState) then
    Exit;

  Pt := Editor.ScreenToClient(Mouse.CursorPos);
  MouseBufferCoord := Editor.DisplayToBufferPos(Editor.PixelsToRowColumn(Pt.X, Pt.Y));
  Editor.GetHighlighterAttriAtRowColEx(MouseBufferCoord, TokenName, TokenType, Start, Attri);

  if FPage.MasterEngine.Engine.isTokenIdentifier(TokenType) then
  begin
    with Editor do
      Pt := RowColumnToPixels(BufferToDisplayPos(WordStartEx(MouseBufferCoord)));

    Rct := Rect(Pt.X, Pt.Y, Pt.X + Editor.CharWidth * Length(TokenName), Pt.Y + Editor.LineHeight);

    OldFont := TFont.Create;
    try
      OldFont.Assign(ACanvas.Font);
      ACanvas.Font.Color := clBlue;
      ACanvas.Font.Style := [fsUnderline];
      ACanvas.TextRect(Rct, Pt.X, Pt.Y, TokenName);
      ACanvas.Font := OldFont;
    finally
      OldFont.Free;
    end;
  end;
end;

procedure TEditorPageSynEditPlugin.LinesDeleted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  // Track the executable lines
  for i := FirstLine - 1 to FPage.FExecutableLines.Size - Count - 1 do
    FPage.FExecutableLines[i] := FPage.FExecutableLines[i + Count];
  FPage.FExecutableLines.Size := FPage.FExecutableLines.Size - Count;

  // Track the executable lines
  for i := FirstLine - 1 to Length(FPage.FLineChangedState) - Count - 1 do
    FPage.FLineChangedState[i] := FPage.FLineChangedState[i + Count];
  SetLength(FPage.FLineChangedState, Length(FPage.FLineChangedState) - Count);

  // Track the breakpoint lines in the debugger
  with FPage.MasterEngine.DebugPlugin do
  begin
    for i := Pred(Breakpoints.ItemCount) downto 0 do
      if Breakpoints[i].ScriptUnitName = FPage.Script.ScriptUnitName then
        if Breakpoints[i].Line in [FirstLine .. FirstLine + Count] then
          Breakpoints.Delete(i)
        else if Breakpoints[i].Line >= Cardinal(FirstLine) then
          Breakpoints[i].Line := Breakpoints[i].Line - Cardinal(Count);
    for i := Pred(Messages.ItemCount) downto 0 do
      if Messages[i].ScriptUnitName = FPage.Script.ScriptUnitName then
        if Messages[i].Line in [FirstLine .. FirstLine + Count] then
          Messages.Delete(i)
        else if Messages[i].Line >= Cardinal(FirstLine) then
          Messages[i].Line := Messages[i].Line - Cardinal(Count);
  end;

  // Redraw the gutter for updated icons.
  FPage.Editor.InvalidateGutter;
end;

{ TEditorPage }

procedure TEditorPage.ClearExecutableLines;
var
  i: Integer;
begin
  for i := 0 to FExecutableLines.Size do
    FExecutableLines[i] := False;

  Editor.InvalidateGutter;
end;

procedure TEditorPage.ClearLineChangeStates;
var
  i: Integer;
begin
  for i := 0 to Length(FLineChangedState) do
    FLineChangedState[i] := csOriginal;

  Editor.InvalidateGutter;
end;

constructor TEditorPage.Create(AOwner: TPageControl; AfrmScripts: TfrmScripts; AScript: TScript);
begin
  inherited Create(AOwner);

  FExecutableLines := TBits.Create;

  FfrmScripts := AfrmScripts;
  FMasterEngine := FfrmScripts.MasterEngine;
  FScript := AScript;

  TabSheet := TTabSheet.Create(AOwner);
  TabSheet.PageControl := AOwner;
  TabSheet.Caption := string(Script.ScriptUnitName);

  Editor := MasterEngine.Engine.GetNewEditor(TabSheet);
  Editor.Parent := TabSheet;

  Editor.SearchEngine := FfrmScripts.SynEditSearch;

  Editor.OnChange := DoOnEditorChange;

  Editor.OnGutterClick := SynEditorGutterClick;
  Editor.OnGutterPaint := SynEditGutterPaint;
  Editor.OnReplaceText := SynEditorReplaceText;
  Editor.OnSpecialLineColors := SynEditorSpecialLineColors;
  Editor.OnProcessUserCommand := SynEditorCommandProcessed;

  // *******************************
  // FEditor.OnMouseMove := SynEditorMouseMove;
  //
  // FEditor.OnCommandProcessed := ;
  //
  // FEditor.OnClick := SynEditorClick;
  // FEditor.OnKeyDown := SynEditorKeyDown;
  // *******************************

  Editor.AddKey(ecGotoXY, 47, [ssAlt]);
  Editor.AddKey(ecOpenFileUnderCursor, VK_RETURN, [ssCtrl]);
  // Editor.AddKey(ecToggleDeclImpl, VK_UP, [ssCtrl, ssShift]);
  // Editor.AddKey(ecToggleDeclImpl, VK_DOWN, [ssCtrl, ssShift]);

  FfrmScripts.SynMacroRecorder.AddEditor(FEditor);
  FfrmScripts.SynParameters.AddEditor(FEditor);
  FfrmScripts.SynCodeCompletion.AddEditor(FEditor);

  TEditorPageSynEditPlugin.Create(Self);
  Editor.Lines.Assign(Script.Code);
  InitExecutableLines;
  InitLineChangeStates;

  SB := TStatusBar.Create(TabSheet);
  SB.Parent := TabSheet;
  SB.Panels.Add.Width := 50;
  SB.Panels.Add.Width := 50;
  SB.Panels.Add.Width := 50;

  TabSheet.Visible := True;
end;

destructor TEditorPage.Destroy;
begin
  FfrmScripts.SynParameters.RemoveEditor(FEditor);
  FfrmScripts.SynCodeCompletion.RemoveEditor(FEditor);
  FfrmScripts.SynMacroRecorder.RemoveEditor(FEditor);
  FExecutableLines.Free;

  FEditor.Free;
  SB.Free;

  TabSheet.Free;

  FMasterEngine := nil;

  inherited;
end;

procedure TEditorPage.DoOnEditorChange(ASender: TObject);
begin
  FLineChangedState[FEditor.CaretY - 1] := csModified;
  Modifie := True;
  FfrmScripts.seScript1Change(ASender);
end;

function TEditorPage.GetLineChangeState(aLine: Integer): TLineChangedState;
begin
  if aLine < Length(FLineChangedState) then
    Result := FLineChangedState[aLine]
  else
    Result := csOriginal;
end;

procedure TEditorPage.GotoLineNumber;
begin
  with TfrmScriptGotoLine.Create(nil) do
    try
      if ShowModal = mrOk then
        FEditor.GotoLineAndCenter(LineNumber);
    finally
      Free;
    end;
end;

procedure TEditorPage.InitExecutableLines;
begin
  FExecutableLines.Size := 0;
  FExecutableLines.Size := Editor.Lines.Count;
end;

procedure TEditorPage.InitLineChangeStates;
begin
  SetLength(FLineChangedState, 0);
  SetLength(FLineChangedState, Editor.Lines.Count);
end;

function TEditorPage.IsExecutableLine(aLine: Integer): Boolean;
begin
  Result := (aLine < FExecutableLines.Size) and FExecutableLines[aLine];
end;

procedure TEditorPage.OpenFileUnderCursor;
begin
  FfrmScripts.LoadScript(Editor.WordAtCursor);
end;

procedure TEditorPage.SetModifie(const Value: Boolean);
begin
  FModifie := Value;
  FScript.Modifie := Value;
end;

procedure TEditorPage.ShowExecutableLines;
var
  LineNumbers: TLineNumbers;
  i: Integer;
begin
  ClearExecutableLines;
  LineNumbers := MasterEngine.Engine.GetExecutableLines(MasterEngine.GetInternalUnitName(FScript));
  for i := 0 to Length(LineNumbers) - 1 do
    FExecutableLines[LineNumbers[i]] := True;
  Editor.InvalidateGutter;
end;

procedure TEditorPage.SynEditGutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
  ScriptUnitName: string;
  Proc, Pos: Cardinal;
begin
  ScriptUnitName := MasterEngine.GetInternalUnitName(FScript);

  IconIndex := -1;
  i := MasterEngine.DebugPlugin.Breakpoints.IndexOf(ScriptUnitName, aLine);
  if i <> -1 then
  begin
    if not MasterEngine.Engine.Running then
      if MasterEngine.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
    else
    begin
      if (Cardinal(aLine) = MasterEngine.Engine.ActiveLine) and SameText(MasterEngine.Engine.ActiveUnitName, ScriptUnitName) then
        IconIndex := imgGutterEXECLINEBP
      else if MasterEngine.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAKVALID
      else
        IconIndex := imgGutterBREAKDISABLED;
    end;
  end
  else
  begin
    if (MasterEngine.Engine.DebugMode = UScriptEngineIntf.dmPaused) and (Cardinal(aLine) = MasterEngine.Engine.ActiveLine) and
      SameText(MasterEngine.Engine.ActiveUnitName, ScriptUnitName) then
      IconIndex := imgGutterEXECLINE;
  end;

  if MasterEngine.Compiled then
    if IsExecutableLine(aLine) or MasterEngine.Engine.TranslatePosition(Proc, Pos, aLine, ScriptUnitName) then
      case IconIndex of
        - 1:
          IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKDISABLED: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAK: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKVALID: IconIndex := imgGutterCOMPLINE;
        imgGutterEXECLINE:
          IconIndex := imgGutterEXECLINECL;
      end
    else
      case IconIndex of
        imgGutterBREAK:
          IconIndex := imgGutterBREAKINVAL;
        imgGutterBREAKVALID:
          IconIndex := imgGutterBREAKINVAL;
      end;

  if IconIndex <> -1 then
    FfrmScripts.lstDebugImages.Draw(TSynEdit(Sender).Canvas, X, Y, IconIndex);
end;

procedure TEditorPage.SynEditorCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command of
    ecGotoXY:
      GotoLineNumber;
    ecOpenFileUnderCursor:
      OpenFileUnderCursor;
    ecToggleDeclImpl:
      // ToggleDeclImpl;
      ;
  end;
end;

procedure TEditorPage.SynEditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  iLine: Integer;
begin
  iLine := Editor.RowToLine(Line);

  if (X <= Editor.Gutter.LeftOffset) and (iLine < FExecutableLines.Size) then
  begin
    MasterEngine.ToggleBreakPoint(MasterEngine.GetInternalUnitName(FScript), iLine, False);
    Editor.Repaint;
  end;
end;

procedure TEditorPage.SynEditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
begin
  case MessageDlg('Remplacer cette occurence ?', mtConfirmation, [mbYes, mbNo, mbCancel, mbYesToAll], 0) of
    mrYes:
      Action := raReplace;
    mrNo:
      Action := raSkip;
    mrCancel:
      Action := raCancel;
    mrYesToAll:
      Action := raReplaceAll;
  end;
end;

procedure TEditorPage.SynEditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  i: Integer;
  ScriptUnitName: string;
  Proc, Pos: Cardinal;
begin
  ScriptUnitName := MasterEngine.GetInternalUnitName(FScript);
  i := MasterEngine.DebugPlugin.Breakpoints.IndexOf(ScriptUnitName, Line);

  if (Cardinal(Line) = MasterEngine.Engine.ActiveLine) and SameText(MasterEngine.Engine.ActiveUnitName, ScriptUnitName) then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else if i <> -1 then
  begin
    Special := True;
    if MasterEngine.DebugPlugin.Breakpoints[i].Active then
    begin
      if MasterEngine.Compiled and not(IsExecutableLine(Line) or MasterEngine.Engine.TranslatePosition(Proc, Pos, Line, ScriptUnitName)) then
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
  else if (MasterEngine.Engine.ErrorLine > 0) and (Cardinal(Line) = MasterEngine.Engine.ErrorLine) and
    SameText(MasterEngine.Engine.ErrorUnitName, ScriptUnitName) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := False;
end;

procedure TEditorPage.UpdateStatusBarPanels;
const
  MacroRecorderStates: array [TSynMacroState] of string = ('Arrêté', 'Enregistrement...', 'Exécution...', 'En pause');
var
  ptCaret: TPoint;
begin
  ptCaret := TPoint(Editor.CaretXY);
  if (ptCaret.X > 0) and (ptCaret.Y > 0) then
    SB.Panels[0].Text := Format(' %6d:%3d ', [ptCaret.Y, ptCaret.X])
  else
    SB.Panels[0].Text := '';

  if Editor.Modified then
    SB.Panels[1].Text := 'Modifié'
  else
    SB.Panels[1].Text := '';

  if Editor.ReadOnly then
    SB.Panels[2].Text := 'Lecture seule'
  else if Editor.InsertMode then
  begin
    if frmScripts.SynMacroRecorder.State <> msStopped then
      SB.Panels[2].Text := UpperCase(MacroRecorderStates[frmScripts.SynMacroRecorder.State])
    else
      SB.Panels[2].Text := 'Insertion'
  end
  else
    SB.Panels[2].Text := 'Remplacer';
end;

{ TEditorPagesList }

function TEditorPagesList.EditorByUnitName(const Script: string): TScriptEditor;
var
  Page: TEditorPage;
begin
  for Page in Self do
    if Page.Script.ScriptUnitName = Script then
      Exit(Page.Editor);
  Result := nil;
end;

end.
