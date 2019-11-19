unit BDTK.Updates.v2_2_3_19;

interface

implementation

uses
  System.SysUtils, UIB, UIBLib, BDTK.Updates;

procedure MAJ2_2_3_19(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create or alter trigger univers_ad0 for univers');
  Query.Script.Add('active after delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  update univers set');
  Query.Script.Add('    id_univers_parent = null');
  Query.Script.Add('  where');
  Query.Script.Add('    id_univers_parent = old.id_univers;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger series_ad0 for series');
  Query.Script.Add('active after delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  update albums set id_serie = null where id_serie = old.id_serie;');
  Query.Script.Add('  update parabd set id_serie = null where id_serie = old.id_serie;');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.19', @MAJ2_2_3_19);

end.
