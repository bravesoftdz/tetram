unit UfrmConsole;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ComCtrls, Vcl.ToolWin, Generics.Collections,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TTraceEvent = class
    TimeStamp: TDateTime;
    Unite: string;
    Evenement: string;

    Duree: Integer;

    Index: Integer;

    constructor Create;
  end;

  TSeparatorEvent = class(TTraceEvent);

  TfrmConsole = class(TForm)
    vstConsole: TVirtualStringTree;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstConsoleGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure Button1Click(Sender: TObject);
    procedure vstConsoleInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  strict private
    class var _instance: TfrmConsole;
  private
    { Déclarations privées }
    FListEvents: TObjectList<TTraceEvent>;
    procedure EventNotification(Sender: TObject; const Item: TTraceEvent; Action: TCollectionNotification);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class procedure AddEvent(const Unite, Evenement: string);
    class procedure AddSeparator;
  end;

implementation

uses
  BDTK.Main.DataModule, DateUtils;

{$R *.dfm}
{ TTraceEvent }

constructor TTraceEvent.Create;
begin
  TimeStamp := Now;
end;

class procedure TfrmConsole.AddEvent(const Unite, Evenement: string);
var
  e: TTraceEvent;
begin
  if not Assigned(_instance) then
    Exit;

  e := TTraceEvent.Create;
  e.Unite := Unite;
  e.Evenement := Evenement;
  _instance.FListEvents.Add(e);

  _instance.vstConsole.ScrollIntoView(_instance.vstConsole.RootNode.LastChild, False);
end;

class procedure TfrmConsole.AddSeparator;
begin
  if not Assigned(_instance) then
    Exit;

  if (_instance.FListEvents.Count > 0) and not(_instance.FListEvents.Last is TSeparatorEvent) then
    _instance.FListEvents.Add(TSeparatorEvent.Create);
end;

procedure TfrmConsole.AfterConstruction;
begin
  inherited;
  _instance := Self;
end;

procedure TfrmConsole.BeforeDestruction;
begin
  inherited;
  _instance := nil;
end;

procedure TfrmConsole.Button1Click(Sender: TObject);
begin
  FListEvents.Clear;
end;

procedure TfrmConsole.EventNotification(Sender: TObject; const Item: TTraceEvent; Action: TCollectionNotification);
var
  e: TTraceEvent;
begin
  Item.Index := FListEvents.Count - 1;
  if Item.Index > 0 then
  begin
    e := FListEvents[Item.Index - 1];
    e.Duree := MilliSecondsBetween(Item.TimeStamp, e.TimeStamp);
  end;

  vstConsole.RootNodeCount := FListEvents.Count;
end;

procedure TfrmConsole.FormActivate(Sender: TObject);
begin
  Self.AlphaBlend := False;
end;

procedure TfrmConsole.FormCreate(Sender: TObject);
begin
  FListEvents := TObjectList<TTraceEvent>.Create(True);
  FListEvents.OnNotify := EventNotification;
end;

procedure TfrmConsole.FormDeactivate(Sender: TObject);
begin
  Self.AlphaBlend := True;
end;

procedure TfrmConsole.FormDestroy(Sender: TObject);
begin
  vstConsole.RootNodeCount := 0;
  FListEvents.OnNotify := nil;
  FListEvents.Free;
end;

procedure TfrmConsole.FormShow(Sender: TObject);
var
  t, l: Integer;
begin
  t := Monitor.WorkareaRect.Height - Self.Height;
  l := Monitor.WorkareaRect.Width - Self.Width;

  Self.SetBounds(l, t, Width, Height);

  if Assigned(Application.MainForm) and Application.MainForm.CanFocus then
    Application.MainForm.SetFocus;
end;

procedure TfrmConsole.vstConsoleGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  e, p: TTraceEvent;
  d: Integer;
begin
  e := FListEvents[Node.Index];
  if not(e is TSeparatorEvent) then
    case Column of
      0:
        CellText := FormatDateTime('hh:mm:ss:zzz', e.TimeStamp);
      1:
        CellText := e.Unite;
      2:
        CellText := e.Evenement;
      3:
        // if e.Duree > 0 then
          CellText := Format('%d:%.3d', [e.Duree div 1000, e.Duree mod 1000]);
      4:
        begin
          while Assigned(Node.PrevSibling) and not(FListEvents[Node.PrevSibling.Index] is TSeparatorEvent) do
            Node := Node.PrevSibling;
          p := FListEvents[Node.Index];
          // if e <> p then
          begin
            d := MilliSecondsBetween(e.TimeStamp, p.TimeStamp) + e.Duree;
            CellText := Format('%d:%.3d', [d div 1000, d mod 1000]);
          end;
        end;
    end;
end;

procedure TfrmConsole.vstConsoleInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  e: TTraceEvent;
begin
  e := FListEvents[Node.Index];
  if e is TSeparatorEvent then
  begin
    Include(InitialStates, ivsDisabled);
    Node.NodeHeight := 8;
  end;
end;

end.
