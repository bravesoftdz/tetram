unit BDTK.Web.Frames.Browser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, uCEFChromium, uCEFWinControl, uCEFWindowParent, System.Actions, Vcl.ActnList, uCEFInterfaces, uCEFTypes,
  BDTK.Web.Browser.Utils, uCEFChromiumEvents, uCEFConstants, Vcl.ComCtrls;

type
  TframeBDTKWebBrowser = class(TFrame)
    pnlToolbar: TPanel;
    pnlButtons: TPanel;
    pnlUrl: TPanel;
    edUrl: TEdit;
    btnReload: TButton;
    btnForward: TButton;
    btnBack: TButton;
    ActionList1: TActionList;
    actBack: TAction;
    actForward: TAction;
    actReload: TAction;
    WindowParent: TCEFWindowParent;
    Splitter: TSplitter;
    DevTools: TCEFWindowParent;
    Chromium: TChromium;
    actToggleDevTools: TAction;
    actToggleAudio: TAction;
    Browser: TPanel;
    StatusBar1: TStatusBar;
    Bevel1: TBevel;
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actBackExecute(ASender: TObject);
    procedure actForwardExecute(ASender: TObject);
    procedure actReloadExecute(ASender: TObject);
    procedure ChromiumAddressChange(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AUrl: ustring);
    procedure ChromiumBeforePopup(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const ATargetUrl, ATargetFrameName: ustring;
      ATargetDisposition: TCefWindowOpenDisposition; AUserGesture: Boolean; const APopupFeatures: TCefPopupFeatures; var AWindowInfo: TCefWindowInfo; var AClient: ICefClient;
      var ASettings: TCefBrowserSettings; var AExtraInfo: ICefDictionaryValue; var ANoJavascriptAccess, AResult: Boolean);
    procedure ChromiumKeyEvent(ASender: TObject; const ABrowser: ICefBrowser; const AEvent: PCefKeyEvent; AosEvent: PMsg; out AResult: Boolean);
    procedure actToggleDevToolsExecute(Sender: TObject);
    procedure actToggleAudioExecute(Sender: TObject);
    procedure ChromiumBeforeContextMenu(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; const AModel: ICefMenuModel);
    procedure ChromiumContextMenuCommand(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; ACommandId: Integer; AEventFlags: Cardinal; out AResult: Boolean);
    procedure ChromiumAfterCreated(ASender: TObject; const ABrowser: ICefBrowser);
    procedure ChromiumClose(ASender: TObject; const ABrowser: ICefBrowser; var AAction: TCefCloseBrowserAction);
    procedure edUrlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChromiumLoadEnd(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; AHttpStatusCode: Integer);
    procedure ChromiumLoadError(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; AErrorCode: Integer; const AErrorText, AFailedUrl: ustring);
    procedure ChromiumOpenUrlFromTab(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const ATargetUrl: ustring; ATargetDisposition: TCefWindowOpenDisposition; AUserGesture: Boolean; out AResult: Boolean);
    procedure ChromiumLoadStart(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; ATransitionType: Cardinal);
    procedure ChromiumProcessMessageReceived(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; ASourceProcess: TCefProcessId; const AMessage: ICefProcessMessage; out AResult: Boolean);
  private
    FClosing: Boolean;
    FOnContextMenuCommand: TOnContextMenuCommand;
    FOnBeforeContextMenu: TOnBeforeContextMenu;
    FSelectedText: string;

    procedure BrowserCreatedMsg(var AMessage: TMessage); message CEF_AFTERCREATED;
    procedure BrowserDetroyParentWindow(var AMessage: TMessage); message BDTKBROWSER_DESTROYWNDPARENT;
    procedure RunAction(var AMessage: TMessage); message BDTKBROWSER_RUN_ACTION;
  public
    procedure Initialize(const ADefaultUrl: string);

    procedure HandleKeyUp(const AMsg: TMsg; var AHandled: Boolean);
    procedure HandleKeyDown(const AMsg: TMsg; var AHandled: Boolean);

    property Closing: Boolean read FClosing;

    property SelectedText: string read FSelectedText;

    property OnBeforeContextMenu: TOnBeforeContextMenu read FOnBeforeContextMenu write FOnBeforeContextMenu;
    property OnContextMenuCommand: TOnContextMenuCommand read FOnContextMenuCommand write FOnContextMenuCommand;
  end;

implementation

uses
  System.Math, uCEFMiscFunctions, BD.Utils.Chromium.Extension, Vcl.Clipbrd,
  System.IOUtils, uCEFApplication;

{$R *.dfm}

{ TframeBDTKWebBrowser }

procedure TframeBDTKWebBrowser.Initialize(const ADefaultUrl: string);
begin
  edUrl.Text := ADefaultUrl; // utile pour éviter que le TEdit montre autre chose au premier affichage (même brièvement)
  Chromium.DefaultUrl := ADefaultUrl;
  Chromium.CreateBrowser(WindowParent);
end;

procedure TframeBDTKWebBrowser.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  actBack.Enabled := Chromium.CanGoBack;
  actForward.Enabled := Chromium.CanGoForward;
  if Chromium.IsLoading then
    actReload.Caption := 'S'
  else
    actReload.Caption := '@';

  if DevTools.Visible then
    actToggleDevTools.Caption := 'Cacher les outils de développement'
  else
    actToggleDevTools.Caption := 'Afficher les outils de développement';
  if Chromium.AudioMuted then
    actToggleAudio.Caption := 'Réactiver le son de l''onglet'
  else
    actToggleAudio.Caption := 'Couper le son de l''onglet';
end;

procedure TframeBDTKWebBrowser.actBackExecute(ASender: TObject);
begin
  Chromium.GoBack;
end;

procedure TframeBDTKWebBrowser.actForwardExecute(ASender: TObject);
begin
  Chromium.GoForward;
end;

procedure TframeBDTKWebBrowser.actReloadExecute(ASender: TObject);
begin
  if Chromium.IsLoading then
    Chromium.StopLoad
  else
    Chromium.Reload;
end;

procedure TframeBDTKWebBrowser.actToggleAudioExecute(Sender: TObject);
begin
  Chromium.AudioMuted := not Chromium.AudioMuted;
end;

procedure TframeBDTKWebBrowser.actToggleDevToolsExecute(Sender: TObject);
var
  p: TPoint;
begin
  try
    if DevTools.Visible then
    begin
      Chromium.CloseDevTools(DevTools);
      Splitter.Visible := False;
      DevTools.Visible := False;
      Chromium.SetFocus(True);
    end
    else
    begin
      if actToggleDevTools.Tag <> 0 then
        p := TPoint.Create((actToggleDevTools.Tag shr 16) and $FFFF, actToggleDevTools.Tag and $FFFF)
      else
        p := TPoint.Create(Low(Integer), Low(Integer));

      Splitter.Visible := True;
      DevTools.Visible := True;
      DevTools.Width := Width div 4;
      Chromium.ShowDevTools(p, DevTools);
    end;
  finally
    actToggleDevTools.Tag := 0;
  end;
end;

procedure TframeBDTKWebBrowser.RunAction(var AMessage: TMessage);
begin
  AMessage.Result := NativeInt(TAction(AMessage.LParam).Execute);
end;

procedure TframeBDTKWebBrowser.ChromiumAddressChange(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AUrl: ustring);
begin
  if not FClosing then
    edUrl.Text := AUrl;
end;

procedure TframeBDTKWebBrowser.ChromiumAfterCreated(ASender: TObject; const ABrowser: ICefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TframeBDTKWebBrowser.BrowserCreatedMsg(var AMessage: TMessage);
begin
  WindowParent.UpdateSize;
end;

procedure TframeBDTKWebBrowser.ChromiumClose(ASender: TObject; const ABrowser: ICefBrowser; var AAction: TCefCloseBrowserAction);
begin
  AAction := cbaDelay;
  PostMessage(Handle, BDTKBROWSER_DESTROYWNDPARENT, 0, 0);
end;

procedure TframeBDTKWebBrowser.BrowserDetroyParentWindow(var AMessage: TMessage);
begin
  // déclenchera Chromium.OnBeforeClose
  FreeAndNil(WindowParent);
end;

procedure TframeBDTKWebBrowser.ChromiumBeforeContextMenu(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; const AModel: ICefMenuModel);

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

begin
  AModel.Remove(MENU_ID_PRINT);
  AModel.Remove(MENU_ID_VIEW_SOURCE);

  AModel.AddSeparator;
  if Assigned(FOnBeforeContextMenu) then
    FOnBeforeContextMenu(ASender, ABrowser, AFrame, AParams, AModel);
  AModel.AddSeparator;
  if AParams.LinkUrl <> '' then
  begin
    AModel.AddItem(BDTKBROWSER_CONTEXTMENU_COPY_LINK, 'Copier le lien dans le presse-papiers');
    AModel.AddItem(BDTKBROWSER_CONTEXTMENU_LINK_TO_NEW_TAB, 'Ouvrir le lien dans un nouvel onglet');
  end;
  AModel.AddSeparator;
  // AModel.AddItem(BDTKBROWSER_CONTEXTMENU_EMPTY_CACHE_AND_RELOAD, 'Vider le cache et recharger la page');
  AModel.AddItem(BDTKBROWSER_CONTEXTMENU_TOGGLEDEVTOOLS, actToggleDevTools.Caption);
  AModel.AddItem(BDTKBROWSER_CONTEXTMENU_TOGGLEAUDIO, actToggleAudio.Caption);
  AModel.AddSeparator;

  CleanSeparators(AModel);
end;

procedure TframeBDTKWebBrowser.ChromiumContextMenuCommand(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const AParams: ICefContextMenuParams; ACommandId: Integer; AEventFlags: Cardinal; out AResult: Boolean);
begin
  // par défaut, on dit qu'on n'a rien fait et on laisse CEF faire le boulot
  // comme on ne gère que des id User, CEF ne fera rien de plus
  AResult := False;

  case ACommandId of
    BDTKBROWSER_CONTEXTMENU_TOGGLEDEVTOOLS:
      begin
        actToggleDevTools.Tag := ((AParams.XCoord and $FFFF) shl 16) or (AParams.YCoord and $FFFF);
        PostMessage(Handle, BDTKBROWSER_RUN_ACTION, 0, LParam(actToggleDevTools));
      end;
    BDTKBROWSER_CONTEXTMENU_TOGGLEAUDIO:
      PostMessage(Handle, BDTKBROWSER_RUN_ACTION, 0, LParam(actToggleAudio));
    BDTKBROWSER_CONTEXTMENU_COPY_LINK:
      Clipboard.AsText := AParams.LinkUrl;
    BDTKBROWSER_CONTEXTMENU_EMPTY_CACHE_AND_RELOAD:
      begin
        // Chromium.ReloadIgnoreCache;
        TDirectory.Delete(GlobalCEFApp.Cache, True);
        Chromium.Reload;
      end;
    else
      if Assigned(FOnContextMenuCommand) then
        FOnContextMenuCommand(ASender, ABrowser, AFrame, AParams, ACommandId, AEventFlags, AResult);
  end;
end;

procedure TframeBDTKWebBrowser.ChromiumBeforePopup(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const ATargetUrl, ATargetFrameName: ustring;
  ATargetDisposition: TCefWindowOpenDisposition; AUserGesture: Boolean; const APopupFeatures: TCefPopupFeatures; var AWindowInfo: TCefWindowInfo; var AClient: ICefClient;
  var ASettings: TCefBrowserSettings; var AExtraInfo: ICefDictionaryValue; var ANoJavascriptAccess, AResult: Boolean);
begin
  AResult := (ATargetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TframeBDTKWebBrowser.ChromiumKeyEvent(ASender: TObject; const ABrowser: ICefBrowser; const AEvent: PCefKeyEvent; AosEvent: PMsg; out AResult: Boolean);
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

procedure TframeBDTKWebBrowser.ChromiumLoadEnd(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; AHttpStatusCode: Integer);
begin
  StatusBar1.SimpleText := '';
  RegisterMouseOverEvent(AFrame);
end;

procedure TframeBDTKWebBrowser.ChromiumLoadError(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; AErrorCode: Integer; const AErrorText, AFailedUrl: ustring);
var
  page: string;
begin
  StatusBar1.SimpleText := '';
  if (AErrorCode = ERR_ABORTED) then
    Exit;

  page := '<html><body bgcolor="white"><h2>Failed to load URL ' + AFailedUrl + ' with error ' + AErrorText + ' (' + AErrorCode.ToString + ').</h2></body></html>';
  Chromium.LoadURL(CefGetDataURI(page, 'text/html'));
end;

procedure TframeBDTKWebBrowser.ChromiumLoadStart(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; ATransitionType: Cardinal);
begin
  StatusBar1.SimpleText := 'Chargement de ' + AFrame.Url;
end;

procedure TframeBDTKWebBrowser.ChromiumOpenUrlFromTab(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; const ATargetUrl: ustring; ATargetDisposition: TCefWindowOpenDisposition; AUserGesture: Boolean; out AResult: Boolean);
begin
  // CTRL + Click sur un lien...
end;

procedure TframeBDTKWebBrowser.ChromiumProcessMessageReceived(ASender: TObject; const ABrowser: ICefBrowser; const AFrame: ICefFrame; ASourceProcess: TCefProcessId; const AMessage: ICefProcessMessage; out AResult: Boolean);
begin
  AResult := False;

  if (AMessage = nil) or (AMessage.ArgumentList = nil) then
    Exit;

  // This function receives the messages with the JavaScript results

  // Many of these events are received in different threads and the VCL
  // doesn't like to create and destroy components in different threads.

  // It's safer to store the results and send a message to the main thread to show them.

  if (AMessage.Name = MOUSEOVER_MESSAGE_NAME) then
  begin
    StatusBar1.SimpleText := AMessage.ArgumentList.GetString(0);
    AResult := True;
  end
  else if (AMessage.Name = SELECTEDTEXT_MESSAGE_NAME) then
  begin
    FSelectedText := AdjustLineBreaks(AMessage.ArgumentList.GetString(0));
    AResult := True;
  end;
end;

procedure TframeBDTKWebBrowser.edUrlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Chromium.LoadURL(edUrl.Text);
end;

procedure TframeBDTKWebBrowser.HandleKeyUp(const AMsg: TMsg; var AHandled: Boolean);
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

    if DevTools.Visible then
      PostMessage(Handle, BDTKBROWSER_HIDEDEVTOOLS, 0, 0)
    else
      PostMessage(Handle, BDTKBROWSER_SHOWDEVTOOLS, 0, 0);
  end;
end;

procedure TframeBDTKWebBrowser.HandleKeyDown(const AMsg: TMsg; var AHandled: Boolean);
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

end.
