unit UMAJ2_2_3_29;

interface

uses
  System.SysUtils;

implementation

uses
  uib, Updates;

procedure MAJ2_2_3_29(Query: TUIBScript);
begin
  Query.Script.Add('insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values (''{4FD4F24D-E332-4836-BCD1-D0ED6AD73DE8}'', 1001, 10, 1, 0, ''Photo'');');
  Query.Script.Add('insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values (''{0D3B74A8-A853-4149-AD4E-2672DC30ECB5}'', 1002, 10, 2, 0, ''Scan'');');
  Query.Script.Add('insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values (''{E197964A-F260-41A4-9E42-916992476C4B}'', 1003, 10, 3, 0, ''Certificat'');');
  Query.Script.Add('insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values (''{C7EB7DE8-FF18-4629-99F0-C8DD86F95B66}'', 1004, 10, 4, 0, ''Divers'');');

  Query.Script.Add('alter table photos add categorieimage smallint;');
  Query.Script.Add('update photos set categorieimage = 1004 where categorieimage is null;');

  Query.Script.Add('create or alter trigger listes_aud0 for listes');
  Query.Script.Add('active after update or delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('declare variable newvalue type of column listes.ref;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (deleting) then newvalue = null;');
  Query.Script.Add('                else newvalue = new.ref;');
  Query.Script.Add('');
  Query.Script.Add('  if (newvalue is distinct from old.ref) then');
  Query.Script.Add('  begin');
  Query.Script.Add('    if (old.categorie = 1) then begin');
  Query.Script.Add('      update editions set etat = :newvalue where etat = old.ref;');
  Query.Script.Add('      update series set etat = :newvalue where etat = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 2) then begin');
  Query.Script.Add('      update editions set reliure = :newvalue where reliure = old.ref;');
  Query.Script.Add('      update series set reliure = :newvalue where reliure = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 3) then begin');
  Query.Script.Add('      update editions set typeedition = :newvalue where typeedition = old.ref;');
  Query.Script.Add('      update series set typeedition = :newvalue where typeedition = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 4) then begin');
  Query.Script.Add('      update editions set orientation = :newvalue where orientation = old.ref;');
  Query.Script.Add('      update series set orientation = :newvalue where orientation = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 5) then begin');
  Query.Script.Add('      update editions set formatedition = :newvalue where formatedition = old.ref;');
  Query.Script.Add('      update series set formatedition = :newvalue where formatedition = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;');
  Query.Script.Add('    if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;');
  Query.Script.Add('    if (old.categorie = 8) then begin');
  Query.Script.Add('      update editions set senslecture = :newvalue where senslecture = old.ref;');
  Query.Script.Add('      update series set senslecture = :newvalue where senslecture = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 9) then');
  Query.Script.Add('    begin');
  Query.Script.Add('      update albums set notation = :newvalue where notation = old.ref;');
  Query.Script.Add('      update series set notation = :newvalue where notation = old.ref;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (old.categorie = 10) then update photos set categorieimage = :newvalue where categorieimage = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('end');
  Query.Script.Add(';');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.29', @MAJ2_2_3_29);

end.
