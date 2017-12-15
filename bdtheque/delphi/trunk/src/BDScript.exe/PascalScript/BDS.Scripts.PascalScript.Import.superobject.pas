unit BDS.Scripts.PascalScript.Import.superobject;

interface

uses SysUtils, Classes, uPSComponent, uPSRuntime, uPSCompiler;

type
  TPSImport_superobject = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

uses BDS.Scripts.PascalScript.Compilation.superobject, BDS.Scripts.PascalScript.Run.superobject;

{ TPSImport_superobject }

procedure TPSImport_superobject.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_superobject(CompExec.Comp);
end;

procedure TPSImport_superobject.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_superobject(ri);
  RIRegister_superobject_Routines(CompExec.Exec); // comment it if no routines
end;

end.
