unit UMySQLMAJ1_0_0_1;

interface

uses Classes, Updates;

implementation

procedure MAJ1_0_0_1(Script: TStrings);
begin
  with Script do
  begin
    Clear;
    Add('ALTER TABLE /*DB_PREFIX*/series');
    Add('  add etat int(11) default NULL,');
    Add('  add reliure int(11) default NULL,');
    Add('  add typeedition int(11) default NULL,');
    Add('  add orientation int(11) default NULL,');
    Add('  add formatedition int(11) default NULL,');
    Add('  add senslecture int(11) default NULL,');
    Add('  add vo smallint(6) default 0,');
    Add('  add couleur smallint(6) default 0;');
    Add('@@');
  end;
end;

initialization

RegisterMySQLUpdate('1.0.0.1', @MAJ1_0_0_1);

end.
