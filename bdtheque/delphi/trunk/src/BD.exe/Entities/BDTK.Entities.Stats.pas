unit BDTK.Entities.Stats;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, BD.Entities.Lite, BD.Entities.Common;

type
  TStats = class(TEntity)
  strict private
    FNbAlbumsGratuit: Integer;
    FNbAlbumsNB: Integer;
    FPrixAlbumMaximun: Currency;
    FPrixAlbumMoyenMoyenne: Currency;
    FPrixAlbumMoyenMediane: Currency;
    FValeurConnue: Currency;
    FNbAlbumsIntegrale: Integer;
    FMaxAnnee: Integer;
    FNbAlbumsDedicace: Integer;
    FListAlbumsMax: TObjectList<TAlbumLite>;
    FNbSeries: Integer;
    FListEditeurs: TObjectList<TStats>;
    FPrixAlbumMinimun: Currency;
    FValeurEstimeeMoyenne: Currency;
    FValeurEstimeeMediane: Currency;
    FValeurEstimeeRegression: Currency;
    FMinAnnee: Integer;
    FNbAlbumsOffert: Integer;
    FNbSeriesTerminee: Integer;
    FListAlbumsMin: TObjectList<TAlbumLite>;
    FNbAlbumsVO: Integer;
    FNbAlbumsSansPrix: Integer;
    FNbAlbums: Integer;
    FNbAlbumsHorsSerie: Integer;
    FNbAlbumsStock: Integer;
    FEditeur: string;
    FListGenre: TObjectList<TGenreLite>;
  strict private
    procedure CreateStats(Stats: TStats); overload;
    procedure CreateStats(Stats: TStats; const ID_Editeur: TGUID; const Editeur: string); overload;
    function EstimationAlbumsSansPrixParRegression: Currency;
  public
    constructor Create; override;
    class function BuildStats(Complete: Boolean): TStats;
    destructor Destroy; override;
    procedure Fill(Complete: Boolean);
    procedure ResetInstance; override;
  published
    property Editeur: string read FEditeur;
    property NbAlbums: Integer read FNbAlbums;
    property NbSeries: Integer read FNbSeries;
    property NbSeriesTerminee: Integer read FNbSeriesTerminee;
    property NbAlbumsNB: Integer read FNbAlbumsNB;
    property NbAlbumsVO: Integer read FNbAlbumsVO;
    property NbAlbumsStock: Integer read FNbAlbumsStock;
    property NbAlbumsIntegrale: Integer read FNbAlbumsIntegrale;
    property NbAlbumsHorsSerie: Integer read FNbAlbumsHorsSerie;
    property NbAlbumsDedicace: Integer read FNbAlbumsDedicace;
    property NbAlbumsOffert: Integer read FNbAlbumsOffert;
    property NbAlbumsGratuit: Integer read FNbAlbumsGratuit;
    property MinAnnee: Integer read FMinAnnee;
    property MaxAnnee: Integer read FMaxAnnee;
    property NbAlbumsSansPrix: Integer read FNbAlbumsSansPrix;
    property ValeurConnue: Currency read FValeurConnue;
    property ValeurEstimeeMoyenne: Currency read FValeurEstimeeMoyenne;
    property ValeurEstimeeMediane: Currency read FValeurEstimeeMediane;
    property ValeurEstimeeRegression: Currency read FValeurEstimeeRegression;
    property PrixAlbumMinimun: Currency read FPrixAlbumMinimun;
    property PrixAlbumMoyenMoyenne: Currency read FPrixAlbumMoyenMoyenne;
    property PrixAlbumMoyenMediane: Currency read FPrixAlbumMoyenMediane;
    property PrixAlbumMaximun: Currency read FPrixAlbumMaximun;
    property ListAlbumsMin: TObjectList<TAlbumLite> read FListAlbumsMin;
    property ListAlbumsMax: TObjectList<TAlbumLite> read FListAlbumsMax;
    property ListGenre: TObjectList<TGenreLite> read FListGenre;
    property ListEditeurs: TObjectList<TStats> read FListEditeurs;
  end;

  TSerieIncomplete = class(TEntity)
  strict private
    FSerie: TSerieLite;
    FNumerosManquants: TStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ChaineAffichage: string;
  published
    property Serie: TSerieLite read FSerie;
    property NumerosManquants: TStringList read FNumerosManquants;
  end;

  TSeriesIncompletes = class(TEntity)
  strict private
    FSeries: TObjectList<TSerieIncomplete>;
  public
    constructor Create(AvecIntegrales, AvecAchats: Boolean); reintroduce; overload;
    constructor Create(const ID_Serie: TGUID); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); overload;
    procedure Fill(AvecIntegrales, AvecAchats: Boolean; const ID_Serie: TGUID); overload;
    procedure ResetInstance; override;
  published
    property Series: TObjectList<TSerieIncomplete> read FSeries;
  end;

  TPrevisionSortie = class(TEntity)
  strict private
    FMois: Integer;
    FAnnee: Integer;
    FSerie: TSerieLite;
    FTome: Integer;
    function GetsAnnee: string; inline;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Serie: TSerieLite read FSerie;
    property Tome: Integer read FTome write FTome;
    property Annee: Integer read FAnnee write FAnnee;
    property Mois: Integer read FMois write FMois;
    property sAnnee: string read GetsAnnee;
  end;

  TPrevisionsSorties = class(TEntity)
  strict private
    FAnneesPassees: TObjectList<TPrevisionSortie>;
    FAnneesProchaines: TObjectList<TPrevisionSortie>;
    FAnneeEnCours: TObjectList<TPrevisionSortie>;
  public
    constructor Create(AvecAchats: Boolean); reintroduce; overload;
    constructor Create(const ID_Serie: TGUID); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); overload;
    procedure Fill(AvecAchats: Boolean); overload;
    procedure Fill(AvecAchats: Boolean; const ID_Serie: TGUID); overload;
    procedure ResetInstance; override;
  published
    property AnneesPassees: TObjectList<TPrevisionSortie> read FAnneesPassees;
    property AnneeEnCours: TObjectList<TPrevisionSortie> read FAnneeEnCours;
    property AnneesProchaines: TObjectList<TPrevisionSortie> read FAnneesProchaines;
  end;

implementation

uses
  BD.Utils.StrUtils, BD.Utils.GUIUtils, uib, BDTK.GUI.DataModules.Main, System.DateUtils, Divers, BDTK.Entities.Dao.Lite,
  BD.Entities.Factory.Lite, BD.DB.Connection, System.Math,
  xalglib, BD.Utils.RandomForest.Classes;

{ TStats }

class function TStats.BuildStats(Complete: Boolean): TStats;
begin
  Result := Create;
  Result.Fill(Complete);
end;

constructor TStats.Create;
begin
  inherited;
  FListAlbumsMax := TObjectList<TAlbumLite>.Create;
  FListAlbumsMin := TObjectList<TAlbumLite>.Create;
  FListGenre := TObjectList<TGenreLite>.Create;
  FListEditeurs := TObjectList<TStats>.Create;
end;

destructor TStats.Destroy;
begin
  FListAlbumsMax.Free;
  FListAlbumsMin.Free;
  FListGenre.Free;
  FListEditeurs.Free;
  inherited;
end;

procedure TStats.ResetInstance;
begin
  inherited;
  ListAlbumsMax.Clear;
  ListAlbumsMin.Clear;
  ListGenre.Clear;
  ListEditeurs.Clear;
end;

procedure TStats.CreateStats(Stats: TStats);
begin
  CreateStats(Stats, GUID_NULL, '');
end;

procedure TStats.CreateStats(Stats: TStats; const ID_Editeur: TGUID; const Editeur: string);
var
  q: TManagedQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Stats.FEditeur := Editeur;
  q := dmPrinc.DBConnection.GetQuery;
  try
    q.SQL.Add('select count(a.id_album) from albums a inner join editions e on a.id_album = e.id_album');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      q.SQL.Add('and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)))
    else
      q.SQL.Add('');
    q.SQL.Add('');
    q.Open;
    Stats.FNbAlbums := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where e.couleur = 0';
    q.Open;
    Stats.FNbAlbumsNB := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where e.vo = 1';
    q.Open;
    Stats.FNbAlbumsVO := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where e.stock = 1';
    q.Open;
    Stats.FNbAlbumsStock := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where e.dedicace = 1';
    q.Open;
    Stats.FNbAlbumsDedicace := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where e.offert = 1';
    q.Open;
    Stats.FNbAlbumsOffert := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where e.gratuit = 1';
    q.Open;
    Stats.FNbAlbumsGratuit := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where a.integrale = 1';
    q.Open;
    Stats.FNbAlbumsIntegrale := q.Fields.AsInteger[0];
    q.Close;

    q.SQL[2] := 'where a.horsserie = 1';
    q.Open;
    Stats.FNbAlbumsHorsSerie := q.Fields.AsInteger[0];
    q.Close;

    q.SQL.Clear;
    q.SQL.Add('select count(distinct a.id_serie) from albums a');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      q.SQL.Add('inner join editions e on e.id_album = a.id_album and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)))
    else
      q.SQL.Add('');
    q.Open;
    Stats.FNbSeries := q.Fields.AsInteger[0];
    q.Close;

    q.SQL.Add('left join series s on a.id_serie = s.id_serie');
    q.SQL.Add('');
    q.SQL[3] := 'where s.terminee = 1';
    q.Open;
    Stats.FNbSeriesTerminee := q.Fields.AsInteger[0];
    q.Close;

    q.SQL.Text := 'select min(a.anneeparution) as minannee, max(a.anneeparution) as maxannee from albums a';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      q.SQL.Add('inner join editions e on e.id_album = a.id_album and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
    q.Open;
    Stats.FMinAnnee := 0;
    Stats.FMaxAnnee := 0;
    if not q.Eof then
    begin
      Stats.FMinAnnee := q.Fields.ByNameAsInteger['minannee'];
      Stats.FMaxAnnee := q.Fields.ByNameAsInteger['maxannee'];
    end;

    q.Close;
    q.SQL.Clear;
    q.SQL.Add('select');
    q.SQL.Add('  count(g.id_genre) as quantitegenre, g.id_genre, g.genre');
    q.SQL.Add('from');
    q.SQL.Add('  genreseries gs');
    q.SQL.Add('  inner join genres g on');
    q.SQL.Add('    gs.id_genre = g.id_genre');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
    begin
      q.SQL.Add('  inner join albums a on');
      q.SQL.Add('    a.id_serie = gs.id_serie');
      q.SQL.Add('  inner join editions e on');
      q.SQL.Add('    e.id_album = a.id_album');
      q.SQL.Add('    and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
    end;
    q.SQL.Add('group by');
    q.SQL.Add('  g.genre, g.id_genre');
    q.SQL.Add('order by');
    q.SQL.Add('  1 desc');
    q.Open;
    TDaoGenreLite.FillList(Stats.ListGenre, q);

    q.Close;
    q.SQL.Clear;
    q.SQL.Add('select');
    q.SQL.Add('  sum(prix) as sumprix, count(prix) as countprix, min(prix) as minprix, max(prix) as maxprix');
    q.SQL.Add('from');
    q.SQL.Add('  editions');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      q.SQL.Add('where id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    q.Open;
    Stats.FValeurConnue := q.Fields.ByNameAsCurrency['sumprix'];
    Stats.FPrixAlbumMoyenMoyenne := 0;
    Stats.FPrixAlbumMoyenMediane := 0;
    Stats.FPrixAlbumMinimun := 0;
    Stats.FPrixAlbumMaximun := 0;
    if not q.Eof and q.Fields.ByNameAsBoolean['countprix'] then
    begin
      Stats.FPrixAlbumMoyenMoyenne := q.Fields.ByNameAsCurrency['sumprix'] / q.Fields.ByNameAsInteger['countprix'];
      Stats.FPrixAlbumMinimun := q.Fields.ByNameAsCurrency['minprix'];
      Stats.FPrixAlbumMaximun := q.Fields.ByNameAsCurrency['maxprix'];
    end;

    q.Close;
    q.SQL.Clear;
    q.SQL.Add('select');
    q.SQL.Add('  count(id_edition) as countref');
    q.SQL.Add('from');
    q.SQL.Add('  editions');
    q.SQL.Add('where');
    q.SQL.Add('  prix is null');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      q.SQL.Add('  and id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    q.Open;
    Stats.FNbAlbumsSansPrix := 0;
    if not q.Eof then
      Stats.FNbAlbumsSansPrix := q.Fields.ByNameAsInteger['countref'] - Stats.NbAlbumsGratuit;

    Stats.FValeurEstimeeRegression := Stats.ValeurConnue + Stats.EstimationAlbumsSansPrixParRegression; // calcule aussi la médiane

    Stats.FValeurEstimeeMoyenne := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyenMoyenne;
    Stats.FValeurEstimeeMediane := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyenMediane;
  finally
    q.Free;
  end;
end;

function TStats.EstimationAlbumsSansPrixParRegression: Currency;

  function Percentile(const Valeurs: TVector; APercentile: Double): Currency;
  var
    p: Double;
  begin
    if not InRange(APercentile, 0, 1) then
      Exit(NAN);

    p := Length(Valeurs) * APercentile;
    if IsZero(Frac(p)) then
      Result := Valeurs[Trunc(p)]
    else
      Result := (Valeurs[Trunc(p)] + Valeurs[Ceil(p)]) / 2;
  end;

var
  q: TManagedQuery;
  Prix: TVector;
  PrixCount: Integer;
  Quartile25, Quartile75, ExtremeMin, ExtremeMax: Currency;

  TrainingSet, EvaluationSet: TArray<TArray<Variant>>;
  TrainingSetCount, EvaluationSetCount: Integer;
  Ligne: ^TArray<Variant>;
  i: Integer;
  RFData: TRFData;
  builder: Tdecisionforestbuilder;
  data: TMatrix;
  forest: Tdecisionforest;
  rep: Tdfreport;
begin
  Result := 0;
  FPrixAlbumMoyenMediane := 0;

  data := nil;

  try
    q := dmPrinc.DBConnection.GetQuery;
    try
      q.SQL.Add('select');
      q.SQL.Add('  e.prix'); // prix doit être le dernier champ des set
      q.SQL.Add('from');
      q.SQL.Add('  editions e');
      q.SQL.Add('  inner join albums a on');
      q.SQL.Add('    e.id_album = a.id_album');
      q.SQL.Add('where');
      q.SQL.Add('  e.prix is not null');
      q.SQL.Add('order by');
      q.SQL.Add('  e.prix'); // /!\ important

      try
        SetLength(Prix, NbAlbums);
        PrixCount := 0;
        q.Open;
        while not q.Eof do
        begin
          Prix[PrixCount] := q.Fields.AsCurrency[q.Fields.FieldCount - 1];
          Inc(PrixCount);
          q.Next;
        end;
        SetLength(Prix, PrixCount);

        Quartile25 := Percentile(Prix, 0.25);
        Quartile75 := Percentile(Prix, 0.75);
        ExtremeMin := Quartile25 - (Quartile75 - Quartile25) * 1.5;
        ExtremeMax := Quartile75 + (Quartile75 - Quartile25) * 1.5;

        FPrixAlbumMoyenMediane := Percentile(Prix, 0.50);
      finally
        Prix := nil;
      end;

      q.SQL.Clear;
      q.SQL.Add('select');
      q.SQL.Add('  e.anneeedition, e.vo, e.couleur, e.etat, e.reliure, e.typeedition, e.dateachat, e.nombredepages, e.orientation, e.formatedition, e.senslecture,');
      q.SQL.Add('  a.moisparution, a.anneeparution, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale,');
      q.SQL.Add('  e.prix'); // prix doit être le dernier champ des set
      q.SQL.Add('from');
      q.SQL.Add('  editions e');
      q.SQL.Add('  inner join albums a on');
      q.SQL.Add('    e.id_album = a.id_album');
      q.SQL.Add('where');
      q.SQL.Add('  e.prix is null or e.prix between :extrememin and :extrememax');
      q.Params.AsCurrency[0] := ExtremeMin;
      q.Params.AsCurrency[1] := ExtremeMax;

      SetLength(TrainingSet, NbAlbums);
      TrainingSetCount := 0;
      SetLength(EvaluationSet, NbAlbums);
      EvaluationSetCount := 0;

      q.Open;
      while not q.Eof do
      begin
        if not q.Fields.IsNull[q.Fields.FieldCount - 1] then
        begin
          Ligne := @TrainingSet[TrainingSetCount];
          Inc(TrainingSetCount);
        end
        else
        begin
          Ligne := @EvaluationSet[EvaluationSetCount];
          Inc(EvaluationSetCount);
        end;

        SetLength(Ligne^, q.Fields.FieldCount);
        for i := 0 to Pred(q.Fields.FieldCount) do
          Ligne^[i] := q.Fields.AsVariant[i];

        q.Next;
      end;
      SetLength(TrainingSet, TrainingSetCount);
      SetLength(EvaluationSet, EvaluationSetCount);
    finally
      q.Free;
    end;

    if TrainingSetCount = 0 then
      Exit;

    builder := nil;
    forest := nil;
    RFData := TRFData.Create;
    try
      // ils doivent être dans le même ordre que les champs du training set donc de la requête
      RFData.Criterias.Add(TRFCriteria.Create('ANNEEEDITION', -1));
      RFData.Criterias.Add(TRFBooleanCriteria.Create('VO'));
      RFData.Criterias.Add(TRFBooleanCriteria.Create('COULEUR'));
      RFData.Criterias.Add(TRFNominalCriteria.CreateFromList('ETAT', 1));
      RFData.Criterias.Add(TRFNominalCriteria.CreateFromList('RELIURE', 2));
      RFData.Criterias.Add(TRFNominalCriteria.CreateFromList('TYPEEDITION', 3));
      RFData.Criterias.Add(TRFCriteria.Create('DATEACHAT', -1));
      RFData.Criterias.Add(TRFCriteria.Create('NOMBREDEPAGES', -1));
      RFData.Criterias.Add(TRFNominalCriteria.CreateFromList('ORIENTATION', 4));
      RFData.Criterias.Add(TRFNominalCriteria.CreateFromList('FORMATEDITION', 5));
      RFData.Criterias.Add(TRFNominalCriteria.CreateFromList('SENSLECTURE', 8));
      RFData.Criterias.Add(TRFCriteria.Create('MOISPARUTION', -1));
      RFData.Criterias.Add(TRFCriteria.Create('ANNEEPARUTION', -1));
      RFData.Criterias.Add(TRFCriteria.Create('TOME', -1));
      RFData.Criterias.Add(TRFCriteria.Create('TOMEDEBUT', -1));
      RFData.Criterias.Add(TRFCriteria.Create('TOMEFIN', -1));
      RFData.Criterias.Add(TRFBooleanCriteria.Create('HORSSERIE'));
      RFData.Criterias.Add(TRFBooleanCriteria.Create('INTEGRALE'));

      RFData.Criterias.Add(TRFCriteria.Create('PRIX', NAN)); // Output

      Assert(RFData.Criterias.Count = Length(TrainingSet[0]));

      dfbuildercreate(builder);

      dfbuildersetsubsampleratio(builder, 0.5); // use only 50% of the training set for each tree
      dfbuildersetrdfsplitstrength(builder, 2); // strong split at the best point of the range
      dfbuildersetrndvarsauto(builder); // use only sqrt(nvars) vars in the trees

      try
        // "data" contains needed ones only. Last col is the one to guess
        data := RFData.GetDatas(TrainingSet);
        dfbuildersetdataset(builder, data, Length(data), Length(data[0]) - 1, 1 { regression } );

        dfbuilderbuildrandomforest(builder, 30, forest, rep); // 30 trees seems to be the least to have the minimum oob error
      finally
        data := nil;
      end;

      try
        data := RFData.GetDatas(EvaluationSet);
        // en dessous de 40000 lignes dans EvaluationSet, il semble qu'un traitement parallèle soit contre-performant
        for i := Low(data) to High(data) do
          Result := Result + dfprocess0(forest, TVector(data[i]));
      finally
        data := nil;
      end;
    finally
      RFData.Free;
      forest.Free;
      builder.Free;
    end;
  finally
    TrainingSet := nil;
    EvaluationSet := nil;
  end;
end;

procedure TStats.Fill(Complete: Boolean);
var
  PS: TStats;
  q: TManagedQuery;
  hg: IHourGlass;
begin
  Clear;
  hg := THourGlass.Create;
  CreateStats(Self);
  if Complete then
  begin
    q := dmPrinc.DBConnection.GetQuery;
    try
      q.SQL.Add('select distinct');
      q.SQL.Add('  ed.id_editeur, e.nomediteur');
      q.SQL.Add('from');
      q.SQL.Add('  editions ed');
      q.SQL.Add('  inner join editeurs e on');
      q.SQL.Add('    ed.id_editeur = e.id_editeur');
      q.SQL.Add('order by');
      q.SQL.Add('  e.nomediteur');
      q.Open;
      while not q.Eof do
      begin
        PS := TStats.Create;
        ListEditeurs.Add(PS);
        CreateStats(PS, StringToGUID(q.Fields.AsString[0]), Trim(q.Fields.AsString[1]));
        q.Next;
      end;
    finally
      q.Free;
    end;
  end;
end;

{ TSeriesIncompletes }

procedure TSeriesIncompletes.ResetInstance;
begin
  inherited;
  Series.Clear;
end;

constructor TSeriesIncompletes.Create(AvecIntegrales, AvecAchats: Boolean);
begin
  inherited Create;
  FSeries := TObjectList<TSerieIncomplete>.Create(True);
  Fill(AvecIntegrales, AvecAchats, GUID_NULL);
end;

constructor TSeriesIncompletes.Create(const ID_Serie: TGUID);
begin
  inherited Create;
  FSeries := TObjectList<TSerieIncomplete>.Create(True);
  Fill(ID_Serie);
end;

destructor TSeriesIncompletes.Destroy;
begin
  FreeAndNil(FSeries);
  inherited;
end;

procedure TSeriesIncompletes.Fill(AvecIntegrales, AvecAchats: Boolean; const ID_Serie: TGUID);
var
  q: TManagedQuery;
  CurrentSerie, dummy: TGUID;
  iDummy, FirstTome, CurrentTome: Integer;

  procedure UpdateSerie;
  var
    i: Integer;
    NumerosManquants: TStringList;
  begin
    NumerosManquants := Self.Series.Last.NumerosManquants;
    if CurrentTome > FirstTome + 1 then
      NumerosManquants.Add(Format('%d<>%d', [FirstTome, CurrentTome]))
    else
      for i := FirstTome to CurrentTome do
        NumerosManquants.Add(IntToStr(i));
  end;

var
  Incomplete: TSerieIncomplete;
begin
  Clear;
  q := dmPrinc.DBConnection.GetQuery;
  try
    q.SQL.Text := 'select * from albums_manquants(:withintegrales, :withachats, :id_serie) order by titreserie, tome';
    q.Params.AsBoolean[0] := AvecIntegrales;
    q.Params.AsBoolean[1] := AvecAchats;
    if not IsEqualGUID(ID_Serie, GUID_NULL) then
      q.Params.AsString[2] := GUIDToString(ID_Serie);
    q.Open;
    CurrentSerie := GUID_NULL;
    FirstTome := -1;
    CurrentTome := -1;
    while not q.Eof do
    begin
      dummy := StringToGUID(q.Fields.ByNameAsString['id_serie']);
      if not IsEqualGUID(dummy, CurrentSerie) then
      begin
        if not IsEqualGUID(CurrentSerie, GUID_NULL) then
          UpdateSerie;
        Incomplete := TSerieIncomplete.Create;
        Self.Series.Add(Incomplete);
        TDaoSerieLite.Fill(Incomplete.Serie, q);
        CurrentSerie := dummy;
        FirstTome := q.Fields.ByNameAsInteger['tome'];
        CurrentTome := FirstTome;
      end
      else
      begin
        iDummy := q.Fields.ByNameAsInteger['tome'];
        if iDummy <> CurrentTome + 1 then
        begin
          UpdateSerie;
          FirstTome := iDummy;
        end;
        CurrentTome := iDummy;
      end;
      q.Next;
    end;
    if not IsEqualGUID(CurrentSerie, GUID_NULL) then
      UpdateSerie;
  finally
    q.Free;
  end;
end;

procedure TSeriesIncompletes.Fill(const Reference: TGUID);
begin
  Fill(True, True, Reference);
end;

{ TPrevisionsSorties }

procedure TPrevisionsSorties.ResetInstance;
begin
  inherited;
  AnneesPassees.Clear;
  AnneeEnCours.Clear;
  AnneesProchaines.Clear;
end;

constructor TPrevisionsSorties.Create(AvecAchats: Boolean);
begin
  inherited Create;
  FAnneesPassees := TObjectList<TPrevisionSortie>.Create(True);
  FAnneeEnCours := TObjectList<TPrevisionSortie>.Create(True);
  FAnneesProchaines := TObjectList<TPrevisionSortie>.Create(True);
  Fill(AvecAchats);
end;

constructor TPrevisionsSorties.Create(const ID_Serie: TGUID);
begin
  inherited Create;
  FAnneesPassees := TObjectList<TPrevisionSortie>.Create(True);
  FAnneeEnCours := TObjectList<TPrevisionSortie>.Create(True);
  FAnneesProchaines := TObjectList<TPrevisionSortie>.Create(True);
  Fill(ID_Serie);
end;

destructor TPrevisionsSorties.Destroy;
begin
  FreeAndNil(FAnneesPassees);
  FreeAndNil(FAnneeEnCours);
  FreeAndNil(FAnneesProchaines);
  inherited;
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean; const ID_Serie: TGUID);
var
  q: TManagedQuery;
  Annee, CurrentAnnee: Integer;
  Prevision: TPrevisionSortie;
begin
  Clear;
  CurrentAnnee := YearOf(Now);
  q := dmPrinc.DBConnection.GetQuery;
  try
    q.SQL.Add('select');
    q.SQL.Add('  *');
    q.SQL.Add('from');
    q.SQL.Add('  previsions_sorties(:withachats, :id_serie)');
    q.SQL.Add('order by');
    q.SQL.Add('  anneeparution,');
    q.SQL.Add('  case');
    q.SQL.Add('    when moisparution between 1 and 4 then 1');
    q.SQL.Add('    when moisparution between 5 and 8 then 2');
    q.SQL.Add('    when moisparution between 9 and 12 then 3');
    q.SQL.Add('    else 0');
    q.SQL.Add('  end,');
    q.SQL.Add('  titreserie');
    q.Params.AsBoolean[0] := AvecAchats;
    if not IsEqualGUID(ID_Serie, GUID_NULL) then
      q.Params.AsString[1] := GUIDToString(ID_Serie);
    q.Open;
    while not q.Eof do
    begin
      Annee := q.Fields.ByNameAsInteger['anneeparution'];
      Prevision := TPrevisionSortie.Create;
      TDaoSerieLite.Fill(Prevision.Serie, q);
      Prevision.Tome := q.Fields.ByNameAsInteger['tome'];
      Prevision.Annee := Annee;
      Prevision.Mois := q.Fields.ByNameAsInteger['moisparution'];
      if Annee < CurrentAnnee then
        Self.AnneesPassees.Add(Prevision)
      else if Annee > CurrentAnnee then
        Self.AnneesProchaines.Add(Prevision)
      else
        Self.AnneeEnCours.Add(Prevision);
      q.Next;
    end;
  finally
    q.Free;
  end;
end;

procedure TPrevisionsSorties.Fill(const Reference: TGUID);
begin
  Fill(True, Reference);
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean);
begin
  Fill(AvecAchats, GUID_NULL);
end;

{ TPrevisionSortie }

constructor TPrevisionSortie.Create;
begin
  inherited;
  FSerie := TFactorySerieLite.getInstance;
end;

destructor TPrevisionSortie.Destroy;
begin
  FreeAndNil(FSerie);
  inherited;
end;

function TPrevisionSortie.GetsAnnee: string;
begin
  Result := IntToStr(Annee);
  if Mois > 0 then
    Result := Choose(Mois - 1, ['début', 'début', 'début', 'début', 'mi', 'mi', 'mi', 'mi', 'fin', 'fin', 'fin', 'fin']) + ' ' + Result;
end;

{ TSerieIncomplete }

function TSerieIncomplete.ChaineAffichage: string;
var
  S: string;
  i: Integer;
begin
  Result := '';
  for i := 0 to NumerosManquants.Count - 1 do
  begin
    S := NumerosManquants[i];
    if Pos('<>', S) <> 0 then
      S := StringReplace(S, '<>', ' à ', []);
    AjoutString(Result, S, ', ');
  end;
end;

constructor TSerieIncomplete.Create;
begin
  inherited;
  FNumerosManquants := TStringList.Create;
  FSerie := TFactorySerieLite.getInstance;
end;

destructor TSerieIncomplete.Destroy;
begin
  FreeAndNil(FSerie);
  FreeAndNil(FNumerosManquants);
  inherited;
end;

end.
