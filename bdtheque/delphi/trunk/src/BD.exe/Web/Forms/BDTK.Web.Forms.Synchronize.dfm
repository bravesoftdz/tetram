object frmSynchroniser: TfrmSynchroniser
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Synchronisation'
  ClientHeight = 359
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 0
    Top = 71
    Width = 30
    Height = 13
    Caption = '          '
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 87
    Width = 329
    Height = 16
    Smooth = True
    TabOrder = 0
  end
  object ProgressBar2: TProgressBar
    Left = 0
    Top = 103
    Width = 329
    Height = 16
    Smooth = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 248
    Top = 137
    Width = 81
    Height = 25
    Caption = 'Synchroniser'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 221
    Width = 329
    Height = 114
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 3
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 262
    Top = 342
    Width = 69
    Height = 17
    Caption = 'Continuer'
    TabOrder = 4
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 329
    Height = 65
    Caption = ' Donn'#233'es '#224' envoyer '
    TabOrder = 5
    Visible = False
    object RadioButton1: TRadioButton
      Left = 8
      Top = 16
      Width = 193
      Height = 17
      Caption = 'Envoyer les derni'#232'res modifications'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton3: TRadioButton
      Left = 8
      Top = 39
      Width = 105
      Height = 17
      Caption = 'R'#233'initialiser le site'
      TabOrder = 1
    end
  end
end
