library FeriesFR;

uses
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UMain in 'UMain.pas',
  UInterfaceJoursFeries in '..\SDK\UInterfaceJoursFeries.pas';

{$R *.res}

// point d'entr�e du plugin
function GetPlugin: IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create;
  Result := Plugin;
end;

exports
  GetPlugin;

begin
end.
