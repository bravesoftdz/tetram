object frmScriptSearch: TfrmScriptSearch
  Left = 413
  Top = 409
  ActiveControl = ComboBox1
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Chercher / Remplacer'
  ClientHeight = 289
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 409
    Height = 257
    TabOrder = 3
    Tabs.Strings = (
      'Chercher'
      'Remplacer')
    TabIndex = 0
    OnChange = TabControl1Change
    object Label2: TLabel
      Left = 20
      Top = 60
      Width = 75
      Height = 13
      Caption = 'Remplacer par :'
    end
    object Label1: TLabel
      Left = 20
      Top = 36
      Width = 49
      Height = 13
      Caption = 'Chercher :'
    end
    object GroupBox1: TGroupBox
      Left = 12
      Top = 80
      Width = 185
      Height = 89
      Caption = 'Options'
      TabOrder = 0
      object CheckBox1: TCheckBox
        Left = 8
        Top = 16
        Width = 161
        Height = 17
        Caption = 'Diff'#233'rencier MAJ/min'
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 40
        Width = 161
        Height = 17
        Caption = 'Mots entiers'
        TabOrder = 1
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 64
        Width = 161
        Height = 17
        Caption = 'Confirmer les remplacements'
        TabOrder = 2
      end
    end
    object RadioGroup3: TRadioGroup
      Left = 12
      Top = 176
      Width = 185
      Height = 65
      Caption = 'Port'#233'e'
      ItemIndex = 0
      Items.Strings = (
        'S'#233'lection'
        'Tout le texte')
      TabOrder = 1
    end
    object ComboBox1: TComboBox
      Left = 100
      Top = 32
      Width = 297
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'ComboBox1'
    end
    object GroupBox2: TGroupBox
      Left = 212
      Top = 80
      Width = 185
      Height = 89
      Caption = 'Direction'
      TabOrder = 3
      object RadioButton1: TRadioButton
        Left = 8
        Top = 16
        Width = 161
        Height = 17
        Caption = 'Avant'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButton2: TRadioButton
        Left = 8
        Top = 40
        Width = 161
        Height = 17
        Caption = 'Arri'#232're'
        TabOrder = 1
      end
    end
    object RadioGroup2: TRadioGroup
      Left = 212
      Top = 176
      Width = 185
      Height = 65
      Caption = 'Origine'
      ItemIndex = 0
      Items.Strings = (
        'Depuis le curseur'
        'Toute la port'#233'e')
      TabOrder = 4
    end
    object ComboBox2: TComboBox
      Left = 100
      Top = 56
      Width = 297
      Height = 21
      ItemHeight = 13
      TabOrder = 5
      Text = 'ComboBox1'
    end
  end
  object Button1: TButton
    Left = 248
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 334
    Top = 264
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object Button3: TButton
    Left = 152
    Top = 264
    Width = 89
    Height = 25
    Caption = 'Tout remplacer'
    ModalResult = 10
    TabOrder = 2
    OnClick = Button3Click
  end
end
