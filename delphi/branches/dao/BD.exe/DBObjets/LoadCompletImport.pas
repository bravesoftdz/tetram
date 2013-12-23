unit LoadCompletImport;

interface

uses
  Windows, SysUtils, Classes, Forms, Entities.Full, Generics.Collections, Graphics;

procedure Import(Self: TAlbumFull);


implementation

uses
  IOUtils, UIB, Commun, VirtualTreeBdtk, UfrmControlImport, Controls, UdmPrinc, WinInet, UHistorique, Proc_Gestions, Editions, UfrmValidationImport, UNet,
  Entities.Lite, CommonConst, Procedures, UMetadata, Divers, Entities.DaoDBLite, Entities.DaoDBFull,
  ProceduresBDtk, Entities.Common;

procedure Import(Self: TAlbumFull);
var
  Qry: TUIBQuery;
  Auteur: TAuteurLite;
  frmValidationImport: TfrmValidationImport;
  choosenText: string;

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
    Qry.Params.AsString[0] := Copy(Texte, 1, Qry.Params.MaxStrLen[0]);
    Qry.Params.AsInteger[1] := Integer(TypeData);
    Qry.Params.AsString[2] := GUIDToString(ParentID);
    Qry.Open;
    if not Qry.Eof and Qry.Bof then
    begin
      Result := StringToGUID(Qry.Fields.AsString[0]);
      Always := Qry.Fields.AsInteger[1] = 1;
    end;
  end;

  function CheckValue(Texte: string; TypeData: TVirtualMode; const ParentID: TGUID; Objet: TObjetFull = nil): TGUID; overload;
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

        frmValidationImport.Left := Application.MainForm.Monitor.Left + (Application.MainForm.Monitor.Width - (frmValidationImport.Width + Width)) div 2;
        Left := frmValidationImport.Left + frmValidationImport.Width;
        frmValidationImport.Top := Application.MainForm.Monitor.Top + (Application.MainForm.Monitor.Height - frmValidationImport.Height) div 2;
        Top := Application.MainForm.Monitor.Top + (Application.MainForm.Monitor.Height - Height) div 2;
        Position := poDesigned;

        Result := GUID_NULL; // on réinitialise pour être sûr de ne pas avoir de retour en cas d'annulation
        case ShowModalEx of
          mrCancel:
            Exit;
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
        choosenText := SelectedText;

        Qry.SQL.Text :=
          'update or insert into import_associations (chaine, id, parentid, typedata, always) values (:chaine, :id, :parentid, :typedata, :always)';
        Qry.Prepare(True);
        // pourquoi l'utilisation du mot clé "const" sur le paramètre Texte provoque ici une opération de pointeur incorrecte après
        // la création d'une nouvelle série est autre grand mystère
        Qry.Params.AsString[0] := Copy(Texte, 1, Qry.Params.MaxStrLen[0]);
        Qry.Params.AsString[1] := GUIDToString(Result);
        Qry.Params.AsString[2] := GUIDToString(ParentID);
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

  function CheckListAuteurs(List: TList<TAuteurLite>; const OtherList: array of TList<TAuteurLite>): Boolean;
  var
    dummyID: TGUID;
    i, j, k: Integer;
    Accept: Boolean;
    Nom: string;
  begin
    Result := False;
    for i := Pred(List.Count) downto 0 do
      if IsEqualGuid(List[i].Personne.ID, GUID_NULL) then
      begin
        dummyID := CheckValue(List[i].Personne.Nom, vmPersonnes);
        if IsEqualGuid(dummyID, GUID_NULL) then
          Exit;

        Accept := not IsEqualGuid(dummyID, GUID_FULL);

        Nom := List[i].Personne.Nom;
        for j := low(OtherList) to high(OtherList) do
          for k := Pred(OtherList[j].Count) downto 0 do
            if SameText(OtherList[j][k].Personne.Nom, Nom) then
              if Accept then
                TDaoPersonnageLite.Fill(OtherList[j][k].Personne, dummyID)
              else
                OtherList[j].Delete(k);
        if Accept then
          TDaoPersonnageLite.Fill(List[i].Personne, dummyID)
        else
          List.Delete(i);

        frmValidationImport.Album := Self;
      end;
    Result := True;
  end;

var
  dummyID: TGUID;
  i: Integer;
  PA: TAuteurLite;
  DefaultEdition, Edition, Edition2: TEditionFull;
begin
  with Self do
  begin
    frmValidationImport := TfrmValidationImport.Create(nil);
    try
      frmValidationImport.Album := Self;
      if frmValidationImport.ShowModal <> mrOk then
        Exit;
      frmValidationImport.framBoutons1.Visible := False;
      frmValidationImport.Show;

      Qry := TUIBQuery.Create(nil);
      try
        Qry.Transaction := GetTransaction(DMPrinc.UIBDataBase);

        frmValidationImport.PageControl1.ActivePageIndex := 0;
        if not CheckListAuteurs(Scenaristes, [Dessinateurs, Coloristes, Serie.Scenaristes, Serie.Dessinateurs, Serie.Coloristes]) then
          Exit;
        if not CheckListAuteurs(Dessinateurs, [Coloristes, Serie.Scenaristes, Serie.Dessinateurs, Serie.Coloristes]) then
          Exit;
        if not CheckListAuteurs(Coloristes, [Serie.Scenaristes, Serie.Dessinateurs, Serie.Coloristes]) then
          Exit;

        frmValidationImport.PageControl1.ActivePageIndex := 1;
        if not CheckListAuteurs(Serie.Scenaristes, [Serie.Dessinateurs, Serie.Coloristes]) then
          Exit;
        if not CheckListAuteurs(Serie.Dessinateurs, [Serie.Coloristes]) then
          Exit;
        if not CheckListAuteurs(Serie.Coloristes, []) then
          Exit;

        for i := Pred(Serie.Genres.Count) downto 0 do
          if IsEqualGuid(StringToGUIDDef(Serie.Genres.Names[i], GUID_NULL), GUID_NULL) then
          begin
            dummyID := CheckValue(Serie.Genres[i], vmGenres);
            if IsEqualGuid(dummyID, GUID_NULL) then
              Exit;
            if IsEqualGuid(dummyID, GUID_FULL) then
              Serie.Genres.Delete(i)
            else
              Serie.Genres[i] := GUIDToString(dummyID) + '=' + choosenText;
            frmValidationImport.Album := Self;
          end;

        if IsEqualGuid(Serie.Editeur.ID_Editeur, GUID_NULL) then
        begin
          dummyID := CheckValue(Serie.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Serie.Editeur);
          if IsEqualGuid(dummyID, GUID_NULL) then
            Exit;
          if IsEqualGuid(dummyID, GUID_FULL) then
          begin
            for Edition in Editions.Editions do
              if SameText(Serie.Editeur.NomEditeur, Edition.Editeur.NomEditeur) then
              begin
                Edition.Editeur.NomEditeur := '';
                Edition.Collection.NomCollection := '';
              end;
            Serie.Editeur.NomEditeur := '';
            Serie.Collection.NomCollection := '';
          end
          else
          begin
            for Edition in Editions.Editions do
              if SameText(Serie.Editeur.NomEditeur, Edition.Editeur.NomEditeur) then
              begin
                TDaoEditeurFull.Fill(Edition.Editeur, dummyID);
                TDaoEditeurLite.Fill(Edition.Collection.Editeur, dummyID);
              end;
            TDaoEditeurFull.Fill(Serie.Editeur, dummyID);
          end;
          frmValidationImport.Album := Self;
        end;

        if (Serie.Collection.NomCollection <> '') and IsEqualGuid(Serie.Collection.ID, GUID_NULL) then
        begin
          dummyID := CheckValue(Serie.Collection.NomCollection, vmCollections, Serie.Editeur.ID_Editeur);
          if IsEqualGuid(dummyID, GUID_NULL) then
            Exit;
          if IsEqualGuid(dummyID, GUID_FULL) then
          begin
            for Edition in Editions.Editions do
              if IsEqualGuid(Serie.Editeur.ID_Editeur, Edition.Editeur.ID_Editeur) and SameText(Serie.Collection.NomCollection, Edition.Collection.NomCollection)
              then
                Edition.Collection.NomCollection := '';
            Serie.Collection.NomCollection := '';
          end
          else
          begin
            for Edition in Editions.Editions do
              if IsEqualGuid(Serie.Editeur.ID_Editeur, Edition.Editeur.ID_Editeur) and SameText(Serie.Collection.NomCollection, Edition.Collection.NomCollection)
              then
                TDaoCollectionLite.Fill(Edition.Collection, dummyID);
            TDaoCollectionLite.Fill(Serie.Collection, dummyID);
          end;
          frmValidationImport.Album := Self;
        end;

        dummyID := CheckValue(Serie.TitreSerie, vmSeries, GUID_NULL, Serie);
        if IsEqualGuid(dummyID, GUID_NULL) then
          Exit;
        if not IsEqualGuid(dummyID, GUID_FULL) then
        begin
          TDaoSerieFull.Fill(Serie, dummyID);

          if Scenaristes.Count + Dessinateurs.Count + Coloristes.Count = 0 then
          begin
            for Auteur in Serie.Scenaristes do
            begin
              PA := TAuteurLite.Create;
              TDaoAuteurLite.Fill(PA, Auteur.Personne, ID_Album, GUID_NULL, TMetierAuteur(0));
              Scenaristes.Add(PA);
            end;

            for Auteur in Serie.Dessinateurs do
            begin
              PA := TAuteurLite.Create;
              TDaoAuteurLite.Fill(PA, Auteur.Personne, ID_Album, GUID_NULL, TMetierAuteur(1));
              Dessinateurs.Add(PA);
            end;

            for Auteur in Serie.Coloristes do
            begin
              PA := TAuteurLite.Create;
              TDaoAuteurLite.Fill(PA, Auteur.Personne, ID_Album, GUID_NULL, TMetierAuteur(2));
              Coloristes.Add(PA);
            end;
          end;
        end;
        frmValidationImport.Album := Self;

        frmValidationImport.PageControl1.ActivePageIndex := 1;
        DefaultEdition := TDaoEditionFull.getInstance(GUID_NULL);
        try
          for Edition in Editions.Editions do
          begin
            if not IsEqualGuid(ID_Serie, GUID_FULL) then
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

            if IsEqualGuid(Edition.Editeur.ID_Editeur, GUID_NULL) then
            begin
              dummyID := CheckValue(Edition.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Edition.Editeur);
              if IsEqualGuid(dummyID, GUID_NULL) then
                Exit;
              if IsEqualGuid(dummyID, GUID_FULL) then
              begin
                for Edition2 in Editions.Editions do
                  if (Edition <> Edition2) and IsEqualGuid(Edition2.Editeur.ID_Editeur, GUID_NULL) and
                    SameText(Edition.Editeur.NomEditeur, Edition2.Editeur.NomEditeur) then
                  begin
                    Edition2.Editeur.NomEditeur := '';
                    Edition2.Collection.NomCollection := '';
                  end;
                Edition.Editeur.NomEditeur := '';
                Edition.Collection.NomCollection := '';
              end
              else
              begin
                for Edition2 in Editions.Editions do
                  if (Edition <> Edition2) and IsEqualGuid(Edition2.Editeur.ID_Editeur, GUID_NULL) and
                    SameText(Edition.Editeur.NomEditeur, Edition2.Editeur.NomEditeur) then
                  begin
                    TDaoEditeurFull.Fill(Edition2.Editeur, dummyID);
                    TDaoEditeurLite.Fill(Edition2.Collection.Editeur, dummyID);
                  end;
                TDaoEditeurFull.Fill(Edition.Editeur, dummyID);
                TDaoEditeurLite.Fill(Edition.Collection.Editeur, dummyID);
              end;
              frmValidationImport.Album := Self;
            end;

            if IsEqualGuid(Edition.Collection.ID, GUID_NULL) then
            begin
              if Edition.Collection.NomCollection <> '' then
              begin
                dummyID := CheckValue(Edition.Collection.NomCollection, vmCollections, Edition.Editeur.ID_Editeur);
                if IsEqualGuid(dummyID, GUID_NULL) then
                  Exit;
                if IsEqualGuid(dummyID, GUID_FULL) then
                begin
                  for Edition2 in Editions.Editions do
                    if (Edition <> Edition2) and IsEqualGuid(Edition2.Collection.ID, GUID_NULL) and
                      IsEqualGuid(Edition.Editeur.ID_Editeur, Edition2.Editeur.ID_Editeur) and
                      SameText(Edition.Collection.NomCollection, Edition2.Collection.NomCollection) then
                      Edition2.Collection.NomCollection := '';
                  Edition.Collection.NomCollection := '';
                end
                else
                begin
                  for Edition2 in Editions.Editions do
                    if (Edition <> Edition2) and IsEqualGuid(Edition2.Collection.ID, GUID_NULL) and
                      IsEqualGuid(Edition.Editeur.ID_Editeur, Edition2.Editeur.ID_Editeur) and
                      SameText(Edition.Collection.NomCollection, Edition2.Collection.NomCollection) then
                      TDaoCollectionLite.Fill(Edition2.Collection, dummyID);
                  TDaoCollectionLite.Fill(Edition.Collection, dummyID);
                end;
              end;
              frmValidationImport.Album := Self;
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
    finally
      frmValidationImport.Free;
    end;
  end;
end;

end.
