unit UPascalScriptEditor;

interface

uses
  System.SysUtils, Winapi.Windows, System.Classes, UScriptEditor, UScriptUtils;

type
  TPascalScriptEditor = class(TScriptEditor)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TPascalScriptEditor }

constructor TPascalScriptEditor.Create(AOwner: TComponent);
begin
  inherited;

end;

end.
