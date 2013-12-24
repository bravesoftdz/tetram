unit EntitiesStats;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Entities.Lite, Entities.Common;

type
  TStats = class(TEntity)
  strict private
    FNbAlbumsGratuit: Integer;
    FNbAlbumsNB: Integer;
    FPrixAlbumMaximun: Currency;
    FPrixAlbumMoyen: Currency;
    FValeurConnue: Currency;
    FNbAlbumsIntegrale: Integer;
    FMaxAnnee: Integer;
    FNbAlbumsDedicace: Integer;
    FListAlbumsMax: TObjectList<TAlbumLite>;
    FNbSeries: Integer;
    FListEditeurs: TObjectList<TStats>;
    FPrixAlbumMinimun: Currency;
    FValeurEstimee: Currency;
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
  public
    constructor Create(Complete: Boolean); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(Complete: Boolean);
    procedure Clear; override;
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
    property ValeurEstimee: Currency read FValeurEstimee;
    property PrixAlbumMinimun: Currency read FPrixAlbumMinimun;
    property PrixAlbumMoyen: Currency read FPrixAlbumMoyen;
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
    procedure Clear; override;
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
    procedure Clear; override;
  published
    property AnneesPassees: TObjectList<TPrevisionSortie> read FAnneesPassees;
    property AnneeEnCours: TObjectList<TPrevisionSortie> read FAnneeEnCours;
    property AnneesProchaines: TObjectList<TPrevisionSortie> read FAnneesProchaines;
  end;

implementation

uses
  Commun, uib, UdmPrinc, System.DateUtils, Divers, Entities.DaoLite,
  Entities.FactoriesLite;

{ TStats }

procedure TStats.Clear;
begin
  inherited;
  ListAlbumsMax.Clear;
  ListAlbumsMin.Clear;
  ListGenre.Clear;
  ListEditeurs.Clear;
  ListEditeurs.Clear;
end;

constructor TStats.Create(Complete: Boolean);
begin
  inherited Create;
  FListAlbumsMax := TObjectList<TAlbumLite>.Create;
  FListAlbumsMin := TObjectList<TAlbumLite>.Create;
  FListGenre := TObjectList<TGenreLite>.Create;
  FListEditeurs := TObjectList<TStats>.Create;
  Fill(Complete);
end;

procedure TStats.CreateStats(Stats: TStats);
begin
  CreateStats(Stats, GUID_NULL, '');
end;

procedure TStats.CreateStats(Stats: TStats; const ID_Editeur: TGUID; const Editeur: string);
var
  q: TUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Stats.FEditeur := Editeur;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Add('select count(a.id_album) from albums a inner join editions e on a.id_album = e.id_album');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)))
      else
        SQL.Add('');
      SQL.Add('');
      Open;
      Stats.FNbAlbums := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.couleur = 0';
      Open;
      Stats.FNbAlbumsNB := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.vo = 1';
      Open;
      Stats.FNbAlbumsVO := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.stock = 1';
      Open;
      Stats.FNbAlbumsStock := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.dedicace = 1';
      Open;
      Stats.FNbAlbumsDedicace := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.offert = 1';
      Open;
      Stats.FNbAlbumsOffert := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.gratuit = 1';
      Open;
      Stats.FNbAlbumsGratuit := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where a.integrale = 1';
      Open;
      Stats.FNbAlbumsIntegrale := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where a.horsserie = 1';
      Open;
      Stats.FNbAlbumsHorsSerie := Fields.AsInteger[0];
      Close;

      SQL.Clear;
      SQL.Add('select count(distinct a.id_serie) from albums a');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_album = a.id_album and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)))
      else
        SQL.Add('');
      Open;
      Stats.FNbSeries := Fields.AsInteger[0];
      Close;
      SQL.Add('left join series s on a.id_serie = s.id_serie');
      SQL.Add('');
      SQL[3] := 'where s.terminee = 1';
      Open;
      Stats.FNbSeriesTerminee := Fields.AsInteger[0];
      Close;

      SQL.Text := 'select min(a.anneeparution) as minannee, max(a.anneeparution) as maxannee from albums a';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_album = a.id_album and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FMinAnnee := 0;
      Stats.FMaxAnnee := 0;
      if not Eof then
      begin
        Stats.FMinAnnee := Fields.ByNameAsInteger['minannee'];
        Stats.FMaxAnnee := Fields.ByNameAsInteger['maxannee'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  count(g.id_genre) as quantitegenre, g.id_genre, g.genre');
      SQL.Add('from');
      SQL.Add('  genreseries gs');
      SQL.Add('  inner join genres g on');
      SQL.Add('    gs.id_genre = g.id_genre');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      begin
        SQL.Add('  inner join albums a on');
        SQL.Add('    a.id_serie = gs.id_serie');
        SQL.Add('  inner join editions e on');
        SQL.Add('    e.id_album = a.id_album');
        SQL.Add('    and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
      end;
      SQL.Add('group by');
      SQL.Add('  g.genre, g.id_genre');
      SQL.Add('order by');
      SQL.Add('  1 desc');
      Open;
      TDaoGenreLite.FillList(Stats.ListGenre, q);

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  sum(prix) as sumprix, count(prix) as countprix, min(prix) as minprix, max(prix) as maxprix');
      SQL.Add('from');
      SQL.Add('  editions');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('where id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FValeurConnue := Fields.ByNameAsCurrency['sumprix'];
      Stats.FPrixAlbumMoyen := 0;
      Stats.FPrixAlbumMinimun := 0;
      Stats.FPrixAlbumMaximun := 0;
      if not Eof and Fields.ByNameAsBoolean['countprix'] then
      begin
        Stats.FPrixAlbumMoyen := Fields.ByNameAsCurrency['sumprix'] / Fields.ByNameAsInteger['countprix'];
        Stats.FPrixAlbumMinimun := Fields.ByNameAsCurrency['minprix'];
        Stats.FPrixAlbumMaximun := Fields.ByNameAsCurrency['maxprix'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  count(id_edition) as countref');
      SQL.Add('from');
      SQL.Add('  editions');
      SQL.Add('where');
      SQL.Add('  prix is null');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('  and id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbAlbumsSansPrix := 0;
      if not Eof then
        Stats.FNbAlbumsSansPrix := Fields.ByNameAsInteger['countref'] - Stats.NbAlbumsGratuit;
      Stats.FValeurEstimee := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyen;
    finally
      Transaction.Free;
      Free;
    end;
end;

destructor TStats.Destroy;
begin
  FreeAndNil(FListAlbumsMax);
  FreeAndNil(FListAlbumsMin);
  FreeAndNil(FListGenre);
  FreeAndNil(FListEditeurs);
  inherited;
end;

procedure TStats.Fill(Complete: Boolean);
var
  PS: TStats;
  q: TUIBQuery;
  hg: IHourGlass;
begin
  DoClear;
  hg := THourGlass.Create;
  CreateStats(Self);
  if Complete then
  begin
    q := TUIBQuery.Create(nil);
    with q do
      try
        Transaction := GetTransaction(dmPrinc.UIBDataBase);
        Close;
        SQL.Clear;
        SQL.Add('select distinct');
        SQL.Add('  ed.id_editeur, e.nomediteur');
        SQL.Add('from');
        SQL.Add('  editions ed');
        SQL.Add('  inner join editeurs e on');
        SQL.Add('    ed.id_editeur = e.id_editeur');
        SQL.Add('order by');
        SQL.Add('  e.nomediteur');
        Open;
        while not Eof do
        begin
          PS := TStats.Create;
          ListEditeurs.Add(PS);
          CreateStats(PS, StringToGUID(Fields.AsString[0]), Trim(Fields.AsString[1]));
          Next;
        end;
      finally
        Transaction.Free;
        Free;
      end;
  end;
end;

{ TSeriesIncompletes }

procedure TSeriesIncompletes.Clear;
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
  q: TUIBQuery;
  CurrentSerie, dummy: TGUID;
  iDummy, FirstTome, CurrentTome: Integer;

  procedure UpdateSerie;
  var
    i: Integer;
  begin
    with Self.Series[Pred(Self.Series.Count)] do
      if CurrentTome > FirstTome + 1 then
        NumerosManquants.Add(Format('%d<>%d', [FirstTome, CurrentTome]))
      else
        for i := FirstTome to CurrentTome do
          NumerosManquants.Add(IntToStr(i));
  end;

var
  Incomplete: TSerieIncomplete;
begin
  DoClear;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Text := 'select * from albums_manquants(:withintegrales, :withachats, :id_serie) order by titreserie, tome';
      Params.AsBoolean[0] := AvecIntegrales;
      Params.AsBoolean[1] := AvecAchats;
      if not IsEqualGUID(ID_Serie, GUID_NULL) then
        Params.AsString[2] := GUIDToString(ID_Serie);
      Open;
      CurrentSerie := GUID_NULL;
      FirstTome := -1;
      CurrentTome := -1;
      while not Eof do
      begin
        dummy := StringToGUID(Fields.ByNameAsString['id_serie']);
        if not IsEqualGUID(dummy, CurrentSerie) then
        begin
          if not IsEqualGUID(CurrentSerie, GUID_NULL) then
            UpdateSerie;
          Incomplete := TSerieIncomplete.Create;
          Self.Series.Add(Incomplete);
          TDaoSerieLite.Fill(Incomplete.Serie, q);
          CurrentSerie := dummy;
          FirstTome := Fields.ByNameAsInteger['tome'];
          CurrentTome := FirstTome;
        end
        else
        begin
          iDummy := Fields.ByNameAsInteger['tome'];
          if iDummy <> CurrentTome + 1 then
          begin
            UpdateSerie;
            FirstTome := iDummy;
          end;
          CurrentTome := iDummy;
        end;
        Next;
      end;
      if not IsEqualGUID(CurrentSerie, GUID_NULL) then
        UpdateSerie;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TSeriesIncompletes.Fill(const Reference: TGUID);
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
  q: TUIBQuery;
  Annee, CurrentAnnee: Integer;
  Prevision: TPrevisionSortie;
begin
  DoClear;
  CurrentAnnee := YearOf(Now);
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  *');
      SQL.Add('from');
      SQL.Add('  previsions_sorties(:withachats, :id_serie)');
      SQL.Add('order by');
      SQL.Add('  anneeparution,');
      SQL.Add('  case');
      SQL.Add('    when moisparution between 1 and 4 then 1');
      SQL.Add('    when moisparution between 5 and 8 then 2');
      SQL.Add('    when moisparution between 9 and 12 then 3');
      SQL.Add('    else 0');
      SQL.Add('  end,');
      SQL.Add('  titreserie');
      Params.AsBoolean[0] := AvecAchats;
      if not IsEqualGUID(ID_Serie, GUID_NULL) then
        Params.AsString[1] := GUIDToString(ID_Serie);
      Open;
      while not Eof do
      begin
        Annee := Fields.ByNameAsInteger['anneeparution'];
        Prevision := TPrevisionSortie.Create;
        TDaoSerieLite.Fill(Prevision.Serie, q);
        Prevision.Tome := Fields.ByNameAsInteger['tome'];
        Prevision.Annee := Annee;
        Prevision.Mois := Fields.ByNameAsInteger['moisparution'];
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
