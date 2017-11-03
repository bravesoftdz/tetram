unit GzMemoDlg;

interface

uses
  SysUtils, Classes, Controls;

type
  TMemoEditDialog = class(TComponent)
  private
    FText: string;
    FTitle: string;
    { D�clarations priv�es }
  protected
    { D�clarations prot�g�es }
  public
    { D�clarations publiques }
    function Execute : Boolean;
  published
    { D�clarations publi�es }
    property Title : string read FTitle write FTitle;
    property Text : string read FText write FText;
  end;


implementation

uses FMemoEditDlg;

{ TMemoEditDialog }

function TMemoEditDialog.Execute: Boolean;
var
  AFen : TDlgMemoEdit;
begin
  Result := False;
  AFen := TDlgMemoEdit.Create(Self);
  try
    AFen.Caption := Title;
    AFen.Memo1.Text := Text;
    if AFen.ShowModal = mrOk then
    begin
      Result := True;
      Text := AFen.Memo1.Text;
    end;
  finally
    AFen.Free;
  end;
end;

end.
 