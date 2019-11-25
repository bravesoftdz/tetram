unit BD.Utils.Chromium.Extension;

{.$D-} // le debugage n'est possible qu'en single process, et les extensions javascript qu'en multi process...

interface

uses
  uCEFInterfaces, System.Classes;

const
  MOUSEOVER_MESSAGE_NAME = 'MouseOver';
  SELECTEDTEXT_MESSAGE_NAME = 'SelectedText';

type
  TBrowserExtension = class
  private
    class var FRegistered: Boolean;
  public
    class property Registered: Boolean read FRegistered;

    class procedure mouseOver(const link: string);
    class procedure getSelectedText(const lang, selectedText: string);
  end;

procedure SetExtensionRegistered(AValue: Boolean);

function RegisterMouseOverEvent(const AFrame: ICefFrame): Boolean;

implementation

uses
  uCEFProcessMessage, uCEFConstants, uCEFMiscFunctions, uCEFv8Context, uCEFTypes,
  uCEFv8Value;

procedure SetExtensionRegistered(AValue: Boolean);
begin
  TBrowserExtension.FRegistered := True;
end;

function RegisterMouseOverEvent(const AFrame: ICefFrame): Boolean;
var
  JSCode: string;
begin
  if not (Assigned(AFrame) and AFrame.IsValid) then
    Exit(False);

//  JSCode := 'document.body.addEventListener("mouseover", function(evt){BrowserExtension.mouseOver(evt.target)})';

  JSCode := 'document.addEventListener("mouseover", function(evt){'+
                'var n = evt.target;'+
                'while (n && !(n instanceof HTMLAnchorElement)) {n = n.parentNode;}'+
                'BrowserExtension.mouseOver(n ? n.href : "");'+
              '}'+
            ')';
  AFrame.ExecuteJavaScript(JSCode, '', 0);

  JSCode := 'document.addEventListener("selectionchange", function(){'+
    'var s = window.getSelection();' +
    'var n = s.anchorNode;'+
    'while (n && n.parentNode && (!n.lang || n.lang === "")) {n = n.parentNode;}' +
    'BrowserExtension.getSelectedText(n ? n.lang : "", s.toString());' +
    '})';
  AFrame.ExecuteJavaScript(JSCode, '', 0);

  Result := True;
end;

{ TBrowserExtension }

class procedure TBrowserExtension.getSelectedText(const lang, selectedText: string);
var
  Msg: ICefProcessMessage;
  Frame: ICefFrame;
begin
  // TCefv8ContextRef.Current returns the v8 context for the frame that is currently executing Javascript.
  Frame := TCefv8ContextRef.Current.Browser.MainFrame;
  if not (Assigned(Frame) and Frame.IsValid) then
    Exit;

  try
    Msg := TCefProcessMessageRef.New(SELECTEDTEXT_MESSAGE_NAME);
    Msg.ArgumentList.SetString(0, lang);
    Msg.ArgumentList.SetString(1, selectedText);

    // Sending a message back to the browser. It'll be received in the TChromium.OnProcessMessageReceived event.
    Frame.SendProcessMessage(PID_BROWSER, Msg);
  finally
    Msg := nil;
  end;
end;

class procedure TBrowserExtension.mouseOver(const link: string);
var
  Msg: ICefProcessMessage;
  Frame: ICefFrame;
begin
  // TCefv8ContextRef.Current returns the v8 context for the frame that is currently executing Javascript.
  Frame := TCefv8ContextRef.Current.Browser.MainFrame;
  if not (Assigned(Frame) and Frame.IsValid) then
    Exit;

  try
    Msg := TCefProcessMessageRef.New(MOUSEOVER_MESSAGE_NAME);
    Msg.ArgumentList.SetString(0, link);

    // Sending a message back to the browser. It'll be received in the TChromium.OnProcessMessageReceived event.
    Frame.SendProcessMessage(PID_BROWSER, Msg);
  finally
    Msg := nil;
  end;
end;

end.
