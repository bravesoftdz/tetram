unit uPSI_BdtkRegEx;

interface

uses
  SysUtils, Classes, uPSComponent, uPSCompiler, uPSRuntime;

type
  TPSImport_BdtkRegEx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

uses
  uPSC_BdtkRegEx,
  uPSR_BdtkRegEx;

{ TPSImport_PerlRegEx }

procedure TPSImport_BdtkRegEx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BdtkRegEx(CompExec.Comp);
end;

procedure TPSImport_BdtkRegEx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BdtkRegEx(ri);
  RIRegister_BdtkRegEx_Routines(CompExec.Exec); // comment it if no routines
end;

end.
