program OverbyteIcsTelnetClient;

{$R '..\Vc32\OverbyteIcsXpManifest.res' '..\Vc32\OverbyteIcsXpManifest.rc'}
{$R '..\Vc32\OverbyteIcsCommonVersion.res' '..\Vc32\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsTelnetClient1 in 'OverbyteIcsTelnetClient1.pas' {TelnetForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTelnetForm, TelnetForm);
  Application.Run;
end.
