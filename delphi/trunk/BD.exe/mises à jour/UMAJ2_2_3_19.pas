unit UMAJ2_2_3_19;

interface

uses
  SysUtils, UIB, UIBLib, Updates;

implementation

procedure MAJ2_2_3_19(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('create or alter trigger univers_ad0 for univers');
    Script.Add('active after delete position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  update univers set');
    Script.Add('    id_univers_parent = null');
    Script.Add('  where');
    Script.Add('    id_univers_parent = old.id_univers;');
    Script.Add('end;');

    Script.Add('create or alter trigger series_ad0 for series');
    Script.Add('active after delete position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  update albums set id_serie = null where id_serie = old.id_serie;');
    Script.Add('  update parabd set id_serie = null where id_serie = old.id_serie;');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization

RegisterFBUpdate('2.2.3.19', @MAJ2_2_3_19);

end.
