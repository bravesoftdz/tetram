unit UMAJ1_2_0_0;

interface

implementation

uses UIB, Updates;

procedure MAJ1_2_0_0(Query: TUIBScript);
begin
  Query.Script.Clear;

  // InitialiseTables
  LoadScript('MAJ1_2_0_0part1', Query.Script);
  Query.ExecuteScript;

  // RecreerVuesProcTrigger
  LoadScript('MAJ1_2_0_0part2', Query.Script);
  Query.ExecuteScript;

  Query.Script.Clear;

  Query.Script.Add('DROP GENERATOR AI_REFALBUM;');
  Query.Script.Add('DROP GENERATOR AI_REFCOLLECTION;');
  Query.Script.Add('DROP GENERATOR AI_REFCOUVERTURE;');
  Query.Script.Add('DROP GENERATOR AI_REFEDITEUR;');
  Query.Script.Add('DROP GENERATOR AI_REFEDITION;');
  Query.Script.Add('DROP GENERATOR AI_REFEMPRUNT;');
  Query.Script.Add('DROP GENERATOR AI_REFEMPRUNTEUR;');
  Query.Script.Add('DROP GENERATOR AI_REFGENRE;');
  Query.Script.Add('DROP GENERATOR AI_REFPARABD;');
  Query.Script.Add('DROP GENERATOR AI_REFPERSONNE;');
  Query.Script.Add('DROP GENERATOR AI_REFSERIE;');
  Query.Script.Add('ALTER TABLE ALBUMS DROP REFALBUM, DROP REFSERIE;');
  Query.Script.Add('ALTER TABLE AUTEURS DROP REFALBUM, DROP REFPERSONNE;');
  Query.Script.Add('ALTER TABLE AUTEURS_PARABD DROP REFPARABD, DROP REFPERSONNE;');
  Query.Script.Add('ALTER TABLE AUTEURS_SERIES DROP REFSERIE, DROP REFPERSONNE;');
  Query.Script.Add('ALTER TABLE COLLECTIONS DROP REFCOLLECTION, DROP REFEDITEUR;');
  Query.Script.Add('ALTER TABLE COTES DROP REFEDITION;');
  Query.Script.Add('ALTER TABLE COTES_PARABD DROP REFPARABD;');
  Query.Script.Add('ALTER TABLE COUVERTURES DROP REFCOUVERTURE, DROP REFALBUM, DROP REFEDITION;');
  Query.Script.Add('ALTER TABLE EDITEURS DROP REFEDITEUR;');
  Query.Script.Add('ALTER TABLE EDITIONS DROP REFEDITION, DROP REFALBUM, DROP REFEDITEUR, DROP REFCOLLECTION;');
  Query.Script.Add('ALTER TABLE EMPRUNTEURS DROP REFEMPRUNTEUR;');
  Query.Script.Add('ALTER TABLE GENRES DROP REFGENRE;');
  Query.Script.Add('ALTER TABLE GENRESERIES DROP REFSERIE, DROP REFGENRE;');
  Query.Script.Add('ALTER TABLE PARABD DROP REFPARABD, DROP REFSERIE;');
  Query.Script.Add('ALTER TABLE PERSONNES DROP REFPERSONNE;');
  Query.Script.Add('ALTER TABLE SERIES DROP REFSERIE, DROP REFEDITEUR, DROP REFCOLLECTION;');
  Query.Script.Add('ALTER TABLE STATUT DROP REFEMPRUNT, DROP REFEDITION, DROP REFEMPRUNTEUR;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.2.0.0', @MAJ1_2_0_0);

end.
