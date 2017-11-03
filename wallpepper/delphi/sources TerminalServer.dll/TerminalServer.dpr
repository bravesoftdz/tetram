library TerminalServer;

uses
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UMain in 'UMain.pas',
  UInterfaceChange in '..\SDK\UInterfaceChange.pas';

{$R *.res}

// point d'entrée du plugin
function GetPlugin: IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create;
  Result := Plugin;
end;

exports
  GetPlugin;

begin
end.
