unit ProceduresBDtk;

interface

uses
  SysUtils, Windows, StdCtrls, Forms, Controls, UfrmProgression, ExtCtrls, CommonConst, Graphics, StrUtils, Dialogs;

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
  private
    FTimer: TTimer;

    FCaption, FMessage: string;
    FValeur, FMaxi: Integer;
    FTimeToWait: Cardinal;
    FForm: TFrmProgression;
    PResult: PInteger;
    procedure InitForm;
    procedure ClearForm;
    procedure RefreshForm;
    procedure Execute(Sender: TObject);
    procedure Cancel(Sender: TObject);
  public
    constructor Create(const Msg: string = ''; WaitFor: Cardinal = 2000; Retour: PInteger = nil); reintroduce;
    destructor Destroy; override;
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
  end;

  IModeEditing = interface
  end;

  TModeEditing = class(TInterfacedObject, IModeEditing)
  private
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
  LibelleDetailSerieOption: array[TDetailSerieOption, TDetailSerieOption] of string = (
    ('Série seule', 'Liste simplifiée des albums et para-BD', 'Liste détaillée des albums et para-BD', 'Liste simplifiée des éditions', 'Liste détaillée des éditions'),
    ('', '', '', '', ''),
    ('', '', 'Album seul', 'Liste simplifiée des éditions', 'Liste détaillée des éditions'),
    ('', '', '', '', ''),
    ('', '', '', '', '')
    );

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean): TModalResult; overload;
function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult; overload;

implementation

uses
  UfrmChoixDetail, UfrmChoix, UfrmConvertisseur, UfrmFond, Divers, Procedures, Math, Textes, ActnList,
  UfrmChoixDetailSerie;

{ TWaiting }

procedure TWaiting.ClearForm;
begin
  if Assigned(FForm) then
    FreeAndNil(FForm);
end;

constructor TWaiting.Create(const Msg: string; WaitFor: Cardinal; Retour: PInteger);
begin
  inherited Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := WaitFor;
  FTimer.OnTimer := Execute;
  FForm := nil;
  FCaption := Msg;
  FTimeToWait := WaitFor;
  if Assigned(Retour) then
    Retour^ := 0;
  PResult := Retour;
  FTimer.Enabled := True;
end;

procedure TWaiting.InitForm;
begin
  FForm := TFrmProgression.Create(Application);
  if Assigned(PResult) then
    FForm.framBoutons1.btnAnnuler.OnClick := Self.Cancel
  else
    FForm.framBoutons1.Visible := False;
  if FCaption <> '' then
    FForm.Caption := FCaption;
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
end;

procedure TWaiting.ShowProgression(const Texte: string; Etape: TEtapeProgression);
begin
  case Etape of
    epNext: Inc(FValeur);
    epFin: FValeur := FMaxi;
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
  if not Bouton in [0..2] then
    Exit;

{$IFDEF DEBUG}
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        with Buttons.Add do
        begin
          Caption := Texte1;
          Default := Bouton = 1;
          ModalResult := mrYes;
        end;

        with Buttons.Add do
        begin
          Caption := Texte2;
          Default := Bouton = 2;
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
{$ENDIF DEBUG}
    with TFrmChoix.Create(Application) do
      try
        BtnChoix1.Caption := Texte1;
        BtnChoix2.Caption := Texte2;
        case bouton of
          0: framBoutons1.btnAnnuler.Default := True;
          1: BtnChoix1.Default := True;
          2: BtnChoix2.Default := True;
        end;
        Result := ShowModal;
      finally
        Free;
      end;
end;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;
begin
  if not Bouton in [0..2] then
  begin
    Result := 0;
    Exit;
  end;
  with TFrmChoixDetail.Create(Application) do
    try
      BtnChoix1.Caption := rsTransListeSimple;
      BtnChoix2.Caption := rsTransListeDetail;
      case Bouton of
        0: framBoutons1.btnAnnuler.Default := True;
        1: BtnChoix1.Default := True;
        2: BtnChoix2.Default := True;
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
{$IFDEF DEBUG}
var
  i: TDetailSerieOption;
{$ENDIF DEBUG}
begin
  Result := mrCancel;
{$IFDEF DEBUG}
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        for i := Low(TDetailSerieOption) to High(TDetailSerieOption) do
          if i >= NiveauDetailMax then
            with Buttons.Add do
            begin
              Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
              Default := i = NiveauDetailMax;
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
{$ENDIF DEBUG}
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

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean): TModalResult;
{$IFDEF DEBUG}
var
  i: TDetailSerieOption;
{$ENDIF DEBUG}
begin
  Result := mrCancel;
{$IFDEF DEBUG}
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        for i := Low(TDetailSerieOption) to High(TDetailSerieOption) do
          if i >= NiveauDetailMax then
            with Buttons.Add do
            begin
              Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
              Default := i = NiveauDetailMax;
              ModalResult := 110 + Integer(i);
            end;

        with RadioButtons.Add do
        begin
          Caption := 'Inclure Prévisions de sorties/Manquants';
          Default := True;
          ModalResult := 105;
        end;
        with RadioButtons.Add do
        begin
          Caption := 'Exclure Prévisions de sorties/Manquants';
          Default := False;
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
{$ENDIF DEBUG}
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

end.

