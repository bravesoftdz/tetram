unit UManquants;

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

  TManquants = class(TWebPageModule)
    PageProducer: TPageProducer;
    Albums: TPagedAdapter;
    Tome: TAdapterField;
    RefSerie: TAdapterField;
    TitreSerie: TAdapterField;
    Libelle: TAdapterField;
    LibelleCourt: TAdapterField;
    Numeros: TAdapterField;
    procedure WebPageModuleCreate(Sender: TObject);
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
    procedure AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure TomeGetValue(Sender: TObject; var Value: Variant);
    procedure RefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
    procedure TitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure TitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure TomeGetDisplayText(Sender: TObject; var Value: string);
    procedure LibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure LibelleCourtGetDisplayText(Sender: TObject; var Value: string);
    procedure NumerosGetDisplayText(Sender: TObject; var Value: string);
    procedure NumerosGetValue(Sender: TObject; var Value: Variant);
  private
    { déclarations privées }
    FSeriesIncompletes: TSeriesIncompletes;
    FSeriePosition: Integer;
  public
    { déclarations publiques }
  end;

function Manquants: TManquants;

implementation

{$R *.dfm}

uses
  WebReq, WebCntxt, WebFact, Variants, DM_Princ, TypeRec, JvUIB, Commun,
  CommonConst, JvUIBLib;

function Manquants: TManquants;
begin
  Result := TManquants(WebContext.FindModuleClass(TManquants));
end;

procedure TManquants.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
end;

procedure TManquants.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
begin
  FSeriesIncompletes := TSeriesIncompletes.Create(Request.QueryFields.Values['AvecIntegrales'] = '1', Request.QueryFields.Values['AvecAchats'] = '1');
end;

procedure TManquants.WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
begin
  FreeAndNil(FSeriesIncompletes);
end;

procedure TManquants.AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FSeriePosition := 0;
  Eof := FSeriePosition >= FSeriesIncompletes.Series.Count;
end;

procedure TManquants.AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FSeriePosition >= FSeriesIncompletes.Series.Count;
  if not Eof then Inc(FSeriePosition);
end;

procedure TManquants.AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FSeriesIncompletes.Series.Count;
end;

procedure TManquants.AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FSeriePosition;
end;

procedure TManquants.TomeGetDisplayText(Sender: TObject; var Value: string);
begin
  //  Value := NonZero(IntToStr(Tome.Value));
end;

procedure TManquants.TomeGetValue(Sender: TObject; var Value: Variant);
begin
  //  Value := FListe.Series[FSeriePosition].NumerosManquants[FNumeroPositon];
end;

procedure TManquants.RefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TSerieIncomplete(FSeriesIncompletes.Series[FSeriePosition]).Serie.ID);
end;

procedure TManquants.TitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TSerieIncomplete(FSeriesIncompletes.Series[FSeriePosition]).Serie.TitreSerie));
end;

procedure TManquants.TitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TSerieIncomplete(FSeriesIncompletes.Series[FSeriePosition]).Serie.TitreSerie;
end;

procedure TManquants.LibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := LibelleCourt.AsFormatted;
  AjoutString(Value, Numeros.AsFormatted, ' - ');
end;

procedure TManquants.LibelleCourtGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TSerieIncomplete(FSeriesIncompletes.Series[FSeriePosition]).Serie.ChaineAffichage(False));
end;

procedure TManquants.NumerosGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(Numeros.Value);
end;

procedure TManquants.NumerosGetValue(Sender: TObject; var Value: Variant);
var
  i: Integer;
  s, s2: string;
begin
  s2 := '';
  with TSerieIncomplete(FSeriesIncompletes.Series[FSeriePosition]) do begin
    for i := 0 to NumerosManquants.Count - 1 do begin
      s := NumerosManquants[i];
      if Pos('<>', s) <> 0 then s := StringReplace(s, '<>', ' à ', []);
      AjoutString(s2, s, ' - ');
    end;
  end;
  Value := s2;
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TManquants, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caCache));

end.
