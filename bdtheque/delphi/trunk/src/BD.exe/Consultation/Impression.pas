unit Impression;

interface

uses
  Dialogs, Controls, Forms, Classes, SysUtils, Windows, ExtCtrls, Graphics, System.UITypes, Printers, BD.Utils.StrUtils, PrintObject, BD.Strings, BD.Common,
  Divers, BD.Entities.Lite, BDTK.GUI.Forms.Main, BDTK.GUI.DataModules.Main, UfrmRecherche, UIB, jpeg, Generics.Collections, BD.Entities.Full,
  BDTK.Entities.Search, BDTK.Entities.Stats;

procedure ImpressionListeCompleteAlbums(Previsualisation: Boolean);

procedure ImpressionInfosBDtheque(Previsualisation: Boolean);

procedure ImpressionFicheAlbum(const Reference, ID_Edition: TGUID; Previsualisation: Boolean);
procedure ImpressionFicheAuteur(const Reference: TGUID; Previsualisation: Boolean);
procedure ImpressionFicheSerie(const Reference: TGUID; Previsualisation: Boolean);
procedure ImpressionFicheUnivers(const Reference: TGUID; Previsualisation: Boolean);
procedure ImpressionFicheParaBD(const Reference: TGUID; Previsualisation: Boolean);

procedure ImpressionRecherche(Recherche: TRecherche; Previsualisation: Boolean);
procedure ImpressionCouvertureAlbum(const Reference, ID_Couverture: TGUID; Previsualisation: Boolean);
procedure ImpressionImageParaBD(const Reference, ID_Photo: TGUID; Previsualisation: Boolean);

procedure ImpressionListeManquants(R: TSeriesIncompletes; Previsualisation: Boolean);
procedure ImpressionListePrevisions(R: TPrevisionsSorties; Previsualisation: Boolean);
procedure ImpressionListePrevisionsAchats(Previsualisation: Boolean);

implementation

uses
  UfrmPreview, Math, BD.Utils.GUIUtils, BDTK.GUI.Utils, DateUtils, UIBlib, StrUtils, BD.Entities.Metadata,
  BDTK.Entities.Dao.Lite, BDTK.Entities.Dao.Full, BD.Entities.Common, BD.Entities.Factory.Lite,
  BD.DB.Connection;

procedure PreparePrintObject(Prn: TPrintObject; Previsualisation: Boolean; const Titre: string);
begin
  Prn.SetOrientation(poPortrait);
  if Previsualisation then
    Prn.PreviewObject := TFrmPreview.Create(Application);
  Prn.Start(Application.Title + ' - ' + Titre);
  Prn.AutoPaging := True;

  Prn.SetFontInformation1('Times New Roman', 12, []);

  Prn.SetMargins(10, 10, 10, 10);
  Prn.SetHeaderDimensions1(-1, -1, -1, 10, False, 0, clWhite);
  Prn.SetFooterDimensions1(-1, -1, -1, 15, False, 0, clWhite);
  Prn.Footers.Clear;
  Prn.SetFooterInformation1(0, 0, CopyrightTetramCorp, taRightJustify, Prn.Font.name, 9, []);
  Prn.SetPageNumberInformation1(Prn.FooterCoordinates.Top + 5, rsTransPage + ' ', '', taCenter, Prn.Font.name, 10, [fsUnderline]);
  Prn.SetDateTimeInformation1(Prn.HeaderCoordinates.Top, dfShortDateFormat, True, dtStart, tfShortTimeFormat, True, DateFirst, ' - ', taRightJustify,
    Prn.Font.name, 9, []);
  Prn.Headers.Clear;
end;

procedure ImprimeEdition(Prn: TPrintObject; Edition: TEditionFull; const fWaiting: IWaiting);
const
  // en mm
  ThumbWidth = 60;
  ThumbHeigth = 60;
  ThumbInterval = 4;

var
  nbImageHorz, numCol: Integer;
  Repositionne, ImageDessinee: Boolean;
  ms: TStream;
  jpg: TJpegImage;
  PC: TCouvertureLite;
begin
  Prn.Columns.Clear;
  Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(1, 42, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(2, 75, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(3, 107, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(4, 150, 30, taLeftJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(5, 140, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(6, 172, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(7, 20, -1, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(8, 42, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);

  Prn.WriteLineColumn(0, -1, rsTransAnneeEdition + ' :');
  Prn.WriteLineColumn(1, -2, NonZero(IntToStr(Edition.AnneeEdition)));
  Prn.WriteLineColumn(0, -1, rsTransISBN + ' :');
  Prn.WriteLineColumn(1, -2, Edition.ISBN);
  if Edition.Stock then
    Prn.WriteLineColumn(4, -2, rsTransStock);

  Prn.WriteLineColumn(0, -1, rsTransEditeur + ' :');
  Prn.WriteLineColumn(1, -2, FormatTitre(Edition.Editeur.NomEditeur));
  if Edition.VO then
    Prn.WriteLineColumn(2, -2, rsTransVO);

  Prn.WriteLineColumn(0, -1, rsTransCollection + ' :');
  Prn.WriteLineColumn(1, -2, Edition.Collection.ChaineAffichage);
  if Edition.Dedicace then
    Prn.WriteLineColumn(2, -2, rsTransDedicace);
  Prn.WriteLineColumn(4, -2, string(IIf(Edition.Couleur, rsTransCouleur, rsTransAbrvNB)));

  Prn.WriteLineColumn(0, -1, rsTransPrix + ' :');
  if Edition.Gratuit then
    Prn.WriteLineColumn(1, -2, rsTransGratuit)
  else if Edition.Prix > 0 then
    Prn.WriteLineColumn(1, -2, BDCurrencyToStr(Edition.Prix));
  if Edition.Offert then
    Prn.WriteLineColumn(2, -2, rsTransOffertLe + ' :')
  else
    Prn.WriteLineColumn(2, -2, rsTransAcheteLe + ' :');
  Prn.WriteLineColumn(3, -2, Edition.sDateAchat);

  if Edition.PrixCote > 0 then
  begin
    Prn.WriteLineColumn(0, -1, rsTransCote + ' :');
    Prn.WriteLineColumn(1, -2, Format('%s (%d)', [BDCurrencyToStr(Edition.PrixCote), Edition.AnneeCote]));
  end;

  Prn.WriteLineColumn(0, -1, rsTransEtat + ' :');
  Prn.WriteLineColumn(1, -2, Edition.Etat.Caption);
  Prn.WriteLineColumn(2, -2, rsTransReliure + ' :');
  Prn.WriteLineColumn(3, -2, Edition.Reliure.Caption);
  Prn.WriteLineColumn(5, -2, rsTransTypeEdition + ' :');
  Prn.WriteLineColumn(6, -2, Edition.TypeEdition.Caption);

  Prn.WriteLineColumn(0, -1, rsTransPages + ' :');
  Prn.WriteLineColumn(1, -2, NonZero(IntToStr(Edition.NombreDePages)));
  Prn.WriteLineColumn(2, -2, rsTransOrientation + ' :');
  Prn.WriteLineColumn(3, -2, Edition.Orientation.Caption);
  Prn.WriteLineColumn(5, -2, rsTransFormatEdition + ' :');
  Prn.WriteLineColumn(6, -2, Edition.FormatEdition.Caption);

  Prn.WriteLineColumn(0, -1, rsTransNumeroPerso + ' :');
  Prn.WriteLineColumn(1, -2, Edition.NumeroPerso);
  Prn.WriteLineColumn(2, -2, rsTransSensLecture + ' :');
  Prn.WriteLineColumn(3, -2, Edition.SensLecture.Caption);

  Prn.NextLine;

  if Edition.Notes <> '' then
  begin
    Prn.WriteLineColumn(0, -1, rsTransNotes + ' :');
    Prn.WriteColumn(7, -1, Edition.Notes);
    Prn.NextLine;
  end;

  nbImageHorz := Trunc((Prn.Detail.Width + ThumbInterval) / (ThumbWidth + ThumbInterval));
  // si nbImageHorz = 0 alors on n'a pas assez de place pour mettre les images dans une page donc pas necessaire de passer à la page suivante
  if TGlobalVar.Utilisateur.Options.FicheAlbumWithCouverture and (nbImageHorz > 0) then
  begin
    numCol := 1;
    Repositionne := False;
    ImageDessinee := False;

    for PC in Edition.Couvertures do
    begin
      fWaiting.ShowProgression(rsTransImage + '...', epNext);
      ms := GetCouvertureStream(False, PC.ID, Prn.MmsToPixelsVertical(ThumbHeigth), Prn.MmsToPixelsHorizontal(ThumbWidth),
        TGlobalVar.Utilisateur.Options.AntiAliasing, True, Prn.MmsToPixelsHorizontal(1));
      if Assigned(ms) then
        try
          if not Repositionne then
            Prn.SetYPosition(Prn.GetYPosition + ThumbInterval);

          if (Prn.Detail.Top + Prn.Detail.Height - Prn.GetYPosition) < ThumbHeigth then
            Prn.NewPage;

          fWaiting.ShowProgression(rsTransImage + '...', epNext);
          jpg := TJpegImage.Create;
          try
            jpg.LoadFromStream(ms);
            Prn.Draw(Prn.Detail.Left + (ThumbWidth + ThumbInterval) * (numCol - 1) + ((ThumbWidth - Prn.PixelsToMmsHorizontal(jpg.Width)) / 2),
              Prn.GetYPosition + ((ThumbHeigth - Prn.PixelsToMmsVertical(jpg.Height)) / 2), jpg);
            Repositionne := True;
            ImageDessinee := True;
            Inc(numCol);
            if numCol > nbImageHorz then
            begin
              numCol := 1;
              Prn.SetYPosition(Prn.GetYPosition + ThumbHeigth);
              Repositionne := False;
            end;
          finally
            FreeAndNil(jpg);
          end;
        finally
          FreeAndNil(ms);
        end;
    end;
    if Repositionne then
      Prn.SetYPosition(Prn.GetYPosition + ThumbHeigth);
    if ImageDessinee then
      Prn.SetYPosition(Prn.GetYPosition + ThumbInterval);
  end;
end;

procedure ImprimeParaBD(Prn: TPrintObject; ParaBD: TParaBDFull; const fWaiting: IWaiting);
var
  ms: TStream;
  jpg: TJpegImage;
  MinTop: Single;
  s: string;
  i, op: Integer;
begin
  Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(1, 42, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(2, 90, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(3, 122, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(4, 20, -1, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(5, 42, 30, taLeftJustify, Prn.Font.name, 16, []);

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 1, 7);

  MinTop := -1;
  if TGlobalVar.Utilisateur.Options.FicheParaBDWithImage and (ParaBD.Photos.Count > 0) then
  begin
    fWaiting.ShowProgression(rsTransImage + '...', epNext);
    ms := GetCouvertureStream(True, ParaBD.Photos[0].ID, Prn.MmsToPixelsVertical(60), Prn.MmsToPixelsHorizontal(60),
      TGlobalVar.Utilisateur.Options.AntiAliasing, True, Prn.MmsToPixelsHorizontal(1));
    if Assigned(ms) then
      try
        fWaiting.ShowProgression(rsTransImage + '...', epNext);
        jpg := TJpegImage.Create;
        try
          jpg.LoadFromStream(ms);
          Prn.Draw(Prn.Detail.Left + Prn.Detail.Width - Prn.PixelsToMmsHorizontal(jpg.Width), Prn.Detail.Top, jpg);
          MinTop := Prn.Detail.Top + Prn.PixelsToMmsVertical(jpg.Height);
        finally
          FreeAndNil(jpg);
        end;
      finally
        FreeAndNil(ms);
      end;
  end;

  Prn.SetTopOfPage;
  Prn.WriteLineColumn(0, -2, rsTransTitre + ' :');
  Prn.WriteLineColumn(5, -2, FormatTitre(ParaBD.TitreParaBD));
  Prn.WriteLineColumn(0, -1, rsTransSerie + ' :');
  Prn.WriteLineColumn(5, -2, FormatTitre(ParaBD.Serie.TitreSerie));
  Prn.NewLines(2);

  Prn.WriteLineColumn(0, -1, ParaBD.CategorieParaBD.Caption);
  if ParaBD.Dedicace then
    Prn.WriteLineColumn(2, -2, rsTransDedicace);
  Prn.WriteLineColumn(0, -1, rsTransAnnee + ' :');
  Prn.WriteLineColumn(1, -2, NonZero(IntToStr(ParaBD.AnneeEdition)));
  if ParaBD.Numerote then
    Prn.WriteLineColumn(2, -2, rsTransNumerote);

  Prn.NextLine;

  if ParaBD.CategorieParaBD.Value = 0 then
    s := rsTransAuteurs
  else
    s := rsTransCreateurs;
  fWaiting.ShowProgression(Format('%s (%s %d)...', [s, rsTransPage, Prn.GetPageNumber]), epNext);
  if ParaBD.Auteurs.Count > 0 then
    Prn.WriteLineColumn(0, -1, s + ' :');
  op := -2;
  for i := 0 to ParaBD.Auteurs.Count - 1 do
  begin
    Prn.WriteLineColumn(1, op, TAuteurLite(ParaBD.Auteurs[i]).ChaineAffichage);
    op := -1;
  end;

  Prn.NextLine;
  if Prn.GetYPosition < MinTop then
    Prn.SetYPosition(MinTop);
  Prn.NextLine;

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransDescription, rsTransPage, Prn.GetPageNumber]), epNext);
  if ParaBD.Description <> '' then
  begin
    Prn.WriteLineColumn(0, -1, rsTransDescription + ' :');
    Prn.WriteColumn(4, -1, ParaBD.Description);
    Prn.NextLine;
  end;

  Prn.NewLines(2);

  Prn.Columns.Clear;
  Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(1, 42, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(2, 75, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(3, 107, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(4, 150, 30, taLeftJustify, Prn.Font.name, 12, [fsBold]);

  Prn.WriteLineColumn(0, -1, rsTransPrix + ' :');
  if ParaBD.Gratuit then
    Prn.WriteLineColumn(1, -2, rsTransGratuit)
  else if ParaBD.Prix > 0 then
    Prn.WriteLineColumn(1, -2, BDCurrencyToStr(ParaBD.Prix));
  if ParaBD.Offert then
    Prn.WriteLineColumn(2, -2, rsTransOffertLe + ' :')
  else
    Prn.WriteLineColumn(2, -2, rsTransAcheteLe + ' :');
  Prn.WriteLineColumn(3, -2, ParaBD.sDateAchat);
  if ParaBD.Stock then
    Prn.WriteLineColumn(4, -2, rsTransStock);
  if ParaBD.PrixCote > 0 then
  begin
    Prn.WriteLineColumn(0, -1, rsTransCote + ' :');
    Prn.WriteLineColumn(1, -2, Format('%s (%d)', [BDCurrencyToStr(ParaBD.PrixCote), ParaBD.AnneeCote]));
  end;
end;

procedure ImprimeAlbum(Prn: TPrintObject; Album: TAlbumFull; DetailsOptions: TDetailSerieOption; const fWaiting: IWaiting);
var
  s, s2: string;
  i, op: Integer;
  Edition: TEditionFull;
begin
  Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(1, 42, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(2, 90, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
  Prn.CreateColumn1(3, 122, 30, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(4, 20, -1, taLeftJustify, Prn.Font.name, 12, []);
  Prn.CreateColumn1(5, 42, 30, taLeftJustify, Prn.Font.name, 16, []);

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransParaDB, rsTransPage, Prn.GetPageNumber]), 1, 7);

  Prn.SetTopOfPage;

  Prn.WriteLineColumn(0, -2, rsTransSerie + ' :');
  Prn.WriteLineColumn(5, -2, FormatTitre(Album.Serie.TitreSerie));
  Prn.WriteLineColumn(0, -1, rsTransAlbum + ' :');
  Prn.WriteLineColumn(5, -2, FormatTitre(Album.TitreAlbum));
  Prn.NewLines(2);

  if Album.HorsSerie then
    Prn.WriteLineColumn(2, -2, rsTransHorsSerie);
  Prn.WriteLineColumn(0, -2, rsTransTome + ' :');
  if Album.Integrale then
  begin
    s := NonZero(IntToStr(Album.TomeDebut));
    AjoutString(s, NonZero(IntToStr(Album.TomeFin)), ' à ');
    AjoutString(s, 'Intégrale', ' ');
    s2 := NonZero(IntToStr(Album.Tome));
    AjoutString(s2, s, ' ', '[', ']');
    Prn.WriteLineColumn(1, -2, s2);
  end
  else
    Prn.WriteLineColumn(1, -2, NonZero(IntToStr(Album.Tome)));
  Prn.WriteLineColumn(0, -1, rsTransAnneeParution + ' :');
  Prn.WriteLineColumn(1, -2, IIf(Album.MoisParution > 0, FormatSettings.ShortMonthNames[Album.MoisParution] + ' ', '') +
    NonZero(IntToStr(Album.AnneeParution)));

  s := '';
  for i := 0 to Album.Serie.Genres.Count - 1 do
    AjoutString(s, Album.Serie.Genres.ValueFromIndex[i], ', ');
  if s <> '' then
  begin
    Prn.WriteLineColumn(0, -1, rsTransGenre + ' :');
    Prn.WriteLineColumn(1, -2, s + '.');
  end;

  Prn.NextLine;

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransScenario, rsTransPage, Prn.GetPageNumber]), epNext);
  if Album.Scenaristes.Count > 0 then
    Prn.WriteLineColumn(0, -1, rsTransScenario + ' :');
  op := -2;
  for i := 0 to Album.Scenaristes.Count - 1 do
  begin
    Prn.WriteLineColumn(1, op, TAuteurLite(Album.Scenaristes[i]).ChaineAffichage);
    op := -1;
  end;

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransDessins, rsTransPage, Prn.GetPageNumber]), epNext);
  if Album.Dessinateurs.Count > 0 then
    Prn.WriteLineColumn(0, -1, rsTransDessins + ' :');
  op := -2;
  for i := 0 to Album.Dessinateurs.Count - 1 do
  begin
    Prn.WriteLineColumn(1, op, TAuteurLite(Album.Dessinateurs[i]).ChaineAffichage);
    op := -1;
  end;

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransCouleurs, rsTransPage, Prn.GetPageNumber]), epNext);
  if Album.Coloristes.Count > 0 then
    Prn.WriteLineColumn(0, -1, rsTransCouleurs + ' :');
  op := -2;
  for i := 0 to Album.Coloristes.Count - 1 do
  begin
    Prn.WriteLineColumn(1, op, TAuteurLite(Album.Coloristes[i]).ChaineAffichage);
    op := -1;
  end;

  Prn.NextLine;

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransHistoire, rsTransPage, Prn.GetPageNumber]), epNext);
  s := Album.Sujet;
  if s = '' then
    s := Album.Serie.Sujet;
  if s <> '' then
  begin
    Prn.WriteLineColumn(0, -1, rsTransHistoire + ' :');
    Prn.WriteColumn(4, -1, s);
    Prn.NextLine;
  end;

  fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransNotes, rsTransPage, Prn.GetPageNumber]), epNext);
  s := Album.Notes;
  if s = '' then
    s := Album.Serie.Notes;
  if s <> '' then
  begin
    Prn.WriteLineColumn(0, -1, rsTransNotes + ' :');
    Prn.WriteColumn(4, -1, s);
    Prn.NextLine;
  end;

  if (DetailsOptions > dsoAlbumsDetails) then
  begin
    if DetailsOptions < dsoEditionsDetaillees then
    begin
      Prn.Columns.Clear;
      Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
      Prn.CreateColumn1(1, 42, -1, taLeftJustify, Prn.Font.name, 12, []);

      Prn.WriteLineColumn(0, -1, rsTransEditions);
      for Edition in Album.Editions do
        Prn.WriteLineColumn(1, -1, Edition.ChaineAffichage);
    end;

    if DetailsOptions > dsoListeEditions then
      for Edition in Album.Editions do
        ImprimeEdition(Prn, Edition, fWaiting);
  end;
end;

procedure ImpressionFicheSerie(const Reference: TGUID; Previsualisation: Boolean);
var
  fWaiting: IWaiting;
  Serie: TSerieFull;
  Prn: TPrintObject;
  i, op: Integer;
  Album: TAlbumLite;
  AlbumComplet: TAlbumFull;
  ParaBD: TParaBDLite;
  ParaBDComplet: TParaBDFull;
  s, s2: string;
  Manquants: TSeriesIncompletes;
  Previsions: TPrevisionsSorties;
  Prevision: TPrevisionSortie;
  DetailsOptions: TDetailSerieOption;
  PrevisionsManquants: Boolean;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  if ChoisirDetailSerie(dsoSerieSeule, DetailsOptions, PrevisionsManquants) = mrCancel then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 9);
  Serie := TDaoSerieFull.getInstance(Reference);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      PreparePrintObject(Prn, Previsualisation, rsTransFiche);

      Prn.SetHeaderDimensions1(-1, -1, -1, 20, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(Serie.TitreSerie), taCenter, Prn.Font.name, 24, [fsBold]);

      Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
      Prn.CreateColumn1(1, 42, 30, taLeftJustify, Prn.Font.name, 12, []);
      Prn.CreateColumn1(2, 30, -1, taLeftJustify, Prn.Font.name, 12, [fsItalic]);
      Prn.CreateColumn1(3, 122, 30, taLeftJustify, Prn.Font.name, 12, []);
      Prn.CreateColumn1(4, 20, -1, taLeftJustify, Prn.Font.name, 12, []);
      Prn.CreateColumn1(5, 42, 30, taLeftJustify, Prn.Font.name, 16, []);

      if not Serie.Terminee.Undefined then
        if Serie.Terminee.AsBoolean[False] then
          Prn.WriteLineColumn(2, -1, rsTransSerieTerminee)
        else
          Prn.WriteLineColumn(2, -1, rsTransSerieEnCours);

      Prn.NextLine;

      Prn.WriteLineColumn(0, -1, rsTransEditeur + ' :');
      Prn.WriteLineColumn(1, -2, FormatTitre(Serie.Editeur.NomEditeur));
      Prn.WriteLineColumn(0, -1, rsTransCollection + ' :');
      Prn.WriteLineColumn(1, -2, FormatTitre(Serie.Collection.NomCollection));

      s := '';
      for i := 0 to Serie.Genres.Count - 1 do
        AjoutString(s, Serie.Genres.ValueFromIndex[i], ', ');
      if s <> '' then
      begin
        Prn.WriteLineColumn(0, -1, rsTransGenre + ' :');
        Prn.WriteLineColumn(1, -2, s + '.');
      end;

      Prn.NextLine;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransScenario, rsTransPage, Prn.GetPageNumber]), epNext);
      if Serie.Scenaristes.Count > 0 then
        Prn.WriteLineColumn(0, -1, rsTransScenario + ' :');
      op := -2;
      for i := 0 to Serie.Scenaristes.Count - 1 do
      begin
        Prn.WriteLineColumn(1, op, TAuteurLite(Serie.Scenaristes[i]).ChaineAffichage);
        op := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransDessins, rsTransPage, Prn.GetPageNumber]), epNext);
      if Serie.Dessinateurs.Count > 0 then
        Prn.WriteLineColumn(0, -1, rsTransDessins + ' :');
      op := -2;
      for i := 0 to Serie.Dessinateurs.Count - 1 do
      begin
        Prn.WriteLineColumn(1, op, TAuteurLite(Serie.Dessinateurs[i]).ChaineAffichage);
        op := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransCouleurs, rsTransPage, Prn.GetPageNumber]), epNext);
      if Serie.Coloristes.Count > 0 then
        Prn.WriteLineColumn(0, -1, rsTransCouleurs + ' :');
      op := -2;
      for i := 0 to Serie.Coloristes.Count - 1 do
      begin
        Prn.WriteLineColumn(1, op, TAuteurLite(Serie.Coloristes[i]).ChaineAffichage);
        op := -1;
      end;

      Prn.NewLines(2);

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransHistoire, rsTransPage, Prn.GetPageNumber]), epNext);
      s := Serie.Sujet;
      if s <> '' then
      begin
        Prn.WriteLineColumn(0, -1, rsTransHistoire + ' :');
        Prn.WriteColumn(4, -1, s);
        Prn.NextLine;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransNotes, rsTransPage, Prn.GetPageNumber]), epNext);
      s := Serie.Notes;
      if s <> '' then
      begin
        Prn.WriteLineColumn(0, -1, rsTransNotes + ' :');
        Prn.WriteColumn(4, -1, s);
        Prn.NextLine;
      end;

      Prn.NextLine;

      if DetailsOptions > dsoSerieSeule then
      begin
        Prn.Columns.Clear;
        Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
        Prn.CreateColumn1(1, 42, -1, taLeftJustify, Prn.Font.name, 12, []);
        Prn.CreateColumn1(2, 42, -1, taLeftJustify, Prn.Font.name, 12, [fsItalic]);

        if (Serie.Albums.Count > 0) and (DetailsOptions < dsoAlbumsDetails) then
        begin
          Prn.WriteLineColumn(0, -1, rsTransAlbums);
          for Album in Serie.Albums do
          begin
            s := '';
            if Album.Integrale then
            begin
              s2 := NonZero(IntToStr(Album.TomeDebut));
              AjoutString(s2, NonZero(IntToStr(Album.TomeFin)), ' à ');
              AjoutString(s, 'Intégrale ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(Album.Tome))));
              AjoutString(s, s2, ' ', '[', ']');
            end
            else if Album.HorsSerie then
              AjoutString(s, 'Hors série ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(Album.Tome))))
            else
              AjoutString(s, NonZero(IntToStr(Album.Tome)), ' - ', 'Tome ');

            AjoutString(s, FormatTitre(Album.Titre), ' - ');
            Prn.WriteLineColumn(1, -1, s);
          end;
        end;

        if PrevisionsManquants then
        begin
          Previsions := TPrevisionsSorties.Create(Serie.ID_Serie);
          try
            Prevision := nil;
            if Previsions.AnneesPassees.Count > 0 then
              Prevision := TPrevisionSortie(Previsions.AnneesPassees[0]);
            if Previsions.AnneeEnCours.Count > 0 then
              Prevision := TPrevisionSortie(Previsions.AnneeEnCours[0]);
            if Previsions.AnneesProchaines.Count > 0 then
              Prevision := TPrevisionSortie(Previsions.AnneesProchaines[0]);
            if Prevision <> nil then
            begin
              if DetailsOptions > dsoListeAlbums then
              begin
                Prn.WriteLineColumn(0, -1, rsTransPrevisionsSorties);
                Prn.WriteLineColumn(1, -1, 'Tome ' + IntToStr(Prevision.Tome) + ' en ' + IntToStr(Prevision.Annee));
              end
              else
                Prn.WriteLineColumn(2, -1, 'Tome ' + IntToStr(Prevision.Tome) + ' en ' + IntToStr(Prevision.Annee));
            end;
          finally
            Previsions.Free;
          end;
          Manquants := TSeriesIncompletes.Create(Serie.ID_Serie);
          try
            if Manquants.Series.Count > 0 then
            begin
              Prn.NextLine;
              Prn.WriteLineColumn(0, -1, rsTransAlbumsManquants);
              Prn.WriteLineColumn(1, -1, TSerieIncomplete(Manquants.Series[0]).ChaineAffichage);
            end;
          finally
            Manquants.Free;
          end;
        end;

        Prn.NextLine;

        Prn.Columns.Clear;
        Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
        Prn.CreateColumn1(1, 42, -1, taLeftJustify, Prn.Font.name, 12, []);
        Prn.CreateColumn1(2, 42, -1, taLeftJustify, Prn.Font.name, 12, [fsItalic]);

        if Serie.ParaBD.Count > 0 then
        begin
          Prn.WriteLineColumn(0, -1, rsTransParaDB);
          for ParaBD in Serie.ParaBD do
          begin
            s := '';
            AjoutString(s, ParaBD.sCategorie, ' - ');
            AjoutString(s, FormatTitre(ParaBD.Titre), ' - ');
            Prn.WriteLineColumn(1, -1, s);
          end;
          Prn.NextLine;
        end;

        if DetailsOptions > dsoListeAlbums then
        begin
          for Album in Serie.Albums do
          begin
            Prn.NewPage;
            AlbumComplet := TDaoAlbumFull.getInstance(Album.ID);
            try
              ImprimeAlbum(Prn, AlbumComplet, DetailsOptions, fWaiting);
            finally
              AlbumComplet.Free;
            end;
          end;

          for ParaBD in Serie.ParaBD do
          begin
            Prn.NewPage;
            ParaBDComplet := TDaoParaBDFull.getInstance(ParaBD.ID);
            try
              ImprimeParaBD(Prn, ParaBDComplet, fWaiting);
            finally
              ParaBDComplet.Free;
            end;
          end;
        end;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    Serie.Free;
  end;
end;

procedure ImpressionFicheUnivers(const Reference: TGUID; Previsualisation: Boolean);
begin
end;

procedure ImpressionFicheAlbum(const Reference, ID_Edition: TGUID; Previsualisation: Boolean);
var
  i: Integer;
  op: Integer;
  Album: TAlbumFull;
  Edition: TEditionFull;
  fWaiting: IWaiting;
  Prn: TPrintObject;
  DetailsOptions: TDetailSerieOption;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  if ChoisirDetailSerie(dsoAlbumsDetails, DetailsOptions) = mrCancel then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 9);
  // MinTop := -1;
  Album := TDaoAlbumFull.getInstance(Reference);
  Edition := nil;
  if not IsEqualGUID(ID_Edition, GUID_NULL) then
    Edition := TDaoEditionFull.getInstance(ID_Edition);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      PreparePrintObject(Prn, Previsualisation, rsTransFiche);

      ImprimeAlbum(Prn, Album, DetailsOptions, fWaiting);

      // imprime album ne peut pas connaitre l'édition qu'on veut imprimer
      if (Edition <> nil) and (DetailsOptions = dsoAlbumsDetails) then
        ImprimeEdition(Prn, Edition, fWaiting);

      Prn.Columns.Clear;
      Prn.CreateColumn1(0, 10, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);
      Prn.CreateColumn1(1, 42, 30, taLeftJustify, Prn.Font.name, 12, []);
      Prn.CreateColumn1(2, 42, 30, taRightJustify, Prn.Font.name, 12, [fsBold]);

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransSerie, rsTransPage, Prn.GetPageNumber]), epNext);
      Prn.WriteLineColumn(0, -1, rsTransSerie + ' :');
      op := -2;
      if Album.Serie.Terminee.AsBoolean[False] then
      begin
        Prn.WriteLineColumn(2, -2, rsTransTerminee);
        op := -1;
      end;
      for i := 0 to Album.Serie.Albums.Count - 1 do
      begin
        Prn.WriteLineColumn(1, op, TAlbumLite(Album.Serie.Albums[i]).ChaineAffichage);
        op := -1;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    if (Edition <> nil) then
      Edition.Free;
    Album.Free;
  end;
end;

procedure ImpressionFicheParaBD(const Reference: TGUID; Previsualisation: Boolean);
var
  ParaBD: TParaBDFull;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 9);
  ParaBD := TDaoParaBDFull.getInstance(Reference);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      PreparePrintObject(Prn, Previsualisation, rsTransFiche);

      ImprimeParaBD(Prn, ParaBD, fWaiting);
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    ParaBD.Free;
  end;
end;

procedure ImpressionFicheAuteur(const Reference: TGUID; Previsualisation: Boolean);
var
  Auteur: TAuteurFull;
  fWaiting: IWaiting;
  Prn: TPrintObject;
  Serie: TSerieFull;
  fl: Integer;
  Album: TAlbumLite;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 3);
  Auteur := TDaoAuteurFull.getInstance(Reference);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      PreparePrintObject(Prn, Previsualisation, rsTransFiche);

      Prn.SetHeaderDimensions1(-1, -1, -1, 20, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(Auteur.NomAuteur), taCenter, Prn.Font.name, 24, [fsBold]);

      Prn.CreateColumn1(0, 10, 70, taLeftJustify, Prn.Font.name, 12, [fsBold]);
      Prn.CreateColumn1(1, 20, -1, taLeftJustify, Prn.Font.name, 12, []);

      fl := -2;
      // if Auteur.SiteWeb <> '' then Prn.WriteColumn(1, -1, Auteur.SiteWeb);
      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransBiographie, rsTransPage, Prn.GetPageNumber]), epNext);
      if Auteur.Biographie <> '' then
      begin
        Prn.WriteLineColumn(0, -2, rsTransBiographie + ' :');
        Prn.WriteColumn(1, -1, Auteur.Biographie);
        fl := -1;
      end;

      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransSeries, rsTransPage, Prn.GetPageNumber]), epNext);
      for Serie in Auteur.Series do
      begin
        Prn.WriteLineColumn(0, fl, FormatTitre(Serie.TitreSerie) + ' :');
        for Album in Serie.Albums do
          Prn.WriteColumn(1, -1, Album.ChaineAffichage);
        fl := -1;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    Auteur.Free;
  end;
end;

procedure ImpressionListeCompleteAlbums(Previsualisation: Boolean);
var
  index: Integer;
  OldSerie: TGUID;
  liste: TModalResult;
  qrySource, qryEquipe: TManagedQuery;
  sl: Boolean;
  Sujet, SujetSerie, sEquipe, s, s2: string;
  ColumnStyle: TFontStyles;
  PAl: TAlbumLite;
  PA: TAuteurLite;
  NbAlbums: Integer;
  DetailsOptions: TDetailAlbumOptions;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  liste := ChoisirDetailAlbum(1, DetailsOptions);
  if liste = mrCancel then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  qrySource := dmPrinc.DBConnection.GetQuery;
  qryEquipe := dmPrinc.DBConnection.GetQuery(qrySource.Transaction);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      qrySource.SQL.Text := 'SELECT Count(a.ID_Album)';
      qrySource.SQL.Add('FROM Albums a INNER JOIN Editions e ON a.ID_Album = e.ID_Album LEFT JOIN Series s ON a.ID_Serie = s.ID_Serie');
      qrySource.Open;
      NbAlbums := qrySource.Fields.AsInteger[0];
      qrySource.Close;
      qrySource.SQL[0] :=
        'SELECT a.ID_Album, a.TITREALBUM, a.MOISPARUTION, a.ANNEEPARUTION, a.ID_Serie, a.TOME, a.TOMEDEBUT, a.TOMEFIN, a.HORSSERIE, a.INTEGRALE, s.TITRESERIE';
      qrySource.SQL.Add('ORDER BY s.TITRESERIE NULLS FIRST, a.ID_Serie, a.HORSSERIE NULLS FIRST, a.INTEGRALE NULLS FIRST, a.TOME NULLS FIRST');
      if liste = mrNo then
      begin
        if daoHistoire in DetailsOptions then
          qrySource.SQL[0] := qrySource.SQL[0] + ', a.SUJETALBUM, s.SUJETSERIE';
        if daoNotes in DetailsOptions then
          qrySource.SQL[0] := qrySource.SQL[0] + ', a.REMARQUESALBUM, s.REMARQUESSERIE';
        qrySource.FetchBlobs := True;
      end;

      qryEquipe.SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL, NULL)';

      PreparePrintObject(Prn, Previsualisation, rsListeCompleteAlbums);

      Prn.SetHeaderDimensions1(-1, -1, -1, 30, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsListeCompleteAlbums, taCenter, Prn.Font.name, 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, IntToStr(NbAlbums) + ' ' + rsTransAlbums, taCenter, Prn.Font.name, 12, []);

      if liste = mrNo then
        ColumnStyle := [fsBold]
      else
        ColumnStyle := [];
      Prn.CreateColumn1(0, 15, 15, taLeftJustify, Prn.Font.name, 12, ColumnStyle); // numéro
      Prn.CreateColumn1(1, 25, -1, taLeftJustify, Prn.Font.name, 12, ColumnStyle); // titre
      Prn.CreateColumn1(2, 35, -1, taLeftJustify, Prn.Font.name, 10, [fsItalic]); // résumé
      Prn.CreateColumn1(3, 35, -1, taLeftJustify, Prn.Font.name, 8, []); // réalisation, acteurs
      Prn.CreateColumn1(4, 15, -1, taLeftJustify, Prn.Font.name, 12, [fsBold]); // série
      Prn.CreateColumn1(5, 25, -1, taLeftJustify, Prn.Font.name, 10, [fsItalic]); // résumé de la série

      PAl := TFactoryAlbumLite.getInstance;
      with qrySource do
      begin
        index := 1;
        Open;
        sl := False;
        OldSerie := GUID_FULL;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 0, NbAlbums + 2);
        while not Eof do
        begin
          if liste = mrNo then
          begin
            Sujet := '';
            if (daoHistoire in DetailsOptions) then
            begin
              SujetSerie := Fields.ByNameAsString['SUJETSERIE'];
              Sujet := Fields.ByNameAsString['SUJETALBUM'];
            end;
            if (daoNotes in DetailsOptions) then
            begin
              AjoutString(SujetSerie, Fields.ByNameAsString['REMARQUESSERIE'], #13#10#13#10);
              AjoutString(Sujet, Fields.ByNameAsString['REMARQUESALBUM'], #13#10#13#10);
            end;
            if ([daoScenario, daoDessins, daoCouleurs] * DetailsOptions) <> [] then
            begin
              sEquipe := '';
              qryEquipe.Close;
              qryEquipe.Params.AsString[0] := Fields.ByNameAsString['ID_Album'];
              qryEquipe.Open;
              with qryEquipe do
              begin
                s := '';
                while (daoScenario in DetailsOptions) and (not Eof) and (TMetierAuteur(Fields.ByNameAsInteger['Metier']) = maScenariste) do
                begin
                  PA := TDaoAuteurAlbumLite.Make(qryEquipe);
                  AjoutString(s, PA.ChaineAffichage, ', ');
                  PA.Free;
                  Next;
                end;
                AjoutString(sEquipe, s, #13#10, rsTransScenario + ': ', '.');
                s := '';
                while (daoDessins in DetailsOptions) and (not Eof) and (TMetierAuteur(Fields.ByNameAsInteger['Metier']) = maDessinateur) do
                begin
                  PA := TDaoAuteurAlbumLite.Make(qryEquipe);
                  AjoutString(s, PA.ChaineAffichage, ', ');
                  PA.Free;
                  Next;
                end;
                AjoutString(sEquipe, s, #13#10, rsTransDessins + ': ', '.');
                s := '';
                while (daoCouleurs in DetailsOptions) and (not Eof) and (TMetierAuteur(Fields.ByNameAsInteger['Metier']) = maColoriste) do
                begin
                  PA := TDaoAuteurAlbumLite.Make(qryEquipe);
                  AjoutString(s, PA.ChaineAffichage, ', ');
                  PA.Free;
                  Next;
                end;
                AjoutString(sEquipe, s, #13#10, rsTransCouleurs + ': ', '.');
              end;
            end;
          end;

          if (index <> 1) and (liste = mrNo) and (SujetSerie + Sujet + sEquipe <> '') and (Prn.GetLinesLeftFont(Prn.Columns[2].Font) < 3) then
          begin
            Prn.NewPage;
            sl := False;
          end;

          TDaoAlbumLite.Fill(PAl, qrySource);

          if not IsEqualGUID(OldSerie, PAl.ID_Serie) then
          begin
            if (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 3) then
            begin
              Prn.NewPage;
              sl := False;
            end;
            if sl then
              Prn.NextLine;
            s := FormatTitre(PAl.Serie);
            if s = '' then
              s := '<Sans série>';
            Prn.WriteLineColumn(4, IIf(sl, -1, -2), s);
            if (liste = mrNo) then
            begin
              if SujetSerie <> '' then
                Prn.WriteColumn(5, -1, SujetSerie);
            end;
          end;

          // Prn.WriteLineColumn(0, IIf(sl or (OldSerie <> PAl.ID_Serie), -1, -2), '#' + IntToStr(index));

          s := '';
          if PAl.Integrale then
          begin
            s2 := NonZero(IntToStr(PAl.TomeDebut));
            AjoutString(s2, NonZero(IntToStr(PAl.TomeFin)), ' à ');
            AjoutString(s, 'Intégrale ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))));
            AjoutString(s, s2, ' ', '[', ']');
          end
          else if PAl.HorsSerie then
            AjoutString(s, 'Hors série ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))))
          else
            AjoutString(s, NonZero(IntToStr(PAl.Tome)), ' - ', 'Tome ');

          AjoutString(s, FormatTitre(PAl.Titre), ' - ');

          if s = '' then
            s := FormatTitre(PAl.Serie); // si l'album n'a pas de titre c'est qu'il a une série

          // Prn.WriteLineColumn(1, -2, s);
          Prn.WriteLineColumn(1, IIf(sl or (not IsEqualGUID(OldSerie, PAl.ID_Serie)), -1, -2), s);

          sl := True;
          if (liste = mrNo) then
          begin
            if sEquipe <> '' then
              Prn.WriteColumn(3, -1, sEquipe);
            if Sujet <> '' then
              Prn.WriteColumn(2, -1, Sujet);
          end;
          OldSerie := PAl.ID_Serie;
          Next;
          fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
          Inc(index);
        end;
        PAl.Free;
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    qrySource.Free;
    qryEquipe.Free;
  end;
end;

procedure ImpressionInfosBDtheque(Previsualisation: Boolean);
var
  fWaiting: IWaiting;
  Prn: TPrintObject;
  Stat: TStats;

  procedure Imprimer(R: TStats; MaxAlbums: Integer = -1);
  var
    i, ColonneGenre, NbLignes: Integer;
    YPos, YPosMax: Single;
    Position: array [1 .. 10] of Single;
  begin
    Prn.SetTopOfPage;
    Prn.SetFontInformation1(Prn.Font.name, 5, []);
    Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack);
    Prn.NextLine;
    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
    Prn.CreateColumn1(0, 20, 35, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(1, 57, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(2, 100, 35, taRightJustify, Prn.Font.name, 10, [fsBold]);
    Prn.CreateColumn1(3, 137, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.Columns[0].Font.Style := [fsBold];
    Prn.WriteLineColumn(0, -2, rsNombreAlbums + ' :');
    Prn.WriteLineColumn(1, -2, IntToStr(R.NbAlbums));
    Prn.Columns[0].Font.Style := [];
    Prn.WriteLineColumn(2, -2, rsAlbumsStock + ' :');
    Prn.WriteLineColumn(3, -2, Format(FormatPourcent, [R.NbAlbumsStock, MulDiv(R.NbAlbumsStock, 100, R.NbAlbums)]));
    Prn.Columns[0].Font.Style := [fsBold];
    Prn.WriteLineColumn(0, -1, rsNombreSeries + ' :');
    Prn.WriteLineColumn(1, -2, IntToStr(R.NbSeries) + ' (dont terminées: ' + Format(FormatPourcent,
      [R.NbSeriesTerminee, MulDiv(R.NbSeriesTerminee, 100, R.NbSeries)]) + ')');
    Prn.Columns[0].Font.Style := [];
    Prn.WriteLineColumn(0, -1, rsAlbumsNB + ' :');
    Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsNB, MulDiv(R.NbAlbumsNB, 100, R.NbAlbums)]));
    Position[3] := Prn.GetYPosition;
    Prn.WriteLineColumn(0, -1, rsAlbumsVO + ' :');
    Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsVO, MulDiv(R.NbAlbumsVO, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(0, -1, rsAlbumsIntegrales + ' :');
    Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsIntegrale, MulDiv(R.NbAlbumsIntegrale, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(0, -1, rsAlbumsHorsSerie + ' :');
    Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsHorsSerie, MulDiv(R.NbAlbumsHorsSerie, 100, R.NbAlbums)]));
    Prn.WriteLineColumn(0, -1, rsAlbumsDedicaces + ' :');
    Prn.WriteLineColumn(1, -2, Format(FormatPourcent, [R.NbAlbumsDedicace, MulDiv(R.NbAlbumsDedicace, 100, R.NbAlbums)]));
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.NextLine;
    Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack);
    Prn.NextLine;
    Position[5] := Prn.GetYPosition;

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransPrix, rsTransPage, Prn.GetPageNumber]), epNext);
    Prn.Columns.Clear;
    Prn.CreateColumn1(0, 20, 35, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(1, 57, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(2, 20, 35, taRightJustify, Prn.Font.name, 10, [fsBold]);
    Prn.CreateColumn1(3, 130, 35, taCenter, Prn.Font.name, 10, []);

    if R.NbAlbums > 0 then
    begin
      Prn.SetYPosition(Position[3]);
      Prn.WriteLineColumnCenter(3, -2, Format('%d < %s < %d', [R.MinAnnee, rsTransAnneeParution, R.MaxAnnee]));
      Prn.SetYPosition(Position[5]);
    end;

    Prn.WriteLineColumn(0, -2, rsValeurMoyenne + ' :');
    Prn.WriteLineColumn(1, -2, BDCurrencyToStr(R.PrixAlbumMoyen));
    Prn.WriteLineColumn(3, -2, BDCurrencyToStr(R.PrixAlbumMinimun) + ' < ' + rsTransPrix + ' < ' + BDCurrencyToStr(R.PrixAlbumMaximun));
    Prn.WriteLineColumn(2, -1, rsValeurConnue + ' :');
    Prn.WriteLineColumn(1, -2, BDCurrencyToStr(R.ValeurConnue));
    Prn.WriteLineColumn(2, -1, rsValeurEstimee + ' :');
    Prn.WriteLineColumn(1, -2, BDCurrencyToStr(R.ValeurEstimee));

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransEmprunteurs, rsTransPage, Prn.GetPageNumber]), epNext);
    Prn.Columns.Clear;
    Prn.CreateColumn1(0, 20, 35, taRightJustify, Prn.Font.name, 10, [fsBold]);
    Prn.CreateColumn1(1, 57, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(2, 110, 35, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(3, 147, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(4, 57, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(5, 20, 35, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(6, 30, -1, taLeftJustify, Prn.Font.name, 10, [fsItalic]);
    Prn.CreateColumn1(7, 147, 15, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(8, 110, 35, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(9, 120, -1, taLeftJustify, Prn.Font.name, 10, [fsItalic]);

    fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransGenres, rsTransPage, Prn.GetPageNumber]), epNext);
    for i := 0 to Prn.Columns.Count - 1 do
      Prn.Columns[0].Free;
    Prn.CreateColumn1(0, 20, 35, taRightJustify, Prn.Font.name, 10, [fsBold]);
    Prn.CreateColumn1(1, 30, 40, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(2, 65, 10, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(3, 82, 10, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(4, 98, 10, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(5, 120, 40, taLeftJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(6, 155, 10, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(7, 172, 10, taRightJustify, Prn.Font.name, 10, []);
    Prn.CreateColumn1(8, 188, 10, taRightJustify, Prn.Font.name, 10, []);
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.NextLine;
    Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack);
    Prn.NextLine;
    i := R.ListGenre.Count;
    if (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < i + 3) and (Prn.GetLinesInDetailAreaFont(Prn.Columns[1].Font) > i) then
      Prn.NewPage;
    Prn.WriteLineColumn(0, -2, rsTransGenres + ' :');
    Prn.AutoPaging := False;
    ColonneGenre := 0;
    NbLignes := Prn.GetLinesLeftFont(Prn.Columns[1].Font);
    if NbLignes * 2 > R.ListGenre.Count then
      NbLignes := Ceil(R.ListGenre.Count / 2);
    i := 0;
    YPos := Prn.GetYPosition;
    YPosMax := YPos;
    while i < R.ListGenre.Count do
    begin
      Prn.WriteLineColumn(1 + 4 * ColonneGenre, -1, TGenreLite(R.ListGenre[i]).ChaineAffichage);
      Prn.WriteLineColumn(2 + 4 * ColonneGenre, -2, Format('%d', [TGenreLite(R.ListGenre[i]).Quantite]));
      Prn.WriteLineColumn(3 + 4 * ColonneGenre, -2, Format('(%f%%)', [MulDiv(TGenreLite(R.ListGenre[i]).Quantite, 100, R.NbAlbums)]));
      if MaxAlbums > 0 then
        Prn.WriteLineColumn(4 + 4 * ColonneGenre, -2, Format('(%f%%)', [MulDiv(TGenreLite(R.ListGenre[i]).Quantite, 100, MaxAlbums)]));
      Inc(i);
      if i = NbLignes then
      begin
        ColonneGenre := 1 - ColonneGenre;
        if ColonneGenre = 0 then
        begin
          Prn.NewPage;
          YPos := Prn.GetYPosition;
          YPosMax := YPos;
        end
        else
        begin
          YPosMax := Prn.GetYPosition;
          Prn.SetYPosition(YPos);
        end;
      end;
    end;
    if YPosMax > Prn.GetYPosition then
      Prn.SetYPosition(YPosMax);
    Prn.NextLineFont(Prn.Columns[0].Font);
    Prn.DrawLine(Prn.Detail.Left, Prn.GetYPosition, Prn.Detail.Left + Prn.Detail.Width, Prn.GetYPosition, 1, clBlack);
    Prn.AutoPaging := True;
  end;

var
  i: Integer;
  Stats: TStats;
begin
  i := Choisir('Générique', 'Détaillée pour chaque éditeur', 1);
  if i = mrCancel then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Stats := TStats.BuildStats(i = mrNo);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      fWaiting.ShowProgression(rsTransConfig + '...', 0, 12);
      PreparePrintObject(Prn, Previsualisation, rsInformationsBDtheque);

      Prn.SetHeaderDimensions1(-1, -1, -1, 30, False, 1, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsInformationsBDtheque, taCenter, Prn.Font.name, 24, [fsBold]);

      Printer.Canvas.Pen.Color := clBlack;

      Imprimer(Stats);
      Prn.SetHeaderInformation1(1, -1, '', taCenter, Prn.Font.name, 12, [fsBold]);
      for Stat in Stats.ListEditeurs do
      begin
        Prn.NewPage;
        Prn.Headers[1].Text := 'Répartition pour ' + FormatTitre(Stat.Editeur);
        Imprimer(Stat, Stats.NbAlbums);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    Stats.Free;
  end;
end;

procedure ImpressionRecherche(Recherche: TRecherche; Previsualisation: Boolean);
var
  col: Single;
  liste: TModalResult;
  i, nTri: Integer;
  PAl: TAlbumLite;
  sl: TStringList;
  qrySource, qryEquipe: TManagedQuery;
  Sujet, sEquipe, s: string;
  PA: TAuteurLite;
  SautLigne: Boolean;
  DetailsOptions: TDetailAlbumOptions;
  fWaiting: IWaiting;
  Prn: TPrintObject;
  Criteres: TStringList;
  CritereTri: TCritereTri;
  h: Single;

  procedure ProcessCritere(aCritere: TBaseCritere; prefix: string = '');
  var
    i: Integer;
    s: string;
  begin
    if aCritere is TCritere then
    begin
      s := IntToStr(aCritere.Level - 1) + '|';
      with TCritere(aCritere) do
        Criteres.Add(s + prefix + Champ + '|' + Test);
    end
    else
      with TGroupCritere(aCritere) do
      begin
        if prefix <> '' then
          Criteres.Add(IntToStr(aCritere.Level - 1) + '|' + prefix + '| ');
        for i := 0 to SousCriteres.Count - 1 do
        begin
          if i > 0 then
            ProcessCritere(SousCriteres[i], TLblGroupOption[GroupOption] + ' ')
          else
            ProcessCritere(SousCriteres[i]);
        end;
      end;
  end;

begin
  liste := ChoisirDetailAlbum(1, DetailsOptions);
  if liste = mrCancel then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  Criteres := TStringList.Create;
  qrySource := dmPrinc.DBConnection.GetQuery;
  qryEquipe := dmPrinc.DBConnection.GetQuery(qrySource.Transaction);
  try
    case Recherche.TypeRecherche of
      trSimple:
        begin
          Criteres.Add(TLblRechercheSimple[Recherche.RechercheSimple]);
          Criteres.Add(Recherche.FLibelle);
        end;
      trComplexe:
        ProcessCritere(Recherche.Criteres);
    end;

    Prn := TPrintObject.Create(frmFond);
    try
      qrySource.SQL.Text := 'SELECT a.ID_Album'#13#10'FROM ALBUMS a LEFT JOIN Series s ON s.ID_Serie = a.ID_Serie WHERE a.ID_Album = ?';
      if liste = mrNo then
      begin
        if daoHistoire in DetailsOptions then
          qrySource.SQL[0] := qrySource.SQL[0] + ', a.SUJETALBUM, s.SUJETSERIE';
        if daoNotes in DetailsOptions then
          qrySource.SQL[0] := qrySource.SQL[0] + ', a.REMARQUESALBUM, s.REMARQUESSERIE';
        qrySource.FetchBlobs := True;
      end;
      qryEquipe.SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL, NULL)';

      PreparePrintObject(Prn, Previsualisation, rsResultatRecherche);

      Prn.SetHeaderDimensions1(-1, -1, -1, 30, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsResultatRecherche, taCenter, Prn.Font.name, 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, IntToStr(Recherche.Resultats.Count) + ' ' + rsTransAlbums, taCenter, Prn.Font.name, 12, []);

      Prn.CreateColumn1(0, 15, 15, taLeftJustify, Prn.Font.name, 12, []);
      Prn.CreateColumn1(1, 30, -1, taLeftJustify, Prn.Font.name, 12, []);
      Prn.CreateColumn1(2, 20, -1, taLeftJustify, Prn.Font.name, 14, [fsBold, fsUnderline]);
      Prn.CreateColumn1(3, 55, -1, taLeftJustify, Prn.Font.name, 12, [fsItalic]);
      Prn.CreateColumn1(4, 35, -1, taLeftJustify, Prn.Font.name, 10, [fsItalic]); // résumé
      Prn.CreateColumn1(5, 35, -1, taLeftJustify, Prn.Font.name, 8, []); // réalisation, acteurs
      Prn.CreateColumn1(6, 35, -1, taLeftJustify, Prn.Font.name, 8, [fsItalic]); // valeur des champs triés

      Prn.WriteLineColumn(2, -2, 'Critères :');
      Prn.NextLine;
      case Recherche.TypeRecherche of
        trSimple:
          begin
            Prn.WriteLineColumn(0, -1, 'Type de recherche :');
            Prn.WriteLineColumn(3, -2, 'Bibliographie');
            if Criteres.Count >= 2 then
            begin
              Prn.WriteLineColumn(0, -1, Criteres[0]);
              Prn.WriteLineColumn(3, -2, Criteres[1]);
            end;
          end;
        trComplexe:
          begin
            Prn.WriteLineColumn(0, -1, 'Type de recherche :');
            Prn.WriteLineColumn(3, -2, 'Complexe');
            if Criteres.Count > 0 then
            begin
              Prn.NextLine;
              sl := TStringList.Create;
              col := Prn.Columns[0].Position;
              try
                for i := 0 to Criteres.Count - 1 do
                begin
                  s := Criteres[i];
                  Split(s, '|');
                  sl.Text := s;
                  Prn.Columns[0].Position := col + StrToInt(sl[0]) * 5;
                  Prn.WriteLineColumn(0, -1, sl[1]);
                  if sl.Count > 2 then
                  begin
                    Prn.Columns[3].Position := Prn.Columns[0].Position + Prn.GetTextWidthFont(sl[1], Prn.Columns[0].Font) + 5;
                    Prn.WriteLineColumn(3, -2, sl[2]);
                  end;
                end;
              finally
                sl.Free;
                Prn.Columns[0].Position := col;
              end;
            end;
            if Recherche.SortBy.Count > 0 then
            begin
              Prn.NextLine;
              Prn.WriteLineColumn(0, -1, 'Tri :');
              for i := 0 to Pred(Recherche.SortBy.Count) do
              begin
                CritereTri := TCritereTri(Recherche.SortBy[i]);
                if CritereTri._Champ.Booleen then
                  s := CritereTri.LabelChamp + ' - ' + IIf(CritereTri.Asc, 'Non puis Oui', 'Oui puis Non') + IIf(CritereTri.NullsFirst, ' - Vides en premier',
                    '') + IIf(CritereTri.NullsLast, ' - Vides en dernier', '')
                else
                  s := CritereTri.LabelChamp + ' - ' + IIf(CritereTri.Asc, 'Croissant', 'Décroissant') + IIf(CritereTri.NullsFirst, ' - Vides en premier', '') +
                    IIf(CritereTri.NullsLast, ' - Vides en dernier', '');
                Prn.WriteLineColumn(3, IIf(i = 0, -2, -1), s);
              end;
            end;
          end;
      end;

      Prn.NewLines(1.5);
      Prn.WriteLineColumn(2, -1, Format('Résultats: (%d)', [Recherche.Resultats.Count]));
      Prn.NextLine;
      fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 0, Recherche.Resultats.Count + 1);
      if (liste = mrNo) then
      begin
        Prn.Columns[0].Font.Style := [fsBold];
        Prn.Columns[1].Font.Style := Prn.Columns[0].Font.Style;
      end;
      SautLigne := True;
      nTri := -1;
      for i := 0 to Recherche.Resultats.Count - 1 do
      begin
        PAl := Recherche.Resultats[i];
        if liste = mrNo then
        begin
          Sujet := '';
          if (daoHistoire in DetailsOptions) or (daoNotes in DetailsOptions) then
          begin
            qrySource.Params.AsString[0] := GUIDToString(PAl.ID);
            qrySource.Open;
            if (daoHistoire in DetailsOptions) then
            begin
              if qrySource.Fields.ByNameIsNull['SUJETALBUM'] then
                Sujet := qrySource.Fields.ByNameAsString['SUJETSERIE']
              else
                Sujet := qrySource.Fields.ByNameAsString['SUJETALBUM']
            end;
            if (daoNotes in DetailsOptions) then
            begin
              if qrySource.Fields.ByNameIsNull['REMARQUESALBUM'] then
                AjoutString(Sujet, qrySource.Fields.ByNameAsString['REMARQUESSERIE'], #13#10#13#10)
              else
                AjoutString(Sujet, qrySource.Fields.ByNameAsString['REMARQUESALBUM'], #13#10#13#10)
            end;
          end;
          if ([daoScenario, daoDessins, daoCouleurs] * DetailsOptions) <> [] then
          begin
            qryEquipe.Params.AsString[0] := GUIDToString(PAl.ID);
            qryEquipe.Open;
            sEquipe := '';
            with qryEquipe do
            begin
              s := '';
              while (daoScenario in DetailsOptions) and (not Eof) and (TMetierAuteur(Fields.ByNameAsInteger['Metier']) = maScenariste) do
              begin
                PA := TDaoAuteurAlbumLite.Make(qryEquipe);
                AjoutString(s, PA.ChaineAffichage, ', ');
                PA.Free;
                Next;
              end;
              AjoutString(sEquipe, s, #13#10, rsTransScenario + ': ', '.');
              s := '';
              while (daoDessins in DetailsOptions) and (not Eof) and (TMetierAuteur(Fields.ByNameAsInteger['Metier']) = maDessinateur) do
              begin
                PA := TDaoAuteurAlbumLite.Make(qryEquipe);
                AjoutString(s, PA.ChaineAffichage, ', ');
                PA.Free;
                Next;
              end;
              AjoutString(sEquipe, s, #13#10, rsTransDessins + ': ', '.');
              s := '';
              while (daoCouleurs in DetailsOptions) and (not Eof) and (TMetierAuteur(Fields.ByNameAsInteger['Metier']) = maColoriste) do
              begin
                PA := TDaoAuteurAlbumLite.Make(qryEquipe);
                AjoutString(s, PA.ChaineAffichage, ', ');
                PA.Free;
                Next;
              end;
              AjoutString(sEquipe, s, #13#10, rsTransCouleurs + ': ', '.');
            end;
          end;
        end;
        if nTri = -1 then
          with TStringList.Create do
            try
              Text := Recherche.ResultatsInfos[i];
              nTri := Count;
            finally
              Free;
            end;

        h := Prn.GetLineHeightMmsFont(Prn.Columns[1].Font);
        if (nTri > 0) then
          // le premier décalage sera de la hauteur de la colonne 1
          // les suivants de la hauteur de la colonne 6
          h := h + Prn.GetLineHeightMmsFont(Prn.Columns[1].Font) + Prn.GetLineHeightMmsFont(Prn.Columns[6].Font) * (nTri - 1);

        if (i <> 0) and ((h > Prn.GetHeightLeftMms) or ((liste = mrNo) and (Sujet + sEquipe <> '') and
          (Prn.GetHeightLeftMms - h < 3 * Prn.GetLineHeightMmsFont(Prn.Columns[4].Font)))) then
        begin
          Prn.NewPage;
          SautLigne := False;
        end;

        Prn.WriteLineColumn(0, IIf(SautLigne, -1, -2), '#' + IntToStr(i + 1));
        case Recherche.TypeRecherche of
          trSimple:
            begin
              s := PAl.ChaineAffichage;
              AjoutString(s, Recherche.ResultatsInfos[i], ' ', '(', ')');
              Prn.WriteLineColumn(1, -2, s);
            end;
          trComplexe:
            begin
              Prn.WriteLineColumn(1, -2, PAl.ChaineAffichage);
              if Recherche.SortBy.Count > 0 then
                Prn.WriteColumn(6, -1, StringReplace(Recherche.ResultatsInfos[i], '\n', #13#10, [rfReplaceAll]));
            end;
        end;
        SautLigne := True;
        if (liste = mrNo) then
        begin
          if sEquipe <> '' then
            Prn.WriteColumn(5, -1, sEquipe);
          if Sujet <> '' then
            Prn.WriteColumn(4, -1, Sujet);
        end;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    qryEquipe.Free;
    qrySource.Free;
    Criteres.Free;
  end;
end;

procedure ImpressionCouvertureAlbum(const Reference, ID_Couverture: TGUID; Previsualisation: Boolean);
var
  Album: TAlbumFull;
  ms: TStream;
  jpg: TJpegImage;
  s: string;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Album := TDaoAlbumFull.getInstance(Reference);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      PreparePrintObject(Prn, Previsualisation, rsTransImage);

      Prn.SetHeaderDimensions1(-1, -1, -1, 20, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(Album.TitreAlbum), taCenter, Prn.Font.name, 24, [fsBold]);
      s := '';
      AjoutString(s, FormatTitre(Album.Serie.TitreSerie), ' - ');
      if Album.Integrale then
        AjoutString(s, 'INT.' + NonZero(IntToStr(Album.Tome)), ' - ')
      else if Album.HorsSerie then
        AjoutString(s, 'HS ' + NonZero(IntToStr(Album.Tome)), ' - ')
      else
        AjoutString(s, NonZero(IntToStr(Album.Tome)), ' - T.');
      Prn.SetHeaderInformation1(1, -1, s, taCenter, Prn.Font.name, 16, [fsBold]);
      // il serait bien d'indiqué ici dans l'entete la catégorie de l'image (couverture, planche, etc)

      Prn.PageNumber.Printed := False;

      // ShowMessage(Format('W %d H %d', [Prn.MmsToPixelsHorizontal(Prn.Detail.Width), Prn.MmsToPixelsVertical(Prn.Detail.Height)]));
      ms := GetCouvertureStream(False, ID_Couverture, Prn.MmsToPixelsVertical(Prn.Detail.Height), Prn.MmsToPixelsHorizontal(Prn.Detail.Width),
        TGlobalVar.Utilisateur.Options.AntiAliasing);
      if Assigned(ms) then
        try
          fWaiting.ShowProgression(rsTransImage + '...', epNext);
          jpg := TJpegImage.Create;
          try
            jpg.LoadFromStream(ms);
            Prn.Draw(Prn.Detail.Left + ((Prn.Detail.Width - Prn.PixelsToMmsHorizontal(jpg.Width)) / 2),
              Prn.Detail.Top + ((Prn.Detail.Height - Prn.PixelsToMmsVertical(jpg.Height)) / 2), jpg);
          finally
            FreeAndNil(jpg);
          end;
        finally
          FreeAndNil(ms);
        end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    Album.Free;
  end;
end;

procedure ImpressionImageParaBD(const Reference, ID_Photo: TGUID; Previsualisation: Boolean);
var
  ParaBD: TParaBDFull;
  ms: TStream;
  jpg: TJpegImage;
  s: string;
  fWaiting: IWaiting;
  Prn: TPrintObject;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  ParaBD := TDaoParaBDFull.getInstance(Reference);
  try
    Prn := TPrintObject.Create(frmFond);
    try
      PreparePrintObject(Prn, Previsualisation, rsTransImage);

      Prn.SetHeaderDimensions1(-1, -1, -1, 20, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, FormatTitre(ParaBD.TitreParaBD), taCenter, Prn.Font.name, 24, [fsBold]);
      s := '';
      AjoutString(s, FormatTitre(ParaBD.Serie.TitreSerie), ' - ');
      AjoutString(s, ParaBD.CategorieParaBD.Caption, ' - ');
      Prn.SetHeaderInformation1(1, -1, s, taCenter, Prn.Font.name, 16, [fsBold]);

      Prn.PageNumber.Printed := False;

      // ShowMessage(Format('W %d H %d', [Prn.MmsToPixelsHorizontal(Prn.Detail.Width), Prn.MmsToPixelsVertical(Prn.Detail.Height)]));
      ms := GetCouvertureStream(True, ID_Photo, Prn.MmsToPixelsVertical(Prn.Detail.Height), Prn.MmsToPixelsHorizontal(Prn.Detail.Width),
        TGlobalVar.Utilisateur.Options.AntiAliasing);
      if Assigned(ms) then
        try
          fWaiting.ShowProgression(rsTransImage + '...', epNext);
          jpg := TJpegImage.Create;
          try
            jpg.LoadFromStream(ms);
            Prn.Draw(Prn.Detail.Left + ((Prn.Detail.Width - Prn.PixelsToMmsHorizontal(jpg.Width)) / 2),
              Prn.Detail.Top + ((Prn.Detail.Height - Prn.PixelsToMmsVertical(jpg.Height)) / 2), jpg);
          finally
            FreeAndNil(jpg);
          end;
        finally
          FreeAndNil(ms);
        end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
    end;
  finally
    ParaBD.Free;
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
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Prn := TPrintObject.Create(frmFond);
  try
    PreparePrintObject(Prn, Previsualisation, rsTransAlbumsManquants);

    Prn.SetHeaderDimensions1(-1, -1, -1, 20, False, 0, clWhite);
    Prn.SetHeaderInformation1(0, 5, 'Séries incomplètes', taCenter, Prn.Font.name, 24, [fsBold]);

    Prn.PageNumber.Printed := False;

    Prn.CreateColumn1(0, 15, 10, taLeftJustify, Prn.Font.name, 12, []);
    Prn.CreateColumn1(1, 30, 105, taLeftJustify, Prn.Font.name, 12, []);
    Prn.CreateColumn1(2, 140, -1, taLeftJustify, Prn.Font.name, 12, []);

    for i := 0 to Pred(R.Series.Count) do
      with TSerieIncomplete(R.Series[i]) do
      begin
        if (i <> 0) and (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 2) then
          Prn.NewPage;
        y1 := Prn.GetYPosition;
        Prn.WriteLineColumn(0, -1, '#' + IntToStr(i + 1));
        Prn.SetYPosition(y1);
        Prn.WriteColumn(1, -1, Serie.ChaineAffichage(False));
        y2 := Prn.GetYPosition;
        s1 := '';
        for j := 0 to NumerosManquants.Count - 1 do
        begin
          s2 := NumerosManquants[j];
          if Pos('<>', s2) <> 0 then
            s2 := StringReplace(s2, '<>', ' à ', []);
          AjoutString(s1, s2, ', ');
        end;
        Prn.SetYPosition(y1);
        Prn.WriteColumn(2, -1, s1);
        if y2 > Prn.GetYPosition then
          Prn.SetYPosition(y2);
      end;
  finally
    fWaiting.ShowProgression(rsTransImpression + '...', epNext);
    if Prn.Printing then
      Prn.Quit;
    Prn.Free;
  end;
end;

procedure ImpressionListePrevisions(R: TPrevisionsSorties; Previsualisation: Boolean);
var
  Prn: TPrintObject;

  procedure PrintGroupe(const Titre: string; Previsions: TList<TPrevisionSortie>);
  var
    i: Integer;
    y1, y2: Single;
    Prevision: TPrevisionSortie;
  begin
    if Previsions.Count > 0 then
    begin
      Prn.WriteColumn(3, -1, Titre);

      for i := 0 to Pred(Previsions.Count) do
      begin
        Prevision := Previsions[i];
        if (i <> 0) and (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 2) then
          Prn.NewPage;
        Prn.WriteLineColumn(0, -1, '#' + IntToStr(i + 1));
        y1 := Prn.GetYPosition - Prn.GetLineHeightMmsFont(Prn.Columns[1].Font);
        Prn.SetYPosition(y1);
        Prn.WriteColumn(1, -1, Prevision.Serie.ChaineAffichage(False));
        y2 := Prn.GetYPosition;
        Prn.SetYPosition(y1);
        Prn.WriteColumn(2, -1, Format('Tome %d en %s', [Prevision.Tome, Prevision.sAnnee]));
        if y2 > Prn.GetYPosition then
          Prn.SetYPosition(y2);
      end;
    end;
  end;

var
  fWaiting: IWaiting;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig, 0, 2);
  Prn := TPrintObject.Create(frmFond);
  try
    PreparePrintObject(Prn, Previsualisation, rsTransPrevisionsSorties);

    Prn.SetHeaderDimensions1(-1, -1, -1, 20, False, 0, clWhite);
    Prn.SetHeaderInformation1(0, 5, 'Prévisions de sorties', taCenter, Prn.Font.name, 24, [fsBold]);

    Prn.PageNumber.Printed := False;

    Prn.CreateColumn1(0, 15, 10, taLeftJustify, Prn.Font.name, 12, []);
    Prn.CreateColumn1(1, 30, 105, taLeftJustify, Prn.Font.name, 12, []);
    Prn.CreateColumn1(2, 140, -1, taLeftJustify, Prn.Font.name, 12, []);
    Prn.CreateColumn1(3, 15, -1, taLeftJustify, Prn.Font.name, 16, [fsBold]);

    PrintGroupe('Années passées', R.AnneesPassees);
    PrintGroupe('Cette année', R.AnneeEnCours);
    PrintGroupe('Prochaines années', R.AnneesProchaines);
  finally
    fWaiting.ShowProgression(rsTransImpression + '...', epNext);
    if Prn.Printing then
      Prn.Quit;
    Prn.Free;
  end;
end;

type
  TAchat = class(TAlbumLite)
  public
    Prix: Currency;
    PrixCalcule: Boolean;
  end;

procedure ImpressionListePrevisionsAchats(Previsualisation: Boolean);
var
  OldAlbum, OldSerie: TGUID;
  qrySource: TManagedQuery;
  sl: Boolean;
  s, s2: string;
  PAl: TAchat;
  NbAlbums: Integer;
  fWaiting: IWaiting;
  Prn: TPrintObject;
  ListAlbums: TObjectList<TAchat>;
  PrixTotal, PrixMoyen: Currency;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsTransConfig + '...', 0, 1);
  qrySource := dmPrinc.DBConnection.GetQuery;
  try
    Prn := TPrintObject.Create(frmFond);
    ListAlbums := TObjectList<TAchat>.Create(True);
    try
      qrySource.SQL.Text := 'SELECT AVG(PRIX) FROM EDITIONS';
      qrySource.Open;
      PrixMoyen := qrySource.Fields.AsCurrency[0];

      qrySource.SQL.Text := 'SELECT Count(a.ID_Album)';
      qrySource.SQL.Add('FROM Albums a LEFT JOIN Series s ON a.ID_Serie = s.ID_Serie');
      qrySource.SQL.Add
        ('left join vw_prixunitaires v on v.horsserie = a.horsserie and v.ID_Serie = s.ID_Serie and (v.ID_Editeur = s.ID_Editeur or s.ID_Editeur is null)');
      qrySource.SQL.Add('WHERE a.Achat = 1');
      qrySource.Open;
      NbAlbums := qrySource.Fields.AsInteger[0] * 2; // on va parcourir 2 fois la liste
      qrySource.Close;
      qrySource.SQL[0] :=
        'SELECT a.ID_Album, a.TITREALBUM, a.MOISPARUTION, a.ANNEEPARUTION, a.ID_Serie, a.TOME, a.TOMEDEBUT, a.TOMEFIN, a.HORSSERIE, a.INTEGRALE, s.TITRESERIE, v.ID_Editeur, v.PRIXUNITAIRE';
      qrySource.SQL.Add('ORDER BY s.TITRESERIE NULLS FIRST, a.ID_Serie, a.HORSSERIE NULLS FIRST, a.INTEGRALE NULLS FIRST, a.TOME NULLS FIRST');

      PreparePrintObject(Prn, Previsualisation, rsListeAchats);

      with qrySource do
      begin
        Open;
        PrixTotal := 0;
        OldAlbum := GUID_FULL;
        PAl := nil;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), 0, NbAlbums + 2);
        while not Eof do
        begin
          if not IsEqualGUID(OldAlbum, StringToGUID(Fields.ByNameAsString['ID_ALBUM'])) then
          begin
            PAl := TAchat.Create;
            TDaoAlbumLite.Fill(PAl, qrySource);
            PAl.PrixCalcule := True;
            PAl.Prix := Fields.ByNameAsCurrency['PRIXUNITAIRE'];
            if PAl.Prix = 0 then
            begin
              PAl.PrixCalcule := False;
              PAl.Prix := PrixMoyen;
            end;
            PrixTotal := PrixTotal + PAl.Prix;
            OldAlbum := PAl.ID;
            ListAlbums.Add(PAl);
          end
          else
          begin
            PrixTotal := PrixTotal - PAl.Prix;
            PAl.PrixCalcule := False;
            PAl.Prix := PrixMoyen;
            PrixTotal := PrixTotal + PAl.Prix;
          end;

          Next;
          fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
        end;
      end;

      Prn.SetHeaderDimensions1(-1, -1, -1, 30, False, 0, clWhite);
      Prn.SetHeaderInformation1(0, 5, rsListeAchats, taCenter, Prn.Font.name, 24, [fsBold]);
      Prn.SetHeaderInformation1(1, -1, Format('%d %s - %s', [NbAlbums div 2
        { NbAlbums contient le double du nb d'albums } , rsTransAlbums, BDCurrencyToStr(PrixTotal)]), taCenter, Prn.Font.name, 12, []);
      Prn.SetHeaderInformation1(2, -1, 'Prix moyen estimé d''un album: ' + BDCurrencyToStr(PrixMoyen), taCenter, Prn.Font.name, 12, []);

      Prn.CreateColumn1(0, 15, 15, taLeftJustify, Prn.Font.name, 12, []); // numéro
      Prn.CreateColumn1(1, 25, -1, taLeftJustify, Prn.Font.name, 12, []); // titre
      Prn.CreateColumn1(2, 35, -1, taLeftJustify, Prn.Font.name, 10, [fsItalic]); // résumé
      Prn.CreateColumn1(3, 35, -1, taLeftJustify, Prn.Font.name, 8, []); // réalisation, acteurs
      Prn.CreateColumn1(4, 15, -1, taLeftJustify, Prn.Font.name, 12, [fsBold]); // série

      sl := False;
      OldSerie := GUID_FULL;
      for PAl in ListAlbums do
      begin
        if not IsEqualGUID(OldSerie, PAl.ID_Serie) then
        begin
          if (Prn.GetLinesLeftFont(Prn.Columns[1].Font) < 3) then
          begin
            Prn.NewPage;
            sl := False;
          end;
          if sl then
            Prn.NextLine;
          s := FormatTitre(PAl.Serie);
          if s = '' then
            s := '<Sans série>';
          Prn.WriteLineColumn(4, IIf(sl, -1, -2), s);
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
          if PAl.Integrale then
          begin
            s2 := NonZero(IntToStr(PAl.TomeDebut));
            AjoutString(s2, NonZero(IntToStr(PAl.TomeFin)), ' à ');
            AjoutString(s, 'Intégrale ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))));
            AjoutString(s, s2, ' ', '[', ']');
          end
          else if PAl.HorsSerie then
            AjoutString(s, 'Hors série ', ' - ', '', TrimRight(' ' + NonZero(IntToStr(PAl.Tome))))
          else
            AjoutString(s, NonZero(IntToStr(PAl.Tome)), ' - ', 'Tome ');

          AjoutString(s, IIf(PAl.MoisParution > 0, FormatSettings.ShortMonthNames[PAl.MoisParution] + ' ', '') + NonZero(IntToStr(PAl.AnneeParution)), ' - ');
          AjoutString(s, FormatTitre(PAl.Titre), ' - ');
          if PAl.PrixCalcule then
            AjoutString(s, BDCurrencyToStr(PAl.Prix), ' - ');

          Prn.WriteLineColumn(1, IIf(sl or (not IsEqualGUID(OldSerie, PAl.ID_Serie)), -1, -2), s);
        finally
          Prn.Columns[1].Font.Color := clBlack;
        end;

        sl := True;

        OldSerie := PAl.ID_Serie;
        fWaiting.ShowProgression(Format('%s (%s %d)...', [rsTransAlbums, rsTransPage, Prn.GetPageNumber]), epNext);
      end;
    finally
      fWaiting.ShowProgression(rsTransImpression + '...', epNext);
      if Prn.Printing then
        Prn.Quit;
      Prn.Free;
      ListAlbums.Free;
    end;
  finally
    qrySource.Free;
  end;
end;

end.
