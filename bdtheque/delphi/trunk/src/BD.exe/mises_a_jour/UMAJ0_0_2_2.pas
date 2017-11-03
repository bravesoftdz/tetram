unit UMAJ0_0_2_2;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_2_2(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('ALTER TABLE EDITIONS ADD NOTES BLOB SUB_TYPE 0;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.2.2', @MAJ0_0_2_2);

end.
