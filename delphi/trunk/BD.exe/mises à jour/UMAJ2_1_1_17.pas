unit UMAJ2_1_1_17;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_1_17(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;
    LoadScript('MAJ2_1_1_17', Script);
    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.1.17', @MAJ2_1_1_17);


end.
