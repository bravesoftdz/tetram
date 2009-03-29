unit uPSI_BdtkObjects;

interface

uses
  SysUtils, Classes, uPSComponent, uPSCompiler, uPSRuntime;

type
  TPSImport_BdtkObjects = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

uses
  uPSC_BdtkObjects,
  uPSR_BdtkObjects;

{ TPSImport_LoadComplet }

procedure TPSImport_BdtkObjects.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BdtkObjects(CompExec.Comp);
end;

procedure TPSImport_BdtkObjects.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BdtkObjects(ri);
end;

end.

