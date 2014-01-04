unit Entities.Serializer;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, dwsJSON, Entities.Full, Entities.Lite,
  Vcl.Dialogs, System.Rtti, UMetadata, Commun, JsonSerializer;

type
  TEntitesSerializer = class(TJsonSerializer)
  protected
    class procedure ProcessWriteToJSON(Entity: TObjetFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAlbumFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TSerieFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditeurFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TCollectionFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TUniversFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditionFull; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TParaBDFull; json: TdwsJSONObject; Options: SerializationOptions); overload;

    class procedure ProcessWriteToJSON(Entity: TBaseLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TCouvertureLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TParaBDLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TPersonnageLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TUniversLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditeurLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAlbumLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TCollectionLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TSerieLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditionLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TGenreLite; json: TdwsJSONObject; Options: SerializationOptions); overload;
  end;

implementation

uses
  System.TypInfo, Entities.Common;

{ TEntitesSerializer }

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TParaBDFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_ParaBD', Entity.ID_ParaBD, json, Options);
  // WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteToJSON(Entity.Serie, json.AddObject('Serie'), Options);
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, json, Options);
  WriteValueToJSON('CategorieParaBD', Entity.CategorieParaBD, json, Options);
  WriteValueToJSON('AnneeCote', Entity.AnneeCote, json, Options);
  WriteValueToJSON('TitreParaBD', Entity.TitreParaBD, json, Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Auteurs, json.AddArray('Auteurs'), Options);
  WriteValueToJSON('Description', Entity.Description, json, Options);
  WriteValueToJSON('Prix', Entity.Prix, json, Options);
  WriteValueToJSON('PrixCote', Entity.PrixCote, json, Options);
  WriteValueToJSON('Dedicace', Entity.Dedicace, json, Options);
  WriteValueToJSON('Numerote', Entity.Numerote, json, Options);
  WriteValueToJSON('Stock', Entity.Stock, json, Options);
  WriteValueToJSON('Offert', Entity.Offert, json, Options);
  WriteValueToJSON('Gratuit', Entity.Gratuit, json, Options);
  WriteValueToJSON('DateAchat', Entity.DateAchat, json, Options);
  // property sDateAchat: string read Get_sDateAchat;
  WriteValueToJSON('HasImage', Entity.HasImage, json, Options);
  WriteValueToJSON('ImageStockee', Entity.ImageStockee, json, Options);
  WriteValueToJSON('FichierImage', Entity.FichierImage, json, Options);
  WriteListEntityToJSON<TUniversLite>(Entity.Univers, json.AddArray('Univers'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAlbumFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Album', Entity.ID_Album, json, Options);
  // WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteToJSON(Entity.Serie, json.AddObject('Serie'), Options);
  WriteValueToJSON('Complet', Entity.Complet, json, Options);
  WriteValueToJSON('TitreAlbum', Entity.TitreAlbum, json, Options);
  WriteValueToJSON('MoisParution', Entity.MoisParution, json, Options);
  WriteValueToJSON('AnneeParution', Entity.AnneeParution, json, Options);
  WriteValueToJSON('Tome', Entity.Tome, json, Options);
  WriteValueToJSON('TomeDebut', Entity.TomeDebut, json, Options);
  WriteValueToJSON('TomeFin', Entity.TomeFin, json, Options);
  WriteValueToJSON('HorsSerie', Entity.HorsSerie, json, Options);
  WriteValueToJSON('Integrale', Entity.Integrale, json, Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Scenaristes, json.AddArray('Scenaristes'), Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Dessinateurs, json.AddArray('Dessinateurs'), Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Coloristes, json.AddArray('Coloristes'), Options);
  WriteValueToJSON('Sujet', Entity.Sujet, json, Options);
  WriteValueToJSON('Notes', Entity.Notes, json, Options);
  WriteListEntityToJSON<TEditionFull>(Entity.Editions, json.AddArray('Editions'), Options);
  // property Notation: Integer read FNotation write FNotation;
  WriteListEntityToJSON<TUniversLite>(Entity.Univers, json.AddArray('Univers'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TSerieFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  // WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json, Options);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'), Options);
  // WriteValueToJSON('ID_Collection', Entity.ID_Collection, json, Options);
  WriteToJSON(Entity.Collection, json.AddObject('Collection'), Options);
  WriteValueToJSON('TitreSerie', Entity.TitreSerie, json, Options);
  WriteValueToJSON('Terminee', Entity.Terminee, json, Options);
  WriteValueToJSON('Genres', Entity.Genres, json, Options, True);
  WriteValueToJSON('Sujet', Entity.Sujet, json, Options);
  WriteValueToJSON('Notes', Entity.Notes, json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json, Options);
  WriteValueToJSON('Complete', Entity.Complete, json, Options);
  WriteValueToJSON('SuivreManquants', Entity.SuivreManquants, json, Options);
  WriteValueToJSON('SuivreSorties', Entity.SuivreSorties, json, Options);
  WriteValueToJSON('NbAlbums', Entity.NbAlbums, json, Options);
  WriteListEntityToJSON<TAlbumLite>(Entity.Albums, json.AddArray('Albums'), Options);
  WriteListEntityToJSON<TParaBDLite>(Entity.ParaBD, json.AddArray('ParaBD'), Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Scenaristes, json.AddArray('Scenaristes'), Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Dessinateurs, json.AddArray('Dessinateurs'), Options);
  WriteListEntityToJSON<TAuteurLite>(Entity.Coloristes, json.AddArray('Coloristes'), Options);
  WriteValueToJSON('VO', Entity.VO, json, Options);
  WriteValueToJSON('Couleur', Entity.Couleur, json, Options);
  WriteValueToJSON('Etat', Entity.Etat, json, Options);
  WriteValueToJSON('Reliure', Entity.Reliure, json, Options);
  WriteValueToJSON('TypeEdition', Entity.TypeEdition, json, Options);
  WriteValueToJSON('FormatEdition', Entity.FormatEdition, json, Options);
  WriteValueToJSON('Orientation', Entity.Orientation, json, Options);
  WriteValueToJSON('SensLecture', Entity.SensLecture, json, Options);
  // property Notation: Integer read FNotation write FNotation;
  WriteListEntityToJSON<TUniversLite>(Entity.Univers, json.AddArray('Univers'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TObjetFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID', Entity.ID, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditeurFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json, Options);
  WriteValueToJSON('NomEditeur', Entity.NomEditeur, json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCollectionFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Collection', Entity.ID_Collection, json, Options);
  WriteValueToJSON('NomCollection', Entity.NomCollection, json, Options);
  // WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json, Options);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TUniversFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Univers', Entity.ID_Univers, json, Options);
  WriteValueToJSON('NomUnivers', Entity.NomUnivers, json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json, Options);
  WriteValueToJSON('Description', Entity.Description, json, Options);
  // WriteValueToJSON('ID_UniversParent', Entity.ID_UniversParent, json, Options);
  WriteToJSON(Entity.UniversParent, json.AddObject('UniversParent'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('ID_Auteur', Entity.ID_Auteur, json, Options);
  WriteValueToJSON('NomAuteur', Entity.NomAuteur, json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, json, Options);
  WriteValueToJSON('Biographie', Entity.Biographie, json, Options);
  WriteListEntityToJSON<TSerieFull>(Entity.Series, json.AddArray('Series'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditionFull; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Edition', Entity.ID_Edition, json, Options);
  WriteValueToJSON('ID_Album', Entity.ID_Album, json, Options);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'), Options);
  WriteToJSON(Entity.Collection, json.AddObject('Collection'), Options);
  WriteValueToJSON('TypeEdition', Entity.TypeEdition, json, Options);
  WriteValueToJSON('Etat', Entity.Etat, json, Options);
  WriteValueToJSON('Reliure', Entity.Reliure, json, Options);
  WriteValueToJSON('FormatEdition', Entity.FormatEdition, json, Options);
  WriteValueToJSON('Orientation', Entity.Orientation, json, Options);
  WriteValueToJSON('SensLecture', Entity.SensLecture, json, Options);
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, json, Options);
  WriteValueToJSON('NombreDePages', Entity.NombreDePages, json, Options);
  WriteValueToJSON('AnneeCote', Entity.AnneeCote, json, Options);
  WriteValueToJSON('Prix', Entity.Prix, json, Options);
  WriteValueToJSON('PrixCote', Entity.PrixCote, json, Options);
  WriteValueToJSON('Couleur', Entity.Couleur, json, Options);
  WriteValueToJSON('VO', Entity.VO, json, Options);
  WriteValueToJSON('Dedicace', Entity.Dedicace, json, Options);
  WriteValueToJSON('Stock', Entity.Stock, json, Options);
  WriteValueToJSON('Prete', Entity.Prete, json, Options);
  WriteValueToJSON('Offert', Entity.Offert, json, Options);
  WriteValueToJSON('Gratuit', Entity.Gratuit, json, Options);
  WriteValueToJSON('ISBN', Entity.ISBN, json, Options);
  WriteValueToJSON('DateAchat', Entity.DateAchat, json, Options);
  // property sDateAchat: string read Get_sDateAchat;
  WriteValueToJSON('Notes', Entity.Notes, json, Options);
  WriteValueToJSON('NumeroPerso', Entity.NumeroPerso, json, Options);
  WriteListEntityToJSON<TCouvertureLite>(Entity.Couvertures, json.AddArray('Couvertures'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TBaseLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID', Entity.ID, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCouvertureLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NewNom', Entity.NewNom, json, Options);
  WriteValueToJSON('OldNom', Entity.OldNom, json, Options);
  WriteValueToJSON('NewStockee', Entity.NewStockee, json, Options);
  WriteValueToJSON('OldStockee', Entity.OldStockee, json, Options);
  json.AddObject('Categorie').AddValue(IntToStr(Entity.Categorie), Entity.sCategorie);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TParaBDLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Titre', Entity.Titre, json, Options);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteValueToJSON('Serie', Entity.Serie, json, Options);
  WriteValueToJSON('Categorie', Entity.sCategorie, json, Options);
  WriteValueToJSON('Achat', Entity.Achat, json, Options);
  WriteValueToJSON('Complet', Entity.Complet, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TPersonnageLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Nom', Entity.Nom, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteToJSON(Entity.Personne, json.AddObject('Personne'));
  WriteValueToJSON('ID_Album', Entity.ID_Album, json, Options);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteValueToJSON('Metier', Entity.metier, json, Options);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TUniversLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NomUnivers', Entity.NomUnivers, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditeurLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NomEditeur', Entity.NomEditeur, json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAlbumLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Tome', Entity.Tome, json, Options);
  WriteValueToJSON('TomeDebut', Entity.TomeDebut, json, Options);
  WriteValueToJSON('TomeFin', Entity.TomeFin, json, Options);
  WriteValueToJSON('Titre', Entity.Titre, json, Options);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteValueToJSON('Serie', Entity.Serie, json, Options);
  WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json, Options);
  WriteValueToJSON('Editeur', Entity.Editeur, json, Options);
  WriteValueToJSON('AnneeParution', Entity.AnneeParution, json, Options);
  WriteValueToJSON('MoisParution', Entity.MoisParution, json, Options);
  WriteValueToJSON('Stock', Entity.Stock, json, Options);
  WriteValueToJSON('Integrale', Entity.Integrale, json, Options);
  WriteValueToJSON('HorsSerie', Entity.HorsSerie, json, Options);
  WriteValueToJSON('Achat', Entity.Achat, json, Options);
  WriteValueToJSON('Complet', Entity.Complet, json, Options);
  // Notation: Integer;
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCollectionLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NomCollection', Entity.NomCollection, json, Options);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TSerieLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('TitreSerie', Entity.TitreSerie, json, Options);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, json.AddObject('Collection'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditionLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, json, Options);
  WriteValueToJSON('ISBN', Entity.ISBN, json, Options);
  WriteToJSON(Entity.Editeur, json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, json.AddObject('Collection'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TGenreLite; json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Genre', Entity.Genre, json, Options);
  // Quantite: Integer;
end;

end.
