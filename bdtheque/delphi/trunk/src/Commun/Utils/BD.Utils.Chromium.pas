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

  // obligatoire pour permettre � bdtheque d'�tre lanc� sans donner le chemin de d�marrage
  // (= les dll de Chromium se trouvent toujours avec l'appli, on n'autorise pas � contourner leur emplacement)
  GlobalCEFApp.SetCurrentDir := True;

  GlobalCEFApp.SingleProcess := {$IFDEF DEBUG}True{$ELSE}False{$ENDIF};
  // utiliser un autre exe comme subprocess permet de ne pas avoir � initialiser Chromium dans le dpr
  GlobalCEFApp.BrowserSubprocessPath := 'Chromium\BD.Chromium.exe';

  GlobalCEFApp.FrameworkDirPath := 'Chromium';
  GlobalCEFApp.ResourcesDirPath := 'Chromium';
  GlobalCEFApp.LocalesDirPath := 'Chromium';
  GlobalCEFApp.LocalesRequired := 'fr';

  // puisqu'on n'utilise pas le m�me exe pour les subprocess, pas besoin de r�agir au r�sultat du retour de la fonction
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
