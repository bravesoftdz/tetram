program BDScript;



{$R *.dres}

uses
  Vcl.Forms,
  UdmPrinc in 'UdmPrinc.pas' {dmPrinc: TDataModule},
  UMetadata in '..\Commun\UMetadata.pas',
  Commun in '..\Commun\Commun.pas',
  CommonConst in '..\Commun\CommonConst.pas',
  Textes in '..\Commun\Textes.pas',
  UfrmSplash in '..\Commun\UfrmSplash.pas' {frmSplash},
  UBdtForms in '..\Commun\UBdtForms.pas' {bdtForm},
  EntitiesDeserializer in '..\Commun\Entities\EntitiesDeserializer.pas',
  EntitiesFull in '..\Commun\Entities\EntitiesFull.pas',
  EntitiesLite in '..\Commun\Entities\EntitiesLite.pas',
  EntitiesSerializer in '..\Commun\Entities\EntitiesSerializer.pas',
  JsonDeserializer in '..\Commun\Entities\JsonDeserializer.pas',
  JsonSerializer in '..\Commun\Entities\JsonSerializer.pas',
  UdmPascalScript in 'PascalScript\UdmPascalScript.pas',
  UPascalScriptEditor in 'PascalScript\UPascalScriptEditor.pas',
  uPSC_BdtkObjects in 'PascalScript\uPSC_BdtkObjects.pas',
  uPSC_BdtkRegEx in 'PascalScript\uPSC_BdtkRegEx.pas',
  uPSC_superobject in 'PascalScript\uPSC_superobject.pas',
  uPSI_BdtkObjects in 'PascalScript\uPSI_BdtkObjects.pas',
  uPSI_BdtkRegEx in 'PascalScript\uPSI_BdtkRegEx.pas',
  uPSI_superobject in 'PascalScript\uPSI_superobject.pas',
  uPSR_BdtkObjects in 'PascalScript\uPSR_BdtkObjects.pas',
  uPSR_BdtkRegEx in 'PascalScript\uPSR_BdtkRegEx.pas',
  uPSR_superobject in 'PascalScript\uPSR_superobject.pas',
  UdmDWScript in 'DWScript\UdmDWScript.pas',
  UDW_BdtkObjects in 'DWScript\UDW_BdtkObjects.pas',
  UDW_BdtkRegEx in 'DWScript\UDW_BdtkRegEx.pas',
  UDW_CommonFunctions in 'DWScript\UDW_CommonFunctions.pas',
  UDWScriptEditor in 'DWScript\UDWScriptEditor.pas',
  UDWUnit in 'DWScript\UDWUnit.pas',
  UScriptList in '..\Commun\Scripts\UScriptList.pas',
  UScriptsFonctions in '..\Commun\Scripts\UScriptsFonctions.pas',
  UScriptUtils in '..\Commun\Scripts\UScriptUtils.pas',
  UNet in '..\Commun\UNet.pas',
  Procedures in '..\Commun\Procedures.pas',
  UfrmProgression in '..\Commun\UfrmProgression.pas' {frmProgression},
  UframBoutons in '..\Commun\UframBoutons.pas' {framBoutons: TFrame};

{$R *.res}

begin
  {$IFDEF WIN64}
  Ce projet n'est pas compilable en 64 bits
  {$ENDIF}

  Application.Initialize;
  Application.Run;
end.
