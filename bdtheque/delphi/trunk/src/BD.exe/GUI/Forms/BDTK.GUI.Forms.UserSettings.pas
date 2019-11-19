unit BDTK.GUI.Forms.UserSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes, System.Types, Vcl.ComCtrls, System.IniFiles, Winapi.CommCtrl, Vcl.ImgList,
  Vcl.Buttons, VDTButton, BD.GUI.Frames.Buttons, Browss, EditLabeled, ComboCheck, BDTK.GUI.Controls.Spin, BD.GUI.Forms, Vcl.FileCtrl,
  PngSpeedButton, PngImageList, JvComponentBase, JclCompression,
  System.ImageList;

type
  TfrmOptions = class(TbdtForm)
    PageControl1: TPageControl;
    options: TTabSheet;
    ImageList1: TPngImageList;
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
    Frame11: TframBoutons;
    Frame12: TframBoutons;
    BtDef: TButton;
    BrowseDirectoryDlg1: TBrowseDirectoryDlg;
    Label9: TLabel;
    Edit1: TEditLabeled;
    ListView1: TVDTListView;
    TabSheet1: TTabSheet;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    ComboBox4: TComboBox;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    RadioButton5: TRadioButton;
    RadioButton4: TRadioButton;
    ComboBox5: TComboBox;
    Label17: TLabel;
    ComboBox6: TComboBox;
    Button1: TButton;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    OpenStart: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox5: TCheckBox;
    Label3: TLabel;
    LightComboCheck2: TLightComboCheck;
    CheckBox3: TCheckBox;
    GrandesIconesMenu: TCheckBox;
    GrandesIconesBarre: TCheckBox;
    LightComboCheck1: TLightComboCheck;
    FicheAlbumCouverture: TCheckBox;
    FicheParaBDCouverture: TCheckBox;
    CheckBox2: TCheckBox;
    Label14: TLabel;
    VDTButton1: TVDTButton;
    AfficherNotesListes: TCheckBox;
    ComboBox1: TComboBox;
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
    procedure Button1Click(Sender: TObject);
  protected
  private
    ImageChargee: Boolean;
    SItem: TListItem;
  public
  end;

implementation

uses
  BD.Common, BDTK.GUI.DataModules.Main, BD.Entities.Lite, UIB, BD.Utils.StrUtils, BD.Utils.GUIUtils, BDTK.Updates, System.IOUtils,
  BDTK.Entities.Dao.Lite, BDTK.GUI.Utils, BD.Entities.Common, BD.Entities.Factory.Lite, ICUNumberFormatter, _uloc,
  BD.DB.Connection;

{$R *.DFM}

procedure TfrmOptions.btnOKClick(Sender: TObject);
var
  PC: TConversionLite;
  i: Integer;
  qry: TManagedQuery;
begin
  if TGlobalVar.RepImages <> VDTButton1.Caption then
    if MessageDlg('Vous avez choisi de modifier le répertoire de stockage des images.'#13'N''oubliez pas de déplacer les fichiers de l''ancien répertoire vers le nouveau.', mtWarning, mbOKCancel, 0) = mrCancel then
    begin
      ModalResult := mrNone;
      Exit;
    end;

  TGlobalVar.Options.SymboleMonnetaire := ComboBox1.Text;
  TGlobalVar.Options.ModeDemarrage := not OpenStart.Checked;
  TGlobalVar.Options.FicheAlbumWithCouverture := FicheAlbumCouverture.Checked;
  TGlobalVar.Options.FicheParaBDWithImage := FicheParaBDCouverture.Checked;
  TGlobalVar.Options.Images := CheckBox3.Checked;
  TGlobalVar.RepImages := VDTButton1.Caption;
  TGlobalVar.Options.AntiAliasing := CheckBox5.Checked;
  TGlobalVar.Options.ImagesStockees := CheckBox2.Checked;
  TGlobalVar.Options.FormatTitreAlbum := LightComboCheck2.Value;
  TGlobalVar.Options.AvertirPret := CheckBox6.Checked;
  TGlobalVar.Options.GrandesIconesMenus := GrandesIconesMenu.Checked;
  TGlobalVar.Options.GrandesIconesBarre := Self.GrandesIconesBarre.Checked;
  TGlobalVar.Options.VerifMAJDelai := LightComboCheck1.Value;
  TGlobalVar.Options.SerieObligatoireAlbums := CheckBox7.Checked;
  TGlobalVar.Options.SerieObligatoireParaBD := CheckBox8.Checked;
  TGlobalVar.Options.AfficheNoteListes := AfficherNotesListes.Checked;

  TGlobalVar.SiteWeb.Adresse := Edit2.Text;
  TGlobalVar.SiteWeb.Cle := Edit3.Text;
  TGlobalVar.SiteWeb.Modele := ComboBox4.Text;
  TGlobalVar.SiteWeb.MySQLServeur := Edit4.Text;
  TGlobalVar.SiteWeb.MySQLLogin := Edit5.Text;
  TGlobalVar.SiteWeb.MySQLPassword := Edit7.Text;
  TGlobalVar.SiteWeb.MySQLBDD := Edit8.Text;
  TGlobalVar.SiteWeb.MySQLPrefix := Edit6.Text;
  if RadioButton5.Checked then
    TGlobalVar.SiteWeb.BddVersion := ''
  else
    TGlobalVar.SiteWeb.BddVersion := ComboBox5.Text;
  TGlobalVar.SiteWeb.Paquets := StrToInt(ComboBox6.Text);

  qry := dmPrinc.DBConnection.GetQuery;
  try
    qry.SQL.Text := 'update or insert into conversions (id_conversion, monnaie1, monnaie2, taux) values (?, ?, ?, ?) matching (id_conversion)';
    qry.Prepare(True);
    for i := 0 to ListView1.Items.Count - 1 do
    begin
      PC := ListView1.Items[i].Data;
      if IsEqualGUID(GUID_NULL, PC.ID) then
        qry.Params.IsNull[0] := True
      else
        qry.Params.AsString[0] := GUIDToString(PC.ID);
      qry.Params.AsString[1] := Copy(PC.Monnaie1, 1, qry.Params.MaxStrLen[1]);
      qry.Params.AsString[2] := Copy(PC.Monnaie2, 1, qry.Params.MaxStrLen[2]);
      qry.Params.AsDouble[3] := PC.Taux;
      qry.Execute;
    end;
    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
  EcritOptions;
  LitOptions;
end;

procedure TfrmOptions.calculKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, [#8, '0' .. '9', ',', '.', FormatSettings.DecimalSeparator]) then
    Key := #0;
  if CharInSet(Key, ['.', ',']) then
    Key := FormatSettings.DecimalSeparator;
end;

procedure TfrmOptions.calculExit(Sender: TObject);
begin
  try
    TEdit(Sender).Text := BDDoubleToStr(BDStrToDouble(TEdit(Sender).Text));
  except
    TEdit(Sender).Text := BDDoubleToStr(0);
  end;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
var
  q: TManagedQuery;
  MySQLUpdate: TMySQLUpdate;
  fileName: String;
  item: TListItem;
begin
  PrepareLV(Self);
  LitOptions;
  for MySQLUpdate in ListMySQLUpdates do
    ComboBox5.Items.Insert(0, MySQLUpdate.Version);
  ComboBox5.ItemIndex := 0;

  for fileName in TDirectory.GetFiles(TGlobalVar.RepWebServer,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := TPath.MatchesPattern(SearchRec.Name, '*.zip', False) or TPath.MatchesPattern(SearchRec.Name, '*.7z', False);
    end) do
    if not SameFileName(TPath.GetFileNameWithoutExtension(fileName), 'interface') then
      ComboBox4.Items.Add(TPath.GetFileNameWithoutExtension(fileName));

  PageControl1.ActivePage := PageControl1.Pages[0];
  ImageChargee := False;
  SItem := nil;

  q := dmPrinc.DBConnection.GetQuery;
  try
    q.SQL.Add('SELECT Monnaie1 AS Monnaie FROM conversions');
    q.SQL.Add('UNION');
    q.SQL.Add('SELECT Monnaie2 AS Monnaie FROM conversions');
    q.Open;
    while not q.Eof do
    begin
      ComboBox1.Items.Add(q.Fields.ByNameAsString['Monnaie']);
      ComboBox2.Items.Add(q.Fields.ByNameAsString['Monnaie']);
      ComboBox3.Items.Add(q.Fields.ByNameAsString['Monnaie']);
      q.Next;
    end;
    q.Close;
    q.SQL.Clear;
    q.SQL.Text := 'SELECT Id_Conversion, Monnaie1, Monnaie2, Taux FROM conversions';
    q.Open;
    while not q.Eof do
    begin
      item := ListView1.Items.Add;
      item.Data := TDaoConversionLite.Make(q);
      item.Caption := TConversionLite(item.Data).ChaineAffichage;
      item.SubItems.Add('0');

      q.Next;
    end;
  finally
    q.Free;
  end;

  if ComboBox1.Items.IndexOf(TGlobalVar.Options.SymboleMonnetaire) = -1 then
    ComboBox1.Items.Add(TGlobalVar.Options.SymboleMonnetaire);
  if ComboBox1.Items.IndexOf(FormatSettings.CurrencyString) = -1 then
    ComboBox1.Items.Add(FormatSettings.CurrencyString);

  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(TGlobalVar.Options.SymboleMonnetaire);
  OpenStart.Checked := not TGlobalVar.Options.ModeDemarrage;
  FicheAlbumCouverture.Checked := TGlobalVar.Options.FicheAlbumWithCouverture;
  FicheParaBDCouverture.Checked := TGlobalVar.Options.FicheParaBDWithImage;
  CheckBox3.Checked := TGlobalVar.Options.Images;
  VDTButton1.Caption := TGlobalVar.RepImages;
  CheckBox5.Checked := TGlobalVar.Options.AntiAliasing;
  CheckBox2.Checked := TGlobalVar.Options.ImagesStockees;
  LightComboCheck2.Value := TGlobalVar.Options.FormatTitreAlbum;
  CheckBox5.Checked := TGlobalVar.Options.AntiAliasing;
  CheckBox6.Checked := TGlobalVar.Options.AvertirPret;
  GrandesIconesMenu.Checked := TGlobalVar.Options.GrandesIconesMenus;
  Self.GrandesIconesBarre.Checked := TGlobalVar.Options.GrandesIconesBarre;
  LightComboCheck1.Value := TGlobalVar.Options.VerifMAJDelai;
  CheckBox7.Checked := TGlobalVar.Options.SerieObligatoireAlbums;
  CheckBox8.Checked := TGlobalVar.Options.SerieObligatoireParaBD;
  AfficherNotesListes.Checked := TGlobalVar.Options.AfficheNoteListes;

  Edit2.Text := TGlobalVar.SiteWeb.Adresse;
  Edit3.Text := TGlobalVar.SiteWeb.Cle;
  ComboBox4.ItemIndex := ComboBox4.Items.IndexOf(TGlobalVar.SiteWeb.Modele);
  Edit4.Text := TGlobalVar.SiteWeb.MySQLServeur;
  Edit5.Text := TGlobalVar.SiteWeb.MySQLLogin;
  Edit7.Text := TGlobalVar.SiteWeb.MySQLPassword;
  Edit8.Text := TGlobalVar.SiteWeb.MySQLBDD;
  Edit6.Text := TGlobalVar.SiteWeb.MySQLPrefix;
  if TGlobalVar.SiteWeb.BddVersion = '' then
    RadioButton5.Checked := True
  else
  begin
    RadioButton4.Checked := True;
    ComboBox5.ItemIndex := ComboBox5.Items.IndexOf(TGlobalVar.SiteWeb.BddVersion);
  end;
  ComboBox6.ItemIndex := ComboBox6.Items.IndexOf(IntToStr(TGlobalVar.SiteWeb.Paquets));
end;

procedure TfrmOptions.Button2Click(Sender: TObject);
var
  PC: TConversionLite;
  i: TListItem;
begin
  if Assigned(SItem) then
  begin
    PC := SItem.Data;
    i := SItem;
    if i.SubItems[0] <> '1' then
      i.SubItems[0] := '2';
    SItem := nil;
  end
  else
  begin
    PC := TFactoryConversionLite.getInstance;
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

procedure TfrmOptions.Button3Click(Sender: TObject);
begin
  SItem := nil;
  Panel4.Visible := False;
  SpeedButton1.Enabled := True;
  SpeedButton2.Enabled := True;
  SpeedButton3.Enabled := True;
end;

procedure TfrmOptions.SpeedButton1Click(Sender: TObject);
begin
  ComboBox2.Text := '';
  ComboBox3.Text := '';
  Edit1.Text := BDDoubleToStr(0);
  Panel4.Visible := True;
  SpeedButton2.Enabled := False;
  SpeedButton3.Enabled := False;
end;

procedure TfrmOptions.ComboBox2Change(Sender: TObject);
begin
  if Sender is TComboBox then
    if Length(TComboBox(Sender).Text) > 5 then
      TComboBox(Sender).Text := Copy(TComboBox(Sender).Text, 1, 5);
  Label10.Caption := Format('%s = %s', [ICUCurrencyToStr(1, uloc_getDefault, ComboBox2.Text), ICUCurrencyToStr(BDStrToDouble(Edit1.Text), uloc_getDefault, ComboBox3.Text)]);
  Frame12.btnOK.Enabled := (ComboBox2.Text <> '') and (Edit1.Text <> '') and (ComboBox3.Text <> '');
end;

procedure TfrmOptions.SpeedButton3Click(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) or Panel4.Visible then
    Exit;
  SItem := ListView1.Selected;
  ComboBox2.Text := TConversionLite(SItem.Data).Monnaie1;
  ComboBox3.Text := TConversionLite(SItem.Data).Monnaie2;
  Edit1.Text := BDDoubleToStr(TConversionLite(SItem.Data).Taux);
  Panel4.Visible := True;
  SpeedButton2.Enabled := False;
  SpeedButton1.Enabled := False;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  TDaoConversionLite.VideListe(ListView1);
end;

procedure TfrmOptions.SpeedButton2Click(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) or Panel4.Visible then
    Exit;
  TConversionLite(ListView1.Selected.Data).Free;
  ListView1.Selected.Delete;
end;

procedure TfrmOptions.Edit1Exit(Sender: TObject);
begin
  try
    TEdit(Sender).Text := BDDoubleToStr(BDStrToDouble(TEdit(Sender).Text));
  except
    TEdit(Sender).Text := BDDoubleToStr(0);
  end;
end;

procedure TfrmOptions.BtDefClick(Sender: TObject);
begin
  if ActiveControl = ListView1 then
  begin
    ListView1DblClick(ListView1);
    Exit;
  end;
end;

procedure TfrmOptions.ListView1DblClick(Sender: TObject);
begin
  if Assigned(ListView1.Selected) then
    SpeedButton3.Click
  else
    SpeedButton1.Click;
end;

procedure TfrmOptions.VDTButton1Click(Sender: TObject);
begin
  BrowseDirectoryDlg1.Selection := TVDTButton(Sender).Caption;
  BrowseDirectoryDlg1.Title := 'Sélectionnez le ' + LowerCase(TVDTButton(Sender).Hint);
  if BrowseDirectoryDlg1.Execute then
    TVDTButton(Sender).Caption := BrowseDirectoryDlg1.Selection;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
  OpenStart.SetFocus;
end;

procedure TfrmOptions.Button1Click(Sender: TObject);

  function SearchFileName(archiveName: string): string;
  begin
    if TFile.Exists(archiveName + '.7z') then
      Result := archiveName + '.7z'
    else
      Result := archiveName + '.zip';
  end;

  procedure ExtractArchive(archiveName: string; const repSave: string);
  var
    AFormats: TJclDecompressArchiveClassArray;
    AFormat: TJclDecompressArchiveClass;
    FArchive: TJclCompressionArchive;
  begin
    archiveName := SearchFileName(archiveName);
    AFormats := GetArchiveFormats.FindDecompressFormats(archiveName);
    for AFormat in AFormats do
    begin
      FArchive := AFormat.Create(archiveName, 0, False);
      if FArchive is TJclDecompressArchive then
      begin
        TJclDecompressArchive(FArchive).ListFiles;
        TJclDecompressArchive(FArchive).ExtractAll(repSave, True);
      end
      else if FArchive is TJclUpdateArchive then
      begin
        TJclUpdateArchive(FArchive).ListFiles;
        TJclUpdateArchive(FArchive).ExtractAll(repSave, True);
      end;
      FArchive.Free;
      Break;
    end;
  end;

var
  repSave: string;
  sl: TStringList;
begin
  if not Vcl.FileCtrl.SelectDirectory('Sélectionnez un répertoire dans lequel créer le site web', '', repSave, [sdNewUI, sdNewFolder, sdValidateDir], Self) then
    Exit;

  ExtractArchive(TGlobalVar.RepWebServer + 'interface', repSave);
  ExtractArchive(TGlobalVar.RepWebServer + TGlobalVar.SiteWeb.Modele, repSave);

  sl := TStringList.Create;
  try
    sl.Add('<?');
    sl.Add('');
    sl.Add('$db_host = ''' + StringReplace(Edit4.Text, '''', '\''', [rfReplaceAll]) + ''';');
    sl.Add('$db_user = ''' + StringReplace(Edit5.Text, '''', '\''', [rfReplaceAll]) + ''';');
    sl.Add('$db_pass = ''' + StringReplace(Edit7.Text, '''', '\''', [rfReplaceAll]) + ''';');
    sl.Add('$db_name = ''' + StringReplace(Edit8.Text, '''', '\''', [rfReplaceAll]) + ''';');
    sl.Add('$db_prefix = ''' + StringReplace(Edit6.Text, '''', '\''', [rfReplaceAll]) + ''';');
    sl.Add('$db_key = ''' + StringReplace(Edit3.Text, '''', '\''', [rfReplaceAll]) + ''';');
    sl.Add('$rep_images = ''images'';');
    sl.Add('');
    sl.Add('');
    sl.Add('if (file_exists(''config_ex.inc'')) include_once ''config_ex.inc'';');
    sl.Add('');
    sl.Add('?>');
    sl.SaveToFile(TPath.Combine(repSave, 'config.inc'));
  finally
    sl.Free;
  end;
end;

end.

