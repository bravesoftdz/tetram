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
