unit LoadCompletImport;

interface

uses
  Windows, SysUtils, Classes, LoadComplet, Generics.Collections, Graphics;

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

    if Trim(Texte) = '' then
    begin
      Result := GUID_FULL;
      Always := True;
      Exit;
    end;

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
        case ShowModalEx of
          mrCancel: Exit;
          mrIgnore:
          begin
            Result := GUID_FULL;
            Exit;
          end;
        end;

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

  function CheckListAuteurs(List: TObjectList<TAuteur>; OtherList: array of TObjectList<TAuteur>): Boolean;

    procedure RemoveAuteur(Index: integer);
    var
      i, j: Integer;
      nom: string;
    begin
      nom := List[Index].Personne.Nom;
      for i := Low(OtherList) to High(OtherList) do
        for j := Pred(OtherList[i].Count) downto 0 do
          if SameText(OtherList[i][j].Personne.Nom, Nom) then
            OtherList[i].Delete(j);
      List.Delete(Index);
    end;

  var
    dummyID: TGUID;

    procedure AcceptAuteur(Index: Integer);
    var
      i, j: Integer;
      nom: string;
    begin
      nom := List[Index].Personne.Nom;
      for i := Low(OtherList) to High(OtherList) do
        for j := Pred(OtherList[i].Count) downto 0 do
          if SameText(OtherList[i][j].Personne.Nom, Nom) then
            OtherList[i][j].Personne.Fill(dummyID);
      List[Index].Personne.Fill(dummyID);
    end;

  var
    i: Integer;
  begin
    Result := False;
    for i := Pred(List.Count) downto 0 do
      if IsEqualGUID(List[i].Personne.ID, GUID_NULL) then
      begin
        dummyID := CheckValue(List[i].Personne.Nom, vmPersonnes);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        if IsEqualGUID(dummyID, GUID_FULL) then
          RemoveAuteur(i)
        else
          List[i].Personne.Fill(dummyID);
      end;
    Result := True;
  end;

var
  dummyID: TGUID;
  i, j: Integer;
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

    if not CheckListAuteurs(Scenaristes, [Dessinateurs, Coloristes, Serie.Scenaristes, Serie.Dessinateurs, Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(Dessinateurs, [Coloristes, Serie.Scenaristes, Serie.Dessinateurs, Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(Coloristes, [Serie.Scenaristes, Serie.Dessinateurs, Serie.Coloristes]) then
      Exit;

    if not CheckListAuteurs(Serie.Scenaristes, [Serie.Dessinateurs, Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(Serie.Dessinateurs, [Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(Serie.Coloristes, []) then
      Exit;

    for i := Pred(Serie.Genres.Count) downto 0 do
      if IsEqualGUID(StringToGUIDDef(Serie.Genres.Names[i], GUID_NULL), GUID_NULL) then
      begin
        dummyID := CheckValue(Serie.Genres[i], vmGenres);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        if IsEqualGUID(dummyID, GUID_FULL) then
          Serie.Genres.Delete(i)
        else
          Serie.Genres[i] := GUIDToString(dummyID) + '=' + Serie.Genres[i];
      end;

    dummyID := CheckValue(Serie.Titre, vmSeries, GUID_NULL, Serie);
    if IsEqualGUID(dummyID, GUID_NULL) then
      Exit;
    if not IsEqualGUID(dummyID, GUID_FULL) then
      ID_Serie := dummyID;

    if IsEqualGUID(Serie.Editeur.ID_Editeur, GUID_NULL) then
    begin
      dummyID := CheckValue(Serie.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Serie.Editeur);
      if IsEqualGUID(dummyID, GUID_NULL) then
        Exit;
      if not IsEqualGUID(dummyID, GUID_FULL) then
      begin
        for j := 0 to Pred(Editions.Editions.Count) do
          if SameText(Serie.Editeur.NomEditeur, Editions.Editions[j].Editeur.NomEditeur) then
            Editions.Editions[j].Editeur.Fill(dummyID);
        Serie.Editeur.Fill(dummyID);
      end;
    end;

    if (Serie.Collection.NomCollection <> '') and IsEqualGUID(Serie.Collection.ID, GUID_NULL) then
    begin
      dummyID := CheckValue(Serie.Collection.NomCollection, vmCollections, dummyID);
      if IsEqualGUID(dummyID, GUID_NULL) then
        Exit;
      if not IsEqualGUID(dummyID, GUID_FULL) then
      begin
        for j := 0 to Pred(Editions.Editions.Count) do
          if SameText(Serie.Collection.NomCollection, Editions.Editions[j].Collection.NomCollection) then
            Editions.Editions[j].Collection.Fill(dummyID);
        Serie.Collection.Fill(dummyID);
      end;
    end;

    for i := 0 to Pred(Editions.Editions.Count) do
    begin
      if IsEqualGUID(Editions.Editions[i].Editeur.ID_Editeur, GUID_NULL) then
      begin
        dummyID := CheckValue(Editions.Editions[i].Editeur.NomEditeur, vmEditeurs, GUID_NULL, Editions.Editions[i].Editeur);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        if not IsEqualGUID(dummyID, GUID_FULL) then
          Editions.Editions[i].Editeur.Fill(dummyID);
      end;

      if IsEqualGUID(Editions.Editions[i].Collection.ID, GUID_NULL) then
      begin
        if Editions.Editions[i].Collection.NomCollection <> '' then
        begin
          dummyID := CheckValue(Editions.Editions[i].Collection.NomCollection, vmCollections, dummyID);
          if IsEqualGUID(dummyID, GUID_NULL) then
            Exit;
          if not IsEqualGUID(dummyID, GUID_FULL) then
            Editions.Editions[i].Collection.Fill(dummyID);
        end;
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
  Couverture: TCouverture;
  tmpFile: string;
  P: PChar;
  sl: TStringList;
begin
  Result := -1;

  SetLength(tmpFile, MAX_PATH + 1);
  FillMemory(@tmpFile[1], Length(tmpFile) * SizeOf(Char), 1);
  GetTempFileName(TempPath, 'bdk', 0, @tmpFile[1]);
  P := @tmpFile[1];
  while P^ <> #0 do
    Inc(P);
  SetLength(tmpFile, (Integer(P) - Integer(@tmpFile[1])) div SizeOf(Char));

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
end;

end.
