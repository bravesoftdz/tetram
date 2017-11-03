unit ProceduresBDtk;

interface

uses
  SysUtils, Windows, StdCtrls, Forms, Controls, Form_Progression, ExtCtrls;

type
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

implementation

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
  FTimer.Free;
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
  Application.ProcessMessages;
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

end.
