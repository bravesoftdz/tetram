unit ProceduresBDtk;

interface

uses SysUtils, Windows, StdCtrls, Forms, Controls, UfrmProgression, ExtCtrls, CommonConst, Graphics, StrUtils, Dialogs, SyncObjs;

type
  IImpressionApercu = interface
    ['{10227EB6-D5D0-4541-AAD6-D1A62E9308C9}']
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  end;

  IFicheEditable = interface
    ['{2B938304-BB07-48D7-8A19-F3C70C38E271}']
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
  end;

  TEtapeProgression = (epNext, epFin);

  IWaiting = interface
    ['{82C50525-A282-4982-92DB-ED5FEC2E5C96}']
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
  end;

  TWaiting = class(TInterfacedObject, IWaiting)
  strict private
    FTimer: TTimer;

    FCaption, FMessage: string;
    FValeur, FMaxi: Integer;
    FTimeToWait: Cardinal;
    FForm: TFrmProgression;
    PResult: PInteger;
    FromMainThread: Boolean;
    procedure InitForm;
    procedure ClearForm;
    procedure RefreshForm;
    procedure Execute(Sender: TObject);
    procedure Cancel(Sender: TObject);
  public
    constructor Create(const Msg: string = ''; WaitFor: Cardinal = 2000; Retour: PInteger = nil; MainThread: Boolean = True); reintroduce;
    destructor Destroy; override;
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
  end;

  IModeEditing = interface
  end;

  TModeEditing = class(TInterfacedObject, IModeEditing)
  strict private
    FOldMode: TModeConsult;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function ChargeImage(ImgBmp: TImage; const ResName: string; ForceVisible: Boolean = True): Boolean; overload;
function ChargeImage(Picture: TPicture; const ResName: string): Boolean; overload;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;

type
  TDetailAlbumOption = (daoScenario, daoDessins, daoCouleurs, daoHistoire, daoNotes);
  TDetailAlbumOptions = set of TDetailAlbumOption;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;

type
  TDetailSerieOption = (dsoSerieSeule, dsoListeAlbums, dsoAlbumsDetails, dsoListeEditions, dsoEditionsDetaillees);

const
  LibelleDetailSerieOption: array [TDetailSerieOption, TDetailSerieOption] of string =
    (('Série seule', 'Liste simplifiée des albums et para-BD', 'Liste détaillée des albums et para-BD', 'Liste simplifiée des éditions',
      'Liste détaillée des éditions'), ('', '', '', '', ''), ('', '', 'Album seul', 'Liste simplifiée des éditions', 'Liste détaillée des éditions'),
    ('', '', '', '', ''), ('', '', '', '', ''));

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean)
  : TModalResult; overload;
function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult; overload;

procedure LitOptions;
procedure EcritOptions;

implementation

uses UfrmChoixDetail, UfrmChoix, UfrmConvertisseur, UfrmFond, Divers, Procedures, Math, Textes, ActnList, UfrmChoixDetailSerie,
  uib;

{ TWaiting }

procedure TWaiting.ClearForm;
begin
  if Assigned(FForm) then
    FreeAndNil(FForm);
end;

constructor TWaiting.Create(const Msg: string; WaitFor: Cardinal; Retour: PInteger; MainThread: Boolean);
begin
  inherited Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := WaitFor;
  FTimer.OnTimer := Execute;
  FromMainThread := MainThread;

  FForm := TFrmProgression.Create(Application);
  if Assigned(PResult) then
    FForm.framBoutons1.btnAnnuler.OnClick := Self.Cancel
  else
    FForm.framBoutons1.Visible := False;
  if FCaption <> '' then
    FForm.Caption := FCaption;

  FCaption := Msg;
  FTimeToWait := WaitFor;
  if Assigned(Retour) then
    Retour^ := 0;
  PResult := Retour;
  FTimer.Enabled := True;
end;

procedure TWaiting.InitForm;
begin
  RefreshForm;
  FForm.Show;
end;

destructor TWaiting.Destroy;
begin
  ShowProgression(FMessage, epFin);
  FreeAndNil(FTimer);
  if Assigned(FForm) then
    ClearForm;
  inherited;
end;

procedure TWaiting.Execute(Sender: TObject);
begin
  FTimer.Enabled := False;
  InitForm;
end;

procedure TWaiting.RefreshForm;
var
  tmp: string;
begin
  if Assigned(FForm) then
  begin
    FForm.ProgressBar1.Max := FMaxi;
    FForm.ProgressBar1.Position := FValeur;
    tmp := FMessage;
    with FForm.op do
      if Canvas.TextWidth(tmp) > Width then
      begin
        while Canvas.TextWidth(tmp + '...') > Width do
          Delete(tmp, Length(tmp) div 2, 1);
        Insert('...', tmp, Length(tmp) div 2);
      end;
    FForm.op.Caption := tmp;
  end;
  if FromMainThread then
    Application.ProcessMessages;
end;

procedure TWaiting.ShowProgression(const Texte: string; Etape: TEtapeProgression);
begin
  case Etape of
    epNext:
      Inc(FValeur);
    epFin:
      FValeur := FMaxi;
  end;
  if Texte <> '' then
    FMessage := Texte;

  RefreshForm;
end;

procedure TWaiting.ShowProgression(const Texte: string; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  if Texte <> '' then
    FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.ShowProgression(Texte: PChar; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  if Texte <> '' then
    FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.Cancel(Sender: TObject);
begin
  if Assigned(PResult) then
    PResult^ := FForm.ModalResult;
  FForm.Release;
  FForm := nil;
end;

function ChargeImage(Picture: TPicture; const ResName: string): Boolean;
begin
  Result := False;
  Picture.Bitmap.FreeImage;
  if TGlobalVar.Utilisateur.Options.Images and not IsRemoteSession then
  begin
    if HandleDLLPic <= 32 then
      HandleDLLPic := LoadLibrary(PChar(RessourcePic));
    if HandleDLLPic > 32 then
      try
        Picture.Bitmap.LoadFromResourceName(HandleDLLPic, ResName);
        Result := True;
      except
      end;
  end;
end;

function ChargeImage(ImgBmp: TImage; const ResName: string; ForceVisible: Boolean = True): Boolean;
begin
  Result := ChargeImage(ImgBmp.Picture, ResName);
  if ForceVisible then
    ImgBmp.Visible := not ImgBmp.Picture.Bitmap.Empty;
end;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;
begin
  Result := mrCancel;
  if not Bouton in [0 .. 2] then
    Exit;
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        with Buttons.Add do
        begin
          Caption := Texte1;
          default := Bouton = 1;
          ModalResult := mrYes;
        end;

        with Buttons.Add do
        begin
          Caption := Texte2;
          default := Bouton = 2;
          ModalResult := mrNo;
        end;
        Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
        CommonButtons := [tcbCancel];
        if Execute then
          Result := ModalResult;
      finally
        Free;
      end
    else
      with TFrmChoix.Create(Application) do
        try
          BtnChoix1.Caption := Texte1;
          BtnChoix2.Caption := Texte2;
          case Bouton of
            0:
              framBoutons1.btnAnnuler.default := True;
            1:
              BtnChoix1.default := True;
            2:
              BtnChoix2.default := True;
          end;
          Result := ShowModal;
        finally
          Free;
        end;
end;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;
begin
  if not Bouton in [0 .. 2] then
  begin
    Result := 0;
    Exit;
  end;
  with TFrmChoixDetail.Create(Application) do
    try
      BtnChoix1.Caption := rsTransListeSimple;
      BtnChoix2.Caption := rsTransListeDetail;
      case Bouton of
        0:
          framBoutons1.btnAnnuler.default := True;
        1:
          BtnChoix1.default := True;
        2:
          BtnChoix2.default := True;
      end;
      Result := ShowModal;
      if Result = mrNo then
      begin
        if cbScenario.Checked then
          Include(DetailsOptions, daoScenario);
        if cbDessins.Checked then
          Include(DetailsOptions, daoDessins);
        if cbCouleurs.Checked then
          Include(DetailsOptions, daoCouleurs);
        if cbHistoire.Checked then
          Include(DetailsOptions, daoHistoire);
        if cbNotes.Checked then
          Include(DetailsOptions, daoNotes);
      end;
    finally
      Free;
    end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult;
var
  i: TDetailSerieOption;
begin
  Result := mrCancel;
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        for i := NiveauDetailMax to high(TDetailSerieOption) do
          with Buttons.Add do
          begin
            Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
            default := i = NiveauDetailMax;
            ModalResult := 110 + Integer(i);
          end;

        Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
        CommonButtons := [tcbCancel];

        if Execute and (ModalResult <> mrCancel) then
        begin
          Result := mrOk;
          DetailSerieOption := TDetailSerieOption(ModalResult - 110);
        end;
      finally
        Free;
      end
    else
      with TFrmChoixDetailSerie.Create(Application) do
        try
          // cacher la checkbox avant d'assigner MaxNiveauDetail
          CheckBox1.Visible := False;
          MaxNiveauDetail := NiveauDetailMax;
          if ShowModal <> mrCancel then
          begin
            Result := mrOk;
            DetailSerieOption := TDetailSerieOption(ModalResult - 110);
          end;
        finally
          Free;
        end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean)
  : TModalResult;
var
  i: TDetailSerieOption;
begin
  Result := mrCancel;
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        for i := NiveauDetailMax to high(TDetailSerieOption) do
          with Buttons.Add do
          begin
            Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
            default := i = NiveauDetailMax;
            ModalResult := 110 + Integer(i);
          end;

        with RadioButtons.Add do
        begin
          Caption := 'Inclure Prévisions de sorties/Manquants';
          default := True;
          ModalResult := 105;
        end;
        with RadioButtons.Add do
        begin
          Caption := 'Exclure Prévisions de sorties/Manquants';
          default := False;
          ModalResult := 106;
        end;

        Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
        CommonButtons := [tcbCancel];

        if Execute and (ModalResult <> mrCancel) then
        begin
          Result := mrOk;
          DetailSerieOption := TDetailSerieOption(ModalResult - 110);
          PrevisionsManquants := Assigned(RadioButton) and (RadioButton.ModalResult = 105);
        end;
      finally
        Free;
      end
    else
      with TFrmChoixDetailSerie.Create(Application) do
        try
          MaxNiveauDetail := NiveauDetailMax;
          if ShowModal <> mrCancel then
          begin
            Result := mrOk;
            DetailSerieOption := TDetailSerieOption(ModalResult - 110);
            PrevisionsManquants := CheckBox1.Checked;
          end;
        finally
          Free;
        end;
end;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;
var
  p: TPoint;
begin
  with TFrmConvers.Create(nil) do
    try
      Valeur := Value;
      p := Caller.ClientOrigin;
      Inc(p.y, Caller.Height);
      Left := p.x;
      Top := p.y;
      if Left + Width > Screen.WorkAreaRect.Right then
        Left := Max(0, Screen.WorkAreaRect.Right - Width);
      if Top + Height > Screen.WorkAreaRect.Bottom then
        Top := Max(0, Screen.WorkAreaRect.Bottom - Height);
      Result := ShowModal = mrOk;
      if Result then
        Value := Valeur;
    finally
      Free;
    end;
end;

{ TModeEditing }

constructor TModeEditing.Create;
var
  i: Integer;
begin
  inherited;
  FOldMode := TGlobalVar.Mode_en_cours;
  TGlobalVar.Mode_en_cours := mdEditing;
  for i := 0 to Pred(frmFond.ActionsOutils.ActionCount) do
    TAction(frmFond.ActionsOutils.Actions[i]).Enabled := False;
end;

destructor TModeEditing.Destroy;
var
  i: Integer;
begin
  TGlobalVar.Mode_en_cours := FOldMode;
  if TGlobalVar.Mode_en_cours <> mdEditing then
    for i := 0 to Pred(frmFond.ActionsOutils.ActionCount) do
      TAction(frmFond.ActionsOutils.Actions[i]).Enabled := True;
  inherited;
end;

procedure LitOptions;

  function LitStr(Table: TUIBQuery; const Champ, Defaut: string): string;
  begin
    with Table do
    begin
      Params.AsString[0] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Open;
      if not Eof then
        Result := Fields.AsUnicodeString[0]
      else
        Result := Defaut;
    end;
  end;

var
  op: TUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TUIBQuery.Create(nil);
  with op do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select first 1 valeur from options where nom_option = ? order by dm_options desc';
      Prepare(True);
      TGlobalVar.Utilisateur.Options.SymboleMonnetaire := LitStr(op, 'SymboleM', FormatSettings.CurrencyString);
      FormatMonnaie := IfThen(FormatSettings.CurrencyFormat in [0, 2], TGlobalVar.Utilisateur.Options.SymboleMonnetaire +
        IfThen(FormatSettings.CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IfThen(FormatSettings.CurrencyFormat in [1, 3],
        IfThen(FormatSettings.CurrencyFormat = 3, ' ', '') + TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '');
      RepImages := LitStr(op, 'RepImages', RepImages);
    finally
      Transaction.Free;
      Free;
    end;
  with TIniFile.Create(FichierIni) do
    try
      TGlobalVar.Utilisateur.Options.ModeDemarrage := ReadBool('DIVERS', 'ModeDemarrage', True);
      TGlobalVar.Utilisateur.Options.FicheAlbumWithCouverture := ReadBool('DIVERS', 'FicheWithCouverture', True);
      TGlobalVar.Utilisateur.Options.FicheParaBDWithImage := ReadBool('DIVERS', 'ParaBDWithImage', True);
      TGlobalVar.Utilisateur.Options.Images := ReadBool('DIVERS', 'Images', True);
      TGlobalVar.Utilisateur.Options.AntiAliasing := ReadBool('DIVERS', 'AntiAliasing', True);
      TGlobalVar.Utilisateur.Options.ImagesStockees := ReadBool('ModeEdition', 'ImagesStockees', False);
      TGlobalVar.Utilisateur.Options.FormatTitreAlbum := ReadInteger('DIVERS', 'FormatTitreAlbum', 0);
      TGlobalVar.Utilisateur.Options.AvertirPret := ReadBool('DIVERS', 'AvertirPret', False);
      TGlobalVar.Utilisateur.Options.GrandesIconesMenus := ReadBool('DIVERS', 'GrandesIconesMenus', True);
      TGlobalVar.Utilisateur.Options.GrandesIconesBarre := ReadBool('DIVERS', 'GrandesIconesBarre', True);
      TGlobalVar.Utilisateur.Options.VerifMAJDelai := ReadInteger('Divers', 'VerifMAJDelai', 4);
      TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums := ReadBool('DIVERS', 'SerieObligatoireAlbums', False);
      TGlobalVar.Utilisateur.Options.SerieObligatoireParaBD := ReadBool('DIVERS', 'SerieObligatoireParaBD', False);
      TGlobalVar.Utilisateur.Options.AfficheNoteListes := ReadBool('DIVERS', 'AfficheNoteListes', True);

      TGlobalVar.Utilisateur.Options.SiteWeb.Adresse := ReadString('WWW', 'Adresse', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.Cle := ReadString('WWW', 'AuthKey', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.Modele := ReadString('WWW', 'Modele', 'Site par défaut');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLServeur := ReadString('WWW', 'MySQLServeur', 'localhost');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin := ReadString('WWW', 'MySQLLogin', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPassword := ReadString('WWW', 'MySQLPassword', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLBDD := ReadString('WWW', 'MySQLBDD', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin);
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPrefix := ReadString('WWW', 'MySQLPrefix', 'bdt');
      TGlobalVar.Utilisateur.Options.SiteWeb.BddVersion := ReadString('WWW', 'BddVersion', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.Paquets := ReadInteger('WWW', 'Paquets', 4096);
    finally
      Free;
    end;
end;

procedure EcritOptions;

  procedure Sauve(Table: TUIBQuery; const Champ: string; Valeur: Currency); overload;
  begin
    with Table do
    begin
      SQL.Text := 'update or insert into options (nom_option, valeur) values (:nom_option, :valeur) matching (nom_option)';
      Prepare(True);
      Params.AsString[1] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Params.AsCurrency[1] := Valeur;
      Execute;
    end;
  end;

  procedure Sauve(Table: TUIBQuery; const Champ, Valeur: string); overload;
  begin
    with Table do
    begin
      SQL.Text := 'update or insert into options (nom_option, valeur) values (:nom_option, :valeur) matching (nom_option)';
      Prepare(True);
      Params.AsString[0] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(Valeur, 1, Params.MaxStrLen[1]);
      Execute;
    end;
  end;

var
  op: TUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TUIBQuery.Create(nil);
  with op do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Sauve(op, 'SymboleM', TGlobalVar.Utilisateur.Options.SymboleMonnetaire);
      Sauve(op, 'RepImages', RepImages);
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
  with TIniFile.Create(FichierIni), TGlobalVar.Utilisateur.Options do
    try
      WriteBool('DIVERS', 'ModeDemarrage', ModeDemarrage);
      WriteBool('DIVERS', 'Images', Images);
      WriteBool('DIVERS', 'FicheWithCouverture', FicheAlbumWithCouverture);
      WriteBool('DIVERS', 'ParaBDWithImage', FicheParaBDWithImage);
      WriteBool('DIVERS', 'AntiAliasing', AntiAliasing);
      WriteBool('DIVERS', 'AvertirPret', AvertirPret);
      WriteBool('DIVERS', 'GrandesIconesMenus', GrandesIconesMenus);
      WriteBool('DIVERS', 'GrandesIconesBarre', GrandesIconesBarre);
      WriteBool('ModeEdition', 'ImagesStockees', ImagesStockees);
      WriteInteger('DIVERS', 'FormatTitreAlbum', FormatTitreAlbum);
      WriteInteger('Divers', 'VerifMAJDelai', VerifMAJDelai);
      WriteBool('DIVERS', 'SerieObligatoireAlbums', SerieObligatoireAlbums);
      WriteBool('DIVERS', 'SerieObligatoireParaBD', SerieObligatoireParaBD);
      WriteBool('DIVERS', 'AfficheNoteListes', AfficheNoteListes);

      WriteString('DIVERS', 'RepImages', ''); // efface la ligne

      WriteString('WWW', 'Adresse', SiteWeb.Adresse);
      WriteString('WWW', 'AuthKey', SiteWeb.Cle);
      WriteString('WWW', 'Modele', SiteWeb.Modele);
      WriteString('WWW', 'MySQLServeur', SiteWeb.MySQLServeur);
      WriteString('WWW', 'MySQLLogin', SiteWeb.MySQLLogin);
      WriteString('WWW', 'MySQLPassword', SiteWeb.MySQLPassword);
      WriteString('WWW', 'MySQLBDD', SiteWeb.MySQLBDD);
      WriteString('WWW', 'MySQLPrefix', SiteWeb.MySQLPrefix);
      WriteString('WWW', 'BddVersion', SiteWeb.BddVersion);
      WriteInteger('WWW', 'Paquets', SiteWeb.Paquets);
    finally
      Free;
    end;
end;

end.
