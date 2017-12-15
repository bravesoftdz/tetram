unit BDTK.Updates.v0_0_0_8;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_0_8(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('ALTER PROCEDURE PROC_AJOUTMVT (');
  Query.Script.Add('    REFEDITION INTEGER,');
  Query.Script.Add('    REFEMPRUNTEUR INTEGER,');
  Query.Script.Add('    DATEEMPRUNT TIMESTAMP,');
  Query.Script.Add('    PRET SMALLINT)');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into STATUT ( DateEmprunt,  RefEmprunteur,  RefEdition,  PretEmprunt)');
  Query.Script.Add('              values (:DateEmprunt, :RefEmprunteur, :RefEdition, :Pret);');
  Query.Script.Add('  update EDITIONS set Prete = :Pret where RefEdition = :RefEdition;');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.0.8', @MAJ0_0_0_8);

end.
