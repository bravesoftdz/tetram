unit UDWScriptEditor;

interface

uses
  System.SysUtils, Winapi.Windows, System.Classes, UScriptEditor, UScriptUtils;

type
  TDWScriptEditor = class(TScriptEditor)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TDWScriptEditor }

constructor TDWScriptEditor.Create(AOwner: TComponent);
begin
  inherited;

end;

end.
