object frmEditCritereTri: TfrmEditCritereTri
  Left = 732
  Top = 251
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = ' '
  ClientHeight = 132
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object champs: TLightComboCheck
    Left = 8
    Top = 8
    Width = 217
    Height = 22
    Cursor = crHandPoint
    Hint = 'Liste des champs (recherche multi-crit'#232'res)'
    Checked = False
    CaptionUnchecked = 'Choisissez une donn'#233'e'
    PropertiesStored = False
    CheckVisible = False
    FillCaption = False
    OnChange = champsChange
    ShowCaptionHint = True
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' - '
    Items = <>
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 107
    Width = 231
    Height = 25
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 107
    ExplicitWidth = 231
    ExplicitHeight = 25
    inherited btnOK: TButton
      Left = 100
      Width = 55
      Action = ActOk
      ExplicitLeft = 100
      ExplicitWidth = 55
    end
    inherited btnAnnuler: TButton
      Left = 160
      Width = 64
      ExplicitLeft = 160
      ExplicitWidth = 64
    end
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 32
    Width = 81
    Height = 17
    Caption = 'Croissant'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 120
    Top = 32
    Width = 89
    Height = 17
    Caption = 'D'#233'croissant'
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Vide en premier'
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 120
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Vide en dernier'
    TabOrder = 4
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Imprimer'
    Enabled = False
    TabOrder = 5
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 200
    Top = 72
    object ActOk: TAction
      Caption = 'OK'
      OnExecute = ActOkExecute
    end
  end
end
