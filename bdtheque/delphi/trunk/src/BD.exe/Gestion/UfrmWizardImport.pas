unit UfrmWizardImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ActnList, BD.GUI.Forms,
  pngimage, System.Actions, PngSpeedButton, VDTButton;

type
  TPageControl = class(ComCtrls.TPageControl)
  private
    function SearchVisible(GoForward: Boolean): TTabSheet;
  public
    function NextVisible: TTabSheet;
    function PreviousVisible: TTabSheet;
  end;

  TfrmWizardImport = class(TbdtForm)
    ActionList1: TActionList;
    actNextPage: TAction;
    actPreviousPage: TAction;
    Panel2: TPanel;
    Panel1: TPanel;
    btnAnnuler: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    TabSheetTypeSource: TTabSheet;
    TabSheetSource: TTabSheet;
    TabSheetFinal: TTabSheet;
    Panel3: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label4: TLabel;
    ComboBox1: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    OpenDialog1: TOpenDialog;
    Label9: TLabel;
    Button1: TButton;
    Label10: TLabel;
    Bevel1: TPanel;
    TabSheetTypeDonnees: TTabSheet;
    Label11: TLabel;
    ComboBox2: TComboBox;
    Label12: TLabel;
    TabSheetChamps: TTabSheet;
    Label13: TLabel;
    Label14: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    VDTButton2: TVDTButton;
    VDTButton4: TVDTButton;
    VDTButton3: TVDTButton;
    procedure FormCreate(Sender: TObject);
    procedure actPreviousPageExecute(Sender: TObject);
    procedure actNextPageExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure TabSheetSourceShow(Sender: TObject);
  private
    FSource: string;
    procedure SetSource(const Value: string);
    function GetCurrentMask: string;
  public
    { Déclarations publiques }
    function IsValidePage(Page: TTabSheet): Boolean;
    function IsValideCurrentPage: Boolean;

    property Source: string read FSource write SetSource;
  end;

var
  frmWizardImport: TfrmWizardImport;

implementation

uses StrUtils, FileCtrl, Masks;

{$R *.dfm}

function TPageControl.NextVisible: TTabSheet;
begin
  Result := SearchVisible(True);
end;

function TPageControl.PreviousVisible: TTabSheet;
begin
  Result := SearchVisible(False);
end;

function TPageControl.SearchVisible(GoForward: Boolean): TTabSheet;
var
  I, StartIndex: Integer;
begin
  if PageCount <> 0 then begin
    StartIndex := ActivePageIndex;
    if StartIndex = -1 then
      if GoForward then
        StartIndex := PageCount - 1
      else
        StartIndex := 0;
    I := StartIndex;
    repeat
      if GoForward then begin
        Inc(I);
        if I = PageCount then I := 0;
      end
      else begin
        if I = 0 then I := PageCount;
        Dec(I);
      end;
      Result := Pages[I];
      if Result.Tag = 1 then Exit;
    until I = StartIndex;
  end;
  Result := nil;
end;

{ TForm1 }

procedure TfrmWizardImport.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(PageControl1.PageCount) do
    with PageControl1.Pages[i] do begin
      TabVisible := False;
      Tag := 1;
    end;

  PageControl1.ActivePageIndex := 0;
  Source := '';
end;

procedure TfrmWizardImport.actPreviousPageExecute(Sender: TObject);
begin
  PageControl1.ActivePage := PageControl1.PreviousVisible;
end;

procedure TfrmWizardImport.actNextPageExecute(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = PageControl1.PageCount - 1 then
    ModalResult := mrOk
  else
    PageControl1.ActivePage := PageControl1.NextVisible;
end;

procedure TfrmWizardImport.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  actPreviousPage.Enabled := PageControl1.ActivePageIndex > 0;
  actNextPage.Enabled := IsValideCurrentPage;
  if PageControl1.ActivePageIndex = PageControl1.PageCount - 1 then
    actNextPage.Caption := 'Terminer'
  else
    actNextPage.Caption := 'Suivant';
end;

function TfrmWizardImport.IsValideCurrentPage: Boolean;
begin
  Result := IsValidePage(PageControl1.ActivePage);
end;

function TfrmWizardImport.IsValidePage(Page: TTabSheet): Boolean;
begin
  Result := (Page = TabSheet1) or (Page = TabSheetFinal);
  if Result then Exit;
  if Page = TabSheetTypeSource then
    Result := ComboBox1.ItemIndex <> -1
  else if Page = TabSheetSource then
    Result := FSource <> ''
  else if Page = TabSheetTypeDonnees then
    Result := ComboBox2.ItemIndex <> -1
  else if Page = TabSheetChamps then
    Result := ListBox2.Items.Count > 0
  else
    ;
end;

procedure TfrmWizardImport.SetSource(const Value: string);
begin
  FSource := Value;
  Label10.Caption := MinimizeName(FSource, Label10.Canvas, Label10.Width);
end;

procedure TfrmWizardImport.Button1Click(Sender: TObject);
begin
  OpenDialog1.Filter := ComboBox1.Text + '|' + GetCurrentMask;
  if OpenDialog1.Execute then Source := OpenDialog1.FileName;
end;

function TfrmWizardImport.GetCurrentMask: string;
begin
  case ComboBox1.ItemIndex of
    0: Result := '*.csv';
    1: Result := '*.xls';
    2: Result := '*.xbd';
    3: Result := 'bd.fdb;bd.gdb';
    else
      Result := '';
  end;
end;

procedure TfrmWizardImport.TabSheetSourceShow(Sender: TObject);
begin
  if not MatchesMask(FSource, GetCurrentMask) then Source := '';
end;

end.

