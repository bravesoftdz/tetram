unit Main;

interface

{.$D-}
{$WARN SYMBOL_DEPRECATED OFF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ImgList, Menus,
  ComCtrls, ExtCtrls, Buttons, ActnList, Printers, iniFiles, jpeg, Contnrs, ToolWin, ProceduresBDtk, UBdtForms;

type
  TActionUpdate = function: Boolean of object;

  TStack = class(Contnrs.TStack) // surcharge pour pouvoir acceder � List
    //  published
    //    property List;
  end;

  TFond = class(TbdtForm)
    ImageList1: TImageList;
    boutons_32x32_hot: TImageList;
    ActionsOutils: TActionList;
    actChangementOptions: TAction;
    actAideContextuelle: TAction;
    actAfficheStatsGenerales: TAction;
    actAfficheStock: TAction;
    PrinterSetupDialog1: TPrinterSetupDialog;
    actAfficheRecherche: TAction;
    actImpression: TAction;
    actApercuImpression: TAction;
    actActualiseRepertoire: TAction;
    actRelireOptions: TAction;
    actQuitter: TAction;
    actAfficheStatsEmprunteurs: TAction;
    actAfficheStatsAlbums: TAction;
    actPersonnaliseBarre: TAction;
    boutons_16x16_hot: TImageList;
    ShareImageList: TImageList;
    ActionList1: TActionList;
    actAideSommaire: TAction;
    actAideAbout: TAction;
    actModeGestion: TAction;
    actModeConsultation: TAction;
    actModeEntretien: TAction;
    actStatsInfosBDtheque: TAction;
    actStatsListeCompletesAlbums: TAction;
    actStatsAlbumsEmpruntes: TAction;
    ActionsStatistiques: TActionList;
    StatsInfosBDApp: TAction;
    StatsInfosBDPrn: TAction;
    StatsListeCompletesAlbumsApp: TAction;
    StatsListeCompletesAlbumsPrn: TAction;
    StatsAlbumsEmpruntesApp: TAction;
    StatsAlbumsEmpruntesPrn: TAction;
    CheminBase: TAction;
    actChangeMode: TAction;
    HistoriqueBack: TAction;
    HistoriqueNext: TAction;
    Splitter1: TSplitter;
    actAfficheSeriesIncompletes: TAction;
    actAffichePrevisionsSorties: TAction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    MainMenu1: TMainMenu;
    BDthque1: TMenuItem;
    Outils1: TMenuItem;
    Aide1: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    Mode1: TMenuItem;
    N1: TMenuItem;
    Etats1: TMenuItem;
    N2: TMenuItem;
    Actualiserlerpertoire1: TMenuItem;
    Relirelesoptions1: TMenuItem;
    Quitter1: TMenuItem;
    N4: TMenuItem;
    Consultation1: TMenuItem;
    Gestion1: TMenuItem;
    Entretien1: TMenuItem;
    Albums1: TMenuItem;
    N5: TMenuItem;
    Basededonnes1: TMenuItem;
    Listecompltedesalbums1: TMenuItem;
    Albumsempruntes1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    Aperuavantimpression2: TMenuItem;
    Imprimer2: TMenuItem;
    InformationsBDthque1: TMenuItem;
    Aperuavantimpression3: TMenuItem;
    Imprimer3: TMenuItem;
    Recherche1: TMenuItem;
    Albumsemprunts1: TMenuItem;
    AfficheSeriesIncompletes1: TMenuItem;
    AffichePrevisionsSorties1: TMenuItem;
    N6: TMenuItem;
    Statistiques1: TMenuItem;
    Gnrales1: TMenuItem;
    Emprunteurs1: TMenuItem;
    Albums2: TMenuItem;
    N7: TMenuItem;
    Options1: TMenuItem;
    Personnaliser1: TMenuItem;
    Sommaire1: TMenuItem;
    Aidecontextuelle1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    Cheminbase1: TMenuItem;
    Apropos1: TMenuItem;
    boutons_32x32_norm: TImageList;
    boutons_16x16_norm: TImageList;
    actNouvelAchat: TAction;
    N11: TMenuItem;
    Achat1: TMenuItem;
    actMiseAJour: TAction;
    N12: TMenuItem;
    Vrifierlaversion1: TMenuItem;
    PopupMenu1: TPopupMenu;
    mnuBack: TMenuItem;
    mnuNext: TMenuItem;
    Aperuavantimpression4: TMenuItem;
    Impression1: TMenuItem;
    N8: TMenuItem;
    Scripts1: TMenuItem;
    actScripts: TAction;
    P1: TMenuItem;
    actPublier: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actChangementOptionsExecute(Sender: TObject);
    procedure actAideContextuelleExecute(Sender: TObject);
    procedure actAfficheStatsGeneralesExecute(Sender: TObject);
    procedure actAfficheStockExecute(Sender: TObject);
    procedure actAfficheRechercheExecute(Sender: TObject);
    procedure actImpressionExecute(Sender: TObject);
    procedure actApercuImpressionExecute(Sender: TObject);
    procedure actChangeModeExecute(Sender: TObject);
    procedure actActualiseRepertoireExecute(Sender: TObject);
    procedure actRelireOptionsExecute(Sender: TObject);
    procedure actQuitterExecute(Sender: TObject);
    procedure actAfficheStatsEmprunteursExecute(Sender: TObject);
    procedure actAfficheStatsAlbumsExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actPersonnaliseBarreExecute(Sender: TObject);
    procedure LoadToolBarres;
    procedure ActionsOutilsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actAideSommaireExecute(Sender: TObject);
    procedure actAideAboutExecute(Sender: TObject);
    procedure actModeGestionExecute(Sender: TObject);
    procedure actStatsInfosBDthequeExecute(Sender: TObject);
    procedure StatsEmpruntsExecute(Sender: TObject);
    procedure actStatsListeCompletesAlbumsExecute(Sender: TObject);
    procedure actStatsAlbumsEmpruntesExecute(Sender: TObject);
    procedure StatsInfosBDAppExecute(Sender: TObject);
    procedure StatsListeCompletesAlbumsAppExecute(Sender: TObject);
    procedure StatsAlbumsEmpruntesAppExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actModeConsultationExecute(Sender: TObject);
    procedure HistoriqueBackExecute(Sender: TObject);
    procedure HistoriqueNextExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionsStatistiquesUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actModeEntretienExecute(Sender: TObject);
    procedure actAfficheSeriesIncompletesExecute(Sender: TObject);
    procedure actAffichePrevisionsSortiesExecute(Sender: TObject);
    procedure MeasureMenuItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
    procedure actNouvelAchatExecute(Sender: TObject);
    procedure actMiseAJourExecute(Sender: TObject);
    procedure actScriptsExecute(Sender: TObject);
    procedure actPublierExecute(Sender: TObject);
  private
    { D�clarations priv�es }
    FToolOriginal: TStringList;
    FModalWindows: TStack;
    procedure ChargeToolBarres(sl: TStringList);
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure MergeMenu(MergedMenu: TMainMenu);
    procedure HistoriqueChanged(Sender: TObject);
    procedure HistoriqueChosen(Sender: TObject);
  public
    { D�clarations publiques }
    FCurrentForm: TForm;
    FToolCurrent: TStringList;
    function IsShowing(Classe: TFormClass): Boolean;
    procedure SetChildForm(Form: TForm; Alignement: TAlign = alClient);
    function SetModalChildForm(Form: TForm; Alignement: TAlign = alClient): Integer;
    procedure RechargeToolBar;
  end;

var
  Fond: TFond;

implementation

{$R *.DFM}

uses
  Form_Repertoire, CommonConst, Form_options, Form_StatsGeneral,
  Form_StatsEmprunteurs, Form_StatsAlbums, LoadComplet, Impression, Form_Gestion, Form_Customize,
  Form_AboutBox, DM_Princ, Types, Procedures, UHistorique, Form_Entretien, ShellAPI, Math,
  Form_Scripts, Form_Publier;

procedure TFond.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE: actQuitter.Execute;
    else
      inherited;
  end;
end;

procedure TFond.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  Historique.OnChange := nil;
  FreeAndNil(FModalWindows);
  FreeAndNil(FToolOriginal);
  FreeAndNil(FToolCurrent);
  for i := Fond.MDIChildCount - 1 downto 0 do
    Fond.MDIChildren[i].Free;
end;

procedure TFond.FormCreate(Sender: TObject);
var
  i: Integer;
  tlb: TToolButton;
begin
  FModalWindows := TStack.Create;
  FToolOriginal := TStringList.Create;
  for i := 0 to ToolBar1.ButtonCount - 1 do
  begin
    tlb := ToolBar1.Buttons[i];
    if Assigned(tlb) then
    begin
      if Assigned(tlb.Action) then
      begin
        if TActionList(tlb.Action.Owner) <> ActionList1 then
          FToolOriginal.Add(Format('b%d=%s', [i, tlb.Action.Name]))
      end
      else if (tlb.Caption = '-') then
        FToolOriginal.Add(Format('b%d=%s', [i, 'X']));
    end;
  end;
  FToolCurrent := TStringList.Create;
  FToolCurrent.Assign(FToolOriginal);
  LoadToolBarres;
  Caption := Application.Title;
  Historique.OnChange := HistoriqueChanged;
end;

procedure TFond.actChangementOptionsExecute(Sender: TObject);
begin
  with TFrmOptions.Create(Self) do
  try
    if ShowModal <> mrOk then Exit;
  finally
    Free;
  end;
  if Assigned(FCurrentForm) and Assigned(FCurrentForm.Menu) then
    if Utilisateur.Options.GrandesIconesMenus then
      FCurrentForm.Menu.Images := boutons_32x32_hot
    else
      FCurrentForm.Menu.Images := boutons_16x16_hot;
  if Utilisateur.Options.GrandesIconesMenus then
    Menu.Images := boutons_32x32_hot
  else
    Menu.Images := boutons_16x16_hot;
  Historique.AddWaiting(fcRecreateToolBar);
end;

procedure TFond.RechargeToolBar;
begin
  ChargeToolBarres(FToolCurrent);
end;

procedure TFond.actAideContextuelleExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXTPOPUP, 0);
end;

procedure TFond.actAfficheStatsGeneralesExecute(Sender: TObject);
var
  R: TStats;
begin
  R := TStats.Create(False);
  with TStatsGeneralesCreate(Self, R) do
  try
    ShowModal;
  finally
    Free;
    R.Free;
  end;
end;

procedure TFond.actAfficheStockExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcStock);
end;

procedure TFond.actAfficheRechercheExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcRecherche);
end;

procedure TFond.actImpressionExecute(Sender: TObject);
var
  iImpression: IImpressionApercu;
begin
  if Assigned(FCurrentForm) and FCurrentForm.GetInterface(IImpressionApercu, iImpression) then
    iImpression.ImpressionExecute(Sender);
end;

procedure TFond.actApercuImpressionExecute(Sender: TObject);
var
  iImpression: IImpressionApercu;
begin
  if Assigned(FCurrentForm) and FCurrentForm.GetInterface(IImpressionApercu, iImpression) then
    iImpression.ApercuExecute(Sender);
end;

procedure TFond.actChangeModeExecute(Sender: TObject);
begin
  if not actChangeMode.Checked then
    actModeGestion.Execute
  else
    actModeConsultation.Execute;
end;

procedure TFond.actActualiseRepertoireExecute(Sender: TObject);
begin
  FrmRepertoire.vstAlbums.InitializeRep;
  FrmRepertoire.vstEmprunteurs.InitializeRep;
  FrmRepertoire.vstAuteurs.InitializeRep;
end;

procedure TFond.actRelireOptionsExecute(Sender: TObject);
begin
  LitOptions;
end;

procedure TFond.actQuitterExecute(Sender: TObject);
var
  i: integer;
begin
  i := 0;
  while i < Application.ComponentCount do
    if (Application.Components[i] is TDataModule) and (Application.Components[i] <> DMPrinc) then
      Application.Components[i].Free
    else
      Inc(i);
  Close;
end;

procedure TFond.actAfficheStatsEmprunteursExecute(Sender: TObject);
var
  R: TStats;
begin
  R := TStats.Create(False);
  with TStatsEmprunteursCreate(Self, R) do
  try
    ShowModal;
  finally
    Free;
    R.Free;
  end;
end;

procedure TFond.actAfficheStatsAlbumsExecute(Sender: TObject);
var
  R: TStats;
begin
  R := TStats.Create(False);
  with TStatsAlbumsCreate(Self, R) do
  try
    ShowModal;
  finally
    Free;
    R.Free;
  end;
end;

procedure TFond.ChargeToolBarres(sl: TStringList);

  function GetAction(Name: string): TAction;
  var
    i: Integer;
    act: TCustomAction;
  begin
    if Copy(Name, 1, 3) <> 'act' then Name := 'act' + Name;
    Result := nil;
    for i := 0 to ActionsOutils.ActionCount - 1 do
    begin
      act := TCustomAction(ActionsOutils.Actions[i]);
      if (act <> nil) and SameText(Name, act.Name) then
      begin
        Result := act as TAction;
        Exit;
      end;
    end;
  end;

  function NewAction(aAction: TAction): TToolButton;
  begin
    Result := TToolButton.Create(ToolBar1);
    with Result do
    begin
      Parent := ToolBar1;
      if aAction = nil then
      begin
        Style := tbsSeparator;
        Width := 8;
      end
      else
      begin
        if aAction = HistoriqueBack then
        begin
          Style := tbsDropDown;
          MenuItem := mnuBack;
        end;
        if aAction = HistoriqueNext then
        begin
          Style := tbsDropDown;
          MenuItem := mnuNext;
        end;
        Cursor := crHandPoint;
        Action := aAction;
      end;
    end;
  end;

type
  TTypeButton = (tbSep, tbBut);

var
  i: Integer;
  s1, s2: string;
  LastButton: TTypeButton;
  aAction: TAction;
var
  LockWindow: ILockWindow;
begin
  LockWindow := TLockWindow.Create(Self);

  for i := 0 to ToolBar1.ButtonCount - 1 do
    ToolBar1.Buttons[0].Free;

  if Utilisateur.Options.GrandesIconesBarre then
  begin
    ToolBar1.Images := boutons_32x32_norm;
    ToolBar1.HotImages := boutons_32x32_hot;
  end
  else
  begin
    ToolBar1.Images := boutons_16x16_norm;
    ToolBar1.HotImages := boutons_16x16_hot;
  end;
  ToolBar1.ButtonHeight := 0; // force la barre � se redimensionner correctement
  ToolBar1.ButtonWidth := 0;

  LastButton := tbSep;
  for i := sl.Count - 1 downto 0 do
  begin
    s1 := sl.Names[i];
    s2 := sl.Values[s1];
    if s2 = 'X' then
    begin
      if LastButton <> tbSep then NewAction(nil);
      LastButton := tbSep;
    end
    else
    begin
      aAction := GetAction(s2);
      if aAction <> nil then
      begin
        NewAction(GetAction(s2));
        LastButton := tbBut;
      end;
    end;
  end;

  if LastButton <> tbSep then NewAction(nil);
  NewAction(HistoriqueNext);
  NewAction(HistoriqueBack);
end;

procedure TFond.LoadToolBarres;
var
  sl: TStringList;
begin
  if FileExists(FichierIni) then
    with TIniFile.Create(FichierIni) do
    begin
      sl := TStringList.Create;
      try
        ReadSections(sl);
        if sl.IndexOf('Barre') = -1 then Exit;
        sl.Clear;
        ReadSectionValues('Barre', sl);
        ChargeToolBarres(sl);
        FToolCurrent.Assign(sl);
      finally
        sl.Free;
        Free;
      end;
    end;
end;

procedure TFond.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  with TIniFile.Create(FichierIni) do
  try
    EraseSection('Barre');
    for i := 0 to Pred(FToolCurrent.Count) do
      WriteString('Barre', FToolCurrent.Names[i], FToolCurrent.ValueFromIndex[i]);
  finally
    Free;
  end
end;

procedure TFond.actPersonnaliseBarreExecute(Sender: TObject);
begin
  with TFrmCustomize.Create(Self) do
  try
    if ShowModal = mrOk then Historique.AddWaiting(fcRecreateToolBar);
  finally
    Free;
  end;
end;

procedure TFond.ActionsOutilsUpdate(Action: TBasicAction; var Handled: Boolean);
var
  ModeConsult: Boolean;
  iImpression: IImpressionApercu;
begin
  Handled := Mode_en_cours = mdEditing;
  if not Handled then
  begin
    ModeConsult := Mode_en_cours = mdConsult;
    actActualiseRepertoire.Enabled := ModeConsult;

    if Assigned(FCurrentForm) and FCurrentForm.GetInterface(IImpressionApercu, iImpression) then
    begin
      try
        actImpression.Enabled := iImpression.ImpressionUpdate;
      except
        actImpression.Enabled := False;
      end;
      try
        actApercuImpression.Enabled := iImpression.ApercuUpdate;
      except
        actApercuImpression.Enabled := False;
      end;
    end
    else
    begin
      actImpression.Enabled := False;
      actApercuImpression.Enabled := False;
    end;
    actAfficheRecherche.Enabled := ModeConsult;
    actAfficheStock.Enabled := ModeConsult;
    actNouvelAchat.Enabled := ModeConsult;
    actModeConsultation.Checked := Assigned(FrmRepertoire);
    actModeGestion.Checked := Assigned(FrmGestions);
    actModeConsultation.Enabled := not actModeConsultation.Checked;
    actModeGestion.Enabled := not actModeGestion.Checked;
    actChangeMode.Checked := actModeGestion.Checked;
    {$IFDEF RELEASE}
    actScripts.Visible := False;
    actPublier.Visible := False;
    {$ENDIF}
  end;
end;

procedure TFond.actAideSommaireExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TFond.actAideAboutExecute(Sender: TObject);
begin
  with TFrmAboutBox.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFond.actModeGestionExecute(Sender: TObject);
var
  LockWindow: ILockWindow;
begin
  LockWindow := TLockWindow.Create(Self);
  if actModeGestion.Checked then Exit;
  if Assigned(FrmRepertoire) then FreeAndNil(FrmRepertoire);
  Application.CreateForm(TFrmGestions, FrmGestions);
  SetChildForm(FrmGestions);
end;

procedure TFond.actModeConsultationExecute(Sender: TObject);
var
  LockWindow: ILockWindow;
begin
  LockWindow := TLockWindow.Create(Self);
  if actModeConsultation.Checked then Exit;
  FrmGestions := nil;
  Application.CreateForm(TFrmRepertoire, FrmRepertoire);
  SetChildForm(FrmRepertoire, alLeft);
  Historique.Refresh;
end;

procedure TFond.actStatsInfosBDthequeExecute(Sender: TObject);
begin
  ImpressionInfosBDtheque(TAction(Sender).ActionComponent.Tag = 1);
end;

procedure TFond.StatsEmpruntsExecute(Sender: TObject);
begin
  ImpressionEmprunts(TAction(Sender).ActionComponent.Tag = 1, seTous, ssTous, -1, -1, True, True);
end;

procedure TFond.actStatsListeCompletesAlbumsExecute(Sender: TObject);
begin
  ImpressionListeCompleteAlbums(TAction(Sender).ActionComponent.Tag = 1);
end;

procedure TFond.actStatsAlbumsEmpruntesExecute(Sender: TObject);
begin
  ImpressionEmprunts(TAction(Sender).ActionComponent.Tag = 1, seTous, ssTous, -1, -1, True, True);
end;

procedure TFond.StatsInfosBDAppExecute(Sender: TObject);
begin
  actStatsInfosBDtheque.ActionComponent := TComponent(Sender);
  actStatsInfosBDtheque.Execute;
end;

procedure TFond.StatsListeCompletesAlbumsAppExecute(Sender: TObject);
begin
  actStatsListeCompletesAlbums.ActionComponent := TComponent(Sender);
  actStatsListeCompletesAlbums.Execute;
end;

procedure TFond.StatsAlbumsEmpruntesAppExecute(Sender: TObject);
begin
  actStatsAlbumsEmpruntes.ActionComponent := TComponent(Sender);
  actStatsAlbumsEmpruntes.Execute;
end;

procedure TFond.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  CheminBase.Caption := DMPrinc.UIBDataBase.DatabaseName;
  HistoriqueBack.Enabled := (Mode_en_cours = mdConsult) and Bool(Historique.CurrentConsultation);
  HistoriqueNext.Enabled := (Mode_en_cours = mdConsult) and Bool(Historique.CountConsultation) and (Historique.CurrentConsultation <> Historique.CountConsultation - 1);
end;

function TFond.SetModalChildForm(Form: TForm; Alignement: TAlign): Integer;
var
  LockWindow: ILockWindow;
  me: IModeEditing;
  CurrentMenu: TMainMenu;
begin
  LockWindow := TLockWindow.Create(Self);
  me := TModeEditing.Create;
  Result := 0;
  if not Assigned(Form) then Exit;
  Application.ModalStarted;
  Form.BorderStyle := bsNone;
  Form.Parent := Self;
  if FModalWindows.Count > 0 then
  begin
    TForm(FModalWindows.Peek).Enabled := False;
    CurrentMenu := TForm(FModalWindows.Peek).Menu;
  end
  else
    CurrentMenu := FCurrentForm.Menu;
  if Assigned(FrmRepertoire) then FrmRepertoire.Visible := False;
  FModalWindows.Push(Form);
  try
    Form.Show;
    Form.Align := Alignement;
    MergeMenu(Form.Menu);
    LockWindow := nil;
    repeat
      Application.HandleMessage;
      Result := Form.ModalResult;
    until Result <> 0;
  finally
    FModalWindows.Pop;
    if FModalWindows.Count > 0 then TForm(FModalWindows.Peek).Enabled := True;
    if Assigned(FrmRepertoire) then FrmRepertoire.Visible := FModalWindows.Count = 0;
    MergeMenu(CurrentMenu);
    Application.ModalFinished;
  end;
end;

function TFond.IsShowing(Classe: TFormClass): Boolean;
var
  i: Integer;
  c: TObject;
begin
  Result := False;
  i := 0;
  while not Result and (i < FModalWindows.Count) do
  begin
    c := FModalWindows.List[i];
    Result := c is Classe;
    Inc(i);
  end;
end;

procedure TFond.MergeMenu(MergedMenu: TMainMenu);

  procedure ProcessMenuItem(MenuItem: TMenuItem);
  var
    i: Integer;
  begin
    if MenuItem.Caption = cLineCaption then Exit;
    if Assigned(MenuItem.Parent) then MenuItem.OnMeasureItem := MeasureMenuItem;
    for i := 0 to Pred(MenuItem.Count) do
      ProcessMenuItem(MenuItem.Items[i]);
  end;

var
  i: Integer;
begin
  if Assigned(MergedMenu) then
  begin
    if Utilisateur.Options.GrandesIconesMenus then
      MergedMenu.Images := boutons_32x32_hot
    else
      MergedMenu.Images := boutons_16x16_hot;
    for i := 0 to Pred(MergedMenu.Items.Count) do
      MergedMenu.Items[i].GroupIndex := 50;
  end;
  Menu.Merge(MergedMenu);
  for i := 0 to Pred(Menu.Items.Count) do
    ProcessMenuItem(Menu.Items[i]);
end;

procedure TFond.SetChildForm(Form: TForm; Alignement: TAlign = alClient);
var
  LockWindow: ILockWindow;
begin
  if not Assigned(Form) then
  begin
    if (Mode_en_cours = mdConsult) then
      Historique.Last
    else if Assigned(FCurrentForm) then
      SetChildForm(FCurrentForm);
    Exit;
  end;
  LockWindow := TLockWindow.Create(Self);
  try
    if Assigned(FCurrentForm) then FreeAndNil(FCurrentForm);
  except
  end;
  Form.BorderStyle := bsNone;
  Form.Parent := Self;
  Form.Visible := True;
  Form.Align := Alignement;
  if not (Form is TFrmRepertoire) then
  begin
    FCurrentForm := Form;
    MergeMenu(FCurrentForm.Menu);
  end
  else
    FCurrentForm := nil;
  if Form is TFrmRepertoire then Splitter1.Left := ClientWidth - Splitter1.Width;
  Form.left := 0;
end;

procedure TFond.HistoriqueBackExecute(Sender: TObject);
begin
  Historique.Back;
end;

procedure TFond.HistoriqueNextExecute(Sender: TObject);
begin
  Historique.Next;
end;

procedure TFond.FormShow(Sender: TObject);
begin
  Splitter1.Left := ClientWidth;
end;

procedure TFond.ActionsStatistiquesUpdate(Action: TBasicAction; var Handled: Boolean);
var
  i: Integer;
begin
  if Mode_en_cours = mdEditing then
  begin
    for i := 0 to Pred(ActionsStatistiques.ActionCount) do
      TAction(ActionsStatistiques.Actions[i]).Enabled := False;
    Handled := True;
  end
  else
    for i := 0 to Pred(ActionsStatistiques.ActionCount) do
      TAction(ActionsStatistiques.Actions[i]).Enabled := True;
end;

procedure TFond.actModeEntretienExecute(Sender: TObject);
begin
  SetModalChildForm(TFrmEntretien.Create(Self));
end;

procedure TFond.actAfficheSeriesIncompletesExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcSeriesIncompletes);
end;

procedure TFond.actAffichePrevisionsSortiesExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcPrevisionsSorties);
end;

procedure TFond.MeasureMenuItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);

  procedure SetMenuSize;
  var
    NonClientMetrics: TNonClientMetrics;
  begin
    NonClientMetrics.cbSize := sizeof(NonClientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    begin
      Height := NonClientMetrics.iMenuHeight;
    end;
  end;

var
  il: TCustomImageList;
begin
  il := TMenuItem(Sender).GetImageList;
  if not Assigned(il) or (TMenuItem(Sender).ImageIndex = -1) then
    SetMenuSize
  else
    Height := il.Height + 3;
end;

procedure TFond.actNouvelAchatExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcPrevisionsAchats);
end;

procedure TFond.actMiseAJourExecute(Sender: TObject);
begin
  DMPrinc.CheckVersion(True);
end;

procedure TFond.HistoriqueChanged(Sender: TObject);
const
  MaxNbItems = 10;
var
  i: Integer;
  mnu: TMenuItem;
begin
  //  mnuBack.Items.Count = Historique.CurrentConsultation;
  //  mnuNext.Items.Count = Historique.CountConsultation - Historique.CurrentConsultation - 1;
  //  mnuCurrent.Items.Count = 1 (Historique.CurrentConsultation);

  mnuBack.Clear;
  for i := Max(0, Historique.CurrentConsultation - MaxNbItems) to (Historique.CurrentConsultation - 1) do
  begin
    mnu := TMenuItem.Create(Self);
    mnu.Caption := Historique.GetDescription(i);
    mnu.Tag := i;
    mnu.OnClick := HistoriqueChosen;
    mnuBack.Insert(0, mnu);
  end;
  if (Historique.CurrentConsultation - MaxNbItems > 0) then
  begin
    mnu := TMenuItem.Create(Self);
    mnu.Caption := '...';
    mnu.Enabled := False;
    mnuBack.Add(mnu);
  end;
  mnuNext.Clear;
  for i := (Historique.CurrentConsultation + 1) to Min(Pred(Historique.CountConsultation), Historique.CurrentConsultation + MaxNbItems) do
  begin
    mnu := TMenuItem.Create(Self);
    mnu.Caption := Historique.GetDescription(i);
    mnu.Tag := i;
    mnu.OnClick := HistoriqueChosen;
    mnuNext.Add(mnu);
  end;
  if (Historique.CurrentConsultation + MaxNbItems < Pred(Historique.CountConsultation)) then
  begin
    mnu := TMenuItem.Create(Self);
    mnu.Caption := '...';
    mnu.Enabled := False;
    mnuNext.Add(mnu);
  end;
end;

procedure TFond.HistoriqueChosen(Sender: TObject);
begin
  Historique.GoConsultation(TComponent(Sender).Tag);
end;

procedure TFond.actScriptsExecute(Sender: TObject);
begin
  with TfrmScripts.Create(nil) do try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFond.actPublierExecute(Sender: TObject);
begin
  with TfrmPublier.Create(nil) do try
    ShowModal;
  finally
    Free;
  end;
end;

end.

