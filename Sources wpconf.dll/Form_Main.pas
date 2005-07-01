unit Form_Main;

interface

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Spin, UCommon, UOptions,
  Registry, Menus, GraphicEx, ComCtrls, Divers, FileCtrl, Browss, CheckLst, IniFiles, UInterfacePlugIn;

type
  TFond = class(TForm)
    Button3: TButton;
    Button5: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    cHistorique: TSpinEdit;
    Label6: TLabel;
    Label4: TLabel;
    cRepertoires: TCheckListBox;
    Button1: TButton;
    Label8: TLabel;
    cTypesImages: TCheckListBox;
    cAliasing: TCheckBox;
    cDemarrageWindows: TCheckBox;
    TabSheet3: TTabSheet;
    CheckBox6: TCheckBox;
    TabSheet5: TTabSheet;
    cCalendrier_UseCalendrier: TCheckBox;
    TabSheet6: TTabSheet;
    cExclusions: TListBox;
    Label16: TLabel;
    Button9: TButton;
    DlgBrowseDirectory1: TBrowseDirectoryDlg;
    cActif: TCheckBox;
    Label17: TLabel;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    Image2: TImage;
    Image5: TImage;
    Image7: TImage;
    OpenDialogArchive: TOpenDialog;
    Button2: TButton;
    Button4: TButton;
    TabSheet7: TTabSheet;
    DateTimePicker1: TDateTimePicker;
    Button10: TButton;
    Image4: TImage;
    cCheckTime: TCheckListBox;
    Label20: TLabel;
    Label3: TLabel;
    cInterval: TSpinEdit;
    Label19: TLabel;
    cDemarrage: TCheckBox;
    OpenDialogExclu: TOpenDialog;
    Label32: TLabel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Label33: TLabel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Label34: TLabel;
    Label36: TLabel;
    cActionDoubleClick: TComboBox;
    cTypesArchives: TCheckListBox;
    Label35: TLabel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Label37: TLabel;
    Button11: TButton;
    PageControl2: TPageControl;
    TabSheet8: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Label38: TLabel;
    Bevel2: TBevel;
    cCalendrier_PremierJourSemaine: TComboBox;
    cCalendrier_WeekEnd: TCheckListBox;
    cCalendrier_JoursFeries: TListBox;
    Button13: TButton;
    Button12: TButton;
    TabSheet9: TTabSheet;
    Bevel3: TBevel;
    Label26: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label29: TLabel;
    cCalendrier_FontColorFerie: TColorBox;
    cCalendrier_FontColorWE: TColorBox;
    cCalendrier_FontColor: TColorBox;
    cCalendrier_FontColorTitreAutre: TColorBox;
    cCalendrier_FontColorTitre: TColorBox;
    Bevel13: TBevel;
    Label7: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    cCalendrier_FontColorSemaine: TColorBox;
    Panel1: TPanel;
    Image1: TImage;
    Panel4: TPanel;
    cSauveRegistry: TRadioButton;
    cSauveIni: TRadioButton;
    Label42: TLabel;
    TabSheet10: TTabSheet;
    Label43: TLabel;
    Panel6: TPanel;
    Label45: TLabel;
    cResolutionBureau: TRadioButton;
    cResolutionEcran: TRadioButton;
    Label44: TLabel;
    TabSheet11: TTabSheet;
    cLegende_UseLegende: TCheckBox;
    PageControl3: TPageControl;
    TabSheet13: TTabSheet;
    Bevel17: TBevel;
    Label65: TLabel;
    Label66: TLabel;
    Label70: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    cLegende_FontColor: TColorBox;
    cLegende_Font: TComboBox;
    cLegende_FontSize: TSpinEdit;
    cLegende_Effet3D: TCheckBox;
    cLegende_Trame: TSpinEdit;
    TabSheet14: TTabSheet;
    Label82: TLabel;
    Bevel19: TBevel;
    Panel7: TPanel;
    PaintBox2: TPaintBox;
    cLegende_Position_X: TTrackBar;
    cLegende_Position_Y: TTrackBar;
    cLegende_Position1: TRadioButton;
    cLegende_Position4: TRadioButton;
    cLegende_Position7: TRadioButton;
    cLegende_Position5: TRadioButton;
    cLegende_Position8: TRadioButton;
    cLegende_Position2: TRadioButton;
    cLegende_Position3: TRadioButton;
    cLegende_Position6: TRadioButton;
    cLegende_Position9: TRadioButton;
    cLegende_Position0: TRadioButton;
    CheckBox24: TCheckBox;
    TabSheet12: TTabSheet;
    Panel8: TPanel;
    cLegende_Fichier0: TRadioButton;
    cLegende_Fichier1: TRadioButton;
    cLegende_Fichier2: TRadioButton;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    cLegende_TrameColor: TColorBox;
    Panel9: TPanel;
    Image8: TImage;
    TabSheet15: TTabSheet;
    cPlugins: TCheckListBox;
    Image6: TImage;
    Label64: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Memo2: TMemo;
    Label69: TLabel;
    Label71: TLabel;
    OpenDialogPlugins: TOpenDialog;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    TabSheet16: TTabSheet;
    TabSheet17: TTabSheet;
    cCalendrier_Avant_Nombre: TSpinEdit;
    cCalendrier_Avant_NumSemaine: TCheckBox;
    cCalendrier_Avant_Ordre: TComboBox;
    cCalendrier_Apres_Nombre: TSpinEdit;
    cCalendrier_Apres_NumSemaine: TCheckBox;
    cCalendrier_Apres_Ordre: TComboBox;
    Label15: TLabel;
    cCalendrier_Font: TComboBox;
    cCalendrier_EnCours_NumSemaine: TCheckBox;
    cCalendrier_Aujourdhui: TCheckBox;
    cCalendrier_Avant_FontSize: TSpinEdit;
    cCalendrier_Avant_Effet3D: TCheckBox;
    Label50: TLabel;
    cCalendrier_Avant_TrameColor: TColorBox;
    cCalendrier_Avant_Trame: TSpinEdit;
    Label51: TLabel;
    Label46: TLabel;
    Label54: TLabel;
    cCalendrier_EnCours_FontSize: TSpinEdit;
    cCalendrier_EnCours_Effet3D: TCheckBox;
    Label22: TLabel;
    cCalendrier_EnCours_TrameColor: TColorBox;
    cCalendrier_EnCours_Trame: TSpinEdit;
    Label23: TLabel;
    cCalendrier_Apres_FontSize: TSpinEdit;
    Label55: TLabel;
    cCalendrier_Apres_Effet3D: TCheckBox;
    Label52: TLabel;
    cCalendrier_Apres_TrameColor: TColorBox;
    cCalendrier_Apres_Trame: TSpinEdit;
    Label53: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    cCalendrier_Avant_Positionnement1: TRadioButton;
    cCalendrier_Avant_Positionnement0: TRadioButton;
    cCalendrier_Apres_Positionnement1: TRadioButton;
    cCalendrier_Apres_Positionnement0: TRadioButton;
    Label63: TLabel;
    Label72: TLabel;
    cCalendrier_Apres_SemaineFontSize: TSpinEdit;
    cCalendrier_Apres_Semaine3D: TCheckBox;
    cCalendrier_Avant_Semaine3D: TCheckBox;
    Label73: TLabel;
    cCalendrier_Avant_SemaineFontSize: TSpinEdit;
    Label74: TLabel;
    cCalendrier_EnCours_Semaine3D: TCheckBox;
    Label75: TLabel;
    cCalendrier_EnCours_SemaineFontSize: TSpinEdit;
    Label78: TLabel;
    cCalendrier_EnCours_CouleurCadre: TColorBox;
    cCalendrier_EnCours_Positionnement0: TRadioButton;
    cCalendrier_EnCours_Positionnement1: TRadioButton;
    Panel13: TPanel;
    cCalendrier_Apres_Position_X: TTrackBar;
    cCalendrier_Apres_Position_Y: TTrackBar;
    cCalendrier_Apres_Position0: TRadioButton;
    Panel11: TPanel;
    PaintBox4: TPaintBox;
    cCalendrier_Apres_Position1: TRadioButton;
    cCalendrier_Apres_Position4: TRadioButton;
    cCalendrier_Apres_Position7: TRadioButton;
    cCalendrier_Apres_Position8: TRadioButton;
    cCalendrier_Apres_Position5: TRadioButton;
    cCalendrier_Apres_Position2: TRadioButton;
    cCalendrier_Apres_Position3: TRadioButton;
    cCalendrier_Apres_Position6: TRadioButton;
    cCalendrier_Apres_Position9: TRadioButton;
    Panel12: TPanel;
    cCalendrier_Avant_Position_X: TTrackBar;
    cCalendrier_Avant_Position_Y: TTrackBar;
    cCalendrier_Avant_Position0: TRadioButton;
    Panel10: TPanel;
    PaintBox3: TPaintBox;
    cCalendrier_Avant_Position1: TRadioButton;
    cCalendrier_Avant_Position4: TRadioButton;
    cCalendrier_Avant_Position7: TRadioButton;
    cCalendrier_Avant_Position8: TRadioButton;
    cCalendrier_Avant_Position5: TRadioButton;
    cCalendrier_Avant_Position2: TRadioButton;
    cCalendrier_Avant_Position3: TRadioButton;
    cCalendrier_Avant_Position6: TRadioButton;
    cCalendrier_Avant_Position9: TRadioButton;
    Panel14: TPanel;
    Panel5: TPanel;
    PaintBox1: TPaintBox;
    cCalendrier_EnCours_Position_X: TTrackBar;
    cCalendrier_EnCours_Position_Y: TTrackBar;
    cCalendrier_EnCours_Position1: TRadioButton;
    cCalendrier_EnCours_Position4: TRadioButton;
    cCalendrier_EnCours_Position7: TRadioButton;
    cCalendrier_EnCours_Position5: TRadioButton;
    cCalendrier_EnCours_Position8: TRadioButton;
    cCalendrier_EnCours_Position2: TRadioButton;
    cCalendrier_EnCours_Position3: TRadioButton;
    cCalendrier_EnCours_Position6: TRadioButton;
    cCalendrier_EnCours_Position9: TRadioButton;
    cCalendrier_EnCours_Position0: TRadioButton;
    cCalendrier_EnCours_Gras: TCheckBox;
    Panel15: TPanel;
    Label48: TLabel;
    Label49: TLabel;
    cCalendrier_Apres_Position: TComboBox;
    cCalendrier_Apres_Alignement: TComboBox;
    Panel16: TPanel;
    Label41: TLabel;
    Label47: TLabel;
    cCalendrier_Avant_Position: TComboBox;
    cCalendrier_Avant_Alignement: TComboBox;
    Label79: TLabel;
    cCalendrier_Avant_Max: TSpinEdit;
    Label80: TLabel;
    cCalendrier_Apres_Max: TSpinEdit;
    Bevel1: TBevel;
    Label81: TLabel;
    Label83: TLabel;
    cPriorite: TComboBox;
    Button19: TButton;
    Label84: TLabel;
    Button14: TButton;
    Button18: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure cCalendrier_UseCalendrierClick(Sender: TObject);
    procedure ComboBox2MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure ComboBox2DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure cExclusionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Button10Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure cCalendrier_PremierJourSemaineChange(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure cCalendrier_JoursFeriesDblClick(Sender: TObject);
    procedure cCalendrier_EnCours_Position0Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure cCalendrier_EnCours_Position_YChange(Sender: TObject);
    procedure cLegende_UseLegendeClick(Sender: TObject);
    procedure cLegende_Position0Click(Sender: TObject);
    procedure cLegende_Position_YChange(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure PaintBox2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure cPluginsClick(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure cCalendrier_Avant_NumSemaineClick(Sender: TObject);
    procedure cCalendrier_EnCours_NumSemaineClick(Sender: TObject);
    procedure cCalendrier_Apres_NumSemaineClick(Sender: TObject);
    procedure PaintBox4Paint(Sender: TObject);
    procedure PaintBox3Paint(Sender: TObject);
    procedure PaintBox3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cCalendrier_Avant_Position1Click(Sender: TObject);
    procedure cCalendrier_Apres_Position0Click(Sender: TObject);
    procedure cCalendrier_Avant_Position_YChange(Sender: TObject);
    procedure cCalendrier_Apres_Position_YChange(Sender: TObject);
    procedure cCalendrier_Apres_Positionnement1Click(Sender: TObject);
    procedure cCalendrier_Avant_Positionnement0Click(Sender: TObject);
    procedure cCalendrier_Apres_NombreChange(Sender: TObject);
    procedure cCalendrier_Avant_NombreChange(Sender: TObject);
    procedure cPluginsDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cPluginsData(Control: TWinControl; Index: Integer;
      var Data: String);
    procedure cPluginsDataObject(Control: TWinControl; Index: Integer;
      var DataObject: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
  private
    { Déclarations privées }
    FCurrentItem: TListItem;
    FModeDebug: Boolean;
    FApplique: Boolean;
    FCurrentImage: string;
    FOptions: ROptions;
    FwasIniFile: Boolean;
    procedure LoadOptions;
    procedure SaveOptions;
    procedure LoadWeek(Debut: Integer);
    procedure SetCurrentImage(const Value: string);
    procedure cExclusionsItemsClear;
    procedure cRepertoiresItemsClear;
  public
    FMainProg: IMainProg;
    constructor Create(ModeDebug: Boolean); reintroduce;
    property Applique: Boolean read FApplique;
    property CurrentImage: string read FCurrentImage write SetCurrentImage;
  end;

implementation

uses Math, UJoursFeries, UInterfaceChange;

{$R *.DFM}

procedure PaintBoxMouseDown(PaintBox: TPaintBox; Button: TRadioButton; TrackBarX, TrackBarY: TTrackBar; X, Y: Integer);
begin
  Button.Checked := True;
  TrackBarX.Position := X * 100 div PaintBox.Width;
  TrackBarY.Position := Y * 100 div PaintBox.Height;
end;

procedure PaintBoxPaint(PaintBox: TPaintBox; HasToPaint: Boolean; X, Y: Integer);
begin
  if HasToPaint then begin
    X := X * Pred(PaintBox.Width) div 100;
    Y := Y * Pred(PaintBox.Height) div 100;
    PaintBox.Canvas.PenPos := Point(X, 0);
    PaintBox.Canvas.LineTo(X, PaintBox.Height);
    PaintBox.Canvas.PenPos := Point(0, Y);
    PaintBox.Canvas.LineTo(PaintBox.Width, Y);
  end;
end;

procedure RadioButtonClick(RadioButton: TRadioButton; TrackBarX, TrackBarY: TTrackBar; PaintBox: TPaintBox);
begin
  TrackBarX.Visible := RadioButton.Checked;
  TrackBarY.Visible := RadioButton.Checked;
  PaintBox.Invalidate;
end;

procedure TFond.FormCreate(Sender: TObject);
var
  Extensions: TStringList;
  i: Integer;
  Chaine: string;
begin
  PageControl1.ActivePageIndex := 0;
  PageControl2.ActivePageIndex := 0;
  PageControl3.ActivePageIndex := 0;
  FCurrentImage := '';

  Extensions := TStringList.Create;
  try
    Extensions.Clear;
    Extensions.Sorted := True;
    Extensions.Duplicates := dupIgnore;
    Chaine := LowerCase(GraphicFileMask(TGraphic));
    Split(Chaine, ';');
    RemplaceChaine(Chaine, '*', '');
    Extensions.Text := Chaine;
    cTypesImages.Items.Assign(Extensions);
  finally
    Extensions.Free;
  end;

  cCalendrier_Font.Items.Assign(Screen.Fonts);
  cLegende_Font.Items.Assign(Screen.Fonts);

  cCalendrier_PremierJourSemaine.OnChange := nil;
  for i := Low(LongDayNames) to High(LongDayNames) do begin
    Chaine := LowerCase(LongDayNames[i]);
    Chaine[1] := UpCase(Chaine[1]);
    cCalendrier_PremierJourSemaine.Items.Add(Chaine);
  end;
  cCalendrier_PremierJourSemaine.ItemIndex := -1;
  cCalendrier_PremierJourSemaine.OnChange := cCalendrier_PremierJourSemaineChange;

  FCurrentItem := nil;

  LoadOptions;
end;

procedure TFond.LoadOptions;
var
  i, j: Integer;
  s: string;
  Image: ^RImage;
  Exclusion: ^RExclusion;
  Plugin: ^RPlugin;
  JourFerie: ^RJourFerie;
  FDebug: RDebug;
  FichierIni: string;
  IniStruct: TCustomIniFile;
  FlagOld: Boolean;
begin
  FichierIni := ChangeFileExt(Application.ExeName, '.ini');
  FwasIniFile := FileExists(FichierIni);

  UOptions.LoadOptions(FOptions, FDebug, FMainProg);
  cSauveIni.Checked := FwasIniFile;

  cRepertoiresItemsClear;
  for i := 0 to Length(FOptions.Images) - 1 do begin
    New(Image);
    CopyMemory(Image, @FOptions.Images[i], SizeOf(RImage));
    cRepertoires.Items.AddObject(Image.Chemin, Pointer(Image));
  end;
  for i := 0 to Pred(cRepertoires.Count) do
    cRepertoires.Checked[i] := RImage(Pointer(cRepertoires.Items.Objects[i])^).SousRepertoire;


  for i := 0 to Length(FOptions.Extensions) - 1 do begin
    j := cTypesImages.Items.IndexOf(FOptions.Extensions[i]);
    if j = -1 then Continue;
    cTypesImages.Checked[j] := True;
  end;

  for i := 0 to Length(FOptions.Archives) - 1 do begin
    j := cTypesArchives.Items.IndexOf(FOptions.Archives[i]);
    if j = -1 then Continue;
    cTypesArchives.Checked[j] := True;
  end;

  cExclusionsItemsClear;
  cExclusions.Items.Add('Economiseur d''écran');
  for i := 0 to Length(FOptions.Exclusions) - 1 do begin
    New(Exclusion);
    CopyMemory(Exclusion, @FOptions.Exclusions[i], SizeOf(RExclusion));
    cExclusions.Items.AddObject(Exclusion.Chemin, Pointer(Exclusion));
  end;

  cCheckTime.Items.Clear;
  for i := 0 to Length(FOptions.HorairesFixe) - 1 do
    cCheckTime.Checked[cCheckTime.Items.Add(TimeToStr(FOptions.HorairesFixe[i].Heure))] := FOptions.HorairesFixe[i].Exclusions;

  cActionDoubleClick.ItemIndex := FOptions.ActionDoubleClick;
  cDemarrageWindows.Checked := FOptions.DemarrageWindows;
  cInterval.Value := FOptions.Interval;
  cHistorique.Value := FOptions.TailleHistorique;
  cDemarrage.Checked := FOptions.ChangerDemarrage;
  cActif.Checked := FOptions.ActiveParDefaut;
  cPriorite.ItemIndex := FOptions.Priorite;

  cLegende_UseLegende.Checked := FOptions.Legende.UseLegende;
  cCalendrier_UseCalendrier.Checked := FOptions.Calendrier.UseCalendrier;
  cCalendrier_Avant_Nombre.Value := FOptions.Calendrier.Avant.Nombre;
  cCalendrier_Apres_Nombre.Value := FOptions.Calendrier.Apres.Nombre;
  cAliasing.Checked := FOptions.AntiAliasing;
  cLegende_Trame.Value := FOptions.Legende.Trame;
  cLegende_TrameColor.Selected := FOptions.Legende.TrameColor;
  cCalendrier_EnCours_Trame.Value := FOptions.Calendrier.EnCours.Trame;
  cCalendrier_Avant_Trame.Value := FOptions.Calendrier.Avant.Trame;
  cCalendrier_Apres_Trame.Value := FOptions.Calendrier.Apres.Trame;
  cCalendrier_Avant_TrameColor.Selected := FOptions.Calendrier.Avant.TrameColor;
  cCalendrier_EnCours_TrameColor.Selected := FOptions.Calendrier.EnCours.TrameColor;
  cCalendrier_Apres_TrameColor.Selected := FOptions.Calendrier.Apres.TrameColor;
  cCalendrier_Font.ItemIndex := cCalendrier_Font.Items.IndexOf(FOptions.Calendrier.Font);
  cLegende_Font.ItemIndex := cLegende_Font.Items.IndexOf(FOptions.Legende.Font);
  cCalendrier_EnCours_FontSize.Value := FOptions.Calendrier.EnCours.FontSize;
  cCalendrier_Avant_FontSize.Value := FOptions.Calendrier.Avant.FontSize;
  cCalendrier_Apres_FontSize.Value := FOptions.Calendrier.Apres.FontSize;
  cLegende_FontSize.Value := FOptions.Legende.FontSize;
  cLegende_FontColor.Selected := FOptions.Legende.FontColor;
  cCalendrier_FontColor.Selected := FOptions.Calendrier.FontColor;
  cCalendrier_FontColorFerie.Selected := FOptions.Calendrier.FontColorFerie;
  cCalendrier_FontColorTitre.Selected := FOptions.Calendrier.FontColorTitre;
  cCalendrier_FontColorTitreAutre.Selected := FOptions.Calendrier.FontColorTitreAutre;
  cCalendrier_FontColorWE.Selected := FOptions.Calendrier.FontColorWE;
  cCalendrier_FontColorSemaine.Selected := FOptions.Calendrier.FontColorSemaine;
  cCalendrier_Aujourdhui.Checked := FOptions.Calendrier.Aujourdhui;
  cCalendrier_Avant_Ordre.ItemIndex := FOptions.Calendrier.Avant.Sens;
  cCalendrier_Apres_Ordre.ItemIndex := FOptions.Calendrier.Apres.Sens;
  cCalendrier_Avant_NumSemaine.Checked := FOptions.Calendrier.Avant.NumSemaine;
  cCalendrier_EnCours_NumSemaine.Checked := FOptions.Calendrier.EnCours.NumSemaine;
  cCalendrier_Apres_NumSemaine.Checked := FOptions.Calendrier.Apres.NumSemaine;
  cLegende_Effet3D.Checked := FOptions.Legende.Effet3D;
  cCalendrier_Avant_Effet3D.Checked := FOptions.Calendrier.Avant.Effet3D;
  cCalendrier_EnCours_Effet3D.Checked := FOptions.Calendrier.EnCours.Effet3D;
  cCalendrier_Apres_Effet3D.Checked := FOptions.Calendrier.Apres.Effet3D;
  cCalendrier_Avant_Semaine3D.Checked := FOptions.Calendrier.Avant.Semaine3D;
  cCalendrier_EnCours_Semaine3D.Checked := FOptions.Calendrier.EnCours.Semaine3D;
  cCalendrier_Apres_Semaine3D.Checked := FOptions.Calendrier.Apres.Semaine3D;
  cCalendrier_Avant_SemaineFontSize.Value := FOptions.Calendrier.Avant.SemaineFontSize;
  cCalendrier_EnCours_SemaineFontSize.Value := FOptions.Calendrier.EnCours.SemaineFontSize;
  cCalendrier_Apres_SemaineFontSize.Value := FOptions.Calendrier.Apres.SemaineFontSize;
  cCalendrier_EnCours_CouleurCadre.Selected := FOptions.Calendrier.ColorCadre;
  cCalendrier_EnCours_Gras.Checked := FOptions.Calendrier.EnCoursGras;
  cCalendrier_Avant_Max.Value := FOptions.Calendrier.Avant.Maximum;
  cCalendrier_Apres_Max.Value := FOptions.Calendrier.Apres.Maximum;

  cCalendrier_EnCours_Positionnement1.Checked := FOptions.Calendrier.EnCours.Positionnement = 1;
  cCalendrier_EnCours_Position1.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position1.Tag;
  cCalendrier_EnCours_Position2.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position2.Tag;
  cCalendrier_EnCours_Position3.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position3.Tag;
  cCalendrier_EnCours_Position4.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position4.Tag;
  cCalendrier_EnCours_Position5.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position5.Tag;
  cCalendrier_EnCours_Position6.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position6.Tag;
  cCalendrier_EnCours_Position7.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position7.Tag;
  cCalendrier_EnCours_Position8.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position8.Tag;
  cCalendrier_EnCours_Position9.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position9.Tag;
  cCalendrier_EnCours_Position0.Checked := FOptions.Calendrier.EnCours.Position = cCalendrier_EnCours_Position0.Tag;
  if cCalendrier_EnCours_Position0.Checked then begin
    cCalendrier_EnCours_Position_X.Position := FOptions.Calendrier.EnCours.Position_X;
    cCalendrier_EnCours_Position_Y.Position := FOptions.Calendrier.EnCours.Position_Y;
  end;
  cCalendrier_EnCours_Position0Click(cCalendrier_EnCours_Position0);

  cCalendrier_Avant_Positionnement1.Checked := FOptions.Calendrier.Avant.Positionnement = 1;
  cCalendrier_Avant_Positionnement0Click(nil);
  if cCalendrier_Avant_Positionnement0.Checked then begin
    cCalendrier_Avant_Position.ItemIndex := FOptions.Calendrier.Avant.Position;
    cCalendrier_Avant_Alignement.ItemIndex := FOptions.Calendrier.Avant.Alignement;
  end else begin
    cCalendrier_Avant_Position1.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position1.Tag;
    cCalendrier_Avant_Position2.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position2.Tag;
    cCalendrier_Avant_Position3.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position3.Tag;
    cCalendrier_Avant_Position4.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position4.Tag;
    cCalendrier_Avant_Position5.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position5.Tag;
    cCalendrier_Avant_Position6.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position6.Tag;
    cCalendrier_Avant_Position7.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position7.Tag;
    cCalendrier_Avant_Position8.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position8.Tag;
    cCalendrier_Avant_Position9.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position9.Tag;
    cCalendrier_Avant_Position0.Checked := FOptions.Calendrier.Avant.Position = cCalendrier_Avant_Position0.Tag;
    if cCalendrier_Avant_Position0.Checked then begin
      cCalendrier_Avant_Position_X.Position := FOptions.Calendrier.Avant.Position_X;
      cCalendrier_Avant_Position_Y.Position := FOptions.Calendrier.Avant.Position_Y;
    end;
    cCalendrier_EnCours_Position0Click(cCalendrier_Avant_Position0);
  end;

  cCalendrier_Apres_Positionnement1.Checked := FOptions.Calendrier.Apres.Positionnement = 1;
  cCalendrier_Apres_Positionnement1Click(nil);
  if cCalendrier_Apres_Positionnement0.Checked then begin
    cCalendrier_Apres_Position.ItemIndex := FOptions.Calendrier.Apres.Position;
    cCalendrier_Apres_Alignement.ItemIndex := FOptions.Calendrier.Apres.Alignement;
  end else begin
    cCalendrier_Apres_Position1.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position1.Tag;
    cCalendrier_Apres_Position2.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position2.Tag;
    cCalendrier_Apres_Position3.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position3.Tag;
    cCalendrier_Apres_Position4.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position4.Tag;
    cCalendrier_Apres_Position5.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position5.Tag;
    cCalendrier_Apres_Position6.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position6.Tag;
    cCalendrier_Apres_Position7.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position7.Tag;
    cCalendrier_Apres_Position8.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position8.Tag;
    cCalendrier_Apres_Position9.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position9.Tag;
    cCalendrier_Apres_Position0.Checked := FOptions.Calendrier.Apres.Position = cCalendrier_Apres_Position0.Tag;
    if cCalendrier_Apres_Position0.Checked then begin
      cCalendrier_Apres_Position_X.Position := FOptions.Calendrier.Apres.Position_X;
      cCalendrier_Apres_Position_Y.Position := FOptions.Calendrier.Apres.Position_Y;
    end;
    cCalendrier_EnCours_Position0Click(cCalendrier_Apres_Position0);
  end;

  cLegende_Position1.Checked := FOptions.Legende.Position = cLegende_Position1.Tag;
  cLegende_Position2.Checked := FOptions.Legende.Position = cLegende_Position2.Tag;
  cLegende_Position3.Checked := FOptions.Legende.Position = cLegende_Position3.Tag;
  cLegende_Position4.Checked := FOptions.Legende.Position = cLegende_Position4.Tag;
  cLegende_Position5.Checked := FOptions.Legende.Position = cLegende_Position5.Tag;
  cLegende_Position6.Checked := FOptions.Legende.Position = cLegende_Position6.Tag;
  cLegende_Position7.Checked := FOptions.Legende.Position = cLegende_Position7.Tag;
  cLegende_Position8.Checked := FOptions.Legende.Position = cLegende_Position8.Tag;
  cLegende_Position9.Checked := FOptions.Legende.Position = cLegende_Position9.Tag;
  cLegende_Position0.Checked := FOptions.Legende.Position = cLegende_Position0.Tag;
  if cLegende_Position0.Checked then begin
    cLegende_Position_X.Position := FOptions.Legende.Position_X;
    cLegende_Position_X.Position := FOptions.Legende.Position_Y;
  end;
  cLegende_Position0Click(cLegende_Position0);

  cLegende_Fichier0.Checked := FOptions.Legende.NomFichier = 0;
  cLegende_Fichier1.Checked := FOptions.Legende.NomFichier = 1;
  cLegende_Fichier2.Checked := FOptions.Legende.NomFichier = 2;

  cResolutionEcran.Checked := FOptions.ResizeDesktop = False;

  cCalendrier_PremierJourSemaine.ItemIndex := FOptions.Calendrier.PremierJourSemaine;
  cCalendrier_PremierJourSemaineChange(nil);
  for i := 1 to 7 do
    cCalendrier_WeekEnd.Checked[cCalendrier_WeekEnd.Items.IndexOfObject(Pointer(i))] := (i in FOptions.Calendrier.WeekEnd);

  cCalendrier_JoursFeries.Items.Clear;
  for i := 1 to Length(FOptions.Calendrier.JoursFeries) do begin
    New(JourFerie);
    CopyMemory(JourFerie, @FOptions.Calendrier.JoursFeries[i - 1], SizeOf(RJourFerie));
    cCalendrier_JoursFeries.Items.AddObject(FormatJourFerie(JourFerie^), Pointer(JourFerie));
  end;
  PageControl2.Visible := cCalendrier_UseCalendrier.Checked;
  PageControl3.Visible := cLegende_UseLegende.Checked;

  cPlugins.Items.Clear;
  for i := 0 to Pred(Length(FOptions.Plugins)) do
    cPlugins.Checked[cPlugins.Items.AddObject(FOptions.Plugins[i].Plugin.GetName, @FOptions.Plugins[i])] := FOptions.Plugins[i].Actif;

  CheckBox6.Checked := FDebug.GenereFichierLog;
  CheckBox8.Checked := FDebug.ListeProcess;
  CheckBox9.Checked := FDebug.ListeProcessDetail;
  CheckBox10.Checked := FDebug.DetailRechercheImage;
  CheckBox11.Checked := FDebug.DetailConversion;
  CheckBox12.Checked := FDebug.DetailConversion_Image;
  CheckBox24.Checked := FDebug.DetailConversion_Legende;
  CheckBox13.Checked := FDebug.DetailConversion_Calendrier;
  CheckBox15.Checked := FDebug.ChangementHeureFixe;
  CheckBox16.Checked := FDebug.Effacer;
  CheckBox6Click(CheckBox6);
end;

procedure TFond.SaveOptions;
var
  i, j: Integer;
  Image: ^RImage;
  Exclusion: ^RExclusion;
  Plugin: ^RPlugin;
  JourFerie: ^RJourFerie;
  FichierIni: string;
  IniStruct: TCustomIniFile;
begin
  FichierIni := ChangeFileExt(Application.ExeName, '.ini');
  if cSauveIni.Checked then begin
    if not FwasIniFile then
      case MessageDlg('Vous avez demandé l''enregistrement des nouvelles options dans un fichier ini.'#13'Voulez-vous supprimer les options éventuellement enregistrées en base de registre?', mtWarning, mbYesNoCancel, 0) of
        mrYes:
          begin
            IniStruct := TRegistryIniFile.Create(ExtractFilePath(CleProg));
            with TRegistryIniFile(IniStruct) do try
              EraseSection(ExtractFileName(CleProg));
            finally
              Free;
            end;
          end;
        mrCancel:
          begin
            ModalResult := mrNone;
            Exit;
          end;
      end;
    // ne plus supprimer le fichier: la configuration des plugins y est enregitrée!!!
    // if FileExists(FichierIni) then DeleteFile(FichierIni);
    IniStruct := TIniFile.Create(FichierIni);
  end else begin
    if FileExists(FichierIni) then
      case MessageDlg('Un fichier ini est présent mais vous avez demandé l''enregistrement des options dans la base de registre.'#13'Si ce fichier n''est pas supprimé, il sera lu prioritairement par rapport à la base de registre.'#13#13'Voulez-vous le supprimer?', mtWarning, mbYesNoCancel, 0) of
        mrYes: if not DeleteFile(FichierIni) then ShowMessage('Erreur'#13'Le fichier n''a pu être supprimé.'#13'Essayez de le supprimer à la main'#13'Fichier: ' + FichierIni);
        mrCancel:
          begin
            ModalResult := mrNone;
            Exit;
          end;
      end;
    IniStruct := TRegistryIniFile.Create(CleProg);
  end;

  // nettoyage de l'ancienne cle
  with TRegistryIniFile.Create(ExtractFilePath(OldCleProg)) do try
    EraseSection(ExtractFileName(OldCleProg));
  finally
    Free;
  end;

  with IniStruct do try
    WriteInteger('General', 'Version', 1);

    EraseSection('Fichiers');
    EraseSection('Sous-Repertoires'); // pour les anciennes versions
    for i := 1 to cRepertoires.Count do begin
      Image := Pointer(cRepertoires.Items.Objects[i - 1]);
      WriteString('Fichiers', 'Path' + IntToStr(i), Image.Chemin);
      WriteBool('Fichiers', 'Arc' + IntToStr(i), Image.Archive);
      WriteBool('Fichiers', 'SubDir' + IntToStr(i), cRepertoires.Checked[i - 1]);
    end;

    EraseSection('Images');
    j := 0;
    for i := 1 to cTypesImages.Count do begin
      if cTypesImages.Checked[i - 1] then begin
        Inc(j);
        WriteString('Images', 'Type' + IntToStr(j), cTypesImages.Items[i - 1]);
      end;
    end;

    EraseSection('Archives');
    j := 0;
    for i := 1 to cTypesArchives.Count do begin
      if cTypesArchives.Checked[i - 1] then begin
        Inc(j);
        WriteString('Archives', 'Type' + IntToStr(j), cTypesArchives.Items[i - 1]);
      end;
    end;

    EraseSection('CheckTime');
    for i := 1 to cCheckTime.Count do begin
      WriteString('CheckTime', 'Time' + IntToStr(i), cCheckTime.Items[i - 1]);
      WriteBool('CheckTime', 'TimeEx' + IntToStr(i), cCheckTime.Checked[i - 1]);
    end;

    EraseSection('Exclus');
    for i := 2 to cExclusions.Count do begin
      Exclusion := Pointer(cExclusions.Items.Objects[i - 1]);
      WriteString('Exclus', 'Path' + IntToStr(i - 1), Exclusion.Chemin);
      WriteBool('Exclus', 'Dir' + IntToStr(i - 1), Exclusion.Repertoire);
    end;

    WriteInteger('Options', 'ActionDoubleClick', cActionDoubleClick.ItemIndex);
    WriteBool('Options', 'Demarrage', cDemarrage.Checked);
    WriteBool('Options', 'Aliasing', cAliasing.Checked);
    WriteBool('Options', 'ResizeDesktop', cResolutionBureau.Checked);
    WriteBool('Options', 'Actif', cActif.Checked);
    WriteBool('Options', 'WZ', cDemarrageWindows.Checked);
    WriteInteger('Options', 'Interval', cInterval.Value);
    WriteInteger('Options', 'Historique', cHistorique.Value);
    WriteInteger('Options', 'Priorite', cPriorite.ItemIndex);

    EraseSection('Calendrier\MoisEnCours');
    EraseSection('Calendrier\MoisAvant');
    EraseSection('Calendrier\MoisApres');
    EraseSection('Calendrier\JoursFeries');
    EraseSection('Calendrier');
    if cCalendrier_UseCalendrier.Checked then begin
      WriteBool('Calendrier', 'Aujourdhui', cCalendrier_Aujourdhui.Checked);
      WriteString('Calendrier', 'Font', cCalendrier_Font.Text);
      WriteInteger('Calendrier', 'PremierJourSemaine', cCalendrier_PremierJourSemaine.ItemIndex);
      WriteInteger('Calendrier', 'FontColor', cCalendrier_FontColor.Selected);
      WriteInteger('Calendrier', 'FontColorFerie', cCalendrier_FontColorFerie.Selected);
      WriteInteger('Calendrier', 'FontColorTitre', cCalendrier_FontColorTitre.Selected);
      WriteInteger('Calendrier', 'FontColorTitreAutre', cCalendrier_FontColorTitreAutre.Selected);
      WriteInteger('Calendrier', 'FontColorWE', cCalendrier_FontColorWE.Selected);
      WriteInteger('Calendrier', 'FontColorSemaine', cCalendrier_FontColorSemaine.Selected);
      WriteInteger('Calendrier', 'ColorCadre', cCalendrier_EnCours_CouleurCadre.Selected);

      WriteInteger('Calendrier\MoisEnCours', 'FontSize', cCalendrier_EnCours_FontSize.Value);
      WriteInteger('Calendrier\MoisEnCours', 'Trame', cCalendrier_EnCours_Trame.Value);
      WriteInteger('Calendrier\MoisEnCours', 'TrameColor', cCalendrier_EnCours_TrameColor.Selected);
      WriteBool('Calendrier\MoisEnCours', 'NumSemaine', cCalendrier_EnCours_NumSemaine.Checked);
      WriteBool('Calendrier\MoisEnCours', 'Effet3D', cCalendrier_EnCours_Effet3D.Checked);
      WriteBool('Calendrier\MoisEnCours', 'Semaine3D', cCalendrier_EnCours_Semaine3D.Checked);
      WriteInteger('Calendrier\MoisEnCours', 'SemaineFontSize', cCalendrier_EnCours_SemaineFontSize.Value);
      WriteBool('Calendrier\MoisEnCours', 'Gras', cCalendrier_EnCours_Gras.Checked);

      if cCalendrier_EnCours_Positionnement0.Checked then FOptions.Calendrier.EnCours.Positionnement := 0;
      if cCalendrier_EnCours_Positionnement1.Checked then FOptions.Calendrier.EnCours.Positionnement := 1;
      WriteInteger('Calendrier\MoisEnCours', 'Positionnement', FOptions.Calendrier.EnCours.Positionnement);
      if cCalendrier_EnCours_Position1.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position1.Tag;
      if cCalendrier_EnCours_Position2.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position2.Tag;
      if cCalendrier_EnCours_Position3.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position3.Tag;
      if cCalendrier_EnCours_Position4.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position4.Tag;
      if cCalendrier_EnCours_Position5.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position5.Tag;
      if cCalendrier_EnCours_Position6.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position6.Tag;
      if cCalendrier_EnCours_Position7.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position7.Tag;
      if cCalendrier_EnCours_Position8.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position8.Tag;
      if cCalendrier_EnCours_Position9.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position9.Tag;
      if cCalendrier_EnCours_Position0.Checked then FOptions.Calendrier.EnCours.Position := cCalendrier_EnCours_Position0.Tag;
      WriteInteger('Calendrier\MoisEnCours', 'Position', FOptions.Calendrier.EnCours.Position);
      if cCalendrier_EnCours_Position0.Checked then begin
        WriteInteger('Calendrier\MoisEnCours', 'Position_X', cCalendrier_EnCours_Position_X.Position);
        WriteInteger('Calendrier\MoisEnCours', 'Position_Y', cCalendrier_EnCours_Position_Y.Position);
      end;

      if cCalendrier_Avant_Nombre.Value > 0 then begin
        WriteInteger('Calendrier\MoisAvant', 'Nombre', cCalendrier_Avant_Nombre.Value);
        WriteBool('Calendrier\MoisAvant', 'NumSemaine', cCalendrier_Avant_NumSemaine.Checked);
        WriteInteger('Calendrier\MoisAvant', 'Ordre', cCalendrier_Avant_Ordre.ItemIndex);
        WriteBool('Calendrier\MoisAvant', 'Effet3D', cCalendrier_Avant_Effet3D.Checked);
        WriteInteger('Calendrier\MoisAvant', 'FontSize', cCalendrier_Avant_FontSize.Value);
        WriteInteger('Calendrier\MoisAvant', 'Trame', cCalendrier_Avant_Trame.Value);
        WriteInteger('Calendrier\MoisAvant', 'TrameColor', cCalendrier_Avant_TrameColor.Selected);
        WriteBool('Calendrier\MoisAvant', 'Semaine3D', cCalendrier_Avant_Semaine3D.Checked);
        WriteInteger('Calendrier\MoisAvant', 'SemaineFontSize', cCalendrier_Avant_SemaineFontSize.Value);
        WriteInteger('Calendrier\MoisAvant', 'Maximum', cCalendrier_Avant_Max.Value);

        if cCalendrier_Avant_Positionnement0.Checked then FOptions.Calendrier.Avant.Positionnement := 0;
        if cCalendrier_Avant_Positionnement1.Checked then FOptions.Calendrier.Avant.Positionnement := 1;
        WriteInteger('Calendrier\MoisAvant', 'Positionnement', FOptions.Calendrier.Avant.Positionnement);

        if FOptions.Calendrier.Avant.Positionnement = 1 then begin
          if cCalendrier_Avant_Position1.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position1.Tag;
          if cCalendrier_Avant_Position2.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position2.Tag;
          if cCalendrier_Avant_Position3.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position3.Tag;
          if cCalendrier_Avant_Position4.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position4.Tag;
          if cCalendrier_Avant_Position5.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position5.Tag;
          if cCalendrier_Avant_Position6.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position6.Tag;
          if cCalendrier_Avant_Position7.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position7.Tag;
          if cCalendrier_Avant_Position8.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position8.Tag;
          if cCalendrier_Avant_Position9.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position9.Tag;
          if cCalendrier_Avant_Position0.Checked then FOptions.Calendrier.Avant.Position := cCalendrier_Avant_Position0.Tag;
          WriteInteger('Calendrier\MoisAvant', 'Position', FOptions.Calendrier.Avant.Position);
          if cCalendrier_Avant_Position0.Checked then begin
            WriteInteger('Calendrier\MoisAvant', 'Position_X', cCalendrier_Avant_Position_X.Position);
            WriteInteger('Calendrier\MoisAvant', 'Position_Y', cCalendrier_Avant_Position_Y.Position);
          end;
        end else begin
          WriteInteger('Calendrier\MoisAvant', 'Position', cCalendrier_Avant_Position.ItemIndex);
          WriteInteger('Calendrier\MoisAvant', 'Alignement', cCalendrier_Avant_Alignement.ItemIndex);
        end;
      end;

      if cCalendrier_Apres_Nombre.Value > 0 then begin
        WriteInteger('Calendrier\MoisApres', 'Nombre', cCalendrier_Apres_Nombre.Value);
        WriteBool('Calendrier\MoisApres', 'NumSemaine', cCalendrier_Apres_NumSemaine.Checked);
        WriteInteger('Calendrier\MoisApres', 'Ordre', cCalendrier_Apres_Ordre.ItemIndex);
        WriteBool('Calendrier\MoisApres', 'Effet3D', cCalendrier_Apres_Effet3D.Checked);
        WriteInteger('Calendrier\MoisApres', 'FontSize', cCalendrier_Apres_FontSize.Value);
        WriteInteger('Calendrier\MoisApres', 'Trame', cCalendrier_Apres_Trame.Value);
        WriteInteger('Calendrier\MoisApres', 'TrameColor', cCalendrier_Apres_TrameColor.Selected);
        WriteBool('Calendrier\MoisApres', 'Semaine3D', cCalendrier_Apres_Semaine3D.Checked);
        WriteInteger('Calendrier\MoisApres', 'SemaineFontSize', cCalendrier_Apres_SemaineFontSize.Value);
        WriteInteger('Calendrier\MoisApres', 'Maximum', cCalendrier_Apres_Max.Value);

        if cCalendrier_Apres_Positionnement0.Checked then FOptions.Calendrier.Apres.Positionnement := 0;
        if cCalendrier_Apres_Positionnement1.Checked then FOptions.Calendrier.Apres.Positionnement := 1;
        WriteInteger('Calendrier\MoisApres', 'Positionnement', FOptions.Calendrier.Apres.Positionnement);

        if FOptions.Calendrier.Apres.Positionnement = 1 then begin
          if cCalendrier_Apres_Position1.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position1.Tag;
          if cCalendrier_Apres_Position2.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position2.Tag;
          if cCalendrier_Apres_Position3.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position3.Tag;
          if cCalendrier_Apres_Position4.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position4.Tag;
          if cCalendrier_Apres_Position5.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position5.Tag;
          if cCalendrier_Apres_Position6.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position6.Tag;
          if cCalendrier_Apres_Position7.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position7.Tag;
          if cCalendrier_Apres_Position8.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position8.Tag;
          if cCalendrier_Apres_Position9.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position9.Tag;
          if cCalendrier_Apres_Position0.Checked then FOptions.Calendrier.Apres.Position := cCalendrier_Apres_Position0.Tag;
          WriteInteger('Calendrier\MoisApres', 'Position', FOptions.Calendrier.Apres.Position);
          if cCalendrier_Apres_Position0.Checked then begin
            WriteInteger('Calendrier\MoisApres', 'Position_X', cCalendrier_Apres_Position_X.Position);
            WriteInteger('Calendrier\MoisApres', 'Position_Y', cCalendrier_Apres_Position_Y.Position);
          end;
        end else begin
          WriteInteger('Calendrier\MoisApres', 'Position', cCalendrier_Apres_Position.ItemIndex);
          WriteInteger('Calendrier\MoisApres', 'Alignement', cCalendrier_Apres_Alignement.ItemIndex);
        end;
      end;

      for i := 0 to Pred(cCalendrier_WeekEnd.Items.Count) do
        WriteBool('Calendrier', 'WeekEnd' + IntToStr(Integer(cCalendrier_WeekEnd.Items.Objects[i])), cCalendrier_WeekEnd.Checked[i]);

      for i := 1 to cCalendrier_JoursFeries.Items.Count do begin
        JourFerie := Pointer(cCalendrier_JoursFeries.Items.Objects[i - 1]);
        WriteString('Calendrier\JoursFeries', 'Libelle' + IntToStr(i), JourFerie.Libelle);
        if JourFerie.UseCouleur then
          WriteInteger('Calendrier\JoursFeries', 'Couleur' + IntToStr(i), JourFerie.Couleur);
        WriteDate('Calendrier\JoursFeries', 'DateTo' + IntToStr(i), JourFerie.DateTo);
        WriteInteger('Calendrier\JoursFeries', 'Periodicite' + IntToStr(i), Integer(JourFerie.Periodicite));
        WriteInteger('Calendrier\JoursFeries', 'Regle' + IntToStr(i), Integer(JourFerie.Regle));
        case JourFerie.Regle of
          rjfDateFixe:
            begin
              WriteDate('Calendrier\JoursFeries', 'Jour' + IntToStr(i), JourFerie.JourFixe);
            end;
          rjfInterval:
            begin
              WriteDate('Calendrier\JoursFeries', 'JourDebut' + IntToStr(i), JourFerie.JourDebut);
              WriteDate('Calendrier\JoursFeries', 'JourFin' + IntToStr(i), JourFerie.JourFin);
            end;
          rjfCalcul:
            begin
              WriteInteger('Calendrier\JoursFeries', 'Jour' + IntToStr(i), JourFerie.Jour);
              if JourFerie.Periodicite > pjfHebdomadaire then WriteInteger('Calendrier\JoursFeries', 'nJour' + IntToStr(i), JourFerie.nJour);
              if JourFerie.Periodicite > pjfMensuel then WriteInteger('Calendrier\JoursFeries', 'Mois' + IntToStr(i), JourFerie.Mois);
            end;
        end;
      end;

    end;

    EraseSection('Legende');
    if cLegende_UseLegende.Checked then begin
      WriteString('Legende', 'Font', cLegende_Font.Text);
      WriteInteger('Legende', 'FontSize', cLegende_FontSize.Value);
      WriteInteger('Legende', 'FontColor', cLegende_FontColor.Selected);
      WriteInteger('Legende', 'Trame', cLegende_Trame.Value);
      WriteInteger('Legende', 'TrameColor', cLegende_TrameColor.Selected);
      WriteBool('Legende', 'Effet3D', cLegende_Effet3D.Checked);
      if cLegende_Position1.Checked then FOptions.Legende.Position := cLegende_Position1.Tag;
      if cLegende_Position2.Checked then FOptions.Legende.Position := cLegende_Position2.Tag;
      if cLegende_Position3.Checked then FOptions.Legende.Position := cLegende_Position3.Tag;
      if cLegende_Position4.Checked then FOptions.Legende.Position := cLegende_Position4.Tag;
      if cLegende_Position5.Checked then FOptions.Legende.Position := cLegende_Position5.Tag;
      if cLegende_Position6.Checked then FOptions.Legende.Position := cLegende_Position6.Tag;
      if cLegende_Position7.Checked then FOptions.Legende.Position := cLegende_Position7.Tag;
      if cLegende_Position8.Checked then FOptions.Legende.Position := cLegende_Position8.Tag;
      if cLegende_Position9.Checked then FOptions.Legende.Position := cLegende_Position9.Tag;
      if cLegende_Position0.Checked then FOptions.Legende.Position := cLegende_Position0.Tag;
      WriteInteger('Legende', 'Position', FOptions.Legende.Position);
      if cLegende_Position0.Checked then begin
        WriteInteger('Legende', 'Position_X', cLegende_Position_X.Position);
        WriteInteger('Legende', 'Position_Y', cLegende_Position_X.Position);
      end;

      if cLegende_Fichier0.Checked then FOptions.Legende.NomFichier := 0;
      if cLegende_Fichier1.Checked then FOptions.Legende.NomFichier := 1;
      if cLegende_Fichier2.Checked then FOptions.Legende.NomFichier := 2;
      WriteInteger('Legende', 'NomFichier', FOptions.Legende.NomFichier);
    end;

    EraseSection('Plugins');
    for i := 1 to cPlugins.Count do begin
      Plugin := Pointer(cPlugins.Items.Objects[i - 1]);
      if cPlugins.Checked[i - 1] then WriteString('Plugins', 'Path' + IntToStr(i), Plugin.Chemin)
                                 else WriteString('Plugins', 'Path' + IntToStr(i), '@' + Plugin.Chemin)
    end;

    WriteBool('Debug', 'Log', CheckBox6.Checked);
    WriteBool('Debug', 'Process', CheckBox8.Checked);
    WriteBool('Debug', 'ProcessDetail', CheckBox9.Checked);
    WriteBool('Debug', 'ScanPicFile', CheckBox10.Checked);
    WriteBool('Debug', 'Conversion', CheckBox11.Checked);
    WriteBool('Debug', 'ConversionImage', CheckBox12.Checked);
    WriteBool('Debug', 'ConversionLegende', CheckBox24.Checked);
    WriteBool('Debug', 'ConversionCalendrier', CheckBox13.Checked);
    WriteBool('Debug', 'ThreadCheckTime', CheckBox15.Checked);
    WriteBool('Debug', 'InitLogFile', CheckBox16.Checked);
  finally
    Free;
  end;
end;

procedure TFond.Button1Click(Sender: TObject);
var
  Image: ^RImage;
begin
  if not DlgBrowseDirectory1.Execute then Exit;
  New(Image);
  Image.Chemin := IncludeTrailingPathDelimiter(DlgBrowseDirectory1.Selection);
  Image.Archive := False;
  Image.SousRepertoire := True;
  cRepertoires.Checked[cRepertoires.Items.AddObject(Image.Chemin, Pointer(Image))] := Image.SousRepertoire;
end;

procedure TFond.Options1Click(Sender: TObject);
begin
  SetForegroundWindow(Handle);               
  Show;
end;

procedure TFond.Button5Click(Sender: TObject);
begin
  SaveOptions;
end;

procedure TFond.cCalendrier_UseCalendrierClick(Sender: TObject);
begin
  PageControl2.Visible := cCalendrier_UseCalendrier.Checked;
end;

procedure TFond.ComboBox2MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
begin
  with TComboBox(Control).Canvas do begin
    Font.Name := TComboBox(Control).Items[Index];
    Height := TextHeight(TComboBox(Control).Items[Index]) + 2; // measure ascenders and descenders
  end;
end;

procedure TFond.ComboBox2DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with TComboBox(Control).Canvas do begin
    FillRect(Rect);
    Font.Name := TComboBox(Control).Items[Index];
    TextOut(Rect.Left + 1, Rect.Top + 1, TComboBox(Control).Items[Index]);
  end;
end;

procedure TFond.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_Hide);
end;

procedure TFond.cExclusionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
  Data: String;
begin
  with cExclusions do begin
    Canvas.FillRect(Rect);
    if Index < Count then begin
      if Index = 0 then Canvas.Font.Color := clInactiveCaptionText;
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then Inc(Rect.Left, 2)
                                     else Dec(Rect.Right, 2);
      Data := Items[Index];
      DrawText(Canvas.Handle, PChar(Data), Length(Data), Rect, Flags);
    end;
  end;
end;

procedure TFond.Button10Click(Sender: TObject);
var
  s: string;
begin
  s := FormatDateTime(ShortTimeFormat, Frac(DateTimePicker1.Time));
  if cCheckTime.Items.IndexOf(s) = -1 then cCheckTime.Checked[cCheckTime.Items.Add(s)] := True;
end;

procedure TFond.CheckBox6Click(Sender: TObject);
begin
  CheckBox8.Enabled := CheckBox6.Checked;
  CheckBox9.Enabled := CheckBox6.Checked and CheckBox8.Checked;
  CheckBox10.Enabled := CheckBox6.Checked;
  CheckBox11.Enabled := CheckBox6.Checked;
  CheckBox12.Enabled := CheckBox6.Checked and CheckBox11.Checked;
  CheckBox13.Enabled := CheckBox6.Checked and CheckBox11.Checked;
  CheckBox24.Enabled := CheckBox6.Checked and CheckBox11.Checked;
  CheckBox15.Enabled := CheckBox6.Checked;

  CheckBox16.Enabled := CheckBox6.Checked;
end;

procedure TFond.CheckBox8Click(Sender: TObject);
begin
  CheckBox9.Enabled := CheckBox6.Checked and CheckBox8.Checked;
end;

procedure TFond.CheckBox11Click(Sender: TObject);
begin
  CheckBox12.Enabled := CheckBox6.Checked and CheckBox11.Checked;
  CheckBox13.Enabled := CheckBox6.Checked and CheckBox11.Checked;
  CheckBox24.Enabled := CheckBox6.Checked and CheckBox11.Checked;
end;

procedure TFond.cExclusionsItemsClear;
var
  i: Integer;
  p: Pointer;
begin
  try
    for i := 0 to Pred(cExclusions.Count) do begin
      p := cExclusions.Items.Objects[i];
      if Assigned(p) then Dispose(p);
    end;
  finally
    cExclusions.Clear;
  end;
end;

procedure TFond.cRepertoiresItemsClear;
var
  i: Integer;
  p: Pointer;
begin
  try
    for i := 0 to Pred(cRepertoires.Count) do begin
      p := cRepertoires.Items.Objects[i];
      if Assigned(p) then Dispose(p);
    end;
  finally
    cRepertoires.Clear;
  end;
end;

procedure TFond.FormDestroy(Sender: TObject);
begin
  cExclusionsItemsClear;
  cRepertoiresItemsClear;
  cPlugins.Items.Clear;
  UnloadPlugins(FOptions.Plugins);
end;

procedure TFond.Button9Click(Sender: TObject);
var
  Exclusion: ^RExclusion;
begin
  if not DlgBrowseDirectory1.Execute then Exit;
  New(Exclusion);
  Exclusion.Chemin := IncludeTrailingPathDelimiter(DlgBrowseDirectory1.Selection);
  Exclusion.Repertoire := True;
  cExclusions.Items.AddObject(Exclusion.Chemin, Pointer(Exclusion));
end;

procedure TFond.Button4Click(Sender: TObject);
var
  Image: ^RImage;
begin
  if not OpenDialogArchive.Execute then Exit;
  New(Image);
  Image.Chemin := OpenDialogArchive.FileName;
  Image.Archive := True;
  Image.SousRepertoire := True;
  cRepertoires.Checked[cRepertoires.Items.AddObject(Image.Chemin, Pointer(Image))] := Image.SousRepertoire;
end;

procedure TFond.Button2Click(Sender: TObject);
var
  Exclusion: ^RExclusion;
begin
  if not OpenDialogExclu.Execute then Exit;
  New(Exclusion);
  Exclusion.Chemin := OpenDialogExclu.FileName;
  Exclusion.Repertoire := False;
  cExclusions.Items.AddObject(Exclusion.Chemin, Pointer(Exclusion));
end;

procedure TFond.Button7Click(Sender: TObject);
begin
  if Assigned(FCurrentItem) then FCurrentItem.Free;
end;

constructor TFond.Create(ModeDebug: Boolean);
begin
  inherited Create(nil);
  FModeDebug := ModeDebug;
  TabSheet3.TabVisible := FModeDebug;
end;

procedure TFond.Button11Click(Sender: TObject);
begin
  SaveOptions;
  if ChangeWallPap(PChar(FCurrentImage), nil, ctManuel, FMainProg) then begin
    FwasIniFile := cSauveIni.Checked;
    FApplique := True;
  end;
end;

procedure TFond.LoadWeek(Debut: Integer);
var
  oldChecked: array[1..7] of Boolean;
  i: Integer;

  procedure AddDay;
  var
    Chaine: string;
  begin
    Chaine := LowerCase(LongDayNames[i]);
    Chaine[1] := UpCase(Chaine[1]);
    cCalendrier_WeekEnd.Checked[cCalendrier_WeekEnd.Items.AddObject(Chaine, Pointer(i))] := oldChecked[i];
  end;

begin
  ZeroMemory(@oldChecked, SizeOf(oldChecked));
  if Bool(cCalendrier_WeekEnd.Items.Count) then
    for i := 1 to 7 do
      oldChecked[Integer(cCalendrier_WeekEnd.Items.Objects[i - 1])] := cCalendrier_WeekEnd.Checked[i - 1];
  cCalendrier_WeekEnd.Items.Clear;

  for i := Debut to High(LongDayNames) do
    AddDay;
  for i := Low(LongDayNames) to Pred(Debut) do
    AddDay;
end;

procedure TFond.cCalendrier_PremierJourSemaineChange(Sender: TObject);
begin
  LoadWeek(cCalendrier_PremierJourSemaine.ItemIndex + 1);
end;

procedure TFond.SetCurrentImage(const Value: string);
begin
  FCurrentImage := Value;
  Button11.Visible := FileExists(FCurrentImage);
end;

procedure TFond.Button12Click(Sender: TObject);
var
  JourFerie: ^RJourFerie;
begin
  if cCalendrier_JoursFeries.ItemIndex <> -1 then begin
    JourFerie := Pointer(cCalendrier_JoursFeries.Items.Objects[cCalendrier_JoursFeries.ItemIndex]);
    Dispose(JourFerie);
    cCalendrier_JoursFeries.DeleteSelected;
  end;
end;

procedure TFond.Button13Click(Sender: TObject);
var
  JourFerie: ^RJourFerie;
begin
  New(JourFerie);
  ZeroMemory(JourFerie, SizeOf(RJourFerie));
  JourFerie.UseCouleur := False;
  JourFerie.Couleur := cCalendrier_FontColorFerie.Selected;
  if EditJourFerie(JourFerie^, cCalendrier_PremierJourSemaine.ItemIndex + 1) then
    cCalendrier_JoursFeries.Items.AddObject(FormatJourFerie(JourFerie^), Pointer(JourFerie))
  else
    Dispose(JourFerie);
end;

procedure TFond.cCalendrier_JoursFeriesDblClick(Sender: TObject);
var
  JourFerie: ^RJourFerie;
begin
  if cCalendrier_JoursFeries.ItemIndex <> -1 then begin
    JourFerie := Pointer(cCalendrier_JoursFeries.Items.Objects[cCalendrier_JoursFeries.ItemIndex]);
    if EditJourFerie(JourFerie^, cCalendrier_PremierJourSemaine.ItemIndex + 1) then begin
      cCalendrier_JoursFeries.Items[cCalendrier_JoursFeries.ItemIndex] := FormatJourFerie(JourFerie^);
      cCalendrier_JoursFeries.Invalidate;
    end;
  end;
end;

procedure TFond.cCalendrier_EnCours_Position0Click(Sender: TObject);
begin
  RadioButtonClick(cCalendrier_EnCours_Position0, cCalendrier_EnCours_Position_X, cCalendrier_EnCours_Position_Y, PaintBox1);
end;

procedure TFond.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseDown(PaintBox1, cCalendrier_EnCours_Position0, cCalendrier_EnCours_Position_X, cCalendrier_EnCours_Position_Y, X, Y);
end;

procedure TFond.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then TPaintBox(Sender).OnMouseDown(Sender, mbLeft, Shift, X, Y);
end;

procedure TFond.PaintBox1Paint(Sender: TObject);
begin
  PaintBoxPaint(PaintBox1, cCalendrier_EnCours_Position0.Checked, cCalendrier_EnCours_Position_X.Position, cCalendrier_EnCours_Position_Y.Position);
end;

procedure TFond.cCalendrier_EnCours_Position_YChange(Sender: TObject);
begin
  PaintBox1.Invalidate;
end;

procedure TFond.cLegende_UseLegendeClick(Sender: TObject);
begin
  PageControl3.Visible := cLegende_UseLegende.Checked;
end;

procedure TFond.cLegende_Position0Click(Sender: TObject);
begin
  cLegende_Position_X.Visible := cLegende_Position0.Checked;
  cLegende_Position_X.Visible := cLegende_Position0.Checked;
  PaintBox2.Invalidate;
end;

procedure TFond.cLegende_Position_YChange(Sender: TObject);
begin
  PaintBox2.Invalidate;
end;

procedure TFond.PaintBox2Paint(Sender: TObject);
var
  X, Y: Integer;
begin
  if cLegende_Position0.Checked then begin
    X := cLegende_Position_X.Position * PaintBox2.Width div 100;
    Y := cLegende_Position_X.Position * PaintBox2.Height div 100;
    PaintBox2.Canvas.PenPos := Point(X, 0);
    PaintBox2.Canvas.LineTo(X, PaintBox2.Height);
    PaintBox2.Canvas.PenPos := Point(0, Y);
    PaintBox2.Canvas.LineTo(PaintBox2.Width, Y);
  end;
end;

procedure TFond.PaintBox2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cLegende_Position0.Checked := True;
  cLegende_Position_X.Position := X * 100 div PaintBox2.Width;
  cLegende_Position_X.Position := Y * 100 div PaintBox2.Height;
end;

procedure TFond.PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then PaintBox2MouseDown(Sender, mbLeft, Shift, X, Y);
end;

procedure TFond.cPluginsClick(Sender: TObject);
var
  Plugin: ^RPlugin;
begin
  Plugin := Pointer(cPlugins.Items.Objects[cPlugins.ItemIndex]);
  if Plugin.Actif then begin
    Memo2.Text := Plugin.Plugin.GetDescription;
    Label68.Caption := Plugin.Plugin.GetAuthor;
    Label69.Caption := Plugin.Plugin.GetAuthorContact;
  end;
end;

procedure TFond.Button15Click(Sender: TObject);
begin
  if cCheckTime.ItemIndex <> -1 then
    cCheckTime.Items.Delete(cCheckTime.ItemIndex);
end;

procedure TFond.Button16Click(Sender: TObject);
var
  Image: ^RImage;
begin
  if cRepertoires.ItemIndex <> -1 then begin
    Image := Pointer(cRepertoires.Items.Objects[cRepertoires.ItemIndex]);
    Dispose(Image);
    cRepertoires.Items.Delete(cRepertoires.ItemIndex);
  end;
end;

procedure TFond.Button17Click(Sender: TObject);
begin
  if cExclusions.ItemIndex > 0 then cExclusions.Items.Delete(cExclusions.ItemIndex);
end;

procedure TFond.cCalendrier_Avant_NumSemaineClick(Sender: TObject);
begin
  cCalendrier_Avant_Semaine3D.Enabled := cCalendrier_Avant_NumSemaine.Checked;
  cCalendrier_Avant_SemaineFontSize.Enabled := cCalendrier_Avant_NumSemaine.Checked;
end;

procedure TFond.cCalendrier_EnCours_NumSemaineClick(Sender: TObject);
begin
  cCalendrier_EnCours_Semaine3D.Enabled := cCalendrier_EnCours_NumSemaine.Checked;
  cCalendrier_EnCours_SemaineFontSize.Enabled := cCalendrier_EnCours_NumSemaine.Checked;
end;

procedure TFond.cCalendrier_Apres_NumSemaineClick(Sender: TObject);
begin
  cCalendrier_Apres_Semaine3D.Enabled := cCalendrier_Apres_NumSemaine.Checked;
  cCalendrier_Apres_SemaineFontSize.Enabled := cCalendrier_Apres_NumSemaine.Checked;
end;

procedure TFond.PaintBox4Paint(Sender: TObject);
begin
  PaintBoxPaint(PaintBox4, cCalendrier_Apres_Position0.Checked, cCalendrier_Apres_Position_X.Position, cCalendrier_Apres_Position_Y.Position);
end;

procedure TFond.PaintBox3Paint(Sender: TObject);
begin
  PaintBoxPaint(PaintBox3, cCalendrier_Avant_Position0.Checked, cCalendrier_Avant_Position_X.Position, cCalendrier_Avant_Position_Y.Position);
end;

procedure TFond.PaintBox3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseDown(PaintBox3, cCalendrier_Avant_Position0, cCalendrier_Avant_Position_X, cCalendrier_Avant_Position_Y, X, Y);
end;

procedure TFond.PaintBox4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseDown(PaintBox4, cCalendrier_Apres_Position0, cCalendrier_Apres_Position_X, cCalendrier_Apres_Position_Y, X, Y);
end;

procedure TFond.cCalendrier_Avant_Position1Click(Sender: TObject);
begin
  RadioButtonClick(cCalendrier_Avant_Position0, cCalendrier_Avant_Position_X, cCalendrier_Avant_Position_Y, PaintBox3);
end;

procedure TFond.cCalendrier_Apres_Position0Click(Sender: TObject);
begin
  RadioButtonClick(cCalendrier_Apres_Position0, cCalendrier_Apres_Position_X, cCalendrier_Apres_Position_Y, PaintBox4);
end;

procedure TFond.cCalendrier_Avant_Position_YChange(Sender: TObject);
begin
  PaintBox3.Invalidate;
end;

procedure TFond.cCalendrier_Apres_Position_YChange(Sender: TObject);
begin
  PaintBox4.Invalidate;
end;

procedure TFond.cCalendrier_Apres_Positionnement1Click(Sender: TObject);
begin
  Panel13.Visible := cCalendrier_Apres_Positionnement1.Checked;
  Panel15.Visible := not Panel13.Visible;
end;

procedure TFond.cCalendrier_Avant_Positionnement0Click(Sender: TObject);
begin
  Panel12.Visible := cCalendrier_Avant_Positionnement1.Checked;
  Panel16.Visible := not Panel12.Visible;
end;

procedure TFond.cCalendrier_Apres_NombreChange(Sender: TObject);
begin
  cCalendrier_Apres_Max.MaxValue := cCalendrier_Apres_Nombre.Value;
  cCalendrier_Apres_Max.Value := cCalendrier_Apres_Nombre.Value;
end;

procedure TFond.cCalendrier_Avant_NombreChange(Sender: TObject);
begin
  cCalendrier_Avant_Max.MaxValue := cCalendrier_Avant_Nombre.Value;
  cCalendrier_Avant_Max.Value := cCalendrier_Avant_Nombre.Value;
end;

procedure TFond.cPluginsDblClick(Sender: TObject);
var
  Plugin: ^RPlugin;
  cnf: IConfiguration;
  IniStruct: IOptionsWriter;
  Old: Boolean;
begin
  if cPlugins.ItemIndex = -1 then Exit;
  Plugin := Pointer(cPlugins.Items.Objects[cPlugins.ItemIndex]);
  if {Plugin.Actif } cPlugins.Checked[cPlugins.ItemIndex] and (Plugin.Plugin.QueryInterface(IConfiguration, cnf) = 0) then begin
    IniStruct := GetIni(Old, cSauveIni.Checked);
    (IniStruct as IConfigureOptionsWriter).SousSection := 'ConfigPlugins\' + ExtractFileName(Plugin.Chemin);
    cnf.Configure(IniStruct);
  end;
end;

procedure TFond.Button3Click(Sender: TObject);
var
  FichierIni: string; 
begin
  FichierIni := ChangeFileExt(Application.ExeName, '.ini');
  if not FwasIniFile and FileExists(FichierIni) then
    DeleteFile(FichierIni);
end;

procedure TFond.cPluginsData(Control: TWinControl; Index: Integer; var Data: String);
begin
  Data := FOptions.Plugins[Index].Plugin.GetName;
end;

procedure TFond.cPluginsDataObject(Control: TWinControl; Index: Integer; var DataObject: TObject);
begin
  DataObject := @FOptions.Plugins[Index];
end;

procedure TFond.Button14Click(Sender: TObject);
var
  i: Integer;
begin
  if cPlugins.ItemIndex < 1 then Exit;
  i := cPlugins.ItemIndex - 1;
  cPlugins.Items.Move(cPlugins.ItemIndex, i);
  cPlugins.ItemIndex := i;
end;

procedure TFond.Button18Click(Sender: TObject);
var
  i: Integer;
begin
  if (cPlugins.ItemIndex = -1) or (cPlugins.ItemIndex >= cPlugins.Count - 1) then Exit;
  i := cPlugins.ItemIndex + 1;
  cPlugins.Items.Move(cPlugins.ItemIndex, i);
  cPlugins.ItemIndex := i;
end;

end.
