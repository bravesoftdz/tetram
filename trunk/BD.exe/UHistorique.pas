unit UHistorique;

interface

uses
  SysUtils, Windows, Classes, Contnrs, Commun;

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
    ReferenceGUID, ReferenceGUID2: TGUID;
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
    procedure AddConsultation(const Consult: RConsult); overload;
    procedure EditConsultation(const Consult: RConsult); overload;
  published
    constructor Create;
    destructor Destroy; override;
  public
    procedure AddConsultation(Consultation: TActionConsultation); overload;
    procedure EditConsultation(const Ref: TGUID; Ref2: Integer); overload;
    procedure AddWaiting(Consultation: TActionConsultation; Ref: Integer = -1; Ref2: Integer = -1); overload;
    procedure AddWaiting(Consultation: TActionConsultation; const Ref: TGUID; Ref2: Integer = -1); overload;
    procedure AddWaiting(Consultation: TActionConsultation; const Ref, Ref2: TGUID); overload;

    procedure Refresh;
    procedure Back;
    procedure BackWaiting;
    procedure Next;
    procedure Last;
    procedure First;
    procedure Clear;
    procedure ProcessNext;
    function GetDescription(Index: Integer): string;
    procedure SetDescription(const Value: string);
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

procedure THistory.AddConsultation(const Consult: RConsult);

  procedure Modifie;
  begin
    EditConsultation(Consult);
  end;

  procedure Ajoute;
  begin
    Inc(FCurrentConsultation);
    SetLength(FListConsultation, FCurrentConsultation + 1);
    with FListConsultation[FCurrentConsultation] do begin
      Action := Consult.Action;
      Reference := Consult.Reference;
      ReferenceGUID := Consult.ReferenceGUID;
      Reference2 := Consult.Reference2;
      ReferenceGUID2 := Consult.ReferenceGUID2;
    end;
  end;

begin
  with FListConsultation[FCurrentConsultation] do
    if not Bool(FLockCount) then begin
      if (FCurrentConsultation > -1) and (Consult.Action = Action) then begin
        if Consult.Action in MustRefresh then
          Modifie
        else if not (Consult.Action in CanRefresh) or (Reference <> Consult.Reference) or (not IsEqualGUID(ReferenceGUID, Consult.ReferenceGUID)) or (Reference2 <> Consult.Reference2) or (not IsEqualGUID(ReferenceGUID2, Consult.ReferenceGUID2)) then
          Ajoute;
      end
      else
        Ajoute;
    end;
end;

procedure THistory.AddConsultation(Consultation: TActionConsultation);
var
  Consult: RConsult;
begin
  Consult.Action := Consultation;
  Consult.Reference := -1;
  Consult.ReferenceGUID := GUID_NULL;
  Consult.Reference2 := -1;
  Consult.ReferenceGUID2 := GUID_NULL;

  AddConsultation(Consult);
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; const Ref, Ref2: TGUID);
var
  p: ^RConsult;
begin
  New(p);
  with RConsult(FListWaiting.Push(p)^) do begin
    Action := Consultation;
    Reference := -1;
    ReferenceGUID := Ref;
    Reference2 := -1;
    ReferenceGUID2 := Ref2;
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
    ReferenceGUID := GUID_NULL;
    Reference2 := Ref2;
    ReferenceGUID2 := GUID_NULL;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; const Ref: TGUID; Ref2: Integer);
var
  p: ^RConsult;
begin
  New(p);
  with RConsult(FListWaiting.Push(p)^) do begin
    Action := Consultation;
    Reference := -1;
    ReferenceGUID := Ref;
    Reference2 := Ref2;
    ReferenceGUID2 := GUID_NULL;
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

procedure THistory.EditConsultation(const Consult: RConsult);
begin
  with FListConsultation[FCurrentConsultation] do begin
    Reference := Consult.Reference;
    ReferenceGUID := Consult.ReferenceGUID;
    Reference2 := Consult.Reference2;
    ReferenceGUID2 := Consult.ReferenceGUID2;
  end;
end;

procedure THistory.EditConsultation(const Ref: TGUID; Ref2: Integer);
var
  Consult: RConsult;
begin
  Consult.Reference := -1;
  Consult.ReferenceGUID := Ref;
  Consult.Reference2 := Ref2;
  Consult.ReferenceGUID2 := GUID_NULL;

  EditConsultation(Consult);
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
      AddConsultation(Consult);
    case Consult.Action of
      fcActionBack: Back;
      fcActionRefresh: Result := Open(FListConsultation[FCurrentConsultation], True);
      fcAlbum: Result := MAJConsultationAlbum(Consult.ReferenceGUID);
      fcEmprunteur: Result := MAJConsultationEmprunteur(Consult.ReferenceGUID);
      fcSerie: Result := MAJConsultationSerie(Consult.ReferenceGUID);
      fcAuteur: Result := MAJConsultationAuteur(Consult.ReferenceGUID);
      fcParaBD: Result := MAJConsultationParaBD(Consult.ReferenceGUID);
      fcCouverture, fcImageParaBD: Result := ZoomCouverture(Consult.Action = fcImageParaBD, Consult.ReferenceGUID, Consult.ReferenceGUID2);
      fcRecherche: MAJRecherche(Consult.ReferenceGUID, Consult.Reference2);
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

procedure THistory.SetDescription(const Value: string);
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

