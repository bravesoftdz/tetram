object frmScriptGotoLine: TfrmScriptGotoLine
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  BorderWidth = 4
  Caption = 'Aller '#224' la ligne'
  ClientHeight = 73
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 47
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 126
    Top = 47
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 247
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 14
      Width = 84
      Height = 13
      Caption = 'Num'#233'ro de ligne :'
    end
    object Edit1: TEdit
      Left = 112
      Top = 11
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      Text = '1'
    end
  end
end
