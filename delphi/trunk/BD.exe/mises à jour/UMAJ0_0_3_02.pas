unit UMAJ0_0_3_02;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_3_02(Query: TUIBScript);

  function HasUpgradeToDo: Boolean;
  begin
    with TUIBQuery.Create(Query.Transaction) do try
      SQL.Text := 'select count(*) from RDB$RELATION_FIELDS where rdb$field_name = ''GRATUIT'' and rdb$relation_name = ''EDITIONS'';';
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

    Script.Add('ALTER TABLE EDITIONS ADD GRATUIT T_YESNO_BASENO, ADD OFFERT T_YESNO_BASENO;');

    Script.Add('UPDATE EDITIONS SET OFFERT = 0 WHERE PRIX IS NOT NULL;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.3.2', @MAJ0_0_3_02);
  RegisterFBUpdate('0.0.3.10', @MAJ0_0_3_02); // le passage de 0.0.2.22 à 0.0.3.7 n'a pas forcément vu cette maj

end.
