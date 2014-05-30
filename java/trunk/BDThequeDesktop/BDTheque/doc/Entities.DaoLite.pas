unit Entities.DaoLite;

interface

uses
  Entities.Lite
  // UMetadata,
  // Entities.DaoCommon,
  // Entities.Common, Entities.FactoriesCommon
  ;

type
  RFieldsInfo = record
    TableName: string;
    Pk: string;
    PkParent: string;
    PkSec: array of string;
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

class procedure TDaoConversionLite.Fill(Entity: TConversionLite; Query: TManagedQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Conversion');
  Entity.Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Entity.Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Entity.Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

end.
