unit BDTK.Updates.v0_0_3_02;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_3_02(Query: TUIBScript);

  function HasUpgradeToDo: Boolean;
  var
    qry: TUIBQuery;
  begin
    qry := TUIBQuery.Create(Query.Transaction);
    try
      qry.SQL.Text := 'select count(*) from RDB$RELATION_FIELDS where rdb$field_name = ''GRATUIT'' and rdb$relation_name = ''EDITIONS'';';
      qry.Open;
      Result := qry.Fields.AsInteger[0] = 0;
    finally
      qry.Free;
    end;
  end;

begin
  if not HasUpgradeToDo then
    Exit;

  Query.Script.Clear;

  Query.Script.Add('ALTER TABLE EDITIONS ADD GRATUIT T_YESNO_BASENO, ADD OFFERT T_YESNO_BASENO;');

  Query.Script.Add('UPDATE EDITIONS SET OFFERT = 0 WHERE PRIX IS NOT NULL;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.3.2', @MAJ0_0_3_02);
RegisterFBUpdate('0.0.3.10', @MAJ0_0_3_02); // le passage de 0.0.2.22 à 0.0.3.7 n'a pas forcément vu cette maj

end.
