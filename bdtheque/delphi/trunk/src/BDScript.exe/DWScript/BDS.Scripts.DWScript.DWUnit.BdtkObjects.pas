unit BDS.Scripts.DWScript.DWUnit.BdtkObjects;

interface

uses
  System.SysUtils, System.Classes, BDS.Scripts.DWScript.DWUnit, dwsComp, dwsExprs, dialogs, BDS.Scripts.Engine.Intf;

type
  TDW_BdtkObjectsUnit = class(TDW_Unit)
  private
    procedure Register_TObjectList;
    procedure Register_TUnivers;
    procedure Register_TObjectListOfUnivers;
    procedure Register_TAuteur;
    procedure Register_TObjectListOfAuteur;
    procedure Register_TEditeurFull;
    procedure Register_TSerieFull;
    procedure Register_TEditionFull;
    procedure Register_TAlbumFull;

    procedure Register_TScriptChoix;
    procedure Register_Classes;

    procedure TAlbumFullDefaultSearch_R(info: TProgramInfo; ExtObject: TObject);
    procedure TAlbumFullEdition_R(info: TProgramInfo; ExtObject: TObject);

    procedure TAuteurNomAuteur(info: TProgramInfo; ExtObject: TObject);

    procedure TEditionFullCollection(info: TProgramInfo; ExtObject: TObject);

    procedure TScriptChoixTitre(info: TProgramInfo; ExtObject: TObject);

    procedure TSerieFullCollection(info: TProgramInfo; ExtObject: TObject);

    procedure TObjectListOfObjectCount_R(info: TProgramInfo; ExtObject: TObject);

    procedure MakeAuteurSerieEval(info: TProgramInfo);
    procedure MakeAuteurAlbumEval(info: TProgramInfo);
    procedure MakeUniversEval(info: TProgramInfo);
  public
    constructor Create(const MasterEngine: IMasterEngine); override;
  published
    procedure OnTAlbumFull_ImportEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTAlbumFull_ClearEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTUnivers_CreateEval(info: TProgramInfo; var ExtObject: TObject);

    procedure OnTAuteurSerie_CreateEval(info: TProgramInfo; var ExtObject: TObject);
    procedure OnTAuteurAlbum_CreateEval(info: TProgramInfo; var ExtObject: TObject);

    procedure OnTEditionFull_AddImageFromURLEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTScriptChoix_CreateEval(info: TProgramInfo; var ExtObject: TObject);
    procedure OnTScriptChoix_DestroyEval(ExtObject: TObject);
    procedure OnTScriptChoix_ResetListEval(ExtObject: TObject);
    procedure OnTScriptChoix_AjoutChoixWithThumbEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTScriptChoix_AjoutChoixEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTScriptChoix_ChoixCountEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTScriptChoix_CategorieCountEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTScriptChoix_CategorieChoixCountEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTScriptChoix_ShowEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTObjectList_DeleteEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTObjectListOfAuteur_ItemsEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTObjectListOfAuteur_AddEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTObjectListOfAuteur_InsertEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTObjectListOfUnivers_ItemsEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTObjectListOfUnivers_AddEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTObjectListOfUnivers_InsertEval(info: TProgramInfo; ExtObject: TObject);
  end;

implementation

uses
  dwsSymbols, BD.Entities.Full, BD.Entities.Metadata, BD.Utils.GUIUtils, AnsiStrings, Divers, Generics.Collections,
  BDS.Scripts.Functions, BD.Entities.Lite, BD.Utils.StrUtils, BD.Entities.Factory.Lite,
  BD.Entities.Factory.Full, BD.Entities.Dao.Lambda;

{ TDW_BdtkObjects }

constructor TDW_BdtkObjectsUnit.Create(const MasterEngine: IMasterEngine);
begin
  inherited;
  UnitName := 'BdtkObjects';
  Dependencies.Add('Classes');
  Register_Classes;
end;

procedure TDW_BdtkObjectsUnit.MakeAuteurAlbumEval(info: TProgramInfo);
begin
  info.ResultAsVariant := GetScriptObjFromExternal(info, MakeAuteurAlbum(info.ParamAsString[0], TMetierAuteur(info.ParamAsInteger[1])));
end;

procedure TDW_BdtkObjectsUnit.MakeAuteurSerieEval(info: TProgramInfo);
begin
  info.ResultAsVariant := GetScriptObjFromExternal(info, MakeAuteurSerie(info.ParamAsString[0], TMetierAuteur(info.ParamAsInteger[1])));
end;

procedure TDW_BdtkObjectsUnit.MakeUniversEval(info: TProgramInfo);
begin
  info.ResultAsVariant := GetScriptObjFromExternal(info, MakeUnivers(info.ParamAsString[0]));
end;

procedure TDW_BdtkObjectsUnit.OnTAlbumFull_ClearEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TAlbumFull).Clear;
end;

procedure TDW_BdtkObjectsUnit.OnTAlbumFull_ImportEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TAlbumFull).ReadyToImport := True;;
end;

procedure TDW_BdtkObjectsUnit.OnTAuteurAlbum_CreateEval(info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TFactoryAuteurAlbumLite.getInstance;
end;

procedure TDW_BdtkObjectsUnit.OnTAuteurSerie_CreateEval(info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TFactoryAuteurSerieLite.getInstance;
end;

procedure TDW_BdtkObjectsUnit.OnTEditionFull_AddImageFromURLEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := AddImageFromURL((ExtObject as TEditionFull), info.ParamAsString[0], info.ParamAsInteger[1]);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfAuteur_AddEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := (ExtObject as TObjectList<TAuteurLite>).Add(info.ParamAsObject[0] as TAuteurLite);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfAuteur_InsertEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TObjectList<TAuteurLite>).Insert(info.ParamAsInteger[0], info.ParamAsObject[1] as TAuteurLite);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfAuteur_ItemsEval(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsVariant := GetScriptObjFromExternal(info, (ExtObject as TObjectList<TAuteurLite>).Items[info.ParamAsInteger[0]]);
    // info.ResultAsVariant := info.RegisterExternalObject((ExtObject as TObjectList<TAuteur>).Items[info.ParamAsInteger[0]]);
  end;
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfUnivers_AddEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := (ExtObject as TObjectList<TUniversLite>).Add(info.ParamAsObject[0] as TUniversLite);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfUnivers_InsertEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TObjectList<TUniversLite>).Insert(info.ParamAsInteger[0], info.ParamAsObject[1] as TUniversLite);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfUnivers_ItemsEval(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsVariant := GetScriptObjFromExternal(info, (ExtObject as TObjectList<TUniversLite>).Items[info.ParamAsInteger[0]]);
    // info.ResultAsVariant := info.RegisterExternalObject((ExtObject as TObjectList<TUnivers>).Items[info.ParamAsInteger[0]]);
  end;
end;

procedure TDW_BdtkObjectsUnit.OnTObjectList_DeleteEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TObjectList<TObject>).Delete(info.ParamAsInteger[0]);
end;

procedure TDW_BdtkObjectsUnit.TAlbumFullDefaultSearch_R(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsString := (ExtObject as TAlbumFull).DefaultSearch;
end;

procedure TDW_BdtkObjectsUnit.TAlbumFullEdition_R(info: TProgramInfo; ExtObject: TObject);
var
  Album: TAlbumFull;
begin
  Album := (ExtObject as TAlbumFull);
  if Album.Editions.Count = 0 then
    Album.Editions.Add(TFactoryEditionFull.getInstance);
  info.ResultAsVariant := GetScriptObjFromExternal(info, Album.Editions[0]);
end;

procedure TDW_BdtkObjectsUnit.TAuteurNomAuteur(info: TProgramInfo; ExtObject: TObject);
begin
  case info.FuncSym.Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TAuteurLite).Personne.Nom;
    fkProcedure:
      (ExtObject as TAuteurLite).Personne.Nom := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.TObjectListOfObjectCount_R(info: TProgramInfo; ExtObject: TObject);
begin
  // le "as" d�clenche une erreur de cast, mais le typage forc� fonctionne.... les joies des generic made in Delphi
  // info.ResultAsInteger := (ExtObject as TObjectList<TObject>).Count;
  info.ResultAsInteger := TObjectList<TObject>(ExtObject).Count;
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_AjoutChoixEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TScriptChoix).AjoutChoix(info.ParamAsString[0], info.ParamAsString[1], info.ParamAsString[2], info.ParamAsString[3]);
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_AjoutChoixWithThumbEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TScriptChoix).AjoutChoixWithThumb(info.ParamAsString[0], info.ParamAsString[1], info.ParamAsString[2], info.ParamAsString[3],
    info.ParamAsString[4]);
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_CategorieChoixCountEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := (ExtObject as TScriptChoix).CategorieChoixCount(info.ParamAsString[0]);
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_CategorieCountEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := (ExtObject as TScriptChoix).CategorieCount;
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_ChoixCountEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := (ExtObject as TScriptChoix).ChoixCount;
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_CreateEval(info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TScriptChoix.Create;
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_DestroyEval(ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_ResetListEval(ExtObject: TObject);
begin
  (ExtObject as TScriptChoix).ResetList;
end;

procedure TDW_BdtkObjectsUnit.OnTScriptChoix_ShowEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsString := (ExtObject as TScriptChoix).Show;
end;

procedure TDW_BdtkObjectsUnit.OnTUnivers_CreateEval(info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TFactoryUniversLite.getInstance;
end;

procedure TDW_BdtkObjectsUnit.TScriptChoixTitre(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TScriptChoix).Titre;
    fkProcedure:
      (ExtObject as TScriptChoix).Titre := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.TSerieFullCollection(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TSerieFull).Collection.NomCollection;
    fkProcedure:
      (ExtObject as TSerieFull).Collection.NomCollection := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.TEditionFullCollection(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TEditionFull).Collection.NomCollection;
    fkProcedure:
      (ExtObject as TEditionFull).Collection.NomCollection := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.Register_Classes;
begin
  RegisterType('Currency', 'Float');
  RegisterType('LongString', 'string');

  Register_TObjectList;

  Register_TUnivers;
  Register_TObjectListOfUnivers;
  Register_TAuteur;
  Register_TObjectListOfAuteur;
  Register_TEditeurFull;
  Register_TSerieFull;
  Register_TEditionFull;
  Register_TAlbumFull;

  Register_TScriptChoix;
end;

procedure TDW_BdtkObjectsUnit.Register_TAlbumFull;
var
  c: TdwsClass;
begin
  c := RegisterClass('TAlbumFull');

  RegisterProperty(c, 'DefaultSearch', 'string', TAlbumFullDefaultSearch_R);

  RegisterProperty(c, 'Titre', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Serie', 'TSerieFull', HandleDynamicProperty);
  RegisterProperty(c, 'MoisParution', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'AnneeParution', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Tome', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'TomeDebut', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'TomeFin', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'HorsSerie', 'Boolean', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Integrale', 'Boolean', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Scenaristes', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Dessinateurs', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Coloristes', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Sujet', 'LongString', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Notes', 'LongString', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Edition', 'TEditionFull', TAlbumFullEdition_R);
  RegisterProperty(c, 'Univers', 'TObjectListOfUnivers' { TObjectList<TUnivers> } , HandleDynamicProperty);

  RegisterMethod(c, 'Clear', []);
  RegisterMethod(c, 'Import', []);
end;

procedure TDW_BdtkObjectsUnit.Register_TAuteur;
var
  c: TdwsClass;
begin
  with Enumerations.Add do
  begin
    Name := 'TMetierAuteur';
    with Elements.Add do
    begin
      Name := 'maScenariste';
      UserDefValue := Ord(maScenariste);
    end;
    with Elements.Add do
    begin
      Name := 'maDessinateur';
      UserDefValue := Ord(maDessinateur);
    end;
    with Elements.Add do
    begin
      Name := 'maColoriste';
      UserDefValue := Ord(maColoriste);
    end;
  end;

  c := RegisterClass('TAuteur');

  RegisterProperty(c, 'NomAuteur', 'string', TAuteurNomAuteur, TAuteurNomAuteur);
  RegisterProperty(c, 'Metier', 'TMetierAuteur', HandleDynamicProperty, HandleDynamicProperty);

  RegisterConstructor(RegisterClass('TAuteurSerie', c.Name), []);
  RegisterConstructor(RegisterClass('TAuteurAlbum', c.Name), []);

  RegisterFunction('MakeAuteurSerie', 'TAuteurSerie', ['Nom', 'string', 'Metier', 'TMetierAuteur'], MakeAuteurSerieEval);
  RegisterFunction('MakeAuteurAlbum', 'TAuteurAlbum', ['Nom', 'string', 'Metier', 'TMetierAuteur'], MakeAuteurAlbumEval);
end;

procedure TDW_BdtkObjectsUnit.Register_TEditeurFull;
var
  c: TdwsClass;
begin
  c := RegisterClass('TEditeurFull');

  RegisterProperty(c, 'NomEditeur', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'SiteWeb', 'string', HandleDynamicProperty, HandleDynamicProperty);
end;

procedure TDW_BdtkObjectsUnit.Register_TEditionFull;
var
  c: TdwsClass;
  i: Integer;
  FListTypesCouverture: TStrings;
  constant: TdwsConstant;
begin
  FListTypesCouverture := TDaoListe.ListTypesCouverture;
  for i := 0 to Pred(FListTypesCouverture.Count) do
  begin
    constant := Constants.Add;
    constant.Name := 'cti' + StringReplace(SansAccents(FListTypesCouverture.ValueFromIndex[i]), ' ', '_', [rfReplaceAll]);
    constant.DataType := 'Integer';
    constant.Value := StrToInt(FListTypesCouverture.Names[i]);
  end;

  c := RegisterClass('TEditionFull');

  RegisterProperty(c, 'Editeur', 'TEditeurFull', HandleDynamicProperty);
  RegisterProperty(c, 'Collection', 'string', TEditionFullCollection, TEditionFullCollection);
  RegisterProperty(c, 'TypeEdition', 'Integer' { ROption } , HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'AnneeEdition', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Etat', 'Integer' { ROption } , HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Reliure', 'Integer' { ROption } , HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'NombreDePages', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'FormatEdition', 'Integer' { ROption } , HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Orientation', 'Integer' { ROption } , HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'AnneeCote', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'SensLecture', 'Integer' { ROption } , HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Prix', 'Currency', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'PrixCote', 'Currency', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Couleur', 'Boolean', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'VO', 'Boolean', HandleDynamicProperty, HandleDynamicProperty);
  // RegisterProperty(c, 'Dedicace', 'Boolean', True);
  // RegisterProperty(c, 'Stock', 'Boolean', True);
  // RegisterProperty(c, 'Prete', 'Boolean', True);
  // RegisterProperty(c, 'Offert', 'Boolean', True);
  RegisterProperty(c, 'Gratuit', 'Boolean', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'ISBN', 'string', HandleDynamicProperty, HandleDynamicProperty);
  // RegisterProperty(c, 'DateAchat', 'TDateTime', True);
  // RegisterProperty(c, 'Notes', 'LongString', HandleDynamicProperty, HandleDynamicProperty);
  // RegisterProperty(c, 'NumeroPerso', 'string', True);
  // RegisterProperty(c, 'Couvertures', 'TMyObjectList<TCouverture>', False);

  RegisterMethod(c, 'AddImageFromURL', 'Integer', ['URL', 'string', 'TypeImage', 'Integer']);
end;

procedure TDW_BdtkObjectsUnit.Register_TObjectList;
var
  c: TdwsClass;
begin
  c := RegisterClass('TObjectList', 'TObject');

  RegisterProperty(c, 'Count', 'Integer', TObjectListOfObjectCount_R);
  RegisterMethod(c, 'Delete', ['Index', 'Integer']);
end;

procedure TDW_BdtkObjectsUnit.Register_TObjectListOfAuteur;
var
  c: TdwsClass;
begin
  c := RegisterClass('TObjectListOfAuteur', 'TObjectList');

  RegisterProperty(c, 'Items', 'TAuteur', ['Index', 'Integer'], OnTObjectListOfAuteur_ItemsEval).IsDefault := True;
  RegisterMethod(c, 'Add', 'Integer', ['AObject', 'TAuteur']);
  RegisterMethod(c, 'Insert', ['Index', 'Integer', 'AObject', 'TAuteur']);
end;

procedure TDW_BdtkObjectsUnit.Register_TObjectListOfUnivers;
var
  c: TdwsClass;
begin
  c := RegisterClass('TObjectListOfUnivers', 'TObjectList');

  RegisterProperty(c, 'Items', 'TUnivers', ['Index', 'Integer'], OnTObjectListOfUnivers_ItemsEval).IsDefault := True;
  RegisterMethod(c, 'Add', 'Integer', ['AObject', 'TUnivers']);
  RegisterMethod(c, 'Insert', ['Index', 'Integer', 'AObject', 'TUnivers']);
end;

procedure TDW_BdtkObjectsUnit.Register_TScriptChoix;
var
  c: TdwsClass;
begin
  c := RegisterClass('TScriptChoix');

  RegisterConstructor(c, []);

  RegisterMethod(c, 'Show', 'string', []);
  RegisterMethod(c, 'ResetList', []);
  RegisterMethod(c, 'AjoutChoix', ['Categorie', 'string', 'Libelle', 'string', 'Commentaire', 'string', 'Data', 'string']);
  RegisterMethod(c, 'AjoutChoixWithThumb', ['Categorie', 'string', 'Libelle', 'string', 'Commentaire', 'string', 'Data', 'string', 'URL', 'string']);
  RegisterMethod(c, 'CategorieCount', 'Integer', []);
  RegisterMethod(c, 'ChoixCount', 'Integer', []);
  RegisterMethod(c, 'CategorieChoixCount', 'Integer', ['Name', 'string']);
  RegisterProperty(c, 'Titre', 'string', TScriptChoixTitre, TScriptChoixTitre);
end;

procedure TDW_BdtkObjectsUnit.Register_TSerieFull;
var
  c: TdwsClass;
begin
  c := RegisterClass('TSerieFull');

  RegisterProperty(c, 'Titre', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Terminee', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Genres', 'TStringList', HandleDynamicProperty);
  RegisterProperty(c, 'Sujet', 'LongString', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Notes', 'LongString', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Editeur', 'TEditeurFull', HandleDynamicProperty);
  RegisterProperty(c, 'Collection', 'string', TSerieFullCollection, TSerieFullCollection);
  RegisterProperty(c, 'SiteWeb', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'NbAlbums', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Scenaristes', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Dessinateurs', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Coloristes', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Univers', 'TObjectListOfUnivers' { TObjectList<TUnivers> } , HandleDynamicProperty);
end;

procedure TDW_BdtkObjectsUnit.Register_TUnivers;
var
  c: TdwsClass;
begin
  c := RegisterClass('TUnivers');

  RegisterProperty(c, 'NomUnivers', 'string', HandleDynamicProperty, HandleDynamicProperty);

  RegisterFunction('MakeUnivers', 'TUnivers', ['Nom', 'string'], MakeUniversEval);
end;

end.
