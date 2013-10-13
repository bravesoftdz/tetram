unit UHistorique;

interface

uses SysUtils, Windows, Classes, Contnrs, Commun;

type
  TActionConsultation = (fcActionBack, fcActionRefresh, fcAlbum, fcAuteur, fcCouverture, fcRecherche, fcPreview, fcSeriesIncompletes,
    fcPrevisionsSorties, fcRecreateToolBar, fcPrevisionsAchats, fcRefreshRepertoire, fcRefreshRepertoireData, fcParaBD, fcImageParaBD, fcSerie, fcGestionAjout,
    fcGestionModif, fcGestionSupp, fcGestionAchat, fcScripts, fcConflitImport, fcGallerie, fcModeConsultation, fcModeGestion, fcModeScript, fcUnivers);

type
  TConsultCallback = procedure(Data: Pointer);

  TConsult = class
  strict private
    FDescription: string;
    procedure SetDescription(const Value: string);
  public
    Action: TActionConsultation;
    ReferenceGUID, ReferenceGUID2: TGUID;
    Reference, Reference2: Integer;
    Data: Pointer;
    Stream: TMemoryStream;

    GestionCallback: TConsultCallback;
    GestionCallbackData: Pointer;

    GestionProc, GestionVTV: Pointer;
    GestionValeur: string;

    constructor Create;
    destructor Destroy; override;

    procedure Assign(Consult: TConsult);
    function CommandLine: string;
    property Description: string read FDescription write SetDescription;
  end;

  THistoriqueChange = procedure(Sender: TObject; LastAction: TConsult) of object;

  THistory = class
  strict private
    FListConsultation: TObjectList;
    FCurrentConsultation: Integer;
    FLockCount: Integer;
    FListWaiting: TObjectList;
    FOnChange: THistoriqueChange;
    function GetCountConsultation: Integer;
    function Open(Consult: TConsult; WithLock: Boolean): Boolean;
    procedure Lock;
    procedure Unlock;
    function GetWaiting: Boolean;
    procedure Delete(index: Integer);
    procedure AddConsultation(Consult: TConsult); overload;
    procedure EditConsultation(Consult: TConsult); overload;
    function GetCurrentConsult: TConsult;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddConsultation(Consultation: TActionConsultation); overload;
    procedure EditConsultation(const Ref: TGUID; Ref2: Integer); overload;
    procedure EditConsultation(Stream: TStream); overload;
    procedure AddWaiting(Consultation: TActionConsultation; Ref: Integer = -1; Ref2: Integer = -1); overload;
    procedure AddWaiting(Consultation: TActionConsultation; const Ref: TGUID; Ref2: Integer = -1); overload;
    procedure AddWaiting(Consultation: TActionConsultation; const Ref, Ref2: TGUID); overload;
    procedure AddWaiting(Consultation: TActionConsultation; Callback: TConsultCallback; CallbackData, Proc, VTV: Pointer; const Valeur: string = ''); overload;
    procedure AddWaiting(Consultation: TActionConsultation; Callback: TConsultCallback; CallbackData, Proc, VTV: Pointer; const Ref: TGUID;
      const Valeur: string = ''); overload;

    procedure Refresh;
    procedure Back;
    procedure BackWaiting;
    procedure Next;
    procedure Last;
    procedure First;
    procedure Clear;
    procedure ProcessNext;
    function GetDescription(index: Integer): string;
    procedure SetDescription(const Value: string);
    procedure GoConsultation(index: Integer);
    property CurrentConsultation: Integer read FCurrentConsultation;
    property CurrentConsult: TConsult read GetCurrentConsult;
    property CountConsultation: Integer read GetCountConsultation;
    property Waiting: Boolean read GetWaiting;
    property OnChange: THistoriqueChange read FOnChange write FOnChange;
  end;

var
  Historique: THistory;

procedure RefreshCallBack(Data: Pointer);

implementation

uses MAJ, UfrmFond, Forms, Proc_Gestions;

const
  UsedInGestion = [fcGestionAjout, fcGestionModif, fcGestionSupp, fcGestionAchat, fcScripts, fcConflitImport];
  Modes = [fcModeConsultation, fcModeGestion, fcModeScript];
  NoSaveHistorique = [fcActionBack, fcActionRefresh, fcPreview, fcRecreateToolBar, fcRefreshRepertoire, fcRefreshRepertoireData]
  // à cause des callback, les appels de gestion ne peuvent pas être sauvés dans l'historique
  // et puis je vois pas bien à quoi ça pourrait servir
    + UsedInGestion + Modes;
  CanRefresh = [fcAlbum, fcAuteur, fcSeriesIncompletes, fcPrevisionsSorties, fcPrevisionsAchats, fcGallerie, fcUnivers];
  MustRefresh = [fcRecherche];

procedure RefreshCallBack(Data: Pointer);
begin
  Historique.Refresh;
end;

procedure THistory.AddConsultation(Consult: TConsult);

  procedure Modifie;
  begin
    EditConsultation(Consult);
  end;

  procedure Ajoute;
  begin
    Inc(FCurrentConsultation);
    FListConsultation.Count := FCurrentConsultation + 1;
    if not Assigned(FListConsultation[FCurrentConsultation]) then
      FListConsultation[FCurrentConsultation] := TConsult.Create;
    Modifie;
  end;

begin
  if not LongBool(FLockCount) then
  begin
    if (FCurrentConsultation > -1) and (Consult.Action = CurrentConsult.Action) then
      with CurrentConsult do
      begin
        if Consult.Action in MustRefresh then
          Modifie
        else if not(Consult.Action in CanRefresh) or (Reference <> Consult.Reference) or (not IsEqualGUID(ReferenceGUID, Consult.ReferenceGUID)) or
          (Reference2 <> Consult.Reference2) or (not IsEqualGUID(ReferenceGUID2, Consult.ReferenceGUID2)) then
          Ajoute;
      end
    else
      Ajoute;
  end;
end;

procedure THistory.AddConsultation(Consultation: TActionConsultation);
var
  Consult: TConsult;
begin
  Consult := TConsult.Create;
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
  FListWaiting.Add(TConsult.Create);
  with TConsult(FListWaiting.Last) do
  begin
    Action := Consultation;
    Reference := -1;
    ReferenceGUID := Ref;
    Reference2 := -1;
    ReferenceGUID2 := Ref2;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; Ref, Ref2: Integer);
begin
  FListWaiting.Add(TConsult.Create);
  with TConsult(FListWaiting.Last) do
  begin
    Action := Consultation;
    Reference := Ref;
    ReferenceGUID := GUID_NULL;
    Reference2 := Ref2;
    ReferenceGUID2 := GUID_NULL;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; const Ref: TGUID; Ref2: Integer);
begin
  FListWaiting.Add(TConsult.Create);
  with TConsult(FListWaiting.Last) do
  begin
    Action := Consultation;
    Reference := -1;
    ReferenceGUID := Ref;
    Reference2 := Ref2;
    ReferenceGUID2 := GUID_NULL;
  end;
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; Callback: TConsultCallback; CallbackData, Proc, VTV: Pointer; const Valeur: string);
begin
  AddWaiting(Consultation, Callback, CallbackData, Proc, VTV, GUID_NULL, Valeur);
end;

procedure THistory.AddWaiting(Consultation: TActionConsultation; Callback: TConsultCallback; CallbackData, Proc, VTV: Pointer; const Ref: TGUID;
  const Valeur: string);
begin
  FListWaiting.Add(TConsult.Create);
  with TConsult(FListWaiting.Last) do
  begin
    Action := Consultation;

    ReferenceGUID := Ref;

    GestionCallback := Callback;
    GestionCallbackData := CallbackData;

    GestionProc := Proc;
    GestionVTV := VTV;
    GestionValeur := Valeur;
  end;
end;

procedure THistory.Back;
begin
  if FCurrentConsultation > 0 then
  begin
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

procedure THistory.Delete(index: Integer);
begin
  if (index < 0) or (index >= FListConsultation.Count) then
    Exit;
  FListConsultation.Delete(index);
end;

destructor THistory.Destroy;
begin
  FreeAndNil(FListConsultation);
  FreeAndNil(FListWaiting);
  inherited;
end;

procedure THistory.EditConsultation(Consult: TConsult);
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

function THistory.GetCurrentConsult: TConsult;
begin
  Result := TConsult(FListConsultation[FCurrentConsultation]);
end;

function THistory.GetDescription(index: Integer): string;
var
  Consult: TConsult;
begin
  Consult := TConsult(FListConsultation[index]);

  Result := Consult.Description;

  if Result = '' then
    if index = FCurrentConsultation then
    begin
      Consult.Description := 'Ask: ' + FormatDateTime('c', Now);
      Result := Consult.Description;
    end
    else
    begin
      Consult.Description := 'Unknown: ' + FormatDateTime('c', Now);
      Result := Consult.Description;
    end;
end;

function THistory.GetWaiting: Boolean;
begin
  Result := LongBool(FListWaiting.Count);
end;

procedure THistory.GoConsultation(index: Integer);
begin
  if (index < 0) or (index >= FListConsultation.Count) then
    Exit;
  FCurrentConsultation := index;
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
  if (CountConsultation > 0) and (FCurrentConsultation < CountConsultation - 1) then
  begin
    Inc(FCurrentConsultation);
    Refresh;
  end;
end;

function THistory.Open(Consult: TConsult; WithLock: Boolean): Boolean;
var
  doCallback: Boolean;
begin
  Result := True;
  doCallback := False;
  if WithLock then
    Lock;
  try
    if not(Consult.Action in NoSaveHistorique) then
      AddConsultation(Consult);
    // if (Consult.Action in UsedInGestion) then
    // frmFond.actModeGestion.Execute;
    case Consult.Action of
      fcModeConsultation:
        frmFond.actModeConsultation.Execute;
      fcModeGestion:
        frmFond.actModeGestion.Execute;
      fcModeScript:
        frmFond.actModeScripts.Execute;
      fcActionBack:
        Back;
      fcActionRefresh:
        Result := Open(CurrentConsult, True);
      fcAlbum:
        Result := MAJConsultationAlbum(Consult.ReferenceGUID);
      fcSerie:
        Result := MAJConsultationSerie(Consult.ReferenceGUID);
      fcAuteur:
        Result := MAJConsultationAuteur(Consult.ReferenceGUID);
      fcUnivers:
        Result := MAJConsultationUnivers(Consult.ReferenceGUID);
      fcParaBD:
        Result := MAJConsultationParaBD(Consult.ReferenceGUID);
      fcCouverture, fcImageParaBD:
        Result := ZoomCouverture(Consult.Action = fcImageParaBD, Consult.ReferenceGUID, Consult.ReferenceGUID2);
      fcRecherche:
        MAJRecherche(Consult.ReferenceGUID, Consult.Reference2, Consult.Stream);
      fcPreview:
        frmFond.SetModalChildForm(TForm(Consult.Reference));
      fcGallerie:
        Result := MAJGallerie(Consult.Reference2, Consult.ReferenceGUID);
      fcSeriesIncompletes:
        MAJSeriesIncompletes;
      fcPrevisionsSorties:
        MAJPrevisionsSorties;
      fcRecreateToolBar:
        frmFond.RechargeToolBar;
      fcPrevisionsAchats:
        MAJPrevisionsAchats;
      fcRefreshRepertoire:
        frmFond.actActualiseRepertoire.Execute;
      fcRefreshRepertoireData:
        frmFond.actActualiseRepertoireData;
      fcScripts:
        if Assigned(Consult.GestionCallback) then
          doCallback := MAJScript(Consult.GestionVTV)
        else
          MAJScript(nil);
      fcConflitImport:
        frmFond.SetModalChildForm(TForm(Consult.Reference));

      fcGestionAjout:
        if not IsEqualGUID(GUID_NULL, Consult.ReferenceGUID) then
          doCallback := not IsEqualGUID(GUID_NULL, TActionGestionAddWithRef(Consult.GestionProc)(Consult.GestionVTV, Consult.ReferenceGUID,
            Consult.GestionValeur))
        else
          doCallback := not IsEqualGUID(GUID_NULL, TActionGestionAdd(Consult.GestionProc)(Consult.GestionVTV, Consult.GestionValeur));
      fcGestionModif:
        if IsEqualGUID(Consult.ReferenceGUID, GUID_NULL) then
          doCallback := TActionGestionModif(Consult.GestionProc)(Consult.GestionVTV)
        else
          doCallback := TActionGestionModif2(Consult.GestionProc)(Consult.ReferenceGUID);
      fcGestionSupp:
        doCallback := TActionGestionSupp(Consult.GestionProc)(Consult.GestionVTV);
      fcGestionAchat:
        doCallback := TActionGestionAchat(Consult.GestionProc)(Consult.GestionVTV);
    end;
    if doCallback then
    begin
      if Assigned(Consult.GestionCallback) then
        Consult.GestionCallback(Consult.GestionCallbackData);
      AddWaiting(fcRefreshRepertoire);
    end;

    if not Result then
    begin
      Delete(FCurrentConsultation);
      BackWaiting;
      Result := True;
    end;
  finally
    if WithLock then
      Unlock;
  end;
  if Assigned(FOnChange) and not(Consult.Action in NoSaveHistorique) then
    FOnChange(Self, Consult);
end;

procedure THistory.ProcessNext;
var
  Consult: TConsult;
begin
  if FListWaiting.Count = 0 then
    Exit;
  Consult := TConsult(FListWaiting.Extract(FListWaiting.First));
  try
    Open(Consult, False);
  finally
    Consult.Free;
  end;
end;

procedure THistory.Refresh;
begin
  // Open(FListConsultation[FCurrentConsultation], True);
  AddWaiting(fcActionRefresh);
end;

procedure THistory.SetDescription(const Value: string);
begin
  CurrentConsult.Description := Value;
end;

procedure THistory.Unlock;
begin
  if FLockCount > 0 then
    Dec(FLockCount);
end;

{ RConsult }

procedure TConsult.Assign(Consult: TConsult);
begin
  Action := Consult.Action;
  ReferenceGUID := Consult.ReferenceGUID;
  ReferenceGUID2 := Consult.ReferenceGUID2;
  Reference := Consult.Reference;
  Reference2 := Consult.Reference2;
  FDescription := Consult.FDescription;
  Stream.Position := 0;
  Stream.CopyFrom(Consult.Stream, 0);
  Data := Consult.Data;
end;

function TConsult.CommandLine: string;
begin
  case Action of
    fcAlbum:
      Result := '/album=' + GUIDToString(ReferenceGUID);
    fcSerie:
      Result := '/serie=' + GUIDToString(ReferenceGUID);
    fcAuteur:
      Result := '/auteur=' + GUIDToString(ReferenceGUID);
  else
    Result := '';
  end;
end;

constructor TConsult.Create;
begin
  inherited;
  Stream := TMemoryStream.Create;
  Data := nil;
end;

destructor TConsult.Destroy;
begin
  Stream.Free;
  inherited;
end;

procedure TConsult.SetDescription(const Value: string);
begin
  FDescription := Value;
  if Assigned(Historique.OnChange) then
    Historique.OnChange(Historique, Self);
end;

initialization

Historique := THistory.Create;

finalization

Historique.Free;

end.
