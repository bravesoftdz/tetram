unit BDTK.Entities.Dao.Lite;

interface

uses
  System.SysUtils, System.Types, BD.Entities.Lite, BD.Entities.Metadata, System.Generics.Collections,
  System.SyncObjs, Vcl.ComCtrls, Vcl.StdCtrls, System.Classes, BD.DB.Connection, BD.Entities.Dao.Common,
  BD.Entities.Common, BD.Entities.Factory.Common, System.IOUtils, Vcl.Dialogs;

type
  // ce serait trop facile si Delphi acceptait cette syntaxe....
  // TClassEntities.DaoLite = class of TDaoLite<>;
  // je suis donc obligé de faire des classes "classique"
  TDaoLiteClass = class of TDaoLite;

  TDaoLite = class abstract(TDaoDBEntity)
  private
    class var cs: TCriticalSection;
    class var FPreparedQueries: TDictionary<TDaoLiteClass, TManagedQuery>;
    class function getPreparedQuery: TManagedQuery;

    class procedure GetFieldIndices; virtual;
    class function GetFieldIndex(const Name: string): Integer;
  public
    class constructor Create;
    class destructor Destroy;

    class procedure Prepare(Query: TManagedQuery);
    class procedure Unprepare(Query: TManagedQuery);

    class function Make(Query: TManagedQuery): TBaseLite;

    class procedure Fill(Entity: TBaseLite; Query: TManagedQuery); reintroduce; virtual; abstract;
    class procedure FillList(List: TList<TBaseLite>; Query: TManagedQuery);

    class procedure VideListe(LV: TListView; DoClear: Boolean = True); overload;
    class procedure VideListe(List: TList<TBaseLite>; DoClear: Boolean = True); overload;
    class procedure VideListe(ListBox: TListBox; DoClear: Boolean = True); overload;
  end;

  TDaoLiteEntity<T: TBaseLite> = class abstract(TDaoLite)
  public
    class function Make(Query: TManagedQuery): T; reintroduce;

    class procedure Fill(Entity: TBaseLite; Query: TManagedQuery); overload; override;
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
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TAlbumLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAlbumLite; const ID_Album: TGUID); overload;
    class procedure Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID); overload;
  end;

  TDaoParaBDLite = class(TDaoLiteEntity<TParaBDLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TParaBDLite; Query: TManagedQuery); override;
  end;

  TDaoSerieLite = class(TDaoLiteEntity<TSerieLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TSerieLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TSerieLite; const ID_Serie: TGUID); overload;
  end;

  TDaoEditionLite = class(TDaoLiteEntity<TEditionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TEditionLite; Query: TManagedQuery); override;
  end;

  TDaoEditeurLite = class(TDaoLiteEntity<TEditeurLite>)
  strict private
    class var IndexID_Editeur: Integer;
    class var IndexNomEditeur: Integer;
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TEditeurLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TEditeurLite; const ID_Editeur: TGUID); overload;
  end;

  TDaoCollectionLite = class(TDaoLiteEntity<TCollectionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TCollectionLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TCollectionLite; const ID_Collection: TGUID); overload;
  end;

  TDaoPersonnageLite = class(TDaoLiteEntity<TPersonnageLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TPersonnageLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TPersonnageLite; const ID_Personne: TGUID); overload;
  end;

  TDaoAuteurSerieLite = class(TDaoLiteEntity<TAuteurSerieLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurSerieLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoAuteurAlbumLite = class(TDaoLiteEntity<TAuteurAlbumLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurAlbumLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoAuteurParaBDLite = class(TDaoLiteEntity<TAuteurParaBDLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurParaBDLite; Query: TManagedQuery); overload; override;
    class procedure Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID); overload;
  end;

  TDaoUniversLite = class(TDaoLiteEntity<TUniversLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
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
    class function FactoryClass: TFactoryClass; override;
    class function getFieldsInfo: RFieldsInfo; override;
  public
    class procedure Fill(Entity: TPhotoLite; Query: TManagedQuery); override;
  end;

  TDaoCouvertureLite = class(TDaoImageLite<TCouvertureLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
    class function getFieldsInfo: RFieldsInfo; override;
  public
    class procedure Fill(Entity: TCouvertureLite; Query: TManagedQuery); override;
  end;

  TDaoGenreLite = class(TDaoLiteEntity<TGenreLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TGenreLite; Query: TManagedQuery); override;
  end;

  TDaoConversionLite = class(TDaoLiteEntity<TConversionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TConversionLite; Query: TManagedQuery); override;
  end;

implementation

uses
  BD.Utils.StrUtils, uiblib, BD.Entities.Factory.Lite, BDTK.GUI.Utils,
  BD.Common, BD.Utils.GUIUtils, BD.Entities.Types;

{ TDaoLite<T> }

class constructor TDaoLite.Create;
begin
  cs := nil;
  FPreparedQueries := TDictionary<TDaoLiteClass, TManagedQuery>.Create;
end;

class destructor TDaoLite.Destroy;
begin
  FPreparedQueries.Free;
  cs.Free;
end;

class procedure TDaoLite.FillList(List: TList<TBaseLite>; Query: TManagedQuery);
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

class function TDaoLite.GetFieldIndex(const Name: string): Integer;
begin
  Result := getPreparedQuery.GetFieldIndex(Name);
end;

class procedure TDaoLite.GetFieldIndices;
begin
  Assert(getPreparedQuery <> nil, 'Doit être préparé avant');
end;

class function TDaoLite.getPreparedQuery: TManagedQuery;
begin
  FPreparedQueries.TryGetValue(Self, Result);
end;

class function TDaoLite.Make(Query: TManagedQuery): TBaseLite;
begin
  Result := getInstance as TBaseLite;
  Fill(Result, Query);
end;

class procedure TDaoLite.Prepare(Query: TManagedQuery);
var
  p: TManagedQuery;
begin
  // Ne peut pas être préparée plusieurs fois
  p := getPreparedQuery;
  if (p <> nil) or (p = Query) then
    Exit;

  if not Assigned(cs) then
    cs := TCriticalSection.Create;
  cs.Enter;
  FPreparedQueries.Add(Self, Query);
  GetFieldIndices;
end;

class procedure TDaoLite.Unprepare(Query: TManagedQuery);
var
  p: TPair<TDaoLiteClass, TManagedQuery>;
begin
  if getPreparedQuery <> Query then
    Exit;

  for p in FPreparedQueries do
    if p.Value = Query then
      FPreparedQueries.Remove(p.Key);

  cs.Release;
end;

class procedure TDaoLite.VideListe(LV: TListView; DoClear: Boolean);
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

class procedure TDaoLite.VideListe(List: TList<TBaseLite>; DoClear: Boolean);
var
  i: Integer;
begin
  try
    for i := 0 to Pred(List.Count) do
      List[i].Free;
  finally
    if DoClear then
      List.Clear;
  end;
end;

class procedure TDaoLite.VideListe(ListBox: TListBox; DoClear: Boolean);
var
  i: Integer;
begin
  try
    for i := 0 to Pred(ListBox.Items.Count) do
    begin
      ListBox.Items.Objects[i].Free;
    end;
  finally
    if DoClear then
      ListBox.Items.Clear;
  end;
end;

{ TDaoLiteEntity<T> }

class procedure TDaoLiteEntity<T>.Fill(Entity: TBaseLite; Query: TManagedQuery);
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
      qry2.SQL.Add(', ' + s);
    qry2.SQL.Add(') values (');
    qry2.SQL.Add('  :pk_parent, :fichier, 1, :ordre, :image, :categorieimage');
    for s in fi.PkSec do
      qry2.SQL.Add(', :' + s);
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
          pi.NewNom := SearchNewFileName(TGlobalVar.RepImages, ExtractFileName(pi.NewNom), True);
          qry6.Params.ByNameAsString['chemin'] := TGlobalVar.RepImages;
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
            qry2.Params.ByNameAsString[fi.PkSec[i]] := GUIDToString(ReferenceSecondaires[i]);
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
                FichiersImages.Add(TPath.Combine(TGlobalVar.RepImages, pi.NewNom))
              else
                FichiersImages.Add(pi.NewNom);
              pi.NewNom := TPath.GetFileNameWithoutExtension(pi.NewNom);
            end
            else
            begin // conversion photos stockées en liées
              pi.NewNom := SearchNewFileName(TGlobalVar.RepImages, pi.NewNom + '.jpg', True);
              qry6.Params.ByNameAsString['chemin'] := TGlobalVar.RepImages;
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

class function TDaoPhotoLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryPhotoLite;
end;

class procedure TDaoPhotoLite.Fill(Entity: TPhotoLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Photo');
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
  Entity.ID := Query.NotNull('ID_Couverture');
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
  Entity.ID := Query.NotNull('ID_Conversion');
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
    Entity.ID := Query.NotNull(IndexID_Editeur);
    Entity.NomEditeur := Query.NotNull(IndexNomEditeur, '');
  end
  else
  begin
    Entity.ID := Query.NotNull('ID_Editeur');
    Entity.NomEditeur := Query.NotNull('NomEditeur', '');
  end;
end;

{ TDaoPersonnageLite }

class procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Personne');
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
    Fill(Entity, PPersonne, Query.NotNull('ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
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
  Entity.ID_Album := Query.NotNull('ID_Album');
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
    Fill(Entity, PPersonne, Query.NotNull('ID_ParaBD'));
  finally
    PPersonne.Free;
  end;
end;

class procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_ParaBD := ReferenceParaBD;
end;

{ TDaoAlbumLite }

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; Query: TManagedQuery);
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
    Entity.ID := Query.NotNull(IndexID_Album);
    Entity.Titre := Query.Fields.AsString[IndexTitreAlbum];
    Entity.Tome := Query.Fields.AsInteger[IndexTome];
    Entity.TomeDebut := Query.Fields.AsInteger[IndexTomeDebut];
    Entity.TomeFin := Query.Fields.AsInteger[IndexTomeFin];
    Entity.ID_Serie := Query.NotNull(IndexID_Serie);
    Entity.Integrale := Query.Fields.AsBoolean[IndexIntegrale];
    Entity.HorsSerie := Query.Fields.AsBoolean[IndexHorsSerie];
    Entity.ID_Editeur := Query.NotNull(IndexID_Editeur);
    Entity.Serie := Query.NotNull(IndexTitreSerie, Entity.Serie);
    Entity.Editeur := Query.NotNull(IndexNomEditeur, Entity.Editeur);
    Entity.MoisParution := Query.NotNull(IndexMoisParution, Entity.MoisParution);
    Entity.AnneeParution := Query.NotNull(IndexAnneeParution, Entity.AnneeParution);
    Entity.Stock := Query.NotNull(IndexStock, Entity.Stock);
    Entity.Achat := Query.NotNull(IndexAchat, Entity.Achat);
    Entity.Complet := Query.NotNull(IndexComplet, Entity.Complet);
    Entity.Notation := Query.NotNull(IndexNotation, Entity.Notation);
  end
  else
  begin
    Entity.ID := Query.NotNull('ID_Album');
    Entity.Titre := Query.Fields.ByNameAsString['TitreAlbum'];
    Entity.Tome := Query.Fields.ByNameAsInteger['Tome'];
    Entity.TomeDebut := Query.Fields.ByNameAsInteger['TomeDebut'];
    Entity.TomeFin := Query.Fields.ByNameAsInteger['TomeFin'];
    Entity.ID_Serie := Query.NotNull('ID_Serie');
    Entity.Integrale := Query.Fields.ByNameAsBoolean['Integrale'];
    Entity.HorsSerie := Query.Fields.ByNameAsBoolean['HorsSerie'];
    Entity.ID_Editeur := Query.NotNull('ID_Editeur');
    Entity.Serie := Query.NotNull('TitreSerie', Entity.Serie);
    Entity.Editeur := Query.NotNull('NomEditeur', Entity.Editeur);
    Entity.MoisParution := Query.NotNull('MoisParution', Entity.MoisParution);
    Entity.AnneeParution := Query.NotNull('AnneeParution', Entity.AnneeParution);
    Entity.Stock := Query.NotNull('Stock', Entity.Stock);
    Entity.Achat := Query.NotNull('Achat', Entity.Achat);
    Entity.Complet := Query.NotNull('Complet', Entity.Complet);
    Entity.Notation := Query.NotNull('Notation', Entity.Notation);
  end;

  if Entity.Notation = 0 then
    Entity.Notation := 900;
end;

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album: TGUID);
begin
  Fill(Entity, ID_Album, GUID_NULL);
end;

class function TDaoAlbumLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAlbumLite;
end;

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID);
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

class procedure TDaoAlbumLite.GetFieldIndices;
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

class procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Collection');
  Entity.NomCollection := Query.Fields.ByNameAsString['NomCollection'];
  try
    TDaoEditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
end;

class function TDaoCollectionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCollectionLite;
end;

class procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; const ID_Collection: TGUID);
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

class procedure TDaoCollectionLite.GetFieldIndices;
begin
  inherited;
  TDaoEditeurLite.Prepare(getPreparedQuery);
end;

{ TDaoSerieLite }

class procedure TDaoSerieLite.Fill(Entity: TSerieLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Serie');
  Entity.TitreSerie := Query.Fields.ByNameAsString['TitreSerie'];
  try
    TDaoEditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
  try
    TDaoCollectionLite.Fill(Entity.Collection, Query);
  except
    Entity.Collection.Clear;
  end;
  Entity.Terminee := Query.NotNull('terminee', RTriStateValue.Default);
end;

class function TDaoSerieLite.FactoryClass: TFactoryClass;
begin
  Result := TFactorySerieLite;
end;

class procedure TDaoSerieLite.Fill(Entity: TSerieLite; const ID_Serie: TGUID);
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

class function TDaoEditionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditionLite;
end;

class procedure TDaoEditionLite.Fill(Entity: TEditionLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Edition');
  Entity.AnneeEdition := Query.Fields.ByNameAsInteger['AnneeEdition'];
  Entity.ISBN := Query.NotNull('ISBN', '');
  TDaoEditeurLite.Fill(Entity.Editeur, Query);
  TDaoCollectionLite.Fill(Entity.Collection, Query);
end;

class procedure TDaoEditionLite.GetFieldIndices;
begin
  inherited;
  // le TDaoEditeurLite.Prepare(getPreparedQuery) sera appelé par TDaoCollectionLite.Prepare(getPreparedQuery)
  // TDaoEditeurLite.Prepare(getPreparedQuery);
  TDaoCollectionLite.Prepare(getPreparedQuery);
end;

{ TDaoGenreLite }

class function TDaoGenreLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryGenreLite;
end;

class procedure TDaoGenreLite.Fill(Entity: TGenreLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Genre');
  Entity.Genre := Query.Fields.ByNameAsString['Genre'];
  Entity.Quantite := Query.NotNull('QuantiteGenre', 0);
end;

{ TDaoParaBDLite }

class function TDaoParaBDLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryParaBDLite;
end;

class procedure TDaoParaBDLite.Fill(Entity: TParaBDLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_ParaBD');
  Entity.Titre := Query.Fields.ByNameAsString['TitreParaBD'];
  Entity.ID_Serie := Query.NotNull('ID_Serie');
  Entity.Serie := Query.NotNull('TitreSerie', '');
  Entity.Achat := Query.NotNull('Achat', False);
  Entity.Complet := Query.NotNull('Complet', True);
  Entity.sCategorie := Query.NotNull('sCategorie', '');
end;

{ TDaoUniversLite }

class procedure TDaoUniversLite.Fill(Entity: TUniversLite; Query: TManagedQuery);
begin
  Entity.ID := Query.NotNull('ID_Univers');
  Entity.NomUnivers := Query.Fields.ByNameAsString['NomUnivers'];
end;

class function TDaoUniversLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryUniversLite;
end;

class procedure TDaoUniversLite.Fill(Entity: TUniversLite; const ID_Univers: TGUID);
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
