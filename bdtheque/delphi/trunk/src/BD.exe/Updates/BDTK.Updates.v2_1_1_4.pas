unit BDTK.Updates.v2_1_1_4;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ2_1_1_4(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create table options_scripts (');
  Query.Script.Add('    id_option   t_guid_notnull,');
  Query.Script.Add('    Query.Script      varchar(50) character set iso8859_1 not null collate fr_fr_ci_ai,');
  Query.Script.Add('    nom_option  varchar(50) character set iso8859_1 not null collate fr_fr_ci_ai,');
  Query.Script.Add('    valeur      varchar(255),');
  Query.Script.Add('    dc_options  t_timestamp_notnull,');
  Query.Script.Add('    dm_options  t_timestamp_notnull');
  Query.Script.Add(');');

  Query.Script.Add('alter table options_scripts add constraint options_scripts_unqid unique (id_option);');
  Query.Script.Add('alter table options_scripts add constraint options_scripts_pk primary key (script, nom_option);');

  Query.Script.Add('create or alter trigger options_scripts_uniqid_biu0 for options_scripts');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_option is null) then new.id_option = old.id_option;');
  Query.Script.Add('  if (new.id_option is null) then new.id_option = udf_createguid();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_options is null) then new.dc_options = old.dc_options;');
  Query.Script.Add('');
  Query.Script.Add('  new.dm_options = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_options is null) then new.dc_options = new.dm_options;');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.1.4', @MAJ2_1_1_4);

end.
