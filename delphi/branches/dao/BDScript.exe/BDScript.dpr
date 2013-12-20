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
  UdmPrinc in 'UdmPrinc.pas' {dmPrinc: TDataModule},
  UMetadata in '..\Commun\UMetadata.pas',
  Commun in '..\Commun\Commun.pas',
  CommonConst in '..\Commun\CommonConst.pas',
  Textes in '..\Commun\Textes.pas',
  UfrmSplash in '..\Commun\UfrmSplash.pas' {frmSplash},
  UBdtForms in '..\Commun\UBdtForms.pas' {bdtForm};

{$R *.res}

begin
  {$IFDEF WIN64}
  Ce projet n'est pas compilable en 64 bits
  {$ENDIF}

  Application.Initialize;
  Application.Run;
end.
