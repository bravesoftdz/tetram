unit UCommon;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, GraphUtil, GraphicEx, Math, ShlObj, ComObj, UJoursFeries, UOptions, Forms,
  IniFiles, UInterfaceChange, ExtCtrls, ActiveX, UInterfacePlugIn;

function ChangeWallPap(Image, LogFile: PChar; Declenchement: TChangeType; MainProg: IMainProg): Boolean; stdcall;
function VideoInverse(Couleur: TColor): TColor;

type
  TFileOfByte = file of Byte;

implementation

uses DateUtils, UInterfaceJoursFeries, Types, UInterfaceDessinCalendrier;

const
  Interval = 10;

type
  PMoisAffiche = ^RMoisAffiche;
  RMoisAffiche = record
    Effet3D, Semaine3D, NumSemaine: Boolean;
    Trame, PoliceSize, SemainePoliceSize: Integer;
    CouleurTitre, CouleurTrame: TColor;
    X, Y: Integer;
    W, H: Integer;
  end;

  PArrayMoisAffiche = ^TArrayMoisAffiche;
  TArrayMoisAffiche = array of RMoisAffiche;

  TChangeWall = class;
  TDessineur = class(TInterfacedObject, IDessineur)
    FChangeWall: TChangeWall;

    // interface IDessineur
    function IsFerie(Date: TDateTime): Boolean; stdcall;
    function IsWeekEnd(Date: TDateTime): Boolean; stdcall;

    constructor Create(ChangeWall: TChangeWall);
  end;

  TChangeWall = class(TObject, IDessineur)
  private
    FMainProg: IMainProg;
    FDessineur: IDessineur;

    FActiveDesktopEx: IActiveDesktop;
    FDesktopWidth, FDesktopHeight: Integer;

    FAfficheJour: array[1..7] of Byte;
    FPathWin: string;

    FDateCalendrier: TDateTime;

    FJoursFeries: TListJoursFeries;

    FTransparence: TColor;

    function PluginCouleurTransparence(Couleur: TColor): Boolean;
    function PlugInIsFerie(Date: TDateTime): Boolean;
    procedure PlugInDessinMois(Mois, Annee: Word; Bitmap: TBitmap; var Largeur, Hauteur: Integer);
    procedure PlugInDessinTitreMois(Mois, Annee: Word; Bitmap: TBitmap; var Largeur, Hauteur: Integer);

    function PrepareImage(var Image: String): Boolean;
    procedure ApplyBack(Fichier: String);
    procedure CalcTransparence;

    procedure WriteLog(Chaine: string);
    procedure DessineMois(ChaineLog: string; BMP: TBitmap; MoisAffiche: PMoisAffiche; PosX, PosY: Integer; Mois, Annee: Word; var LargeurCal, HauteurCal: Integer; AujourdHui: Integer = -1);
    procedure DessineCalendrier(BMP: TBitmap);
    procedure DessineLegende(BMP: TBitmap; FichierImage: string);
    procedure EcritText(Canvas: TCanvas; const Chaine: string; X, Y: Integer; Font: TFont; Effet3D: Boolean; var Larg, Haut: Integer);
    procedure MergeCanvas(dstCanvas: TCanvas; srcImage: TBitmap; dstX, dstY: Integer); overload;
    procedure MergeCanvas(dstCanvas: TCanvas; Image: TBitmap; var PosX, PosY: Integer; UseArray: TArrayMoisAffiche; Position, Alignement: Integer; MoisArround: RMoisAffiche); overload;
    procedure MergeCanvas(dstCanvas: TCanvas; Image: TBitmap; UseArray: TArrayMoisAffiche; Position, Position_X, Position_Y: Integer); overload;
    procedure CalculePosition(Image: TBitmap; var PosX, PosY: Integer; UseArray: TArrayMoisAffiche; Position, Alignement: Integer; MoisArround: RMoisAffiche; var Bottom, Right: Integer);
    procedure ProcessMerge(dstCanvas: TCanvas; Image: TBitmap; PosX, PosY: Integer; UseArray: TArrayMoisAffiche);
    procedure DoMerge(dstCanvas: TCanvas; Image: TBitmap; var PosX, PosY: Integer; UseArray: TArrayMoisAffiche; Mois: RDetailMois; MoisArround: RMoisAffiche);
    procedure DessinePlusieursMois(const ChaineLog: string; UseArray: PArrayMoisAffiche; var Bitmap: TBitmap; var PosX, PosY: Integer; DetailMois: RDetailMois; DecalageMin, DecalageMax: Integer); procedure InitBitmap(var tmpBMP: TBitmap);
  public
    FDebug: RDebug;
    FOptions: ROptions;
    procedure ShowImage(Image: TBitmap);
    constructor Create(MainProg: IMainProg);
    destructor Destroy; override;

    property Dessineur: IDessineur read FDessineur implements IDessineur;
  end;

  TThreadChange = class(TThread)
    Image: string;
    LogFile: string;
    Declenchement: TChangeType;
    FMainProg: IMainProg;
    procedure Execute; override;
  end;

procedure TThreadChange.Execute;
var
  sImage: string;
  NeedToUninitialize: Boolean;
begin
  NeedToUninitialize := Succeeded(CoInitialize(nil));
  try
    with TChangeWall.Create(FMainProg) do try
      Priority := TThreadPriority(FOptions.Priorite);

      FMainProg := Self.FMainProg;
      FDebug.GenereFichierLog := (LogFile <> '') and FDebug.GenereFichierLog;
      FDebug.FichierLog := LogFile;
      sImage := Image;
      ReturnValue := 0;
      if FileExists(sImage) and PrepareImage(sImage) then ReturnValue := 1;
      if ReturnValue = 1 then ApplyBack(sImage);
    finally
      Free;
    end;
  finally
    if NeedToUninitialize then CoUninitialize;
  end;
end;

function ChangeWallPap(Image, LogFile: PChar; Declenchement: TChangeType; MainProg: IMainProg): Boolean;
var
//  sImage: string;
  Thread: TThreadChange;
begin
  Thread := TThreadChange.Create(True);
  try
    Thread.FMainProg := MainProg;
    Thread.Image := Image;
    if Assigned(LogFile) then Thread.LogFile := LogFile;
    Thread.Declenchement := Declenchement;

    Thread.Resume;
    Thread.WaitFor;
    Result := Bool(Thread.ReturnValue);
  finally
    Thread.Free;
  end;

//  with TChangeWall.Create do try
//    FDebug.GenereFichierLog := Assigned(LogFile) and FDebug.GenereFichierLog;
//    FDebug.FichierLog := StrPas(LogFile);
//    sImage := StrPas(Image);
//    Result := False;
//    if FileExists(sImage) then Result := PrepareImage(sImage);
//    if Result then ApplyBack(sImage);
//  finally
//    Free;
//  end;
end;

function NewMoisAffiche(UseArray: PArrayMoisAffiche): PMoisAffiche;
begin
  SetLength(UseArray^, Succ(Length(UseArray^)));
  Result := @UseArray^[Pred(Length(UseArray^))];
end;

function VideoInverse(Couleur: TColor): TColor;
begin
  Result := RGB(255 - GetRValue(Couleur), 255 - GetGValue(Couleur), 255 - GetBValue(Couleur));
end;

procedure ChangeLight(Value: Integer; Canvas: TCanvas; R: TRect; Seuil: TColor = clWhite);
var
  i, j: Integer;
  c: TColor;
  rc, gc, bc,
  rp, gp, bp: Integer;
begin
  if Value < 0 then begin
    Seuil := VideoInverse(Seuil);
    Value := -Value;
  end;
  rc := GetRValue(Seuil);
  gc := GetGValue(Seuil);
  bc := GetBValue(Seuil);
  if Value <> 0 then
    for i := R.Left to R.Right - 1 do begin
      for j := R.Top to R.Bottom - 1 do begin
        c := Canvas.Pixels[i, j];

        rp := GetRValue(c);
        rp := rp + ((rc - rp) * Value div 100);
        gp := GetGValue(c);
        gp := gp + ((gc - gp) * Value div 100);
        bp := GetBValue(c);
        bp := bp + ((bc - bp) * Value div 100);

        c := RGB(Max(0, Min(255, rp)),
                 Max(0, Min(255, gp)),
                 Max(0, Min(255, bp)));
        Canvas.Pixels[i, j] := c;
      end;
    end;
end;

{ TChangeWall }

procedure TChangeWall.ApplyBack(Fichier: String);
var
  PImage: PWideChar;
  WallPapOptions: TWallPaperOpt;
begin
  WriteLog('Collage du papier-peint');
  (FMainProg as IEvenements).AvantApplicationNouveauFond;
  try
    if not FileExists(Fichier) then Exit;
    PImage := StringToOleStr(Fichier);
    FActiveDesktopEx.SetWallpaper(PImage, 0);
    WallPapOptions.dwSize := SizeOf(WallPapOptions);
    WallPapOptions.dwStyle := WPSTYLE_CENTER;
    FActiveDesktopEx.SetWallpaperOptions(WallPapOptions, 0);
    FActiveDesktopEx.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
    WriteLog('Collage du papier-peint - Ok');
  finally
    (FMainProg as IEvenements).ApresApplicationNouveauFond;
  end;
end;

procedure TChangeWall.CalcTransparence;
var
  couleurs: array of TColor;

  function ValeurIsInTab(Valeur: Word): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Pred(Length(couleurs)) do begin
      Result := couleurs[i] = Valeur;
      if Result then Exit;
    end;
  end;

  procedure Composante(Valeur: TColor);
  begin
    if not ValeurIsInTab(Valeur) then begin
      SetLength(couleurs, Succ(Length(couleurs)));
      couleurs[Pred(Length(couleurs))] := Valeur;
    end;
  end;

  procedure TraiteCouleur(Couleur: TColor);
  begin
    Composante(Couleur);
    Composante(VideoInverse(Couleur));
  end;

  function TrouveComposante: Word;
  begin
    Result := 0;
    while (ValeurIsInTab(Result) or not PluginCouleurTransparence(Result)) and (Result < 255) do
      Inc(Result);
  end;

var
  i: Integer;
begin
  SetLength(couleurs, 0);

  TraiteCouleur(FOptions.Legende.FontColor);
  TraiteCouleur(FOptions.Calendrier.FontColor);
  TraiteCouleur(FOptions.Calendrier.FontColorFerie);
  TraiteCouleur(FOptions.Calendrier.FontColorTitre);
  TraiteCouleur(FOptions.Calendrier.FontColorTitreAutre);
  TraiteCouleur(FOptions.Calendrier.FontColorWE);
  TraiteCouleur(FOptions.Calendrier.FontColorSemaine);
  for i := 0 to Pred(Length(FJoursFeries.JoursFeries)) do
    TraiteCouleur(FJoursFeries.JoursFeries[i].Couleur);

  FTransparence := TrouveComposante;
end;

constructor TChangeWall.Create(MainProg: IMainProg);
var
  dummy: array[0..MAX_PATH] of Char;
begin
  FMainProg := MainProg;
  FDessineur := TDessineur.Create(Self);
  FActiveDesktopEx := CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;

  ZeroMemory(@dummy[0], SizeOf(dummy));
  SHGetSpecialFolderPath(0, @dummy[0], CSIDL_APPDATA, True);
//  GetWindowsDirectory(dummy, SizeOf(dummy));
  FPathWin := IncludeTrailingPathDelimiter(StrPas(dummy));

  FJoursFeries := TListJoursFeries.Create;

  LoadOptions(FOptions, FDebug, FMainProg);

  FDateCalendrier := Now;
  FJoursFeries.BeginUpdate;
  FJoursFeries.SetJoursFeries(FOptions.Calendrier.JoursFeries, Length(FOptions.Calendrier.JoursFeries));
  FJoursFeries.DateDebut := IncMonth(StartOfTheMonth(FDateCalendrier), -FOptions.Calendrier.Avant.Nombre);
  FJoursFeries.DateFin := IncMonth(EndOfTheMonth(FDateCalendrier), FOptions.Calendrier.Apres.Nombre);
  FJoursFeries.EndUpdate;
end;

destructor TChangeWall.Destroy;
begin
  FreeAndNil(FJoursFeries);
  UnloadPlugins(FOptions.Plugins);
  inherited;
end;

procedure TChangeWall.DessineLegende(BMP: TBitmap; FichierImage: string);
var
  Legende: TStringList;
  FichierLegende: string;
  ini: TIniFile;
  imgLegende: TBitmap;
  i, PosX, PosY,
  HeightLeg, WidthLeg: Integer;
  e: Extended;
  s: string;
begin
  if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende');

  Legende := TStringList.Create;
  imgLegende := TBitmap.Create;
  try
    FichierLegende := ChangeFileExt(FichierImage, '.leg');
    if FileExists(FichierLegende) then begin
      if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende - Fichier "' + FichierLegende + '"');
      Legende.LoadFromFile(FichierLegende);
    end else begin
      FichierLegende := ExtractFilePath(FichierImage) + 'Legendes.txt';
      if FileExists(FichierLegende) then begin
        if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende - Fichier "' + FichierLegende + '"');
        ini := TIniFile.Create(FichierLegende);
        try
          i := 1;
          while ini.ValueExists(ExtractFileName(FichierImage), 'Ligne' + IntToStr(i)) do begin
            Legende.Add(ini.ReadString(ExtractFileName(FichierImage), 'Ligne' + IntToStr(i), ''));
            Inc(i);
          end;
        finally
          ini.Free;
        end;
      end else begin
        if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende - Pas de fichier légende');
      end;
    end;
    case FOptions.Legende.NomFichier of
      0: ; // on ajoute rien
      1: Legende.Insert(0, ExtractFileName(FichierImage));
      2: Legende.Insert(0, FichierImage);
    end;

    if Legende.Count > 0 then with imgLegende do begin
      Width := BMP.Width;
      Height := BMP.Height;
      Transparent := False; // sera passé transparent à la fin
      TransparentColor := FTransparence;
      TransparentMode := tmFixed;

      Canvas.Brush.Color := FTransparence;
      Canvas.FillRect(Rect(0, 0, Width, Height));

      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

      Canvas.Font.Name := FOptions.Legende.Font;
      Canvas.Font.Size := 16 + FOptions.Legende.FontSize;
      Canvas.Font.Height := Canvas.Font.Height + Canvas.Font.Size div 4;

      HeightLeg := 0;
      WidthLeg := 0;
      for i := 0 to Pred(Legende.Count) do begin
        s := Legende[i];
        if FOptions.Legende.Effet3D then begin
          Canvas.Font.Color := VideoInverse(FOptions.Legende.FontColor);
          Canvas.TextOut(1, HeightLeg + 1, s);
        end;

        Canvas.Font.Color := FOptions.Legende.FontColor;
        Canvas.TextOut(0, HeightLeg, s);

        WidthLeg := Max(WidthLeg, Canvas.TextWidth(s));
        Inc(HeightLeg, Canvas.TextHeight(s));
      end;

      Width := WidthLeg;
      Height := HeightLeg;

      PosX := 0;
      PosY := 0;
      Transparent := True;
      if FOptions.Legende.Position = 99 then begin
        PosX := Trunc(FDesktopWidth * FOptions.Legende.Position_X / 100) - (Width div 2);
        PosY := Trunc(FDesktopHeight * FOptions.Legende.Position_Y / 100) - (Height div 2);
      end else begin
        e := Frac(FOptions.Legende.Position / 10) * 10;
        case Round(e) of            // Trunc renvoi 0 avec PositionCal = 21 !!!!
          0: PosX := 0;
          1: PosX := (FDesktopWidth - Width) div 2;
          2: PosX := FDesktopWidth - Width;
        end;
        case FOptions.Legende.Position div 10 of
          0: PosY := 0;
          1: PosY := (FDesktopHeight - Height) div 2;
          2: PosY := FDesktopHeight - Height;
        end;
      end;
      if FOptions.ResizeDesktop then begin
        Inc(PosX, Screen.WorkAreaLeft);
        Inc(PosY, Screen.WorkAreaTop);
      end;

      if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende - Trame de fond');
      ChangeLight(FOptions.Legende.Trame, BMP.Canvas, Rect(PosX, PosY, PosX + WidthLeg, PosY + HeightLeg), FOptions.Legende.TrameColor);

      BMP.Canvas.Draw(PosX, PosY, imgLegende);
    end else begin
      if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende - Légende vide');
    end;
  finally
    imgLegende.Free;
    Legende.Free;
  end;

  if FDebug.DetailConversion and FDebug.DetailConversion_Legende then WriteLog('Legende - OK');
end;

procedure TChangeWall.ShowImage(Image: TBitmap);
var
  f: TForm;
  i: TImage;
begin
  f := TForm.Create(nil);
  with f do try
    i := TImage.Create(f);
    i.Parent := f;
    i.Align := alClient;
    i.Picture.Assign(Image);
    i.Transparent := False;
    i.Visible := True;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TChangeWall.MergeCanvas(dstCanvas: TCanvas; srcImage: TBitmap; dstX, dstY: Integer);
begin
  dstCanvas.Draw(dstX, dstY, srcImage);
end;

procedure TChangeWall.EcritText(Canvas: TCanvas; const Chaine: string; X, Y: Integer; Font: TFont; Effet3D: Boolean; var Larg, Haut: Integer);
var
  tmpBMP: TBitmap;
  P: TSize;
begin
  tmpBMP := TBitmap.Create;
  try
    tmpBMP.Width := Screen.Width;
    tmpBMP.Height := Screen.Height;

    tmpBMP.Transparent := False; // sera passé transparent à la fin
    tmpBMP.TransparentColor := FTransparence;
    tmpBMP.TransparentMode := tmFixed;
    tmpBMP.Canvas.Brush.Color := FTransparence;

    tmpBMP.Canvas.Font.Assign(Font);

    P := tmpBMP.Canvas.TextExtent(Chaine);

    tmpBMP.Canvas.FillRect(Rect(0, 0, P.cx + 1, P.cy + 1));
    tmpBMP.Canvas.Brush.Style := bsClear;

    if Effet3D then begin
      tmpBMP.Canvas.Font.Color := VideoInverse(Font.Color);
      tmpBMP.Canvas.TextOut(1, 1, Chaine);
      Inc(P.cx);
      Inc(P.cy);
      tmpBMP.Canvas.Font.Color := Font.Color;
    end;

    tmpBMP.Canvas.TextOut(0, 0, Chaine);

    Larg := P.cx;
    Haut := P.cy;

    tmpBMP.Width := Larg;
    tmpBMP.Height := Haut;

    tmpBMP.Transparent := True;

    MergeCanvas(Canvas, tmpBMP, X, Y);
  finally
    FreeAndNil(tmpBMP);
  end;
end;

procedure TChangeWall.MergeCanvas(dstCanvas: TCanvas; Image: TBitmap; var PosX, PosY: Integer; UseArray: TArrayMoisAffiche; Position, Alignement: Integer; MoisArround: RMoisAffiche);
var
  dummy1, dummy2: Integer;
begin
  CalculePosition(Image, PosX, PosY, UseArray, Position, Alignement, MoisArround, dummy1, dummy2);
  ProcessMerge(dstCanvas, Image, PosX, PosY, UseArray);
end;

procedure TChangeWall.MergeCanvas(dstCanvas: TCanvas; Image: TBitmap; UseArray: TArrayMoisAffiche; Position, Position_X, Position_Y: Integer);
var
  i: Integer;
  e: Real;
  PosX, PosY: Integer;
begin
  PosX := 0;
  PosY := 0;
  if Position = 99 then begin
    PosX := Trunc(FDesktopWidth * Position_X / 100) - (Image.Width div 2);
    PosY := Trunc(FDesktopHeight * Position_Y / 100) - (Image.Height div 2);
  end else begin
    e := Frac(Position / 10) * 10;
    case Round(e) of            // Trunc renvoi 0 avec PositionCal = 21 !!!!
      0: PosX := 0;
      1: PosX := (FDesktopWidth - Image.Width) div 2;
      2: PosX := FDesktopWidth - Image.Width;
    end;
    case Position div 10 of
      0: PosY := 0;
      1: PosY := (FDesktopHeight - Image.Height) div 2;
      2: PosY := FDesktopHeight - Image.Height;
    end;
  end;
  if FOptions.ResizeDesktop then begin
    Inc(PosX, Screen.WorkAreaLeft);
    Inc(PosY, Screen.WorkAreaTop);
  end;
  for i := 0 to Pred(Length(UseArray)) do with UseArray[i] do
    ChangeLight(Trame, dstCanvas, Rect(PosX + X, PosY + Y, PosX + X + W, PosY + Y + H), CouleurTrame);
  dstCanvas.Draw(PosX, PosY, Image);
end;

procedure TChangeWall.DessineMois(ChaineLog: string; BMP: TBitmap; MoisAffiche: PMoisAffiche; PosX, PosY: Integer; Mois, Annee: Word; var LargeurCal, HauteurCal: Integer; AujourdHui: Integer);

  procedure SetFontSize(Value: Integer);
  begin
    BMP.Canvas.Font.Size := 16 + Value;
    BMP.Canvas.Font.Height := BMP.Canvas.Font.Height + BMP.Canvas.Font.Size div 4;
  end;

var
  DateTrav: TDate;
  JourFerie: PJourFerie;
  Chaine, Semaine: String;
  LastBkMode, TextHgt: Integer;
  DayWeek, LengthMonth, i: Byte;
  PosDayNumber: array[0..7] of Integer;
  LargeurDay, PrecLargeurCal: Integer;
  dummy1, dummy2: Integer;
  FirstDay: Boolean;
begin
  if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - ' + ChaineLog);

  DateTrav := StartOfAMonth(Annee, Mois);
  LengthMonth := DaysInAMonth(Annee, Mois);
  Chaine := LongMonthNames[Mois] + ' ' + IntToStr(Annee);
  Chaine[1] := UpCase(Chaine[1]);
  MoisAffiche.X := PosX;
  MoisAffiche.Y := PosY;
  with BMP.Canvas do begin
    LastBkMode := GetBkMode(Handle);
    try
      SetBkMode(Handle, TRANSPARENT);

      if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Entête');
      Font.Name := FOptions.Calendrier.Font;

      Font.Color := MoisAffiche.CouleurTitre;
      SetFontSize(MoisAffiche.PoliceSize);
      LargeurDay := TextWidth(' 00 ');
      LargeurCal := 7 * LargeurDay;
      if MoisAffiche.NumSemaine then Inc(LargeurCal, LargeurDay);

      if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Titre');
      EcritText(BMP.Canvas, Chaine, PosX + (LargeurCal - TextWidth(Chaine)) div 2, PosY, Font, MoisAffiche.Effet3D, dummy1, TextHgt);
      Inc(PosY, TextHgt);

      PrecLargeurCal := LargeurCal;
      PlugInDessinTitreMois(Mois, Annee, BMP, LargeurCal, PosY);
      PosX := (LargeurCal - PrecLargeurCal) div 2; // recentrage du calendrier sur la nouvelle largeur du titre

      Inc(PosY, Trunc(TextHgt * 0.5));
      if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Titre jours');
      PosDayNumber[0] := PosX;
      for i := 1 to 7 do begin
        DayWeek := FAfficheJour[i];
        if DayWeek in FOptions.Calendrier.WeekEnd then Font.Color := FOptions.Calendrier.FontColorWE
                                                  else Font.Color := FOptions.Calendrier.FontColor;
        Chaine := UpCase(ShortDayNames[DayWeek][1]);
        PosDayNumber[DayWeek] := PosX + (i - 1) * (LargeurDay);
        if MoisAffiche.NumSemaine then Inc(PosDayNumber[DayWeek], LargeurDay);
        EcritText(BMP.Canvas, Chaine, PosDayNumber[DayWeek] + (LargeurDay - TextWidth(Chaine)) div 2, PosY, Font, MoisAffiche.Effet3D, dummy1, dummy2);
      end;
      if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Titre jours - OK');

      Inc(PosY, TextHgt);
      FirstDay := True;
      for i := 1 to LengthMonth do begin
        DayWeek := DayOfWeek(DateTrav);
        JourFerie := FJoursFeries.IsFerie(DateTrav);
        if Assigned(JourFerie) then begin
          if JourFerie.UseCouleur then Font.Color := JourFerie.Couleur
                                  else Font.Color := FOptions.Calendrier.FontColorFerie;
        end
        else if PlugInIsFerie(DateTrav) then Font.Color := FOptions.Calendrier.FontColorFerie
        else if (DayWeek in FOptions.Calendrier.WeekEnd) then Font.Color := FOptions.Calendrier.FontColorWE
        else Font.Color := FOptions.Calendrier.FontColor;
        Chaine := IntToStr(i);

        if (i = AujourdHui) and FOptions.Calendrier.Aujourdhui then begin
          if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Jours - Aujourd''hui');
          Brush.Color := FOptions.Calendrier.ColorCadre;
          FrameRect(Rect(PosDayNumber[DayWeek], PosY, PosDayNumber[DayWeek] + LargeurDay, PosY + TextHgt));
          Brush.Color := clWhite;
          Brush.Style := bsClear;
          if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Jours - Aujourd''hui - OK');
        end;

        if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - Mois - Jours - Day: ' + IntToStr(i) + ' DayOfWeek:' + IntToStr(DayWeek));
        EcritText(BMP.Canvas, Chaine, PosDayNumber[DayWeek] + (LargeurDay - TextWidth(Chaine)) div 2, PosY, Font, MoisAffiche.Effet3D, dummy1, dummy2);

        if FirstDay and MoisAffiche.NumSemaine then begin
          FirstDay := False;
          Semaine := IntToStr(WeekOf(DateTrav));
          SetFontSize(MoisAffiche.SemainePoliceSize);
          Font.Color := FOptions.Calendrier.FontColorSemaine;
          Chaine := IntToStr(WeekOf(DateTrav));
          EcritText(BMP.Canvas, Chaine, PosDayNumber[0] + (LargeurDay - TextWidth(Semaine)) div 2, PosY, Font, MoisAffiche.Semaine3D, dummy1, dummy2);
          SetFontSize(MoisAffiche.PoliceSize);
        end else
          FirstDay := False;
        if (DayWeek = FAfficheJour[7]) and (i <> LengthMonth) then begin
          Inc(PosY, TextHgt);
          FirstDay := True;
        end;
        DateTrav := DateTrav + 1;
      end;
      HauteurCal := (PosY - MoisAffiche.Y);
      if not FirstDay then Inc(HauteurCal, TextHgt);
      MoisAffiche.W := LargeurCal;
      MoisAffiche.H := HauteurCal;
    finally
      SetBkMode(Handle, LastBkMode);
    end;
  end;

end;

procedure TChangeWall.CalculePosition(Image: TBitmap; var PosX, PosY: Integer; UseArray: TArrayMoisAffiche; Position, Alignement: Integer; MoisArround: RMoisAffiche; var Bottom, Right: Integer);
begin
  PosX := MoisArround.X;
  PosY := MoisArround.Y;
  Bottom := MoisArround.H;
  Right := MoisArround.W;
  if Assigned(Image) then begin
    PosX := MoisArround.X;
    PosY := MoisArround.Y;
    case Position of
      0: Dec(PosX, Image.Width + Interval);     // à gauche
      1: Inc(PosX, MoisArround.W + Interval);   // à droite
      2: Dec(PosY, Image.Height + Interval);    // au dessus
      3: Inc(PosY, MoisArround.H + Interval);   // en dessous
    end;
    case Alignement of
      0: PosY := MoisArround.Y;                 // en haut
      1: PosX := MoisArround.X;                 // à gauche
      2:                                        // centré
        case Position of
          0, 1: PosY := MoisArround.Y + (MoisArround.H - Image.Height) div 2;  // à gauche, à droite
          2, 3: PosX := MoisArround.X + (MoisArround.W - Image.Width) div 2;   // au dessus, en dessous
        end;
      3: PosX := MoisArround.X + MoisArround.W - Image.Width;  // à droite
      4: PosY := MoisArround.Y + MoisArround.H - Image.Height; // en bas
    end;
    Bottom := Max(MoisArround.H, PosY + Image.Height);
    Right := Max(MoisArround.W, PosX + Image.Width);
    if FOptions.ResizeDesktop then begin
      Inc(PosX, Screen.WorkAreaLeft);
      Inc(PosY, Screen.WorkAreaTop);
    end;
  end;
end;

procedure TChangeWall.ProcessMerge(dstCanvas: TCanvas; Image: TBitmap; PosX, PosY: Integer; UseArray: TArrayMoisAffiche);
var
  i: Integer;
begin
  for i := 0 to Pred(Length(UseArray)) do with UseArray[i] do
    ChangeLight(Trame, dstCanvas, Rect(PosX + X, PosY + Y, PosX + X + W, PosY + Y + H), CouleurTrame);
  MergeCanvas(dstCanvas, Image, PosX, PosY);
end;

procedure TChangeWall.DoMerge(dstCanvas: TCanvas; Image: TBitmap; var PosX, PosY: Integer; UseArray: TArrayMoisAffiche; Mois: RDetailMois; MoisArround: RMoisAffiche);
begin
  if Assigned(Image) then begin
    Image.Transparent := True;
    case Mois.Positionnement of
      1: MergeCanvas(dstCanvas, Image, UseArray, Mois.Position, Mois.Position_X, Mois.Position_Y);
      0: MergeCanvas(dstCanvas, Image, PosX, PosY, UseArray, Mois.Position, Mois.Alignement, MoisArround);
    end;
  end;
end;

procedure TChangeWall.InitBitmap(var tmpBMP: TBitmap);
begin
  tmpBMP := TBitmap.Create;
  tmpBMP.Width := Screen.Width;
  tmpBMP.Height := Screen.Height;
  tmpBMP.Transparent := False;
  tmpBMP.TransparentColor := FTransparence;
  tmpBMP.TransparentMode := tmFixed;

  tmpBMP.Canvas.Brush.Color := FTransparence;
  tmpBMP.Canvas.FillRect(Rect(0, 0, tmpBMP.Width, tmpBMP.Height));
end;

procedure TChangeWall.DessinePlusieursMois(const ChaineLog: string; UseArray: PArrayMoisAffiche; var Bitmap: TBitmap; var PosX, PosY: Integer; DetailMois: RDetailMois; DecalageMin, DecalageMax: Integer);
var
  i, n: Integer;
  w, h: Integer;
  Annee, Mois, Jour: Word;
  LargeurCal, HeightCal: Integer;
  MoisAffiche: PMoisAffiche;
  Marge: Integer;
  tmpBMP: TBitmap;
begin
  if (DetailMois.Nombre > 0) and (DetailMois.Sens in [0..4]) then begin
    InitBitmap(Bitmap);

    PosX := 0;
    PosY := 0;
    w := 0;
    h := 0;
    n := 1;
    Marge := 0;
    for i := DecalageMin to DecalageMax do begin
      InitBitmap(tmpBMP);
      try
        case DetailMois.Sens of
          0, 2: DecodeDate(IncMonth(FDateCalendrier, i), Annee, Mois, Jour);
          1, 3: DecodeDate(IncMonth(FDateCalendrier, DecalageMin + DecalageMax - i), Annee, Mois, Jour);
        end;

        MoisAffiche := NewMoisAffiche(UseArray);
        MoisAffiche.Effet3D := DetailMois.Effet3D;
        MoisAffiche.NumSemaine := DetailMois.NumSemaine;
        MoisAffiche.Semaine3D := DetailMois.Semaine3D;
        MoisAffiche.SemainePoliceSize := DetailMois.SemaineFontSize;
        MoisAffiche.Trame := DetailMois.Trame;
        MoisAffiche.CouleurTrame := DetailMois.TrameColor;
        MoisAffiche.PoliceSize := DetailMois.FontSize;
        MoisAffiche.CouleurTitre := FOptions.Calendrier.FontColorTitreAutre;

        DessineMois(ChaineLog + ' (' + IntToStr(i) + ')', tmpBMP, MoisAffiche, 0, 0, Mois, Annee, LargeurCal, HeightCal);
        PlugInDessinMois(Mois, Annee, tmpBMP, LargeurCal, HeightCal);
        MoisAffiche.X := PosX;
        MoisAffiche.Y := PosY;
        MoisAffiche.W := LargeurCal;
        MoisAffiche.H := HeightCal;
        Bitmap.Canvas.CopyRect(Rect(PosX, PosY, PosX + LargeurCal, PosY + HeightCal), tmpBMP.Canvas, Rect(0, 0, LargeurCal, HeightCal));

        case DetailMois.Sens of
          0, 1:
            begin
              Inc(PosY, HeightCal + Interval);
              w := Max(w, PosX + LargeurCal);
              h := Max(h, PosY - Interval);
              Marge := Max(Marge, LargeurCal);
            end;
          2, 3:
            begin
              Inc(PosX, LargeurCal + Interval);
              h := Max(h, PosY + HeightCal);
              w := Max(w, PosX - Interval);
              Marge := Max(Marge, HeightCal);
            end;
        end;
        if (n mod DetailMois.Maximum = 0) then begin
          case DetailMois.Sens of
            0, 1:
              begin
                PosY := 0;
                Inc(PosX, Marge + Interval);
              end;
            2, 3:
              begin
                PosX := 0;
                Inc(PosY, Marge + Interval);
              end;
          end;
          Marge := 0;
        end;
        Inc(n);
      finally
        tmpBMP.Free;
      end;
    end;
    Bitmap.Width := w;
    Bitmap.Height := h;
  end;
end;

procedure TChangeWall.DessineCalendrier(BMP: TBitmap);
var
  MoisAvantAffiches, MoisEnCoursAffiche, MoisApresAffiches: TArrayMoisAffiche;
  MoisAffiche: PMoisAffiche;
  i,
  HeightCal, LargeurCal,
  PosX, PosY: Integer;
  Annee, Mois, Jour: Word;
  MoisAvant, MoisEnCours, MoisApres: TBitmap;
  LargeurToday, l, t, w, h: Integer;
  e: Real;
begin
  PosX := 1;
  for i := FOptions.Calendrier.PremierJourSemaine + 1 to 7 do begin
    FAfficheJour[PosX] := i;
    Inc(PosX);
  end;
  for i := 1 to FOptions.Calendrier.PremierJourSemaine do begin
    FAfficheJour[PosX] := i;
    Inc(PosX);
  end;

  if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier');

  MoisAvant := nil;
  MoisEnCours := nil;
  MoisApres := nil;
  try
      HeightCal := 0;

      // mois précédents
      DessinePlusieursMois('Mois précédents', @MoisAvantAffiches, MoisAvant, PosX, PosY, FOptions.Calendrier.Avant, -FOptions.Calendrier.Avant.Nombre, -1);

      // mois courant
      DecodeDate(FDateCalendrier, Annee, Mois, Jour);

      InitBitmap(MoisEnCours);
      if FOptions.Calendrier.EnCoursGras then
        MoisEnCours.Canvas.Font.Style := MoisEnCours.Canvas.Font.Style + [fsBold];

      MoisAffiche := NewMoisAffiche(@MoisEnCoursAffiche);
      MoisAffiche.Effet3D := FOptions.Calendrier.EnCours.Effet3D;
      MoisAffiche.NumSemaine := FOptions.Calendrier.EnCours.NumSemaine;
      MoisAffiche.Semaine3D := FOptions.Calendrier.EnCours.Semaine3D;
      MoisAffiche.SemainePoliceSize := FOptions.Calendrier.EnCours.SemaineFontSize;
      MoisAffiche.Trame := FOptions.Calendrier.EnCours.Trame;
      MoisAffiche.CouleurTrame := FOptions.Calendrier.EnCours.TrameColor;
      MoisAffiche.PoliceSize := FOptions.Calendrier.EnCours.FontSize;
      MoisAffiche.CouleurTitre := FOptions.Calendrier.FontColorTitre;

      DessineMois('Mois courant', MoisEnCours, MoisAffiche, 0, 0, Mois, Annee, LargeurToday, HeightCal, Jour);
      PlugInDessinMois(Mois, Annee, MoisEnCours, LargeurToday, HeightCal);
      MoisEnCoursAffiche[0].W := LargeurToday;
      MoisEnCoursAffiche[0].H := HeightCal;
      MoisEnCours.Width := MoisEnCoursAffiche[0].W;
      MoisEnCours.Height := MoisEnCoursAffiche[0].H;
      MoisEnCours.Transparent := True;

      // mois suivants
      DessinePlusieursMois('Mois suivants', @MoisApresAffiches, MoisApres, PosX, PosY, FOptions.Calendrier.Apres, 1, FOptions.Calendrier.Apres.Nombre);

      if FOptions.Calendrier.EnCours.Positionnement = 1 then begin  // positionnement du EnCours seul
        MergeCanvas(BMP.Canvas, MoisEnCours, MoisEnCoursAffiche, FOptions.Calendrier.EnCours.Position, FOptions.Calendrier.EnCours.Position_X, FOptions.Calendrier.EnCours.Position_Y);
        // PosX et PosY sont à la position de MoisEnCours
        MoisEnCoursAffiche[0].X := PosX;
        MoisEnCoursAffiche[0].Y := PosY;
      end else begin // positionnement du calendrier complet
        l := MoisEnCoursAffiche[0].X;
        t := MoisEnCoursAffiche[0].Y;
        LargeurCal := MoisEnCoursAffiche[0].W;
        HeightCal := MoisEnCoursAffiche[0].H;

        if FOptions.Calendrier.Avant.Positionnement = 0 then begin
          CalculePosition(MoisAvant, PosX, PosY, MoisAvantAffiches, FOptions.Calendrier.Avant.Position, FOptions.Calendrier.Avant.Alignement, MoisEnCoursAffiche[0], h, w);
          l := Min(l, PosX);
          t := Min(t, PosY);
          LargeurCal := Max(LargeurCal, w);
          HeightCal := Max(HeightCal, h);
        end;
        if FOptions.Calendrier.Apres.Positionnement = 0 then begin
          CalculePosition(MoisApres, PosX, PosY, MoisApresAffiches, FOptions.Calendrier.Apres.Position, FOptions.Calendrier.Apres.Alignement, MoisEnCoursAffiche[0], h, w);
          l := Min(l, PosX);
          t := Min(t, PosY);
          LargeurCal := Max(LargeurCal, w);
          HeightCal := Max(HeightCal, h);
        end;
        LargeurCal := LargeurCal - l;
        HeightCal := HeightCal - t;

        if FOptions.Calendrier.EnCours.Position = 99 then begin
          PosX := Trunc(FDesktopWidth * FOptions.Calendrier.EnCours.Position_X / 100) - (LargeurCal div 2);
          PosY := Trunc(FDesktopHeight * FOptions.Calendrier.EnCours.Position_Y / 100) - (HeightCal div 2);
        end else begin
          e := Frac(FOptions.Calendrier.EnCours.Position / 10) * 10;
          case Round(e) of            // Trunc renvoi 0 avec PositionCal = 21 !!!!
            0: PosX := 0;
            1: PosX := (FDesktopWidth - LargeurCal) div 2;
            2: PosX := FDesktopWidth - LargeurCal;
          end;
          case FOptions.Calendrier.EnCours.Position div 10 of
            0: PosY := 0;
            1: PosY := (FDesktopHeight - HeightCal) div 2;
            2: PosY := FDesktopHeight - HeightCal;
          end;
        end;
        if FOptions.ResizeDesktop then begin
          Inc(PosX, Screen.WorkAreaLeft);
          Inc(PosY, Screen.WorkAreaTop);
        end;
        Dec(PosX, l);
        Dec(PosY, t);
      end;
      ProcessMerge(BMP.Canvas, MoisEnCours, PosX, PosY, MoisEnCoursAffiche);
      MoisEnCoursAffiche[0].X := PosX;
      MoisEnCoursAffiche[0].Y := PosY;
      DoMerge(BMP.Canvas, MoisAvant, PosX, PosY, MoisAvantAffiches, FOptions.Calendrier.Avant, MoisEnCoursAffiche[0]);
      DoMerge(BMP.Canvas, MoisApres, PosX, PosY, MoisApresAffiches, FOptions.Calendrier.Apres, MoisEnCoursAffiche[0]);
  finally
    if Assigned(MoisAvant) then FreeAndNil(MoisAvant);
    if Assigned(MoisEnCours) then FreeAndNil(MoisEnCours);
    if Assigned(MoisApres) then FreeAndNil(MoisApres);
  end;
  if FDebug.DetailConversion and FDebug.DetailConversion_Calendrier then WriteLog('Calendrier - OK');
end;

function TChangeWall.PrepareImage(var Image: String): Boolean;
var
  TempBMP, BMP: TBitmap;
  gauche, haut, largeur, hauteur: Integer;
begin
  Result := False;
  if FDebug.DetailConversion then begin
    WriteLog('Préparation de l''image');
    WriteLog('Fichier Image: ' + Image);
  end;

  if FDebug.DetailConversion then WriteLog('DebutDessinFond');
  try
    (FMainProg as IEvenements).DebutDessinFond(Self);
  except
    if FDebug.DetailConversion then WriteLog('Exception DebutDessinFond - ' + Exception(ExceptObject).Message);
    raise;
  end;
  if FDebug.DetailConversion then WriteLog('DebutDessinFond - Ok');
  BMP := TBitmap.Create;
  try
    CalcTransparence;

    if FOptions.ResizeDesktop then begin
      FDesktopWidth := Screen.WorkAreaWidth;
      FDesktopHeight := Screen.WorkAreaHeight;
    end else begin
      FDesktopWidth := Screen.Width;
      FDesktopHeight := Screen.Height;
    end;

    TempBMP := TBitmap.Create;
    try
      if FDebug.DetailConversion and FDebug.DetailConversion_Image then WriteLog('Lecture du fichier image');
      with TPicture.Create do try
        LoadFromFile(Image);
        if not Assigned(Graphic) or Graphic.Empty then begin
          if FDebug.DetailConversion then WriteLog('Image non valide');
          Exit;
        end;
        TempBMP.Width := Width;
        TempBMP.Height := Height;
        TempBMP.Canvas.Draw(0, 0, Graphic);
      finally
        Free;
      end;
      if FDebug.DetailConversion and FDebug.DetailConversion_Image then WriteLog('Lecture du fichier image - OK');

      if FDebug.DetailConversion and FDebug.DetailConversion_Image then WriteLog('Redimensionement du fichier image');
      gauche := 0;
      haut := 0;
      hauteur := FDesktopHeight;
      largeur := FDesktopWidth;
      BMP.Width := Screen.Width;
      BMP.Height := Screen.Height;
      if (FDesktopHeight / FDesktopWidth) > (TempBMP.Height / TempBMP.Width) then begin
        hauteur := largeur * TempBMP.Height div TempBMP.Width;
        haut := (FDesktopHeight - hauteur) div 2;
      end else begin
        largeur := hauteur * TempBMP.Width div TempBMP.Height;
        gauche := (FDesktopWidth - largeur) div 2;
      end;
      if FOptions.ResizeDesktop then begin
        Inc(gauche, Screen.WorkAreaLeft);
        Inc(haut, Screen.WorkAreaTop);
      end;
      BMP.Canvas.Brush.Color := clBlack;
      BMP.Canvas.FillRect(BMP.Canvas.ClipRect);
      if FOptions.AntiAliasing then begin
        if FDebug.DetailConversion and FDebug.DetailConversion_Image then WriteLog('Redimensionement du fichier image - Antialiasing');
        Stretch(largeur, hauteur, sfBell, 0, TempBMP);
        BMP.Canvas.Draw(gauche, haut, TempBMP);
      end else
        BMP.Canvas.StretchDraw(Rect(gauche, haut, gauche + largeur, haut + hauteur), TempBMP);
      if FDebug.DetailConversion and FDebug.DetailConversion_Image then WriteLog('Redimensionement du fichier image - OK');
    finally
      TempBMP.Free;
    end;

    if FOptions.Legende.UseLegende then DessineLegende(BMP, Image);

    if FOptions.Calendrier.UseCalendrier then DessineCalendrier(BMP);

    BMP.SaveToFile(FPathWin + 'WallPap.bmp');
    Image := FPathWin + 'WallPap.bmp';
    Result := True;
    WriteLog('Fichier WallPap: ' + Image);
    WriteLog('Préparation de l''image - Ok');
  finally
    BMP.Free;
    (FMainProg as IEvenements).FinDessinFond(Self);
  end;
end;

procedure TChangeWall.WriteLog(Chaine: string);
var
  FOut: TextFile;
begin
  if not (FDebug.ModeDebug and FDebug.GenereFichierLog) then Exit;
  try
    {.$I-}
    AssignFile(FOut, FDebug.FichierLog);
    try
      try
        Append(FOut);
      except
        Rewrite(FOut);
      end;
      Writeln(FOut, Chaine);
    finally
      CloseFile(FOut);
    end;
    {.$I+}
  except
  end;
end;

function TChangeWall.PlugInIsFerie(Date: TDateTime): Boolean;
var
  i: Integer;
  JF: IJoursFeries;
begin
  Result := False;
  for i := 0 to Pred(Length(FOptions.Plugins)) do with FOptions.Plugins[i] do
    if Actif and not Bool(Plugin.QueryInterface(IJoursFeries, JF)) then begin
      Result := JF.IsFerie(Date);
      if Result then Break;
    end;
end;

procedure TChangeWall.PlugInDessinMois(Mois, Annee: Word; Bitmap: TBitmap; var Largeur, Hauteur: Integer);
var
  h, w: Integer;
  bmp: TBitmap;
  i: Integer;
  DC: IDessinCalendrier;
begin
  bmp := TBitmap.Create;
  try
    for i := 0 to Pred(Length(FOptions.Plugins)) do with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IDessinCalendrier, DC)) then begin
        repeat
          bmp.Assign(Bitmap);
          DC.DessinMois(Mois, Annee, bmp.Canvas.Handle, Largeur, Hauteur, FTransparence);
          h := bmp.Height;
          w := bmp.Width;
          if Hauteur > h then bmp.Height := Hauteur;
          if Largeur > w then bmp.Width := Largeur;
        until (Hauteur <= h) and (Largeur <= w);
        Bitmap.Assign(bmp);
      end;
  finally
    bmp.Free;
  end;
end;

procedure TChangeWall.PlugInDessinTitreMois(Mois, Annee: Word; Bitmap: TBitmap; var Largeur, Hauteur: Integer);
var
  h, w: Integer;
  bmp: TBitmap;
  i: Integer;
  DC: IDessinCalendrier;
begin
  bmp := TBitmap.Create;
  try
    for i := 0 to Pred(Length(FOptions.Plugins)) do with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IDessinCalendrier, DC)) then begin
        repeat
          bmp.Assign(Bitmap);
          DC.DessinTitreMois(Mois, Annee, bmp.Canvas.Handle, Largeur, Hauteur, FTransparence);
          h := bmp.Height;
          w := bmp.Width;
          if Hauteur > h then bmp.Height := Hauteur;
          if Largeur > w then bmp.Width := Largeur;
        until (Hauteur <= h) and (Largeur <= w);
        Bitmap.Assign(bmp);
      end;
  finally
    bmp.Free;
  end;
end;

function TChangeWall.PluginCouleurTransparence(Couleur: TColor): Boolean;
var
  i: Integer;
  DC: IDessinCalendrier;
begin
  Result := True;
  for i := 0 to Pred(Length(FOptions.Plugins)) do with FOptions.Plugins[i] do
    if Actif and not Bool(Plugin.QueryInterface(IDessinCalendrier, DC)) then begin
      Result := DC.CouleurTransparence(Couleur);
      if not Result then Break;
    end;
end;

{ TDessineur }

constructor TDessineur.Create(ChangeWall: TChangeWall);
begin
  FChangeWall := ChangeWall;
end;

function TDessineur.IsFerie(Date: TDateTime): Boolean;
var
  FJoursFeries: TListJoursFeries;
begin
  FJoursFeries := TListJoursFeries.Create;
  try
    FJoursFeries.BeginUpdate;
    FJoursFeries.SetJoursFeries(FChangeWall.FOptions.Calendrier.JoursFeries, Length(FChangeWall.FOptions.Calendrier.JoursFeries));
    FJoursFeries.DateDebut := IncDay(Date, -1);
    FJoursFeries.DateFin := IncDay(Date, 1);
    FJoursFeries.EndUpdate;

    Result := Assigned(FJoursFeries.IsFerie(Date)) or FChangeWall.PlugInIsFerie(Date);
  finally
    FreeAndNil(FJoursFeries);
  end;
end;

function TDessineur.IsWeekEnd(Date: TDateTime): Boolean;
begin
// DayOfTheWeek considère que le premier jour de la semaine est le Lundi alors que WP considère que c'est le Dimanche
//  Result := DayOfTheWeek(Date) in FChangeWall.FOptions.Calendrier.WeekEnd;
  Result := DayOfWeek(Date) in FChangeWall.FOptions.Calendrier.WeekEnd;
end;

end.
