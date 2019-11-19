object frmProgression: TfrmProgression
  Left = 535
  Top = 202
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Travail en cours...'
  ClientHeight = 74
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    367
    74)
  PixelsPerInch = 96
  TextHeight = 13
  object op: TLabel
    Left = 0
    Top = 0
    Width = 358
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    ShowAccelChar = False
    Transparent = True
    ExplicitWidth = 348
  end
  object Label1: TLabel
    Left = 330
    Top = 22
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = '50 %'
    ExplicitLeft = 320
  end
  object ProgressBar1: TProgressBar
    Left = 3
    Top = 22
    Width = 321
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    Position = 50
    Smooth = True
    TabOrder = 0
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 49
    Width = 367
    Height = 25
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 49
    ExplicitWidth = 367
    ExplicitHeight = 25
    inherited btnOK: TButton
      Left = 204
      ExplicitLeft = 204
    end
    inherited btnAnnuler: TButton
      Left = 284
      ExplicitLeft = 284
    end
  end
end
