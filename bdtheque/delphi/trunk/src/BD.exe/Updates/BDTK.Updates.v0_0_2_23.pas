unit BDTK.Updates.v0_0_2_23;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_2_23(Query: TUIBScript);

  function HasUpgradeToDo: Boolean;
  var
    qry: TUIBQuery;
  begin
    qry := TUIBQuery.Create(Query.Transaction);
    try
      qry.SQL.Text := 'select count(*) from RDB$RELATION_FIELDS where rdb$field_name = ''ACHAT'' and rdb$relation_name = ''EDITIONS'';';
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

  Query.Script.Add('ALTER TABLE EDITIONS ADD ACHAT DATE;');

  Query.Script.Add('ALTER PROCEDURE SERIES_ALBUMS (');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    COUNTSERIE INTEGER,');
  Query.Script.Add('    REFSERIE INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(132);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             -1,');
  Query.Script.Add('             RefSerie,');
  Query.Script.Add('             Count(REFALBUM)');
  Query.Script.Add('      from vw_liste_albums');
  Query.Script.Add('      where TITRESerie is null '' || SWHERE ||');
  Query.Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
  Query.Script.Add('  into :TITRESerie,');
  Query.Script.Add('       :RefSerie,');
  Query.Script.Add('       :countSerie');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             TITRESerie,');
  Query.Script.Add('             RefSerie,');
  Query.Script.Add('             Count(REFALBUM)');
  Query.Script.Add('      from vw_liste_albums');
  Query.Script.Add('      where TITRESerie is not null '' || SWHERE ||');
  Query.Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
  Query.Script.Add('  into :TITRESerie,');
  Query.Script.Add('       :RefSerie,');
  Query.Script.Add('       :countSerie');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_SERIE (');
  Query.Script.Add('    SERIE INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(130);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('      ''SELECT REFALBUM,');
  Query.Script.Add('             TITREALBUM,');
  Query.Script.Add('             TOME,');
  Query.Script.Add('             TOMEDEBUT,');
  Query.Script.Add('             TOMEFIN,');
  Query.Script.Add('             HORSSERIE,');
  Query.Script.Add('             INTEGRALE,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             REFSERIE,');
  Query.Script.Add('             TITRESERIE');
  Query.Script.Add('      FROM vw_liste_albums');
  Query.Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
  Query.Script.Add('      ''ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, UPPERTITREALBUM''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE');
  Query.Script.Add('  DO');
  Query.Script.Add('  BEGIN');
  Query.Script.Add('    SUSPEND;');
  Query.Script.Add('  END');
  Query.Script.Add('END;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.2.23', @MAJ0_0_2_23);
RegisterFBUpdate('0.0.3.8', @MAJ0_0_2_23); // le passage de 0.0.2.22 à 0.0.3.7 n'a pas forcément vu cette maj

end.
