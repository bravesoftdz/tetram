unit MainDM;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, TrayIcon, Forms, Menus, ActnList, Controls;

type
  RDebug = record
    ModeDebug: Boolean;
    FichierLog: string;
    GenereFichierLog,
    DetailRechercheImage,
    DetailConversion,
    ChangementHeureFixe,
    Effacer: Boolean;
  end;

  ROptions = record
  end;

  TFileOfByte = file of Byte;

  TThreadCheckTime = class(TThread)
    FOnCheckTime: TNotifyEvent;
    FHeurePrevue: TTime;
    FCheckExclusions: Boolean;
    procedure Execute; override;
  private
    procedure DoEvent;
  end;

  TDataModule1 = class(TDataModule)
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Changermaintenant1: TMenuItem;
    N3: TMenuItem;
    Supprimercetteimage1: TMenuItem;
    N2: TMenuItem;
    Activ1: TMenuItem;
    Options1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    ActionList1: TActionList;
    SupprimerImage: TAction;
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject; Shift: TShiftState);
    procedure TrayIcon1MouseDown(Sender: TObject; Shift: TShiftState);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState);
    procedure Changermaintenant1Click(Sender: TObject);
    procedure Activ1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure SupprimerImageUpdate(Sender: TObject);
    procedure SupprimerImageExecute(Sender: TObject);
  private
    { Déclarations privées }
    FDebug: RDebug;
    FOptions: ROptions;

    FFichiersCount: Integer;
    FListFichiers: string;
    FHistorique: TStringList;
    FHIcon: THandle;
    FLastChange: TDateTime;
    procedure WriteLog(Chaine: string);
    procedure BeginTravail;
    procedure EndTravail;
    function SSRunning: Boolean;
    procedure ChargeListeFichiers;
    procedure RestreintHistorique;
    function PrepareImage(var Image: String): Boolean;
    procedure ApplyBack(Fichier: String);
    procedure InitCheckThread;
  public
    { Déclarations publiques }
    procedure ChangeWallPap(Actif: Boolean = True; Force: Boolean = False);
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

procedure TDataModule1.BeginTravail;
begin
  if FDebug.GenereFichierLog and FDebug.Effacer and FileExists(FDebug.FichierLog) then DeleteFile(FDebug.FichierLog);
  WriteLog('BeginTravail - ' + DateTimeToStr(Now));
  if FHIcon = 0 then FHIcon := LoadIcon(hInstance, 'TRAVAIL');
  TrayIcon1.Icon.Handle := FHIcon;
end;

procedure TDataModule1.ChangeWallPap(Actif, Force: Boolean);
var
  m: Integer;
  F: TFileOfByte;
  p: Integer;
  c: Byte;

  procedure LitFichier(var Fichier: string);
  var
    s: string;
  begin
    if FDebug.DetailRechercheImage then WriteLog(Format('LitFichier - p:%d m:%d', [p, m]));
    c := 0;
    s := '';
    while not Eof(f) and (c <> 1) do begin
      Read(F, c);
      if (c <> 1) then s := s + Char(c);
    end;

    m := Length(s);
    while s[m] in ['"', #13, #10] do Dec(m);
    SetLength(s, m);
    if s[1] = '"' then s := Copy(s, 2, Length(s));

    Fichier := s;
  end;

  function ChercheFichier: string;
  begin
    m := FileSize(F);
    p := Random(m);
    if FDebug.DetailRechercheImage then WriteLog(Format('ChercheFichier - p:%d m:%d', [p, m]));
    Seek(F, p);
    Read(F, c);
    while (p > 0) and (c <> 1) do begin
      Dec(p);
      Seek(F, p);
      Read(F, c);
    end;

    LitFichier(Result);
  end;

  function ChooseImage: String;
  var
    Fichier: string;

    procedure WriteImageLog;
    begin
      if FDebug.DetailRechercheImage then begin
        if (not FileExists(Fichier)) then WriteLog('Fichier image trouvé: ' + Fichier + ' (inexistant)')
        else if (FHistorique.IndexOf(Fichier) <> -1) then WriteLog('Fichier image trouvé: ' + Fichier + ' (dans l''historique)')
        else WriteLog('Fichier image trouvé: ' + Fichier);
      end;
    end;

  begin
    AssignFile(F, FListFichiers);
    Reset(F);
    try
      Fichier := ChercheFichier;
      WriteImageLog;
      while (not FileExists(Fichier)) or ((FHistorique.Count < FFichiersCount) and (FHistorique.IndexOf(Fichier) <> -1)) do begin
        Fichier := ChercheFichier;
        WriteImageLog;
      end;
    finally
      CloseFile(F);
    end;
    Result := Fichier;
  end;

const
  Working: Boolean = False;  
var
  Image: String;
begin
  if Working then Exit;
  BeginTravail;
  Working := True;
  try
    if not Actif then Exit;
    if SSRunning and not (FDebug.ModeDebug or Force) then Exit;
    if not FileExists(FListFichiers) then ChargeListeFichiers;
    if not Bool(FFichiersCount) then Exit;
    Image := ChooseImage;
    FHistorique.Add(Image);
    RestreintHistorique;
    if PrepareImage(Image) then ApplyBack(Image);
    InitCheckThread;
  finally
    Working := False;
    EndTravail;
  end;
end;

procedure TDataModule1.EndTravail;
begin
  TrayIcon1.Icon.Assign(Application.Icon);
  FLastChange := Now;
  WriteLog('FinTravail - ' + DateTimeToStr(Now) + #13#10);
end;

procedure TDataModule1.Timer1Timer(Sender: TObject);
begin
  if (Sender is TThread) and FDebug.ChangementHeureFixe then WriteLog('Thread CheckTime - Déclenchement');
  if (Sender is TThread) then ChangeWallPap(Activ1.Checked, not TThreadCheckTime(Sender).FCheckExclusions)
                         else ChangeWallPap(Activ1.Checked);
end;

procedure TDataModule1.WriteLog(Chaine: string);
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

procedure TDataModule1.TrayIcon1DblClick(Sender: TObject; Shift: TShiftState);
begin
  Options1.Click;
end;

procedure TDataModule1.TrayIcon1MouseDown(Sender: TObject; Shift: TShiftState);
begin
  if ssRight in Shift then begin
    SetForegroundWindow(Handle);
    PopupMenu1.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
  end;
end;

procedure TDataModule1.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState);
begin
  RefreshIconCaption;
end;

function TDataModule1.SSRunning: Boolean;

  function RetrouveSS: string;
  begin
    Result := '';
    with TRegistry.Create(KEY_READ) do begin
      try
        RootKey := HKEY_CURRENT_USER;
        if OpenKeyReadOnly('Control Panel\Desktop') then
          Result := ExtractShortPathName(ReadString('SCRNSAVE.EXE'));
      finally
        Free;
      end;
    end;
  end;

var
  ScreenSave: String;
  HdlSnapshotSystem, HdlSnapshotProcess: LongInt;
  pe32: PROCESSENTRY32;
  me32: MODULEENTRY32;

  function ContinueScan(Fichier: string; Level: Integer = 0): Boolean;
  begin
    if CheckBox8.Checked and CheckBox9.Checked then
      if Level = 1 then begin
        WriteLog('me32.szModule: ' + StrPas(me32.szModule));
        WriteLog('me32.szExePath: ' + Fichier);
      end else begin
        WriteLog('pe32.szExeFile: ' + Fichier);
      end;
    Fichier := ExtractShortPathName(Fichier);
    Result := not FileExists(Fichier);
    if Result then Exit;
    Result := not SameFileName(Fichier, ScreenSave);
    if not Result then begin
      WriteLog('Economiseur trouvé');
      Exit;
    end;
    Result := (ListBox2.Items.IndexOf(ExtractLongPathName(Fichier)) = -1);
    if not Result then begin
      WriteLog('Exclu trouvé: ' + Fichier);
      Exit;
    end;
  end;

begin
  Result := False;
  try
    ScreenSave := RetrouveSS;
    WriteLog('Economiseur: ' + ScreenSave);
    HdlSnapshotSystem := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if HdlSnapshotSystem = -1 then Exit;
    try
      FillMemory(@pe32, SizeOf(PROCESSENTRY32), 0);
      pe32.dwSize := SizeOf(PROCESSENTRY32);
      if CheckBox8.Checked then WriteLog('Modules en exécution:');
      if Process32First(HdlSnapshotSystem, pe32) then
        repeat
          if CheckBox8.Checked then WriteLog(StrPas(pe32.szExeFile));
//          if ContinueScan(StrPas(pe32.szExeFile)) then begin
            HdlSnapshotProcess := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pe32.th32ProcessID);
            if (HdlSnapshotProcess <> -1) then begin
              try
                FillMemory(@me32, SizeOf(MODULEENTRY32), 0);
                me32.dwSize := SizeOf(MODULEENTRY32);
                if (Module32First(HdlSnapshotProcess, me32)) then begin
                  repeat
                    Result := not ContinueScan(me32.szExePath, 1);
                  until (Result or not Module32Next(HdlSnapshotProcess, me32));
                end;
              finally
                CloseHandle(HdlSnapshotProcess);
              end;
            end;
//          end else
//            Result := True;
        until Result or not Process32Next(HdlSnapshotSystem, pe32);
    finally
      CloseHandle(HdlSnapshotSystem);
    end;
  except
    Result := False;
  end;
  WriteLog('Economiseur non trouvé');
end;

procedure TDataModule1.ChargeListeFichiers;

  function FichierBon(Fichier: string): Boolean;
  var
    i: Integer;
  begin
    i := CheckListBox1.Items.IndexOf(ExtractFileExt(Fichier));
    Result := (i <> -1) and CheckListBox1.Checked[i];
  end;

var
  FOut: TextFile;

  procedure Scan(Path: String; SousRep: Boolean);
  var
    rec: TSearchRec;
    resultat: Integer;
  begin
    if (Length(Path) > 0) and (Path[Length(Path)] <> PathDelim) then Path := Path + PathDelim;
    resultat := FindFirst(Path + '*.*', faAnyFile, rec);
    if resultat = 0 then begin
      while resultat = 0 do begin
        if (rec.Attr and faDirectory > 0) then begin
          if (rec.Name <> '.') and (rec.Name <> '..') and SousRep then Scan(Path + rec.Name, SousRep);
        end else
          if FichierBon(Path + rec.Name) then begin
            Write(FOut, #1 + Path + rec.Name);
            Inc(FichiersCount);
          end;
        resultat := FindNext(rec);
      end;
      FindClose(rec);
    end;
  end;

var
  i: Integer;
  Path: string;
begin
  ListFichiers := ChangeFileExt(Application.ExeName, '.tmp');
  {.$I-}
  AssignFile(FOut, ListFichiers);
  try
    Rewrite(FOut);
    FichiersCount := 0;
    for i := 0 to ListBox1.Items.Count - 1 do begin
      Path := ListBox1.Items[i];
      if (Length(Path) > 0) and (Path[Length(Path)] <> PathDelim) then begin
        Path := Path + PathDelim;
        ListBox1.Items[i] := Path;
      end;
      Scan(Path, ListBox1.Checked[i]);
    end;
    Label7.Caption := IntToStr(FichiersCount) + ' images';
  finally
    CloseFile(FOut);
  end;
  {.$I+}
end;

procedure TDataModule1.RestreintHistorique;
begin
  while Historique.Count > MulDiv(SpinEdit4.Value, FichiersCount, 100) do
    Historique.Delete(0);
end;

function TDataModule1.PrepareImage(var Image: String): Boolean;
const
//  LargeurCal = 112;
//  LargeurToday = 185;
  Interval = 10;
  FontSizeToday = 14;
  FontSizeAutre = 8;
var
  LargeurCal: Integer;
  LargeurToday: Integer;
  TempBMP, BMP: TBitmap;
  DesktopWidth, DesktopHeight: Integer;
  Annee, Mois, Jour: Word;
  clFerie, clFerieInv: TColor;
  i, TabX, PosX, PosY, oldPosY: Integer;
  gauche, haut, largeur, hauteur: Integer;
begin
  if CheckBox11.Checked then begin
    WriteLog('Préparation de l''image');
    WriteLog('Fichier Image: ' + Image);
  end;
  CurrentImage := Image;

//LargeurCal := 112;
  TabX := 1;
  for i := ComboBox1.ItemIndex + 1 to 7 do begin
    AfficheJour[TabX] := i;
    Inc(TabX);
  end;
  for i := 1 to ComboBox1.ItemIndex do begin
    AfficheJour[TabX] := i;
    Inc(TabX);
  end;
  WeekEnd := [];
  for i := 1 to 7 do
    if CheckListBox2.Checked[i - 1] then Include(WeekEnd, i);

  SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);
  DesktopWidth := WorkArea.Right - WorkArea.Left;
  DesktopHeight := WorkArea.Bottom - WorkArea.Top;
  BMP := TBitmap.Create;
  try
    TempBMP := TBitmap.Create;
    try
      if CheckBox11.Checked and CheckBox12.Checked then WriteLog('Lecture du fichier image');
      with TPicture.Create do begin
        try
          LoadFromFile(Image);
          TempBMP.Width := Width;
          TempBMP.Height := Height;
          TempBMP.Canvas.Draw(0, 0, Graphic);
        finally
          Free;
        end;
      end;
      if CheckBox11.Checked and CheckBox12.Checked then WriteLog('Lecture du fichier image - OK');

      if CheckBox11.Checked and CheckBox12.Checked then WriteLog('Redimensionement du fichier image');
      gauche := 0;
      haut := 0;
      hauteur := DesktopHeight;
      largeur := DesktopWidth;
      BMP.Width := DesktopWidth;
      BMP.Height := DesktopHeight;
      if (DesktopHeight / DesktopWidth) > (TempBMP.Height / TempBMP.Width) then begin
        hauteur := largeur * TempBMP.Height div TempBMP.Width;
        haut := (DesktopHeight - hauteur) div 2;
      end else begin
        largeur := hauteur * TempBMP.Width div TempBMP.Height;
        gauche := (DesktopWidth - largeur) div 2;
      end;
      BMP.Canvas.Brush.Color := clBlack;
      BMP.Canvas.FillRect(BMP.Canvas.ClipRect);
      if CheckBox4.Checked then begin
        if CheckBox11.Checked and CheckBox12.Checked then WriteLog('Redimensionement du fichier image - Antialiasing');
        Stretch(largeur, hauteur, sfBell, 0, TempBMP);
        BMP.Canvas.Draw(gauche, haut, TempBMP);
      end else
        BMP.Canvas.StretchDraw(Rect(gauche, haut, gauche + largeur, haut + hauteur), TempBMP);
      if CheckBox11.Checked and CheckBox12.Checked then WriteLog('Redimensionement du fichier image - OK');
    finally
      TempBMP.Free;
    end;

    with BMP do begin
      if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier');
      clFerie := RGB(255, 0, 0);
      clFerieInv := RGB(0, 255, 255);

      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

      TabX := DesktopWidth - 5;
      if CheckBox1.Checked then begin
        if SpinEdit2.Value > 0 then begin
          // mois suivants
          oldPosY := 0;
          for i := 1 to SpinEdit2.Value do begin
            DecodeDate(IncMonth(Now, i), Annee, Mois, Jour);

            PosX := TabX;
            PosY := oldPosY;
            if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - Mois suivants (' + IntToStr(i) + ') - Video inverse');
            EcritMois(Canvas, PosX, PosY, Mois, Annee, clBlack, clFerieInv, LargeurCal, FontSizeAutre, True);
//            EcritMois(Canvas, PosX, PosY, Mois, Annee, clWhite, clFerieInv, LargeurCal, FontSizeAutre);

            PosX := TabX + 1;
            PosY := oldPosY + 1;
            if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - Mois suivants (' + IntToStr(i) + ')');
            EcritMois(Canvas, PosX, PosY, Mois, Annee, clWhite, clFerie, LargeurCal, FontSizeAutre, False);
//            EcritMois(Canvas, PosX, PosY, Mois, Annee, clBlack, clFerie, LargeurCal, FontSizeAutre);

            Inc(PosY, Trunc(Canvas.TextHeight('A') * 1.5));
            oldPosY := PosY;
          end;
        end;
        TabX := TabX - LargeurCal;

        // mois courant
        DecodeDate(Now, Annee, Mois, Jour);
        Canvas.Font.Style := Canvas.Font.Style + [fsBold];
        TabX := TabX - Interval;
        oldPosY := 0;

        PosX := TabX;
        PosY := 0;
        if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - Mois courant - Video inverse');
//        EcritMois(Canvas, PosX, PosY, Mois, Annee, clWhite, clFerieInv, LargeurToday, FontSizeToday, Jour);
        EcritMois(Canvas, PosX, PosY, Mois, Annee, clBlack, clFerieInv, LargeurToday, FontSizeToday, True, Jour);

        PosX := TabX + 1;
        PosY := oldPosY + 1;
        if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - Mois courant');
//        EcritMois(Canvas, PosX, PosY, Mois, Annee, clBlack, clFerie, LargeurToday, FontSizeToday, Jour);
        EcritMois(Canvas, PosX, PosY, Mois, Annee, clWhite, clFerie, LargeurToday, FontSizeToday, False, Jour);
        Canvas.Font.Style := Canvas.Font.Style - [fsBold];
        TabX := TabX - LargeurToday;

        if SpinEdit1.Value > 0 then begin
          // mois précédents
          oldPosY := 0;
          TabX := TabX - Interval;
          for i := -SpinEdit1.Value to -1 do begin
            DecodeDate(IncMonth(Now, i), Annee, Mois, Jour);

            PosX := TabX;
            PosY := oldPosY;
            if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - Mois précédents (' + IntToStr(i) + ') - Video inverse');
//            EcritMois(Canvas, PosX, PosY, Mois, Annee, clWhite, clFerieInv, LargeurCal, FontSizeAutre);
            EcritMois(Canvas, PosX, PosY, Mois, Annee, clBlack, clFerieInv, LargeurCal, FontSizeAutre, True);

            PosX := TabX + 1;
            PosY := oldPosY + 1;
            if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - Mois précédents (' + IntToStr(i) + ')');
//            EcritMois(Canvas, PosX, PosY, Mois, Annee, clBlack, clFerie, LargeurCal, FontSizeAutre);
            EcritMois(Canvas, PosX, PosY, Mois, Annee, clWhite, clFerie, LargeurCal, FontSizeAutre, False);

            Inc(PosY, Trunc(Canvas.TextHeight('A') * 1.5));
            oldPosY := PosY;
          end;
        end;

      end;
      if CheckBox11.Checked and CheckBox13.Checked then WriteLog('Calendrier - OK');
      
      if CheckBox2.Checked then begin
        if CheckBox11.Checked and CheckBox14.Checked then WriteLog('Citation');
        if FileExists(Label11.Caption) then EcritCitation(Canvas, DesktopWidth, DesktopHeight)
                                       else if CheckBox11.Checked and CheckBox14.Checked then WriteLog('Citation - Fichier "' + Label11.Caption + '" introuvable');
        if CheckBox11.Checked and CheckBox14.Checked then WriteLog('Citation - OK');
      end;
    end;

    BMP.SaveToFile(PathWin + 'WallPap.bmp');
    Image := PathWin + 'WallPap.bmp';
    Result := True;
    WriteLog('Fichier WallPap: ' + Image);
    WriteLog('Préparation de l''image - Ok');
  finally
    BMP.Free;
  end;
end;

procedure TDataModule1.ApplyBack(Fichier: String);
var
  PImage: PWideChar;
  WallPapOptions: TWallPaperOpt;
begin
  WriteLog('Collage du papier-peint');
  if not FileExists(Fichier) then Exit;
  PImage := StringToOleStr(Fichier);
  ActiveDesktopEx.SetWallpaper(PImage, 0);
  WallPapOptions.dwSize := SizeOf(WallPapOptions);
  WallPapOptions.dwStyle := WPSTYLE_STRETCH;
  ActiveDesktopEx.SetWallpaperOptions(WallPapOptions, 0);
  ActiveDesktopEx.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
  WriteLog('Collage du papier-peint - Ok');
end;

procedure TDataModule1.InitCheckThread;
var
  TimeCheck: TDateTime;
  Found: Boolean;
  i: Integer;

  procedure MakeTime;
  var
    j, m, a, h, mn, s, ms: Word;
  begin
    TimeCheck := Frac(TimeCheck);
    DecodeDate(Now, a, m, j);
    DecodeTime(TimeCheck, h, mn, s, ms);
    TimeCheck := EncodeDateTime(a, m, j, h, mn, s, ms);
  end;

var
  CheckExclusions: Boolean;
begin
  if CheckBox11.Checked and CheckBox16.Checked then WriteLog('Thread CheckTime - Initialisation');
  if Assigned(FThreadCheckTime) then FThreadCheckTime.Terminate;
  CheckExclusions := True;
  if Bool(ListBox3.Items.Count) then begin
    Found := False;
    i := 0;
    while not Found and (i <= Pred(ListBox3.Items.Count)) do begin
      if TryStrToTime(ListBox3.Items[i], TimeCheck) then begin
        MakeTime;
        Found := TimeCheck > Now;
        if Found then CheckExclusions := ListBox3.Checked[i];
      end;
      Inc(i);
    end;

    if not Found then begin
      if CheckBox11.Checked and CheckBox16.Checked then WriteLog('Thread CheckTime - Not found');
      TimeCheck := StrToTime(ListBox3.Items[0]);
      MakeTime;
      TimeCheck := IncDay(TimeCheck);
      CheckExclusions := ListBox3.Checked[0];
    end;

    if CheckBox11.Checked and CheckBox16.Checked then WriteLog('Thread CheckTime - ' + DateTimeToStr(TimeCheck));
    FThreadCheckTime := TThreadCheckTime.Create(True);
    FThreadCheckTime.FreeOnTerminate := True;
    FThreadCheckTime.OnTerminate := ThreadTerminate;
    FThreadCheckTime.FOnCheckTime := Timer1Timer;
    FThreadCheckTime.FHeurePrevue := TimeCheck;
    FThreadCheckTime.FCheckExclusions := CheckExclusions;
    if Activ1.Checked then FThreadCheckTime.Resume;
  end else
    if CheckBox11.Checked and CheckBox16.Checked then WriteLog('Thread CheckTime - Pas d''horaires');

  if CheckBox11.Checked and CheckBox16.Checked then WriteLog('Thread CheckTime - OK');
end;

procedure TDataModule1.Changermaintenant1Click(Sender: TObject);
begin
  ChangeWallPap(True, True);
end;

procedure TDataModule1.Activ1Click(Sender: TObject);
begin
  if Assigned(FThreadCheckTime) then
    if Activ1.Checked then FThreadCheckTime.Resume
                      else FThreadCheckTime.Suspend;
end;

procedure TDataModule1.Options1Click(Sender: TObject);
begin
  SetForegroundWindow(Handle);
  Show;
end;

procedure TDataModule1.Quitter1Click(Sender: TObject);
begin
  Close;
end;

procedure TDataModule1.SupprimerImageUpdate(Sender: TObject);
begin
  SupprimerImage.Enabled := FileExists(CurrentImage);
end;

procedure TDataModule1.SupprimerImageExecute(Sender: TObject);
begin
  if MessageDlg('Êtes-vous sûr de vouloir supprimer le fichier:'#13 + CurrentImage, mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  DeleteFile(CurrentImage);
  if FileExists(ListFichiers) then DeleteFile(ListFichiers);
  ChangeWallPap;
end;

{ TThreadCheckTime }

procedure TThreadCheckTime.DoEvent;
begin
  if Assigned(FOnCheckTime) then FOnCheckTime(Self);
end;

procedure TThreadCheckTime.Execute;
begin
  while not Terminated and (Now < FHeurePrevue) do
    Sleep(1000);
  if not Terminated then Synchronize(DoEvent);
end;

end.
