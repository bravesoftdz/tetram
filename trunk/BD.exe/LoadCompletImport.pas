unit LoadCompletImport;

interface

uses
  Windows, SysUtils, Classes, LoadComplet, Generics.Collections;

type
  TAlbumCompletHelper = class helper for TAlbumComplet
    procedure Import;
  end;

  TEditionCompleteHelper = class helper for TEditionComplete
    function AddImageFromURL(const URL: string; TypeImage: Integer): Integer;
  end;


implementation

uses
  UIB, Commun, VirtualTree, UfrmControlImport, Controls, UdmPrinc, WinInet,
  UHistorique, Proc_Gestions, Editions, UfrmValidationImport, UNet,
  TypeRec, CommonConst, Procedures;

procedure TAlbumCompletHelper.Import;
var
  Qry: TUIBQuery;

  function SearchAssociation(const Texte: string; TypeData: TVirtualMode; out Always: Boolean; ParentID: TGUID): TGUID;
  begin
    Result := GUID_NULL;

    Qry.SQL.Text := 'select id, always from import_associations where chaine = :chaine and typedata = :typedata and parentid = :parentid';
    Qry.Prepare(True);
    Qry.Params.AsString[0] := Copy(Texte, 1, Qry.Params.SQLLen[0]);
    Qry.Params.AsInteger[1] := Integer(TypeData);
    Qry.Params.AsString[2] := GUIDToString(ParentID);
    Qry.Open;
    if not Qry.Eof and Qry.Bof then
    begin
      Result := StringToGUID(Qry.Fields.AsString[0]);
      Always := Qry.Fields.AsInteger[1] = 1;
    end;
  end;

  function CheckValue(const Texte: string; TypeData: TVirtualMode; ParentID: TGUID; Objet: TObjetComplet = nil): TGUID; overload;
  var
    Toujours: Boolean;
  begin
    Result := SearchAssociation(Texte, TypeData, Toujours, ParentID);
    if not IsEqualGuid(Result, GUID_NULL) and Toujours then
      Exit;

    with TfrmControlImport.Create(nil) do
      try
        Mode := TypeData;
        framVTEdit1.ParentValue := ParentID;
        ObjetImport := Objet;
        Label2.Caption := Texte;
        if not IsEqualGuid(Result, GUID_NULL) then
          framVTEdit1.CurrentValue := Result
        else
        begin
          // on recherche le premier item correspondant
          framVTEdit1.VTEdit.Text := Texte;
          // on force l'edit à afficher le texte de l'item sélectionné
          framVTEdit1.VTEdit.CurrentValue := framVTEdit1.VTEdit.PopupWindow.TreeView.CurrentValue;
        end;

        Result := GUID_NULL; // on réinitialise pour être sûr de ne pas avoir de retour en cas d'annulatfion
        if ShowModalEx <> mrOk then
          Exit;

        Result := framVTEdit1.CurrentValue;

        Qry.SQL.Text := 'update or insert into import_associations (chaine, id, parentid, typedata, always) values (:chaine, :id, :parentid, :typedata, :always)';
        Qry.Prepare(True);
        Qry.Params.AsString[0] := Copy(Texte, 1, Qry.Params.SQLLen[0]);
        Qry.Params.AsString[1] := GuidToString(Result);
        Qry.Params.AsString[2] := GuidToString(ParentID);
        Qry.Params.AsInteger[3] := Integer(TypeData);
        Qry.Params.AsBoolean[4] := CheckBox1.Checked;
        Qry.Execute;
      finally
        Free;
      end;
    Qry.Transaction.Commit;
  end;

  function CheckValue(const Texte: string; TypeData: TVirtualMode): TGUID; inline; overload;
  begin
    Result := CheckValue(Texte, TypeData, GUID_NULL);
  end;

  function CheckListAuteurs(List: TObjectList<TAuteur>): Boolean;
  var
    dummyID: TGUID;
    i: Integer;
  begin
    Result := False;
    for i := 0 to Pred(List.Count) do
      if IsEqualGUID(List[i].Personne.ID, GUID_NULL) then
      begin
        dummyID := CheckValue(List[i].Personne.Nom, vmPersonnes);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        List[i].Personne.Fill(dummyID);
      end;
    Result := True;
  end;

var
  dummyID: TGUID;
  i: Integer;
begin
  with TfrmValidationImport.Create(nil) do
    try
      Album := Self;
      if ShowModal <> mrOk then
        Exit;
    finally
      Free;
    end;

  Qry := TUIBQuery.Create(nil);
  try
    Qry.Transaction := GetTransaction(DMPrinc.UIBDataBase);

    dummyID := CheckValue(Serie.Titre, vmSeries, GUID_NULL, Serie);
    if IsEqualGUID(dummyID, GUID_NULL) then
      Exit;
    ID_Serie := dummyID;

    if not CheckListAuteurs(Scenaristes) then
      Exit;
    if not CheckListAuteurs(Dessinateurs) then
      Exit;
    if not CheckListAuteurs(Coloristes) then
      Exit;

    if not CheckListAuteurs(Serie.Scenaristes) then
      Exit;
    if not CheckListAuteurs(Serie.Dessinateurs) then
      Exit;
    if not CheckListAuteurs(Serie.Coloristes) then
      Exit;

    if IsEqualGUID(Serie.Editeur.ID_Editeur, GUID_NULL) then
    begin
      dummyID := CheckValue(Serie.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Serie.Editeur);
      if IsEqualGUID(dummyID, GUID_NULL) then
        Exit;
      Serie.Editeur.Fill(dummyID);
    end;

    if (Serie.Collection.NomCollection <> '') and IsEqualGUID(Serie.Collection.ID, GUID_NULL) then
    begin
      dummyID := CheckValue(Serie.Collection.NomCollection, vmCollections, dummyID);
      if IsEqualGUID(dummyID, GUID_NULL) then
        Exit;
      Serie.Collection.Fill(dummyID);
    end;

    for i := 0 to Pred(Editions.Editions.Count) do
    begin
      dummyID := CheckValue(Editions.Editions[i].Editeur.NomEditeur, vmEditeurs, GUID_NULL, Editions.Editions[i].Editeur);
      if IsEqualGUID(dummyID, GUID_NULL) then
        Exit;
      Editions.Editions[i].Editeur.Fill(dummyID);

      if Editions.Editions[i].Collection.NomCollection <> '' then
      begin
        dummyID := CheckValue(Editions.Editions[i].Collection.NomCollection, vmCollections, dummyID);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        Editions.Editions[i].Collection.Fill(dummyID);
      end;
    end;

    Qry.Transaction.Commit;
  finally
    Qry.Transaction.Free;
    Qry.Free;
  end;

  if IsEqualGUID(ID_Album, GUID_NULL) then
    New(False);
  CreationAlbum(Self);
end;

function TEditionCompleteHelper.AddImageFromURL(const URL: string; TypeImage: Integer): Integer;
var
  Stream: TFileStream;
  URLComponents: TURLComponents;
  Couverture: TCouverture;
  tmpFile: string;
  sl: TStringList;
begin
  Result := -1;

  ZeroMemory(@URLComponents, SizeOf(URLComponents));
  URLComponents.dwStructSize := SizeOf(URLComponents);
  URLComponents.dwHostNameLength := 1;
  URLComponents.dwSchemeLength := 1;
  URLComponents.dwUserNameLength := 1;
  URLComponents.dwPasswordLength := 1;
  URLComponents.dwUrlPathLength := 1;
  InternetCrackUrl(PChar(URL), Length(URL), 0, URLComponents);

  tmpFile := TempPath + ExtractFileName(StringReplace(URLComponents.lpszUrlPath, '/', '\', [rfReplaceAll]));
  if FileExists(tmpFile) then
    Stream := TFileStream.Create(tmpFile, fmOpenReadWrite, fmShareExclusive)
  else
    Stream := TFileStream.Create(tmpFile, fmCreate, fmShareExclusive);
  try
    if LoadStreamURL(URL, [], Stream) <> 200 then
      Exit;
  finally
    Stream.Free;
  end;

  Couverture := TCouverture.Create;
  Result := Couvertures.Add(Couverture);
  Couverture.NewNom := tmpFile;
  Couverture.OldNom := Couverture.NewNom;
  Couverture.NewStockee := TGlobalVar.Utilisateur.Options.ImagesStockees;
  Couverture.OldStockee := Couverture.NewStockee;
  Couverture.Categorie := TypeImage;
  sl := TStringList.Create;
  try
    // c'est pas génial de recharger la liste à chaque fois mais ça évite du code usine à gaz
    LoadStrings(6, sl);
    Couverture.sCategorie := sl.Values[IntToStr(TypeImage)];
  finally
    sl.Free;
  end;

  //  DeleteFile(tmpFile);
end;

end.
