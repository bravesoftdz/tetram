library TestPlug;

uses
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UMain in 'UMain.pas',
  UInterfaceJoursFeries in '..\SDK\UInterfaceJoursFeries.pas',
  UInterfaceChange in '..\SDK\UInterfaceChange.pas';

{$R *.res}

// point d'entr�e du plugin
// WP-2.1.0.4
function GetPlugin(MainProg: IMainProg): IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create;
  Result := Plugin;
end;

// point d'entr�e du plugin
// WP-2.1.0.18
function GetPlugin2(MainProg: IMainProg): IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create;
  Result := Plugin;
end;

// une seule des deux fonctions est necessaire
// si les deux sont d�clar�es, c'est GetPlugin2 qui sera utilis�e en priorit�
exports
  GetPlugin,
  GetPlugin2;

begin
end.
