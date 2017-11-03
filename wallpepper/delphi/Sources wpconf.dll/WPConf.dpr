library WPConf;

{ Remarque importante concernant la gestion de m�moire de DLL : ShareMem doit
  �tre la premi�re unit� de la clause USES de votre biblioth�que ET de votre projet 
  (s�lectionnez Projet-Voir source) si votre DLL exporte des proc�dures ou des
  fonctions qui passent des cha�nes en tant que param�tres ou r�sultats de fonction.
  Cela s'applique � toutes les cha�nes pass�es de et vers votre DLL --m�me celles
  qui sont imbriqu�es dans des enregistrements et classes. ShareMem est l'unit� 
  d'interface pour le gestionnaire de m�moire partag�e BORLNDMM.DLL, qui doit
  �tre d�ploy� avec vos DLL. Pour �viter d'utiliser BORLNDMM.DLL, passez les 
  informations de cha�nes avec des param�tres PChar ou ShortString. }

uses
  SysUtils,
  Classes,
  Controls,
  UCommon in 'UCommon.pas',
  Form_Main in 'Form_Main.pas' {Fond},
  Divers in '..\..\..\Common\Divers.pas',
  DrawTreeDemo in 'DrawTreeDemo.pas' {DrawTreeForm},
  UJoursFeries in 'UJoursFeries.pas',
  UOptions in 'UOptions.pas',
  UOldOptions in 'UOldOptions.pas',
  UInterfaceJoursFeries in '..\SDK\UInterfaceJoursFeries.pas',
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UInterfaceChange in '..\SDK\UInterfaceChange.pas',
  UInterfaceDessinCalendrier in '..\SDK\UInterfaceDessinCalendrier.pas',
  UInterfacePluginCommandes in '..\SDK\UInterfacePluginCommandes.pas',
  Form_CreateExclu in '..\sources\Form_CreateExclu.pas' {FCreateExclu},
  Form_SelectWindow in '..\sources\Form_SelectWindow.pas' {FSelectWindow};

{$R *.res}

function ChangeOptions(ModeDebug: Boolean; Image: PChar; MainProg: IMainProg): Boolean; stdcall;
begin
  with TFond.Create(ModeDebug) do try
    FMainProg := MainProg;
    CurrentImage := StrPas(Image);
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

function SelectImage(ListeFichiers: PChar; var Image, Archive: array of Char; MainProg: IMainProg): Boolean; stdcall;
begin
  with TDrawTreeForm.Create(nil) do try
    FMainProg := MainProg;
    LoadListe(ListeFichiers);
    Result := (ShowModal = mrOk) or UseTest;
    if ModalResult = mrOk then begin
      StrCopy(Image, PChar(SelectedImage));
      StrCopy(Archive, PChar(SelectedArchive));
    end;
  finally
    Free;
  end;
end;

exports
  ChangeOptions,
  ChangeWallPap,
  SelectImage;

begin
end.
