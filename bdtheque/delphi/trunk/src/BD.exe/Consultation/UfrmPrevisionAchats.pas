unit UfrmPrevisionAchats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, VirtualTrees, BDTK.GUI.Controls.VirtualTree, Buttons, VDTButton, BDTK.GUI.Utils,
  ExtCtrls, BD.Utils.GUIUtils, ComboCheck, StdCtrls, BD.GUI.Forms, PngSpeedButton,
  System.Actions;

type
  TfrmPrevisionsAchats = class(TBdtForm, IImpressionApercu)
    vstPrevisionsAchats: TVirtualStringTree;
    ActionList1: TActionList;
    ListeApercu: TAction;
    ListeImprime: TAction;
    MainMenu1: TMainMenu;
    Liste1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    LightComboCheck1: TLightComboCheck;
    supprimer: TVDTButton;
    modifier: TVDTButton;
    ajouter: TVDTButton;
    actAjouter: TAction;
    actModifier: TAction;
    actSupprimer: TAction;
    Bevel7: TBevel;
    btAcheter: TVDTButton;
    actAcheter: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ListeApercuExecute(Sender: TObject);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure vstPrevisionsAchatsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure actSupprimerExecute(Sender: TObject);
    procedure actAjouterExecute(Sender: TObject);
    procedure actModifierExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actAcheterExecute(Sender: TObject);
  private
    procedure ChangeAlbumMode(Mode: TVirtualMode);
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  end;

implementation

uses Impression, IniFiles, BD.Common, BD.Entities.Lite, DateUtils, UHistorique,
  Proc_Gestions, BD.Utils.StrUtils;

{$R *.dfm}

procedure TfrmPrevisionsAchats.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ChargeImage(vstPrevisionsAchats.Background, 'FONDVT');
  vstPrevisionsAchats.ShowAchat := False; // on affiche que �a
  vstPrevisionsAchats.ShowDateParutionAlbum := True;
  vstPrevisionsAchats.Filtre := 'ACHAT = 1';
  vstPrevisionsAchats.UseFiltre := True;

  vstPrevisionsAchats.Mode := vmNone;
  LightComboCheck1.OnChange := nil;
  LightComboCheck1.Value := -1;
  LightComboCheck1.OnChange := LightComboCheck1Change;
  ini := TIniFile.Create(FichierIni);
  try
    LightComboCheck1.Value := ini.ReadInteger('Options', 'AchatsGroupBy', 1);
  finally
    ini.Free;
  end;
end;

procedure TfrmPrevisionsAchats.ChangeAlbumMode(Mode: TVirtualMode);
var
  i: TGUID;
const
  FirstTime: Boolean = True;
begin
  if (vstPrevisionsAchats.Mode <> Mode) or FirstTime then begin
    i := vstPrevisionsAchats.CurrentValue;
    vstPrevisionsAchats.Mode := Mode;
    vstPrevisionsAchats.CurrentValue := i;
  end;
  FirstTime := False;
end;

procedure TfrmPrevisionsAchats.LightComboCheck1Change(Sender: TObject);
const
  NewMode: array[0..5] of TVirtualMode = (vmAlbums, vmAlbumsSerie, vmAchatsAlbumsEditeur, vmAlbumsGenre, vmAlbumsAnnee, vmAlbumsCollection);
var
  ini: TIniFile;
begin
  ChangeAlbumMode(NewMode[LightComboCheck1.Value]);
  ini := TIniFile.Create(FichierIni);
  try
    ini.WriteInteger('Options', 'AchatsGroupBy', LightComboCheck1.Value);
  finally
    ini.Free;
  end
end;

procedure TfrmPrevisionsAchats.ApercuExecute(Sender: TObject);
begin
  ListeApercu.Execute;
end;

function TfrmPrevisionsAchats.ApercuUpdate: Boolean;
begin
  Result := ListeApercu.Enabled;
end;

procedure TfrmPrevisionsAchats.ImpressionExecute(Sender: TObject);
begin
  ListeImprime.Execute;
end;

function TfrmPrevisionsAchats.ImpressionUpdate: Boolean;
begin
  Result := ListeImprime.Enabled;
end;

procedure TfrmPrevisionsAchats.ListeApercuExecute(Sender: TObject);
begin
  ImpressionListePrevisionsAchats(TComponent(Sender).Tag = 1);
end;

procedure TfrmPrevisionsAchats.vstPrevisionsAchatsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Album: TAlbumLite;
begin
  Album := TAlbumLite(vstPrevisionsAchats.GetNodeBasePointer(Node));
  if Assigned(Album) then
    if (Album.AnneeParution > 0) and (Album.AnneeParution = YearOf(Now)) then
      if (Album.MoisParution > 0) and (Album.MoisParution <= MonthOf(Now)) then
        TargetCanvas.Font.Color := clRed
      else
        TargetCanvas.Font.Color := clFuchsia;
end;

procedure TfrmPrevisionsAchats.actAcheterExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionAchat, nil, nil, @AcheterAlbums, vstPrevisionsAchats);
end;

procedure TfrmPrevisionsAchats.actAjouterExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterAchatsAlbum, vstPrevisionsAchats, '');
end;

procedure TfrmPrevisionsAchats.ActionList1Update(Action: TBasicAction;  var Handled: Boolean);
begin
  actModifier.Enabled := not IsEqualGUID(vstPrevisionsAchats.CurrentValue, GUID_NULL);
  actSupprimer.Enabled := actModifier.Enabled;
  actAcheter.Enabled := actModifier.Enabled;
end;

procedure TfrmPrevisionsAchats.actModifierExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierAchatsAlbum, vstPrevisionsAchats);
end;

procedure TfrmPrevisionsAchats.actSupprimerExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionSupp, nil, nil, @SupprimerAchatsAlbum, vstPrevisionsAchats);
end;

end.

