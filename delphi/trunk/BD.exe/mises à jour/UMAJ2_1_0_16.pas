unit UMAJ2_1_0_16;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_0_16(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('alter table series');
  Query.Script.Add('  add etat integer,');
  Query.Script.Add('  add reliure integer,');
  Query.Script.Add('  add typeedition integer,');
  Query.Script.Add('  add orientation integer,');
  Query.Script.Add('  add formatedition integer,');
  Query.Script.Add('  add senslecture integer,');
  Query.Script.Add('  add vo t_yesno,');
  Query.Script.Add('  add couleur t_yesno;');

  Query.Script.Add('create or alter trigger listes_aud0 for listes');
  Query.Script.Add('active after update or delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('declare variable newvalue integer;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (deleting) then newvalue = null;');
  Query.Script.Add('                else newvalue = new.ref;');
  Query.Script.Add('');
  Query.Script.Add('  if (old.categorie = 1) then begin');
  Query.Script.Add('    update editions set etat = :newvalue where etat = old.ref;');
  Query.Script.Add('    update series set etat = :newvalue where etat = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (old.categorie = 2) then begin');
  Query.Script.Add('    update editions set reliure = :newvalue where reliure = old.ref;');
  Query.Script.Add('    update series set reliure = :newvalue where reliure = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (old.categorie = 3) then begin');
  Query.Script.Add('    update editions set typeedition = :newvalue where typeedition = old.ref;');
  Query.Script.Add('    update series set typeedition = :newvalue where typeedition = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (old.categorie = 4) then begin');
  Query.Script.Add('    update editions set orientation = :newvalue where orientation = old.ref;');
  Query.Script.Add('    update series set orientation = :newvalue where orientation = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (old.categorie = 5) then begin');
  Query.Script.Add('    update editions set formatedition = :newvalue where formatedition = old.ref;');
  Query.Script.Add('    update series set formatedition = :newvalue where formatedition = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;');
  Query.Script.Add('  if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;');
  Query.Script.Add('  if (old.categorie = 8) then begin');
  Query.Script.Add('    update editions set senslecture = :newvalue where senslecture = old.ref;');
  Query.Script.Add('    update series set senslecture = :newvalue where senslecture = old.ref;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.0.16', @MAJ2_1_0_16);

end.
