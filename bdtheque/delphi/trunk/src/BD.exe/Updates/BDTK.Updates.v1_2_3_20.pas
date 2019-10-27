unit BDTK.Updates.v1_2_3_20;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ1_2_3_20(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('CREATE VIEW VW_LISTE_EDITEURS_ACHATALBUMS(');
  Query.Script.Add('    ID_ALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    MOISPARUTION,');
  Query.Script.Add('    ANNEEPARUTION,');
  Query.Script.Add('    ID_SERIE,');
  Query.Script.Add('    TITRESERIE,');
  Query.Script.Add('    UPPERTITREALBUM,');
  Query.Script.Add('    ID_EDITEUR,');
  Query.Script.Add('    NOMEDITEUR,');
  Query.Script.Add('    UPPERNOMEDITEUR,');
  Query.Script.Add('    UPPERTITRESERIE,');
  Query.Script.Add('    ACHAT,');
  Query.Script.Add('    COMPLET)');
  Query.Script.Add('AS');
  Query.Script.Add('select a.ID_ALBUM,');
  Query.Script.Add('       a.TITREALBUM,');
  Query.Script.Add('       a.TOME,');
  Query.Script.Add('       a.TOMEDEBUT,');
  Query.Script.Add('       a.TOMEFIN,');
  Query.Script.Add('       a.HORSSERIE,');
  Query.Script.Add('       a.INTEGRALE,');
  Query.Script.Add('       a.MOISPARUTION,');
  Query.Script.Add('       a.ANNEEPARUTION,');
  Query.Script.Add('       a.ID_SERIE,');
  Query.Script.Add('       a.TITRESERIE,');
  Query.Script.Add('       a.UPPERTITREALBUM,');
  Query.Script.Add('       e.ID_EDITEUR,');
  Query.Script.Add('       e.NOMEDITEUR,');
  Query.Script.Add('       e.UPPERNOMEDITEUR,');
  Query.Script.Add('       a.UPPERTITRESERIE,');
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN SERIES s ON s.id_serie = a.id_serie');
  Query.Script.Add('                       LEFT JOIN EDITEURS e ON e.ID_EDITEUR = s.id_editeur;');

  Query.Script.Add('CREATE PROCEDURE EDITEURS_ACHATALBUMS (');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    nomediteur varchar(50),');
  Query.Script.Add('    countediteur integer,');
  Query.Script.Add('    id_editeur char(38))');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             CAST(''''-1'''' AS VARCHAR(50)),');
  Query.Script.Add('             Count(ID_ALBUM),');
  Query.Script.Add('             NULL');
  Query.Script.Add('      from vw_liste_editeurs_achatalbums');
  Query.Script.Add('      where ID_EDITEUR is null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppernomediteur, nomediteur, ID_editeur''');
  Query.Script.Add('  into :nomediteur,');
  Query.Script.Add('       :countediteur,');
  Query.Script.Add('       :ID_Editeur');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             nomediteur,');
  Query.Script.Add('             Count(ID_ALBUM),');
  Query.Script.Add('             ID_Editeur');
  Query.Script.Add('      from vw_liste_editeurs_achatalbums');
  Query.Script.Add('      where ID_EDITEUR is not null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppernomediteur, nomediteur, ID_editeur''');
  Query.Script.Add('  into :nomediteur,');
  Query.Script.Add('       :countediteur,');
  Query.Script.Add('       :ID_Editeur');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE PROCEDURE ACHATALBUMS_BY_EDITEUR (');
  Query.Script.Add('    id_editeur char(38),');
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
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
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
  Query.Script.Add('      from albums a LEFT JOIN series s on a.id_serie = s.ID_SERIE');
  Query.Script.Add('      WHERE coalesce(s.id_editeur, -1) = '''''' || :id_editeur || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
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

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.2.3.20', @MAJ1_2_3_20);

end.
