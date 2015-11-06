program BDScript;



{$R *.dres}

uses
  Vcl.Forms,
  UMetadata in '..\Commun\UMetadata.pas',
  Commun in '..\Commun\Commun.pas',
  CommonConst in '..\Commun\CommonConst.pas',
  Textes in '..\Commun\Textes.pas',
  UfrmSplash in '..\Commun\UfrmSplash.pas' {frmSplash},
  UBdtForms in '..\Commun\UBdtForms.pas' {bdtForm},
  Entities.Deserializer in '..\Commun\Entities\Entities.Deserializer.pas',
  Entities.Full in '..\Commun\Entities\Entities.Full.pas',
  Entities.Lite in '..\Commun\Entities\Entities.Lite.pas',
  Entities.Serializer in '..\Commun\Entities\Entities.Serializer.pas',
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
  UframBoutons in '..\Commun\UframBoutons.pas' {framBoutons: TFrame},
  IDHashMap in 'IDHashMap.pas',
  UdmPrinc in 'UdmPrinc.pas' {dmPrinc: TDataModule},
  UframBreakpoints in 'UframBreakpoints.pas' {framBreakpoints: TFrame},
  UframMessages in 'UframMessages.pas' {framMessages: TFrame},
  UframScriptInfos in 'UframScriptInfos.pas' {framScriptInfos: TFrame},
  UframWatches in 'UframWatches.pas' {framWatches: TFrame},
  UfrmScriptChoix in 'UfrmScriptChoix.pas' {frmScriptChoix},
  UfrmScriptEditOption in 'UfrmScriptEditOption.pas' {frmScriptEditOption},
  UfrmScriptGotoLine in 'UfrmScriptGotoLine.pas' {frmScriptGotoLine},
  UfrmScriptOption in '..\Commun\Scripts\UfrmScriptOption.pas' {frmScriptOption},
  UfrmScripts in 'UfrmScripts.pas' {frmScripts},
  UfrmScriptSearch in 'UfrmScriptSearch.pas' {frmScriptSearch},
  UfrmScriptsUpdate in 'UfrmScriptsUpdate.pas' {frmScriptsUpdate},
  UMasterEngine in 'UMasterEngine.pas',
  UScriptEditor in 'UScriptEditor.pas',
  UScriptEditorPage in 'UScriptEditorPage.pas',
  UScriptEngineIntf in 'UScriptEngineIntf.pas',
  UScriptsHTMLFunctions in 'UScriptsHTMLFunctions.pas',
  BdtkRegEx in '..\Commun\BdtkRegEx.pas',
  VirtualTree in '..\Commun\VirtualTree.pas',
  UfrmAboutBox in '..\Commun\UfrmAboutBox.pas' {frmAboutBox},
  Entities.Common in '..\Commun\Entities\Entities.Common.pas',
  Entities.FactoriesLite in '..\Commun\Entities\Entities.FactoriesLite.pas',
  Entities.FactoriesCommon in '..\Commun\Entities\Entities.FactoriesCommon.pas',
  Entities.FactoriesFull in '..\Commun\Entities\Entities.FactoriesFull.pas',
  Entities.DaoLambdaJSON in 'Entities.DaoLambdaJSON.pas',
  Entities.DaoLambda in '..\Commun\Entities\Entities.DaoLambda.pas',
  UNetICSCompress in '..\Commun\UNetICSCompress.pas',
  Entities.Types in '..\Commun\Entities\Entities.Types.pas';

{$R *.res}

begin
  {$IFDEF WIN64}
  {$Message Fatal 'Ce projet n''est pas compilable en 64 bits: les moteurs de scripts ne supportent pas ce mode'}
  {$ENDIF}

  Application.Initialize;
  Application.Run;
end.
