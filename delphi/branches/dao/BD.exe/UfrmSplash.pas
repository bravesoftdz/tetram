unit UfrmSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, verslabp, jpeg, UBdtForms;

type
  TfrmSplash = class(TbdtForm)
    Label1: TLabel;
    VersionLabel1: TfshVersionLabel;
    Label2: TLabel;
    VersionLabel2: TfshVersionLabel;
    Image2: TImage;
    acte: TBevel;
    ImageFond: TImage;
    Image1: TImage;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Affiche_act(const Texte: string);
  end;

var
  frmSplash: TfrmSplash;

implementation

uses CommonConst;

{$R *.DFM}

procedure TfrmSplash.FormCreate(Sender: TObject);
var
  FormRgn: hRgn;
begin
  ImageFond.Picture.Bitmap.LoadFromResourceName(HInstance, 'ABOUT');

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

procedure TfrmSplash.Affiche_act(const Texte: string);
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

procedure TfrmSplash.FormDestroy(Sender: TObject);
begin
  Cursor := crDefault;
end;

end.
