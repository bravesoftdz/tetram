unit UMAJ2_2_3_16;

interface

implementation

uses
  SysUtils, UIB, UIBLib, Updates;

procedure MAJ2_2_3_16(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('create domain t_siteweb as varchar(255) character set utf8 collate utf8;');

    Script.Add('create table univers (');
    Script.Add('  id_univers t_guid_notnull,');
    Script.Add('  nomunivers t_nom_utf8 not null,');
    Script.Add('  description t_description_utf8,');
    Script.Add('  initialenomunivers t_initiale_utf8,');
    Script.Add('  siteweb t_siteweb,');
    Script.Add('  id_universparent t_guid');
    Script.Add(');');

    ExecuteScript;
  end;
end;

initialization

RegisterFBUpdate('2.2.3.16', @MAJ2_2_3_16);

end.
