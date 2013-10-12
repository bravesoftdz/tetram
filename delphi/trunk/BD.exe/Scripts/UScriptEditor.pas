unit UScriptEditor;

interface

uses SynEdit;

type
  TExecutableLines = array of boolean;

  TScriptEditorClass = class of TScriptEditor;

  TScriptEditor = class(TSynEdit)
  public
    FExecutableLines: TExecutableLines;
  published
    property BevelKind;
  end;

implementation

end.
