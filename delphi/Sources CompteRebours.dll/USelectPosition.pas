unit USelectPosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    FLastColumn: Integer;
  end;

var
  Form1: TForm1;

implementation

uses GPS, Math;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FLastColumn := 1;
  ComboBox1.Items.Clear;
  for i := Low(Coordonnees) to High(Coordonnees) do
    ComboBox1.Items.Add(Coordonnees[i].Nom);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: Integer;
begin
  ListView1.Columns[0].Caption := Coordonnees[ComboBox1.ItemIndex].Intitules[0];
  ListView1.Columns[1].Caption := Coordonnees[ComboBox1.ItemIndex].Intitules[1];
  ListView1.Clear;
  for i := 1 to Coordonnees[ComboBox1.ItemIndex].nVilles do
    with ListView1.Items.Add do begin
      Caption := Coordonnees[ComboBox1.ItemIndex].Villes[i].Intitule1;
      SubItems.Add(Coordonnees[ComboBox1.ItemIndex].Villes[i].Nom);
      SubItems.Add(FloatToStr(Coordonnees[ComboBox1.ItemIndex].Villes[i].Latitude));
      SubItems.Add(FloatToStr(Coordonnees[ComboBox1.ItemIndex].Villes[i].Longitude));
    end;

end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  FLastColumn := Column.Index;
  ListView1.AlphaSort;
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  case FLastColumn of
    0: Compare := CompareStr(Item1.Caption, Item2.Caption);
    1: Compare := CompareStr(Item1.SubItems[0], Item2.SubItems[0]);
    2: Compare := CompareValue(StrToFloat(Item1.SubItems[1]), StrToFloat(Item2.SubItems[1]));
    3: Compare := CompareValue(StrToFloat(Item1.SubItems[2]), StrToFloat(Item2.SubItems[2]));
  end;
end;

end.
