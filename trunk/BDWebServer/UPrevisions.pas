unit UPrevisions;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, HTTPProd, WebAdapt, WebComp, Procedures, LoadComplet;

type
  TAdapterField = class(WebAdapt.TAdapterField);

  TInitialeType = (Chaine, Entier);

  RInitialeInfo = record
    Initiale: string;
    Count: Integer;
    Value: Variant;
  end;

  TPrevisions = class(TWebPageModule)
    PageProducer: TPageProducer;
    AnneesPassees: TPagedAdapter;
    APTome: TAdapterField;
    APRefSerie: TAdapterField;
    APTitreSerie: TAdapterField;
    APLibelle: TAdapterField;
    APLibelleCourt: TAdapterField;
    APAnnee: TAdapterField;
    AnneeEnCours: TPagedAdapter;
    ACRefSerie: TAdapterField;
    ACTome: TAdapterField;
    ACAnnee: TAdapterField;
    ACTitreSerie: TAdapterField;
    ACLibelle: TAdapterField;
    ACLibelleCourt: TAdapterField;
    AnneesProchaines: TPagedAdapter;
    prRefSerie: TAdapterField;
    prTome: TAdapterField;
    prAnnee: TAdapterField;
    prTitreSerie: TAdapterField;
    prLibelle: TAdapterField;
    prLibelleCourt: TAdapterField;
    procedure WebPageModuleCreate(Sender: TObject);
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
    procedure AnneesPasseesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AnneesPasseesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AnneesPasseesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AnneesPasseesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure APTomeGetValue(Sender: TObject; var Value: Variant);
    procedure APRefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
    procedure APTitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure APTitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure APTomeGetDisplayText(Sender: TObject; var Value: string);
    procedure APLibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure APLibelleCourtGetDisplayText(Sender: TObject; var Value: string);
    procedure APAnneeGetDisplayText(Sender: TObject; var Value: string);
    procedure APAnneeGetValue(Sender: TObject; var Value: Variant);
    procedure ACRefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure ACTomeGetValue(Sender: TObject; var Value: Variant);
    procedure ACTomeGetDisplayText(Sender: TObject; var Value: string);
    procedure ACAnneeGetValue(Sender: TObject; var Value: Variant);
    procedure ACAnneeGetDisplayText(Sender: TObject; var Value: string);
    procedure ACTitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure ACTitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure ACLibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure ACLibelleCourtGetDisplayText(Sender: TObject; var Value: string);
    procedure AnneeEnCoursGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AnneeEnCoursGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AnneeEnCoursGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AnneeEnCoursGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure AnneesProchainesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AnneesProchainesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AnneesProchainesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AnneesProchainesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure prRefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure prTomeGetDisplayText(Sender: TObject; var Value: string);
    procedure prTomeGetValue(Sender: TObject; var Value: Variant);
    procedure prAnneeGetValue(Sender: TObject; var Value: Variant);
    procedure prAnneeGetDisplayText(Sender: TObject; var Value: string);
    procedure prTitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure prTitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure prLibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure prLibelleCourtGetDisplayText(Sender: TObject; var Value: string);
  private
    { déclarations privées }
    FPrevisions: TPrevisionsSorties;
    FAnneesPasseesPosition, FAnneeEnCoursPosition, FAnneesProchainesPosition: Integer;
  public
    { déclarations publiques }
  end;

function Previsions: TPrevisions;

implementation

{$R *.dfm}

uses
  WebReq, WebCntxt, WebFact, Variants, DM_Princ, TypeRec, JvUIB, Commun,
  CommonConst, JvUIBLib;

function Previsions: TPrevisions;
begin
  Result := TPrevisions(WebContext.FindModuleClass(TPrevisions));
end;

procedure TPrevisions.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
end;

procedure TPrevisions.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
begin
  FPrevisions := TPrevisionsSorties.Create(Request.QueryFields.Values['AvecIntegrales'] = '1');
end;

procedure TPrevisions.WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
begin
  FreeAndNil(FPrevisions);
end;

procedure TPrevisions.AnneesPasseesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FAnneesPasseesPosition := 0;
  Eof := FAnneesPasseesPosition >= FPrevisions.AnneesPassees.Count;
end;

procedure TPrevisions.AnneesPasseesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FAnneesPasseesPosition >= FPrevisions.AnneesPassees.Count;
  if not Eof then Inc(FAnneesPasseesPosition);
end;

procedure TPrevisions.AnneesPasseesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FPrevisions.AnneesPassees.Count;
end;

procedure TPrevisions.AnneesPasseesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FAnneesPasseesPosition;
end;

procedure TPrevisions.AnneeEnCoursGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FAnneeEnCoursPosition := 0;
  Eof := FAnneeEnCoursPosition >= FPrevisions.AnneeEnCours.Count;
end;

procedure TPrevisions.AnneeEnCoursGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FAnneeEnCoursPosition >= FPrevisions.AnneeEnCours.Count;
  if not Eof then Inc(FAnneeEnCoursPosition);
end;

procedure TPrevisions.AnneeEnCoursGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FPrevisions.AnneeEnCours.Count;
end;

procedure TPrevisions.AnneeEnCoursGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FAnneeEnCoursPosition;
end;

procedure TPrevisions.AnneesProchainesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FAnneesProchainesPosition := 0;
  Eof := FAnneesProchainesPosition >= FPrevisions.AnneesProchaines.Count;
end;

procedure TPrevisions.AnneesProchainesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FAnneesProchainesPosition >= FPrevisions.AnneesProchaines.Count;
  if not Eof then Inc(FAnneesProchainesPosition);
end;

procedure TPrevisions.AnneesProchainesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FPrevisions.AnneesProchaines.Count;
end;

procedure TPrevisions.AnneesProchainesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FAnneesProchainesPosition;
end;

procedure TPrevisions.APTomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(APTome.Value));
end;

procedure TPrevisions.APTomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneesPassees[FAnneesPasseesPosition]).Tome;
end;

procedure TPrevisions.APRefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TPrevisionSortie(FPrevisions.AnneesPassees[FAnneesPasseesPosition]).Serie.ID);
end;

procedure TPrevisions.APTitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(APTitreSerie.Value));
end;

procedure TPrevisions.APTitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneesPassees[FAnneesPasseesPosition]).Serie.TitreSerie;
end;

procedure TPrevisions.APLibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := APLibelleCourt.AsFormatted;
  AjoutString(Value, APTome.AsFormatted + ' en ' + APAnnee.AsFormatted, ' - ');
end;

procedure TPrevisions.APLibelleCourtGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TPrevisionSortie(FPrevisions.AnneesPassees[FAnneesPasseesPosition]).Serie.ChaineAffichage(False));
end;

procedure TPrevisions.APAnneeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(APAnnee.Value);
end;

procedure TPrevisions.APAnneeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneesPassees[FAnneesPasseesPosition]).Annee;
end;

procedure TPrevisions.ACRefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TPrevisionSortie(FPrevisions.AnneeEnCours[FAnneeEnCoursPosition]).Serie.ID);
end;

procedure TPrevisions.ACTomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneeEnCours[FAnneeEnCoursPosition]).Tome;
end;

procedure TPrevisions.ACTomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(ACTome.Value));
end;

procedure TPrevisions.ACAnneeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneeEnCours[FAnneeEnCoursPosition]).Annee;
end;

procedure TPrevisions.ACAnneeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(ACAnnee.Value);
end;

procedure TPrevisions.ACTitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneeEnCours[FAnneeEnCoursPosition]).Serie.TitreSerie;
end;

procedure TPrevisions.ACTitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(ACTitreSerie.Value));
end;

procedure TPrevisions.ACLibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := ACLibelleCourt.AsFormatted;
  AjoutString(Value, ACTome.AsFormatted + ' en ' + ACAnnee.AsFormatted, ' - ');
end;

procedure TPrevisions.ACLibelleCourtGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TPrevisionSortie(FPrevisions.AnneeEnCours[FAnneeEnCoursPosition]).Serie.ChaineAffichage(False));
end;

procedure TPrevisions.prRefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TPrevisionSortie(FPrevisions.AnneesProchaines[FAnneesProchainesPosition]).Serie.ID);
end;

procedure TPrevisions.prTomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(prTome.Value));
end;

procedure TPrevisions.prTomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneesProchaines[FAnneesProchainesPosition]).Tome;
end;

procedure TPrevisions.prAnneeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneesProchaines[FAnneesProchainesPosition]).Annee;
end;

procedure TPrevisions.prAnneeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TPrevisionSortie(FPrevisions.AnneesProchaines[FAnneesProchainesPosition]).sAnnee);
end;

procedure TPrevisions.prTitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(prTitreSerie.Value));
end;

procedure TPrevisions.prTitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TPrevisionSortie(FPrevisions.AnneesProchaines[FAnneesProchainesPosition]).Serie.TitreSerie;
end;

procedure TPrevisions.prLibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := prLibelleCourt.AsFormatted;
  AjoutString(Value, prTome.AsFormatted + ' en ' + prAnnee.AsFormatted, ' - ');
end;

procedure TPrevisions.prLibelleCourtGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TPrevisionSortie(FPrevisions.AnneesProchaines[FAnneesProchainesPosition]).Serie.ChaineAffichage(False));
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TPrevisions, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caCache));

end.
