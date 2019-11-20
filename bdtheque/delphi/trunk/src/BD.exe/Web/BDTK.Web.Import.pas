unit BDTK.Web.Import;

interface

uses
  Winapi.Windows, SysUtils, Classes, Forms, BD.Entities.Full, Generics.Collections, Graphics,
  BDTK.Web.Forms.Preview;

procedure AssociateToDBEntities(AFormPreview: TfrmBDTKWebPreview);

implementation

uses
  uib, BD.Entities.Lite, BDTK.GUI.Controls.VirtualTree, BDTK.Web.Forms.Associate, BD.Utils.StrUtils, BDTK.Entities.Dao.Lite, BDTK.GUI.DataModules.Main, BDTK.Entities.Dao.Full,
  BD.Entities.Factory.Lite,
  BD.Entities.Metadata, System.UITypes, Divers, BD.Entities.Common, BD.Entities.Types;

function SearchAssociation(AQry: TUIBQuery; const ATexte: string; ATypeData: TVirtualMode; out AAlways: Boolean; const AParentID: TGUID): TGUID;
begin
  Result := GUID_NULL;

  if Trim(ATexte) = '' then
  begin
    Result := GUID_FULL;
    AAlways := True;
    Exit;
  end;

  AQry.SQL.Text := 'select id, always from import_associations where chaine = :chaine and typedata = :typedata and parentid = :parentid';
  AQry.Prepare(True);
  AQry.Params.AsString[0] := ATexte.Substring(0, AQry.Params.MaxStrLen[0]);
  AQry.Params.AsInteger[1] := Integer(ATypeData);
  AQry.Params.AsString[2] := GUIDToString(AParentID);
  AQry.Open;
  if not AQry.Eof and AQry.Bof then
  begin
    Result := StringToGUID(AQry.Fields.AsString[0]);
    AAlways := AQry.Fields.AsInteger[1] = 1;
  end;
end;

function CheckValue(AFormPreview: TfrmBDTKWebPreview; AQry: TUIBQuery; const ATexte: string; ATypeData: TVirtualMode; const AParentID: TGUID; AObjet: TObjetFull = nil; AGetChoosenText: TProc<string> = nil): TGUID; overload;
var
  Toujours: Boolean;
  frm: TfrmControlImport;
begin
  Result := SearchAssociation(AQry, ATexte, ATypeData, Toujours, AParentID);
  if not IsEqualGuid(Result, GUID_NULL) and Toujours then
    Exit;

  frm := TfrmControlImport.Create(nil);
  try
    frm.Mode := ATypeData;
    frm.framVTEdit1.ParentValue := AParentID;
    frm.ObjetImport := AObjet;
    frm.Label2.Caption := ATexte;
    if not IsEqualGuid(Result, GUID_NULL) then
      frm.framVTEdit1.CurrentValue := Result
    else
    begin
      // on recherche le premier item correspondant
      frm.framVTEdit1.VTEdit.Text := ATexte;
      // on force l'edit à afficher le texte de l'item sélectionné
      frm.framVTEdit1.VTEdit.CurrentValue := frm.framVTEdit1.VTEdit.PopupWindow.TreeView.CurrentValue;
    end;

    AFormPreview.Left := Application.MainForm.Monitor.Left + (Application.MainForm.Monitor.Width - (AFormPreview.Width + frm.Width)) div 2;
    frm.Left := AFormPreview.Left + AFormPreview.Width;
    AFormPreview.Top := Application.MainForm.Monitor.Top + (Application.MainForm.Monitor.Height - AFormPreview.Height) div 2;
    frm.Top := Application.MainForm.Monitor.Top + (Application.MainForm.Monitor.Height - frm.Height) div 2;
    frm.Position := poDesigned;

    Result := GUID_NULL; // on réinitialise pour être sûr de ne pas avoir de retour en cas d'annulation
    case frm.ShowModalEx of
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
    Result := frm.SelectedValue;
    if Assigned(AGetChoosenText) then
      AGetChoosenText(frm.SelectedText);

    AQry.SQL.Text := 'update or insert into import_associations (chaine, id, parentid, typedata, always) values (:chaine, :id, :parentid, :typedata, :always)';
    AQry.Prepare(True);
    AQry.Params.AsString[0] := ATexte.Substring(0, AQry.Params.MaxStrLen[0]);
    AQry.Params.AsString[1] := GUIDToString(Result);
    AQry.Params.AsString[2] := GUIDToString(AParentID);
    AQry.Params.AsInteger[3] := Integer(ATypeData);
    AQry.Params.AsBoolean[4] := frm.CheckBox1.Checked;
    AQry.Execute;
  finally
    frm.Free;
  end;
  AQry.Transaction.Commit;
end;

function CheckValue(AFormPreview: TfrmBDTKWebPreview; AQry: TUIBQuery; const ATexte: string; ATypeData: TVirtualMode): TGUID; inline; overload;
begin
  Result := CheckValue(AFormPreview, AQry, ATexte, ATypeData, GUID_NULL);
end;

function CheckListAuteurs(AFormPreview: TfrmBDTKWebPreview; AQry: TUIBQuery; List: TList<TAuteurSerieLite>; const OtherList: array of TList<TAuteurSerieLite>): Boolean; overload;
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
      dummyID := CheckValue(AFormPreview, AQry, List[i].Personne.Nom, vmPersonnes);
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

      AFormPreview.ReloadAlbum;
    end;
  Result := True;
end;

function CheckListAuteurs(AFormPreview: TfrmBDTKWebPreview; AQry: TUIBQuery; List: TList<TAuteurAlbumLite>; const OtherList: array of TList<TAuteurAlbumLite>; const OtherList2: array of TList<TAuteurSerieLite>): Boolean; overload;
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
      dummyID := CheckValue(AFormPreview, AQry, List[i].Personne.Nom, vmPersonnes);
      if IsEqualGuid(dummyID, GUID_NULL) then
        Exit;

      Accept := not IsEqualGuid(dummyID, GUID_FULL);

      Nom := List[i].Personne.Nom;
      for j := High(OtherList2) downto Low(OtherList2) do
        for k := 0 to Pred(OtherList2[j].Count) do
          if SameText(OtherList2[j][k].Personne.Nom, Nom) then
            if Accept then
              TDaoPersonnageLite.Fill(OtherList2[j][k].Personne, dummyID)
            else
              OtherList2[j].Delete(k);
      for j := Low(OtherList) to High(OtherList) do
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

      AFormPreview.ReloadAlbum;
    end;
  Result := True;
end;

procedure AssociateToDBEntities(AFormPreview: TfrmBDTKWebPreview);

  function Album: TAlbumFull;
  begin
    Result := AFormPreview.Album;
  end;

var
  Qry: TUIBQuery;
  Auteur: TAuteurSerieLite;
  dummyID: TGUID;
  i: Integer;
  PA: TAuteurAlbumLite;
  DefaultEdition, Edition, Edition2: TEditionFull;
begin
  Qry := dmPrinc.DBConnection.GetQuery;
  try
    AFormPreview.PageControl1.ActivePageIndex := 0;
    if not CheckListAuteurs(AFormPreview, Qry, Album.Scenaristes, [Album.Dessinateurs, Album.Coloristes], [Album.Serie.Scenaristes, Album.Serie.Dessinateurs, Album.Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(AFormPreview, Qry, Album.Dessinateurs, [Album.Coloristes], [Album.Serie.Scenaristes, Album.Serie.Dessinateurs, Album.Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(AFormPreview, Qry, Album.Coloristes, [], [Album.Serie.Scenaristes, Album.Serie.Dessinateurs, Album.Serie.Coloristes]) then
      Exit;

    AFormPreview.PageControl1.ActivePageIndex := 1;
    if not CheckListAuteurs(AFormPreview, Qry, Album.Serie.Scenaristes, [Album.Serie.Dessinateurs, Album.Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(AFormPreview, Qry, Album.Serie.Dessinateurs, [Album.Serie.Coloristes]) then
      Exit;
    if not CheckListAuteurs(AFormPreview, Qry, Album.Serie.Coloristes, []) then
      Exit;

    for i := Pred(Album.Serie.Univers.Count) downto 0 do
      if IsEqualGuid(Album.Serie.Univers[i].ID, GUID_NULL) then
      begin
        dummyID := CheckValue(AFormPreview, Qry, Album.Serie.Univers[i].NomUnivers, vmUnivers);
        if IsEqualGuid(dummyID, GUID_NULL) then
          Exit;
        if IsEqualGuid(dummyID, GUID_FULL) then
          Album.Serie.Univers.Delete(i)
        else
          TDaoUniversLite.Fill(Album.Serie.Univers[i], dummyID);
        AFormPreview.ReloadAlbum;
      end;

    for i := Pred(Album.Serie.Genres.Count) downto 0 do
      if IsEqualGuid(StringToGUIDDef(Album.Serie.Genres.Names[i], GUID_NULL), GUID_NULL) then
      begin
        var choosenText: string;
        dummyID := CheckValue(AFormPreview, Qry, Album.Serie.Genres[i], vmGenres, GUID_NULL, nil, procedure(AText: string) begin choosenText := AText; end);
        if IsEqualGuid(dummyID, GUID_NULL) then
          Exit;
        if IsEqualGuid(dummyID, GUID_FULL) then
          Album.Serie.Genres.Delete(i)
        else
          Album.Serie.Genres[i] := GUIDToString(dummyID) + '=' + choosenText;
        AFormPreview.ReloadAlbum;
      end;

    if IsEqualGuid(Album.Serie.Editeur.ID_Editeur, GUID_NULL) then
    begin
      dummyID := CheckValue(AFormPreview, Qry, Album.Serie.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Album.Serie.Editeur);
      if IsEqualGuid(dummyID, GUID_NULL) then
        Exit;
      if IsEqualGuid(dummyID, GUID_FULL) then
      begin
        for Edition in Album.Editions do
          if SameText(Album.Serie.Editeur.NomEditeur, Edition.Editeur.NomEditeur) then
          begin
            Edition.Editeur.NomEditeur := '';
            Edition.Collection.NomCollection := '';
          end;
        Album.Serie.Editeur.NomEditeur := '';
        Album.Serie.Collection.NomCollection := '';
      end
      else
      begin
        for Edition in Album.Editions do
          if SameText(Album.Serie.Editeur.NomEditeur, Edition.Editeur.NomEditeur) then
          begin
            TDaoEditeurFull.Fill(Edition.Editeur, dummyID, nil);
            TDaoEditeurLite.Fill(Edition.Collection.Editeur, dummyID);
          end;
        TDaoEditeurFull.Fill(Album.Serie.Editeur, dummyID, nil);
      end;
      AFormPreview.ReloadAlbum;
    end;

    if (Album.Serie.Collection.NomCollection <> '') and IsEqualGuid(Album.Serie.Collection.ID, GUID_NULL) then
    begin
      dummyID := CheckValue(AFormPreview, Qry, Album.Serie.Collection.NomCollection, vmCollections, Album.Serie.Editeur.ID_Editeur);
      if IsEqualGuid(dummyID, GUID_NULL) then
        Exit;
      if IsEqualGuid(dummyID, GUID_FULL) then
      begin
        for Edition in Album.Editions do
          if IsEqualGuid(Album.Serie.Editeur.ID_Editeur, Edition.Editeur.ID_Editeur) and SameText(Album.Serie.Collection.NomCollection, Edition.Collection.NomCollection) then
            Edition.Collection.NomCollection := '';
        Album.Serie.Collection.NomCollection := '';
      end
      else
      begin
        for Edition in Album.Editions do
          if IsEqualGuid(Album.Serie.Editeur.ID_Editeur, Edition.Editeur.ID_Editeur) and SameText(Album.Serie.Collection.NomCollection, Edition.Collection.NomCollection) then
            TDaoCollectionLite.Fill(Edition.Collection, dummyID);
        TDaoCollectionLite.Fill(Album.Serie.Collection, dummyID);
      end;
      AFormPreview.ReloadAlbum;
    end;

    dummyID := CheckValue(AFormPreview, Qry, Album.Serie.TitreSerie, vmSeries, GUID_NULL, Album.Serie);
    if IsEqualGuid(dummyID, GUID_NULL) then
      Exit;
    if not IsEqualGuid(dummyID, GUID_FULL) then
    begin
      TDaoSerieFull.Fill(Album.Serie, dummyID, nil);

      if Album.Scenaristes.Count + Album.Dessinateurs.Count + Album.Coloristes.Count = 0 then
      begin
        for Auteur in Album.Serie.Scenaristes do
        begin
          PA := TFactoryAuteurAlbumLite.getInstance;
          TDaoAuteurAlbumLite.Fill(PA, Auteur.Personne, Album.ID_Album, GUID_NULL, TMetierAuteur(0));
          Album.Scenaristes.Add(PA);
        end;

        for Auteur in Album.Serie.Dessinateurs do
        begin
          PA := TFactoryAuteurAlbumLite.getInstance;
          TDaoAuteurAlbumLite.Fill(PA, Auteur.Personne, Album.ID_Album, GUID_NULL, TMetierAuteur(1));
          Album.Dessinateurs.Add(PA);
        end;

        for Auteur in Album.Serie.Coloristes do
        begin
          PA := TFactoryAuteurAlbumLite.getInstance;
          TDaoAuteurAlbumLite.Fill(PA, Auteur.Personne, Album.ID_Album, GUID_NULL, TMetierAuteur(2));
          Album.Coloristes.Add(PA);
        end;
      end;
    end;
    AFormPreview.ReloadAlbum;

    AFormPreview.PageControl1.ActivePageIndex := 1;
    DefaultEdition := TDaoEditionFull.getInstance(GUID_NULL);
    try
      for Edition in Album.Editions do
      begin
        if not IsEqualGuid(Album.ID_Serie, GUID_FULL) then
        begin
          if Edition.Couleur = DefaultEdition.Couleur then
            Edition.Couleur := Album.Serie.Couleur.AsBoolean[DefaultEdition.Couleur];
          if Edition.VO = DefaultEdition.VO then
            Edition.VO := Album.Serie.VO.AsBoolean[DefaultEdition.VO];
          if Edition.Etat.Value = DefaultEdition.Etat.Value then
            Edition.Etat := ROption.Create(IIf(Album.Serie.Etat.Value = -1, DefaultEdition.Etat.Value, Album.Serie.Etat.Value), '');
          if Edition.Reliure.Value = DefaultEdition.Reliure.Value then
            Edition.Reliure := ROption.Create(IIf(Album.Serie.Reliure.Value = -1, DefaultEdition.Reliure.Value, Album.Serie.Reliure.Value), '');
          if Edition.Orientation.Value = DefaultEdition.Orientation.Value then
            Edition.Orientation := ROption.Create(IIf(Album.Serie.Orientation.Value = -1, DefaultEdition.Orientation.Value, Album.Serie.Orientation.Value), '');
          if Edition.FormatEdition.Value = DefaultEdition.FormatEdition.Value then
            Edition.FormatEdition := ROption.Create(IIf(Album.Serie.FormatEdition.Value = -1, DefaultEdition.FormatEdition.Value, Album.Serie.FormatEdition.Value), '');
          if Edition.SensLecture.Value = DefaultEdition.SensLecture.Value then
            Edition.SensLecture := ROption.Create(IIf(Album.Serie.SensLecture.Value = -1, DefaultEdition.SensLecture.Value, Album.Serie.SensLecture.Value), '');
          if Edition.TypeEdition.Value = DefaultEdition.TypeEdition.Value then
            Edition.TypeEdition := ROption.Create(IIf(Album.Serie.TypeEdition.Value = -1, DefaultEdition.TypeEdition.Value, Album.Serie.TypeEdition.Value), '');
        end;

        if IsEqualGuid(Edition.Editeur.ID_Editeur, GUID_NULL) then
        begin
          dummyID := CheckValue(AFormPreview, Qry, Edition.Editeur.NomEditeur, vmEditeurs, GUID_NULL, Edition.Editeur);
          if IsEqualGuid(dummyID, GUID_NULL) then
            Exit;
          if IsEqualGuid(dummyID, GUID_FULL) then
          begin
            for Edition2 in Album.Editions do
              if (Edition <> Edition2) and IsEqualGuid(Edition2.Editeur.ID_Editeur, GUID_NULL) and SameText(Edition.Editeur.NomEditeur, Edition2.Editeur.NomEditeur) then
              begin
                Edition2.Editeur.NomEditeur := '';
                Edition2.Collection.NomCollection := '';
              end;
            Edition.Editeur.NomEditeur := '';
            Edition.Collection.NomCollection := '';
          end
          else
          begin
            for Edition2 in Album.Editions do
              if (Edition <> Edition2) and IsEqualGuid(Edition2.Editeur.ID_Editeur, GUID_NULL) and SameText(Edition.Editeur.NomEditeur, Edition2.Editeur.NomEditeur) then
              begin
                TDaoEditeurFull.Fill(Edition2.Editeur, dummyID, nil);
                TDaoEditeurLite.Fill(Edition2.Collection.Editeur, dummyID);
              end;
            TDaoEditeurFull.Fill(Edition.Editeur, dummyID, nil);
            TDaoEditeurLite.Fill(Edition.Collection.Editeur, dummyID);
          end;
          AFormPreview.ReloadAlbum;
        end;

        if IsEqualGuid(Edition.Collection.ID, GUID_NULL) then
        begin
          if Edition.Collection.NomCollection <> '' then
          begin
            dummyID := CheckValue(AFormPreview, Qry, Edition.Collection.NomCollection, vmCollections, Edition.Editeur.ID_Editeur);
            if IsEqualGuid(dummyID, GUID_NULL) then
              Exit;
            if IsEqualGuid(dummyID, GUID_FULL) then
            begin
              for Edition2 in Album.Editions do
                if (Edition <> Edition2) and IsEqualGuid(Edition2.Collection.ID, GUID_NULL) and IsEqualGuid(Edition.Editeur.ID_Editeur, Edition2.Editeur.ID_Editeur) and
                  SameText(Edition.Collection.NomCollection, Edition2.Collection.NomCollection) then
                  Edition2.Collection.NomCollection := '';
              Edition.Collection.NomCollection := '';
            end
            else
            begin
              for Edition2 in Album.Editions do
                if (Edition <> Edition2) and IsEqualGuid(Edition2.Collection.ID, GUID_NULL) and IsEqualGuid(Edition.Editeur.ID_Editeur, Edition2.Editeur.ID_Editeur) and
                  SameText(Edition.Collection.NomCollection, Edition2.Collection.NomCollection) then
                  TDaoCollectionLite.Fill(Edition2.Collection, dummyID);
              TDaoCollectionLite.Fill(Edition.Collection, dummyID);
            end;
          end;
          AFormPreview.ReloadAlbum;
        end;
      end;
    finally
      DefaultEdition.Free;
    end;

    Qry.Transaction.Commit;
    Album.ReadyToFusion := True;
  finally
    Qry.Free;
  end;
end;

end.
