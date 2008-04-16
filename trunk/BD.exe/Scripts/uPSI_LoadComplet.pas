unit uPSI_LoadComplet;

interface

uses
  SysUtils, Classes, uPSComponent, uPSCompiler, uPSRuntime;

type
  TPSImport_LoadComplet = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

uses
  uPSC_LoadComplet,
  uPSR_LoadComplet;

{ TPSImport_LoadComplet }

procedure TPSImport_LoadComplet.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LoadComplet(CompExec.Comp);
end;

procedure TPSImport_LoadComplet.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LoadComplet(ri);
end;

end.

