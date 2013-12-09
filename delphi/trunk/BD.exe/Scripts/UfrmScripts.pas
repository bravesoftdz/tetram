unit UfrmScripts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, SynEditHighlighter, SynEdit, ImgList,
  StrUtils, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, Menus, SynEditTypes, ComCtrls, UScriptUtils, VirtualTrees, StdCtrls,
  ExtCtrls, LoadComplet, SynEditKeyCmds, UBdtForms, Generics.Collections, ToolWin, UfrmFond, UScriptEditor,
  PngImageList, UScriptEngineIntf, UScriptList, UframBoutons, EditLabeled,
  System.Actions, SynCompletionProposal, SynEditPlugins, SynMacroRecorder,
  dwsDebugger, UframWatches, UframBreakpoints, UframMessages, UframScriptInfos, UScriptEditorPage;

type
  TfrmScripts = class(TbdtForm, IFrmScriptsEditor)
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
    procedure GoToPosition(Script: TScript; Line, Char: Cardinal); overload; inline;
    procedure GoToPosition(ScriptUnitName: string; Line, Char: Cardinal); overload; inline;
    procedure GoToMessage(msg: IMessageInfo);
    procedure GoToBreakpoint(msg: IBreakpointInfo);
{$ENDREGION}
    function GetPageFromUnitName(const ScriptUnitName: string): TEditorPage;
    function GetPageForScript(const Script: TScript): TEditorPage;

    procedure SetCompiled(const Value: Boolean);
    function GetProjet: string;
    procedure SetProjet(const Value: string);
    function LoadScript(Script: TScript): TEditorPage; overload;
    function LoadScript(const ScriptUnitName: string): TEditorPage; overload;
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

    function GetMasterEngine: IMasterEngine;
    function GetSynEditSearch: TSynEditSearch;
    procedure AddEditor(Page: TEditorPage);
    procedure RemoveEditor(Page: TEditorPage);
    function GetseScript1Change: TNotifyEvent;
    function GetlstDebugImages: TPngImageList;
    function GetSynMacroRecorder: TSynMacroRecorder;
  public
    property MasterEngine: IMasterEngine read FMasterEngine write SetMasterEngine;
    property Compiled: Boolean read FCompiled write SetCompiled;
    property Projet: string read GetProjet write SetProjet;
    property ProjetOuvert: Boolean read FProjetOuvert write SetProjetOuvert;
  end;

implementation

{$R *.dfm}

uses
  UfrmScriptSearch, UScriptsFonctions, CommonConst, UIB, Procedures, BdtkRegEx, Commun, Divers,
  UScriptsHTMLFunctions, JclSimpleXML, UdmPrinc, UfrmScriptOption, UfrmScriptEditOption, UfrmScriptsUpdate,
  UdmPascalScript, SynHighlighterDWS, UMasterEngine;

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
    Editor := FOpenedScript.EditorByUnitName(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ErrorUnitName));
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
  FCurrentPage := nil;
  FOpenedScript.Delete(pcScripts.ActivePageIndex);
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

function TfrmScripts.GetlstDebugImages: TPngImageList;
begin
  REsult := lstDebugImages;
end;

function TfrmScripts.GetMasterEngine: IMasterEngine;
begin
  Result := FMasterEngine;
end;

function TfrmScripts.GetPageForScript(const Script: TScript): TEditorPage;
begin
  REsult := FOpenedScript.PageByScript(Script);
end;

function TfrmScripts.GetPageFromUnitName(const ScriptUnitName: string): TEditorPage;
begin
  REsult := FOpenedScript.PageByUnitName(ScriptUnitName);
end;

function TfrmScripts.GetProjet: string;
begin
  REsult := MasterEngine.ProjectScript.ScriptUnitName;
end;

function TfrmScripts.GetseScript1Change: TNotifyEvent;
begin
  REsult := seScript1Change;
end;

function TfrmScripts.GetSynEditSearch: TSynEditSearch;
begin
  REsult := SynEditSearch;
end;

function TfrmScripts.GetSynMacroRecorder: TSynMacroRecorder;
begin
  Result := SynMacroRecorder;
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
  MasterEngine.DebugPlugin.OnGetScriptEditor := FOpenedScript.EditorByScript;
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

procedure TfrmScripts.RemoveEditor(Page: TEditorPage);
begin
  SynParameters.RemoveEditor(Page.Editor);
  SynCodeCompletion.RemoveEditor(Page.Editor);
  SynMacroRecorder.RemoveEditor(Page.Editor);
end;

function TfrmScripts.LoadScript(const ScriptUnitName: string): TEditorPage;
var
  Script: TScript;
begin
  if (ScriptUnitName = MasterEngine.Engine.GetSpecialMainUnitName) then
    Script := MasterEngine.ProjectScript
  else
    Script := MasterEngine.ScriptList.InfoScriptByUnitName(ScriptUnitName);

  // doit être fait avant la création de page pour s'assurer de l'existence du fichier
  if not Assigned(Script) then
    raise Exception.Create('Impossible de trouver l''unité ' + string(ScriptUnitName) + '.');

  REsult := LoadScript(Script);
end;

function TfrmScripts.LoadScript(Script: TScript): TEditorPage;
var
  LockWindow: ILockWindow;
begin
  REsult := GetPageForScript(Script);
  if not Assigned(REsult) then
  begin
    // if not Info.Loaded then
    Script.Load; // on force le rechargement pour être sûr de bien avoir la dernière version
    LockWindow := TLockWindow.Create(pcScripts);
    REsult := TEditorPage.Create(pcScripts, Self, Script);
    FOpenedScript.Add(REsult);
  end;
  GoToPosition(REsult.Editor, 1, 1);
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
  GoToPosition(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ActiveUnitName), MasterEngine.Engine.ActiveLine, 1);
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
  MasterEngine.ToggleBreakPoint(FCurrentPage.Script, FCurrentPage.Editor.CaretY, False);
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
  EditorPage: TEditorPage;
begin
  if msg = nil then
    Exit;

  EditorPage := GetPageForScript(msg.Script);
  if not Assigned(EditorPage) then
    LoadScript(msg.Script);
  GoToPosition(msg.Script, msg.Line, msg.Char);
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
  EditorPage: TEditorPage;
begin
  EditorPage := GetPageForScript(msg.Script);
  if not Assigned(EditorPage) then
    LoadScript(msg.Script);
  GoToPosition(msg.Script, msg.Line, 0);
  PageControl1.ActivePage := tabBreakpoints;
end;

procedure TfrmScripts.GoToPosition(ScriptUnitName: string; Line, Char: Cardinal);
var
  EditorPage: TEditorPage;
begin
  EditorPage := GetPageFromUnitName(ScriptUnitName);
  if not Assigned(EditorPage) then
    EditorPage := LoadScript(ScriptUnitName);
  GoToPosition(EditorPage.Editor, Line, Char);
end;

procedure TfrmScripts.GoToPosition(Script: TScript; Line, Char: Cardinal);
var
  EditorPage: TEditorPage;
begin
  EditorPage := GetPageForScript(Script);
  if not Assigned(EditorPage) then
    EditorPage := LoadScript(Script);
  GoToPosition(EditorPage.Editor, Line, Char);
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
  REsult := MasterEngine.Engine.Run;
  if (MasterEngine.DebugPlugin.Messages.ItemCount > 0) then
    GoToMessage(MasterEngine.DebugPlugin.Messages.Last);
  if not REsult then
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

procedure TfrmScripts.AddEditor(Page: TEditorPage);
begin
  SynMacroRecorder.AddEditor(Page.Editor);
  SynParameters.AddEditor(Page.Editor);
  SynCodeCompletion.AddEditor(Page.Editor);
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
  REsult := MasterEngine.Engine.Compile(MasterEngine.ProjectScript, msg);
  Compiled := REsult;
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
  Script: TScript;
begin
  framWatches1.Invalidate;

  Script := FMasterEngine.ScriptList.FindScriptByUnitName(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ActiveUnitName));
  if Assigned(Script) then
    i := FMasterEngine.DebugPlugin.Breakpoints.IndexOf(Script, MasterEngine.Engine.ActiveLine)
  else
    i := -1;

  if i > -1 then
    GoToBreakpoint(FMasterEngine.DebugPlugin.Breakpoints[i])
  else
    GoToPosition(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ActiveUnitName), MasterEngine.Engine.ActiveLine, 0);
end;

end.
