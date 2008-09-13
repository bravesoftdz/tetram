unit UMAJ1_0_0_3;

interface

implementation

uses UIB, Updates;

procedure MAJ1_0_0_3(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('CREATE VIEW VW_PRIXALBUMS(');
    Script.Add('    REFALBUM,');
    Script.Add('    HORSSERIE,');
    Script.Add('    TOME,');
    Script.Add('    INTEGRALE,');
    Script.Add('    TOMEDEBUT,');
    Script.Add('    TOMEFIN,');
    Script.Add('    NBALBUMS,');
    Script.Add('    REFSERIE,');
    Script.Add('    REFEDITION,');
    Script.Add('    REFEDITEUR,');
    Script.Add('    PRIX)');
    Script.Add('AS');
    Script.Add('select');
    Script.Add('  a.refalbum,');
    Script.Add('  a.horsserie,');
    Script.Add('  a.tome,');
    Script.Add('  a.integrale,');
    Script.Add('  a.tomedebut,');
    Script.Add('  a.tomefin,');
    Script.Add('  case');
    Script.Add('    when a.integrale = 0 then 1');
    Script.Add('    when a.tomedebut is null');
    Script.Add('    then 1 when a.tomefin is null');
    Script.Add('    then 1 when a.tomefin < a.tomedebut then 1');
    Script.Add('    else a.tomefin - a.tomedebut + 1');
    Script.Add('  end as nbalbums,');
    Script.Add('  a.refserie,');
    Script.Add('  e.refedition,');
    Script.Add('  e.refediteur,');
    Script.Add('  e.prix');
    Script.Add('from albums a');
    Script.Add('  inner join editions e on a.refalbum = e.refalbum;');

    Script.Add('CREATE VIEW VW_PRIXUNITAIRES(');
    Script.Add('    HORSSERIE,');
    Script.Add('    REFSERIE,');
    Script.Add('    REFEDITEUR,');
    Script.Add('    PRIXUNITAIRE)');
    Script.Add('AS');
    Script.Add('select');
    Script.Add('  horsserie,');
    Script.Add('  refserie,');
    Script.Add('  refediteur,');
    Script.Add('  avg(prix / nbalbums) as prixunitaire');
    Script.Add('from vw_prixalbums');
    Script.Add('where');
    Script.Add('  prix is not null');
    Script.Add('group by');
    Script.Add('  refserie,');
    Script.Add('  horsserie,');
    Script.Add('  refediteur;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('1.0.0.3', @MAJ1_0_0_3);

end.

