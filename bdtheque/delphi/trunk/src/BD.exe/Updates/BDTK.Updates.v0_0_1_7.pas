unit BDTK.Updates.v0_0_1_7;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_1_7(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_AUTEUR (');
  Query.Script.Add('    REFAUTEUR INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    METIER SMALLINT)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  for SELECT A.REFALBUM,');
  Query.Script.Add('             A.TITREALBUM,');
  Query.Script.Add('             A.TOME,');
  Query.Script.Add('             A.HORSSERIE,');
  Query.Script.Add('             A.INTEGRALE,');
  Query.Script.Add('             A.ANNEEPARUTION,');
  Query.Script.Add('             A.REFSERIE,');
  Query.Script.Add('             A.TITRESERIE,');
  Query.Script.Add('             AU.metier');
  Query.Script.Add('        FROM vw_liste_albums A INNER JOIN auteurs au on a.refalbum = au.refalbum');
  Query.Script.Add('        WHERE au.refpersonne = :RefAuteur');
  Query.Script.Add
    ('        ORDER BY UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, UPPERTITREALBUM, METIER');
  Query.Script.Add('        INTO :REFALBUM,');
  Query.Script.Add('             :TITREALBUM,');
  Query.Script.Add('             :TOME,');
  Query.Script.Add('             :HORSSERIE,');
  Query.Script.Add('             :INTEGRALE,');
  Query.Script.Add('             :ANNEEPARUTION,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :TITRESERIE,');
  Query.Script.Add('             :METIER');
  Query.Script.Add('      DO');
  Query.Script.Add('      BEGIN');
  Query.Script.Add('        SUSPEND;');
  Query.Script.Add('      END');
  Query.Script.Add('END;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.1.7', @MAJ0_0_1_7);

end.
