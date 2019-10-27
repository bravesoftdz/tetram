unit BDTK.Updates.v0_0_2_3;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_2_3(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('CREATE PROCEDURE PREVISIONS_SORTIES');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    TOME INTEGER,');
  Query.Script.Add('    ANNEEPARUTION INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE CURRENTREFSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE OLDREFSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
  Query.Script.Add('DECLARE VARIABLE MAXTOME INTEGER;');
  Query.Script.Add('DECLARE VARIABLE SOMMEPONDEREE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE COMPTEALBUM INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTANNEE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE MAXANNEE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE TOMEPRECEDENT INTEGER;');
  Query.Script.Add('DECLARE VARIABLE ANNEEPRECEDENTE INTEGER;');
  Query.Script.Add('begin');
  Query.Script.Add('  oldrefserie = -1;');
  Query.Script.Add('  tomeprecedent = -1;');
  Query.Script.Add('  anneeprecedente = -1;');
  Query.Script.Add('  for select TOME, ANNEEPARUTION, s.RefSerie from');
  Query.Script.Add('        albums a inner join series s on s.refserie = a.refserie');
  Query.Script.Add('        where (s.terminee is null or s.terminee <> 1)');
  Query.Script.Add('        and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null');
  Query.Script.Add('        order by s.refserie, TOME');
  Query.Script.Add('        into');
  Query.Script.Add('          :CURRENTTOME,');
  Query.Script.Add('          :CURRENTANNEE,');
  Query.Script.Add('          :CURRENTREFSERIE');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (currentrefserie <> oldrefserie) then begin');
  Query.Script.Add('');
  Query.Script.Add('      if (oldrefserie <> -1 and comptealbum > 0) then begin');
  Query.Script.Add('        select MAX(TOME) + 1, MAX(ANNEEPARUTION) from albums');
  Query.Script.Add('        where horsserie = 0 and integrale = 0 and refserie = :oldrefserie');
  Query.Script.Add('        into');
  Query.Script.Add('          :TOME,');
  Query.Script.Add('          :MAXANNEE;');
  Query.Script.Add('');
  Query.Script.Add('        select s.RefSerie, s.TitreSerie, e.RefEditeur, e.NomEditeur, c.RefCollection, c.NomCollection from');
  Query.Script.Add('          series s left join editeurs e on e.refediteur = s.refediteur');
  Query.Script.Add('                   left join collections c on c.refcollection = s.refcollection');
  Query.Script.Add('        where s.RefSerie = :oldrefserie');
  Query.Script.Add('        into');
  Query.Script.Add('          :REFSERIE,');
  Query.Script.Add('          :TITRESERIE,');
  Query.Script.Add('          :REFEDITEUR,');
  Query.Script.Add('          :NOMEDITEUR,');
  Query.Script.Add('          :REFCOLLECTION,');
  Query.Script.Add('          :NOMCOLLECTION;');
  Query.Script.Add('');
  Query.Script.Add('        ANNEEPARUTION = maxannee + ((tome - maxtome) * (sommeponderee / comptealbum));');
  Query.Script.Add('        suspend;');
  Query.Script.Add('      end');
  Query.Script.Add('');
  Query.Script.Add('      oldrefserie = currentrefserie;');
  Query.Script.Add('      sommeponderee = 0;');
  Query.Script.Add('      comptealbum = 0;');
  Query.Script.Add('      tomeprecedent = -1;');
  Query.Script.Add('      anneeprecedente = -1;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (tomeprecedent <> -1) then begin');
  Query.Script.Add('      /* non pondéré: sommeponderee = sommeponderee + ((CURRENTANNEE - ANNEEPRECEDENTE) / (CURRENTTOME - TOMEPRECEDENT)); */');
  Query.Script.Add('      sommeponderee = sommeponderee + ((CURRENTANNEE - ANNEEPRECEDENTE) / (CURRENTTOME - TOMEPRECEDENT)) * CURRENTTOME;');
  Query.Script.Add('      /* non pondéré: comptealbum = comptealbum + 1;*/');
  Query.Script.Add('      comptealbum = comptealbum + CURRENTTOME;');
  Query.Script.Add('    end');
  Query.Script.Add('    tomeprecedent = CURRENTTOME;');
  Query.Script.Add('    anneeprecedente = CURRENTANNEE;');
  Query.Script.Add('    maxtome = CURRENTTOME;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.2.3', @MAJ0_0_2_3);

end.
