unit VirtualTree;

interface

uses
  SysUtils, Classes, Graphics, LinkControls, VirtualTrees, Controls;

type
  TVirtualStringTree = class(VirtualTrees.TVirtualStringTree)
  strict private
    FSynchroBackground: Boolean;
    FLinkControls: TControlList;

    procedure SetLinkControls(const Value: TControlList);
  protected
    procedure DoScroll(DeltaX, DeltaY: Integer);override;
    procedure DoEnter;override;
    procedure DoExit;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    procedure BackgroundChange(Sender: TObject);
  published
    property SynchroBackground: Boolean read FSynchroBackground write FSynchroBackground default False;
    property LinkControls: TControlList read FLinkControls write SetLinkControls;
  end;

implementation

constructor TVirtualStringTree.Create(AOwner: TComponent);
begin
  inherited;
  Background.OnChange := BackgroundChange;
  FLinkControls := TControlList.Create;
  FSynchroBackground := False;
  ButtonFillMode := fmShaded;
  ButtonStyle := bsRectangle;
  AnimationDuration := 0;
  //  DefaultNodeHeight := 16;
  DefaultText := '';
  TreeOptions.PaintOptions := [toHideFocusRect, toHotTrack, toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused];
  TreeOptions.AutoOptions := [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes];
  TreeOptions.MiscOptions := [{toFullRepaintOnResize, }toInitOnSave, toToggleOnDblClick, toWheelPanning];
  TreeOptions.SelectionOptions := [toFullRowSelect];
  TreeOptions.StringOptions := [toSaveCaptions, toAutoAcceptEditChange];
  if Header.Columns.Count > 0 then
  begin
    Header.AutoSizeIndex := 0;
    Header.Options := Header.Options + [hoAutoResize];
  end;
  HintMode := hmTooltip;
  HintAnimation := hatNone;
  HotCursor := crHandPoint;
  Color := clWhite;
  //  if clBtnFace = clWhite then
  begin
    Colors.BorderColor := clSilver;
    Colors.GridLineColor := clSilver;
    Colors.TreeLineColor := clSilver;
    Colors.UnfocusedSelectionColor := clSilver;
    Colors.UnfocusedSelectionBorderColor := clSilver;
  end;
end;

destructor TVirtualStringTree.Destroy;
begin
  FLinkControls.Free;
  inherited;
end;

procedure TVirtualStringTree.DoScroll(DeltaX, DeltaY: Integer);
begin
  inherited;
  if SynchroBackground then
  begin
    BackgroundOffsetY := BackgroundOffsetY - DeltaY;
    BackgroundOffsetX := BackgroundOffsetX - DeltaX;
  end;
end;

procedure TVirtualStringTree.SetLinkControls(const Value: TControlList);
begin
  FLinkControls.Assign(Value);
end;

procedure TVirtualStringTree.DoEnter;
begin
  FLinkControls.DoEnter;
  inherited;
end;

procedure TVirtualStringTree.DoExit;
begin
  FLinkControls.DoExit;
  inherited;
end;

procedure TVirtualStringTree.BackgroundChange(Sender: TObject);
begin
  if Background.Graphic.Empty then
    TreeOptions.PaintOptions := TreeOptions.PaintOptions - [toShowBackground]
  else
    TreeOptions.PaintOptions := TreeOptions.PaintOptions + [toShowBackground];
end;

end.
