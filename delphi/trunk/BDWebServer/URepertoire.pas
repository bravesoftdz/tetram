unit URepertoire;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, HTTPProd, WebAdapt, WebComp, Procedures,
  DB, JvUIBDataSet, DBAdapt, VirtualTree;

type
  TAdapterField = class(WebAdapt.TAdapterField);

  TRepertoire = class(TWebPageModule)
    PageProducer: TPageProducer;
    Initiales: TPagedAdapter;
    Albums: TPagedAdapter;
    Initiale: TAdapterField;
    Count: TAdapterField;
    RefAlbum: TAdapterField;
    TitreAlbum: TAdapterField;
    HorsSerie: TAdapterBooleanField;
    Tome: TAdapterField;
    RefSerie: TAdapterField;
    Integrale: TAdapterBooleanField;
    TitreSerie: TAdapterField;
    Libelle: TAdapterField;
    LibelleCourt: TAdapterField;
    UsedGroupBy: TAdapterField;
    procedure WebPageModuleCreate(Sender: TObject);
    procedure WebPageModuleDestroy(Sender: TObject);
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
    procedure InitialesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure InitialesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure InitialesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure InitialesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure InitialeGetValue(Sender: TObject; var Value: Variant);
    procedure CountGetValue(Sender: TObject; var Value: Variant);
    procedure RefAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure HorsSerieGetValue(Sender: TObject; var Value: Boolean);
    procedure TomeGetValue(Sender: TObject; var Value: Variant);
    procedure RefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
    procedure WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
    procedure IntegraleGetValue(Sender: TObject; var Value: Boolean);
    procedure TitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure TitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure TomeGetDisplayText(Sender: TObject; var Value: string);
    procedure LibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure LibelleCourtGetDisplayText(Sender: TObject; var Value: string);
    procedure InitialeGetDisplayText(Sender: TObject; var Value: string);
    procedure UsedGroupByGetValue(Sender: TObject; var Value: Variant);
    procedure UsedGroupByGetDisplayText(Sender: TObject; var Value: string);
  private
    { déclarations privées }
    FListInitiales: array of RInitialeInfo;
    FListAlbums: TList;
    FInitialesPosition, FAlbumsPosition, FLastGroupBy: Integer;
    sLastInitiale: string[38];
  public
    { déclarations publiques }
  end;

function Repertoire: TRepertoire;

implementation

{$R *.dfm}

uses
  WebReq, WebCntxt, WebFact, Variants, DM_Princ, TypeRec, JvUIB, Commun,
  CommonConst, JvUIBLib;

function WSVirtualMode(Value: Integer): TVirtualMode;
begin
  case Value of
    0: Result := vmAlbums;
    1: Result := vmAlbumsAnnee;
    2: Result := vmAlbumsCollection;
    3: Result := vmAlbumsEditeur;
    4: Result := vmAlbumsGenre;
    5: Result := vmAlbumsSerie;
    else
      Result := vmAlbums;
  end
end;

function Repertoire: TRepertoire;
begin
  Result := TRepertoire(WebContext.FindModuleClass(TRepertoire));
end;

procedure TRepertoire.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
  FListAlbums := TList.Create;
  sLastInitiale := '';
  FLastGroupBy := -1;
end;

procedure TRepertoire.WebPageModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FListAlbums);
  FreeAndNil(FListInitiales);
end;

procedure TRepertoire.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
var
  Query: TJvUIBQuery;
  Modele: string;
  ModeInfo: RModeInfo;
  i: Integer;
begin
  FLastGroupBy := StrToIntDef(Request.QueryFields.Values['GroupBy'], 0);
  ModeInfo := vmModeInfos[WSVirtualMode(FLastGroupBy)];
  Modele := Request.QueryFields.Values['Modele'];
  if Modele <> '' then
    PageProducer.HTMLFile := WebServerPath + Modele + '.html'
  else
    PageProducer.HTMLFile := WebServerPath + PageName + '.html';

  FInitialesPosition := 0;
  FAlbumsPosition := 0;

  Query := TJvUIBQuery.Create(Self);
  with Query do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT Count(*) FROM ' + ModeInfo.FILTRECOUNT;
    Open;
    SetLength(FListInitiales, Fields.AsInteger[0]);

    SQL.Text := 'SELECT * FROM ' + ModeInfo.FILTRECOUNT;
    Open;
    if Request.QueryFields.Values['initiale'] <> '' then
      sLastInitiale := Request.QueryFields.Values['initiale'];
    if not Eof then begin
      if (sLastInitiale = '') then sLastInitiale := Fields.ByNameAsString[ModeInfo.INITIALEVALUE];
    end;
    i := 0;
    while not Eof do begin
      FListInitiales[i].Count := Fields.AsInteger[1];
      FListInitiales[i].Initiale := Fields.AsString[0];
      if WSVirtualMode(FLastGroupBy) in [vmAlbumsSerie, vmAlbumsEditeur, vmAlbumsCollection] then
        FListInitiales[i].Initiale := FormatTitre(FListInitiales[i].Initiale);
      FListInitiales[i].Value := Fields.ByNameAsString[ModeInfo.INITIALEVALUE];
      Inc(i);
      Next;
    end;

    if (sLastInitiale <> '') then begin
      SQL.Text := 'SELECT ' + ModeInfo.FIELDS + ' FROM ' + ModeInfo.FILTRE;
      Params.AsString[0] := sLastInitiale;
      Open;
      while not Eof do begin
        FListAlbums.Add(TAlbum.Make(Query));
        Next;
      end;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TRepertoire.WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
begin
  SetLength(FListInitiales, 0);
  TAlbum.VideListe(FListAlbums);
end;

procedure TRepertoire.InitialesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FInitialesPosition := 0;
  Eof := FInitialesPosition >= Length(FListInitiales);
end;

procedure TRepertoire.InitialesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FInitialesPosition >= Length(FListInitiales);
  if not Eof then Inc(FInitialesPosition);
end;

procedure TRepertoire.InitialesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := Length(FListInitiales);
end;

procedure TRepertoire.InitialesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FInitialesPosition;
end;

procedure TRepertoire.AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FAlbumsPosition := 0;
  Eof := FAlbumsPosition >= FListAlbums.Count;
end;

procedure TRepertoire.AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FAlbumsPosition >= FListAlbums.Count;
  if not Eof then Inc(FAlbumsPosition);
end;

procedure TRepertoire.AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FListAlbums.Count;
end;

procedure TRepertoire.AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FAlbumsPosition;
end;

procedure TRepertoire.InitialeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := FListInitiales[FInitialesPosition].Initiale;
  if Value = '-1' then Value := '<Inconnu>';
  Value := HTMLPrepare(Value);
end;

procedure TRepertoire.InitialeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := HTTPEncode(HTMLPrepare(FListInitiales[FInitialesPosition].Value));
end;

procedure TRepertoire.CountGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FListInitiales[FInitialesPosition].Count;
end;

procedure TRepertoire.UsedGroupByGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FLastGroupBy;
end;

procedure TRepertoire.UsedGroupByGetDisplayText(Sender: TObject; var Value: string);
const
  Lbl: array[TVirtualMode] of string = ('',
    'Titre',
    '', // vmCollections,
    '', // vmEditeurs,
    '', // vmEmprunteurs,
    '', // vmGenres,
    '', // vmPersonnes,
    '', // vmSeries,
    'Année de parution',
    'Collection',
    'Editeur',
    'Genre',
    'Série',
    '', // vmParaBDSerie
    '' // vmAchatAlbumsEditeurs
    );

begin
  Value := HTMLPrepare(Lbl[WSVirtualMode(FLastGroupBy)]);
end;

procedure TRepertoire.RefAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TAlbum(FListAlbums[FAlbumsPosition]).ID);
end;

procedure TRepertoire.TitreAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FListAlbums[FAlbumsPosition]).Titre;
end;

procedure TRepertoire.TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TAlbum(FListAlbums[FAlbumsPosition]).Titre));
end;

procedure TRepertoire.HorsSerieGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TAlbum(FListAlbums[FAlbumsPosition]).HorsSerie;
end;

procedure TRepertoire.TomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(Tome.Value));
end;

procedure TRepertoire.TomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FListAlbums[FAlbumsPosition]).Tome;
end;

procedure TRepertoire.RefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TAlbum(FListAlbums[FAlbumsPosition]).ID_Serie);
end;

procedure TRepertoire.IntegraleGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TAlbum(FListAlbums[FAlbumsPosition]).Integrale;
end;

procedure TRepertoire.TitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TAlbum(FListAlbums[FAlbumsPosition]).Serie));
end;

procedure TRepertoire.TitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FListAlbums[FAlbumsPosition]).Serie;
end;

procedure TRepertoire.LibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TAlbum(FListAlbums[FAlbumsPosition]).ChaineAffichage);
end;

procedure TRepertoire.LibelleCourtGetDisplayText(Sender: TObject; var Value: string);
var
  s: string;
begin
  s := TAlbum(FListAlbums[FAlbumsPosition]).Serie;
  TAlbum(FListAlbums[FAlbumsPosition]).Serie := '';
  Value := Libelle.AsFormatted;
  TAlbum(FListAlbums[FAlbumsPosition]).Serie := s;
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TRepertoire, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caDestroy));

end.

