unit UChampsRecherche;

interface

uses
  SysUtils, UIBLib;

type
  TChampSpecial = (csNone, csTitre, csGenre, csAffiche, csEtat, csReliure, csOrientation, csFormatEdition, csTypeEdition, csISBN, csMonnaie, csSensLecture);

  PChamp = ^RChamp;
  RChamp = record
    Groupe: Integer;
    ID: Integer;
    NomTable: string;
    NomChamp: string;
    LibelleChamp: string;
    Special: TChampSpecial;
    Booleen: Boolean;
    ChampImpressionTri: Boolean;

    TypeData: TUIBFieldType;
  end;

  TArrayOfChamp = array[1..40] of RChamp;
  PArrayOfChamp = ^TArrayOfChamp;

function ChampsRecherche: PArrayOfChamp;
function ChampByID(Id: Integer): PChamp;

const
  Groupes: array[1..3] of string = ('Série', 'Album', 'Edition');

implementation

uses Textes, Commun, UIB, DM_Princ;

const
  _ChampsRecherche: TArrayOfChamp = (
    (Groupe: 2; ID: 01; NomTable: 'ALBUMS'; NomChamp: 'uppertitrealbum'; LibelleChamp: rsTransTitreAlbum; Special: csTitre),
    (Groupe: 2; ID: 02; NomTable: 'ALBUMS'; NomChamp: 'anneeparution'; LibelleChamp: rsTransAnneeParution; ChampImpressionTri: True),
    (Groupe: 2; ID: 38; NomTable: 'ALBUMS'; NomChamp: 'moisparution'; LibelleChamp: rsTransMoisParution; ChampImpressionTri: True),
    (Groupe: 2; ID: 03; NomTable: 'ALBUMS'; NomChamp: 'tome'; LibelleChamp: rsTransTome),
    (Groupe: 2; ID: 04; NomTable: 'ALBUMS'; NomChamp: 'horsserie'; LibelleChamp: rsTransHorsSerie; Booleen: True),
    (Groupe: 2; ID: 05; NomTable: 'ALBUMS'; NomChamp: 'integrale'; LibelleChamp: rsTransIntegrale; Booleen: True),
    (Groupe: 2; ID: 06; NomTable: 'ALBUMS'; NomChamp: 'uppersujetalbum'; LibelleChamp: rsTransHistoire + ' ' + rsTransAlbum),
    (Groupe: 2; ID: 07; NomTable: 'ALBUMS'; NomChamp: 'upperremarquesalbum'; LibelleChamp: rsTransNotes + ' ' + rsTransAlbum),
    (Groupe: 2; ID: 08; NomTable: 'ALBUMS'; NomChamp: 'nbeditions'; LibelleChamp: rsTransNombreDEditions; ChampImpressionTri: True),
    (Groupe: 1; ID: 09; NomTable: 'SERIES'; NomChamp: 'uppertitreserie'; LibelleChamp: rsTransTitreSerie; Special: csTitre),
    (Groupe: 1; ID: 10; NomTable: 'SERIES'; NomChamp: 'uppersujetserie'; LibelleChamp: rsTransHistoire + ' ' + rsTransSerie),
    (Groupe: 1; ID: 11; NomTable: 'SERIES'; NomChamp: 'upperremarquesserie'; LibelleChamp: rsTransNotes + ' ' + rsTransSerie),
    (Groupe: 1; ID: 12; NomTable: 'SERIES'; NomChamp: 'terminee'; LibelleChamp: rsTransSerieTerminee; Booleen: True; ChampImpressionTri: True),
    (Groupe: 1; ID: 13; NomTable: 'SERIES'; NomChamp: 'complete'; LibelleChamp: rsTransSerieComplete; Booleen: True; ChampImpressionTri: True),
    (Groupe: 1; ID: 14; NomTable: 'SERIES'; NomChamp: 'suivremanquants'; LibelleChamp: rsTransSerieChercherManquants; Booleen: True; ChampImpressionTri: True),
    (Groupe: 1; ID: 15; NomTable: 'SERIES'; NomChamp: 'suivresorties'; LibelleChamp: rsTransSerieSuivreSorties; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 16; NomTable: 'EDITIONS'; NomChamp: 'anneeedition'; LibelleChamp: rsTransAnneeEdition; ChampImpressionTri: True),
    (Groupe: 3; ID: 17; NomTable: 'EDITIONS'; NomChamp: 'prix'; LibelleChamp: rsTransPrix; Special: csMonnaie; ChampImpressionTri: True),
    (Groupe: 3; ID: 18; NomTable: 'EDITIONS'; NomChamp: 'vo'; LibelleChamp: rsTransVO; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 19; NomTable: 'EDITIONS'; NomChamp: 'couleur'; LibelleChamp: rsTransCouleur; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 20; NomTable: 'EDITIONS'; NomChamp: 'isbn'; LibelleChamp: rsTransISBN; Special: csISBN; ChampImpressionTri: True),
    (Groupe: 3; ID: 21; NomTable: 'EDITIONS'; NomChamp: 'prete'; LibelleChamp: rsTransPrete; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 22; NomTable: 'EDITIONS'; NomChamp: 'stock'; LibelleChamp: rsTransStock; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 23; NomTable: 'EDITIONS'; NomChamp: 'typeedition'; LibelleChamp: rsTransEdition; ChampImpressionTri: False),
    (Groupe: 3; ID: 24; NomTable: 'EDITIONS'; NomChamp: 'dedicace'; LibelleChamp: rsTransDedicace; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 25; NomTable: 'EDITIONS'; NomChamp: 'etat'; LibelleChamp: rsTransEtat; Special: csEtat; ChampImpressionTri: False),
    (Groupe: 3; ID: 26; NomTable: 'EDITIONS'; NomChamp: 'reliure'; LibelleChamp: rsTransReliure; Special: csReliure; ChampImpressionTri: False),
    (Groupe: 3; ID: 27; NomTable: 'EDITIONS'; NomChamp: 'orientation'; LibelleChamp: rsTransOrientation; Special: csOrientation; ChampImpressionTri: False),
    (Groupe: 3; ID: 28; NomTable: 'EDITIONS'; NomChamp: 'formatedition'; LibelleChamp: rsTransFormatEdition; Special: csFormatEdition; ChampImpressionTri: False),
    (Groupe: 3; ID: 29; NomTable: 'EDITIONS'; NomChamp: 'typeedition'; LibelleChamp: rsTransTypeEdition; Special: csTypeEdition; ChampImpressionTri: False),
    (Groupe: 3; ID: 30; NomTable: 'EDITIONS'; NomChamp: 'dateachat'; LibelleChamp: rsTransDateAchat; ChampImpressionTri: True),
    (Groupe: 3; ID: 31; NomTable: 'EDITIONS'; NomChamp: 'gratuit'; LibelleChamp: rsTransGratuit; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 32; NomTable: 'EDITIONS'; NomChamp: 'offert'; LibelleChamp: rsTransOffert; Booleen: True; ChampImpressionTri: True),
    (Groupe: 3; ID: 33; NomTable: 'EDITIONS'; NomChamp: 'nombredepages'; LibelleChamp: rsTransNombreDePages; ChampImpressionTri: True),
    (Groupe: 3; ID: 34; NomTable: 'EDITIONS'; NomChamp: 'anneecote'; LibelleChamp: rsTransCote + ' (' + rsTransAnnee + ')'; ChampImpressionTri: True),
    (Groupe: 3; ID: 35; NomTable: 'EDITIONS'; NomChamp: 'prixcote'; LibelleChamp: rsTransCote + ' (' + rsTransPrix + ')'; Special: csMonnaie; ChampImpressionTri: True),
    (Groupe: 3; ID: 36; NomTable: 'EDITIONS'; NomChamp: 'notes'; LibelleChamp: rsTransNotes + ' ' + rsTransEdition),
    (Groupe: 3; ID: 39; NomTable: 'EDITIONS'; NomChamp: 'numeroperso'; LibelleChamp: rsTransNumeroPerso; ChampImpressionTri: True),
    (Groupe: 3; ID: 40; NomTable: 'EDITIONS'; NomChamp: 'senslecture'; LibelleChamp: rsTransSensLecture; Special: csSensLecture; ChampImpressionTri: False),
    (Groupe: 1; ID: 37; NomTable: 'GENRESERIES'; NomChamp: 'ID_GENRE'; LibelleChamp: rsTransGenre + ' *'; Special: csGenre)
    );

function ChampByID(Id: Integer): PChamp;
var
  i: Integer;
begin
  for i := Low(_ChampsRecherche) to High(_ChampsRecherche) do
    if _ChampsRecherche[i].ID = Id then
    begin
      Result := @_ChampsRecherche[i];
      Exit;
    end;
  Result := nil;
end;

function ChampsRecherche: PArrayOfChamp;
var
  iChamp, pChamp: Integer;
  Table: string;
  hg: IHourGlass;
  Qry: TUIBQuery;
begin
  if _ChampsRecherche[1].TypeData = uftUnKnown then
  begin
    hg := THourGlass.Create;
    Qry := TUIBQuery.Create(nil);
    try
      Qry.Transaction := GetTransaction(DMPrinc.UIBDataBase);

      iChamp := 1;
      while iChamp <= High(_ChampsRecherche) do
      begin
        Table := _ChampsRecherche[iChamp].NomTable;
        Qry.Close;
        Qry.SQL.Text := 'select first 0 * from ' + Table;
        Qry.Open;

        while iChamp <= High(_ChampsRecherche) do
        begin
          if SameText(Table, _ChampsRecherche[iChamp].NomTable) then
          begin
            pChamp := Qry.Fields.GetFieldIndex(_ChampsRecherche[iChamp].NomChamp);
            _ChampsRecherche[iChamp].TypeData := qry.Fields.FieldType[pChamp];
            Inc(iChamp);
          end
          else
            Break;
        end;
      end;
    finally
      Qry.Transaction.Free;
      Qry.Free;
    end;
  end;
  Result := @_ChampsRecherche;
end;

end.

