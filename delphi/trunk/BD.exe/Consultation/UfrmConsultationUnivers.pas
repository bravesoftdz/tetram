unit UfrmConsultationUnivers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StrUtils,
  Dialogs, LoadComplet, StdCtrls, VirtualTrees, ExtCtrls, UfrmFond, Procedures,
  ComCtrls, VDTButton, Buttons, ActnList, Menus, ProceduresBDtk, UBdtForms,
  LabeledCheckBox, System.Actions;

type
  TfrmConsultationUnivers = class(TBdtForm, IImpressionApercu, IFicheEditable)
    ScrollBox2: TScrollBox;
    l_sujet: TLabel;
    NomUnivers: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Description: TMemo;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NomUniversClick(Sender: TObject);
    procedure FicheApercuExecute(Sender: TObject);
    procedure FicheModifierExecute(Sender: TObject);
    procedure UniversParentDblClick(Sender: TObject);
  private
    FUnivers: TUniversComplet;
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
    property Univers: TUniversComplet read FUnivers;
    property ID_Univers: TGUID read GetID_Univers write SetID_Univers;
  end;

implementation

uses Commun, TypeRec, UHistorique, Divers, ShellAPI, Textes, CommonConst, jpeg, Impression,
  Proc_Gestions;

{$R *.dfm}

{ TfrmConsultationUnivers }

function TfrmConsultationUnivers.GetID_Univers: TGUID;
begin
  Result := FUnivers.ID_Univers;
end;

procedure TfrmConsultationUnivers.SetID_Univers(const Value: TGUID);
begin
  ClearForm;
  FUnivers.Fill(Value);

  Caption := 'Fiche d''univers - ' + FUnivers.ChaineAffichage;
  NomUnivers.Caption := FormatTitre(FUnivers.NomUnivers);
  if FUnivers.SiteWeb <> '' then begin
    NomUnivers.Font.Color := clBlue;
    NomUnivers.Font.Style := NomUnivers.Font.Style + [fsUnderline];
    NomUnivers.Cursor := crHandPoint;
  end
  else begin
    NomUnivers.Font.Color := clWindowText;
    NomUnivers.Font.Style := NomUnivers.Font.Style - [fsUnderline];
    NomUnivers.Cursor := crDefault;
  end;
  UniversParent.Caption := FormatTitre(FUnivers.UniversParent.NomUnivers);
  Description.Text := FUnivers.Description.Text;
end;

procedure TfrmConsultationUnivers.UniversParentDblClick(Sender: TObject);
begin
  if not IsEqualGUID(FUnivers.UniversParent.ID, GUID_NULL) then
    Historique.AddWaiting(fcUnivers, FUnivers.UniversParent.ID, 0);
end;

procedure TfrmConsultationUnivers.ClearForm;
begin

end;

procedure TfrmConsultationUnivers.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FUnivers := TUniversComplet.Create;
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
  if not IsDownKey(VK_CONTROL) then begin
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
  Historique.AddWaiting(fcGestionModif, @RefreshCallBack, nil, @ModifierUnivers2, nil, FUnivers.ID);
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

