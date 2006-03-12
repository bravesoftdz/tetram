unit UOptions;

interface

uses
  Windows, SysUtils, Controls, Graphics, Registry, IniFiles, Forms, ActnList, UInterfacePlugin;

const
  CleProg = 'SOFTWARE\TetramCorp\WallPepper';
  OldCleProg = 'SOFTWARE\Medi@ Kit\WallPap';

type
  TRegleJourFerie = (rjfAucune, rjfDateFixe, rjfInterval, rjfCalcul);
  TPeriodiciteJourFerie = (pjfAucune, pjfHebdomadaire, pjfMensuel, pjfAnnuel);

  PJourFerie = ^RJourFerie;
  RJourFerie = record
    Libelle: string[25];
    UseCouleur: Boolean;
    Couleur: TColor;
    DateTo: TDateTime;
    Periodicite: TPeriodiciteJourFerie;
    case Regle: TRegleJourFerie of
      rjfDateFixe: (JourFixe: TDateTime);
      rjfInterval: (JourDebut, JourFin: TDateTime);
      rjfCalcul: (nJour, Jour, Mois: Word);
  end;
  TArrayJoursFeries = array of RJourFerie;

  RDebug = record
    ModeDebug: Boolean;
    FichierLog: string;
    GenereFichierLog,
      ListeProcess, ListeProcessDetail,
      DetailRechercheImage,
      DetailConversion,
      DetailConversion_Image,
      DetailConversion_Legende,
      DetailConversion_Calendrier,
      ChangementHeureFixe,
      Effacer: Boolean;
  end;

  RExclusion = record
    Chemin: ShortString;
    Repertoire: Boolean;
    Process: Boolean;
  end;

  RImage = record
    Chemin: ShortString;
    Archive, SousRepertoire: Boolean;
  end;

  RHoraireFixe = record
    Heure: TTime;
    Exclusions: Boolean;
  end;

  RDetailMois = record
    Nombre, // pas utilisé pour mois en cours
    Sens: Integer; // pas utilisé pour mois en cours
    NumSemaine,
      Effet3D, Semaine3D: Boolean;
    FontSize, SemaineFontSize,
      Trame: Integer;
    TrameColor: TColor;
    Maximum,
      Positionnement, Position, Alignement, Position_X, Position_Y: Integer;
  end;

  RCalendrier = record
    UseCalendrier: Boolean;
    Avant, EnCours, Apres: RDetailMois;

    Aujourdhui: Boolean;
    Font: string;
    PremierJourSemaine,
      FontColor, FontColorFerie, FontColorTitre, FontColorTitreAutre, FontColorWE, FontColorSemaine,
      ColorCadre: TColor;
    EnCoursGras: Boolean;
    WeekEnd: set of Byte;
    JoursFeries: TArrayJoursFeries;
  end;

  RLegende = record
    UseLegende: Boolean;
    Font: string;
    Position, Position_X, Position_Y,
      FontSize,
      Trame,
      NomFichier: Integer;
    FontColor, TrameColor: TColor;
    Effet3D: Boolean;
  end;

  PPlugin = ^RPlugin;
  RPlugin = record
    Chemin: ShortString;
    Actif: Boolean;

    DllHandle: Cardinal;
    Plugin: IPlugIn;
    MainProg: IMainProg;
  end;

  ROptions = record
    VerifMAJDelai: Integer;
    LastVerifMAJ: TDateTime;

    Calendrier: RCalendrier;
    Legende: RLegende;

    Priorite: Integer;
    AntiAliasing, ResizeDesktop: Boolean;

    ActiveParDefaut,
      ChangerDemarrage,
      DemarrageWindows: Boolean;
    Interval, TailleHistorique: Integer;
    Exclusions: array of RExclusion;
    Images: array of RImage;
    Extensions: array of string;
    Archives: array of string;
    HorairesFixe: array of RHoraireFixe;
    Plugins: array of RPlugin;
    ActionDoubleClick: Integer;
    ActionPluginDoubleClick: string;
  end;

procedure WriteIntegerOption(Section, Item: string; Valeur: Integer);
function GetIni(out Old: Boolean; ForceIniFile: Boolean = False): IOptionsWriter;
procedure LoadOptions(var FOptions: ROptions; var FDebug: RDebug; MainProg: IMainProg);
function LoadPlugin(MainProg: IMainProg; var FPlugin: RPlugin): Boolean;
procedure UnloadPlugin(var FPlugin: RPlugin);
procedure UnloadPlugins(var FPlugins: array of RPlugin);

type
  IConfigureOptionsWriter = interface
    ['{DE768B52-E9E3-4F22-88E2-3ACE34FA1F21}']
    function GetSousSection: string;
    procedure SetSousSection(Value: string);

    property SousSection: string read GetSousSection write SetSousSection;
  end;

implementation

uses UOldOptions;

type
  TMainProgContainer = class(TInterfacedObject, IMainProg)
    FMainProg: IMainProg;
    FSousSection: string;

    // interface IMainProg
    function OptionsWriter: IOptionsWriter; stdcall;
    procedure RelireOptions(PluginsInclus: Boolean); stdcall;
    procedure ChangerFond(Exclusions: Boolean); stdcall;
    procedure RafraichirFond(Exclusions: Boolean); stdcall;
    procedure ForcerFond(Archive, Image: ShortString; Exclusions: Boolean); stdcall;

    constructor Create(MainProg: IMainProg; SousSection: string);
    destructor Detroy;
  end;

  TOptionsWriter = class(TInterfacedObject, IOptionsWriter, IConfigureOptionsWriter)
  private
    FSousSection: string;

    function GetSection(Section: string): string;

    function GetSousSection: string;
    procedure SetSousSection(Value: string);
  public
    FWriter: TCustomIniFile;

    constructor Create;
    destructor Detroy;

    function SectionExists(const Section: ShortString): Boolean; stdcall;
    function ReadString(const Section, Ident, Default: ShortString): ShortString; stdcall;
    procedure WriteString(const Section, Ident, Value: ShortString); stdcall;
    function ReadInteger(const Section, Ident: ShortString; Default: Longint): Longint; stdcall;
    procedure WriteInteger(const Section, Ident: ShortString; Value: Longint); stdcall;
    function ReadBool(const Section, Ident: ShortString; Default: Boolean): Boolean; stdcall;
    procedure WriteBool(const Section, Ident: ShortString; Value: Boolean); stdcall;
    //    function ReadBinaryStream(const Section, Name: ShortString; Value: TStream): Integer; stdcall;
    function ReadDate(const Section, Name: ShortString; Default: TDateTime): TDateTime; stdcall;
    function ReadDateTime(const Section, Name: ShortString; Default: TDateTime): TDateTime; stdcall;
    function ReadFloat(const Section, Name: ShortString; Default: Double): Double; stdcall;
    function ReadTime(const Section, Name: ShortString; Default: TDateTime): TDateTime; stdcall;
    //    procedure WriteBinaryStream(const Section, Name: ShortString; Value: TStream); stdcall;
    procedure WriteDate(const Section, Name: ShortString; Value: TDateTime); stdcall;
    procedure WriteDateTime(const Section, Name: ShortString; Value: TDateTime); stdcall;
    procedure WriteFloat(const Section, Name: ShortString; Value: Double); stdcall;
    procedure WriteTime(const Section, Name: ShortString; Value: TDateTime); stdcall;
    //    procedure ReadSection(const Section: ShortString; Strings: TStrings); stdcall;
    //    procedure ReadSections(Strings: TStrings); stdcall;
    //    procedure ReadSectionValues(const Section: ShortString; Strings: TStrings); stdcall;
    procedure EraseSection(const Section: ShortString); stdcall;
    procedure DeleteKey(const Section, Ident: ShortString); stdcall;
    function ValueExists(const Section, Ident: ShortString): Boolean; stdcall;
    function FileName: ShortString; stdcall;
  end;

function GetIni(out Old: Boolean; ForceIniFile: Boolean = False): IOptionsWriter;
var
  FichierIni: string;
  OptionsWriter: TOptionsWriter;
begin
  OptionsWriter := TOptionsWriter.Create;

  FichierIni := ChangeFileExt(Application.ExeName, '.ini');
  if FileExists(FichierIni) or ForceIniFile then begin
    OptionsWriter.FWriter := TIniFile.Create(FichierIni);
    Old := not OptionsWriter.SectionExists('General');
  end
  else begin
    OptionsWriter.FWriter := TRegistryIniFile.Create(CleProg);
    Old := not OptionsWriter.SectionExists('General');
    if Old then begin
      OptionsWriter.FWriter.Free;
      OptionsWriter.FWriter := TRegistryIniFile.Create(OldCleProg);
    end;
  end;
  Result := OptionsWriter;
end;

procedure WriteIntegerOption(Section, Item: string; Valeur: Integer);
var
  IniStruct: IOptionsWriter;
  FlagOld: Boolean;
begin
  IniStruct := GetIni(FlagOld);
  try
    IniStruct.WriteInteger(Section, Item, Valeur);
  finally
    IniStruct := nil;
  end;
end;

procedure LoadOptions(var FOptions: ROptions; var FDebug: RDebug; MainProg: IMainProg);
var
  IniStruct: IOptionsWriter;
  FlagOld: Boolean;
  i, j: Integer;
  sr: TSearchRec;
  AddPlugin: Boolean;
begin
  IniStruct := GetIni(FlagOld);
  try
    if FlagOld then begin
      LoadOldOptions(IniStruct, FOptions, FDebug);
      Exit;
    end;

    with IniStruct, FOptions do begin
      AntiAliasing := ReadBool('Options', 'Aliasing', True);
      ResizeDesktop := ReadBool('Options', 'ResizeDesktop', True);
      ActionDoubleClick := ReadInteger('Options', 'ActionDoubleClick', 1);
      ActionPluginDoubleClick := ReadString('Options', 'ActionPluginDoubleClick', '');
      DemarrageWindows := ReadBool('Options', 'WZ', True);
      Interval := ReadInteger('Options', 'Interval', 60);
      TailleHistorique := ReadInteger('Options', 'Historique', 10);
      ChangerDemarrage := ReadBool('Options', 'Demarrage', False);
      ActiveParDefaut := ReadBool('Options', 'Actif', True);
      Priorite := ReadInteger('Options', 'Priorite', 3);
      VerifMAJDelai := ReadInteger('Options', 'VerifMAJDelai', 4);
      LastVerifMAJ := ReadInteger('Divers', 'LastVerifMAJ', 0);

      SetLength(Images, 0);
      i := 1;
      while ValueExists('Fichiers', 'Path' + IntToStr(i)) do begin
        SetLength(Images, i);
        with Images[i - 1] do begin
          Chemin := ReadString('Fichiers', 'Path' + IntToStr(i), '');
          Archive := ReadBool('Fichiers', 'Arc' + IntToStr(i), False);
          SousRepertoire := ReadBool('Fichiers', 'SubDir' + IntToStr(i), False);
          if not Archive then Chemin := IncludeTrailingPathDelimiter(Chemin);
        end;
        Inc(i);
      end;

      SetLength(Extensions, 0);
      i := 1;
      while ValueExists('Images', 'Type' + IntToStr(i)) do begin
        SetLength(Extensions, i);
        Extensions[i - 1] := ReadString('Images', 'Type' + IntToStr(i), '');
        Inc(i);
      end;

      SetLength(Archives, 0);
      i := 1;
      while ValueExists('Archives', 'Type' + IntToStr(i)) do begin
        SetLength(Archives, i);
        Archives[i - 1] := ReadString('Archives', 'Type' + IntToStr(i), '');
        Inc(i);
      end;

      SetLength(Exclusions, 0);
      i := 1;
      while ValueExists('Exclus', 'Path' + IntToStr(i)) do begin
        SetLength(Exclusions, i);
        with Exclusions[i - 1] do begin
          Chemin := Trim(ReadString('Exclus', 'Path' + IntToStr(i), ''));
          Repertoire := ReadBool('Exclus', 'Dir' + IntToStr(i), ReadBool('Exclus', 'Child' + IntToStr(i), False));
          Process := ReadBool('Exclus', 'Process' + IntToStr(i), True);
        end;
        Inc(i);
      end;

      SetLength(HorairesFixe, 0);
      i := 1;
      while ValueExists('CheckTime', 'Time' + IntToStr(i)) do begin
        SetLength(HorairesFixe, i);
        with HorairesFixe[i - 1] do begin
          Heure := StrToTime(ReadString('CheckTime', 'Time' + IntToStr(i), '00:00'));
          Exclusions := ReadBool('CheckTime', 'TimeEx' + IntToStr(i), True);
        end;
        Inc(i);
      end;

      with Calendrier do begin
        UseCalendrier := SectionExists('Calendrier');

        Aujourdhui := ReadBool('Calendrier', 'Aujourdhui', True);
        Font := ReadString('Calendrier', 'Font', 'Arial');
        PremierJourSemaine := ReadInteger('Calendrier', 'PremierJourSemaine', 1);
        FontColor := ReadInteger('Calendrier', 'FontColor', clWhite);
        FontColorFerie := ReadInteger('Calendrier', 'FontColorFerie', clRed);
        FontColorTitre := ReadInteger('Calendrier', 'FontColorTitre', clWhite);
        FontColorTitreAutre := ReadInteger('Calendrier', 'FontColorTitreAutre', clWhite);
        FontColorWE := ReadInteger('Calendrier', 'FontColorWE', clRed);
        FontColorSemaine := ReadInteger('Calendrier', 'FontColorSemaine', clWhite);
        ColorCadre := ReadInteger('Calendrier', 'ColorCadre', FontColorSemaine);
        EnCoursGras := ReadBool('Calendrier\MoisEnCours', 'Gras', True);

        WeekEnd := [];
        for i := 1 to 7 do
          if ReadBool('Calendrier', 'WeekEnd' + IntToStr(i), False) then Include(WeekEnd, i);

        SetLength(JoursFeries, 0);
        i := 1;
        while ValueExists('Calendrier\JoursFeries', 'Regle' + IntToStr(i)) do begin
          SetLength(JoursFeries, i);
          with JoursFeries[i - 1] do begin
            Libelle := ReadString('Calendrier\JoursFeries', 'Libelle' + IntToStr(i), 'Jour ferié #' + IntToStr(i));
            UseCouleur := ValueExists('Calendrier\JoursFeries', 'Couleur' + IntToStr(i));
            Couleur := ReadInteger('Calendrier\JoursFeries', 'Couleur' + IntToStr(i), FOptions.Calendrier.FontColorFerie);
            DateTo := ReadDate('Calendrier\JoursFeries', 'DateTo' + IntToStr(i), -1);
            Periodicite := TPeriodiciteJourFerie(ReadInteger('Calendrier\JoursFeries', 'Periodicite' + IntToStr(i), 0));
            Regle := TRegleJourFerie(ReadInteger('Calendrier\JoursFeries', 'Regle' + IntToStr(i), 0));
            case Regle of
              rjfDateFixe: begin
                  JourFixe := ReadDate('Calendrier\JoursFeries', 'Jour' + IntToStr(i), -1);
                end;
              rjfInterval: begin
                  JourDebut := ReadDate('Calendrier\JoursFeries', 'JourDebut' + IntToStr(i), -1);
                  JourFin := ReadDate('Calendrier\JoursFeries', 'JourFin' + IntToStr(i), -1);
                end;
              rjfCalcul: begin
                  Jour := ReadInteger('Calendrier\JoursFeries', 'Jour' + IntToStr(i), 0);
                  if Periodicite > pjfHebdomadaire then
                    nJour := ReadInteger('Calendrier\JoursFeries', 'nJour' + IntToStr(i), 0)
                  else
                    nJour := 0;
                  if Periodicite > pjfMensuel then
                    Mois := ReadInteger('Calendrier\JoursFeries', 'Mois' + IntToStr(i), 0)
                  else
                    Mois := 0;
                end;
            end;
          end;
          Inc(i);
        end;

        //        EnCours.Nombre          := ReadInteger('Calendrier\MoisEnCours', 'Nombre', 0);           // pas utilisé pour mois en cours
        EnCours.NumSemaine := ReadBool('Calendrier\MoisEnCours', 'NumSemaine', True);
        //        EnCours.Ordre           := ReadInteger('Calendrier\MoisEnCours', 'Ordre', True);            // pas utilisé pour mois en cours
        EnCours.Effet3D := ReadBool('Calendrier\MoisEnCours', 'Effet3D', True);
        EnCours.FontSize := ReadInteger('Calendrier\MoisEnCours', 'FontSize', 0);
        EnCours.Semaine3D := ReadBool('Calendrier\MoisEnCours', 'Semaine3D', EnCours.Effet3D);
        EnCours.SemaineFontSize := ReadInteger('Calendrier\MoisEnCours', 'SemaineFontSize', EnCours.FontSize);
        EnCours.Trame := ReadInteger('Calendrier\MoisEnCours', 'Trame', 0);
        EnCours.TrameColor := ReadInteger('Calendrier\MoisEnCours', 'TrameColor', clWhite);
        EnCours.Positionnement := ReadInteger('Calendrier\MoisEnCours', 'Positionnement', ReadInteger('Calendrier', 'Positionnement', 0));
        EnCours.Position := ReadInteger('Calendrier\MoisEnCours', 'Position', ReadInteger('Calendrier', 'Position', 2));
        EnCours.Position_X := ReadInteger('Calendrier\MoisEnCours', 'Position_X', ReadInteger('Calendrier', 'Position_X', 0));
        EnCours.Position_Y := ReadInteger('Calendrier\MoisEnCours', 'Position_Y', ReadInteger('Calendrier', 'Position_Y', 0));

        Avant.Nombre := ReadInteger('Calendrier\MoisAvant', 'Nombre', 0);
        Avant.NumSemaine := ReadBool('Calendrier\MoisAvant', 'NumSemaine', True);
        Avant.Sens := ReadInteger('Calendrier\MoisAvant', 'Ordre', 1);
        Avant.Effet3D := ReadBool('Calendrier\MoisAvant', 'Effet3D', True);
        Avant.FontSize := ReadInteger('Calendrier\MoisAvant', 'FontSize', EnCours.FontSize - 6);
        Avant.Semaine3D := ReadBool('Calendrier\MoisAvant', 'Semaine3D', Avant.Effet3D);
        Avant.SemaineFontSize := ReadInteger('Calendrier\MoisAvant', 'SemaineFontSize', Avant.FontSize);
        Avant.Trame := ReadInteger('Calendrier\MoisAvant', 'Trame', EnCours.Trame);
        Avant.TrameColor := ReadInteger('Calendrier\MoisAvant', 'TrameColor', EnCours.TrameColor);
        Avant.Maximum := ReadInteger('Calendrier\MoisAvant', 'Maximum', Avant.Nombre);
        if Avant.Maximum = 0 then Avant.Maximum := Apres.Nombre; // il arrive que le fichier ai la valeur 0 de stockée suite à une conversion d'ancienne version
        Avant.Positionnement := ReadInteger('Calendrier\MoisAvant', 'Positionnement', 0);
        Avant.Position := ReadInteger('Calendrier\MoisAvant', 'Position', 0);
        Avant.Alignement := ReadInteger('Calendrier\MoisAvant', 'Alignement', 0);
        Avant.Position_X := ReadInteger('Calendrier\MoisAvant', 'Position_X', 0);
        Avant.Position_Y := ReadInteger('Calendrier\MoisAvant', 'Position_Y', 0);

        Apres.Nombre := ReadInteger('Calendrier\MoisApres', 'Nombre', 0);
        Apres.NumSemaine := ReadBool('Calendrier\MoisApres', 'NumSemaine', True);
        Apres.Sens := ReadInteger('Calendrier\MoisApres', 'Ordre', 0);
        Apres.Effet3D := ReadBool('Calendrier\MoisApres', 'Effet3D', True);
        Apres.FontSize := ReadInteger('Calendrier\MoisApres', 'FontSize', EnCours.FontSize - 6);
        Apres.Semaine3D := ReadBool('Calendrier\MoisApres', 'Semaine3D', Apres.Effet3D);
        Apres.SemaineFontSize := ReadInteger('Calendrier\MoisApres', 'SemaineFontSize', Apres.FontSize);
        Apres.Trame := ReadInteger('Calendrier\MoisApres', 'Trame', EnCours.Trame);
        Apres.TrameColor := ReadInteger('Calendrier\MoisApres', 'TrameColor', EnCours.TrameColor);
        Apres.Maximum := ReadInteger('Calendrier\MoisApres', 'Maximum', Apres.Nombre);
        if Apres.Maximum = 0 then Apres.Maximum := Apres.Nombre; // il arrive que le fichier ai la valeur 0 de stockée suite à une conversion d'ancienne version
        Apres.Positionnement := ReadInteger('Calendrier\MoisApres', 'Positionnement', 0);
        Apres.Position := ReadInteger('Calendrier\MoisApres', 'Position', 1);
        Apres.Alignement := ReadInteger('Calendrier\MoisApres', 'Alignement', 0);
        Apres.Position_X := ReadInteger('Calendrier\MoisApres', 'Position_X', 0);
        Apres.Position_Y := ReadInteger('Calendrier\MoisApres', 'Position_Y', 0);
      end;

      with Legende do begin
        UseLegende := SectionExists('Legende');
        NomFichier := ReadInteger('Legende', 'NomFichier', 0);
        Font := ReadString('Legende', 'Font', 'Arial');
        FontSize := ReadInteger('Legende', 'FontSize', 0);
        FontColor := ReadInteger('Legende', 'FontColor', clWhite);
        Position := ReadInteger('Legende', 'Position', 21);
        Position_X := ReadInteger('Legende', 'Position_X', 0);
        Position_Y := ReadInteger('Legende', 'Position_Y', 0);
        Trame := ReadInteger('Legende', 'Trame', 0);
        TrameColor := ReadInteger('Legende', 'TrameColor', clWhite);
        Effet3D := ReadBool('Legende', 'Effet3D', True);
      end;

      UnloadPlugins(Plugins);
      SetLength(Plugins, 0);
      i := 1;
      while ValueExists('Plugins', 'Path' + IntToStr(i)) do begin
        SetLength(Plugins, Succ(Length(Plugins)));
        Plugins[Pred(Length(Plugins))].Chemin := ReadString('Plugins', 'Path' + IntToStr(i), '');
        if not LoadPlugin(MainProg, Plugins[Pred(Length(Plugins))]) then
          SetLength(Plugins, Pred(Length(Plugins)));
        Inc(i);
      end;

      i := FindFirst(ExtractFilePath(Application.ExeName) + 'Plugins\*.dll', faAnyFile and not faDirectory, sr);
      try
        while i = 0 do begin
          AddPlugin := True;
          for j := 0 to Pred(Length(Plugins)) do
            AddPlugin := AddPlugin and (sr.Name <> Plugins[j].Chemin);
          if AddPlugin then begin
            SetLength(Plugins, Succ(Length(Plugins)));
            Plugins[Pred(Length(Plugins))].Chemin := sr.Name;
            if not LoadPlugin(MainProg, Plugins[Pred(Length(Plugins))]) then
              SetLength(Plugins, Pred(Length(Plugins)));
          end;
          i := FindNext(sr);
        end;
      finally
        FindClose(sr);
      end;

      FDebug.ModeDebug := FindCmdLineSwitch('debug');
      FDebug.GenereFichierLog := ReadBool('Debug', 'Log', False);
      FDebug.ListeProcess := ReadBool('Debug', 'Process', False);
      FDebug.ListeProcessDetail := ReadBool('Debug', 'ProcessDetail', False);
      FDebug.DetailRechercheImage := ReadBool('Debug', 'ScanPicFile', False);
      FDebug.DetailConversion := ReadBool('Debug', 'Conversion', False);
      FDebug.DetailConversion_Image := ReadBool('Debug', 'ConversionImage', False);
      FDebug.DetailConversion_Legende := ReadBool('Debug', 'ConversionLegende', False);
      FDebug.DetailConversion_Calendrier := ReadBool('Debug', 'ConversionCalendrier', False);
      FDebug.ChangementHeureFixe := ReadBool('Debug', 'ThreadCheckTime', False);
      FDebug.Effacer := ReadBool('Debug', 'InitLogFile', False);
    end;
  finally
    IniStruct := nil;
  end;
end;

function LoadPlugin(MainProg: IMainProg; var FPlugin: RPlugin): Boolean;
type
  TGetPlugin = function: IPlugin; stdcall;
  TGetPlugin2 = function(MainProg: IMainProg): IPlugin; stdcall;
var
  GetPlugin: TGetPlugin;
  GetPlugin2: TGetPlugin2;
  s: string;
begin
  Result := False;
  FPlugin.Actif := (FPlugin.Chemin <> '') and (FPlugin.Chemin[1] <> '@');
  if not FPlugin.Actif then
    FPlugin.Chemin := Copy(FPlugin.Chemin, 2, Length(FPlugin.Chemin));

  s := ExtractFilePath(Application.ExeName) + 'Plugins\' + FPlugin.Chemin;
  FPlugin.DllHandle := LoadLibrary(PChar(s));
  FPlugin.Plugin := nil;
  if FPlugin.DllHandle > 32 then begin
    GetPlugin2 := GetProcAddress(FPlugin.DllHandle, 'GetPlugin2');
    GetPlugin := GetProcAddress(FPlugin.DllHandle, 'GetPlugin');
    FPlugin.MainProg := TMainProgContainer.Create(MainProg, 'ConfigPlugins\' + ExtractFileName(FPlugin.Chemin));
    if Assigned(GetPlugin2) then
      FPlugin.PlugIn := GetPlugin2(FPlugin.MainProg)
    else if Assigned(GetPlugin) then
      FPlugin.PlugIn := GetPlugin;

    Result := Assigned(FPlugin.Plugin);
    if not Result then begin
      FreeLibrary(FPlugin.DllHandle);
      FPlugin.DllHandle := INVALID_HANDLE_VALUE;
      FPlugin.MainProg := nil;
    end;
  end;
end;

procedure UnloadPlugin(var FPlugin: RPlugin);
begin
  with FPlugin do
  {if Actif then }begin
    Plugin := nil;
    MainProg := nil;
    FreeLibrary(DllHandle);
    DllHandle := INVALID_HANDLE_VALUE;
  end;
end;

procedure UnloadPlugins(var FPlugins: array of RPlugin);
var
  i: Integer;
begin
  for i := 0 to Pred(Length(FPlugins)) do
    UnloadPlugin(FPlugins[i]);
end;

{ TOptionsWriter }

constructor TOptionsWriter.Create;
begin
  FSousSection := '';
end;

procedure TOptionsWriter.DeleteKey(const Section, Ident: ShortString);
begin
  FWriter.DeleteKey(GetSection(Section), Ident);
end;

destructor TOptionsWriter.Detroy;
begin
  if Assigned(FWriter) then FreeAndNil(FWriter);
end;

procedure TOptionsWriter.EraseSection(const Section: ShortString);
begin
  FWriter.EraseSection(GetSection(Section));
end;

function TOptionsWriter.FileName: ShortString;
begin
  Result := FWriter.FileName;
end;

function TOptionsWriter.GetSection(Section: string): string;
begin
  if FSousSection <> '' then
    Result := FSousSection + '\' + Section
  else
    Result := Section;
end;

function TOptionsWriter.GetSousSection: string;
begin
  Result := FSousSection;
end;

function TOptionsWriter.ReadBool(const Section, Ident: ShortString; Default: Boolean): Boolean;
begin
  Result := FWriter.ReadBool(GetSection(Section), Ident, Default);
end;

function TOptionsWriter.ReadDate(const Section, Name: ShortString; Default: TDateTime): TDateTime;
begin
  Result := FWriter.ReadDate(GetSection(Section), Name, Default);
end;

function TOptionsWriter.ReadDateTime(const Section, Name: ShortString; Default: TDateTime): TDateTime;
begin
  Result := FWriter.ReadDateTime(GetSection(Section), Name, Default);
end;

function TOptionsWriter.ReadFloat(const Section, Name: ShortString; Default: Double): Double;
begin
  Result := FWriter.ReadFloat(GetSection(Section), Name, Default);
end;

function TOptionsWriter.ReadInteger(const Section, Ident: ShortString; Default: Integer): Longint;
begin
  Result := FWriter.ReadInteger(GetSection(Section), Ident, Default);
end;

function TOptionsWriter.ReadString(const Section, Ident, Default: ShortString): ShortString;
begin
  Result := FWriter.ReadString(GetSection(Section), Ident, Default);
end;

function TOptionsWriter.ReadTime(const Section, Name: ShortString; Default: TDateTime): TDateTime;
begin
  Result := FWriter.ReadTime(GetSection(Section), Name, Default);
end;

function TOptionsWriter.SectionExists(const Section: ShortString): Boolean;
begin
  Result := FWriter.SectionExists(GetSection(Section));
end;

procedure TOptionsWriter.SetSousSection(Value: string);
begin
  FSousSection := Value;
end;

function TOptionsWriter.ValueExists(const Section, Ident: ShortString): Boolean;
begin
  Result := FWriter.ValueExists(GetSection(Section), Ident);
end;

procedure TOptionsWriter.WriteBool(const Section, Ident: ShortString; Value: Boolean);
begin
  FWriter.WriteBool(GetSection(Section), Ident, Value);
end;

procedure TOptionsWriter.WriteDate(const Section, Name: ShortString; Value: TDateTime);
begin
  FWriter.WriteDate(GetSection(Section), Name, Value);
end;

procedure TOptionsWriter.WriteDateTime(const Section, Name: ShortString; Value: TDateTime);
begin
  FWriter.WriteDateTime(GetSection(Section), Name, Value);
end;

procedure TOptionsWriter.WriteFloat(const Section, Name: ShortString; Value: Double);
begin
  FWriter.WriteFloat(GetSection(Section), Name, Value);
end;

procedure TOptionsWriter.WriteInteger(const Section, Ident: ShortString; Value: Integer);
begin
  FWriter.WriteInteger(GetSection(Section), Ident, Value);
end;

procedure TOptionsWriter.WriteString(const Section, Ident, Value: ShortString);
begin
  FWriter.WriteString(GetSection(Section), Ident, Value);
end;

procedure TOptionsWriter.WriteTime(const Section, Name: ShortString; Value: TDateTime);
begin
  FWriter.WriteTime(GetSection(Section), Name, Value);
end;

{ TMainProgContainer }

procedure TMainProgContainer.ChangerFond(Exclusions: Boolean);
begin
  FMainProg.ChangerFond(Exclusions);
end;

constructor TMainProgContainer.Create(MainProg: IMainProg; SousSection: string);
begin
  FMainProg := MainProg;
  FSousSection := SousSection;
end;

destructor TMainProgContainer.Detroy;
begin
  FMainProg := nil;
end;

procedure TMainProgContainer.ForcerFond(Archive, Image: ShortString; Exclusions: Boolean);
begin
  FMainProg.ForcerFond(Archive, Image, Exclusions);
end;

function TMainProgContainer.OptionsWriter: IOptionsWriter;
begin
  Result := FMainProg.OptionsWriter;
  (Result as IConfigureOptionsWriter).SousSection := FSousSection;
end;

procedure TMainProgContainer.RafraichirFond(Exclusions: Boolean);
begin
  FMainProg.RafraichirFond(Exclusions);
end;

procedure TMainProgContainer.RelireOptions(PluginsInclus: Boolean);
begin
  FMainProg.RelireOptions(PluginsInclus);
end;

end.


