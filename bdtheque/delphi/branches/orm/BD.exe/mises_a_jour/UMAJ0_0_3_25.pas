unit UMAJ0_0_3_25;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_3_25(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER TABLE EDITIONS ALTER ACHAT TO DATEACHAT;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_EDITEUR (');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('     ''SELECT a.REFALBUM,');
  Query.Script.Add('             a.TITREALBUM,');
  Query.Script.Add('             a.TOME,');
  Query.Script.Add('             a.TOMEDEBUT,');
  Query.Script.Add('             a.TOMEFIN,');
  Query.Script.Add('             a.HORSSERIE,');
  Query.Script.Add('             a.INTEGRALE,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      from albums a LEFT join editions e on a.refalbum = e.refalbum');
  Query.Script.Add('                    LEFT join series s on a.refserie = s.refserie');
  Query.Script.Add('      WHERE coalesce(e.refediteur, -1) = '''''' || :refediteur || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
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

RegisterFBUpdate('0.0.3.25', @MAJ0_0_3_25);

end.
