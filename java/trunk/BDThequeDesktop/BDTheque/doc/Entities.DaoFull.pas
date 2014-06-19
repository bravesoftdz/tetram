unit Entities.DaoFull;

interface

uses
  Entities.Full,
  // Entities.Common, Entities.DaoCommon, Entities.FactoriesCommon,
  Entities.Types;

type
  // ce serait trop facile si XE4 acceptait cette syntaxe....
  // TClassDaoComplet = class of TDaoComplet<>;
  // je suis donc obligé de faire des classes "classique"
  TDaoFullClass = class of TDaoFull;

  TDaoFull = class abstract(TDaoDBEntity)
  public
    class procedure SaveToDatabase(Entity: TObjetFull); overload;
    class procedure SaveToDatabase(Entity: TObjetFull; UseTransaction: TUIBTransaction); overload; virtual; abstract;

    class procedure FillAssociations(Entity: TObjetFull; TypeData: TVirtualMode);
    class procedure SaveAssociations(Entity: TObjetFull; TypeData: TVirtualMode; const ParentID: TGUID);
  end;

  TDaoFullEntity<T: TObjetFull> = class abstract(TDaoFull)
    class function getInstance: T; reintroduce; overload;
    class function getInstance(const Reference: TGUID): T; reintroduce; overload;

    class procedure Fill(Entity: TDBEntity; const Reference: TGUID); overload; override;
    class procedure Fill(Entity: T; const Reference: TGUID); reintroduce; overload; virtual;

    class procedure SaveToDatabase(Entity: TObjetFull; UseTransaction: TUIBTransaction); overload; override;
    class procedure SaveToDatabase(Entity: T; UseTransaction: TUIBTransaction); reintroduce; overload; virtual;
  end;

  TDaoAlbumFull = class(TDaoFullEntity<TAlbumFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAlbumFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TAlbumFull; UseTransaction: TUIBTransaction); override;
    class procedure Acheter(Entity: TAlbumFull; Prevision: Boolean);
    class procedure FusionneInto(Source, Dest: TAlbumFull);
  end;

  TDaoParaBDFull = class(TDaoFullEntity<TParaBDFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TParaBDFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TParaBDFull; UseTransaction: TUIBTransaction); override;
    class procedure Acheter(Entity: TParaBDFull; Prevision: Boolean);
  end;

  TDaoSerieFull = class(TDaoFullEntity<TSerieFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class constructor Create;
    class destructor Destroy;

    class function getInstance(const Reference, IdAuteurFiltre: TGUID): TSerieFull; reintroduce; overload;
    class function getInstance(const Reference, IdAuteurFiltre: TGUID; ForceLoad: Boolean): TSerieFull; reintroduce; overload;

    class procedure Fill(Entity: TSerieFull; const Reference: TGUID); overload; override;
    class procedure Fill(Entity: TSerieFull; const Reference, IdAuteurFiltre: TGUID); reintroduce; overload;
    class procedure Fill(Entity: TSerieFull; const Reference, IdAuteurFiltre: TGUID; ForceLoad: Boolean); reintroduce; overload;
    class procedure SaveToDatabase(Entity: TSerieFull; UseTransaction: TUIBTransaction); override;
  end;

  TDaoEditionFull = class(TDaoFullEntity<TEditionFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class constructor Create;
    class destructor Destroy;

    class procedure Fill(Entity: TEditionFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TEditionFull; UseTransaction: TUIBTransaction); override;
    class procedure FusionneInto(Source, Dest: TEditionFull); overload;
    class procedure FusionneInto(Source, Dest: TObjectList<TEditionFull>); overload;

    class function getList(const Reference: TGUID; Stock: Integer = -1): TObjectList<TEditionFull>;
    class procedure FillList(EntitiesList: TObjectList<TEditionFull>; const Reference: TGUID; Stock: Integer = -1);

    class procedure InitEdition(Entity: TEntity);
  end;

  TDaoEditeurFull = class(TDaoFullEntity<TEditeurFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TEditeurFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TEditeurFull; UseTransaction: TUIBTransaction); override;
  end;

  TDaoCollectionFull = class(TDaoFullEntity<TCollectionFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TCollectionFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TCollectionFull; UseTransaction: TUIBTransaction); override;
  end;

  TDaoAuteurFull = class(TDaoFullEntity<TAuteurFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TAuteurFull; UseTransaction: TUIBTransaction); override;
  end;

  TDaoUniversFull = class(TDaoFullEntity<TUniversFull>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TUniversFull; const Reference: TGUID); override;
    class procedure SaveToDatabase(Entity: TUniversFull; UseTransaction: TUIBTransaction); override;
  end;

implementation

uses
  Commun, UfrmConsole, Entities.DaoLite, Entities.Lite, Procedures,
  CommonConst, System.IOUtils, Vcl.Dialogs, UMetadata, UfrmFusionEditions,
  Vcl.Controls, ProceduresBDtk, Entities.FactoriesFull, Entities.FactoriesLite,
  Entities.DaoLambda, Entities.DBConnection;

{ TDaoAlbumFull }

class procedure TDaoAlbumFull.FusionneInto(Source, Dest: TAlbumFull);

  function NotInList(Auteur: TAuteurAlbumLite; List: TObjectList<TAuteurAlbumLite>): Boolean; inline; overload;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(List.Count)) do
    begin
      Result := not IsEqualGUID(List[i].Personne.ID, Auteur.Personne.ID);
      Inc(i);
    end;
  end;

  function NotInList(Univers: TUniversLite; List: TObjectList<TUniversLite>): Boolean; inline; overload;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(List.Count)) do
    begin
      Result := not IsEqualGUID(List[i].ID, Univers.ID);
      Inc(i);
    end;
  end;

var
  DefaultAlbum: TAlbumFull;
  Auteur: TAuteurAlbumLite;
  Univers: TUniversLite;
begin
  DefaultAlbum := TFactoryAlbumFull.getInstance;
  try
    // Album
    if not SameText(Source.TitreAlbum, DefaultAlbum.TitreAlbum) then
      Dest.TitreAlbum := Source.TitreAlbum;
    if Source.MoisParution <> DefaultAlbum.MoisParution then
      Dest.MoisParution := Source.MoisParution;
    if Source.AnneeParution <> DefaultAlbum.AnneeParution then
      Dest.AnneeParution := Source.AnneeParution;
    if Source.Tome <> DefaultAlbum.Tome then
      Dest.Tome := Source.Tome;
    if Source.TomeDebut <> DefaultAlbum.TomeDebut then
      Dest.TomeDebut := Source.TomeDebut;
    if Source.TomeFin <> DefaultAlbum.TomeFin then
      Dest.TomeFin := Source.TomeFin;
    if Source.HorsSerie <> DefaultAlbum.HorsSerie then
      Dest.HorsSerie := Source.HorsSerie;
    if Source.Integrale <> DefaultAlbum.Integrale then
      Dest.Integrale := Source.Integrale;

    for Auteur in Source.Scenaristes do
      if NotInList(Auteur, Dest.Scenaristes) then
        Dest.Scenaristes.Add(TFactoryAuteurAlbumLite.Duplicate(Auteur));
    for Auteur in Source.Dessinateurs do
      if NotInList(Auteur, Dest.Dessinateurs) then
        Dest.Dessinateurs.Add(TFactoryAuteurAlbumLite.Duplicate(Auteur));
    for Auteur in Source.Coloristes do
      if NotInList(Auteur, Dest.Coloristes) then
        Dest.Coloristes.Add(TFactoryAuteurAlbumLite.Duplicate(Auteur));

    if not SameText(Source.Sujet, DefaultAlbum.Sujet) then
      Dest.Sujet := Source.Sujet;
    if not SameText(Source.Notes, DefaultAlbum.Notes) then
      Dest.Notes := Source.Notes;

    // Série
    if not IsEqualGUID(Source.ID_Serie, DefaultAlbum.ID_Serie) and not IsEqualGUID(Source.ID_Serie, Dest.ID_Serie) then
      TDaoSerieFull.Fill(Dest.Serie, Source.ID_Serie);

    // Univers
    for Univers in Source.Univers do
      if NotInList(Univers, Dest.Univers) then
        Dest.Univers.Add(TFactoryUniversLite.Duplicate(Univers));

    if Source.FusionneEditions then
      TDaoEditionFull.FusionneInto(Source.Editions, Dest.Editions);
  finally
    DefaultAlbum.Free;
  end;
end;

{ TDaoEditionFull }

class procedure TDaoEditionFull.FusionneInto(Source, Dest: TObjectList<TEditionFull>);
type
  OptionFusion = record
    ImporterImages: Boolean;
    RemplacerImages: Boolean;
  end;
var
  FusionsEditions: array of TEditionFull;
  OptionsFusion: array of OptionFusion;
  Edition: TEditionFull;
  i: Integer;
  frm: TfrmFusionEditions;
begin
  if Source.Count = 0 then
    Exit;

  SetLength(FusionsEditions, Source.Count);
  ZeroMemory(FusionsEditions, Length(FusionsEditions) * SizeOf(TEditionFull));
  SetLength(OptionsFusion, Source.Count);
  ZeroMemory(OptionsFusion, Length(OptionsFusion) * SizeOf(OptionFusion));
  // même si la destination n'a aucune données, on peut choisir de ne rien y importer
  // if Dest.Editions.Count > 0 then
  for i := 0 to Pred(Source.Count) do
  begin
    frm := TfrmFusionEditions.Create(nil);
    try
      frm.SetEditionSrc(Source[i]);
      // SetEditions doit être fait après SetEditionSrc
      frm.SetEditions(Dest, FusionsEditions);

      case frm.ShowModal of
        mrCancel:
          FusionsEditions[i] := nil;
        mrOk:
          if frm.CheckBox1.Checked then
          begin
            FusionsEditions[i] := TFactoryEditionFull.getInstance;
            Dest.Add(FusionsEditions[i]);
          end
          else
            FusionsEditions[i] := TEditionFull(frm.lbEditions.Items.Objects[frm.lbEditions.ItemIndex]);
      end;
      OptionsFusion[i].ImporterImages := frm.CheckBox2.Checked and (Source[i].Couvertures.Count > 0);
      OptionsFusion[i].RemplacerImages := frm.CheckBox3.Checked and OptionsFusion[i].ImporterImages;
    finally
      frm.Free;
    end;
  end;

  for i := 0 to Pred(Source.Count) do
  begin
    Edition := FusionsEditions[i];
    if Assigned(Edition) then
    begin
      if not OptionsFusion[i].ImporterImages then
        Source[i].Couvertures.Clear
      else if OptionsFusion[i].RemplacerImages then
        Edition.Couvertures.Clear;

      FusionneInto(Source[i], Edition);
    end;
  end;
end;

class procedure TDaoEditionFull.FusionneInto(Source, Dest: TEditionFull);
var
  DefaultEdition: TEditionFull;
  Couverture: TCouvertureLite;
begin
  DefaultEdition := TFactoryEditionFull.getInstance;
  try
    if not IsEqualGUID(Source.Editeur.ID_Editeur, DefaultEdition.Editeur.ID_Editeur) and not IsEqualGUID(Source.Editeur.ID_Editeur, Dest.Editeur.ID_Editeur)
    then
      TDaoEditeurFull.Fill(Dest.Editeur, Source.Editeur.ID_Editeur);
    if not IsEqualGUID(Source.Collection.ID, DefaultEdition.Collection.ID) and not IsEqualGUID(Source.Collection.ID, Dest.Collection.ID) then
      TDaoCollectionLite.Fill(Dest.Collection, Source.Collection.ID);

    if Source.TypeEdition.Value <> DefaultEdition.TypeEdition.Value then
      Dest.TypeEdition := Source.TypeEdition;
    if Source.Etat.Value <> DefaultEdition.Etat.Value then
      Dest.Etat := Source.Etat;
    if Source.Reliure.Value <> DefaultEdition.Reliure.Value then
      Dest.Reliure := Source.Reliure;
    if Source.FormatEdition.Value <> DefaultEdition.FormatEdition.Value then
      Dest.FormatEdition := Source.FormatEdition;
    if Source.Orientation.Value <> DefaultEdition.Orientation.Value then
      Dest.Orientation := Source.Orientation;
    if Source.SensLecture.Value <> DefaultEdition.SensLecture.Value then
      Dest.SensLecture := Source.SensLecture;

    if Source.AnneeEdition <> DefaultEdition.AnneeEdition then
      Dest.AnneeEdition := Source.AnneeEdition;
    if Source.NombreDePages <> DefaultEdition.NombreDePages then
      Dest.NombreDePages := Source.NombreDePages;
    if Source.AnneeCote <> DefaultEdition.AnneeCote then
      Dest.AnneeCote := Source.AnneeCote;
    if Source.Prix <> DefaultEdition.Prix then
      Dest.Prix := Source.Prix;
    if Source.PrixCote <> DefaultEdition.PrixCote then
      Dest.PrixCote := Source.PrixCote;
    if Source.Couleur <> DefaultEdition.Couleur then
      Dest.Couleur := Source.Couleur;
    if Source.VO <> DefaultEdition.VO then
      Dest.VO := Source.VO;
    if Source.Dedicace <> DefaultEdition.Dedicace then
      Dest.Dedicace := Source.Dedicace;
    if Source.Stock <> DefaultEdition.Stock then
      Dest.Stock := Source.Stock;
    if Source.Prete <> DefaultEdition.Prete then
      Dest.Prete := Source.Prete;
    if Source.Offert <> DefaultEdition.Offert then
      Dest.Offert := Source.Offert;
    if Source.Gratuit <> DefaultEdition.Gratuit then
      Dest.Gratuit := Source.Gratuit;
    if Source.ISBN <> DefaultEdition.ISBN then
      Dest.ISBN := Source.ISBN;
    if Source.DateAchat <> DefaultEdition.DateAchat then
      Dest.DateAchat := Source.DateAchat;
    if not SameText(Source.Notes, DefaultEdition.Notes) then
      Dest.Notes := Source.Notes;
    if Source.NumeroPerso <> DefaultEdition.NumeroPerso then
      Dest.NumeroPerso := Source.NumeroPerso;

    for Couverture in Source.Couvertures do
      Dest.Couvertures.Add(TFactoryCouvertureLite.Duplicate(Couverture));
  finally
    DefaultEdition.Free;
  end;
end;

class function TDaoEditionFull.getList(const Reference: TGUID; Stock: Integer): TObjectList<TEditionFull>;
begin
  Result := TObjectList<TEditionFull>.Create;
  FillList(Result, Reference, Stock);
end;

{ TDaoSerieFull }

class procedure TDaoSerieFull.Fill(Entity: TSerieFull; const Reference: TGUID);
begin
  Fill(Entity, Reference, GUID_NULL, False);
end;

class procedure TDaoSerieFull.Fill(Entity: TSerieFull; const Reference, IdAuteurFiltre: TGUID);
begin
  Fill(Entity, Reference, IdAuteurFiltre, False);
end;

class procedure TDaoSerieFull.Fill(Entity: TSerieFull; const Reference, IdAuteurFiltre: TGUID; ForceLoad: Boolean);
var
  qry: TUIBQuery;
begin
  inherited Fill(Entity, Reference);
  if IsEqualGUID(Reference, GUID_NULL) and (not ForceLoad) then
    Exit;
  Entity.ID_Serie := Reference;
  qry := DBConnection.GetQuery;
  try
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select');
    qry.SQL.Add('  id_parabd, titreparabd, id_serie, titreserie, achat, complet, scategorie');
    qry.SQL.Add('from');
    qry.SQL.Add('  vw_liste_parabd');
    qry.SQL.Add('where');
    if IsEqualGUID(Reference, GUID_NULL) then
      qry.SQL.Add('  (id_serie is null or id_serie = ?)')
    else
      qry.SQL.Add('  id_serie = ?');
    if not IsEqualGUID(IdAuteurFiltre, GUID_NULL) then
      qry.SQL.Add('and id_parabd in (select id_parabd from auteurs_parabd where id_personne = ?)');
    qry.SQL.Add('order by');
    qry.SQL.Add('  titreparabd');
qry.Params.AsString[0] := GUIDToString(Reference);
    if not IsEqualGUID(IdAuteurFiltre, GUID_NULL) then
      qry.Params.AsString[1] := GUIDToString(IdAuteurFiltre);
    qry.Open;
    TDaoParaBDLite.FillList(Entity.ParaBD, qry);
  finally
    qry.Free;
  end;
end;

class function TDaoSerieFull.getInstance(const Reference, IdAuteurFiltre: TGUID): TSerieFull;
begin
  Result := TFactorySerieFull.getInstance;
  Fill(Result, Reference, IdAuteurFiltre);
end;

class function TDaoSerieFull.getInstance(const Reference, IdAuteurFiltre: TGUID; ForceLoad: Boolean): TSerieFull;
begin
  Result := TFactorySerieFull.getInstance;
  Fill(Result, Reference, IdAuteurFiltre, ForceLoad);
end;

end.
