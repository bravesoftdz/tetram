unit BDTK.Updates.v0_0_0_9;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_0_9(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('ALTER TABLE SERIES ADD COMPLETE T_YESNO_BASENO;');

  Query.Script.Add('UPDATE SERIES SET COMPLETE = 0;');

  Query.Script.Add('CREATE PROCEDURE ALBUMS_MANQUANTS');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    COUNTSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    TOME INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE MAXSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
  Query.Script.Add('DECLARE VARIABLE OWNEDTOME INTEGER;');
  Query.Script.Add('begin');
  Query.Script.Add('  for select');
  Query.Script.Add('        A.REFSERIE,');
  Query.Script.Add('        max(TOME),');
  Query.Script.Add('        count(distinct TOME),');
  Query.Script.Add('        S.REFEDITEUR,');
  Query.Script.Add('        NOMEDITEUR,');
  Query.Script.Add('        S.REFCOLLECTION,');
  Query.Script.Add('        NOMCOLLECTION');
  Query.Script.Add('      from ALBUMS A inner join SERIES S on A.REFSERIE = S.REFSERIE');
  Query.Script.Add('                    left join EDITEURS E on S.REFEDITEUR = E.REFEDITEUR');
  Query.Script.Add('                    left join COLLECTIONS C on S.REFCOLLECTION = C.REFCOLLECTION');
  Query.Script.Add('      where INTEGRALE = 0 and HORSSERIE = 0 and TOME is not null and S.COMPLETE = 0');
  Query.Script.Add('      group by A.REFSERIE, UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION,');
  Query.Script.Add('               S.REFEDITEUR, NOMEDITEUR, S.REFCOLLECTION, NOMCOLLECTION');
  Query.Script.Add('      order by UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION');
  Query.Script.Add('      into');
  Query.Script.Add('        :REFSERIE,');
  Query.Script.Add('        :MAXSERIE,');
  Query.Script.Add('        :COUNTSERIE,');
  Query.Script.Add('        :REFEDITEUR,');
  Query.Script.Add('        :NOMEDITEUR,');
  Query.Script.Add('        :REFCOLLECTION,');
  Query.Script.Add('        :NOMCOLLECTION');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (COUNTSERIE <> MAXSERIE) then begin');
  Query.Script.Add('      CURRENTTOME = 0;');
  Query.Script.Add('      for select distinct');
  Query.Script.Add('            TITRESERIE,');
  Query.Script.Add('            TOME');
  Query.Script.Add('          from ALBUMS A inner join SERIES S on A.REFSERIE = S.REFSERIE and S.REFSERIE = :REFSERIE');
  Query.Script.Add('          where INTEGRALE = 0 and HORSSERIE = 0 and TOME is not null');
  Query.Script.Add('          order by TOME');
  Query.Script.Add('          into');
  Query.Script.Add('            :TITRESERIE,');
  Query.Script.Add('            :OWNEDTOME');
  Query.Script.Add('      do begin');
  Query.Script.Add('        CURRENTTOME = CURRENTTOME + 1;');
  Query.Script.Add('        while ((CURRENTTOME <> OWNEDTOME) and (CURRENTTOME < MAXSERIE)) do begin');
  Query.Script.Add('          TOME = CURRENTTOME;');
  Query.Script.Add('          suspend;');
  Query.Script.Add('          CURRENTTOME = CURRENTTOME + 1;');
  Query.Script.Add('        end');
  Query.Script.Add('      end');
  Query.Script.Add('    end');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.0.9', @MAJ0_0_0_9);

end.
