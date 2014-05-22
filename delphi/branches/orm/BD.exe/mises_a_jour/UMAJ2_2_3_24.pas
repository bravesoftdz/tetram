unit UMAJ2_2_3_24;

interface

uses
  System.SysUtils;

implementation

uses
  uib, Updates;

procedure MAJ2_2_3_24(Query: TUIBScript);
var
  idfieldname, currenttable, dcfieldname, dmfieldname, dsfieldname: string;
  qry: TUIBQuery;
begin
  Query.Script.Add('drop trigger criteres_biu0;');
  Query.Script.Add('alter table suppressions add constraint pk_suppressions primary key (id_suppression);');
  Query.Script.Add('drop trigger options_scripts_uniqid_biu0;');
  Query.Script.Add('alter table options_scripts alter dc_options to dc_options_scripts, alter dm_options to dm_options_scripts;');

  qry := TUIBQuery.Create(Query.Transaction);
  try
    qry.SQL.Add('select');
    qry.SQL.Add('  r.rdb$relation_name,');
    qry.SQL.Add('  s.rdb$field_name');
    qry.SQL.Add('from');
    qry.SQL.Add('  rdb$index_segments s');
    qry.SQL.Add('  inner join rdb$indices i on');
    qry.SQL.Add('    s.rdb$index_name = i.rdb$index_name');
    qry.SQL.Add('  inner join rdb$relations r on');
    qry.SQL.Add('    i.rdb$relation_name = r.rdb$relation_name');
    qry.SQL.Add('where');
    qry.SQL.Add('  r.rdb$view_blr is null');
    qry.SQL.Add('  and r.rdb$system_flag = 0');
    qry.SQL.Add('  and i.rdb$unique_flag = 1');
    qry.SQL.Add('  and i.rdb$segment_count = 1');
    qry.SQL.Add('  and s.rdb$field_name starting with ''ID_''');
    qry.SQL.Add('order by');
    qry.SQL.Add('  r.rdb$relation_name');
    qry.Open;
    while not qry.Eof do
    begin
      currenttable := qry.Fields.AsString[0].Trim;
      idfieldname := qry.Fields.AsString[1].Trim;
      dcfieldname := 'dc_' + currenttable;
      dmfieldname := 'dm_' + currenttable;
      dsfieldname := 'ds_' + currenttable;

      Query.Script.Add('alter table ' + currenttable + ' add ' + dsfieldname + ' timestamp;');

      Query.Script.Add('create or alter trigger ' + currenttable + '_uniqid_biu0 for ' + currenttable);
      Query.Script.Add('active before insert or update position 0');
      Query.Script.Add('as');
      Query.Script.Add('begin');
      Query.Script.Add('  if (new.' + idfieldname + ' is null) then new.' + idfieldname + ' = old.' + idfieldname + ';');
      Query.Script.Add('  if (new.' + idfieldname + ' is null) then new.' + idfieldname + ' = udf_createguid();');
      Query.Script.Add('');
      Query.Script.Add('  if (new.' + dcfieldname + ' is null) then new.' + dcfieldname + ' = old.' + dcfieldname + ';');
      Query.Script.Add('');
      Query.Script.Add('  if (new.' + dmfieldname + ' is not distinct from old.' + dmfieldname + ') then');
      Query.Script.Add('    new.' + dmfieldname + ' = cast(''now'' as timestamp);');
      Query.Script.Add('  if (inserting or new.' + dcfieldname + ' is null) then new.' + dcfieldname + ' = new.' + dmfieldname + ';');
      Query.Script.Add('end;');

      qry.Next;
    end;
  finally
    qry.Free;
  end;

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.24', @MAJ2_2_3_24);

end.
