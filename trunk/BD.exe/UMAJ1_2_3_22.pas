unit UMAJ1_2_3_22;

interface

implementation

uses JvUIB, Updates;

procedure MAJ1_2_3_22(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('ALTER PROCEDURE INITIALES_ALBUMS (');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    initialetitrealbum char(1),');
    Script.Add('    countinitiale integer)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''WHERE '' || filtre;');
    Script.Add('  for execute statement');
    Script.Add('      ''select coalesce(initialetitrealbum, initialetitreserie),');
    Script.Add('               Count(ID_ALBUM)');
    Script.Add('      from ALBUMS left join series on albums.id_serie = series.id_serie '' || SWHERE ||');
    Script.Add('      '' group by 1''');
    Script.Add('      into :INITIALETITREALBUM,');
    Script.Add('           :COUNTINITIALE');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('end;');

    Script.Add('ALTER PROCEDURE ALBUMS_BY_INITIALE (');
    Script.Add('    initiale char(1),');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    id_album char(38),');
    Script.Add('    titrealbum varchar(150),');
    Script.Add('    tome smallint,');
    Script.Add('    tomedebut smallint,');
    Script.Add('    tomefin smallint,');
    Script.Add('    horsserie smallint,');
    Script.Add('    integrale smallint,');
    Script.Add('    moisparution smallint,');
    Script.Add('    anneeparution smallint,');
    Script.Add('    id_serie char(38),');
    Script.Add('    titreserie varchar(150),');
    Script.Add('    achat smallint,');
    Script.Add('    complet integer)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('BEGIN');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = '' and '' || filtre || '' '';');
    Script.Add('  FOR execute statement');
    Script.Add('     ''SELECT a.ID_ALBUM,');
    Script.Add('             a.TITREALBUM,');
    Script.Add('             a.TOME,');
    Script.Add('             a.TOMEDEBUT,');
    Script.Add('             a.TOMEFIN,');
    Script.Add('             a.HORSSERIE,');
    Script.Add('             a.INTEGRALE,');
    Script.Add('             a.MOISPARUTION,');
    Script.Add('             a.ANNEEPARUTION,');
    Script.Add('             a.ID_SERIE,');
    Script.Add('             s.TITRESERIE,');
    Script.Add('             a.ACHAT,');
    Script.Add('             a.COMPLET');
    Script.Add('      FROM ALBUMS a LEFT JOIN SERIES s ON s.ID_SERIE = a.id_serie');
    Script.Add('      WHERE coalesce(a.initialetitrealbum, s.initialetitreserie) = '''''' ||: INITIALE || '''''' '' || swhere ||');
    Script.Add('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST ''');
    Script.Add('      INTO :ID_ALBUM,');
    Script.Add('           :TITREALBUM,');
    Script.Add('           :TOME,');
    Script.Add('           :TOMEDEBUT,');
    Script.Add('           :TOMEFIN,');
    Script.Add('           :HORSSERIE,');
    Script.Add('           :INTEGRALE,');
    Script.Add('           :MOISPARUTION,');
    Script.Add('           :ANNEEPARUTION,');
    Script.Add('           :ID_SERIE,');
    Script.Add('           :TITRESERIE,');
    Script.Add('           :ACHAT,');
    Script.Add('           :COMPLET');
    Script.Add('  DO');
    Script.Add('  BEGIN');
    Script.Add('    SUSPEND;');
    Script.Add('  END');
    Script.Add('end;');

    Script.Add('update albums set initialetitrealbum = null, uppertitrealbum = null where titrealbum is null;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('1.2.3.22', @MAJ1_2_3_22);

end.

