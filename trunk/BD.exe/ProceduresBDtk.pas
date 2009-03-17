unit ProceduresBDtk;

interface

uses
  SysUtils, Windows, StdCtrls, Forms, Controls, UfrmProgression, ExtCtrls, CommonConst, Graphics;

type
  IImpressionApercu = interface
    ['{10227EB6-D5D0-4541-AAD6-D1A62E9308C9}']
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
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

    FMessage: string;
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
  if Assigned(FForm) then FreeAndNil(FForm);
end;

constructor TWaiting.Create(const Msg: string; WaitFor: Cardinal; Retour: PInteger);
begin
  inherited Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := WaitFor;
  FTimer.OnTimer := Execute;
  FForm := nil;
  FTimeToWait := WaitFor;
  if Assigned(Retour) then Retour^ := 0;
  PResult := Retour;
  FTimer.Enabled := True;
end;

procedure TWaiting.InitForm;
var
  FButton: TButton;
  tmpForm: TFrmProgression;
begin
  tmpForm := TFrmProgression.Create(Application);
  if Assigned(PResult) then
  begin
    FButton := TButton.Create(FForm);
    with FButton do
    begin
      Parent := tmpForm;
      ModalResult := mrCancel;
      Caption := 'Annuler';
      Parent.ClientHeight := Parent.ClientHeight + Height + 5;
      SetBounds(Parent.ClientWidth - Width, Parent.ClientHeight - Height, Width, Height);
      OnClick := Self.Cancel;
    end;
  end;
  FForm := tmpForm;
  RefreshForm;
end;

destructor TWaiting.Destroy;
begin
  ShowProgression(FMessage, epFin);
  FreeAndNil(FTimer);
  if Assigned(FForm) then ClearForm;
  inherited;
end;

procedure TWaiting.Execute(Sender: TObject);
begin
  FTimer.Enabled := False;
  InitForm;
end;

procedure TWaiting.RefreshForm;
begin
  if Assigned(FForm) then
  begin
    FForm.ProgressBar1.Max := FMaxi;
    FForm.ProgressBar1.Position := FValeur;
    FForm.op.Caption := FMessage;
    FForm.Show;
  end;
  // Application.ProcessMessages;
end;

procedure TWaiting.ShowProgression(const Texte: string; Etape: TEtapeProgression);
begin
  case Etape of
    epNext: Inc(FValeur);
    epFin: FValeur := FMaxi;
  end;
  FMessage := Texte;

  RefreshForm;
end;

procedure TWaiting.ShowProgression(const Texte: string; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.ShowProgression(Texte: PChar; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.Cancel(Sender: TObject);
begin
  if Assigned(PResult) then PResult^ := FForm.ModalResult;
  FForm.Release;
  FForm := nil;
end;

function ChargeImage(Picture: TPicture; const ResName: string): Boolean;
begin
  Result := False;
  Picture.Bitmap.FreeImage;
  if TGlobalVar.Utilisateur.Options.Images and not IsRemoteSession then
  begin
    if HandleDLLPic <= 32 then HandleDLLPic := LoadLibrary(PChar(RessourcePic));
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
  if ForceVisible then ImgBmp.Visible := not ImgBmp.Picture.Bitmap.Empty;
end;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;
var
  w: Integer;
begin
  if not Bouton in [0..2] then
  begin
    Result := 0;
    Exit;
  end;
  with TFrmChoix.Create(Application) do
  try
    w := Max(Canvas.TextWidth(Texte1), Canvas.TextWidth(Texte2));
    with BtnChoix1 do
    begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte1;
    end;
    with BtnChoix2 do
    begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte2;
    end;
    ClientWidth := BtnChoix1.Width + 2 * BtnChoix1.Left;
    Bevel2.Width := ClientWidth - 2 * Bevel2.Left;
    Bevel1.Width := ClientWidth - 2 * Bevel1.Left;
    BtnAnnuler.Left := (ClientWidth - BtnAnnuler.Width) div 2;
    if bouton = 0 then BtnAnnuler.Default := True;
    if bouton = 1 then BtnChoix1.Default := True;
    if bouton = 2 then BtnChoix2.Default := True;
    Result := ShowModal;
  finally
    Free;
  end;
end;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;
var
  w: Integer;
  Texte1, Texte2: string;
begin
  Texte1 := rsTransListeSimple;
  Texte2 := rsTransListeDetail;
  if not Bouton in [0..2] then
  begin
    Result := 0;
    Exit;
  end;
  with TFrmChoixDetail.Create(Application) do
  try
    w := Max(Canvas.TextWidth(Texte1), Canvas.TextWidth(Texte2));
    with BtnChoix1 do
    begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte1;
    end;
    with BtnChoix2 do
    begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte2;
    end;
    ClientWidth := BtnChoix1.Width + 2 * BtnChoix1.Left;
    Bevel2.Width := ClientWidth - 2 * Bevel2.Left;
    Bevel1.Width := ClientWidth - 2 * Bevel1.Left;
    BtnAnnuler.Left := (ClientWidth - BtnAnnuler.Width) div 2;
    if bouton = 0 then BtnAnnuler.Default := True;
    if bouton = 1 then BtnChoix1.Default := True;
    if bouton = 2 then BtnChoix2.Default := True;
    Result := ShowModal;
    if Result = mrNo then
    begin
      if cbScenario.Checked then Include(DetailsOptions, daoScenario);
      if cbDessins.Checked then Include(DetailsOptions, daoDessins);
      if cbCouleurs.Checked then Include(DetailsOptions, daoCouleurs);
      if cbHistoire.Checked then Include(DetailsOptions, daoHistoire);
      if cbNotes.Checked then Include(DetailsOptions, daoNotes);
    end;
  finally
    Free;
  end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult;
begin
  with TFrmChoixDetailSerie.Create(Application) do
  try
    CheckBox1.Visible := False;
    MaxNiveauDetail := NiveauDetailMax;
    Result := ShowModal;
    if Result = mrOk then
    begin
      DetailSerieOption := TDetailSerieOption(LightComboCheck1.Value);
    end;
  finally
    Free;
  end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean): TModalResult;
begin
  with TFrmChoixDetailSerie.Create(Application) do
  try
    MaxNiveauDetail := NiveauDetailMax;
    Result := ShowModal;
    if Result = mrOk then
    begin
      DetailSerieOption := TDetailSerieOption(LightComboCheck1.Value);
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
    if Left + Width > Screen.WorkAreaRect.Right then Left := Max(0, Screen.WorkAreaRect.Right - Width);
    if Top + Height > Screen.WorkAreaRect.Bottom then Top := Max(0, Screen.WorkAreaRect.Bottom - Height);
    Result := ShowModal = mrOk;
    if Result then Value := Valeur;
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

