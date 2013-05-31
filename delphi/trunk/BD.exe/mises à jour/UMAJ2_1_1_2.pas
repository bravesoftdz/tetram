unit UMAJ2_1_1_2;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_1_2(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('create table import_associations (');
    Script.Add('  chaine varchar(150) character set iso8859_1 not null collate fr_fr_ci_ai,');
    Script.Add('  id t_guid_notnull,');
    Script.Add('  parentid t_guid_notnull,');
    Script.Add('  typedata smallint not null,');
    Script.Add('  always t_yesno_baseno);');
    Script.Add('alter table import_associations add constraint pk_import_associations primary key (chaine,typedata,parentid);');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.1.2', @MAJ2_1_1_2);


end.
