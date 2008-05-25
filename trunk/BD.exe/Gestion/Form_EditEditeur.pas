unit Form_EditEditeur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, DBEditLabeled, ShellAPI, Fram_Boutons, LoadComplet, UBdtForms;

type
  TFrmEditEditeur = class(TbdtForm)
    ScrollBox1: TScrollBox;
    Label2: TLabel;
    edNom: TEditLabeled;
    Label1: TLabel;
    edSite: TEditLabeled;
    VDTButton13: TVDTButton;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FEditeur: TEditeurComplet;
    procedure SetID_Editeur(const Value: TGUID);
    function GetID_Editeur: TGUID;
  public
    { Déclarations publiques }
    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
  end;

implementation

uses
  JvUIB, Commun, Procedures, Textes;

{$R *.DFM}

procedure TFrmEditEditeur.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FEditeur := TEditeurComplet.Create;
end;

procedure TFrmEditEditeur.SetID_Editeur(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FEditeur.Fill(Value);

  edNom.Text := FEditeur.NomEditeur;
  edSite.Text := FEditeur.SiteWeb;
end;

procedure TFrmEditEditeur.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FEditeur.NomEditeur := Trim(edNom.Text);
  FEditeur.SiteWeb := Trim(edSite.Text);
  FEditeur.SaveToDatabase;

  ModalResult := mrOk;
end;

procedure TFrmEditEditeur.FormShow(Sender: TObject);
begin
  edNom.SetFocus;
end;

procedure TFrmEditEditeur.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TFrmEditEditeur.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := Copy(LowerCase(edSite.Text), 1, 7) = 'http://';
end;

function TFrmEditEditeur.GetID_Editeur: TGUID;
begin
  Result := FEditeur.ID_Editeur;
end;

procedure TFrmEditEditeur.FormDestroy(Sender: TObject);
begin
  FEditeur.Free;
end;

end.

