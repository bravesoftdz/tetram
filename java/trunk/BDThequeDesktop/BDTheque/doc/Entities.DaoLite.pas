unit Entities.DaoLite;

interface

uses
  Entities.Lite
  // UMetadata,
  // Entities.DaoCommon,
  // Entities.Common, Entities.FactoriesCommon
  ;

type
  TDaoLite<T: TBaseLite> = class abstract(TDaoGenericDBEntity<T>)
  public
    class function Make(Query: TManagedQuery): TBaseLite;

    class procedure FillList(List: TList<TBaseLite>; Query: TManagedQuery);

    class procedure VideListe(LV: TListView; DoClear: Boolean = True);
  end;

  TDaoLiteEntity<T: TBaseLite> = class abstract(TDaoLite<T>)
  public
    class function Make(Query: TManagedQuery): T; reintroduce;

    class procedure Fill(Entity: TDBEntity; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: T; Query: TManagedQuery); reintroduce; overload; virtual; abstract;
    class procedure FillList(List: TList<T>; Query: TManagedQuery);
    class procedure SaveList(List: TList<T>; ReferenceParent: TGUID; ReferenceSecondaires: array of TGUID; UseTransaction: TManagedTransaction); virtual; abstract;
  end;

  TDaoAlbumLite = class(TDaoLiteEntity<TAlbumLite>)
  strict private
    class var IndexID_Album: Integer;
    class var IndexTome: Integer;
    class var IndexTomeDebut: Integer;
    class var IndexTomeFin: Integer;
    class var IndexTitreAlbum: Integer;
    class var IndexID_Serie: Integer;
    class var IndexTitreSerie: Integer;
    class var IndexID_Editeur: Integer;
    class var IndexNomEditeur: Integer;
    class var IndexAnneeParution, IndexMoisParution: Integer;
    class var IndexStock: Integer;
    class var IndexIntegrale: Integer;
    class var IndexHorsSerie: Integer;
    class var IndexAchat: Integer;
    class var IndexComplet: Integer;
    class var IndexNotation: Integer;
  public
    class procedure GetFieldIndices; override;
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TAlbumLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAlbumLite; const ID_Album: TGUID); overload;
    class procedure Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID); overload;
  end;

  TDaoPersonnageLite = class(TDaoLiteEntity<TPersonnageLite>)
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TPersonnageLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TPersonnageLite; const ID_Personne: TGUID); overload;
  end;

  TDaoAuteurSerieLite = class(TDaoLiteEntity<TAuteurSerieLite>)
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TAuteurSerieLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoAuteurAlbumLite = class(TDaoLiteEntity<TAuteurAlbumLite>)
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TAuteurAlbumLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoAuteurParaBDLite = class(TDaoLiteEntity<TAuteurParaBDLite>)
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TAuteurParaBDLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID); overload;
  end;

  TDaoUniversLite = class(TDaoLiteEntity<TUniversLite>)
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TUniversLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TUniversLite; const ID_Univers: TGUID); overload;
  end;

type
  RFieldsInfo = record
    TableName: string;
    Pk: string;
    PkParent: string;
    PkSec: TArray<string>;
    champFichier, champStockage, champImage: string;
  end;

  TDaoImageLite<T: TImageLite> = class(TDaoLiteEntity<T>)
  protected
    class function getFieldsInfo: RFieldsInfo; virtual; abstract;
  public
    class procedure SaveList(List: TList<T>; ReferenceParent: TGUID; ReferenceSecondaires: array of TGUID; UseTransaction: TManagedTransaction); override;
  end;

  TDaoPhotoLite = class(TDaoImageLite<TPhotoLite>)
  protected
    class function getFieldsInfo: RFieldsInfo; override;
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TPhotoLite; Query: TManagedQuery); override;
  end;

  TDaoCouvertureLite = class(TDaoImageLite<TCouvertureLite>)
  protected
    class function getFieldsInfo: RFieldsInfo; override;
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TCouvertureLite; Query: TManagedQuery); override;
  end;

  TDaoConversionLite = class(TDaoLiteEntity<TConversionLite>)
  public
    class function FactoryClass: TFactoryClass; override;
    class procedure Fill(Entity: TConversionLite; Query: TManagedQuery); override;
  end;

implementation

uses
  Commun, uib, uiblib, Entities.FactoriesLite, ProceduresBDtk,
  CommonConst, Procedures;

{ TDaoLite<T> }

class procedure TDaoLite<T>.FillList(List: TList<TBaseLite>; Query: TManagedQuery);
begin
  Prepare(Query);
  try
    while not Query.Eof do
    begin
      List.Add(Make(Query));
      Query.Next;
    end;
  finally
    Unprepare(Query);
  end;
end;

class function TDaoLite<T>.Make(Query: TManagedQuery): TBaseLite;
begin
  Result := getInstance as TBaseLite;
  Fill(Result, Query);
end;

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

{ TDaoLiteEntity<T> }

class procedure TDaoLiteEntity<T>.Fill(Entity: TDBEntity; Query: TManagedQuery);
begin
  Fill(T(Entity), Query);
end;

class procedure TDaoLiteEntity<T>.FillList(List: TList<T>; Query: TManagedQuery);
begin
  Prepare(Query);
  try
    while not Query.Eof do
    begin
      List.Add(Make(Query));
      Query.Next;
    end;
  finally
    Unprepare(Query);
  end;
end;

class function TDaoLiteEntity<T>.Make(Query: TManagedQuery): T;
begin
  Result := T(inherited Make(Query));
end;

{ TDaoImageLite<T> }

class procedure TDaoImageLite<T>.SaveList(List: TList<T>; ReferenceParent: TGUID; ReferenceSecondaires: array of TGUID; UseTransaction: TManagedTransaction);
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
        begin // photos li�es (q1)
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
        begin // photos stock�es (q2)
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
            begin // conversion photos li�es en stock�es (q3)
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
            begin // conversion photos stock�es en li�es
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
        // photos renomm�es, r�ordonn�es, etc (q5)
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

class function TDaoPhotoLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryPhotoLite;
end;

class procedure TDaoPhotoLite.Fill(Entity: TPhotoLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Photo');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierPhoto'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['StockagePhoto'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

class function TDaoPhotoLite.getFieldsInfo: RFieldsInfo;
begin
  Result.TableName := 'Photos';
  Result.Pk := 'id_photo';
  Result.PkParent := 'id_parabd';
  Result.champFichier := 'fichierphoto';
  Result.champStockage := 'stockagephoto';
  Result.champImage := 'imagephoto';
end;

{ TDaoCouvertureLite }

class function TDaoCouvertureLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCouvertureLite;
end;

class procedure TDaoCouvertureLite.Fill(Entity: TCouvertureLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Couverture');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['StockageCouverture'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

class function TDaoCouvertureLite.getFieldsInfo: RFieldsInfo;
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

class function TDaoConversionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryConversionLite;
end;

class procedure TDaoConversionLite.Fill(Entity: TConversionLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Conversion');
  Entity.Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Entity.Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Entity.Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

{ TDaoEditeurLite }

class function TDaoEditeurLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditeurLite;
end;

class procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; const ID_Editeur: TGUID);
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

class procedure TDaoEditeurLite.GetFieldIndices;
begin
  inherited;
  IndexID_Editeur := GetFieldIndex('ID_Editeur');
  IndexNomEditeur := GetFieldIndex('NomEditeur');
end;

class procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; Query: TManagedQuery);
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

class procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Personne');
  Entity.Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

class function TDaoPersonnageLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryPersonnageLite;
end;

class procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; const ID_Personne: TGUID);
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

class function TDaoAuteurSerieLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurSerieLite;
end;

class procedure TDaoAuteurSerieLite.Fill(Entity: TAuteurSerieLite; Query: TManagedQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoPersonnageLite.Make(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
  finally
    PPersonne.Free;
  end;
end;

class procedure TDaoAuteurSerieLite.Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_Serie := ReferenceSerie;
  Entity.Metier := Metier;
end;

{ TDaoAuteurAlbumLite }

class procedure TDaoAuteurAlbumLite.Fill(Entity: TAuteurAlbumLite; Query: TManagedQuery);
begin
  TDaoAuteurSerieLite.Fill(Entity, Query);
  Entity.ID_Album := NonNull(Query, 'ID_Album');
end;

class function TDaoAuteurAlbumLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurAlbumLite;
end;

class procedure TDaoAuteurAlbumLite.Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  TDaoAuteurSerieLite.Fill(Entity, Pe, ReferenceSerie, Metier);
  Entity.ID_Album := ReferenceAlbum;
end;

{ TDaoAuteurParaBDLite }

class function TDaoAuteurParaBDLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurParaBDLite;
end;

class procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Query: TManagedQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoPersonnageLite.Make(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_ParaBD'));
  finally
    PPersonne.Free;
  end;
end;

class procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_ParaBD := ReferenceParaBD;
end;

end.
