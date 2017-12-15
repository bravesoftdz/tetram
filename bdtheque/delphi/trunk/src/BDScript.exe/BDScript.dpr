program BDScript;

{$R *.dres}

uses
  Vcl.Forms,
  BD.Entities.Metadata in '..\Commun\Entities\BD.Entities.Metadata.pas',
  BD.Utils.StrUtils in '..\Commun\Utils\BD.Utils.StrUtils.pas',
  BD.Common in '..\Commun\BD.Common.pas',
  BD.Strings in '..\Commun\BD.Strings.pas',
  BD.GUI.Forms.Splash in '..\Commun\GUI\Forms\BD.GUI.Forms.Splash.pas' {frmSplash},
  BD.GUI.Forms in '..\Commun\GUI\Forms\BD.GUI.Forms.pas' {bdtForm},
  BD.Entities.Utils.Deserializer in '..\Commun\Entities\BD.Entities.Utils.Deserializer.pas',
  BD.Entities.Full in '..\Commun\Entities\BD.Entities.Full.pas',
  BD.Entities.Lite in '..\Commun\Entities\BD.Entities.Lite.pas',
  BD.Entities.Utils.Serializer in '..\Commun\Entities\BD.Entities.Utils.Serializer.pas',
  BD.Utils.Deserializer.JSON in '..\Commun\Utils\BD.Utils.Deserializer.JSON.pas',
  BD.Utils.Serializer.JSON in '..\Commun\Utils\BD.Utils.Serializer.JSON.pas',
  BDS.Scripts.PascalScript in 'PascalScript\BDS.Scripts.PascalScript.pas',
  BDS.Scripts.PascalScript.Editor in 'PascalScript\BDS.Scripts.PascalScript.Editor.pas',
  BDS.Scripts.PascalScript.Compilation.BdtkObjects in 'PascalScript\BDS.Scripts.PascalScript.Compilation.BdtkObjects.pas',
  BDS.Scripts.PascalScript.Compilation.BdtkRegEx in 'PascalScript\BDS.Scripts.PascalScript.Compilation.BdtkRegEx.pas',
  BDS.Scripts.PascalScript.Compilation.superobject in 'PascalScript\BDS.Scripts.PascalScript.Compilation.superobject.pas',
  BDS.Scripts.PascalScript.Import.BdtkObjects in 'PascalScript\BDS.Scripts.PascalScript.Import.BdtkObjects.pas',
  BDS.Scripts.PascalScript.Import.BdtkRegEx in 'PascalScript\BDS.Scripts.PascalScript.Import.BdtkRegEx.pas',
  BDS.Scripts.PascalScript.Import.superobject in 'PascalScript\BDS.Scripts.PascalScript.Import.superobject.pas',
  BDS.Scripts.PascalScript.Run.BdtkObjects in 'PascalScript\BDS.Scripts.PascalScript.Run.BdtkObjects.pas',
  BDS.Scripts.PascalScript.Run.BdtkRegEx in 'PascalScript\BDS.Scripts.PascalScript.Run.BdtkRegEx.pas',
  BDS.Scripts.PascalScript.Run.superobject in 'PascalScript\BDS.Scripts.PascalScript.Run.superobject.pas',
  BDS.Scripts.DWScript in 'DWScript\BDS.Scripts.DWScript.pas',
  BDS.Scripts.DWScript.DWUnit.BdtkObjects in 'DWScript\BDS.Scripts.DWScript.DWUnit.BdtkObjects.pas',
  BDS.Scripts.DWScript.DWUnit.BdtkRegEx in 'DWScript\BDS.Scripts.DWScript.DWUnit.BdtkRegEx.pas',
  BDS.Scripts.DWScript.DWUnit.Functions in 'DWScript\BDS.Scripts.DWScript.DWUnit.Functions.pas',
  BDS.Scripts.DWScript.Editor in 'DWScript\BDS.Scripts.DWScript.Editor.pas',
  BDS.Scripts.DWScript.DWUnit in 'DWScript\BDS.Scripts.DWScript.DWUnit.pas',
  BD.Scripts in '..\Commun\Scripts\BD.Scripts.pas',
  BD.Scripts.Functions in '..\Commun\Scripts\BD.Scripts.Functions.pas',
  BD.Scripts.Utils in '..\Commun\Scripts\BD.Scripts.Utils.pas',
  BD.Utils.Net in '..\Commun\Utils\BD.Utils.Net.pas',
  BD.Utils.GUIUtils in '..\Commun\Utils\BD.Utils.GUIUtils.pas',
  BD.GUI.Forms.Progress in '..\Commun\GUI\Forms\BD.GUI.Forms.Progress.pas' {frmProgression},
  BD.GUI.Frames.Buttons in '..\Commun\GUI\Frames\BD.GUI.Frames.Buttons.pas' {framBoutons: TFrame},
  IDHashMap in 'IDHashMap.pas',
  BDS.DataModules.Main in 'GUI\DataModules\BDS.DataModules.Main.pas' {dmPrinc: TDataModule},
  UframBreakpoints in 'UframBreakpoints.pas' {framBreakpoints: TFrame},
  UframMessages in 'UframMessages.pas' {framMessages: TFrame},
  UframScriptInfos in 'UframScriptInfos.pas' {framScriptInfos: TFrame},
  UframWatches in 'UframWatches.pas' {framWatches: TFrame},
  UfrmScriptChoix in 'UfrmScriptChoix.pas' {frmScriptChoix},
  UfrmScriptEditOption in 'UfrmScriptEditOption.pas' {frmScriptEditOption},
  UfrmScriptGotoLine in 'UfrmScriptGotoLine.pas' {frmScriptGotoLine},
  BD.Scripts.Forms.UserSetting in '..\Commun\Scripts\BD.Scripts.Forms.UserSetting.pas' {frmScriptOption},
  BDS.Forms.Main in 'GUI\Forms\BDS.Forms.Main.pas' {frmScripts},
  UfrmScriptSearch in 'UfrmScriptSearch.pas' {frmScriptSearch},
  UfrmScriptsUpdate in 'UfrmScriptsUpdate.pas' {frmScriptsUpdate},
  UMasterEngine in 'UMasterEngine.pas',
  UScriptEditor in 'UScriptEditor.pas',
  UScriptEditorPage in 'UScriptEditorPage.pas',
  UScriptEngineIntf in 'UScriptEngineIntf.pas',
  UScriptsHTMLFunctions in 'UScriptsHTMLFunctions.pas',
  BD.Utils.RegEx in '..\Commun\Utils\BD.Utils.RegEx.pas',
  BD.GUI.Controls.VirtualTree in '..\Commun\GUI\Controls\BD.GUI.Controls.VirtualTree.pas',
  BD.GUI.Forms.About in '..\Commun\GUI\Forms\BD.GUI.Forms.About.pas' {frmAboutBox},
  BD.Entities.Common in '..\Commun\Entities\BD.Entities.Common.pas',
  BD.Entities.Factory.Lite in '..\Commun\Entities\BD.Entities.Factory.Lite.pas',
  BD.Entities.Factory.Common in '..\Commun\Entities\BD.Entities.Factory.Common.pas',
  BD.Entities.Factory.Full in '..\Commun\Entities\BD.Entities.Factory.Full.pas',
  Entities.DaoLambdaJSON in 'Entities.DaoLambdaJSON.pas',
  BD.Entities.Dao.Lambda in '..\Commun\Entities\BD.Entities.Dao.Lambda.pas',
  BD.Utils.Net.ICS in '..\Commun\Utils\BD.Utils.Net.ICS.pas',
  BD.Entities.Types in '..\Commun\Entities\BD.Entities.Types.pas',
  BD.GUI.DataModules.Common in '..\Commun\GUI\DataModules\BD.GUI.DataModules.Common.pas' {dmCommon: TDataModule};

{$R *.res}

begin
  {$IFDEF WIN64}
  {$Message Fatal 'Ce projet n''est pas compilable en 64 bits: les moteurs de scripts ne supportent pas ce mode'}
  {$ENDIF}

  Application.Initialize;
  Application.Run;
end.
