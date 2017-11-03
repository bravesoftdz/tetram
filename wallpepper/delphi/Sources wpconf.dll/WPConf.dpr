library WPConf;

{ Remarque importante concernant la gestion de mémoire de DLL : ShareMem doit
  être la première unité de la clause USES de votre bibliothèque ET de votre projet 
  (sélectionnez Projet-Voir source) si votre DLL exporte des procédures ou des
  fonctions qui passent des chaînes en tant que paramètres ou résultats de fonction.
  Cela s'applique à toutes les chaînes passées de et vers votre DLL --même celles
  qui sont imbriquées dans des enregistrements et classes. ShareMem est l'unité 
  d'interface pour le gestionnaire de mémoire partagée BORLNDMM.DLL, qui doit
  être déployé avec vos DLL. Pour éviter d'utiliser BORLNDMM.DLL, passez les 
  informations de chaînes avec des paramètres PChar ou ShortString. }

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
