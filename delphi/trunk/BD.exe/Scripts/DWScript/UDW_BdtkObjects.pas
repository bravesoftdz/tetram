unit UDW_BdtkObjects;

interface

uses
  System.SysUtils, System.Classes, UDWUnit, dwsComp, dwsExprs, dialogs, UScriptEngineIntf;

type
  TDW_BdtkObjectsUnit = class(TDW_Unit)
  private
    procedure Register_TObjectList;
    procedure Register_TAuteur;
    procedure Register_TObjectListOfAuteur;
    procedure Register_TEditeurComplet;
    procedure Register_TSerieComplete;
    procedure Register_TEditionComplete;
    procedure Register_TAlbumComplet;

    procedure Register_TScriptChoix;
    procedure Register_Classes;

    procedure TAlbumCompletDefaultSearch_R(info: TProgramInfo; ExtObject: TObject);
    procedure TAlbumCompletEdition_R(info: TProgramInfo; ExtObject: TObject);

    procedure TAuteurNomAuteur(info: TProgramInfo; ExtObject: TObject);

    procedure TEditionCompleteCollection(info: TProgramInfo; ExtObject: TObject);

    procedure TScriptChoixTitre(info: TProgramInfo; ExtObject: TObject);

    procedure TSerieCompleteCollection(info: TProgramInfo; ExtObject: TObject);

    procedure TObjectListOfObjectCount_R(info: TProgramInfo; ExtObject: TObject);

    procedure MakeAuteurEval(info: TProgramInfo);
  public
    constructor Create(MasterEngine: IMasterEngine); override;
  published
    procedure OnTAlbumComplet_ImportEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTAlbumComplet_ClearEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTAuteur_CreateEval(info: TProgramInfo; var ExtObject: TObject);

    procedure OnTEditionComplete_AddImageFromURLEval(info: TProgramInfo; ExtObject: TObject);

    procedure OnTObjectListOfAuteur_ItemsEval(info: TProgramInfo; ExtObject: TObject);

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

    procedure OnTObjectListOfAuteur_AddEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTObjectListOfAuteur_InsertEval(info: TProgramInfo; ExtObject: TObject);
  end;

implementation

uses
  dwsSymbols, LoadComplet, UMetadata, Procedures, AnsiStrings, Divers, Generics.Collections,
  UScriptsFonctions, TypeRec, LoadCompletImport, Commun;

{ TDW_BdtkObjects }

constructor TDW_BdtkObjectsUnit.Create(MasterEngine: IMasterEngine);
begin
  inherited;
  UnitName := 'BdtkObjects';
  Dependencies.Add('Classes');
  Register_Classes;
end;

procedure TDW_BdtkObjectsUnit.MakeAuteurEval(info: TProgramInfo);
begin
  info.ResultAsVariant := GetScriptObjFromExternal(info, MakeAuteur(info.ParamAsString[0], TMetierAuteur(info.ParamAsInteger[1])));
end;

procedure TDW_BdtkObjectsUnit.OnTAlbumComplet_ClearEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TAlbumComplet).Clear;
end;

procedure TDW_BdtkObjectsUnit.OnTAlbumComplet_ImportEval(info: TProgramInfo; ExtObject: TObject);
begin
  Import(ExtObject as TAlbumComplet);
end;

procedure TDW_BdtkObjectsUnit.OnTAuteur_CreateEval(info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TAuteur.Create;
end;

procedure TDW_BdtkObjectsUnit.OnTEditionComplete_AddImageFromURLEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := AddImageFromURL((ExtObject as TEditionComplete), info.ParamAsString[0], info.ParamAsInteger[1]);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfAuteur_AddEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsInteger := (ExtObject as TObjectList<TAuteur>).Add(info.ParamAsObject[0] as TAuteur);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfAuteur_InsertEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TObjectList<TAuteur>).Insert(info.ParamAsInteger[0], info.ParamAsObject[1] as TAuteur);
end;

procedure TDW_BdtkObjectsUnit.OnTObjectListOfAuteur_ItemsEval(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsVariant := GetScriptObjFromExternal(info, (ExtObject as TObjectList<TAuteur>).Items[info.ParamAsInteger[0]]);
    // info.ResultAsVariant := info.RegisterExternalObject((ExtObject as TObjectList<TAuteur>).Items[info.ParamAsInteger[0]]);
  end;
end;

procedure TDW_BdtkObjectsUnit.OnTObjectList_DeleteEval(info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TObjectList<TObject>).Delete(info.ParamAsInteger[0]);
end;

procedure TDW_BdtkObjectsUnit.TAlbumCompletDefaultSearch_R(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsString := (ExtObject as TAlbumComplet).DefaultSearch;
end;

procedure TDW_BdtkObjectsUnit.TAlbumCompletEdition_R(info: TProgramInfo; ExtObject: TObject);
var
  Album: TAlbumComplet;
begin
  Album := (ExtObject as TAlbumComplet);
  if Album.Editions.Editions.Count = 0 then
  begin
    Album.Editions.Editions.Add(TEditionComplete.Create(GUID_NULL));
    Album.Editions.Editions[0].New;
  end;
  info.ResultAsVariant := GetScriptObjFromExternal(info, Album.Editions.Editions[0]);
end;

procedure TDW_BdtkObjectsUnit.TAuteurNomAuteur(info: TProgramInfo; ExtObject: TObject);
begin
  case info.FuncSym.Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TAuteur).Personne.Nom;
    fkProcedure:
      (ExtObject as TAuteur).Personne.Nom := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.TObjectListOfObjectCount_R(info: TProgramInfo; ExtObject: TObject);
begin
  // le "as" déclenche une erreur de cast, mais le typage forcé fonctionne.... les joies des generic made in Delphi
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

procedure TDW_BdtkObjectsUnit.TScriptChoixTitre(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TScriptChoix).Titre;
    fkProcedure:
      (ExtObject as TScriptChoix).Titre := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.TSerieCompleteCollection(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TSerieComplete).Collection.NomCollection;
    fkProcedure:
      (ExtObject as TSerieComplete).Collection.NomCollection := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.TEditionCompleteCollection(info: TProgramInfo; ExtObject: TObject);
begin
  case TMethodSymbol(info.FuncSym).Kind of
    fkFunction:
      info.ResultAsString := (ExtObject as TEditionComplete).Collection.NomCollection;
    fkProcedure:
      (ExtObject as TEditionComplete).Collection.NomCollection := info.ParamAsString[0];
end;
end;

procedure TDW_BdtkObjectsUnit.Register_Classes;
begin
  with TdwsSynonym(Synonyms.Add) do
  begin
    Name := 'Currency';
    DataType := 'Float';
  end;

  Register_TObjectList;

  Register_TAuteur;
  Register_TObjectListOfAuteur;
  Register_TEditeurComplet;
  Register_TSerieComplete;
  Register_TEditionComplete;
  Register_TAlbumComplet;

  Register_TScriptChoix;
end;

procedure TDW_BdtkObjectsUnit.Register_TAlbumComplet;
var
  c: TdwsClass;
begin
  c := RegisterClass('TAlbumComplet');

  RegisterProperty(c, 'DefaultSearch', 'string', TAlbumCompletDefaultSearch_R);

  RegisterProperty(c, 'Titre', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Serie', 'TSerieComplete', HandleDynamicProperty);
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
  RegisterProperty(c, 'Sujet', 'TStringList', HandleDynamicProperty);
  RegisterProperty(c, 'Notes', 'TStringList', HandleDynamicProperty);
  RegisterProperty(c, 'Edition', 'TEditionComplete', TAlbumCompletEdition_R);

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

  RegisterConstructor(c, []);
  RegisterProperty(c, 'NomAuteur', 'string', TAuteurNomAuteur, TAuteurNomAuteur);
  RegisterProperty(c, 'Metier', 'TMetierAuteur', HandleDynamicProperty, HandleDynamicProperty);

  RegisterFunction('MakeAuteur', 'TAuteur', ['Nom', 'string', 'Metier', 'TMetierAuteur'], MakeAuteurEval);
end;

procedure TDW_BdtkObjectsUnit.Register_TEditeurComplet;
var
  c: TdwsClass;
begin
  c := RegisterClass('TEditeurComplet');

  RegisterProperty(c, 'NomEditeur', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'SiteWeb', 'string', HandleDynamicProperty, HandleDynamicProperty);
end;

procedure TDW_BdtkObjectsUnit.Register_TEditionComplete;
var
  c: TdwsClass;
  i: Integer;
  FListTypesImages: TStringList;
begin
  FListTypesImages := TStringList.Create;
  try
    LoadStrings(6, FListTypesImages);
    for i := 0 to Pred(FListTypesImages.Count) do
      with Constants.Add do
      begin
        Name := 'cti' + StringReplace(SansAccents(FListTypesImages.ValueFromIndex[i]), ' ', '_', [rfReplaceAll]);
        DataType := 'Integer';
        Value := StrToInt(FListTypesImages.Names[i]);
      end;
  finally
    FListTypesImages.Free;
  end;

  c := RegisterClass('TEditionComplete');

  RegisterProperty(c, 'Editeur', 'TEditeurComplet', HandleDynamicProperty);
  RegisterProperty(c, 'Collection', 'string', TEditionCompleteCollection, TEditionCompleteCollection);
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
  // RegisterProperty(c, 'Notes', 'TStringList', False);
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

procedure TDW_BdtkObjectsUnit.Register_TSerieComplete;
var
  c: TdwsClass;
begin
  c := RegisterClass('TSerieComplete');

  RegisterProperty(c, 'Titre', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Terminee', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Genres', 'TStringList', HandleDynamicProperty);
  RegisterProperty(c, 'Sujet', 'TStringList', HandleDynamicProperty);
  RegisterProperty(c, 'Notes', 'TStringList', HandleDynamicProperty);
  RegisterProperty(c, 'Editeur', 'TEditeurComplet', HandleDynamicProperty);
  RegisterProperty(c, 'Collection', 'string', TSerieCompleteCollection, TSerieCompleteCollection);
  RegisterProperty(c, 'SiteWeb', 'string', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'NbAlbums', 'Integer', HandleDynamicProperty, HandleDynamicProperty);
  RegisterProperty(c, 'Scenaristes', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Dessinateurs', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
  RegisterProperty(c, 'Coloristes', 'TObjectListOfAuteur' { TObjectList<TAuteur> } , HandleDynamicProperty);
end;

end.
