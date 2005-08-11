unit UHistorique;

interface

uses
  SysUtils, Windows, Contnrs;

type
  TFicheConsultation = (fcActionBack, fcActionRefresh, fcAlbum, fcEmprunteur, fcAuteur, fcCouverture, fcRecherche, fcStock, fcPreview, fcSeriesIncompletes, fcPrevisionsSorties, fcRecreateToolBar, fcPrevisionsAchats, fcRefreshRepertoire);

const
  NoSaveHistorique: set of TFicheConsultation = [fcActionBack, fcActionRefresh, fcPreview, fcRecreateToolBar, fcRefreshRepertoire];

type
  RConsult = record
    Fiche: TFicheConsultation;
    Reference, Reference2: Integer;
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
    function GetCountConsultation: Integer;
    procedure Open(const Consult: RConsult; WithLock: Boolean);
    procedure Lock;
    procedure Unlock;
    function GetWaiting: Boolean;
  published
    constructor Create;
    destructor Destroy; override;
  public
    procedure AddConsultation(Consultation: TFicheConsultation; Ref: Integer = -1; Ref2: Integer = -1);
    procedure EditConsultation(Ref: Integer = -1; Ref2: Integer = -1);
    procedure AddWaiting(Consultation: TFicheConsultation; Ref: Integer = -1; Ref2: Integer = -1);
    procedure Refresh;
    procedure Back;
    procedure BackWaiting;
    procedure Next;
    procedure Last;
    procedure First;
    procedure Clear;
    procedure ProcessNext;
    property CurrentConsultation: Integer read FCurrentConsultation;
    property CountConsultation: Integer read GetCountConsultation;
    property Waiting: Boolean read GetWaiting;
  end;

var
  Historique: THistory;

implementation

uses
  MAJ, Main, Forms;

procedure THistory.AddConsultation(Consultation: TFicheConsultation; Ref, Ref2: Integer);

  procedure Modifie;
  begin
    EditConsultation(Ref, Ref2);
  end;

  procedure Ajoute;
  begin
    Inc(FCurrentConsultation);
    SetLength(FListConsultation, FCurrentConsultation + 1);
    with FListConsultation[FCurrentConsultation] do begin
      Fiche := Consultation;
      Reference := Ref;
      Reference2 := Ref2;
    end;
  end;
begin
  if not Bool(FLockCount) then begin
    if (FCurrentConsultation > -1) and (Consultation = FListConsultation[FCurrentConsultation].Fiche) then
      case Consultation of
        fcRecherche, fcStock: Modifie;
        else
          Ajoute;
      end
    else
      Ajoute;
  end;
end;

procedure THistory.AddWaiting(Consultation: TFicheConsultation; Ref, Ref2: Integer);
var
  p: ^RConsult;
begin
  New(p);
  with RConsult(FListWaiting.Push(p)^) do begin
    Fiche := Consultation;
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

function THistory.GetWaiting: Boolean;
begin
  Result := Bool(FListWaiting.Count);
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

procedure THistory.Open(const Consult: RConsult; WithLock: Boolean);
begin
  if WithLock then Lock;
  try
    if not (Consult.Fiche in NoSaveHistorique) then
      AddConsultation(Consult.Fiche, Consult.Reference, Consult.Reference2);
    case Consult.Fiche of
      fcActionBack: Back;
      fcActionRefresh: Open(FListConsultation[FCurrentConsultation], True);
      fcAlbum: MAJConsultation(Consult.Reference);
      fcEmprunteur: MAJConsultationE(Consult.Reference);
      fcAuteur: MAJConsultationAuteur(Consult.Reference);
      fcCouverture: ZoomCouverture(Consult.Reference, Consult.Reference2);
      fcRecherche: MAJRecherche(Consult.Reference, Consult.Reference2);
      fcStock: MAJStock;
      fcPreview: Fond.SetModalChildForm(TForm(Consult.Reference));
      fcSeriesIncompletes: MAJSeriesIncompletes;
      fcPrevisionsSorties: MAJPrevisionsSorties;
      fcRecreateToolBar: Fond.RechargeToolBar;
      fcPrevisionsAchats: MAJPrevisionsAchats;
      fcRefreshRepertoire: Fond.ActualiseRepertoire.Execute;
    end;
  finally
    if WithLock then Unlock;
  end;
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
