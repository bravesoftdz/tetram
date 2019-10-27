unit UfrmEditAuteur;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.Menus, Vcl.ExtCtrls,
  EditLabeled, Vcl.Buttons, VDTButton, BD.GUI.Frames.Buttons, BD.Entities.Full, BD.GUI.Forms,
  PngSpeedButton, Vcl.ComCtrls;

type
  TfrmEditAuteur = class(TbdtForm)
    ScrollBox1: TScrollBox;
    edBiographie: TMemoLabeled;
    edNom: TEditLabeled;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edSite: TEditLabeled;
    VDTButton13: TVDTButton;
    Bevel1: TBevel;
    Frame11: TframBoutons;
    edAssociations: TMemoLabeled;
    Label4: TLabel;
    Bevel4: TBevel;
    Label28: TLabel;
    procedure Frame11btnOKClick(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
  private
    { Déclarations privées }
    FAuteur: TAuteurFull;
    procedure SetAuteur(const Value: TAuteurFull);
    function GetID_Auteur: TGUID;
  public
    { Déclarations publiques }
    property ID_Auteur: TGUID read GetID_Auteur;
    property Auteur: TAuteurFull read FAuteur write SetAuteur;
  end;

implementation

uses
  BD.Utils.StrUtils, Winapi.ShellAPI, BD.Utils.GUIUtils, BD.Strings, BDTK.GUI.Controls.VirtualTree, BDTK.Entities.Dao.Full,
  BD.Entities.Common;

{$R *.DFM}

procedure TfrmEditAuteur.SetAuteur(const Value: TAuteurFull);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FAuteur := Value;
  TDaoAuteurFull.FillAssociations(FAuteur, vmPersonnes);

  edNom.Text := FAuteur.NomAuteur;
  edSite.Text := FAuteur.SiteWeb;
  edBiographie.Text := FAuteur.Biographie;
  edAssociations.Text := FAuteur.Associations.Text;
end;

procedure TfrmEditAuteur.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FAuteur.NomAuteur := Trim(edNom.Text);
  FAuteur.SiteWeb := Trim(edSite.Text);
  FAuteur.Biographie := edBiographie.Text;
  FAuteur.Associations.Text := edAssociations.Text;

  TDaoAuteurFull.SaveToDatabase(FAuteur, nil);
  TDaoAuteurFull.SaveAssociations(FAuteur, vmPersonnes, GUID_NULL);

  ModalResult := mrOk;
end;

procedure TfrmEditAuteur.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := CompareMem(PChar(LowerCase(Trim(edSite.Text))), PChar('http://'), 7);
end;

procedure TfrmEditAuteur.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

function TfrmEditAuteur.GetID_Auteur: TGUID;
begin
  Result := FAuteur.ID_Auteur;
end;

end.

