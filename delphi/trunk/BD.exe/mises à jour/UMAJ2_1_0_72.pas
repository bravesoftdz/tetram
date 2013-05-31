unit UMAJ2_1_0_72;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_0_72(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    // libération des dépendances
    LoadScript('MAJ2_1_0_72part1', Script);
    ExecuteScript;

    // recréation des champs
    LoadScript('MAJ2_1_0_72part2', Script);
    ExecuteScript;

    // recréation des procs/vues/triggers
    LoadScript('MAJ2_1_0_72part3', Script);
    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.0.72', @MAJ2_1_0_72);

end.

