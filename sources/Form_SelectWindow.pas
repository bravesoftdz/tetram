unit Form_SelectWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFSelectWindow = class(TForm)
    TreeView1: TTreeView;
    Button5: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FSelectWindow: TFSelectWindow;

implementation

{$R *.dfm}

type
  PSearchWindowsName = ^RSearchWindowsName;
  RSearchWindowsName = record
    TV: TTreeView;
    ParentNode: TTreeNode;
    ProcessChild: Boolean;
    ThisForm: TForm;
  end;

function EnumWindowsProc(hwnd: HWND; lParam: LPARAM): Boolean; cdecl;
var
  Buffer: array[0..1023] of Char;
  SearchWindowsName: PSearchWindowsName;
  SearchChildWindowsName: RSearchWindowsName;
begin
  SearchWindowsName := Pointer(lParam);
  if IsWindowVisible(hwnd) and
    (TForm(TForm(SearchWindowsName.ThisForm.Owner).Owner).Handle <> hwnd) and
    (TForm(SearchWindowsName.ThisForm.Owner).Handle <> hwnd) and
    (SearchWindowsName.ThisForm.Handle <> hwnd) and
    (GetWindowText(hwnd, @Buffer, 1024) > 0) then begin
    if SearchWindowsName.ProcessChild then begin
      SearchChildWindowsName.TV := SearchWindowsName.TV;
      SearchChildWindowsName.ProcessChild := False;
      SearchChildWindowsName.ThisForm := SearchWindowsName.ThisForm;
      SearchChildWindowsName.ParentNode := SearchWindowsName.TV.Items.Add(nil, Trim(Buffer));

      EnumChildWindows(hwnd, @EnumWindowsProc, Integer(@SearchChildWindowsName));
    end
    else begin
      SearchWindowsName.TV.Items.AddChild(SearchWindowsName.ParentNode, Trim(Buffer));
    end;
  end;

  Result := True;
end;

procedure TFSelectWindow.FormCreate(Sender: TObject);
var
  SearchWindowsName: RSearchWindowsName;
begin
  SearchWindowsName.TV := TreeView1;
  SearchWindowsName.ProcessChild := True;
  SearchWindowsName.ThisForm := Self;
  EnumWindows(@EnumWindowsProc, Integer(@SearchWindowsName));
end;

end.

 