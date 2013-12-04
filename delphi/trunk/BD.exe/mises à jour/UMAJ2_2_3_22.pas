unit UMAJ2_2_3_22;

interface

uses
  SysUtils, UIB, UIBLib, Updates;

implementation

procedure MAJ2_2_3_22(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('alter table albums_univers add id_album_univers t_guid_notnull;');
  Query.Script.Add('alter table series_univers add id_serie_univers t_guid_notnull;');
  Query.Script.Add('alter table parabd_univers add id_parabd_univers t_guid_notnull;');

  Query.Script.Add('create or alter trigger albums_univers_uniqid_biu0 for albums_univers');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_album_univers is null) then new.id_album_univers = old.id_album_univers;');
  Query.Script.Add('  if (new.id_album_univers is null) then new.id_album_univers = udf_createguid();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_albums_univers is null) then new.dc_albums_univers = old.dc_albums_univers;');
  Query.Script.Add('');
  Query.Script.Add('  new.dm_albums_univers = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_albums_univers is null) then new.dc_albums_univers = new.dm_albums_univers;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger series_univers_uniqid_biu0 for series_univers');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_serie_univers is null) then new.id_serie_univers = old.id_serie_univers;');
  Query.Script.Add('  if (new.id_serie_univers is null) then new.id_serie_univers = udf_createguid();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_series_univers is null) then new.dc_series_univers = old.dc_series_univers;');
  Query.Script.Add('');
  Query.Script.Add('  new.dm_series_univers = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_series_univers is null) then new.dc_series_univers = new.dm_series_univers;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger parabd_univers_uniqid_biu0 for parabd_univers');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_parabd_univers is null) then new.id_parabd_univers = old.id_parabd_univers;');
  Query.Script.Add('  if (new.id_parabd_univers is null) then new.id_parabd_univers = udf_createguid();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_parabd_univers is null) then new.dc_parabd_univers = old.dc_parabd_univers;');
  Query.Script.Add('');
  Query.Script.Add('  new.dm_parabd_univers = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_parabd_univers is null) then new.dc_parabd_univers = new.dm_parabd_univers;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger albums_univers_logsup_ad0 for albums_univers');
  Query.Script.Add('active after delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''ALBUMS_UNIVERS'', ''id_album_univers'', old.id_album_univers);');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger series_univers_logsup_ad0 for series_univers');
  Query.Script.Add('active after delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''SERIES_UNIVERS'', ''id_serie_univers'', old.id_serie_univers);');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger parabd_univers_logsup_ad0 for parabd_univers');
  Query.Script.Add('active after delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''PARABD_UNIVERS'', ''id_parabd_univers'', old.id_parabd_univers);');
  Query.Script.Add('end;');

  Query.Script.Add('update albums_univers set id_album_univers = id_album_univers;');
  Query.Script.Add('update series_univers set id_serie_univers = id_serie_univers;');
  Query.Script.Add('update parabd_univers set id_parabd_univers = id_parabd_univers;');

  Query.Script.Add('alter table albums_univers add constraint unq1_albums_univers unique (id_album_univers);');
  Query.Script.Add('alter table series_univers add constraint unq1_series_univers unique (id_serie_univers);');
  Query.Script.Add('alter table parabd_univers add constraint unq1_parabd_univers unique (id_parabd_univers);');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.22', @MAJ2_2_3_22);

end.
