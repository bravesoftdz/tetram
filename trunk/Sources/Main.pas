unit Main;

interface

{.$D-}
{$WARN SYMBOL_DEPRECATED OFF}

uses
  Divers, PrintObject, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ImgList, Menus,
  ComCtrls, ExtCtrls, Buttons, ActnList, Printers, iniFiles, jpeg, Contnrs, ToolWin;

type
  TActionUpdate = function: Boolean of object;

  TStack = class(Contnrs.TStack)
    //  published
    //    property List;
  end;

  TFond = class(TForm)
    ImageList1: TImageList;
    boutons_32x32_hot: TImageList;
    ActionsOutils: TActionList;
    ChangementOptions: TAction;
    AideContextuelle: TAction;
    AfficheStatsGenerales: TAction;
    AfficheStock: TAction;
    PrinterSetupDialog1: TPrinterSetupDialog;
    AfficheRecherche: TAction;
    Impression: TAction;
    ApercuImpression: TAction;
    ActualiseRepertoire: TAction;
    RelireOptions: TAction;
    Quitter: TAction;
    AfficheStatsEmprunteurs: TAction;
    AfficheStatsAlbums: TAction;
    PersonnaliseBarre: TAction;
    boutons_16x16_hot: TImageList;
    ShareImageList: TImageList;
    ActionList1: TActionList;
    PrintDialog1: TPrintDialog;
    AideSommaire: TAction;
    AideAbout: TAction;
    ModeGestion: TAction;
    ModeConsultation: TAction;
    ModeEntretien: TAction;
    StatsInfosBDtheque: TAction;
    StatsListeCompletesAlbums: TAction;
    StatsAlbumsEmpruntes: TAction;
    ActionsStatistiques: TActionList;
    StatsInfosBDApp: TAction;
    StatsInfosBDPrn: TAction;
    StatsListeCompletesAlbumsApp: TAction;
    StatsListeCompletesAlbumsPrn: TAction;
    StatsAlbumsEmpruntesApp: TAction;
    StatsAlbumsEmpruntesPrn: TAction;
    CheminBase: TAction;
    ChangeMode: TAction;
    HistoriqueBack: TAction;
    HistoriqueNext: TAction;
    Splitter1: TSplitter;
    ActiveWebServer: TAction;
    AfficheSeriesIncompletes: TAction;
    AffichePrevisionsSorties: TAction;
    actExporter: TAction;
    actImporter: TAction;
    AllerVersWebServer: TAction;
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
    Importer1: TMenuItem;
    Exporter1: TMenuItem;
    N3: TMenuItem;
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
    N8: TMenuItem;
    WebServer1: TMenuItem;
    Dmarrer1: TMenuItem;
    Voir1: TMenuItem;
    Sommaire1: TMenuItem;
    Aidecontextuelle1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    Cheminbase1: TMenuItem;
    Apropos1: TMenuItem;
    boutons_32x32_norm: TImageList;
    boutons_16x16_norm: TImageList;
    NouvelAchat: TAction;
    N11: TMenuItem;
    Achat1: TMenuItem;
    actMiseAJour: TAction;
    N12: TMenuItem;
    Vrifierlaversion1: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ChangementOptionsExecute(Sender: TObject);
    procedure AideContextuelleExecute(Sender: TObject);
    procedure AfficheStatsGeneralesExecute(Sender: TObject);
    procedure AfficheStockExecute(Sender: TObject);
    procedure AfficheRechercheExecute(Sender: TObject);
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuImpressionExecute(Sender: TObject);
    procedure ChangeModeExecute(Sender: TObject);
    procedure ActualiseRepertoireExecute(Sender: TObject);
    procedure RelireOptionsExecute(Sender: TObject);
    procedure QuitterExecute(Sender: TObject);
    procedure AfficheStatsEmprunteursExecute(Sender: TObject);
    procedure AfficheStatsAlbumsExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PersonnaliseBarreExecute(Sender: TObject);
    procedure LoadToolBarres;
    procedure ActionsOutilsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure AideSommaireExecute(Sender: TObject);
    procedure AideAboutExecute(Sender: TObject);
    procedure ModeGestionExecute(Sender: TObject);
    procedure StatsInfosBDthequeExecute(Sender: TObject);
    procedure StatsEmpruntsExecute(Sender: TObject);
    procedure StatsListeCompletesAlbumsExecute(Sender: TObject);
    procedure StatsAlbumsEmpruntesExecute(Sender: TObject);
    procedure StatsInfosBDAppExecute(Sender: TObject);
    procedure StatsListeCompletesAlbumsAppExecute(Sender: TObject);
    procedure StatsAlbumsEmpruntesAppExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure ModeConsultationExecute(Sender: TObject);
    procedure HistoriqueBackExecute(Sender: TObject);
    procedure HistoriqueNextExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionsStatistiquesUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActiveWebServerExecute(Sender: TObject);
    procedure ModeEntretienExecute(Sender: TObject);
    procedure AfficheSeriesIncompletesExecute(Sender: TObject);
    procedure AffichePrevisionsSortiesExecute(Sender: TObject);
    procedure actExporterExecute(Sender: TObject);
    procedure AllerVersWebServerExecute(Sender: TObject);
    procedure MeasureMenuItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
    procedure NouvelAchatExecute(Sender: TObject);
    procedure actMiseAJourExecute(Sender: TObject);
  private
    { Déclarations privées }
    FToolOriginal: TStringList;
    FModalWindows: TStack;
    procedure ChargeToolBarres(sl: TStringList);
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure MergeMenu(MergedMenu: TMainMenu);
  public
    { Déclarations publiques }
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
  MAJ, Form_Consultation, Form_ConsultationE, Form_Repertoire, CommonConst, Commun, Form_options, Form_StatsGeneral,
  Form_StatsEmprunteurs, Form_StatsAlbums, Textes, LoadComplet, Impression, Editions, Form_Gestion, Form_Customize,
  Form_AboutBox, DM_Princ, TypeRec, Types, Procedures, UHistorique, Form_Entretien,
  Form_Exportation, ShellAPI;

procedure TFond.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE: Quitter.Execute;
    else
      inherited;
  end;
end;

procedure TFond.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
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
  for i := 0 to ToolBar1.ButtonCount - 1 do begin
    tlb := ToolBar1.Buttons[i];
    if Assigned(tlb) then begin
      if Assigned(tlb.Action) then begin
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
end;

procedure TFond.ChangementOptionsExecute(Sender: TObject);
begin
  with TFrmOptions.Create(Self) do try
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

procedure TFond.AideContextuelleExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXTPOPUP, 0);
end;

procedure TFond.AfficheStatsGeneralesExecute(Sender: TObject);
var
  R: TStats;
begin
  R := TStats.Create(False);
  with TStatsGeneralesCreate(Self, R) do begin
    try
      ShowModal;
    finally
      Free;
      R.Free;
    end;
  end;
end;

procedure TFond.AfficheStockExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcStock);
end;

procedure TFond.AfficheRechercheExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcRecherche);
end;

procedure TFond.ImpressionExecute(Sender: TObject);
var
  iImpression: IImpressionApercu;
begin
  if Assigned(FCurrentForm) and FCurrentForm.GetInterface(IImpressionApercu, iImpression) then
    iImpression.ImpressionExecute(Sender);
end;

procedure TFond.ApercuImpressionExecute(Sender: TObject);
var
  iImpression: IImpressionApercu;
begin
  if Assigned(FCurrentForm) and FCurrentForm.GetInterface(IImpressionApercu, iImpression) then
    iImpression.ApercuExecute(Sender);
end;

procedure TFond.ChangeModeExecute(Sender: TObject);
begin
  if not ChangeMode.Checked then
    ModeGestion.Execute
  else
    ModeConsultation.Execute;
end;

procedure TFond.ActualiseRepertoireExecute(Sender: TObject);
begin
  FrmRepertoire.vstAlbums.InitializeRep;
  FrmRepertoire.vstEmprunteurs.InitializeRep;
  FrmRepertoire.vstAuteurs.InitializeRep;
end;

procedure TFond.RelireOptionsExecute(Sender: TObject);
begin
  LitOptions;
end;

procedure TFond.QuitterExecute(Sender: TObject);
var
  i: integer;
begin
  if (DMPrinc.HTTPServer.Active) and (AffMessage('Êtes-vous sûr de vouloir quitter?', mtConfirmation, [mbYes, mbNo], True) <> mrYes) then Exit;
  i := 0;
  while i < Application.ComponentCount do
    if (Application.Components[i] is TDataModule) and
      (Application.Components[i] <> DMPrinc) then
      Application.Components[i].Free
    else
      Inc(i);
  Close;
end;

procedure TFond.AfficheStatsEmprunteursExecute(Sender: TObject);
var
  R: TStats;
begin
  R := TStats.Create(False);
  with TStatsEmprunteursCreate(Self, R) do try
    ShowModal;
  finally
    Free;
    R.Free;
  end;
end;

procedure TFond.AfficheStatsAlbumsExecute(Sender: TObject);
var
  R: TStats;
begin
  R := TStats.Create(False);
  with TStatsAlbumsCreate(Self, R) do begin
    try
      ShowModal;
    finally
      Free;
      R.Free;
    end;
  end;
end;

procedure TFond.ChargeToolBarres(sl: TStringList);

  function GetAction(const Name: string): TAction;
  var
    i: integer;
    act: TCustomAction;
    s1, s2: string;
  begin
    Result := nil;
    s1 := UpperCase(Name);
    for i := 0 to ActionsOutils.ActionCount - 1 do begin
      act := TCustomAction(ActionsOutils.Actions[i]);
      if act <> nil then begin
        s2 := UpperCase(act.Name);
        if s1 = s2 then begin
          Result := act as TAction;
          Exit;
        end;
      end;
    end;
  end;

  function NewAction(aAction: TAction): TToolButton;
  begin
    Result := TToolButton.Create(ToolBar1);
    with Result do begin
      Parent := ToolBar1;
      if aAction = nil then begin
        Style := tbsSeparator;
        Width := 8;
      end
      else begin
        Action := aAction;
        Cursor := crHandPoint;
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

  if Utilisateur.Options.GrandesIconesBarre then begin
    ToolBar1.Images := boutons_32x32_norm;
    ToolBar1.HotImages := boutons_32x32_hot;
  end
  else begin
    ToolBar1.Images := boutons_16x16_norm;
    ToolBar1.HotImages := boutons_16x16_hot;
  end;
  ToolBar1.ButtonHeight := 0; // force la barre à se redimensionner correctement
  ToolBar1.ButtonWidth := 0;

  LastButton := tbSep;
  for i := sl.Count - 1 downto 0 do begin
    s1 := sl.Names[i];
    s2 := sl.Values[s1];
    if s2 = 'X' then begin
      if LastButton <> tbSep then NewAction(nil);
      LastButton := tbSep;
    end
    else begin
      aAction := GetAction(s2);
      if aAction <> nil then begin
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
    with TIniFile.Create(FichierIni) do begin
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
  i: integer;
begin
  with TIniFile.Create(FichierIni) do try
    EraseSection('Barre');
    for i := 0 to Pred(FToolCurrent.Count) do
      WriteString('Barre', FToolCurrent.Names[i], FToolCurrent.ValueFromIndex[i]);
  finally
    Free;
  end
end;

procedure TFond.PersonnaliseBarreExecute(Sender: TObject);
begin
  with TFrmCustomize.Create(Self) do try
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
  if not Handled then begin
    ModeConsult := Mode_en_cours = mdConsult;
    ActualiseRepertoire.Enabled := ModeConsult;

    if Assigned(FCurrentForm) and FCurrentForm.GetInterface(IImpressionApercu, iImpression) then begin
      try
        Impression.Enabled := iImpression.ImpressionUpdate;
      except
        Impression.Enabled := False;
      end;
      try
        ApercuImpression.Enabled := iImpression.ApercuUpdate;
      except
        ApercuImpression.Enabled := False;
      end;
    end
    else begin
      Impression.Enabled := False;
      ApercuImpression.Enabled := False;
    end;
    AfficheRecherche.Enabled := ModeConsult;
    AfficheStock.Enabled := ModeConsult;
    NouvelAchat.Enabled := ModeConsult;
    ModeConsultation.Checked := Assigned(FrmRepertoire);
    ModeGestion.Checked := Assigned(FrmGestions);
    ChangeMode.Checked := ModeGestion.Checked;
    AllerVersWebServer.Enabled := DMPrinc.HTTPServer.Active;
    if AllerVersWebServer.Enabled then
      ActiveWebServer.Caption := 'Arrêter'
    else
      ActiveWebServer.Caption := 'Démarrer';
  end;
end;

procedure TFond.AideSommaireExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TFond.AideAboutExecute(Sender: TObject);
begin
  with TFrmAboutBox.Create(Application) do begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFond.ModeGestionExecute(Sender: TObject);
var
  LockWindow: ILockWindow;
begin
  LockWindow := TLockWindow.Create(Self);
  if ModeGestion.Checked then Exit;
  if Assigned(FrmRepertoire) then FreeAndNil(FrmRepertoire);
  Application.CreateForm(TFrmGestions, FrmGestions);
  SetChildForm(FrmGestions);
end;

procedure TFond.ModeConsultationExecute(Sender: TObject);
var
  LockWindow: ILockWindow;
begin
  LockWindow := TLockWindow.Create(Self);
  if ModeConsultation.Checked then Exit;
  FrmGestions := nil;
  Application.CreateForm(TFrmRepertoire, FrmRepertoire);
  SetChildForm(FrmRepertoire, alLeft);
  Historique.Refresh;
end;

procedure TFond.StatsInfosBDthequeExecute(Sender: TObject);
begin
  ImpressionInfosBDtheque(TAction(Sender).ActionComponent.Tag = 1);
end;

procedure TFond.StatsEmpruntsExecute(Sender: TObject);
begin
  ImpressionEmprunts(TAction(Sender).ActionComponent.Tag = 1, seTous, ssTous, -1, -1, True, True);
end;

procedure TFond.StatsListeCompletesAlbumsExecute(Sender: TObject);
begin
  ImpressionListeCompleteAlbums(TAction(Sender).ActionComponent.Tag = 1);
end;

procedure TFond.StatsAlbumsEmpruntesExecute(Sender: TObject);
begin
  ImpressionEmprunts(TAction(Sender).ActionComponent.Tag = 1, seTous, ssTous, -1, -1, True, True);
end;

procedure TFond.StatsInfosBDAppExecute(Sender: TObject);
begin
  StatsInfosBDtheque.ActionComponent := TComponent(Sender);
  StatsInfosBDtheque.Execute;
end;

procedure TFond.StatsListeCompletesAlbumsAppExecute(Sender: TObject);
begin
  StatsListeCompletesAlbums.ActionComponent := TComponent(Sender);
  StatsListeCompletesAlbums.Execute;
end;

procedure TFond.StatsAlbumsEmpruntesAppExecute(Sender: TObject);
begin
  StatsAlbumsEmpruntes.ActionComponent := TComponent(Sender);
  StatsAlbumsEmpruntes.Execute;
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
  if FModalWindows.Count > 0 then begin
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
  while not Result and (i < FModalWindows.Count) do begin
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
  if Assigned(MergedMenu) then begin
    if Utilisateur.Options.GrandesIconesMenus then
      MergedMenu.Images := boutons_32x32_hot
    else
      MergedMenu.Images := boutons_16x16_hot;
    for i := 0 to Pred(MergedMenu.Items.Count) do begin
      MergedMenu.Items[i].GroupIndex := 50;
      ProcessMenuItem(MergedMenu.Items[i]);
    end;
  end;
  Menu.Merge(MergedMenu);
end;

procedure TFond.SetChildForm(Form: TForm; Alignement: TAlign = alClient);
var
  LockWindow: ILockWindow;
begin
  if not Assigned(Form) then begin
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
  if not (Form is TFrmRepertoire) then begin
    FCurrentForm := Form;
    MergeMenu(FCurrentForm.Menu);
  end
  else
    FCurrentForm := nil;
  if Form is TFrmRepertoire then Splitter1.Left := ClientWidth - Splitter1.Width;
  Form.left := 0;
//  for i := 0 to Pred(MainMenu1.Items.Count) do
//    ProcessMenuItem(MainMenu1.Items[i]);
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
  if Mode_en_cours = mdEditing then begin
    for i := 0 to Pred(ActionsStatistiques.ActionCount) do
      TAction(ActionsStatistiques.Actions[i]).Enabled := False;
    Handled := True;
  end
  else begin
    for i := 0 to Pred(ActionsStatistiques.ActionCount) do
      TAction(ActionsStatistiques.Actions[i]).Enabled := True;
  end;
end;

procedure TFond.ActiveWebServerExecute(Sender: TObject);
begin
  DMPrinc.ActiveHTTPServer(not DMPrinc.HTTPServer.Active);
end;

procedure TFond.ModeEntretienExecute(Sender: TObject);
begin
  SetModalChildForm(TFrmEntretien.Create(Self));
end;

procedure TFond.AfficheSeriesIncompletesExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcSeriesIncompletes);
end;

procedure TFond.AffichePrevisionsSortiesExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcPrevisionsSorties);
end;

procedure TFond.actExporterExecute(Sender: TObject);
begin
  SetModalChildForm(TFrmExportation.Create(Self));
end;

procedure TFond.AllerVersWebServerExecute(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PChar('http://127.0.0.1:' + IntToStr(Utilisateur.Options.WebServerPort)), nil, nil, SW_NORMAL);
end;

procedure TFond.MeasureMenuItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);

  procedure GetMenuSize;
  var
    NonClientMetrics: TNonClientMetrics;
  begin
    NonClientMetrics.cbSize := sizeof(NonClientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then begin
      Height := NonClientMetrics.iMenuHeight;
    end;
  end;

var
  il: TCustomImageList;
begin
  il := TMenuItem(Sender).GetImageList;
  if not Assigned(il) or (TMenuItem(Sender).ImageIndex = -1) then
    GetMenuSize
  else
    Height := il.Height + 3;
end;

procedure TFond.NouvelAchatExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcPrevisionsAchats);
end;

procedure TFond.actMiseAJourExecute(Sender: TObject);
begin
  DMPrinc.CheckVersion(True);
end;

end.

