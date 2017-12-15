unit BDTK.Updates.v0_0_3_01;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_3_01(Query: TUIBScript);

  function HasUpgradeToDo: Boolean;
  var
    qry: TUIBQuery;
  begin
    qry := TUIBQuery.Create(Query.Transaction);
    try
      qry.SQL.Text := 'select count(*) from RDB$RELATION_FIELDS where rdb$field_name = ''SITEWEB'' and rdb$relation_name = ''SERIES'';';
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

  Query.Script.Add('ALTER TABLE SERIES ADD SITEWEB VARCHAR(255);');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.3.1', @MAJ0_0_3_01);
RegisterFBUpdate('0.0.3.9', @MAJ0_0_3_01); // le passage de 0.0.2.22 à 0.0.3.7 n'a pas forcément vu cette maj

end.
