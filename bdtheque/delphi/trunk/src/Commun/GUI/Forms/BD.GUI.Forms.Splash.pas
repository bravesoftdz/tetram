unit BD.GUI.Forms.Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, verslabp, Vcl.Imaging.jpeg, BD.GUI.Forms, Vcl.Imaging.pngimage;

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
    function GetFileName: TFileName;
    procedure SetFileName(const Value: TFileName);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Affiche_act(const Texte: string);
    property FileName: TFileName read GetFileName write SetFileName;
  end;

implementation

uses
  BD.Common;

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

function TfrmSplash.GetFileName: TFileName;
begin
  Result := VersionLabel1.Filename;
end;

procedure TfrmSplash.SetFileName(const Value: TFileName);
begin
  VersionLabel1.Filename := Value;
  VersionLabel2.Filename := Value;
end;

end.
