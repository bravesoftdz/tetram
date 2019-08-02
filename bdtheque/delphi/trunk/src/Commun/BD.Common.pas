unit BD.Common;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  System.SysUtils, Winapi.Windows, VCL.Forms, System.Classes, System.IOUtils, Divers,
  sevenzip;

const
  TitreApplication = 'BDthèque';
  CopyrightTetramCorp = 'Copyright © Teträm Corp';

const
  // Error codes are 32-bit values (bit 31 is the most significant bit). Bit 29 is reserved for application-defined error
  // codes; no system error code has this bit set. If you are defining an error code for your application, set this bit to
  // indicate that the error code has been defined by your application and to ensure that your error code does not
  // conflict with any system-defined error codes.
  UserDefinedErrorCode = $20000000;
  ScriptRunOK = UserDefinedErrorCode or 1;
  ScriptRunOKNoImport = UserDefinedErrorCode or 2;
  ScriptRunError = UserDefinedErrorCode or 3;
  ScriptCompileError = UserDefinedErrorCode or 4;

type
  TSiteWeb = class
  public
    Adresse: string;
    Cle: string;
    Modele: string;
    MySQLServeur: string;
    MySQLBDD: string;
    MySQLLogin: string;
    MySQLPassword: string;
    MySQLPrefix: string;
    BddVersion: string;
    Paquets: Integer;

    procedure Assign(ASite: TSiteWeb);
  end;

  TOptions = class
    FicheAlbumWithCouverture, FicheParaBDWithImage, ModeDemarrage, Images: Boolean;
    SymboleMonnetaire: string;
    AntiAliasing: Boolean;
    ImagesStockees: Boolean;
    AvertirPret: Boolean;
    GrandesIconesMenus, GrandesIconesBarre: Boolean;
    VerifMAJDelai: Integer;
    LastVerifMAJ: TDateTime;
    SerieObligatoireAlbums, SerieObligatoireParaBD: Boolean;
    FormatTitreAlbum: Integer;
    AfficheNoteListes: Boolean;
  end;

  TModeConsult = (mdLoad, mdConsult, mdEdit, mdEditing, mdEntretien, mdImportation, mdExportation, mdScript);

type
  TGlobalVar = class
  private
    class var FOptions: TOptions;
    class var FExeVersion: TVersionNumber;
    class var FAppVersion: TVersionNumber;
    class var FSQLSettings: TFormatSettings;
    class var FMode_en_cours: TModeConsult;
    class var FServerSynchro: TSiteWeb;
    class var FSiteWeb: TSiteWeb;
    class var FRepImages: string;
    class var FDatabaseRole: string;
    class var FFichierIni: string;
    class var FRessourcePic: string;
    class var FHandleDLLPic: Integer;
    class var FTempPath: string;
    class var FRepWebServer: string;
    class var FDatabasePassword: string;
    class var FDatabaseLibraryName: string;
    class var FDatabaseUserName: string;
    class var FDatabasePath: string;
    class var FCommonAppData: string;
    class var FAppData: string;
    class var FFormatPourcent: string;

    class procedure EmptyTempPath; static;
    class procedure InitPath; static;
    class procedure ReadIniFile; static;
  public
    class constructor Create;
    class destructor Destroy;

    class property AppData: string read FAppData;
    class property CommonAppData: string read FCommonAppData;
    class property DatabasePath: string read FDatabasePath write FDatabasePath;
    class property DatabaseUserName: string read FDatabaseUserName;
    class property DatabasePassword: string read FDatabasePassword;
    class property DatabaseRole: string read FDatabaseRole;
    class property DatabaseLibraryName: string read FDatabaseLibraryName;
    class property TempPath: string read FTempPath;
    class property RepImages: string read FRepImages write FRepImages;
    class property RepWebServer: string read FRepWebServer;
    class property RessourcePic: string read FRessourcePic;
    class property HandleDLLPic: Integer read FHandleDLLPic write FHandleDLLPic;
    class property FichierIni: string read FFichierIni;
    class property FormatPourcent: string read FFormatPourcent;

    class property Mode_en_cours: TModeConsult read FMode_en_cours write FMode_en_cours;
    class property Options: TOptions read FOptions;
    class property SiteWeb: TSiteWeb read FSiteWeb;
    class property ServerSynchro: TSiteWeb read FServerSynchro;
    class property ExeVersion: TVersionNumber read FExeVersion write FExeVersion;
    class property AppVersion: TVersionNumber read FAppVersion write FAppVersion;
    class property SQLSettings: TFormatSettings read FSQLSettings;
  end;

implementation

uses
  Winapi.ShellAPI, Winapi.SHFolder, System.IniFiles, System.StrUtils, JclWin32,
  Winapi.AccCtrl;

{ TGlobalVar }

class constructor TGlobalVar.Create;
begin
  FOptions := TOptions.Create;
  FServerSynchro := TSiteWeb.Create;
  FSiteWeb := TSiteWeb.Create;

  FAppData := 'TetramCorp\BDTheque\';
  FCommonAppData := 'TetramCorp\BDTheque\';
  FDatabasePath := 'bd.gdb';
  FDatabaseUserName := 'SYSDBA';
  FDatabasePassword := 'masterkey';
  FDatabaseRole := 'ReadOnly'; // AllAccess
  FDatabaseLibraryName := 'fbembed.dll';
  FTempPath := 'TC_BDTK';
  FRepImages := 'Images\';
  FRepWebServer := 'WebServer\';
  FRessourcePic := 'BDPic.dll';
  FHandleDLLPic := 0;
  FFichierIni := 'Bd.ini';
  FFormatPourcent := '';

  FSQLSettings := TFormatSettings.Create('en-US');
  FSQLSettings.ShortDateFormat := 'YYYY-MM-DD';
  FSQLSettings.ShortTimeFormat := 'HH:mm:ss:zzz';
  FSQLSettings.LongTimeFormat := 'HH:mm:ss:zzz';
  FSQLSettings.DateSeparator := '-';
  FSQLSettings.TimeSeparator := ':';

  InitPath;
  FFormatPourcent := '%d (%f%%)';
  ExeVersion := GetFichierVersion(TPath.GetLibraryPath);
  AppVersion := Format('%d.%d', [ExeVersion.MajorVersion, ExeVersion.MinorVersion]);
  ReadIniFile;
end;

class destructor TGlobalVar.Destroy;
begin
  EmptyTempPath;

  FOptions.Free;
  FServerSynchro.Free;
  FSiteWeb.Free;

  if HandleDLLPic <> 0 then
    FreeLibrary(HandleDLLPic);
end;

class procedure TGlobalVar.InitPath;
var
  buffer: array [0..MAX_PATH] of Char;
  parentPath: string;
begin
  FTempPath := TPath.Combine(TPath.GetTempPath, FTempPath);
  TDirectory.CreateDirectory(FTempPath);
  EmptyTempPath;

  FCommonAppData := TPath.Combine(TPath.GetPublicPath, CommonAppData);
  TDirectory.CreateDirectory(FCommonAppData);

  FAppData := TPath.Combine(TPath.GetHomePath, FAppData);
  TDirectory.CreateDirectory(FAppData);

  // si le fichier ini est dans le répertoire parent de l'exe (correspond à la version de développement)
  // alors on utilise les anciennes valeurs par défaut
  parentPath := TDirectory.GetParent(TPath.GetDirectoryName(TPath.GetLibraryPath));
  if TFile.Exists(TPath.Combine(parentPath, FichierIni)) then
  begin
    FFichierIni := TPath.Combine(parentPath, FFichierIni);
    FDatabasePath := TPath.Combine(parentPath, FDatabasePath);
    FRepImages := TPath.Combine(parentPath, FRepImages);
    FRepWebServer := TPath.Combine(parentPath, FRepWebServer);
  end
  else
  begin
    FFichierIni := TPath.Combine(AppData, FFichierIni);
    FDatabasePath := TPath.Combine(AppData, FDatabasePath);
    FRepImages := TPath.Combine(AppData, FRepImages);
    FRepWebServer := TPath.Combine(CommonAppData, FRepWebServer);
  end;
end;

class procedure TGlobalVar.EmptyTempPath;
var
  op: _SHFILEOPSTRUCT;
begin
  op.Wnd := INVALID_HANDLE_VALUE;
  op.wFunc := FO_DELETE;
  op.pFrom := PChar(TPath.Combine(TGlobalVar.TempPath, '*'));
  op.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI;
  SHFileOperation(op);
end;

class procedure TGlobalVar.ReadIniFile;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FichierIni);
  try
    FDatabasePath := ini.ReadString('Database', 'Database', FDatabasePath);
    FDatabaseUserName := ini.ReadString('Database', 'UserName', FDatabaseUserName);
    FDatabasePassword := ini.ReadString('Database', 'Password', FDatabasePassword);
    FDatabaseRole := ini.ReadString('Database', 'Role', FDatabaseRole);
    FDatabaseLibraryName := ini.ReadString('Database', 'LibraryName', DatabaseLibraryName);
    FRepImages := IncludeTrailingPathDelimiter(ini.ReadString('DIVERS', 'RepImages', FRepImages));
    FRepWebServer := IncludeTrailingPathDelimiter(ini.ReadString('DIVERS', 'WebServer', FRepWebServer));

    TGlobalVar.Options.VerifMAJDelai := ini.ReadInteger('Divers', 'VerifMAJDelai', 4);
    TGlobalVar.Options.LastVerifMAJ := ini.ReadInteger('Divers', 'LastVerifMAJ', 0);
  finally
    ini.Free;
  end;
end;

{ TSiteWeb }

procedure TSiteWeb.Assign(ASite: TSiteWeb);
begin
  Adresse := ASite.Adresse;
  Cle := ASite.Cle;
  Modele := ASite.Modele;
  MySQLServeur := ASite.MySQLServeur;
  MySQLBDD := ASite.MySQLBDD;
  MySQLLogin := ASite.MySQLLogin;
  MySQLPassword := ASite.MySQLPassword;
  MySQLPrefix := ASite.MySQLPrefix;
  BddVersion := ASite.BddVersion;
  Paquets := ASite.Paquets;
end;

initialization
{$IFDEF WIN32}
  SevenzipLibraryName := '7z_x86.dll';
{$ENDIF}
{$IFDEF WIN64}
  SevenzipLibraryName := '7z_x64.dll';
{$ENDIF}

end.
