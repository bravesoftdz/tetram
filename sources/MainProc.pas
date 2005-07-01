unit MainProc;

interface

uses
  Windows, SysUtils, Menus, Classes, Forms, ShellAPI, ShlObj, ComObj, ActiveX, Registry, ExtCtrls;

procedure ChargeIcon;
procedure BeginTravail;
procedure EndTravail;
procedure ApplyBack(Fichier: String);
procedure WriteLog(Chaine: string);
procedure LoadOptions;

const
  PathWin: string = '';
  StartupFolder: string = '';
  CleProg = 'SOFTWARE\Medi@ Kit\WallPap';
  TitleAPP = 'Medi@ Kit - WallPap 1.0';
  WorkArea: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

implementation

uses
  Form_Main;

type
  TFileOfByte = file of Byte;

  TStoreProc = class(TPersistent)
    procedure OptionsClick(Sender: TObject);
    procedure QuitterClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    procedure ActiveClick(Sender: TObject);
  end;

const
  PopupMenu: TPopupMenu = nil;
  StoreProc: TStoreProc = nil;
  Timer: TTimer = nil;
  HIcon: THandle = 0;
  LastChange: TDateTime = 0;
  ActiveDesktopEx: IActiveDesktop = nil;

var
  NotifyData : TNotifyIconData; // "structure" de l'icône

procedure TStoreProc.OptionsClick(Sender: TObject);
begin
  with TFond.Create(nil) do begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TStoreProc.QuitterClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TStoreProc.TimerTimer(Sender: TObject);
begin
  ChangeWallPap(ListOptions.Actif);
end;

procedure TStoreProc.ActiveClick(Sender: TObject);
begin
  ListOptions.Actif := not ListOptions.Actif;
  (Sender as TMenuItem).Checked := ListOptions.Actif;
end;

procedure RefreshIconCaption;

  function MyEncodeTime(Minutes: Integer): TDateTime;
  begin
    Result := EncodeTime(Minutes div 60, Minutes mod 60, 0, 0);
  end;

var
  Chaine: string;
  j: Integer;
  Duree, TempsEcoule, TempsRestant: TDateTime;
begin
  Chaine := TitleAPP;
  if Timer.Enabled then begin
    Duree := MyEncodeTime(ListOptions.Interval);
    TempsEcoule := Now - LastChange;
    TempsRestant :=  Duree - TempsEcoule;
    Chaine := Chaine + ' - Temps restant: ' + TimeToStr(TempsRestant);
  end else
    Chaine := Chaine + ' - Désactivé';
  for j := 0 to Length(Chaine) - 1 do
    NotifyData.szTip[j] := Chaine[j + 1];
  NotifyData.szTip[Length(Chaine)] := #0;
  Shell_NotifyIcon(NIM_MODIFY, @NotifyData);
end;

const
  CLSID_ActiveDesktop: TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';
  IID_IPersistFile: TGUID = (D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

type
  TLinkInfos = record
    Arguments: string;
    Description: string;
    HotKey: Word;
    IconLocation: string;
    IconIndex: Integer;
    IDList: PItemIDList;
    FileName: string;
    UNCFileName: string;
    ShowCMD: Integer;
    WorkingDirectory: string;
  end;

function GetLinkInfos(LinkFile: string; var LinkInfos: TLinkInfos; Dialogue: Boolean = True): Boolean;
var
  ShellLink: IShellLink;
  szDummy: array[0..MAX_PATH] of char;
  wfd: TWIN32FINDDATA;
  wsz: array[0..MAX_PATH] of WideChar;
  PersistFile: IPersistFile;
  Flag: Cardinal;
begin
  CoInitialize(nil);
  try
    // Get a pointer to the IShellLink interface.
    OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_SERVER, IID_IShellLinkA, ShellLink));
    try
      // Get a pointer to the IPersistFile interface.
      OleCheck(ShellLink.QueryInterface(IID_IPersistFile, PersistFile));
      try
        // Ensure that the string is Unicode.
        MultiByteToWideChar(CP_ACP, 0, PChar(LinkFile), -1, wsz, MAX_PATH);
        // Load the shortcut.
        OleCheck(PersistFile.Load(wsz, STGM_READ));
        // Resolve the link.
        if Dialogue then Flag := SLR_ANY_MATCH
                    else Flag := SLR_NO_UI;
        OleCheck(ShellLink.Resolve(Application.Handle, Flag));
        // Get the arguments of the target.
        OleCheck(ShellLink.GetArguments(szDummy, MAX_PATH));
        LinkInfos.Arguments := StrPas(szDummy);
        // Get the description of the target.
        OleCheck(ShellLink.GetDescription(szDummy, MAX_PATH));
        LinkInfos.Description := StrPas(szDummy);
        // Get the hotkey of the target.
        OleCheck(ShellLink.GetHotkey(LinkInfos.HotKey));
        // Get the icon infos of the target.
        OleCheck(ShellLink.GetIconLocation(szDummy, MAX_PATH, LinkInfos.IconIndex));
        LinkInfos.IconLocation := StrPas(szDummy);
        // Get the ItemIdList of the target.
        OleCheck(ShellLink.GetIDList(LinkInfos.IDList));
        // Get the path to the link target.
        OleCheck(ShellLink.GetPath(szDummy, MAX_PATH, wfd, SLGP_SHORTPATH));
        LinkInfos.FileName := StrPas(szDummy);
        // Get the unc path to the link target.
        OleCheck(ShellLink.GetPath(szDummy, MAX_PATH, wfd, SLGP_UNCPRIORITY));
        LinkInfos.UNCFileName := StrPas(szDummy);
        // Get the ShowCmd to the link target.
        OleCheck(ShellLink.GetShowCmd(LinkInfos.ShowCMD));
        // Get the Working Directory to the link target.
        OleCheck(ShellLink.GetWorkingDirectory(szDummy, MAX_PATH));
        LinkInfos.WorkingDirectory := StrPas(szDummy);
        Result := True;
      finally
        PersistFile := nil;
      end;
    finally
      ShellLink := nil;
    end;
  finally
    CoUninitialize;
  end;
end;

function CreateLink(lpszPathObj, lpszPathLink, lpszDesc: PChar): Boolean;
var
  ShellLink: IShellLink;
  wsz: array[0..MAX_PATH] of WideChar;
  PersistFile: IPersistFile;
begin
  CoInitialize(nil);
  try
    // Get a pointer to the IShellLink interface.
    OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_SERVER, IID_IShellLinkA, ShellLink));
    try
      ShellLink.SetPath(lpszPathObj);
      ShellLink.SetDescription(lpszDesc);

      // Get a pointer to the IPersistFile interface.
      OleCheck(ShellLink.QueryInterface(IID_IPersistFile, PersistFile));
      try
        // Ensure that the string is Unicode.
        MultiByteToWideChar(CP_ACP, 0, PChar(lpszPathLink), -1, wsz, MAX_PATH);
        // Save the shortcut.
        OleCheck(PersistFile.Save(wsz, True));
        Result := True;
      finally
        PersistFile := nil;
      end;
    finally
      ShellLink := nil;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure CheckStartupLink;

  procedure GetLinkFile;
  var
    i: Integer;
  begin
    i := 0;
    ListOptions.LinkFile := 'WallPap';
    while FileExists(StartupFolder + ListOptions.LinkFile + IntToStr(i) + '.lnk') do
      Inc(i);
    ListOptions.LinkFile := ListOptions.LinkFile + IntToStr(i) + '.lnk';
  end;

var
  TmpLinkFile: string;
//  LinkInfos: TLinkInfos;
begin
  TmpLinkFile := StartupFolder + ListOptions.LinkFile;
  if ListOptions.Windows then begin
    if FileExists(TmpLinkFile) {and GetLinkInfos(TmpLinkFile, LinkInfos, False) and (LowerCase(LinkInfos.FileName) = LowerCase(Application.ExeName))}
      then Exit;
    CreateLink(PChar(Application.ExeName), PChar(TmpLinkFile), PChar(TitleAPP));
  end else begin
    if not FileExists(TmpLinkFile) then Exit;                                                       // le lien éxiste
//    if not GetLinkInfos(TmpLinkFile, LinkInfos, False) then Exit;                                   // la cible existe
//    if LowerCase(LinkInfos.FileName) = LowerCase(Application.ExeName) then
    DeleteFile(TmpLinkFile); // la cible est cette appli
  end;
end;

procedure LoadOptions;
var
  i, j: Integer;
  Chemins: TStringList;
begin
  Chemins := TStringList.Create;
  Chemins.Duplicates := dupIgnore;
  with TRegIniFile.Create do begin
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKeyReadOnly(CleProg);
      Chemins.Clear;
      ListOptions.Calendar.Shown := ReadBool('Options', 'Calendrier', False);
      ListOptions.Calendar.MoisAvant := ReadInteger('Options', 'MoisAvant', 0);
      ListOptions.Calendar.MoisApres := ReadInteger('Options', 'MoisApres', 0);
      ListOptions.Calendar.FontName := ReadString('Options', 'CalPolice', 'Arial');
      ListOptions.Calendar.FontSize := ReadInteger('Options', 'CalPoliceSize', 0);
      ListOptions.Interval := ReadInteger('Options', 'Interval', 60);
      Timer.Interval := ListOptions.Interval * 60 * 1000;
      ListOptions.PremierJourSemaine := ReadInteger('Options', 'PremierJour', 1);
      ListOptions.Historik.PctHistorique := ReadInteger('Options', 'Historique', 10);
      ListOptions.Windows := ReadBool('Options', 'WZ', True);
      ListOptions.Demarrage := ReadBool('Options', 'Demarrage', False);
      ListOptions.AntiAliasing := ReadBool('Options', 'Aliasing', True);
      ListOptions.FichierLog := ReadBool('Options', 'Log', False);
      ListOptions.Citations.Shown := ReadBool('Options', 'Citation', False);
      ListOptions.Citations.Fichier := ReadString('Options', 'Citations', '');
      ListOptions.Citations.FontName := ReadString('Options', 'CitPolice', 'Arial');
      ListOptions.Citations.FontSize := ReadInteger('Options', 'CitPoliceSize', 0);
      ListOptions.WeekEnd := [];
      for i := 1 to 7 do
        if ReadBool('Options', 'WE' + IntToStr(i), False) then Include(ListOptions.WeekEnd, i);

      CheckStartupLink;
    finally
      Free;
      Chemins.Free;
    end;
  end;
  ChargeListeFichiers;
end;

procedure WriteLog(Chaine: string);
var
  FOut: TextFile;
begin
  if not (ListOptions.ModeDebug and ListOptions.FichierLog) then Exit;
  try
    {.$I-}
    AssignFile(FOut, ListOptions.LogFile);
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

procedure BeginTravail;
begin
  WriteLog('BeginTravail - ' + DateTimeToStr(Now));
  if HIcon = 0 then HIcon := LoadIcon(hInstance, 'TRAVAIL');
  NotifyData.hIcon := HIcon;
  Shell_NotifyIcon(NIM_MODIFY, @NotifyData);
end;

procedure EndTravail;
begin
  NotifyData.hIcon := Application.Icon.Handle;
  Shell_NotifyIcon(NIM_MODIFY, @NotifyData);
  LastChange := Now;
  WriteLog('FinTravail - ' + DateTimeToStr(Now) + #13#10);
end;

procedure ApplyBack(Fichier: String);
var
  PImage: PWideChar;
begin
  WriteLog('Collage du papier-peint');
  if not FileExists(Fichier) then Exit;
  PImage := StringToOleStr(Fichier);
  ActiveDesktopEx.SetWallpaper(PImage, 0);
  ActiveDesktopEx.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
  WriteLog('Collage du papier-peint - Ok');
end;

function GetDisplayName(ShellFolder: IShellFolder; PIDL: PItemIDList; ForParsing: Boolean): string;
var
  StrRet: TStrRet;
  P: PChar;
  Flags: Integer;
begin
  Result := '';
  if ForParsing then Flags := SHGDN_FORPARSING
                else Flags := SHGDN_NORMAL;

  ShellFolder.GetDisplayNameOf(PIDL, Flags, StrRet);
  case StrRet.uType of
    STRRET_CSTR:
      SetString(Result, StrRet.cStr, lStrLen(StrRet.cStr));
    STRRET_OFFSET:
      begin
        P := @PIDL.mkid.abID[StrRet.uOffset - SizeOf(PIDL.mkid.cb)];
        SetString(Result, P, PIDL.mkid.cb - StrRet.uOffset);
      end;
    STRRET_WSTR:
      Result := StrRet.pOleStr;
  end;
end;

procedure TraiteLigneCommande;
var
  i: Integer;
begin
  ListOptions.ModeDebug := False;
  for i := 1 to ParamCount do begin
    ListOptions.ModeDebug := LowerCase(ParamStr(i)) = '/debug';
    if ListOptions.ModeDebug then Exit;
  end;
end;

function MenuItem(Texte: string; ClickProc: TNotifyEvent = nil): TMenuItem;
begin
  Result := TMenuItem.Create(PopupMenu);
  with Result do begin
    Caption := Texte;
    OnClick := ClickProc;
  end;
end;

procedure Initialisation;
var
  dummy: array[0..MAX_PATH] of Char;
  FIDesktopFolder: IShellFolder;
  PIDL: PItemIDList;
begin
  TraiteLigneCommande;

  ActiveDesktopEx := CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;
  OLECheck(SHGetDesktopFolder(FIDesktopFolder));
  OLECheck(SHGetSpecialFolderLocation(0, CSIDL_STARTUP, PIDL));
  StartupFolder := GetDisplayName(FIDesktopFolder, PIDL, True);
  if (Length(StartupFolder) > 0) and (StartupFolder[Length(StartupFolder)] <> '\') then StartupFolder := StartupFolder + '\';

  GetWindowsDirectory(dummy, SizeOf(dummy));
  PathWin := IncludeTrailingBackslash(StrPas(dummy));
  if (PathWin <> '') and (PathWin[Length(PathWin)] <> '\') then PathWin := PathWin + '\';

  Randomize;

  PopupMenu := TPopupMenu.Create(nil);
  with PopupMenu.Items, StoreProc do begin
    Add(MenuItem('Changer maintenant', TimerTimer));
    Add(MenuItem('-'));
    Add(MenuItem('Activé', ActiveClick));
    Add(MenuItem('Options', OptionsClick));
    Add(MenuItem('-'));
    Add(MenuItem('Quitter', QuitterClick));
  end;
end;

procedure FinProg;
begin
  FreeAndNil(PopupMenu);
  if ListOptions.Fichiers <> '' then DeleteFile(PChar(ListOptions.Fichiers));
  if Assigned(@NotifyData) then Shell_NotifyIcon(NIM_DELETE, @NotifyData);//retire la petite icône de la barre des taches
end;

procedure ChargeIcon;
begin
  try
    LoadOptions;
  finally
    Application.Title := TitleAPP;
    FlagActif := False;
    NotifyData.cbSize := SizeOf(NotifyData);
    NotifyData.Wnd := Handle;
    NotifyData.uID := 1;
    NotifyData.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
    NotifyData.uCallbackMessage := WM_MYMESSAGE;
    NotifyData.hIcon := Application.Icon.Handle;
    for j := 0 to Length(TitleAPP) - 1 do
      NotifyData.szTip[j] := TitleAPP[j + 1];
    NotifyData.szTip[Length(TitleAPP)] := #0;
    Shell_NotifyIcon(NIM_ADD, @NotifyData);

    LastChange := Now;
    if not ListOptions.ModeDebug and CheckBox3.Checked then ChangeWallPap;
  end;
end;

initialization
  Initialisation;

finalization
  FinProg;

end.
