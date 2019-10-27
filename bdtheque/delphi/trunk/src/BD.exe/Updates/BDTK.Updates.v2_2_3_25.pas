unit BDTK.Updates.v2_2_3_25;

interface

implementation

uses
  System.SysUtils, UIB, UIBLib, BDTK.Updates;

procedure MAJ2_2_3_25(Query: TUIBScript);
begin
  Query.Script.Add('create table photos (');
  Query.Script.Add('    id_photo       t_guid_notnull,');
  Query.Script.Add('    id_parabd      t_guid_notnull,');
  Query.Script.Add('    ordre          integer,');
  Query.Script.Add('    stockagephoto  smallint,');
  Query.Script.Add('    imagephoto     blob sub_type 0 segment size 80,');
  Query.Script.Add('    dc_photos      t_timestamp_notnull,');
  Query.Script.Add('    dm_photos      t_timestamp_notnull,');
  Query.Script.Add('    fichierphoto   varchar(255),');
  Query.Script.Add('    ds_photos      timestamp');
  Query.Script.Add(');');

  Query.Script.Add('alter table photos add constraint photos_pk primary key (id_photo);');
  Query.Script.Add('alter table photos add constraint photos_fk1 foreign key (id_parabd) references parabd (id_parabd) on delete cascade on update cascade;');

  Query.Script.Add('create index photos_idx1 on photos (ordre, id_photo);');

  Query.Script.Add('create or alter trigger photos_logsup_ad0 for photos');
  Query.Script.Add('active after delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''PHOTOS'', ''id_photo'', old.id_photo);');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger photos_uniqid_biu0 for photos');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_photo is null) then new.id_photo = old.id_photo;');
  Query.Script.Add('  if (new.id_photo is null) then new.id_photo = udf_createguid();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_photos is null) then new.dc_photos = old.dc_photos;');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dm_photos is not distinct from old.dm_photos) then');
  Query.Script.Add('    new.dm_photos = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_photos is null) then new.dc_photos = new.dm_photos;');
  Query.Script.Add('end;');

  Query.Script.Add('insert into photos (id_parabd, ordre, stockagephoto, imagephoto, fichierphoto)');
  Query.Script.Add('select id_parabd, 0, stockageparabd, imageparabd, fichierparabd');
  Query.Script.Add('from parabd');
  Query.Script.Add('where imageparabd is not null or fichierparabd is not null;');

  Query.Script.Add('alter table parabd drop stockageparabd, drop imageparabd, drop fichierparabd;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.25', @MAJ2_2_3_25);

end.
