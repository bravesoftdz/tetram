unit UMAJ0_0_3_14;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_3_14(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('DROP VIEW VW_EMPRUNTS;');

    Script.Add('CREATE VIEW VW_EMPRUNTS(');
    Script.Add('    REFEMPRUNT,');
    Script.Add('    REFEDITION,');
    Script.Add('    REFALBUM,');
    Script.Add('    TITREALBUM,');
    Script.Add('    UPPERTITREALBUM,');
    Script.Add('    REFSERIE,');
    Script.Add('    TOME,');
    Script.Add('    INTEGRALE,');
    Script.Add('    TOMEDEBUT,');
    Script.Add('    TOMEFIN,');
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
    Script.Add('SELECT S.RefEmprunt,');
    Script.Add('       Ed.refedition,');
    Script.Add('       A.refalbum,');
    Script.Add('       A.titrealbum,');
    Script.Add('       A.uppertitrealbum,');
    Script.Add('       A.refserie,');
    Script.Add('       A.Tome,');
    Script.Add('       A.Integrale,');
    Script.Add('       A.TomeDebut,');
    Script.Add('       A.TomeFin,');
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
  RegisterFBUpdate('0.0.3.14', @MAJ0_0_3_14);

end.
