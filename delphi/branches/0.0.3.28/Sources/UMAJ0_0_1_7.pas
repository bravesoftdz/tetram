unit UMAJ0_0_1_7;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_1_7(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('ALTER PROCEDURE ALBUMS_BY_AUTEUR (');
    Script.Add('    REFAUTEUR INTEGER)');
    Script.Add('RETURNS (');
    Script.Add('    REFALBUM INTEGER,');
    Script.Add('    TITREALBUM VARCHAR(150),');
    Script.Add('    TOME SMALLINT,');
    Script.Add('    HORSSERIE SMALLINT,');
    Script.Add('    INTEGRALE SMALLINT,');
    Script.Add('    ANNEEPARUTION SMALLINT,');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    METIER SMALLINT)');
    Script.Add('AS');
    Script.Add('BEGIN');
    Script.Add('  for SELECT A.REFALBUM,');
    Script.Add('             A.TITREALBUM,');
    Script.Add('             A.TOME,');
    Script.Add('             A.HORSSERIE,');
    Script.Add('             A.INTEGRALE,');
    Script.Add('             A.ANNEEPARUTION,');
    Script.Add('             A.REFSERIE,');
    Script.Add('             A.TITRESERIE,');
    Script.Add('             AU.metier');
    Script.Add('        FROM vw_liste_albums A INNER JOIN auteurs au on a.refalbum = au.refalbum');
    Script.Add('        WHERE au.refpersonne = :RefAuteur');
    Script.Add('        ORDER BY UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, UPPERTITREALBUM, METIER');
    Script.Add('        INTO :REFALBUM,');
    Script.Add('             :TITREALBUM,');
    Script.Add('             :TOME,');
    Script.Add('             :HORSSERIE,');
    Script.Add('             :INTEGRALE,');
    Script.Add('             :ANNEEPARUTION,');
    Script.Add('             :REFSERIE,');
    Script.Add('             :TITRESERIE,');
    Script.Add('             :METIER');
    Script.Add('      DO');
    Script.Add('      BEGIN');
    Script.Add('        SUSPEND;');
    Script.Add('      END');
    Script.Add('END;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('0.0.1.7', @MAJ0_0_1_7);

end.
