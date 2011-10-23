unit UfrmSaisieEmpruntEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, ComCtrls, ExtCtrls,
  ToolWin, Buttons, UframBoutons, ScanEdit, VDTButton, Menus, Commun, EditLabeled, VirtualTrees, VirtualTree,
  ComboCheck, UframRechercheRapide, LoadComplet, CRFurtif, UBdtForms;

type
  TfrmSaisieEmpruntEmprunteur = class(TbdtForm)
    Panel4: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    ListView1: TVDTListView;
    Panel5: TPanel;
    Frame11: TframBoutons;
    Panel9: TPanel;
    VDTButton2: TCRFurtifLight;
    VDTButton3: TCRFurtifLight;
    Panel1: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    pret: TCheckBoxLabeled;
    date_pret: TDateTimePickerLabeled;
    lccEditions: TLightComboCheck;
    Panel6: TPanel;
    vtAlbums: TVirtualStringTree;
    FrameRechercheRapide1: TFramRechercheRapide;
    procedure FormCreate(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pretClick(Sender: TObject);
    procedure date_pretChange(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOkExecute(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure lccEditionsChange(Sender: TObject);
  private
    { Déclarations privées }
    FID_Emprunteur: TGUID;
    FEditions: TEditionsCompletes;
    procedure SetID_Emprunteur(const Value: TGUID);
  public
    { Déclarations publiques }
    property ID_Emprunteur: TGUID read FID_Emprunteur write SetID_Emprunteur;
    procedure AjouteAlbum(const ID_Album, ID_Edition: TGUID);
  end;

implementation

uses TypeRec, CommonConst, Procedures, ProceduresBDtk;

{$R *.DFM}

const
  v: array[False..True] of string = ('Retour', 'Prêt');
  GUID_EditionPasSelectionnee: TGUID = '{888B7D84-401B-4DC2-803A-D38B63ED4BD3}';

const
  TitreListeEmprunts = 'Liste des emprunts';
  NoEmprunts = 'Pas d''emprunts.';
  NotThisEntryHere = 'Impossible d''ajouter ce mouvement dans cette fenêtre';

procedure TfrmSaisieEmpruntEmprunteur.SetID_Emprunteur(const Value: TGUID);
begin
  if IsEqualGUID(Value, FID_Emprunteur) then Exit;
  FID_Emprunteur := Value;
  with TEmprunteur.Create do try
    Fill(Value);
    Label2.Caption := ChaineAffichage;
  finally
    Free;
  end;
end;

procedure TfrmSaisieEmpruntEmprunteur.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapide1.VirtualTreeView := vtAlbums;
  FrameRechercheRapide1.ShowNewButton := False;
  vtAlbums.Mode := vmAlbumsSerie;
  ChargeImage(vtAlbums.Background, 'FONDVT');
  FEditions := TEditionsCompletes.Create;
  date_pret.Date := Date;
end;

procedure TfrmSaisieEmpruntEmprunteur.ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i, ValueSelected: Integer;
  PEd: TEditionComplete;
  PA: TAlbum;
  ID_Edition: TGUID;
begin
  date_pret.Enabled := Selected;
  pret.Enabled := Selected;
  lccEditions.Enabled := Selected;

  if Selected then begin
    ID_Edition := StringToGUID(Item.SubItems[2]);
    ValueSelected := -1;

    PA := Item.Data;
    date_pret.Date := StrToDateTime(Item.SubItems[0]);
    pret.Checked := Item.SubItems[1] = v[True];
    lccEditions.Items.Clear;
    FEditions.Fill(PA.ID);
    for i := 0 to Pred(FEditions.Editions.Count) do begin
      PEd := FEditions.Editions[i];
      with lccEditions.Items.Add do begin
        Caption := PEd.ChaineAffichage;
        Valeur := i;
      end;
      if IsEqualGUID(PEd.ID_Edition, ID_Edition) then ValueSelected := ValueSelected;
    end;

    lccEditions.DefaultValueChecked := 0;
    if not lccEditions.ValidValue(ValueSelected) then ValueSelected := lccEditions.DefaultValueChecked;
    lccEditions.Value := ValueSelected;
    lccEditionsChange(nil);
  end;
end;

procedure TfrmSaisieEmpruntEmprunteur.pretClick(Sender: TObject);
begin
  ListView1.Selected.SubItems[1] := v[pret.Checked];
end;

procedure TfrmSaisieEmpruntEmprunteur.date_pretChange(Sender: TObject);
begin
  ListView1.Selected.SubItems[0] := FormatDateTime(FormatSettings.ShortDateFormat, date_pret.Date);
end;

procedure TfrmSaisieEmpruntEmprunteur.ToolButton1Click(Sender: TObject);
begin
  MoveListItem(ListView1, -1);
end;

procedure TfrmSaisieEmpruntEmprunteur.ToolButton4Click(Sender: TObject);
begin
  MoveListItem(ListView1, 1);
end;

procedure TfrmSaisieEmpruntEmprunteur.AjouteAlbum(const ID_Album, ID_Edition: TGUID);
var
  PA: TAlbum;
  Item: TListItem;
begin
  try
    if IsEqualGUID(ID_Album, GUID_NULL) or IsEqualGUID(ID_Edition, GUID_NULL) then Exit;
    Item := ListView1.Items.Add;
    with Item do begin
      PA := TAlbum.Create;
      if IsEqualGUID(ID_Edition, GUID_EditionPasSelectionnee) then
        PA.Fill(ID_Album)
      else
        PA.Fill(ID_Album, ID_Edition);
      Data := PA;
      Caption := PA.ChaineAffichage(True);
      SubItems.Add(FormatDateTime(FormatSettings.ShortDateFormat, Date));
      SubItems.Add(v[PA.Stock]);
      SubItems.Add(GUIDToString(ID_Edition));
    end;
    ListView1.Selected := Item;
  except
    AffMessage(Exception(ExceptObject).Message, mtError, [mbOk], True);
  end;
  Frame11.btnOK.Enabled := LongBool(ListView1.Items.Count);
end;

procedure TfrmSaisieEmpruntEmprunteur.ListView1DblClick(Sender: TObject);
var
  PA: TAlbum;
begin
  if Assigned(ListView1.Selected) then begin
    PA := ListView1.Selected.Data;
    PA.Free;
    ListView1.Selected.Delete;
  end;
  Frame11.btnOK.Enabled := LongBool(ListView1.Items.Count);
end;

procedure TfrmSaisieEmpruntEmprunteur.FormDestroy(Sender: TObject);
begin
  TAlbum.VideListe(ListView1);
  FEditions.Free;
end;

procedure TfrmSaisieEmpruntEmprunteur.BtnOkExecute(Sender: TObject);
var
  i: Integer;
  Edition: TEditionComplete;
begin
  for i := 0 to ListView1.Items.Count - 1 do
    if ListView1.Items[i].SubItems[2] = GUIDToString(GUID_EditionPasSelectionnee) then begin
      ShowMessage('Vous n''avez pas sélectionné l''édition empruntée pour '#13#10 + ListView1.Items[i].Caption);
      ModalResult := mrNone;
      Exit;
    end
    else if TGlobalVar.Utilisateur.Options.AvertirPret and (ListView1.Items[i].SubItems[1] = v[True]) then begin
      Edition := TEditionComplete.Create(StringToGUID(ListView1.Items[i].SubItems[2]));
      try
        if (Edition.Prete) and (MessageDlg(ListView1.Items[i].Caption + #13#13'Cette édition est déjà prêtée.'#13#10'Continuer?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then begin
          ModalResult := mrNone;
          Exit;
        end;
      finally
        Edition.Free;
      end;
    end;

  for i := 0 to ListView1.Items.Count - 1 do
    AjoutMvt(ID_Emprunteur, StringToGUID(ListView1.Items[i].SubItems[2]), StrToDate(ListView1.Items[i].SubItems[0]), ListView1.Items[i].SubItems[1] = v[True]);
end;

procedure TfrmSaisieEmpruntEmprunteur.vtAlbumsDblClick(Sender: TObject);
begin
  AjouteAlbum(vtAlbums.CurrentValue, GUID_EditionPasSelectionnee);
end;

procedure TfrmSaisieEmpruntEmprunteur.lccEditionsChange(Sender: TObject);
begin
  if Assigned(ListView1.Selected) then begin
    ListView1.Selected.SubItems[2] := GUIDToString(TEditionComplete(FEditions.Editions[lccEditions.Value]).ID_Edition);
  end;
end;

end.

