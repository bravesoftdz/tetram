unit UMAJ0_0_3_25;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_3_25(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('ALTER TABLE EDITIONS ALTER ACHAT TO DATEACHAT;');

    Script.Add('ALTER PROCEDURE ALBUMS_BY_EDITEUR (');
    Script.Add('    REFEDITEUR INTEGER,');
    Script.Add('    FILTRE VARCHAR(125))');
    Script.Add('RETURNS (');
    Script.Add('    REFALBUM INTEGER,');
    Script.Add('    TITREALBUM VARCHAR(150),');
    Script.Add('    TOME SMALLINT,');
    Script.Add('    TOMEDEBUT SMALLINT,');
    Script.Add('    TOMEFIN SMALLINT,');
    Script.Add('    HORSSERIE SMALLINT,');
    Script.Add('    INTEGRALE SMALLINT,');
    Script.Add('    ANNEEPARUTION SMALLINT,');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    ACHAT SMALLINT,');
    Script.Add('    COMPLET INTEGER)');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
    Script.Add('BEGIN');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
    Script.Add('  FOR execute statement');
    Script.Add('     ''SELECT a.REFALBUM,');
    Script.Add('             a.TITREALBUM,');
    Script.Add('             a.TOME,');
    Script.Add('             a.TOMEDEBUT,');
    Script.Add('             a.TOMEFIN,');
    Script.Add('             a.HORSSERIE,');
    Script.Add('             a.INTEGRALE,');
    Script.Add('             a.ANNEEPARUTION,');
    Script.Add('             a.REFSERIE,');
    Script.Add('             s.TITRESERIE,');
    Script.Add('             a.ACHAT,');
    Script.Add('             a.COMPLET');
    Script.Add('      from albums a LEFT join editions e on a.refalbum = e.refalbum');
    Script.Add('                    LEFT join series s on a.refserie = s.refserie');
    Script.Add('      WHERE coalesce(e.refediteur, -1) = '''''' || :refediteur || '''''' '' || swhere ||');
    Script.Add('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
    Script.Add('      INTO :REFALBUM,');
    Script.Add('           :TITREALBUM,');
    Script.Add('           :TOME,');
    Script.Add('           :TOMEDEBUT,');
    Script.Add('           :TOMEFIN,');
    Script.Add('           :HORSSERIE,');
    Script.Add('           :INTEGRALE,');
    Script.Add('           :ANNEEPARUTION,');
    Script.Add('           :REFSERIE,');
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
  RegisterUpdate('0.0.3.25', @MAJ0_0_3_25);

end.

