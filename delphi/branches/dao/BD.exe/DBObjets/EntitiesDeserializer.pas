unit EntitiesDeserializer;

interface

uses
  System.SysUtils, JsonDeserializer, dwsJSON, EntitiesFull, EntitiesLite;

type
  TEntitesDeserializer = class(TJsonDeserializer)
  protected
    class procedure ProcessReadFromJSON(Entity: TObjetFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAlbumFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TSerieFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditeurFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TCollectionFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TUniversFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditionFull; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TParaBDFull; json: TdwsJSONObject); overload;

    class procedure ProcessReadFromJSON(Entity: TBaseLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TCouvertureLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TParaBDLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAuteurLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TPersonnageLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TUniversLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditeurLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TAlbumLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TCollectionLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TSerieLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TEditionLite; json: TdwsJSONObject); overload;
    class procedure ProcessReadFromJSON(Entity: TGenreLite; json: TdwsJSONObject); overload;
  end;

implementation

uses
  Commun;

{ TEntitesSerializer }

{ TEntitesDeserializer }

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TObjetFull; json: TdwsJSONObject);
begin
  // Entity.ID := json.Items['ID'].AsString;
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAlbumFull; json: TdwsJSONObject);
begin
  Entity.ID_Album := ReadValueFromJSON('ID_Album', Entity.ID_Album, json);
  Entity.Complet := ReadValueFromJSON('Complet', Entity.Complet, json);
  Entity.TitreAlbum := ReadValueFromJSON('TitreAlbum', Entity.TitreAlbum, json);
  // Entity.ID_Serie := ReadValueFromJSON('ID_Serie', json, Entity.ID_Serie);
  ReadFromJSON(Entity.Serie, json.Items['Serie'] as TdwsJSONObject);
  Entity.MoisParution := ReadValueFromJSON('MoisParution', Entity.MoisParution, json);
  Entity.AnneeParution := ReadValueFromJSON('AnneeParution', Entity.AnneeParution, json);
  Entity.Tome := ReadValueFromJSON('Tome', Entity.Tome, json);
  Entity.TomeDebut := ReadValueFromJSON('TomeDebut', Entity.TomeDebut, json);
  Entity.TomeFin := ReadValueFromJSON('TomeFin', Entity.TomeFin, json);
  Entity.HorsSerie := ReadValueFromJSON('HorsSerie', Entity.HorsSerie, json);
  Entity.Integrale := ReadValueFromJSON('Integrale', Entity.Integrale, json);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Scenaristes, json.Items['Scenaristes'] as TdwsJSONArray);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Dessinateurs, json.Items['Dessinateurs'] as TdwsJSONArray);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Coloristes, json.Items['Coloristes'] as TdwsJSONArray);
  Entity.Sujet := ReadValueFromJSON('Sujet', Entity.Sujet, json);
  Entity.Notes := ReadValueFromJSON('Notes', Entity.Notes, json);
  ReadFromJSON(Entity.Editions, json.Items['Editions'] as TdwsJSONObject);
  // property Notation: Integer read FNotation write FNotation;
  ReadListLiteFromJSON<TUniversLite>(Entity.Univers, json.Items['Univers'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TParaBDFull; json: TdwsJSONObject);
begin
  Entity.ID_ParaBD := ReadValueFromJSON('ID_ParaBD', Entity.ID_ParaBD, json);
  Entity.AnneeEdition := ReadValueFromJSON('AnneeEdition', Entity.AnneeEdition, json);
  Entity.CategorieParaBD := ReadValueFromJSON('CategorieParaBD', Entity.CategorieParaBD, json);
  Entity.AnneeCote := ReadValueFromJSON('AnneeCote', Entity.AnneeCote, json);
  Entity.TitreParaBD := ReadValueFromJSON('TitreParaBD', Entity.TitreParaBD, json);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Auteurs, json.Items['Auteurs'] as TdwsJSONArray);
  Entity.Description := ReadValueFromJSON('Description', Entity.Description, json);
  // Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
  ReadFromJSON(Entity.Serie, json.Items['Serie'] as TdwsJSONObject);
  Entity.Prix := ReadValueFromJSON('Prix', Entity.Prix, json);
  Entity.PrixCote := ReadValueFromJSON('PrixCote', Entity.PrixCote, json);
  Entity.Dedicace := ReadValueFromJSON('Dedicace', Entity.Dedicace, json);
  Entity.Numerote := ReadValueFromJSON('Numerote', Entity.Numerote, json);
  Entity.Stock := ReadValueFromJSON('Stock', Entity.Stock, json);
  Entity.Offert := ReadValueFromJSON('Offert', Entity.Offert, json);
  Entity.Gratuit := ReadValueFromJSON('Gratuit', Entity.Gratuit, json);
  Entity.DateAchat := ReadValueFromJSON('DateAchat', Entity.DateAchat, json);
  // property sDateAchat: string read Get_sDateAchat;
  Entity.HasImage := ReadValueFromJSON('HasImage', Entity.HasImage, json);
  Entity.ImageStockee := ReadValueFromJSON('ImageStockee', Entity.ImageStockee, json);
  Entity.FichierImage := ReadValueFromJSON('FichierImage', Entity.FichierImage, json);
  ReadListLiteFromJSON<TUniversLite>(Entity.Univers, json.Items['Univers'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditionFull; json: TdwsJSONObject);
begin
  Entity.ID_Edition := ReadValueFromJSON('ID_Edition', Entity.ID_Edition, json);
  Entity.ID_Album := ReadValueFromJSON('ID_Album', Entity.ID_Album, json);
  ReadFromJSON(Entity.Editeur, json.Items['Editeur'] as TdwsJSONObject);
  ReadFromJSON(Entity.Collection, json.Items['Collection'] as TdwsJSONObject);
  Entity.TypeEdition := ReadValueFromJSON('TypeEdition', Entity.TypeEdition, json);
  Entity.Etat := ReadValueFromJSON('Etat', Entity.Etat, json);
  Entity.Reliure := ReadValueFromJSON('Reliure', Entity.Reliure, json);
  Entity.FormatEdition := ReadValueFromJSON('FormatEdition', Entity.FormatEdition, json);
  Entity.Orientation := ReadValueFromJSON('Orientation', Entity.Orientation, json);
  Entity.SensLecture := ReadValueFromJSON('SensLecture', Entity.SensLecture, json);
  Entity.AnneeEdition := ReadValueFromJSON('AnneeEdition', Entity.AnneeEdition, json);
  Entity.NombreDePages := ReadValueFromJSON('NombreDePages', Entity.NombreDePages, json);
  Entity.AnneeCote := ReadValueFromJSON('AnneeCote', Entity.AnneeCote, json);
  Entity.Prix := ReadValueFromJSON('Prix', Entity.Prix, json);
  Entity.PrixCote := ReadValueFromJSON('PrixCote', Entity.PrixCote, json);
  Entity.Couleur := ReadValueFromJSON('Couleur', Entity.Couleur, json);
  Entity.VO := ReadValueFromJSON('VO', Entity.VO, json);
  Entity.Dedicace := ReadValueFromJSON('Dedicace', Entity.Dedicace, json);
  Entity.Stock := ReadValueFromJSON('Stock', Entity.Stock, json);
  Entity.Prete := ReadValueFromJSON('Prete', Entity.Prete, json);
  Entity.Offert := ReadValueFromJSON('Offert', Entity.Offert, json);
  Entity.Gratuit := ReadValueFromJSON('Gratuit', Entity.Gratuit, json);
  Entity.ISBN := ReadValueFromJSON('ISBN', Entity.ISBN, json);
  Entity.DateAchat := ReadValueFromJSON('DateAchat', Entity.DateAchat, json);
  // property sDateAchat: string read Get_sDateAchat;
  Entity.Notes := ReadValueFromJSON('Notes', Entity.Notes, json);
  Entity.NumeroPerso := ReadValueFromJSON('NumeroPerso', Entity.NumeroPerso, json);
  ReadListLiteFromJSON<TCouvertureLite>(Entity.Couvertures, json.Items['Couvertures'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TCouvertureLite; json: TdwsJSONObject);
begin
  Entity.NewNom := ReadValueFromJSON('NewNom', Entity.NewNom, json);
  Entity.OldNom := ReadValueFromJSON('OldNom', Entity.OldNom, json);
  Entity.NewStockee := ReadValueFromJSON('NewStockee', Entity.NewStockee, json);
  Entity.OldStockee := ReadValueFromJSON('OldStockee', Entity.OldStockee, json);
  Entity.Categorie := StrToInt(json.Items['Categorie'].Names[0]);
  Entity.sCategorie := ReadValueFromJSON(IntToStr(Entity.Categorie), Entity.sCategorie, json.Items['Categorie'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TBaseLite; json: TdwsJSONObject);
begin
  Entity.ID := ReadValueFromJSON('ID', Entity.ID, json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurFull; json: TdwsJSONObject);
begin
  Entity.ID_Auteur := ReadValueFromJSON('ID_Auteur', Entity.ID_Auteur, json);
  Entity.NomAuteur := ReadValueFromJSON('NomAuteur', Entity.NomAuteur, json);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, json);
  Entity.Biographie := ReadValueFromJSON('Biographie', Entity.Biographie, json);
  ReadListFullFromJSON<TSerieFull>(Entity.Series, json.Items['Series'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditeurFull; json: TdwsJSONObject);
begin
  Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, json);
  Entity.NomEditeur := ReadValueFromJSON('NomEditeur', Entity.NomEditeur, json);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TSerieFull; json: TdwsJSONObject);
begin
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
  Entity.TitreSerie := ReadValueFromJSON('TitreSerie', Entity.TitreSerie, json);
  Entity.Terminee := ReadValueFromJSON('Terminee', Entity.Terminee, json);
  ReadValueFromJSON('Genres', Entity.Genres, json, True);
  Entity.Sujet := ReadValueFromJSON('Sujet', Entity.Sujet, json);
  Entity.Notes := ReadValueFromJSON('Notes', Entity.Notes, json);
  // Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, json);
  ReadFromJSON(Entity.Editeur, json.Items['Editeur'] as TdwsJSONObject);
  // Entity.ID_Collection := ReadValueFromJSON('ID_Collection', Entity.ID_Collection, json);
  ReadFromJSON(Entity.Collection, json.Items['Collection'] as TdwsJSONObject);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, json);
  Entity.Complete := ReadValueFromJSON('Complete', Entity.Complete, json);
  Entity.SuivreManquants := ReadValueFromJSON('SuivreManquants', Entity.SuivreManquants, json);
  Entity.SuivreSorties := ReadValueFromJSON('SuivreSorties', Entity.SuivreSorties, json);
  Entity.NbAlbums := ReadValueFromJSON('NbAlbums', Entity.NbAlbums, json);
  ReadListLiteFromJSON<TAlbumLite>(Entity.Albums, json.Items['Albums'] as TdwsJSONArray);
  ReadListLiteFromJSON<TParaBDLite>(Entity.ParaBD, json.Items['ParaBD'] as TdwsJSONArray);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Scenaristes, json.Items['Scenaristes'] as TdwsJSONArray);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Dessinateurs, json.Items['Dessinateurs'] as TdwsJSONArray);
  ReadListLiteFromJSON<TAuteurLite>(Entity.Coloristes, json.Items['Coloristes'] as TdwsJSONArray);
  Entity.VO := ReadValueFromJSON('VO', Entity.VO, json);
  Entity.Couleur := ReadValueFromJSON('Couleur', Entity.Couleur, json);
  Entity.Etat := ReadValueFromJSON('Etat', Entity.Etat, json);
  Entity.Reliure := ReadValueFromJSON('Reliure', Entity.Reliure, json);
  Entity.TypeEdition := ReadValueFromJSON('TypeEdition', Entity.TypeEdition, json);
  Entity.FormatEdition := ReadValueFromJSON('FormatEdition', Entity.FormatEdition, json);
  Entity.Orientation := ReadValueFromJSON('Orientation', Entity.Orientation, json);
  Entity.SensLecture := ReadValueFromJSON('SensLecture', Entity.SensLecture, json);
  // property Notation: Integer read FNotation write FNotation;
  ReadListLiteFromJSON<TUniversLite>(Entity.Univers, json.Items['Univers'] as TdwsJSONArray);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TUniversFull; json: TdwsJSONObject);
begin
  Entity.ID_Univers := ReadValueFromJSON('ID_Univers', Entity.ID_Univers, json);
  Entity.NomUnivers := ReadValueFromJSON('NomUnivers', Entity.NomUnivers, json);
  Entity.SiteWeb := ReadValueFromJSON('SiteWeb', Entity.SiteWeb, json);
  Entity.Description := ReadValueFromJSON('Description', Entity.Description, json);
  // Entity.ID_UniversParent := ReadValueFromJSON('ID_UniversParent', Entity.ID_UniversParent, json);
  ReadFromJSON(Entity.UniversParent, json.Items['UniversParent'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TCollectionFull; json: TdwsJSONObject);
begin
  Entity.ID_Collection := ReadValueFromJSON('ID_Collection', Entity.ID_Collection, json);
  Entity.NomCollection := ReadValueFromJSON('NomCollection', Entity.NomCollection, json);
  // Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, json);
  ReadFromJSON(Entity.Editeur, json.Items['Editeur'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TParaBDLite; json: TdwsJSONObject);
begin
  Entity.Titre := ReadValueFromJSON('Titre', Entity.Titre, json);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
  Entity.Serie := ReadValueFromJSON('Serie', Entity.Serie, json);
  Entity.sCategorie := ReadValueFromJSON('Categorie', Entity.sCategorie, json);
  Entity.Achat := ReadValueFromJSON('Achat', Entity.Achat, json);
  Entity.Complet := ReadValueFromJSON('Complet', Entity.Complet, json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TSerieLite; json: TdwsJSONObject);
begin
  ReadValueFromJSON('TitreSerie', Entity.TitreSerie, json);
  ReadFromJSON(Entity.Editeur, json.Items['Editeur'] as TdwsJSONObject);
  ReadFromJSON(Entity.Collection, json.Items['Collection'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TCollectionLite; json: TdwsJSONObject);
begin
  Entity.NomCollection := ReadValueFromJSON('NomCollection', Entity.NomCollection, json);
  ReadFromJSON(Entity.Editeur, json.Items['Editeur'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TGenreLite; json: TdwsJSONObject);
begin
  Entity.Genre := ReadValueFromJSON('Genre', Entity.Genre, json);
  // Quantite: Integer;
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditionLite; json: TdwsJSONObject);
begin
  Entity.AnneeEdition := ReadValueFromJSON('AnneeEdition', Entity.AnneeEdition, json);
  Entity.ISBN := ReadValueFromJSON('ISBN', Entity.ISBN, json);
  ReadFromJSON(Entity.Editeur, json.Items['Editeur'] as TdwsJSONObject);
  ReadFromJSON(Entity.Collection, json.Items['Collection'] as TdwsJSONObject);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAlbumLite; json: TdwsJSONObject);
begin
  Entity.Tome := ReadValueFromJSON('Tome', Entity.Tome, json);
  Entity.TomeDebut := ReadValueFromJSON('TomeDebut', Entity.TomeDebut, json);
  Entity.TomeFin := ReadValueFromJSON('TomeFin', Entity.TomeFin, json);
  Entity.Titre := ReadValueFromJSON('Titre', Entity.Titre, json);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
  Entity.Serie := ReadValueFromJSON('Serie', Entity.Serie, json);
  Entity.ID_Editeur := ReadValueFromJSON('ID_Editeur', Entity.ID_Editeur, json);
  Entity.Editeur := ReadValueFromJSON('Editeur', Entity.Editeur, json);
  Entity.AnneeParution := ReadValueFromJSON('AnneeParution', Entity.AnneeParution, json);
  Entity.MoisParution := ReadValueFromJSON('MoisParution', Entity.MoisParution, json);
  Entity.Stock := ReadValueFromJSON('Stock', Entity.Stock, json);
  Entity.Integrale := ReadValueFromJSON('Integrale', Entity.Integrale, json);
  Entity.HorsSerie := ReadValueFromJSON('HorsSerie', Entity.HorsSerie, json);
  Entity.Achat := ReadValueFromJSON('Achat', Entity.Achat, json);
  Entity.Complet := ReadValueFromJSON('Complet', Entity.Complet, json);
  // Notation: Integer;
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TPersonnageLite; json: TdwsJSONObject);
begin
  Entity.Nom := ReadValueFromJSON('Nom', Entity.Nom, json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TAuteurLite; json: TdwsJSONObject);
begin
  ReadFromJSON(Entity.Personne, json.Items['Personne'] as TdwsJSONObject);
  Entity.ID_Album := ReadValueFromJSON('ID_Album', Entity.ID_Album, json);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
  Entity.metier := ReadValueFromJSON('Metier', Entity.metier, json);
  Entity.ID_Serie := ReadValueFromJSON('ID_Serie', Entity.ID_Serie, json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TEditeurLite; json: TdwsJSONObject);
begin
  Entity.NomEditeur := ReadValueFromJSON('NomEditeur', Entity.NomEditeur, json);
end;

class procedure TEntitesDeserializer.ProcessReadFromJSON(Entity: TUniversLite; json: TdwsJSONObject);
begin
  Entity.NomUnivers := ReadValueFromJSON('NomUnivers', Entity.NomUnivers, json);
end;

end.
