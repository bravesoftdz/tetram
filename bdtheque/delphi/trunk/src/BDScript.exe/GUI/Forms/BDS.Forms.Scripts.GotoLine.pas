unit BDS.Forms.Scripts.GotoLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmScriptGotoLine = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
  private
    function GetLineNumber: Integer;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property LineNumber: Integer read GetLineNumber;
  end;

implementation

{$R *.dfm}

{ TfrmScriptGotoLine }

function TfrmScriptGotoLine.GetLineNumber: Integer;
begin
  Result := StrToInt(Edit1.Text);
end;

end.
