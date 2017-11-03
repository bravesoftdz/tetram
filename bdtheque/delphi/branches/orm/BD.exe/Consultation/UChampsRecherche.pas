unit UChampsRecherche;

interface

uses
  Windows, SysUtils, Classes, UIBLib, AnsiStrings;

type
  TChampSpecial = (csNone, csTitre, csGenre, csAffiche, csEtat, csReliure, csOrientation, csFormatEdition, csTypeEdition, csISBN, csMonnaie, csSensLecture, csNotation);

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

  TArrayOfChamp = array[1..44] of RChamp;
  PArrayOfChamp = ^TArrayOfChamp;

function ChampsRecherche: PArrayOfChamp;
function ChampByID(Id: Integer): PChamp;

const
  Groupes: array[1..4] of string = ('Univers', 'S�rie', 'Album', 'Edition');

implementation

uses
  Textes, Commun, UIB, UdmPrinc, ORM.Core.DBConnection;

const
  GP_UNIVERS = 1;
  GP_SERIES = 2;
  GP_ALBUMS = 3;
  GP_EDITIONS = 4;

var
  // Bien que pas g�nant, il vaut mieux que les champs soient regroup�s par table
  _ChampsRecherche: TArrayOfChamp = (
    (Groupe: GP_ALBUMS; ID: 01; NomTable: 'ALBUMS'; NomChamp: 'titrealbum'; LibelleChamp: rsTransTitreAlbum; Special: csTitre),
    (Groupe: GP_ALBUMS; ID: 02; NomTable: 'ALBUMS'; NomChamp: 'anneeparution'; LibelleChamp: rsTransAnneeParution; ChampImpressionTri: True),
    (Groupe: GP_ALBUMS; ID: 38; NomTable: 'ALBUMS'; NomChamp: 'moisparution'; LibelleChamp: rsTransMoisParution; ChampImpressionTri: True),
    (Groupe: GP_ALBUMS; ID: 03; NomTable: 'ALBUMS'; NomChamp: 'tome'; LibelleChamp: rsTransTome),
    (Groupe: GP_ALBUMS; ID: 04; NomTable: 'ALBUMS'; NomChamp: 'horsserie'; LibelleChamp: rsTransHorsSerie; Booleen: True),
    (Groupe: GP_ALBUMS; ID: 05; NomTable: 'ALBUMS'; NomChamp: 'integrale'; LibelleChamp: rsTransIntegrale; Booleen: True),
    (Groupe: GP_ALBUMS; ID: 06; NomTable: 'ALBUMS'; NomChamp: 'sujetalbum'; LibelleChamp: rsTransHistoire + ' ' + rsTransAlbum),
    (Groupe: GP_ALBUMS; ID: 07; NomTable: 'ALBUMS'; NomChamp: 'remarquesalbum'; LibelleChamp: rsTransNotes + ' ' + rsTransAlbum),
    (Groupe: GP_ALBUMS; ID: 08; NomTable: 'ALBUMS'; NomChamp: 'nbeditions'; LibelleChamp: rsTransNombreDEditions; ChampImpressionTri: True),
    (Groupe: GP_ALBUMS; ID: 42; NomTable: 'ALBUMS'; NomChamp: 'notation'; LibelleChamp: rsTransAlbumNotation; Special: csNotation; ChampImpressionTri: True),
    (Groupe: GP_SERIES; ID: 09; NomTable: 'SERIES'; NomChamp: 'titreserie'; LibelleChamp: rsTransTitreSerie; Special: csTitre),
    (Groupe: GP_SERIES; ID: 10; NomTable: 'SERIES'; NomChamp: 'sujetserie'; LibelleChamp: rsTransHistoire + ' ' + rsTransSerie),
    (Groupe: GP_SERIES; ID: 11; NomTable: 'SERIES'; NomChamp: 'remarquesserie'; LibelleChamp: rsTransNotes + ' ' + rsTransSerie),
    (Groupe: GP_SERIES; ID: 12; NomTable: 'SERIES'; NomChamp: 'terminee'; LibelleChamp: rsTransSerieTerminee; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_SERIES; ID: 13; NomTable: 'SERIES'; NomChamp: 'complete'; LibelleChamp: rsTransSerieComplete; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_SERIES; ID: 14; NomTable: 'SERIES'; NomChamp: 'suivremanquants'; LibelleChamp: rsTransSerieChercherManquants; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_SERIES; ID: 15; NomTable: 'SERIES'; NomChamp: 'suivresorties'; LibelleChamp: rsTransSerieSuivreSorties; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_SERIES; ID: 41; NomTable: 'SERIES'; NomChamp: 'notation'; LibelleChamp: rsTransSerieSuivreSorties; Special: csNotation; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 16; NomTable: 'EDITIONS'; NomChamp: 'anneeedition'; LibelleChamp: rsTransAnneeEdition; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 17; NomTable: 'EDITIONS'; NomChamp: 'prix'; LibelleChamp: rsTransPrix; Special: csMonnaie; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 18; NomTable: 'EDITIONS'; NomChamp: 'vo'; LibelleChamp: rsTransVO; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 19; NomTable: 'EDITIONS'; NomChamp: 'couleur'; LibelleChamp: rsTransCouleur; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 20; NomTable: 'EDITIONS'; NomChamp: 'isbn'; LibelleChamp: rsTransISBN; Special: csISBN; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 21; NomTable: 'EDITIONS'; NomChamp: 'prete'; LibelleChamp: rsTransPrete; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 22; NomTable: 'EDITIONS'; NomChamp: 'stock'; LibelleChamp: rsTransStock; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 23; NomTable: 'EDITIONS'; NomChamp: 'typeedition'; LibelleChamp: rsTransEdition; ChampImpressionTri: False),
    (Groupe: GP_EDITIONS; ID: 24; NomTable: 'EDITIONS'; NomChamp: 'dedicace'; LibelleChamp: rsTransDedicace; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 25; NomTable: 'EDITIONS'; NomChamp: 'etat'; LibelleChamp: rsTransEtat; Special: csEtat; ChampImpressionTri: False),
    (Groupe: GP_EDITIONS; ID: 26; NomTable: 'EDITIONS'; NomChamp: 'reliure'; LibelleChamp: rsTransReliure; Special: csReliure; ChampImpressionTri: False),
    (Groupe: GP_EDITIONS; ID: 27; NomTable: 'EDITIONS'; NomChamp: 'orientation'; LibelleChamp: rsTransOrientation; Special: csOrientation; ChampImpressionTri: False),
    (Groupe: GP_EDITIONS; ID: 28; NomTable: 'EDITIONS'; NomChamp: 'formatedition'; LibelleChamp: rsTransFormatEdition; Special: csFormatEdition; ChampImpressionTri: False),
    (Groupe: GP_EDITIONS; ID: 29; NomTable: 'EDITIONS'; NomChamp: 'typeedition'; LibelleChamp: rsTransTypeEdition; Special: csTypeEdition; ChampImpressionTri: False),
    (Groupe: GP_EDITIONS; ID: 30; NomTable: 'EDITIONS'; NomChamp: 'dateachat'; LibelleChamp: rsTransDateAchat; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 31; NomTable: 'EDITIONS'; NomChamp: 'gratuit'; LibelleChamp: rsTransGratuit; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 32; NomTable: 'EDITIONS'; NomChamp: 'offert'; LibelleChamp: rsTransOffert; Booleen: True; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 33; NomTable: 'EDITIONS'; NomChamp: 'nombredepages'; LibelleChamp: rsTransNombreDePages; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 34; NomTable: 'EDITIONS'; NomChamp: 'anneecote'; LibelleChamp: rsTransCote + ' (' + rsTransAnnee + ')'; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 35; NomTable: 'EDITIONS'; NomChamp: 'prixcote'; LibelleChamp: rsTransCote + ' (' + rsTransPrix + ')'; Special: csMonnaie; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 36; NomTable: 'EDITIONS'; NomChamp: 'notes'; LibelleChamp: rsTransNotes + ' ' + rsTransEdition),
    (Groupe: GP_EDITIONS; ID: 39; NomTable: 'EDITIONS'; NomChamp: 'numeroperso'; LibelleChamp: rsTransNumeroPerso; ChampImpressionTri: True),
    (Groupe: GP_EDITIONS; ID: 40; NomTable: 'EDITIONS'; NomChamp: 'senslecture'; LibelleChamp: rsTransSensLecture; Special: csSensLecture; ChampImpressionTri: False),
    (Groupe: GP_SERIES; ID: 37; NomTable: 'GENRESERIES'; NomChamp: 'ID_GENRE'; LibelleChamp: rsTransGenre + ' *'; Special: csGenre),
    (Groupe: GP_UNIVERS; ID: 43; NomTable: 'UNIVERS'; NomChamp: 'NomUnivers'; LibelleChamp: rsTransNomUnivers; Special: csTitre),
    (Groupe: GP_UNIVERS; ID: 44; NomTable: 'UNIVERS'; NomChamp: 'Description'; LibelleChamp: rsTransDescription + ' ' + rsTransUnivers)
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
  qry: TManagedQuery;
begin
  if _ChampsRecherche[1].TypeData = uftUnKnown then
  begin
    hg := THourGlass.Create;
    qry := dmPrinc.DBConnection.GetQuery;
    try
      iChamp := 1;
      while iChamp <= High(_ChampsRecherche) do
      begin
        Table := _ChampsRecherche[iChamp].NomTable;
        qry.Close;
        qry.SQL.Text := 'select first 0 * from ' + Table;
        qry.Open;

        while iChamp <= High(_ChampsRecherche) do
        begin
          if SameText(Table, _ChampsRecherche[iChamp].NomTable) then
          begin
            pChamp := qry.Fields.GetFieldIndex(AnsiString(_ChampsRecherche[iChamp].NomChamp));
            _ChampsRecherche[iChamp].TypeData := qry.Fields.FieldType[pChamp];
            Inc(iChamp);
          end
          else
            Break;
        end;
      end;
    finally
      qry.Free;
    end;
  end;
  Result := @_ChampsRecherche;
end;

end.

