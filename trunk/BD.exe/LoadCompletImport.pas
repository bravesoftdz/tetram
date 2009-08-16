unit LoadCompletImport;

interface

uses
  Windows, SysUtils, Classes, LoadComplet, Generics.Collections, Graphics;

procedure Import(Self: TAlbumComplet);

function AddImageFromURL(Edition: TEditionComplete; const URL: string; TypeImage: Integer): Integer;

implementation

uses
  UIB, Commun, VirtualTree, UfrmControlImport, Controls, UdmPrinc, WinInet,
  UHistorique, Proc_Gestions, Editions, UfrmValidationImport, UNet,
  TypeRec, CommonConst, Procedures, UMetadata, Divers;

procedure Import(Self: TAlbumComplet);
var
  Qry: TUIBQuery;
  Auteur: TAuteur;

  function SearchAssociation(Texte: string; TypeData: TVirtualMode; out Always: Boolean; const ParentID: TGUID): TGUID;
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

  function CheckValue(Texte: string; TypeData: TVirtualMode; const ParentID: TGUID; Objet: TObjetComplet = nil): TGUID; overload;
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

        Result := GUID_NULL; // on réinitialise pour être sûr de ne pas avoir de retour en cas d'annulation
        case ShowModalEx of
          mrCancel: Exit;
          mrIgnore:
          begin
            Result := GUID_FULL;
            Exit;
          end;
        end;

        // pourquoi on doit passer par une variable intermédiaire à cause des collections restera
        // un grand mystère pour moi
        // Result := framVTEdit1.CurrentValue;
        Result := SelectedValue;

        Qry.SQL.Text := 'update or insert into import_associations (chaine, id, parentid, typedata, always) values (:chaine, :id, :parentid, :typedata, :always)';
        Qry.Prepare(True);
        // pourquoi l'utilisation du mot clé "const" sur le paramètre Texte provoque ici une opération de pointeur incorrecte après
        // la création d'une nouvelle série est autre grand mystère
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

  function CheckValue(Texte: string; TypeData: TVirtualMode): TGUID; inline; overload;
  begin
    Result := CheckValue(Texte, TypeData, GUID_NULL);
  end;

  function CheckListAuteurs(List: TObjectList<TAuteur>; const OtherList: array of TObjectList<TAuteur>): Boolean;
  var
    dummyID: TGUID;
    i, j, k: Integer;
    Accept: Boolean;
    Nom: string;
  begin
    Result := False;
    for i := Pred(List.Count) downto 0 do
      if IsEqualGUID(List[i].Personne.ID, GUID_NULL) then
      begin
        dummyID := CheckValue(List[i].Personne.Nom, vmPersonnes);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;

        Accept := not IsEqualGUID(dummyID, GUID_FULL);

        Nom := List[i].Personne.Nom;
        for j := Low(OtherList) to High(OtherList) do
          for k := Pred(OtherList[j].Count) downto 0 do
            if SameText(OtherList[j][k].Personne.Nom, Nom) then
              if Accept then
                OtherList[j][k].Personne.Fill(dummyID)
              else
                OtherList[j].Delete(k);
        if Accept then
          List[i].Personne.Fill(dummyID)
        else
          List.Delete(i);
      end;
    Result := True;
  end;

var
  dummyID: TGUID;
  i, j: Integer;
  PA: TAuteur;
  DefaultEdition, Edition: TEditionComplete;
begin
  with Self do
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

      if IsEqualGUID(Serie.Editeur.ID_Editeur, GUID_NULL) then
      begin
        dummyID := CheckValue(Serie.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Serie.Editeur);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        if IsEqualGUID(dummyID, GUID_FULL) then
        begin
          Serie.Editeur.NomEditeur := '';
          Serie.Collection.NomCollection := '';
        end
        else
        begin
          for Edition in Editions.Editions do
            if SameText(Serie.Editeur.NomEditeur, Edition.Editeur.NomEditeur) then
            begin
              Edition.Editeur.Fill(dummyID);
              Edition.Collection.Editeur.Fill(dummyID);
            end;
          Serie.Editeur.Fill(dummyID);
        end;
      end;

      if (Serie.Collection.NomCollection <> '') and IsEqualGUID(Serie.Collection.ID, GUID_NULL) then
      begin
        dummyID := CheckValue(Serie.Collection.NomCollection, vmCollections, Serie.Editeur.ID_Editeur);
        if IsEqualGUID(dummyID, GUID_NULL) then
          Exit;
        if IsEqualGUID(dummyID, GUID_FULL) then
          Serie.Collection.NomCollection := ''
        else
        begin
          for Edition in Editions.Editions do
            if IsEqualGUID(Serie.Editeur.ID_Editeur, Edition.Editeur.ID_Editeur)
              and SameText(Serie.Collection.NomCollection, Edition.Collection.NomCollection) then
              Edition.Collection.Fill(dummyID);
          Serie.Collection.Fill(dummyID);
        end
      end;

      dummyID := CheckValue(Serie.Titre, vmSeries, GUID_NULL, Serie);
      if IsEqualGUID(dummyID, GUID_NULL) then
        Exit;
      if not IsEqualGUID(dummyID, GUID_FULL) then
      begin
        ID_Serie := dummyID;

        if Scenaristes.Count + Dessinateurs.Count + Coloristes.Count = 0 then
        begin
          for Auteur in Serie.Scenaristes do
          begin
            PA := TAuteur.Create;
            PA.Fill(Auteur.Personne, ID_Album, GUID_NULL, TMetierAuteur(0));
            Scenaristes.Add(PA);
          end;

          for Auteur in Serie.Dessinateurs do
          begin
            PA := TAuteur.Create;
            PA.Fill(Auteur.Personne, ID_Album, GUID_NULL, TMetierAuteur(0));
            Dessinateurs.Add(PA);
          end;

          for Auteur in Serie.Coloristes do
          begin
            PA := TAuteur.Create;
            PA.Fill(Auteur.Personne, ID_Album, GUID_NULL, TMetierAuteur(0));
            Coloristes.Add(PA);
          end;
        end;
      end;

      DefaultEdition := TEditionComplete.Create(GUID_NULL);
      try
        for Edition in Editions.Editions do
        begin
          if not IsEqualGUID(ID_Serie, GUID_FULL) then
          begin
            if Edition.Couleur = DefaultEdition.Couleur then
              Edition.Couleur := IIf(Serie.Couleur = -1, DefaultEdition.Couleur, Serie.Couleur = 1);
            if Edition.VO = DefaultEdition.VO then
              Edition.VO := IIf(Serie.VO = -1, DefaultEdition.VO, Serie.VO = 1);
            if Edition.Etat.Value = DefaultEdition.Etat.Value then
              Edition.Etat := MakeOption(IIf(Serie.Etat.Value = -1, DefaultEdition.Etat.Value, Serie.Etat.Value), '');
            if Edition.Reliure.Value = DefaultEdition.Reliure.Value then
              Edition.Reliure := MakeOption(IIf(Serie.Reliure.Value = -1, DefaultEdition.Reliure.Value, Serie.Reliure.Value), '');
            if Edition.Orientation.Value = DefaultEdition.Orientation.Value then
              Edition.Orientation := MakeOption(IIf(Serie.Orientation.Value = -1, DefaultEdition.Orientation.Value, Serie.Orientation.Value), '');
            if Edition.FormatEdition.Value = DefaultEdition.FormatEdition.Value then
              Edition.FormatEdition := MakeOption(IIf(Serie.FormatEdition.Value = -1, DefaultEdition.FormatEdition.Value, Serie.FormatEdition.Value), '');
            if Edition.SensLecture.Value = DefaultEdition.SensLecture.Value then
              Edition.SensLecture := MakeOption(IIf(Serie.SensLecture.Value = -1, DefaultEdition.SensLecture.Value, Serie.SensLecture.Value), '');
            if Edition.TypeEdition.Value = DefaultEdition.TypeEdition.Value then
              Edition.TypeEdition := MakeOption(IIf(Serie.TypeEdition.Value = -1, DefaultEdition.TypeEdition.Value, Serie.TypeEdition.Value), '');
          end;

          if IsEqualGUID(Edition.Editeur.ID_Editeur, GUID_NULL) then
          begin
            dummyID := CheckValue(Edition.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Edition.Editeur);
            if IsEqualGUID(dummyID, GUID_NULL) then
              Exit;
            if IsEqualGUID(dummyID, GUID_FULL) then
            begin
              Edition.Editeur.NomEditeur := '';
              Edition.Collection.NomCollection := '';
            end
            else
            begin
              Edition.Editeur.Fill(dummyID);
              Edition.Collection.Editeur.Fill(dummyID);
            end;
          end;

          if IsEqualGUID(Edition.Collection.ID, GUID_NULL) then
          begin
            if Edition.Collection.NomCollection <> '' then
            begin
              dummyID := CheckValue(Edition.Collection.NomCollection, vmCollections, Edition.Editeur.ID_Editeur);
              if IsEqualGUID(dummyID, GUID_NULL) then
                Exit;
              if IsEqualGUID(dummyID, GUID_FULL) then
                Edition.Collection.NomCollection := ''
              else
                Edition.Collection.Fill(dummyID);
            end;
          end;
        end;
      finally
        DefaultEdition.Free;
      end;

      Qry.Transaction.Commit;
      Self.ReadyToFusion := True;
    finally
      Qry.Transaction.Free;
      Qry.Free;
    end;
  end;
end;

function AddImageFromURL(Edition: TEditionComplete; const URL: string; TypeImage: Integer): Integer;
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
  GetTempFileName(PChar(TempPath), 'bdk', 0, @tmpFile[1]);
  P := @tmpFile[1];
  while P^ <> #0 do
    Inc(P);
  SetLength(tmpFile, (Integer(P) - Integer(@tmpFile[1])) div SizeOf(Char));

  if FileExists(tmpFile) then
    Stream := TFileStream.Create(tmpFile, fmOpenReadWrite, fmShareExclusive)
  else
    Stream := TFileStream.Create(tmpFile, fmCreate, fmShareExclusive);
  try
    Stream.Size := 0;
    if LoadStreamURL(URL, [], Stream) <> 200 then
      Exit;
  finally
    Stream.Free;
  end;

  Couverture := TCouverture.Create;
  Result := Edition.Couvertures.Add(Couverture);
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
