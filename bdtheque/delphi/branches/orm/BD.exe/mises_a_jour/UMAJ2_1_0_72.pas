unit UMAJ2_1_0_72;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_0_72(Query: TUIBScript);
begin
  Query.Script.Clear;

  // lib�ration des d�pendances
  LoadScript('MAJ2_1_0_72part1', Query.Script);
  Query.ExecuteScript;

  // recr�ation des champs
  LoadScript('MAJ2_1_0_72part2', Query.Script);
  Query.ExecuteScript;

  // recr�ation des procs/vues/triggers
  LoadScript('MAJ2_1_0_72part3', Query.Script);
  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.0.72', @MAJ2_1_0_72);

end.
