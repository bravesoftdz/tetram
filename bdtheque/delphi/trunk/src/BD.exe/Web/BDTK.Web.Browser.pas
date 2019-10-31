unit BDTK.Web.Browser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BD.GUI.Forms, BD.GUI.Frames.Buttons,
  BD.Entities.Full;

type
  TfrmBDTKWebBrowser = class(TBdtForm)
    Frame11: TframBoutons;
  private
    FAutoSearchKeyWords: string;
    FAlbum: TAlbumFull;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Album: TAlbumFull read FAlbum write FAlbum;
    property AutoSearchKeyWords: string read FAutoSearchKeyWords write FAutoSearchKeyWords;
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
