unit BDTK.Updates.v1_2_3_22;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ1_2_3_22(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER PROCEDURE INITIALES_ALBUMS (');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    initialetitrealbum char(1),');
  Query.Script.Add('    countinitiale integer)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''WHERE '' || filtre;');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('      ''select coalesce(initialetitrealbum, initialetitreserie),');
  Query.Script.Add('               Count(ID_ALBUM)');
  Query.Script.Add('      from ALBUMS left join series on albums.id_serie = series.id_serie '' || SWHERE ||');
  Query.Script.Add('      '' group by 1''');
  Query.Script.Add('      into :INITIALETITREALBUM,');
  Query.Script.Add('           :COUNTINITIALE');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_INITIALE (');
  Query.Script.Add('    initiale char(1),');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_album char(38),');
  Query.Script.Add('    titrealbum varchar(150),');
  Query.Script.Add('    tome smallint,');
  Query.Script.Add('    tomedebut smallint,');
  Query.Script.Add('    tomefin smallint,');
  Query.Script.Add('    horsserie smallint,');
  Query.Script.Add('    integrale smallint,');
  Query.Script.Add('    moisparution smallint,');
  Query.Script.Add('    anneeparution smallint,');
  Query.Script.Add('    id_serie char(38),');
  Query.Script.Add('    titreserie varchar(150),');
  Query.Script.Add('    achat smallint,');
  Query.Script.Add('    complet integer)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = '' and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('     ''SELECT a.ID_ALBUM,');
  Query.Script.Add('             a.TITREALBUM,');
  Query.Script.Add('             a.TOME,');
  Query.Script.Add('             a.TOMEDEBUT,');
  Query.Script.Add('             a.TOMEFIN,');
  Query.Script.Add('             a.HORSSERIE,');
  Query.Script.Add('             a.INTEGRALE,');
  Query.Script.Add('             a.MOISPARUTION,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.ID_SERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      FROM ALBUMS a LEFT JOIN SERIES s ON s.ID_SERIE = a.id_serie');
  Query.Script.Add('      WHERE coalesce(a.initialetitrealbum, s.initialetitreserie) = '''''' ||: INITIALE || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST ''');
  Query.Script.Add('      INTO :ID_ALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :MOISPARUTION,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :ID_SERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET');
  Query.Script.Add('  DO');
  Query.Script.Add('  BEGIN');
  Query.Script.Add('    SUSPEND;');
  Query.Script.Add('  END');
  Query.Script.Add('end;');

  Query.Script.Add('update albums set initialetitrealbum = null, uppertitrealbum = null where titrealbum is null;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.2.3.22', @MAJ1_2_3_22);

end.
