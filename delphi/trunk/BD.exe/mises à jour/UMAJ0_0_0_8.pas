unit UMAJ0_0_0_8;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_0_8(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('ALTER PROCEDURE PROC_AJOUTMVT (');
    Script.Add('    REFEDITION INTEGER,');
    Script.Add('    REFEMPRUNTEUR INTEGER,');
    Script.Add('    DATEEMPRUNT TIMESTAMP,');
    Script.Add('    PRET SMALLINT)');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into STATUT ( DateEmprunt,  RefEmprunteur,  RefEdition,  PretEmprunt)');
    Script.Add('              values (:DateEmprunt, :RefEmprunteur, :RefEdition, :Pret);');
    Script.Add('  update EDITIONS set Prete = :Pret where RefEdition = :RefEdition;');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.0.8', @MAJ0_0_0_8);

end.
