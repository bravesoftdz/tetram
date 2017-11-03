unit Entities.Deserializer;

interface

uses
  System.SysUtils, System.Classes, JsonDeserializer, dwsJSON, Entities.Full, Entities.Lite,
  Entities.Types, UMetadata, Commun;

type
  TEntitesDeserializer = class(TJsonDeserializer)
  public
    class function ReadValueFromJSON(const Name: string; const Default: ROption; Json: TdwsJSONObject): ROption; overload; inline;
    class function ReadValueFromJSON(const Name: string; const Default: RGUIDEx; Json: TdwsJSONObject): RGUIDEx; overload; inline;
    class function ReadValueFromJSON(const Name: string; const Default: TMetierAuteur; Json: TdwsJSONObject): TMetierAuteur; overload; inline;
    class function ReadValueFromJSON(const Name: string; const Default: RTriStateValue; Json: TdwsJSONObject): RTriStateValue; overload; // inline;
  protected
    class procedure ProcessReadFromJSON(Entity: TObjetFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAlbumFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TSerieFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditeurFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TCollectionFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TUniversFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditionFull; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TParaBDFull; Json: TdwsJSONObject); overload;

    class procedure ProcessReadFromJSON(Entity: TBaseLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TImageLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TParaBDLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurSerieLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurAlbumLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurParaBDLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TPersonnageLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TUniversLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditeurLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAlbumLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TCollectionLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TSerieLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditionLite; Json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TGenreLite; Json: TdwsJSONObject); overload;
  end;

implementation

uses
  Entities.FactoriesLite, Entities.FactoriesFull,
  Entities.Common;

{ TEntitesSerializer }

{ TEntitesDeserializer }

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TObjetFull; Json: TdwsJSONObject);
begin
  // Entity.ID := json.Items['ID'].AsString;
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAlbumFull; Json: TdwsJSONObject);
begin
  Entity.ID_Album := ReadValueFromJSON('ID_Album', Entity.ID_Album, Json);
  Entity.Complet := ReadValueFromJSON('Complet', Entity.Complet, Json);
  Entity.TitreAlbum := ReadValueFromJSON('TitreAlbum', Entity.TitreAlbum, Json);
  // Entity.ID_Serie := ReadValueFromJSON('ID_Serie', json, Entity.ID_Serie);
  ReadFromJSON(Entity.Serie, Json.Items['Serie'] as TdwsJSONObject);
  Entity.MoisParution := ReadValueFromJSON('MoisParution', Entity.MoisParution, Json);
  Entity.AnneeParution := ReadValueFromJSON('AnneeParution', Entity.AnneeParution, Json);
  Entity.Tome := ReadValueFromJSON('Tome', Entity.Tome, Json);
  Entity.TomeDebut := ReadValueFromJSON('TomeDebut', Entity.TomeDebut, Json);
  Entity.TomeFin := ReadValueFromJSON('TomeFin', Entity.TomeFin, Json);
  Entity.HorsSerie := ReadValueFromJSON('HorsSerie', Entity.HorsSerie, Json);
  Entity.Integrale := ReadValueFromJSON('Integrale', Entity.Integrale, Json);
  ReadListEntitiesFromJSON<TAuteurAlbumLite, TFactoryAuteurAlbumLite>(Entity.Scenaristes, Json.Items['Scenaristes'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TAuteurAlbumLite, TFactoryAuteurAlbumLite>(Entity.Dessinateurs, Json.Items['Dessinateurs'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TAuteurAlbumLite, TFactoryAuteurAlbumLite>(Entity.Coloristes, Json.Items['Coloristes'] as TdwsJSONArray);
  Entity.Sujet := ReadValueFromJSON('Sujet', Entity.Sujet, Json);
  Entity.Notes := ReadValueFromJSON('Notes', Entity.Notes, Json);
  ReadListEntitiesFromJSON<TEditionFull, TFactoryEditionFull>(Entity.Editions, Json.Items['Editions'] as TdwsJSONArray);
  // property Notation: Integer read FNotation write FNotation;
  ReadListEntitiesFromJSON<TUniversLite, TFactoryUniversLite>(Entity.Univers, Json.Items['Univers'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TParaBDFull; Json: TdwsJSONObject);
begin
  Entity.ID_ParaBD := ReadValueFromJSON('ID_ParaBD', Entity.ID_ParaBD, Json);
  Entity.AnneeEdition := ReadValueFromJSON('AnneeEdition', Entity.AnneeEdition, Json);
  Entity.CategorieParaBD := ReadValueFromJSON('CategorieParaBD', Entity.CategorieParaBD, Json);
  Entity.AnneeCote := ReadValueFromJSON('AnneeCote', Entity.AnneeCote, Json);
  Entity.TitreParaBD := ReadValueFromJSON('TitreParaBD', Entity.TitreParaBD, Json);
  ReadListEntitiesFromJSON<TAuteurParaBDLite, TFactoryAuteurParaBDLite>(Entity.Auteurs, Json.Items['Auteurs'] as TdwsJSONArray);
  Entity.Description := ReadValueFromJSON('Description', Entity.Description, Json);
  // Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
  ReadFromJSON(Entity.Serie, Json.Items['Serie'] as TdwsJSONObject);
  Entity.Prix := ReadValueFromJSON('Prix', Entity.Prix, Json);
  Entity.PrixCote := ReadValueFromJSON('PrixCote', Entity.PrixCote, Json);
  Entity.Dedicace := ReadValueFromJSON('Dedicace', Entity.Dedicace, Json);
  Entity.Numerote := ReadValueFromJSON('Numerote', Entity.Numerote, Json);
  Entity.Stock := ReadValueFromJSON('Stock', Entity.Stock, Json);
  Entity.Offert := ReadValueFromJSON('Offert', Entity.Offert, Json);
  Entity.Gratuit := ReadValueFromJSON('Gratuit', Entity.Gratuit, Json);
  Entity.DateAchat := ReadValueFromJSON('DateAchat', Entity.DateAchat, Json);
  // property sDateAchat: string read Get_sDateAchat;
  ReadListEntitiesFromJSON<TUniversLite, TFactoryUniversLite>(Entity.Univers, Json.Items['Univers'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TPhotoLite, TFactoryPhotoLite>(Entity.Photos, Json.Items['Photos'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditionFull; Json: TdwsJSONObject);
begin
  Entity.ID_Edition := ReadValueFromJSON('ID_Edition', Entity.ID_Edition, Json);
  Entity.ID_Album := ReadValueFromJSON('ID_Album', Entity.ID_Album, Json);
  ReadFromJSON(Entity.Editeur, Json.Items['Editeur'] as TdwsJSONObject);
  ReadFromJSON(Entity.Collection, Json.Items['Collection'] as TdwsJSONObject);
  Entity.TypeEdition := ReadValueFromJSON('TypeEdition', Entity.TypeEdition, Json);
  Entity.Etat := ReadValueFromJSON('Etat', Entity.Etat, Json);
  Entity.Reliure := ReadValueFromJSON('Reliure', Entity.Reliure, Json);
  Entity.FormatEdition := ReadValueFromJSON('FormatEdition', Entity.FormatEdition, Json);
  Entity.Orientation := ReadValueFromJSON('Orientation', Entity.Orientation, Json);
  Entity.SensLecture := ReadValueFromJSON('SensLecture', Entity.SensLecture, Json);
  Entity.AnneeEdition := ReadValueFromJSON('AnneeEdition', Entity.AnneeEdition, Json);
  Entity.NombreDePages := ReadValueFromJSON('NombreDePages', Entity.NombreDePages, Json);
  Entity.AnneeCote := ReadValueFromJSON('AnneeCote', Entity.AnneeCote, Json);
  Entity.Prix := ReadValueFromJSON('Prix', Entity.Prix, Json);
  Entity.PrixCote := ReadValueFromJSON('PrixCote', Entity.PrixCote, Json);
  Entity.Couleur := ReadValueFromJSON('Couleur', Entity.Couleur, Json);
  Entity.VO := ReadValueFromJSON('VO', Entity.VO, Json);
  Entity.Dedicace := ReadValueFromJSON('Dedicace', Entity.Dedicace, Json);
  Entity.Stock := ReadValueFromJSON('Stock', Entity.Stock, Json);
  Entity.Prete := ReadValueFromJSON('Prete', Entity.Prete, Json);
  Entity.Offert := ReadValueFromJSON('Offert', Entity.Offert, Json);
  Entity.Gratuit := ReadValueFromJSON('Gratuit', Entity.Gratuit, Json);
  Entity.ISBN := ReadValueFromJSON('ISBN', Entity.ISBN, Json);
  Entity.DateAchat := ReadValueFromJSON('DateAchat', Entity.DateAchat, Json);
  // property sDateAchat: string read Get_sDateAchat;
  Entity.Notes := ReadValueFromJSON('Notes', Entity.Notes, Json);
  Entity.NumeroPerso := ReadValueFromJSON('NumeroPerso', Entity.NumeroPerso, Json);
  ReadListEntitiesFromJSON<TCouvertureLite, TFactoryCouvertureLite>(Entity.Couvertures, Json.Items['Couvertures'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TImageLite; Json: TdwsJSONObject);
begin
  Entity.NewNom := ReadValueFromJSON('NewNom', Entity.NewNom, Json);
  Entity.OldNom := ReadValueFromJSON('OldNom', Entity.OldNom, Json);
  Entity.NewStockee := ReadValueFromJSON('NewStockee', Entity.NewStockee, Json);
  Entity.OldStockee := ReadValueFromJSON('OldStockee', Entity.OldStockee, Json);
  Entity.Categorie := StrToInt(Json.Items['Categorie'].Names[0]);
  Entity.sCategorie := ReadValueFromJSON(IntToStr(Entity.Categorie), Entity.sCategorie, Json.Items['Categorie'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TBaseLite; Json: TdwsJSONObject);
begin
  Entity.ID := ReadValueFromJSON('ID', Entity.ID, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurFull; Json: TdwsJSONObject);
begin
  Entity.ID_Auteur := ReadValueFromJSON('ID_Auteur', Entity.ID_Auteur, Json);
  Entity.NomAuteur := ReadValueFromJSON('NomAuteur', Entity.NomAuteur, Json);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, Json);
  Entity.Biographie := ReadValueFromJSON('Biographie', Entity.Biographie, Json);
  ReadListEntitiesFromJSON<TSerieFull, TFactorySerieFull>(Entity.Series, Json.Items['Series'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditeurFull; Json: TdwsJSONObject);
begin
  Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, Json);
  Entity.NomEditeur := ReadValueFromJSON('NomEditeur', Entity.NomEditeur, Json);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TSerieFull; Json: TdwsJSONObject);
begin
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, Json);
  Entity.TitreSerie := ReadValueFromJSON('TitreSerie', Entity.TitreSerie, Json);
  Entity.Terminee := ReadValueFromJSON('Terminee', Entity.Terminee, Json);
  ReadValueFromJSON('Genres', Entity.Genres, Json, True);
  Entity.Sujet := ReadValueFromJSON('Sujet', Entity.Sujet, Json);
  Entity.Notes := ReadValueFromJSON('Notes', Entity.Notes, Json);
  // Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, json);
  ReadFromJSON(Entity.Editeur, Json.Items['Editeur'] as TdwsJSONObject);
  // Entity.ID_Collection := ReadValueFromJSON('ID_Collection', Entity.ID_Collection, json);
  ReadFromJSON(Entity.Collection, Json.Items['Collection'] as TdwsJSONObject);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, Json);
  Entity.Complete := ReadValueFromJSON('Complete', Entity.Complete, Json);
  Entity.SuivreManquants := ReadValueFromJSON('SuivreManquants', Entity.SuivreManquants, Json);
  Entity.SuivreSorties := ReadValueFromJSON('SuivreSorties', Entity.SuivreSorties, Json);
  Entity.NbAlbums := ReadValueFromJSON('NbAlbums', Entity.NbAlbums, Json);
  ReadListEntitiesFromJSON<TAlbumLite, TFactoryAlbumLite>(Entity.Albums, Json.Items['Albums'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TParaBDLite, TFactoryParaBDLite>(Entity.ParaBD, Json.Items['ParaBD'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TAuteurSerieLite, TFactoryAuteurSerieLite>(Entity.Scenaristes, Json.Items['Scenaristes'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TAuteurSerieLite, TFactoryAuteurSerieLite>(Entity.Dessinateurs, Json.Items['Dessinateurs'] as TdwsJSONArray);
  ReadListEntitiesFromJSON<TAuteurSerieLite, TFactoryAuteurSerieLite>(Entity.Coloristes, Json.Items['Coloristes'] as TdwsJSONArray);
  Entity.VO := ReadValueFromJSON('VO', Entity.VO, Json);
  Entity.Couleur := ReadValueFromJSON('Couleur', Entity.Couleur, Json);
  Entity.Etat := ReadValueFromJSON('Etat', Entity.Etat, Json);
  Entity.Reliure := ReadValueFromJSON('Reliure', Entity.Reliure, Json);
  Entity.TypeEdition := ReadValueFromJSON('TypeEdition', Entity.TypeEdition, Json);
  Entity.FormatEdition := ReadValueFromJSON('FormatEdition', Entity.FormatEdition, Json);
  Entity.Orientation := ReadValueFromJSON('Orientation', Entity.Orientation, Json);
  Entity.SensLecture := ReadValueFromJSON('SensLecture', Entity.SensLecture, Json);
  // property Notation: Integer read FNotation write FNotation;
  ReadListEntitiesFromJSON<TUniversLite, TFactoryUniversLite>(Entity.Univers, Json.Items['Univers'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TUniversFull; Json: TdwsJSONObject);
begin
  Entity.ID_Univers := ReadValueFromJSON('ID_Univers', Entity.ID_Univers, Json);
  Entity.NomUnivers := ReadValueFromJSON('NomUnivers', Entity.NomUnivers, Json);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, Json);
  Entity.Description := ReadValueFromJSON('Description', Entity.Description, Json);
  // Entity.ID_UniversParent := ReadValueFromJSON('ID_UniversParent', Entity.ID_UniversParent, json);
  ReadFromJSON(Entity.UniversParent, Json.Items['UniversParent'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TCollectionFull; Json: TdwsJSONObject);
begin
  Entity.ID_Collection := ReadValueFromJSON('ID_Collection', Entity.ID_Collection, Json);
  Entity.NomCollection := ReadValueFromJSON('NomCollection', Entity.NomCollection, Json);
  // Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, json);
  ReadFromJSON(Entity.Editeur, Json.Items['Editeur'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TParaBDLite; Json: TdwsJSONObject);
begin
  Entity.Titre := ReadValueFromJSON('Titre', Entity.Titre, Json);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, Json);
  Entity.Serie := ReadValueFromJSON('Serie', Entity.Serie, Json);
  Entity.sCategorie := ReadValueFromJSON('Categorie', Entity.sCategorie, Json);
  Entity.Achat := ReadValueFromJSON('Achat', Entity.Achat, Json);
  Entity.Complet := ReadValueFromJSON('Complet', Entity.Complet, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TSerieLite; Json: TdwsJSONObject);
begin
  ReadValueFromJSON('TitreSerie', Entity.TitreSerie, Json);
  ReadFromJSON(Entity.Editeur, Json.Items['Editeur'] as TdwsJSONObject);
  ReadFromJSON(Entity.Collection, Json.Items['Collection'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TCollectionLite; Json: TdwsJSONObject);
begin
  Entity.NomCollection := ReadValueFromJSON('NomCollection', Entity.NomCollection, Json);
  ReadFromJSON(Entity.Editeur, Json.Items['Editeur'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TGenreLite; Json: TdwsJSONObject);
begin
  Entity.Genre := ReadValueFromJSON('Genre', Entity.Genre, Json);
  // Quantite: Integer;
end;

class function TEntitesDeserializer.ReadValueFromJSON(const Name: string; const Default: RGUIDEx; Json: TdwsJSONObject): RGUIDEx;
begin
  Result := ReadValueFromJSON(Name, string(Default), Json);
end;

class function TEntitesDeserializer.ReadValueFromJSON(const Name: string; const Default: ROption; Json: TdwsJSONObject): ROption;
var
  o: TdwsJSONObject;
begin
  o := json.Items[Name] as TdwsJSONObject;
  if o = nil then
    Result := Default
  else
  begin
    Result.Value := StrToInt(o.Names[0]);
    Result.Caption := ReadValueFromJSON(IntToStr(Result.Value), Result.Caption, o);
  end;
end;

class function TEntitesDeserializer.ReadValueFromJSON(const Name: string; const Default: RTriStateValue; Json: TdwsJSONObject): RTriStateValue;
var
  o: TdwsJSONValue;
begin
  o := json.Items[Name] as TdwsJSONValue;
  if o = nil then
    Result := Default
  else
    Result := RTriStateValue.FromInteger(o.AsInteger);
end;

class function TEntitesDeserializer.ReadValueFromJSON(const Name: string; const Default: TMetierAuteur; Json: TdwsJSONObject): TMetierAuteur;
var
  o: TdwsJSONObject;
begin
  o := json.Items[Name] as TdwsJSONObject;
  if o = nil then
    Result := Default
  else
    Result := TMetierAuteur(StrToIntDef(o.Names[0], Integer(Default)));
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditionLite; Json: TdwsJSONObject);
begin
  Entity.AnneeEdition := ReadValueFromJSON('AnneeEdition', Entity.AnneeEdition, Json);
  Entity.ISBN := ReadValueFromJSON('ISBN', Entity.ISBN, Json);
  ReadFromJSON(Entity.Editeur, Json.Items['Editeur'] as TdwsJSONObject);
  ReadFromJSON(Entity.Collection, Json.Items['Collection'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAlbumLite; Json: TdwsJSONObject);
begin
  Entity.Tome := ReadValueFromJSON('Tome', Entity.Tome, Json);
  Entity.TomeDebut := ReadValueFromJSON('TomeDebut', Entity.TomeDebut, Json);
  Entity.TomeFin := ReadValueFromJSON('TomeFin', Entity.TomeFin, Json);
  Entity.Titre := ReadValueFromJSON('Titre', Entity.Titre, Json);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, Json);
  Entity.Serie := ReadValueFromJSON('Serie', Entity.Serie, Json);
  Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, Json);
  Entity.Editeur := ReadValueFromJSON('Editeur', Entity.Editeur, Json);
  Entity.AnneeParution := ReadValueFromJSON('AnneeParution', Entity.AnneeParution, Json);
  Entity.MoisParution := ReadValueFromJSON('MoisParution', Entity.MoisParution, Json);
  Entity.Stock := ReadValueFromJSON('Stock', Entity.Stock, Json);
  Entity.Integrale := ReadValueFromJSON('Integrale', Entity.Integrale, Json);
  Entity.HorsSerie := ReadValueFromJSON('HorsSerie', Entity.HorsSerie, Json);
  Entity.Achat := ReadValueFromJSON('Achat', Entity.Achat, Json);
  Entity.Complet := ReadValueFromJSON('Complet', Entity.Complet, Json);
  // Notation: Integer;
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TPersonnageLite; Json: TdwsJSONObject);
begin
  Entity.Nom := ReadValueFromJSON('Nom', Entity.Nom, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurLite; Json: TdwsJSONObject);
begin
  ReadFromJSON(Entity.Personne, Json.Items['Personne'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurSerieLite; Json: TdwsJSONObject);
begin
  ReadFromJSON(Entity.Personne, Json.Items['Personne'] as TdwsJSONObject);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, Json);
  Entity.metier := ReadValueFromJSON('Metier', Entity.metier, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurAlbumLite; Json: TdwsJSONObject);
begin
  Entity.ID_Album := ReadValueFromJSON('ID_Album', Entity.ID_Album, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurParaBDLite; Json: TdwsJSONObject);
begin
  Entity.ID_ParaBD := ReadValueFromJSON('ID_ParaBD', Entity.ID_ParaBD, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditeurLite; Json: TdwsJSONObject);
begin
  Entity.NomEditeur := ReadValueFromJSON('NomEditeur', Entity.NomEditeur, Json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TUniversLite; Json: TdwsJSONObject);
begin
  Entity.NomUnivers := ReadValueFromJSON('NomUnivers', Entity.NomUnivers, Json);
end;

end.
