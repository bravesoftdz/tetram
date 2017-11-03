unit Impression;

interface

uses
  dialogs,
  Controls, Forms, Classes, SysUtils, Windows, ExtCtrls, Graphics, Printers, LoadComplet, Commun, PrintObject, Textes, CommonConst,
  Divers, TypeRec, Main, DM_Princ, Form_Recherche, JvUIB, jpeg;

procedure ImpressionListeCompleteAlbums(Previsualisation: Boolean);

procedure ImpressionInfosBDtheque(Previsualisation: Boolean);

procedure ImpressionEmprunts(Previsualisation: Boolean; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False);

procedure ImpressionFicheAlbum(Reference: Variant; RefEdition: Integer; Previsualisation: Boolean);
procedure ImpressionFicheAuteur(Reference: Variant; Previsualisation: Boolean);
procedure ImpressionSerie(Reference: Variant; Previsualisation: Boolean);
procedure ImpressionEmpruntsAlbum(Reference: Variant; Previsualisation: Boolean);

procedure ImpressionFicheEmprunteur(Reference: Variant; Previsualisation: Boolean);
procedure ImpressionEmpruntsEmprunteur(Reference: Variant; Previsualisation: Boolean);

procedure ImpressionRecherche(Resultat: TList; ResultatInfos, Criteres: TStringList; TypeRecherche: TTypeRecherche; Previsualisation: Boolean);
procedure ImpressionCouvertureAlbum(Reference: Variant; RefCouverture: Integer; Previsualisation: Boolean);

procedure ImpressionListeManquants(R: TSeriesIncompletes; Previsualisation: Boolean);
procedure ImpressionListePrevisions(R: TPrevisionsSorties; Previsualisation: Boolean);
procedure ImpressionListePrevisionsAchats(Previsualisation: Boolean);

implementation

uses Form_Preview, Math, Procedures, DateUtils;

function ConfigPrinter(Previsualisation: Boolean): Boolean;
begin
  Result := Previsualisation;
  if not Result then Result := Fond.PrintDialog1.Execute;
end;

procedure ImpressionSerie(Reference: Variant; Previsualisation: Boolean);
var
  fWaiting: IWaiting;
  Serie: TSerieComplete;
  Prn: TPrintObject;
  Infos, i, op: Integer;
  Album: TAlbum;
  s, s2: string;
  Manquants: TSeriesIncompletes;
  AlbumsManquants: TSerieIncomplete;
  Previsions: TPrevisionsSorties;
  Prevision: TPrevisionSortie;
begin
  Infos := Choisir('Inclure Pr�visions et Manquants', 'Omettre Pr�visions et Manquants', 1);
  if Infos = mrCancel then Exit;
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 9);
  Serie := TSerieComplete.Create(Reference);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTransFiche);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(Serie.Titre), taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.SetTopOfPage;
      Prn.SetFontInformation1('Times New Roman', 12, []);
      Prn.CreateColumn1(0, 10, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(1, 42, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, 30, -1, taLeftJustify, 'Times New Roman', 12, [fsItalic]);
      Prn.CreateColumn1(3, 122, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(4, 20, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(5, 42, 30, taLeftJustify, 'Times New Roman', 16, []);

      if Serie.Terminee = 1 then
        Prn.WriteLineColumn(2, -1, rsTransSerieTerminee)
      else
        Prn.WriteLineColumn(2, -1, rsTransSerieEnCours);

      Prn.NextLine;

      Prn.WriteLineColumn(0, -1, rsTransEditeur + ':');
      Prn.WriteLineColumn(1, -2, FormatTitre(Serie.Editeur.NomEditeur));
      Prn.WriteLineColumn(0, -1, rsTransCollection + ':');
      Prn.WriteLineColumn(1, -2, FormatTitre(Serie.Collection.NomCollection));

      s := '';
      for i := 0 to Serie.Genres.Count - 1 do
        AjoutString(s, Serie.Genres[i], ', ');
      if s <> '' then begin
        Prn.WriteLineColumn(0, -1, rsTransGenre + ':');
        Prn.WriteLineColumn(1, -2, s + '.');
      end;

      Prn.NextLine;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransScenario, rsTransPage, Prn.GetPageNumber]), epNext);
      if Serie.Scenaristes.Count > 0 then Prn.WriteLineColumn(0, -1, rsTransScenario + ':');
      op := -2;
      for i := 0 to Serie.Scenaristes.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAuteur(Serie.Scenaristes[i]).ChaineAffichage);
        op := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransDessins, rsTransPage, Prn.GetPageNumber]), epNext);
      if Serie.Dessinateurs.Count > 0 then Prn.WriteLineColumn(0, -1, rsTransDessins + ':');
      op := -2;
      for i := 0 to Serie.Dessinateurs.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAuteur(Serie.Dessinateurs[i]).ChaineAffichage);
        op := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransCouleurs, rsTransPage, Prn.GetPageNumber]), epNext);
      if Serie.Coloristes.Count > 0 then Prn.WriteLineColumn(0, -1, rsTransCouleurs + ':');
      op := -2;
      for i := 0 to Serie.Coloristes.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAuteur(Serie.Coloristes[i]).ChaineAffichage);
        op := -1;
      end;

      Prn.NewLines(2);

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransHistoire, rsTransPage, Prn.GetPageNumber]), epNext);
      s := Serie.Sujet.Text;
      if s <> '' then begin
        Prn.WriteLineColumn(0, -1, rsTransHistoire + ':');
        Prn.WriteColumn(4, -1, s);
        Prn.NextLine;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransNotes, rsTransPage, Prn.GetPageNumber]), epNext);
      s := Serie.Notes.Text;
      if s <> '' then begin
        Prn.WriteLineColumn(0, -1, rsTransNotes + ':');
        Prn.WriteColumn(4, -1, s);
        Prn.NextLine;
      end;

      Prn.NextLine;

      Prn.Columns.Clear;
      Prn.CreateColumn1(0, 10, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(1, 42, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, 42, -1, taLeftJustify, 'Times New Roman', 12, [fsItalic]);

      if Serie.Albums.Count > 0 then begin
        Prn.WriteLineColumn(0, -1, rsTransAlbums);
        for i := 0 to Pred(Serie.Albums.Count) do begin
          Album := Serie.Albums[i];
          s := '';
          if Album.Integrale then begin
            s2 := NonZero(IntToStr(Album.TomeDebut));
            AjoutString(s2, NonZero(IntToStr(Album.TomeFin)), ' � ');
            AjoutString(s, 'Int�grale ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(Album.Tome))));
            AjoutString(s, s2, ' ', '[', ']');
          end
          else if Album.HorsSerie then
            AjoutString(s, 'Hors s�rie ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(Album.Tome))))
          else
            AjoutString(s, NonZero(IntToStr(Album.Tome)), ' - ', 'Tome ');

          AjoutString(s, FormatTitre(Album.Titre), ' - ');
          Prn.WriteLineColumn(1, -1, s);
        end;

        if Infos = mrYes then begin
          Previsions := TPrevisionsSorties.Create(Serie.RefSerie);
          try
            Prevision := nil;
            if Previsions.AnneesPassees.Count > 0 then Prevision := TPrevisionSortie(Previsions.AnneesPassees[0]);
            if Previsions.AnneeEnCours.Count > 0 then Prevision := TPrevisionSortie(Previsions.AnneeEnCours[0]);
            if Previsions.AnneesProchaines.Count > 0 then Prevision := TPrevisionSortie(Previsions.AnneesProchaines[0]);
            if Assigned(Prevision) then
              Prn.WriteLineColumn(2, -1, 'Tome ' + IntToStr(Prevision.Tome) + ' en ' + IntToStr(Prevision.Annee));
          finally
            Previsions.Free;
          end;
          Manquants := TSeriesIncompletes.Create(Serie.RefSerie);
          try
            if Manquants.Series.Count > 0 then begin
              AlbumsManquants := TSerieIncomplete(Manquants.Series[0]);
              Prn.NextLine;
              Prn.WriteLineColumn(0, -1, rsTransAlbumsManquants);
              Prn.WriteLineColumn(1, -1, AlbumsManquants.ChaineAffichage);
            end;
          finally
            Manquants.Free;
          end;
        end;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Serie.Free;
  end;
end;

procedure ImpressionFicheAlbum(Reference: Variant; RefEdition: Integer; Previsualisation: Boolean);
var
  i: Integer;
  op: Integer;
  Album: TAlbumComplet;
  Edition: TEditionComplete;
  ms: TStream;
  jpg: TJPEGImage;
  s, s2: string;
  fWaiting: IWaiting;
  MinTop: Extended;
  Prn: TPrintObject;
begin
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 9);
  MinTop := -1;
  Album := TAlbumComplet.Create(Reference);
  Edition := nil;
  if RefEdition > -1 then Edition := TEditionComplete.Create(RefEdition);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTransFiche);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top { + 25}, Prn.Margin.Bottom + 20);
      //      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.SetTopOfPage;
      Prn.SetFontInformation1('Times New Roman', 12, []);
      Prn.CreateColumn1(0, 10, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(1, 42, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, 90, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(3, 122, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(4, 20, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(5, 42, 30, taLeftJustify, 'Times New Roman', 16, []);

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 1, 7);

      if Utilisateur.Options.FicheWithCouverture and Assigned(Edition) then begin
        if Edition.Couvertures.Count > 0 then begin
          fWaiting.ShowProgression(rsTransImage + '...', epNext);
          ms := GetCouvertureStream(TCouverture(Edition.Couvertures[0]).Reference, Prn.MmsToPixelsVertical(60), Prn.MmsToPixelsHorizontal(60), Utilisateur.Options.AntiAliasing, True, Prn.MmsToPixelsHorizontal(1));
          if Assigned(ms) then try
            fWaiting.ShowProgression(rsTransImage + '...', epNext);
            jpg := TJPEGImage.Create;
            try
              jpg.LoadFromStream(ms);
              Prn.Draw(Prn.Detail.Left + Prn.Detail.Width - Prn.PixelsToMmsHorizontal(jpg.Width),
                Prn.Detail.Top,
                jpg);
              MinTop := Prn.Detail.Top + Prn.PixelsToMmsVertical(jpg.Height);
            finally
              FreeAndNil(jpg);
            end;
          finally
            FreeAndNil(ms);
          end;
        end;
      end;

      Prn.SetTopOfPage;
      Prn.WriteLineColumn(0, -2, rsTransSerie + ':');
      Prn.WriteLineColumn(5, -2, FormatTitre(Album.Serie.Titre));
      Prn.WriteLineColumn(0, -1, rsTransAlbum + ':');
      Prn.WriteLineColumn(5, -2, FormatTitre(Album.Titre));
      Prn.NewLines(2);

      if Album.HorsSerie then Prn.WriteLineColumn(0, -1, rsTransHorsSerie);
      Prn.WriteLineColumn(0, -2, rsTransTome + ':');
      if Album.Integrale then begin
        s := NonZero(IntToStr(Album.TomeDebut));
        AjoutString(s, NonZero(IntToStr(Album.TomeFin)), ' � ');
        AjoutString(s, 'Int�grale', ' ');
        s2 := NonZero(IntToStr(Album.Tome));
        AjoutString(s2, s, ' ', '[', ']');
        Prn.WriteLineColumn(1, -2, s2);
      end
      else
        Prn.WriteLineColumn(1, -2, NonZero(IntToStr(Album.Tome)));
      Prn.WriteLineColumn(0, -1, rsTransAnneeParution + ':');
      Prn.WriteLineColumn(1, -2, IIf(Album.MoisParution > 0, ShortMonthNames[Album.MoisParution] + ' ', '') + NonZero(IntToStr(Album.AnneeParution)));

      s := '';
      for i := 0 to Album.Serie.Genres.Count - 1 do
        AjoutString(s, Album.Serie.Genres[i], ', ');
      if s <> '' then begin
        Prn.WriteLineColumn(0, -1, rsTransGenre + ':');
        Prn.WriteLineColumn(1, -2, s + '.');
      end;

      Prn.NextLine;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransScenario, rsTransPage, Prn.GetPageNumber]), epNext);
      if Album.Scenaristes.Count > 0 then Prn.WriteLineColumn(0, -1, rsTransScenario + ':');
      op := -2;
      for i := 0 to Album.Scenaristes.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAuteur(Album.Scenaristes[i]).ChaineAffichage);
        op := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransDessins, rsTransPage, Prn.GetPageNumber]), epNext);
      if Album.Dessinateurs.Count > 0 then Prn.WriteLineColumn(0, -1, rsTransDessins + ':');
      op := -2;
      for i := 0 to Album.Dessinateurs.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAuteur(Album.Dessinateurs[i]).ChaineAffichage);
        op := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransCouleurs, rsTransPage, Prn.GetPageNumber]), epNext);
      if Album.Coloristes.Count > 0 then Prn.WriteLineColumn(0, -1, rsTransCouleurs + ':');
      op := -2;
      for i := 0 to Album.Coloristes.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAuteur(Album.Coloristes[i]).ChaineAffichage);
        op := -1;
      end;

      Prn.NextLine;
      if Prn.GetYPosition < MinTop then Prn.SetYPosition(MinTop);
      Prn.NextLine;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransHistoire, rsTransPage, Prn.GetPageNumber]), epNext);
      s := Album.Sujet.Text;
      if s = '' then s := Album.Serie.Sujet.Text;
      if s <> '' then begin
        Prn.WriteLineColumn(0, -1, rsTransHistoire + ':');
        Prn.WriteColumn(4, -1, s);
        Prn.NextLine;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransNotes, rsTransPage, Prn.GetPageNumber]), epNext);
      s := Album.Notes.Text;
      if s = '' then s := Album.Serie.Notes.Text;
      if s <> '' then begin
        Prn.WriteLineColumn(0, -1, rsTransNotes + ':');
        Prn.WriteColumn(4, -1, s);
        Prn.NextLine;
      end;

      Prn.Columns.Clear;
      Prn.CreateColumn1(0, 10, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(1, 42, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, 75, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(3, 107, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(4, 150, 30, taLeftJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(5, 140, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(6, 172, 30, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(7, 20, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(8, 42, 30, taRightJustify, 'Times New Roman', 12, [fsBold]);

      if Assigned(Edition) then begin
        Prn.WriteLineColumn(0, -1, rsTransAnneeEdition + ':');
        Prn.WriteLineColumn(1, -2, NonZero(IntToStr(Edition.AnneeEdition)));
        Prn.WriteLineColumn(0, -1, rsTransISBN + ':');
        Prn.WriteLineColumn(1, -2, Edition.ISBN);
        if Edition.Offert then Prn.WriteLineColumn(2, -2, rsTransOffert);
        if Edition.Stock then Prn.WriteLineColumn(4, -2, rsTransStock);

        Prn.WriteLineColumn(0, -1, rsTransEditeur + ':');
        Prn.WriteLineColumn(1, -2, FormatTitre(Edition.Editeur.NomEditeur));
        if Edition.VO then Prn.WriteLineColumn(2, -2, rsTransVO);

        Prn.WriteLineColumn(0, -1, rsTransCollection + ':');
        Prn.WriteLineColumn(1, -2, Edition.Collection.ChaineAffichage);
        if Edition.Dedicace then Prn.WriteLineColumn(2, -2, rsTransDedicace);
        Prn.WriteLineColumn(4, -2, string(IIf(Edition.Couleur, rsTransCouleur, rsTransAbrvNB)));

        Prn.WriteLineColumn(0, -1, rsTransPrix + ':');
        if Edition.Gratuit then
          Prn.WriteLineColumn(1, -2, rsTransGratuit)
        else if Edition.Prix > 0 then
          Prn.WriteLineColumn(1, -2, FormatCurr(FormatMonnaie, Edition.Prix));
        if Edition.Offert then
          Prn.WriteLineColumn(2, -2, rsTransOffertLe + ':')
        else
          Prn.WriteLineColumn(2, -2, rsTransAcheteLe + ':');
        Prn.WriteLineColumn(3, -2, Edition.sDateAchat);

        Prn.WriteLineColumn(0, -1, rsTransEtat + ':');
        Prn.WriteLineColumn(1, -2, Edition.sEtat);
        Prn.WriteLineColumn(2, -2, rsTransReliure + ':');
        Prn.WriteLineColumn(3, -2, Edition.sReliure);
        Prn.WriteLineColumn(5, -2, rsTransTypeEdition + ':');
        Prn.WriteLineColumn(6, -2, Edition.sTypeEdition);

        Prn.WriteLineColumn(0, -1, rsTransPages + ':');
        Prn.WriteLineColumn(1, -2, NonZero(IntToStr(Edition.NombreDePages)));
        Prn.WriteLineColumn(2, -2, rsTransOrientation + ':');
        Prn.WriteLineColumn(3, -2, Edition.sOrientation);
        Prn.WriteLineColumn(5, -2, rsTransFormatEdition + ':');
        Prn.WriteLineColumn(6, -2, Edition.sFormatEdition);

        Prn.NextLine;

        s := Edition.Notes.Text;
        if s <> '' then begin
          Prn.WriteLineColumn(0, -1, rsTransNotes + ':');
          Prn.WriteColumn(7, -1, s);
          Prn.NextLine;
        end;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransSerie, rsTransPage, Prn.GetPageNumber]), epNext);
      Prn.WriteLineColumn(0, -1, rsTransSerie + ':');
      op := -2;
      if Album.Serie.Terminee = 1 then begin
        Prn.WriteLineColumn(8, -2, rsTransTerminee);
        op := -1;
      end;
      for i := 0 to Album.Serie.Albums.Count - 1 do begin
        Prn.WriteLineColumn(1, op, TAlbum(Album.Serie.Albums[i]).ChaineAffichage);
        op := -1;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    if RefEdition > -1 then Edition.Free;
    Album.Free;
  end;
end;

procedure ImpressionFicheAuteur(Reference: Variant; Previsualisation: Boolean);
var
  Auteur: TAuteurComplet;
  fWaiting: IWaiting;
  Prn: TPrintObject;
  i, j: Integer;
  Serie: TSerieComplete;
  fl: Integer;
begin
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 3);
  Auteur := TAuteurComplet.Create(Reference);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTransFiche);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(Auteur.NomAuteur), taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.SetTopOfPage;
      Prn.SetFontInformation1('Times New Roman', 12, []);
      Prn.CreateColumn1(0, 10, 70, taLeftJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(1, 20, -1, taLeftJustify, 'Times New Roman', 12, []);

      fl := -2;
      //      if Auteur.SiteWeb <> '' then Prn.WriteColumn(1, -1, Auteur.SiteWeb);
      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransBiographie, rsTransPage, Prn.GetPageNumber]), epNext);
      if Auteur.Biographie.Text <> '' then begin
        Prn.WriteLineColumn(0, -2, rsTransBiographie + ':');
        Prn.WriteColumn(1, -1, Auteur.Biographie.Text);
        fl := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransSeries, rsTransPage, Prn.GetPageNumber]), epNext);
      for i := 0 to Pred(Auteur.Series.Count) do begin
        Serie := TSerieComplete(Auteur.Series[i]);
        Prn.WriteLineColumn(0, fl, FormatTitre(Serie.Titre) + ':');
        for j := 0 to Pred(Serie.Albums.Count) do
          Prn.WriteColumn(1, -1, TAlbum(Serie.Albums[j]).ChaineAffichage);
        fl := -1;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Auteur.Free;
  end;
end;

procedure ImpressionFicheEmprunteur(Reference: Variant; Previsualisation: Boolean);
var
  Emprunteur: TEmprunteurComplet;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Emprunteur := TEmprunteurComplet.Create(Reference);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTransFiche);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, Emprunteur.Nom, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.SetTopOfPage;
      Prn.SetFontInformation1('Times New Roman', 12, []);
      Prn.CreateColumn1(0, 10, 70, taLeftJustify, 'Times New Roman', 12, [fsBold]);
      Prn.CreateColumn1(1, 20, -1, taLeftJustify, 'Times New Roman', 12, []);

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransCoordonnees, rsTransPage, Prn.GetPageNumber]), epNext);
      Prn.WriteLineColumn(0, -2, rsTransCoordonnees + ':');
      Prn.WriteColumn(1, -1, Emprunteur.Adresse.Text);
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Emprunteur.Free;
  end;
end;

procedure ImpressionEmpruntsAlbum(Reference: Variant; Previsualisation: Boolean);
var
  index, i: Integer;
  Album: TAlbumComplet;
  Edition: TEditionComplete;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 1);
  Album := TAlbumComplet.Create(Reference);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTitreListeEmprunts);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsTitreListeEmprunts, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, FormatTitre(Album.Titre), taCenter, 'Times New Roman', 16, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(1, 45, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, Prn.Detail.Width / 2, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.Font.Name := 'Times New Roman';
      Prn.Font.Size := 5;
      Prn.Font.Style := [];
      Prn.SetTopOfPage;
      Edition := TEditionComplete.Create;
      try
        for i := 0 to Pred(Album.Editions.Editions.Count) do begin
          Edition.Fill(TEdition(Album.Editions.Editions[i]).Reference);
          if Album.Editions.Editions.Count > 1 then
            Prn.WriteLineColumn(0, IIf(i = 0, -2, -1), TEdition(Album.Editions.Editions[i]).ChaineAffichage);
          case Edition.Emprunts.NBEmprunts of
            0: Prn.WriteLineColumn(0, -1, rsNoEmprunts);
            else
              fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunts, rsTransPage, Prn.GetPageNumber]), 0, Edition.Emprunts.NBEmprunts + 2);
              for index := 0 to Pred(Edition.Emprunts.NBEmprunts) do begin
                Prn.WriteLineColumn(0, -1, '#' + IntToStr(index) + ' (' + IIf(TEmprunt(Edition.Emprunts.Emprunts[index]).Pret, rsTransPret, rsTransRetour) + ')');
                Prn.WriteLineColumn(1, -2, TEmprunt(Edition.Emprunts.Emprunts[index]).ChaineAffichage);
                Prn.WriteLineColumn(2, -2, TEmprunt(Edition.Emprunts.Emprunts[index]).Emprunteur.ChaineAffichage);
                fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunts, rsTransPage, Prn.GetPageNumber]), epNext);
              end;
          end;
        end;
      finally
        Edition.Free;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Album.Free;
  end;
end;

procedure ImpressionEmpruntsEmprunteur(Reference: Variant; Previsualisation: Boolean);
var
  index: Integer;
  Emprunteur: TEmprunteurComplet;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 1);
  Emprunteur := TEmprunteurComplet.Create(Reference);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTitreListeEmprunts);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsTitreListeEmprunts, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, Emprunteur.Nom, taCenter, 'Times New Roman', 16, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(1, 45, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, Prn.Detail.Width / 2, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.Font.Name := 'Times New Roman';
      Prn.Font.Size := 5;
      Prn.Font.Style := [];
      Prn.SetTopOfPage;
      case Emprunteur.Emprunts.NBEmprunts of
        0: Prn.WriteLineColumn(0, -1, rsNoEmprunts);
        else
          fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunts, rsTransPage, Prn.GetPageNumber]), 0, Emprunteur.Emprunts.NBEmprunts + 2);
          for index := 0 to Emprunteur.Emprunts.Emprunts.Count - 1 do begin
            Prn.WriteLineColumn(0, IIf(Index = 0, -2, -1), '#' + IntToStr(index) + ' (' + IIf(TEmprunt(Emprunteur.Emprunts.Emprunts[index]).Pret, rsTransPret, rsTransRetour) + ')');
            Prn.WriteLineColumn(1, -2, TEmprunt(Emprunteur.Emprunts.Emprunts[index]).ChaineAffichage);
            Prn.WriteLineColumn(2, -2, TEmprunt(Emprunteur.Emprunts.Emprunts[index]).Album.ChaineAffichage);
            fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunts, rsTransPage, Prn.GetPageNumber]), epNext);
          end;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Emprunteur.Free;
  end;
end;

procedure ImpressionListeCompleteAlbums(Previsualisation: Boolean);
var
  Index, OldSerie: Integer;
  liste: TModalResult;
  Source, Equipe: TJvUIBQuery;
  sl: Boolean;
  Sujet, SujetSerie, sEquipe, s, s2: string;
  ColumnStyle: TFontStyles;
  PAl: TAlbum;
  PA: TAuteur;
  NbAlbums: Integer;
  DetailsOptions: TDetailOptions;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  liste := ChoisirDetail(1, DetailsOptions);
  if liste = mrCancel then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Source := TJvUIBQuery.Create(nil);
  Equipe := TJvUIBQuery.Create(nil);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Source.SQL.Text := 'SELECT Count(a.REFALBUM)';
      Source.SQL.Add('FROM Albums a INNER JOIN Editions e ON a.RefAlbum = e.RefAlbum INNER JOIN Series s ON a.RefSerie = s.RefSerie');
      Source.Open;
      NbAlbums := Source.Fields.AsInteger[0];
      Source.Close;
      Source.SQL[0] := 'SELECT a.REFALBUM, a.TITREALBUM, a.MOISPARUTION, a.ANNEEPARUTION, a.REFSERIE, a.TOME, a.TOMEDEBUT, a.TOMEFIN, a.HORSSERIE, a.INTEGRALE, s.TITRESERIE';
      Source.SQL.Add('ORDER BY s.UPPERTITRESERIE, a.REFSERIE, a.HORSSERIE NULLS FIRST, a.INTEGRALE NULLS FIRST, a.TOME NULLS FIRST');
      if liste = mrNo then begin
        if doHistoire in DetailsOptions then Source.SQL[0] := Source.SQL[0] + ', a.SUJETALBUM, s.SUJETSERIE';
        if doNotes in DetailsOptions then Source.SQL[0] := Source.SQL[0] + ', a.REMARQUESALBUM, s.REMARQUESSERIE';
        Source.FetchBlobs := True;
      end;
      Equipe.Transaction := Source.Transaction;
      Equipe.SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL)';
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsListeCompleteAlbums);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsListeCompleteAlbums, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, IntToStr(NbAlbums) + ' ' + rsTransAlbums, taCenter, 'Times New Roman', 12, []);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      if liste = mrNo then
        ColumnStyle := [fsBold]
      else
        ColumnStyle := [];
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, 'Times New Roman', 12, ColumnStyle); // num�ro
      Prn.CreateColumn1(1, 25, -1, taLeftJustify, 'Times New Roman', 12, ColumnStyle); // titre
      Prn.CreateColumn1(2, 35, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]); // r�sum�
      Prn.CreateColumn1(3, 35, -1, taLeftJustify, 'Times New Roman', 8, []); // r�alisation, acteurs
      Prn.CreateColumn1(4, 15, -1, taLeftJustify, 'Times New Roman', 12, [fsBold]); // s�rie
      Prn.CreateColumn1(5, 25, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]); // r�sum� de la s�rie
      Prn.SetTopOfPage;
      PAl := TAlbum.Create;
      with Source do begin
        index := 1;
        Open;
        sl := False;
        OldSerie := -1;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 0, NbAlbums + 2);
        while not EOF do begin
          if liste = mrNo then begin
            Sujet := '';
            if (doHistoire in DetailsOptions) then begin
              SujetSerie := Fields.ByNameAsString['SUJETSERIE'];
              Sujet := Fields.ByNameAsString['SUJETALBUM'];
            end;
            if (doNotes in DetailsOptions) then begin
              AjoutString(SujetSerie, Fields.ByNameAsString['REMARQUESSERIE'], #13#10#13#10);
              AjoutString(Sujet, Fields.ByNameAsString['REMARQUESALBUM'], #13#10#13#10);
            end;
            if ([doScenario, doDessins, doCouleurs] * DetailsOptions) <> [] then begin
              sEquipe := '';
              Equipe.Close;
              Equipe.Params.AsInteger[0] := Fields.ByNameAsInteger['RefAlbum'];
              Equipe.Open;
              with Equipe do begin
                s := '';
                while (doScenario in DetailsOptions) and (not Eof) and (Fields.ByNameAsInteger['Metier'] = 0) do begin
                  PA := TAuteur(TAuteur.Make(Equipe));
                  AjoutString(s, PA.ChaineAffichage, ', ');
                  PA.Free;
                  Next;
                end;
                AjoutString(sEquipe, s, #13#10, rsTransScenario + ': ', '.');
                s := '';
                while (doDessins in DetailsOptions) and (not Eof) and (Fields.ByNameAsInteger['Metier'] = 1) do begin
                  PA := TAuteur(TAuteur.Make(Equipe));
                  AjoutString(s, PA.ChaineAffichage, ', ');
                  PA.Free;
                  Next;
                end;
                AjoutString(sEquipe, s, #13#10, rsTransDessins + ': ', '.');
                s := '';
                while (doCouleurs in DetailsOptions) and (not Eof) and (Fields.ByNameAsInteger['Metier'] = 2) do begin
                  PA := TAuteur(TAuteur.Make(Equipe));
                  AjoutString(s, PA.ChaineAffichage, ', ');
                  PA.Free;
                  Next;
                end;
                AjoutString(sEquipe, s, #13#10, rsTransCouleurs + ': ', '.');
              end;
            end;
          end;

          if (index <> 1) and (liste = mrNo) and (SujetSerie + Sujet + sEquipe <> '') and (Prn.GetLinesLeftFont(Prn.Columns[2].Font) < 3) then begin
            Prn.NewPage;
            sl := False;
          end;

          PAl.Fill(Source);

          if OldSerie <> PAl.RefSerie then begin
            if (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 3) then begin
              Prn.NewPage;
              sl := False;
            end;
            if sl then Prn.NextLine;
            Prn.WriteLineColumn(4, IIf(sl, -1, -2), FormatTitre(PAl.Serie));
            if (liste = mrNo) then begin
              if SujetSerie <> '' then Prn.WriteColumn(5, -1, SujetSerie);
            end;
          end;

          //          Prn.WriteLineColumn(0, IIf(sl or (OldSerie <> PAl.RefSerie), -1, -2), '#' + IntToStr(index));

          s := '';
          if PAl.Integrale then begin
            s2 := NonZero(IntToStr(PAl.TomeDebut));
            AjoutString(s2, NonZero(IntToStr(PAl.TomeFin)), ' � ');
            AjoutString(s, 'Int�grale ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))));
            AjoutString(s, s2, ' ', '[', ']');
          end
          else if PAl.HorsSerie then
            AjoutString(s, 'Hors s�rie ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))))
          else
            AjoutString(s, NonZero(IntToStr(PAl.Tome)), ' - ', 'Tome ');

          AjoutString(s, FormatTitre(PAl.Titre), ' - ');

          //          Prn.WriteLineColumn(1, -2, s);
          Prn.WriteLineColumn(1, IIf(sl or (OldSerie <> PAl.RefSerie), -1, -2), s);

          sl := True;
          if (liste = mrNo) then begin
            if sEquipe <> '' then Prn.WriteColumn(3, -1, sEquipe);
            if Sujet <> '' then Prn.WriteColumn(2, -1, Sujet);
          end;
          OldSerie := PAl.RefSerie;
          Next;
          fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
          Inc(index);
        end;
        PAl.Free;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Source.Transaction.Free;
    Source.Free;
    Equipe.Free;
  end;
end;

procedure ImpressionEmprunts(Previsualisation: Boolean; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False);
var
  index: Integer;
  Emprunts: TEmpruntsComplet;
  Titre: string;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if Source = seEmprunteur then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Emprunts := TEmpruntsComplet.Create(-1, Source, Sens, Apres, Avant, EnCours, Stock);
  case Source of
    seAlbum: Titre := rsListeAlbumsEmpruntes;
    else
      Titre := rsListeEmprunts;
  end;
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + Titre);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, Titre, taCenter, 'Times New Roman', 24, [fsBold]);
      if Avant > -1 then Prn.SetHeaderInformation1(-1, -1, 'Avant le ' + DateToStr(Avant), taCenter, 'Times New Roman', 12, [fsItalic]);
      if Apres > -1 then Prn.SetHeaderInformation1(-1, -1, 'Apr�s le ' + DateToStr(Apres), taCenter, 'Times New Roman', 12, [fsItalic]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(1, 30, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, 35, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]);
      Prn.CreateColumn1(3, 45, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic, fsUnderline]);
      Prn.SetTopOfPage;
      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunts, rsTransPage, Prn.GetPageNumber]), 0, Emprunts.NBEmprunts + 2);
      for index := 0 to Emprunts.Emprunts.Count - 1 do begin
        Prn.WriteLineColumn(0, -1, '#' + IntToStr(index + 1));
        if TEmprunt(Emprunts.Emprunts[index]).Album.Reference <> -1 then Prn.WriteLineColumn(1, -2, TEmprunt(Emprunts.Emprunts[index]).Album.ChaineAffichage);
        Prn.WriteLineColumn(3, -1, Format(rsTransEmprunteLePar, [TEmprunt(Emprunts.Emprunts[index]).ChaineAffichage, TEmprunt(Emprunts.Emprunts[index]).Emprunteur.ChaineAffichage]));
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunts, rsTransPage, Prn.GetPageNumber]), epNext);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Emprunts.Free;
  end;
end;

procedure ImpressionInfosBDtheque(Previsualisation: Boolean);
var
  fWaiting: IWaiting;
  Position: array[1..10] of Single;
  Prn: TPrintObject;

  procedure Imprimer(R: TStats; MaxAlbums: Integer = -1);
  var
    i, ColonneGenre, NbLignes: Integer;
    YPos, YPosMax: Single;
  begin
    Prn.SetTopOfPage;
    Prn.SetFontInformation1('Times New Roman', 5, []);
    Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack); Prn.NextLine;
    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
    Prn.CreateColumn1(0, 20, 35, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(1, 57, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(2, 100, 35, taRightJustify, 'Times New Roman', 10, [fsBold]);
    Prn.CreateColumn1(3, 137, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.Columns[0].Font.Style := [fsBold];
    Prn.WriteLineColumn(0, -2, rsNombreAlbums + ':'); Prn.WriteLineColumn(1, -2, IntToStr(R.NbAlbums));
    Prn.Columns[0].Font.Style := [];
    Prn.WriteLineColumn(2, -2, rsAlbumsStock + ':'); Prn.WriteLineColumn(3, -2, Format(FormatPourcent, [R.NbAlbumsStock, MulDiv(R.NbAlbumsStock, 100, R.NbAlbums)]));
    Prn.Columns[0].Font.Style := [fsBold];
    Prn.WriteLineColumn(0, -1, rsNombreSeries + ':'); Prn.WriteLineColumn(1, -2, IntToStr(R.NbSeries) + ' (dont termin�es: ' + Format(FormatPourcent, [R.NbSeriesTerminee, MulDiv(R.NbSeriesTerminee, 100, R.NbSeries)]) + ')');
    Prn.Columns[0].Font.Style := [];
    Prn.WriteLineColumn(0, -1, rsAlbumsNB + ':'); Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsNB, MulDiv(R.NbAlbumsNB, 100, R.NbAlbums)])); Position[3] := Prn.GetYPosition;
    Prn.WriteLineColumn(0, -1, rsAlbumsVO + ':'); Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsVO, MulDiv(R.NbAlbumsVO, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(0, -1, rsAlbumsIntegrales + ':'); Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsIntegrale, MulDiv(R.NbAlbumsIntegrale, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(0, -1, rsAlbumsHorsSerie + ':'); Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsHorsSerie, MulDiv(R.NbAlbumsHorsSerie, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(0, -1, rsAlbumsDedicaces + ':'); Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsDedicace, MulDiv(R.NbAlbumsDedicace, 100, R.NbAlbums)]));
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.NextLine; Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack); Prn.NextLine;
    Position[5] := Prn.GetYPosition;

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransPrix, rsTransPage, Prn.GetPageNumber]), epNext);
    for i := 0 to Prn.Columns.Count - 1 do
      Prn.Columns[0].Free;
    Prn.CreateColumn1(0, 20, 35, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(1, 57, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(2, 20, 35, taRightJustify, 'Times New Roman', 10, [fsBold]);
    Prn.CreateColumn1(3, 130, 35, taCenter, 'Times New Roman', 10, []);

    if R.NbAlbums > 0 then begin
      Prn.SetYPosition(Position[3]);
      Prn.WriteLineColumnCenter(3, -2, Format('%d < %s < %d', [R.MinAnnee, rsTransAnneeParution, R.MaxAnnee]));
      Prn.SetYPosition(Position[5]);
    end;

    Prn.WriteLineColumn(0, -2, rsValeurMoyenne + ':'); Prn.WriteLineColumn(1, -2, FormatCurr(FormatMonnaie, R.PrixAlbumMoyen));
    Prn.WriteLineColumn(3, -2, FormatCurr(FormatMonnaie, R.PrixAlbumMinimun) + ' < ' + rsTransPrix + ' < ' + FormatCurr(FormatMonnaie, R.PrixAlbumMaximun));
    Prn.WriteLineColumn(2, -1, rsValeurConnue + ':'); Prn.WriteLineColumn(1, -2, FormatCurr(FormatMonnaie, R.ValeurConnue));
    Prn.WriteLineColumn(2, -1, rsValeurEstimee + ':'); Prn.WriteLineColumn(1, -2, FormatCurr(FormatMonnaie, R.ValeurEstimee));

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunteurs, rsTransPage, Prn.GetPageNumber]), epNext);
    for i := 0 to Prn.Columns.Count - 1 do
      Prn.Columns[0].Free;
    Prn.CreateColumn1(0, 20, 35, taRightJustify, 'Times New Roman', 10, [fsBold]);
    Prn.CreateColumn1(1, 57, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(2, 110, 35, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(3, 147, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(4, 57, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(5, 20, 35, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(6, 30, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]);
    Prn.CreateColumn1(7, 147, 15, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(8, 110, 35, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(9, 120, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]);

    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.NextLine; Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack); Prn.NextLine;
    Prn.WriteLineColumn(0, -2, rsTransEmprunteurs + ':');
    Prn.WriteLineColumn(1, -2, IntToStr(R.NbEmprunteurs));
    Prn.WriteLineColumn(2, -2, rsNombreMoyenEmprunts + ':');
    Prn.WriteLineColumn(3, -2, IntToStr(R.MoyEmprunteurs));

    YPos := Prn.GetYPosition;
    Prn.WriteLineColumn(5, -1, rsTransMinimum + ':');
    Prn.WriteLineColumn(4, -2, Format('%d (%d)', [R.MinEmprunteurs, R.ListEmprunteursMin.Count]));
    for i := 0 to R.ListEmprunteursMin.Count - 1 do begin
      Prn.WriteLineColumn(6, -1, IIf(i = 5, '...', TEmprunteur(R.ListEmprunteursMin[i]).ChaineAffichage));
      if i = 5 then Break;
    end;
    YPosMax := Prn.GetYPosition;
    Prn.SetYPosition(YPos);
    Prn.WriteLineColumn(8, -1, rsTransMaximum + ':');
    Prn.WriteLineColumn(7, -2, Format('%d (%d)', [R.MaxEmprunteurs, R.ListEmprunteursMax.Count]));
    for i := 0 to R.ListEmprunteursMax.Count - 1 do begin
      Prn.WriteLineColumn(9, -1, IIf(i = 5, '...', TEmprunteur(R.ListEmprunteursMax[i]).ChaineAffichage));
      if i = 5 then Break;
    end;
    if R.ListEmprunteursMin.Count > R.ListEmprunteursMax.Count then Prn.SetYPosition(YPosMax);

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbumsEmpruntes, rsTransPage, Prn.GetPageNumber]), epNext);
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.NextLine; Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack); Prn.NextLine;
    Prn.WriteLineColumn(0, -2, rsTransAlbumsEmpruntes + ':');
    Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbEmpruntes, MulDiv(R.NbEmpruntes, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(2, -2, rsNombreMoyenEmprunts + ':');
    Prn.WriteLineColumn(3, -2, IntToStr(R.MoyEmpruntes));

    YPos := Prn.GetYPosition;
    Prn.WriteLineColumn(5, -1, rsTransMinimum + ':');
    Prn.WriteLineColumn(4, -2, Format('%d (%d)', [R.MinEmprunteurs, R.ListAlbumsMin.Count]));
    for i := 0 to R.ListAlbumsMin.Count - 1 do begin
      Prn.WriteLineColumn(6, -1, IIf(i = 5, '...', TAlbum(R.ListAlbumsMin[i]).ChaineAffichage));
      if i = 5 then Break;
    end;
    YPosMax := Prn.GetYPosition;
    Prn.SetYPosition(YPos);
    Prn.WriteLineColumn(8, -1, rsTransMaximum + ':');
    Prn.WriteLineColumn(7, -2, Format('%d (%d)', [R.MaxEmpruntes, R.ListAlbumsMax.Count]));
    for i := 0 to R.ListAlbumsMax.Count - 1 do begin
      Prn.WriteLineColumn(9, -1, IIf(i = 5, '...', TAlbum(R.ListAlbumsMax[i]).ChaineAffichage));
      if i = 5 then Break;
    end;
    if R.ListAlbumsMin.Count > R.ListAlbumsMax.Count then Prn.SetYPosition(YPosMax);

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransGenres, rsTransPage, Prn.GetPageNumber]), epNext);
    for i := 0 to Prn.Columns.Count - 1 do
      Prn.Columns[0].Free;
    Prn.CreateColumn1(0, 20, 35, taRightJustify, 'Times New Roman', 10, [fsBold]);
    Prn.CreateColumn1(1, 30, 40, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(2, 65, 10, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(3, 82, 10, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(4, 98, 10, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(5, 120, 40, taLeftJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(6, 155, 10, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(7, 172, 10, taRightJustify, 'Times New Roman', 10, []);
    Prn.CreateColumn1(8, 188, 10, taRightJustify, 'Times New Roman', 10, []);
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.NextLine; Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack); Prn.NextLine;
    i := R.ListGenre.Count;
    if (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < i + 3) and (Prn.GetLinesInDetailAreaFont(Prn.Columns[1].Font) > i) then Prn.NewPage;
    Prn.WriteLineColumn(0, -2, rsTransGenres + ':');
    Prn.AutoPaging := False;
    ColonneGenre := 0;
    NbLignes := Prn.GetLinesLeftFont(Prn.Columns[1].Font);
    if NbLignes * 2 > R.ListGenre.Count then NbLignes := Ceil(R.ListGenre.Count / 2);
    i := 0;
    YPos := Prn.GetYPosition;
    while i < R.ListGenre.Count do begin
      Prn.WriteLineColumn(1 + 4 * ColonneGenre, -1, TGenre(R.ListGenre[i]).ChaineAffichage);
      Prn.WriteLineColumn(2 + 4 * ColonneGenre, -2, Format('%d', [TGenre(R.ListGenre[i]).Quantite]));
      Prn.WriteLineColumn(3 + 4 * ColonneGenre, -2, Format('(%f%%)', [MulDiv(TGenre(R.ListGenre[i]).Quantite, 100, R.NbAlbums)]));
      if MaxAlbums > 0 then
        Prn.WriteLineColumn(4 + 4 * ColonneGenre, -2, Format('(%f%%)', [MulDiv(TGenre(R.ListGenre[i]).Quantite, 100, MaxAlbums)]));
      Inc(i);
      if i = NbLignes then begin
        ColonneGenre := 1 - ColonneGenre;
        if ColonneGenre = 0 then begin
          Prn.NewPage;
          YPos := Prn.GetYPosition;
          YPosMax := YPos;
        end
        else begin
          YPosMax := Prn.GetYPosition;
          Prn.SetYPosition(YPos);
        end;
      end;
    end;
    if YPosMax > Prn.GetYPosition then Prn.SetYPosition(YPosMax);
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack);
    Prn.AutoPaging := True;
  end;

var
  i: Integer;
  Stats: TStats;
begin
  i := Choisir('G�n�rique', 'D�taill�e pour chaque �diteur', 1);
  if i = mrCancel then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Stats := TStats.Create(i = mrNo);
  try
    Prn := TPrintObject.Create(Fond);
    try
      fWaiting.ShowProgression(rsTransConfig + '...', 0, 12);
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsInformationsBDtheque);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Printer.Canvas.Pen.Color := clBlack;
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 1, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 1, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsInformationsBDtheque, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);

      Imprimer(Stats);
      Prn.SetHeaderInformation1(1, -1, '', taCenter, 'Times New Roman', 12, [fsBold]);
      for i := 0 to Pred(Stats.ListEditeurs.Count) do begin
        Prn.NewPage;
        Prn.Headers[1].Text := 'R�partition pour ' + FormatTitre(TStats(Stats.ListEditeurs[i]).Editeur);
        Imprimer(Stats.ListEditeurs[i], Stats.NbAlbums);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Stats.Free;
  end;
end;

procedure ImpressionRecherche(Resultat: TList; ResultatInfos, Criteres: TStringList; TypeRecherche: TTypeRecherche; Previsualisation: Boolean);
var
  col: Single;
  liste: TModalResult;
  i: Integer;
  PAl: TAlbum;
  sl: TStringList;
  Source, Equipe: TJvUIBQuery;
  Sujet, sEquipe, s: string;
  PA: TAuteur;
  SautLigne: Boolean;
  DetailsOptions: TDetailOptions;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  liste := ChoisirDetail(1, DetailsOptions);
  if liste = mrCancel then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Source := TJvUIBQuery.Create(nil);
  Equipe := TJvUIBQuery.Create(nil);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Source.SQL.Text := 'SELECT a.RefAlbum'#13#10'FROM ALBUMS a INNER JOIN Series s ON s.RefSerie = a.RefSerie WHERE a.RefAlbum = ?';
      if liste = mrNo then begin
        if doHistoire in DetailsOptions then Source.SQL[0] := Source.SQL[0] + ', a.SUJETALBUM, s.SUJETSERIE';
        if doNotes in DetailsOptions then Source.SQL[0] := Source.SQL[0] + ', a.REMARQUESALBUM, s.REMARQUESSERIE';
        Source.FetchBlobs := True;
      end;
      Equipe.Transaction := Source.Transaction;
      Equipe.SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL)';
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsResultatRecherche);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsResultatRecherche, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, IntToStr(Resultat.Count) + ' ' + rsTransAlbums, taCenter, 'Times New Roman', 12, []);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(1, 30, -1, taLeftJustify, 'Times New Roman', 12, []);
      Prn.CreateColumn1(2, 20, -1, taLeftJustify, 'Times New Roman', 14, [fsBold, fsUnderline]);
      Prn.CreateColumn1(3, 55, -1, taLeftJustify, 'Times New Roman', 12, [fsItalic]);
      Prn.CreateColumn1(4, 35, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]); // r�sum�
      Prn.CreateColumn1(5, 35, -1, taLeftJustify, 'Times New Roman', 8, []); // r�alisation, acteurs
      Prn.SetTopOfPage;

      Prn.WriteLineColumn(2, -2, 'Crit�res:');
      Prn.NextLine;
      case TypeRecherche of
        trSimple: begin
            Prn.WriteLineColumn(0, -1, 'Type de recherche:');
            Prn.WriteLineColumn(3, -2, 'Bibliographie');
            if Criteres.Count >= 2 then begin
              Prn.WriteLineColumn(0, -1, Criteres[0]);
              Prn.WriteLineColumn(3, -2, Criteres[1]);
            end;
          end;
        trComplexe: begin
            Prn.WriteLineColumn(0, -1, 'Type de recherche:');
            Prn.WriteLineColumn(3, -2, 'Complexe');
            if Criteres.Count > 0 then begin
              Prn.NextLine;
              sl := TStringList.Create;
              col := Prn.Columns[0].Position;
              try
                for i := 0 to Criteres.Count - 1 do begin
                  s := Criteres[i];
                  Split(s, '|');
                  sl.Text := s;
                  Prn.Columns[0].Position := col + StrToInt(sl[0]) * 5;
                  Prn.WriteLineColumn(0, -1, sl[1]);
                  if sl.Count > 2 then begin
                    Prn.Columns[3].Position := Prn.Columns[0].Position + Prn.GetTextWidthFont(sl[1], Prn.Columns[0].Font) + 5;
                    Prn.WriteLineColumn(3, -2, sl[2]);
                  end;
                end;
              finally
                sl.Free;
                Prn.Columns[0].Position := col;
              end;
            end;
          end;
      end;

      Prn.NewLines(2);
      Prn.WriteLineColumn(2, -1, Format('R�sultats: (%d)', [Resultat.Count]));
      Prn.NextLine;
      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 0, Resultat.Count + 1);
      if (liste = mrNo) then begin
        Prn.Columns[0].Font.Style := [fsBold];
        Prn.Columns[1].Font.Style := Prn.Columns[0].Font.Style;
      end;
      SautLigne := True;
      for i := 0 to Resultat.Count - 1 do begin
        PAl := Resultat[i];
        if liste = mrNo then begin
          Sujet := '';
          if (doHistoire in DetailsOptions) or (doNotes in DetailsOptions) then begin
            Source.Params.AsInteger[0] := PAl.Reference;
            Source.Open;
            if (doHistoire in DetailsOptions) then begin
              if Source.Fields.ByNameIsNull['SUJETALBUM'] then
                Sujet := Source.Fields.ByNameAsString['SUJETSERIE']
              else
                Sujet := Source.Fields.ByNameAsString['SUJETALBUM']
            end;
            if (doNotes in DetailsOptions) then begin
              if Source.Fields.ByNameIsNull['REMARQUESALBUM'] then
                AjoutString(Sujet, Source.Fields.ByNameAsString['REMARQUESSERIE'], #13#10#13#10)
              else
                AjoutString(Sujet, Source.Fields.ByNameAsString['REMARQUESALBUM'], #13#10#13#10)
            end;
          end;
          if ([doScenario, doDessins, doCouleurs] * DetailsOptions) <> [] then begin
            Equipe.Params.AsInteger[0] := PAl.Reference;
            Equipe.Open;
            sEquipe := '';
            with Equipe do begin
              s := '';
              while (doScenario in DetailsOptions) and (not Eof) and (Fields.ByNameAsInteger['Metier'] = 0) do begin
                PA := TAuteur(TAuteur.Make(Equipe));
                AjoutString(s, PA.ChaineAffichage, ', ');
                PA.Free;
                Next;
              end;
              AjoutString(sEquipe, s, #13#10, rsTransScenario + ': ', '.');
              s := '';
              while (doDessins in DetailsOptions) and (not Eof) and (Fields.ByNameAsInteger['Metier'] = 1) do begin
                PA := TAuteur(TAuteur.Make(Equipe));
                AjoutString(s, PA.ChaineAffichage, ', ');
                PA.Free;
                Next;
              end;
              AjoutString(sEquipe, s, #13#10, rsTransDessins + ': ', '.');
              s := '';
              while (doCouleurs in DetailsOptions) and (not Eof) and (Fields.ByNameAsInteger['Metier'] = 2) do begin
                PA := TAuteur(TAuteur.Make(Equipe));
                AjoutString(s, PA.ChaineAffichage, ', ');
                PA.Free;
                Next;
              end;
              AjoutString(sEquipe, s, #13#10, rsTransCouleurs + ': ', '.');
            end;
          end;
        end;
        if (i <> 0) and (liste = mrNo) and (Sujet + sEquipe <> '') and (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 3) then begin
          Prn.NewPage;
          SautLigne := False;
        end;
        Prn.WriteLineColumn(0, IIf(SautLigne, -1, -2), '#' + IntToStr(i + 1));
        case TypeRecherche of
          trSimple: begin
              s := PAl.ChaineAffichage;
              AjoutString(s, ResultatInfos[i], ' ', '(', ')');
              Prn.WriteLineColumn(1, -2, s);
            end;
          trComplexe:
            Prn.WriteLineColumn(1, -2, PAl.ChaineAffichage);
        end;
        SautLigne := True;
        if (liste = mrNo) then begin
          if sEquipe <> '' then Prn.WriteColumn(5, -1, sEquipe);
          if Sujet <> '' then Prn.WriteColumn(4, -1, Sujet);
        end;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Source.Transaction.Free;
    Source.Free;
    Equipe.Free;
  end;
end;

procedure ImpressionCouvertureAlbum(Reference: Variant; RefCouverture: Integer; Previsualisation: Boolean);
var
  Album: TAlbumComplet;
  ms: TStream;
  jpg: TJPEGImage;
  s: string;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if Reference = 0 then Exit;
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Album := TAlbumComplet.Create(Reference);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsTransImage);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(Album.Titre), taCenter, 'Times New Roman', 24, [fsBold]);
      s := '';
      AjoutString(s, Album.Serie.Titre, ' - ');
      if Album.Integrale then
        AjoutString(s, 'INT.' + NonZero(IntToStr(Album.Tome)), ' - ')
      else if Album.HorsSerie then
        AjoutString(s, 'HS ' + NonZero(IntToStr(Album.Tome)), ' - ')
      else
        AjoutString(s, NonZero(IntToStr(Album.Tome)), ' - T.');
      Prn.SetHeaderInformation1(1, -1, s, taCenter, 'Times New Roman', 16, [fsBold]);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.PageNumber.Printed := False;
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.SetTopOfPage;
      Prn.SetFontInformation1('Times New Roman', 12, []);

      ShowMessage(Format('W %d H %d', [Prn.MmsToPixelsHorizontal(Prn.Detail.Width), Prn.MmsToPixelsVertical(Prn.Detail.Height)]));
      ms := GetCouvertureStream(RefCouverture, Prn.MmsToPixelsVertical(Prn.Detail.Height), Prn.MmsToPixelsHorizontal(Prn.Detail.Width), Utilisateur.Options.AntiAliasing);
      if Assigned(ms) then try
        fWaiting.ShowProgression(rsTransImage + '...', epNext);
        jpg := TJPEGImage.Create;
        try
          jpg.LoadFromStream(ms);
          Prn.Draw(Prn.Detail.Left + ((Prn.Detail.Width - Prn.PixelsToMmsHorizontal(jpg.Width)) / 2),
            Prn.Detail.Top + ((Prn.Detail.Height - Prn.PixelsToMmsVertical(jpg.Height)) / 2),
            jpg);
        finally
          FreeAndNil(jpg);
        end;
      finally
        FreeAndNil(ms);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Album.Free;
  end;
end;

procedure ImpressionListeManquants(R: TSeriesIncompletes; Previsualisation: Boolean);
var
  i, j: Integer;
  s1, s2: string;
  y1, y2: Single;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Prn := TPrintObject.Create(Fond);
  try
    Prn.SetOrientation(poPortrait);
    Prn.Preview := Previsualisation;
    if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
    Prn.Start(1, Application.Title + ' - ' + rsTransImage);
    Prn.AutoPaging := True;
    Prn.SetMargins(10, 10, 10, 10);
    Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
    Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
    Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
    Prn.SetHeaderInformation1(0, 5, 'S�ries incompl�tes', taCenter, 'Times New Roman', 24, [fsBold]);

    Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
    Prn.PageNumber.Printed := False;
    Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
    Prn.SetTopOfPage;
    Prn.SetFontInformation1('Times New Roman', 12, []);

    Prn.CreateColumn1(0, 15, 10, taLeftJustify, 'Times New Roman', 12, []);
    Prn.CreateColumn1(1, 30, 105, taLeftJustify, 'Times New Roman', 12, []);
    Prn.CreateColumn1(2, 140, -1, taLeftJustify, 'Times New Roman', 12, []);

    for i := 0 to Pred(R.Series.Count) do
      with TSerieIncomplete(R.Series[i]) do begin
        if (i <> 0) and (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 2) then Prn.NewPage;
        y1 := Prn.GetYPosition;
        Prn.WriteLineColumn(0, -1, '#' + IntToStr(i + 1));
        Prn.SetYPosition(y1);
        Prn.WriteColumn(1, -1, Serie.ChaineAffichage);
        y2 := Prn.GetYPosition;
        s1 := '';
        for j := 0 to NumerosManquants.Count - 1 do begin
          s2 := NumerosManquants[j];
          if Pos('<>', s2) <> 0 then s2 := StringReplace(s2, '<>', ' � ', []);
          AjoutString(s1, s2, ', ');
        end;
        Prn.SetYPosition(y1);
        Prn.WriteColumn(2, -1, s1);
        if y2 > Prn.GetYPosition then
          Prn.SetYPosition(y2);
      end;
  finally
    fWaiting.ShowProgression(rsTransImpression + '...', epNext);
    if Prn.Printing then Prn.Quit;
    Prn.Free;
  end;
end;

procedure ImpressionListePrevisions(R: TPrevisionsSorties; Previsualisation: Boolean);
var
  Prn: TPrintObject;

  procedure PrintGroupe(const Titre: string; Previsions: TList);
  var
    i: Integer;
    y1, y2: Single;
  begin
    if Previsions.Count > 0 then begin
      Prn.WriteColumn(3, -1, Titre);

      for i := 0 to Pred(Previsions.Count) do
        with TPrevisionSortie(Previsions[i]) do begin
          if (i <> 0) and (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 2) then Prn.NewPage;
          Prn.WriteLineColumn(0, -1, '#' + IntToStr(i + 1));
          y1 := Prn.GetYPosition - Prn.GetLineHeightMmsFont(Prn.Columns[1].Font);
          Prn.SetYPosition(y1);
          Prn.WriteColumn(1, -1, Serie.ChaineAffichage);
          y2 := Prn.GetYPosition;
          Prn.SetYPosition(y1);
          Prn.WriteColumn(2, -1, Format('Tome %d en %s', [Tome, sAnnee]));
          if y2 > Prn.GetYPosition then
            Prn.SetYPosition(y2);
        end;
    end;
  end;

var
  fWaiting: IWaiting;
begin
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Prn := TPrintObject.Create(Fond);
  try
    Prn.SetOrientation(poPortrait);
    Prn.Preview := Previsualisation;
    if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
    Prn.Start(1, Application.Title + ' - ' + rsTransImage);
    Prn.AutoPaging := True;
    Prn.SetMargins(10, 10, 10, 10);
    Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
    Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
    Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
    Prn.SetHeaderInformation1(0, 5, 'Pr�visions de sorties', taCenter, 'Times New Roman', 24, [fsBold]);

    Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
    Prn.PageNumber.Printed := False;
    Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
    Prn.SetTopOfPage;
    Prn.SetFontInformation1('Times New Roman', 12, []);

    Prn.CreateColumn1(0, 15, 10, taLeftJustify, 'Times New Roman', 12, []);
    Prn.CreateColumn1(1, 30, 105, taLeftJustify, 'Times New Roman', 12, []);
    Prn.CreateColumn1(2, 140, -1, taLeftJustify, 'Times New Roman', 12, []);
    Prn.CreateColumn1(3, 15, -1, taLeftJustify, 'Times New Roman', 16, [fsBold]);

    PrintGroupe('Ann�es pass�es', R.AnneesPassees);
    PrintGroupe('Cette ann�e', R.AnneeEnCours);
    PrintGroupe('Prochaines ann�es', R.AnneesProchaines);
  finally
    fWaiting.ShowProgression(rsTransImpression + '...', epNext);
    if Prn.Printing then Prn.Quit;
    Prn.Free;
  end;
end;

procedure ImpressionListePrevisionsAchats(Previsualisation: Boolean);
var
  OldSerie: Integer;
  Source: TJvUIBQuery;
  sl: Boolean;
  s, s2: string;
  ColumnStyle: TFontStyles;
  PAl: TAlbum;
  NbAlbums: Integer;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if not ConfigPrinter(Previsualisation) then Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Source := TJvUIBQuery.Create(nil);
  try
    Prn := TPrintObject.Create(Fond);
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Source.SQL.Text := 'SELECT Count(a.REFALBUM)';
      Source.SQL.Add('FROM Albums a INNER JOIN Series s ON a.RefSerie = s.RefSerie');
      Source.SQL.Add('WHERE a.Achat = 1');
      Source.Open;
      NbAlbums := Source.Fields.AsInteger[0];
      Source.Close;
      Source.SQL[0] := 'SELECT a.REFALBUM, a.TITREALBUM, a.MOISPARUTION, a.ANNEEPARUTION, a.REFSERIE, a.TOME, a.TOMEDEBUT, a.TOMEFIN, a.HORSSERIE, a.INTEGRALE, s.TITRESERIE';
      Source.SQL.Add('ORDER BY s.UPPERTITRESERIE, a.REFSERIE, a.HORSSERIE NULLS FIRST, a.INTEGRALE NULLS FIRST, a.TOME NULLS FIRST');
      Prn.SetOrientation(poPortrait);
      Prn.Preview := Previsualisation;
      if Previsualisation then Prn.PreviewObject := TFrmPreview.Create(Application);
      Prn.Start(1, Application.Title + ' - ' + rsListeAchats);
      Prn.AutoPaging := True;
      Prn.SetMargins(10, 10, 10, 10);
      Prn.SetDetailTopBottom(Prn.Margin.Top + 25, Prn.Margin.Bottom + 20);
      Prn.SetHeaderDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Top, 20, False, 0, clWhite);
      Prn.SetFooterDimensions1(Prn.Margin.Left, Prn.Margin.Right, Prn.Margin.Bottom, 10, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsListeAchats, taCenter, 'Times New Roman', 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, IntToStr(NbAlbums) + ' ' + rsTransAlbums, taCenter, 'Times New Roman', 12, []);
      Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, 'Times New Roman', 9, []);
      Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, 'Times New Roman', 10, [fsUnderline]);
      Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify, 'Times New Roman', 9, []);
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, 'Times New Roman', 12, ColumnStyle); // num�ro
      Prn.CreateColumn1(1, 25, -1, taLeftJustify, 'Times New Roman', 12, ColumnStyle); // titre
      Prn.CreateColumn1(2, 35, -1, taLeftJustify, 'Times New Roman', 10, [fsItalic]); // r�sum�
      Prn.CreateColumn1(3, 35, -1, taLeftJustify, 'Times New Roman', 8, []); // r�alisation, acteurs
      Prn.CreateColumn1(4, 15, -1, taLeftJustify, 'Times New Roman', 12, [fsBold]); // s�rie
      Prn.SetTopOfPage;
      PAl := TAlbum.Create;
      with Source do begin
        Open;
        sl := False;
        OldSerie := -1;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 0, NbAlbums + 2);
        while not EOF do begin
          PAl.Fill(Source);

          if OldSerie <> PAl.RefSerie then begin
            if (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 3) then begin
              Prn.NewPage;
              sl := False;
            end;
            if sl then Prn.NextLine;
            Prn.WriteLineColumn(4, IIf(sl, -1, -2), FormatTitre(PAl.Serie));
          end;

          if (PAl.AnneeParution > 0) and (PAl.AnneeParution = YearOf(Now)) then
            if (PAl.MoisParution > 0) and (PAl.MoisParution <= MonthOf(Now)) then
              Prn.Columns[1].Font.Color := clRed
            else
              Prn.Columns[1].Font.Color := clFuchsia
          else
            Prn.Columns[1].Font.Color := clBlack;

          try
            s := '';
            if PAl.Integrale then begin
              s2 := NonZero(IntToStr(PAl.TomeDebut));
              AjoutString(s2, NonZero(IntToStr(PAl.TomeFin)), ' � ');
              AjoutString(s, 'Int�grale ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))));
              AjoutString(s, s2, ' ', '[', ']');
            end
            else if PAl.HorsSerie then
              AjoutString(s, 'Hors s�rie ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))))
            else
              AjoutString(s, NonZero(IntToStr(PAl.Tome)), ' - ', 'Tome ');

            AjoutString(s, IIf(PAl.MoisParution > 0, ShortMonthNames[PAl.MoisParution] + ' ', '') + NonZero(IntToStr(PAl.AnneeParution)), ' - ');
            AjoutString(s, FormatTitre(PAl.Titre), ' - ');

            Prn.WriteLineColumn(1, IIf(sl or (OldSerie <> PAl.RefSerie), -1, -2), s);
          finally
            Prn.Columns[1].Font.Color := clBlack;
          end;

          sl := True;

          OldSerie := PAl.RefSerie;
          Next;
          fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
        end;
        PAl.Free;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then Prn.Quit;
      Prn.Free;
    end;
  finally
    Source.Transaction.Free;
    Source.Free;
  end;
end;

end.

