object frmProgression: TfrmProgression
  Left = 535
  Top = 202
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Travail en cours...'
  ClientHeight = 47
  ClientWidth = 196
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object op: TLabel
    Left = 4
    Top = 4
    Width = 187
    Height = 16
    AutoSize = False
    Transparent = True
  end
  object ProgressBar1: TMKProgressBar
    Left = 4
    Top = 24
    Width = 187
    Height = 21
    BarBevelOuter = bvNone
    BevelOuter = bvLowered
    Orientation = orHorizontal
    Max = 100
    Min = 0
    Position = 100
    ShowText = True
    ShowTextStyle = stsPercent
    BeginColor = clActiveCaption
    EndColor = clWhite
    Style = sExSolid
    Step = 1
    TransparentGlyph = True
  end
end
