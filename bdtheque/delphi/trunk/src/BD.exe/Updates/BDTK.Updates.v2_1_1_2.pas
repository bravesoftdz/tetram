unit BDTK.Updates.v2_1_1_2;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ2_1_1_2(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create table import_associations (');
  Query.Script.Add('  chaine varchar(150) character set iso8859_1 not null collate fr_fr_ci_ai,');
  Query.Script.Add('  id t_guid_notnull,');
  Query.Script.Add('  parentid t_guid_notnull,');
  Query.Script.Add('  typedata smallint not null,');
  Query.Script.Add('  always t_yesno_baseno);');
  Query.Script.Add('alter table import_associations add constraint pk_import_associations primary key (chaine,typedata,parentid);');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.1.2', @MAJ2_1_1_2);

end.
