unit uPSI_TypeRec;

interface

uses
  SysUtils, Classes, uPSComponent, uPSRuntime, uPSCompiler;

type
  TPSImport_TypeRec = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

uses
  uPSR_TypeRec,
  uPSC_TypeRec;

{ TPSImport_TypeRec }

procedure TPSImport_TypeRec.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TypeRec(CompExec.Comp);
end;

procedure TPSImport_TypeRec.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TypeRec(ri);
end;

end.

