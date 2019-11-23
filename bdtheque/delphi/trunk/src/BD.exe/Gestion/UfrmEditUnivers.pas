﻿unit UfrmEditUnivers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.Buttons, VDTButton, Vcl.ComCtrls,
  EditLabeled, VirtualTrees, BDTK.GUI.Controls.VirtualTree, BD.Entities.Full, Vcl.Menus, Vcl.ExtDlgs, BDTK.GUI.Frames.QuickSearch, BD.GUI.Frames.Buttons, BD.GUI.Forms,
  ComboCheck, System.StrUtils, PngSpeedButton, UframVTEdit;

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
    FUnivers: TUniversFull;
    procedure SetUnivers(Value: TUniversFull);
    function GetID_Univers: TGUID;
  public
    { Déclarations publiques }
    property ID_Univers: TGUID read GetID_Univers;
    property Univers: TUniversFull read FUnivers write SetUnivers;
  end;

implementation

uses
  BD.Utils.StrUtils, Proc_Gestions, BD.Entities.Lite, BD.Utils.GUIUtils, Divers, BD.Strings, System.StdConvs, Winapi.ShellAPI, BD.Common, Vcl.Imaging.jpeg,
  UHistorique, BD.Entities.Metadata, BDTK.Entities.Dao.Full, BDTK.Entities.Dao.Lite, BD.Entities.Common;

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
  TDaoUniversLite.Fill(FUnivers.UniversParent, vtEditUnivers.CurrentValue);

  FUnivers.Associations.Text := edAssociations.Lines.Text;

  TDaoUniversFull.SaveToDatabase(FUnivers, nil);
  TDaoUniversFull.SaveAssociations(FUnivers, vmUnivers, GUID_NULL);

  ModalResult := mrOk;
end;

procedure TfrmEditUnivers.SetUnivers(Value: TUniversFull);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FUnivers := Value;
  TDaoUniversFull.FillAssociations(FUnivers, vmUnivers);

  edNom.Text := FUnivers.NomUnivers;
  edDescription.Text := FUnivers.Description;
  edSite.Text := FUnivers.SiteWeb;

  vtAlbums.Filtre := 'branche_univers containing ' + QuotedStr('|' + GUIDToString(ID_Univers) + '|');
  vtAlbums.Mode := vmAlbumsSerie;
  vtAlbums.FullExpand;

  vtParaBD.Filtre := 'branche_univers containing ' + QuotedStr('|' + GUIDToString(ID_Univers) + '|');
  vtParaBD.Mode := vmParaBDSerie;
  vtParaBD.FullExpand;

  vtEditUnivers.Mode := vmUnivers;
  vtEditUnivers.ParentValue := ID_Univers;
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

