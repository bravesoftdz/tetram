object frmPublier: TfrmPublier
  Left = 443
  Top = 163
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Publication'
  ClientHeight = 402
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 0
    Top = 117
    Width = 30
    Height = 13
    Caption = '          '
  end
  object Label9: TLabel
    Left = 0
    Top = 165
    Width = 30
    Height = 13
    Caption = '          '
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 329
    Height = 89
    Caption = ' Donn'#233'es '#224' envoyer '
    TabOrder = 0
    object DateTimePicker1: TDateTimePicker
      Left = 200
      Top = 38
      Width = 89
      Height = 21
      Date = 39587.000000000000000000
      Time = 0.542089050919457800
      TabOrder = 0
      OnChange = DateTimePicker1Change
    end
    object RadioButton1: TRadioButton
      Left = 8
      Top = 16
      Width = 193
      Height = 17
      Caption = 'Envoyer les derni'#232'res modifications'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 40
      Width = 190
      Height = 17
      Caption = 'Envoyer les modifications depuis le '
      TabOrder = 2
    end
    object RadioButton3: TRadioButton
      Left = 8
      Top = 64
      Width = 105
      Height = 17
      Caption = 'R'#233'initialiser le site'
      TabOrder = 3
    end
  end
  object CheckBox2: TCheckBox
    Left = 0
    Top = 96
    Width = 113
    Height = 17
    Caption = 'Envoyer les images'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object Button1: TButton
    Left = 254
    Top = 180
    Width = 75
    Height = 25
    Caption = 'Publier'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 130
    Width = 329
    Height = 16
    Smooth = True
    TabOrder = 3
  end
  object ProgressBar2: TProgressBar
    Left = 0
    Top = 146
    Width = 329
    Height = 16
    Smooth = True
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 262
    Top = 385
    Width = 69
    Height = 17
    Caption = 'Continuer'
    TabOrder = 5
    Visible = False
  end
  object Memo1: TMemo
    Left = 0
    Top = 264
    Width = 329
    Height = 114
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 6
    Visible = False
  end
end
