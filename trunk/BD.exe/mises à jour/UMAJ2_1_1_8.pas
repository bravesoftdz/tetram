unit UMAJ2_1_1_8;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_1_8(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    // libération des dépendances
    LoadScript('MAJ2_1_1_8part1', Script);
    ExecuteScript;

    // recréation des champs
    LoadScript('MAJ2_1_1_8part2', Script);
    ExecuteScript;

    // recréation des procs/vues/triggers
    LoadScript('MAJ2_1_1_8part3', Script);
    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.1.8', @MAJ2_1_1_8);

end.

