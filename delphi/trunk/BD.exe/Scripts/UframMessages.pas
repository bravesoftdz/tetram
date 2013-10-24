unit UframMessages;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, UMasterEngine;

type
  TframMessages = class(TFrame)
    vstMessages: TVirtualStringTree;
    procedure vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    FMasterEngine: IMasterEngine;
    procedure SetMasterEngine(const Value: IMasterEngine);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Invalidate; override;
    property MasterEngine: IMasterEngine read FMasterEngine write SetMasterEngine;
  end;

implementation

uses
  UScriptUtils;

{$R *.dfm}

procedure TframMessages.Invalidate;
begin
  inherited;
  vstMessages.Invalidate;
end;

procedure TframMessages.SetMasterEngine(const Value: IMasterEngine);
begin
  if FMasterEngine <> nil then
    FMasterEngine.DebugPlugin.Messages.View := nil;
  FMasterEngine := Value;
  if FMasterEngine <> nil then
    FMasterEngine.DebugPlugin.Messages.View := vstMessages;
end;

procedure TframMessages.vstMessagesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with MasterEngine.DebugPlugin.Messages[Node.index] do
    case Column of
      0:
        case Category of
          cmInfo:
            CellText := 'Information';
          cmCompileError:
            CellText := 'Compilation';
          cmRuntimeError:
            CellText := 'Exécution';
        else
          CellText := '';
        end;
      1:
        CellText := string(TypeMessage);
      2:
        if Fichier = MasterEngine.Engine.GetSpecialMainUnitName then
          // CellText := Projet
        else
          CellText := string(Fichier);
      3:
        CellText := string(Text);
    end;
end;

end.
