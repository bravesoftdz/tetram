unit UMAJ2_1_1_4;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_1_4(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('create table options_scripts (');
    Script.Add('    id_option   t_guid_notnull,');
    Script.Add('    script      varchar(50) character set iso8859_1 not null collate fr_fr_ci_ai,');
    Script.Add('    nom_option  varchar(50) character set iso8859_1 not null collate fr_fr_ci_ai,');
    Script.Add('    valeur      varchar(255),');
    Script.Add('    dc_options  t_timestamp_notnull,');
    Script.Add('    dm_options  t_timestamp_notnull');
    Script.Add(');');

    Script.Add('alter table options_scripts add constraint options_scripts_unqid unique (id_option);');
    Script.Add('alter table options_scripts add constraint options_scripts_pk primary key (script, nom_option);');

    Script.Add('create or alter trigger options_scripts_uniqid_biu0 for options_scripts');
    Script.Add('active before insert or update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  if (new.id_option is null) then new.id_option = old.id_option;');
    Script.Add('  if (new.id_option is null) then new.id_option = udf_createguid();');
    Script.Add('');
    Script.Add('  if (new.dc_options is null) then new.dc_options = old.dc_options;');
    Script.Add('');
    Script.Add('  new.dm_options = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.dc_options is null) then new.dc_options = new.dm_options;');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.1.4', @MAJ2_1_1_4);


end.
