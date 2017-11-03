unit Form_Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, verslabp, HarmFade, jpeg;

type
  TFrmSplash = class(TForm)
    Label1: TLabel;
    VersionLabel1: TVersionLabelP;
    Label2: TLabel;
    VersionLabel2: TVersionLabelP;
    Image2: TImage;
    acte: TBevel;
    ImageFond: TImage;
    Image1: TImage;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    procedure Affiche_act(Texte: string);
  end;

var
  FrmSplash: TFrmSplash;

implementation

uses Main, CommonConst;

{$R *.DFM}

procedure TFrmSplash.FormCreate(Sender: TObject);
var
  FormRgn: hRgn;
begin
  Cursor := crHourglass;
  //  ClientHeight := ImageFond.Height + ImageFond.Top;
  //  ClientWidth := ImageFond.Width + ImageFond.Left;
  Canvas.Brush.Style := bsClear;
  FormRgn := 0;
  if GetWindowRgn(Handle, FormRgn) in [SIMPLEREGION, COMPLEXREGION] then
    DeleteObject(FormRgn);
  FormRgn := CreateRoundRectRgn(0, 0, ClientWidth, ClientHeight, 20, 20);
  SetWindowRgn(Handle, FormRgn, TRUE);
end;

procedure TFrmSplash.Affiche_act(Texte: string);
begin
  Label1.Visible := True;
  Image2.Visible := True;
  versionLabel1.Visible := True;
  acte.Visible := True;
  Label2.Visible := True;
  VersionLabel2.Visible := True;
  Image1.Visible := True;

  Label4.Visible := True;
  Label4.Caption := Texte;
  Application.ProcessMessages;
end;

procedure TFrmSplash.FormDestroy(Sender: TObject);
begin
  Utilisateur.AppVersion := Copy(VersionLabel1.Caption, Length(VersionLabel1.InfoPrefix) + 1, Length(VersionLabel1.Caption) - Length(VersionLabel1.InfoPrefix));
  Application.Title := '� Tetr�mCorp ' + TitreApplication + Utilisateur.AppVersion;
  Fond.Caption := Application.Title;
  Cursor := crDefault;
end;

end.
