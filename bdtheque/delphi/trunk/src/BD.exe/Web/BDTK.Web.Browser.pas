unit BDTK.Web.Browser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BD.GUI.Forms;

type
  TfrmBDTKWebBrowser = class(TBdtForm)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  uCEFApplication, BD.Utils.GUIUtils, BD.Utils.Chromium;

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

end.
