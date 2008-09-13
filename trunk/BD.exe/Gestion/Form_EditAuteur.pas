unit Form_EditAuteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, Menus, ExtCtrls,
  DBEditLabeled, DB, Buttons, VDTButton, Fram_Boutons, LoadComplet, UBdtForms;

type
  TFrmEditAuteur = class(TbdtForm)
    ScrollBox1: TScrollBox;
    edBiographie: TMemoLabeled;
    edNom: TEditLabeled;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edSite: TEditLabeled;
    VDTButton13: TVDTButton;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure Frame11btnOKClick(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FAuteur: TAuteurComplet;
    procedure SetID_Auteur(const Value: TGUID);
    function GetID_Auteur: TGUID;
  public
    { Déclarations publiques }
    property ID_Auteur: TGUID read GetID_Auteur write SetID_Auteur;
  end;

implementation

uses Commun, ShellAPI, Procedures, Textes;

{$R *.DFM}

procedure TFrmEditAuteur.SetID_Auteur(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FAuteur.Fill(Value);

  edNom.Text := FAuteur.NomAuteur;
  edSite.Text := FAuteur.SiteWeb;
  edBiographie.Lines.Text := FAuteur.Biographie.Text;
end;

procedure TFrmEditAuteur.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FAuteur.NomAuteur := Trim(edNom.Text);
  FAuteur.SiteWeb := Trim(edSite.Text);
  FAuteur.Biographie.Text := edBiographie.Lines.Text;
  FAuteur.SaveToDatabase;

  ModalResult := mrOk;
end;

procedure TFrmEditAuteur.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := CompareMem(PChar(LowerCase(Trim(edSite.Text))), PChar('http://'), 7);
end;

procedure TFrmEditAuteur.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TFrmEditAuteur.FormCreate(Sender: TObject);
begin
  FAuteur := TAuteurComplet.Create;
end;

procedure TFrmEditAuteur.FormDestroy(Sender: TObject);
begin
  FAuteur.Free;
end;

function TFrmEditAuteur.GetID_Auteur: TGUID;
begin
  Result := FAuteur.ID_Auteur;
end;

end.

