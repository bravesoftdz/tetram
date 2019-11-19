unit BDTK.Updates.v2_2_3_13;

interface

implementation

uses
  System.SysUtils, UIB, UIBLib, BDTK.Updates;

procedure MAJ2_2_3_13(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('CREATE OR ALTER trigger listes_aud0 for listes');
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
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('update listes set ref = categorie * 100 + ref;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.13', @MAJ2_2_3_13);

end.
