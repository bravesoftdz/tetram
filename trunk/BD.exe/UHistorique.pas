unit UHistorique;

interface

uses
  SysUtils, Windows, Classes, Contnrs;

type
  TActionConsultation = (
    fcActionBack,
    fcActionRefresh,
    fcAlbum,
    fcEmprunteur,
    fcAuteur,
    fcCouverture,
    fcRecherche,
    fcStock,
    fcPreview,
    fcSeriesIncompletes,
    fcPrevisionsSorties,
    fcRecreateToolBar,
    fcPrevisionsAchats,
    fcRefreshRepertoire,
    fcParaBD,
    fcImageParaBD,
    fcSerie
    );

const
  NoSaveHistorique: set of TActionConsultation = [fcActionBack, fcActionRefresh, fcPreview, fcRecreateToolBar, fcRefreshRepertoire];
  CanRefresh: set of TActionConsultation = [fcAlbum, fcEmprunteur, fcAuteur, fcSeriesIncompletes, fcPrevisionsSorties, fcPrevisionsAchats];
  MustRefresh: set of TActionConsultation = [fcRecherche, fcStock];

type
  RConsult = record
    Action: TActionConsultation;
    Reference, Reference2: Integer;
    Description: string;
  end;

  TConsultQueue = class(TQueue)
  published
    destructor Destroy; override;
    procedure Clear;
  end;

  THistory = class
  private
    FListConsultation: array of RConsult;
    FCurrentConsultation: Integer;
    FLockCount: Integer;
    FListWaiting: TConsultQueue;
    FOnChange: TNotifyEvent;
    function GetCountConsultation: Integer;
    function Open(const Consult: RConsult; WithLock: Boolean): Boolean;
    procedure Lock;
    procedure Unlock;
    function GetWaiting: Boolean;
    procedure Delete(Index: Integer);
  published
    constructor Create;
    destructor Destroy; override;
  public
    procedure AddConsultation(Consultation: TActionConsultation; Ref: Integer = -1; Ref2: Integer = -1);
    procedure EditConsultation(Ref: Integer = -1; Ref2: Integer = -1);
    procedure AddWaiting(Consultation: TActionConsultation; Ref: Integer = -1; Ref2: Integer = -1);
    procedure Refresh;
    procedure Back;
    procedure BackWaiting;
    procedure Next;
    procedure Last;
    procedure First;
    procedure Clear;
    procedure ProcessNext;
    function GetDescription(Index: Integer): string;
    procedure SetDescription(Value: string);
    procedure GoConsultation(Index: Integer);
    property CurrentConsultation: Integer read FCurrentConsultation;
    property CountConsultation: Integer read GetCountConsultation;
    property Waiting: Boolean read GetWaiting;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

var
  Historique: THistory;

implementation

uses
  MAJ, Main, Forms;

procedure THistory.AddConsultation(Consultation: TActionConsultation; Ref, Ref2: Integer);

  procedure Modifie;
  begin
    EditConsultation(Ref, Ref2);
  end;

  procedure Ajoute;
  begin
    Inc(FCurrentConsultation);
    SetLength(FListConsultation, FCurrentConsultation + 1);
    with FListConsultation[FCurrentConsultation] do begin
      Action := Consultation;
      Reference := Ref;
      Reference2 := Ref2;
    end;
  end;

begin
  with FListConsultation[FCurrentConsultation] do
    if not Bool(FLockCount) then begin
      if (FCurrentConsultation > -1) and (Consultation = Action) then begin
        if Consultation in MustRefresh then
          Modifie
        else if not (Consultation in CanRefresh) or (Reference <> Ref) or (Reference2 <> Ref2) then
          Ajoute;
      end
      else
        Ajoute;
    end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; Ref, Ref2: Integer);
var
  p: ^RConsult;
begin
  New(p);
  with RConsult(FListWaiting.Push(p)^) do begin
    Action := Consultation;
    Reference := Ref;
    Reference2 := Ref2;
  end;
end;

procedure THistory.Back;
begin
  if FCurrentConsultation > 0 then begin
    Dec(FCurrentConsultation);
    Refresh;
  end;
end;

procedure THistory.BackWaiting;
begin
  AddWaiting(fcActionBack);
end;

procedure THistory.Clear;
begin
  SetLength(FListConsultation, 1);
  First;
end;

constructor THistory.Create;
begin
  inherited;
  SetLength(FListConsultation, 0);
  FCurrentConsultation := -1;
  FLockCount := 0;
  FListWaiting := TConsultQueue.Create;
end;

procedure THistory.Delete(Index: Integer);
var
  i: Integer;
begin
  if (Index < 0) or (Index >= Length(FListConsultation)) then Exit;
  for i := Index + 1 to Pred(Length(FListConsultation)) do
    FListConsultation[i - 1] := FListConsultation[i];
  SetLength(FListConsultation, Length(FListConsultation) - 1);
end;

destructor THistory.Destroy;
begin
  SetLength(FListConsultation, 0);
  FreeAndNil(FListWaiting);
  inherited;
end;

procedure THistory.EditConsultation(Ref, Ref2: Integer);
begin
  with FListConsultation[FCurrentConsultation] do begin
    Reference := Ref;
    Reference2 := Ref2;
  end;
end;

procedure THistory.First;
begin
  FCurrentConsultation := 0;
  Refresh;
end;

function THistory.GetCountConsultation: Integer;
begin
  Result := Length(FListConsultation);
end;

function THistory.GetDescription(Index: Integer): string;
begin
  Result := FListConsultation[Index].Description;

  if Result = '' then
    if Index = FCurrentConsultation then begin
      FListConsultation[Index].Description := 'Ask: ' + FormatDateTime('c', Now);
      Result := FListConsultation[Index].Description;
    end
    else begin
      FListConsultation[Index].Description := 'Unknown: ' + FormatDateTime('c', Now);
      Result := FListConsultation[Index].Description;
    end;
end;

function THistory.GetWaiting: Boolean;
begin
  Result := Bool(FListWaiting.Count);
end;

procedure THistory.GoConsultation(Index: Integer);
begin
  if (Index < 0) or (Index >= Length(FListConsultation)) then Exit;
  FCurrentConsultation := Index;
  Refresh;
end;

procedure THistory.Last;
begin
  FCurrentConsultation := CountConsultation - 1;
  Refresh;
end;

procedure THistory.Lock;
begin
  Inc(FLockCount);
end;

procedure THistory.Next;
begin
  if Bool(CountConsultation) and (FCurrentConsultation < CountConsultation - 1) then begin
    Inc(FCurrentConsultation);
    Refresh;
  end;
end;

function THistory.Open(const Consult: RConsult; WithLock: Boolean): Boolean;
begin
  Result := True;
  if WithLock then Lock;
  try
    if not (Consult.Action in NoSaveHistorique) then
      AddConsultation(Consult.Action, Consult.Reference, Consult.Reference2);
    case Consult.Action of
      fcActionBack: Back;
      fcActionRefresh: Result := Open(FListConsultation[FCurrentConsultation], True);
      fcAlbum: Result := MAJConsultationAlbum(Consult.Reference);
      fcEmprunteur: Result := MAJConsultationEmprunteur(Consult.Reference);
      fcSerie: Result := MAJConsultationSerie(Consult.Reference);
      fcAuteur: Result := MAJConsultationAuteur(Consult.Reference);
      fcParaBD: Result := MAJConsultationParaBD(Consult.Reference);
      fcCouverture, fcImageParaBD: Result := ZoomCouverture(Consult.Action = fcImageParaBD, Consult.Reference, Consult.Reference2);
      fcRecherche: MAJRecherche(Consult.Reference, Consult.Reference2);
      fcStock: MAJStock;
      fcPreview: Fond.SetModalChildForm(TForm(Consult.Reference));
      fcSeriesIncompletes: MAJSeriesIncompletes;
      fcPrevisionsSorties: MAJPrevisionsSorties;
      fcRecreateToolBar: Fond.RechargeToolBar;
      fcPrevisionsAchats: MAJPrevisionsAchats;
      fcRefreshRepertoire: Fond.ActualiseRepertoire.Execute;
    end;
    if not Result then begin
      Delete(FCurrentConsultation);
      BackWaiting;
      Result := True;
    end;
  finally
    if WithLock then Unlock;
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure THistory.ProcessNext;
var
  p: ^RConsult;
begin
  p := FListWaiting.Pop;
  Open(p^, False);
  Dispose(p);
end;

procedure THistory.Refresh;
begin
  //  Open(FListConsultation[FCurrentConsultation], True);
  AddWaiting(fcActionRefresh);
end;

procedure THistory.SetDescription(Value: string);
begin
  FListConsultation[FCurrentConsultation].Description := Value;
end;

procedure THistory.Unlock;
begin
  if FLockCount > 0 then Dec(FLockCount);
end;

{ TConsultQueue }

procedure TConsultQueue.Clear;
begin
  while Bool(Count) do
    Dispose(Pop);
end;

destructor TConsultQueue.Destroy;
begin
  Clear;
  inherited;
end;

initialization
  Historique := THistory.Create;

finalization
  Historique.Free;

end.

