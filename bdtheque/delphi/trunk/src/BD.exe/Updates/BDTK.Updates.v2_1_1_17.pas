unit BDTK.Updates.v2_1_1_17;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ2_1_1_17(Query: TUIBScript);
begin
  Query.Script.Clear;
  LoadScript('MAJ2_1_1_17', Query.Script);
  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.1.17', @MAJ2_1_1_17);

end.
