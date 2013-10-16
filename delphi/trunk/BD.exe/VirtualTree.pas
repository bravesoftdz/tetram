unit VirtualTree;

{ .$D- }

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, VirtualTrees, VirtualTreeBdtk,
  EditLabeled, TypeRec, StrUtils, LinkControls
{$IFDEF DEBUG}, Clipbrd{$ENDIF}
    ;

type
  PInitialeInfo = ^RInitialeInfo;

  RInitialeInfo = record
    Initiale: string;
    Count: Integer;
    sValue: string;
  end;

  PNodeInfo = ^RNodeInfo;

  RNodeInfo = record
    List: TList;
    // PDetail: Pointer;
    InitialeInfo: PInitialeInfo;
    Detail: TBasePointeur;
  end;

  // !!! Les valeurs ne doivent pas être changées
  TVirtualMode = (vmNone = 0, vmAlbums = 1, vmCollections = 2, vmEditeurs = 3, {vmEmprunteurs = 4, }vmGenres = 5, vmPersonnes = 6, vmSeries = 7,
    vmAlbumsAnnee = 8, vmAlbumsCollection = 9, vmAlbumsEditeur = 10, vmAlbumsGenre = 11, vmAlbumsSerie = 12, vmParaBDSerie = 13, vmAchatsAlbumsEditeur = 14,
    vmUnivers = 15, vmAlbumsUnivers = 16, vmParaBDUnivers = 17);

  TOnCompareNodeString = procedure(Sender: TBaseVirtualTree; Node: PVirtualNode; const Text: string; var Concorde: Boolean) of object;

  TVirtualStringTree = class(VirtualTreeBdtk.TVirtualStringTree)
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: UnicodeString); override;
  protected
    procedure DoFreeNode(Node: PVirtualNode); override;
    procedure DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal); override;
    function InitNode(Node: PVirtualNode): Boolean; reintroduce;
    procedure DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType); override;
    procedure DoAfterPaint(Canvas: TCanvas); override;
    procedure DoCollapsed(Node: PVirtualNode); override;
    function DoCompareNodeString(Node: PVirtualNode; const Text: string): Boolean; virtual;
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
    function GetNodeBasePointer(Node: PVirtualNode): TBasePointeur;
    function GetFocusedNodeData: Pointer;
    procedure InitializeRep(KeepValue: Boolean = True);
    procedure ReinitNodes(NodeLevel: Integer = -1);
    procedure Find(const Text: string; GetNext: Boolean = False);
    procedure MemorizeIndexNode;
    procedure FindIndexNode;
    procedure ClearIndexNode;
    procedure MakeVisibleValue(const Value: TGUID);
  end;

type
  RModeInfo = record
    FILTRECOUNT, Filtre, FIELDS: string;
    INITIALEFIELDS, INITIALEVALUE, REFFIELDS: string;
    TABLESEARCH: string;
    FIELDSEARCH: string;
    SEARCHORDER: string;
    WHERECONDITION: string;
    DEFAULTFILTRE: string;
  end;

const
  vmModeInfos: array [TVirtualMode] of RModeInfo = ((),
    ( // vmAlbums
    FILTRECOUNT: 'INITIALES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_INITIALE(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'INITIALETITREALBUM'; INITIALEVALUE: 'INITIALETITREALBUM'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'TITREALBUM, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmCollections
    FILTRECOUNT: 'INITIALES_COLLECTIONS(?)'; Filtre: 'COLLECTIONS_BY_INITIALE(?, ?)';
    FIELDS: 'ID_COLLECTION, NOMCOLLECTION, id_editeur, nomediteur';
    INITIALEFIELDS: 'INITIALENOMCOLLECTION'; INITIALEVALUE: 'INITIALENOMCOLLECTION'; REFFIELDS: 'ID_COLLECTION'; TABLESEARCH: 'COLLECTIONS';
    FIELDSEARCH: 'NOMCOLLECTION'),
    ( // vmEditeurs
    FILTRECOUNT: 'VW_INITIALES_EDITEURS'; Filtre: 'EDITEURS_BY_INITIALE(?)';
    FIELDS: 'ID_EDITEUR, NOMEDITEUR';
    INITIALEFIELDS: 'INITIALENOMEDITEUR'; INITIALEVALUE: 'INITIALENOMEDITEUR'; REFFIELDS: 'ID_EDITEUR'; TABLESEARCH: 'EDITEURS';
    FIELDSEARCH: 'NOMEDITEUR'),
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
    FIELDSEARCH: 'GENRE'),
    ( // vmPersonnes
    FILTRECOUNT: 'VW_INITIALES_PERSONNES'; Filtre: 'PERSONNES_BY_INITIALE(?)';
    FIELDS: 'ID_PERSONNE, NOMPERSONNE';
    INITIALEFIELDS: 'INITIALENOMPERSONNE'; INITIALEVALUE: 'INITIALENOMPERSONNE'; REFFIELDS: 'ID_PERSONNE'; TABLESEARCH: 'PERSONNES';
    FIELDSEARCH: 'NOMPERSONNE'),
    ( // vmSeries
    FILTRECOUNT: 'VW_INITIALES_SERIES'; Filtre: 'SERIES_BY_INITIALE(?)';
    FIELDS: 'ID_SERIE, TITRESERIE, ID_EDITEUR, NOMEDITEUR, ID_COLLECTION, NOMCOLLECTION';
    INITIALEFIELDS: 'INITIALETITRESERIE'; INITIALEVALUE: 'INITIALETITRESERIE'; REFFIELDS: 'ID_SERIE'; TABLESEARCH: 'SERIES';
    FIELDSEARCH: 'TITRESERIE'),
    ( // vmAlbumsAnnee
    FILTRECOUNT: 'ANNEES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_ANNEE(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'ANNEEPARUTION'; INITIALEVALUE: 'ANNEEPARUTION'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmAlbumsCollection
    FILTRECOUNT: 'COLLECTIONS_ALBUMS(?)'; Filtre: 'ALBUMS_BY_COLLECTION(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'NOMCOLLECTION'; INITIALEVALUE: 'ID_COLLECTION'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_COLLECTIONS_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmAlbumsEditeur
    FILTRECOUNT: 'EDITEURS_ALBUMS(?)'; Filtre: 'ALBUMS_BY_EDITEUR(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'NOMEDITEUR'; INITIALEVALUE: 'ID_EDITEUR'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_EDITEURS_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmAlbumsGenre
    FILTRECOUNT: 'GENRES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_GENRE(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'GENRE'; INITIALEVALUE: 'ID_GENRE'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_GENRES_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmAlbumsSerie
    FILTRECOUNT: 'SERIES_ALBUMS(?)'; Filtre: 'ALBUMS_BY_SERIE(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'TITRESERIE'; INITIALEVALUE: 'ID_SERIE'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmParaBDSerie
    FILTRECOUNT: 'SERIES_PARABD(?)'; Filtre: 'PARABD_BY_SERIE(?, ?)';
    FIELDS: 'ID_PARABD, TITREPARABD, ID_SERIE, TITRESERIE, ACHAT, COMPLET, SCATEGORIE';
    INITIALEFIELDS: 'TITRESERIE'; INITIALEVALUE: 'ID_SERIE'; REFFIELDS: 'ID_PARABD'; TABLESEARCH: 'VW_LISTE_PARABD';
    FIELDSEARCH: 'COALESCE(TITREPARABD, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREPARABD, TITRESERIE)';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmAchatsAlbumsEditeur
    FILTRECOUNT: 'EDITEURS_ACHATALBUMS(?)'; Filtre: 'ACHATALBUMS_BY_EDITEUR(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'NOMEDITEUR'; INITIALEVALUE: 'ID_EDITEUR'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_EDITEURS_ACHATALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'ACHAT = 1'),
    ( // vmUnivers
    FILTRECOUNT: 'INITIALES_UNIVERS(?)'; Filtre: 'UNIVERS_BY_INITIALE(?, ?)';
    FIELDS: 'ID_UNIVERS, NOMUNIVERS';
    INITIALEFIELDS: 'INITIALENOMUNIVERS'; INITIALEVALUE: 'INITIALENOMUNIVERS'; REFFIELDS: 'ID_UNIVERS'; TABLESEARCH: 'UNIVERS';
    FIELDSEARCH: 'NOMUNIVERS'),
    ( // vmAlbumsUnivers
    FILTRECOUNT: 'UNIVERS_ALBUMS(?)'; Filtre: 'ALBUMS_BY_UNIVERS(?, ?)';
    FIELDS: 'ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, HORSSERIE, INTEGRALE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE, TITRESERIE, ACHAT, COMPLET, NOTATION';
    INITIALEFIELDS: 'NOMUNIVERS'; INITIALEVALUE: 'ID_UNIVERS'; REFFIELDS: 'ID_ALBUM'; TABLESEARCH: 'VW_LISTE_ALBUMS';
    FIELDSEARCH: 'COALESCE(TITREALBUM, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREALBUM, TITRESERIE), HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST';
    DEFAULTFILTRE: 'COMPLET = 1'),
    ( // vmParaBDUnivers
    FILTRECOUNT: 'UNIVERS_PARABD(?)'; Filtre: 'PARABD_BY_UNIVERS(?, ?)';
    FIELDS: 'ID_PARABD, TITREPARABD, ID_SERIE, TITRESERIE, ACHAT, COMPLET, SCATEGORIE';
    INITIALEFIELDS: 'NOMUNIVERS'; INITIALEVALUE: 'ID_UNIVERS'; REFFIELDS: 'ID_PARABD'; TABLESEARCH: 'VW_LISTE_PARABD';
    FIELDSEARCH: 'COALESCE(TITREPARABD, TITRESERIE)';
    SEARCHORDER: 'COALESCE(TITREPARABD, TITRESERIE)';
    DEFAULTFILTRE: 'COMPLET = 1')
  );

implementation

uses
  UIB, UdmPrinc, Commun, Types, UIBLib, Divers;

{ TVirtualStringTree }
procedure TVirtualStringTree.ClearIndexNode;
begin
  FMemorizedIndexNode := False;
end;

constructor TVirtualStringTree.Create(AOwner: TComponent);
begin
  inherited;
  TreeOptions.StringOptions := TreeOptions.StringOptions + [toShowStaticText];
  NodeDataSize := SizeOf(RNodeInfo);
  Indent := 8;
  FShowAchat := True;
  FShowDateParutionAlbum := False;
  FUseFiltre := False;
  FUseDefaultFiltre := True;
  SetLength(FFindArray, 0);
  FLastFindText := '';
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
var
  NodeInfo: ^RNodeInfo;
begin
  if FMode <> vmNone then
    if (GetNodeLevel(Node) = 0) then
    begin
      NodeInfo := GetNodeData(Node);
      if Assigned(NodeInfo.List) then
      begin
        TBasePointeur.VideListe(NodeInfo.List);
        NodeInfo.List.Free;
      end;
      // Finalize(NodeInfo^);
    end;
  inherited;
end;

procedure TVirtualStringTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: UnicodeString);
var
  PA: TAlbum;
begin
  Text := '';
  if FMode <> vmNone then
    if GetNodeLevel(Node) > 0 then
    begin
      if TextType = ttStatic then
        Exit;
      case FMode of
        vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAchatsAlbumsEditeur:
          begin
            PA := RNodeInfo(GetNodeData(Node)^).Detail as TAlbum;
            case Header.Columns.Count of
              2:
                case Column of
                  0:
                    begin
                      Text := PA.ChaineAffichage(False);
                      if FShowDateParutionAlbum then
                        AjoutString(Text, IfThen(PA.MoisParution > 0, FormatSettings.ShortMonthNames[PA.MoisParution] + ' ', '') +
                          NonZero(IntToStr(PA.AnneeParution)), ' - ');
                    end;
                  1:
                    Text := FormatTitre(PA.Serie);
                end;
              4:
                case Column of
                  0:
                    Text := FormatTitre(PA.Titre);
                  1:
                    Text := NonZero(IntToStr(PA.Tome));
                  2:
                    Text := IfThen(PA.MoisParution > 0, FormatSettings.ShortMonthNames[PA.MoisParution] + ' ', '') + NonZero(IntToStr(PA.AnneeParution));
                  3:
                    Text := FormatTitre(PA.Serie);
                end;
            else
              begin
                Text := PA.ChaineAffichage(FMode <> vmAlbumsSerie);
                if FShowDateParutionAlbum then
                  AjoutString(Text, IfThen(PA.MoisParution > 0, FormatSettings.ShortMonthNames[PA.MoisParution] + ' ', '') +
                    NonZero(IntToStr(PA.AnneeParution)), ' - ');
              end;
            end;
          end;
        vmPersonnes, vmGenres, vmEditeurs, vmUnivers:
          begin
            Text := RNodeInfo(GetNodeData(Node)^).Detail.ChaineAffichage(True);
          end;
        vmCollections:
          begin
            Text := RNodeInfo(GetNodeData(Node)^).Detail.ChaineAffichage(FUseFiltre and (Pos('id_editeur', LowerCase(FFiltre)) > 0));
          end;
        vmSeries:
          begin
            Text := RNodeInfo(GetNodeData(Node)^).Detail.ChaineAffichage(False);
          end;
        vmParaBDSerie:
          begin
            Text := RNodeInfo(GetNodeData(Node)^).Detail.ChaineAffichage(False);
          end;
      end;
    end
    else
    begin
      if (Column = 0) or (Column = -1) then
        if TextType = ttNormal then
          if FCountPointers[Node.Index].Initiale <> '-1' then
            Text := FCountPointers[Node.Index].Initiale
          else
            case FMode of
              vmAlbumsSerie, vmParaBDSerie:
                Text := '<Sans série>';
            else
              Text := '<Inconnu>';
            end
        else
          AjoutString(Text, NonZero(IntToStr(FCountPointers[Node.Index].Count)), ' ', '(', ')');
    end;
  inherited;
end;

procedure TVirtualStringTree.DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal);
type
  TClassBasePointeur = class of TBasePointeur;
var
  InfoNode: ^RNodeInfo;
  q: TUIBQuery;
  ClassPointeur: TClassBasePointeur;
begin
  if (FMode <> vmNone) and (GetNodeLevel(Node) = 0) then
  begin
    case FMode of
      vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAchatsAlbumsEditeur, vmAlbumsUnivers:
        ClassPointeur := TAlbum;
      vmPersonnes:
        ClassPointeur := TPersonnage;
      vmSeries:
        ClassPointeur := TSerie;
      vmGenres:
        ClassPointeur := TGenre;
      vmEditeurs:
        ClassPointeur := TEditeur;
      vmCollections:
        ClassPointeur := TCollection;
      vmParaBDSerie, vmParaBDUnivers:
        ClassPointeur := TParaBD;
      vmUnivers:
        ClassPointeur := TUnivers;
    else
      ClassPointeur := nil;
    end;

    ChildCount := FCountPointers[Node.Index].Count;
    InfoNode := GetNodeData(Node);
    if not Assigned(InfoNode.List) then
      InfoNode.List := TList.Create;
    q := TUIBQuery.Create(Self);
    with q do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        SQL.Text := 'SELECT ' + vmModeInfos[FMode].FIELDS + ' FROM ' + vmModeInfos[FMode].Filtre;
        Prepare(True);
        Params.AsString[0] := Copy(FCountPointers[Node.Index].sValue, 1, Params.MaxStrLen[0]);
        if FUseFiltre then
          Params.AsString[1] := Copy(FFiltre, 1, Params.MaxStrLen[1])
        else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
          Params.AsString[1] := Copy(vmModeInfos[FMode].DEFAULTFILTRE, 1, Params.MaxStrLen[1]);
        Open;
        ClassPointeur.FillList(InfoNode.List, q);
      finally
        Transaction.Free;
        Free;
      end;
  end;
  inherited;
end;

procedure TVirtualStringTree.DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := GetNodeData(Node);
  if FMode <> vmNone then
    if GetNodeLevel(Node) > 0 then
    begin
      NodeInfo.Detail := RNodeInfo(GetNodeData(Parent)^).List[Node.Index];
      InitStates := InitStates - [ivsHasChildren];
    end
    else
    begin
      if Assigned(NodeInfo.List) then
        TBasePointeur.VideListe(NodeInfo.List);
      FreeAndNil(NodeInfo.List);
      NodeInfo.InitialeInfo := @FCountPointers[Node.Index];
      if LongBool(FCountPointers[Node.Index].Count) then
        InitStates := InitStates + [ivsHasChildren]
      else
        InitStates := InitStates + [ivsDisabled];
    end;
  inherited;
end;

procedure TVirtualStringTree.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
var
  InfoNode: ^RNodeInfo;
begin
  InfoNode := GetNodeData(Node);
  if (FMode <> vmNone) and (TextType = ttNormal) then
    if (GetNodeLevel(Node) = 0) then
    begin
      Canvas.Font.Height := -11;
      Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    end
    else
      case FMode of
        vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAchatsAlbumsEditeur:
          if FShowAchat and TAlbum(InfoNode.Detail).Achat then
            Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
        vmParaBDSerie:
          if FShowAchat and TParaBD(InfoNode.Detail).Achat then
            Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
      end;
  inherited;
end;

procedure TVirtualStringTree.Find(const Text: string; GetNext: Boolean = False);
var
  iCurrent, iFind: TGUID;
  nCurrent, nFind: PVirtualNode;
  i: Integer;
begin
  if (Text <> FLastFindText) then
    GetNext := False;
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
    if (Length(FFindArray) = 0) then
      GetNext := False;
    if Text = '' then
    begin
      CurrentValue := GUID_NULL;
      SetLength(FFindArray, 0);
      Exit;
    end;
    if GetNext then
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
      with TUIBQuery.Create(nil) do
        try
          Transaction := GetTransaction(DMPrinc.UIBDataBase);
          SQL.Text := 'SELECT ' + vmModeInfos[FMode].REFFIELDS + ' FROM ' + vmModeInfos[FMode].TABLESEARCH + ' WHERE ' + vmModeInfos[FMode].FIELDSEARCH +
            ' LIKE ''%'' || ? || ''%''';
          if FUseFiltre then
            SQL.Add('AND ' + FFiltre)
          else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
            SQL.Add('AND ' + vmModeInfos[FMode].DEFAULTFILTRE);
          SQL.Add('ORDER BY ' + vmModeInfos[FMode].INITIALEFIELDS + ',');
          if vmModeInfos[FMode].SEARCHORDER <> '' then
            SQL.Add(vmModeInfos[FMode].SEARCHORDER + ',');
          SQL.Add(vmModeInfos[FMode].FIELDSEARCH);
          Prepare(True);
          Params.AsString[0] := Copy(UpperCase(SansAccents(Text)), 1, Params.MaxStrLen[0] - 2);

          Open;
          SetLength(FFindArray, 0);
          i := 0;
          while not Eof do
          begin
            Inc(i);
            // pour gagner en rapidité, on alloue par espace de 250 positions
            if i > Length(FFindArray) then
              SetLength(FFindArray, i + 250);
            FFindArray[i - 1] := StringToGUID(FIELDS.AsString[0]);
            Next;
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
          Transaction.Free;
          Free;
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
      Result := RNodeInfo(GetNodeData(Node)^).Detail.ID;
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
      DoGetText(Node, -1, ttNormal, Result)
    else
      DoGetText(Node, 0, ttNormal, Result);
end;

function TVirtualStringTree.GetFocusedNodeFullCaption: UnicodeString;
var
  PA: TAlbum;
  Node: PVirtualNode;
begin
  Result := '';
  Node := GetFirstSelected;
  if GetNodeLevel(Node) > 0 then
    case FMode of
      vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie, vmAchatsAlbumsEditeur:
        begin
          PA := RNodeInfo(GetNodeData(Node)^).Detail as TAlbum;
          Result := PA.ChaineAffichage(True);
        end;
    else
      if Header.Columns.Count = 0 then
        DoGetText(Node, -1, ttNormal, Result)
      else
        DoGetText(Node, 0, ttNormal, Result);
    end;
end;

function TVirtualStringTree.GetNodeBasePointer(Node: PVirtualNode): TBasePointeur;
begin
  Result := nil;
  if GetNodeLevel(Node) > 0 then
    Result := RNodeInfo(GetNodeData(Node)^).Detail;
end;

function TVirtualStringTree.GetNodeByValue(const Value: TGUID): PVirtualNode;
var
  Node: PVirtualNode;
  init: Cardinal;
  cs: string;
begin
  Result := nil;
  if IsEqualGUID(Value, GUID_NULL) then
    Exit;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT coalesce(' + vmModeInfos[FMode].INITIALEVALUE + ', ''-1'') FROM ' + vmModeInfos[FMode].TABLESEARCH + ' WHERE ' +
        vmModeInfos[FMode].REFFIELDS + ' = ?';
      Params.AsString[0] := GUIDToString(Value);
      Open;
      if Eof then
        Exit;
      init := 0;

      cs := Trim(FIELDS.AsString[0]);
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
        while Assigned(Result) and InitNode(Result) and (not IsEqualGUID(RNodeInfo(GetNodeData(Result)^).Detail.ID, Value)) do
          Result := Result.NextSibling;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

function TVirtualStringTree.GetFocusedNodeData: Pointer;
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
begin
  iCurrent := CurrentValue;
  Clear;
  if FMode <> vmNone then
    with TUIBQuery.Create(Self) do
    begin
      BeginUpdate;
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        SQL.Text := 'SELECT * FROM ' + vmModeInfos[FMode].FILTRECOUNT;
        Prepare(True);
        if FUseFiltre then
          Params.AsString[0] := Copy(FFiltre, 1, Params.MaxStrLen[0])
        else if FUseDefaultFiltre and (vmModeInfos[FMode].DEFAULTFILTRE <> '') then
          Params.AsString[0] := Copy(vmModeInfos[FMode].DEFAULTFILTRE, 1, Params.MaxStrLen[0]);
        Open;

        SetLength(FCountPointers, 0);
        i := 0;
        while not Eof do
        begin
          // on alloue par plage de 250 pour eviter de le faire trop souvent
          if Length(FCountPointers) <= i then
            SetLength(FCountPointers, Length(FCountPointers) + 250);
          FCountPointers[i].Count := FIELDS.AsInteger[1];
          FCountPointers[i].Initiale := FIELDS.AsString[0];
          if FMode in [vmAlbumsSerie, vmAlbumsEditeur, vmAlbumsCollection, vmAchatsAlbumsEditeur] then
            FCountPointers[i].Initiale := FormatTitre(FCountPointers[i].Initiale);
          if FMode = vmAlbumsCollection then
            AjoutString(FCountPointers[i].Initiale, FormatTitre(FIELDS.AsString[3]), ' ', '(', ')');
          FCountPointers[i].sValue := FIELDS.ByNameAsString[vmModeInfos[FMode].INITIALEVALUE];
          Next;
          Inc(i);
        end;
        // on retire ce qui a été alloué en trop
        SetLength(FCountPointers, i);

        RootNodeCount := Length(FCountPointers);
      finally
        Transaction.Free;
        Free;
        EndUpdate;
      end;
    end;
  if KeepValue then
    CurrentValue := iCurrent;
  SetLength(FFindArray, 0);
end;

function TVirtualStringTree.InitNode(Node: PVirtualNode): Boolean;
begin
  if not(vsInitialized in Node.States) then
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

destructor TVirtualStringTree.Destroy;
begin
  inherited;
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
