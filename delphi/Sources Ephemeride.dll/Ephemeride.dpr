library Ephemeride;

{$R 'ressources.res' 'ressources.rc'}

uses
  UInterfacePlugIn in '..\SDK\UInterfacePlugIn.pas',
  UInterfaceDessinCalendrier in '..\SDK\UInterfaceDessinCalendrier.pas',
  UMain in 'UMain.pas',
  GPS in '..\Sources CompteRebours.dll\GPS.pas',
  USelectPosition in '..\Sources CompteRebours.dll\USelectPosition.pas' {Form1};

{$R *.res}

// point d'entrée du plugin
function GetPlugin2(MainProg: IMainProg): IPlugIn; stdcall;
begin
  if not Assigned(Plugin) then Plugin := TPlugin.Create(MainProg);
  Result := Plugin;
end;

exports
  GetPlugin2;

begin
end.
