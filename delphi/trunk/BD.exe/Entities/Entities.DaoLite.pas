unit Entities.DaoLite;

interface

uses
  System.SysUtils, System.Types, Entities.Lite, UMetadata, System.Generics.Collections,
  System.SyncObjs, Vcl.ComCtrls, Vcl.StdCtrls, System.Classes, ORM.Core.DBConnection, ORM.Core.Dao,
  ORM.Core.Entities, ORM.Core.Factories, System.IOUtils, Vcl.Dialogs,
  ORM.Core.Attributes;

type
  TDaoLite<T: TBaseLite> = class abstract(TabstractDaoDB<T>)
  public
    procedure SaveList(List: TList<T>; ReferenceParent: TGUID; ReferenceSecondaires: array of TGUID; UseTransaction: TManagedTransaction); virtual; abstract;

    class procedure VideListe(LV: TListView; DoClear: Boolean = True);
  end;

  [Dao]
  TDaoAlbumLite = class(TDaoLite<TAlbumLite>)
  strict private
    IndexID_Album: Integer;
    IndexTome: Integer;
    IndexTomeDebut: Integer;
    IndexTomeFin: Integer;
    IndexTitreAlbum: Integer;
    IndexID_Serie: Integer;
    IndexTitreSerie: Integer;
    IndexID_Editeur: Integer;
    IndexNomEditeur: Integer;
    IndexAnneeParution, IndexMoisParution: Integer;
    IndexStock: Integer;
    IndexIntegrale: Integer;
    IndexHorsSerie: Integer;
    IndexAchat: Integer;
    IndexComplet: Integer;
    IndexNotation: Integer;
  public
    procedure GetFieldIndices; override;
    procedure Fill(Entity: TAlbumLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TAlbumLite; const ID_Album: TGUID); overload; override;
    procedure Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID); overload;
  end;

  [Dao]
  TDaoParaBDLite = class(TDaoLite<TParaBDLite>)
  public
    procedure Fill(Entity: TParaBDLite; Query: TManagedQuery); override;
  end;

  [Dao]
  TDaoSerieLite = class(TDaoLite<TSerieLite>)
  public
    procedure Fill(Entity: TSerieLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TSerieLite; const ID_Serie: TGUID); overload; override;
  end;

  [Dao]
  TDaoEditionLite = class(TDaoLite<TEditionLite>)
  protected
    procedure GetFieldIndices; override;
  public
    procedure Fill(Entity: TEditionLite; Query: TManagedQuery); override;
  end;

  [Dao]
  TDaoEditeurLite = class(TDaoLite<TEditeurLite>)
  strict private
    IndexID_Editeur: Integer;
    IndexNomEditeur: Integer;
  protected
    procedure GetFieldIndices; override;
  public
    procedure Fill(Entity: TEditeurLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TEditeurLite; const ID_Editeur: TGUID); overload; override;
  end;

  [Dao]
  TDaoCollectionLite = class(TDaoLite<TCollectionLite>)
  protected
    procedure GetFieldIndices; override;
  public
    procedure Fill(Entity: TCollectionLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TCollectionLite; const ID_Collection: TGUID); overload; override;
  end;

  [Dao]
  TDaoPersonnageLite = class(TDaoLite<TPersonnageLite>)
  public
    procedure Fill(Entity: TPersonnageLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TPersonnageLite; const ID_Personne: TGUID); overload; override;
  end;

  [Dao]
  TDaoAuteurSerieLite = class(TDaoLite<TAuteurSerieLite>)
  public
    procedure Fill(Entity: TAuteurSerieLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  [Dao]
  TDaoAuteurAlbumLite = class(TDaoLite<TAuteurAlbumLite>)
  public
    procedure Fill(Entity: TAuteurAlbumLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  [Dao]
  TDaoAuteurParaBDLite = class(TDaoLite<TAuteurParaBDLite>)
  public
    procedure Fill(Entity: TAuteurParaBDLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID); overload;
  end;

  [Dao]
  TDaoUniversLite = class(TDaoLite<TUniversLite>)
  public
    procedure Fill(Entity: TUniversLite; Query: TManagedQuery); overload; override;
    procedure Fill(Entity: TUniversLite; const ID_Univers: TGUID); overload; override;
  end;

  TDaoImageLite<T: TImageLite> = class(TDaoLite<T>)
  protected type
    RFieldsInfo = record
      TableName: string;
      Pk: string;
      PkParent: string;
      PkSec: TArray<string>;
      champFichier, champStockage, champImage: string;
    end;
  protected
    class function getFieldsInfo: RFieldsInfo; virtual; abstract;
  public
    procedure SaveList(List: TList<T>; ReferenceParent: TGUID; ReferenceSecondaires: array of TGUID; UseTransaction: TManagedTransaction); override;
  end;

  [Dao]
  TDaoPhotoLite = class(TDaoImageLite<TPhotoLite>)
  protected
    class function getFieldsInfo: TDaoImageLite<TPhotoLite>.RFieldsInfo; override;
  public
    procedure Fill(Entity: TPhotoLite; Query: TManagedQuery); override;
  end;

  [Dao]
  TDaoCouvertureLite = class(TDaoImageLite<TCouvertureLite>)
  protected
    class function getFieldsInfo: TDaoImageLite<TCouvertureLite>.RFieldsInfo; override;
  public
    procedure Fill(Entity: TCouvertureLite; Query: TManagedQuery); override;
  end;

  [Dao]
  TDaoGenreLite = class(TDaoLite<TGenreLite>)
  public
    procedure Fill(Entity: TGenreLite; Query: TManagedQuery); override;
  end;

  [Dao]
  TDaoConversionLite = class(TDaoLite<TConversionLite>)
  public
    procedure Fill(Entity: TConversionLite; Query: TManagedQuery); override;
  end;

implementation

uses
  Commun, uib, uiblib, ProceduresBDtk, CommonConst, Procedures;

{ TDaoLite<T> }

class procedure TDaoLite<T>.VideListe(LV: TListView; DoClear: Boolean);
var
  i: Integer;
begin
  LV.Items.BeginUpdate;
  try
    for i := LV.Items.Count - 1 downto 0 do
    begin
      TBaseLite(LV.Items[i].Data).Free;
      LV.Items.Delete(i);
    end;
  finally
    if DoClear then
      LV.Items.Clear;
    LV.Items.EndUpdate;
  end;
end;

{ TDaoImageLite<T> }

procedure TDaoImageLite<T>.SaveList(List: TList<T>; ReferenceParent: TGUID; ReferenceSecondaires: array of TGUID; UseTransaction: TManagedTransaction);
var
  s: string;
  pi: T;
  qry1, qry2, qry3, qry4, qry5, qry6: TManagedQuery;
  Stream: TStream;
  FichiersImages: TStringList;
  fi: RFieldsInfo;
  i: Integer;
begin
  fi := getFieldsInfo;

  s := '';
  for pi in List do
    if not IsEqualGUID(pi.ID, GUID_NULL) then
      AjoutString(s, QuotedStr(GUIDToString(pi.ID)), ',');

  qry1 := DBConnection.GetQuery(UseTransaction);
  qry2 := DBConnection.GetQuery(qry1.Transaction);
  qry3 := DBConnection.GetQuery(qry1.Transaction);
  qry4 := DBConnection.GetQuery(qry1.Transaction);
  qry5 := DBConnection.GetQuery(qry1.Transaction);
  qry6 := DBConnection.GetQuery(qry1.Transaction);
  FichiersImages := TStringList.Create;
  try
    qry1.SQL.Clear;
    qry1.SQL.Add('delete from ' + fi.TableName);
    qry1.SQL.Add('where');
    qry1.SQL.Add('  ' + fi.PkParent + ' = ?');
    if s <> '' then
      qry1.SQL.Add(' and ' + fi.Pk + ' not in (' + s + ')');
    qry1.Params.AsString[0] := GUIDToString(ReferenceParent);
    qry1.Execute;

    qry1.SQL.Clear;
    qry1.SQL.Add('insert into ' + fi.TableName + ' (');
    qry1.SQL.Add('  ' + fi.PkParent + ', ' + fi.champFichier + ', ' + fi.champStockage + ', ordre, categorieimage');
    for s in fi.PkSec do
      qry1.SQL.Add(', ' + s);
    qry1.SQL.Add(') values (');
    qry1.SQL.Add('  :pk_parent, :fichier, 0, :ordre, :categorieimage');
    for s in fi.PkSec do
      qry1.SQL.Add(', :' + s);
    qry1.SQL.Add(') returning ' + fi.Pk);

    qry6.SQL.Text := 'select result from saveblobtofile(:Chemin, :Fichier, :BlobContent)';

    qry2.SQL.Clear;
    qry2.SQL.Add('insert into ' + fi.TableName + ' (');
    qry2.SQL.Add('  ' + fi.PkParent + ', ' + fi.champFichier + ', ' + fi.champStockage + ', ordre, ' + fi.champImage + ', categorieimage');
    for s in fi.PkSec do
      qry1.SQL.Add(', ' + s);
    qry2.SQL.Add(') values (');
    qry2.SQL.Add('  :pk_parent, :fichier, 1, :ordre, :image, :categorieimage');
    for s in fi.PkSec do
      qry1.SQL.Add(', :' + s);
    qry2.SQL.Add(') returning ' + fi.Pk);

    qry3.SQL.Text := 'update ' + fi.TableName + ' set ' + fi.champImage + ' = :image, ' + fi.champStockage + ' = 1 where ' + fi.Pk + ' = :pk';

    qry4.SQL.Text := 'update ' + fi.TableName + ' set ' + fi.champImage + ' = null, ' + fi.champStockage + ' = 0 where ' + fi.Pk + ' = :pk';

    qry5.SQL.Clear;
    qry5.SQL.Add('update ' + fi.TableName + ' set');
    qry5.SQL.Add('  ' + fi.champFichier + ' = :fichier, ordre = :ordre, categorieimage = :categorieimage');
    qry5.SQL.Add('where');
    qry5.SQL.Add('  ' + fi.Pk + ' = :pk');

    for pi in List do
      if IsEqualGUID(pi.ID, GUID_NULL) then
      begin // nouvelles photos
        if (not pi.NewStockee) then
        begin // photos liées (q1)
          pi.OldNom := pi.NewNom;
          pi.NewNom := SearchNewFileName(RepImages, ExtractFileName(pi.NewNom), True);
          qry6.Params.ByNameAsString['chemin'] := RepImages;
          qry6.Params.ByNameAsString['fichier'] := pi.NewNom;
          Stream := GetJPEGStream(pi.OldNom, -1, -1, False);
          try
            qry6.ParamsSetBlob('blobcontent', Stream);
          finally
            Stream.Free;
          end;
          qry6.Open;

          qry1.Params.ByNameAsString['pk_parent'] := GUIDToString(ReferenceParent);
          qry1.Params.ByNameAsString['fichier'] := pi.NewNom;
          qry1.Params.ByNameAsInteger['ordre'] := List.IndexOf(pi);
          qry1.Params.ByNameAsInteger['categorieimage'] := pi.Categorie;
          for i := 0 to Pred(Length(fi.PkSec)) do
            qry1.Params.ByNameAsString[fi.PkSec[i]] := GUIDToString(ReferenceSecondaires[i]);
          qry1.Execute;
          pi.ID := StringToGUID(qry1.Fields.AsString[0]);
        end
        else if TFile.Exists(pi.NewNom) then
        begin // photos stockées (q2)
          qry2.Params.ByNameAsString['pk_parent'] := GUIDToString(ReferenceParent);
          qry2.Params.ByNameAsString['fichier'] := TPath.GetFileNameWithoutExtension(pi.NewNom);
          qry2.Params.ByNameAsInteger['ordre'] := List.IndexOf(pi);
          Stream := GetJPEGStream(pi.NewNom);
          try
            qry2.ParamsSetBlob('image', Stream);
          finally
            Stream.Free;
          end;
          qry2.Params.ByNameAsInteger['categorieimage'] := pi.Categorie;
          for i := 0 to Pred(Length(fi.PkSec)) do
            qry1.Params.ByNameAsString[fi.PkSec[i]] := GUIDToString(ReferenceSecondaires[i]);
          qry2.Execute;
          pi.ID := StringToGUID(qry2.Fields.AsString[0]);
        end;
      end
      else
      begin // ancienne photo
        if pi.OldStockee <> pi.NewStockee then
        begin // changement de stockage
          Stream := GetCouvertureStream(True, pi.ID, -1, -1, False);
          try
            if (pi.NewStockee) then
            begin // conversion photos liées en stockées (q3)
              qry3.ParamsSetBlob('image', Stream);
              qry3.Params.ByNameAsString['pk'] := GUIDToString(pi.ID);
              qry3.Execute;
              if TPath.GetDirectoryName(pi.NewNom) = '' then
                FichiersImages.Add(TPath.Combine(RepImages, pi.NewNom))
              else
                FichiersImages.Add(pi.NewNom);
              pi.NewNom := TPath.GetFileNameWithoutExtension(pi.NewNom);
            end
            else
            begin // conversion photos stockées en liées
              pi.NewNom := SearchNewFileName(RepImages, pi.NewNom + '.jpg', True);
              qry6.Params.ByNameAsString['chemin'] := RepImages;
              qry6.Params.ByNameAsString['fichier'] := pi.NewNom;
              qry6.ParamsSetBlob('blobcontent', Stream);
              qry6.Open;

              qry4.Params.ByNameAsString['pk'] := GUIDToString(pi.ID);
              qry4.Execute;
            end;
          finally
            Stream.Free;
          end;
        end;
        // photos renommées, réordonnées, etc (q5)
        // obligatoire pour les changement de stockage
        qry5.Params.ByNameAsString['fichier'] := pi.NewNom;
        qry5.Params.ByNameAsInteger['ordre'] := List.IndexOf(pi);
        qry5.Params.ByNameAsInteger['categorieimage'] := pi.Categorie;
        qry5.Params.ByNameAsString['pk'] := GUIDToString(pi.ID);
        qry5.Execute;
      end;

    if FichiersImages.Count > 0 then
    begin
      qry1.SQL.Text := 'select * from deletefile(:fichier)';
      qry1.Prepare(True);
      for s in FichiersImages do
      begin
        qry1.Params.AsString[0] := Copy(s, 1, qry1.Params.MaxStrLen[0]);
        qry1.Open;
        if qry1.Fields.AsInteger[0] <> 0 then
          ShowMessage(s + #13#13 + SysErrorMessage(qry1.Fields.AsInteger[0]));
      end;
    end;

    if UseTransaction = nil then
      qry1.Transaction.Commit;
  finally
    FichiersImages.Free;
    FreeAndNil(qry1);
    FreeAndNil(qry2);
    FreeAndNil(qry3);
    FreeAndNil(qry4);
    FreeAndNil(qry5);
    FreeAndNil(qry6);
  end;
end;

{ TDaoPhotoLite }

procedure TDaoPhotoLite.Fill(Entity: TPhotoLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Photo');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierPhoto'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['StockagePhoto'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

class function TDaoPhotoLite.getFieldsInfo: TDaoImageLite<TPhotoLite>.RFieldsInfo;
begin
  Result.TableName := 'Photos';
  Result.Pk := 'id_photo';
  Result.PkParent := 'id_parabd';
  Result.champFichier := 'fichierphoto';
  Result.champStockage := 'stockagephoto';
  Result.champImage := 'imagephoto';
end;

{ TDaoCouvertureLite }

procedure TDaoCouvertureLite.Fill(Entity: TCouvertureLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Couverture');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['StockageCouverture'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

class function TDaoCouvertureLite.getFieldsInfo: TDaoImageLite<TCouvertureLite>.RFieldsInfo;
begin
  Result.TableName := 'Couvertures';
  Result.Pk := 'id_couverture';
  Result.PkParent := 'id_edition';
  SetLength(Result.PkSec, 1);
  Result.PkSec[0] := 'id_album';
  Result.champFichier := 'fichiercouverture';
  Result.champStockage := 'stockagecouverture';
  Result.champImage := 'imagecouverture';
end;

{ TDaoConversionLite }

procedure TDaoConversionLite.Fill(Entity: TConversionLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Conversion');
  Entity.Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Entity.Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Entity.Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

{ TDaoEditeurLite }

procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; const ID_Editeur: TGUID);
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select nomediteur, id_editeur from editeurs where id_editeur = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Editeur);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Free;
  end;
end;

procedure TDaoEditeurLite.GetFieldIndices;
begin
  inherited;
  IndexID_Editeur := GetFieldIndex('ID_Editeur');
  IndexNomEditeur := GetFieldIndex('NomEditeur');
end;

procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; Query: TManagedQuery);
begin
  Entity.NomEditeur := '';

  if getPreparedQuery = Query then
  begin
    Entity.ID := NonNull(Query, IndexID_Editeur);
    if IndexNomEditeur <> -1 then
      Entity.NomEditeur := Query.Fields.AsString[IndexNomEditeur];
  end
  else
  begin
    Entity.ID := NonNull(Query, 'ID_Editeur');
    try
      Entity.NomEditeur := Query.Fields.ByNameAsString['NomEditeur'];
    except
    end;
  end;
end;

{ TDaoPersonnageLite }

procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Personne');
  Entity.Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; const ID_Personne: TGUID);
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select nompersonne, id_personne from personnes where id_personne = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Personne);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Free;
  end;
end;

{ TDaoAuteurSerieLite }

procedure TDaoAuteurSerieLite.Fill(Entity: TAuteurSerieLite; Query: TManagedQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoFactory.getDaoDB<TPersonnageLite>.getInstance(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
  finally
    PPersonne.Free;
  end;
end;

procedure TDaoAuteurSerieLite.Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_Serie := ReferenceSerie;
  Entity.Metier := Metier;
end;

{ TDaoAuteurAlbumLite }

procedure TDaoAuteurAlbumLite.Fill(Entity: TAuteurAlbumLite; Query: TManagedQuery);
begin
  TDaoFactory.getDaoDB<TAuteurSerieLite>.Fill(Entity, Query);
  Entity.ID_Album := NonNull(Query, 'ID_Album');
end;

procedure TDaoAuteurAlbumLite.Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  (TDaoFactory.getDaoDB<TAuteurSerieLite> as TDaoAuteurSerieLite).Fill(Entity, Pe, ReferenceSerie, Metier);
  Entity.ID_Album := ReferenceAlbum;
end;

{ TDaoAuteurParaBDLite }

procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Query: TManagedQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoFactory.getDaoDB<TPersonnageLite>.getInstance(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_ParaBD'));
  finally
    PPersonne.Free;
  end;
end;

procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_ParaBD := ReferenceParaBD;
end;

{ TDaoAlbumLite }

procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; Query: TManagedQuery);
begin
  Entity.Serie := '';
  Entity.Editeur := '';
  Entity.MoisParution := 0;
  Entity.AnneeParution := 0;
  Entity.Stock := True;
  Entity.Achat := False;
  Entity.Complet := True;
  Entity.Notation := 900;

  if getPreparedQuery = Query then
  begin
    Entity.ID := NonNull(Query, IndexID_Album);
    Entity.Titre := Query.Fields.AsString[IndexTitreAlbum];
    Entity.Tome := Query.Fields.AsInteger[IndexTome];
    Entity.TomeDebut := Query.Fields.AsInteger[IndexTomeDebut];
    Entity.TomeFin := Query.Fields.AsInteger[IndexTomeFin];
    Entity.ID_Serie := NonNull(Query, IndexID_Serie);
    Entity.Integrale := Query.Fields.AsBoolean[IndexIntegrale];
    Entity.HorsSerie := Query.Fields.AsBoolean[IndexHorsSerie];
    Entity.ID_Editeur := NonNull(Query, IndexID_Editeur);
    if IndexTitreSerie <> -1 then
      Entity.Serie := Query.Fields.AsString[IndexTitreSerie];
    if IndexNomEditeur <> -1 then
      Entity.Editeur := Query.Fields.AsString[IndexNomEditeur];
    if IndexMoisParution <> -1 then
      Entity.MoisParution := Query.Fields.AsInteger[IndexMoisParution];
    if IndexAnneeParution <> -1 then
      Entity.AnneeParution := Query.Fields.AsInteger[IndexAnneeParution];
    if IndexStock <> -1 then
      Entity.Stock := Query.Fields.AsBoolean[IndexStock];
    if IndexAchat <> -1 then
      Entity.Achat := Query.Fields.AsBoolean[IndexAchat];
    if IndexComplet <> -1 then
      Entity.Complet := Query.Fields.AsBoolean[IndexComplet];
    if IndexNotation <> -1 then
      Entity.Notation := Query.Fields.AsSmallint[IndexNotation];
  end
  else
  begin
    Entity.ID := NonNull(Query, 'ID_Album');
    Entity.Titre := Query.Fields.ByNameAsString['TitreAlbum'];
    Entity.Tome := Query.Fields.ByNameAsInteger['Tome'];
    Entity.TomeDebut := Query.Fields.ByNameAsInteger['TomeDebut'];
    Entity.TomeFin := Query.Fields.ByNameAsInteger['TomeFin'];
    Entity.ID_Serie := NonNull(Query, 'ID_Serie');
    Entity.Integrale := Query.Fields.ByNameAsBoolean['Integrale'];
    Entity.HorsSerie := Query.Fields.ByNameAsBoolean['HorsSerie'];
    Entity.ID_Editeur := NonNull(Query, 'ID_Editeur');
    try
      Entity.Serie := Query.Fields.ByNameAsString['TitreSerie'];
    except
    end;
    try
      Entity.Editeur := Query.Fields.ByNameAsString['NomEditeur'];
    except
    end;
    try
      Entity.MoisParution := Query.Fields.ByNameAsInteger['MoisParution'];
    except
    end;
    try
      Entity.AnneeParution := Query.Fields.ByNameAsInteger['AnneeParution'];
    except
    end;
    try
      Entity.Stock := Query.Fields.ByNameAsBoolean['Stock'];
    except
    end;
    try
      Entity.Achat := Query.Fields.ByNameAsBoolean['Achat'];
    except
    end;
    try
      Entity.Complet := Query.Fields.ByNameAsBoolean['Complet'];
    except
    end;
    try
      Entity.Notation := Query.Fields.ByNameAsSmallint['Notation'];
    except
    end;
  end;

  if Entity.Notation = 0 then
    Entity.Notation := 900;
end;

procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album: TGUID);
begin
  Fill(Entity, ID_Album, GUID_NULL);
end;

procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID);
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select a.id_album, a.titrealbum, a.horsserie, a.integrale, a.tome, a.tomedebut, a.tomefin, a.id_serie, a.achat, a.complet, a.titreserie';
    qry.SQL.Add('from vw_liste_albums a');
    qry.SQL.Add('where a.id_album = :id_album');
    if not IsEqualGUID(ID_Edition, GUID_NULL) then
    begin
      qry.SQL[0] := qry.SQL[0] + ', e.stock';
      qry.SQL[1] := qry.SQL[1] + ' inner join editions e on a.id_album = e.id_album';
      qry.SQL.Add('and e.id_edition = :id_edition');
    end;
    qry.Params.AsString[0] := GUIDToString(ID_Album);
    if not IsEqualGUID(ID_Edition, GUID_NULL) then
      qry.Params.AsString[1] := GUIDToString(ID_Edition);
    qry.Open;
    Prepare(qry);
    try
      Fill(Entity, qry);
    finally
      Unprepare(qry);
    end;
  finally
    qry.Free;
  end;
end;

procedure TDaoAlbumLite.GetFieldIndices;
begin
  inherited;
  IndexID_Album := GetFieldIndex('ID_Album');
  IndexTitreAlbum := GetFieldIndex('TitreAlbum');
  IndexTome := GetFieldIndex('Tome');
  IndexTomeDebut := GetFieldIndex('TomeDebut');
  IndexTomeFin := GetFieldIndex('TomeFin');
  IndexID_Serie := GetFieldIndex('ID_Serie');
  IndexIntegrale := GetFieldIndex('Integrale');
  IndexHorsSerie := GetFieldIndex('HorsSerie');
  IndexID_Editeur := GetFieldIndex('ID_Editeur');
  IndexTitreSerie := GetFieldIndex('TitreSerie');
  IndexNomEditeur := GetFieldIndex('NomEditeur');
  IndexMoisParution := GetFieldIndex('MoisParution');
  IndexAnneeParution := GetFieldIndex('AnneeParution');
  IndexStock := GetFieldIndex('Stock');
  IndexAchat := GetFieldIndex('Achat');
  IndexComplet := GetFieldIndex('Complet');
  IndexNotation := GetFieldIndex('Notation');
end;

{ TDaoCollectionLite }

procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Collection');
  Entity.NomCollection := Query.Fields.ByNameAsString['NomCollection'];
  try
    TDaoFactory.getDaoDB<TEditeurLite>.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
end;

procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; const ID_Collection: TGUID);
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select id_collection, nomcollection from collections where id_collection = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Collection);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Free;
  end;
end;

procedure TDaoCollectionLite.GetFieldIndices;
begin
  inherited;
  TDaoFactory.getDaoDB<TEditeurLite>.Prepare(getPreparedQuery);
end;

{ TDaoSerieLite }

procedure TDaoSerieLite.Fill(Entity: TSerieLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Serie');
  Entity.TitreSerie := Query.Fields.ByNameAsString['TitreSerie'];
  try
    TDaoFactory.getDaoDB<TEditeurLite>.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
  try
    TDaoFactory.getDaoDB<TCollectionLite>.Fill(Entity.Collection, Query);
  except
    Entity.Collection.Clear;
  end;
end;

procedure TDaoSerieLite.Fill(Entity: TSerieLite; const ID_Serie: TGUID);
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select id_serie, titreserie from series where id_serie = :id_serie';
    qry.Params.AsString[0] := GUIDToString(ID_Serie);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Free;
  end;
end;

{ TDaoEditionLite }

procedure TDaoEditionLite.Fill(Entity: TEditionLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Edition');
  Entity.AnneeEdition := Query.Fields.ByNameAsInteger['AnneeEdition'];
  try
    Entity.ISBN := Trim(Query.Fields.ByNameAsString['ISBN']);
  except
    Entity.ISBN := '';
  end;
  TDaoFactory.getDaoDB<TEditeurLite>.Fill(Entity.Editeur, Query);
  TDaoFactory.getDaoDB<TCollectionLite>.Fill(Entity.Collection, Query);
end;

procedure TDaoEditionLite.GetFieldIndices;
begin
  inherited;
  // le TDaoEditeurLite.Prepare(getPreparedQuery) sera appelé par TDaoCollectionLite.Prepare(getPreparedQuery)
  // TDaoEditeurLite.Prepare(getPreparedQuery);
  TDaoFactory.getDaoDB<TCollectionLite>.Prepare(getPreparedQuery);
end;

{ TDaoGenreLite }

procedure TDaoGenreLite.Fill(Entity: TGenreLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Genre');
  Entity.Genre := Query.Fields.ByNameAsString['Genre'];
  try
    Entity.Quantite := Query.Fields.ByNameAsInteger['QuantiteGenre'];
  except
    Entity.Quantite := 0;
  end;
end;

{ TDaoParaBDLite }

procedure TDaoParaBDLite.Fill(Entity: TParaBDLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_ParaBD');
  Entity.Titre := Query.Fields.ByNameAsString['TitreParaBD'];
  Entity.ID_Serie := NonNull(Query, 'ID_Serie');
  try
    Entity.Serie := Query.Fields.ByNameAsString['TitreSerie'];
  except
    Entity.Serie := '';
  end;
  try
    Entity.Achat := Query.Fields.ByNameAsBoolean['Achat'];
  except
    Entity.Achat := False;
  end;
  try
    Entity.Complet := Query.Fields.ByNameAsBoolean['Complet'];
  except
    Entity.Complet := True;
  end;
  try
    Entity.sCategorie := Query.Fields.ByNameAsString['sCategorie'];
  except
    Entity.sCategorie := '';
  end;
end;

{ TDaoUniversLite }

procedure TDaoUniversLite.Fill(Entity: TUniversLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Univers');
  Entity.NomUnivers := Query.Fields.ByNameAsString['NomUnivers'];
end;

procedure TDaoUniversLite.Fill(Entity: TUniversLite; const ID_Univers: TGUID);
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select nomunivers, id_univers from univers where id_univers = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Univers);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Free;
  end;
end;

end.
