unit UMain;

interface

uses Windows, SysUtils, Forms, UInterfacePlugIn, UInterfaceDessinCalendrier, StdCtrls, Classes,
  Controls, ExtCtrls, Spin, Graphics;

type
  TFMain = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Label65: TLabel;
    Label66: TLabel;
    Label70: TLabel;
    ColorBox2: TColorBox;
    ComboBox1: TComboBox;
    SpinEdit2: TSpinEdit;
    CheckBox8: TCheckBox;
    Bevel17: TBevel;
    Bevel1: TBevel;
    Label1: TLabel;
    CheckBox5: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ColorBox1: TColorBox;
    SpinEdit1: TSpinEdit;
    CheckBox6: TCheckBox;
    Label5: TLabel;
    CheckBox7: TCheckBox;
    CheckBox9: TCheckBox;
    Button3: TButton;
    Bevel2: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    CheckBox10: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox1MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
    FWriter: IOptionsWriter;
  public
    { Déclarations publiques }
  end;

  TPlugin = class(TInterfacedObject, IPlugin, IDessinCalendrier, IConfiguration)
  private
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
    procedure DessineLune(Image: TBitmap; Marge, Diametre: Integer);
  public
    FMainProg: IMainProg;
    constructor Create(MainProg: IMainProg);
    destructor Destroy; override;
  end;

var
  Plugin: IPlugin;

implementation

// latitude/longitude de villes
// http://www.astromedia.org/atlas/atlas_geo_select.php
// http://perso.wanadoo.fr/pgj/latlong.htm

uses DateUtils, Math, IniFiles, StDate, StDateSt, StAstro, USelectPosition,
  ComCtrls;

{$R *.dfm}

type
  ROptions = record
    HeuresGMT,
    DateDuJour, Quantieme, Saints, Saison, HorairesSoleil, HorairesLune, PhasesLune: Boolean;
    Police: string;
    DateTaille, InfosTaille: Integer;
    Date3D, Infos3D: Boolean;
    DateCouleur, InfosCouleur: TColor;
    Latitude, Longitude: Double;
  end;

procedure LoadOptions(Writer: IOptionsWriter; var Options: ROptions);
begin
  with Writer do begin
    Options.HeuresGMT      := ReadBool('Options', 'HeuresGMT', False);
    Options.DateDuJour     := ReadBool('Options', 'DateDuJour', True);
    Options.Quantieme      := ReadBool('Options', 'Quantieme', True);
    Options.Saints         := ReadBool('Options', 'Saints', True);
    Options.Saison         := ReadBool('Options', 'Saison', True);
    Options.HorairesSoleil := ReadBool('Options', 'Soleil', True);
    Options.HorairesLune   := ReadBool('Options', 'Lune', True);
    Options.PhasesLune     := ReadBool('Options', 'PhasesLune', Options.PhasesLune);

    Options.Police         := ReadString('Options', 'Police', 'Arial');
    Options.DateTaille     := ReadInteger('Options', 'DateTaille', 0);
    Options.Date3D         := ReadBool('Options', 'Date3D', True);
    Options.DateCouleur    := ReadInteger('Options', 'DateCouleur', clWhite);
    Options.InfosTaille    := ReadInteger('Options', 'InfosTaille', -5);
    Options.Infos3D        := ReadBool('Options', 'Infos3D', True);
    Options.InfosCouleur   := ReadInteger('Options', 'InfosCouleur', clWhite);

    // Paris par défaut
    Options.Latitude       := ReadFloat('Options', 'Latitude', 48.5);
    Options.Longitude      := ReadFloat('Options', 'Longitude', 2.20);
  end;
end;

procedure SaveOptions(Writer: IOptionsWriter; Options: ROptions);
begin
  with Writer do begin
    WriteBool('Options', 'HeuresGMT', Options.HeuresGMT); 
    WriteBool('Options', 'DateDuJour', Options.DateDuJour);
    WriteBool('Options', 'Quantieme', Options.Quantieme);
    WriteBool('Options', 'Saints', Options.Saints);
    WriteBool('Options', 'Saison', Options.Saison);
    WriteBool('Options', 'Soleil', Options.HorairesSoleil);
    WriteBool('Options', 'Lune', Options.HorairesLune);
    WriteBool('Options', 'PhasesLune', Options.PhasesLune);

    WriteString('Options', 'Police', Options.Police);
    WriteInteger('Options', 'DateTaille', Options.DateTaille);
    WriteBool('Options', 'Date3D', Options.Date3D);
    WriteInteger('Options', 'DateCouleur', Options.DateCouleur);
    WriteInteger('Options', 'InfosTaille', Options.InfosTaille);
    WriteBool('Options', 'Infos3D', Options.Infos3D);
    WriteInteger('Options', 'InfosCouleur', Options.InfosCouleur);

    WriteFloat('Options', 'Latitude', Options.Latitude);
    WriteFloat('Options', 'Longitude', Options.Longitude);     
  end;
end;

{ Plugin }

function VideoInverse(Couleur: TColor): TColor;
begin
  Result := RGB(255 - GetRValue(Couleur), 255 - GetGValue(Couleur), 255 - GetBValue(Couleur));
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
  Result := (Couleur <> Options.DateCouleur) and (Couleur <> Options.InfosCouleur) and
            (Couleur <> VideoInverse(Options.DateCouleur)) and (Couleur <> VideoInverse(Options.InfosCouleur)); 
end;

constructor TPlugin.Create(MainProg: IMainProg);
begin
  FMainProg := MainProg;
end;

procedure TPlugin.DessinMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer);
begin

end;

procedure TPlugin.DessineLune(Image: TBitmap; Marge, Diametre: Integer);
var
  Rayon: Integer;
  pl: Double;
  ut: TStDateTimeRec;
  rgn, rgnRond: THandle;
  rgnDroit, rgnGauche: THandle;
  r: Integer;
begin
  Rayon := Diametre div 2;

  ut.D := DateTimeToStDate(Now);
  ut.T := DateTimeToStTime(Now);
  pl := LunarPhase(ut);

  rgnRond := CreateEllipticRgn(Marge, Marge, Image.Width - Marge, Image.Height - Marge);
  rgn := CreateRectRgn(Marge + Rayon, Marge, Image.Width - Marge, Image.Height - Marge);
  rgnDroit := CreateRectRgn(0, 0, 0, 0);
  CombineRgn(rgnDroit, rgn, rgnRond, RGN_AND);
//  DeleteObject(rgn);
  rgn := CreateRectRgn(Marge, Marge, Marge + Rayon, Image.Height - Marge);
  rgnGauche := CreateRectRgn(0, 0, 0, 0);
  CombineRgn(rgnGauche, rgn, rgnRond, RGN_AND);
//  DeleteObject(rgn);
//  DeleteObject(rgnRond);

  r := Round((abs(pl) - 0.5) * 2 * Rayon);
  rgnRond := CreateEllipticRgn(Marge + Rayon - r, Marge, Marge + Rayon + r, Image.Height - Marge);

  // premier quartier : pl = 0.5
  // pleine lune : pl = 1
  // dernier quartier : pl = -0.5
  // nouvelle lune : pl = 0

  if pl > 0 then rgn := rgnGauche
            else rgn := rgnDroit;

  if Abs(pl) < 0.5 then CombineRgn(rgn, rgn, rgnRond, RGN_OR)
                   else CombineRgn(rgn, rgn, rgnRond, RGN_DIFF);

  Image.TransparentMode := tmAuto;
  Image.Transparent := True;
  Image.Canvas.Brush.Color := Image.TransparentColor;
  FillRgn(Image.Canvas.Handle, rgn, Image.Canvas.Brush.Handle);

  DeleteObject(rgnRond);
  DeleteObject(rgnDroit);
  DeleteObject(rgnGauche);
  DeleteObject(rgn);
end;

procedure TPlugin.DessinTitreMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer);
var
  Options: ROptions;
  Canvas: TCanvas;
  BMP, bckBMP: TBitmap;
  s, jour: string;
  Y, i, L, h, G: Integer;
  sl: TStringList;
  rs: TResourceStream;
  Lune: TBitmap;
  Infos: TStringList;
  DTR: TStDateTimeRec;
  RSet: TStRiseSetRec;
  dtRise, dtSet: TDateTime;
  DiffSoleil: TStTime;
  lpTimeZoneInformation: TTimeZoneInformation;
  GMT: Integer;
  sGMT: string;
begin
  if (Mois = MonthOf(Now)) and (Annee = YearOf(Now)) then begin
    LoadOptions(FMainProg.OptionsWriter, Options);
    Infos := TStringList.Create;
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

      h := 0;
      L := 0;
      G := 0;
      if Options.DateDuJour then begin
        Y := 0;
        s := FormatDateTime('dddd d', Now);
        s[1] := UpCase(s[1]);
        if Options.Date3D then begin
          BMP.Canvas.Font.Color := VideoInverse(Options.DateCouleur);
          BMP.Canvas.TextOut(0, Y, s);
        end;
        BMP.Canvas.Font.Color := Options.DateCouleur;
        BMP.Canvas.TextOut(1, Y + 1, s);
        L := BMP.Canvas.TextWidth(s);
        h := BMP.Canvas.TextHeight(s) + 4;
        G := L + 8;
      end;

      if Options.Quantieme then
        Infos.Add('Jour de l''année: ' + IntToStr(DayOfTheYear(Now)));

      if Options.Saints then begin
        sl := TStringList.Create;
        try
          rs := TResourceStream.Create(HInstance, 'SAINTS', 'TEXT');
          try
            sl.LoadFromStream(rs);
          finally
            rs.Free;
          end;
          sl.Sorted := True;
          jour := Format('%.2d/%.2d'#9, [DayOf(Now), MonthOf(Now)]);
          sl.Find(jour, i);
          while (i < sl.Count) and (Copy(sl[i], 1, 6) = jour) do begin
            s := sl[i];
            Infos.Add(Copy(s, 7, Length(s)));
            Inc(i);
          end;
        finally
          sl.Free;
        end;
      end;

      if Options.Saison then begin
        DTR := Equinox(Annee, 0, True);
        if SameDate(StDateToDateTime(DTR.D), Now) then
          Infos.Add('Printemps')
        else begin
          DTR := Equinox(Annee, 0, False);
          if SameDate(StDateToDateTime(DTR.D), Now) then
            Infos.Add('Automne')
          else begin
            DTR := Solstice(Annee, 0, True);
            if SameDate(StDateToDateTime(DTR.D), Now) then
              Infos.Add('Eté')
            else begin
              DTR := Solstice(Annee, 0, False);
              if SameDate(StDateToDateTime(DTR.D), Now) then
                Infos.Add('Hiver')
            end;
          end;
        end;
      end;

      GMT := 0;
      sGMT := '(GMT) ';
      if not Options.HeuresGMT then
        case GetTimeZoneInformation(lpTimeZoneInformation) of
          TIME_ZONE_ID_STANDARD:
            begin
              GMT := lpTimeZoneInformation.Bias + lpTimeZoneInformation.StandardBias;
              sGMT := '';
            end;
          TIME_ZONE_ID_DAYLIGHT:
            begin
              GMT := lpTimeZoneInformation.Bias + lpTimeZoneInformation.DaylightBias;
              sGMT := '';
            end;
        end;
      GMT := -GMT;

      if Options.HorairesSoleil then begin
        s := '';
        DiffSoleil := AmountOfSunlight(DateTimeToStDate(Now), Options.Longitude, Options.Latitude) - AmountOfSunlight(DateTimeToStDate(IncDay(Now, -1)), Options.Longitude, Options.Latitude);
        s := StTimeToTimeString('m', Abs(DiffSoleil), False);

        if DiffSoleil > 0 then
          s := ' (+' + s + ' min)'
        else if DiffSoleil < 0 then
          s := ' (-' + s + ' min)'
        else
          s := '';

        RSet := SunRiseSet(DateTimeToStDate(Now), Options.Longitude, Options.Latitude);
        dtRise := StTimeToDateTime(RSet.ORise);
        dtSet :=  StTimeToDateTime(RSet.OSet);
        Infos.Add(Format('Soleil: %s%s - %s%s', [sGMT, FormatDateTime('hh:mm', IncMinute(dtRise, GMT)), FormatDateTime('hh:mm', IncMinute(dtSet, GMT)), s]));
      end;

      if Options.HorairesLune then begin
        RSet := MoonRiseSet(DateTimeToStDate(Now), Options.Longitude, Options.Latitude);
        dtRise := StTimeToDateTime(RSet.ORise);
        dtSet :=  StTimeToDateTime(RSet.OSet);
        Infos.Add(Format('Lune: %s%s - %s', [sGMT, FormatDateTime('hh:mm', IncMinute(dtRise, GMT)), FormatDateTime('hh:mm', IncMinute(dtSet, GMT))]));
      end;

      if Options.PhasesLune then begin
        DTR := NextNewMoon(DateTimeToStDate(Now));
        if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
           Infos.Add(Format('Nouvelle lune (%s)', [FormatDateTime(ShortTimeFormat, StTimeToDateTime(DTR.T))]))
        else begin
          DTR := NextFirstQuarter(DateTimeToStDate(Now));
          if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
            Infos.Add(Format('Premier quart (%s)', [FormatDateTime(ShortTimeFormat, StTimeToDateTime(DTR.T))]))
          else begin
            DTR := NextFullMoon(DateTimeToStDate(Now));
            if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
              Infos.Add(Format('Pleine lune (%s)', [FormatDateTime(ShortTimeFormat, StTimeToDateTime(DTR.T))]))
            else begin
              DTR := NextLastQuarter(DateTimeToStDate(Now));
              if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
                Infos.Add(Format('Dernier quart (%s)', [FormatDateTime(ShortTimeFormat, StTimeToDateTime(DTR.T))]))
            end;
          end;
        end;

      end;

      Y := 0;
      BMP.Canvas.Font.Size := 14 + Options.InfosTaille;
      BMP.Canvas.Font.Height := BMP.Canvas.Font.Height + BMP.Canvas.Font.Size div 4;
      for i := 0 to Pred(Infos.Count) do begin
        s := Infos[i];
        if Options.Infos3D then begin
          BMP.Canvas.Font.Color := VideoInverse(Options.InfosCouleur);
          BMP.Canvas.TextOut(G, Y, s);
        end;
        BMP.Canvas.Font.Color := Options.InfosCouleur;
        BMP.Canvas.TextOut(G + 1, Y + 1, s);
        Inc(Y, BMP.Canvas.TextHeight(s));
        L := Max(L, G + BMP.Canvas.TextWidth(s));
      end;

      if Options.PhasesLune then begin
        Lune := TBitmap.Create;

        Lune.LoadFromResourceName(HInstance, 'PhasesLune');
//        DessineLune(Lune, 2, 52);
        DessineLune(Lune, -2, 34);

//        DTR := NextNewMoon(DateTimeToStDate(Now));
//        if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
//           Lune.LoadFromResourceName(HInstance, 'NOUVELLELUNE')
//        else begin
//          DTR := NextFirstQuarter(DateTimeToStDate(Now));
//          if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
//            Lune.LoadFromResourceName(HInstance, 'PREMIERQUART')
//          else begin
//            DTR := NextFullMoon(DateTimeToStDate(Now));
//            if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
//              Lune.LoadFromResourceName(HInstance, 'PLEINELUNE')
//            else begin
//              DTR := NextLastQuarter(DateTimeToStDate(Now));
//              if (DTR.D <> BadDate) and (SameDate(StDateToDateTime(DTR.D), Now)) then
//                Lune.LoadFromResourceName(HInstance, 'DERNIERQUART')
//              else
//                FreeAndNil(Lune);
//            end;
//          end;
//        end;
        if Assigned(Lune) then try
          Lune.Transparent := True;
          Lune.TransparentMode := tmAuto;
          BMP.Canvas.Draw(L + 4, 0, Lune);
          Inc(L, 4 + Lune.Width);
          Y := Max(Y, Lune.Height);
        finally
          FreeAndNil(Lune);
        end;
      end;

      Y := Max(h, Y);

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
      Infos.Free;
      bckBMP.Free;
      BMP.Free;
    end;
  end;
end;

destructor TPlugin.Destroy;
begin
  FMainProg := nil;
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
  Result := 'Ce plugin ajoute l''éphéméride du jour au calendrier: quantième, saint et phases de la lune.';
end;

function TPlugin.GetName: ShortString;
begin
  Result := 'Ephéméride.';
end;

procedure TFMain.Button1Click(Sender: TObject);
var
  Options: ROptions;
begin
  try
    Options.HeuresGMT := CheckBox9.Checked;
    Options.DateDuJour := CheckBox1.Checked;
    Options.Quantieme := CheckBox2.Checked;
    Options.Saints := CheckBox3.Checked;
    Options.Saison := CheckBox7.Checked;
    Options.HorairesSoleil := CheckBox5.Checked;
    Options.HorairesLune := CheckBox4.Checked;
    Options.PhasesLune := CheckBox10.Checked;
    Options.Police := ComboBox1.Text;
    Options.DateTaille := SpinEdit2.Value;
    Options.InfosTaille := SpinEdit1.Value;
    Options.Date3D := CheckBox8.Checked;
    Options.Infos3D := CheckBox6.Checked;
    Options.DateCouleur := ColorBox2.Selected;
    Options.InfosCouleur := ColorBox1.Selected;
    Options.Longitude := StrToFloat(Edit1.Text);
    Options.Latitude := StrToFloat(Edit2.Text);

    SaveOptions(FWriter, Options);
  except
    ModalResult := mrNone;
    raise;
  end;
end;

procedure TFMain.FormShow(Sender: TObject);
var
  Options: ROptions;
begin
  LoadOptions(FWriter, Options);
  CheckBox9.Checked := Options.HeuresGMT;
  CheckBox1.Checked := Options.DateDuJour;
  CheckBox2.Checked := Options.Quantieme;
  CheckBox3.Checked := Options.Saints;
  CheckBox7.Checked := Options.Saison;
  CheckBox5.Checked := Options.HorairesSoleil;
  CheckBox4.Checked := Options.HorairesLune;
  CheckBox10.Checked := Options.PhasesLune;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(Options.Police);
  SpinEdit2.Value := Options.DateTaille;
  SpinEdit1.Value := Options.InfosTaille;
  CheckBox8.Checked := Options.Date3D;
  CheckBox6.Checked := Options.Infos3D;
  ColorBox2.Selected := Options.DateCouleur;
  ColorBox1.Selected := Options.InfosCouleur;
  Edit1.Text := FloatToStr(Options.Longitude);
  Edit2.Text := FloatToStr(Options.Latitude);
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

procedure TFMain.Button3Click(Sender: TObject);
begin
  with TForm1.Create(Self) do try
    if (ShowModal = mrOk) and (ListView1.ItemIndex <> -1) then begin
      Edit2.Text := ListView1.Items[ListView1.ItemIndex].SubItems[1];
      Edit1.Text := ListView1.Items[ListView1.ItemIndex].SubItems[2];
    end;
  finally
    Free;
  end;
end;

procedure TPlugin.RelireOptions(Writer: IOptionsWriter);
begin
  // on s'en moque: les options sont relues au moment du changement de fond
end;

initialization
  Plugin := nil;

end.
