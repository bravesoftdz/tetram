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
  uCEFApplication, BD.Utils.GUIUtils;

{$R *.dfm}

procedure InitializeBrowser;
var
  HourGlass: IHourGlass;
begin
  if Assigned(GlobalCEFApp) then
    Exit;

  HourGlass := THourGlass.Create;

  GlobalCEFApp := TCefApplication.Create;

  // obligatoire pour permettre à bdtheque d'être lancé sans donner le chemin de démarrage
  // (= les dll de Chromium se trouvent toujours avec l'appli, on n'autorise pas à contourner leur emplacement)
  GlobalCEFApp.SetCurrentDir := True;

  // obligatoire puisqu'on n'initialise pas GlobalCEFApp dans le dpr
  GlobalCEFApp.SingleProcess := True;

  GlobalCEFApp.FrameworkDirPath := 'Chromium';
  GlobalCEFApp.ResourcesDirPath := 'Chromium';
  GlobalCEFApp.LocalesDirPath := 'Chromium';
  GlobalCEFApp.LocalesRequired := 'fr';

  if not GlobalCEFApp.StartMainProcess then
    Exit;
end;

procedure FinalizeBrowser;
var
  HourGlass: IHourGlass;
begin
  if not Assigned(GlobalCEFApp) then
    Exit;

  HourGlass := THourGlass.Create;

  GlobalCEFApp.Free;
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

initialization
  // on attend le dernier moment pour charger Chromimum (pas besoin de surcharger le process si on ne s'en sert pas)

finalization
  FinalizeBrowser;

end.
