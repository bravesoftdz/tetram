unit EntitiesRecherche;

interface

uses
  System.SysUtils, System.Classes, Generics.Collections, UChampsRecherche, Entities.Full, Entities.Lite,
  Entities.Common;

type
  TGroupOption = (goEt, goOu);

const
  TLblGroupOption: array [TGroupOption] of string = ('ET', 'OU');

type
  TGroupCritere = class;

  TBaseCritere = class
    Level: Integer;
    Parent: TGroupCritere;
    constructor Create(AParent: TGroupCritere); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
  end;

  TCritere = class(TBaseCritere)
    // affichage
    Champ, Test: string;
    // sql
    NomTable: string;
    TestSQL: string;
    // fenêtre
    iChamp: Integer;
    iSignes, iCritere2: Integer;
    valeurText: string;

    procedure Assign(S: TCritere);
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TGroupCritere = class(TBaseCritere)
    SousCriteres: TObjectList<TBaseCritere>;
    GroupOption: TGroupOption;

    constructor Create(Parent: TGroupCritere); override;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TCritereTri = class
    // sql
    Champ, NomTable: string;
    Asc: Boolean;
    NullsFirst, NullsLast: Boolean;
    // fenêtre
    iChamp: Integer;
    // impression
    LabelChamp: string;
    Imprimer: Boolean;

    // valeur de travail
    _Champ: PChamp;

    procedure Assign(S: TCritereTri);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
  end;

  TTypeRecherche = (trAucune, trSimple, trComplexe);
  TRechercheSimple = (rsAuteur, rsUnivers, rsSerie, rsEditeur, rsGenre, rsCollection);

const
  TLblRechercheSimple: array [TRechercheSimple] of string = ('Auteur', 'Univers', 'Serie', 'Editeur', 'Genre', 'Collection');

type
  TRecherche = class(TEntity)
  public
    TypeRecherche: TTypeRecherche;
    Resultats: TObjectList<TAlbumLite>;
    ResultatsInfos: TStrings;
    Criteres: TGroupCritere;
    SortBy: TObjectList<TCritereTri>;
    RechercheSimple: TRechercheSimple;
    FLibelle: string;

    procedure Clear; override;
    procedure ClearCriteres;
    procedure Fill; reintroduce; overload;
    procedure Fill(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string); reintroduce; overload;

    function AddCritere(Parent: TGroupCritere): TCritere;
    function AddGroup(Parent: TGroupCritere): TGroupCritere;
    function AddSort: TCritereTri;
    procedure Delete(Item: TBaseCritere); overload;
    procedure Delete(Item: TCritereTri); overload;

    constructor Create; overload; override;
    constructor Create(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string); reintroduce; overload;
    destructor Destroy; override;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
  end;

implementation

uses
  uib, Commun, UdmPrinc, Divers, uiblib, CommonConst, UMetadata, Textes,
  Entities.DaoLite, ICUNumberFormatter;

{ TRecherche }

procedure TRecherche.Clear;
begin
  inherited;
  Resultats.Clear;
  ResultatsInfos.Clear;
  TypeRecherche := trAucune;
end;

constructor TRecherche.Create;
begin
  inherited;
  Resultats := TObjectList<TAlbumLite>.Create(True);
  ResultatsInfos := TStringList.Create;
  Criteres := TGroupCritere.Create(nil);
  SortBy := TObjectList<TCritereTri>.Create(True);
end;

procedure TRecherche.ClearCriteres;
begin
  Criteres.SousCriteres.Clear;
  SortBy.Clear;
  TypeRecherche := trAucune;
end;

constructor TRecherche.Create(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string);
begin
  inherited Create;
  Fill(Recherche, ID, Libelle);
end;

procedure TRecherche.Fill;
var
  slFrom, slWhere: TStringList;

  function ProcessTables: string;
  var
    i: Integer;
  begin
    // Tables possibles:
    // ALBUMS
    // SERIES
    // EDITIONS
    // GENRESERIES
    // ALBUMS_UNIVERS + UNIVERS

    Result := '';
    Result := Result + #13#10' albums';
    Result := Result + #13#10' inner join editions on albums.id_album = editions.id_album';
    Result := Result + #13#10' left join series on albums.id_serie = series.id_serie';

    i := slFrom.IndexOf('genreseries');
    if i <> -1 then
      Result := Result + #13#10' left join genreseries on genreseries.id_serie = albums.id_serie';

    i := slFrom.IndexOf('univers');
    if i <> -1 then
    begin
      Result := Result + #13#10' left join albums_univers on albums_univers.id_album = albums.id_album';
      Result := Result + #13#10' left join univers on univers.id_univers = albums_univers.id_univers';
    end;
  end;

  function ProcessSort(out sOrderBy: string): string;
  var
    Critere: TCritereTri;
    S: string;
  begin
    sOrderBy := '';
    Result := '';
    for Critere in SortBy do
    begin
      Critere._Champ := ChampByID(Critere.iChamp);
      S := Critere.NomTable + '.' + Critere.Champ;
      Result := Result + ', ' + S;
      if not Critere.Asc then
        S := S + ' desc';
      if Critere.NullsFirst then
        S := S + ' nulls first'
      else if Critere.NullsLast then
        S := S + ' nulls last';
      sOrderBy := sOrderBy + S + ', ';
      slFrom.Add(Critere.NomTable);
    end;
  end;

  function ProcessCritere(ItemCritere: TGroupCritere): string;
  var
    p: TBaseCritere;
    sBool: string;
  begin
    Result := '';
    if ItemCritere.GroupOption = goOu then
      sBool := ' or '
    else
      sBool := ' and ';
    for p in ItemCritere.SousCriteres do
      if p is TCritere then
      begin
        if Result = '' then
          Result := '(' + TCritere(p).TestSQL + ')'
        else
          Result := Result + sBool + '(' + TCritere(p).TestSQL + ')';
        slFrom.Add(TCritere(p).NomTable);
      end
      else
      begin
        if Result = '' then
          Result := '(' + ProcessCritere(p as TGroupCritere) + ')'
        else
          Result := Result + sBool + '(' + ProcessCritere(p as TGroupCritere) + ')';
      end;
  end;

var
  Album: TAlbumLite;
  q: TUIBQuery;
  sWhere, sOrderBy, S: string;
  CritereTri: TCritereTri;
begin
  DoClear;
  q := TUIBQuery.Create(nil);
  slFrom := TStringList.Create;
  slFrom.Sorted := True;
  slFrom.Duplicates := dupIgnore;
  slFrom.CaseSensitive := False;
  slWhere := TStringList.Create;
  with q do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Clear;
      SQL.Add('select distinct');
      SQL.Add('  albums.id_album, albums.titrealbum, albums.tome, albums.tomedebut, albums.tomefin,');
      SQL.Add('  albums.horsserie, albums.integrale, albums.moisparution, albums.anneeparution, albums.id_serie,');
      SQL.Add('  series.titreserie');
      SQL.Add(ProcessSort(sOrderBy));
      slFrom.Add('albums');
      slFrom.Add('series');
      slFrom.Add('editions');
      sWhere := ProcessCritere(Criteres);

      SQL.Add('from ' + ProcessTables);

      if sWhere <> '' then
        SQL.Add('where ' + sWhere);

      SQL.Add('order by');
      SQL.Add('  ' + sOrderBy);
      SQL.Add('  coalesce(albums.titrealbum, series.titreserie), series.titreserie, albums.horsserie nulls first,');
      SQL.Add('  albums.integrale nulls first, albums.tome nulls first, albums.tomedebut nulls first,');
      SQL.Add('  albums.tomefin nulls first, albums.anneeparution nulls first, albums.moisparution nulls first');

      Open;
      while not Eof do
      begin
        Album := TDaoAlbumLite.Make(q);
        Resultats.Add(Album);
        S := '';
        for CritereTri in SortBy do
          if CritereTri.Imprimer then
          begin
            AjoutString(S, CritereTri.LabelChamp + ' : ', #13#10);
            if Fields.ByNameIsNull[CritereTri.Champ] then
              S := S + '<vide>'
            else if CritereTri._Champ.Booleen then
              S := S + IIf(Fields.ByNameAsBoolean[CritereTri.Champ], 'Oui', 'Non')
            else
              case CritereTri._Champ.Special of
                csISBN:
                  S := S + FormatISBN(Fields.ByNameAsString[CritereTri.Champ]);
                csTitre:
                  S := S + FormatTitre(Fields.ByNameAsString[CritereTri.Champ]);
                csMonnaie:
                  S := S + ICUCurrencyToStr(Fields.ByNameAsCurrency[CritereTri.Champ]);
              else
                case CritereTri._Champ.TypeData of
                  uftDate:
                    S := S + FormatDateTime('dd mmm yyyy', Fields.ByNameAsDate[CritereTri.Champ]);
                  uftTime:
                    S := S + FormatDateTime('hh:mm:ss', Fields.ByNameAsTime[CritereTri.Champ]);
                  uftTimestamp:
                    S := S + FormatDateTime('dd mmm yyyy, hh:mm:ss', Fields.ByNameAsDateTime[CritereTri.Champ]);
                else
                  S := S + StringReplace(AdjustLineBreaks(Fields.ByNameAsString[CritereTri.Champ], tlbsCRLF), #13#10, '\n', [rfReplaceAll]);
                end;
              end;
          end;
        ResultatsInfos.Add(S);
        Next;
      end;
      if Resultats.Count > 0 then
        TypeRecherche := trComplexe
      else
        TypeRecherche := trAucune;
    finally
      Transaction.Free;
      Free;
      slFrom.Free;
      slWhere.Free;
    end;
end;

destructor TRecherche.Destroy;
begin
  ClearCriteres;
  FreeAndNil(ResultatsInfos);
  FreeAndNil(Resultats);
  FreeAndNil(Criteres);
  FreeAndNil(SortBy);
  inherited;
end;

procedure TRecherche.Fill(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string);
const
  Proc: array [0 .. 5] of string = ('albums_by_auteur(?, null)', 'albums_by_univers(?, null)', 'albums_by_serie(?, null)', 'albums_by_editeur(?, null)',
    'albums_by_genre(?, null)', 'albums_by_collection(?, null)');
var
  q: TUIBQuery;
  S: string;
  Album: TAlbumLite;
  oldID_Album: TGUID;
  oldIndex: Integer;
begin
  DoClear;
  if not IsEqualGUID(ID, GUID_NULL) then
  begin
    q := TUIBQuery.Create(nil);
    with q do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        SQL.Text := 'select * from ' + Proc[Integer(Recherche)];
        Params.AsString[0] := GUIDToString(ID);
        FLibelle := Libelle;
        Open;
        oldID_Album := GUID_NULL;
        oldIndex := -1;
        S := '';
        while not Eof do
        begin
          if IsEqualGUID(oldID_Album, StringToGUID(Fields.ByNameAsString['id_album'])) and (oldIndex <> -1) then
          begin
            if Recherche = rsAuteur then
            begin
              S := ResultatsInfos[oldIndex];
              case TMetierAuteur(Fields.ByNameAsInteger['metier']) of
                maScenariste:
                  AjoutString(S, rsTransScenario, ', ');
                maDessinateur:
                  AjoutString(S, rsTransDessins, ', ');
                maColoriste:
                  AjoutString(S, rsTransCouleurs, ', ');
              end;
              ResultatsInfos[oldIndex] := S;
            end;
          end
          else
          begin
            Album := TDaoAlbumLite.Make(q);
            Resultats.Add(Album);
            if Recherche = rsAuteur then
              case TMetierAuteur(Fields.ByNameAsInteger['metier']) of
                maScenariste:
                  oldIndex := ResultatsInfos.Add(rsTransScenario);
                maDessinateur:
                  oldIndex := ResultatsInfos.Add(rsTransDessins);
                maColoriste:
                  oldIndex := ResultatsInfos.Add(rsTransCouleurs);
              end
            else
              ResultatsInfos.Add('');
          end;
          oldID_Album := StringToGUID(Fields.ByNameAsString['id_album']);
          Next;
        end;
        if Resultats.Count > 0 then
          TypeRecherche := trSimple
        else
          TypeRecherche := trAucune;
      finally
        Transaction.Free;
        Free;
      end;
  end;
end;

function TRecherche.AddCritere(Parent: TGroupCritere): TCritere;
begin
  if not Assigned(Parent) then
    Parent := Criteres;
  Result := TCritere.Create(Parent);
  TypeRecherche := trAucune;
end;

function TRecherche.AddGroup(Parent: TGroupCritere): TGroupCritere;
begin
  if not Assigned(Parent) then
    Parent := Criteres;
  Result := TGroupCritere.Create(Parent);
  TypeRecherche := trAucune;
end;

procedure TRecherche.Delete(Item: TBaseCritere);
begin
  if Item = Criteres then
    ClearCriteres
  else
    Item.Parent.SousCriteres.Remove(Item);
  TypeRecherche := trAucune;
end;

procedure TRecherche.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.read(Result[1], l);
  end;

  function CreateCritere(CritereType: Integer; ParentCritere: TBaseCritere): TBaseCritere;
  begin
    Assert(not Assigned(ParentCritere) or (ParentCritere is TGroupCritere), 'Architecture des critères incorrecte.');
    case CritereType of
      0:
        Result := AddGroup(ParentCritere as TGroupCritere);
      1:
        Result := AddCritere(ParentCritere as TGroupCritere);
    else
      raise Exception.Create('Type de critère inconnu: ' + IntToStr(CritereType));
    end;
    Result.LoadFromStream(Stream);
  end;

var
  lvl, CritereType, i: Integer;
  ACritere, NextCritere: TBaseCritere;
begin
  ClearCriteres;
  Stream.Position := 0;

  for i := 1 to ReadInteger do
    AddSort.LoadFromStream(Stream);

  ReadInteger; // level de la racine
  ReadInteger; // type de la racine
  Criteres.LoadFromStream(Stream);
  ACritere := Criteres;
  while Stream.Position < Stream.Size do
  begin
    lvl := ReadInteger;
    CritereType := ReadInteger;
    if ACritere = nil then
      ACritere := CreateCritere(CritereType, nil)
    else if ACritere.Level = lvl then
      ACritere := CreateCritere(CritereType, ACritere.Parent)
    else if ACritere.Level = (lvl - 1) then
      ACritere := CreateCritere(CritereType, ACritere)
    else if ACritere.Level > lvl then
    begin
      NextCritere := ACritere.Parent;
      while NextCritere.Level > lvl do
        NextCritere := NextCritere.Parent;
      ACritere := CreateCritere(CritereType, NextCritere.Parent);
    end;
  end;
end;

procedure TRecherche.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.write(Value, SizeOf(Integer));
  end;

  procedure WriteCritere(Critere: TBaseCritere);
  begin
    WriteInteger(Critere.Level);
    if Critere is TGroupCritere then
      WriteInteger(0)
    else if Critere is TCritere then
      WriteInteger(1)
    else
      raise Exception.Create('Type de critère inconnu: ' + Critere.ClassName);
    Critere.SaveToStream(Stream);
  end;

  procedure ProcessSousCriteres(ACritere: TGroupCritere);
  var
    Critere: TBaseCritere;
  begin
    for Critere in ACritere.SousCriteres do
    begin
      WriteCritere(Critere);
      if (Critere is TGroupCritere) then
        ProcessSousCriteres(TGroupCritere(Critere));
    end;
  end;

  procedure WriteSortBy;
  var
    CritereTri: TCritereTri;
  begin
    WriteInteger(SortBy.Count);
    for CritereTri in SortBy do
      CritereTri.SaveToStream(Stream);
  end;

begin
  Stream.Size := 0;
  WriteSortBy;
  WriteCritere(Criteres);
  ProcessSousCriteres(Criteres);
end;

procedure TRecherche.Delete(Item: TCritereTri);
begin
  SortBy.Remove(Item);
  TypeRecherche := trAucune;
end;

function TRecherche.AddSort: TCritereTri;
begin
  Result := TCritereTri.Create;
  SortBy.Add(Result);
  TypeRecherche := trAucune;
end;

{ TCritere }

procedure TCritere.Assign(S: TCritere);
begin
  Champ := S.Champ;
  Test := S.Test;
  NomTable := S.NomTable;
  TestSQL := S.TestSQL;
  iChamp := S.iChamp;
  iSignes := S.iSignes;
  iCritere2 := S.iCritere2;
  valeurText := S.valeurText;
end;

procedure TCritere.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.read(Result[1], l * SizeOf(Char));
  end;

begin
  inherited;
  Champ := ReadString;
  Test := ReadString;
  NomTable := ReadString;
  TestSQL := ReadString;
  iChamp := ReadInteger;
  iSignes := ReadInteger;
  iCritere2 := ReadInteger;
  valeurText := ReadString;
end;

procedure TCritere.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.write(Value, SizeOf(Integer));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l * SizeOf(Char));
  end;

begin
  inherited;
  WriteString(Champ);
  WriteString(Test);
  WriteString(NomTable);
  WriteString(TestSQL);
  WriteInteger(iChamp);
  WriteInteger(iSignes);
  WriteInteger(iCritere2);
  WriteString(valeurText);
end;

{ TGroupCritere }

constructor TGroupCritere.Create(Parent: TGroupCritere);
begin
  inherited;
  SousCriteres := TObjectList<TBaseCritere>.Create(True);
end;

destructor TGroupCritere.Destroy;
begin
  FreeAndNil(SousCriteres);
  inherited;
end;

procedure TGroupCritere.LoadFromStream(Stream: TStream);
begin
  inherited;
  Stream.read(GroupOption, SizeOf(Byte));
end;

procedure TGroupCritere.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.write(Byte(GroupOption), SizeOf(Byte));
end;

{ TBaseCritere }

{ TBaseCritere }

constructor TBaseCritere.Create(AParent: TGroupCritere);
begin
  inherited Create;
  Parent := AParent;
  if Assigned(AParent) then
  begin
    Level := AParent.Level + 1;
    Parent.SousCriteres.Add(Self);
  end
  else
    Level := 0;
end;

procedure TBaseCritere.LoadFromStream(Stream: TStream);
begin

end;

procedure TBaseCritere.SaveToStream(Stream: TStream);
begin

end;

{ TCritereTri }

procedure TCritereTri.Assign(S: TCritereTri);
begin
  Champ := S.Champ;
  LabelChamp := S.LabelChamp;
  NomTable := S.NomTable;
  Asc := S.Asc;
  NullsFirst := S.NullsFirst;
  NullsLast := S.NullsLast;
  iChamp := S.iChamp;
  Imprimer := S.Imprimer;
end;

procedure TCritereTri.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.read(Result, SizeOf(Integer));
  end;

  function ReadBool: Boolean;
  var
    dummy: Byte;
  begin
    Stream.read(dummy, SizeOf(Byte));
    Result := dummy = 1;
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.read(Result[1], l * SizeOf(Char));
  end;

begin
  inherited;
  LabelChamp := ReadString;
  Champ := ReadString;
  NomTable := ReadString;
  iChamp := ReadInteger;
  Asc := ReadBool;
  NullsFirst := ReadBool;
  NullsLast := ReadBool;
  Imprimer := ReadBool;
end;

procedure TCritereTri.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.write(Value, SizeOf(Integer));
  end;

  procedure WriteBool(Value: Boolean);
  var
    dummy: Byte;
  begin
    if Value then
      dummy := 1
    else
      dummy := 0;
    Stream.write(dummy, SizeOf(Byte));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l * SizeOf(Char));
  end;

begin
  WriteString(LabelChamp);
  WriteString(Champ);
  WriteString(NomTable);
  WriteInteger(iChamp);
  WriteBool(Asc);
  WriteBool(NullsFirst);
  WriteBool(NullsLast);
  WriteBool(Imprimer);
end;

end.
