unit UMAJ1_0_0_0;

interface

implementation

uses JvUIB, Updates;

procedure MAJ1_0_0_0(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('alter table options alter valeur type varchar(255);');

    Script.Add('ALTER PROCEDURE PREVISIONS_SORTIES (');
    Script.Add('    WITHACHAT SMALLINT,');
    Script.Add('    IN_REFSERIE INTEGER)');
    Script.Add('RETURNS (');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    UPPERTITRESERIE VARCHAR(150),');
    Script.Add('    TOME INTEGER,');
    Script.Add('    ANNEEPARUTION INTEGER,');
    Script.Add('    MOISPARUTION INTEGER,');
    Script.Add('    REFEDITEUR INTEGER,');
    Script.Add('    NOMEDITEUR VARCHAR(50),');
    Script.Add('    REFCOLLECTION INTEGER,');
    Script.Add('    NOMCOLLECTION VARCHAR(50))');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE CURRENTREFSERIE INTEGER;');
    Script.Add('DECLARE VARIABLE OLDREFSERIE INTEGER;');
    Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
    Script.Add('DECLARE VARIABLE SOMMEPONDEREE INTEGER;');
    Script.Add('DECLARE VARIABLE COMPTEALBUM INTEGER;');
    Script.Add('DECLARE VARIABLE CURRENTANNEE INTEGER;');
    Script.Add('DECLARE VARIABLE CURRENTMOIS INTEGER;');
    Script.Add('DECLARE VARIABLE TOMEPRECEDENT INTEGER;');
    Script.Add('DECLARE VARIABLE ANNEEPRECEDENTE INTEGER;');
    Script.Add('DECLARE VARIABLE MOISPRECEDENT INTEGER;');
    Script.Add('DECLARE VARIABLE DIFFMOIS INTEGER;');
    Script.Add('begin');
    Script.Add('  if (withachat is Null) then withachat = 1;');
    Script.Add('  oldrefserie = -1;');
    Script.Add('  tomeprecedent = -1;');
    Script.Add('  anneeprecedente = -1;');
    Script.Add('  moisprecedent = null;');
    Script.Add('  for select TOME, ANNEEPARUTION, MOISPARUTION, s.RefSerie');
    Script.Add('      from albums a inner join series s on s.refserie = a.refserie');
    Script.Add('      where (s.terminee is null or s.terminee <> 1)');
    Script.Add('            and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null');
    Script.Add('            and (:in_refserie is null or s.refserie = :in_refserie)');
    Script.Add('            and (:withachat = 1 or achat = 0)');
    Script.Add('      order by s.refserie, TOME');
    Script.Add('      into :CURRENTTOME, :CURRENTANNEE, :CURRENTMOIS, :CURRENTREFSERIE');
    Script.Add('  do begin');
    Script.Add('    if (currentrefserie <> oldrefserie) then begin');
    Script.Add('');
    Script.Add('      if (oldrefserie <> -1 and comptealbum > 0) then begin');
    Script.Add('        select REFSERIE, TITRESERIE, UPPERTITRESERIE,');
    Script.Add('               TOME, ANNEEPARUTION, MOISPARUTION,');
    Script.Add('               REFEDITEUR, NOMEDITEUR,');
    Script.Add('               REFCOLLECTION, NOMCOLLECTION');
    Script.Add('        from CALCUL_ANNEE_SORTIE(:withachat, :oldrefserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
    Script.Add('        into :REFSERIE, :TITRESERIE, :UPPERTITRESERIE,');
    Script.Add('             :TOME, :ANNEEPARUTION, :MOISPARUTION,');
    Script.Add('             :REFEDITEUR, :NOMEDITEUR,');
    Script.Add('             :REFCOLLECTION, :NOMCOLLECTION;');
    Script.Add('        suspend;');
    Script.Add('      end');
    Script.Add('');
    Script.Add('      oldrefserie = currentrefserie;');
    Script.Add('      sommeponderee = 0;');
    Script.Add('      comptealbum = 0;');
    Script.Add('      tomeprecedent = -1;');
    Script.Add('      anneeprecedente = -1;');
    Script.Add('      moisprecedent = -1;');
    Script.Add('    end');
    Script.Add('    if (tomeprecedent <> -1) then begin');
    Script.Add('      if (CURRENTMOIS is null or MOISPRECEDENT is null) then');
    Script.Add('        diffmois = 0;');
    Script.Add('      else');
    Script.Add('        diffmois = CURRENTMOIS - MOISPRECEDENT;');
    Script.Add('      /* non pondéré: sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)); */');
    Script.Add('      sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + diffmois) / (CURRENTTOME - TOMEPRECEDENT)) * CURRENTTOME;');
    Script.Add('      /* non pondéré: comptealbum = comptealbum + 1;*/');
    Script.Add('      comptealbum = comptealbum + CURRENTTOME;');
    Script.Add('    end');
    Script.Add('    tomeprecedent = CURRENTTOME;');
    Script.Add('    anneeprecedente = CURRENTANNEE;');
    Script.Add('    moisprecedent = CURRENTMOIS;');
    Script.Add('  end');
    Script.Add('');
    Script.Add('  if (oldrefserie <> -1 and comptealbum > 0) then begin');
    Script.Add('    select REFSERIE, TITRESERIE, UPPERTITRESERIE,');
    Script.Add('           TOME, ANNEEPARUTION, MOISPARUTION,');
    Script.Add('           REFEDITEUR, NOMEDITEUR,');
    Script.Add('           REFCOLLECTION, NOMCOLLECTION');
    Script.Add('    from CALCUL_ANNEE_SORTIE(:withachat, :oldrefserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
    Script.Add('    into :REFSERIE, :TITRESERIE, :UPPERTITRESERIE,');
    Script.Add('         :TOME, :ANNEEPARUTION, :MOISPARUTION,');
    Script.Add('         :REFEDITEUR, :NOMEDITEUR,');
    Script.Add('         :REFCOLLECTION, :NOMCOLLECTION;');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('1.0.0.0', @MAJ1_0_0_0);

end.

