unit UfrmProgression;

{.$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, Commun, UBdtForms,
  JvExControls, JvLabel, UframBoutons;

type
  TProgressBar = class(ComCtrls.TProgressBar)
  private
    function GetPosition: Integer;
    procedure SetPosition(Value: Integer);
    function GetMax: Integer;
    procedure SetMax(Value: Integer);
    procedure RefreshLabel;
  protected
    FLabel: TLabel;
  published
    property Position: Integer read GetPosition write SetPosition;
    property Max: Integer read GetMax write SetMax;
    property BevelKind;
  end;

  TfrmProgression = class(TbdtForm)
    op: TLabel;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    framBoutons1: TframBoutons;
    procedure FormCreate(Sender: TObject);
  private
    hg: IHourGlass;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.DFM}

function TProgressBar.GetMax: Integer;
begin
  Result := inherited Max;
end;

function TProgressBar.GetPosition: Integer;
begin
  Result := inherited Position;
end;

procedure TProgressBar.RefreshLabel;
begin
  if Assigned(FLabel) then
    if Max = Min then
      FLabel.Caption := ''
    else
      FLabel.Caption := IntToStr(Trunc(MulDiv(Position, 100, Max - Min))) + ' %';
end;

procedure TProgressBar.SetMax(Value: Integer);
begin
  if Value > Min then
  begin
    inherited Max := Value;
    RefreshLabel;
  end;
end;

procedure TProgressBar.SetPosition(Value: Integer);
begin
  if (Value >= Min) and (Value <= Max) then
  begin
    inherited Position := Value;
    RefreshLabel;
  end;
end;

procedure TfrmProgression.FormCreate(Sender: TObject);
begin
  hg := THourGlass.Create;
  framBoutons1.btnOK.Visible := False;
  ProgressBar1.FLabel := Label1;
end;

end.
