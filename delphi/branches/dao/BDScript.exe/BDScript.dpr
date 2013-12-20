program BDScript;

{$R *.dres}

uses
  Vcl.Forms,
  EntitiesSerializer in '..\BD.exe\DBObjets\EntitiesSerializer.pas',
  JsonSerializer in '..\BD.exe\DBObjets\JsonSerializer.pas',
  EntitiesDeserializer in '..\BD.exe\DBObjets\EntitiesDeserializer.pas',
  JsonDeserializer in '..\BD.exe\DBObjets\JsonDeserializer.pas',
  EntitiesFull in '..\BD.exe\DBObjets\EntitiesFull.pas',
  EntitiesLite in '..\BD.exe\DBObjets\EntitiesLite.pas',
  Commun in '..\BD.exe\Commun.pas',
  CommonConst in '..\BD.exe\CommonConst.pas',
  UMetadata in '..\BD.exe\UMetadata.pas',
  UdmPrinc in 'UdmPrinc.pas' {dmPrinc: TDataModule},
  UfrmSplash in '..\BD.exe\UfrmSplash.pas' {frmSplash},
  UBdtForms in '..\BD.exe\UBdtForms.pas' {bdtForm},
  Textes in '..\BD.exe\Textes.pas';

{$R *.res}

begin
  {$IFDEF WIN64}
  Ce projet n'est pas compilable en 64 bits
  {$ENDIF}

  Application.Initialize;
  Application.Run;
end.
