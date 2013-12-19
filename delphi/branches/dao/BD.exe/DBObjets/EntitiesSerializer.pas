unit EntitiesSerializer;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, dwsJSON, EntitiesFull, EntitiesLite,
  Vcl.Dialogs, System.Rtti, UMetadata, Commun, JsonSerializer;

type
  TEntitesSerializer = class(TJsonSerializer)
  protected
    class procedure ProcessWriteToJSON(Entity: TObjetFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TAlbumFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TSerieFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TEditeurFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TCollectionFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TUniversFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TEditionFull; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TParaBDFull; json: TdwsJSONObject); overload;

    class procedure ProcessWriteToJSON(Entity: TBaseLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TCouvertureLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TParaBDLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TPersonnageLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TUniversLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TEditeurLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TAlbumLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TCollectionLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TSerieLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TEditionLite; json: TdwsJSONObject); overload;
    class procedure ProcessWriteToJSON(Entity: TGenreLite; json: TdwsJSONObject); overload;
  end;

implementation

uses
  System.TypInfo;

{ TEntitesSerializer }

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TParaBDFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_ParaBD', Entity.ID_ParaBD, json);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, json);
  WriteValueToJSON('CategorieParaBD', Entity.CategorieParaBD, json);
  WriteValueToJSON('AnneeCote', Entity.AnneeCote, json);
  WriteValueToJSON('TitreParaBD', Entity.TitreParaBD, json);
  WriteListLiteToJSON<TAuteurLite>(Entity.Auteurs, json.AddArray('Auteurs'));
  WriteValueToJSON('Description', Entity.Description, json);
  WriteToJSON(Entity.Serie, json.AddObject('Serie'));
  WriteValueToJSON('Prix', Entity.Prix, json);
  WriteValueToJSON('PrixCote', Entity.PrixCote, json);
  WriteValueToJSON('Dedicace', Entity.Dedicace, json);
  WriteValueToJSON('Numerote', Entity.Numerote, json);
  WriteValueToJSON('Stock', Entity.Stock, json);
  WriteValueToJSON('Offert', Entity.Offert, json);
  WriteValueToJSON('Gratuit', Entity.Gratuit, json);
  WriteValueToJSON('DateAchat', Entity.DateAchat, json);
  // property sDateAchat: string read Get_sDateAchat;
  WriteValueToJSON('HasImage', Entity.HasImage, json);
  WriteValueToJSON('ImageStockee', Entity.ImageStockee, json);
  WriteValueToJSON('FichierImage', Entity.FichierImage, json);
  WriteListLiteToJSON<TUniversLite>(Entity.Univers, json.AddArray('Univers'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAlbumFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Album', Entity.ID_Album, json);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
  WriteValueToJSON('Complet', Entity.Complet, json);
  WriteValueToJSON('TitreAlbum', Entity.TitreAlbum, json);
  WriteToJSON(Entity.Serie, json.AddObject('Serie'));
  WriteValueToJSON('MoisParution', Entity.MoisParution, json);
  WriteValueToJSON('AnneeParution', Entity.AnneeParution, json);
  WriteValueToJSON('Tome', Entity.Tome, json);
  WriteValueToJSON('TomeDebut', Entity.TomeDebut, json);
  WriteValueToJSON('TomeFin', Entity.TomeFin, json);
  WriteValueToJSON('HorsSerie', Entity.HorsSerie, json);
  WriteValueToJSON('Integrale', Entity.Integrale, json);
  WriteListLiteToJSON<TAuteurLite>(Entity.Scenaristes, json.AddArray('Scenaristes'));
  WriteListLiteToJSON<TAuteurLite>(Entity.Dessinateurs, json.AddArray('Dessinateurs'));
  WriteListLiteToJSON<TAuteurLite>(Entity.Coloristes, json.AddArray('Coloristes'));
  WriteValueToJSON('Sujet', Entity.Sujet, json);
  WriteValueToJSON('Notes', Entity.Notes, json);
  WriteToJSON(Entity.Editions, json.AddObject('Editions'));
  // property Notation: Integer read FNotation write FNotation;
  WriteListLiteToJSON<TUniversLite>(Entity.Univers, json.AddArray('Univers'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TSerieFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
  WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json);
  WriteValueToJSON('ID_Collection', Entity.ID_Collection, json);
  WriteValueToJSON('TitreSerie', Entity.TitreSerie, json);
  WriteValueToJSON('Terminee', Entity.Terminee, json);
  WriteValueToJSON('Genres', Entity.Genres, json, True);
  WriteValueToJSON('Sujet', Entity.Sujet, json);
  WriteValueToJSON('Notes', Entity.Notes, json);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, json.AddObject('Collection'));
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json);
  WriteValueToJSON('Complete', Entity.Complete, json);
  WriteValueToJSON('SuivreManquants', Entity.SuivreManquants, json);
  WriteValueToJSON('SuivreSorties', Entity.SuivreSorties, json);
  WriteValueToJSON('NbAlbums', Entity.NbAlbums, json);
  WriteListLiteToJSON<TAlbumLite>(Entity.Albums, json.AddArray('Albums'));
  WriteListLiteToJSON<TParaBDLite>(Entity.ParaBD, json.AddArray('ParaBD'));
  WriteListLiteToJSON<TAuteurLite>(Entity.Scenaristes, json.AddArray('Scenaristes'));
  WriteListLiteToJSON<TAuteurLite>(Entity.Dessinateurs, json.AddArray('Dessinateurs'));
  WriteListLiteToJSON<TAuteurLite>(Entity.Coloristes, json.AddArray('Coloristes'));
  WriteValueToJSON('VO', Entity.VO, json);
  WriteValueToJSON('Couleur', Entity.Couleur, json);
  WriteValueToJSON('Etat', Entity.Etat, json);
  WriteValueToJSON('Reliure', Entity.Reliure, json);
  WriteValueToJSON('TypeEdition', Entity.TypeEdition, json);
  WriteValueToJSON('FormatEdition', Entity.FormatEdition, json);
  WriteValueToJSON('Orientation', Entity.Orientation, json);
  WriteValueToJSON('SensLecture', Entity.SensLecture, json);
  // property Notation: Integer read FNotation write FNotation;
  WriteListLiteToJSON<TUniversLite>(Entity.Univers, json.AddArray('Univers'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TObjetFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID', Entity.ID, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditeurFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json);
  WriteValueToJSON('NomEditeur', Entity.NomEditeur, json);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCollectionFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Collection', Entity.ID_Collection, json);
  WriteValueToJSON('NomCollection', Entity.NomCollection, json);
  WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TUniversFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Univers', Entity.ID_Univers, json);
  WriteValueToJSON('NomUnivers', Entity.NomUnivers, json);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json);
  WriteValueToJSON('Description', Entity.Description, json);
  WriteValueToJSON('ID_UniversParent', Entity.ID_UniversParent, json);
  WriteToJSON(Entity.UniversParent, json.AddObject('UniversParent'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Auteur', Entity.ID_Auteur, json);
  WriteValueToJSON('NomAuteur', Entity.NomAuteur, json);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json);
  WriteValueToJSON('Biographie', Entity.Biographie, json);
  WriteListFullToJSON<TSerieFull>(Entity.Series, json.AddArray('Series'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditionFull; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID_Edition', Entity.ID_Edition, json);
  WriteValueToJSON('ID_Album', Entity.ID_Album, json);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, json.AddObject('Collection'));
  WriteValueToJSON('TypeEdition', Entity.TypeEdition, json);
  WriteValueToJSON('Etat', Entity.Etat, json);
  WriteValueToJSON('Reliure', Entity.Reliure, json);
  WriteValueToJSON('FormatEdition', Entity.FormatEdition, json);
  WriteValueToJSON('Orientation', Entity.Orientation, json);
  WriteValueToJSON('SensLecture', Entity.SensLecture, json);
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, json);
  WriteValueToJSON('NombreDePages', Entity.NombreDePages, json);
  WriteValueToJSON('AnneeCote', Entity.AnneeCote, json);
  WriteValueToJSON('Prix', Entity.Prix, json);
  WriteValueToJSON('PrixCote', Entity.PrixCote, json);
  WriteValueToJSON('Couleur', Entity.Couleur, json);
  WriteValueToJSON('VO', Entity.VO, json);
  WriteValueToJSON('Dedicace', Entity.Dedicace, json);
  WriteValueToJSON('Stock', Entity.Stock, json);
  WriteValueToJSON('Prete', Entity.Prete, json);
  WriteValueToJSON('Offert', Entity.Offert, json);
  WriteValueToJSON('Gratuit', Entity.Gratuit, json);
  WriteValueToJSON('ISBN', Entity.ISBN, json);
  WriteValueToJSON('DateAchat', Entity.DateAchat, json);
  // property sDateAchat: string read Get_sDateAchat;
  WriteValueToJSON('Notes', Entity.Notes, json);
  WriteValueToJSON('NumeroPerso', Entity.NumeroPerso, json);
  WriteListLiteToJSON<TCouvertureLite>(Entity.Couvertures, json.AddArray('Couvertures'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TBaseLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('ID', Entity.ID, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCouvertureLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('NewNom', Entity.NewNom, json);
  WriteValueToJSON('OldNom', Entity.OldNom, json);
  WriteValueToJSON('NewStockee', Entity.NewStockee, json);
  WriteValueToJSON('OldStockee', Entity.OldStockee, json);
  json.AddObject('Categorie').AddValue(IntToStr(Entity.Categorie), Entity.sCategorie);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TParaBDLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('Titre', Entity.Titre, json);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
  WriteValueToJSON('Serie', Entity.Serie, json);
  WriteValueToJSON('Categorie', Entity.sCategorie, json);
  WriteValueToJSON('Achat', Entity.Achat, json);
  WriteValueToJSON('Complet', Entity.Complet, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TPersonnageLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('Nom', Entity.Nom, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurLite; json: TdwsJSONObject);
begin
  WriteToJSON(Entity.Personne, json.AddObject('Personne'));
  WriteValueToJSON('ID_Album', Entity.ID_Album, json);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
  WriteValueToJSON('Metier', Entity.metier, json);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TUniversLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('NomUnivers', Entity.NomUnivers, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditeurLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('NomEditeur', Entity.NomEditeur, json);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAlbumLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('Tome', Entity.Tome, json);
  WriteValueToJSON('TomeDebut', Entity.TomeDebut, json);
  WriteValueToJSON('TomeFin', Entity.TomeFin, json);
  WriteValueToJSON('Titre', Entity.Titre, json);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json);
  WriteValueToJSON('Serie', Entity.Serie, json);
  WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json);
  WriteValueToJSON('Editeur', Entity.Editeur, json);
  WriteValueToJSON('AnneeParution', Entity.AnneeParution, json);
  WriteValueToJSON('MoisParution', Entity.MoisParution, json);
  WriteValueToJSON('Stock', Entity.Stock, json);
  WriteValueToJSON('Integrale', Entity.Integrale, json);
  WriteValueToJSON('HorsSerie', Entity.HorsSerie, json);
  WriteValueToJSON('Achat', Entity.Achat, json);
  WriteValueToJSON('Complet', Entity.Complet, json);
  // Notation: Integer;
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCollectionLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('NomCollection', Entity.NomCollection, json);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TSerieLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('TitreSerie', Entity.TitreSerie, json);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, json.AddObject('Collection'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditionLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, json);
  WriteValueToJSON('ISBN', Entity.ISBN, json);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, json.AddObject('Collection'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TGenreLite; json: TdwsJSONObject);
begin
  WriteValueToJSON('Genre', Entity.Genre, json);
  // Quantite: Integer;
end;

end.
