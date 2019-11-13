unit BDTK.Web.Browser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BD.GUI.Forms, BD.GUI.Frames.Buttons,
  BD.Entities.Full, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  uCEFChromium, uCEFWindowParent, uCEFInterfaces, uCEFApplication, uCEFTypes, uCEFConstants,
  uCEFSentinel, Vcl.AppEvnts;

// This is the destruction sequence when a user closes a tab sheet:
// 1. TChromium.CloseBrowser triggers a TChromium.OnClose event.
// 2. TChromium.OnClose sends a BDTKBROWSER_DESTROYWNDPARENT message to destroy TCEFWindowParent in the main thread which triggers a TChromium.OnBeforeClose event.
// 3. TChromium.OnBeforeClose sends a BDTKBROWSER_DESTROYTAB message to destroy the tab in the main thread.

const
  // les threads de CEF empêchent d'utiliser Synchronize
  // et puisque certains events CEF ne sont pas déclenchés dans le thread principal... il ne reste que la solution des messages
  BDTKBROWSER = WM_APP + $100;
  BDTKBROWSER_CLOSE = BDTKBROWSER + $00;
  BDTKBROWSER_MODALRESULT = BDTKBROWSER + $01;
  BDTKBROWSER_DESTROYWNDPARENT = BDTKBROWSER + $02;
  BDTKBROWSER_DESTROYTAB = BDTKBROWSER + $03;

  BDTKBROWSER_SHOWDEVTOOLS = WM_APP + $04;
  BDTKBROWSER_HIDEDEVTOOLS = WM_APP + $05;

  BDTKBROWSER_CONTEXTMENU_TOOLS = MENU_ID_USER_FIRST;
  BDTKBROWSER_CONTEXTMENU_IMPORT = MENU_ID_USER_FIRST + $100;

  BDTKBROWSER_CONTEXTMENU_SHOWDEVTOOLS = BDTKBROWSER_CONTEXTMENU_TOOLS + $01;
  BDTKBROWSER_CONTEXTMENU_HIDEDEVTOOLS = BDTKBROWSER_CONTEXTMENU_TOOLS + $02;
  BDTKBROWSER_CONTEXTMENU_MUTEAUDIO = BDTKBROWSER_CONTEXTMENU_TOOLS + $03;
  BDTKBROWSER_CONTEXTMENU_UNMUTEAUDIO = BDTKBROWSER_CONTEXTMENU_TOOLS + $04;

type
  TBrowserTabSheet = class(TTabSheet)
  private
    FChromium: TChromium;
    FWindowParent: TCEFWindowParent;
    FSplitter: TSplitter;
    FDevTools: TCEFWindowParent;
  public
    constructor Create(AOwner: TPageControl; const ADefaultUrl: string = ''); reintroduce;

    property WindowParent: TCEFWindowParent read FWindowParent;
    property Chromium: TChromium read FChromium;
    property Splitter: TSplitter read FSplitter;
    property DevTools: TCEFWindowParent read FDevTools;
  end;

  TfrmBDTKWebBrowser = class(TBdtForm)
    Frame11: TframBoutons;
    ButtonPnl: TPanel;
    NavButtonPnl: TPanel;
    BackBtn: TButton;
    ForwardBtn: TButton;
    ReloadBtn: TButton;
    StopBtn: TButton;
    AddTabBtn: TButton;
    RemoveTabBtn: TButton;
    ConfigPnl: TPanel;
    GoBtn: TButton;
    URLEditPnl: TPanel;
    URLCbx: TComboBox;
    PageControl1: TPageControl;
    CEFSentinel1: TCEFSentinel;
    ApplicationEvents1: TApplicationEvents;
    procedure FormShow(ASender: TObject);
    procedure CEFSentinel1Close(ASender: TObject);
    procedure AddTabBtnClick(ASender: TObject);
    procedure RemoveTabBtnClick(Sender: TObject);
    procedure FormCloseQuery(ASender: TObject; var ACanClose: Boolean);
    procedure ForwardBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure ReloadBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure Frame11btnAnnulerClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
  private
    FAutoSearchKeyWords: string;
    FAlbum: TAlbumFull;
    FClosingTab, FCanClose, FClosing: Boolean;
    FRequestedModalResult: TModalResult;
    function GetPageIndex(ASender: TObject; out APageIndex: Integer): Boolean;
    function GetPage(APageIndex: Integer; out APage: TBrowserTabSheet): Boolean;
    procedure CloseAllBrowsers;

    procedure CloseModalMsg(var AMessage: TMessage); message BDTKBROWSER_CLOSE;
    procedure ModalResultMsg(var AMessage: TMessage); message BDTKBROWSER_MODALRESULT;

    procedure Chromium_OnAfterCreated(ASender: TObject; const ABrowser: ICefBrowser);
    procedure BrowserCreatedMsg(var AMessage: TMessage); message CEF_AFTERCREATED;
    procedure Chromium_OnAddressChange(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AUrl: ustring);
    procedure Chromium_OnTitleChange(ASender: TObject; const ABrowser: ICefBrowser; const ATitle: ustring);
    procedure Chromium_OnClose(ASender: TObject; const ABrowser: ICefBrowser; var AAction: TCefCloseBrowserAction);
    procedure BrowserDetroyParentWindow(var AMessage: TMessage); message BDTKBROWSER_DESTROYWNDPARENT;
    procedure Chromium_OnBeforeClose(ASender: TObject; const ABrowser: ICefBrowser);
    procedure BrowserDestroyTabMsg(var AMessage: TMessage); message BDTKBROWSER_DESTROYTAB;
    procedure Chromium_OnBeforePopup(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const ATargetUrl, ATargetFrameName: ustring; ATargetDisposition: TCefWindowOpenDisposition; AUserGesture: Boolean; const APopupFeatures: TCefPopupFeatures; var AWindowInfo: TCefWindowInfo; var AClient: ICefClient; var ASettings: TCefBrowserSettings; var AExtraInfo: ICefDictionaryValue; var ANoJavascriptAccess: Boolean; var AResult: Boolean);
    procedure Chromium_OnBeforeContextMenu(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; const AModel: ICefMenuModel);
    procedure Chromium_OnContextMenuCommand(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; ACommandId: Integer; AEventFlags: Cardinal; out AResult: Boolean);
    procedure Chromium_OnKeyEvent(ASender: TObject; const ABrowser: ICefBrowser; const AEvent: PCefKeyEvent; AosEvent: PMsg; out AResult: Boolean);

    procedure WMMove(var AMessage: TWMMove); message WM_MOVE;
    procedure WMMoving(var AMessage: TMessage); message WM_MOVING;
    procedure NotifyMoveOrResizeStarted;
    procedure WMEnterMenuLoop(var AMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var AMessage: TMessage); message WM_EXITMENULOOP;

    procedure ShowDevToolsMsg(var AMessage: TMessage); message BDTKBROWSER_SHOWDEVTOOLS;
    procedure HideDevToolsMsg(var AMessage: TMessage); message BDTKBROWSER_HIDEDEVTOOLS;
    procedure ShowDevTools(APageIndex: Integer; APoint: TPoint); overload;
    procedure ShowDevTools(APageIndex: Integer); overload;
    procedure HideDevTools(APageIndex: Integer);

    procedure HandleKeyUp(const AMsg: TMsg; var AHandled: Boolean);
    procedure HandleKeyDown(const AMsg: TMsg; var AHandled: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Album: TAlbumFull read FAlbum write FAlbum;
    property AutoSearchKeyWords: string read FAutoSearchKeyWords write FAutoSearchKeyWords;
  end;

implementation

uses
  BD.Utils.GUIUtils, BD.Utils.Chromium, System.Math, BD.Utils.Net,
  System.StrUtils;

{$R *.dfm}

procedure InitializeBrowser;
var
  HourGlass: IHourGlass;
begin
  if Assigned(GlobalCEFApp) then
    Exit;

  HourGlass := THourGlass.Create;
  InitializeChromium;
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

  Caption := 'New Tab';
  PageControl := AOwner;

  FWindowParent := TCEFWindowParent.Create(Self);
  FWindowParent.Parent := Self;
  FWindowParent.Color := clWhite;
  FWindowParent.Align := alClient;

  FChromium := TChromium.Create(Self);
  FChromium.DefaultUrl := ADefaultUrl;
  FChromium.OnAfterCreated := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnAfterCreated;
  FChromium.OnAddressChange := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnAddressChange;
  FChromium.OnTitleChange := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnTitleChange;
  FChromium.OnClose := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnClose;
  FChromium.OnBeforeClose := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnBeforeClose;
  FChromium.OnBeforePopup := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnBeforePopup;
  FChromium.OnBeforeContextMenu := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnBeforeContextMenu;
  FChromium.OnContextMenuCommand := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnContextMenuCommand;
  FChromium.OnKeyEvent := TfrmBDTKWebBrowser(AOwner.Owner).Chromium_OnKeyEvent;

  FSplitter := TSplitter.Create(Self);
  FSplitter.Parent := Self;
  FSplitter.Align := alRight;
  FSplitter.Visible := False;

  FDevTools := TCEFWindowParent.Create(Self);
  FDevTools.Parent := Self;
  FDevTools.Color := clWhite;
  FDevTools.Align := alRight;
  FDevTools.Visible := False;

  FChromium.CreateBrowser(FWindowParent, '');
end;

{ TfrmBDTKWebBrowser }

constructor TfrmBDTKWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  InitializeBrowser;
end;

destructor TfrmBDTKWebBrowser.Destroy;
begin
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
      Page.Chromium.NotifyMoveOrResizeStarted;
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
      Page.Chromium.CloseBrowser(True);
end;

procedure TfrmBDTKWebBrowser.FormShow(ASender: TObject);
begin
  inherited;
  WaitForCEFInitializationEnd;

  if FAutoSearchKeyWords.IsEmpty then
    URLCbx.Items[0] := 'https://www.google.com'
  else
    URLCbx.Items[0] := 'https://www.google.com/search?q=' + FAutoSearchKeyWords.Replace(' ', '+');
  URLCbx.Text := URLCbx.Items[0];

  AddTabBtn.Click;
end;

function TfrmBDTKWebBrowser.GetPageIndex(ASender: TObject; out APageIndex: Integer): Boolean;
begin
  Result := (ASender is TComponent) and (TComponent(ASender).Owner is TTabSheet);
  if Result then
    APageIndex := TTabSheet(TComponent(ASender).Owner).PageIndex;
end;

function TfrmBDTKWebBrowser.GetPage(APageIndex: Integer; out APage: TBrowserTabSheet): Boolean;
begin
  if not InRange(APageIndex, 0, PageControl1.PageCount - 1) then
    Exit(False);
  APage := PageControl1.Pages[APageIndex] as TBrowserTabSheet;
  Result := Assigned(APage);
end;

procedure TfrmBDTKWebBrowser.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  inherited;
  case Msg.message of
    WM_KEYUP:
      HandleKeyUp(Msg, Handled);
    WM_KEYDOWN:
      HandleKeyDown(Msg, Handled);
  end;
end;

procedure TfrmBDTKWebBrowser.AddTabBtnClick(ASender: TObject);
begin
  ButtonPnl.Enabled := False;
  PageControl1.Enabled := False;
  TBrowserTabSheet.Create(PageControl1, IfThen(PageControl1.PageCount = 0, URLCbx.Text, ''));
end;

procedure TfrmBDTKWebBrowser.RemoveTabBtnClick(Sender: TObject);
var
  Page: TBrowserTabSheet;
begin
  if (PageControl1.PageCount > 1) and GetPage(PageControl1.TabIndex, Page) then
  begin
    FClosingTab := True;
    ButtonPnl.Enabled := False;
    PageControl1.Enabled := False;
    Page.Chromium.CloseBrowser(True);
  end;
end;

procedure TfrmBDTKWebBrowser.ForwardBtnClick(Sender: TObject);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(PageControl1.TabIndex, Page) then
    Page.Chromium.GoForward;
end;

procedure TfrmBDTKWebBrowser.BackBtnClick(Sender: TObject);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(PageControl1.TabIndex, Page) then
    Page.Chromium.GoBack;
end;

procedure TfrmBDTKWebBrowser.ReloadBtnClick(Sender: TObject);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(PageControl1.TabIndex, Page) then
    Page.Chromium.Reload;
end;

procedure TfrmBDTKWebBrowser.StopBtnClick(Sender: TObject);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(PageControl1.TabIndex, Page) then
    Page.Chromium.StopLoad;
end;

procedure TfrmBDTKWebBrowser.PageControl1Change(Sender: TObject);
var
  Page: TBrowserTabSheet;
begin
  if Showing and GetPage(PageControl1.TabIndex, Page) then
    URLCbx.Text := Page.Chromium.DocumentURL;
end;

procedure TfrmBDTKWebBrowser.Frame11btnOKClick(Sender: TObject);
begin
  inherited;
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

procedure TfrmBDTKWebBrowser.Chromium_OnAddressChange(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AUrl: ustring);
var
  PageIndex: Integer;
begin
  if (not FClosing) and (PageControl1.TabIndex >= 0) and GetPageIndex(ASender, PageIndex) and (PageControl1.TabIndex = PageIndex) then
    URLCbx.Text := AUrl;
end;

procedure TfrmBDTKWebBrowser.Chromium_OnAfterCreated(ASender: TObject; const ABrowser: ICefBrowser);
var
  PageIndex: Integer;
begin
  if GetPageIndex(ASender, PageIndex) then
    PostMessage(Handle, CEF_AFTERCREATED, 0, PageIndex);
end;

procedure TfrmBDTKWebBrowser.BrowserCreatedMsg(var AMessage: TMessage);
var
  Page: TBrowserTabSheet;
begin
  ButtonPnl.Enabled := True;
  PageControl1.Enabled := True;

  if GetPage(AMessage.LParam, Page) then
    Page.WindowParent.UpdateSize;
end;

procedure TfrmBDTKWebBrowser.Chromium_OnBeforePopup(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const ATargetUrl,
  ATargetFrameName: ustring; ATargetDisposition: TCefWindowOpenDisposition; AUserGesture: Boolean; const APopupFeatures: TCefPopupFeatures;
  var AWindowInfo: TCefWindowInfo; var AClient: ICefClient; var ASettings: TCefBrowserSettings; var AExtraInfo: ICefDictionaryValue;
  var ANoJavascriptAccess, AResult: Boolean);
begin
  // For simplicity, this demo blocks all popup windows and new tabs
  AResult := (ATargetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TfrmBDTKWebBrowser.Chromium_OnClose(ASender: TObject; const ABrowser: ICefBrowser; var AAction: TCefCloseBrowserAction);
var
  PageIndex: Integer;
begin
  if GetPageIndex(ASender, PageIndex) then
  begin
    AAction := cbaDelay;
    PostMessage(Handle, BDTKBROWSER_DESTROYWNDPARENT, 0, PageIndex);
  end;
end;

procedure TfrmBDTKWebBrowser.BrowserDetroyParentWindow(var AMessage: TMessage);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(AMessage.LParam, Page) then
    Page.WindowParent.Free;
end;

procedure TfrmBDTKWebBrowser.Chromium_OnBeforeClose(ASender: TObject; const ABrowser: ICefBrowser);
var
  PageIndex: Integer;
begin
  if GetPageIndex(ASender, PageIndex) then
    PostMessage(Handle, BDTKBROWSER_DESTROYTAB, 0, PageIndex);
end;

procedure TfrmBDTKWebBrowser.BrowserDestroyTabMsg(var AMessage: TMessage);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(AMessage.LParam, Page) then
    Page.Free;

  FClosingTab := False;
  ButtonPnl.Enabled := True;
  PageControl1.Enabled := True;
end;

procedure TfrmBDTKWebBrowser.Chromium_OnTitleChange(ASender: TObject; const ABrowser: ICefBrowser; const ATitle: ustring);
var
  PageIndex : integer;
begin
  if (not FClosing) and GetPageIndex(ASender, PageIndex) then
    PageControl1.Pages[PageIndex].Caption := ATitle;
end;

procedure TfrmBDTKWebBrowser.Chromium_OnKeyEvent(ASender: TObject; const ABrowser: ICefBrowser; const AEvent: PCefKeyEvent; AosEvent: PMsg; out AResult: Boolean);
begin
  AResult := False;

  if Assigned(AEvent) and Assigned(AosEvent) then
    case AosEvent.message of
      WM_KEYUP:
        HandleKeyUp(AosEvent^, AResult);
      WM_KEYDOWN:
        HandleKeyDown(AosEvent^, AResult);
    end;
end;

procedure TfrmBDTKWebBrowser.HandleKeyUp(const AMsg: TMsg; var AHandled: Boolean);
var
  Msg: TMessage;
  KeyMsg: TWMKey;
begin
  Msg.Msg := AMsg.message;
  Msg.WParam := AMsg.WParam;
  Msg.LParam := AMsg.LParam;
  KeyMsg := TWMKey(Msg);

  if (KeyMsg.CharCode = VK_F12) then
  begin
    AHandled := True;

    if TBrowserTabSheet(PageControl1.ActivePage).DevTools.Visible then
      PostMessage(Handle, BDTKBROWSER_HIDEDEVTOOLS, 0, PageControl1.ActivePageIndex)
    else
      PostMessage(Handle, BDTKBROWSER_SHOWDEVTOOLS, 0, PageControl1.ActivePageIndex);
  end;
end;

procedure TfrmBDTKWebBrowser.HandleKeyDown(const AMsg: TMsg; var AHandled: Boolean);
var
  Msg: TMessage;
  KeyMsg: TWMKey;
begin
  Msg.Msg := AMsg.message;
  Msg.WParam := AMsg.WParam;
  Msg.LParam := AMsg.LParam;
  KeyMsg := TWMKey(Msg);

  if (KeyMsg.CharCode = VK_F12) then
    AHandled := True;
end;

procedure TfrmBDTKWebBrowser.Chromium_OnBeforeContextMenu(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; const AModel: ICefMenuModel);

  procedure CleanSeparators(AMenu: ICefMenuModel);
  var
    i: Integer;
    SubMenu: ICefMenuModel;
  begin
    for i := Pred(AMenu.GetCount) downto 0 do
      case AMenu.GetTypeAt(i) of
        MENUITEMTYPE_SEPARATOR:
          if (i = 0) or (i = AMenu.GetCount - 1) or (AMenu.GetTypeAt(i + 1) = MENUITEMTYPE_SEPARATOR) then
            AMenu.RemoveAt(i);
        MENUITEMTYPE_SUBMENU:
          begin
            SubMenu := AMenu.GetSubMenuAt(i);
            CleanSeparators(SubMenu);
            if SubMenu.GetCount = 0 then
              AMenu.RemoveAt(i);
          end;
      end;
  end;

var
  PageIndex: Integer;
  Page: TBrowserTabSheet;
begin
  if not (GetPageIndex(ASender, PageIndex) and GetPage(PageIndex, Page)) then
    Exit;

  AModel.Remove(MENU_ID_PRINT);
  AModel.Remove(MENU_ID_VIEW_SOURCE);

  AModel.AddSeparator;
  if Page.DevTools.Visible then
    AModel.AddItem(BDTKBROWSER_CONTEXTMENU_HIDEDEVTOOLS, 'Cacher les outils de développement')
  else
    AModel.AddItem(BDTKBROWSER_CONTEXTMENU_SHOWDEVTOOLS, 'Afficher les outils de développement');

  if Page.Chromium.AudioMuted then
    AModel.AddItem(BDTKBROWSER_CONTEXTMENU_UNMUTEAUDIO, 'Réactiver le son de l''onglet')
  else
    AModel.AddItem(BDTKBROWSER_CONTEXTMENU_MUTEAUDIO, 'Couper le son de l''onglet');
  AModel.AddSeparator;

  CleanSeparators(AModel);
end;

procedure TfrmBDTKWebBrowser.Chromium_OnContextMenuCommand(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; ACommandId: Integer; AEventFlags: Cardinal; out AResult: Boolean);
var
  PageIndex: Integer;
  Page: TBrowserTabSheet;
begin
  AResult := False;
  if not (GetPageIndex(ASender, PageIndex) and GetPage(PageIndex, Page)) then
    Exit;

  case ACommandId of
    BDTKBROWSER_CONTEXTMENU_HIDEDEVTOOLS:
      PostMessage(Handle, BDTKBROWSER_HIDEDEVTOOLS, 0, PageIndex);
    BDTKBROWSER_CONTEXTMENU_SHOWDEVTOOLS :
      PostMessage(Handle, BDTKBROWSER_SHOWDEVTOOLS, ((AParams.XCoord and $FFFF) shl 16) or (AParams.YCoord and $FFFF), PageIndex);
    BDTKBROWSER_CONTEXTMENU_UNMUTEAUDIO:
      Page.Chromium.AudioMuted := False;
    BDTKBROWSER_CONTEXTMENU_MUTEAUDIO:
      Page.Chromium.AudioMuted := True;
  end;
end;

procedure TfrmBDTKWebBrowser.ShowDevTools(APageIndex: Integer; APoint: TPoint);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(APageIndex, Page) then
  begin
    Page.Splitter.Visible := True;
    Page.DevTools.Visible := True;
    Page.DevTools.Width := Width div 4;
    Page.Chromium.ShowDevTools(APoint, Page.DevTools);
  end;
end;

procedure TfrmBDTKWebBrowser.ShowDevTools(APageIndex: Integer);
begin
  ShowDevTools(APageIndex, TPoint.Create(Low(Integer), Low(Integer)));
end;

procedure TfrmBDTKWebBrowser.ShowDevToolsMsg(var AMessage: TMessage);
begin
  ShowDevTools(AMessage.LParam, TPoint.Create((AMessage.WParam shr 16) and $FFFF, AMessage.WParam and $FFFF));
end;

procedure TfrmBDTKWebBrowser.HideDevTools(APageIndex: Integer);
var
  Page: TBrowserTabSheet;
begin
  if GetPage(APageIndex, Page) then
  begin
    Page.Chromium.CloseDevTools(Page.DevTools);
    Page.Splitter.Visible := False;
    Page.DevTools.Visible := False;
    Page.DevTools.Width := 0;
  end;
end;

procedure TfrmBDTKWebBrowser.HideDevToolsMsg(var AMessage: TMessage);
var
  Page: TBrowserTabSheet;
begin
  HideDevTools(AMessage.LParam);
  if GetPage(AMessage.LParam, Page) then
    Page.Chromium.SetFocus(True);
end;

end.
