unit UMAJ0_0_0_9;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_0_9(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('ALTER TABLE SERIES ADD COMPLETE T_YESNO_BASENO;');

    Script.Add('UPDATE SERIES SET COMPLETE = 0;');

    Script.Add('CREATE PROCEDURE ALBUMS_MANQUANTS');
    Script.Add('RETURNS (');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    COUNTSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    TOME INTEGER,');
    Script.Add('    REFEDITEUR INTEGER,');
    Script.Add('    NOMEDITEUR VARCHAR(50),');
    Script.Add('    REFCOLLECTION INTEGER,');
    Script.Add('    NOMCOLLECTION VARCHAR(50))');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE MAXSERIE INTEGER;');
    Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
    Script.Add('DECLARE VARIABLE OWNEDTOME INTEGER;');
    Script.Add('begin');
    Script.Add('  for select');
    Script.Add('        A.REFSERIE,');
    Script.Add('        max(TOME),');
    Script.Add('        count(distinct TOME),');
    Script.Add('        S.REFEDITEUR,');
    Script.Add('        NOMEDITEUR,');
    Script.Add('        S.REFCOLLECTION,');
    Script.Add('        NOMCOLLECTION');
    Script.Add('      from ALBUMS A inner join SERIES S on A.REFSERIE = S.REFSERIE');
    Script.Add('                    left join EDITEURS E on S.REFEDITEUR = E.REFEDITEUR');
    Script.Add('                    left join COLLECTIONS C on S.REFCOLLECTION = C.REFCOLLECTION');
    Script.Add('      where INTEGRALE = 0 and HORSSERIE = 0 and TOME is not null and S.COMPLETE = 0');
    Script.Add('      group by A.REFSERIE, UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION,');
    Script.Add('               S.REFEDITEUR, NOMEDITEUR, S.REFCOLLECTION, NOMCOLLECTION');
    Script.Add('      order by UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION');
    Script.Add('      into');
    Script.Add('        :REFSERIE,');
    Script.Add('        :MAXSERIE,');
    Script.Add('        :COUNTSERIE,');
    Script.Add('        :REFEDITEUR,');
    Script.Add('        :NOMEDITEUR,');
    Script.Add('        :REFCOLLECTION,');
    Script.Add('        :NOMCOLLECTION');
    Script.Add('  do begin');
    Script.Add('    if (COUNTSERIE <> MAXSERIE) then begin');
    Script.Add('      CURRENTTOME = 0;');
    Script.Add('      for select distinct');
    Script.Add('            TITRESERIE,');
    Script.Add('            TOME');
    Script.Add('          from ALBUMS A inner join SERIES S on A.REFSERIE = S.REFSERIE and S.REFSERIE = :REFSERIE');
    Script.Add('          where INTEGRALE = 0 and HORSSERIE = 0 and TOME is not null');
    Script.Add('          order by TOME');
    Script.Add('          into');
    Script.Add('            :TITRESERIE,');
    Script.Add('            :OWNEDTOME');
    Script.Add('      do begin');
    Script.Add('        CURRENTTOME = CURRENTTOME + 1;');
    Script.Add('        while ((CURRENTTOME <> OWNEDTOME) and (CURRENTTOME < MAXSERIE)) do begin');
    Script.Add('          TOME = CURRENTTOME;');
    Script.Add('          suspend;');
    Script.Add('          CURRENTTOME = CURRENTTOME + 1;');
    Script.Add('        end');
    Script.Add('      end');
    Script.Add('    end');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.0.9', @MAJ0_0_0_9);

end.
