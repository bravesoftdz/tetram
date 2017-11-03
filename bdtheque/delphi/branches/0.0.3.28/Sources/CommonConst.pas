unit CommonConst;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  SysUtils, Windows, Forms, FileCtrl, Classes,
  Contnrs;

const
  DatabasePath: string = 'bd.gdb';
  DatabaseUserName: string = 'SYSDBA';
  DatabasePassword: string = 'masterkey';
  DatabaseRole: string = 'ReadOnly'; // AllAccess
  DatabaseLibraryName: string = 'fbembed.dll';
  WebServerPath: string = 'WebServer\';
  TempPath: array[0..1024] of Char = #0;
  RepImages: string = 'Images\';
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
  ROptions = record
    FicheWithCouverture, ModeDemarrage, Images: Boolean;
    SymboleMonnetaire: string[5];
    WebServerAutoStart: Boolean;
    WebServerPort: Integer;
    WebServerAntiAliasing, AntiAliasing: Boolean;
    ImagesStockees: Boolean;
    AvertirPret: Boolean;
    GrandesIconesMenus, GrandesIconesBarre: Boolean;
  end;

  TUtilisateur = record
    Options: ROptions;
    ExeVersion, AppVersion: string;
  end;

  TModeConsult = (mdLoad, mdConsult, mdEdit, mdEditing, mdEntretien, mdImportation, mdExportation);

var
  Mode_en_cours: TModeConsult;
  Utilisateur: TUtilisateur;

implementation

uses Divers, IniFiles;

initialization
  GetTempPath(Length(TempPath), TempPath);
  RepImages := ExtractFilePath(Application.ExeName) + RepImages;
  WebServerPath := ExtractFilePath(Application.ExeName) + WebServerPath;
  FichierIni := ExtractFilePath(Application.ExeName) + FichierIni;
  FormatMonnaieCourt := '#,##0.00';
  FormatMonnaieSimple := '0.00';
  FormatMonnaie := IIf(CurrencyFormat in [0, 2], CurrencyString + IIf(CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IIf(CurrencyFormat in [1, 3], IIf(CurrencyFormat = 3, ' ', '') + CurrencyString, '');
  FormatPourcent := '%d (%f%%)';
  with TIniFile.Create(FichierIni) do try
    DatabasePath := ReadString('Database', 'Database', ExtractFilePath(Application.ExeName) + DatabasePath);
    DatabaseUserName := ReadString('Database', 'UserName', DatabaseUserName);
    DatabasePassword := ReadString('Database', 'Password', DatabasePassword);
    DatabaseRole := ReadString('Database', 'Role', DatabaseRole);
    DatabaseLibraryName := ReadString('Database', 'LibraryName', DatabaseLibraryName);
    RepImages := ReadString('DIVERS', 'RepImages', RepImages);
  finally
    Free;
  end;

finalization
  if HandleDLLPic <> 0 then FreeLibrary(HandleDLLPic);

end.
