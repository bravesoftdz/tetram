unit Entities.DaoFull;

interface

uses
  System.SysUtils, System.Classes, VirtualTreeBdtk, Entities.Full, uib,
  Vcl.StdCtrls, Winapi.Windows, System.Rtti, System.Generics.Collections,
  Entities.Common, Entities.DaoCommon, Entities.FactoriesCommon;

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
    class procedure ChangeNotation(Entity: TAlbumFull; Note: Integer);
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
    class procedure ChangeNotation(Entity: TSerieFull; Note: Integer);

    class procedure InitSerie(Entity: TEntity);
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
  UdmPrinc, Commun, UfrmConsole, Entities.DaoLite, Entities.Lite, Procedures,
  CommonConst, System.IOUtils, Vcl.Dialogs, UMetadata, UfrmFusionEditions,
  Vcl.Controls, ProceduresBDtk, Entities.FactoriesFull, Entities.FactoriesLite,
  Entities.DaoLambda;

{ TDaoFull }

class procedure TDaoFull.FillAssociations(Entity: TObjetFull; TypeData: TVirtualMode);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select chaine, always from import_associations where typedata = :typedata and id = :id and always = 1';
    qry.Params.AsInteger[0] := Integer(TypeData);
    qry.Params.AsString[1] := GUIDToString(Entity.ID);
    qry.Open;
    while not qry.Eof do
    begin
      Entity.Associations.Add(qry.Fields.AsString[0]);
      qry.Next;
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoFull.SaveAssociations(Entity: TObjetFull; TypeData: TVirtualMode; const ParentID: TGUID);
var
  association: string;
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'delete from import_associations where typedata = :typedata and id = :id and always = 1';
    qry.Params.AsInteger[0] := Integer(TypeData);
    qry.Params.AsString[1] := GUIDToString(Entity.ID);
    qry.Execute;

    qry.SQL.Text := 'update or insert into import_associations (chaine, id, parentid, typedata, always) values (:chaine, :id, :parentid, :typedata, 1)';
    qry.Prepare(True);
    for association in Entity.Associations do
      if Trim(association) <> '' then
      begin
        qry.Params.AsString[0] := Copy(Trim(association), 1, qry.Params.MaxStrLen[0]);
        qry.Params.AsString[1] := GUIDToString(Entity.ID);
        qry.Params.AsString[2] := GUIDToString(ParentID);
        qry.Params.AsInteger[3] := Integer(TypeData);
        qry.Execute;
      end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoFull.SaveToDatabase(Entity: TObjetFull);
var
  Transaction: TUIBTransaction;
begin
  // Assert(not IsEqualGUID(Entity.ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');

  Transaction := GetTransaction(dmPrinc.UIBDataBase);
  try
    SaveToDatabase(Entity, Transaction);
    Transaction.Commit;
    Entity.RecInconnu := False;
  finally
    Transaction.Free;
  end;
end;

{ TDaoFullEntity<T> }

class procedure TDaoFullEntity<T>.Fill(Entity: TDBEntity; const Reference: TGUID);
begin
  Fill(T(Entity), Reference);
end;

class procedure TDaoFullEntity<T>.Fill(Entity: T; const Reference: TGUID);
begin
  Entity.DoClear;
end;

class function TDaoFullEntity<T>.getInstance: T;
begin
  Result := getInstance(GUID_NULL);
end;

class function TDaoFullEntity<T>.getInstance(const Reference: TGUID): T;
begin
  Result := T(inherited getInstance(Reference));
end;

class procedure TDaoFullEntity<T>.SaveToDatabase(Entity: T; UseTransaction: TUIBTransaction);
begin
  // Assert(not IsEqualGUID(Entity.ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');
end;

class procedure TDaoFullEntity<T>.SaveToDatabase(Entity: TObjetFull; UseTransaction: TUIBTransaction);
begin
  SaveToDatabase(T(Entity), UseTransaction);
end;

{ TDaoSerieFull }

class procedure TDaoSerieFull.ChangeNotation(Entity: TSerieFull; Note: Integer);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'update series set notation = ? where id_serie = ?';
    qry.Params.AsSmallint[0] := Note;
    qry.Params.AsString[1] := GUIDToString(Entity.ID_Serie);
    qry.Execute;
    qry.Transaction.Commit;

    Entity.Notation := Note;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

{ TDaoAlbumFull }

class procedure TDaoAlbumFull.Acheter(Entity: TAlbumFull; Prevision: Boolean);
var
  qry: TUIBQuery;
begin
  if IsEqualGUID(Entity.ID_Album, GUID_NULL) then
    Exit;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'update albums set achat = :achat where id_album = ?';
    qry.Params.AsBoolean[0] := Prevision;
    qry.Params.AsString[1] := GUIDToString(Entity.ID_Album);
    qry.Execute;
    qry.Transaction.Commit;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoAlbumFull.ChangeNotation(Entity: TAlbumFull; Note: Integer);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'update albums set notation = ? where id_album = ?';
    qry.Params.AsSmallint[0] := Note;
    qry.Params.AsString[1] := GUIDToString(Entity.ID_Album);
    qry.Execute;
    qry.Transaction.Commit;

    Entity.Notation := Note;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class function TDaoAlbumFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAlbumFull;
end;

class procedure TDaoAlbumFull.Fill(Entity: TAlbumFull; const Reference: TGUID);
var
  qry: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_Album := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);

    TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill > données de base - ' + GUIDToString(Reference));

    qry.FetchBlobs := True;
    qry.SQL.Clear;
    qry.SQL.Add('select');
    qry.SQL.Add('  titrealbum, moisparution, anneeparution, id_serie, tome, tomedebut, tomefin, sujetalbum,');
    qry.SQL.Add('  remarquesalbum, horsserie, integrale, complet, notation');
    qry.SQL.Add('from');
    qry.SQL.Add('  albums');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_album = ?');
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.TitreAlbum := qry.Fields.ByNameAsString['titrealbum'];
      Entity.AnneeParution := qry.Fields.ByNameAsInteger['anneeparution'];
      Entity.MoisParution := qry.Fields.ByNameAsInteger['moisparution'];
      Entity.Sujet := qry.Fields.ByNameAsString['sujetalbum'];
      Entity.Notes := qry.Fields.ByNameAsString['remarquesalbum'];
      Entity.Tome := qry.Fields.ByNameAsInteger['tome'];
      Entity.TomeDebut := qry.Fields.ByNameAsInteger['tomedebut'];
      Entity.TomeFin := qry.Fields.ByNameAsInteger['tomefin'];
      Entity.Integrale := qry.Fields.ByNameAsBoolean['integrale'];
      Entity.HorsSerie := qry.Fields.ByNameAsBoolean['horsserie'];
      Entity.Notation := qry.Fields.ByNameAsSmallint['notation'];
      if Entity.Notation = 0 then
        Entity.Notation := 900;

      Entity.Complet := qry.Fields.ByNameAsBoolean['complet'];

      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill < données de base - ' + GUIDToString(Reference));

      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill > série - ' + GUIDToString(Reference));
      TDaoSerieFull.Fill(Entity.Serie, StringToGUIDDef(qry.Fields.ByNameAsString['id_serie'], GUID_NULL));
      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill < série - ' + GUIDToString(Reference));

      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill > univers - ' + GUIDToString(Reference));
      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('select');
      qry.SQL.Add('  u.*');
      qry.SQL.Add('from');
      qry.SQL.Add('  univers u');
      qry.SQL.Add('  inner join albums_univers au on');
      qry.SQL.Add('    au.id_univers = u.id_univers');
      qry.SQL.Add('where');
      qry.SQL.Add('  au.source_album = 1 and au.id_album = ?');
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      TDaoUniversLite.FillList(Entity.Univers, qry);
      Entity.UniversFull.Clear;
      Entity.UniversFull.AddRange(Entity.Serie.Univers);
      Entity.UniversFull.AddRange(Entity.Univers);
      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill < univers - ' + GUIDToString(Reference));

      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill > auteurs - ' + GUIDToString(Reference));
      qry.Close;
      qry.SQL.Text := 'select * from proc_auteurs(?, null, null)';
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      TDaoAuteurLite.Prepare(qry);
      try
        while not qry.Eof do
        begin
          case TMetierAuteur(qry.Fields.ByNameAsInteger['metier']) of
            maScenariste:
              Entity.Scenaristes.Add(TDaoAuteurLite.Make(qry));
            maDessinateur:
              Entity.Dessinateurs.Add(TDaoAuteurLite.Make(qry));
            maColoriste:
              Entity.Coloristes.Add(TDaoAuteurLite.Make(qry));
          end;
          qry.Next;
        end;
      finally
        TDaoAuteurLite.Unprepare;
      end;
      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill < auteurs - ' + GUIDToString(Reference));

      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill > éditions - ' + GUIDToString(Reference));
      TDaoEditionFull.FillList(Entity.Editions, Entity.ID_Album);
      TfrmConsole.AddEvent(Self.UnitName, 'TDaoAlbumFull.Fill < éditions - ' + GUIDToString(Reference));
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoAlbumFull.FusionneInto(Source, Dest: TAlbumFull);

  function NotInList(Auteur: TAuteurLite; List: TObjectList<TAuteurLite>): Boolean; inline; overload;
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
  Auteur: TAuteurLite;
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
        Dest.Scenaristes.Add(TFactoryAuteurLite.Duplicate(Auteur));
    for Auteur in Source.Dessinateurs do
      if NotInList(Auteur, Dest.Dessinateurs) then
        Dest.Dessinateurs.Add(TFactoryAuteurLite.Duplicate(Auteur));
    for Auteur in Source.Coloristes do
      if NotInList(Auteur, Dest.Coloristes) then
        Dest.Coloristes.Add(TFactoryAuteurLite.Duplicate(Auteur));

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

class procedure TDaoAlbumFull.SaveToDatabase(Entity: TAlbumFull; UseTransaction: TUIBTransaction);
var
  S: string;
  qry: TUIBQuery;
  Auteur: TAuteurLite;
  hg: IHourGlass;
  Edition: TEditionFull;
  Univers: TUniversLite;
begin
  inherited;
  hg := THourGlass.Create;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into albums (');
    qry.SQL.Add('  id_album, titrealbum, moisparution, anneeparution, id_serie, tome, tomedebut, tomefin,');
    qry.SQL.Add('  horsserie, integrale, sujetalbum, remarquesalbum');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_album, :titrealbum, :moisparution, :anneeparution, :id_serie, :tome, :tomedebut, :tomefin,');
    qry.SQL.Add('  :horsserie, :integrale, :sujetalbum, :remarquesalbum');
    qry.SQL.Add(') returning id_album');
    qry.Prepare(True);

    if IsEqualGUID(GUID_NULL, Entity.ID_Album) then
      qry.Params.ByNameIsNull['id_album'] := True
    else
      qry.Params.ByNameAsString['id_album'] := GUIDToString(Entity.ID_Album);
    if Entity.TitreAlbum = '' then
      qry.Params.ByNameIsNull['titrealbum'] := True
    else
      qry.Params.ByNameAsString['titrealbum'] := Entity.TitreAlbum;
    if Entity.AnneeParution = 0 then
    begin
      qry.Params.ByNameIsNull['anneeparution'] := True;
      qry.Params.ByNameIsNull['moisparution'] := True;
    end
    else
    begin
      qry.Params.ByNameAsInteger['anneeparution'] := Entity.AnneeParution;
      if Entity.MoisParution = 0 then
        qry.Params.ByNameIsNull['moisparution'] := True
      else
        qry.Params.ByNameAsInteger['moisparution'] := Entity.MoisParution;
    end;
    if Entity.Tome = 0 then
      qry.Params.ByNameIsNull['tome'] := True
    else
      qry.Params.ByNameAsInteger['tome'] := Entity.Tome;
    if (not Entity.Integrale) or (Entity.TomeDebut = 0) then
      qry.Params.ByNameIsNull['tomedebut'] := True
    else
      qry.Params.ByNameAsInteger['tomedebut'] := Entity.TomeDebut;
    if (not Entity.Integrale) or (Entity.TomeFin = 0) then
      qry.Params.ByNameIsNull['tomefin'] := True
    else
      qry.Params.ByNameAsInteger['tomefin'] := Entity.TomeFin;
    qry.Params.ByNameAsBoolean['integrale'] := Entity.Integrale;
    qry.Params.ByNameAsBoolean['horsserie'] := Entity.HorsSerie;
    S := Entity.Sujet;
    if S <> '' then
      qry.ParamsSetBlob('sujetalbum', S)
    else
      qry.Params.ByNameIsNull['sujetalbum'] := True;
    S := Entity.Notes;
    if S <> '' then
      qry.ParamsSetBlob('remarquesalbum', S)
    else
      qry.Params.ByNameIsNull['remarquesalbum'] := True;
    if Entity.Serie.RecInconnu or IsEqualGUID(Entity.ID_Serie, GUID_NULL) then
      qry.Params.ByNameIsNull['ID_SERIE'] := True
    else
      qry.Params.ByNameAsString['id_serie'] := GUIDToString(Entity.ID_Serie);
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Album := StringToGUID(qry.Fields.AsString[0]);

    SupprimerToutDans('', 'auteurs', 'id_album', Entity.ID_Album);
    qry.SQL.Clear;
    qry.SQL.Add('insert into auteurs (');
    qry.SQL.Add('  id_album, metier, id_personne');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_album, :metier, :id_personne');
    qry.SQL.Add(') returning id_auteur');
    for Auteur in Entity.Scenaristes do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
      qry.Params.AsInteger[1] := 0;
      qry.Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;
    for Auteur in Entity.Dessinateurs do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
      qry.Params.AsInteger[1] := 1;
      qry.Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;
    for Auteur in Entity.Coloristes do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
      qry.Params.AsInteger[1] := 2;
      qry.Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;

    S := '';
    for Univers in Entity.Univers do
      AjoutString(S, QuotedStr(GUIDToString(Univers.ID)), ',');
    qry.SQL.Clear;
    qry.SQL.Add('update albums_univers set source_album = 0');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_album = ?');
    if S <> '' then
      qry.SQL.Add('  and id_univers not in (' + S + ')');
    qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
    qry.Execute;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into albums_univers (');
    qry.SQL.Add('  id_album, id_univers, source_album');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_album, :id_univers, 1');
    qry.SQL.Add(') returning id_album_univers');
    qry.Prepare(True);
    for Univers in Entity.Univers do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
      qry.Params.AsString[1] := GUIDToString(Univers.ID);
      qry.Execute;
      Univers.ID := StringToGUID(qry.Fields.AsString[0]);
    end;

    S := '';
    for Edition in Entity.Editions do
      if not Edition.RecInconnu then
        AjoutString(S, QuotedStr(GUIDToString(Edition.ID_Edition)), ',');

    // éditions supprimées
    qry.SQL.Clear;
    qry.SQL.Add('delete from editions');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_album = ?');
    if S <> '' then
      qry.SQL.Add('  and id_edition not in (' + S + ')');
    qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
    qry.Execute;
    qry.SQL.Clear;
    qry.SQL.Add('delete from couvertures');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_album = ? and id_edition is not null');
    if S <> '' then
      qry.SQL.Add('  and id_edition not in (' + S + ')');
    qry.Params.AsString[0] := GUIDToString(Entity.ID_Album);
    qry.Execute;

    for Edition in Entity.Editions do
    begin
      Edition.ID_Album := Entity.ID_Album;
      TDaoEditionFull.SaveToDatabase(Edition, qry.Transaction);
    end;

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

{ TDaoParaBDFull }

class procedure TDaoParaBDFull.Acheter(Entity: TParaBDFull; Prevision: Boolean);
var
  qry: TUIBQuery;
begin
  if IsEqualGUID(Entity.ID_ParaBD, GUID_NULL) then
    Exit;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'update parabd set achat = :achat where id_parabd = ?';
    qry.Params.AsBoolean[0] := Prevision;
    qry.Params.AsString[1] := GUIDToString(Entity.ID_ParaBD);
    qry.Execute;
    qry.Transaction.Commit;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class function TDaoParaBDFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryParaBDFull;
end;

class procedure TDaoParaBDFull.Fill(Entity: TParaBDFull; const Reference: TGUID);
var
  qry: TUIBQuery;
  ID_Serie: TGUID;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_ParaBD := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.FetchBlobs := True;
    qry.SQL.Clear;
    qry.SQL.Add('select');
    qry.SQL.Add('  titreparabd, annee, id_serie, achat, description, dedicace, numerote, anneecote, prixcote,');
    qry.SQL.Add('  gratuit, offert, dateachat, prix, stock, categorieparabd, lc.libelle as scategorieparabd,');
    qry.SQL.Add('  fichierparabd, stockageparabd, case when imageparabd is null then 0 else 1 end as hasblobimage');
    qry.SQL.Add('from');
    qry.SQL.Add('  parabd p');
    qry.SQL.Add('  left join listes lc on');
    qry.SQL.Add('    (lc.ref = p.categorieparabd and lc.categorie = 7)');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_parabd = ?');

    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.TitreParaBD := qry.Fields.ByNameAsString['titreparabd'];
      Entity.AnneeEdition := qry.Fields.ByNameAsInteger['annee'];
      Entity.Description := qry.Fields.ByNameAsString['description'];
      Entity.CategorieParaBD := MakeOption(qry.Fields.ByNameAsInteger['categorieparabd'], qry.Fields.ByNameAsString['scategorieparabd']);
      Entity.Prix := qry.Fields.ByNameAsCurrency['prix'];
      Entity.Dedicace := qry.Fields.ByNameAsBoolean['dedicace'];
      Entity.Numerote := qry.Fields.ByNameAsBoolean['numerote'];
      Entity.Offert := qry.Fields.ByNameAsBoolean['offert'];
      Entity.Gratuit := qry.Fields.ByNameAsBoolean['gratuit'];
      Entity.Stock := qry.Fields.ByNameAsBoolean['stock'];
      Entity.DateAchat := qry.Fields.ByNameAsDate['dateachat'];
      Entity.AnneeCote := qry.Fields.ByNameAsInteger['anneecote'];
      Entity.PrixCote := qry.Fields.ByNameAsCurrency['prixcote'];

      ID_Serie := StringToGUIDDef(qry.Fields.ByNameAsString['id_serie'], GUID_NULL);

      Entity.ImageStockee := qry.Fields.ByNameAsBoolean['stockageparabd'];
      Entity.FichierImage := qry.Fields.ByNameAsString['fichierparabd'];
      Entity.HasImage := (qry.Fields.ByNameAsSmallint['hasblobimage'] = 1) or (Entity.FichierImage <> '');

      Entity.OldImageStockee := Entity.ImageStockee;
      Entity.OldFichierImage := Entity.FichierImage;
      Entity.OldHasImage := Entity.HasImage;

      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('select');
      qry.SQL.Add('  u.*');
      qry.SQL.Add('from');
      qry.SQL.Add('  univers u');
      qry.SQL.Add('  inner join parabd_univers pu on');
      qry.SQL.Add('    pu.id_univers = u.id_univers');
      qry.SQL.Add('where');
      qry.SQL.Add('  pu.source_parabd = 1 and pu.id_parabd = ?');
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      TDaoUniversLite.FillList(Entity.Univers, qry);
      Entity.UniversFull.Clear;
      Entity.UniversFull.AddRange(Entity.Serie.Univers);
      Entity.UniversFull.AddRange(Entity.Univers);

      qry.Close;
      qry.SQL.Text := 'select * from proc_auteurs(null, null, ?)';
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      TDaoAuteurLite.FillList(Entity.Auteurs, qry);

      TDaoSerieFull.Fill(Entity.Serie, ID_Serie);
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoParaBDFull.SaveToDatabase(Entity: TParaBDFull; UseTransaction: TUIBTransaction);
var
  S: string;
  qry: TUIBQuery;
  hg: IHourGlass;
  Stream: TStream;
  Auteur: TAuteurLite;
  Univers: TUniversLite;
begin
  inherited;
  hg := THourGlass.Create;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into parabd (');
    qry.SQL.Add('  id_parabd, titreparabd, annee, id_serie, categorieparabd, dedicace, numerote, anneecote,');
    qry.SQL.Add('  prixcote, gratuit, offert, dateachat, prix, stock, description, complet');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_parabd, :titreparabd, :annee, :id_serie, :categorieparabd, :dedicace, :numerote, :anneecote,');
    qry.SQL.Add('  :prixcote, :gratuit, :offert, :dateachat, :prix, :stock, :description, 1');
    qry.SQL.Add(') returning id_parabd');

    if IsEqualGUID(GUID_NULL, Entity.ID_ParaBD) then
      qry.Params.ByNameIsNull['id_parabd'] := True
    else
      qry.Params.ByNameAsString['id_parabd'] := GUIDToString(Entity.ID_ParaBD);
    if Entity.TitreParaBD = '' then
      qry.Params.ByNameIsNull['titreparabd'] := True
    else
      qry.Params.ByNameAsString['titreparabd'] := Entity.TitreParaBD;
    if Entity.AnneeEdition = 0 then
      qry.Params.ByNameIsNull['annee'] := True
    else
      qry.Params.ByNameAsInteger['annee'] := Entity.AnneeEdition;
    qry.Params.ByNameAsInteger['categorieparabd'] := Entity.CategorieParaBD.Value;
    qry.Params.ByNameAsBoolean['dedicace'] := Entity.Dedicace;
    qry.Params.ByNameAsBoolean['numerote'] := Entity.Numerote;
    if Entity.Description <> '' then
      qry.ParamsSetBlob('description', Entity.Description)
    else
      qry.Params.ByNameIsNull['description'] := True;
    qry.Params.ByNameAsBoolean['gratuit'] := Entity.Gratuit;
    qry.Params.ByNameAsBoolean['offert'] := Entity.Offert;

    if Entity.DateAchat = 0 then
      qry.Params.ByNameIsNull['dateachat'] := True
    else
      qry.Params.ByNameAsDate['dateachat'] := Trunc(Entity.DateAchat);
    if Entity.Prix = 0 then
      qry.Params.ByNameIsNull['prix'] := True
    else
      qry.Params.ByNameAsCurrency['prix'] := Entity.Prix;
    if (Entity.AnneeCote = 0) or (Entity.PrixCote = 0) then
    begin
      qry.Params.ByNameIsNull['anneecote'] := True;
      qry.Params.ByNameIsNull['prixcote'] := True;
    end
    else
    begin
      qry.Params.ByNameAsInteger['anneecote'] := Entity.AnneeCote;
      qry.Params.ByNameAsCurrency['prixcote'] := Entity.PrixCote;
    end;
    qry.Params.ByNameAsBoolean['stock'] := Entity.Stock;

    if Entity.Serie.RecInconnu or IsEqualGUID(Entity.Serie.ID_Serie, GUID_NULL) then
      qry.Params.ByNameIsNull['id_serie'] := True
    else
      qry.Params.ByNameAsString['id_serie'] := GUIDToString(Entity.Serie.ID_Serie);
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_ParaBD := StringToGUID(qry.Fields.AsString[0]);

    SupprimerToutDans('', 'auteurs_parabd', 'id_parabd', Entity.ID_ParaBD);
    qry.SQL.Clear;
    qry.SQL.Add('insert into auteurs_parabd (');
    qry.SQL.Add('  id_parabd, id_personne');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_album, :id_personne');
    qry.SQL.Add(') returning id_auteur_parabd');
    for Auteur in Entity.Auteurs do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_ParaBD);
      qry.Params.AsString[1] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;

    S := '';
    for Univers in Entity.Univers do
      AjoutString(S, QuotedStr(GUIDToString(Univers.ID)), ',');
    qry.SQL.Clear;
    qry.SQL.Add('update parabd_univers set source_parabd = 0');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_parabd = ?');
    if S <> '' then
      qry.SQL.Add('  and id_univers not in (' + S + ')');
    qry.Params.AsString[0] := GUIDToString(Entity.ID_ParaBD);
    qry.Execute;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into parabd_univers (');
    qry.SQL.Add('  id_parabd, id_univers, source_parabd');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_parabd, :id_univers, 1');
    qry.SQL.Add(') returning id_parabd_univers');
    qry.Prepare(True);
    for Univers in Entity.Univers do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_ParaBD);
      qry.Params.AsString[1] := GUIDToString(Univers.ID);
      qry.Execute;
      Univers.ID := StringToGUID(qry.Fields.AsString[0]);
    end;

    if not Entity.HasImage then
    begin
      qry.SQL.Text := 'update parabd set imageparabd = null, stockageparabd = 0, fichierparabd = null where id_parabd = :id_parabd';
      qry.Params.ByNameAsString['id_parabd'] := GUIDToString(Entity.ID_ParaBD);
      qry.Execute;
    end
    else if (Entity.OldFichierImage <> Entity.FichierImage) or (Entity.OldImageStockee <> Entity.ImageStockee) then
    begin
      if Entity.ImageStockee then
      begin
        qry.SQL.Text := 'update parabd set imageparabd = :imageparabd, stockageparabd = 1, fichierparabd = :fichierparabd where id_parabd = :id_parabd';
        if TPath.GetDirectoryName(Entity.FichierImage) = '' then
          Entity.FichierImage := TPath.Combine(RepImages, Entity.FichierImage);
        Stream := GetJPEGStream(Entity.FichierImage, -1, -1, False);
        try
          qry.ParamsSetBlob('imageparabd', Stream);
        finally
          Stream.Free;
        end;
        qry.Params.ByNameAsString['fichierparabd'] := TPath.GetFileName(Entity.FichierImage);
      end
      else
      begin
        qry.SQL.Text := 'select result from saveblobtofile(:chemin, :fichier, :blobcontent)';
        if TPath.GetDirectoryName(Entity.FichierImage) = '' then
          Stream := GetCouvertureStream(True, Entity.ID_ParaBD, -1, -1, False)
        else
          Stream := GetJPEGStream(Entity.FichierImage, -1, -1, False);
        try
          Entity.FichierImage := SearchNewFileName(RepImages, TPath.GetFileName(Entity.FichierImage), True);
          qry.Params.ByNameAsString['chemin'] := RepImages;
          qry.Params.ByNameAsString['fichier'] := Entity.FichierImage;
          qry.ParamsSetBlob('blobcontent', Stream);
        finally
          Stream.Free;
        end;
        qry.Open;

        qry.SQL.Text := 'update parabd set imageparabd = null, stockageparabd = 0, fichierparabd = :fichierparabd where id_parabd = :id_parabd';
        qry.Params.ByNameAsString['fichierparabd'] := Entity.FichierImage;
      end;
      qry.Params.ByNameAsString['id_parabd'] := GUIDToString(Entity.ID_ParaBD);
      qry.Execute;
    end;

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

{ TDaoUniversFull }

class function TDaoUniversFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryUniversFull;
end;

class procedure TDaoUniversFull.Fill(Entity: TUniversFull; const Reference: TGUID);
var
  qry: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_Univers := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nomunivers, id_univers_parent, description, siteweb from univers where id_univers = ?';
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.NomUnivers := qry.Fields.ByNameAsString['nomunivers'];
      TDaoUniversLite.Fill(Entity.UniversParent, StringToGUIDDef(qry.Fields.ByNameAsString['id_univers_parent'], GUID_NULL));
      Entity.Description := qry.Fields.ByNameAsString['description'];
      Entity.SiteWeb := qry.Fields.ByNameAsString['siteweb'];
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoUniversFull.SaveToDatabase(Entity: TUniversFull; UseTransaction: TUIBTransaction);
var
  qry: TUIBQuery;
begin
  inherited;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into univers (');
    qry.SQL.Add('  id_univers, nomunivers, id_univers_parent, description, siteweb');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_univers, :nomunivers, :id_univers_parent, :description, :siteweb');
    qry.SQL.Add(') returning id_univers');

    if IsEqualGUID(GUID_NULL, Entity.ID_Univers) then
      qry.Params.ByNameIsNull['id_univers'] := True
    else
      qry.Params.ByNameAsString['id_univers'] := GUIDToString(Entity.ID_Univers);
    qry.Params.ByNameAsString['nomunivers'] := Entity.NomUnivers;
    qry.Params.ByNameAsString['siteweb'] := Entity.SiteWeb;
    if Entity.Description <> '' then
      qry.ParamsSetBlob('description', Entity.Description)
    else
      qry.Params.ByNameIsNull['description'] := True;
    if IsEqualGUID(GUID_NULL, Entity.ID_UniversParent) then
      qry.Params.ByNameIsNull['id_univers_parent'] := True
    else
      qry.Params.ByNameAsString['id_univers_parent'] := GUIDToString(Entity.ID_UniversParent);
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Univers := StringToGUID(qry.Fields.AsString[0]);

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

{ TDaoCollectionFull }

class function TDaoCollectionFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCollectionFull;
end;

class procedure TDaoCollectionFull.Fill(Entity: TCollectionFull; const Reference: TGUID);
var
  qry: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_Collection := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nomcollection, id_editeur from collections where id_collection = ?';
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.NomCollection := qry.Fields.ByNameAsString['nomcollection'];
      TDaoEditeurLite.Fill(Entity.Editeur, StringToGUIDDef(qry.Fields.ByNameAsString['id_editeur'], GUID_NULL));
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoCollectionFull.SaveToDatabase(Entity: TCollectionFull; UseTransaction: TUIBTransaction);
var
  qry: TUIBQuery;
begin
  inherited;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into collections (');
    qry.SQL.Add('  id_collection, nomcollection, id_editeur');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_collection, :nomcollection, :id_editeur');
    qry.SQL.Add(') returning id_collection');

    if IsEqualGUID(GUID_NULL, Entity.ID_Collection) then
      qry.Params.ByNameIsNull['id_collection'] := True
    else
      qry.Params.ByNameAsString['id_collection'] := GUIDToString(Entity.ID_Collection);
    qry.Params.ByNameAsString['nomcollection'] := Entity.NomCollection;
    qry.Params.ByNameAsString['id_editeur'] := GUIDToString(Entity.ID_Editeur);
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Collection := StringToGUID(qry.Fields.AsString[0]);

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

{ TDaoEditeurFull }

class function TDaoEditeurFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditeurFull;
end;

class procedure TDaoEditeurFull.Fill(Entity: TEditeurFull; const Reference: TGUID);
var
  qry: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_Editeur := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nomediteur, siteweb from editeurs where id_editeur = ?';
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.NomEditeur := qry.Fields.ByNameAsString['nomediteur'];
      Entity.SiteWeb := qry.Fields.ByNameAsString['siteweb'];
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoEditeurFull.SaveToDatabase(Entity: TEditeurFull; UseTransaction: TUIBTransaction);
var
  qry: TUIBQuery;
begin
  inherited;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into editeurs (');
    qry.SQL.Add('  id_editeur, nomediteur, siteweb');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_editeur, :nomediteur, :siteweb');
    qry.SQL.Add(') returning id_editeur');

    if IsEqualGUID(GUID_NULL, Entity.ID_Editeur) then
      qry.Params.ByNameIsNull['id_editeur'] := True
    else
      qry.Params.ByNameAsString['id_editeur'] := GUIDToString(Entity.ID_Editeur);
    qry.Params.ByNameAsString['nomediteur'] := Entity.NomEditeur;
    qry.Params.ByNameAsString['siteweb'] := Entity.SiteWeb;
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Editeur := StringToGUID(qry.Fields.AsString[0]);

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

{ TDaoAuteurFull }

class function TDaoAuteurFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurFull;
end;

class procedure TDaoAuteurFull.Fill(Entity: TAuteurFull; const Reference: TGUID);
var
  qry: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_Auteur := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nompersonne, siteweb, biographie from personnes where id_personne = ?';
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.FetchBlobs := True;
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.NomAuteur := qry.Fields.ByNameAsString['nompersonne'];
      Entity.Biographie := qry.Fields.ByNameAsString['biographie'];
      Entity.SiteWeb := qry.Fields.ByNameAsString['siteweb'];
      qry.FetchBlobs := False;

      qry.SQL.Clear;
      // TitreSerie en premier pour forcer l'union à trier sur le titre
      qry.SQL.Add('select');
      qry.SQL.Add('  titreserie, al.id_serie');
      qry.SQL.Add('from');
      qry.SQL.Add('  vw_liste_albums al');
      qry.SQL.Add('  inner join auteurs au on');
      qry.SQL.Add('    al.id_album = au.id_album and au.id_personne = :id_personne');
      qry.SQL.Add('union');
      qry.SQL.Add('select');
      qry.SQL.Add('  titreserie, s.id_serie');
      qry.SQL.Add('from');
      qry.SQL.Add('  auteurs_series au');
      qry.SQL.Add('  inner join series s on');
      qry.SQL.Add('    s.id_serie = au.id_serie and au.id_personne = :id_personne');
      qry.SQL.Add('union');
      qry.SQL.Add('select');
      qry.SQL.Add('  titreserie, p.id_serie');
      qry.SQL.Add('from');
      qry.SQL.Add('  auteurs_parabd ap');
      qry.SQL.Add('  inner join vw_liste_parabd p on');
      qry.SQL.Add('    ap.id_parabd = p.id_parabd and ap.id_personne = :id_personne');
      qry.Params.ByNameAsString['id_personne'] := GUIDToString(Reference);
      qry.Open;
      while not qry.Eof do
      begin
        if qry.Fields.IsNull[1] then
          Entity.Series.Insert(0, TDaoSerieFull.getInstance(GUID_NULL, Entity.ID_Auteur, True))
        else
          Entity.Series.Add(TDaoSerieFull.getInstance(StringToGUID(qry.Fields.AsString[1]), Entity.ID_Auteur, True));
        qry.Next;
      end;
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoAuteurFull.SaveToDatabase(Entity: TAuteurFull; UseTransaction: TUIBTransaction);
var
  qry: TUIBQuery;
begin
  inherited;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into personnes (');
    qry.SQL.Add('  id_personne, nompersonne, siteweb, biographie');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_personne, :nompersonne, :siteweb, :biographie');
    qry.SQL.Add(') returning id_personne');

    if IsEqualGUID(GUID_NULL, Entity.ID_Auteur) then
      qry.Params.ByNameIsNull['id_personne'] := True
    else
      qry.Params.ByNameAsString['id_personne'] := GUIDToString(Entity.ID_Auteur);
    qry.Params.ByNameAsString['nompersonne'] := Entity.NomAuteur;
    qry.Params.ByNameAsString['siteweb'] := Entity.SiteWeb;
    if Entity.Biographie <> '' then
      qry.ParamsSetBlob('biographie', Entity.Biographie)
    else
      qry.Params.ByNameIsNull['biographie'] := True;
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Auteur := StringToGUID(qry.Fields.AsString[0]);

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

{ TDaoEditionFull }

class constructor TDaoEditionFull.Create;
begin
  TEditionFull.RegisterInitEvent(InitEdition);
end;

class destructor TDaoEditionFull.Destroy;
begin
  TEditionFull.UnregisterInitEvent(InitEdition);
end;

class function TDaoEditionFull.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditionFull;
end;

class procedure TDaoEditionFull.Fill(Entity: TEditionFull; const Reference: TGUID);
var
  qry: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Entity.ID_Edition := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);

    TfrmConsole.AddEvent(Self.UnitName, 'TDaoEditionFull.Fill > données de base - ' + GUIDToString(Reference));
    qry.SQL.Clear;
    qry.SQL.Add('select');
    qry.SQL.Add('  id_edition, id_album, e.id_editeur, e.id_collection, nomcollection, anneeedition, prix, vo,');
    qry.SQL.Add('  couleur, isbn, dedicace, prete, stock, offert, gratuit, nombredepages, dateachat, notes,');
    qry.SQL.Add('  anneecote, prixcote, numeroperso, etat, le.libelle as setat, reliure, lr.libelle as sreliure,');
    qry.SQL.Add('  orientation, lo.libelle as sorientation, formatedition, lf.libelle as sformatedition,');
    qry.SQL.Add('  typeedition, lte.libelle as stypeedition, senslecture, lsl.libelle as ssenslecture');
    qry.SQL.Add('from');
    qry.SQL.Add('  editions e');
    qry.SQL.Add('  left join collections c on');
    qry.SQL.Add('    e.id_collection = c.id_collection');
    qry.SQL.Add('  left join listes le on');
    qry.SQL.Add('    (le.ref = e.etat and le.categorie = 1)');
    qry.SQL.Add('  left join listes lr on');
    qry.SQL.Add('    (lr.ref = e.reliure and lr.categorie = 2)');
    qry.SQL.Add('  left join listes lte on');
    qry.SQL.Add('    (lte.ref = e.typeedition and lte.categorie = 3)');
    qry.SQL.Add('  left join listes lo on');
    qry.SQL.Add('    (lo.ref = e.orientation and lo.categorie = 4)');
    qry.SQL.Add('  left join listes lf on');
    qry.SQL.Add('    (lf.ref = e.formatedition and lf.categorie = 5)');
    qry.SQL.Add('  left join listes lsl on');
    qry.SQL.Add('    (lsl.ref = e.senslecture and lsl.categorie = 8)');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_edition = ?');
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.FetchBlobs := True;
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.ID_Album := StringToGUIDDef(qry.Fields.ByNameAsString['id_album'], GUID_NULL);
      TDaoEditeurFull.Fill(Entity.Editeur, StringToGUIDDef(qry.Fields.ByNameAsString['id_editeur'], GUID_NULL));
      TDaoCollectionLite.Fill(Entity.Collection, qry);
      Entity.AnneeEdition := qry.Fields.ByNameAsInteger['anneeedition'];
      Entity.Prix := qry.Fields.ByNameAsCurrency['prix'];
      Entity.VO := qry.Fields.ByNameAsBoolean['vo'];
      Entity.Couleur := qry.Fields.ByNameAsBoolean['couleur'];
      Entity.Dedicace := qry.Fields.ByNameAsBoolean['dedicace'];
      Entity.Offert := qry.Fields.ByNameAsBoolean['offert'];
      Entity.Gratuit := qry.Fields.ByNameAsBoolean['gratuit'];
      Entity.Prete := qry.Fields.ByNameAsBoolean['prete'];
      Entity.Stock := qry.Fields.ByNameAsBoolean['stock'];
      Entity.ISBN := FormatISBN(Trim(qry.Fields.ByNameAsString['isbn']));
      Entity.TypeEdition := MakeOption(qry.Fields.ByNameAsInteger['typeedition'], qry.Fields.ByNameAsString['stypeedition']);
      Entity.NombreDePages := qry.Fields.ByNameAsInteger['nombredepages'];
      Entity.Etat := MakeOption(qry.Fields.ByNameAsInteger['etat'], qry.Fields.ByNameAsString['setat']);
      Entity.Reliure := MakeOption(qry.Fields.ByNameAsInteger['reliure'], qry.Fields.ByNameAsString['sreliure']);
      Entity.Orientation := MakeOption(qry.Fields.ByNameAsInteger['orientation'], qry.Fields.ByNameAsString['sorientation']);
      Entity.FormatEdition := MakeOption(qry.Fields.ByNameAsInteger['formatedition'], qry.Fields.ByNameAsString['sformatedition']);
      Entity.SensLecture := MakeOption(qry.Fields.ByNameAsInteger['senslecture'], qry.Fields.ByNameAsString['ssenslecture']);
      Entity.DateAchat := qry.Fields.ByNameAsDate['dateachat'];
      Entity.Notes := qry.Fields.ByNameAsString['notes'];
      Entity.AnneeCote := qry.Fields.ByNameAsInteger['anneecote'];
      Entity.PrixCote := qry.Fields.ByNameAsCurrency['prixcote'];
      Entity.NumeroPerso := qry.Fields.ByNameAsString['numeroperso'];
      TfrmConsole.AddEvent(Self.UnitName, 'TDaoEditionFull.Fill < données de base - ' + GUIDToString(Reference));

      TfrmConsole.AddEvent(Self.UnitName, 'TDaoEditionFull.Fill > images - ' + GUIDToString(Reference));
      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('select');
      qry.SQL.Add('  id_couverture, fichiercouverture, stockagecouverture, categorieimage, l.libelle as scategorieimage');
      qry.SQL.Add('from');
      qry.SQL.Add('  couvertures c');
      qry.SQL.Add('  left join listes l on');
      qry.SQL.Add('    (c.categorieimage = l.ref and l.categorie = 6)');
      qry.SQL.Add('where');
      qry.SQL.Add('  id_edition = ?');
      qry.SQL.Add('order by');
      qry.SQL.Add('  l.ordre nulls last, c.ordre');
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Edition);
      qry.Open;
      TDaoCouvertureLite.FillList(Entity.Couvertures, qry);
      TfrmConsole.AddEvent(Self.UnitName, 'TDaoEditionFull.Fill < images - ' + GUIDToString(Reference));
    end;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoEditionFull.FillList(EntitiesList: TObjectList<TEditionFull>; const Reference: TGUID; Stock: Integer);
var
  qry: TUIBQuery;
begin
  EntitiesList.Clear;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);

    TfrmConsole.AddEvent(Self.UnitName, '> TDaoEditionFull.FillList - ' + GUIDToString(Reference));
    qry.SQL.Text := 'select id_edition from editions where id_album = ?';
    if Stock in [0, 1] then
      qry.SQL.Add('  and e.stock = :stock');
    qry.Params.AsString[0] := GUIDToString(Reference);
    if Stock in [0, 1] then
      qry.Params.AsInteger[1] := Stock;
    qry.Open;
    while not qry.Eof do
    begin
      EntitiesList.Add(getInstance(StringToGUID(qry.Fields.AsString[0])));
      qry.Next;
    end;
    TfrmConsole.AddEvent(Self.UnitName, '< TDaoEditionFull.FillList - ' + GUIDToString(Reference));
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoEditionFull.FusionneInto(Source, Dest: TObjectList<TEditionFull>);
type
  OptionFusion = record
    ImporterImages: Boolean;
    RemplacerImages: Boolean;
  end;
var
  FusionsGUID: array of TGUID;
  OptionsFusion: array of OptionFusion;
  Edition: TEditionFull;
  i, j: Integer;
begin
  if Source.Count = 0 then
    Exit;

  SetLength(FusionsGUID, Source.Count);
  ZeroMemory(FusionsGUID, Length(FusionsGUID) * SizeOf(TGUID));
  SetLength(OptionsFusion, Source.Count);
  ZeroMemory(OptionsFusion, Length(OptionsFusion) * SizeOf(OptionFusion));
  // même si la destination n'a aucune données, on peut choisir de ne rien y importer
  // if Dest.Editions.Count > 0 then
  for i := 0 to Pred(Source.Count) do
    with TfrmFusionEditions.Create(nil) do
      try
        SetEditionSrc(Source[i]);
        // SetEditions doit être fait après SetEditionSrc
        SetEditions(Dest, FusionsGUID);

        case ShowModal of
          mrCancel:
            FusionsGUID[i] := GUID_FULL;
          mrOk:
            if CheckBox1.Checked then
              FusionsGUID[i] := GUID_NULL
            else
              FusionsGUID[i] := TEditionFull(lbEditions.Items.Objects[lbEditions.ItemIndex]).ID_Edition;
        end;
        OptionsFusion[i].ImporterImages := CheckBox2.Checked and (Source[i].Couvertures.Count > 0);
        OptionsFusion[i].RemplacerImages := CheckBox3.Checked and OptionsFusion[i].ImporterImages;
      finally
        Free;
      end;

  Edition := nil;
  for i := 0 to Pred(Source.Count) do
  begin
    if IsEqualGUID(FusionsGUID[i], GUID_FULL) then
      Continue;
    if IsEqualGUID(FusionsGUID[i], GUID_NULL) then
      Dest.Add(TFactoryEditionFull.getInstance)
    else
    begin
      Edition := nil;
      for j := 0 to Pred(Dest.Count) do
        if IsEqualGUID(Dest[j].ID_Edition, FusionsGUID[i]) then
        begin
          Edition := Dest[j];
          Break;
        end;
    end;
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

class procedure TDaoEditionFull.InitEdition(Entity: TEntity);
begin
  (Entity as TEditionFull).TypeEdition := TDaoListe.DefaultTypeEdition;
  (Entity as TEditionFull).Etat := TDaoListe.DefaultEtat;
  (Entity as TEditionFull).Reliure := TDaoListe.DefaultReliure;
  (Entity as TEditionFull).FormatEdition := TDaoListe.DefaultFormatEdition;
  (Entity as TEditionFull).Orientation := TDaoListe.DefaultOrientation;
  (Entity as TEditionFull).SensLecture := TDaoListe.DefaultSensLecture;
end;

class procedure TDaoEditionFull.SaveToDatabase(Entity: TEditionFull; UseTransaction: TUIBTransaction);
var
  PC: TCouvertureLite;
  hg: IHourGlass;
  qry: TUIBQuery;
  S: string;
  i: Integer;
  Stream: TStream;
  qry1, qry2, qry3, qry4, qry5, qry6: TUIBQuery;
  FichiersImages: TStringList;
begin
  inherited;
  FichiersImages := TStringList.Create;
  hg := THourGlass.Create;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into editions (');
    qry.SQL.Add('  id_edition, id_album, id_editeur, id_collection, anneeedition, prix, vo, typeedition,');
    qry.SQL.Add('  couleur, isbn, stock, dedicace, offert, gratuit, etat, reliure, orientation, formatedition,');
    qry.SQL.Add('  dateachat, notes, nombredepages, anneecote, prixcote, numeroperso, senslecture');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_edition, :id_album, :id_editeur, :id_collection, :anneeedition, :prix, :vo, :typeedition,');
    qry.SQL.Add('  :couleur, :isbn, :stock, :dedicace, :offert, :gratuit, :etat, :reliure, :orientation, :formatedition,');
    qry.SQL.Add('  :dateachat, :notes, :nombredepages, :anneecote, :prixcote, :numeroperso, :senslecture');
    qry.SQL.Add(') returning id_edition');

    if IsEqualGUID(GUID_NULL, Entity.ID_Edition) then
      qry.Params.ByNameIsNull['id_edition'] := True
    else
      qry.Params.ByNameAsString['id_edition'] := GUIDToString(Entity.ID_Edition);
    qry.Params.ByNameAsString['id_album'] := GUIDToString(Entity.ID_Album);
    qry.Params.ByNameAsString['id_editeur'] := GUIDToString(Entity.Editeur.ID_Editeur);
    qry.Params.ByNameAsString['id_collection'] := GUIDToString(Entity.Collection.ID);
    if Entity.AnneeEdition = 0 then
      qry.Params.ByNameIsNull['anneeedition'] := True
    else
      qry.Params.ByNameAsInteger['anneeedition'] := Entity.AnneeEdition;
    if Entity.NombreDePages = 0 then
      qry.Params.ByNameIsNull['nombredepages'] := True
    else
      qry.Params.ByNameAsInteger['nombredepages'] := Entity.NombreDePages;
    if Entity.Prix = 0 then
      qry.Params.ByNameIsNull['prix'] := True
    else
      qry.Params.ByNameAsCurrency['prix'] := Entity.Prix;
    qry.Params.ByNameAsBoolean['vo'] := Entity.VO;
    qry.Params.ByNameAsBoolean['couleur'] := Entity.Couleur;
    qry.Params.ByNameAsString['isbn'] := ClearISBN(Entity.ISBN);
    qry.Params.ByNameAsBoolean['stock'] := Entity.Stock;
    qry.Params.ByNameAsBoolean['dedicace'] := Entity.Dedicace;
    qry.Params.ByNameAsBoolean['gratuit'] := Entity.Gratuit;
    qry.Params.ByNameAsBoolean['offert'] := Entity.Offert;
    qry.Params.ByNameAsInteger['typeedition'] := Entity.TypeEdition.Value;
    qry.Params.ByNameAsInteger['etat'] := Entity.Etat.Value;
    qry.Params.ByNameAsInteger['reliure'] := Entity.Reliure.Value;
    qry.Params.ByNameAsInteger['orientation'] := Entity.Orientation.Value;
    qry.Params.ByNameAsInteger['formatedition'] := Entity.FormatEdition.Value;
    qry.Params.ByNameAsInteger['senslecture'] := Entity.SensLecture.Value;
    if Entity.DateAchat = 0 then
      qry.Params.ByNameIsNull['dateachat'] := True
    else
      qry.Params.ByNameAsDate['dateachat'] := Trunc(Entity.DateAchat);
    if (Entity.AnneeCote = 0) or (Entity.PrixCote = 0) then
    begin
      qry.Params.ByNameIsNull['anneecote'] := True;
      qry.Params.ByNameIsNull['prixcote'] := True;
    end
    else
    begin
      qry.Params.ByNameAsInteger['anneecote'] := Entity.AnneeCote;
      qry.Params.ByNameAsCurrency['prixcote'] := Entity.PrixCote;
    end;
    qry.Params.ByNameAsString['numeroperso'] := Entity.NumeroPerso;

    if Entity.Notes <> '' then
      qry.ParamsSetBlob('notes', Entity.Notes)
    else
      qry.Params.ByNameIsNull['notes'] := True;
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Edition := StringToGUID(qry.Fields.AsString[0]);

    S := '';
    for PC in Entity.Couvertures do
      if not IsEqualGUID(PC.ID, GUID_NULL) then
        AjoutString(S, QuotedStr(GUIDToString(PC.ID)), ',');

    qry.SQL.Clear;
    qry.SQL.Add('delete from couvertures');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_edition = ?');
    if S <> '' then
      qry.SQL.Add(' and id_couverture not in (' + S + ')');
    qry.Params.AsString[0] := GUIDToString(Entity.ID_Edition);
    qry.Execute;

    qry1 := TUIBQuery.Create(nil);
    qry2 := TUIBQuery.Create(nil);
    qry3 := TUIBQuery.Create(nil);
    qry4 := TUIBQuery.Create(nil);
    qry5 := TUIBQuery.Create(nil);
    qry6 := TUIBQuery.Create(nil);
    try
      qry1.Transaction := qry.Transaction;
      qry2.Transaction := qry.Transaction;
      qry3.Transaction := qry.Transaction;
      qry4.Transaction := qry.Transaction;
      qry5.Transaction := qry.Transaction;
      qry6.Transaction := qry.Transaction;

      qry1.SQL.Clear;
      qry1.SQL.Add('insert into couvertures (');
      qry1.SQL.Add('  id_edition, id_album, fichiercouverture, stockagecouverture, ordre, categorieimage');
      qry1.SQL.Add(') values (');
      qry1.SQL.Add('  :id_edition, :id_album, :fichiercouverture, 0, :ordre, :categorieimage');
      qry1.SQL.Add(') returning id_couverture');

      qry6.SQL.Text := 'select result from saveblobtofile(:Chemin, :Fichier, :BlobContent)';

      qry2.SQL.Clear;
      qry2.SQL.Add('insert into couvertures (');
      qry2.SQL.Add('  id_edition, id_album, fichiercouverture, stockagecouverture, ordre, imagecouverture, categorieimage');
      qry2.SQL.Add(') values (');
      qry2.SQL.Add('  :id_edition, :id_album, :fichiercouverture, 1, :ordre, :imagecouverture, :categorieimage');
      qry2.SQL.Add(') returning id_couverture');

      qry3.SQL.Text := 'update couvertures set imagecouverture = :imagecouverture, stockagecouverture = 1 where id_couverture = :id_couverture';

      qry4.SQL.Text := 'update couvertures set imagecouverture = null, stockagecouverture = 0 where id_couverture = :id_couverture';

      qry5.SQL.Clear;
      qry5.SQL.Add('update couvertures set');
      qry5.SQL.Add('  fichiercouverture = :fichiercouverture, ordre = :ordre, categorieimage = :categorieimage');
      qry5.SQL.Add('where');
      qry5.SQL.Add('  id_couverture = :id_couverture');

      for PC in Entity.Couvertures do
        if IsEqualGUID(PC.ID, GUID_NULL) then
        begin // nouvelles couvertures
          if (not PC.NewStockee) then
          begin // couvertures liées (q1)
            PC.OldNom := PC.NewNom;
            PC.NewNom := SearchNewFileName(RepImages, ExtractFileName(PC.NewNom), True);
            qry6.Params.ByNameAsString['chemin'] := RepImages;
            qry6.Params.ByNameAsString['fichier'] := PC.NewNom;
            Stream := GetJPEGStream(PC.OldNom, -1, -1, False);
            try
              qry6.ParamsSetBlob('blobcontent', Stream);
            finally
              Stream.Free;
            end;
            qry6.Open;

            qry1.Params.ByNameAsString['id_edition'] := GUIDToString(Entity.ID_Edition);
            qry1.Params.ByNameAsString['id_album'] := GUIDToString(Entity.ID_Album);
            qry1.Params.ByNameAsString['fichiercouverture'] := PC.NewNom;
            qry1.Params.ByNameAsInteger['ordre'] := Entity.Couvertures.IndexOf(PC);
            qry1.Params.ByNameAsInteger['categorieimage'] := PC.Categorie;
            qry1.Execute;
            PC.ID := StringToGUID(qry.Fields.AsString[0]);
          end
          else if TFile.Exists(PC.NewNom) then
          begin // couvertures stockées (q2)
            qry2.Params.ByNameAsString['id_edition'] := GUIDToString(Entity.ID_Edition);
            qry2.Params.ByNameAsString['id_album'] := GUIDToString(Entity.ID_Album);
            qry2.Params.ByNameAsString['fichiercouverture'] := TPath.GetFileNameWithoutExtension(PC.NewNom);
            qry2.Params.ByNameAsInteger['ordre'] := Entity.Couvertures.IndexOf(PC);
            Stream := GetJPEGStream(PC.NewNom);
            try
              qry2.ParamsSetBlob('imagecouverture', Stream);
            finally
              Stream.Free;
            end;
            qry2.Params.ByNameAsInteger['categorieimage'] := PC.Categorie;
            qry2.Execute;
            PC.ID := StringToGUID(qry.Fields.AsString[0]);
          end;
        end
        else
        begin // ancienne couverture
          if PC.OldStockee <> PC.NewStockee then
          begin // changement de stockage
            Stream := GetCouvertureStream(False, PC.ID, -1, -1, False);
            try
              if (PC.NewStockee) then
              begin // conversion couvertures liées en stockées (q3)
                qry3.ParamsSetBlob('imagecouverture', Stream);
                qry3.Params.ByNameAsString['id_couverture'] := GUIDToString(PC.ID);
                qry3.Execute;
                if TPath.GetDirectoryName(PC.NewNom) = '' then
                  FichiersImages.Add(TPath.Combine(RepImages, PC.NewNom))
                else
                  FichiersImages.Add(PC.NewNom);
                PC.NewNom := TPath.GetFileNameWithoutExtension(PC.NewNom);
              end
              else
              begin // conversion couvertures stockées en liées
                PC.NewNom := SearchNewFileName(RepImages, PC.NewNom + '.jpg', True);
                qry6.Params.ByNameAsString['chemin'] := RepImages;
                qry6.Params.ByNameAsString['fichier'] := PC.NewNom;
                qry6.ParamsSetBlob('blobcontent', Stream);
                qry6.Open;

                qry4.Params.ByNameAsString['id_couverture'] := GUIDToString(PC.ID);
                qry4.Execute;
              end;
            finally
              Stream.Free;
            end;
          end;
          // couvertures renommées, réordonnées, changée de catégorie, etc (q5)
          // obligatoire pour les changement de stockage
          qry5.Params.ByNameAsString['fichiercouverture'] := PC.NewNom;
          qry5.Params.ByNameAsInteger['ordre'] := Entity.Couvertures.IndexOf(PC);
          qry5.Params.ByNameAsInteger['categorieimage'] := PC.Categorie;
          qry5.Params.ByNameAsString['id_couverture'] := GUIDToString(PC.ID);
          qry5.Execute;
        end;
    finally
      FreeAndNil(qry1);
      FreeAndNil(qry2);
      FreeAndNil(qry3);
      FreeAndNil(qry4);
      FreeAndNil(qry5);
      FreeAndNil(qry6);
    end;
    qry.Transaction.Commit;

    if FichiersImages.Count > 0 then
    begin
      qry.Transaction.StartTransaction;
      qry.SQL.Text := 'select * from deletefile(:fichier)';
      qry.Prepare(True);
      for i := 0 to Pred(FichiersImages.Count) do
      begin
        qry.Params.AsString[0] := Copy(FichiersImages[i], 1, qry.Params.MaxStrLen[0]);
        qry.Open;
        if qry.Fields.AsInteger[0] <> 0 then
          ShowMessage(FichiersImages[i] + #13#13 + SysErrorMessage(qry.Fields.AsInteger[0]));
      end;
      qry.Transaction.Commit;
    end;
  finally
    FichiersImages.Free;
    qry.Free;
  end;
end;

class procedure TDaoSerieFull.Fill(Entity: TSerieFull; const Reference: TGUID);
begin
  Fill(Entity, Reference, GUID_NULL, False);
end;

class procedure TDaoSerieFull.Fill(Entity: TSerieFull; const Reference, IdAuteurFiltre: TGUID);
begin
  Fill(Entity, Reference, IdAuteurFiltre, False);
end;

class constructor TDaoSerieFull.Create;
begin
  TSerieFull.RegisterInitEvent(InitSerie);
end;

class destructor TDaoSerieFull.Destroy;
begin
  TSerieFull.UnregisterInitEvent(InitSerie);
end;

class function TDaoSerieFull.FactoryClass: TFactoryClass;
begin
  Result := TFactorySerieFull;
end;

class procedure TDaoSerieFull.Fill(Entity: TSerieFull; const Reference, IdAuteurFiltre: TGUID; ForceLoad: Boolean);
var
  qry: TUIBQuery;
begin
  inherited Fill(Entity, Reference);
  if IsEqualGUID(Reference, GUID_NULL) and (not ForceLoad) then
    Exit;
  Entity.ID_Serie := Reference;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.FetchBlobs := True;
    qry.SQL.Clear;
    qry.SQL.Add('select');
    qry.SQL.Add('  s.titreserie, coalesce(s.terminee, -1) as terminee, s.sujetserie, s.remarquesserie, s.siteweb, s.complete,');
    qry.SQL.Add('  s.nb_albums, s.id_editeur, s.id_collection, c.nomcollection, s.suivresorties, s.suivremanquants,');
    qry.SQL.Add('  coalesce(s.vo, -1) as vo, coalesce(s.couleur, -1) as couleur,');
    qry.SQL.Add('  coalesce(s.etat, -1) as etat, le.libelle as setat, coalesce(s.reliure, -1) as reliure,');
    qry.SQL.Add('  lr.libelle as sreliure, coalesce(s.orientation, -1) as orientation, lo.libelle as sorientation,');
    qry.SQL.Add('  coalesce(s.formatedition, -1) as formatedition, lf.libelle as sformatedition,');
    qry.SQL.Add('  coalesce(s.typeedition, -1) as typeedition, lte.libelle as stypeedition,');
    qry.SQL.Add('  coalesce(s.senslecture, -1) as senslecture, lsl.libelle as ssenslecture,');
    qry.SQL.Add('  s.notation');
    qry.SQL.Add('from');
    qry.SQL.Add('  series s');
    qry.SQL.Add('  left join collections c on');
    qry.SQL.Add('    s.id_collection = c.id_collection');
    qry.SQL.Add('  left join listes le on');
    qry.SQL.Add('    (le.ref = s.etat and le.categorie = 1)');
    qry.SQL.Add('  left join listes lr on');
    qry.SQL.Add('    (lr.ref = s.reliure and lr.categorie = 2)');
    qry.SQL.Add('  left join listes lte on');
    qry.SQL.Add('    (lte.ref = s.typeedition and lte.categorie = 3)');
    qry.SQL.Add('  left join listes lo on');
    qry.SQL.Add('    (lo.ref = s.orientation and lo.categorie = 4)');
    qry.SQL.Add('  left join listes lf on');
    qry.SQL.Add('    (lf.ref = s.formatedition and lf.categorie = 5)');
    qry.SQL.Add('  left join listes lsl on');
    qry.SQL.Add('    (lsl.ref = s.senslecture and lsl.categorie = 8)');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_serie = ?');
    qry.Params.AsString[0] := GUIDToString(Reference);
    qry.Open;
    Entity.RecInconnu := qry.Eof;

    if not Entity.RecInconnu then
    begin
      Entity.TitreSerie := qry.Fields.ByNameAsString['titreserie'];
      Entity.Notation := qry.Fields.ByNameAsSmallint['notation'];
      if Entity.Notation = 0 then
        Entity.Notation := 900;
      Entity.Terminee := qry.Fields.ByNameAsInteger['terminee'];
      Entity.VO := qry.Fields.ByNameAsInteger['vo'];
      Entity.Couleur := qry.Fields.ByNameAsInteger['couleur'];
      Entity.SuivreSorties := Entity.RecInconnu or qry.Fields.ByNameAsBoolean['suivresorties'];
      Entity.Complete := qry.Fields.ByNameAsBoolean['complete'];
      Entity.SuivreManquants := Entity.RecInconnu or qry.Fields.ByNameAsBoolean['suivremanquants'];
      Entity.NbAlbums := qry.Fields.ByNameAsInteger['nb_albums'];
      Entity.Sujet := qry.Fields.ByNameAsString['sujetserie'];
      Entity.Notes := qry.Fields.ByNameAsString['remarquesserie'];
      Entity.SiteWeb := qry.Fields.ByNameAsString['siteweb'];

      Entity.TypeEdition := MakeOption(qry.Fields.ByNameAsInteger['typeedition'], qry.Fields.ByNameAsString['stypeedition']);
      Entity.Etat := MakeOption(qry.Fields.ByNameAsInteger['etat'], qry.Fields.ByNameAsString['setat']);
      Entity.Reliure := MakeOption(qry.Fields.ByNameAsInteger['reliure'], qry.Fields.ByNameAsString['sreliure']);
      Entity.Orientation := MakeOption(qry.Fields.ByNameAsInteger['orientation'], qry.Fields.ByNameAsString['sorientation']);
      Entity.FormatEdition := MakeOption(qry.Fields.ByNameAsInteger['formatedition'], qry.Fields.ByNameAsString['sformatedition']);
      Entity.SensLecture := MakeOption(qry.Fields.ByNameAsInteger['senslecture'], qry.Fields.ByNameAsString['ssenslecture']);

      TDaoEditeurFull.Fill(Entity.Editeur, StringToGUIDDef(qry.Fields.ByNameAsString['id_editeur'], GUID_NULL));
      TDaoCollectionLite.Fill(Entity.Collection, qry);
      qry.FetchBlobs := False;

      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('select');
      qry.SQL.Add('  u.*');
      qry.SQL.Add('from');
      qry.SQL.Add('  univers u');
      qry.SQL.Add('  inner join series_univers su on');
      qry.SQL.Add('    su.id_univers = u.id_univers');
      qry.SQL.Add('where');
      qry.SQL.Add('  su.id_serie = ?');
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      TDaoUniversLite.FillList(Entity.Univers, qry);

      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('select');
      qry.SQL.Add('  g.id_genre, g.genre');
      qry.SQL.Add('from');
      qry.SQL.Add('  genreseries s');
      qry.SQL.Add('  inner join genres g on');
      qry.SQL.Add('    g.id_genre = s.id_genre');
      qry.SQL.Add('where');
      qry.SQL.Add('  s.id_serie = ?');
      qry.SQL.Add('order by');
      qry.SQL.Add('  g.genre');
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      while not qry.Eof do
      begin
        Entity.Genres.Values[qry.Fields.AsString[0]] := qry.Fields.AsString[1];
        qry.Next;
      end;

      qry.Close;
      qry.SQL.Text := 'select * from proc_auteurs(null, ?, null)';
      qry.Params.AsString[0] := GUIDToString(Reference);
      qry.Open;
      TDaoAuteurLite.Prepare(qry);
      try
        while not qry.Eof do
        begin
          case TMetierAuteur(qry.Fields.ByNameAsInteger['metier']) of
            maScenariste:
              Entity.Scenaristes.Add(TDaoAuteurLite.Make(qry));
            maDessinateur:
              Entity.Dessinateurs.Add(TDaoAuteurLite.Make(qry));
            maColoriste:
              Entity.Coloristes.Add(TDaoAuteurLite.Make(qry));
          end;
          qry.Next;
        end;
      finally
        TDaoAuteurLite.Unprepare;
      end;
    end;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select');
    qry.SQL.Add('  id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie, notation');
    qry.SQL.Add('from');
    qry.SQL.Add('  albums');
    qry.SQL.Add('where');
    if IsEqualGUID(Reference, GUID_NULL) then
      qry.SQL.Add('  (id_serie is null or id_serie = ?)')
    else
      qry.SQL.Add('  id_serie = ?');
    if not IsEqualGUID(IdAuteurFiltre, GUID_NULL) then
      qry.SQL.Add('  and id_album in (select id_album from auteurs where id_personne = ?)');
    qry.SQL.Add('order by');
    qry.SQL.Add('  horsserie nulls first, integrale nulls first, tome nulls first, anneeparution, moisparution');
    qry.Params.AsString[0] := GUIDToString(Reference);
    if not IsEqualGUID(IdAuteurFiltre, GUID_NULL) then
      qry.Params.AsString[1] := GUIDToString(IdAuteurFiltre);
    qry.Open;
    TDaoAlbumLite.FillList(Entity.Albums, qry);

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
    qry.Transaction.Free;
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

class procedure TDaoSerieFull.InitSerie(Entity: TEntity);
begin
  (Entity as TSerieFull).TypeEdition := TDaoListe.DefaultTypeEdition;
  (Entity as TSerieFull).Etat := TDaoListe.DefaultEtat;
  (Entity as TSerieFull).Reliure := TDaoListe.DefaultReliure;
  (Entity as TSerieFull).FormatEdition := TDaoListe.DefaultFormatEdition;
  (Entity as TSerieFull).Orientation := TDaoListe.DefaultOrientation;
  (Entity as TSerieFull).SensLecture := TDaoListe.DefaultSensLecture;
end;

class procedure TDaoSerieFull.SaveToDatabase(Entity: TSerieFull; UseTransaction: TUIBTransaction);
var
  qry: TUIBQuery;
  S, genre: string;
  Auteur: TAuteurLite;
  Univers: TUniversLite;
begin
  inherited;
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := UseTransaction;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into series (');
    qry.SQL.Add('  id_serie, titreserie, terminee, suivresorties, complete, suivremanquants, siteweb, id_editeur,');
    qry.SQL.Add('  id_collection, sujetserie, remarquesserie, nb_albums, vo, couleur, etat, reliure, typeedition,');
    qry.SQL.Add('  orientation, formatedition, senslecture');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_serie, :titreserie, :terminee, :suivresorties, :complete, :suivremanquants, :siteweb, :id_editeur,');
    qry.SQL.Add('  :id_collection, :sujetserie, :remarquesserie, :nb_albums, :vo, :couleur, :etat, :reliure, :typeedition,');
    qry.SQL.Add('  :orientation, :formatedition, :senslecture');
    qry.SQL.Add(') returning id_serie');

    if IsEqualGUID(GUID_NULL, Entity.ID_Serie) then
      qry.Params.ByNameIsNull['id_serie'] := True
    else
      qry.Params.ByNameAsString['id_serie'] := GUIDToString(Entity.ID_Serie);
    qry.Params.ByNameAsString['titreserie'] := Entity.TitreSerie;
    if TCheckBoxState(Entity.Terminee) = cbGrayed then
      qry.Params.ByNameIsNull['terminee'] := True
    else
      qry.Params.ByNameAsInteger['terminee'] := Entity.Terminee;
    if TCheckBoxState(Entity.VO) = cbGrayed then
      qry.Params.ByNameIsNull['vo'] := True
    else
      qry.Params.ByNameAsInteger['vo'] := Entity.VO;
    if TCheckBoxState(Entity.Couleur) = cbGrayed then
      qry.Params.ByNameIsNull['couleur'] := True
    else
      qry.Params.ByNameAsInteger['couleur'] := Entity.Couleur;
    qry.Params.ByNameAsInteger['typeedition'] := Entity.TypeEdition.Value;
    qry.Params.ByNameAsInteger['etat'] := Entity.Etat.Value;
    qry.Params.ByNameAsInteger['reliure'] := Entity.Reliure.Value;
    qry.Params.ByNameAsInteger['orientation'] := Entity.Orientation.Value;
    qry.Params.ByNameAsInteger['formatedition'] := Entity.FormatEdition.Value;
    qry.Params.ByNameAsInteger['senslecture'] := Entity.SensLecture.Value;
    qry.Params.ByNameAsBoolean['suivresorties'] := Entity.SuivreSorties;
    qry.Params.ByNameAsBoolean['complete'] := Entity.Complete;
    qry.Params.ByNameAsBoolean['suivremanquants'] := Entity.SuivreManquants;
    if Entity.NbAlbums > 0 then
      qry.Params.ByNameAsInteger['nb_albums'] := Entity.NbAlbums
    else
      qry.Params.ByNameIsNull['nb_albums'] := True;
    qry.Params.ByNameAsString['siteweb'] := Entity.SiteWeb;
    if IsEqualGUID(Entity.ID_Editeur, GUID_NULL) then
    begin
      qry.Params.ByNameIsNull['id_editeur'] := True;
      qry.Params.ByNameIsNull['id_collection'] := True;
    end
    else
    begin
      qry.Params.ByNameAsString['id_editeur'] := GUIDToString(Entity.ID_Editeur);
      if IsEqualGUID(Entity.ID_Collection, GUID_NULL) then
        qry.Params.ByNameIsNull['id_collection'] := True
      else
        qry.Params.ByNameAsString['id_collection'] := GUIDToString(Entity.ID_Collection);
    end;
    if Entity.Sujet <> '' then
      qry.ParamsSetBlob('sujetserie', Entity.Sujet)
    else
      qry.Params.ByNameIsNull['sujetserie'] := True;
    if Entity.Notes <> '' then
      qry.ParamsSetBlob('remarquesserie', Entity.Notes)
    else
      qry.Params.ByNameIsNull['remarquesserie'] := True;
    qry.Execute;

    if Entity.RecInconnu then
      Entity.ID_Serie := StringToGUID(qry.Fields.AsString[0]);

    SupprimerToutDans('', 'genreseries', 'id_serie', Entity.ID_Serie);
    qry.SQL.Clear;
    qry.SQL.Add('insert into genreseries (id_serie, id_genre) values (:id_serie, :id_genre)');
    qry.Prepare(True);
    for genre in Entity.Genres do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Serie);
      qry.Params.AsString[1] := Copy(genre, 1, qry.Params.MaxStrLen[1]);
      qry.Execute;
    end;

    SupprimerToutDans('', 'auteurs_series', 'id_serie', Entity.ID_Serie);
    qry.SQL.Clear;
    qry.SQL.Add('insert into auteurs_series (');
    qry.SQL.Add('  id_serie, metier, id_personne');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_serie, :metier, :id_personne');
    qry.SQL.Add(') returning id_auteur_series');
    for Auteur in Entity.Scenaristes do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Serie);
      qry.Params.AsInteger[1] := 0;
      qry.Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;
    for Auteur in Entity.Dessinateurs do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Serie);
      qry.Params.AsInteger[1] := 1;
      qry.Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;
    for Auteur in Entity.Coloristes do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Serie);
      qry.Params.AsInteger[1] := 2;
      qry.Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
      qry.Execute;
      Auteur.ID := StringToGUID(qry.Fields.AsString[0]);
    end;

    S := '';
    for Univers in Entity.Univers do
      AjoutString(S, QuotedStr(GUIDToString(Univers.ID)), ',');
    qry.SQL.Clear;
    qry.SQL.Add('delete from series_univers');
    qry.SQL.Add('where');
    qry.SQL.Add('  id_serie = ?');
    if S <> '' then
      qry.SQL.Add('  and id_univers not in (' + S + ')');
    qry.Params.AsString[0] := GUIDToString(Entity.ID_Serie);
    qry.Execute;

    qry.SQL.Clear;
    qry.SQL.Add('update or insert into series_univers (');
    qry.SQL.Add('  id_serie, id_univers');
    qry.SQL.Add(') values (');
    qry.SQL.Add('  :id_serie, :id_univers');
    qry.SQL.Add(') returning id_serie_univers');
    qry.Prepare(True);
    for Univers in Entity.Univers do
    begin
      qry.Params.AsString[0] := GUIDToString(Entity.ID_Serie);
      qry.Params.AsString[1] := GUIDToString(Univers.ID);
      qry.Execute;
      Univers.ID := StringToGUID(qry.Fields.AsString[0]);
    end;

    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
end;

end.
