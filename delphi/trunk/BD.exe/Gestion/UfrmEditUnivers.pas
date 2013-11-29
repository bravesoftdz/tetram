unit UfrmEditUnivers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, ExtCtrls, DBCtrls, Mask, Buttons, VDTButton, ComCtrls,
  EditLabeled, VirtualTrees, VirtualTree, LoadComplet, Menus, ExtDlgs, UframRechercheRapide, UframBoutons, UBdtForms,
  ComboCheck, StrUtils, PngSpeedButton, UframVTEdit;

type
  TfrmEditUnivers = class(TbdtForm)
    ScrollBox2: TScrollBox;
    Label2: TLabel;
    edNom: TEditLabeled;
    Bevel2: TBevel;
    Label6: TLabel;
    edDescription: TMemoLabeled;
    vtAlbums: TVirtualStringTree;
    VDTButton13: TVDTButton;
    edSite: TEditLabeled;
    Label1: TLabel;
    vtParaBD: TVirtualStringTree;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Frame11: TframBoutons;
    edAssociations: TMemoLabeled;
    Label10: TLabel;
    Bevel4: TBevel;
    Label28: TLabel;
    vtEditUnivers: TframVTEdit;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edNomChange(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure vtParaBDDblClick(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FUnivers: TUniversComplet;
    procedure SetUnivers(Value: TUniversComplet);
    function GetID_Univers: TGUID;
  public
    { Déclarations publiques }
    property ID_Univers: TGUID read GetID_Univers;
    property Univers: TUniversComplet read FUnivers write SetUnivers;
  end;

implementation

uses
  Commun, Proc_Gestions, TypeRec, Procedures, Divers, Textes, StdConvs, ShellAPI, CommonConst, JPEG,
  UHistorique, UMetadata;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';

procedure TfrmEditUnivers.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;
end;

procedure TfrmEditUnivers.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then
  begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FUnivers.NomUnivers := Trim(edNom.Text);
  FUnivers.SiteWeb := Trim(edSite.Text);
  FUnivers.ID_UniversParent := vtEditUnivers.CurrentValue;

  FUnivers.Associations.Text := edAssociations.Lines.Text;

  FUnivers.SaveToDatabase;
  FUnivers.SaveAssociations(vmUnivers, GUID_NULL);

  ModalResult := mrOk;
end;

procedure TfrmEditUnivers.SetUnivers(Value: TUniversComplet);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FUnivers := Value;
  FUnivers.FillAssociations(vmUnivers);

  edNom.Text := FUnivers.NomUnivers;
  edDescription.Text := FUnivers.Description.Text;
  edSite.Text := FUnivers.SiteWeb;

  vtAlbums.Filtre := 'branche_univers containing ' + QuotedStr('|' + GUIDToString(ID_Univers) + '|');
  vtAlbums.Mode := vmAlbumsSerie;
  vtAlbums.FullExpand;

  vtParaBD.Filtre := 'branche_univers containing ' + QuotedStr('|' + GUIDToString(ID_Univers) + '|');
  vtParaBD.Mode := vmParaBDSerie;
  vtParaBD.FullExpand;

  vtEditUnivers.Mode := vmUnivers;
  vtEditUnivers.VTEdit.PopupWindow.TreeView.UseFiltre := True;
  vtEditUnivers.VTEdit.PopupWindow.TreeView.Filtre := 'branche_univers not containing ' + QuotedStr('|' + GUIDToString(ID_Univers) + '|');
  vtEditUnivers.CurrentValue := FUnivers.ID_UniversParent;

  // pour le moment
  // TODO: voir pour pouvoir appeler plusieurs fenêtres d'édition de même classe
  vtEditUnivers.CanCreate := False;
  vtEditUnivers.CanEdit := False;

  edAssociations.Text := FUnivers.Associations.Text;
end;

procedure TfrmEditUnivers.FormShow(Sender: TObject);
begin
  edNom.SetFocus;
end;

procedure TfrmEditUnivers.edNomChange(Sender: TObject);
begin
  Caption := 'Saisie d''univers - ' + FormatTitre(edNom.Text);
end;

procedure TfrmEditUnivers.vtAlbumsDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierAlbums, vtAlbums);
end;

procedure TfrmEditUnivers.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TfrmEditUnivers.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := CompareMem(PChar(LowerCase(Trim(edSite.Text))), PChar('http://'), 7);
end;

function TfrmEditUnivers.GetID_Univers: TGUID;
begin
  Result := FUnivers.ID_Univers;
end;

procedure TfrmEditUnivers.vtParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierParaBD, vtParaBD);
end;

end.

