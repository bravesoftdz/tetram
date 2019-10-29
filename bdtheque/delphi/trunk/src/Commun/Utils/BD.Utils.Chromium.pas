unit BD.Utils.Chromium;

interface

uses
  System.SysUtils;

procedure InitializeChromium;

implementation

uses
  uCEFApplication;

procedure InitializeChromium;
begin
  GlobalCEFApp := TCefApplication.Create;

  // obligatoire pour permettre à bdtheque d'être lancé sans donner le chemin de démarrage
  // (= les dll de Chromium se trouvent toujours avec l'appli, on n'autorise pas à contourner leur emplacement)
  GlobalCEFApp.SetCurrentDir := True;

  GlobalCEFApp.SingleProcess := {$IFDEF DEBUG}True{$ELSE}False{$ENDIF};
  // utiliser un autre exe comme subprocess permet de ne pas avoir à initialiser Chromium dans le dpr
  GlobalCEFApp.BrowserSubprocessPath := 'Chromium\BD.Chromium.exe';

  GlobalCEFApp.FrameworkDirPath := 'Chromium';
  GlobalCEFApp.ResourcesDirPath := 'Chromium';
  GlobalCEFApp.LocalesDirPath := 'Chromium';
  GlobalCEFApp.LocalesRequired := 'fr';

  // puisqu'on n'utilise pas le même exe pour les subprocess, pas besoin de réagir au résultat du retour de la fonction
  GlobalCEFApp.StartMainProcess;
end;

procedure FinalizeChromium;
begin
  FreeAndNil(GlobalCEFApp);
end;

initialization

finalization
  FinalizeChromium;

end.
