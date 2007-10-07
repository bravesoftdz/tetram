object FrmConsultationEmprunteur: TFrmConsultationEmprunteur
  Left = 497
  Top = 243
  Width = 513
  Height = 486
  Caption = 'Fiche d'#39'emprunteur'
  Color = clWindow
  Ctl3D = False
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
    505
    434)
  PixelsPerInch = 96
  TextHeight = 13
  object l_emprunts: TLabel
    Left = 4
    Top = 226
    Width = 42
    Height = 11
    Hint = 'Nombre d'#39'emprunts de l'#39'emprunteur'
    Alignment = taRightJustify
    Caption = 'Emprunts:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object emprunts: TLabel
    Left = 49
    Top = 225
    Width = 3
    Height = 13
    Hint = 'Nombre d'#39'emprunts de l'#39'emprunteur'
    Alignment = taCenter
    Transparent = True
  end
  object Bevel4: TBevel
    Left = 80
    Top = 59
    Width = 418
    Height = 135
    Anchors = [akLeft, akTop, akRight]
    Style = bsRaised
  end
  object Bevel2: TBevel
    Left = 7
    Top = 247
    Width = 491
    Height = 155
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = bsRaised
  end
  object Label6: TLabel
    Left = 52
    Top = 41
    Width = 23
    Height = 11
    Alignment = taRightJustify
    Caption = 'Nom:'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object nom: TLabel
    Left = 82
    Top = 34
    Width = 415
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    WordWrap = True
  end
  object Label1: TLabel
    Left = 39
    Top = 61
    Width = 36
    Height = 11
    Alignment = taRightJustify
    Caption = 'Adresse:'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Adresse: TMemo
    Left = 82
    Top = 59
    Width = 415
    Height = 134
    Hint = 'Coordonn'#233'es de l'#39'emprunteur'
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    ReadOnly = True
    TabOrder = 0
  end
  object btAjouter: TButton
    Left = 426
    Top = 225
    Width = 72
    Height = 18
    Cursor = crHandPoint
    Anchors = [akTop, akRight]
    Caption = 'Ajouter'
    TabOrder = 1
    OnClick = btAjouterClick
  end
  object ListeEmprunts: TVirtualStringTree
    Left = 6
    Top = 245
    Width = 491
    Height = 156
    Anchors = [akLeft, akTop, akRight, akBottom]
    AnimationDuration = 0
    BorderStyle = bsNone
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Images = Fond.ImageList1
    Header.MainColumn = 1
    Header.Options = [hoColumnResize, hoShowImages, hoVisible]
    Header.Style = hsPlates
    HotCursor = crHandPoint
    Images = Fond.ImageList1
    TabOrder = 2
    TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
    OnDblClick = ListeEmpruntsDblClick
    OnGetText = ListeEmpruntsGetText
    OnGetImageIndex = ListeEmpruntsGetImageIndex
    OnHeaderClick = ListeEmpruntsHeaderClick
    Columns = <
      item
        Position = 0
        WideText = 'Date'
      end
      item
        Position = 1
        WideText = 'Album'
      end
      item
        Position = 2
        Width = 250
        WideText = 'Edition'
      end>
  end
  object Button1: TButton
    Left = 329
    Top = 225
    Width = 90
    Height = 18
    Cursor = crHandPoint
    Action = Retour1
    Anchors = [akTop, akRight]
    TabOrder = 3
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 52
    Top = 12
    object FicheApercu: TAction
      Tag = 1
      Category = 'Fiche'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer2Click
    end
    object FicheImprime: TAction
      Tag = 2
      Category = 'Fiche'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer2Click
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
    object Retour1: TAction
      Caption = 'Pr'#234't / Retour'
      OnExecute = Retour1Execute
    end
  end
  object MainMenu1: TMainMenu
    Left = 120
    Top = 16
    object Fiche1: TMenuItem
      Caption = 'Fiche'
      object Aperuavantimpression1: TMenuItem
        Action = FicheApercu
      end
      object Aperuavantimpression2: TMenuItem
        Action = FicheImprime
      end
    end
    object Emprunts1: TMenuItem
      Caption = 'Emprunts'
      object Aperuavantimpression3: TMenuItem
        Action = EmpruntApercu
      end
      object Aperuavantimpression4: TMenuItem
        Action = EmpruntImprime
      end
    end
  end
end
