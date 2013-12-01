unit UMAJ2_2_3_21;

interface

uses
  SysUtils, UIB, UIBLib, Updates;

implementation

procedure MAJ2_2_3_21(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('create or alter trigger univers_au0 for univers');
    Script.Add('active after update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  if (new.branche_univers is distinct from old.branche_univers) then');
    Script.Add('    update univers set');
    Script.Add('      branche_univers = new.branche_univers || ''|'' || id_univers');
    Script.Add('    where');
    Script.Add('      id_univers_parent = new.id_univers;');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization

RegisterFBUpdate('2.2.3.21', @MAJ2_2_3_21);

end.
