unit Entities.DaoLambda;

interface

uses
  System.Classes, Entities.Full, System.Generics.Collections;

type
  TDaoListe = class
  type
    // les valeurs doivent correspondre avec le champ "categorie" de la table "liste"
    CategorieIndex = (piNOTUSED = 0, piEtat = 1, piReliure = 2, piTypeEdition = 3, piOrientation = 4, piFormatEdition = 5, piTypeCouverture = 6,
      piCategorieParaBD = 7, piSensLecture = 8, piNoteAlbum = 9, piTypePhoto = 10);
    TMethod = procedure of object;
    TArrayOfROption = array [CategorieIndex] of ROption;
  private
    class var FEnsureLists: TMethod;
    class var FEnsureDefaultValues: TMethod;

  protected
    class var FDefaultValuesLoaded: Boolean;
    class var FDefaultValues: TArrayOfROption;

    class var FListsLoaded: Boolean;
    class var FLists: TDictionary<CategorieIndex, TStrings>;

    class function GetDefaultValue(Index: CategorieIndex): ROption; static;
    class function GetList(const Index: CategorieIndex): TStrings; static;
    class function GetDefaultValues: TArrayOfROption; static;
    class function GetLists: TDictionary<CategorieIndex, TStrings>; static;

  public
    class constructor Create;
    class destructor Destroy;

    class property EnsureDefaultValues: TMethod read FEnsureDefaultValues write FEnsureDefaultValues;
    class property DefaultValues: TArrayOfROption read GetDefaultValues;
    class property DefaultEtat: ROption index piEtat read GetDefaultValue;
    class property DefaultReliure: ROption index piReliure read GetDefaultValue;
    class property DefaultFormatEdition: ROption index piFormatEdition read GetDefaultValue;
    class property DefaultTypeEdition: ROption index piTypeEdition read GetDefaultValue;
    class property DefaultOrientation: ROption index piOrientation read GetDefaultValue;
    class property DefaultTypeCouverture: ROption index piTypeCouverture read GetDefaultValue;
    class property DefaultCategorieParaBD: ROption index piCategorieParaBD read GetDefaultValue;
    class property DefaultSensLecture: ROption index piSensLecture read GetDefaultValue;
    class property DefaultNoteAlbum: ROption index piNoteAlbum read GetDefaultValue;
    class property DefaultTypePhoto: ROption index piTypePhoto read GetDefaultValue;

    class property EnsureLists: TMethod read FEnsureLists write FEnsureLists;
    class property Lists: TDictionary<CategorieIndex, TStrings> read GetLists;
    class property ListEtats: TStrings index piEtat read GetList;
    class property ListReliures: TStrings index piReliure read GetList;
    class property ListFormatsEdition: TStrings index piFormatEdition read GetList;
    class property ListTypesEdition: TStrings index piTypeEdition read GetList;
    class property ListOrientations: TStrings index piOrientation read GetList;
    class property ListTypesCouverture: TStrings index piTypeCouverture read GetList;
    class property ListCategoriesParaBD: TStrings index piCategorieParaBD read GetList;
    class property ListSensLecture: TStrings index piSensLecture read GetList;
    class property ListNotesAlbum: TStrings index piNoteAlbum read GetList;
    class property ListTypesPhoto: TStrings index piTypePhoto read GetList;
  end;

implementation

uses
  uib, UdmPrinc, Commun;

{ TDaoListe }

class constructor TDaoListe.Create;
var
  c: CategorieIndex;
begin
  FDefaultValuesLoaded := False;

  FListsLoaded := False;
  FLists := TObjectDictionary<CategorieIndex, TStrings>.Create([doOwnsValues]);
  for c := Low(CategorieIndex) to High(CategorieIndex) do
  begin
    FLists.Add(c, TStringList.Create);
    FDefaultValues[c] := MakeOption(-1, '');
  end;
end;

class destructor TDaoListe.Destroy;
begin
  FLists.Free;
end;

class function TDaoListe.GetDefaultValue(Index: CategorieIndex): ROption;
begin
  Result := DefaultValues[Index];
end;

class function TDaoListe.GetDefaultValues: TArrayOfROption;
begin
  EnsureDefaultValues;
  Result := FDefaultValues;
end;

class function TDaoListe.GetList(const Index: CategorieIndex): TStrings;
begin
  Lists.TryGetValue(Index, Result);
end;

class function TDaoListe.GetLists: TDictionary<CategorieIndex, TStrings>;
begin
  EnsureLists;
  Result := FLists;
end;

end.
