unit UJoursFeries;

interface

uses
  SysUtils, Windows, Classes, Forms, Controls, DateUtils, dialogs, Types, Graphics,
  StdCtrls, ComCtrls, ExtCtrls, UOptions;

type
  TListJoursFeries = class(TList)
  private
    FCountUpdate: Integer;
    FDateDebut: TDateTime;
    FDateFin: TDateTime;
    FJoursFeries: TArrayJoursFeries;
    FRegles: array of Integer;
    procedure SetDateInterval(const Index: Integer; const Value: TDateTime);
    function GetNbJoursFeries: Integer;
    function IsFerieDateFixe(Date: TDateTime; Jour: RJourFerie): Boolean;
    function IsFerieInterval(Date: TDateTime; Interval: RJourFerie): Boolean;
    function AdjustDate(DateRef, DateToAdjust: TDateTime; Periodicite: TPeriodiciteJourFerie; CompareValue: TValueRelationship): TDateTime;
    function IsFerieCalcul(Date: TDateTime; Jour: RJourFerie): Boolean;
  public
    constructor Create;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure MakeList;
    procedure SetJoursFeries(const Value: TArrayJoursFeries; Count: Integer);
    function IsFerie(Date: TDateTime): PJourFerie; 
    procedure AddJour(Date: TDateTime; IndexRegle: Integer);
  published
    property DateDebut: TDateTime index 0 read FDateDebut write SetDateInterval;
    property DateFin: TDateTime index 1 read FDateFin write SetDateInterval;
    property JoursFeries: TArrayJoursFeries read FJoursFeries;
    property NbJoursFeries: Integer read GetNbJoursFeries;
  end;

  TEditJourFerie = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    Bevel1: TBevel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    TabControl1: TTabControl;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker3: TDateTimePicker;
    Panel1: TPanel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ColorBox1: TColorBox;
    CheckBox2: TCheckBox;
    procedure TabControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
  private
    procedure LoadWeek(Debut: Integer);
  end;

function EditJourFerie(var JourFerie: RJourFerie; DebutSemaine: Integer): Boolean;
function FormatJourFerie(JourFerie: RJourFerie): string;

implementation

{$R *.dfm}

function FormatJourFerie(JourFerie: RJourFerie): string;
var
  s: string;
begin
  s := '';
  Result := JourFerie.Libelle;
  case JourFerie.Regle of
    rjfDateFixe: s := DateToStr(JourFerie.JourFixe);
    rjfInterval: s := DateToStr(JourFerie.JourDebut) + ' - ' + DateToStr(JourFerie.JourFin);
    rjfCalcul:
      begin
        if JourFerie.Periodicite > pjfHebdomadaire then
          case JourFerie.nJour + 1 of
            1: s := 'Premier ';
            2: s := 'Deuxième ';
            3: s := 'Troisième ';
            4: s := 'Quatrième ';
            5: s := 'Cinquième ';
            6: s := 'Dernier ';
          end
        else
          s := 'Chaque ';
        s := s + LongDayNames[JourFerie.Jour];
        if JourFerie.Periodicite > pjfMensuel then
          s := s + ' / ' + LongMonthNames[JourFerie.Mois];
      end;
  end;
  case JourFerie.Periodicite of
    pjfHebdomadaire: s := s + ' - Hebdomadaire';
    pjfMensuel: s := s + ' - Mensuel';
    pjfAnnuel: s := s + ' - Annuel';
  end;
  Result := Result + #9' [' + s + ']';
end;

{ TListJoursFeries }

procedure TListJoursFeries.AddJour(Date: TDateTime; IndexRegle: Integer);
begin
  SetLength(FRegles, Succ(Count));
  FRegles[Add(Pointer(Trunc(Date)))] := IndexRegle;
end;

procedure TListJoursFeries.BeginUpdate;
begin
  Inc(FCountUpdate);
end;

constructor TListJoursFeries.Create;
begin
  inherited;
  FCountUpdate := 0;
end;

procedure TListJoursFeries.EndUpdate;
begin
  if FCountUpdate > 0 then Dec(FCountUpdate);
  MakeList;
end;

function TListJoursFeries.GetNbJoursFeries: Integer;
begin
  Result := Length(FJoursFeries);
end;

function TListJoursFeries.AdjustDate(DateRef, DateToAdjust: TDateTime; Periodicite: TPeriodiciteJourFerie; CompareValue: TValueRelationship): TDateTime;
begin
  Result := DateToAdjust;
  case Periodicite of
    pjfAucune: ;
    pjfHebdomadaire: while CompareDate(DateRef, Result) = CompareValue do Result := IncWeek(Result, CompareValue);
    pjfMensuel:      while CompareDate(DateRef, Result) = CompareValue do Result := IncMonth(Result, CompareValue);
    pjfAnnuel:       while CompareDate(DateRef, Result) = CompareValue do Result := IncYear(Result, CompareValue);
  end;
end;

function TListJoursFeries.IsFerie(Date: TDateTime): PJourFerie;
var
  i: Integer;
begin
  i := IndexOf(Pointer(Trunc(Date)));
  if i > -1 then Result := @JoursFeries[FRegles[i]]
            else Result := nil;
end;

function TListJoursFeries.IsFerieCalcul(Date: TDateTime; Jour: RJourFerie): Boolean;

  function nDayOf: Boolean;
  var
    n: Integer;
    lastDay: TDateTime;
  begin
    if Jour.nJour < 5 then begin
      n := DayOf(Date) div 7;
      Result := (n = Jour.nJour)
    end else begin
      lastDay := Trunc(EndOfTheMonth(Date));
      while DayOfWeek(Date) <> DayOfWeek(lastDay) do lastDay := IncDay(lastDay, -1);
      Result := lastDay = Date;
    end;
  end;

begin
  Result := DayOfWeek(Date) = Jour.Jour;
  if not Result then Exit;

  Result := (Jour.Periodicite <= pjfHebdomadaire) or nDayOf;
  if not Result then Exit;

  Result := (Jour.Periodicite <= pjfMensuel) or (MonthOf(Date) = Jour.Mois);
  if not Result then Exit;
end;

function TListJoursFeries.IsFerieDateFixe(Date: TDateTime; Jour: RJourFerie): Boolean;
begin
  if Jour.JourFixe < Date then Result := SameDate(Date, AdjustDate(Date, Jour.JourFixe, Jour.Periodicite, GreaterThanValue))
                          else Result := SameDate(Date, Jour.JourFixe);
end;

function TListJoursFeries.IsFerieInterval(Date: TDateTime; Interval: RJourFerie): Boolean;
var
  JourDebut, JourFin: TDateTime;
begin
  JourDebut := Trunc(Interval.JourDebut);
  JourFin := Trunc(Interval.JourFin);

  if JourFin < Date then begin
    JourFin := AdjustDate(Date, JourFin, Interval.Periodicite, GreaterThanValue);
    JourDebut := JourFin - (Interval.JourFin - Interval.JourDebut);
  end;

  Date := Trunc(Date);
  Result := (Date >= JourDebut) and (Date <= JourFin);
end;

procedure TListJoursFeries.MakeList;
var
  d: TDateTime;
  i: Integer;
  ToAdd: Boolean;
begin
  if LongBool(FCountUpdate) then Exit;
  Clear;
  d := FDateDebut;
  while d <= FDateFin do begin
    ToAdd := False;
    i := 0;
    while not ToAdd and (i < NbJoursFeries) do begin
try
      if (JoursFeries[i].DateTo = -1) or (JoursFeries[i].DateTo >= d) then
        case JoursFeries[i].Regle of
          rjfDateFixe: ToAdd := IsFerieDateFixe(d, JoursFeries[i]);
          rjfInterval: ToAdd := IsFerieInterval(d, JoursFeries[i]);
          rjfCalcul:   ToAdd := IsFerieCalcul(d, JoursFeries[i]);
        end;
except
  ShowMessageFmt('%d - %d', [d, i]);
  raise;
end;
      Inc(i);
    end;
    if ToAdd then AddJour(d, i - 1);
    d := IncDay(d);
  end;
end;

procedure TListJoursFeries.SetDateInterval(const Index: Integer; const Value: TDateTime);
begin
  case Index of
    0: FDateDebut := Value;
    1: FDateFin := Value;
  end;
  MakeList;
end;

procedure TListJoursFeries.SetJoursFeries(const Value: TArrayJoursFeries; Count: Integer);
begin
  SetLength(FJoursFeries, Count);
  CopyMemory(FJoursFeries, Value, Count * SizeOf(RJourFerie));
  MakeList;
end;

function EditJourFerie(var JourFerie: RJourFerie; DebutSemaine: Integer): Boolean;
begin
  with TEditJourFerie.Create(nil) do try
    LoadWeek(DebutSemaine);
    Edit1.Text := JourFerie.Libelle;
    CheckBox2.Checked := JourFerie.UseCouleur;
    CheckBox2Click(CheckBox2);
    ColorBox1.Selected := JourFerie.Couleur;
    case JourFerie.Regle of
      rjfAucune:
        TabControl1.TabIndex := 0;
      rjfDateFixe:
        begin
          TabControl1.TabIndex := 0;
          if JourFerie.JourFixe = 0 then JourFerie.JourFixe := Now;
          DateTimePicker2.DateTime := JourFerie.JourFixe;
        end;
      rjfInterval:
        begin
          TabControl1.TabIndex := 1;
          if JourFerie.JourDebut = 0 then JourFerie.JourDebut := Now;
          DateTimePicker2.DateTime := JourFerie.JourDebut;
          if JourFerie.JourFin = 0 then JourFerie.JourFin := Now;
          DateTimePicker3.DateTime := JourFerie.JourFin;
        end;
      rjfCalcul:
        begin
          TabControl1.TabIndex := 2;
          ComboBox2.ItemIndex := JourFerie.nJour;
          ComboBox3.ItemIndex := ComboBox3.Items.IndexOfObject(Pointer(JourFerie.Jour));
          ComboBox4.ItemIndex := JourFerie.Mois - 1;
        end;
    end;
    TabControl1Change(TabControl1);
    CheckBox1.Checked := JourFerie.DateTo > 0;
    if CheckBox1.Checked then DateTimePicker1.DateTime := JourFerie.DateTo;
    ComboBox1.ItemIndex := Integer(JourFerie.Periodicite);
    ComboBox1Change(ComboBox1);

    Result := ShowModal = mrOk;
    if Result then begin
      JourFerie.Libelle := Trim(Edit1.Text);
      JourFerie.UseCouleur := CheckBox2.Checked;
      JourFerie.Couleur := ColorBox1.Selected;
      case TabControl1.TabIndex of
        0:
          begin
            JourFerie.Regle := rjfDateFixe;
            JourFerie.JourFixe := DateTimePicker2.Date;
          end;
        1:
          begin
            JourFerie.Regle := rjfInterval;
            JourFerie.JourDebut := DateTimePicker2.Date;
            JourFerie.JourFin := DateTimePicker3.Date;
          end;
        2:
          begin
            JourFerie.Regle := rjfCalcul;
            JourFerie.nJour := ComboBox2.ItemIndex;
            JourFerie.Jour := Integer(ComboBox3.Items.Objects[ComboBox3.ItemIndex]);
            JourFerie.Mois := ComboBox4.ItemIndex + 1;
          end;
      end;
      if CheckBox1.Checked then JourFerie.DateTo := DateTimePicker1.Date
                           else JourFerie.DateTo := -1;
      JourFerie.Periodicite := TPeriodiciteJourFerie(ComboBox1.ItemIndex);
    end;
  finally
    Free;
  end;
end;

procedure TEditJourFerie.TabControl1Change(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0:
      begin
        Label1.Caption := 'Date :';
      end;
    1:
      begin
        Label1.Caption := 'Du :';
      end;
  end;
  Label2.Visible := TabControl1.TabIndex = 1;
  DateTimePicker3.Visible := TabControl1.TabIndex = 1;
  Panel1.Visible := TabControl1.TabIndex = 2;
end;

procedure TEditJourFerie.FormCreate(Sender: TObject);
var
  i: Integer;
  Chaine: string;

begin
  Panel1.BringToFront;
  Panel1.Left := 0;
  Panel1.Top := 24;

  for i := Low(LongMonthNames) to High(LongMonthNames) do begin
    Chaine := LowerCase(LongMonthNames[i]);
    Chaine[1] := UpCase(Chaine[1]);
    ComboBox4.Items.AddObject(Chaine, Pointer(i));
  end;

end;

procedure TEditJourFerie.LoadWeek(Debut: Integer);
var
  i: Integer;

  procedure AddDay;
  var
    Chaine: string;
  begin
    Chaine := LowerCase(LongDayNames[i]);
    Chaine[1] := UpCase(Chaine[1]);
    ComboBox3.Items.AddObject(Chaine, Pointer(i));
  end;

begin
  for i := Debut to High(LongDayNames) do
    AddDay;
  for i := Low(LongDayNames) to Pred(Debut) do
    AddDay;
end;

procedure TEditJourFerie.ComboBox1Change(Sender: TObject);
begin
  ComboBox2.Enabled := ComboBox1.ItemIndex > 1;
  ComboBox3.Enabled := ComboBox1.ItemIndex > 0;
  ComboBox4.Enabled := ComboBox1.ItemIndex > 2;
end;

procedure TEditJourFerie.Button1Click(Sender: TObject);
begin
  try
    case TabControl1.TabIndex of
      0:
        begin
          if CheckBox1.Checked and (DateTimePicker1.Date > DateTimePicker2.Date) then raise Exception.Create('La date d''expiration doit être antérieure à la date du jour ferié.');
        end;
      1:
        begin
          if DateTimePicker2.Date > DateTimePicker3.Date then raise Exception.Create('La date de début doit être antérieure à la date de fin.');
          if CheckBox1.Checked and (DateTimePicker1.Date > DateTimePicker2.Date) then raise Exception.Create('La date d''expiration doit être antérieure à la date de début.');
          if CheckBox1.Checked and (DateTimePicker1.Date > DateTimePicker3.Date) then raise Exception.Create('La date d''expiration doit être antérieure à la date de fin.');
        end;
      2:
        begin
          if ComboBox1.ItemIndex = 0 then raise Exception.Create('Un jour ferié calculé doit avoir une periodicité.');
          if ComboBox2.Enabled and (ComboBox2.ItemIndex < 0) then raise Exception.Create('Vous n''avez pas sélectionné le numéro du jour.');
          if ComboBox4.Enabled and (ComboBox4.ItemIndex < 0) then raise Exception.Create('Vous n''avez pas sélectionné le mois.');
          if ComboBox3.Enabled and (ComboBox3.ItemIndex = 0) then raise Exception.Create('Vous n''avez pas sélectionné le jour.');
        end;
    end;
  except
    ApplicationShowException(Exception(ExceptObject));
    ModalResult := mrNone;
  end;
end;

procedure TEditJourFerie.CheckBox2Click(Sender: TObject);
begin
//  ColorBox1.Enabled := CheckBox2.Enabled;
end;

procedure TEditJourFerie.DateTimePicker1Change(Sender: TObject);
begin
  CheckBox1.Checked := True;
end;

procedure TEditJourFerie.ColorBox1Change(Sender: TObject);
begin
  CheckBox2.Checked := True;
end;

procedure TEditJourFerie.DateTimePicker2Change(Sender: TObject);
begin
  if DateTimePicker3.DateTime < DateTimePicker2.DateTime then
    DateTimePicker3.DateTime := DateTimePicker2.DateTime;  
end;

end.
