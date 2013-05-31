program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  LoadComplet in '..\BD.exe\LoadComplet.pas',
  TypeRec in '..\BD.exe\TypeRec.pas',
  Commun in '..\BD.exe\Commun.pas',
  DM_Princ in 'DM_Princ.pas' {DMPrinc: TDataModule},
  ListOfTypeRec in '..\BD.exe\ListOfTypeRec.pas',
  Procedures in '..\BD.exe\Procedures.pas',
  CommonConst in '..\BD.exe\CommonConst.pas',
  Textes in '..\BD.exe\Textes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDMPrinc, DMPrinc);
  Application.Run;
end.
