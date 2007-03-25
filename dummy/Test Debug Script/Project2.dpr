program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit4 in 'Unit4.pas',
  Unit5 in 'Unit5.pas',
  ProceduresBDtk in 'ProceduresBDtk.pas',
  Form_Progression in 'Form_Progression.pas' {FrmProgression};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
