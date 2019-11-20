﻿unit BDTK.Web.Forms.Preview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, System.Generics.Collections, BD.Entities.Lite, Vcl.Dialogs, Vcl.StdCtrls, BD.Entities.Full,
  Vcl.ExtCtrls, Vcl.CheckLst, Vcl.Menus, Vcl.Imaging.jpeg, BD.GUI.Frames.Buttons, ComboCheck, EditLabeled, Vcl.ComCtrls,
  BD.GUI.Forms, BD.Entities.Types;

type
  TfrmBDTKWebPreview = class(TbdtForm)
    CheckBox1: TCheckBoxLabeled;
    edTitreAlbum: TEditLabeled;
    CheckBox2: TCheckBoxLabeled;
    edTome: TEditLabeled;
    edMoisParution: TEditLabeled;
    CheckBox3: TCheckBoxLabeled;
    CheckBox4: TCheckBoxLabeled;
    edAnneeParution: TEditLabeled;
    CheckBox5: TCheckBoxLabeled;
    pnHorsSerie: TPanel;
    RadioButton1: TRadioButtonLabeled;
    RadioButton2: TRadioButtonLabeled;
    pnIntegrale: TPanel;
    RadioButton3: TRadioButtonLabeled;
    RadioButton4: TRadioButtonLabeled;
    CheckBox6: TCheckBoxLabeled;
    cklScenaristes: TCheckListBoxLabeled;
    CheckBox8: TCheckBoxLabeled;
    cklDessinateurs: TCheckListBoxLabeled;
    CheckBox9: TCheckBoxLabeled;
    cklColoristes: TCheckListBoxLabeled;
    CheckBox10: TCheckBoxLabeled;
    mmResumeAlbum: TMemoLabeled;
    mmNotesAlbum: TMemoLabeled;
    CheckBox11: TCheckBoxLabeled;
    CheckBox12: TCheckBoxLabeled;
    CheckBox13: TCheckBoxLabeled;
    edTitreSerie: TEditLabeled;
    pnTerminee: TPanel;
    RadioButton5: TRadioButtonLabeled;
    RadioButton6: TRadioButtonLabeled;
    CheckBox14: TCheckBoxLabeled;
    CheckBox15: TCheckBoxLabeled;
    cklGenres: TCheckListBoxLabeled;
    edSiteWebSerie: TEditLabeled;
    CheckBox16: TCheckBoxLabeled;
    mmResumeSerie: TMemoLabeled;
    CheckBox17: TCheckBoxLabeled;
    mmNotesSerie: TMemoLabeled;
    CheckBox18: TCheckBoxLabeled;
    edNbAlbums: TEditLabeled;
    cbxEtat: TLightComboCheck;
    cbxEdition: TLightComboCheck;
    cbxReliure: TLightComboCheck;
    cbxOrientation: TLightComboCheck;
    cbxSensLecture: TLightComboCheck;
    cbxFormat: TLightComboCheck;
    CheckBox24: TCheckBoxLabeled;
    CheckBox23: TCheckBoxLabeled;
    CheckBox25: TCheckBoxLabeled;
    CheckBox26: TCheckBoxLabeled;
    CheckBox27: TCheckBoxLabeled;
    CheckBox28: TCheckBoxLabeled;
    Label9: TCheckBoxLabeled;
    edPrix: TEditLabeled;
    edISBN: TEditLabeled;
    Label11: TCheckBoxLabeled;
    Label24: TCheckBoxLabeled;
    edAnneeCote: TEditLabeled;
    Label25: TCheckBoxLabeled;
    edPrixCote: TEditLabeled;
    pnGratuit: TPanel;
    RadioButton7: TRadioButtonLabeled;
    RadioButton8: TRadioButtonLabeled;
    CheckBox30: TCheckBoxLabeled;
    pnCouleur: TPanel;
    RadioButton9: TRadioButtonLabeled;
    RadioButton10: TRadioButtonLabeled;
    CheckBox31: TCheckBoxLabeled;
    pnVO: TPanel;
    RadioButton11: TRadioButtonLabeled;
    RadioButton12: TRadioButtonLabeled;
    CheckBox7: TCheckBoxLabeled;
    edTomeDebut: TEditLabeled;
    Label17: TLabel;
    edTomeFin: TEditLabeled;
    CheckBox33: TCheckBoxLabeled;
    edNbPages: TEditLabeled;
    RadioButtonLabeled1: TRadioButtonLabeled;
    cklImages: TCheckListBoxLabeled;
    CheckBoxLabeled1: TCheckBoxLabeled;
    imgVisu: TImage;
    cklScenaristesSerie: TCheckListBoxLabeled;
    CheckBoxLabeled2: TCheckBoxLabeled;
    cklDessinateursSerie: TCheckListBoxLabeled;
    CheckBoxLabeled3: TCheckBoxLabeled;
    cklColoristesSerie: TCheckListBoxLabeled;
    CheckBoxLabeled4: TCheckBoxLabeled;
    CheckBoxLabeled5: TCheckBoxLabeled;
    edNomEditeurSerie: TEditLabeled;
    edSiteWebEditeurSerie: TEditLabeled;
    CheckBoxLabeled6: TCheckBoxLabeled;
    edCollectionSerie: TEditLabeled;
    CheckBoxLabeled7: TCheckBoxLabeled;
    PageControl1: TPageControl;
    TabAlbum: TTabSheet;
    TabSerie: TTabSheet;
    TabEdition: TTabSheet;
    edNomEditeur: TEditLabeled;
    CheckBox20: TCheckBoxLabeled;
    edSiteWebEditeur: TEditLabeled;
    CheckBox21: TCheckBoxLabeled;
    edCollection: TEditLabeled;
    CheckBox22: TCheckBoxLabeled;
    edAnneeEdition: TEditLabeled;
    CheckBox29: TCheckBoxLabeled;
    CheckBox32: TCheckBoxLabeled;
    cklUnivers: TCheckListBoxLabeled;
    CheckBox19: TCheckBoxLabeled;
    CheckBoxLabeled8: TCheckBoxLabeled;
    procedure FormCreate(Sender: TObject);
    procedure framBoutons1btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxEtatBeforeShowPop(Sender: TObject; Menu: TPopupMenu; var Continue: Boolean);
    procedure cklImagesClick(Sender: TObject);
    procedure imgVisuClick(Sender: TObject);
  private
    FAlbum: TAlbumFull;
    DefaultValues: TAlbumFull;
    DefaultEdition: TEditionFull;
    procedure VisuClose(Sender: TObject);
  public
    property Album: TAlbumFull read FAlbum;

    procedure SetValue(AId: Integer; const AValue: string);
  end;

implementation

uses
  System.IOUtils, BD.Utils.StrUtils, BD.Utils.GUIUtils, BD.Common, BDTK.Entities.Dao.Full, BDTK.GUI.Utils,
  BD.Entities.Common, BD.Entities.Dao.Lambda, BDTK.Web.Browser.Utils;

{$R *.dfm}

type
  TStringsHelper = class helper for TStrings
    function Contains(const AString: string): Boolean;
  end;

  TLightComboCheckHelper = class helper for TLightComboCheck
    function GetValue(const AString: string): Integer;
  end;

{ TStringsHelper }

function TStringsHelper.Contains(const AString: string): Boolean;
var
  s: string;
begin
  for s in Self do
    if SameText(s, AString) then
      Exit(True);
  Result := False;
end;

{ TLightComboCheckHelper }

function TLightComboCheckHelper.GetValue(const AString: string): Integer;

  function ProcessSubItem(ASubItem: TSubItem; out AValue: Integer): Boolean;
  var
    i: Integer;
  begin
    if not (ASubItem.Visible and ASubItem.Enabled) then
      Exit(False);
    if ASubItem.SubItems.Count = 0 then
    begin
      Result := SameText(AString, ASubItem.Caption);
      if Result then
        AValue := ASubItem.Valeur;
    end
    else
    begin
      for i := 0 to Pred(ASubItem.SubItems.Count) do
        if ProcessSubItem(ASubItem.SubItems[i], AValue) then
          Exit(True);
      Result := False;
    end;
  end;

var
  i: Integer;
begin
  for i := 0 to Pred(Items.Count) do
    if ProcessSubItem(Items[i], Result) then
      Exit;
  Result := DefaultValueUnchecked;
end;

{ TfrmBDTKWebPreview }

procedure TfrmBDTKWebPreview.VisuClose(Sender: TObject);
begin
  TForm(TImage(Sender).Parent).ModalResult := mrCancel;
end;

procedure TfrmBDTKWebPreview.cbxEtatBeforeShowPop(Sender: TObject; Menu: TPopupMenu; var Continue: Boolean);
begin
  // on n'autorise pas l'ouverture du menu
  Continue := False;
end;

procedure TfrmBDTKWebPreview.cklImagesClick(Sender: TObject);
var
  PC: TCouvertureLite;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
begin
  if cklImages.ItemIndex > -1 then
  begin
    PC := FAlbum.Editions[0].Couvertures[cklImages.ItemIndex];
    hg := THourGlass.Create;
    if IsEqualGUID(PC.ID, GUID_NULL) then
      ms := GetJPEGStream(PC.NewNom, imgVisu.Height, imgVisu.Width, TGlobalVar.Options.AntiAliasing)
    else
      ms := GetCouvertureStream(False, PC.ID, imgVisu.Height, imgVisu.Width, TGlobalVar.Options.AntiAliasing);
    if Assigned(ms) then
      try
        jpg := TJPEGImage.Create;
        try
          jpg.LoadFromStream(ms);
          imgVisu.Picture.Assign(jpg);
        finally
          FreeAndNil(jpg);
        end;
      finally
        FreeAndNil(ms);
      end;
  end
  else
    imgVisu.Picture.Assign(nil);
end;

procedure TfrmBDTKWebPreview.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;

  DefaultValues := TDaoAlbumFull.getInstance(GUID_NULL);
  DefaultEdition := TDaoEditionFull.getInstance(GUID_NULL);
  DefaultValues.Editions.Add(DefaultEdition);

  LoadCombo(cbxEtat, TDaoListe.ListEtats, TDaoListe.DefaultEtat);
  LoadCombo(cbxReliure, TDaoListe.ListReliures, TDaoListe.DefaultReliure);
  LoadCombo(cbxEdition, TDaoListe.ListTypesEdition, TDaoListe.DefaultTypeEdition);
  LoadCombo(cbxOrientation, TDaoListe.ListOrientations, TDaoListe.DefaultOrientation);
  LoadCombo(cbxFormat, TDaoListe.ListFormatsEdition, TDaoListe.DefaultFormatEdition);
  LoadCombo(cbxSensLecture, TDaoListe.ListSensLecture, TDaoListe.DefaultSensLecture);

  TabSerie.TabVisible := False;
  TabEdition.TabVisible := False;
end;

procedure TfrmBDTKWebPreview.FormDestroy(Sender: TObject);
begin
  DefaultValues.Free;
  // pas la peine de détruire DefaultEdition, il est associé à DefaultValues qui le supprimera
end;

procedure TfrmBDTKWebPreview.framBoutons1btnOKClick(Sender: TObject);

  function SetValue(Ctrl: TCustomEdit; Chk: TCheckBox; const Defaut: string): string; overload;
  begin
    if Chk.Checked then
      Result := Ctrl.Text
    else
      Result := Defaut;
  end;

  function SetValue(Ctrl: TEdit; Chk: TCheckBox; Defaut: Integer): Integer; overload;
  begin
    if Chk.Checked then
      Result := StrToIntDef(Ctrl.Text, Defaut)
    else
      Result := Defaut;
  end;

  procedure SetValue(Value: TStrings; Ctrl: TMemo; Chk: TCheckBox); overload;
  begin
    if Chk.Checked then
      Value.Text := Ctrl.Lines.Text
    else
      Value.Clear;
  end;

  procedure SetValue(Value: TStrings; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    Value.Clear;
    if Chk.Checked then
      for i := 0 to Pred(Ctrl.Items.Count) do
        if Ctrl.Checked[i] then
          Value.Add(Ctrl.Items[i]);
  end;

  procedure SetValue(Value: TList<TUniversLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    if Chk.Checked then
    begin
      for i := Pred(Value.Count) downto 0 do
        if not Ctrl.Checked[i] then
          Value.Delete(i);
    end
    else
      Value.Clear;
  end;

  procedure SetValue(Value: TList<TAuteurSerieLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    if Chk.Checked then
    begin
      for i := Pred(Value.Count) downto 0 do
        if not Ctrl.Checked[i] then
          Value.Delete(i);
    end
    else
      Value.Clear;
  end;

  procedure SetValue(Value: TList<TAuteurAlbumLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    if Chk.Checked then
    begin
      for i := Pred(Value.Count) downto 0 do
        if not Ctrl.Checked[i] then
          Value.Delete(i);
    end
    else
      Value.Clear;
  end;

  procedure SetValue(Value: TList<TCouvertureLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    if Chk.Checked then
    begin
      for i := Pred(Value.Count) downto 0 do
        if not Ctrl.Checked[i] then
          Value.Delete(i);
    end
    else
      Value.Clear;
  end;

  function SetValue(Ctrl: TPanel; Chk: TCheckBox; Defaut: Boolean): Boolean; overload;
  begin
    if Chk.Checked then
      Result := TRadioButton(Ctrl.Controls[0]).Checked
    else
      Result := Defaut;
  end;

  function SetValue(Ctrl: TPanel; Chk: TCheckBox; Defaut: Integer): Integer; overload;
  begin
    if Chk.Checked then
    begin
      if TRadioButton(Ctrl.Controls[0]).Checked then
        Result := Integer(cbChecked)
      else if TRadioButton(Ctrl.Controls[1]).Checked then
        Result := Integer(cbUnchecked)
      else
        Result := -1;
    end
    else
      Result := Defaut;
  end;

  function SetValue(Ctrl: TPanel; Chk: TCheckBox; Defaut: RTriStateValue): RTriStateValue; overload;
  begin
    if Chk.Checked then
    begin
      if TRadioButton(Ctrl.Controls[0]).Checked then
        Result := True
      else if TRadioButton(Ctrl.Controls[1]).Checked then
        Result := False
      else
        Result.SetUndefined;
    end
    else
      Result := Defaut;
  end;

  function SetValue(Ctrl: TLightComboCheck; Chk: TCheckBox): ROption; overload;
  begin
    if Chk.Checked then
      Result := ROption.Create(Ctrl.Value, Ctrl.Caption)
    else
      Result := ROption.Create(Ctrl.DefaultValueChecked, Ctrl.GetCaption(Ctrl.DefaultValueChecked));
  end;

begin
  // Album
  FAlbum.TitreAlbum := SetValue(edTitreAlbum, CheckBox1, DefaultValues.TitreAlbum);
  FAlbum.MoisParution := SetValue(edMoisParution, CheckBox3, DefaultValues.MoisParution);
  FAlbum.AnneeParution := SetValue(edAnneeParution, CheckBox4, DefaultValues.AnneeParution);
  FAlbum.Tome := SetValue(edTome, CheckBox2, DefaultValues.Tome);
  FAlbum.TomeDebut := SetValue(edTomeDebut, CheckBox7, DefaultValues.TomeDebut);
  FAlbum.TomeFin := SetValue(edTomeFin, CheckBox7, DefaultValues.TomeFin);
  FAlbum.HorsSerie := SetValue(pnHorsSerie, CheckBox5, DefaultValues.HorsSerie);
  FAlbum.Integrale := SetValue(pnIntegrale, CheckBox6, DefaultValues.Integrale);
  SetValue(FAlbum.Scenaristes, cklScenaristes, CheckBox8);
  SetValue(FAlbum.Dessinateurs, cklDessinateurs, CheckBox9);
  SetValue(FAlbum.Coloristes, cklColoristes, CheckBox10);
  FAlbum.Sujet := SetValue(mmResumeAlbum, CheckBox11, DefaultValues.Sujet);
  FAlbum.Notes := SetValue(mmNotesAlbum, CheckBox12, DefaultValues.Notes);

  // Série
  FAlbum.Serie.TitreSerie := SetValue(edTitreSerie, CheckBox13, DefaultValues.Serie.TitreSerie);
  FAlbum.Serie.SiteWeb := SetValue(edSiteWebSerie, CheckBox16, DefaultValues.Serie.SiteWeb);
  SetValue(FAlbum.Serie.Univers, cklUnivers, CheckBox19);
  FAlbum.Serie.NbAlbums := SetValue(edNbAlbums, CheckBoxLabeled8, DefaultValues.Serie.NbAlbums);
  FAlbum.Serie.Terminee := SetValue(pnTerminee, CheckBox14, DefaultValues.Serie.Terminee);
  SetValue(FAlbum.Serie.Genres, cklGenres, CheckBox15);
  SetValue(FAlbum.Serie.Scenaristes, cklScenaristesSerie, CheckBoxLabeled2);
  SetValue(FAlbum.Serie.Dessinateurs, cklDessinateursSerie, CheckBoxLabeled3);
  SetValue(FAlbum.Serie.Coloristes, cklColoristesSerie, CheckBoxLabeled4);
  FAlbum.Serie.Sujet := SetValue(mmResumeSerie, CheckBox17, DefaultValues.Serie.Sujet);
  FAlbum.Serie.Notes := SetValue(mmNotesSerie, CheckBox18, DefaultValues.Serie.Notes);
  FAlbum.Serie.Editeur.NomEditeur := SetValue(edNomEditeurSerie, CheckBoxLabeled5, DefaultValues.Serie.Editeur.NomEditeur);
  FAlbum.Serie.Editeur.SiteWeb := SetValue(edSiteWebEditeurSerie, CheckBoxLabeled6, DefaultValues.Serie.Editeur.SiteWeb);
  FAlbum.Serie.Collection.NomCollection := SetValue(edCollectionSerie, CheckBoxLabeled7, DefaultValues.Serie.Collection.NomCollection);

  // Edition
  if FAlbum.Editions.Count > 0 then
    with FAlbum.Editions[0] do
    begin
      Editeur.NomEditeur := SetValue(edNomEditeur, CheckBox20, DefaultEdition.Editeur.NomEditeur);
      Editeur.SiteWeb := SetValue(edSiteWebEditeur, CheckBox21, DefaultEdition.Editeur.SiteWeb);
      Collection.NomCollection := SetValue(edCollection, CheckBox22, DefaultEdition.Collection.NomCollection);
      AnneeEdition := SetValue(edAnneeEdition, CheckBox29, DefaultEdition.AnneeEdition);
      Prix := BDStrToDoubleDef(SetValue(edPrix, Label9, BDCurrencyToStr(DefaultEdition.Prix)), 0);
      Gratuit := SetValue(pnGratuit, CheckBox30, DefaultEdition.Gratuit);
      ISBN := SetValue(edISBN, Label11, DefaultEdition.ISBN);
      Etat := SetValue(cbxEtat, CheckBox23);
      TypeEdition := SetValue(cbxEdition, CheckBox24);
      Reliure := SetValue(cbxReliure, CheckBox25);
      Orientation := SetValue(cbxOrientation, CheckBox26);
      SensLecture := SetValue(cbxSensLecture, CheckBox27);
      FormatEdition := SetValue(cbxFormat, CheckBox28);
      AnneeCote := SetValue(edAnneeCote, Label24, DefaultEdition.AnneeCote);
      if PrixCote <> 0 then
        PrixCote := BDStrToDoubleDef(SetValue(edPrixCote, Label25, BDCurrencyToStr(DefaultEdition.PrixCote)), 0);
      Couleur := SetValue(pnCouleur, CheckBox31, DefaultEdition.Couleur);
      VO := SetValue(pnVO, CheckBox32, DefaultEdition.VO);
      NombreDePages := SetValue(edNbPages, CheckBox33, DefaultEdition.NombreDePages);
      SetValue(Couvertures, cklImages, CheckBoxLabeled1);
    end;
end;

procedure TfrmBDTKWebPreview.imgVisuClick(Sender: TObject);
var
  PC: TCouvertureLite;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
  Couverture: TImage;
  Frm: TForm;
begin
  if cklImages.ItemIndex = -1 then
    Exit;
  PC := FAlbum.Editions[0].Couvertures[cklImages.ItemIndex];
  hg := THourGlass.Create;
  if IsEqualGUID(PC.ID, GUID_NULL) then
    ms := GetJPEGStream(PC.NewNom, 400, 500, TGlobalVar.Options.AntiAliasing)
  else
    ms := GetCouvertureStream(False, PC.ID, 400, 500, TGlobalVar.Options.AntiAliasing);
  if Assigned(ms) then
    try
      jpg := TJPEGImage.Create;
      Frm := TbdtForm.Create(Self);
      Couverture := TImage.Create(Frm);
      try
        jpg.LoadFromStream(ms);
        Frm.BorderIcons := [];
        Frm.BorderStyle := bsToolWindow;
        Frm.Position := poOwnerFormCenter;
        Couverture.Parent := Frm;
        Couverture.Picture.Assign(jpg);
        Couverture.Cursor := crHandPoint;
        Couverture.OnClick := VisuClose;
        Couverture.AutoSize := True;
        Frm.AutoSize := True;
        Frm.ShowModal;
      finally
        FreeAndNil(jpg);
        FreeAndNil(Couverture);
        FreeAndNil(Frm);
      end;
    finally
      FreeAndNil(ms);
    end;
end;

procedure TfrmBDTKWebPreview.SetValue(AId: Integer; const AValue: string);

  procedure ChangeState(Chk: TCheckBox; Ctrl: TControl);
  var
    TabSheet: TWinControl;
  begin
    Chk.Enabled := Chk.Checked;
    Ctrl.Enabled := Chk.Enabled and not(Ctrl is TPanel);
    TabSheet := Chk.Parent;
    while Assigned(TabSheet) and not (TabSheet is TTabSheet) do
      TabSheet := TabSheet.Parent;
    if Assigned(TabSheet) then
    begin
      TTabSheet(TabSheet).TabVisible := True;
      PageControl1.ActivePage := TTabSheet(TabSheet);
    end;
  end;

  procedure LoadValue(const Value: string; Ctrl: TCustomEdit; Chk: TCheckBox; const Defaut: string); overload;
  begin
    Ctrl.Text := Value;
    Chk.Checked := Value <> Defaut;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: Integer; Ctrl: TEdit; Chk: TCheckBox; Defaut: Integer); overload;
  begin
    Ctrl.Text := NonZero(Value);
    Chk.Checked := Value <> Defaut;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: TStrings; Ctrl: TMemo; Chk: TCheckBox); overload;
  begin
    Ctrl.Lines.Assign(Value);
    Chk.Checked := Value.Text <> '';
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: TStrings; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i, p: Integer;
    s: string;
  begin
    Ctrl.Items.Clear;
    for i := Pred(Value.Count) downto 0 do
    begin
      s := Trim(Value[i]);
      if s = '' then
        Value.Delete(i)
      else
      begin
        p := Pos('=', s);
        if (p > 0) and not IsEqualGUID(StringToGUIDDef(Copy(s, 1, p - 1), GUID_FULL), GUID_FULL) then
          s := Copy(s, p + 1, MaxInt);
        Ctrl.Items.Insert(0, s);
        Ctrl.Checked[0] := True;
      end;
    end;
    Chk.Checked := Ctrl.Items.Count > 0;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: TList<TUniversLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    Ctrl.Items.Clear;
    for i := 0 to Pred(Value.Count) do
    begin
      Ctrl.Items.Add(Value[i].ChaineAffichage);
      Ctrl.Checked[i] := True;
    end;
    Chk.Checked := Ctrl.Items.Count > 0;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(const Value: string; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  begin
    if not Ctrl.Items.Contains(Value) then
      Ctrl.Checked[Ctrl.Items.Add(Value)] := True;
    Chk.Checked := Ctrl.Items.Count > 0;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: TList<TAuteurAlbumLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    Ctrl.Items.Clear;
    for i := 0 to Pred(Value.Count) do
    begin
      Ctrl.Items.Add(Value[i].Personne.ChaineAffichage);
      Ctrl.Checked[i] := True;
    end;
    Chk.Checked := Ctrl.Items.Count > 0;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: TList<TCouvertureLite>; Ctrl: TCheckListBox; Chk: TCheckBox); overload;
  var
    i: Integer;
  begin
    Ctrl.Items.Clear;
    for i := 0 to Pred(Value.Count) do
    begin
      if Value[i].sCategorie <> '' then
        Ctrl.Items.Add(Value[i].sCategorie)
      else
        Ctrl.Items.Add(TPath.GetFileName(Value[i].NewNom));
      Ctrl.Checked[i] := True;
    end;
    Chk.Checked := Ctrl.Items.Count > 0;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: Boolean; Ctrl: TPanel; Chk: TCheckBox; Defaut: Boolean); overload;
  begin
    Chk.Checked := Defaut <> Value;
    TRadioButton(Ctrl.Controls[0]).Checked := Value;
    TRadioButton(Ctrl.Controls[1]).Checked := not Value;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(Value: RTriStateValue; Ctrl: TPanel; Chk: TCheckBox; Defaut: RTriStateValue); overload;
  begin
    Chk.Checked := Defaut <> Value;
    TRadioButton(Ctrl.Controls[0]).Checked := Value.AsBoolean[False];
    TRadioButton(Ctrl.Controls[1]).Checked := not Value.AsBoolean[True];
    TRadioButton(Ctrl.Controls[2]).Checked := Value.Undefined;
    ChangeState(Chk, Ctrl);
  end;

  procedure LoadValue(const Value: string; Ctrl: TLightComboCheck; Chk: TCheckBox); overload;
  var
    CtrlValue: Integer;
  begin
    CtrlValue := Ctrl.GetValue(Value);
    if CtrlValue = Ctrl.DefaultValueUnchecked then
      Exit;

    Ctrl.Value := CtrlValue;
    Chk.Checked := CtrlValue <> Ctrl.DefaultValueChecked;
    ChangeState(Chk, Ctrl);
  end;

begin
  case AId of
    // Album
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TITRE:
      LoadValue(AValue, edTitreAlbum, CheckBox1, DefaultValues.TitreAlbum);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Mois:
      LoadValue(AValue.ToInteger, edMoisParution, CheckBox3, DefaultValues.MoisParution);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Annee:
      LoadValue(AValue.ToInteger, edAnneeParution, CheckBox4, DefaultValues.AnneeParution);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Tome:
      LoadValue(AValue.ToInteger, edTome, CheckBox2, DefaultValues.Tome);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeDebut, BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeFin:
      begin
        if AId = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeDebut then
          LoadValue(AValue.ToInteger, edTomeDebut, CheckBox7, DefaultValues.TomeDebut)
        else
          LoadValue(AValue.ToInteger, edTomeFin, CheckBox7, DefaultValues.TomeFin);
        CheckBox7.Checked := (edTomeDebut.Text <> NonZero(DefaultValues.TomeDebut)) and (edTomeFin.Text <> NonZero(DefaultValues.TomeFin));
        ChangeState(CheckBox7, edTomeDebut);
        ChangeState(CheckBox7, edTomeFin);
      end;
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_HorsSerie:
      LoadValue(AValue.ToBoolean, pnHorsSerie, CheckBox5, DefaultValues.HorsSerie);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Integrale:
      LoadValue(AValue.ToBoolean, pnIntegrale, CheckBox6, DefaultValues.Integrale);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Scenaristes:
      LoadValue(AValue, cklScenaristes, CheckBox8);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Dessinateurs:
      LoadValue(AValue, cklDessinateurs, CheckBox9);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Coloristes:
      LoadValue(AValue, cklColoristes, CheckBox10);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Sujet:
      LoadValue(AValue, mmResumeAlbum, CheckBox11, DefaultValues.Sujet);
    BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Notes:
      LoadValue(AValue, mmNotesAlbum, CheckBox12, DefaultValues.Notes);
    // Série
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_TITRE:
      LoadValue(AValue, edTitreSerie, CheckBox13, DefaultValues.Serie.TitreSerie);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_SiteWeb:
      LoadValue(AValue, edSiteWebSerie, CheckBox16, DefaultValues.Serie.SiteWeb);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Univers:
      LoadValue(AValue, cklUnivers, CheckBox19);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_NbAlbums:
      LoadValue(AValue.ToInteger, edNbAlbums, CheckBoxLabeled8, DefaultValues.Serie.NbAlbums);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Terminee:
      LoadValue(AValue.ToBoolean, pnTerminee, CheckBox14, DefaultValues.Serie.Terminee);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Genres:
      LoadValue(AValue, cklGenres, CheckBox15);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Scenaristes:
      LoadValue(AValue, cklScenaristesSerie, CheckBoxLabeled2);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Dessinateurs:
      LoadValue(AValue, cklDessinateursSerie, CheckBoxLabeled3);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Coloristes:
      LoadValue(AValue, cklColoristesSerie, CheckBoxLabeled4);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Sujet:
      LoadValue(AValue, mmResumeSerie, CheckBox17, DefaultValues.Serie.Sujet);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Notes:
      LoadValue(AValue, mmNotesSerie, CheckBox18, DefaultValues.Serie.Notes);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Editeur_NomEditeur:
      LoadValue(AValue, edNomEditeurSerie, CheckBoxLabeled5, DefaultValues.Serie.Editeur.NomEditeur);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Editeur_SiteWeb:
      LoadValue(AValue, edSiteWebEditeurSerie, CheckBoxLabeled6, DefaultValues.Serie.Editeur.SiteWeb);
    BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Collection_NomCollection:
      LoadValue(AValue, edCollectionSerie, CheckBoxLabeled7, DefaultValues.Serie.Collection.NomCollection);
  // Edition
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Editeur_NomEditeur:
      LoadValue(AValue, edNomEditeur, CheckBox20, DefaultEdition.Editeur.NomEditeur);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Editeur_SiteWeb:
      LoadValue(AValue, edSiteWebEditeur, CheckBox21, DefaultEdition.Editeur.SiteWeb);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Collection_NomCollection:
      LoadValue(AValue, edCollection, CheckBox22, DefaultEdition.Collection.NomCollection);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_AnneeEdition:
      LoadValue(AValue.ToInteger, edAnneeEdition, CheckBox29, DefaultEdition.AnneeEdition);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Prix:
      LoadValue(BDCurrencyToStr(AValue.ToDouble), edPrix, Label9, BDCurrencyToStr(DefaultEdition.Prix));
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Gratuit:
      LoadValue(AValue.ToBoolean, pnGratuit, CheckBox30, DefaultEdition.Gratuit);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_ISBN:
      LoadValue(AValue, edISBN, Label11, DefaultEdition.ISBN);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Etat:
      LoadValue(AValue, cbxEtat, CheckBox23);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_TypeEdition:
      LoadValue(AValue, cbxEdition, CheckBox24);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Reliure:
      LoadValue(AValue, cbxReliure, CheckBox25);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Orientation:
      LoadValue(AValue, cbxOrientation, CheckBox26);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_SensLecture:
      LoadValue(AValue, cbxSensLecture, CheckBox27);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_FormatEdition:
      LoadValue(AValue, cbxFormat, CheckBox28);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_AnneeCote:
      LoadValue(AValue.ToInteger, edAnneeCote, Label24, DefaultEdition.AnneeCote);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_PrixCote:
      LoadValue(BDCurrencyToStr(AValue.ToDouble), edPrixCote, Label25, BDCurrencyToStr(DefaultEdition.PrixCote));
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Couleur:
      LoadValue(AValue.ToBoolean, pnCouleur, CheckBox31, DefaultEdition.Couleur);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_VO:
      LoadValue(AValue.ToBoolean, pnVO, CheckBox32, DefaultEdition.VO);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_NombreDePages:
      LoadValue(AValue.ToInteger, edNbPages, CheckBox33, DefaultEdition.NombreDePages);
    BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Couvertures:
      // LoadValue(Couvertures, cklImages, CheckBoxLabeled1);
      ;
  end;
end;

end.
