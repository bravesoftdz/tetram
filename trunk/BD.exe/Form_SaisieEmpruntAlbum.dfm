object FrmSaisie_EmpruntAlbum: TFrmSaisie_EmpruntAlbum
  Left = 457
  Top = 358
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Saisie d'#39'un mouvement d'#39'album'
  ClientHeight = 257
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    479
    257)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 213
    Width = 23
    Height = 11
    Hint = 'Date du mouvement'
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Date:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 37
    Top = 48
    Width = 179
    Height = 73
    Anchors = [akLeft, akTop, akBottom]
    AutoSize = False
    Caption = ' '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label3: TLabel
    Left = 4
    Top = 47
    Width = 30
    Height = 11
    Hint = 'Date du mouvement'
    Alignment = taRightJustify
    Caption = 'Album:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object VDTButton2: TVDTButton
    Left = 445
    Top = 6
    Width = 26
    Height = 17
    Cursor = crHandPoint
    Anchors = [akTop, akRight]
    Caption = '...'
    Flat = True
    OnClick = ScanEditEmprunteurClick
  end
  object Label4: TLabel
    Left = 10
    Top = 7
    Width = 24
    Height = 11
    Hint = 'Date du mouvement'
    Alignment = taRightJustify
    Caption = 'S'#233'rie:'
    FocusControl = date_pret
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 37
    Top = 8
    Width = 179
    Height = 33
    Anchors = [akLeft, akTop, akBottom]
    AutoSize = False
    Caption = ' '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label6: TLabel
    Left = 3
    Top = 127
    Width = 31
    Height = 11
    Hint = 'Date du mouvement'
    Alignment = taRightJustify
    Caption = 'Edition:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object lccEditions: TLightComboCheck
    Left = 37
    Top = 122
    Width = 179
    Height = 20
    Checked = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    PropertiesStored = False
    CheckVisible = False
    OnChange = lccEditionsChange
    ShowCaptionHint = False
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' '
    Items = <>
  end
  inline Frame11: TFrame1
    Left = 0
    Top = 234
    Width = 479
    Height = 23
    Align = alBottom
    TabOrder = 3
    inherited btnOK: TBitBtn
      Left = 319
      Width = 73
      Height = 19
      Enabled = False
      OnClick = okClick
    end
    inherited btnAnnuler: TBitBtn
      Left = 399
      Width = 72
      Height = 19
    end
  end
  object date_pret: TDateTimePickerLabeled
    Left = 37
    Top = 209
    Width = 90
    Height = 22
    Hint = 'Date du mouvement'
    Anchors = [akLeft, akBottom]
    CalColors.BackColor = clScrollBar
    Date = 36293.507726388900000000
    Time = 36293.507726388900000000
    TabOrder = 0
    LinkLabel.LinkLabel.Strings = (
      'Label1')
  end
  object pret: TCheckBoxLabeled
    Left = 153
    Top = 210
    Width = 37
    Height = 19
    Hint = 'Case coch'#233'e = le mouvement est un emprunt'
    Alignment = taLeftJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Pr'#234't:'
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    LinkLabel.LinkLabel.Strings = (
      'pret')
  end
  object VTreeEmprunteur: TVirtualStringTree
    Left = 223
    Top = 28
    Width = 249
    Height = 200
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    AnimationDuration = 0
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    Indent = 8
    TabOrder = 2
    OnChange = VTreeEmprunteurChange
    Columns = <>
  end
  object ScanEditEmprunteur: TEdit
    Left = 223
    Top = 6
    Width = 218
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    TabOrder = 4
    OnChange = ScanEditEmprunteurClick
  end
end
