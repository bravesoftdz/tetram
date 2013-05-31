unit UMAJ0_0_2_23;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_2_23(Query: TUIBScript);

  function HasUpgradeToDo: Boolean;
  begin
    with TUIBQuery.Create(Query.Transaction) do try
      SQL.Text := 'select count(*) from RDB$RELATION_FIELDS where rdb$field_name = ''ACHAT'' and rdb$relation_name = ''EDITIONS'';';
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

    Script.Add('ALTER TABLE EDITIONS ADD ACHAT DATE;');

    Script.Add('ALTER PROCEDURE SERIES_ALBUMS (');
    Script.Add('    FILTRE VARCHAR(125))');
    Script.Add('RETURNS (');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    COUNTSERIE INTEGER,');
    Script.Add('    REFSERIE INTEGER)');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE SWHERE VARCHAR(132);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             -1,');
    Script.Add('             RefSerie,');
    Script.Add('             Count(REFALBUM)');
    Script.Add('      from vw_liste_albums');
    Script.Add('      where TITRESerie is null '' || SWHERE ||');
    Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
    Script.Add('  into :TITRESerie,');
    Script.Add('       :RefSerie,');
    Script.Add('       :countSerie');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             TITRESerie,');
    Script.Add('             RefSerie,');
    Script.Add('             Count(REFALBUM)');
    Script.Add('      from vw_liste_albums');
    Script.Add('      where TITRESerie is not null '' || SWHERE ||');
    Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
    Script.Add('  into :TITRESerie,');
    Script.Add('       :RefSerie,');
    Script.Add('       :countSerie');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('end;');

    Script.Add('ALTER PROCEDURE ALBUMS_BY_SERIE (');
    Script.Add('    SERIE INTEGER,');
    Script.Add('    FILTRE VARCHAR(125))');
    Script.Add('RETURNS (');
    Script.Add('    REFALBUM INTEGER,');
    Script.Add('    TITREALBUM VARCHAR(150),');
    Script.Add('    TOME SMALLINT,');
    Script.Add('    TOMEDEBUT SMALLINT,');
    Script.Add('    TOMEFIN SMALLINT,');
    Script.Add('    HORSSERIE SMALLINT,');
    Script.Add('    INTEGRALE SMALLINT,');
    Script.Add('    ANNEEPARUTION SMALLINT,');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150))');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE SWHERE VARCHAR(130);');
    Script.Add('BEGIN');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
    Script.Add('  FOR execute statement');
    Script.Add('      ''SELECT REFALBUM,');
    Script.Add('             TITREALBUM,');
    Script.Add('             TOME,');
    Script.Add('             TOMEDEBUT,');
    Script.Add('             TOMEFIN,');
    Script.Add('             HORSSERIE,');
    Script.Add('             INTEGRALE,');
    Script.Add('             ANNEEPARUTION,');
    Script.Add('             REFSERIE,');
    Script.Add('             TITRESERIE');
    Script.Add('      FROM vw_liste_albums');
    Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
    Script.Add('      ''ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, UPPERTITREALBUM''');
    Script.Add('      INTO :REFALBUM,');
    Script.Add('           :TITREALBUM,');
    Script.Add('           :TOME,');
    Script.Add('           :TOMEDEBUT,');
    Script.Add('           :TOMEFIN,');
    Script.Add('           :HORSSERIE,');
    Script.Add('           :INTEGRALE,');
    Script.Add('           :ANNEEPARUTION,');
    Script.Add('           :REFSERIE,');
    Script.Add('           :TITRESERIE');
    Script.Add('  DO');
    Script.Add('  BEGIN');
    Script.Add('    SUSPEND;');
    Script.Add('  END');
    Script.Add('END;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.2.23', @MAJ0_0_2_23);
  RegisterFBUpdate('0.0.3.8', @MAJ0_0_2_23); // le passage de 0.0.2.22 à 0.0.3.7 n'a pas forcément vu cette maj

end.
