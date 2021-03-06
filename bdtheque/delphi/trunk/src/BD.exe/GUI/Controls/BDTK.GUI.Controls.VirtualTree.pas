﻿unit BDTK.GUI.Controls.VirtualTree;

{.$D-}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics, VirtualTrees, BD.GUI.Controls.VirtualTree, System.UITypes,
  EditLabeled, BD.Entities.Lite, System.StrUtils, LinkControls, System.Generics.Collections,
{$IFDEF DEBUG}Vcl.Clipbrd, {$ENDIF}
  BDTK.Entities.Dao.Lite;

type
  PInitialeInfo = ^RInitialeInfo;
  RInitialeInfo = record
    Initiale: string;
    Count: Integer;
    sValue: string;
  end;

  // !!! Les valeurs ne doivent pas être changées
  TVirtualMode = (vmNone = 0, vmAlbums = 1, vmCollections = 2, vmEditeurs = 3, {vmEmprunteurs = 4, }vmGenres = 5, vmPersonnes = 6, vmSeries = 7,
    vmAlbumsAnnee = 8, vmAlbumsCollection = 9, vmAlbumsEditeur = 10, vmAlbumsGenre = 11, vmAlbumsSerie = 12, vmParaBDSerie = 13, vmAchatsAlbumsEditeur = 14,
    vmUnivers = 15, vmAlbumsSerieUnivers = 16, vmParaBDSerieUnivers = 17);
  TVirtualModes = set of TVirtualMode;

  TOnCompareNodeString = procedure(Sender: TBaseVirtualTree; Node: PVirtualNode; const Text: string; var Concorde: Boolean) of object;

  TVirtualStringTree = class(BD.GUI.Controls.VirtualTree.TVirtualStringTree)
  strict private
    class constructor InitializeClass;
    class destructor FinalizeClass;
    class var FInstances: TList<TVirtualStringTree>;
  strict private
    FMemorizedIndexNode: Boolean;
    FIndexNode: Cardinal;

    FMode: TVirtualMode;
    FCountPointers: array of RInitialeInfo;
    FUseFiltre: Boolean;
    FFiltre: string;
    FUseDefaultFiltre: Boolean;
    FShowAchat: Boolean;

    FFindArray: array of TGUID;
    FLastFindText: string;
    FShowDateParutionAlbum: Boolean;
    FOnCompareNodeString: TOnCompareNodeString;

    procedure SetMode(const Value: TVirtualMode);
    function GetCurrentValue: TGUID;
    procedure SetCurrentValue(const Value: TGUID);
    function GetFocusedNodeCaption: UnicodeString;
    function GetFocusedNodeFullCaption: UnicodeString;
    procedure SetFiltre(const Value: string);
    procedure SetUseFiltre(const Value: Boolean);
    procedure SetUseDefaultFiltre(const Value: Boolean);
    procedure SetShowAchat(const Value: Boolean);
    procedure SetShowDateParutionAlbum(const Value: Boolean);
    function GetNodeByValue(const Value: TGUID): PVirtualNode;
  protected
    procedure DoFreeNode(Node: PVirtualNode); override;
    function DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal): Boolean; override;
    function InitNode(Node: PVirtualNode): Boolean; reintroduce;
    procedure DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType); override;
    procedure DoAfterPaint(Canvas: TCanvas); override;
    procedure DoCollapsed(Node: PVirtualNode); override;
    function DoCompareNodeString(Node: PVirtualNode; const Text: string): Boolean; virtual;
  public
    class procedure InitializeRep(AModes: TVirtualModes; AExcept: TVirtualStringTree = nil); overload;
    class procedure InitializeRep(AParentModes: TVirtualModes; AChildModes: TVirtualModes; ARemovedId: TGUID); overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure DoGetText(var pEventArgs: TVSTGetCellTextEventArgs); override;
    function GetNodeBasePointer(Node: PVirtualNode): TBaseLite;
    function GetFocusedNodeData: TBaseLite;
    procedure InitializeRep(KeepValue: Boolean = True); overload;
    procedure ReinitNodes(NodeLevel: Integer = -1);
    procedure Find(const Text: string; GetNext: Boolean = False);
    procedure MemorizeIndexNode;
    procedure FindIndexNode;
    procedure ClearIndexNode;
    procedure MakeVisibleValue(const Value: TGUID);
  published
    property Mode: TVirtualMode read FMode write SetMode;
    property CurrentValue: TGUID read GetCurrentValue write SetCurrentValue;
    property Caption: UnicodeString read GetFocusedNodeCaption;
    property FullCaption: UnicodeString read GetFocusedNodeFullCaption;
    property Filtre: string read FFiltre write SetFiltre;
    property UseFiltre: Boolean read FUseFiltre write SetUseFiltre;
    property UseDefaultFiltre: Boolean read FUseDefaultFiltre write SetUseDefaultFiltre;
    property ShowAchat: Boolean read FShowAchat write SetShowAchat default True;
    property ShowDateParutionAlbum: Boolean read FShowDateParutionAlbum write SetShowDateParutionAlbum default False;
    property OnCompareNodeString: TOnCompareNodeString read FOnCompareNodeString write FOnCompareNodeString;
  end;

type
  TClassBasePointeur = class of TBaseLite;

  RModeInfo = record
    FILTRECOUNT, Filtre, FIELDS: string;
    INITIALEFIELDS, INITIALEVALUE, REFFIELDS: string;
    TABLESEARCH: string;
    FIELDSEARCH: string;
    SEARCHORDER: string;
    WHERECONDITION: string;
    DEFAULTFILTRE: string;
    ClassPointeur: TClassBasePointeur;
    ClassDao: TDaoLiteClass;
  end;

const
  vmPARENT_ALBUMS = [vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAlbumsSerieUnivers];
  vmCHILD_ALBUMS = [];
  vmPARENT_SERIES = [vmSeries];
  vmCHILD_SERIES = [vmAlbumsSerie, vmParaBDSerie, vmAlbumsSerieUnivers, vmParaBDSerieUnivers];
  vmPARENT_EDITEURS = [vmEditeurs];
  vmCHILD_EDITEURS = [vmAlbumsEditeur, vmAchatsAlbumsEditeur];
  vmPARENT_COLLECTIONS = [vmCollections];
  vmCHILD_COLLECTIONS = [vmAlbumsCollection];
  vmPARENT_PERSONNES = [vmPersonnes];
  vmCHILD_PERSONNES = [];
  vmPARENT_GENRES = [vmGenres];
  vmCHILD_GENRES = [vmAlbumsGenre];
  vmPARENT_PARABD = [];
  vmCHILD_PARABD = [vmParaBDSerie, vmParaBDSerieUnivers];
  vmPARENT_UNIVERS = [vmUnivers];
  vmCHILD_UNIVERS = [vmAlbumsSerieUnivers, vmParaBDSerieUnivers];

  vmModeInfos: array[TVirtualMode] of RModeInfo = (
    ( // vmNone
    ),
    ( // vmAlbums
      FILTRECOUNT: 'INITIALES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_INITIALE(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'INITIALETITREALBUM'; INITIALEVALUE: 'INITIALETITREALBUM'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'TITREALBUM, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmCollections
      FILTRECOUNT: 'INITIALES_COLLECTIONS(?)'; Filtre: 'COLLECTIONS_BY_INITIALE(?, ?)';
      FIELDS: 'ID_COLLECTION, NOMCOLLECTION, id_editeur, nomediteur';
      INITIALEFIELDS: 'INITIALENOMCOLLECTION'; INITIALEVALUE: 'INITIALENOMCOLLECTION'; REFFIELDS: 'ID_COLLECTION'; TABLESEARCH: 'COLLECTIONS';
      FIELDSEARCH: 'NOMCOLLECTION';
      ClassPointeur: TCollectionLite; ClassDao: TDaoCollectionLite
    ),
    ( // vmEditeurs
      FILTRECOUNT: 'VW_INITIALES_EDITEURS'; Filtre: 'EDITEURS_BY_INITIALE(?)';
      FIELDS: 'ID_EDITEUR, NOMEDITEUR';
      INITIALEFIELDS: 'INITIALENOMEDITEUR'; INITIALEVALUE: 'INITIALENOMEDITEUR'; REFFIELDS: 'ID_EDITEUR'; TABLESEARCH: 'EDITEURS';
      FIELDSEARCH: 'NOMEDITEUR';
      ClassPointeur: TEditeurLite; ClassDao: TDaoEditeurLite
    ),
    ( // vmEmprunteurs = plus utilisé
    (*
        FILTRECOUNT: 'VW_INITIALES_EMPRUNTEURS'; Filtre: 'EMPRUNTEURS_BY_INITIALE(?)';
        FIELDS: 'ID_EMPRUNTEUR, NOMEMPRUNTEUR';
        INITIALEFIELDS: 'INITIALENOMEMPRUNTEUR'; INITIALEVALUE: 'INITIALENOMEMPRUNTEUR'; REFFIELDS: 'ID_EMPRUNTEUR'; TABLESEARCH: 'EMPRUNTEURS';
        FIELDSEARCH: 'NOMEMPRUNTEUR'
    *)
    ),
    ( // vmGenres
      FILTRECOUNT: 'VW_INITIALES_GENRES'; Filtre: 'GENRES_BY_INITIALE(?)';
      FIELDS: 'ID_GENRE, GENRE';
      INITIALEFIELDS: 'INITIALEGENRE'; INITIALEVALUE: 'INITIALEGENRE'; REFFIELDS: 'ID_GENRE'; TABLESEARCH: 'GENRES';
      FIELDSEARCH: 'GENRE';
      ClassPointeur: TGenreLite; ClassDao: TDaoGenreLite
    ),
    ( // vmPersonnes
      FILTRECOUNT: 'VW_INITIALES_PERSONNES'; Filtre: 'PERSONNES_BY_INITIALE(?)';
      FIELDS: 'ID_PERSONNE, NOMPERSONNE';
      INITIALEFIELDS: 'INITIALENOMPERSONNE'; INITIALEVALUE: 'INITIALENOMPERSONNE'; REFFIELDS: 'ID_PERSONNE'; TABLESEARCH: 'PERSONNES';
      FIELDSEARCH: 'NOMPERSONNE';
      ClassPointeur: TPersonnageLite; ClassDao: TDaoPersonnageLite
    ),
    ( // vmSeries
      FILTRECOUNT: 'VW_INITIALES_SERIES'; Filtre: 'SERIES_BY_INITIALE(?)';
      FIELDS: 'ID_SERIE, TITRESERIE, ID_EDITEUR, NOMEDITEUR, ID_COLLECTION, NOMCOLLECTION';
      INITIALEFIELDS: 'INITIALETITRESERIE'; INITIALEVALUE: 'INITIALETITRESERIE'; REFFIELDS: 'ID_SERIE'; TABLESEARCH: 'SERIES';
      FIELDSEARCH: 'TITRESERIE';
      ClassPointeur: TSerieLite; ClassDao: TDaoSerieLite
    ),
    ( // vmAlbumsAnnee
      FILTRECOUNT: 'ANNEES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_ANNEE(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'ANNEEPARUTION'; INITIALEVALUE: 'ANNEEPARUTION'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmAlbumsCollection
      FILTRECOUNT: 'COLLECTIONS_ALBUMS(?)'; Filtre: 'ALBUMS_BY_COLLECTION(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'NOMCOLLECTION'; INITIALEVALUE: 'ID_COLLECTION'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_COLLECTIONS_ALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmAlbumsEditeur
      FILTRECOUNT: 'EDITEURS_ALBUMS(?)'; Filtre: 'ALBUMS_BY_EDITEUR(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'NOMEDITEUR'; INITIALEVALUE: 'ID_EDITEUR'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_EDITEURS_ALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmAlbumsGenre
      FILTRECOUNT: 'GENRES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_GENRE(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'GENRE'; INITIALEVALUE: 'ID_GENRE'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_GENRES_ALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmAlbumsSerie
      FILTRECOUNT: 'SERIES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_SERIE(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'TITRESERIE'; INITIALEVALUE: 'ID_SERIE'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmParaBDSerie
      FILTRECOUNT: 'SERIES_PARABD(?)'; Filtre: 'PARABD_BY_SERIE(?, ?)';
      FIELDS: 'ID_PARABD, TITREPARABD, ID_SERIE, TITRESERIE, ACHAT, COMPLET, SCATEGORIE';
      INITIALEFIELDS: 'TITRESERIE'; INITIALEVALUE: 'ID_SERIE'; REFFIELDS: 'ID_PARABD'; TABLESEARCH: 'VW_LISTE_PARABD';
      FIELDSEARCH: 'COALESCE(TITREPARABD, TITRESERIE)';
      SEARCHORDER: 'COALESCE(TITREPARABD, TITRESERIE)';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TParaBDLite; ClassDao: TDaoParaBDLite
    ),
    ( // vmAchatsAlbumsEditeur
      FILTRECOUNT: 'EDITEURS_ACHATALBUMS(?)'; Filtre: 'ACHATALBUMS_BY_EDITEUR(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'NOMEDITEUR'; INITIALEVALUE: 'ID_EDITEUR'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_EDITEURS_ACHATALBUMS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'ACHAT = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmUnivers
      FILTRECOUNT: 'INITIALES_UNIVERS(?)'; Filtre: 'UNIVERS_BY_INITIALE(?, ?)';
      FIELDS: 'ID_UNIVERS, NOMUNIVERS';
      INITIALEFIELDS: 'INITIALENOMUNIVERS'; INITIALEVALUE: 'INITIALENOMUNIVERS'; REFFIELDS: 'ID_UNIVERS'; TABLESEARCH: 'UNIVERS';
      FIELDSEARCH: 'NOMUNIVERS';
      ClassPointeur: TUniversLite; ClassDao: TDaoUniversLite
    ),
    ( // vmAlbumsSerieUnivers
      FILTRECOUNT: 'SERIES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_SERIE(?, ?)';
      FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
      INITIALEFIELDS: 'TITRESERIE'; INITIALEVALUE: 'ID_SERIE'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS_UNIVERS';
      FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
      SEARCHORDER:
        'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TAlbumLite; ClassDao: TDaoAlbumLite
    ),
    ( // vmParaBDSerieUnivers
      FILTRECOUNT: 'SERIES_PARABD(?)'; Filtre: 'PARABD_BY_SERIE(?, ?)';
      FIELDS: 'ID_PARABD, TITREPARABD, ID_SERIE, TITRESERIE, ACHAT, COMPLET, SCATEGORIE';
      INITIALEFIELDS: 'TITRESERIE'; INITIALEVALUE: 'ID_SERIE'; REFFIELDS: 'ID_PARABD'; TABLESEARCH: 'VW_LISTE_PARABD_UNIVERS';
      FIELDSEARCH: 'COALESCE(TITREPARABD, TITRESERIE)';
      SEARCHORDER: 'COALESCE(TITREPARABD, TITRESERIE)';
      DEFAULTFILTRE: 'COMPLET = 1';
      ClassPointeur: TParaBDLite; ClassDao: TDaoParaBDLite
    )
  );

implementation

uses
  UIB, BDTK.GUI.DataModules.Main, BD.Utils.StrUtils, System.Types, UIBLib, Divers, BD.Entities.Common,
  BD.DB.Connection;

type
  TNodeData = TObjectList<TBaseLite>;

{ TVirtualStringTree }

class constructor TVirtualStringTree.InitializeClass;
begin
  inherited;
  FInstances := TList<TVirtualStringTree>.Create;
end;

class destructor TVirtualStringTree.FinalizeClass;
begin
  FInstances.Free;
  inherited;
end;

class procedure TVirtualStringTree.InitializeRep(AModes: TVirtualModes; AExcept: TVirtualStringTree);
var
  Tree: TVirtualStringTree;
begin
  for Tree in FInstances do
    if (Tree.Mode in AModes) then
      Tree.InitializeRep(Tree <> AExcept);
end;

class procedure TVirtualStringTree.InitializeRep(AParentModes: TVirtualModes; AChildModes: TVirtualModes; ARemovedId: TGUID);
var
  Tree: TVirtualStringTree;
  FindIndexNode: Boolean;
begin
  for Tree in FInstances do
  begin
    if (Tree.Mode in AParentModes) then
      FindIndexNode := (ARemovedId <> GUID_NULL) and (Tree.CurrentValue = ARemovedId)
    else if (Tree.Mode in AChildModes) then
      FindIndexNode := (ARemovedId <> GUID_NULL) and (Tree.CurrentValue <> GUID_NULL) and (Tree.GetNodeBasePointer(Tree.GetFirstSelected).ID = ARemovedId)
    else
      Continue;

    if FindIndexNode then
    begin
      Tree.MemorizeIndexNode;
      Tree.InitializeRep(False);
      Tree.FindIndexNode;
      Tree.ClearIndexNode;
    end
    else
    begin
      Tree.InitializeRep;
    end;
  end;
end;

constructor TVirtualStringTree.Create(AOwner: TComponent);
begin
  inherited;
  TreeOptions.StringOptions := TreeOptions.StringOptions + [toShowStaticText];
  Indent := 8;
  FShowAchat := True;
  FShowDateParutionAlbum := False;
  FUseFiltre := False;
  FUseDefaultFiltre := True;
  SetLength(FFindArray, 0);
  FLastFindText := '';
end;

destructor TVirtualStringTree.Destroy;
begin
  inherited;
end;

procedure TVirtualStringTree.AfterConstruction;
begin
  inherited;
  FInstances.Add(Self);
end;

procedure TVirtualStringTree.BeforeDestruction;
begin
  FInstances.Remove(Self);
  inherited;
end;

procedure TVirtualStringTree.ClearIndexNode;
begin
  FMemorizedIndexNode := False;
end;

procedure TVirtualStringTree.DoAfterPaint(Canvas: TCanvas);
const
  s = 'Pas d''éléments à afficher.';
var
  Ext: TSize;
  p: TPoint;
begin
  inherited;
  if RootNodeCount = 0 then
  begin
    Ext := Canvas.TextExtent(s);
    p.X := (Width - Ext.cx) div 2;
    p.Y := (Height - Ext.cy) div 2;
    if p.X < 0 then
      p.X := 0;
    if p.Y < 0 then
      p.Y := 0;
    Canvas.Font.Assign(Font);
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(p.X, p.Y, s);
  end;
end;

procedure TVirtualStringTree.DoCollapsed(Node: PVirtualNode);
begin
  inherited;
  if HasAsParent(FocusedNode, Node) then
    CurrentValue := GUID_NULL;
end;

procedure TVirtualStringTree.DoFreeNode(Node: PVirtualNode);
begin
  if FMode <> vmNone then
    GetNodeData<TNodeData>(Node).Free;
  inherited;
end;

procedure TVirtualStringTree.DoGetText(var pEventArgs: TVSTGetCellTextEventArgs);
var
  PA: TAlbumLite;
begin
  inherited;
  if FMode = vmNone then
    Exit;

  pEventArgs.CellText := '';
  if GetNodeLevel(pEventArgs.Node) > 0 then
  begin
    case FMode of
      vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAchatsAlbumsEditeur, vmAlbumsSerieUnivers:
        begin
          PA := GetNodeBasePointer(pEventArgs.Node) as TAlbumLite;
          case Header.Columns.Count of
            2:
              case pEventArgs.Column of
                0:
                  begin
                    pEventArgs.CellText := PA.ChaineAffichage(False);
                    if FShowDateParutionAlbum then
                      AjoutString(pEventArgs.CellText, IfThen(PA.MoisParution > 0, FormatSettings.ShortMonthNames[PA.MoisParution] + ' ', '') +
                        NonZero(IntToStr(PA.AnneeParution)), ' - ');
                  end;
                1:
                  pEventArgs.CellText := FormatTitre(PA.Serie);
              end;
            4:
              case pEventArgs.Column of
                0:
                  pEventArgs.CellText := FormatTitre(PA.Titre);
                1:
                  pEventArgs.CellText := NonZero(IntToStr(PA.Tome));
                2:
                  pEventArgs.CellText := IfThen(PA.MoisParution > 0, FormatSettings.ShortMonthNames[PA.MoisParution] + ' ', '') + NonZero(IntToStr(PA.AnneeParution));
                3:
                  pEventArgs.CellText := FormatTitre(PA.Serie);
              end;
            else
              begin
                pEventArgs.CellText := PA.ChaineAffichage(FMode <> vmAlbumsSerie);
                if FShowDateParutionAlbum then
                  AjoutString(pEventArgs.CellText, IfThen(PA.MoisParution > 0, FormatSettings.ShortMonthNames[PA.MoisParution] + ' ', '') +
                    NonZero(IntToStr(PA.AnneeParution)), ' - ');
              end;
          end;
        end;
      vmPersonnes, vmGenres, vmEditeurs, vmUnivers:
        begin
          pEventArgs.CellText := GetNodeBasePointer(pEventArgs.Node).ChaineAffichage(True);
        end;
      vmCollections:
        begin
          pEventArgs.CellText := GetNodeBasePointer(pEventArgs.Node).ChaineAffichage(FUseFiltre and (Pos('id_editeur', LowerCase(FFiltre)) > 0));
        end;
      vmSeries:
        begin
          pEventArgs.CellText := GetNodeBasePointer(pEventArgs.Node).ChaineAffichage(False);
        end;
      vmParaBDSerie, vmParaBDSerieUnivers:
        begin
          pEventArgs.CellText := GetNodeBasePointer(pEventArgs.Node).ChaineAffichage(False);
        end;
    end;
  end
  else
  begin
    if (pEventArgs.Column = 0) or (pEventArgs.Column = -1) then
    begin
      if FCountPointers[pEventArgs.Node.Index].Initiale <> '-1' then
        pEventArgs.CellText := FCountPointers[pEventArgs.Node.Index].Initiale
      else
        case FMode of
          vmAlbumsSerie, vmAlbumsSerieUnivers, vmParaBDSerie, vmParaBDSerieUnivers:
            pEventArgs.CellText := '<Sans série>';
          else
            pEventArgs.CellText := '<Inconnu>';
        end;
      AjoutString(pEventArgs.StaticText, NonZero(IntToStr(FCountPointers[pEventArgs.Node.Index].Count)), ' ', '(', ')');
    end;
  end;
end;

function TVirtualStringTree.DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal): Boolean;
var
  List: TList<TBaseLite>;
  q: TManagedQuery;
begin
  if (FMode <> vmNone) and (GetNodeLevel(Node) = 0) then
  begin
    ChildCount := FCountPointers[Node.Index].Count;
    List := GetNodeData<TNodeData>(Node);
    List.Clear;
    q := dmPrinc.DBConnection.GetQuery;
    try
      q.SQL.Text := 'select ' + vmModeInfos[FMode].FIELDS + ' from ' + vmModeInfos[FMode].Filtre;
      q.Prepare(True);
      case q.Params.FieldType[0] of
        uftChar, uftVarchar, uftCstring:
          q.Params.AsString[0] := Copy(FCountPointers[Node.Index].sValue, 1, q.Params.MaxStrLen[0]);
        uftSmallint:
          q.Params.AsSmallint[0] := FCountPointers[Node.Index].sValue.ToInteger;
      end;
      if FUseFiltre then
        q.Params.AsString[1] := Copy(FFiltre, 1, q.Params.MaxStrLen[1])
      else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
        q.Params.AsString[1] := Copy(vmModeInfos[FMode].DEFAULTFILTRE, 1, q.Params.MaxStrLen[1]);
      q.Open;
      vmModeInfos[FMode].ClassDao.FillList(List, q);

      Assert(Cardinal(List.Count) = ChildCount);
    finally
      q.Free;
    end;
    Result := True;
  end
  else
    Result := inherited DoInitChildren(Node, ChildCount);
end;

procedure TVirtualStringTree.DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates);
var
  NodeData: TNodeData;
begin
  if FMode <> vmNone then
    if GetNodeLevel(Node) > 0 then
    begin
      InitStates := InitStates - [ivsHasChildren];
    end
    else
    begin
      NodeData := GetNodeData<TNodeData>(Node);
      if not Assigned(NodeData) then
      begin
        NodeData := TNodeData.Create(True);
        SetNodeData<TNodeData>(Node, NodeData);
      end;
      if FCountPointers[Node.Index].Count > 0 then
        InitStates := InitStates + [ivsHasChildren]
      else
        InitStates := InitStates + [ivsDisabled];
    end;
  inherited;
end;

procedure TVirtualStringTree.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if (FMode <> vmNone) and (TextType = ttNormal) then
    if (GetNodeLevel(Node) = 0) then
    begin
      Canvas.Font.Height := -11;
      Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    end
    else
      case FMode of
        vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAchatsAlbumsEditeur, vmAlbumsSerieUnivers:
          if FShowAchat and TAlbumLite(GetNodeBasePointer(Node)).Achat then
            Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
        vmParaBDSerie, vmParaBDSerieUnivers:
          if FShowAchat and TParaBDLite(GetNodeBasePointer(Node)).Achat then
            Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
      end;
  inherited;
end;

procedure TVirtualStringTree.Find(const Text: string; GetNext: Boolean = False);
var
  iCurrent, iFind: TGUID;
  nCurrent, nFind: PVirtualNode;
  i: Integer;
  Query: TManagedQuery;
begin
  GetNext := GetNext and SameText(Text, FLastFindText);
  FLastFindText := Text;
  if FMode = vmNone then
  begin
    nCurrent := nil;
    if GetNext then
      nCurrent := GetFirstSelected;
    if nCurrent = nil then
      nCurrent := GetFirst;
    nFind := nil;
    while nFind <> nCurrent do
    begin
      if nFind = nil then
        if GetNext then
          nFind := Self.GetNext(nCurrent)
        else
          nFind := nCurrent;
      if DoCompareNodeString(nFind, Text) then
        Break;
      nFind := Self.GetNext(nFind);
      if nFind = nil then
        nFind := GetFirst;
    end;
    ClearSelection;
    if Assigned(nFind) then
      FocusedNode := nFind
    else
      FocusedNode := nil;
    Selected[nFind] := True;
  end
  else
  begin
    if Text = '' then
    begin
      CurrentValue := GUID_NULL;
      SetLength(FFindArray, 0);
    end
    else if GetNext and (Length(FFindArray) > 0) then
    begin
      iCurrent := CurrentValue;
      iFind := FFindArray[0];
      for i := 0 to Pred(Length(FFindArray)) do
        if IsEqualGUID(FFindArray[i], iCurrent) then
        begin
          // pas besoin de tester si on est sur le dernier: on ne peut pas puisque c'est une copie du premier
          iFind := FFindArray[i + 1];
          Break;
        end;
      CurrentValue := iFind;
    end
    else
    begin
      Query := dmPrinc.DBConnection.GetQuery;
      try
        Query.SQL.Text := 'SELECT ' + vmModeInfos[FMode].REFFIELDS + ' FROM ' + vmModeInfos[FMode].TABLESEARCH + ' WHERE ' + vmModeInfos[FMode].FIELDSEARCH +
          ' LIKE ''%'' || ? || ''%''';
        if FUseFiltre then
          Query.SQL.Add('AND ' + FFiltre)
        else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
          Query.SQL.Add('AND ' + vmModeInfos[FMode].DEFAULTFILTRE);
        Query.SQL.Add('ORDER BY ' + vmModeInfos[FMode].INITIALEFIELDS + ',');
        if vmModeInfos[FMode].SEARCHORDER <> '' then
          Query.SQL.Add(vmModeInfos[FMode].SEARCHORDER + ',');
        Query.SQL.Add(vmModeInfos[FMode].FIELDSEARCH);
        Query.Prepare(True);
        Query.Params.AsString[0] := Copy(UpperCase(SansAccents(Text)), 1, Query.Params.MaxStrLen[0] - 2);

        Query.Open;
        SetLength(FFindArray, 0);
        i := 0;
        while not Query.Eof do
        begin
          Inc(i);
          // pour gagner en rapidité, on alloue par espace de 250 positions
          if i > Length(FFindArray) then
            SetLength(FFindArray, i + 250);
          FFindArray[i - 1] := StringToGUID(Query.Fields.AsString[0]);
          Query.Next;
        end;
        // on retire ce qui est alloué en trop
        SetLength(FFindArray, i + 1);
        // recopie du permier à la fin pour pouvoir boucler la recherche
        FFindArray[i] := FFindArray[0];

        if Length(FFindArray) = 0 then
          CurrentValue := GUID_NULL
        else
          CurrentValue := FFindArray[0];
      finally
        Query.Free;
      end;
    end;
  end;
end;

procedure TVirtualStringTree.FindIndexNode;
var
  Node: PVirtualNode;
begin
  if FMemorizedIndexNode then
  begin
    Node := GetFirst;
    while Assigned(Node) and (Node.Index <> FIndexNode) do
      Node := GetNextSibling(Node);
    if Assigned(Node) then
    begin
      FocusedNode := Node;
      Selected[Node] := True;
      Expanded[Node] := True;
      ScrollIntoView(Node, True);
    end;
  end;
end;

function TVirtualStringTree.GetCurrentValue: TGUID;
var
  Node: PVirtualNode;
begin
  Result := GUID_NULL;
  if FMode <> vmNone then
  begin
    Node := GetFirstSelected;
    if GetNodeLevel(Node) > 0 then
      Result := GetNodeBasePointer(Node).ID;
  end;
end;

function TVirtualStringTree.GetFocusedNodeCaption: UnicodeString;
var
  Node: PVirtualNode;
begin
  Result := '';
  Node := GetFirstSelected;
  if GetNodeLevel(Node) > 0 then
    if Header.Columns.Count = 0 then
      Result := Text[Node, -1]
    else
      Result := Text[Node, 0];
end;

function TVirtualStringTree.GetFocusedNodeFullCaption: UnicodeString;
var
  Node: PVirtualNode;
begin
  Result := '';
  Node := GetFirstSelected;
  if GetNodeLevel(Node) > 0 then
    if GetNodeBasePointer(Node) is TAlbumLite then
      Result := TAlbumLite(GetNodeBasePointer(Node)).ChaineAffichage(True)
    else if Header.Columns.Count = 0 then
      Result := Text[Node, -1]
    else
      Result := Text[Node, 0];
end;

function TVirtualStringTree.GetNodeBasePointer(Node: PVirtualNode): TBaseLite;
begin
  Result := nil;
  if GetNodeLevel(Node) > 0 then
    Result := GetNodeData<TNodeData>(Node.Parent).List[Node.Index];
end;

function TVirtualStringTree.GetNodeByValue(const Value: TGUID): PVirtualNode;
var
  DefaultValue: string;
  Node: PVirtualNode;
  init: Cardinal;
  cs: string;
  Query: TManagedQuery;
begin
  Result := nil;
  if IsEqualGUID(Value, GUID_NULL) then
    Exit;

  case FMode of
    vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmParaBDSerie, vmAchatsAlbumsEditeur, vmAlbumsSerieUnivers, vmParaBDSerieUnivers:
      DefaultValue := '';
    else
      DefaultValue := '-1';
  end;

  Query := dmPrinc.DBConnection.GetQuery;
  try
    Query.SQL.Text :=
      'SELECT coalesce(' + vmModeInfos[FMode].INITIALEVALUE + ', ''' + DefaultValue + ''')' +
      ' FROM ' + vmModeInfos[FMode].TABLESEARCH +
      ' WHERE ' + vmModeInfos[FMode].REFFIELDS + ' = ?';
    Query.Params.AsString[0] := GUIDToString(Value);
    Query.Open;
    if Query.Eof then
      Exit;

    cs := Trim(Query.Fields.AsString[0]);
  finally
    Query.Free;
  end;

  init := 0;
  while (Integer(init) < Length(FCountPointers)) and (FCountPointers[init].sValue <> cs) do
    Inc(init);

  Node := GetFirst;
  while Assigned(Node) and (Node.Index <> init) do
    Node := Node.NextSibling;
  Result := nil;
  if Assigned(Node) then
  begin
    InitNode(Node);
    InitChildren(Node);
    Result := Node.FirstChild;
    while Assigned(Result) and InitNode(Result) and (not IsEqualGUID(GetNodeBasePointer(Result).ID, Value)) do
      Result := Result.NextSibling;
  end;
end;

function TVirtualStringTree.GetFocusedNodeData: TBaseLite;
begin
  Result := nil;
  if FMode <> vmNone then
  begin
    Result := GetNodeBasePointer(GetFirstSelected);
  end;
end;

procedure TVirtualStringTree.InitializeRep(KeepValue: Boolean = True);
var
  i: Integer;
  iCurrent: TGUID;
  Query: TManagedQuery;
begin
  iCurrent := CurrentValue;
  Clear;
  if FMode <> vmNone then
  begin
    Query := dmPrinc.DBConnection.GetQuery;
    BeginUpdate;
    try
      Query.SQL.Text := 'SELECT * FROM ' + vmModeInfos[FMode].FILTRECOUNT;
      Query.Prepare(True);
      if FUseFiltre then
        Query.Params.AsString[0] := Copy(FFiltre, 1, Query.Params.MaxStrLen[0])
      else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
        Query.Params.AsString[0] := Copy(vmModeInfos[FMode].DEFAULTFILTRE, 1, Query.Params.MaxStrLen[0]);
      Query.Open;

      SetLength(FCountPointers, 0);
      i := 0;
      while not Query.Eof do
      begin
        // on alloue par plage de 250 pour eviter de le faire trop souvent
        if Length(FCountPointers) <= i then
          SetLength(FCountPointers, Length(FCountPointers) + 250);
        FCountPointers[i].Count := Query.Fields.AsInteger[1];
        FCountPointers[i].Initiale := Query.Fields.AsString[0];
        if FMode in [vmAlbumsSerie, vmAlbumsEditeur, vmAlbumsCollection, vmAchatsAlbumsEditeur, vmAlbumsSerieUnivers, vmParaBDSerie, vmParaBDSerieUnivers] then
          FCountPointers[i].Initiale := FormatTitre(FCountPointers[i].Initiale);
        if FMode = vmAlbumsCollection then
          AjoutString(FCountPointers[i].Initiale, FormatTitre(Query.Fields.AsString[3]), ' ', '(', ')');
        FCountPointers[i].sValue := Query.Fields.ByNameAsString[vmModeInfos[FMode].INITIALEVALUE];
        Query.Next;
        Inc(i);
      end;
      // on retire ce qui a été alloué en trop
      SetLength(FCountPointers, i);

      RootNodeCount := Length(FCountPointers);
    finally
      Query.Free;
      EndUpdate;
    end;
  end;
  if KeepValue then
    CurrentValue := iCurrent;
  SetLength(FFindArray, 0);
end;

function TVirtualStringTree.InitNode(Node: PVirtualNode): Boolean;
begin
  if not (vsInitialized in Node.States) then
    inherited InitNode(Node);
  Result := True;
end;

procedure TVirtualStringTree.MakeVisibleValue(const Value: TGUID);
var
  ChildNode: PVirtualNode;
begin
  if FMode = vmNone then
    Exit;

  ChildNode := GetNodeByValue(Value);
  if Assigned(ChildNode) then
    FocusedNode := ChildNode
  else
    FocusedNode := nil;
end;

procedure TVirtualStringTree.MemorizeIndexNode;
begin
  FMemorizedIndexNode := (not IsEqualGUID(CurrentValue, GUID_NULL)) and (FocusedNode.Parent.ChildCount > 1);
  if FMemorizedIndexNode then
    FIndexNode := FocusedNode.Parent.Index;
end;

procedure TVirtualStringTree.ReinitNodes(NodeLevel: Integer);
var
  oldNode, Node: PVirtualNode;
begin
  if NodeLevel = -1 then
    Node := RootNode
  else
  begin
    Node := GetFirstNoInit;
    while Assigned(Node) and (GetNodeLevel(Node) <> Cardinal(NodeLevel)) do
      Node := GetNextNoInit(Node);

    if Assigned(Node) and (GetNodeLevel(Node) <> Cardinal(NodeLevel)) then
      // i.e. there is no node with the desired level in the tree
      Node := nil;
  end;

  if not Assigned(Node) then
    Exit;

  while Assigned(Node) do
  begin
    oldNode := Node;
    ReinitNode(Node.Parent, True);
    InvalidateChildren(Node.Parent, True);

    Node := oldNode.Parent.NextSibling;
    if Assigned(Node) then
    begin
      while Assigned(Node) and (GetNodeLevel(Node) <> Cardinal(NodeLevel)) do
        Node := GetNextNoInit(Node);
      if Assigned(Node) and (GetNodeLevel(Node) <> Cardinal(NodeLevel)) then
        // i.e. there is no node with the desired level in the tree
        Node := nil;
    end;
  end;

end;

procedure TVirtualStringTree.SetCurrentValue(const Value: TGUID);
begin
  if FMode = vmNone then
    Exit;

  MakeVisibleValue(Value);
  if Assigned(FocusedNode) then
    Selected[FocusedNode] := True
  else
    ClearSelection;
  FocusedColumn := -1;
end;

procedure TVirtualStringTree.SetFiltre(const Value: string);
begin
  FFiltre := Value;
  if FUseFiltre then
    InitializeRep(True);
end;

procedure TVirtualStringTree.SetMode(const Value: TVirtualMode);
begin
  Clear;
  FMode := Value;
  InitializeRep(False);
end;

procedure TVirtualStringTree.SetShowAchat(const Value: Boolean);
begin
  FShowAchat := Value;
  InitializeRep(True);
end;

procedure TVirtualStringTree.SetShowDateParutionAlbum(const Value: Boolean);
begin
  FShowDateParutionAlbum := Value;
  InitializeRep(True);
end;

procedure TVirtualStringTree.SetUseDefaultFiltre(const Value: Boolean);
begin
  FUseDefaultFiltre := Value;
  InitializeRep(True);
end;

procedure TVirtualStringTree.SetUseFiltre(const Value: Boolean);
begin
  FUseFiltre := Value;
  InitializeRep(True);
end;

function TVirtualStringTree.DoCompareNodeString(Node: PVirtualNode; const Text: string): Boolean;
begin
  if Assigned(FOnCompareNodeString) then
  begin
    Result := False;
    FOnCompareNodeString(Self, Node, Text, Result);
  end
  else
    Result := True;
end;

end.

