unit UMain;

interface

uses Windows, SysUtils, Forms, UInterfacePlugIn, UInterfaceDessinCalendrier, StdCtrls,
  ComCtrls, Controls, Classes, Spin, ExtCtrls;

type
  TFMain = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Bevel17: TBevel;
    Label66: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    ColorBox1: TColorBox;
    SpinEdit1: TSpinEdit;
    CheckBox1: TCheckBox;
    Bevel1: TBevel;
    Label6: TLabel;
    DateTimePicker1: TDateTimePicker;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox1MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
  private
    FWriter: IOptionsWriter;
  end;

  TPlugin = class(TInterfacedObject, IPlugin, IDessinCalendrier, IConfiguration, IEvenements)
  private
    FDessineur: IDessineur;

    // interface IPlugin
    function GetName: ShortString; stdcall;
    function GetDescription: ShortString; stdcall;
    function GetAuthor: ShortString; stdcall;
    function GetAuthorContact: ShortString; stdcall;

    // interface IConfiguration
    function Configure(Writer: IOptionsWriter): Boolean; stdcall;
    procedure RelireOptions(Writer: IOptionsWriter); stdcall;

    // interface IDessinCalendrier
    function CouleurTransparence(Couleur: Integer): Boolean; stdcall;
    procedure DessinMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer); stdcall;
    procedure DessinTitreMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer); stdcall;

    // interface IEvenements
    procedure DemarrageWP; stdcall;
    procedure FermetureWP; stdcall;
    procedure DebutRechercheFond; stdcall;
    procedure FinRechercheFond; stdcall;
    procedure DebutDessinFond(Dessineur: IDessineur); stdcall;
    procedure FinDessinFond(Dessineur: IDessineur); stdcall;
    procedure AvantApplicationNouveauFond; stdcall;
    procedure ApresApplicationNouveauFond; stdcall;
  public
    FMainProg: IMainProg;
    constructor Create(MainProg: IMainProg);
    destructor Destroy; override;
  end;

var
  Plugin: IPlugin;

implementation

uses DateUtils, Graphics, Math, IniFiles;

{$R *.dfm}

type
  ROptions = record
    DateFinale: TDateTime;
    Description: String;
    Police: string;
    DateTaille: Integer;
    Date3D: Boolean;
    DateCouleur: TColor;

    ExclureWE, ExclureJF: Boolean;
  end;

procedure LoadOptions(Writer: IOptionsWriter; var Options: ROptions);
begin
  with Writer do begin
    Options.DateFinale  := ReadDate('Options', 'DateFinale', Now);
    Options.Description := ReadString('Options', 'Description', '');
    Options.Police      := ReadString('Options', 'Police', 'Arial');
    Options.DateTaille  := ReadInteger('Options', 'DateTaille', 5);
    Options.Date3D      := ReadBool('Options', 'Date3D', True);
    Options.DateCouleur := ReadInteger('Options', 'DateCouleur', clRed);
    Options.ExclureWE   := ReadBool('Options', 'ExclureWE', False);
    Options.ExclureJF   := ReadBool('Options', 'ExclureJF', False);
  end;
end;

procedure SaveOptions(Writer: IOptionsWriter; Options: ROptions);
begin
  with Writer do begin
    WriteDate('Options', 'DateFinale', Options.DateFinale);
    WriteString('Options', 'Description', Options.Description);
    WriteString('Options', 'Police', Options.Police);
    WriteInteger('Options', 'DateTaille', Options.DateTaille);
    WriteBool('Options', 'Date3D', Options.Date3D);
    WriteInteger('Options', 'DateCouleur', Options.DateCouleur);
    WriteBool('Options', 'ExclureWE', Options.ExclureWE);
    WriteBool('Options', 'ExclureJF', Options.ExclureJF);
  end;
end;

{ Plugin }

function VideoInverse(Couleur: TColor): TColor;
begin
  Result := RGB(255 - GetRValue(Couleur), 255 - GetGValue(Couleur), 255 - GetBValue(Couleur));
end;

procedure TPlugin.ApresApplicationNouveauFond;
begin

end;

procedure TPlugin.AvantApplicationNouveauFond;
begin

end;

function TPlugin.Configure(Writer: IOptionsWriter): Boolean;
begin
  with TFMain.Create(nil) do try
    FWriter := Writer;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

function TPlugin.CouleurTransparence(Couleur: Integer): Boolean;
var
  Options: ROptions;
begin
  LoadOptions(FMainProg.OptionsWriter, Options);
  Result := (Couleur <> Options.DateCouleur) and (Couleur <> VideoInverse(Options.DateCouleur));
end;

constructor TPlugin.Create(MainProg: IMainProg);
begin
  FMainProg := MainProg;
end;

procedure TPlugin.DebutDessinFond(Dessineur: IDessineur);
begin
  FDessineur := Dessineur;
end;

procedure TPlugin.DebutRechercheFond;
begin

end;

procedure TPlugin.DemarrageWP;
begin

end;

procedure TPlugin.DessinMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer);
begin
end;

procedure TPlugin.DessinTitreMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer);
var
  Canvas: TCanvas;
  BMP, bckBMP: TBitmap;
  s: string;
  Y, L, diff, i: Integer;
  NextDate: TDateTime;
  Options: ROptions;
  isWE, isJF: Boolean;
begin
  if (Mois = MonthOf(Now)) and (Annee = YearOf(Now)) then begin
    LoadOptions(FMainProg.OptionsWriter, Options);
    BMP := TBitmap.Create;
    bckBMP := TBitmap.Create;
    try
      BMP.Width := 1024;
      BMP.Height := 1024;
      BMP.Transparent := False;
      BMP.TransparentColor := CouleurTransparence;
      BMP.TransparentMode := tmFixed;

      BMP.Canvas.Brush.Color := CouleurTransparence;
      BMP.Canvas.FillRect(Rect(0, 0, BMP.Width, BMP.Height));

      BMP.Canvas.Font.Name := Options.Police;

      BMP.Canvas.Font.Size := 14 + Options.DateTaille;
      BMP.Canvas.Font.Height := BMP.Canvas.Font.Height + BMP.Canvas.Font.Size div 4;
      BMP.Canvas.Brush.Style := bsClear;

      Y := 0;
      NextDate := Trunc(Options.DateFinale);
      diff := DaysBetween(NextDate, Trunc(Now));
      if Options.ExclureWE or Options.ExclureJF then begin
        if NextDate > Now then begin
          for i := Trunc(IncDay(Now, 1)) to Trunc(IncDay(NextDate, -1)) do begin
            isJF := Options.ExclureJF and FDessineur.IsFerie(i);
            isWE := Options.ExclureWE and FDessineur.IsWeekEnd(i);
            if isWE or isJF then Dec(Diff);
          end;
        end else if NextDate < Now then begin
          for i := Trunc(IncDay(NextDate, 1)) to Trunc(IncDay(Now, -1)) do begin
            isJF := Options.ExclureJF and FDessineur.IsFerie(i);
            isWE := Options.ExclureWE and FDessineur.IsWeekEnd(i);
            if isWE or isJF then Dec(Diff);
          end;
        end;
      end;

      s := Options.Description;
      if s <> '' then s := s + ': ';
      if SameDate(NextDate, Now) then
        s := s + 'jour J'
      else if NextDate < Now then
        s := s + 'J + ' + IntToStr(diff)
      else
        s := s + 'J - ' + IntToStr(diff);

//      BMP.Canvas.Font.Style := [fsBold];
      if Options.Date3D then begin
        BMP.Canvas.Font.Color := VideoInverse(Options.DateCouleur);
        BMP.Canvas.TextOut(0, Y, s);
      end;
      BMP.Canvas.Font.Color := Options.DateCouleur;
      BMP.Canvas.TextOut(1, Y + 1, s);
      Inc(Y, BMP.Canvas.TextHeight(s) + 4);
      L := BMP.Canvas.TextWidth(s);

      Canvas := TCanvas.Create;
      try
        Canvas.Handle := hHandle;

        if L > Largeur then begin
          bckBMP.Width := Largeur;
          bckBMP.Height := Hauteur;
          bckBMP.Transparent := False;
          bckBMP.TransparentColor := CouleurTransparence;
          bckBMP.TransparentMode := tmFixed;
          bckBMP.Canvas.CopyRect(Rect(0, 0, Largeur, Hauteur), Canvas, Rect(0, 0, Largeur, Hauteur));
          Canvas.Brush.Color := CouleurTransparence;
          Canvas.FillRect(Rect(0, 0, Largeur, Hauteur));
          Canvas.Draw((L - Largeur) div 2, 0, bckBMP);
          Inc(Hauteur, 8);
          Canvas.Draw(0, Hauteur, BMP);
        end else begin
          Inc(Hauteur, 8);
          Canvas.Draw((Largeur - L) div 2, Hauteur, BMP);
        end;

        Hauteur := Max(Hauteur, Hauteur + Y);
        Largeur := Max(Largeur, L);
      finally
        Canvas.Free;
      end;
    finally
      bckBMP.Free;
      BMP.Free;
    end;
  end;
end;

destructor TPlugin.Destroy;
begin
  FMainProg := nil;
  inherited;
end;

procedure TPlugin.FermetureWP;
begin

end;

procedure TPlugin.FinDessinFond(Dessineur: IDessineur);
begin
  FDessineur := nil;
end;

procedure TPlugin.FinRechercheFond;
begin

end;

function TPlugin.GetAuthor: ShortString;
begin
  Result := 'Teträm Corp';
end;

function TPlugin.GetAuthorContact: ShortString;
begin
  Result := 'http://www.tetram.info';
end;

function TPlugin.GetDescription: ShortString;
begin
  Result := 'Ce plugin ajoute le décompte d''une date au calendrier.';
end;

function TPlugin.GetName: ShortString;
begin
  Result := 'Compte à rebours.';
end;

procedure TFMain.Button1Click(Sender: TObject);
var
  Options: ROptions;
begin
  Options.DateFinale := DateTimePicker1.Date;
  Options.Description := Edit1.Text;
  Options.ExclureWE := CheckBox2.Checked;
  Options.ExclureJF := CheckBox3.Checked;
  Options.Police := ComboBox1.Text;
  Options.DateTaille := SpinEdit1.Value;
  Options.Date3D := CheckBox1.Checked;
  Options.DateCouleur := ColorBox1.Selected;
  SaveOptions(FWriter, Options);
end;

procedure TFMain.FormShow(Sender: TObject);
var
  Options: ROptions;
begin
  LoadOptions(FWriter, Options);
  DateTimePicker1.Date := Options.DateFinale;
  Edit1.Text := Options.Description;
  CheckBox2.Checked := Options.ExclureWE;
  CheckBox3.Checked := Options.ExclureJF;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(Options.Police);
  SpinEdit1.Value := Options.DateTaille;
  CheckBox1.Checked := Options.Date3D;
  ColorBox1.Selected := Options.DateCouleur;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  ComboBox1.Items.Assign(Screen.Fonts);
end;

procedure TFMain.ComboBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with TComboBox(Control).Canvas do begin
    FillRect(Rect);
    Font.Name := TComboBox(Control).Items[Index];
    TextOut(Rect.Left + 1, Rect.Top + 1, TComboBox(Control).Items[Index]);
  end;
end;

procedure TFMain.ComboBox1MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
begin
  with TComboBox(Control).Canvas do begin
    Font.Name := TComboBox(Control).Items[Index];
    Height := TextHeight(TComboBox(Control).Items[Index]) + 2; // measure ascenders and descenders
  end;
end;

procedure TPlugin.RelireOptions(Writer: IOptionsWriter);
begin
  // les options sont relues au moment du changement de fond
end;

initialization
  Plugin := nil;

end.
