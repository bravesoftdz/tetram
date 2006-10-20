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
  RConsult = class
    Action: TActionConsultation;
    ReferenceGUID, ReferenceGUID2: TGUID;
    Reference, Reference2: Integer;
    Description: string;
    Stream: TMemoryStream;

    constructor Create;
    destructor Destroy; override;

    procedure Assign(Consult: RConsult);
  end;

  THistory = class
  private
    FListConsultation: TObjectList;
    FCurrentConsultation: Integer;
    FLockCount: Integer;
    FListWaiting: TObjectList;
    FOnChange: TNotifyEvent;
    function GetCountConsultation: Integer;
    function Open(const Consult: RConsult; WithLock: Boolean): Boolean;
    procedure Lock;
    procedure Unlock;
    function GetWaiting: Boolean;
    procedure Delete(Index: Integer);
    procedure AddConsultation(const Consult: RConsult); overload;
    procedure EditConsultation(Consult: RConsult); overload;
    function GetCurrentConsult: RConsult;
  published
    constructor Create;
    destructor Destroy; override;
  public
    procedure AddConsultation(Consultation: TActionConsultation); overload;
    procedure EditConsultation(const Ref: TGUID; Ref2: Integer); overload;
    procedure EditConsultation(Stream: TStream); overload;
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
    property CurrentConsult: RConsult read GetCurrentConsult;
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
    FListConsultation.Count := FCurrentConsultation + 1;
    if not Assigned(FListConsultation[FCurrentConsultation]) then
      FListConsultation[FCurrentConsultation] := RConsult.Create;
    Modifie;
  end;

begin
  if not Bool(FLockCount) then begin
    if (FCurrentConsultation > -1) and (Consult.Action = CurrentConsult.Action) then
      with CurrentConsult do begin
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
  Consult := RConsult.Create;
  try
    Consult.Action := Consultation;
    Consult.Reference := -1;
    Consult.ReferenceGUID := GUID_NULL;
    Consult.Reference2 := -1;
    Consult.ReferenceGUID2 := GUID_NULL;
    Consult.Stream.Size := 0;

    AddConsultation(Consult);
  finally
    Consult.Free;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; const Ref, Ref2: TGUID);
begin
  FListWaiting.Add(RConsult.Create);
  with RConsult(FListWaiting.Last) do begin
    Action := Consultation;
    Reference := -1;
    ReferenceGUID := Ref;
    Reference2 := -1;
    ReferenceGUID2 := Ref2;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; Ref, Ref2: Integer);
begin
  FListWaiting.Add(RConsult.Create);
  with RConsult(FListWaiting.Last) do begin
    Action := Consultation;
    Reference := Ref;
    ReferenceGUID := GUID_NULL;
    Reference2 := Ref2;
    ReferenceGUID2 := GUID_NULL;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; const Ref: TGUID; Ref2: Integer);
begin
  FListWaiting.Add(RConsult.Create);
  with RConsult(FListWaiting.Last) do begin
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
  FListConsultation.Count := 1;
  First;
end;

constructor THistory.Create;
begin
  inherited;
  FListConsultation := TObjectList.Create(True);
  FCurrentConsultation := -1;
  FLockCount := 0;
  FListWaiting := TObjectList.Create(True);
end;

procedure THistory.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FListConsultation.Count) then Exit;
  FListConsultation.Delete(Index);
end;

destructor THistory.Destroy;
begin
  FreeAndNil(FListConsultation);
  FreeAndNil(FListWaiting);
  inherited;
end;

procedure THistory.EditConsultation(Consult: RConsult);
begin
  CurrentConsult.Assign(Consult);
end;

procedure THistory.EditConsultation(const Ref: TGUID; Ref2: Integer);
begin
  CurrentConsult.Reference := -1;
  CurrentConsult.ReferenceGUID := Ref;
  CurrentConsult.Reference2 := Ref2;
  CurrentConsult.ReferenceGUID2 := GUID_NULL;
  CurrentConsult.Stream.Size := 0;
end;

procedure THistory.EditConsultation(Stream: TStream);
begin
  CurrentConsult.Reference := -1;
  CurrentConsult.ReferenceGUID := GUID_NULL;
  CurrentConsult.Reference2 := -1;
  CurrentConsult.ReferenceGUID2 := GUID_NULL;
  CurrentConsult.Stream.Size := 0;
  CurrentConsult.Stream.CopyFrom(Stream, 0);
end;

procedure THistory.First;
begin
  FCurrentConsultation := 0;
  Refresh;
end;

function THistory.GetCountConsultation: Integer;
begin
  Result := FListConsultation.Count;
end;

function THistory.GetCurrentConsult: RConsult;
begin
  Result := RConsult(FListConsultation[FCurrentConsultation]);
end;

function THistory.GetDescription(Index: Integer): string;
var
  Consult: RConsult;
begin
  Consult := RConsult(FListConsultation[Index]);

  Result := Consult.Description;

  if Result = '' then
    if Index = FCurrentConsultation then begin
      Consult.Description := 'Ask: ' + FormatDateTime('c', Now);
      Result := Consult.Description;
    end
    else begin
      Consult.Description := 'Unknown: ' + FormatDateTime('c', Now);
      Result := Consult.Description;
    end;
end;

function THistory.GetWaiting: Boolean;
begin
  Result := Bool(FListWaiting.Count);
end;

procedure THistory.GoConsultation(Index: Integer);
begin
  if (Index < 0) or (Index >= FListConsultation.Count) then Exit;
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
      fcActionRefresh: Result := Open(CurrentConsult, True);
      fcAlbum: Result := MAJConsultationAlbum(Consult.ReferenceGUID);
      fcEmprunteur: Result := MAJConsultationEmprunteur(Consult.ReferenceGUID);
      fcSerie: Result := MAJConsultationSerie(Consult.ReferenceGUID);
      fcAuteur: Result := MAJConsultationAuteur(Consult.ReferenceGUID);
      fcParaBD: Result := MAJConsultationParaBD(Consult.ReferenceGUID);
      fcCouverture, fcImageParaBD: Result := ZoomCouverture(Consult.Action = fcImageParaBD, Consult.ReferenceGUID, Consult.ReferenceGUID2);
      fcRecherche: MAJRecherche(Consult.ReferenceGUID, Consult.Reference2, Consult.Stream);
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
begin
  if FListWaiting.Count = 0 then Exit;
  Open(RConsult(FListWaiting.First), False);
  FListWaiting.Delete(0);
end;

procedure THistory.Refresh;
begin
  //  Open(FListConsultation[FCurrentConsultation], True);
  AddWaiting(fcActionRefresh);
end;

procedure THistory.SetDescription(const Value: string);
begin
  CurrentConsult.Description := Value;
end;

procedure THistory.Unlock;
begin
  if FLockCount > 0 then Dec(FLockCount);
end;

{ RConsult }

procedure RConsult.Assign(Consult: RConsult);
begin
  Action := Consult.Action;
  ReferenceGUID := Consult.ReferenceGUID;
  ReferenceGUID2 := Consult.ReferenceGUID2;
  Reference := Consult.Reference;
  Reference2 := Consult.Reference2;
  Description := Consult.Description;
  Stream.Position := 0;
  Stream.CopyFrom(Consult.Stream, 0);
end;

constructor RConsult.Create;
begin
  Stream := TMemoryStream.Create;
end;

destructor RConsult.Destroy;
begin
  Stream.Free;
  inherited;
end;

initialization
  Historique := THistory.Create;

finalization
  Historique.Free;

end.

