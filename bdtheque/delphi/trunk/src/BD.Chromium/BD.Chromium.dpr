program BD.Chromium;

{$R *.res}

uses
  WinApi.Windows,
  BD.Utils.Chromium in '..\Commun\Utils\BD.Utils.Chromium.pas';

{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

begin
  InitializeChromium;
end.
