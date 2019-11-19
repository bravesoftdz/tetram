unit BD.Entities.Utils.Serializer;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, dwsJSON,
  BD.Entities.Full, BD.Entities.Lite,
  Vcl.Dialogs, System.Rtti, BD.Entities.Metadata, BD.Utils.StrUtils, BD.Utils.Serializer.JSON, BD.Entities.Types;

type
  TEntitesSerializer = class(TJsonSerializer)
  public
    class procedure WriteValueToJSON(const Name: string; Value: ROption; Json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: RGUIDEx; Json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: RTriStateValue; Json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: TMetierAuteur; Json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
  protected
    class procedure ProcessWriteToJSON(Entity: TObjetFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAlbumFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TSerieFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditeurFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TCollectionFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TUniversFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditionFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TParaBDFull; Json: TdwsJSONObject; Options: SerializationOptions); overload;

    class procedure ProcessWriteToJSON(Entity: TBaseLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TImageLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TParaBDLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurSerieLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurAlbumLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAuteurParaBDLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TPersonnageLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TUniversLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditeurLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TAlbumLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TCollectionLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TSerieLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TEditionLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
    class procedure ProcessWriteToJSON(Entity: TGenreLite; Json: TdwsJSONObject; Options: SerializationOptions); overload;
  end;

implementation

uses
  System.TypInfo, BD.Entities.Common;

{ TEntitesSerializer }

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TParaBDFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_ParaBD', Entity.ID_ParaBD, Json, Options);
  // WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteToJSON(Entity.Serie, Json.AddObject('Serie'), Options);
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, Json, Options);
  WriteValueToJSON('CategorieParaBD', Entity.CategorieParaBD, Json, Options);
  WriteValueToJSON('AnneeCote', Entity.AnneeCote, Json, Options);
  WriteValueToJSON('TitreParaBD', Entity.TitreParaBD, Json, Options);
  WriteListEntityToJSON<TAuteurParaBDLite>(Entity.Auteurs, Json.AddArray('Auteurs'), Options);
  WriteValueToJSON('Description', Entity.Description, Json, Options);
  WriteValueToJSON('Prix', Entity.Prix, Json, Options);
  WriteValueToJSON('PrixCote', Entity.PrixCote, Json, Options);
  WriteValueToJSON('Dedicace', Entity.Dedicace, Json, Options);
  WriteValueToJSON('Numerote', Entity.Numerote, Json, Options);
  WriteValueToJSON('Stock', Entity.Stock, Json, Options);
  WriteValueToJSON('Offert', Entity.Offert, Json, Options);
  WriteValueToJSON('Gratuit', Entity.Gratuit, Json, Options);
  WriteValueToJSON('DateAchat', Entity.DateAchat, Json, Options);
  // property sDateAchat: string read Get_sDateAchat;
  WriteListEntityToJSON<TUniversLite>(Entity.Univers, Json.AddArray('Univers'), Options);
  WriteListEntityToJSON<TPhotoLite>(Entity.Photos, Json.AddArray('Photos'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAlbumFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Album', Entity.ID_Album, Json, Options);
  // WriteValueToJSON('ID_Serie', Entity.ID_Serie, json, Options);
  WriteToJSON(Entity.Serie, Json.AddObject('Serie'), Options);
  WriteValueToJSON('Complet', Entity.Complet, Json, Options);
  WriteValueToJSON('TitreAlbum', Entity.TitreAlbum, Json, Options);
  WriteValueToJSON('MoisParution', Entity.MoisParution, Json, Options);
  WriteValueToJSON('AnneeParution', Entity.AnneeParution, Json, Options);
  WriteValueToJSON('Tome', Entity.Tome, Json, Options);
  WriteValueToJSON('TomeDebut', Entity.TomeDebut, Json, Options);
  WriteValueToJSON('TomeFin', Entity.TomeFin, Json, Options);
  WriteValueToJSON('HorsSerie', Entity.HorsSerie, Json, Options);
  WriteValueToJSON('Integrale', Entity.Integrale, Json, Options);
  WriteListEntityToJSON<TAuteurAlbumLite>(Entity.Scenaristes, Json.AddArray('Scenaristes'), Options);
  WriteListEntityToJSON<TAuteurAlbumLite>(Entity.Dessinateurs, Json.AddArray('Dessinateurs'), Options);
  WriteListEntityToJSON<TAuteurAlbumLite>(Entity.Coloristes, Json.AddArray('Coloristes'), Options);
  WriteValueToJSON('Sujet', Entity.Sujet, Json, Options);
  WriteValueToJSON('Notes', Entity.Notes, Json, Options);
  WriteListEntityToJSON<TEditionFull>(Entity.Editions, Json.AddArray('Editions'), Options);
  // property Notation: Integer read FNotation write FNotation;
  WriteListEntityToJSON<TUniversLite>(Entity.Univers, Json.AddArray('Univers'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TSerieFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Serie', Entity.ID_Serie, Json, Options);
  // WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json, Options);
  WriteToJSON(Entity.Editeur, Json.AddObject('Editeur'), Options);
  // WriteValueToJSON('ID_Collection', Entity.ID_Collection, json, Options);
  WriteToJSON(Entity.Collection, Json.AddObject('Collection'), Options);
  WriteValueToJSON('TitreSerie', Entity.TitreSerie, Json, Options);
  WriteValueToJSON('Terminee', Entity.Terminee, Json, Options);
  WriteValueToJSON('Genres', Entity.Genres, Json, Options, True);
  WriteValueToJSON('Sujet', Entity.Sujet, Json, Options);
  WriteValueToJSON('Notes', Entity.Notes, Json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, Json, Options);
  WriteValueToJSON('Complete', Entity.Complete, Json, Options);
  WriteValueToJSON('SuivreManquants', Entity.SuivreManquants, Json, Options);
  WriteValueToJSON('SuivreSorties', Entity.SuivreSorties, Json, Options);
  WriteValueToJSON('NbAlbums', Entity.NbAlbums, Json, Options);
  WriteListEntityToJSON<TAlbumLite>(Entity.Albums, Json.AddArray('Albums'), Options);
  WriteListEntityToJSON<TParaBDLite>(Entity.ParaBD, Json.AddArray('ParaBD'), Options);
  WriteListEntityToJSON<TAuteurSerieLite>(Entity.Scenaristes, Json.AddArray('Scenaristes'), Options);
  WriteListEntityToJSON<TAuteurSerieLite>(Entity.Dessinateurs, Json.AddArray('Dessinateurs'), Options);
  WriteListEntityToJSON<TAuteurSerieLite>(Entity.Coloristes, Json.AddArray('Coloristes'), Options);
  WriteValueToJSON('VO', Entity.VO, Json, Options);
  WriteValueToJSON('Couleur', Entity.Couleur, Json, Options);
  WriteValueToJSON('Etat', Entity.Etat, Json, Options);
  WriteValueToJSON('Reliure', Entity.Reliure, Json, Options);
  WriteValueToJSON('TypeEdition', Entity.TypeEdition, Json, Options);
  WriteValueToJSON('FormatEdition', Entity.FormatEdition, Json, Options);
  WriteValueToJSON('Orientation', Entity.Orientation, Json, Options);
  WriteValueToJSON('SensLecture', Entity.SensLecture, Json, Options);
  // property Notation: Integer read FNotation write FNotation;
  WriteListEntityToJSON<TUniversLite>(Entity.Univers, Json.AddArray('Univers'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TObjetFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID', Entity.ID, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditeurFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, Json, Options);
  WriteValueToJSON('NomEditeur', Entity.NomEditeur, Json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCollectionFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Collection', Entity.ID_Collection, Json, Options);
  WriteValueToJSON('NomCollection', Entity.NomCollection, Json, Options);
  // WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, json, Options);
  WriteToJSON(Entity.Editeur, Json.AddObject('Editeur'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TUniversFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Univers', Entity.ID_Univers, Json, Options);
  WriteValueToJSON('NomUnivers', Entity.NomUnivers, Json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, Json, Options);
  WriteValueToJSON('Description', Entity.Description, Json, Options);
  // WriteValueToJSON('ID_UniversParent', Entity.ID_UniversParent, json, Options);
  WriteToJSON(Entity.UniversParent, Json.AddObject('UniversParent'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('ID_Auteur', Entity.ID_Auteur, Json, Options);
  WriteValueToJSON('NomAuteur', Entity.NomAuteur, Json, Options);
  WriteValueToJSON('SiteWeb', Entity.SiteWeb, Json, Options);
  WriteValueToJSON('Biographie', Entity.Biographie, Json, Options);
  WriteListEntityToJSON<TSerieFull>(Entity.Series, Json.AddArray('Series'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditionFull; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID_Edition', Entity.ID_Edition, Json, Options);
  WriteValueToJSON('ID_Album', Entity.ID_Album, Json, Options);
  WriteToJSON(Entity.Editeur, Json.AddObject('Editeur'), Options);
  WriteToJSON(Entity.Collection, Json.AddObject('Collection'), Options);
  WriteValueToJSON('TypeEdition', Entity.TypeEdition, Json, Options);
  WriteValueToJSON('Etat', Entity.Etat, Json, Options);
  WriteValueToJSON('Reliure', Entity.Reliure, Json, Options);
  WriteValueToJSON('FormatEdition', Entity.FormatEdition, Json, Options);
  WriteValueToJSON('Orientation', Entity.Orientation, Json, Options);
  WriteValueToJSON('SensLecture', Entity.SensLecture, Json, Options);
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, Json, Options);
  WriteValueToJSON('NombreDePages', Entity.NombreDePages, Json, Options);
  WriteValueToJSON('AnneeCote', Entity.AnneeCote, Json, Options);
  WriteValueToJSON('Prix', Entity.Prix, Json, Options);
  WriteValueToJSON('PrixCote', Entity.PrixCote, Json, Options);
  WriteValueToJSON('Couleur', Entity.Couleur, Json, Options);
  WriteValueToJSON('VO', Entity.VO, Json, Options);
  WriteValueToJSON('Dedicace', Entity.Dedicace, Json, Options);
  WriteValueToJSON('Stock', Entity.Stock, Json, Options);
  WriteValueToJSON('Prete', Entity.Prete, Json, Options);
  WriteValueToJSON('Offert', Entity.Offert, Json, Options);
  WriteValueToJSON('Gratuit', Entity.Gratuit, Json, Options);
  WriteValueToJSON('ISBN', Entity.ISBN, Json, Options);
  WriteValueToJSON('DateAchat', Entity.DateAchat, Json, Options);
  // property sDateAchat: string read Get_sDateAchat;
  WriteValueToJSON('Notes', Entity.Notes, Json, Options);
  WriteValueToJSON('NumeroPerso', Entity.NumeroPerso, Json, Options);
  WriteListEntityToJSON<TCouvertureLite>(Entity.Couvertures, Json.AddArray('Couvertures'), Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TBaseLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if soFull in Options then
    WriteValueToJSON('ID', Entity.ID, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TImageLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NewNom', Entity.NewNom, Json, Options);
  WriteValueToJSON('OldNom', Entity.OldNom, Json, Options);
  WriteValueToJSON('NewStockee', Entity.NewStockee, Json, Options);
  WriteValueToJSON('OldStockee', Entity.OldStockee, Json, Options);
  Json.AddObject('Categorie').AddValue(IntToStr(Entity.Categorie), Entity.sCategorie);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TParaBDLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Titre', Entity.Titre, Json, Options);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, Json, Options);
  WriteValueToJSON('Serie', Entity.Serie, Json, Options);
  WriteValueToJSON('Categorie', Entity.sCategorie, Json, Options);
  WriteValueToJSON('Achat', Entity.Achat, Json, Options);
  WriteValueToJSON('Complet', Entity.Complet, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TPersonnageLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Nom', Entity.Nom, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteToJSON(Entity.Personne, Json.AddObject('Personne'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurSerieLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, Json, Options);
  WriteValueToJSON('Metier', Entity.metier, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurAlbumLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('ID_Album', Entity.ID_Album, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAuteurParaBDLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('ID_ParaBD', Entity.ID_ParaBD, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TUniversLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NomUnivers', Entity.NomUnivers, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditeurLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NomEditeur', Entity.NomEditeur, Json, Options);
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TAlbumLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Tome', Entity.Tome, Json, Options);
  WriteValueToJSON('TomeDebut', Entity.TomeDebut, Json, Options);
  WriteValueToJSON('TomeFin', Entity.TomeFin, Json, Options);
  WriteValueToJSON('Titre', Entity.Titre, Json, Options);
  WriteValueToJSON('ID_Serie', Entity.ID_Serie, Json, Options);
  WriteValueToJSON('Serie', Entity.Serie, Json, Options);
  WriteValueToJSON('ID_Editeur', Entity.ID_Editeur, Json, Options);
  WriteValueToJSON('Editeur', Entity.Editeur, Json, Options);
  WriteValueToJSON('AnneeParution', Entity.AnneeParution, Json, Options);
  WriteValueToJSON('MoisParution', Entity.MoisParution, Json, Options);
  WriteValueToJSON('Stock', Entity.Stock, Json, Options);
  WriteValueToJSON('Integrale', Entity.Integrale, Json, Options);
  WriteValueToJSON('HorsSerie', Entity.HorsSerie, Json, Options);
  WriteValueToJSON('Achat', Entity.Achat, Json, Options);
  WriteValueToJSON('Complet', Entity.Complet, Json, Options);
  // Notation: Integer;
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TCollectionLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('NomCollection', Entity.NomCollection, Json, Options);
  WriteToJSON(Entity.Editeur, Json.AddObject('Editeur'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TSerieLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('TitreSerie', Entity.TitreSerie, Json, Options);
  WriteToJSON(Entity.Editeur, Json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, Json.AddObject('Collection'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TEditionLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('AnneeEdition', Entity.AnneeEdition, Json, Options);
  WriteValueToJSON('ISBN', Entity.ISBN, Json, Options);
  WriteToJSON(Entity.Editeur, Json.AddObject('Editeur'));
  WriteToJSON(Entity.Collection, Json.AddObject('Collection'));
end;

class procedure TEntitesSerializer.ProcessWriteToJSON(Entity: TGenreLite; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  WriteValueToJSON('Genre', Entity.Genre, Json, Options);
  // Quantite: Integer;
end;

class procedure TEntitesSerializer.WriteValueToJSON(const Name: string; Value: RGUIDEx; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or (not IsEqualGUID(Value, GUID_NULL)) then
    Json.AddValue(Name, Value);
end;

class procedure TEntitesSerializer.WriteValueToJSON(const Name: string; Value: ROption; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or (Value.Value > 0) then
    Json.AddObject(Name).AddValue(IntToStr(Value.Value), Value.Caption);
end;

class procedure TEntitesSerializer.WriteValueToJSON(const Name: string; Value: TMetierAuteur; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if Value in [Low(TMetierAuteur) .. High(TMetierAuteur)] then
    Json.AddObject(Name).AddValue(IntToStr(Ord(Value)), GetEnumName(TypeInfo(TMetierAuteur), Ord(Value)).Substring(2));
end;

class procedure TEntitesSerializer.WriteValueToJSON(const Name: string; Value: RTriStateValue; Json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or (Integer(Value) <> Integer(RTriStateValue.Default)) then
    Json.AddValue(Name, Integer(Value));
end;

end.
