unit UfrmEditParaBD;

interface

uses
  Windows, Messages, SysUtils, System.Types, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, EditLabeled, VirtualTrees, ComCtrls, VDTButton,
  BDTK.GUI.Controls.VirtualTree, ComboCheck, ExtCtrls, Buttons, BDTK.GUI.Frames.QuickSearch, Vcl.ExtDlgs, BD.Entities.Full,
  BD.GUI.Frames.Buttons, BD.GUI.Forms, PngSpeedButton, UframVTEdit, Vcl.Menus,
  BD.Utils.IOUtils, ActiveX;

type
  TfrmEditParaBD = class(TbdtForm)
    ScrollBox: TScrollBox;
    Label2: TLabel;
    Label6: TLabel;
    btCreateur: TVDTButton;
    Label19: TLabel;
    Bevel1: TBevel;
    Label20: TLabel;
    Bevel4: TBevel;
    edTitre: TEditLabeled;
    edDescription: TMemoLabeled;
    lvAuteurs: TVDTListViewLabeled;
    Label24: TLabel;
    edAnneeCote: TEditLabeled;
    Label25: TLabel;
    edPrixCote: TEditLabeled;
    VDTButton14: TVDTButton;
    Label10: TLabel;
    edAnneeEdition: TEditLabeled;
    cbStock: TCheckBoxLabeled;
    cbGratuit: TCheckBoxLabeled;
    cbOffert: TCheckBoxLabeled;
    dtpAchat: TDateTimePickerLabeled;
    Label18: TLabel;
    Label9: TLabel;
    edPrix: TEditLabeled;
    SpeedButton3: TVDTButton;
    cbDedicace: TCheckBoxLabeled;
    Label12: TLabel;
    cbxCategorie: TLightComboCheck;
    ChoixImageDialog: TOpenPictureDialog;
    Frame11: TframBoutons;
    Bevel2: TBevel;
    vtEditSeries: TframVTEdit;
    vtEditPersonnes: TframVTEdit;
    Bevel3: TBevel;
    Label28: TLabel;
    vtEditUnivers: TframVTEdit;
    Label11: TLabel;
    lvUnivers: TVDTListViewLabeled;
    btUnivers: TVDTButton;
    ChoixImage: TVDTButton;
    vstImages: TVirtualStringTree;
    VDTButton5: TVDTButton;
    VDTButton4: TVDTButton;
    Bevel5: TBevel;
    cbNumerote: TCheckBoxLabeled;
    pmChoixCategorie: TPopupMenu;
    Label1: TLabel;
    edNotes: TMemoLabeled;
    imgVisu: TImage;
    procedure cbOffertClick(Sender: TObject);
    procedure cbGratuitClick(Sender: TObject);
    procedure edPrixChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton14Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ChoixImageClick(Sender: TObject);
    procedure btCreateurClick(Sender: TObject);
    procedure lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lvAuteursData(Sender: TObject; Item: TListItem);
    procedure cbxCategorieChange(Sender: TObject);
    procedure vtEditSeriesVTEditChange(Sender: TObject);
    procedure vtEditPersonnesVTEditChange(Sender: TObject);
    procedure OnEditPersonnes(Sender: TObject);
    procedure vtEditUniversVTEditChange(Sender: TObject);
    procedure btUniversClick(Sender: TObject);
    procedure lvUniversData(Sender: TObject; Item: TListItem);
    procedure lvUniversKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstImagesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstImagesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstImagesDblClick(Sender: TObject);
    procedure vstImagesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstImagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstImagesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstImagesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstImagesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstImagesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstImagesStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
    procedure VDTButton4Click(Sender: TObject);
    procedure VDTButton5Click(Sender: TObject);
    procedure vstImagesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pmChoixCategoriePopup(Sender: TObject);
    procedure miChangeCategorieImageClick(Sender: TObject);
    procedure imgVisuClick(Sender: TObject);
    procedure vstImagesDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure vstImagesDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
  private
    FCreation: Boolean;
    FisAchat: Boolean;
    FParaBD: TParaBDFull;
    FDateAchat: TDateTime;
    procedure SetParaBD(const Value: TParaBDFull);
    function GetID_ParaBD: TGUID;
    procedure VisuClose(Sender: TObject);
    procedure AddImageFiles(AImageList: TStrings; AAtPosition: Integer = -1);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isCreation: Boolean read FCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property ID_ParaBD: TGUID read GetID_ParaBD;
    property ParaBD: TParaBDFull read FParaBD write SetParaBD;
  end;

  TFrmEditAchatParaBD = class(TfrmEditParaBD)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Math, BD.Utils.StrUtils, BD.Common, BD.Strings, BD.Utils.GUIUtils, BDTK.GUI.Utils, jpeg, Proc_Gestions, BD.Entities.Lite, Divers, UHistorique,
  BD.Entities.Metadata, BDTK.Entities.Dao.Lite, BDTK.Entities.Dao.Full, BD.Entities.Common,
  BD.Entities.Factory.Lite, BD.Entities.Dao.Lambda, BD.Entities.Types;

{$R *.dfm}
{ TFrmEditAchatParaBD }

constructor TFrmEditAchatParaBD.Create(AOwner: TComponent);
begin
  inherited;
  FisAchat := True;
end;

{ TFrmEditParaBD }

procedure TfrmEditParaBD.SetParaBD(const Value: TParaBDFull);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FParaBD := Value;

  edTitre.Text := FParaBD.TitreParaBD;
  edAnneeEdition.Text := NonZero(IntToStr(FParaBD.AnneeEdition));
  cbxCategorie.Value := FParaBD.CategorieParaBD.Value;
  cbDedicace.Checked := FParaBD.Dedicace;
  cbNumerote.Checked := FParaBD.Numerote;
  edDescription.Text := FParaBD.Description;
  edNotes.Text := FParaBD.Notes;

  vtEditSeries.VTEdit.OnChange := nil;
  vtEditSeries.CurrentValue := FParaBD.Serie.ID_Serie;
  vtEditSeries.VTEdit.OnChange := vtEditSeriesVTEditChange;

  cbOffert.Checked := FParaBD.Offert;
  cbGratuit.Checked := FParaBD.Gratuit;
  cbOffertClick(nil);

  // artifice pour contourner un bug du TDateTimePicker
  // dtpAchat est initialisé dans le OnShow de la fenêtre
  FDateAchat := FParaBD.DateAchat;

  if FParaBD.Prix = 0 then
    edPrix.Text := ''
  else
    edPrix.Text := BDCurrencyToStr(FParaBD.Prix);
  edAnneeCote.Text := NonZero(IntToStr(FParaBD.AnneeCote));
  if FParaBD.PrixCote = 0 then
    edPrixCote.Text := ''
  else
    edPrixCote.Text := BDCurrencyToStr(FParaBD.PrixCote);
  cbStock.Checked := FParaBD.Stock;

  lvUnivers.Items.BeginUpdate;
  lvAuteurs.Items.BeginUpdate;

  lvUnivers.Items.Count := FParaBD.Univers.Count;
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;

  lvUnivers.Items.EndUpdate;
  lvAuteurs.Items.EndUpdate;

  vstImages.Clear;
  vstImages.RootNodeCount := FParaBD.Photos.Count;
  vstImages.Selected[vstImages.GetFirst] := True;
  vstImages.FocusedNode := vstImages.GetFirst;
end;

procedure TfrmEditParaBD.cbOffertClick(Sender: TObject);
begin
  if cbOffert.Checked then
    Label18.Caption := rsTransOffertLe
  else
    Label18.Caption := rsTransAcheteLe;
end;

procedure TfrmEditParaBD.cbGratuitClick(Sender: TObject);
begin
  if cbGratuit.Checked then
    edPrix.Text := '';
end;

procedure TfrmEditParaBD.edPrixChange(Sender: TObject);
begin
  if edPrix.Text <> '' then
    cbGratuit.Checked := False;
end;

procedure TfrmEditParaBD.SpeedButton3Click(Sender: TObject);
var
  c: Currency;
begin
  c := BDStrToDoubleDef(edPrix.Text, 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrix.Focused then
      edPrix.Text := BDDoubleToStr(c)
    else
      edPrix.Text := BDCurrencyToStr(c);
end;

procedure TfrmEditParaBD.VDTButton14Click(Sender: TObject);
var
  c: Currency;
begin
  c := BDStrToDoubleDef(edPrixCote.Text, 0);
  if Convertisseur(VDTButton14, c) then
    if edPrixCote.Focused then
      edPrixCote.Text := BDDoubleToStr(c)
    else
      edPrixCote.Text := BDCurrencyToStr(c);
end;

procedure TfrmEditParaBD.VDTButton4Click(Sender: TObject);
begin
  FParaBD.Photos.Move(vstImages.FocusedNode.Index, Pred(vstImages.FocusedNode.Index));
  vstImages.FocusedNode := vstImages.FocusedNode.PrevSibling;
  vstImages.Selected[vstImages.FocusedNode] := True;
  vstImages.Invalidate;
end;

procedure TfrmEditParaBD.VDTButton5Click(Sender: TObject);
begin
  FParaBD.Photos.Move(vstImages.FocusedNode.Index, Succ(vstImages.FocusedNode.Index));
  vstImages.FocusedNode := vstImages.FocusedNode.NextSibling;
  vstImages.Selected[vstImages.FocusedNode] := True;
  vstImages.Invalidate;
end;

procedure TfrmEditParaBD.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

procedure TfrmEditParaBD.FormCreate(Sender: TObject);
var
  i: Integer;
  mi: TMenuItem;
begin
  PrepareLV(Self);
  vtEditSeries.Mode := vmSeries;
  vtEditSeries.VTEdit.LinkControls.Add(Label20);
  vtEditUnivers.Mode := vmUnivers;
  vtEditUnivers.VTEdit.LinkControls.Add(Label11);
  vtEditPersonnes.Mode := vmPersonnes;
  vtEditPersonnes.VTEdit.LinkControls.Add(Label19);
  vtEditPersonnes.AfterEdit := OnEditPersonnes;

  vstImages.LinkControls.Clear;
  vstImages.LinkControls.Add(ChoixImage);
  vstImages.LinkControls.Add(VDTButton4);
  vstImages.LinkControls.Add(VDTButton5);
  vstImages.Mode := vmNone;
  vstImages.TreeOptions.StringOptions := [];
  vstImages.TreeOptions.MiscOptions := vstImages.TreeOptions.MiscOptions + [toCheckSupport];
  vstImages.TreeOptions.PaintOptions := vstImages.TreeOptions.PaintOptions - [toShowButtons, toShowRoot, toShowTreeLines];

  LoadCombo(cbxCategorie, TDaoListe.ListCategoriesParaBD, TDaoListe.DefaultCategorieParaBD);

  for i := 0 to Pred(TDaoListe.ListTypesPhoto.Count) do
  begin
    mi := TMenuItem.Create(pmChoixCategorie);
    mi.Caption := TDaoListe.ListTypesPhoto.ValueFromIndex[i];
    mi.Tag := StrToInt(TDaoListe.ListTypesPhoto.Names[i]);
    mi.OnClick := miChangeCategorieImageClick;
    pmChoixCategorie.Items.Add(mi);
  end;
end;

procedure TfrmEditParaBD.btnOKClick(Sender: TObject);
var
  AnneeCote: Integer;
  PrixCote: Currency;
  hg: IHourGlass;
begin
  if TGlobalVar.Utilisateur.Options.SerieObligatoireParaBD and IsEqualGUID(vtEditSeries.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
    vtEditSeries.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtEditSeries.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsTitreObligatoireParaBDSansSerie, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if cbxCategorie.Value = -1 then
  begin
    AffMessage(rsTypeParaBDObligatoire, mtInformation, [mbOk], True);
    // cbxType.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  AnneeCote := StrToIntDef(edAnneeCote.Text, 0);
  PrixCote := BDStrToDoubleDef(edPrixCote.Text, 0);
  if (AnneeCote * PrixCote = 0) and (AnneeCote + PrixCote <> 0) then
  begin
    // une cote doit être composée d'une année ET d'un prix
    AffMessage(rsCoteIncomplete, mtInformation, [mbOk], True);
    edAnneeCote.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;

  FParaBD.TitreParaBD := Trim(edTitre.Text);
  FParaBD.AnneeEdition := StrToIntDef(edAnneeEdition.Text, 0);
  FParaBD.CategorieParaBD := ROption.Create(cbxCategorie.Value, cbxCategorie.Caption);
  FParaBD.Dedicace := cbDedicace.Checked;
  FParaBD.Numerote := cbNumerote.Checked;
  FParaBD.Description := edDescription.Text;
  FParaBD.Notes := edNotes.Text;
  FParaBD.AnneeCote := AnneeCote;
  FParaBD.PrixCote := PrixCote;
  FParaBD.Gratuit := cbGratuit.Checked;
  FParaBD.Offert := cbOffert.Checked;
  if dtpAchat.Checked then
    FParaBD.DateAchat := Trunc(dtpAchat.Date)
  else
    FParaBD.DateAchat := 0;
  FParaBD.Prix := BDStrToDoubleDef(edPrix.Text, 0);
  FParaBD.Stock := cbStock.Checked;

  TDaoParaBDFull.SaveToDatabase(FParaBD, nil);
  if isAchat then
    TDaoParaBDFull.Acheter(FParaBD, False);

  ModalResult := mrOk;
end;

procedure TfrmEditParaBD.btUniversClick(Sender: TObject);
begin
  if IsEqualGUID(vtEditUnivers.CurrentValue, GUID_NULL) then
    Exit;

  FParaBD.Univers.Add(TFactoryUniversLite.Duplicate(TUniversLite(vtEditUnivers.VTEdit.Data)));
  lvUnivers.Items.Count := FParaBD.Univers.Count;
  lvUnivers.Invalidate;

  vtEditUniversVTEditChange(vtEditUnivers.VTEdit);
end;

procedure TfrmEditParaBD.AddImageFiles(AImageList: TStrings; AAtPosition: Integer);
var
  GraphicMasks: TArray<string>;
  Filename: string;
  PP: TPhotoLite;
begin
  GraphicMasks := SplitMasks(GraphicFilter(TGraphic));

  if not InRange(AAtPosition, 0, Pred(FParaBD.Photos.Count)) then
    AAtPosition := FParaBD.Photos.Count;

  vstImages.BeginUpdate;
  try
    for Filename in AImageList do
    if MatchesMasks(Filename, GraphicMasks) then
    begin
      PP := TFactoryPhotoLite.getInstance;
      FParaBD.Photos.Insert(AAtPosition, PP);
      PP.ID := GUID_NULL;
      PP.OldNom := Filename;
      PP.NewNom := PP.OldNom;
    end;
  finally
    vstImages.RootNodeCount := FParaBD.Photos.Count;
    vstImages.EndUpdate;
  end;
end;

procedure TfrmEditParaBD.ChoixImageClick(Sender: TObject);
begin
  ChoixImageDialog.Options := ChoixImageDialog.Options + [ofAllowMultiSelect];
  ChoixImageDialog.Filter := GraphicFilter(TGraphic);
  ChoixImageDialog.InitialDir := RepImages;
  ChoixImageDialog.FileName := '';
  if ChoixImageDialog.Execute then
    AddImageFiles(ChoixImageDialog.Files);
end;

procedure TfrmEditParaBD.vstImagesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  PP: TPhotoLite;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
begin
  VDTButton4.Enabled := Assigned(Node) and (Node.Index > 0);
  VDTButton5.Enabled := Assigned(Node) and (Node.Index < Pred(vstImages.RootNodeCount));

  if Assigned(Node) then
  begin
    PP := FParaBD.Photos[Node.Index];
    hg := THourGlass.Create;
    if IsEqualGUID(PP.ID, GUID_NULL) then
      ms := GetJPEGStream(PP.NewNom, imgVisu.Height, imgVisu.Width, TGlobalVar.Utilisateur.Options.AntiAliasing)
    else
      ms := GetCouvertureStream(True, PP.ID, imgVisu.Height, imgVisu.Width, TGlobalVar.Utilisateur.Options.AntiAliasing);
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

procedure TfrmEditParaBD.vstImagesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FParaBD.Photos[Node.Index].NewStockee := (Node.CheckState = csCheckedNormal);
end;

procedure TfrmEditParaBD.vstImagesDblClick(Sender: TObject);
var
  PP: TPhotoLite;
begin
  if not Assigned(vstImages.FocusedNode) then
    Exit;
  PP := FParaBD.Photos[vstImages.FocusedNode.Index];
  if IsEqualGUID(PP.ID, GUID_NULL) then
  begin
    ChoixImageDialog.Options := ChoixImageDialog.Options - [ofAllowMultiSelect];
    ChoixImageDialog.FileName := PP.NewNom;
    if ChoixImageDialog.Execute then
    begin
      PP.NewNom := ChoixImageDialog.FileName;
      vstImages.InvalidateNode(vstImages.FocusedNode);
    end;
  end;
end;

procedure TfrmEditParaBD.vstImagesDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  Fmt: Word;
  FilesList: TStringList;
  Position: Integer;
begin
  inherited;
  case Mode of
    dmOnNode, dmBelow:
      Position := vstImages.DropTargetNode.Index + 1;
    dmAbove:
      Position := vstImages.DropTargetNode.Index;
    else
      Position := -1;
  end;

  for Fmt in Formats do
    if Fmt = CF_HDROP then
    begin
      FilesList := TStringList.Create;
      try
        GetFileListFromExplorerDropObj(DataObject, FilesList);
        AddImageFiles(FilesList, Position);
      finally
        FilesList.Free;
      end;
      Exit;
    end;
end;

procedure TfrmEditParaBD.vstImagesDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  inherited;
  Accept := Source = nil; // means from external source ??
end;

procedure TfrmEditParaBD.vstImagesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
// var
// PP: TPhotoLite;
begin
  // PP := FParaBD.Photos[Node.Index];
  // Allowed := (PP.Reference <> -1) and (PP.NewStockee) and (PP.NewStockee = PP.OldStockee);

  // devrait être autorisé aussi pour changer le nom de l'image
  // l'édition de la catégorie d'image n'est pas gérée par le virtualtreeview
  Allowed := False;
end;

procedure TfrmEditParaBD.vstImagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  PP: TPhotoLite;
begin
  PP := FParaBD.Photos[Node.Index];
  CellText := '';
  case Column of
    0:
      CellText := PP.NewNom;
    1:
      CellText := PP.sCategorie;
  end;
end;

procedure TfrmEditParaBD.vstImagesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  PP: TPhotoLite;
begin
  PP := FParaBD.Photos[Node.Index];
  Node.CheckType := ctCheckBox;
  if PP.NewStockee then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmEditParaBD.vstImagesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    FParaBD.Photos.Delete(vstImages.FocusedNode.Index);
    vstImages.RootNodeCount := FParaBD.Photos.Count;
    imgVisu.Picture.Assign(nil);
    vstImages.ReinitNode(vstImages.RootNode, True);
  end;
end;

procedure TfrmEditParaBD.vstImagesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  Node: PVirtualNode;
  DisplayRect: TRect;
begin
  Node := vstImages.GetNodeAt(X, Y);
  if (Node <> nil) and (vstImages.Header.Columns.ColumnFromPosition(Point(X, Y)) = 1) then
  begin
    DisplayRect := vstImages.GetDisplayRect(Node, 1, False);
    pt := vstImages.ClientToScreen(Point(DisplayRect.Left, DisplayRect.Bottom));
    pmChoixCategorie.PopupComponent := TComponent(Node.Index);
    pmChoixCategorie.Tag := FParaBD.Photos[Node.Index].Categorie;
    pmChoixCategorie.Popup(pt.X, pt.Y);
  end;
end;

procedure TfrmEditParaBD.vstImagesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  PP: TPhotoLite;
begin
  PP := FParaBD.Photos[Node.Index];
  case Column of
    0:
      PP.NewNom := NewText;
  end;
end;

procedure TfrmEditParaBD.vstImagesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  PP: TPhotoLite;
begin
  PP := FParaBD.Photos[Node.Index];
  if (Column = 0) and (not IsEqualGUID(PP.ID, GUID_NULL)) then
    if vstImages.Selected[Node] then
      TargetCanvas.Font.Color := clInactiveCaption
    else
      TargetCanvas.Font.Color := clInactiveCaptionText;
end;

procedure TfrmEditParaBD.vstImagesStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
begin
  vstImagesChange(Sender, vstImages.FocusedNode);
end;

procedure TfrmEditParaBD.vtEditPersonnesVTEditChange(Sender: TObject);
var
  IdPersonne: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do
    begin
      Result := not IsEqualGUID(TAuteurLite(LV.Items[i].Data).Personne.ID, IdPersonne);
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtEditPersonnes.CurrentValue;
  btCreateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvAuteurs);
end;

procedure TfrmEditParaBD.vtEditSeriesVTEditChange(Sender: TObject);
begin
  TDaoSerieFull.Fill(FParaBD.Serie, vtEditSeries.CurrentValue, nil);
end;

procedure TfrmEditParaBD.vtEditUniversVTEditChange(Sender: TObject);
var
  IdUnivers: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do
    begin
      Result := not IsEqualGUID(TUniversLite(LV.Items[i].Data).ID, IdUnivers);
      Inc(i);
    end;
  end;

begin
  IdUnivers := vtEditUnivers.CurrentValue;
  btUnivers.Enabled := (not IsEqualGUID(IdUnivers, GUID_NULL)) and NotIn(lvUnivers);
end;

procedure TfrmEditParaBD.OnEditPersonnes(Sender: TObject);
var
  i: Integer;
  Auteur: TAuteurLite;
  CurrentAuteur: TPersonnageLite;
begin
  CurrentAuteur := vtEditPersonnes.VTEdit.Data as TPersonnageLite;
  for i := 0 to Pred(lvAuteurs.Items.Count) do
  begin
    Auteur := lvAuteurs.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvAuteurs.Items[i].Caption := Auteur.ChaineAffichage;
    end;
  end;
  lvAuteurs.Invalidate;
end;

procedure TfrmEditParaBD.pmChoixCategoriePopup(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  for MenuItem in pmChoixCategorie.Items do
    MenuItem.Checked := pmChoixCategorie.Tag = MenuItem.Tag;
end;

procedure TfrmEditParaBD.btCreateurClick(Sender: TObject);
var
  PA: TAuteurParaBDLite;
begin
  if IsEqualGUID(vtEditPersonnes.CurrentValue, GUID_NULL) then
    Exit;
  PA := TFactoryAuteurParaBDLite.getInstance;
  TDaoAuteurParaBDLite.Fill(PA, TPersonnageLite(vtEditPersonnes.VTEdit.Data), ID_ParaBD);
  FParaBD.Auteurs.Add(PA);
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;
  lvAuteurs.Invalidate;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditParaBD.lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  if src = lvAuteurs then
    FParaBD.Auteurs.Delete(src.Selected.Index);
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;
  src.Invalidate;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditParaBD.lvUniversData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.Univers[Item.Index];
  Item.Caption := TUniversLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditParaBD.lvUniversKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  if src = lvUnivers then
    FParaBD.Univers.Delete(src.Selected.Index);
  lvUnivers.Items.Count := FParaBD.Univers.Count;
  src.Invalidate;
  vtEditUniversVTEditChange(vtEditUnivers.VTEdit);
end;

procedure TfrmEditParaBD.miChangeCategorieImageClick(Sender: TObject);
var
  PP: TPhotoLite;
begin
  PP := FParaBD.Photos[Integer(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent)];
  PP.Categorie := Integer(TMenuItem(Sender).Tag);
  PP.sCategorie := TDaoListe.ListTypesPhoto.Values[IntToStr(PP.Categorie)];
  vstImages.Invalidate;
end;

procedure TfrmEditParaBD.FormShow(Sender: TObject);
begin
  // code pour contourner un bug du TDateTimePicker
  // Cheched := False est réinitialisé au premier affichage du compo (à la création de son handle)
  dtpAchat.Date := Now;
  dtpAchat.Checked := FDateAchat > 0;
  if dtpAchat.Checked then
    dtpAchat.Date := FDateAchat;
  edTitre.SetFocus;
end;

function TfrmEditParaBD.GetID_ParaBD: TGUID;
begin
  Result := FParaBD.ID_ParaBD;
end;

procedure TfrmEditParaBD.VisuClose(Sender: TObject);
begin
  TForm(TImage(Sender).Parent).ModalResult := mrCancel;
end;

procedure TfrmEditParaBD.imgVisuClick(Sender: TObject);
var
  PP: TPhotoLite;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
  Couverture: TImage;
  frm: TForm;
begin
  if not Assigned(vstImages.FocusedNode) then
    Exit;
  PP := FParaBD.Photos[vstImages.FocusedNode.Index];
  hg := THourGlass.Create;
  if IsEqualGUID(PP.ID, GUID_NULL) then
    ms := GetJPEGStream(PP.NewNom, 400, 500, TGlobalVar.Utilisateur.Options.AntiAliasing)
  else
    ms := GetCouvertureStream(True, PP.ID, 400, 500, TGlobalVar.Utilisateur.Options.AntiAliasing);
  if Assigned(ms) then
    try
      jpg := TJPEGImage.Create;
      frm := TbdtForm.Create(Self);
      Couverture := TImage.Create(frm);
      try
        jpg.LoadFromStream(ms);
        frm.BorderIcons := [];
        frm.BorderStyle := bsToolWindow;
        frm.Position := poOwnerFormCenter;
        Couverture.Parent := frm;
        Couverture.Picture.Assign(jpg);
        Couverture.Cursor := crHandPoint;
        Couverture.OnClick := VisuClose;
        Couverture.AutoSize := True;
        frm.AutoSize := True;
        frm.ShowModal;
      finally
        FreeAndNil(jpg);
        FreeAndNil(Couverture);
        FreeAndNil(frm);
      end;
    finally
      FreeAndNil(ms);
    end;
end;

procedure TfrmEditParaBD.lvAuteursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.Auteurs[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditParaBD.cbxCategorieChange(Sender: TObject);
begin
  if cbxCategorie.Value = 700 then
    btCreateur.Caption := 'Auteur'
  else
    btCreateur.Caption := 'Créateur';
end;

end.
