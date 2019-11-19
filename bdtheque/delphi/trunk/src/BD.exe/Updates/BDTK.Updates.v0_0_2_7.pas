unit BDTK.Updates.v0_0_2_7;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_2_7(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('ALTER TABLE EDITIONS DROP NOTES, ADD NOTES BLOB SUB_TYPE 1;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.2.7', @MAJ0_0_2_7);

end.
