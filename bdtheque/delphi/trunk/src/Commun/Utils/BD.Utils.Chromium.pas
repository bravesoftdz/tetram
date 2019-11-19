unit BD.Utils.Chromium;

interface

uses
  System.SysUtils;

procedure InitializeChromium(AUseSingleProcess: Boolean = {$IFDEF DEBUG}True{$ELSE}False{$ENDIF});

implementation

uses
  uCEFApplication, uCEFWorkScheduler, uCEFv8Handler, uCEFMiscFunctions, uCEFConstants,
  BD.Utils.Chromium.Extension, System.IOUtils;

procedure GlobalCEFApp_OnScheduleMessagePumpWork(const ADelayMS: Int64);
begin
  if (GlobalCEFWorkScheduler <> nil) then
    GlobalCEFWorkScheduler.ScheduleMessagePumpWork(ADelayMS);
end;

procedure GlobalCEFApp_OnWebKitInitialized;
begin
  SetExtensionRegistered(TCefRTTIExtension.Register('BrowserExtension', TBrowserExtension));
{$IFDEF DEBUG}
  if TBrowserExtension.Registered then
    CefDebugLog('JavaScript extension registered successfully!')
  else
    CefDebugLog('There was an error registering the JavaScript extension!');
{$ENDIF}
end;

procedure InitializeChromium(AUseSingleProcess: Boolean);
var
  IsSubProcess: Boolean;
  LocalPath: string;
begin
  IsSubProcess := SameText(ExtractFileName(ParamStr(0)), 'BD.Chromium.exe');

  GlobalCEFWorkScheduler := TCEFWorkScheduler.Create(nil);
  GlobalCEFApp := TCefApplication.Create;

  // obligatoire pour permettre à bdtheque d'être lancé sans donner le chemin de démarrage
  // (= les dll de Chromium se trouvent toujours avec l'appli, on n'autorise pas à contourner leur emplacement)
  GlobalCEFApp.SetCurrentDir := True;

  GlobalCEFApp.SingleProcess := {$IFDEF DEBUG}AUseSingleProcess and not IsSubProcess{$ELSE}False{$ENDIF};
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

  LocalPath := TPath.Combine(TPath.GetHomePath, 'TetramCorp\BDTheque\BD.Chromium');
  GlobalCEFApp.UserDataPath := TPath.Combine(LocalPath, 'UserData');
  GlobalCEFApp.Cache := TPath.Combine(LocalPath, 'Cache');
  GlobalCEFApp.PersistSessionCookies := True;
  GlobalCEFApp.PersistUserPreferences := True;

  GlobalCEFApp.ExternalMessagePump := True;
  GlobalCEFApp.MultiThreadedMessageLoop := False;
  GlobalCEFApp.OnScheduleMessagePumpWork := GlobalCEFApp_OnScheduleMessagePumpWork;
  GlobalCEFApp.OnWebKitInitialized := GlobalCEFApp_OnWebKitInitialized;

{$IFDEF DEBUG}
  GlobalCEFApp.LogFile := 'BD.Chromium.debug.log';
  GlobalCEFApp.LogSeverity := LOGSEVERITY_DEBUG;
  GlobalCEFApp.LogProcessInfo := True;
{$ENDIF}

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
