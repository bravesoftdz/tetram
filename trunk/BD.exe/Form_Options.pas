unit Form_options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniFiles, CommCtrl, ImgList,
  Buttons, VDTButton, Fram_Boutons, Browss, DBEditLabeled, ComboCheck, Spin;

type
  TFrmOptions = class(TForm)
    PageControl1: TPageControl;
    options: TTabSheet;
    ImageList1: TImageList;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    Panel4: TPanel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Panel6: TPanel;
    Label10: TLabel;
    SpeedButton1: TVDTButton;
    SpeedButton2: TVDTButton;
    SpeedButton3: TVDTButton;
    Frame11: TFrame1;
    Frame12: TFrame1;
    BtDef: TButton;
    BrowseDirectoryDlg1: TBrowseDirectoryDlg;
    Label9: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEditLabeled;
    ListView1: TVDTListView;
    PanelImpression: TPanel;
    Label11: TLabel;
    FicheAlbumCouverture: TCheckBox;
    PanelWebServer: TPanel;
    Label13: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    SpinEditLabeled1: TSpinEditLabeled;
    CheckBox4: TCheckBox;
    PanelGestion: TPanel;
    Label2: TLabel;
    CheckBox2: TCheckBox;
    PanelGeneral: TPanel;
    Label1: TLabel;
    OpenStart: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox5: TCheckBox;
    Label14: TLabel;
    VDTButton1: TVDTButton;
    CheckBox6: TCheckBox;
    GrandesIconesMenu: TCheckBox;
    GrandesIconesBarre: TCheckBox;
    LightComboCheck1: TLightComboCheck;
    FicheParaBDCouverture: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure calculKeyPress(Sender: TObject; var Key: Char);
    procedure calculExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure BtDefClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
  private
    ImageChargee: Boolean;
    SItem: TListItem;
  public
  end;

implementation

uses CommonConst, DM_Princ, TypeRec, JvUIB, Commun, Procedures;

{$R *.DFM}

procedure TFrmOptions.btnOKClick(Sender: TObject);
var
  PC: TConversion;
  i: Integer;
begin
  if RepImages <> VDTButton1.Caption then
    if MessageDlg('Vous avez choisi de modifier le répertoire de stockage des images.'#13'N''oubliez pas de déplacer les fichiers de l''ancien répertoire vers le nouveau.', mtWarning, mbOKCancel, 0) = mrCancel then begin
      ModalResult := mrNone;
      Exit;
    end;

  with Utilisateur.Options do begin
    SymboleMonnetaire := ComboBox1.Text;
    ModeDemarrage := not OpenStart.Checked;
    FicheAlbumWithCouverture := FicheAlbumCouverture.Checked;
    FicheParaBDWithImage := FicheParaBDCouverture.Checked;
    Images := CheckBox3.Checked;
    RepImages := VDTButton1.Caption;
    AntiAliasing := CheckBox5.Checked;
    ImagesStockees := CheckBox2.Checked;
    WebServerAutoStart := CheckBox1.Checked;
    WebServerPort := SpinEditLabeled1.Value;
    WebServerAntiAliasing := CheckBox4.Checked;
    AntiAliasing := CheckBox5.Checked;
    AvertirPret := CheckBox6.Checked;
    GrandesIconesMenus := GrandesIconesMenu.Checked;
    GrandesIconesBarre := Self.GrandesIconesBarre.Checked;
    VerifMAJDelai := LightComboCheck1.Value;
    SerieObligatoireAlbums := CheckBox7.Checked;
    SerieObligatoireParaBD := CheckBox8.Checked;
  end;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'DELETE FROM CONVERSIONS';
    ExecSQL;
    SQL.Text := 'INSERT INTO CONVERSIONS (Monnaie1, Monnaie2, Taux) VALUES (?, ?, ?)';
    for i := 0 to ListView1.Items.Count - 1 do begin
      PC := ListView1.Items[i].Data;
      Params.AsString[0] := PC.Monnaie1;
      Params.AsString[1] := PC.Monnaie2;
      Params.AsDouble[2] := PC.Taux;
      ExecSQL;
    end;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  EcritOptions;
  LitOptions;
end;

procedure TFrmOptions.calculKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', ',', '.', DecimalSeparator]) then Key := #0;
  if Key in ['.', ','] then Key := DecimalSeparator;
end;

procedure TFrmOptions.calculExit(Sender: TObject);
begin
  try
    TEdit(Sender).Text := FormatCurr(FormatMonnaieCourt, StrToCurr(TEdit(Sender).Text));
  except
    TEdit(Sender).Text := Format('0%s00', [DecimalSeparator]);
  end;
end;

procedure TFrmOptions.FormCreate(Sender: TObject);
var
  q: TJvUIBQuery;
begin
  PrepareLV(Self);
  LitOptions;

  PageControl1.ActivePage := PageControl1.Pages[0];
  ImageChargee := False;
  SItem := nil;

  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Add('SELECT Monnaie1 AS Monnaie FROM conversions');
    SQL.Add('UNION');
    SQL.Add('SELECT Monnaie2 AS Monnaie FROM conversions');
    Open;
    while not EOF do begin
      ComboBox1.Items.Add(Fields.ByNameAsString['Monnaie']);
      ComboBox2.Items.Add(Fields.ByNameAsString['Monnaie']);
      ComboBox3.Items.Add(Fields.ByNameAsString['Monnaie']);
      Next;
    end;
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT Monnaie1, Monnaie2, Taux FROM conversions';
    Open;
    while not EOF do begin
      with ListView1.Items.Add do begin
        Data := TConversion.Make(Q);
        Caption := TConversion(Data).ChaineAffichage;
        SubItems.Add('0');
      end;
      Next;
    end;
  finally
    Transaction.Free;
    Free;
  end;
  with ComboBox1.Items, Utilisateur.Options do begin
    if IndexOf(SymboleMonnetaire) = -1 then Add(SymboleMonnetaire);
    if IndexOf(CurrencyString) = -1 then Add(CurrencyString);
  end;

  with Utilisateur.Options do begin
    ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(SymboleMonnetaire);
    OpenStart.Checked := not ModeDemarrage;
    FicheAlbumCouverture.Checked := FicheAlbumWithCouverture;
    FicheParaBDCouverture.Checked := FicheParaBDWithImage;
    CheckBox3.Checked := Images;
    VDTButton1.Caption := RepImages;
    CheckBox5.Checked := AntiAliasing;
    CheckBox2.Checked := ImagesStockees;
    CheckBox1.Checked := WebServerAutoStart;
    SpinEditLabeled1.Value := WebServerPort;
    CheckBox4.Checked := WebServerAntiAliasing;
    CheckBox5.Checked := AntiAliasing;
    CheckBox6.Checked := AvertirPret;
    GrandesIconesMenu.Checked := GrandesIconesMenus;
    Self.GrandesIconesBarre.Checked := GrandesIconesBarre;
    LightComboCheck1.Value := VerifMAJDelai;
    CheckBox7.Checked := SerieObligatoireAlbums;
    CheckBox8.Checked := SerieObligatoireParaBD;
  end;
end;

procedure TFrmOptions.Button2Click(Sender: TObject);
var
  PC: TConversion;
  i: TListItem;
begin
  if Assigned(SItem) then begin
    PC := SItem.Data;
    i := SItem;
    if i.SubItems[0] <> '1' then i.SubItems[0] := '2';
    SItem := nil;
  end
  else begin
    PC := TConversion.Create;
    i := ListView1.Items.Add;
    i.SubItems.Add('1');
    i.Data := PC;
  end;
  PC.Monnaie1 := ComboBox2.Text;
  PC.Monnaie2 := ComboBox3.Text;
  PC.Taux := StrToFloat(Edit1.Text);
  i.Caption := PC.ChaineAffichage;

  Panel4.Visible := False;
  SpeedButton1.Enabled := True;
  SpeedButton2.Enabled := True;
  SpeedButton3.Enabled := True;
end;

procedure TFrmOptions.Button3Click(Sender: TObject);
begin
  SItem := nil;
  Panel4.Visible := False;
  SpeedButton1.Enabled := True;
  SpeedButton2.Enabled := True;
  SpeedButton3.Enabled := True;
end;

procedure TFrmOptions.SpeedButton1Click(Sender: TObject);
begin
  ComboBox2.Text := '';
  ComboBox3.Text := '';
  Edit1.Text := Format('0%s00', [DecimalSeparator]); ;
  Panel4.Visible := True;
  SpeedButton2.Enabled := False;
  SpeedButton3.Enabled := False;
end;

procedure TFrmOptions.ComboBox2Change(Sender: TObject);
begin
  if Sender is TComboBox then
    if Length(TComboBox(Sender).Text) > 5 then TComboBox(Sender).Text := Copy(TComboBox(Sender).Text, 1, 5);
  Label10.Caption := Format('1 %s = %s %s', [ComboBox2.Text, Edit1.Text, ComboBox3.Text]);
  Frame12.btnOK.Enabled := (ComboBox2.Text <> '') and (Edit1.Text <> '') and (ComboBox3.Text <> '');
end;

procedure TFrmOptions.SpeedButton3Click(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) or Panel4.Visible then Exit;
  SItem := ListView1.Selected;
  ComboBox2.Text := TConversion(SItem.Data).Monnaie1;
  ComboBox3.Text := TConversion(SItem.Data).Monnaie2;
  Edit1.Text := Format('%g', [TConversion(SItem.Data).Taux]);
  Panel4.Visible := True;
  SpeedButton2.Enabled := False;
  SpeedButton1.Enabled := False;
end;

procedure TFrmOptions.FormDestroy(Sender: TObject);
begin
  TConversion.VideListe(ListView1);
end;

procedure TFrmOptions.SpeedButton2Click(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) or Panel4.Visible then Exit;
  TConversion(ListView1.Selected.Data).Free;
  ListView1.Selected.Delete;
end;

procedure TFrmOptions.Edit1Exit(Sender: TObject);
begin
  try
    TEdit(Sender).Text := FloatToStr(StrToFloat(TEdit(Sender).Text));
  except
    TEdit(Sender).Text := Format('0%s00', [DecimalSeparator]);
  end;
end;

procedure TFrmOptions.BtDefClick(Sender: TObject);
begin
  if ActiveControl = ListView1 then begin
    ListView1DblClick(ListView1);
    Exit;
  end;
end;

procedure TFrmOptions.ListView1DblClick(Sender: TObject);
begin
  if Assigned(ListView1.Selected) then
    SpeedButton3.Click
  else
    SpeedButton1.Click;
end;

procedure TFrmOptions.VDTButton1Click(Sender: TObject);
begin
  BrowseDirectoryDlg1.Selection := TVDTButton(Sender).Caption;
  BrowseDirectoryDlg1.Title := 'Sélectionnez le ' + LowerCase(TVDTButton(Sender).Hint);
  if BrowseDirectoryDlg1.Execute then TVDTButton(Sender).Caption := BrowseDirectoryDlg1.Selection;
end;

procedure TFrmOptions.FormShow(Sender: TObject);
begin
  OpenStart.SetFocus;
end;

end.

