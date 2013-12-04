unit UMAJ2_2_3_21;

interface

uses
  SysUtils, UIB, UIBLib, Updates;

implementation

procedure MAJ2_2_3_21(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create or alter trigger univers_au0 for univers');
  Query.Script.Add('active after update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.branche_univers is distinct from old.branche_univers) then');
  Query.Script.Add('    update univers set');
  Query.Script.Add('      branche_univers = new.branche_univers || ''|'' || id_univers');
  Query.Script.Add('    where');
  Query.Script.Add('      id_univers_parent = new.id_univers;');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.21', @MAJ2_2_3_21);

end.
