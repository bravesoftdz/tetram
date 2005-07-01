unit UMAJ0_0_2_2;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_2_2(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('ALTER TABLE EDITIONS ADD NOTES BLOB SUB_TYPE 0;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('0.0.2.2', @MAJ0_0_2_2);

end.
