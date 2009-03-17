object frmEditCritere: TfrmEditCritere
  Left = 732
  Top = 251
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = ' '
  ClientHeight = 112
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
  object signes: TLightComboCheck
    Left = 8
    Top = 32
    Width = 105
    Height = 22
    Cursor = crHandPoint
    Visible = False
    Checked = False
    CaptionUnchecked = 'Comparaison'
    PropertiesStored = False
    CheckVisible = False
    FillCaption = False
    ShowCaptionHint = True
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' '
    Items = <>
  end
  object Critere2: TLightComboCheck
    Left = 120
    Top = 32
    Width = 105
    Height = 22
    Cursor = crHandPoint
    Visible = False
    Checked = False
    CaptionUnchecked = 'Valeur / Langue'
    PropertiesStored = False
    CheckVisible = False
    FillCaption = False
    ShowCaptionHint = True
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' '
    Items = <>
  end
  object valeur: TEditLabeled
    Left = 8
    Top = 56
    Width = 217
    Height = 19
    Hint = 'Valeur de r'#233'f'#233'rence (recherche multi-crit'#232'res)'
    BevelKind = bkTile
    BorderStyle = bsNone
    TabOrder = 0
    Visible = False
    LinkControls = <>
    CurrencyChar = #0
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 87
    Width = 231
    Height = 25
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 87
    ExplicitWidth = 231
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
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Top = 80
    object ActOk: TAction
      Caption = 'OK'
      OnExecute = ActOkExecute
    end
  end
end
