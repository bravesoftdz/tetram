unit BDTK.Web.Frames.Browser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, uCEFChromium, uCEFWinControl, uCEFWindowParent, System.Actions, Vcl.ActnList, uCEFInterfaces, uCEFTypes,
  BDTK.Web.Browser.Utils, uCEFChromiumEvents, uCEFConstants, Vcl.ComCtrls,
  uCEFUrlRequestClientComponent, System.Generics.Collections;

type
  TDownloadPromise = TProc<string, TStream>;
  TDownload = class
  private
    FFilename: string;
    FPromise: TDownloadPromise;
    FStream: TMemoryStream;
    FUrl: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure PrepareDownload;

    property Url: string read FUrl write FUrl;
    property Filename: string read FFilename write FFilename;
    property Promise: TDownloadPromise read FPromise write FPromise;
    property Stream: TMemoryStream read FStream;
  end;

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
    CEFUrlRequestClientComponent1: TCEFUrlRequestClientComponent;
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
    procedure CEFUrlRequestClientComponent1DownloadData(ASender: TObject; const ARequest: ICefUrlRequest; AData: Pointer; ADataLength: NativeUInt);
    procedure CEFUrlRequestClientComponent1DownloadProgress(ASender: TObject; const ARequest: ICefUrlRequest; ACurrent, ATotal: Int64);
    procedure CEFUrlRequestClientComponent1RequestComplete(ASender: TObject; const ARequest: ICefUrlRequest);
    procedure CEFUrlRequestClientComponent1CreateURLRequest(ASender: TObject);
  private
    FClosing: Boolean;
    FOnContextMenuCommand: TOnContextMenuCommand;
    FOnBeforeContextMenu: TOnBeforeContextMenu;
    FSelectedText: string;
    FPendingDownloads: TQueue<TDownload>;
    FCurrentDownloads: TObjectDictionary<UInt64, TDownload>;

    procedure BrowserCreatedMsg(var AMessage: TMessage); message CEF_AFTERCREATED;
    procedure BrowserDetroyParentWindow(var AMessage: TMessage); message BDTKBROWSER_DESTROYWNDPARENT;
    procedure RunAction(var AMessage: TMessage); message BDTKBROWSER_RUN_ACTION;
    procedure URLRequestSuccess(var AMessage: TMessage); message BDTKBROWSER_URLREQUEST_SUCCESS;
    procedure URLRequestError(var AMessage: TMessage); message BDTKBROWSER_URLREQUEST_ERROR;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize(const ADefaultUrl: string);

    procedure HandleKeyUp(const AMsg: TMsg; var AHandled: Boolean);
    procedure HandleKeyDown(const AMsg: TMsg; var AHandled: Boolean);

    procedure DownloadURL(const AUrl: string; APromise: TDownloadPromise);

    property Closing: Boolean read FClosing;

    property SelectedText: string read FSelectedText;

    property OnBeforeContextMenu: TOnBeforeContextMenu read FOnBeforeContextMenu write FOnBeforeContextMenu;
    property OnContextMenuCommand: TOnContextMenuCommand read FOnContextMenuCommand write FOnContextMenuCommand;
  end;

implementation

uses
  System.Math, uCEFMiscFunctions, BD.Utils.Chromium.Extension, Vcl.Clipbrd,
  System.IOUtils, uCEFApplication, uCEFRequest, uCEFUrlRequest;

{$R *.dfm}

{ TDownload }

constructor TDownload.Create;
begin

end;

destructor TDownload.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

procedure TDownload.PrepareDownload;
begin
  if not Assigned(FStream) then
    FStream := TMemoryStream.Create;
end;

{ TframeBDTKWebBrowser }

constructor TframeBDTKWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  FPendingDownloads := TQueue<TDownload>.Create;
  FCurrentDownloads := TObjectDictionary<UInt64, TDownload>.Create([doOwnsValues]);
end;

destructor TframeBDTKWebBrowser.Destroy;
begin
  while FPendingDownloads.Count > 0 do
    FPendingDownloads.Dequeue.Free;
  FPendingDownloads.Free;

  FCurrentDownloads.Free;

  inherited;
end;

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

procedure TframeBDTKWebBrowser.CEFUrlRequestClientComponent1CreateURLRequest(ASender: TObject);
var
  Download: TDownload;
  NewRequest: ICefRequest;
begin
  while FPendingDownloads.Count > 0 do
  begin
    Download := FPendingDownloads.Dequeue;
    try
      NewRequest := TCefRequestRef.New;
      NewRequest.Url := Download.Url;
      NewRequest.Method := 'GET';
      NewRequest.Flags := UR_FLAG_ALLOW_STORED_CREDENTIALS;

      // Set the "client" parameter to the TCEFUrlRequestClientComponent.Client property
      // to use the TCEFUrlRequestClientComponent events.
      // The "requestContext" parameter can be nil to use the global request context.
      TCefUrlRequestRef.New(NewRequest, CEFUrlRequestClientComponent1.Client, nil);
      FCurrentDownloads.Add(NewRequest.Identifier, Download);
    finally
      NewRequest := nil;
    end;
  end;
end;

procedure TframeBDTKWebBrowser.CEFUrlRequestClientComponent1DownloadData(ASender: TObject; const ARequest: ICefUrlRequest; AData: Pointer; ADataLength: NativeUInt);
var
  Download: TDownload;
begin
  if not Assigned(ARequest) then
    Exit;

  if FClosing then
    ARequest.Cancel
  else if (AData <> nil) and (ADataLength > 0) and FCurrentDownloads.TryGetValue(ARequest.Request.Identifier, Download) then
  begin
    Download.PrepareDownload;
    Download.Stream.WriteBuffer(AData^, ADataLength);
  end;
end;

procedure TframeBDTKWebBrowser.CEFUrlRequestClientComponent1DownloadProgress(ASender: TObject; const ARequest: ICefUrlRequest; ACurrent, ATotal: Int64);
begin
  if not Assigned(ARequest) then
    Exit;

  if FClosing then
    ARequest.Cancel
  else
  begin
//    if (ATotal > 0) then
//      StatusBar1.Panels[0].Text := 'Downloading : ' + inttostr(round((ACurrent / ATotal) * 100)) + ' %'
//    else
//      StatusBar1.Panels[0].Text := 'Downloading : ' + inttostr(ACurrent) + ' bytes';
  end;
end;

procedure TframeBDTKWebBrowser.CEFUrlRequestClientComponent1RequestComplete(ASender: TObject; const ARequest: ICefUrlRequest);
begin
  if not Assigned(ARequest) then
    Exit;

  // Use ARequest.response here to get a ICefResponse interface with all the response headers, status, error code, etc.

  if (ARequest.RequestStatus = UR_SUCCESS) then
    PostMessage(Handle, BDTKBROWSER_URLREQUEST_SUCCESS, ARequest.Request.Identifier, 0)
  else
    PostMessage(Handle, BDTKBROWSER_URLREQUEST_ERROR, ARequest.Request.Identifier, ARequest.RequestError);
end;

procedure TframeBDTKWebBrowser.URLRequestError(var AMessage: TMessage);
var
  Download: TDownload;
begin
  if not FCurrentDownloads.TryGetValue(AMessage.WParam, Download) then
    Exit;
  try

  finally
    FCurrentDownloads.Remove(AMessage.WParam);
  end;
end;

procedure TframeBDTKWebBrowser.URLRequestSuccess(var AMessage: TMessage);
var
  Download: TDownload;
begin
  if not FCurrentDownloads.TryGetValue(AMessage.WParam, Download) then
    Exit;
  try
    Download.Promise(Download.Filename, Download.Stream);
  finally
    FCurrentDownloads.Remove(AMessage.WParam);
  end;
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

  function HasVisible(AMenu: ICefMenuModel): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Pred(AMenu.GetCount) do
      if AMenu.isVisibleAt(i) then
        Exit(True);
  end;

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
            if not HasVisible(SubMenu) then
              if (AMenu = AModel) and InRange(AMenu.GetCommandIdAt(i), MENU_ID_USER_FIRST, MENU_ID_USER_LAST) then
                AMenu.SetEnabledAt(i, False)
              else
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
      Clipboard.AsText := AParams.UnfilteredLinkUrl;
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

procedure TframeBDTKWebBrowser.DownloadURL(const AUrl: string; APromise: TDownloadPromise);
var
  UrlParts: TUrlParts;
  i: Integer;
  NewDownload: TDownload;
begin
  if AUrl.IsEmpty then
    Exit;

  NewDownload := TDownload.Create;
  NewDownload.Url := AURL;
  NewDownload.Promise := APromise;

  CefParseUrl(AUrl, UrlParts);
  NewDownload.Filename := string(UrlParts.path).Trim;

  i := NewDownload.Filename.LastIndexOf('/');
  if (i >= 0) then
    NewDownload.Filename := NewDownload.Filename.Substring(i + 1).Trim;

  FPendingDownloads.Enqueue(NewDownload);
  CEFUrlRequestClientComponent1.AddURLRequest;
end;

end.
