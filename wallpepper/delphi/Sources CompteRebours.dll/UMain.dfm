object FMain: TFMain
  Left = 362
  Top = 296
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Compte '#224' rebours'
  ClientHeight = 193
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 425
    Height = 89
  end
  object Label1: TLabel
    Left = 208
    Top = 10
    Width = 59
    Height = 13
    Caption = 'Description :'
  end
  object Bevel17: TBevel
    Left = 0
    Top = 96
    Width = 425
    Height = 65
  end
  object Label66: TLabel
    Left = 8
    Top = 106
    Width = 112
    Height = 13
    Caption = 'Police de caract'#232're'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 104
    Top = 135
    Width = 25
    Height = 13
    Caption = 'Taille'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 272
    Top = 135
    Width = 36
    Height = 13
    Caption = 'Couleur'
  end
  object Label6: TLabel
    Left = 8
    Top = 10
    Width = 58
    Height = 13
    Caption = 'Ech'#233'ance'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 208
    Top = 32
    Width = 207
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 270
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 350
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 9
  end
  object ComboBox1: TComboBox
    Left = 136
    Top = 101
    Width = 281
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 4
    OnDrawItem = ComboBox1DrawItem
    OnMeasureItem = ComboBox1MeasureItem
  end
  object ColorBox1: TColorBox
    Left = 320
    Top = 130
    Width = 89
    Height = 22
    DefaultColorColor = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 7
  end
  object SpinEdit1: TSpinEdit
    Left = 136
    Top = 130
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = -10
    TabOrder = 5
    Value = 0
  end
  object CheckBox1: TCheckBox
    Left = 187
    Top = 133
    Width = 65
    Height = 17
    Caption = 'Effet 3D'
    TabOrder = 6
  end
  object DateTimePicker1: TDateTimePicker
    Left = 8
    Top = 32
    Width = 193
    Height = 21
    Date = 38258.901801585650000000
    Time = 38258.901801585650000000
    DateFormat = dfLong
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 64
    Width = 121
    Height = 17
    Caption = 'Exclure Week-End'
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    Left = 208
    Top = 64
    Width = 113
    Height = 17
    Caption = 'Exclure jours f'#233'ries'
    TabOrder = 3
  end
end
