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
    Script.Add('  id_universparent t_guid,');
    Script.Add('  dc_univers t_timestamp_notnull,');
    Script.Add('  dm_univers t_timestamp_notnull');
    Script.Add(');');

    Script.Add('alter table univers add constraint pk_univers primary key (id_univers);');

    Script.Add('create or alter trigger univers_uniqid_biu0 for univers');
    Script.Add('active before insert or update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  if (new.id_univers is null) then new.id_univers = old.id_univers;');
    Script.Add('  if (new.id_univers is null) then new.id_univers = udf_createguid();');
    Script.Add('');
    Script.Add('  if (new.dc_univers is null) then new.dc_univers = old.dc_univers;');
    Script.Add('');
    Script.Add('  new.dm_univers = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.dc_univers is null) then new.dc_univers = new.dm_univers;');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization

RegisterFBUpdate('2.2.3.16', @MAJ2_2_3_16);

end.
