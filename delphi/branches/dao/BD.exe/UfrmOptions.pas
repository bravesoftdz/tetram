unit UfrmOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, System.UITypes, System.Types, ComCtrls, IniFiles, CommCtrl, ImgList,
  Buttons, VDTButton, UframBoutons, Browss, EditLabeled, ComboCheck, Spin, UBdtForms, FileCtrl,
  PngSpeedButton, PngImageList, JvComponentBase, JclCompression;

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

uses CommonConst, UdmPrinc, EntitiesLite, UIB, Commun, Procedures, Updates, IOUtils,
  DaoLite, ProceduresBDtk;

{$R *.DFM}

procedure TfrmOptions.btnOKClick(Sender: TObject);
var
  PC: TConversionLite;
  i: Integer;
begin
  if RepImages <> VDTButton1.Caption then
    if MessageDlg
      ('Vous avez choisi de modifier le répertoire de stockage des images.'#13'N''oubliez pas de déplacer les fichiers de l''ancien répertoire vers le nouveau.',
      mtWarning, mbOKCancel, 0) = mrCancel then
    begin
      ModalResult := mrNone;
      Exit;
    end;

  with TGlobalVar.Utilisateur.options do
  begin
    SymboleMonnetaire := ComboBox1.Text;
    ModeDemarrage := not OpenStart.Checked;
    FicheAlbumWithCouverture := FicheAlbumCouverture.Checked;
    FicheParaBDWithImage := FicheParaBDCouverture.Checked;
    Images := CheckBox3.Checked;
    RepImages := VDTButton1.Caption;
    AntiAliasing := CheckBox5.Checked;
    ImagesStockees := CheckBox2.Checked;
    FormatTitreAlbum := LightComboCheck2.Value;
    AntiAliasing := CheckBox5.Checked;
    AvertirPret := CheckBox6.Checked;
    GrandesIconesMenus := GrandesIconesMenu.Checked;
    GrandesIconesBarre := Self.GrandesIconesBarre.Checked;
    VerifMAJDelai := LightComboCheck1.Value;
    SerieObligatoireAlbums := CheckBox7.Checked;
    SerieObligatoireParaBD := CheckBox8.Checked;
    AfficheNoteListes := AfficherNotesListes.Checked;

    SiteWeb.Adresse := Edit2.Text;
    SiteWeb.Cle := Edit3.Text;
    SiteWeb.Modele := ComboBox4.Text;
    SiteWeb.MySQLServeur := Edit4.Text;
    SiteWeb.MySQLLogin := Edit5.Text;
    SiteWeb.MySQLPassword := Edit7.Text;
    SiteWeb.MySQLBDD := Edit8.Text;
    SiteWeb.MySQLPrefix := Edit6.Text;
    if RadioButton5.Checked then
      SiteWeb.BddVersion := ''
    else
      SiteWeb.BddVersion := ComboBox5.Text;
    SiteWeb.Paquets := StrToInt(ComboBox6.Text);
  end;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'update or insert into conversions (id_conversion, monnaie1, monnaie2, taux) values (?, ?, ?, ?) matching (id_conversion)';
      Prepare(True);
      for i := 0 to ListView1.Items.Count - 1 do
      begin
        PC := ListView1.Items[i].Data;
        if IsEqualGUID(GUID_NULL, PC.ID) then
          Params.IsNull[0] := True
        else
          Params.AsString[0] := GUIDToString(PC.ID);
        Params.AsString[1] := Copy(PC.Monnaie1, 1, Params.MaxStrLen[1]);
        Params.AsString[2] := Copy(PC.Monnaie2, 1, Params.MaxStrLen[2]);
        Params.AsDouble[3] := PC.Taux;
        Execute;
      end;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
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
    TEdit(Sender).Text := FormatCurr(FormatMonnaieCourt, StrToCurr(TEdit(Sender).Text));
  except
    TEdit(Sender).Text := Format('0%s00', [FormatSettings.DecimalSeparator]);
  end;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
var
  q: TUIBQuery;
  MySQLUpdate: TMySQLUpdate;
  fileName: String;
begin
  PrepareLV(Self);
  LitOptions;
  for MySQLUpdate in ListMySQLUpdates do
    ComboBox5.Items.Insert(0, MySQLUpdate.Version);
  ComboBox5.ItemIndex := 0;

  for fileName in TDirectory.GetFiles(RepWebServer,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := TPath.MatchesPattern(SearchRec.Name, '*.zip', False) or TPath.MatchesPattern(SearchRec.Name, '*.7z', False);
    end) do
    if not SameFileName(TPath.GetFileNameWithoutExtension(fileName), 'interface') then
      ComboBox4.Items.Add(TPath.GetFileNameWithoutExtension(fileName));

  PageControl1.ActivePage := PageControl1.Pages[0];
  ImageChargee := False;
  SItem := nil;

  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Add('SELECT Monnaie1 AS Monnaie FROM conversions');
      SQL.Add('UNION');
      SQL.Add('SELECT Monnaie2 AS Monnaie FROM conversions');
      Open;
      while not Eof do
      begin
        ComboBox1.Items.Add(Fields.ByNameAsString['Monnaie']);
        ComboBox2.Items.Add(Fields.ByNameAsString['Monnaie']);
        ComboBox3.Items.Add(Fields.ByNameAsString['Monnaie']);
        Next;
      end;
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT Id_Conversion, Monnaie1, Monnaie2, Taux FROM conversions';
      Open;
      while not Eof do
      begin
        with ListView1.Items.Add do
        begin
          Data := TDaoConversionLite.Make(q);
          Caption := TConversionLite(Data).ChaineAffichage;
          SubItems.Add('0');
        end;
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
  with ComboBox1.Items, TGlobalVar.Utilisateur.options do
  begin
    if IndexOf(SymboleMonnetaire) = -1 then
      Add(SymboleMonnetaire);
    if IndexOf(FormatSettings.CurrencyString) = -1 then
      Add(FormatSettings.CurrencyString);
  end;

  with TGlobalVar.Utilisateur.options do
  begin
    ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(SymboleMonnetaire);
    OpenStart.Checked := not ModeDemarrage;
    FicheAlbumCouverture.Checked := FicheAlbumWithCouverture;
    FicheParaBDCouverture.Checked := FicheParaBDWithImage;
    CheckBox3.Checked := Images;
    VDTButton1.Caption := RepImages;
    CheckBox5.Checked := AntiAliasing;
    CheckBox2.Checked := ImagesStockees;
    LightComboCheck2.Value := FormatTitreAlbum;
    CheckBox5.Checked := AntiAliasing;
    CheckBox6.Checked := AvertirPret;
    GrandesIconesMenu.Checked := GrandesIconesMenus;
    Self.GrandesIconesBarre.Checked := GrandesIconesBarre;
    LightComboCheck1.Value := VerifMAJDelai;
    CheckBox7.Checked := SerieObligatoireAlbums;
    CheckBox8.Checked := SerieObligatoireParaBD;
    AfficherNotesListes.Checked := AfficheNoteListes;

    Edit2.Text := SiteWeb.Adresse;
    Edit3.Text := SiteWeb.Cle;
    ComboBox4.ItemIndex := ComboBox4.Items.IndexOf(SiteWeb.Modele);
    Edit4.Text := SiteWeb.MySQLServeur;
    Edit5.Text := SiteWeb.MySQLLogin;
    Edit7.Text := SiteWeb.MySQLPassword;
    Edit8.Text := SiteWeb.MySQLBDD;
    Edit6.Text := SiteWeb.MySQLPrefix;
    if SiteWeb.BddVersion = '' then
      RadioButton5.Checked := True
    else
    begin
      RadioButton4.Checked := True;
      ComboBox5.ItemIndex := ComboBox5.Items.IndexOf(SiteWeb.BddVersion);
    end;
    ComboBox6.ItemIndex := ComboBox6.Items.IndexOf(IntToStr(SiteWeb.Paquets));
  end;
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
    PC := TConversionLite.Create;
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
  Edit1.Text := Format('0%s00', [FormatSettings.DecimalSeparator]);;
  Panel4.Visible := True;
  SpeedButton2.Enabled := False;
  SpeedButton3.Enabled := False;
end;

procedure TfrmOptions.ComboBox2Change(Sender: TObject);
begin
  if Sender is TComboBox then
    if Length(TComboBox(Sender).Text) > 5 then
      TComboBox(Sender).Text := Copy(TComboBox(Sender).Text, 1, 5);
  Label10.Caption := Format('1 %s = %s %s', [ComboBox2.Text, Edit1.Text, ComboBox3.Text]);
  Frame12.btnOK.Enabled := (ComboBox2.Text <> '') and (Edit1.Text <> '') and (ComboBox3.Text <> '');
end;

procedure TfrmOptions.SpeedButton3Click(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) or Panel4.Visible then
    Exit;
  SItem := ListView1.Selected;
  ComboBox2.Text := TConversionLite(SItem.Data).Monnaie1;
  ComboBox3.Text := TConversionLite(SItem.Data).Monnaie2;
  Edit1.Text := Format('%g', [TConversionLite(SItem.Data).Taux]);
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
    TEdit(Sender).Text := FloatToStr(StrToFloat(TEdit(Sender).Text));
  except
    TEdit(Sender).Text := Format('0%s00', [FormatSettings.DecimalSeparator]);
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
  if not FileCtrl.SelectDirectory('Sélectionnez un répertoire dans lequel créer le site web', '', repSave, [sdNewUI, sdNewFolder, sdValidateDir], Self) then
    Exit;

  ExtractArchive(RepWebServer + 'interface', repSave);
  ExtractArchive(RepWebServer + TGlobalVar.Utilisateur.options.SiteWeb.Modele, repSave);

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
