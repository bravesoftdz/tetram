unit BDS.Scripts.PascalScript.Import.RegExpr;

interface

uses
  SysUtils, Classes, uPSComponent, uPSCompiler, uPSRuntime;

type
  TPSImport_RegExpr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

uses
  uPSC_regexpr,
  uPSR_regexpr;

{ TPSImport_RegExp }

procedure TPSImport_RegExpr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RegExpr(CompExec.Comp);
end;

procedure TPSImport_RegExpr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RegExpr(RI);
end;

end.

