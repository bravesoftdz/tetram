unit UFichePersonne;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, HTTPProd, LoadComplet, WebAdapt, WebComp, Procedures;

type
  TFichePersonne = class(TWebPageModule)
    PageProducer: TPageProducer;
    Albums: TPagedAdapter;
    RefAlbum: TAdapterField;
    TitreAlbum: TAdapterField;
    Tome: TAdapterField;
    HorsSerie: TAdapterBooleanField;
    RefSerie: TAdapterField;
    Integrale: TAdapterBooleanField;
    Personne: TAdapter;
    RefPersonne: TAdapterField;
    Nom: TAdapterField;
    IsScenariste: TAdapterBooleanField;
    IsDessinateur: TAdapterBooleanField;
    TitreSerie: TAdapterField;
    IsColoriste: TAdapterBooleanField;
    Libelle: TAdapterField;
    Biographie: TAdapterMemoField;
    SiteWeb: TAdapterField;
    procedure WebPageModuleCreate(Sender: TObject);
    procedure WebPageModuleDestroy(Sender: TObject);
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
    procedure WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
    procedure RefPersonneGetValue(Sender: TObject; var Value: Variant);
    procedure NomGetValue(Sender: TObject; var Value: Variant);
    procedure AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure RefAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
    procedure TomeGetValue(Sender: TObject; var Value: Variant);
    procedure TomeGetDisplayText(Sender: TObject; var Value: string);
    procedure HorsSerieGetValue(Sender: TObject; var Value: Boolean);
    procedure RefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure IntegraleGetValue(Sender: TObject; var Value: Boolean);
    procedure TitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure IsScenaristeGetValue(Sender: TObject; var Value: Boolean);
    procedure IsDessinateurGetValue(Sender: TObject; var Value: Boolean);
    procedure NomGetDisplayText(Sender: TObject; var Value: string);
    procedure IsColoristeGetValue(Sender: TObject; var Value: Boolean);
    procedure TitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure LibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure BiographieGetValue(Sender: TObject;
      var Value: string);
    procedure SiteWebGetValue(Sender: TObject; var Value: Variant);
    procedure SiteWebGetDisplayText(Sender: TObject; var Value: string);
  private
    { déclarations privées }
    FPersonne: TAuteurComplet;
    FBibliographie: TList;
    FAlbumsPosition: Integer;
  public
    { déclarations publiques }
  end;

function FichePersonne: TFichePersonne;

implementation

{$R *.dfm}

uses WebReq, WebCntxt, WebFact, Variants, JvUIB, Commun, DM_Princ, TypeRec,
  CommonConst, JvUIBLib;

type
  TBiblio = class
    Album: TAlbum;
    Scenariste: Boolean;
    Dessinateur: Boolean;
    Coloriste: Boolean;
  end;

function FichePersonne: TFichePersonne;
begin
  Result := TFichePersonne(WebContext.FindModuleClass(TFichePersonne));
end;

procedure TFichePersonne.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
  FBibliographie := TList.Create;
end;

procedure TFichePersonne.WebPageModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FBibliographie);
end;

procedure TFichePersonne.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
var
  Query: TJvUIBQuery;
  oldRefAlbum: Integer;
  PBiblio: TBiblio;
  Modele: string;
begin
  Modele := Request.QueryFields.Values['Modele'];
  if Modele <> '' then
    PageProducer.HTMLFile := WebServerPath + Modele + '.html'
  else
    PageProducer.HTMLFile := WebServerPath + PageName + '.html';
  FPersonne := TAuteurComplet.Create(StringToGUIDDef(Request.QueryFields.Values['RefPersonne'], GUID_NULL));
  if not IsEqualGUID(FPersonne.ID_Auteur, GUID_NULL) then begin
    Query := TJvUIBQuery.Create(Self);
    with Query do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);

      SQL.Text := 'SELECT * FROM ALBUMS_BY_AUTEUR(' + Request.QueryFields.Values['RefPersonne'] + ')';
      Open;
      oldRefAlbum := -1;
      PBiblio := nil;
      while not EOF do begin
        if (oldRefAlbum = Fields.ByNameAsInteger['RefAlbum']) and Assigned(PBiblio) then begin
          if Fields.ByNameAsInteger['Metier'] = 0 then PBiblio.Scenariste := True;
          if Fields.ByNameAsInteger['Metier'] = 1 then PBiblio.Dessinateur := True;
          if Fields.ByNameAsInteger['Metier'] = 2 then PBiblio.Coloriste := True;
        end
        else begin
          PBiblio := TBiblio.Create;
          FBibliographie.Add(PBiblio);
          PBiblio.Album := TAlbum(TAlbum.Make(Query));
          PBiblio.Scenariste := Fields.ByNameAsInteger['Metier'] = 0;
          PBiblio.Dessinateur := Fields.ByNameAsInteger['Metier'] = 1;
          PBiblio.Coloriste := Fields.ByNameAsInteger['Metier'] = 2;
        end;
        oldRefAlbum := Fields.ByNameAsInteger['RefAlbum'];
        Next;
      end;
    finally
      Free;
    end;
  end;
  FAlbumsPosition := 0;
end;

procedure TFichePersonne.WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
var
  i: Integer;
  PBiblio: TBiblio;
begin
  try
    for i := 0 to Pred(FBibliographie.Count) do begin
      PBiblio := FBibliographie[i];
      PBiblio.Album.Free;
      PBiblio.Free;
    end;
  finally
    FBibliographie.Clear;
  end;
  FPersonne.Free;
end;

procedure TFichePersonne.RefPersonneGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FPersonne.ID_Auteur);
end;

procedure TFichePersonne.NomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(Nom.Value));
end;

procedure TFichePersonne.NomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FPersonne.NomAuteur;
end;

procedure TFichePersonne.AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FAlbumsPosition := 0;
  Eof := FAlbumsPosition >= FBibliographie.Count;
end;

procedure TFichePersonne.AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FAlbumsPosition >= FBibliographie.Count;
  if not Eof then Inc(FAlbumsPosition);
end;

procedure TFichePersonne.AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FBibliographie.Count;
end;

procedure TFichePersonne.AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FAlbumsPosition;
end;

procedure TFichePersonne.RefAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TBiblio(FBibliographie[FAlbumsPosition]).Album.ID);
end;

procedure TFichePersonne.TitreAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := HTMLPrepare(TBiblio(FBibliographie[FAlbumsPosition]).Album.Titre);
end;

procedure TFichePersonne.TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TBiblio(FBibliographie[FAlbumsPosition]).Album.Titre));
end;

procedure TFichePersonne.TomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Album.Tome;
end;

procedure TFichePersonne.TomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(Tome.Value));
end;

procedure TFichePersonne.HorsSerieGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Album.HorsSerie;
end;

procedure TFichePersonne.RefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TBiblio(FBibliographie[FAlbumsPosition]).Album.ID_Serie);
end;

procedure TFichePersonne.IntegraleGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Album.Integrale;
end;

procedure TFichePersonne.TitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TitreSerie.Value);
end;

procedure TFichePersonne.TitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Album.Serie;
end;

procedure TFichePersonne.IsScenaristeGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Scenariste;
end;

procedure TFichePersonne.IsDessinateurGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Dessinateur;
end;

procedure TFichePersonne.IsColoristeGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TBiblio(FBibliographie[FAlbumsPosition]).Coloriste;
end;

procedure TFichePersonne.LibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TBiblio(FBibliographie[FAlbumsPosition]).Album.ChaineAffichage);
end;

procedure TFichePersonne.BiographieGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FPersonne.Biographie.GetText);
end;

procedure TFichePersonne.SiteWebGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FPersonne.SiteWeb;
end;

procedure TFichePersonne.SiteWebGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(SiteWeb.Value);
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TFichePersonne, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caDestroy));

end.
