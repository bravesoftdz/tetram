program Project2;

uses
  Forms,
  Form_Scripts in '..\..\Sources\BD.exe\Scripts\Form_Scripts.pas' {Form1},
  Form_ScriptSearch in '..\..\Sources\BD.exe\Scripts\Form_ScriptSearch.pas' {Form2},
  UScriptsFonctions in '..\..\Sources\BD.exe\Scripts\UScriptsFonctions.pas',
  UScriptUtils in '..\..\Sources\BD.exe\Scripts\UScriptUtils.pas',
  ProceduresBDtk in 'ProceduresBDtk.pas',
  Form_Progression in 'Form_Progression.pas' {FrmProgression},
  uPSComponent_RegExpr in 'uPSComponent_RegExpr.pas',
  uPSC_RegExpr in 'uPSC_RegExpr.pas',
  uPSR_RegExpr in 'uPSR_RegExpr.pas',
  RegExpr in '..\..\..\..\Composants\TRegExp\Source\RegExpr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
