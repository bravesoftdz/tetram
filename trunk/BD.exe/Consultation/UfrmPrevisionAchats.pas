unit UfrmPrevisionAchats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, VirtualTrees, VirtualTree, Buttons, VDTButton, ProceduresBDtk,
  ExtCtrls, Procedures, ComboCheck, StdCtrls, UBdtForms;

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
    procedure FormCreate(Sender: TObject);
    procedure ListeApercuExecute(Sender: TObject);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure vstPrevisionsAchatsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
    procedure ChangeAlbumMode(Mode: TVirtualMode);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  end;

implementation

uses Impression, IniFiles, CommonConst, TypeRec, DateUtils;

{$R *.dfm}

procedure TfrmPrevisionsAchats.FormCreate(Sender: TObject);
begin
  ChargeImage(vstPrevisionsAchats.Background, 'FONDVT');
  vstPrevisionsAchats.ShowAchat := False; // on affiche que ça
  vstPrevisionsAchats.ShowDateParutionAlbum := True;
  vstPrevisionsAchats.Filtre := 'ACHAT = 1';
  vstPrevisionsAchats.UseFiltre := True;

  vstPrevisionsAchats.Mode := vmNone;
  with TIniFile.Create(FichierIni) do try
    LightComboCheck1.OnChange := nil;
    LightComboCheck1.Value := -1;
    LightComboCheck1.OnChange := LightComboCheck1Change;
    LightComboCheck1.Value := ReadInteger('Options', 'AchatsGroupBy', 1);
  finally
    Free;
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
begin
  ChangeAlbumMode(NewMode[LightComboCheck1.Value]);
  with TIniFile.Create(FichierIni) do try
    WriteInteger('Options', 'AchatsGroupBy', LightComboCheck1.Value);
  finally
    Free;
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
  Album: TAlbum;
begin
  Album := TAlbum(vstPrevisionsAchats.GetNodeBasePointer(Node));
  if Assigned(Album) then
    if (Album.AnneeParution > 0) and (Album.AnneeParution = YearOf(Now)) then
      if (Album.MoisParution > 0) and (Album.MoisParution <= MonthOf(Now)) then
        TargetCanvas.Font.Color := clRed
      else
        TargetCanvas.Font.Color := clFuchsia;
end;

end.

