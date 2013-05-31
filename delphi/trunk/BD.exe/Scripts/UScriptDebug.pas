unit UScriptDebug;

interface

uses
  SysUtils, Types, Classes, Graphics, SynEdit, UScriptUtils;

type
  TSynDebugPlugin = class(TSynEditPlugin)
  strict private
    FDebug: TDebugInfos;
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer); override;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
  public
    constructor Create(AOwner: TCustomSynEdit; Debug: TDebugInfos); reintroduce;
  end;

implementation

procedure TSynDebugPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer);
begin
  inherited;
end;

constructor TSynDebugPlugin.Create(AOwner: TCustomSynEdit; Debug: TDebugInfos);
begin
  inherited Create(AOwner);
  FDebug := Debug;
end;

procedure TSynDebugPlugin.LinesDeleted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := Pred(FDebug.Breakpoints.Count) downto 0 do
    if FDebug.Breakpoints[i].Line in [FirstLine..FirstLine + Count] then
      FDebug.Breakpoints.Delete(i)
    else if FDebug.Breakpoints[i].Line > Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Breakpoints[i].Line);
      FDebug.Breakpoints[i].Line := FDebug.Breakpoints[i].Line - Cardinal(Count);
    end;

  for i := Pred(FDebug.Messages.Count) downto 0 do
    if FDebug.Messages[i].Line in [FirstLine..FirstLine + Count] then
      FDebug.Messages.Delete(i)
    else if FDebug.Messages[i].Line > Cardinal(FirstLine) then
      FDebug.Messages[i].Line := FDebug.Messages[i].Line - Cardinal(Count);
end;

procedure TSynDebugPlugin.LinesInserted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FDebug.Breakpoints.Count - 1 do
    if FDebug.Breakpoints[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Breakpoints[i].Line);
      FDebug.Breakpoints[i].Line := FDebug.Breakpoints[i].Line + Cardinal(Count);
    end;
  for i := 0 to FDebug.Messages.Count - 1 do
    if FDebug.Messages[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Messages[i].Line);
      FDebug.Messages[i].Line := FDebug.Messages[i].Line + Cardinal(Count);
    end;
end;

end.
