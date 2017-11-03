library TestPlug;

uses
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UMain in 'UMain.pas',
  UInterfaceJoursFeries in '..\SDK\UInterfaceJoursFeries.pas',
  UInterfaceChange in '..\SDK\UInterfaceChange.pas';

{$R *.res}

// point d'entrée du plugin
// WP-2.1.0.4
function GetPlugin(MainProg: IMainProg): IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create;
  Result := Plugin;
end;

// point d'entrée du plugin
// WP-2.1.0.18
function GetPlugin2(MainProg: IMainProg): IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create;
  Result := Plugin;
end;

// une seule des deux fonctions est necessaire
// si les deux sont déclarées, c'est GetPlugin2 qui sera utilisée en priorité
exports
  GetPlugin,
  GetPlugin2;

begin
end.
