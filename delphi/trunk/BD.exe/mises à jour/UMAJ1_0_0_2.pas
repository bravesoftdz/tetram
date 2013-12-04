unit UMAJ1_0_0_2;

interface

implementation

uses UIB, Updates;

procedure MAJ1_0_0_2(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER PROCEDURE PREVISIONS_SORTIES (');
  Query.Script.Add('    WITHACHAT SMALLINT,');
  Query.Script.Add('    IN_REFSERIE INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    UPPERTITRESERIE VARCHAR(150),');
  Query.Script.Add('    TOME INTEGER,');
  Query.Script.Add('    ANNEEPARUTION INTEGER,');
  Query.Script.Add('    MOISPARUTION INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE CURRENTREFSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE OLDREFSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
  Query.Script.Add('DECLARE VARIABLE SOMMEPONDEREE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE COMPTEALBUM INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTANNEE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTMOIS INTEGER;');
  Query.Script.Add('DECLARE VARIABLE TOMEPRECEDENT INTEGER;');
  Query.Script.Add('DECLARE VARIABLE ANNEEPRECEDENTE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE MOISPRECEDENT INTEGER;');
  Query.Script.Add('DECLARE VARIABLE DIFFMOIS INTEGER;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (withachat is Null) then withachat = 1;');
  Query.Script.Add('  oldrefserie = -1;');
  Query.Script.Add('  tomeprecedent = -1;');
  Query.Script.Add('  anneeprecedente = -1;');
  Query.Script.Add('  moisprecedent = null;');
  Query.Script.Add('  for select TOME, ANNEEPARUTION, MOISPARUTION, s.RefSerie');
  Query.Script.Add('      from albums a inner join series s on s.refserie = a.refserie');
  Query.Script.Add('      where (s.terminee is null or s.terminee <> 1)');
  Query.Script.Add('            and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null');
  Query.Script.Add('            and (:in_refserie is null or s.refserie = :in_refserie)');
  Query.Script.Add('            and (:withachat = 1 or achat = 0)');
  Query.Script.Add('      order by s.refserie, TOME');
  Query.Script.Add('      into :CURRENTTOME, :CURRENTANNEE, :CURRENTMOIS, :CURRENTREFSERIE');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (currentrefserie <> oldrefserie) then begin');
  Query.Script.Add('');
  Query.Script.Add('      if (oldrefserie <> -1 and comptealbum > 0) then begin');
  Query.Script.Add('        select REFSERIE, TITRESERIE, UPPERTITRESERIE,');
  Query.Script.Add('               TOME, ANNEEPARUTION, MOISPARUTION,');
  Query.Script.Add('               REFEDITEUR, NOMEDITEUR,');
  Query.Script.Add('               REFCOLLECTION, NOMCOLLECTION');
  Query.Script.Add
    ('        from CALCUL_ANNEE_SORTIE(:withachat, :oldrefserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
  Query.Script.Add('        into :REFSERIE, :TITRESERIE, :UPPERTITRESERIE,');
  Query.Script.Add('             :TOME, :ANNEEPARUTION, :MOISPARUTION,');
  Query.Script.Add('             :REFEDITEUR, :NOMEDITEUR,');
  Query.Script.Add('             :REFCOLLECTION, :NOMCOLLECTION;');
  Query.Script.Add('        suspend;');
  Query.Script.Add('      end');
  Query.Script.Add('');
  Query.Script.Add('      oldrefserie = currentrefserie;');
  Query.Script.Add('      sommeponderee = 0;');
  Query.Script.Add('      comptealbum = 0;');
  Query.Script.Add('      tomeprecedent = -1;');
  Query.Script.Add('      anneeprecedente = -1;');
  Query.Script.Add('      moisprecedent = -1;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (tomeprecedent <> -1 and CURRENTTOME - TOMEPRECEDENT <> 0) then begin');
  Query.Script.Add('      if (CURRENTMOIS is null or MOISPRECEDENT is null) then');
  Query.Script.Add('        diffmois = 0;');
  Query.Script.Add('      else');
  Query.Script.Add('        diffmois = CURRENTMOIS - MOISPRECEDENT;');
  Query.Script.Add
    ('      /* non pondéré: sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)); */');
  Query.Script.Add('      sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + diffmois) / (CURRENTTOME - TOMEPRECEDENT)) * CURRENTTOME;');
  Query.Script.Add('      /* non pondéré: comptealbum = comptealbum + 1;*/');
  Query.Script.Add('      comptealbum = comptealbum + CURRENTTOME;');
  Query.Script.Add('    end');
  Query.Script.Add('    tomeprecedent = CURRENTTOME;');
  Query.Script.Add('    anneeprecedente = CURRENTANNEE;');
  Query.Script.Add('    moisprecedent = CURRENTMOIS;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  if (oldrefserie <> -1 and comptealbum > 0) then begin');
  Query.Script.Add('    select REFSERIE, TITRESERIE, UPPERTITRESERIE,');
  Query.Script.Add('           TOME, ANNEEPARUTION, MOISPARUTION,');
  Query.Script.Add('           REFEDITEUR, NOMEDITEUR,');
  Query.Script.Add('           REFCOLLECTION, NOMCOLLECTION');
  Query.Script.Add('    from CALCUL_ANNEE_SORTIE(:withachat, :oldrefserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
  Query.Script.Add('    into :REFSERIE, :TITRESERIE, :UPPERTITRESERIE,');
  Query.Script.Add('         :TOME, :ANNEEPARUTION, :MOISPARUTION,');
  Query.Script.Add('         :REFEDITEUR, :NOMEDITEUR,');
  Query.Script.Add('         :REFCOLLECTION, :NOMCOLLECTION;');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.0.0.2', @MAJ1_0_0_2);

end.
