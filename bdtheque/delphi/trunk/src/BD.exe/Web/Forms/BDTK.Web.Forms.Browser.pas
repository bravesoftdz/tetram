unit BDTK.Web.Forms.Browser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BD.GUI.Forms, BD.GUI.Frames.Buttons,
  BD.Entities.Full, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  uCEFChromium, uCEFWindowParent, uCEFInterfaces, uCEFApplication, uCEFTypes, uCEFConstants,
  uCEFSentinel, Vcl.AppEvnts, BDTK.Web.Frames.Browser, BDTK.Web.Browser.Utils,
  Vcl.Menus, BDTK.Web.Forms.Preview;

// This is the destruction sequence when a user closes a tab sheet:
// 1. TChromium.CloseBrowser triggers a TChromium.OnClose event.
// 2. TChromium.OnClose sends a BDTKBROWSER_DESTROYWNDPARENT message to destroy TCEFWindowParent in the main thread which triggers a TChromium.OnBeforeClose event.
// 3. TChromium.OnBeforeClose sends a BDTKBROWSER_DESTROYTAB message to destroy the tab in the main thread.

type
  TBrowserTabSheet = class(TTabSheet)
  private
    FFrame: TframeBDTKWebBrowser;

    procedure Chromium_OnTitleChange(ASender: TObject; const ABrowser: ICefBrowser; const ATitle: ustring);
    procedure Chromium_BeforeClose(ASender: TObject; const ABrowser: ICefBrowser);
  public
    constructor Create(AOwner: TPageControl; const ADefaultUrl: string = ''); reintroduce;

    property Frame: TframeBDTKWebBrowser read FFrame;
  end;

  TfrmBDTKWebBrowser = class(TbdtForm)
    Frame11: TframBoutons;
    PageControl1: TPageControl;
    CEFSentinel1: TCEFSentinel;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    Fermerlonglet1: TMenuItem;
    procedure FormShow(ASender: TObject);
    procedure CEFSentinel1Close(ASender: TObject);
    procedure FormCloseQuery(ASender: TObject; var ACanClose: Boolean);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure Frame11btnAnnulerClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure Chromium_OnBeforeContextMenu(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; const AModel: ICefMenuModel);
    procedure Chromium_OnContextMenuCommand(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; ACommandId: Integer; AEventFlags: Cardinal; out AResult: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Fermerlonglet1Click(Sender: TObject);
  private
    FAutoSearchKeyWords: string;
    FAlbum: TAlbumFull;
    FClosingTab, FCanClose, FClosing: Boolean;
    FRequestedModalResult: TModalResult;
    FImportPreview: TfrmBDTKWebPreview;
    procedure AddTab(const AUrl: string);
    procedure RemoveTab(APageIndex: Integer);
    function GetPage(ASender: TObject; out APage: TBrowserTabSheet): Boolean; overload;
    function GetPage(APageIndex: Integer; out APage: TBrowserTabSheet): Boolean; overload;
    procedure CloseAllBrowsers;

    procedure CloseModalMsg(var AMessage: TMessage); message BDTKBROWSER_CLOSE;
    procedure ModalResultMsg(var AMessage: TMessage); message BDTKBROWSER_MODALRESULT;

    procedure BrowserDestroyTabMsg(var AMessage: TMessage); message BDTKBROWSER_DESTROYTAB;

    procedure WMMove(var AMessage: TWMMove); message WM_MOVE;
    procedure WMMoving(var AMessage: TMessage); message WM_MOVING;
    procedure NotifyMoveOrResizeStarted;
    procedure WMEnterMenuLoop(var AMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var AMessage: TMessage); message WM_EXITMENULOOP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Album: TAlbumFull read FAlbum write FAlbum;
    property AutoSearchKeyWords: string read FAutoSearchKeyWords write FAutoSearchKeyWords;
  end;

implementation

uses
  BD.Utils.GUIUtils, BD.Utils.Chromium, System.Math, BD.Utils.Net,
  System.StrUtils, BDTK.Web.Forms.Associate, BDTK.Web.Import;

{$R *.dfm}

procedure InitializeBrowser;
var
  HourGlass: IHourGlass;
begin
  if Assigned(GlobalCEFApp) then
    Exit;

  HourGlass := THourGlass.Create;
  InitializeChromium(False); // utiliser True pour faciliter le debuggage, mais les extensions javascript ne seront pas chargées
end;

procedure WaitForCEFInitializationEnd;
begin
  while not GlobalCEFApp.GlobalContextInitialized do
    Sleep(500);
end;

{ TBrowserTabSheet }

constructor TBrowserTabSheet.Create(AOwner: TPageControl; const ADefaultUrl: string);
begin
  inherited Create(AOwner);

  Caption := '';
  PageControl := AOwner;

  FFrame := TframeBDTKWebBrowser.Create(Self);
  FFrame.Parent := Self;
  FFrame.Align := alClient;
  FFrame.Chromium.OnBeforeClose := Chromium_BeforeClose;
  FFrame.Chromium.OnTitleChange := Chromium_OnTitleChange;
  FFrame.OnBeforeContextMenu := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnBeforeContextMenu;
  FFrame.OnContextMenuCommand := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnContextMenuCommand;
  FFrame.Initialize(ADefaultUrl);
end;

procedure TBrowserTabSheet.Chromium_BeforeClose(ASender: TObject; const ABrowser: ICefBrowser);
begin
  PostMessage((Owner.Owner as TForm).Handle, BDTKBROWSER_DESTROYTAB, 0, LParam(Self));
end;

procedure TBrowserTabSheet.Chromium_OnTitleChange(ASender: TObject; const ABrowser: ICefBrowser; const ATitle: ustring);
begin
  if not FFrame.Closing then
    Caption := ATitle;
end;

{ TfrmBDTKWebBrowser }

constructor TfrmBDTKWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  InitializeBrowser;
  FImportPreview := TfrmBDTKWebPreview.Create(Application);
end;

destructor TfrmBDTKWebBrowser.Destroy;
begin
  FImportPreview.Free;
  inherited;
end;

procedure TfrmBDTKWebBrowser.WMEnterMenuLoop(var AMessage: TMessage);
begin
  inherited;
  if (not FClosing) and (AMessage.WParam = 0) and (GlobalCEFApp <> nil) then
    GlobalCEFApp.OsmodalLoop := True;
end;

procedure TfrmBDTKWebBrowser.WMExitMenuLoop(var AMessage: TMessage);
begin
  inherited;
  if (not FClosing) and (AMessage.WParam = 0) and (GlobalCEFApp <> nil) then
    GlobalCEFApp.OsmodalLoop := False;
end;

procedure TfrmBDTKWebBrowser.NotifyMoveOrResizeStarted;
var
  i: Integer;
  Page: TBrowserTabSheet;
begin
  if (not Showing) or (PageControl1 = nil) or FClosing then
    Exit;

  for i := 0 to Pred(PageControl1.PageCount) do
    if GetPage(i, Page) then
      Page.Frame.Chromium.NotifyMoveOrResizeStarted;
end;

procedure TfrmBDTKWebBrowser.WMMove(var AMessage: TWMMove);
begin
  inherited;
  NotifyMoveOrResizeStarted;
end;

procedure TfrmBDTKWebBrowser.WMMoving(var AMessage: TMessage);
begin
  inherited;
  NotifyMoveOrResizeStarted;
end;

procedure TfrmBDTKWebBrowser.FormCloseQuery(ASender: TObject; var ACanClose: Boolean);
begin
  inherited;
  if FClosingTab then
    ACanClose := False
  else if (PageControl1.PageCount = 0) then
    ACanClose := True
  else
  begin
    ACanClose := FCanClose;

    if not FClosing then
    begin
      FClosing := True;
      CloseAllBrowsers;
    end;
  end;
end;

procedure TfrmBDTKWebBrowser.CloseAllBrowsers;
var
  p: Integer;
  Page: TBrowserTabSheet;
begin
  for p := Pred(PageControl1.PageCount) downto 0 do
    if GetPage(p, Page) then
      Page.Frame.Chromium.CloseBrowser(True);
end;

procedure TfrmBDTKWebBrowser.FormShow(ASender: TObject);
var
  url: string;
begin
  inherited;
  WaitForCEFInitializationEnd;

  if FAutoSearchKeyWords.IsEmpty then
    url := 'https://www.google.com'
  else
    url := 'https://www.google.com/search?q=' + FAutoSearchKeyWords.Replace(' ', '+');

  AddTab(url);

  FImportPreview.Album := Album;
  FImportPreview.Show;
end;

function TfrmBDTKWebBrowser.GetPage(ASender: TObject; out APage: TBrowserTabSheet): Boolean;
begin
  if not (ASender is TComponent) then
    Exit(False);

  if (TComponent(ASender).Owner is TBrowserTabSheet) then
    APage := TBrowserTabSheet(TComponent(ASender).Owner)
  else if (TComponent(ASender).Owner.Owner is TBrowserTabSheet) then
    APage := TBrowserTabSheet(TComponent(ASender).Owner.Owner)
  else
    APage := nil;

  Result := Assigned(APage);
end;

function TfrmBDTKWebBrowser.GetPage(APageIndex: Integer; out APage: TBrowserTabSheet): Boolean;
begin
  if not InRange(APageIndex, 0, PageControl1.PageCount - 1) then
    Exit(False);
  APage := PageControl1.Pages[APageIndex] as TBrowserTabSheet;
  Result := Assigned(APage);
end;

procedure TfrmBDTKWebBrowser.AddTab(const AUrl: string);
begin
//  PageControl1.Enabled := False;
  PageControl1.ActivePage := TBrowserTabSheet.Create(PageControl1, AUrl);
end;

procedure TfrmBDTKWebBrowser.RemoveTab(APageIndex: Integer);
var
  Page: TBrowserTabSheet;
begin
  if (PageControl1.PageCount > 1) and GetPage(APageIndex, Page) then
  begin
//    FClosingTab := True;
//    PageControl1.Enabled := False;
    Page.Frame.Chromium.CloseBrowser(True);
  end;
end;

procedure TfrmBDTKWebBrowser.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  inherited;
  case Msg.message of
    WM_KEYUP:
      TBrowserTabSheet(PageControl1.ActivePage).Frame.HandleKeyUp(Msg, Handled);
    WM_KEYDOWN:
      TBrowserTabSheet(PageControl1.ActivePage).Frame.HandleKeyDown(Msg, Handled);
  end;
end;

procedure TfrmBDTKWebBrowser.Frame11btnOKClick(Sender: TObject);
begin
  inherited;

  FImportPreview.StoreData;
  AssociateToDBEntities(FImportPreview);

  if PageControl1.PageCount = 0 then
    Frame11.btnOKClick(Sender)
  else
    PostMessage(Handle, BDTKBROWSER_CLOSE, WPARAM(mrOk), 0);
end;

procedure TfrmBDTKWebBrowser.Frame11btnAnnulerClick(Sender: TObject);
begin
  inherited;
  if PageControl1.PageCount = 0 then
    Frame11.btnAnnulerClick(Sender)
  else
    PostMessage(Handle, BDTKBROWSER_CLOSE, WPARAM(mrCancel), 0);
end;

procedure TfrmBDTKWebBrowser.CloseModalMsg(var AMessage: TMessage);
begin
  FClosing := True;
  FRequestedModalResult := TModalResult(AMessage.WParam);
  CEFSentinel1.Start;
  CloseAllBrowsers; // CEFSentinel1 nous dira quand on peut fermer la fenêtre
end;

procedure TfrmBDTKWebBrowser.CEFSentinel1Close(ASender: TObject);
begin
  inherited;
  PostMessage(Handle, BDTKBROWSER_MODALRESULT, 0, 0);
end;

procedure TfrmBDTKWebBrowser.ModalResultMsg(var AMessage: TMessage);
begin
  FCanClose := True;
  ModalResult := FRequestedModalResult;
end;

procedure TfrmBDTKWebBrowser.BrowserDestroyTabMsg(var AMessage: TMessage);
begin
  TObject(AMessage.LParam).Free;
end;

procedure TfrmBDTKWebBrowser.PopupMenu1Popup(Sender: TObject);
var
  p: TPoint;
begin
  inherited;
  Fermerlonglet1.Enabled := PageControl1.PageCount > 1;
  p := PageControl1.ScreenToClient(Mouse.CursorPos);
  Fermerlonglet1.Tag := PageControl1.IndexOfTabAt(p.X, p.Y);
end;

procedure TfrmBDTKWebBrowser.Fermerlonglet1Click(Sender: TObject);
begin
  inherited;
  RemoveTab(Fermerlonglet1.Tag);
end;

procedure TfrmBDTKWebBrowser.Chromium_OnBeforeContextMenu(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; const AModel: ICefMenuModel);
var
  IsText, IsInteger, IsFloat, IsBoolean: Boolean;

  procedure AddTextCommand(const AModel: ICefMenuModel; ACommandId: Integer; const ACommandText: string);
  begin
    if IsText then
      AModel.AddItem(ACommandId, ACommandText);
  end;

  procedure AddIntegerCommand(const AModel: ICefMenuModel; ACommandId: Integer; const ACommandText: string);
  begin
    if IsInteger then
      AModel.AddItem(ACommandId, ACommandText);
  end;

  procedure AddFloatCommand(const AModel: ICefMenuModel; ACommandId: Integer; const ACommandText: string);
  begin
    if IsFloat then
      AModel.AddItem(ACommandId, ACommandText);
  end;

  procedure AddBooleanCommand(const AModel: ICefMenuModel; ACommandId: Integer; const ACommandText: string);
  begin
    if IsBoolean then
      AModel.AddItem(ACommandId, ACommandText);
  end;

var
  DummyInt: Integer;
  DummyDbl: Double;
  DummyBool: Boolean;
  SubModel, SubModel2: ICefMenuModel;
  s: string;
  Page: TBrowserTabSheet;
begin
  if not GetPage(ASender, Page) then
    Exit;

  s := Page.Frame.SelectedText.Trim([#9, #32, #160]);

  IsText := not s.IsEmpty;
  IsInteger := TryStrToInt(s, DummyInt);
  IsFloat := TryStrToFloat(s, DummyDbl);
  IsBoolean := TryStrToBool(s, DummyBool);

  if not IsText then
    Exit;

  SubModel := AModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM, 'Album');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TITRE, 'Titre');
  SubModel2 := SubModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution, 'Parution');
  AddIntegerCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Annee, 'Année');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Mois, 'Mois');
  SubModel2.AddSeparator;
//  AddPeriodCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Date, 'Date');
  AddIntegerCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Tome, 'Tome');
  SubModel2 := SubModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Integrale, 'Intégrale');
  AddIntegerCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeDebut, 'Tome début');
  AddIntegerCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeFin, 'Tome fin');
  AddBooleanCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_HorsSerie, 'Hors série');
  SubModel2 := SubModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Auteur, 'Auteur');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Scenaristes, 'Scénariste');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Dessinateurs, 'Dessinateur');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Coloristes, 'Coloriste');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Sujet, 'Histoire');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Notes, 'Notes');

  SubModel := AModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE, 'Série');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_TITRE, 'Titre');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_SiteWeb, 'Site web');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Univers, 'Univers');
  AddIntegerCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_NbAlbums, 'Nombre d''albums');
  AddBooleanCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Terminee, 'Terminée');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Genres, 'Genre');
  SubModel2 := SubModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Auteurs, 'Auteur');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Scenaristes, 'Scénariste');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Dessinateurs, 'Dessinateur');
  AddTextCommand(SubModel2, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Coloristes, 'Coloriste');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Sujet, 'Histoire');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Notes, 'Notes');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Editeur_NomEditeur, 'Editeur');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Editeur_SiteWeb, 'Site web de l''éditeur');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Collection_NomCollection, 'Collection');

  SubModel := AModel.AddSubMenu(BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION, 'Edition');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Editeur_NomEditeur, 'Editeur');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Editeur_SiteWeb, 'Site web de l''éditeur');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Collection_NomCollection, 'Collection');
  AddIntegerCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_AnneeEdition, 'Annéee d''édition');
  AddFloatCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Prix, 'Prix');
  AddBooleanCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Gratuit, 'Gratuit');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_ISBN, 'ISBN');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Etat, 'Etat');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_TypeEdition, 'Type d''édition');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Reliure, 'Reliure');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Orientation, 'Orientation');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_SensLecture, 'Sens de lecture');
  AddTextCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_FormatEdition, 'Format');
  AddIntegerCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_AnneeCote, 'Année de la cotation');
  AddFloatCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_PrixCote, 'Cote');
  AddBooleanCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Couleur, 'Couleur');
  AddBooleanCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_VO, 'VO');
  AddIntegerCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_NombreDePages, 'Nombre de pages');
//  AddImageCommand(SubModel, BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Couvertures, 'Image');
end;

procedure TfrmBDTKWebBrowser.Chromium_OnContextMenuCommand(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; ACommandId: Integer; AEventFlags: Cardinal; out AResult: Boolean);
var
  Page: TBrowserTabSheet;
begin
  AResult := False;

  case ACommandId of
    BDTKBROWSER_CONTEXTMENU_LINK_TO_NEW_TAB:
      AddTab(AParams.LinkUrl);
    BDTKBROWSER_CONTEXTMENU_IMPORT..MENU_ID_USER_LAST:
      if GetPage(ASender, Page) then
        FImportPreview.SetValue(ACommandId, Page.Frame.SelectedText.Trim([#9, #32, #160]));
  end;
end;

end.
