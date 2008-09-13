object FrmStock: TFrmStock
  Left = 510
  Top = 341
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
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1102
    561)
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
    Header.Images = frmFond.ImageList1
    Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible]
    Header.Style = hsPlates
    HotCursor = crHandPoint
    Images = frmFond.ImageList1
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
    LinkControls = <
      item
        Control = LightComboCheck1
      end
      item
        Control = LightComboCheck2
      end>
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
