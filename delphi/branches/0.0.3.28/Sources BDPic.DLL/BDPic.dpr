
library BDPic;

{ Remarque importante concernant la gestion de mémoire des DLL : ShareMem doit être
  la première unité de la clause USES de votre bibliothèque ET de votre projet
  (sélectionnez Projet-Voir source) si votre DLL exporte des procédures ou des
  fonctions qui passent des chaînes comme paramètres ou résultats de fonctions.
  Ceci s'applique à toutes les chaînes passées de et vers votre DLL - même celles
  qui sont imbriquées dans des enregistrements et classes. ShareMem est l'unité d'interface pour
  le gestionnaire de mémoire partagée BORLNDMM.DLL, qui doit être déployé avec
  vos DLLs. Pour éviter d'utiliser BORLNDMM.DLL, passez les informations de chaînes
  avec des paramètres PChar ou ShortString.}

{uses
  SysUtils,
  Classes;}

{$R *.RES}
{$R 'pics.res' 'pics.rc'}

begin
end.
