unit CommonConst;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  SysUtils, Windows, Forms, FileCtrl, Classes, Divers,
  Contnrs;

const
  DatabasePath: string = 'bd.gdb';
  DatabaseUserName: string = 'SYSDBA';
  DatabasePassword: string = 'masterkey';
  DatabaseRole: string = 'ReadOnly'; // AllAccess
  DatabaseLibraryName: string = 'fbembed.dll';
  TempPath: array[0..1024] of Char = #0;
  RepImages: string = 'Images\';
  RepWebServer: string = 'WebServer\';
  RessourcePic: string = 'BDPic.dll';
  HandleDLLPic: Integer = 0;
  FichierIni: string = 'Bd.ini';
  FormatMonnaieCourt: string = '';
  FormatPourcent: string = '';
  FormatMonnaie: string = '';
  FormatMonnaieSimple: string = '';
  CODE_APP = '954726'; {code (6 caract�res num�riques) arbitraire utilis� pour g�n�rer les r�f�rences de cassettes}
  TitreApplication = 'BDth�que';
  CopyrightTetramCorp = 'Copyright � Tetr�m Corp';

  csAll = '(Toutes)'; // All categories
  csCaption = '<Barre>'; // Default Toolbar Caption
  cstbU = 'tbU'; // ID for userdefined toolbars
  customizing: Boolean = False;

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
  end;

  RUtilisateur = record
    Options: ROptions;
    ExeVersion, AppVersion: TFileVersion;
  end;

  TModeConsult = (mdLoad, mdConsult, mdEdit, mdEditing, mdEntretien, mdImportation, mdExportation);

type
  TGlobalVar = class
    class var Mode_en_cours: TModeConsult;
    class var Utilisateur: RUtilisateur;
  end;

implementation

uses
  IniFiles;

initialization
  GetTempPath(Length(TempPath), TempPath);
  RepImages := ExtractFilePath(Application.ExeName) + RepImages;
  FichierIni := ExtractFilePath(Application.ExeName) + FichierIni;
  RepWebServer := ExtractFilePath(Application.ExeName) + RepWebServer;
  FormatMonnaieCourt := '#,##0.00';
  FormatMonnaieSimple := '0.00';
  FormatMonnaie := IIf(CurrencyFormat in [0, 2], CurrencyString + IIf(CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IIf(CurrencyFormat in [1, 3], IIf(CurrencyFormat = 3, ' ', '') + CurrencyString, '');
  FormatPourcent := '%d (%f%%)';
  TGlobalVar.Utilisateur.ExeVersion := GetFichierVersion(Application.ExeName);
  with TIniFile.Create(FichierIni) do
    try
      DatabasePath := ReadString('Database', 'Database', ExtractFilePath(Application.ExeName) + DatabasePath);
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
  if HandleDLLPic <> 0 then
    FreeLibrary(HandleDLLPic);

end.

