unit UMAJ2_1_0_16;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_0_16(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('alter table series');
    Script.Add('  add etat integer,');
    Script.Add('  add reliure integer,');
    Script.Add('  add typeedition integer,');
    Script.Add('  add orientation integer,');
    Script.Add('  add formatedition integer,');
    Script.Add('  add senslecture integer,');
    Script.Add('  add vo t_yesno,');
    Script.Add('  add couleur t_yesno;');

    Script.Add('create or alter trigger listes_aud0 for listes');
    Script.Add('active after update or delete position 0');
    Script.Add('as');
    Script.Add('declare variable newvalue integer;');
    Script.Add('begin');
    Script.Add('  if (deleting) then newvalue = null;');
    Script.Add('                else newvalue = new.ref;');
    Script.Add('');
    Script.Add('  if (old.categorie = 1) then begin');
    Script.Add('    update editions set etat = :newvalue where etat = old.ref;');
    Script.Add('    update series set etat = :newvalue where etat = old.ref;');
    Script.Add('  end');
    Script.Add('  if (old.categorie = 2) then begin');
    Script.Add('    update editions set reliure = :newvalue where reliure = old.ref;');
    Script.Add('    update series set reliure = :newvalue where reliure = old.ref;');
    Script.Add('  end');
    Script.Add('  if (old.categorie = 3) then begin');
    Script.Add('    update editions set typeedition = :newvalue where typeedition = old.ref;');
    Script.Add('    update series set typeedition = :newvalue where typeedition = old.ref;');
    Script.Add('  end');
    Script.Add('  if (old.categorie = 4) then begin');
    Script.Add('    update editions set orientation = :newvalue where orientation = old.ref;');
    Script.Add('    update series set orientation = :newvalue where orientation = old.ref;');
    Script.Add('  end');
    Script.Add('  if (old.categorie = 5) then begin');
    Script.Add('    update editions set formatedition = :newvalue where formatedition = old.ref;');
    Script.Add('    update series set formatedition = :newvalue where formatedition = old.ref;');
    Script.Add('  end');
    Script.Add('  if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;');
    Script.Add('  if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;');
    Script.Add('  if (old.categorie = 8) then begin');
    Script.Add('    update editions set senslecture = :newvalue where senslecture = old.ref;');
    Script.Add('    update series set senslecture = :newvalue where senslecture = old.ref;');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.0.16', @MAJ2_1_0_16);

end.

