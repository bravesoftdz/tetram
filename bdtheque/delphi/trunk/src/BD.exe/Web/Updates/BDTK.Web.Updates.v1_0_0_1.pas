unit BDTK.Web.Updates.v1_0_0_1;

interface

uses
  System.Classes, BDTK.Updates;

implementation

procedure MAJ1_0_0_1(Script: TStrings);
begin
  Script.Clear;
  Script.Add('ALTER TABLE /*DB_PREFIX*/series');
  Script.Add('  add etat int(11) default NULL,');
  Script.Add('  add reliure int(11) default NULL,');
  Script.Add('  add typeedition int(11) default NULL,');
  Script.Add('  add orientation int(11) default NULL,');
  Script.Add('  add formatedition int(11) default NULL,');
  Script.Add('  add senslecture int(11) default NULL,');
  Script.Add('  add vo smallint(6) default 0,');
  Script.Add('  add couleur smallint(6) default 0;');
  Script.Add('@@');
end;

initialization

RegisterMySQLUpdate('1.0.0.1', @MAJ1_0_0_1);

end.
