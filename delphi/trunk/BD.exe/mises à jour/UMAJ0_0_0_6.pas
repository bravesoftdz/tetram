unit UMAJ0_0_0_6;

interface

implementation

uses UIB, Updates;

procedure MAJ0_0_0_6(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 3, ''Première édition'', 1, 0);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (2, 3, ''Edition spéciale'', 2, 0);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (3, 3, ''Tirage de tête'', 3, 0);');

    Script.Add('ALTER TABLE EDITIONS ADD TYPEEDITION INTEGER;');

    Script.Add('ALTER TRIGGER LISTES_AUD0');
    Script.Add('ACTIVE AFTER UPDATE OR DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE newvalue INTEGER;');
    Script.Add('begin');
    Script.Add('  if (deleting) then newvalue = null;');
    Script.Add('                else newvalue = new.REF;');
    Script.Add('');
    Script.Add('  if (old.categorie = 1) then update editions set etat = :newvalue where etat = old.ref;');
    Script.Add('  if (old.categorie = 2) then update editions set reliure = :newvalue where reliure = old.ref;');
    Script.Add('  if (old.categorie = 3) then update editions set typeedition = :newvalue where typeedition = old.ref;');
    Script.Add('end;');

    Script.Add('update editions set typeedition = originale where originale = 1;');

    Script.Add('ALTER TABLE EDITIONS DROP originale;');

    Script.Add('CREATE VIEW VW_EMPRUNTS(');
    Script.Add('    REFEDITION,');
    Script.Add('    REFALBUM,');
    Script.Add('    TITREALBUM,');
    Script.Add('    UPPERTITREALBUM,');
    Script.Add('    REFSERIE,');
    Script.Add('    TOME,');
    Script.Add('    INTEGRALE,');
    Script.Add('    HORSSERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    REFEDITEUR,');
    Script.Add('    NOMEDITEUR,');
    Script.Add('    REFCOLLECTION,');
    Script.Add('    NOMCOLLECTION,');
    Script.Add('    PRETE,');
    Script.Add('    ANNEEEDITION,');
    Script.Add('    ISBN,');
    Script.Add('    REFEMPRUNTEUR,');
    Script.Add('    NOMEMPRUNTEUR,');
    Script.Add('    PRETEMPRUNT,');
    Script.Add('    DATEEMPRUNT)');
    Script.Add('AS');
    Script.Add('SELECT Ed.refedition,');
    Script.Add('       A.refalbum,');
    Script.Add('       A.titrealbum,');
    Script.Add('       A.uppertitrealbum,');
    Script.Add('       A.refserie,');
    Script.Add('       A.Tome,');
    Script.Add('       A.Integrale,');
    Script.Add('       A.HorsSerie,');
    Script.Add('       Se.titreserie,');
    Script.Add('       E.RefEditeur,');
    Script.Add('       E.NomEditeur,');
    Script.Add('       C.RefCollection,');
    Script.Add('       C.NomCollection,');
    Script.Add('       Ed.prete,');
    Script.Add('       Ed.AnneeEdition,');
    Script.Add('       Ed.ISBN,');
    Script.Add('       Em.RefEmprunteur,');
    Script.Add('       Em.NomEmprunteur,');
    Script.Add('       S.PretEmprunt,');
    Script.Add('       S.DateEmprunt');
    Script.Add('FROM ALBUMS A INNER JOIN EDITIONS Ed ON A.refalbum = Ed.refalbum');
    Script.Add('              INNER JOIN EDITEURS e ON e.RefEditeur = ed.RefEditeur');
    Script.Add('              LEFT JOIN COLLECTIONS C ON C.refcollection = ed.refcollection');
    Script.Add('              INNER JOIN STATUT S ON Ed.RefEdition = S.RefEdition');
    Script.Add('              INNER JOIN EMPRUNTEURS Em ON Em.RefEmprunteur = S.RefEmprunteur');
    Script.Add('              INNER JOIN SERIES Se ON A.refserie = Se.refserie;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.0.6', @MAJ0_0_0_6);

end.
