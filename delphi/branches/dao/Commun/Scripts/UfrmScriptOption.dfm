object frmScriptOption: TfrmScriptOption
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Option'
  ClientHeight = 115
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 0
    Width = 301
    Height = 81
    Caption = 'RadioGroup1'
    Items.Strings = (
      '456'
      '456'
      '456')
    TabOrder = 0
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 90
    Width = 319
    Height = 25
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 90
    ExplicitWidth = 319
    ExplicitHeight = 25
    inherited btnOK: TButton
      Left = 156
      ExplicitLeft = 156
    end
    inherited btnAnnuler: TButton
      Left = 236
      ExplicitLeft = 236
    end
  end
end
