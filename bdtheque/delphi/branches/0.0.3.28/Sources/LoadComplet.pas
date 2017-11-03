unit LoadComplet;

interface

uses
  SysUtils, Windows, Classes, TypeRec, Commun, CommonConst, DM_Princ, JvUIB, DateUtils, Contnrs;

type
  TBaseComplet = class
  private
    procedure WriteString(Stream: TStream; const Chaine: string);
    procedure WriteStringLN(Stream: TStream; const Chaine: string);
  public
    procedure Fill(const Reference: Integer); virtual;
    procedure BeforeDestruction; override;
    procedure Clear; virtual;

    constructor Create; overload; virtual;
    constructor Create(const Reference: Integer); overload;

    procedure WriteXMLToStream(Stream: TStream); virtual;
  end;

  TSrcEmprunt = (seTous, seAlbum, seEmprunteur);
  TSensEmprunt = (ssTous, ssPret, ssRetour);

  TEmpruntsComplet = class(TBaseComplet)
    Emprunts: TList;
    NBEmprunts: Integer;

    procedure Fill(Reference: Integer; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(Reference: Integer; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce; overload;
    destructor Destroy; override;
  end;

  TEditeurComplet = class(TBaseComplet)
    RefEditeur: Integer;
    NomEditeur: string[50];
    SiteWeb: string[255];

    procedure Fill(const Reference: Integer); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TAuteurComplet = class(TBaseComplet)
    RefAuteur: Integer;
    NomAuteur: string[50];
    SiteWeb: string[255];
    Biographie: TStringList;
    Series: TObjectList;

    procedure Fill(const Reference: Integer); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TSerieComplete = class(TBaseComplet)
    RefSerie: Integer;
    Titre: string;
    Terminee: Integer;
    Albums: TList;
    Genres: TStringList;
    Sujet, Notes: TStringList;
    Editeur: TEditeurComplet;
    Collection: TCollection;
    SiteWeb: string[255];
    Scenaristes, Dessinateurs, Coloristes: TList;

    FIdAuteur: Integer;

    procedure Fill(const Reference: Integer); override;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(const Reference, IdAuteur: Integer); overload;
    destructor Destroy; override;
  end;

  TEditionComplete = class(TBaseComplet)
  private
    function Get_sDateAchat: string;
  public
    RefEdition, RefAlbum: Integer;
    Editeur: TEditeurComplet;
    Collection: TCollection;
    TypeEdition, AnneeEdition, Etat, Reliure, NombreDePages, FormatEdition, Orientation: Integer;
    Prix: Currency;
    Couleur, VO, Dedicace, Stock, Prete, Offert, Gratuit: Boolean;
    ISBN, sEtat, sReliure, sTypeEdition, sFormatEdition, sOrientation: string;
    DateAchat: TDateTime;
    Notes: TStringList;
    Emprunts: TEmpruntsComplet;
    Couvertures: TList;

    procedure Fill(const Reference: Integer); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;

    procedure WriteXMLToStream(Stream: TStream); override;
  published
    property sDateAchat: string read Get_sDateAchat;
  end;

  TEditionsComplet = class(TBaseComplet)
    Editions: TList;

    procedure Fill(Reference: Integer; Stock: Integer = -1); reintroduce;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(Reference: Integer; Stock: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
  end;

  TAlbumComplet = class(TBaseComplet)
    RefAlbum, MoisParution, AnneeParution, Tome, TomeDebut, TomeFin: Integer;
    Titre: string[50];
    HorsSerie, Integrale: Boolean;
    Scenaristes, Dessinateurs, Coloristes: TList;
    Sujet, Notes: TStringList;
    Serie: TSerieComplete;
    Editions: TEditionsComplet;

    procedure Fill(const Reference: Integer); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;

    procedure WriteXMLToStream(Stream: TStream); override;
  end;

  TEmprunteurComplet = class(TBaseComplet)
    RefEmprunteur: Integer;
    Nom: string[100];
    Adresse: TStringList;
    Emprunts: TEmpruntsComplet;

    procedure Fill(const Reference: Integer); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TStats = class(TBaseComplet)
    Editeur: string;
    NbAlbums, NbSeries, NbSeriesTerminee,
      NbAlbumsNB, NbAlbumsVO, NbAlbumsStock, NbAlbumsIntegrale, NbAlbumsHorsSerie, NbAlbumsDedicace, NbAlbumsOffert, NbAlbumsGratuit,
      MinAnnee, MaxAnnee,
      NbEmprunteurs, MoyEmprunteurs, MinEmprunteurs, MaxEmprunteurs,
      NbEmpruntes, MoyEmpruntes, MinEmpruntes, MaxEmpruntes,
      NbAlbumsSansPrix: Integer;
    ValeurConnue, ValeurEstimee,
      PrixAlbumMinimun, PrixAlbumMoyen, PrixAlbumMaximun: Currency;
    ListAlbumsMin, ListEmprunteursMin,
      ListAlbumsMax, ListEmprunteursMax,
      ListGenre: TList;
    ListEditeurs: TList;

    procedure Fill(Complete: Boolean); reintroduce;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(Complete: Boolean); reintroduce; overload;
    destructor Destroy; override;

  private
    procedure CreateStats(var Stats: TStats; RefEditeur: Integer = -1; Editeur: string = '');
  end;

  TSerieIncomplete = class
    Serie: TSerie;
    NumerosManquants: TStringList;

    constructor Create;
    destructor Destroy; override;
    function ChaineAffichage: string;
  end;

  TSeriesIncompletes = class(TBaseComplet)
    Series: TObjectList;

    procedure Fill(const Reference: Integer); overload; override;
    procedure Fill(AvecIntegrales, AvecAchats: Boolean; RefSerie: Integer); reintroduce; overload;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(AvecIntegrales, AvecAchats: Boolean); reintroduce; overload;
    destructor Destroy; override;
  end;

  TPrevisionSortie = class
    Serie: TSerie;
    Tome, Annee, Mois: Integer;

    constructor Create;
    destructor Destroy; override;
    function sAnnee: string;
  end;

  TPrevisionsSorties = class(TBaseComplet)
    AnneesPassees: TObjectList;
    AnneeEnCours: TObjectList;
    AnneesProchaines: TObjectList;

    procedure Fill(const Reference: Integer); overload; override;
    procedure Fill(AvecAchats: Boolean); reintroduce; overload;
    procedure Fill(AvecAchats: Boolean; RefSerie: Integer); reintroduce; overload;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(AvecAchats: Boolean); reintroduce; overload;
    destructor Destroy; override;
  end;

implementation

uses JvUIBLib, Divers;

{ TBaseComplet }

procedure TBaseComplet.BeforeDestruction;
begin
  inherited;
  Clear;
end;

procedure TBaseComplet.Clear;
begin
  // nettoyage de toutes les listes et autres
end;

constructor TBaseComplet.Create(const Reference: Integer);
begin
  Create;
  Fill(Reference);
end;

constructor TBaseComplet.Create;
begin

end;

procedure TBaseComplet.Fill(const Reference: Integer);
begin
  Clear;
end;

procedure TBaseComplet.WriteString(Stream: TStream; const Chaine: string);
begin
  Stream.Write(Chaine[1], Length(Chaine));
end;

procedure TBaseComplet.WriteStringLN(Stream: TStream; const Chaine: string);
begin
  WriteString(Stream, Chaine + #13#10);
end;

procedure TBaseComplet.WriteXMLToStream(Stream: TStream);
begin

end;

{ TAlbumComplet }

procedure TAlbumComplet.Clear;
begin
  inherited;
  RefAlbum := -1;
  Titre := '';

  TAuteur.VideListe(Scenaristes);
  TAuteur.VideListe(Dessinateurs);
  TAuteur.VideListe(Coloristes);

  Sujet.Clear;
  Notes.Clear;
  Serie.Clear;
  Editions.Clear;
end;

constructor TAlbumComplet.Create;
begin
  Scenaristes := TList.Create;
  Dessinateurs := TList.Create;
  Coloristes := TList.Create;
  Sujet := TStringList.Create;
  Notes := TStringList.Create;
  Serie := TSerieComplete.Create;
  Editions := TEditionsComplet.Create;
end;

destructor TAlbumComplet.Destroy;
begin
  FreeAndNil(Scenaristes);
  FreeAndNil(Dessinateurs);
  FreeAndNil(Coloristes);

  Sujet.Free;
  Notes.Free;
  Serie.Free;
  Editions.Free;
  inherited;
end;

procedure TAlbumComplet.Fill(const Reference: Integer);
var
  serie: Integer;
  q: TJvUIBQuery;
begin
  inherited;
  if (Reference = 0) then Exit;
  Self.RefAlbum := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITREALBUM, MOISPARUTION, ANNEEPARUTION, REFSERIE, TOME, TOMEDEBUT, TOMEFIN, SUJETALBUM, REMARQUESALBUM, HORSSERIE, INTEGRALE FROM ALBUMS WHERE RefAlbum = ?';
    Params.AsInteger[0] := Reference;
    Open;
    Self.Titre := Fields.ByNameAsString['TITREALBUM'];
    Self.AnneeParution := Fields.ByNameAsInteger['ANNEEPARUTION'];
    Self.MoisParution := Fields.ByNameAsInteger['MOISPARUTION'];
    Self.Sujet.Text := Fields.ByNameAsString['SUJETALBUM'];
    Self.Notes.Text := Fields.ByNameAsString['REMARQUESALBUM'];
    Self.Tome := Fields.ByNameAsInteger['TOME'];
    Self.TomeDebut := Fields.ByNameAsInteger['TOMEDEBUT'];
    Self.TomeFin := Fields.ByNameAsInteger['TOMEFIN'];
    Self.Integrale := Fields.ByNameAsBoolean['INTEGRALE'];
    Self.HorsSerie := Fields.ByNameAsBoolean['HORSSERIE'];

    serie := Fields.ByNameAsInteger['REFSERIE'];

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL)';
    Params.AsInteger[0] := Reference;
    Open;
    while not Eof do begin
      case Fields.ByNameAsInteger['Metier'] of
        0: Self.Scenaristes.Add(TAuteur.Make(q));
        1: Self.Dessinateurs.Add(TAuteur.Make(q));
        2: Self.Coloristes.Add(TAuteur.Make(q));
      end;
      Next;
    end;

    Self.Serie.Fill(serie);

    Self.Editions.Fill(Self.RefAlbum);
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

procedure TAlbumComplet.WriteXMLToStream(Stream: TStream);
var
  i: Integer;
begin
  inherited;
  WriteStringLN(Stream, Format('<Album RefAlbum="%d">', [RefAlbum]));

  WriteStringLN(Stream, #9'<Titre><![CDATA[' + Titre + ']]></Titre>');
  WriteStringLN(Stream, Format(#9'<Tome Value="%s" />', [NonZero(IntToStr(Tome))]));
  WriteStringLN(Stream, Format(#9'<Parution Annee="%s" />', [NonZero(IntToStr(AnneeParution))]));
  if Integrale then
    WriteStringLN(Stream, Format(#9'<Integrale TomeDebut="%s" TomeFin="%s" />', [NonZero(IntToStr(TomeDebut)), NonZero(IntToStr(TomeFin))]));
  if HorsSerie then
    WriteStringLN(Stream, #9'<HorsSerie />');

  if Sujet.Count > 0 then
    WriteStringLN(Stream, #9'<Sujet><![CDATA[' + Sujet.Text + ']]></Sujet>');
  if Notes.Count > 0 then
    WriteStringLN(Stream, #9'<Notes><![CDATA[' + Notes.Text + ']]></Notes>');

  for i := 0 to Pred(Scenaristes.Count) do
    WriteStringLN(Stream, Format(#9'<Scenariste RefAuteur="%d" />', [TAuteur(Scenaristes[i]).Personne.Reference]));
  for i := 0 to Pred(Dessinateurs.Count) do
    WriteStringLN(Stream, Format(#9'<Dessinateur RefAuteur="%d" />', [TAuteur(Dessinateurs[i]).Personne.Reference]));
  for i := 0 to Pred(Coloristes.Count) do
    WriteStringLN(Stream, Format(#9'<Coloriste RefAuteur="%d" />', [TAuteur(Coloristes[i]).Personne.Reference]));

  WriteStringLN(Stream, Format(#9'<Serie RefSerie="%d" />', [Serie.RefSerie]));

  for i := 0 to Pred(Editions.Editions.Count) do
    with TEditionComplete.Create(TEdition(Editions.Editions[i]).Reference) do try
      WriteXMLToStream(Stream);
    finally
      Free;
    end;

  WriteStringLN(Stream, '</Album>');
end;

{ TEditionComplete }

constructor TEditionComplete.Create;
begin
  Editeur := TEditeurComplet.Create;
  Collection := TCollection.Create;
  Emprunts := TEmpruntsComplet.Create;
  Couvertures := TList.Create;
  Notes := TStringList.Create;
end;

procedure TEditionComplete.Clear;
begin
  inherited;
  RefEdition := -1;
  Editeur.Clear;
  Collection.Clear;
  Emprunts.Clear;
  TCouverture.VideListe(Couvertures);
  Notes.Clear;
end;

destructor TEditionComplete.Destroy;
begin
  Couvertures.Free;
  Editeur.Free;
  FreeAndNil(Collection);
  FreeAndNil(Emprunts);
  FreeAndNil(Notes);
  inherited;
end;

procedure TEditionComplete.Fill(const Reference: Integer);
var
  q: TJvUIBQuery;
begin
  inherited;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT REFEDITION, RefAlbum, e.REFEDITEUR, e.REFCOLLECTION, NOMCOLLECTION, ANNEEEDITION, PRIX, VO, COULEUR, ISBN, DEDICACE, PRETE, STOCK, Offert, Gratuit,';
    SQL.Add('NombreDePages, etat, le.libelle as setat, reliure, lr.libelle as sreliure, orientation, lo.libelle as sorientation, FormatEdition, lf.libelle as sFormatEdition, typeedition, lte.libelle as stypeedition, DateAchat, Notes');
    SQL.Add('FROM EDITIONS e LEFT JOIN COLLECTIONS c ON e.REFCOLLECTION = c.REFCOLLECTION');
    SQL.Add('LEFT JOIN LISTES le on (le.ref = e.etat and le.categorie = 1)');
    SQL.Add('LEFT JOIN LISTES lr on (lr.ref = e.reliure and lr.categorie = 2)');
    SQL.Add('LEFT JOIN LISTES lte on (lte.ref = e.typeedition and lte.categorie = 3)');
    SQL.Add('LEFT JOIN LISTES lo on (lo.ref = e.orientation and lo.categorie = 4)');
    SQL.Add('LEFT JOIN LISTES lf on (lf.ref = e.formatedition and lf.categorie = 5)');
    SQL.Add('WHERE REFEDITION = ?');
    Params.AsInteger[0] := Reference;
    FetchBlobs := True;
    Open;

    Self.RefEdition := Fields.ByNameAsInteger['REFEDITION'];
    Self.RefAlbum := Fields.ByNameAsInteger['RefAlbum'];
    Self.Editeur.Fill(Fields.ByNameAsInteger['REFEDITEUR']);
    Self.Collection.Fill(q);
    Self.AnneeEdition := Fields.ByNameAsInteger['ANNEEEDITION'];
    Self.Prix := Fields.ByNameAsCurrency['PRIX'];
    Self.VO := Fields.ByNameAsBoolean['VO'];
    Self.Couleur := Fields.ByNameAsBoolean['COULEUR'];
    Self.Dedicace := Fields.ByNameAsBoolean['DEDICACE'];
    Self.Offert := Fields.ByNameAsBoolean['OFFERT'];
    Self.Gratuit := Fields.ByNameAsBoolean['GRATUIT'];
    Self.Prete := Fields.ByNameAsBoolean['PRETE'];
    Self.Stock := Fields.ByNameAsBoolean['STOCK'];
    Self.ISBN := FormatISBN(Trim(Fields.ByNameAsString['ISBN']));
    Self.TypeEdition := Fields.ByNameAsInteger['TypeEdition'];
    Self.sTypeEdition := Trim(Fields.ByNameAsString['sTypeEdition']);
    Self.NombreDePages := Fields.ByNameAsInteger['NombreDePages'];
    Self.Etat := Fields.ByNameAsInteger['Etat'];
    Self.sEtat := Trim(Fields.ByNameAsString['sEtat']);
    Self.Reliure := Fields.ByNameAsInteger['Reliure'];
    Self.sReliure := Trim(Fields.ByNameAsString['sReliure']);
    Self.Orientation := Fields.ByNameAsInteger['Orientation'];
    Self.sOrientation := Trim(Fields.ByNameAsString['sOrientation']);
    Self.FormatEdition := Fields.ByNameAsInteger['FormatEdition'];
    Self.sFormatEdition := Trim(Fields.ByNameAsString['sFormatEdition']);
    Self.DateAchat := Fields.ByNameAsDate['DateAchat'];
    Self.Notes.Text := Fields.ByNameAsString['Notes'];

    Self.Emprunts.Fill(Self.RefEdition, seAlbum);

    Close;
    SQL.Text := 'SELECT RefCouverture, FichierCouverture, TypeCouverture FROM Couvertures WHERE RefEdition = ? ORDER BY Ordre';
    Params.AsInteger[0] := Self.RefEdition;
    Open;
    while not Eof do begin
      Self.Couvertures.Add(TCouverture.Make(q));
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

function TEditionComplete.Get_sDateAchat: string;
begin
  if Self.DateAchat > 0 then
    Result := DateToStr(Self.DateAchat)
  else
    Result := '';
end;

procedure TEditionComplete.WriteXMLToStream(Stream: TStream);
begin
  inherited;
  WriteStringLN(Stream, Format('<Edition RefEdition="%d" RefAlbum="%d">', [RefEdition, RefAlbum]));

  if ISBN <> '' then WriteStringLN(Stream, Format(#9'<ISBN>%s</ISBN>', [ISBN]));
  WriteStringLN(Stream, Format(#9'<AnneeEdition Value="%s" />', [NonZero(IntToStr(AnneeEdition))]));

  if Prix > 0 then
    WriteStringLN(Stream, Format(#9'<Prix Monnaie="%s">%s</Prix>', [Utilisateur.Options.SymboleMonnetaire, FloatToStr(Prix)]));

  if DateAchat > 0 then
    WriteStringLN(Stream, Format(#9'<DateAchat Format="DD/MM/YYYY">%s</DateAchat>', [FormatDateTime('dd/mm/yyyy', DateAchat)]));

  if Couleur then WriteStringLN(Stream, #9'<Couleur />');
  if VO then WriteStringLN(Stream, #9'<VO />');
  if Dedicace then WriteStringLN(Stream, #9'<Dedicace />');
  if Stock then WriteStringLN(Stream, #9'<Stock />');
  if Prete then WriteStringLN(Stream, #9'<Prete />');
  if Offert then WriteStringLN(Stream, #9'<Offert />');
  if Gratuit then WriteStringLN(Stream, #9'<Gratuit />');

  WriteStringLN(Stream, Format(#9'<TypeEdition Value="%d">%s</TypeEdition>', [TypeEdition, sTypeEdition]));
  WriteStringLN(Stream, Format(#9'<Etat Value="%d">%s</Etat>', [Etat, sEtat]));
  WriteStringLN(Stream, Format(#9'<Reliure Value="%d">%s</Reliure>', [Reliure, sReliure]));

  if Editeur.RefEditeur > -1 then
    WriteStringLN(Stream, Format(#9'<Editeur RefEditeur="%d" />', [Editeur.RefEditeur]));
  if Collection.Reference > -1 then
    WriteStringLN(Stream, Format(#9'<Collection RefCollection="%d" />', [Collection.Reference]));

  if Notes.Count > 0 then
    WriteStringLN(Stream, #9'<Notes><![CDATA[' + Notes.Text + ']]></Notes>');

  //    Couvertures: TList;

  WriteStringLN(Stream, '</Edition>');
end;

{ TEditionsComplet }

procedure TEditionsComplet.Clear;
begin
  inherited;
  TEdition.VideListe(Editions);
end;

constructor TEditionsComplet.Create;
begin
  inherited;
  Editions := TList.Create;
end;

constructor TEditionsComplet.Create(Reference, Stock: Integer);
begin
  Create;
  Fill(Reference, Stock);
end;

destructor TEditionsComplet.Destroy;
begin
  Editions.Free;
  inherited;
end;

procedure TEditionsComplet.Fill(Reference: Integer; Stock: Integer = -1);
var
  q: TJvUIBQuery;
begin
  inherited Fill(Reference);
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT REFEDITION, e.REFEDITEUR, ed.nomediteur, e.REFCOLLECTION, c.nomcollection, ANNEEEDITION, ISBN';
    SQL.Add('FROM EDITIONS e LEFT JOIN editeurs ed on e.refediteur = ed.refediteur LEFT JOIN collections c on e.refcollection = c.refcollection');
    SQL.Add('WHERE REFALBUM = ?');
    if Stock in [0, 1] then SQL.Add('AND e.STOCK = :Stock');
    Params.AsInteger[0] := Reference;
    if Stock in [0, 1] then Params.AsInteger[1] := Stock;
    Open;
    while not Eof do begin
      Editions.Add(TEdition.Make(q));
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TEmprunteurComplet }

procedure TEmprunteurComplet.Clear;
begin
  inherited;
  RefEmprunteur := -1;
  Nom := '';
  Adresse.Clear;
  Emprunts.Clear;
end;

constructor TEmprunteurComplet.Create;
begin
  inherited;
  Adresse := TStringList.Create;
  Emprunts := TEmpruntsComplet.Create;
end;

destructor TEmprunteurComplet.Destroy;
begin
  FreeAndNil(Adresse);
  FreeAndNil(Emprunts);
  inherited;
end;

procedure TEmprunteurComplet.Fill(const Reference: Integer);
var
  q: TJvUIBQuery;
begin
  inherited;
  if (Reference = 0) then Exit;
  Self.RefEmprunteur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NomEmprunteur, AdresseEmprunteur FROM Emprunteurs WHERE RefEmprunteur = ?';
    Params.AsInteger[0] := Reference;
    FetchBlobs := True;
    Open;
    Self.Nom := Fields.ByNameAsString['NomEmprunteur'];
    Self.Adresse.Text := Fields.ByNameAsString['AdresseEmprunteur'];

    Self.Emprunts.Fill(Self.RefEmprunteur, seEmprunteur);

    Close;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TSerieComplete }

procedure TSerieComplete.Clear;
begin
  inherited;
  RefSerie := -1;
  Titre := '';
  TAlbum.VideListe(Albums);
  Genres.Clear;
  Sujet.Clear;
  Notes.Clear;
  Editeur.Clear;
  Collection.Clear;
  TAuteur.VideListe(Scenaristes);
  TAuteur.VideListe(Dessinateurs);
  TAuteur.VideListe(Coloristes);
end;

constructor TSerieComplete.Create;
begin
  inherited;
  FIdAuteur := -1;
  Albums := TList.Create;
  Genres := TStringList.Create;
  Sujet := TStringList.Create;
  Notes := TStringList.Create;
  Editeur := TEditeurComplet.Create;
  Collection := TCollection.Create;
  Scenaristes := TList.Create;
  Dessinateurs := TList.Create;
  Coloristes := TList.Create;
end;

constructor TSerieComplete.Create(const Reference, IdAuteur: Integer);
begin
  Create;
  FIdAuteur := IdAuteur;
  Fill(Reference);
end;

destructor TSerieComplete.Destroy;
begin
  FreeAndNil(Albums);
  Genres.Free;
  Sujet.Free;
  Notes.Free;
  Editeur.Free;
  FreeAndNil(Collection);
  FreeAndNil(Scenaristes);
  FreeAndNil(Dessinateurs);
  FreeAndNil(Coloristes);
  inherited;
end;

procedure TSerieComplete.Fill(const Reference: Integer);
var
  q: TJvUIBQuery;
begin
  inherited;
  if (Reference = 0) then Exit;
  Self.RefSerie := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, S.REFEDITEUR, S.REFCOLLECTION, NOMCOLLECTION '
      + 'FROM SERIES S LEFT JOIN COLLECTIONS C ON S.REFCOLLECTION = C.REFCOLLECTION '
      + 'WHERE REFSERIE = ?';
    Params.AsInteger[0] := Reference;
    Open;
    Self.Titre := FormatTitre(Fields.ByNameAsString['TITRESERIE']);
    if Fields.ByNameIsNull['TERMINEE'] then
      Self.Terminee := -1
    else
      Self.Terminee := Fields.ByNameAsInteger['TERMINEE'];
    Self.Sujet.Text := Fields.ByNameAsString['SUJETSERIE'];
    Self.Notes.Text := Fields.ByNameAsString['REMARQUESSERIE'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
    Self.Editeur.Fill(Fields.ByNameAsInteger['REFEDITEUR']);
    Self.Collection.Fill(q);
    FetchBlobs := False;

    Close;
    SQL.Text := 'SELECT REFALBUM, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, REFSERIE '
      + 'FROM ALBUMS '
      + 'WHERE REFSERIE = ? ';
    if FIdAuteur <> -1 then
      SQL.Text := SQL.Text
        + 'AND REFALBUM IN (SELECT REFALBUM FROM AUTEURS WHERE REFPERSONNE = ?) ';
    SQL.Text := SQL.Text
      + 'ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST';
    Params.AsInteger[0] := Reference;
    if FIdAuteur <> -1 then
      Params.AsInteger[1] := FIdAuteur;
    Open;
    while not Eof do begin
      Self.Albums.Add(TAlbum.Make(q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT Genre '
      + 'FROM GenreSeries s INNER JOIN Genres g ON g.RefGenre = s.RefGenre '
      + 'WHERE RefSerie = ?';
    Params.AsInteger[0] := Reference;
    Open;
    while not Eof do begin
      Self.Genres.Add(Fields.AsString[0]);
      Next;
    end;

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, ?)';
    Params.AsInteger[0] := Reference;
    Open;
    while not Eof do begin
      case Fields.ByNameAsInteger['Metier'] of
        0: Self.Scenaristes.Add(TAuteur.Make(q));
        1: Self.Dessinateurs.Add(TAuteur.Make(q));
        2: Self.Coloristes.Add(TAuteur.Make(q));
      end;
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TEditeurComplet }

procedure TEditeurComplet.Clear;
begin
  inherited;
  RefEditeur := -1;
  NomEditeur := '';
  SiteWeb := '';
end;

constructor TEditeurComplet.Create;
begin
  inherited;

end;

destructor TEditeurComplet.Destroy;
begin

  inherited;
end;

procedure TEditeurComplet.Fill(const Reference: Integer);
var
  q: TJvUIBQuery;
begin
  inherited;
  if (Reference = 0) then Exit;
  Self.RefEditeur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMEDITEUR, SITEWEB FROM EDITEURS WHERE REFEDITEUR = ?';
    Params.AsInteger[0] := Reference;
    Open;
    Self.NomEditeur := Fields.ByNameAsString['NOMEDITEUR'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TStats }

procedure TStats.Clear;
var
  i: Integer;
begin
  inherited;
  TEmprunteur.VideListe(ListEmprunteursMax);
  TEmprunteur.VideListe(ListEmprunteursMin);
  TAlbum.VideListe(ListAlbumsMax);
  TAlbum.VideListe(ListAlbumsMin);
  TGenre.VideListe(ListGenre);
  for i := 0 to Pred(ListEditeurs.Count) do
    TStats(ListEditeurs[i]).Free;
  ListEditeurs.Clear;
end;

constructor TStats.Create;
begin
  inherited;
  ListEmprunteursMax := TList.Create;
  ListAlbumsMax := TList.Create;
  ListEmprunteursMin := TList.Create;
  ListAlbumsMin := TList.Create;
  ListGenre := TList.Create;
  ListEditeurs := TList.Create;
end;

constructor TStats.Create(Complete: Boolean);
begin
  Create;
  Fill(Complete);
end;

procedure TStats.CreateStats(var Stats: TStats; RefEditeur: Integer; Editeur: string);
var
  q: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Stats.Editeur := Editeur;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Add('SELECT COUNT(a.RefAlbum) FROM Albums a INNER JOIN Editions e ON a.RefAlbum = e.RefAlbum');
    if RefEditeur > -1 then
      SQL.Add('AND e.RefEditeur = ' + IntToStr(RefEditeur))
    else
      SQL.Add('');
    SQL.Add('');
    Open; Stats.NbAlbums := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Couleur = 0'; Open; Stats.NbAlbumsNB := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.VO = 1'; Open; Stats.NbAlbumsVO := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Stock = 1'; Open; Stats.NbAlbumsStock := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Dedicace = 1'; Open; Stats.NbAlbumsDedicace := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Offert = 1'; Open; Stats.NbAlbumsOffert := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Gratuit = 1'; Open; Stats.NbAlbumsGratuit := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE a.Integrale = 1'; Open; Stats.NbAlbumsIntegrale := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE a.HorsSerie = 1'; Open; Stats.NbAlbumsHorsSerie := Fields.AsInteger[0]; Close;

    SQL.Clear;
    SQL.Add('select count(distinct a.refserie) from albums a');
    if RefEditeur > -1 then
      SQL.Add('inner join editions e on e.refalbum = a.refalbum and e.RefEditeur=' + IntToStr(RefEditeur))
    else
      SQL.Add('');
    Open; Stats.NbSeries := Fields.AsInteger[0]; Close;
    SQL.Add('inner join Series s on a.RefSerie = s.RefSerie');
    SQL.Add('');
    SQL[3] := 'WHERE s.Terminee = 1'; Open; Stats.NbSeriesTerminee := Fields.AsInteger[0]; Close;

    SQL.Text := 'SELECT Min(a.AnneeParution) AS MinAnnee, Max(a.AnneeParution) AS MaxAnnee FROM Albums a';
    if RefEditeur > -1 then SQL.Add('INNER JOIN Editions e ON e.refalbum = a.refalbum and e.RefEditeur=' + IntToStr(RefEditeur));
    Open;
    Stats.MinAnnee := 0;
    Stats.MaxAnnee := 0;
    if not EOF then begin
      Stats.MinAnnee := Fields.ByNameAsInteger['MinAnnee'];
      Stats.MaxAnnee := Fields.ByNameAsInteger['MaxAnnee'];
    end;

    Close;
    SQL.Text := 'SELECT COUNT(g.RefGenre) AS QuantiteGenre, g.RefGenre, g.Genre, g.UpperGenre FROM GenreSeries gs INNER JOIN Genres g ON gs.RefGenre = g.RefGenre';
    if RefEditeur > -1 then begin
      SQL.Add('INNER JOIN Albums a ON a.RefSerie = gs.RefSerie');
      SQL.Add('INNER JOIN Editions e ON e.refalbum = a.refalbum and e.RefEditeur=' + IntToStr(RefEditeur));
    end;
    SQL.Add('GROUP BY g.Genre, g.RefGenre, g.UpperGenre ORDER BY 1 desc, g.UpperGenre');
    Open;
    while not (EOF) do begin
      Stats.ListGenre.Add(TGenre.Make(Q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT Sum(Prix) AS SumPrix, COUNT(Prix) AS CountPrix, Min(Prix) AS MinPrix, Max(Prix) AS MaxPrix FROM Editions';
    if RefEditeur > -1 then SQL.Add('WHERE RefEditeur = ' + IntToStr(RefEditeur));
    Open;
    Stats.ValeurConnue := Fields.ByNameAsCurrency['SumPrix'];
    Stats.PrixAlbumMoyen := 0;
    Stats.PrixAlbumMinimun := 0;
    Stats.PrixAlbumMaximun := 0;
    if not EOF and Fields.ByNameAsBoolean['CountPrix'] then begin
      Stats.PrixAlbumMoyen := Fields.ByNameAsCurrency['SumPrix'] / Fields.ByNameAsInteger['CountPrix'];
      Stats.PrixAlbumMinimun := Fields.ByNameAsCurrency['MinPrix'];
      Stats.PrixAlbumMaximun := Fields.ByNameAsCurrency['MaxPrix'];
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(RefEdition) AS CountRef FROM Editions WHERE Prix IS NULL');
    if RefEditeur > -1 then SQL.Add('AND RefEditeur = ' + IntToStr(RefEditeur));
    Open;
    Stats.NbAlbumsSansPrix := 0;
    if not EOF then Stats.NbAlbumsSansPrix := Fields.ByNameAsInteger['countref'] - Stats.NbAlbumsGratuit;
    Stats.ValeurEstimee := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyen;

    Close;
    SQL.Text := 'SELECT COUNT(DISTINCT st.RefEmprunteur) FROM Statut st';
    if RefEditeur > -1 then SQL.Add('INNER JOIN Editions e ON e.RefEdition = st.RefEdition AND e.RefEditeur = ' + IntToStr(RefEditeur));
    Open;
    Stats.NbEmprunteurs := Fields.AsInteger[0];

    Close;
    SQL.Text := 'SELECT COUNT(st.RefEmprunteur)/' + IntToStr(Stats.NbEmprunteurs) + ' AS moy FROM Statut st';
    if RefEditeur > -1 then SQL.Add('INNER JOIN Editions e ON e.RefEdition = st.RefEdition AND e.RefEditeur = ' + IntToStr(RefEditeur));
    SQL.Add('WHERE st.PretEmprunt = 1');
    Stats.MoyEmprunteurs := 0;
    if Bool(Stats.NbEmprunteurs) then begin
      Open;
      Stats.MoyEmprunteurs := Fields.ByNameAsInteger['moy'];
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(e.RefEmprunteur) AS CountNumero, e.NomEmprunteur, e.RefEmprunteur');
    SQL.Add('FROM Statut st INNER JOIN Emprunteurs e ON e.RefEmprunteur = st.RefEmprunteur');
    if RefEditeur > -1 then SQL.Add('INNER JOIN Editions ed ON ed.RefEdition = st.RefEdition AND ed.RefEditeur = ' + IntToStr(RefEditeur));
    SQL.Add('WHERE (st.PretEmprunt = 1)');
    SQL.Add('GROUP BY e.RefEmprunteur, e.NomEmprunteur');
    SQL.Add('ORDER BY 1 DESC, e.NomEmprunteur DESC');
    Open;
    Stats.MinEmprunteurs := 0;
    Stats.MaxEmprunteurs := 0;
    if not EOF then begin
      Stats.MaxEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
      while not Eof do
        Next; // Last;
      Stats.MinEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
      if Stats.MinEmprunteurs = Stats.MaxEmprunteurs then Stats.MinEmprunteurs := 0;
      Close;
      Open;
      repeat
        if Fields.ByNameAsInteger['CountNumero'] in [Stats.MinEmprunteurs, Stats.MaxEmprunteurs] then begin
          if Fields.ByNameAsInteger['CountNumero'] = Stats.MinEmprunteurs then
            Stats.ListEmprunteursMin.Insert(0, TEmprunteur.Make(Q))
          else
            Stats.ListEmprunteursMax.Insert(0, TEmprunteur.Make(Q));
        end;
        Next;
      until EOF;
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(DISTINCT st.RefEdition) FROM Statut st');
    if RefEditeur > -1 then SQL.Add('INNER JOIN Editions e ON e.RefEdition = st.RefEdition AND e.RefEditeur = ' + IntToStr(RefEditeur));
    Open;
    Stats.NbEmpruntes := Fields.AsInteger[0];

    Close;
    SQL.Text := 'SELECT COUNT(st.RefEdition)/' + IntToStr(Stats.NbEmpruntes) + ' AS moy FROM Statut st';
    if RefEditeur > -1 then SQL.Add('INNER JOIN Editions e ON e.RefEdition = st.RefEdition AND e.RefEditeur = ' + IntToStr(RefEditeur));
    SQL.Add('WHERE st.PretEmprunt = 1');
    Stats.MoyEmpruntes := 0;
    if Bool(Stats.NbEmpruntes) then begin
      Open;
      Stats.MoyEmpruntes := Fields.ByNameAsInteger['moy'];
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT distinct count(refedition) FROM VW_EMPRUNTS WHERE (PretEmprunt = 1)');
    if RefEditeur > -1 then SQL.Add('AND RefEditeur = ' + IntToStr(RefEditeur));
    SQL.Add('group by refedition');
    SQL.Add('ORDER BY 1');
    Open;
    Stats.MinEmpruntes := 0;
    Stats.MaxEmpruntes := 0;
    if not EOF then begin
      Stats.MaxEmpruntes := Fields.AsInteger[0];
      while not Eof do
        Next; // Last;
      Stats.MinEmpruntes := Fields.AsInteger[0];
      if Stats.MinEmpruntes = Stats.MaxEmpruntes then Stats.MinEmpruntes := 0;

      Close;
      SQL.Clear;
      SQL.Add('SELECT *');
      SQL.Add('FROM VW_EMPRUNTS');
      SQL.Add('WHERE (PretEmprunt = 1)');
      if RefEditeur > -1 then SQL.Add('AND RefEditeur = ' + IntToStr(RefEditeur));
      SQL.Add('AND RefEdition in (SELECT RefEdition FROM STATUT WHERE PretEmprunt = 1 GROUP BY RefEdition HAVING Count(RefEdition) = :CountEdition)');
      Params.AsInteger[0] := Stats.MaxEmpruntes;
      Open;
      while not Eof do begin
        Stats.ListAlbumsMax.Insert(0, TAlbum.Make(Q));
        Next;
      end;
      if (Stats.MinEmpruntes > 0) and (Stats.MinEmpruntes <> Stats.MaxEmpruntes) then begin
        Close;
        Params.AsInteger[0] := Stats.MinEmpruntes;
        Open;
        while not Eof do begin
          Stats.ListAlbumsMin.Insert(0, TAlbum.Make(Q));
          Next;
        end;
      end;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

destructor TStats.Destroy;
begin
  FreeAndNil(ListEmprunteursMax);
  FreeAndNil(ListEmprunteursMin);
  FreeAndNil(ListAlbumsMax);
  FreeAndNil(ListAlbumsMin);
  FreeAndNil(ListGenre);
  FreeAndNil(ListEditeurs);
  inherited;
end;

procedure TStats.Fill(Complete: Boolean);
var
  PS: TStats;
  q: TJvUIBQuery;
  hg: IHourGlass;
begin
  inherited Fill(-1);
  hg := THourGlass.Create;
  CreateStats(Self);
  if Complete then begin
    q := TJvUIBQuery.Create(nil);
    with q do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Close;
      SQL.Clear;
      SQL.Add('SELECT DISTINCT ed.RefEditeur, e.NomEditeur FROM Editions ed');
      SQL.Add('INNER JOIN Editeurs e ON ed.RefEditeur = e.RefEditeur');
      SQL.Add('ORDER BY e.UpperNomEditeur');
      Open;
      while not Eof do begin
        PS := TStats.Create;
        ListEditeurs.Add(PS);
        CreateStats(PS, Fields.AsInteger[0], Trim(Fields.AsString[1]));
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
  end;
end;

{ TEmpruntsComplet }

procedure TEmpruntsComplet.Clear;
begin
  inherited;
  NBEmprunts := 0;
  TEmprunt.VideListe(Emprunts);
end;

constructor TEmpruntsComplet.Create;
begin
  inherited;
  Emprunts := TList.Create;
end;

constructor TEmpruntsComplet.Create(Reference: Integer; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
begin
  Create;
  Fill(Reference, Source, Sens, Apres, Avant, EnCours, Stock);
end;

destructor TEmpruntsComplet.Destroy;
begin
  Emprunts.Free;
  inherited;
end;

procedure TEmpruntsComplet.Fill(Reference: Integer; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
var
  q: TJvUIBQuery;

  procedure MakeQuery;
  var
    i: Integer;
  begin
    q.SQL.Text := 'SELECT * FROM VW_EMPRUNTS';

    with TStringList.Create do try
      case Source of
        seAlbum: Add('RefEdition = ' + IntToStr(Reference));
        seEmprunteur: Add('RefEmprunteur = ' + IntToStr(Reference));
      end;
      if EnCours then Add('Prete = 1');
      case Sens of
        ssPret: Add('PretEmprunt = 1');
        ssRetour: Add('PretEmprunt = 0');
      end;
      if Apres >= 0 then Add('DateEmprunt >= :DateApres');
      if Avant >= 0 then Add('DateEmprunt <= :DateAvant');

      for i := 0 to Count - 1 do begin
        if i = 0 then
          q.SQL.Add('WHERE')
        else
          q.SQL.Add('and');
        q.SQL.Add(Strings[i]);
      end;
      q.SQL.Add('ORDER BY DateEmprunt DESC, RefEmprunt ASC'); // le dernier saisi a priorit� en cas de "m�me date"
    finally
      Free;
    end;
    if Apres >= 0 then q.Params.ByNameAsDateTime['DateApres'] := Apres;
    if Avant >= 0 then q.Params.ByNameAsDateTime['DateAvant'] := Avant;
  end;

var
  PE: TEmprunt;
  s: TStringList;
  Ref: string;
begin
  inherited Fill(-1);
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    s := TStringList.Create;
    Self.NBEmprunts := 0;
    try
      MakeQuery;
      Open;
      s.Clear;
      while not Eof do begin
        Ref := Fields.ByNameAsString['RefEdition'];
        if not Stock or (s.IndexOf(Ref) = -1) then begin
          s.Add(Ref);
          PE := TEmprunt(TEmprunt.Make(q));
          if PE.Pret then Inc(Self.NBEmprunts);
          Self.Emprunts.Add(PE);
        end;
        Next;
      end;
    finally
      s.Free;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

{ TSeriesIncompletes }

procedure TSeriesIncompletes.Clear;
begin
  inherited;
  Series.Clear;
end;

constructor TSeriesIncompletes.Create;
begin
  inherited;
  Series := TObjectList.Create(True);
end;

constructor TSeriesIncompletes.Create(AvecIntegrales, AvecAchats: Boolean);
begin
  Create;
  Fill(AvecIntegrales, AvecAchats, -1);
end;

destructor TSeriesIncompletes.Destroy;
begin

  inherited;
end;

procedure TSeriesIncompletes.Fill(AvecIntegrales, AvecAchats: Boolean; RefSerie: Integer);
var
  q: TJvUIBQuery;
  dummy: Integer;
  CurrentSerie, FirstTome, CurrentTome: Integer;

  procedure UpdateSerie;
  var
    i: Integer;
  begin
    with TSerieIncomplete(Self.Series[Pred(Self.Series.Count)]) do
      if CurrentTome > FirstTome + 1 then
        NumerosManquants.Add(Format('%d<>%d', [FirstTome, CurrentTome]))
      else
        for i := FirstTome to CurrentTome do
          NumerosManquants.Add(IntToStr(i));
  end;

var
  Incomplete: TSerieIncomplete;
begin
  inherited Fill(-1);
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM Albums_MANQUANTS(:WithIntegrales, :WithAchats, :RefSerie) order by UPPERTITRESERIE, TOME';
    Params.AsBoolean[0] := AvecIntegrales;
    Params.AsBoolean[1] := AvecAchats;
    if RefSerie > -1 then
      Params.AsInteger[2] := RefSerie;
    Open;
    CurrentSerie := -1;
    FirstTome := -1;
    CurrentTome := -1;
    while not Eof do begin
      dummy := Fields.ByNameAsInteger['RefSerie'];
      if (dummy <> CurrentSerie) then begin
        if (CurrentSerie <> -1) then UpdateSerie;
        Incomplete := TSerieIncomplete.Create;
        Self.Series.Add(Incomplete);
        Incomplete.Serie.Fill(q);
        CurrentSerie := dummy;
        FirstTome := Fields.ByNameAsInteger['TOME'];
        CurrentTome := FirstTome;
      end
      else begin
        dummy := Fields.ByNameAsInteger['TOME'];
        if dummy <> CurrentTome + 1 then begin
          UpdateSerie;
          FirstTome := dummy;
        end;
        CurrentTome := dummy;
      end;
      Next;
    end;
    if (CurrentSerie <> -1) then UpdateSerie;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TSeriesIncompletes.Fill(const Reference: Integer);
begin
  Fill(True, True, Reference);
end;

{ TPrevisionsSorties }

procedure TPrevisionsSorties.Clear;
begin
  inherited;
  AnneesPassees.Clear;
  AnneeEnCours.Clear;
  AnneesProchaines.Clear;
end;

constructor TPrevisionsSorties.Create;
begin
  inherited;
  AnneesPassees := TObjectList.Create(True);
  AnneeEnCours := TObjectList.Create(True);
  AnneesProchaines := TObjectList.Create(True);
end;

constructor TPrevisionsSorties.Create(AvecAchats: Boolean);
begin
  Create;
  Fill(AvecAchats);
end;

destructor TPrevisionsSorties.Destroy;
begin
  AnneesPassees.Free;
  AnneeEnCours.Free;
  AnneesProchaines.Free;
  inherited;
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean; RefSerie: Integer);
var
  q: TJvUIBQuery;
  Annee, CurrentAnnee: Integer;
  Prevision: TPrevisionSortie;
begin
  inherited Fill(-1);
  CurrentAnnee := YearOf(Now);
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM PREVISIONS_SORTIES(:WithAchats, :RefSerie) order by ANNEEPARUTION, CASE WHEN MOISPARUTION BETWEEN 1 AND 4 THEN 1 WHEN MOISPARUTION BETWEEN 5 AND 8 THEN 2 WHEN MOISPARUTION BETWEEN 9 AND 12 THEN 3 ELSE 0 END, UPPERTITRESERIE';
    Params.AsBoolean[0] := AvecAchats;
    if RefSerie > -1 then
      Params.AsInteger[1] := RefSerie;
    Open;
    while not Eof do begin
      Annee := Fields.ByNameAsInteger['ANNEEPARUTION'];
      Prevision := TPrevisionSortie.Create;
      Prevision.Serie.Fill(q);
      Prevision.Tome := Fields.ByNameAsInteger['TOME'];
      Prevision.Annee := Annee;
      Prevision.Mois := Fields.ByNameAsInteger['MOISPARUTION'];
      if Annee < CurrentAnnee then
        Self.AnneesPassees.Add(Prevision)
      else if Annee > CurrentAnnee then
        Self.AnneesProchaines.Add(Prevision)
      else
        Self.AnneeEnCours.Add(Prevision);
      Next;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TPrevisionsSorties.Fill(const Reference: Integer);
begin
  Fill(True, Reference);
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean);
begin
  Fill(AvecAchats, -1);
end;

{ TPrevisionSortie }

constructor TPrevisionSortie.Create;
begin
  Serie := TSerie.Create;
end;

destructor TPrevisionSortie.Destroy;
begin
  Serie.Free;
  inherited;
end;

function TPrevisionSortie.sAnnee: string;
begin
  Result := IntToStr(Annee);
  if Mois > 0 then
    Result := Choose(Mois - 1, ['d�but', 'd�but', 'd�but', 'd�but', 'mi', 'mi', 'mi', 'mi', 'fin', 'fin', 'fin', 'fin']) + ' ' + Result;
end;

{ TSerieIncomplete }

function TSerieIncomplete.ChaineAffichage: string;
var
  s: string;
  i: Integer;
begin
  Result := '';
  for i := 0 to NumerosManquants.Count - 1 do begin
    s := NumerosManquants[i];
    if Pos('<>', s) <> 0 then s := StringReplace(s, '<>', ' � ', []);
    AjoutString(Result, s, ', ');
  end;
end;

constructor TSerieIncomplete.Create;
begin
  NumerosManquants := TStringList.Create;
  Serie := TSerie.Create;
end;

destructor TSerieIncomplete.Destroy;
begin
  Serie.Free;
  NumerosManquants.Free;
  inherited;
end;

{ TAuteurComplet }

procedure TAuteurComplet.Clear;
begin
  inherited;
  Series.Clear;
end;

constructor TAuteurComplet.Create;
begin
  inherited;
  Series := TObjectList.Create(True);
  Biographie := TStringList.Create;
end;

destructor TAuteurComplet.Destroy;
begin
  FreeAndNil(Series);
  FreeAndNil(Biographie);
  inherited;
end;

procedure TAuteurComplet.Fill(const Reference: Integer);
var
  q: TJvUIBQuery;
begin
  inherited;
  if (Reference = 0) then Exit;
  Self.RefAuteur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE REFPERSONNE = ?';
    Params.AsInteger[0] := Reference;
    FetchBlobs := True;
    Open;
    Self.NomAuteur := Fields.ByNameAsString['NOMPERSONNE'];
    Self.Biographie.Text := Fields.ByNameAsString['BIOGRAPHIE'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
    FetchBlobs := False;

    SQL.Clear;
    // UpperTitreSerie en premier pour forcer l'union � trier sur le titre
    SQL.Add('SELECT UPPERTITRESERIE, s.REFSERIE');
    SQL.Add('FROM ALBUMS al');
    SQL.Add('  INNER JOIN AUTEURS au ON al.refalbum = au.refalbum AND au.refpersonne = :RefPersonne');
    SQL.Add('  INNER JOIN SERIES s ON s.refserie = al.refserie');
    SQL.Add('union');
    SQL.Add('SELECT UPPERTITRESERIE, s.REFSERIE');
    SQL.Add('FROM auteurs_series au');
    SQL.Add('  INNER JOIN SERIES s ON s.refserie = au.refserie AND au.refpersonne = :RefPersonne');
    Params.ByNameAsInteger['RefPersonne'] := Reference;
    Open;
    while not Eof do begin
      Series.Add(TSerieComplete.Create(Fields.AsInteger[1], Self.RefAuteur));
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

end.

