unit UfrmConsultationUnivers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, System.StrUtils, System.UITypes,
  Vcl.Dialogs, BD.Entities.Full, Vcl.StdCtrls, VirtualTrees, Vcl.ExtCtrls, BDTK.GUI.Forms.Main, BD.Utils.GUIUtils,
  Vcl.ComCtrls, VDTButton, Vcl.Buttons, Vcl.ActnList, Vcl.Menus, BDTK.GUI.Utils, BD.GUI.Forms, BDTK.GUI.Controls.VirtualTree,
  LabeledCheckBox, System.Actions;

type
  TfrmConsultationUnivers = class(TBdtForm, IImpressionApercu, IFicheEditable)
    ScrollBox2: TScrollBox;
    l_sujet: TLabel;
    NomUnivers: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    edDescription: TMemo;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    ImageApercu: TAction;
    ImageImprime: TAction;
    FicheApercu: TAction;
    FicheImprime: TAction;
    Fiche1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    FicheModifier: TAction;
    Modifier1: TMenuItem;
    N1: TMenuItem;
    Label1: TLabel;
    UniversParent: TLabel;
    Label3: TLabel;
    vtAlbums: TVirtualStringTree;
    Label4: TLabel;
    vtParaBD: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NomUniversClick(Sender: TObject);
    procedure FicheApercuExecute(Sender: TObject);
    procedure FicheModifierExecute(Sender: TObject);
    procedure UniversParentDblClick(Sender: TObject);
    procedure vtAlbumsAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure vtParaBDDblClick(Sender: TObject);
  private
    FUnivers: TUniversFull;
    function GetID_Univers: TGUID;
    procedure SetID_Univers(const Value: TGUID);
    procedure ClearForm;
    procedure ImpRep(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ApercuUpdate: Boolean;
    procedure ImpressionExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property Univers: TUniversFull read FUnivers;
    property ID_Univers: TGUID read GetID_Univers write SetID_Univers;
  end;

implementation

uses
  BD.Utils.StrUtils, BD.Entities.Lite, UHistorique, Divers, Winapi.ShellAPI, BD.Strings, BD.Common, Vcl.Imaging.jpeg, Impression,
  Proc_Gestions, BDTK.Entities.Dao.Full, BD.Entities.Common, BD.Entities.Factory.Full;

{$R *.dfm}
{ TfrmConsultationUnivers }

function TfrmConsultationUnivers.GetID_Univers: TGUID;
begin
  Result := FUnivers.ID_Univers;
end;

procedure TfrmConsultationUnivers.SetID_Univers(const Value: TGUID);
begin
  ClearForm;
  TDaoUniversFull.Fill(FUnivers, Value, nil);

  Caption := 'Fiche d''univers - ' + FUnivers.ChaineAffichage;
  NomUnivers.Caption := FormatTitre(FUnivers.NomUnivers);
  if FUnivers.SiteWeb <> '' then
  begin
    NomUnivers.Font.Color := clBlue;
    NomUnivers.Font.Style := NomUnivers.Font.Style + [fsUnderline];
    NomUnivers.Cursor := crHandPoint;
  end
  else
  begin
    NomUnivers.Font.Color := clWindowText;
    NomUnivers.Font.Style := NomUnivers.Font.Style - [fsUnderline];
    NomUnivers.Cursor := crDefault;
  end;
  UniversParent.Caption := FormatTitre(FUnivers.UniversParent.NomUnivers);
  edDescription.Text := FUnivers.Description;

  vtAlbums.Filtre := 'branche_univers containing ' + QuotedStr(GUIDToString(ID_Univers));
  vtAlbums.Mode := vmAlbumsSerieUnivers;
  vtAlbums.FullExpand;

  vtParaBD.Filtre := 'branche_univers containing ' + QuotedStr(GUIDToString(ID_Univers));
  vtParaBD.Mode := vmParaBDSerieUnivers;
  vtParaBD.FullExpand;
end;

procedure TfrmConsultationUnivers.UniversParentDblClick(Sender: TObject);
begin
  if not IsEqualGUID(FUnivers.UniversParent.ID, GUID_NULL) then
    Historique.AddWaiting(fcUnivers, FUnivers.UniversParent.ID, 0);
end;

procedure TfrmConsultationUnivers.vtAlbumsAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
begin
  if vtAlbums.GetNodeLevel(Node) > 0 then
    frmFond.DessineNote(TargetCanvas, ItemRect, TAlbumLite(vtAlbums.GetNodeBasePointer(Node)).Notation);
end;

procedure TfrmConsultationUnivers.vtAlbumsDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcAlbum, vtAlbums.CurrentValue);
end;

procedure TfrmConsultationUnivers.vtParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcParaBD, vtParaBD.CurrentValue);
end;

procedure TfrmConsultationUnivers.ClearForm;
begin
  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;
end;

procedure TfrmConsultationUnivers.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FUnivers := TFactoryUniversFull.getInstance;
end;

procedure TfrmConsultationUnivers.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FUnivers.Free;
end;

procedure TfrmConsultationUnivers.NomUniversClick(Sender: TObject);
var
  s: string;
begin
  if not IsDownKey(VK_CONTROL) then
  begin
    s := FUnivers.SiteWeb;
    if s <> '' then
      ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
  end;
end;

procedure TfrmConsultationUnivers.FicheApercuExecute(Sender: TObject);
begin
  ImpRep(Sender);
end;

procedure TfrmConsultationUnivers.FicheModifierExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, RefreshCallBack, nil, @ModifierUnivers2, nil, FUnivers.ID);
end;

procedure TfrmConsultationUnivers.ImpRep(Sender: TObject);
begin
  ImpressionFicheUnivers(ID_Univers, TComponent(Sender).Tag = 1)
end;

procedure TfrmConsultationUnivers.ApercuExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationUnivers.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationUnivers.ImpressionExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationUnivers.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationUnivers.ModificationExecute(Sender: TObject);
begin
  FicheModifierExecute(Sender);
end;

function TfrmConsultationUnivers.ModificationUpdate: Boolean;
begin
  Result := True;
end;

end.
