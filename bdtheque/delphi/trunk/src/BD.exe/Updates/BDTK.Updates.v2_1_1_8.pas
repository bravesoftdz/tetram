unit BDTK.Updates.v2_1_1_8;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ2_1_1_8(Query: TUIBScript);
begin
  Query.Script.Clear;

  // libération des dépendances
  LoadScript('MAJ2_1_1_8part1', Query.Script);
  Query.ExecuteScript;

  // recréation des champs
  LoadScript('MAJ2_1_1_8part2', Query.Script);
  Query.ExecuteScript;

  // recréation des procs/vues/triggers
  LoadScript('MAJ2_1_1_8part3', Query.Script);
  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.1.8', @MAJ2_1_1_8);

end.
