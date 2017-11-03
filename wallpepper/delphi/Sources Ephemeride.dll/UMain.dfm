object FMain: TFMain
  Left = 379
  Top = 222
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Ephemeride'
  ClientHeight = 313
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 425
    Height = 105
  end
  object Bevel17: TBevel
    Left = 0
    Top = 112
    Width = 425
    Height = 105
  end
  object Label65: TLabel
    Left = 8
    Top = 191
    Width = 68
    Height = 13
    Caption = 'Autres infos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label66: TLabel
    Left = 8
    Top = 122
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
  object Label70: TLabel
    Left = 104
    Top = 167
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
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 67
    Height = 13
    Caption = 'Eph'#233'm'#233'ride'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 167
    Width = 71
    Height = 13
    Caption = 'Date du jour'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 280
    Top = 167
    Width = 36
    Height = 13
    Caption = 'Couleur'
  end
  object Label4: TLabel
    Left = 104
    Top = 191
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
    Left = 280
    Top = 191
    Width = 36
    Height = 13
    Caption = 'Couleur'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 224
    Width = 425
    Height = 57
  end
  object Label6: TLabel
    Left = 8
    Top = 232
    Width = 127
    Height = 13
    Caption = 'Position g'#233'ographique'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 280
    Top = 260
    Width = 47
    Height = 13
    Caption = 'Longitude'
  end
  object Label8: TLabel
    Left = 280
    Top = 236
    Width = 38
    Height = 13
    Caption = 'Latitude'
  end
  object CheckBox1: TCheckBox
    Left = 136
    Top = 8
    Width = 84
    Height = 17
    Caption = 'Date du jour'
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 136
    Top = 32
    Width = 113
    Height = 17
    Caption = 'Quanti'#232'me du jour'
    TabOrder = 1
  end
  object CheckBox3: TCheckBox
    Left = 136
    Top = 56
    Width = 49
    Height = 17
    Caption = 'Saints'
    TabOrder = 2
  end
  object CheckBox4: TCheckBox
    Left = 261
    Top = 56
    Width = 116
    Height = 17
    Caption = 'Horaires de la lune'
    TabOrder = 5
  end
  object Button1: TButton
    Left = 270
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 13
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 350
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 14
  end
  object ColorBox2: TColorBox
    Left = 328
    Top = 162
    Width = 89
    Height = 22
    DefaultColorColor = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 9
  end
  object ComboBox1: TComboBox
    Left = 136
    Top = 117
    Width = 281
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 6
    OnDrawItem = ComboBox1DrawItem
    OnMeasureItem = ComboBox1MeasureItem
  end
  object SpinEdit2: TSpinEdit
    Left = 136
    Top = 162
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = -10
    TabOrder = 7
    Value = 0
  end
  object CheckBox8: TCheckBox
    Left = 187
    Top = 165
    Width = 65
    Height = 17
    Caption = 'Effet 3D'
    TabOrder = 8
  end
  object CheckBox5: TCheckBox
    Left = 261
    Top = 32
    Width = 105
    Height = 17
    Caption = 'Horaires du soleil'
    TabOrder = 4
  end
  object ColorBox1: TColorBox
    Left = 328
    Top = 186
    Width = 89
    Height = 22
    DefaultColorColor = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 12
  end
  object SpinEdit1: TSpinEdit
    Left = 136
    Top = 186
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = -10
    TabOrder = 10
    Value = 0
  end
  object CheckBox6: TCheckBox
    Left = 187
    Top = 189
    Width = 65
    Height = 17
    Caption = 'Effet 3D'
    TabOrder = 11
  end
  object CheckBox7: TCheckBox
    Left = 261
    Top = 8
    Width = 57
    Height = 17
    Caption = 'Saison'
    TabOrder = 3
  end
  object CheckBox9: TCheckBox
    Left = 8
    Top = 80
    Width = 89
    Height = 17
    Caption = 'Horaires GMT'
    TabOrder = 15
  end
  object Button3: TButton
    Left = 168
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Choisir'
    TabOrder = 16
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 328
    Top = 256
    Width = 89
    Height = 21
    TabOrder = 17
  end
  object Edit2: TEdit
    Left = 328
    Top = 232
    Width = 89
    Height = 21
    TabOrder = 18
  end
  object CheckBox10: TCheckBox
    Left = 261
    Top = 80
    Width = 108
    Height = 17
    Caption = 'Phases de la lune'
    TabOrder = 19
  end
end
