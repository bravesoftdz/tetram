unit BDS.Scripts.PascalScript.Editor;

interface

uses
  System.SysUtils, Winapi.Windows, System.Classes, BDS.GUI.Controls.ScriptEditor, BDS.Scripts.Utils;

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
