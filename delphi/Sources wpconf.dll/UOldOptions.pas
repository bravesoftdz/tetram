unit UOldOptions;

interface

uses IniFiles, UOptions, UInterfacePlugIn;

procedure LoadOldOptions(IniStruct: IOptionsWriter; var FOptions: ROptions; var FDebug: RDebug);

implementation

uses Windows, SysUtils, Classes, Graphics;

function VideoInverse(Couleur: TColor): TColor;
begin
  Result := RGB(255 - GetRValue(Couleur), 255 - GetGValue(Couleur), 255 - GetBValue(Couleur));
end;

procedure LoadOldOptions(IniStruct: IOptionsWriter; var FOptions: ROptions; var FDebug: RDebug);
var
  i, j: Integer;
  s: string;
begin
  with IniStruct do begin
    FOptions.Legende.UseLegende := ReadBool('Options', 'Legende', False);
    FOptions.Legende.Position := ReadInteger('Options', 'PositionLeg', 21);
    FOptions.Legende.Position_X := ReadInteger('Options', 'PositionLeg_X', 0);
    FOptions.Legende.Position_Y := ReadInteger('Options', 'PositionLeg_Y', 0);
    FOptions.Legende.NomFichier := ReadInteger('Options', 'LegFichier', 0);
    FOptions.Calendrier.UseCalendrier := ReadBool('Options', 'Calendrier', False);
    FOptions.Calendrier.EnCours.Positionnement := 0;
    FOptions.Calendrier.EnCours.Position := ReadInteger('Options', 'PositionCal', 2);
    FOptions.Calendrier.EnCours.Position_X := ReadInteger('Options', 'PositionCal_X', 0);
    FOptions.Calendrier.EnCours.Position_Y := ReadInteger('Options', 'PositionCal_Y', 0);
    FOptions.Calendrier.Avant.Nombre := ReadInteger('Options', 'MoisAvant', 0);
    FOptions.Calendrier.Apres.Nombre := ReadInteger('Options', 'MoisApres', 0);
    FOptions.Calendrier.PremierJourSemaine := ReadInteger('Options', 'PremierJour', 1);
    FOptions.AntiAliasing := ReadBool('Options', 'Aliasing', True);
    FOptions.ResizeDesktop := ReadBool('Options', 'ResizeDesktop', True);
    FOptions.Legende.Trame := ReadInteger('Options', 'TrameLegende', 0);
    FOptions.Legende.TrameColor := ReadInteger('Options', 'TrameLegendeColor', clWhite);
    FOptions.Calendrier.EnCours.Trame := ReadInteger('Options', 'CalTrame', 0);
    FOptions.Calendrier.Avant.Trame := ReadInteger('Options', 'TrameCalendrierAvant', FOptions.Calendrier.EnCours.Trame);
    FOptions.Calendrier.Apres.Trame := ReadInteger('Options', 'TrameCalendrierApres', FOptions.Calendrier.EnCours.Trame);
    FOptions.Calendrier.Avant.TrameColor := ReadInteger('Options', 'TrameCalendrierAvantColor', clWhite);
    FOptions.Calendrier.EnCours.TrameColor := ReadInteger('Options', 'TrameCalendrierColor', FOptions.Calendrier.EnCours.TrameColor);
    FOptions.Calendrier.Apres.TrameColor := ReadInteger('Options', 'TrameCalendrierApresColor', FOptions.Calendrier.EnCours.TrameColor);
    if FOptions.Calendrier.EnCours.Trame < 0 then begin
      FOptions.Calendrier.EnCours.TrameColor := VideoInverse(FOptions.Calendrier.EnCours.TrameColor);
      FOptions.Calendrier.EnCours.Trame := -FOptions.Calendrier.EnCours.Trame;
    end;
    if FOptions.Calendrier.Avant.Trame < 0 then begin
      FOptions.Calendrier.Avant.TrameColor := VideoInverse(FOptions.Calendrier.Avant.TrameColor);
      FOptions.Calendrier.Avant.Trame := -FOptions.Calendrier.Avant.Trame;
    end;
    if FOptions.Calendrier.Apres.Trame < 0 then begin
      FOptions.Calendrier.Apres.TrameColor := VideoInverse(FOptions.Calendrier.Apres.TrameColor);
      FOptions.Calendrier.Apres.Trame := -FOptions.Calendrier.Apres.Trame;
    end;
    FOptions.Legende.Font := ReadString('Options', 'LegPolice', 'Arial');
    FOptions.Calendrier.Font := ReadString('Options', 'CalPolice', 'Arial');
    FOptions.Legende.FontSize := ReadInteger('Options', 'FontSizeLegende', 0);
    FOptions.Calendrier.EnCours.FontSize := ReadInteger('Options', 'CalPoliceSize', 0);
    FOptions.Calendrier.Avant.FontSize := ReadInteger('Options', 'FontSizeCalendrierAvant', FOptions.Calendrier.EnCours.FontSize - 6);
    FOptions.Calendrier.Apres.FontSize := ReadInteger('Options', 'FontSizeCalendrierApres', FOptions.Calendrier.EnCours.FontSize - 6);
    FOptions.Legende.FontColor := ReadInteger('Options', 'LegPoliceColor', clWhite);
    FOptions.Calendrier.FontColor := ReadInteger('Options', 'CalPoliceColor', clWhite);
    FOptions.Calendrier.FontColorFerie := ReadInteger('Options', 'CalFeriePoliceColor', clRed);
    FOptions.Calendrier.FontColorTitre := ReadInteger('Options', 'CalTitrePoliceColor', clWhite);
    FOptions.Calendrier.FontColorTitreAutre := ReadInteger('Options', 'CalTitreAutrePoliceColor', clWhite);
    FOptions.Calendrier.FontColorWE := ReadInteger('Options', 'CalWEPoliceColor', clRed);
    FOptions.Calendrier.FontColorSemaine := ReadInteger('Options', 'CalSemaineColor', clWhite);
    FOptions.Calendrier.Avant.NumSemaine := ReadBool('Options', 'SemaineAvant', True);
    FOptions.Calendrier.EnCours.NumSemaine := ReadBool('Options', 'SemaineEnCours', True);
    FOptions.Calendrier.Apres.NumSemaine := ReadBool('Options', 'SemaineApres', True);
    FOptions.Calendrier.Aujourdhui := ReadBool('Options', 'Aujourdhui', True);
    FOptions.Calendrier.Avant.Sens := ReadInteger('Options', 'CalOrdreAvant', 1);
    FOptions.Calendrier.Apres.Sens := ReadInteger('Options', 'CalOrdreApres', 0);
    FOptions.Legende.Effet3D := ReadBool('Options', 'Leg3D', True);
    FOptions.Calendrier.Avant.Effet3D := ReadBool('Options', 'Cal3DAvant', True);
    FOptions.Calendrier.EnCours.Effet3D := ReadBool('Options', 'Cal3DEnCours', True);
    FOptions.Calendrier.Apres.Effet3D := ReadBool('Options', 'Cal3DApres', True);

    FOptions.Calendrier.WeekEnd := [];
    for i := 1 to 7 do
      if ReadBool('Options', 'WE' + IntToStr(i), False) then Include(FOptions.Calendrier.WeekEnd, i);

    SetLength(FOptions.Calendrier.JoursFeries, ReadInteger('Feries', 'Nombre', 0));
    for i := 1 to Length(FOptions.Calendrier.JoursFeries) do with FOptions.Calendrier.JoursFeries[i - 1] do begin
      Libelle := ReadString('Feries', 'Libelle' + IntToStr(i), 'Jour ferié #' + IntToStr(i));
      UseCouleur := ValueExists('Feries', 'Couleur' + IntToStr(i));
      Couleur := ReadInteger('Feries', 'Couleur' + IntToStr(i), FOptions.Calendrier.FontColorFerie);
      DateTo := ReadDate('Feries', 'DateTo' + IntToStr(i), -1);
      Periodicite := TPeriodiciteJourFerie(ReadInteger('Feries', 'Periodicite' + IntToStr(i), 0));
      Regle := TRegleJourFerie(ReadInteger('Feries', 'Regle' + IntToStr(i), 0));
      case Regle of
        rjfDateFixe:
          begin
            JourFixe := ReadDate('Feries', 'Jour' + IntToStr(i), -1);
          end;
        rjfInterval:
          begin
            JourDebut := ReadDate('Feries', 'JourDebut' + IntToStr(i), -1);
            JourFin := ReadDate('Feries', 'JourFin' + IntToStr(i), -1);
          end;
        rjfCalcul:
          begin
            Jour := ReadInteger('Feries', 'Jour' + IntToStr(i), 0);
            if Periodicite > pjfHebdomadaire then nJour := ReadInteger('Feries', 'nJour' + IntToStr(i), 0)
                                             else nJour := 0;
            if Periodicite > pjfMensuel then Mois := ReadInteger('Feries', 'Mois' + IntToStr(i), 0)
                                        else Mois := 0;
          end;
      end;
    end;

    SetLength(FOptions.Images, ReadInteger('Fichiers', 'Nombre', 0));
    for i := 0 to Pred(Length(FOptions.Images)) do
      with FOptions.Images[i] do begin
        Chemin := ReadString('Fichiers', 'Path' + IntToStr(i + 1), '');
        Archive := ReadBool('Fichiers', 'Arc' + IntToStr(i + 1), False);
        SousRepertoire := ReadBool('Fichiers', 'SubDir' + IntToStr(i + 1), False);
        if not Archive then Chemin := IncludeTrailingPathDelimiter(Chemin);
      end;
    for i := 1 to ReadInteger('Sous-Repertoires', 'Nombre', 0) do begin // pas de boucle si la clé n'existe plus = ancienne version
      s := IncludeTrailingPathDelimiter(ReadString('Sous-Repertoires', 'Path' + IntToStr(i), ''));
      for j := 0 to Pred(Length(FOptions.Images)) do with FOptions.Images[j] do
        if Chemin = s then begin
          SousRepertoire := True;
          Break;
        end;
    end;

    SetLength(FOptions.Extensions, ReadInteger('Images', 'Nombre', 0));
    for i := 0 to Pred(Length(FOptions.Extensions)) do
      FOptions.Extensions[i] := ReadString('Images', 'Type' + IntToStr(i + 1), '');

    SetLength(FOptions.Archives, ReadInteger('Archives', 'Nombre', 0));
    for i := 0 to Pred(Length(FOptions.Archives)) do
      FOptions.Archives[i] := ReadString('Archives', 'Type' + IntToStr(i + 1), '');

    SetLength(FOptions.Exclusions, ReadInteger('Exclus', 'Nombre', 0));
    for i := 0 to Pred(Length(FOptions.Exclusions)) do
      with FOptions.Exclusions[i] do begin
        Chemin := ReadString('Exclus', 'Path' + IntToStr(i + 1), '');
        Repertoire := ReadBool('Exclus', 'Dir' + IntToStr(i + 1), False);
      end;

    SetLength(FOptions.HorairesFixe, ReadInteger('CheckTime', 'Nombre', 0));
    for i := 0 to Pred(Length(FOptions.HorairesFixe)) do
      with FOptions.HorairesFixe[i] do begin
        Heure := StrToTime(ReadString('CheckTime', 'Time' + IntToStr(i + 1), '00:00'));
        Exclusions := ReadBool('CheckTime', 'TimeEx' + IntToStr(i + 1), True);
      end;

    FOptions.ActionDoubleClick := ReadInteger('Options', 'ActionDoubleClick', 1);
    FOptions.DemarrageWindows := ReadBool('Options', 'WZ', True);
    FOptions.Interval := ReadInteger('Options', 'Interval', 60);
    FOptions.TailleHistorique := ReadInteger('Options', 'Historique', 10);
    FOptions.ChangerDemarrage := ReadBool('Options', 'Demarrage', False);
    FOptions.ActiveParDefaut := ReadBool('Options', 'Actif', True);
    FOptions.Priorite := ReadInteger('Options', 'Priorite', 3);

    FDebug.ModeDebug                   := FindCmdLineSwitch('debug');
    FDebug.GenereFichierLog            := ReadBool('Debug', 'Log', False);
    FDebug.ListeProcess                := ReadBool('Debug', 'Process', False);
    FDebug.ListeProcessDetail          := ReadBool('Debug', 'ProcessDetail', False);
    FDebug.DetailRechercheImage        := ReadBool('Debug', 'ScanPicFile', False);
    FDebug.DetailConversion            := ReadBool('Debug', 'Conversion', False);
    FDebug.DetailConversion_Image      := ReadBool('Debug', 'ConversionImage', False);
    FDebug.DetailConversion_Legende    := ReadBool('Debug', 'ConversionLegende', False);
    FDebug.DetailConversion_Calendrier := ReadBool('Debug', 'ConversionCalendrier', False);
    FDebug.ChangementHeureFixe         := ReadBool('Debug', 'ThreadCheckTime', False);
    FDebug.Effacer                     := ReadBool('Debug', 'InitLogFile', False);
  end;
end;

end.
