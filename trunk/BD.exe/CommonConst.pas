unit CommonConst;

interface

{$WARN UNIT_PLATFORM OFF}

uses SysUtils, Windows, Forms, FileCtrl, Classes, Divers, Contnrs;

const
  AppData: string = 'TetramCorp\BDTheque\';
  DatabasePath: string = 'bd.gdb';
  DatabaseUserName: string = 'SYSDBA';
  DatabasePassword: string = 'masterkey';
  DatabaseRole: string = 'ReadOnly'; // AllAccess
  DatabaseLibraryName: string = 'fbembed.dll';
  TempPath: string = 'TC_BDTK';
  RepImages: string = 'Images\';
  RepWebServer: string = 'WebServer\';
  RessourcePic: string = 'BDPic.dll';
  HandleDLLPic: Integer = 0;
  FichierIni: string = 'Bd.ini';
  FormatMonnaieCourt: string = '';
  FormatPourcent: string = '';
  FormatMonnaie: string = '';
  FormatMonnaieSimple: string = '';
  TitreApplication = 'BDthèque';
  CopyrightTetramCorp = 'Copyright © Teträm Corp';

  csAll = '(Toutes)'; // All categories

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
    RepertoireScripts: string;
    FormatTitreAlbum: Integer;
    SiteWeb: RSiteWeb;
    AfficheNoteListes: Boolean;
  end;

  RUtilisateur = record
    Options: ROptions;
    ExeVersion, AppVersion: TFileVersion;
  end;

  TModeConsult = (mdLoad, mdConsult, mdEdit, mdEditing, mdEntretien, mdImportation, mdExportation, mdScript);

type
  TGlobalVar = class
  class var
    Mode_en_cours: TModeConsult;
    class var Utilisateur: RUtilisateur;
  end;

implementation

uses IniFiles, ShellAPI, SHFolder;


procedure EmptyTempPath;
var
  op: _SHFILEOPSTRUCT;
begin
  op.Wnd := INVALID_HANDLE_VALUE;
  op.wFunc := FO_DELETE;
  op.pFrom := PChar(IncludeTrailingPathDelimiter(TempPath)+ '*');
  op.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI;
  SHFileOperation(op);
end;

procedure InitPath;
var
  buffer: array [0..MAX_PATH] of Char;
begin
  ZeroMemory(@buffer, Length(buffer) * SizeOf(Char));
  GetTempPath(Length(buffer), buffer);
  TempPath := IncludeTrailingPathDelimiter(buffer) + TempPath;
  ForceDirectories(TempPath);
  EmptyTempPath;

  ZeroMemory(@buffer, Length(buffer) * SizeOf(Char));
  SHGetFolderPath(0, CSIDL_APPDATA, 0, SHGFP_TYPE_CURRENT, buffer);
  AppData := IncludeTrailingPathDelimiter(buffer) + AppData;
  ForceDirectories(AppData);

  if FileExists(ExtractFilePath(Application.ExeName) + FichierIni) then
  begin
    FichierIni := ExtractFilePath(Application.ExeName) + FichierIni;
    DatabasePath := ExtractFilePath(Application.ExeName) + DatabasePath;
    RepImages := ExtractFilePath(Application.ExeName) + RepImages;
  end
  else
  begin
    FichierIni := AppData + FichierIni;
    DatabasePath := AppData + DatabasePath;
    RepImages := AppData + RepImages;
  end;
  RepWebServer := ExtractFilePath(Application.ExeName) + RepWebServer;
end;

initialization
  InitPath;
  FormatMonnaieCourt := '#,##0.00';
  FormatMonnaieSimple := '0.00';
  FormatMonnaie := IIf(CurrencyFormat in [0, 2], CurrencyString + IIf(CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IIf(CurrencyFormat in [1, 3], IIf(CurrencyFormat = 3, ' ', '') + CurrencyString, '');
  FormatPourcent := '%d (%f%%)';
  TGlobalVar.Utilisateur.ExeVersion := GetFichierVersion(Application.ExeName);
  TGlobalVar.Utilisateur.AppVersion := Format('%d.%d', [TGlobalVar.Utilisateur.ExeVersion.MajorVersion, TGlobalVar.Utilisateur.ExeVersion.MinorVersion]);
  with TIniFile.Create(FichierIni) do
    try
      DatabasePath := ReadString('Database', 'Database', DatabasePath);
      DatabaseUserName := ReadString('Database', 'UserName', DatabaseUserName);
      DatabasePassword := ReadString('Database', 'Password', DatabasePassword);
      DatabaseRole := ReadString('Database', 'Role', DatabaseRole);
      DatabaseLibraryName := ReadString('Database', 'LibraryName', DatabaseLibraryName);
      RepImages := ReadString('DIVERS', 'RepImages', RepImages);
      TGlobalVar.Utilisateur.Options.VerifMAJDelai := ReadInteger('Divers', 'VerifMAJDelai', 4);
      TGlobalVar.Utilisateur.Options.LastVerifMAJ := ReadInteger('Divers', 'LastVerifMAJ', 0);
    finally
      Free;
    end;

finalization
  if HandleDLLPic <> 0 then FreeLibrary(HandleDLLPic);

end.
