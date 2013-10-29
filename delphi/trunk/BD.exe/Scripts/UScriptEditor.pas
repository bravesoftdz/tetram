unit UScriptEditor;

interface

uses
  Classes, VCL.Controls, VCL.Graphics, VCL.Forms, SynEdit;

type
  TScriptEditorClass = class of TScriptEditor;

  TScriptEditor = class(TSynEdit)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BevelKind;
  end;

implementation

{ TScriptEditor }

constructor TScriptEditor.Create(AOwner: TComponent);
begin
  inherited;
  Align := alClient;
  Color := clWhite;
  ActiveLineColor := 16314351;
  Font.Color := clWindowText;
  Font.Height := -13;
  Font.name := 'Courier New';
  Font.Style := [];
  Gutter.AutoSize := True;
  Gutter.DigitCount := 3;
  Gutter.Font.Color := clWindowText;
  Gutter.Font.Height := -11;
  Gutter.Font.name := 'Terminal';
  Gutter.Font.Style := [];
  Gutter.LeftOffset := 27;
  Gutter.ShowLineNumbers := True;
  Gutter.Width := 0;
  BorderStyle := bsNone;
  BevelKind := bkTile;

  Options := [eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoKeepCaretX, eoRightMouseMovesCursor, eoScrollByOneLess,
    eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];

  ScrollHintFormat := shfTopToBottom;
  TabWidth := 2;
  WantTabs := True;
end;

end.
