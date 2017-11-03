unit UMAJ0_0_3_01;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_3_01(Query: TJvUIBScript);

  function HasUpgradeToDo: Boolean;
  begin
    with TJvUIBQuery.Create(Query.Transaction) do try
      SQL.Text := 'select count(*) from RDB$RELATION_FIELDS where rdb$field_name = ''SITEWEB'' and rdb$relation_name = ''SERIES'';';
      Open;
      Result := Fields.AsInteger[0] = 0;
    finally
      Free;
    end;
  end;

begin
  if not HasUpgradeToDo then Exit;
  with Query do begin
    Script.Clear;

    Script.Add('ALTER TABLE SERIES ADD SITEWEB VARCHAR(255);');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('0.0.3.1', @MAJ0_0_3_01);
  RegisterUpdate('0.0.3.9', @MAJ0_0_3_01); // le passage de 0.0.2.22 � 0.0.3.7 n'a pas forc�ment vu cette maj

end.
