program BD.Chromium;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  WinApi.Windows,
  uCEFApplication,
  BD.Utils.Chromium in '..\Commun\Utils\BD.Utils.Chromium.pas';

{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

begin
  InitializeChromium;
end.
