unit CommonConst;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  System.SysUtils, Winapi.Windows, VCL.Forms, System.Classes, System.IOUtils, Divers,
  sevenzip;

var
  AppData: string = 'TetramCorp\BDTheque\';
  CommonAppData: string = 'TetramCorp\BDTheque\';
  DatabasePath: string = 'bd.gdb';
  DatabaseUserName: string = 'SYSDBA';
  DatabasePassword: string = 'masterkey';
  DatabaseRole: string = 'ReadOnly'; // AllAccess
  DatabaseLibraryName: string = 'fbembed.dll';
  TempPath: string = 'TC_BDTK';
  RepImages: string = 'Images\';
  RepWebServer: string = 'WebServer\';
  RepScripts: string = 'Scripts\';
  FileScriptsOptions: string = 'Scripts.opt';
  FileScriptsMetadata: string = '';
  RessourcePic: string = 'BDPic.dll';
  HandleDLLPic: Integer = 0;
  FichierIni: string = 'Bd.ini';
  FormatPourcent: string = '';

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
  RSiteWeb = record
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
  end;

  ROptions = record
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
    SiteWeb, ServerSynchro: RSiteWeb;
    AfficheNoteListes: Boolean;
  end;

  RUtilisateur = record
    Options: ROptions;
    ExeVersion, AppVersion: TVersionNumber;
  end;

  TModeConsult = (mdLoad, mdConsult, mdEdit, mdEditing, mdEntretien, mdImportation, mdExportation, mdScript);

type
  TGlobalVar = class
  public
    class var Mode_en_cours: TModeConsult;
    class var Utilisateur: RUtilisateur;
    class var SQLSettings: TFormatSettings;

    class constructor Create;
  end;

implementation

uses
  Winapi.ShellAPI, Winapi.SHFolder, System.IniFiles, System.StrUtils, JclWin32,
  Winapi.AccCtrl;

procedure EmptyTempPath;
var
  op: _SHFILEOPSTRUCT;
begin
  op.Wnd := INVALID_HANDLE_VALUE;
  op.wFunc := FO_DELETE;
  op.pFrom := PChar(TPath.Combine(TempPath, '*'));
  op.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI;
  SHFileOperation(op);
end;

procedure InitPath;
var
  buffer: array [0 .. MAX_PATH] of Char;
  parentPath: string;
begin
  TempPath := TPath.Combine(TPath.GetTempPath, TempPath);
  TDirectory.CreateDirectory(TempPath);
  EmptyTempPath;

  ZeroMemory(@buffer, Length(buffer) * SizeOf(Char));
  SHGetFolderPath(0, CSIDL_COMMON_APPDATA, 0, SHGFP_TYPE_CURRENT, buffer);
  CommonAppData := TPath.Combine(buffer, CommonAppData);
  TDirectory.CreateDirectory(CommonAppData);

  AppData := TPath.Combine(TPath.GetHomePath, AppData);
  TDirectory.CreateDirectory(AppData);

  // si le fichier ini est dans le répertoire parent de l'exe (correspond à la version de développement)
  // alors on utilise les anciennes valeurs par défaut
  parentPath := TDirectory.GetParent(TPath.GetDirectoryName(TPath.GetLibraryPath));
  if TFile.Exists(TPath.Combine(parentPath, FichierIni)) then
  begin
    FichierIni := TPath.Combine(parentPath, FichierIni);
    DatabasePath := TPath.Combine(parentPath, DatabasePath);
    RepImages := TPath.Combine(parentPath, RepImages);
    RepScripts := TPath.Combine(parentPath, RepScripts);
    RepWebServer := TPath.Combine(parentPath, RepWebServer);
  end
  else
  begin
    FichierIni := TPath.Combine(AppData, FichierIni);
    DatabasePath := TPath.Combine(AppData, DatabasePath);
    RepImages := TPath.Combine(AppData, RepImages);
    RepScripts := TPath.Combine(CommonAppData, RepScripts);
    RepWebServer := TPath.Combine(CommonAppData, RepWebServer);
  end;
end;

procedure ReadIniFile;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FichierIni);
  try
    DatabasePath := ini.ReadString('Database', 'Database', DatabasePath);
    DatabaseUserName := ini.ReadString('Database', 'UserName', DatabaseUserName);
    DatabasePassword := ini.ReadString('Database', 'Password', DatabasePassword);
    DatabaseRole := ini.ReadString('Database', 'Role', DatabaseRole);
    DatabaseLibraryName := ini.ReadString('Database', 'LibraryName', DatabaseLibraryName);
    RepImages := IncludeTrailingPathDelimiter(ini.ReadString('DIVERS', 'RepImages', RepImages));
    RepScripts := IncludeTrailingPathDelimiter(ini.ReadString('DIVERS', 'Scripts', RepScripts));
    RepWebServer := IncludeTrailingPathDelimiter(ini.ReadString('DIVERS', 'WebServer', RepWebServer));

    FileScriptsOptions := TPath.Combine(TPath.GetDirectoryName(DatabasePath), 'Scripts.opt');
    FileScriptsMetadata := TPath.ChangeExtension(DatabasePath, '.mtd');

    TGlobalVar.Utilisateur.Options.VerifMAJDelai := ini.ReadInteger('Divers', 'VerifMAJDelai', 4);
    TGlobalVar.Utilisateur.Options.LastVerifMAJ := ini.ReadInteger('Divers', 'LastVerifMAJ', 0);
  finally
    ini.Free;
  end;
end;

{ TGlobalVar }

class constructor TGlobalVar.Create;
begin
  SQLSettings := TFormatSettings.Create('en-US');
  SQLSettings.ShortDateFormat := 'YYYY-MM-DD';
  SQLSettings.ShortTimeFormat := 'HH:mm:ss:zzz';
  SQLSettings.LongTimeFormat := 'HH:mm:ss:zzz';
  SQLSettings.DateSeparator := '-';
  SQLSettings.TimeSeparator := ':';
end;

initialization

{$IFDEF WIN32}
  SevenzipLibraryName := '7z_x86.dll';
{$ENDIF}
{$IFDEF WIN64}
SevenzipLibraryName := '7z_x64.dll';
{$ENDIF}
InitPath;
FormatPourcent := '%d (%f%%)';
TGlobalVar.Utilisateur.ExeVersion := GetFichierVersion(TPath.Combine(TPath.GetLibraryPath, 'bd.exe'));
TGlobalVar.Utilisateur.AppVersion := Format('%d.%d', [TGlobalVar.Utilisateur.ExeVersion.MajorVersion, TGlobalVar.Utilisateur.ExeVersion.MinorVersion]);
ReadIniFile;

finalization

if HandleDLLPic <> 0 then
  FreeLibrary(HandleDLLPic);

end.
