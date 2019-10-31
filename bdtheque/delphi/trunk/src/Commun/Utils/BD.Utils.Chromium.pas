unit BD.Utils.Chromium;

interface

uses
  System.SysUtils;

procedure InitializeChromium;

implementation

uses
  uCEFApplication, uCEFWorkScheduler;

procedure GlobalCEFApp_OnScheduleMessagePumpWork(const ADelayMS: Int64);
begin
  if (GlobalCEFWorkScheduler <> nil) then
    GlobalCEFWorkScheduler.ScheduleMessagePumpWork(ADelayMS);
end;

procedure InitializeChromium;
var
  IsSubProcess: Boolean;
begin
  IsSubProcess := SameText(ExtractFileName(ParamStr(0)), 'BD.Chromium.exe');

  GlobalCEFWorkScheduler := TCEFWorkScheduler.Create(nil);
  GlobalCEFApp := TCefApplication.Create;

  // obligatoire pour permettre à bdtheque d'être lancé sans donner le chemin de démarrage
  // (= les dll de Chromium se trouvent toujours avec l'appli, on n'autorise pas à contourner leur emplacement)
  GlobalCEFApp.SetCurrentDir := True;

  GlobalCEFApp.SingleProcess := {$IFDEF DEBUG}not IsSubProcess{$ELSE}False{$ENDIF};
  // utiliser un autre exe comme subprocess permet de ne pas avoir à initialiser Chromium dans le dpr
  if not GlobalCEFApp.SingleProcess then
    if IsSubProcess then
      GlobalCEFApp.BrowserSubprocessPath := ParamStr(0)
    else
      GlobalCEFApp.BrowserSubprocessPath := 'Chromium\BD.Chromium.exe';

  GlobalCEFApp.FrameworkDirPath := 'Chromium';
  GlobalCEFApp.ResourcesDirPath := 'Chromium';
  GlobalCEFApp.LocalesDirPath := 'Chromium';
  GlobalCEFApp.LocalesRequired := 'fr';

  GlobalCEFApp.ExternalMessagePump := True;
  GlobalCEFApp.MultiThreadedMessageLoop := False;
  GlobalCEFApp.OnScheduleMessagePumpWork := GlobalCEFApp_OnScheduleMessagePumpWork;

  // on n'utilise pas Application.ExeName pour éviter les uses trop gourmand (Forms)
  if IsSubProcess then
    GlobalCEFApp.StartSubProcess
  else
    // puisqu'on n'utilise pas le même exe pour les subprocess, pas besoin de réagir au résultat du retour de la fonction
    GlobalCEFApp.StartMainProcess;
end;

procedure FinalizeChromium;
begin
  FreeAndNil(GlobalCEFApp);
  FreeAndNil(GlobalCEFWorkScheduler);
end;

initialization

finalization
  FinalizeChromium;

end.
