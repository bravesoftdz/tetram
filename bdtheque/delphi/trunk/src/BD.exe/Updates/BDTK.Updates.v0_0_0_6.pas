unit BDTK.Updates.v0_0_0_6;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_0_6(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 3, ''Première édition'', 1, 0);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (2, 3, ''Edition spéciale'', 2, 0);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (3, 3, ''Tirage de tête'', 3, 0);');

  Query.Script.Add('ALTER TABLE EDITIONS ADD TYPEEDITION INTEGER;');

  Query.Script.Add('ALTER TRIGGER LISTES_AUD0');
  Query.Script.Add('ACTIVE AFTER UPDATE OR DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE newvalue INTEGER;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (deleting) then newvalue = null;');
  Query.Script.Add('                else newvalue = new.REF;');
  Query.Script.Add('');
  Query.Script.Add('  if (old.categorie = 1) then update editions set etat = :newvalue where etat = old.ref;');
  Query.Script.Add('  if (old.categorie = 2) then update editions set reliure = :newvalue where reliure = old.ref;');
  Query.Script.Add('  if (old.categorie = 3) then update editions set typeedition = :newvalue where typeedition = old.ref;');
  Query.Script.Add('end;');

  Query.Script.Add('update editions set typeedition = originale where originale = 1;');

  Query.Script.Add('ALTER TABLE EDITIONS DROP originale;');

  Query.Script.Add('CREATE VIEW VW_EMPRUNTS(');
  Query.Script.Add('    REFEDITION,');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    UPPERTITREALBUM,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    TITRESERIE,');
  Query.Script.Add('    REFEDITEUR,');
  Query.Script.Add('    NOMEDITEUR,');
  Query.Script.Add('    REFCOLLECTION,');
  Query.Script.Add('    NOMCOLLECTION,');
  Query.Script.Add('    PRETE,');
  Query.Script.Add('    ANNEEEDITION,');
  Query.Script.Add('    ISBN,');
  Query.Script.Add('    REFEMPRUNTEUR,');
  Query.Script.Add('    NOMEMPRUNTEUR,');
  Query.Script.Add('    PRETEMPRUNT,');
  Query.Script.Add('    DATEEMPRUNT)');
  Query.Script.Add('AS');
  Query.Script.Add('SELECT Ed.refedition,');
  Query.Script.Add('       A.refalbum,');
  Query.Script.Add('       A.titrealbum,');
  Query.Script.Add('       A.uppertitrealbum,');
  Query.Script.Add('       A.refserie,');
  Query.Script.Add('       A.Tome,');
  Query.Script.Add('       A.Integrale,');
  Query.Script.Add('       A.HorsSerie,');
  Query.Script.Add('       Se.titreserie,');
  Query.Script.Add('       E.RefEditeur,');
  Query.Script.Add('       E.NomEditeur,');
  Query.Script.Add('       C.RefCollection,');
  Query.Script.Add('       C.NomCollection,');
  Query.Script.Add('       Ed.prete,');
  Query.Script.Add('       Ed.AnneeEdition,');
  Query.Script.Add('       Ed.ISBN,');
  Query.Script.Add('       Em.RefEmprunteur,');
  Query.Script.Add('       Em.NomEmprunteur,');
  Query.Script.Add('       S.PretEmprunt,');
  Query.Script.Add('       S.DateEmprunt');
  Query.Script.Add('FROM ALBUMS A INNER JOIN EDITIONS Ed ON A.refalbum = Ed.refalbum');
  Query.Script.Add('              INNER JOIN EDITEURS e ON e.RefEditeur = ed.RefEditeur');
  Query.Script.Add('              LEFT JOIN COLLECTIONS C ON C.refcollection = ed.refcollection');
  Query.Script.Add('              INNER JOIN STATUT S ON Ed.RefEdition = S.RefEdition');
  Query.Script.Add('              INNER JOIN EMPRUNTEURS Em ON Em.RefEmprunteur = S.RefEmprunteur');
  Query.Script.Add('              INNER JOIN SERIES Se ON A.refserie = Se.refserie;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.0.6', @MAJ0_0_0_6);

end.
