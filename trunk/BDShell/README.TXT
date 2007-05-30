Extension du Namespace Windows
------------------------------

ce projet n'est pas abouti...le but est ici d'explorer l'extension du bureau Windows avec un dossier virtuel.

j'ai choisi de repartir de zéro, actuellement le projet merdoie autour de la notion de PItemIDList.

Le principe
-----------

MyShell.DLL export les fonctions suivantes

  DllRegisterServer
  DllUnregisterServer

  DllGetClassObject
  DllCanUnloadNow

 les deux premières sont invoquées par regsvr32.exe quand on enregistre (ou pas) la DLL

 les deux suivantes sont invoquées quand Windows a besoin de l'objet déclaré lors de l'enregistrement.

la fonction RegisterShellFolder() de ShellFolder.pas permet de déclarer un objet COM comme un dossier virtuel; dès lors il apparait dans le "Poste de Travail" et Windows invoque la DLL quand il en a besoin.

DllGetClassObject est utilisé pour retrouver un IClassFactory responsable de la création des instances.
IClassFactory.CreateInstance permet d'instancier l'objet COM déclaré

dans MyShell, c'est le même objet Delphi qui implémente IClassFactory et IShellFolder, ce n'est pas génant dans la mesure ou la DLL ne publie qu'un seul objet. Du coup utiliser la fonction QueryInterface de TObject pour passer de l'un à l'autre.

 DllCanUnloadNow retourne OK si toutes les instances de l'objet ont été libérées.

Structure du programme
----------------------

 Je déclare dans une unité, une classe qui implémente une interface. Celle ci répond E_NOTIMPL sur chaque méthode de l'interface, exemple :

 // IShellFolder
 function TShellFolder.ParseDisplayName(hwndOwner: HWND;
   pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG;
   out ppidl: PItemIDList; var dwAttributes: ULONG): HResult; stdcall;
 begin
 {$IFDEF LOG}WriteLn(ClassName,'.IShellFolder.ParseDisplayName');{$ENDIF}
  Result:=E_NOTIMPL;
 end;

Si cette fonction doit être exploitée dans ma classe dérivée, je la déclare virtuelle, ce qui me permet d'avoir une classe dérivée débarassée de toutes les méthodes dont elle n'a pas besoin.

-> Voir la différence entre TShellFolder, qui implémente toutes les fonctions de IShellFodler, et TMyShell=class(TShellFolder) qui ne reprend en override que ce dont elle a besoin.

Paul TOTH
25 mai 2007