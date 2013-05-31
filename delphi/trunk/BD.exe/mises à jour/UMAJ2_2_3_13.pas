unit UMAJ2_2_3_13;

interface

implementation

uses
  SysUtils, UIB, UIBLib, Updates;

procedure MAJ2_2_3_13(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('CREATE OR ALTER trigger listes_aud0 for listes');
    Script.Add('active after update or delete position 0');
    Script.Add('as');
    Script.Add('declare variable newvalue type of column listes.ref;');
    Script.Add('begin');
    Script.Add('  if (deleting) then newvalue = null;');
    Script.Add('                else newvalue = new.ref;');
    Script.Add('');
    Script.Add('  if (newvalue is distinct from old.ref) then');
    Script.Add('  begin');
    Script.Add('    if (old.categorie = 1) then begin');
    Script.Add('      update editions set etat = :newvalue where etat = old.ref;');
    Script.Add('      update series set etat = :newvalue where etat = old.ref;');
    Script.Add('    end');
    Script.Add('    if (old.categorie = 2) then begin');
    Script.Add('      update editions set reliure = :newvalue where reliure = old.ref;');
    Script.Add('      update series set reliure = :newvalue where reliure = old.ref;');
    Script.Add('    end');
    Script.Add('    if (old.categorie = 3) then begin');
    Script.Add('      update editions set typeedition = :newvalue where typeedition = old.ref;');
    Script.Add('      update series set typeedition = :newvalue where typeedition = old.ref;');
    Script.Add('    end');
    Script.Add('    if (old.categorie = 4) then begin');
    Script.Add('      update editions set orientation = :newvalue where orientation = old.ref;');
    Script.Add('      update series set orientation = :newvalue where orientation = old.ref;');
    Script.Add('    end');
    Script.Add('    if (old.categorie = 5) then begin');
    Script.Add('      update editions set formatedition = :newvalue where formatedition = old.ref;');
    Script.Add('      update series set formatedition = :newvalue where formatedition = old.ref;');
    Script.Add('    end');
    Script.Add('    if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;');
    Script.Add('    if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;');
    Script.Add('    if (old.categorie = 8) then begin');
    Script.Add('      update editions set senslecture = :newvalue where senslecture = old.ref;');
    Script.Add('      update series set senslecture = :newvalue where senslecture = old.ref;');
    Script.Add('    end');
    Script.Add('    if (old.categorie = 9) then');
    Script.Add('    begin');
    Script.Add('      update albums set notation = :newvalue where notation = old.ref;');
    Script.Add('      update series set notation = :newvalue where notation = old.ref;');
    Script.Add('    end');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('update listes set ref = categorie * 100 + ref;');

    ExecuteScript;
  end;
end;

initialization

RegisterFBUpdate('2.2.3.13', @MAJ2_2_3_13);

end.
