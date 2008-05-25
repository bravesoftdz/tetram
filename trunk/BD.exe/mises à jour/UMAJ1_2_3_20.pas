unit UMAJ1_2_3_20;

interface

implementation

uses JvUIB, Updates;

procedure MAJ1_2_3_20(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('CREATE VIEW VW_LISTE_EDITEURS_ACHATALBUMS(');
    Script.Add('    ID_ALBUM,');
    Script.Add('    TITREALBUM,');
    Script.Add('    TOME,');
    Script.Add('    TOMEDEBUT,');
    Script.Add('    TOMEFIN,');
    Script.Add('    HORSSERIE,');
    Script.Add('    INTEGRALE,');
    Script.Add('    MOISPARUTION,');
    Script.Add('    ANNEEPARUTION,');
    Script.Add('    ID_SERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    UPPERTITREALBUM,');
    Script.Add('    ID_EDITEUR,');
    Script.Add('    NOMEDITEUR,');
    Script.Add('    UPPERNOMEDITEUR,');
    Script.Add('    UPPERTITRESERIE,');
    Script.Add('    ACHAT,');
    Script.Add('    COMPLET)');
    Script.Add('AS');
    Script.Add('select a.ID_ALBUM,');
    Script.Add('       a.TITREALBUM,');
    Script.Add('       a.TOME,');
    Script.Add('       a.TOMEDEBUT,');
    Script.Add('       a.TOMEFIN,');
    Script.Add('       a.HORSSERIE,');
    Script.Add('       a.INTEGRALE,');
    Script.Add('       a.MOISPARUTION,');
    Script.Add('       a.ANNEEPARUTION,');
    Script.Add('       a.ID_SERIE,');
    Script.Add('       a.TITRESERIE,');
    Script.Add('       a.UPPERTITREALBUM,');
    Script.Add('       e.ID_EDITEUR,');
    Script.Add('       e.NOMEDITEUR,');
    Script.Add('       e.UPPERNOMEDITEUR,');
    Script.Add('       a.UPPERTITRESERIE,');
    Script.Add('       a.ACHAT,');
    Script.Add('       a.COMPLET');
    Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN SERIES s ON s.id_serie = a.id_serie');
    Script.Add('                       LEFT JOIN EDITEURS e ON e.ID_EDITEUR = s.id_editeur;');

    Script.Add('CREATE PROCEDURE EDITEURS_ACHATALBUMS (');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    nomediteur varchar(50),');
    Script.Add('    countediteur integer,');
    Script.Add('    id_editeur char(38))');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             CAST(''''-1'''' AS VARCHAR(50)),');
    Script.Add('             Count(ID_ALBUM),');
    Script.Add('             NULL');
    Script.Add('      from vw_liste_editeurs_achatalbums');
    Script.Add('      where ID_EDITEUR is null '' || SWHERE ||');
    Script.Add('     ''group by uppernomediteur, nomediteur, ID_editeur''');
    Script.Add('  into :nomediteur,');
    Script.Add('       :countediteur,');
    Script.Add('       :ID_Editeur');
    Script.Add('  do begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             nomediteur,');
    Script.Add('             Count(ID_ALBUM),');
    Script.Add('             ID_Editeur');
    Script.Add('      from vw_liste_editeurs_achatalbums');
    Script.Add('      where ID_EDITEUR is not null '' || SWHERE ||');
    Script.Add('     ''group by uppernomediteur, nomediteur, ID_editeur''');
    Script.Add('  into :nomediteur,');
    Script.Add('       :countediteur,');
    Script.Add('       :ID_Editeur');
    Script.Add('  do begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('CREATE PROCEDURE ACHATALBUMS_BY_EDITEUR (');
    Script.Add('    id_editeur char(38),');
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
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
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
    Script.Add('      from albums a LEFT JOIN series s on a.id_serie = s.ID_SERIE');
    Script.Add('      WHERE coalesce(s.id_editeur, -1) = '''''' || :id_editeur || '''''' '' || swhere ||');
    Script.Add('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
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

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('1.2.3.20', @MAJ1_2_3_20);

end.

