unit UMAJ0_0_2_3;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_2_3(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('CREATE PROCEDURE PREVISIONS_SORTIES');
    Script.Add('RETURNS (');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    TOME INTEGER,');
    Script.Add('    ANNEEPARUTION INTEGER,');
    Script.Add('    REFEDITEUR INTEGER,');
    Script.Add('    NOMEDITEUR VARCHAR(50),');
    Script.Add('    REFCOLLECTION INTEGER,');
    Script.Add('    NOMCOLLECTION VARCHAR(50))');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE CURRENTREFSERIE INTEGER;');
    Script.Add('DECLARE VARIABLE OLDREFSERIE INTEGER;');
    Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
    Script.Add('DECLARE VARIABLE MAXTOME INTEGER;');
    Script.Add('DECLARE VARIABLE SOMMEPONDEREE INTEGER;');
    Script.Add('DECLARE VARIABLE COMPTEALBUM INTEGER;');
    Script.Add('DECLARE VARIABLE CURRENTANNEE INTEGER;');
    Script.Add('DECLARE VARIABLE MAXANNEE INTEGER;');
    Script.Add('DECLARE VARIABLE TOMEPRECEDENT INTEGER;');
    Script.Add('DECLARE VARIABLE ANNEEPRECEDENTE INTEGER;');
    Script.Add('begin');
    Script.Add('  oldrefserie = -1;');
    Script.Add('  tomeprecedent = -1;');
    Script.Add('  anneeprecedente = -1;');
    Script.Add('  for select TOME, ANNEEPARUTION, s.RefSerie from');
    Script.Add('        albums a inner join series s on s.refserie = a.refserie');
    Script.Add('        where (s.terminee is null or s.terminee <> 1)');
    Script.Add('        and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null');
    Script.Add('        order by s.refserie, TOME');
    Script.Add('        into');
    Script.Add('          :CURRENTTOME,');
    Script.Add('          :CURRENTANNEE,');
    Script.Add('          :CURRENTREFSERIE');
    Script.Add('  do begin');
    Script.Add('    if (currentrefserie <> oldrefserie) then begin');
    Script.Add('');
    Script.Add('      if (oldrefserie <> -1 and comptealbum > 0) then begin');
    Script.Add('        select MAX(TOME) + 1, MAX(ANNEEPARUTION) from albums');
    Script.Add('        where horsserie = 0 and integrale = 0 and refserie = :oldrefserie');
    Script.Add('        into');
    Script.Add('          :TOME,');
    Script.Add('          :MAXANNEE;');
    Script.Add('');
    Script.Add('        select s.RefSerie, s.TitreSerie, e.RefEditeur, e.NomEditeur, c.RefCollection, c.NomCollection from');
    Script.Add('          series s left join editeurs e on e.refediteur = s.refediteur');
    Script.Add('                   left join collections c on c.refcollection = s.refcollection');
    Script.Add('        where s.RefSerie = :oldrefserie');
    Script.Add('        into');
    Script.Add('          :REFSERIE,');
    Script.Add('          :TITRESERIE,');
    Script.Add('          :REFEDITEUR,');
    Script.Add('          :NOMEDITEUR,');
    Script.Add('          :REFCOLLECTION,');
    Script.Add('          :NOMCOLLECTION;');
    Script.Add('');
    Script.Add('        ANNEEPARUTION = maxannee + ((tome - maxtome) * (sommeponderee / comptealbum));');
    Script.Add('        suspend;');
    Script.Add('      end');
    Script.Add('');
    Script.Add('      oldrefserie = currentrefserie;');
    Script.Add('      sommeponderee = 0;');
    Script.Add('      comptealbum = 0;');
    Script.Add('      tomeprecedent = -1;');
    Script.Add('      anneeprecedente = -1;');
    Script.Add('    end');
    Script.Add('    if (tomeprecedent <> -1) then begin');
    Script.Add('      /* non pondéré: sommeponderee = sommeponderee + ((CURRENTANNEE - ANNEEPRECEDENTE) / (CURRENTTOME - TOMEPRECEDENT)); */');
    Script.Add('      sommeponderee = sommeponderee + ((CURRENTANNEE - ANNEEPRECEDENTE) / (CURRENTTOME - TOMEPRECEDENT)) * CURRENTTOME;');
    Script.Add('      /* non pondéré: comptealbum = comptealbum + 1;*/');
    Script.Add('      comptealbum = comptealbum + CURRENTTOME;');
    Script.Add('    end');
    Script.Add('    tomeprecedent = CURRENTTOME;');
    Script.Add('    anneeprecedente = CURRENTANNEE;');
    Script.Add('    maxtome = CURRENTTOME;');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.2.3', @MAJ0_0_2_3);

end.
