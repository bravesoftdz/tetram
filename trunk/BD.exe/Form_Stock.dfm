object FrmStock: TFrmStock
  Left = 144
  Top = 342
  Width = 1110
  Height = 607
  Caption = 'Albums emprunt'#233's'
  Color = clBtnFace
  Constraints.MinWidth = 400
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    0007777FF77F777F777FF7770000000000077F77F777F77F7777777700000000
    00077F7777777F7777F7777F00000000000777777FFF777777777F7F00000000
    000F77FF777777FF77777F7F0000000000077F77F7777FF77F77777700000000
    00077777F77FF77F7F77F77700000000000F777F77FF77777777F77F00000000
    0007777777F7F777F77FFF7700000000000F7777F77777F77F777F7700000000
    000F7FF7777777FF77777F7700000000000F77F7FF7F7777FFF7777700000000
    0007FF7F7F7FF7F7FFF777F700000000000F7777FF77FFF77777777700000000
    0007777777FF7F7FFF7F777700000000000F7F77FF77F77777F7F77700000000
    0007FFF7777F777F7F777F7700000000000777777FF77F7F777F7F7700000000
    00077F7FF000000000FF777F00000000000777FF0FFFFFFFFF07F77700000000
    000FF7770FFFFFFFFF07777F0000000000077FF70FFFFFFFFF077F7F00000000
    000FF7770FFFFFFFFF07777F000000000007777F0FFFFFFFFF0F777F00000000
    00077FFF0FFFFFFFFF0FF77700000000000F77F7F0000000007F77FF00000000
    0007F777F777F777FFF7777700000000000F7F777777F777777F777700000000
    000FF7F777F7777777F7F7770000000000077F7F7FF777777FF7777F00000000
    0000000000000000000000000000E000000FE0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E000000F280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    777F7F77F7000000F7F777FFFF0000007F77FF77770000007777F7FF7F000000
    7FF77777770000007777F7F7F70000007F7F7F777F000000FF7777FF77000000
    FF700007F7000000770FFFF07F000000FF0FFFF07F000000770FFFF0F7000000
    F770000777000000F7F777F7F700000000000000000080030000800100008001
    0000800100008001000080010000800100008001000080010000800100008001
    00008001000080010000800100008001000080030000}
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1102
    560)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 2
    Top = 56
    Width = 1097
    Height = 105
    Anchors = [akLeft, akTop, akRight]
  end
  object Image1: TImage
    Left = 1021
    Top = 490
    Width = 78
    Height = 60
    Anchors = [akRight, akBottom]
    Transparent = True
  end
  object LightComboCheck1: TLightComboCheck
    Left = 8
    Top = 62
    Width = 129
    Height = 20
    Checked = True
    CaptionUnchecked = 'Choisir un filtre'
    DefaultValueUnchecked = 0
    ValueMissing = 0
    PropertiesStored = False
    CheckedCaptionBold = False
    OnChange = LightComboCheck1Change
    ShowCaptionHint = False
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' '
    Items = <
      item
        Valeur = 0
        Caption = 'Pas de filtre'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end
      item
        Valeur = 1
        Caption = 'Depuis plus de'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end
      item
        Valeur = 2
        Caption = 'Depuis moins de'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end>
  end
  object LightComboCheck2: TLightComboCheck
    Left = 173
    Top = 62
    Width = 79
    Height = 20
    Visible = False
    Checked = True
    DefaultValueChecked = 0
    PropertiesStored = False
    Transparent = True
    CheckVisible = False
    CheckedCaptionBold = False
    ShowCaptionHint = False
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' '
    Items = <
      item
        Valeur = 0
        Caption = 'jours'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end
      item
        Valeur = 1
        Caption = 'semaines'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end
      item
        Valeur = 2
        Caption = 'mois'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end
      item
        Valeur = 3
        Caption = 'ans'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end>
  end
  object Button1: TButton
    Left = 6
    Top = 27
    Width = 69
    Height = 23
    Action = Retour2
    TabOrder = 0
  end
  object ListeEmprunts: TVirtualStringTree
    Left = 2
    Top = 88
    Width = 1098
    Height = 394
    Anchors = [akLeft, akTop, akRight, akBottom]
    AnimationDuration = 0
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = 2
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Images = Fond.ImageList1
    Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible]
    Header.Style = hsPlates
    HotCursor = crHandPoint
    Images = Fond.ImageList1
    TabOrder = 1
    TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
    OnDblClick = ListeEmpruntsDblClick
    OnGetText = ListeEmpruntsGetText
    OnGetImageIndex = ListeEmpruntsGetImageIndex
    OnGetPopupMenu = ListeEmpruntsGetPopupMenu
    OnHeaderClick = ListeEmpruntsHeaderClick
    Columns = <
      item
        MinWidth = 80
        Position = 0
        Width = 80
        WideText = 'Date'
      end
      item
        MinWidth = 50
        Position = 1
        Width = 150
        WideText = 'Emprunteur'
      end
      item
        MinWidth = 50
        Position = 2
        Width = 614
        WideText = 'Album'
      end
      item
        Position = 3
        Width = 250
        WideText = 'Edition'
      end>
  end
  object EditLabeled1: TEditLabeled
    Left = 138
    Top = 62
    Width = 31
    Height = 21
    MaxLength = 2
    TabOrder = 2
    LinkLabel.LinkLabel.Strings = (
      'LightComboCheck1'
      'LightComboCheck2')
    TypeDonnee = tdEntier
    CurrencyChar = #0
  end
  object Button2: TButton
    Left = 278
    Top = 61
    Width = 69
    Height = 23
    Action = actFiltrer
    TabOrder = 3
    Visible = False
  end
  object PopupMenu1: TPopupMenu
    AutoPopup = False
    OnPopup = PopupMenu1Popup
    Left = 42
    Top = 260
    object Item1: TMenuItem
      OnClick = Item2Click
    end
    object Item2: TMenuItem
      Caption = 'Fiche'
      OnClick = Item2Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MnuRetour: TMenuItem
      Action = Retour1
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 8
    Top = 264
    object Retour2: TAction
      Caption = 'Retour'
      OnExecute = Retour2Execute
    end
    object Retour1: TAction
      Caption = 'Retour'
      OnExecute = Retour1Execute
    end
    object actFiltrer: TAction
      Caption = 'Appliquer'
      OnExecute = actFiltrerExecute
    end
    object EmpruntApercu: TAction
      Tag = 1
      Category = 'Emprunts'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer1Click
    end
    object EmpruntImprime: TAction
      Tag = 2
      Category = 'Emprunts'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 104
    Top = 272
    object Emprunts1: TMenuItem
      Caption = 'Emprunts'
      object Aperuavantimpression1: TMenuItem
        Action = EmpruntApercu
      end
      object Imprimer1: TMenuItem
        Action = EmpruntImprime
      end
    end
  end
end
