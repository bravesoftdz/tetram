unit BDTK.Updates.v0_0_3_14;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_3_14(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('DROP VIEW VW_EMPRUNTS;');

  Query.Script.Add('CREATE VIEW VW_EMPRUNTS(');
  Query.Script.Add('    REFEMPRUNT,');
  Query.Script.Add('    REFEDITION,');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    UPPERTITREALBUM,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
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
  Query.Script.Add('SELECT S.RefEmprunt,');
  Query.Script.Add('       Ed.refedition,');
  Query.Script.Add('       A.refalbum,');
  Query.Script.Add('       A.titrealbum,');
  Query.Script.Add('       A.uppertitrealbum,');
  Query.Script.Add('       A.refserie,');
  Query.Script.Add('       A.Tome,');
  Query.Script.Add('       A.Integrale,');
  Query.Script.Add('       A.TomeDebut,');
  Query.Script.Add('       A.TomeFin,');
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

RegisterFBUpdate('0.0.3.14', @MAJ0_0_3_14);

end.
