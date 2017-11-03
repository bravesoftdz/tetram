unit Form_Main;

interface

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, tlhelp32, Registry, Menus, GraphicEx, UInterfacePlugIn,
  ActnList, StdActns, TrayIcon, Divers, ExtCtrls, UnrarComp, ZipMstr, ShellAPI, StdCtrls, ExtDlgs, UOptions, UInterfaceChange, WinInet;

const
  DLLConf = 'WPConf.dll';

type
  ISuspend = interface
  end;
  TSuspend = class(TInterfacedObject, ISuspend)
    FActionList: TActionList;
    constructor Create(ActionList: TActionList);
    destructor Destroy; override;
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

  RPluginCommandes = record
    Plugin: PPlugin;
    IdCommande: Integer;
  end;

  TFond = class(TForm, IChange, IValideImage, IMainProg, IEvenements)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Options1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    Activ1: TMenuItem;
    N2: TMenuItem;
    Changermaintenant1: TMenuItem;
    TrayIcon1: TTrayIcon;
    N3: TMenuItem;
    Supprimercetteimage1: TMenuItem;
    ActionList1: TActionList;
    SupprimerImage: TAction;
    ChangerMaintenant: TAction;
    Options: TAction;
    FileExit1: TAction;
    Unrar1: TUnrar;
    SelectionImage: TAction;
    Slectionneruneimage1: TMenuItem;
    ShowMenu: TAction;
    ZipMaster1: TZipMaster;
    Button1: TButton;
    Label1: TLabel;
    N4: TMenuItem;
    Apropos1: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ChoisirImage: TAction;
    Choisiruneimageautre1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    N5: TMenuItem;
    Vrifierlaversion1: TMenuItem;
    Rafraichir: TAction;
    Rafraichir1: TMenuItem;
    N6: TMenuItem;
    ExecCommandePlugin: TAction;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Restore(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure ChangeWallPap(Declenchement: TChangeType; Actif: Boolean = True; Force: Boolean = False; Image: string = '');
    procedure SupprimerImageExecute(Sender: TObject);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure Activ1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject; Shift: TShiftState);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure ChangerMaintenantExecute(Sender: TObject);
    procedure OptionsExecute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure SelectionImageExecute(Sender: TObject);
    procedure TrayIcon1MouseUp(Sender: TObject; Shift: TShiftState);
    procedure ShowMenuExecute(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure ChoisirImageExecute(Sender: TObject);
    procedure Vrifierlaversion1Click(Sender: TObject);
    procedure RafraichirExecute(Sender: TObject);
    procedure ExecCommandePluginExecute(Sender: TObject);
  private
    { Déclarations privées }
    FDebug: RDebug;
    FOptions: ROptions;

    FFichiersCount: Integer;
    FListFichiers: string;
    FPathTemp: string;
    FlagActif: Boolean;
    FLastChange: TDateTime;
    FHistorique: TStringList;
    HIcon: THandle;
    FCurrentImage, FCurrentArchive, FImage: string;
    FThreadCheckTime: TThreadCheckTime;
    FActionDoubleClick: TAction;

    PluginCommandes: array of RPluginCommandes;

    procedure LoadOptions;
    procedure RefreshIconCaption;
    procedure RestreintHistorique;
    function SSRunning: Boolean;
    procedure BeginTravail;
    procedure EndTravail;
    procedure ChargeListeFichiers;
    procedure CheckStartupLink;
    procedure InitCheckThread;
    procedure ThreadTerminate(Sender: TObject);

    procedure WriteLog(Chaine: string);
    function ExtraitArchive(var Image: string; out Archive, Fichier: string): Boolean;
    function ChooseImage: string;
    function FindActions(Index: Integer): TAction;

    function PluginsForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
    function PluginsCanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
    function PluginsValiderImage(Image: PAnsiChar; Archive: PAnsiChar; var AutreImage: Boolean): Boolean; stdcall;

    // interface IChange
    function IChange.CanChange = PluginsCanChange;
    function IChange.ForceChange = PluginsForceChange;

    // interface IValideImage
    function IValideImage.IsValide = PluginsValiderImage;

    // interface IMainProg
    function OptionsWriter: IOptionsWriter; stdcall;
    procedure RelireOptions(PluginsInclus: Boolean); stdcall;
    procedure ChangerFond(Exclusions: Boolean); stdcall;
    procedure RafraichirFond(Exclusions: Boolean); stdcall;
    procedure ForcerFond(Archive, Image: ShortString; Exclusions: Boolean); stdcall;

    // interface IEvenements
    procedure DemarrageWP; stdcall;
    procedure FermetureWP; stdcall;
    procedure DebutRechercheFond; stdcall;
    procedure FinRechercheFond; stdcall;
    procedure DebutDessinFond(Dessineur: IDessineur); stdcall;
    procedure FinDessinFond(Dessineur: IDessineur); stdcall;
    procedure AvantApplicationNouveauFond; stdcall;
    procedure ApresApplicationNouveauFond; stdcall;

    function PluginForcerImage(var Archive, Fichier: string; out UseHistorique: Boolean): Boolean;
    procedure WriteImageLog(i: Integer; Fichier: string);
    procedure MenuItemExecPluginCommandeClick(Sender: TObject);
    function FindIndexPluginCommande(Ident: string): Integer;
    procedure ExecutePluginCommande(IdPluginCommande: Integer);
    function CheckVersion(ForceMessage: Boolean): Boolean;
  public
    { Déclarations publiques }
  end;

var
  Fond: TFond;

implementation

uses DateUtils, CheckVersionNet, RNDGen, UInterfacePluginCommandes;

{$R *.DFM}

function LoadLibrary(lpLibFileName: PChar): HMODULE;
begin
  Result := Windows.LoadLibrary(PChar(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + ExtractFileName(lpLibFileName)));
  if Result < 32 then
    Result := Windows.LoadLibrary(lpLibFileName);
end;

const
  TitleAPP = 'Teträm Corp - WallPepper';

  { TThreadCheckTime }

procedure TThreadCheckTime.Execute;
begin
  while not Terminated and (Now < FHeurePrevue) do
    Sleep(1000);
  if not Terminated then Synchronize(DoEvent);
end;

procedure TThreadCheckTime.DoEvent;
begin
  if Assigned(FOnCheckTime) then FOnCheckTime(Self);
end;

procedure TFond.ApplicationEvents1Restore(Sender: TObject);
begin
  Application.BringToFront;
end;

procedure TFond.FormCreate(Sender: TObject);

  procedure TraiteLigneCommande;
  begin
    FDebug.ModeDebug := FindCmdLineSwitch('debug');
  end;

var
  dummy: array[0..MAX_PATH] of Char;
  VerifNet: Boolean;
begin
  SetLength(PluginCommandes, 0);

  TraiteLigneCommande;
  ShowWindow(Application.Handle, SW_Hide);

  FDebug.FichierLog := ChangeFileExt(Application.ExeName, '.log');

  Randomize;

  ZeroMemory(@dummy[0], SizeOf(dummy));
  GetTempPath(SizeOf(dummy), dummy);
  FPathTemp := IncludeTrailingPathDelimiter(StrPas(dummy));

  Application.OnRestore := ApplicationEvents1Restore;
  Application.OnException := ApplicationEvents1Exception;

  FHistorique := TStringList.Create;

  FImage := '';

  try
    LoadOptions;
    Activ1.Checked := FOptions.ActiveParDefaut;
  finally
    Application.Title := TitleAPP;
    FlagActif := False;
    with TrayIcon1 do begin
      IconID := 1;
      Icon.Assign(Application.Icon);
      Tip := TitleAPP;
      Refresh;
    end;
    FLastChange := Now;
  end;

  case FOptions.VerifMAJDelai of
    0: // jamais de verification
      VerifNet := False;
    1: // à chaque démarrage
      VerifNet := True;
    2: // une fois par jour
      VerifNet := DaysBetween(Now, FOptions.LastVerifMAJ) > 0;
    3: // une fois par semaine
      VerifNet := WeeksBetween(Now, FOptions.LastVerifMAJ) > 0;
    else // une fois par mois
      VerifNet := MonthsBetween(Now, FOptions.LastVerifMAJ) > 0;
  end;
  if VerifNet then try
    VerifNet := CheckVersion(False);
    WriteIntegerOption('Divers', 'LastVerifMAJ', Trunc(Now));
    if VerifNet then Exit;
  except
  end;

  if not FDebug.ModeDebug and FOptions.ChangerDemarrage then ChangeWallPap(ctAutomatique);

  Icon.Assign(Application.Icon);
  Caption := Application.Title;
  Label3.Caption := 'Version: ' + GetFichierVersion(DLLConf);
end;

procedure TFond.ChargeListeFichiers;

  function IsArchive(Fichier: string): Boolean;
  var
    i: Integer;
    Ext: string;
  begin
    i := 0;
    Result := False;
    Ext := LowerCase(ExtractFileExt(Fichier));
    while not Result and (i < Length(FOptions.Archives)) do begin
      Result := FOptions.Archives[i] = Ext;
      Inc(i);
    end;
  end;

  function FichierBon(Fichier: string): Boolean;
  var
    i: Integer;
    Ext: string;
  begin
    i := 0;
    Result := False;
    Ext := LowerCase(ExtractFileExt(Fichier));
    while not Result and (i < Length(FOptions.Extensions)) do begin
      Result := FOptions.Extensions[i] = Ext;
      Inc(i);
    end;
  end;

var
  FOut: TextFile;

  procedure ScanArchive(Path: string; SousRep: Boolean);
  var
    ext: string;
    i: Integer;
  begin
    ext := LowerCase(ExtractFileExt(Path));
    if ext = '.rar' then begin
      try
        Unrar1.RarFile := Path;
        try
          Unrar1.List;
        except
          on E: ERAROpenException do begin
            ShowMessage('Impossible d''ouvrir ' + Path + #13#10 + Exception(ExceptObject).Message);
            Exit;
          end;
          on E: ERARListException do begin
            ShowMessage('Impossible de lire ' + Path + #13#10 + Exception(ExceptObject).Message);
            Exit;
          end;
          else
            raise;
        end;
        for i := 0 to Pred(Unrar1.RarEntries.Count) do
          with Unrar1.RarEntries[i] do
            if not IsDirectory and (SousRep or (ExtractFilePath(FileName) = '')) and FichierBon(FileName) then begin
              Write(FOut, #1 + FileName + '|' + Path);
              Inc(FFichiersCount);
            end;
      finally
        Unrar1.Close;
      end;
    end
    else if ext = '.zip' then begin
      ZipMaster1.ZipFileName := Path;
      ZipMaster1.FSpecArgs.Clear;
      // ZipMaster1.List;
      for i := 0 to Pred(ZipMaster1.Count) do
        with ZipMaster1.DirEntry[i]^ do
          if (SousRep or (ExtractFilePath(FileName) = '')) and FichierBon(FileName) then begin
            Write(FOut, #1 + FileName + '|' + Path);
            Inc(FFichiersCount);
          end;
    end;
  end;

  procedure Scan(Path: string; SousRep: Boolean);
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
        end
        else if FichierBon(Path + rec.Name) then begin
          Write(FOut, #1 + Path + rec.Name);
          Inc(FFichiersCount);
        end
        else if IsArchive(Path + rec.Name) then
          ScanArchive(Path + rec.Name, True);
        resultat := FindNext(rec);
      end;
      FindClose(rec);
    end;
  end;

var
  i: Integer;
begin
  FListFichiers := ChangeFileExt(Application.ExeName, '.tmp');
  {.$I-}
  AssignFile(FOut, FListFichiers);
  try
    Rewrite(FOut);
    FFichiersCount := 0;
    for i := 0 to Pred(Length(FOptions.Images)) do
      if FOptions.Images[i].Archive then
        ScanArchive(FOptions.Images[i].Chemin, FOptions.Images[i].SousRepertoire)
      else
        Scan(FOptions.Images[i].Chemin, FOptions.Images[i].SousRepertoire);
  finally
    CloseFile(FOut);
  end;
  {.$I+}
end;

function TFond.FindActions(Index: Integer): TAction;
begin
  case Index of
    1: Result := Options;
    2: Result := ChangerMaintenant;
    3: Result := SelectionImage;
    4: Result := Rafraichir;
    5: Result := ExecCommandePlugin;
    else
      Result := nil;
  end;
  Changermaintenant1.Default := Result = ChangerMaintenant;
  Slectionneruneimage1.Default := Result = SelectionImage;
  Options1.Default := Result = Options;
  Rafraichir1.Default := Result = Rafraichir;
end;

function TFond.FindIndexPluginCommande(Ident: string): Integer;
var
  i, Commande: Integer;
begin
  Result := -1;
  Ident := Trim(UpperCase(Ident));
  if Ident = '' then Exit;
  i := LastDelimiter('\', Ident);
  Commande := StrToIntDef(Copy(Ident, Succ(i), Length(Ident)), -1);
  Ident := Copy(Ident, 1, Pred(i));
  if (Trim(Ident) = '') or (Commande = -1) then Exit;
  for i := 0 to Pred(Length(PluginCommandes)) do
    with PluginCommandes[i] do
      if (UpperCase(ExtractFileName(Plugin.Chemin)) = Ident) and Plugin.Actif and (IdCommande = Commande) then begin
        Result := i;
        Exit;
      end;
end;

procedure TFond.ExecutePluginCommande(IdPluginCommande: Integer);
var
  IPC: IInterfacePluginCommandes;
begin
  if not (IdPluginCommande in [0..Length(PluginCommandes)]) then Exit;
  with PluginCommandes[IdPluginCommande].Plugin^ do
    if Actif and not Bool(Plugin.QueryInterface(IInterfacePluginCommandes, IPC)) then
      IPC.ExecuteCommande(PluginCommandes[IdPluginCommande].IdCommande, MainProg.OptionsWriter);
end;

procedure TFond.ExecCommandePluginExecute(Sender: TObject);
begin
  ExecutePluginCommande(FindIndexPluginCommande(FOptions.ActionPluginDoubleClick));
end;

procedure TFond.MenuItemExecPluginCommandeClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then Exit;
  ExecutePluginCommande(TMenuItem(Sender).Tag);
end;

procedure TFond.LoadOptions;
var
  i, IndexMnu, nbCommandes: Integer;
  Commandes: array of RInfoCommande;
  MenuItem: TMenuItem;
  slExtensions: TStringList;
  IPC: IInterfacePluginCommandes;
begin
  UOptions.LoadOptions(FOptions, FDebug, Self);

  SetLength(PluginCommandes, 0);
  IndexMnu := PopupMenu1.Items.IndexOf(N5) + 1;
  while PopupMenu1.Items[IndexMnu] <> N6 do
    PopupMenu1.Items.Delete(IndexMnu);
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IInterfacePluginCommandes, IPC)) then begin
        nbCommandes := 16;
        SetLength(Commandes, nbCommandes);
        IPC.GetCommandes(nbCommandes, Commandes);
        if nbCommandes < 0 then begin
          nbCommandes := -nbCommandes;
          SetLength(Commandes, nbCommandes);
          IPC.GetCommandes(nbCommandes, Commandes);
        end;
        Dec(nbCommandes);
        while nbCommandes > -1 do begin
          MenuItem := TMenuItem.Create(Self);
          MenuItem.Caption := Plugin.GetName + ' -> ' + Commandes[nbCommandes].MenuLabel;
          MenuItem.Tag := Length(PluginCommandes);
          SetLength(PluginCommandes, MenuItem.Tag + 1);
          PluginCommandes[MenuItem.Tag].Plugin := @FOptions.Plugins[i];
          PluginCommandes[MenuItem.Tag].IdCommande := Commandes[nbCommandes].IdCommande;
          MenuItem.OnClick := MenuItemExecPluginCommandeClick;
          MenuItem.Default := MenuItem.Tag = FindIndexPluginCommande(FOptions.ActionPluginDoubleClick);
          PopupMenu1.Items.Insert(IndexMnu, MenuItem);
          Dec(nbCommandes);
        end;
      end;

  if Assigned(FThreadCheckTime) then FThreadCheckTime.Terminate;

  slExtensions := TStringList.Create;
  try
    slExtensions.Clear;
    for i := 0 to Pred(Length(FOptions.Extensions)) do
      slExtensions.Add('*' + FOptions.Extensions[i]);
    slExtensions.Delimiter := ';';
    OpenPictureDialog1.Filter := 'Tous (' + slExtensions.DelimitedText + ')|' + slExtensions.DelimitedText;
  finally
    FreeAndNil(slExtensions);
  end;

  FActionDoubleClick := FindActions(FOptions.ActionDoubleClick);

  Timer1.Interval := FOptions.Interval * 60 * 1000;
  Timer1.Enabled := Bool(Timer1.Interval);

  CheckStartupLink;

  ChargeListeFichiers;
  InitCheckThread;
end;

procedure TFond.Timer1Timer(Sender: TObject);
begin
  if (Sender is TThread) and FDebug.ChangementHeureFixe and FDebug.Effacer then WriteLog('Thread CheckTime - Déclenchement');
  if (Sender is TThread) then
    ChangeWallPap(ctProgramme, Activ1.Checked, not TThreadCheckTime(Sender).FCheckExclusions)
  else
    ChangeWallPap(ctAutomatique, Activ1.Checked);
end;

function TFond.ExtraitArchive(var Image: string; out Archive, Fichier: string): Boolean;
var
  ext: string;
  i: Integer;
begin
  Result := False;
  i := Pos('|', Image);
  Archive := Copy(Image, Succ(i), Length(Image));
  Fichier := Copy(Image, 1, Pred(i));
  ext := LowerCase(ExtractFileExt(Archive));
  if (ext = '.rar') then begin
    try
      Unrar1.RarFile := Archive;
      Unrar1.UsePath := False;
      Unrar1.PathMask := IncludeTrailingPathDelimiter(ExtractFilePath(Fichier));
      Unrar1.FileMask := 'Legendes.txt';
      try
        Unrar1.Extract;
      except
        on E: ERARException do begin
          WriteLog('Lecture du fichier image - ' + E.ClassName + #13#10 + Exception(ExceptObject).Message);
          Exit;
        end;
        else
          raise;
      end;
      Unrar1.FileMask := ChangeFileExt(ExtractFileName(Fichier), '.leg');
      Unrar1.PathDest := FPathTemp + 'WallPepper\';
      try
        Unrar1.Extract;
      except
        on E: ERARException do begin
          WriteLog('Lecture du fichier image - ' + E.ClassName + #13#10 + Exception(ExceptObject).Message);
          Exit;
        end;
        else
          raise;
      end;
      Unrar1.FileMask := ExtractFileName(Fichier);
      Unrar1.PathDest := FPathTemp + 'WallPepper\';
      try
        Unrar1.Extract;
      except
        on E: ERARException do begin
          WriteLog('Lecture du fichier image - ' + E.ClassName + #13#10 + Exception(ExceptObject).Message);
          Exit;
        end;
        else
          raise;
      end;
      Image := Unrar1.PathDest + ExtractFileName(Fichier);
      Result := True;
    finally
      Unrar1.Close;
      Unrar1.FileMask := '';
      Unrar1.PathMask := '';
    end;
  end
  else if (ext = '.zip') then begin
    try
      ZipMaster1.ZipFileName := Archive;
      ZipMaster1.FSpecArgs.Add(Fichier);
      ZipMaster1.FSpecArgs.Add(ChangeFileExt(Fichier, '.*'));
      ZipMaster1.FSpecArgs.Add(ExtractFilePath(Fichier) + 'Legendes.txt');
      ZipMaster1.ExtrBaseDir := FPathTemp + 'WallPepper\';
      ZipMaster1.ExtrOptions := ZipMaster1.ExtrOptions - [ExtrDirNames] + [ExtrForceDirs, ExtrOverWrite];
      ZipMaster1.Extract;
      Image := ZipMaster1.ExtrBaseDir + ExtractFileName(Fichier);
      Result := True;
    finally
      ZipMaster1.ZipFileName := '';
      ZipMaster1.FSpecArgs.Clear;
    end;
  end;
end;

procedure TFond.WriteImageLog(i: Integer; Fichier: string);
begin
  if FDebug.DetailRechercheImage then begin
    if (i <> 0) and (not FileExists(Copy(Fichier, Succ(i), Length(Fichier)))) then
      WriteLog('Fichier image trouvé: ' + Fichier + ' (archive inexistante)')
    else if (i = 0) and (not FileExists(Fichier)) then
      WriteLog('Fichier image trouvé: ' + Fichier + ' (inexistant)')
    else if (FHistorique.IndexOf(Fichier) <> -1) then
      WriteLog('Fichier image trouvé: ' + Fichier + ' (dans l''historique)')
    else
      WriteLog('Fichier image trouvé: ' + Fichier);
  end;
end;

function TFond.ChooseImage: string;
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
    while s[m] in ['"', #13, #10] do
      Dec(m);
    SetLength(s, m);
    if s[1] = '"' then s := Copy(s, 2, Length(s));

    Fichier := s;
  end;

  function ChercheFichier: string;
  begin
    m := FileSize(F);
    //    p := Random(m);
    p := GetRNDInt(m);
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

var
  Fichier: string;
  i: Integer;
begin
  AssignFile(F, FListFichiers);
  Reset(F);
  try
    repeat
      Fichier := ChercheFichier;
      i := Pos('|', Fichier);
      WriteImageLog(i, Fichier);
    until not ((((i <> 0) and (not FileExists(Copy(Fichier, Succ(i), Length(Fichier))))) or ((i = 0) and (not FileExists(Fichier)))) or ((FHistorique.Count < FFichiersCount) and (FHistorique.IndexOf(Fichier) <> -1)));
  finally
    CloseFile(F);
  end;
  Result := Fichier;
end;

procedure TFond.ChangeWallPap(Declenchement: TChangeType; Actif: Boolean = True; Force: Boolean = False; Image: string = '');
type
  TChangeWallPap = function(Image, LogFile: PChar; Declenchement: TChangeType; MainProg: IMainProg): Boolean; stdcall;

const
  Working: Boolean = False;
var
  Suspend: ISuspend;
  i, Boucle: Integer;
  hdl: THandle;
  fChangeWallPap: TChangeWallPap;
  Archive, Fichier: string;
  ChercherAutreImage: Boolean;
  isSSRunning, UseHistorique: Boolean;
begin
  Suspend := TSuspend.Create(ActionList1);
  if Working then Exit;
  BeginTravail;
  Working := True;
  try
    if not Actif then Exit;
    isSSRunning := not Force and SSRunning;
    if (isSSRunning or not (Self as IChange).CanChange(Declenchement, isSSRunning)) and not (FDebug.ModeDebug or Force or (Self as IChange).ForceChange(Declenchement, isSSRunning)) then Exit;
    hdl := LoadLibrary(DLLConf);
    if hdl >= 32 then try
      fChangeWallPap := GetProcAddress(hdl, 'ChangeWallPap');
      if not Assigned(fChangeWallPap) then raise Exception.Create(DLLConf + ' est invalide.');
      if Image <> '' then begin
        i := Pos('|', Image);
        Archive := Copy(Image, Succ(i), Length(Image));
        Fichier := Copy(Image, 1, Pred(i));
      end;
      if PluginForcerImage(Archive, Fichier, UseHistorique) then begin
        Boucle := 0;
        Image := Fichier;
        if Archive <> '' then Image := Archive + '|' + Fichier;
        i := Pos('|', Image);
        while UseHistorique do begin
          // demander une image tant que celle retournée est présente dans l'historique
          WriteImageLog(i, Image);
          if not ((((i <> 0) and (not FileExists(Fichier))) or ((i = 0) and (not FileExists(Image)))) or ((FHistorique.Count < FFichiersCount) and (FHistorique.IndexOf(Image) <> -1))) then Break;
          // limiter à X recherches pour éviter les boucles infinies
          Inc(Boucle);
          if (Boucle > 10) or not PluginForcerImage(Archive, Fichier, UseHistorique) then Exit;
          Image := Fichier;
          if Archive <> '' then Image := Archive + '|' + Fichier;
          i := Pos('|', Image);
        end;
        i := 0;
      end
      else begin
        (Self as IEvenements).DebutRechercheFond;
        try
          UseHistorique := True;
          if not FileExists(FListFichiers) then ChargeListeFichiers;
          if not Bool(FFichiersCount) then Exit;
          if Image = '' then Image := ChooseImage;
          ChercherAutreImage := True;
          repeat
            if not ChercherAutreImage then Exit;
            i := Pos('|', Image);
            Archive := Copy(Image, Succ(i), Length(Image));
            Fichier := Copy(Image, 1, Pred(i));
          until PluginsValiderImage(PChar(Fichier), PChar(Archive), ChercherAutreImage);
        finally
          (Self as IEvenements).FinRechercheFond;
        end;
      end;
      if Image = '' then Exit;
      if UseHistorique then begin
        FHistorique.Add(Image);
        RestreintHistorique;
      end;
      if ((i = 0) or ExtraitArchive(Image, Archive, Fichier)) and fChangeWallPap(PChar(Image), PChar(FDebug.FichierLog), Declenchement, Self) then begin
        if (i <> 0) then begin
          FCurrentArchive := Archive;
          FCurrentImage := Fichier;
          FImage := FCurrentImage + '|' + FCurrentArchive;
        end
        else begin
          FCurrentArchive := '';
          FCurrentImage := Image;
          FImage := Image;
        end;
      end;
      if (i <> 0) then begin
        DeleteFile(Image);
        DeleteFile(ChangeFileExt(Image, '.leg'));
        DeleteFile(ExtractFilePath(Image) + 'Legendes.txt');
        RemoveDir(ExtractFilePath(Image));
      end;
      InitCheckThread;
    finally
      FreeLibrary(hdl);
    end
    else
      RaiseLastOSError;
  finally
    Working := False;
    EndTravail;
  end;
end;

procedure TFond.FormDestroy(Sender: TObject);
begin
  (Self as IEvenements).FermetureWP;
  SetLength(PluginCommandes, 0);
  UnloadPlugins(FOptions.Plugins);
  TrayIcon1.Active := False;
  if FileExists(FListFichiers) then DeleteFile(FListFichiers);
  FHistorique.Free;
end;

procedure TFond.Quitter1Click(Sender: TObject);
begin
  Close;
end;

procedure TFond.RefreshIconCaption;

  function MyEncodeTime(Minutes: Integer): TDateTime;
  begin
    Result := EncodeTime(Minutes div 60, Minutes mod 60, 0, 0);
  end;

var
  Chaine: string;
  TempsRestant, FinThread, FinTimer, Fin: TDateTime;
begin
  Chaine := TitleAPP;
  FinThread := -1;
  FinTimer := -1;
  if Assigned(FThreadCheckTime) then
    FinThread := FThreadCheckTime.FHeurePrevue;
  if Timer1.Enabled then
    FinTimer := FLastChange + MyEncodeTime(FOptions.Interval);
  if (FinTimer > FinThread) and (FinThread <> -1) then
    Fin := FinThread
  else
    Fin := FinTimer;

  if Fin > -1 then begin
    TempsRestant := Fin - Now;
    Chaine := Chaine + ' - Temps restant: ' + TimeToStr(TempsRestant);
  end;
  if not Activ1.Checked then Chaine := Chaine + ' - Désactivé';
  TrayIcon1.Tip := Chaine;
end;

procedure TFond.RestreintHistorique;
begin
  while FHistorique.Count > MulDiv(FOptions.TailleHistorique, FFichiersCount, 100) do
    FHistorique.Delete(0);
end;

type
  PSearchWindowsName = ^RSearchWindowsName;
  RSearchWindowsName = record
    FenetreTrouvee: Boolean;
    ProcessChild: Boolean;
    Form: TFond;
  end;

function EnumWindowsProc(hwnd: HWND; lParam: LPARAM): Bool; stdcall; export;
var
  Buffer: array[0..1023] of Char;
  i: Integer;
  SearchWindowsName: PSearchWindowsName;
  SearchChildWindowsName: RSearchWindowsName;
begin
  SearchWindowsName := Pointer(lParam);
  SearchWindowsName.FenetreTrouvee := False;

  if GetWindowText(hwnd, @Buffer, 1024) > 0 then begin
    i := 0;
    while (not SearchWindowsName.FenetreTrouvee) and (i < Length(SearchWindowsName.Form.FOptions.Exclusions)) do begin
      with SearchWindowsName.Form.FOptions.Exclusions[i] do
        if (not Process) and (SearchWindowsName.ProcessChild or Repertoire) then begin
          SearchWindowsName.FenetreTrouvee := SameText(Buffer, Chemin);
          if SearchWindowsName.FenetreTrouvee then SearchWindowsName.Form.WriteLog('Exclu trouvée: ' + Chemin);
        end;
      Inc(i);
    end;

    if (not SearchWindowsName.FenetreTrouvee) and (SearchWindowsName.ProcessChild) then begin
      SearchChildWindowsName.FenetreTrouvee := False;
      SearchChildWindowsName.Form := SearchWindowsName.Form;
      SearchChildWindowsName.ProcessChild := False;

      EnumChildWindows(hwnd, @EnumWindowsProc, Integer(@SearchChildWindowsName));
      SearchWindowsName.FenetreTrouvee := SearchChildWindowsName.FenetreTrouvee;
    end;
  end;

  Result := not SearchWindowsName.FenetreTrouvee;
end;

function TFond.SSRunning: Boolean;

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
  ScreenSave: string;
  HdlSnapshotSystem, HdlSnapshotProcess: LongInt;
  pe32: PROCESSENTRY32;
  me32: MODULEENTRY32;

  function ContinueScan(Fichier: string; Level: Integer = 0): Boolean;
  var
    i: Integer;
  begin
    if FDebug.ListeProcess and FDebug.ListeProcessDetail then
      if Level = 1 then begin
        WriteLog('me32.szModule: ' + StrPas(me32.szModule));
        WriteLog('me32.szExePath: ' + Fichier);
      end
      else begin
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
    for i := 0 to Pred(Length(FOptions.Exclusions)) do
      with FOptions.Exclusions[i] do
        if Process then begin
          if Repertoire then
            Result := Copy(ExtractLongPathName(Fichier), 1, Length(Chemin)) <> Chemin
          else
            Result := ExtractLongPathName(Fichier) <> Chemin;
          if not Result then Break;
        end;
    if not Result then begin
      WriteLog('Exclu trouvée: ' + Fichier);
      Exit;
    end;
  end;

var
  HasWindowSearch: Boolean;
  i: Integer;
  SearchWindowsName: RSearchWindowsName;
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
      if FDebug.ListeProcess then WriteLog('Modules en exécution:');
      if Process32First(HdlSnapshotSystem, pe32) then
        repeat
          if FDebug.ListeProcess then WriteLog(StrPas(pe32.szExeFile));
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

    if not Result then begin
      HasWindowSearch := False;
      i := 0;
      while (not HasWindowSearch) and (i < Length(FOptions.Exclusions)) do begin
        HasWindowSearch := not FOptions.Exclusions[i].Process;
        Inc(i);
      end;

      if HasWindowSearch then begin
        SearchWindowsName.FenetreTrouvee := False;
        SearchWindowsName.Form := Self;
        SearchWindowsName.ProcessChild := True;

        EnumWindows(@EnumWindowsProc, Integer(@SearchWindowsName));

        Result := SearchWindowsName.FenetreTrouvee;
      end;
    end;
  except
    Result := False;
  end;
  if not Result then WriteLog('Economiseur non trouvé');
end;

procedure TFond.BeginTravail;
begin
  if FDebug.GenereFichierLog and FDebug.Effacer and FileExists(FDebug.FichierLog) then DeleteFile(FDebug.FichierLog);
  WriteLog('BeginTravail - ' + DateTimeToStr(Now));
  if HIcon = 0 then HIcon := LoadIcon(hInstance, 'TRAVAIL');
  TrayIcon1.Icon.Handle := HIcon;
end;

procedure TFond.EndTravail;
begin
  TrayIcon1.Icon.Assign(Application.Icon);
  FLastChange := Now;
  WriteLog('FinTravail - ' + DateTimeToStr(Now) + #13#10);
end;

procedure TFond.CheckStartupLink;
begin
  with TRegistry.Create do try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
      if FOptions.DemarrageWindows then
        WriteString('WallPepper', Application.ExeName)
      else
        DeleteValue('WallPepper');
  finally
    Free;
  end;
end;

procedure TFond.WriteLog(Chaine: string);
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

procedure TFond.SupprimerImageExecute(Sender: TObject);
begin
  if MessageDlg('Êtes-vous sûr de vouloir supprimer le fichier:'#13 + FCurrentImage, mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  DeleteFile(FCurrentImage);
  if FileExists(FListFichiers) then DeleteFile(FListFichiers);
  ChangerMaintenant.Execute;
end;

procedure TFond.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState);
begin
  RefreshIconCaption;
end;

procedure TFond.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  SupprimerImage.Enabled := (FCurrentArchive = '') and FileExists(FCurrentImage);
  Rafraichir.Enabled := (FImage <> '');
end;

procedure TFond.Activ1Click(Sender: TObject);
begin
  if Assigned(FThreadCheckTime) then
    if Activ1.Checked then
      FThreadCheckTime.Resume
    else
      FThreadCheckTime.Suspend;
end;

procedure TFond.InitCheckThread;
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
  if FDebug.ChangementHeureFixe then WriteLog('Thread CheckTime - Initialisation');
  if Assigned(FThreadCheckTime) then FThreadCheckTime.Terminate;
  CheckExclusions := True;
  if Bool(Length(FOptions.HorairesFixe)) then begin
    Found := False;
    i := 0;
    while not Found and (i <= Pred(Length(FOptions.HorairesFixe))) do begin
      if FOptions.HorairesFixe[i].Heure <> -1 then begin
        TimeCheck := FOptions.HorairesFixe[i].Heure;
        MakeTime;
        Found := TimeCheck > Now;
        if Found then CheckExclusions := FOptions.HorairesFixe[i].Exclusions;
      end;
      Inc(i);
    end;

    if not Found then begin
      if FDebug.ChangementHeureFixe then WriteLog('Thread CheckTime - Not found');
      TimeCheck := FOptions.HorairesFixe[0].Heure;
      MakeTime;
      TimeCheck := IncDay(TimeCheck);
      CheckExclusions := FOptions.HorairesFixe[0].Exclusions;
    end;

    if FDebug.ChangementHeureFixe then WriteLog('Thread CheckTime - ' + DateTimeToStr(TimeCheck));
    FThreadCheckTime := TThreadCheckTime.Create(True);
    FThreadCheckTime.FreeOnTerminate := True;
    FThreadCheckTime.OnTerminate := ThreadTerminate;
    FThreadCheckTime.FOnCheckTime := Timer1Timer;
    FThreadCheckTime.FHeurePrevue := TimeCheck;
    FThreadCheckTime.FCheckExclusions := CheckExclusions;
    if Activ1.Checked then FThreadCheckTime.Resume;
  end
  else if FDebug.ChangementHeureFixe then
    WriteLog('Thread CheckTime - Pas d''horaires');

  if FDebug.ChangementHeureFixe then WriteLog('Thread CheckTime - OK');
end;

procedure TFond.ThreadTerminate(Sender: TObject);
begin
  if FThreadCheckTime = Sender then FThreadCheckTime := nil;
end;

procedure TFond.TrayIcon1DblClick(Sender: TObject; Shift: TShiftState);
begin
  if (ssLeft in Shift) and Assigned(FActionDoubleClick) then FActionDoubleClick.Execute;
end;

procedure TFond.ApplicationEvents1Exception(Sender: TObject; E: Exception);
var
  FOut: TextFile;
begin
  try
    {.$I-}
    AssignFile(FOut, ChangeFileExt(Application.ExeName, '.except'));
    try
      try
        Append(FOut);
      except
        Rewrite(FOut);
      end;
      Writeln(FOut, 'Exception: ' + E.ClassName);
      Writeln(FOut, E.Message);
    finally
      CloseFile(FOut);
    end;
    {.$I+}
  except
  end;
  WriteLog('Exception: ' + E.ClassName);
  WriteLog(E.Message);
  ApplicationShowException(E);
end;

procedure TFond.ChangerMaintenantExecute(Sender: TObject);
begin
  ChangerFond(False);
end;

procedure TFond.OptionsExecute(Sender: TObject);
type
  TChangeOptions = function(ModeDebug: Boolean; Image: PChar; MainProg: IMainProg): Boolean; stdcall;
var
  hdl: THandle;
  fChangeOptions: TChangeOptions;
  Suspend: ISuspend;
begin
  Suspend := TSuspend.Create(ActionList1);
  SetForegroundWindow(Handle);
  hdl := LoadLibrary(DLLConf);
  if hdl >= 32 then try
    fChangeOptions := GetProcAddress(hdl, 'ChangeOptions');
    if not Assigned(fChangeOptions) then raise Exception.Create(DLLConf + ' est invalide.');
    if fChangeOptions(FDebug.ModeDebug, PChar(FImage), Self) then begin
      RelireOptions(True);
      RafraichirFond(False);
    end;
  finally
    FreeLibrary(hdl);
  end
  else
    RaiseLastOSError;
end;

{ TSuspend }

constructor TSuspend.Create(ActionList: TActionList);
begin
  FActionList := ActionList;
  FActionList.State := asSuspended;
end;

destructor TSuspend.Destroy;
begin
  FActionList.State := asNormal;
  inherited;
end;

procedure TFond.FileExit1Execute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFond.SelectionImageExecute(Sender: TObject);
type
  TSelectImage = function(Liste: PChar; var Image, Archive: array of Char; MainProg: IMainProg): Boolean; stdcall;
var
  hdl: THandle;
  fSelectImage: TSelectImage;
  Suspend: ISuspend;
  Archive, Fichier: array[0..MAX_PATH] of Char;
  Image: string;
begin
  Suspend := TSuspend.Create(ActionList1);
  SetForegroundWindow(Handle);
  hdl := LoadLibrary(DLLConf);
  if hdl >= 32 then try
    fSelectImage := GetProcAddress(hdl, 'SelectImage');
    if not Assigned(fSelectImage) then raise Exception.Create(DLLConf + ' est invalide.');
    ZeroMemory(@Fichier[0], SizeOf(Fichier));
    ZeroMemory(@Archive[0], SizeOf(Archive));
    if fSelectImage(PChar(FListFichiers), Fichier, Archive, Self) then begin
      if StrPas(Archive) <> '' then
        Image := StrPas(Fichier) + '|' + StrPas(Archive)
      else
        Image := StrPas(Fichier);
      if Image = '' then Image := FImage;
      ChangeWallPap(ctManuel, True, True, Image);
    end;
  finally
    FreeLibrary(hdl);
  end
  else
    RaiseLastOSError;
end;

procedure TFond.TrayIcon1MouseUp(Sender: TObject; Shift: TShiftState);
begin
  if (ssRight in Shift) then ShowMenu.Execute;
end;

procedure TFond.ShowMenuExecute(Sender: TObject);
begin
  SetForegroundWindow(Handle);
  PopupMenu1.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;

procedure TFond.Apropos1Click(Sender: TObject);
begin
  ShowModal;
end;

procedure TFond.Label4Click(Sender: TObject);
begin
  ShellExecute(0, '', PChar(Label4.Caption), nil, nil, SW_NORMAL);
end;

procedure TFond.ChoisirImageExecute(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then ChangeWallPap(ctManuel, True, True, OpenPictureDialog1.FileName);
end;

function TFond.PluginsCanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean;
var
  i: Integer;
  IC: IChange;
begin
  Result := True;
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IChange, IC)) then begin
        Result := IC.CanChange(Declenchement, Exclusion);
        if not Result then begin
          WriteLog('Changement refusé par le plugin ' + Plugin.GetName);
          Break;
        end;
      end;
end;

function TFond.PluginsForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean;
var
  i: Integer;
  IC: IChange;
begin
  Result := False;
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IChange, IC)) then begin
        Result := IC.ForceChange(Declenchement, Exclusion);
        if Result then begin
          WriteLog('Changement forcé par le plugin ' + Plugin.GetName);
          Break;
        end;
      end;
end;

function TFond.PluginsValiderImage(Image: PAnsiChar; Archive: PAnsiChar; var AutreImage: Boolean): Boolean; stdcall;
var
  i: Integer;
  IVI: IValideImage;
begin
  Result := True;
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IValideImage, IVI)) then begin
        Result := IVI.IsValide(Image, Archive, AutreImage);
        if not Result then begin
          if FDebug.DetailRechercheImage then WriteLog('Image refusée par le plugin ' + Plugin.GetName);
          Break;
        end;
      end;
end;

function TFond.PluginForcerImage(var Archive, Fichier: string; out UseHistorique: Boolean): Boolean;
var
  i: Integer;
  sArchive, sFichier: ShortString;
  IFI: IForceImage;
begin
  Result := False;
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IForceImage, IFI)) then begin
        sArchive := Archive;
        sFichier := Fichier;
        Result := IFI.ForceImage(sFichier, sArchive, UseHistorique);
        if Result then begin
          Archive := sArchive;
          Fichier := sFichier;
          WriteLog('Image imposée par le plugin ' + Plugin.GetName);
          Break;
        end;
      end;
end;

procedure TFond.Vrifierlaversion1Click(Sender: TObject);
begin
  CheckVersion(True);
end;

function TFond.CheckVersion(ForceMessage: Boolean): Boolean;
begin
  Result := CheckVersionNet.CheckVersion(TitleAPP, 'wallpepper', GetFichierVersion(DLLConf), ForceMessage, not ForceMessage) = 1;
end;

function TFond.OptionsWriter: IOptionsWriter;
var
  Old: Boolean;
begin
  Result := GetIni(Old);
end;

procedure TFond.RelireOptions(PluginsInclus: Boolean);
var
  i: Integer;
  IC: IConfiguration;
begin
  LoadOptions;
  if PluginsInclus then begin
    for i := 0 to Pred(Length(FOptions.Plugins)) do
      with FOptions.Plugins[i] do
        if Actif and not Bool(Plugin.QueryInterface(IConfiguration, IC)) then
          IC.RelireOptions(MainProg.OptionsWriter);
  end;
end;

procedure TFond.ChangerFond(Exclusions: Boolean);
begin
  ChangeWallPap(ctManuel, True, not Exclusions);
end;

procedure TFond.RafraichirFond(Exclusions: Boolean);
begin
  ChangeWallPap(ctManuel, True, not Exclusions, FImage);
end;

procedure TFond.ForcerFond(Archive, Image: ShortString; Exclusions: Boolean);
var
  Fichier: string;
begin
  Fichier := Image;
  if Archive <> '' then Fichier := Archive + '|' + Image;
  ChangeWallPap(ctManuel, True, not Exclusions, Fichier);
end;

procedure TFond.ApresApplicationNouveauFond;
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.ApresApplicationNouveauFond;
end;

procedure TFond.AvantApplicationNouveauFond;
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.AvantApplicationNouveauFond;
end;

procedure TFond.DebutDessinFond(Dessineur: IDessineur);
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.DebutDessinFond(Dessineur);
end;

procedure TFond.DebutRechercheFond;
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.DebutRechercheFond;
end;

procedure TFond.DemarrageWP;
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.DemarrageWP;
end;

procedure TFond.FermetureWP;
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.FermetureWP;
end;

procedure TFond.FinDessinFond(Dessineur: IDessineur);
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.FinDessinFond(Dessineur);
end;

procedure TFond.FinRechercheFond;
var
  i: Integer;
  IE: IEvenements;
begin
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    with FOptions.Plugins[i] do
      if Actif and not Bool(Plugin.QueryInterface(IEvenements, IE)) then
        IE.FinRechercheFond;
end;

procedure TFond.RafraichirExecute(Sender: TObject);
begin
  RafraichirFond(False);
end;

end.

