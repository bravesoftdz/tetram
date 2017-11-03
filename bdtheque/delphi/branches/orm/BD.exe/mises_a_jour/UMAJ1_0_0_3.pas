unit UMAJ1_0_0_3;

interface

implementation

uses UIB, Updates;

procedure MAJ1_0_0_3(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('CREATE VIEW VW_PRIXALBUMS(');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    NBALBUMS,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    REFEDITION,');
  Query.Script.Add('    REFEDITEUR,');
  Query.Script.Add('    PRIX)');
  Query.Script.Add('AS');
  Query.Script.Add('select');
  Query.Script.Add('  a.refalbum,');
  Query.Script.Add('  a.horsserie,');
  Query.Script.Add('  a.tome,');
  Query.Script.Add('  a.integrale,');
  Query.Script.Add('  a.tomedebut,');
  Query.Script.Add('  a.tomefin,');
  Query.Script.Add('  case');
  Query.Script.Add('    when a.integrale = 0 then 1');
  Query.Script.Add('    when a.tomedebut is null');
  Query.Script.Add('    then 1 when a.tomefin is null');
  Query.Script.Add('    then 1 when a.tomefin < a.tomedebut then 1');
  Query.Script.Add('    else a.tomefin - a.tomedebut + 1');
  Query.Script.Add('  end as nbalbums,');
  Query.Script.Add('  a.refserie,');
  Query.Script.Add('  e.refedition,');
  Query.Script.Add('  e.refediteur,');
  Query.Script.Add('  e.prix');
  Query.Script.Add('from albums a');
  Query.Script.Add('  inner join editions e on a.refalbum = e.refalbum;');

  Query.Script.Add('CREATE VIEW VW_PRIXUNITAIRES(');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    REFEDITEUR,');
  Query.Script.Add('    PRIXUNITAIRE)');
  Query.Script.Add('AS');
  Query.Script.Add('select');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  refserie,');
  Query.Script.Add('  refediteur,');
  Query.Script.Add('  avg(prix / nbalbums) as prixunitaire');
  Query.Script.Add('from vw_prixalbums');
  Query.Script.Add('where');
  Query.Script.Add('  prix is not null');
  Query.Script.Add('group by');
  Query.Script.Add('  refserie,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  refediteur;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.0.0.3', @MAJ1_0_0_3);

end.
