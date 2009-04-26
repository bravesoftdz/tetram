object frmConsultationSerie: TfrmConsultationSerie
  Left = 1349
  Top = 58
  Caption = 'frmConsultationSerie'
  ClientHeight = 767
  ClientWidth = 862
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 0
    Width = 862
    Height = 767
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    OnClick = EditeurClick
    ExplicitHeight = 786
    DesignSize = (
      862
      767)
    object l_remarques: TLabel
      Left = 25
      Top = 296
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes'
      Color = clWhite
      FocusControl = remarques
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_sujet: TLabel
      Left = 17
      Top = 225
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire'
      Color = clWhite
      FocusControl = sujet
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 499
      Top = 46
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Genres'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_acteurs: TLabel
      Left = 17
      Top = 128
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Dessins'
      Color = clWhite
      FocusControl = lvDessinateurs
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_realisation: TLabel
      Left = 12
      Top = 87
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Scenario'
      Color = clWhite
      FocusControl = lvScenaristes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 24
      Top = 10
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Titre :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object Label7: TLabel
      Left = 11
      Top = 170
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Couleurs'
      Color = clWhite
      FocusControl = lvColoristes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TitreSerie: TLabel
      Left = 59
      Top = 5
      Width = 795
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'S'#233'rie'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      OnClick = TitreSerieClick
    end
    object Bevel1: TBevel
      Left = 0
      Top = 764
      Width = 862
      Height = 3
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 783
    end
    object Label4: TLabel
      Left = 14
      Top = 495
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Para-BD'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 19
      Top = 370
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Albums'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Lbl_type: TLabel
      Left = 19
      Top = 40
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Editeur: TLabel
      Left = 59
      Top = 40
      Width = 33
      Height = 13
      Caption = 'Editeur'
      ShowAccelChar = False
      OnClick = EditeurClick
    end
    object Label9: TLabel
      Left = 7
      Top = 59
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Collection'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Collection: TLabel
      Left = 59
      Top = 59
      Width = 46
      Height = 13
      Caption = 'Collection'
      ShowAccelChar = False
    end
    object remarques: TMemo
      Left = 59
      Top = 296
      Width = 797
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object sujet: TMemo
      Left = 59
      Top = 224
      Width = 797
      Height = 67
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object lvScenaristes: TVDTListView
      Left = 59
      Top = 87
      Width = 797
      Height = 35
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      TabOrder = 2
      OnDblClick = lvScenaristesDblClick
    end
    object lvDessinateurs: TVDTListView
      Left = 59
      Top = 128
      Width = 797
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      SortType = stData
      TabOrder = 3
      OnDblClick = lvScenaristesDblClick
    end
    object Memo1: TMemo
      Left = 538
      Top = 46
      Width = 318
      Height = 34
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object lvColoristes: TVDTListView
      Left = 59
      Top = 170
      Width = 797
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      SortType = stData
      TabOrder = 5
      OnDblClick = lvScenaristesDblClick
    end
    object vtAlbums: TVirtualStringTree
      Left = 59
      Top = 370
      Width = 797
      Height = 119
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentColor = True
      TabOrder = 6
      OnDblClick = vtAlbumsDblClick
      Columns = <>
    end
    object vtParaBD: TVirtualStringTree
      Left = 59
      Top = 495
      Width = 797
      Height = 130
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      CheckImageKind = ckDarkCheck
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      ParentColor = True
      TabOrder = 7
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.StringOptions = []
      OnDblClick = vtParaBDDblClick
      Columns = <>
    end
    object cbTerminee: TReadOnlyCheckBox
      Left = 216
      Top = 38
      Width = 62
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Termin'#233'e'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 8
    end
  end
  object MainMenu1: TMainMenu
    AutoMerge = True
    Images = frmFond.boutons_32x32_hot
    Left = 416
    Top = 24
    object Fiche1: TMenuItem
      Caption = 'Fiche'
      object Modifier1: TMenuItem
        Action = FicheModifier
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Aperuavantimpression1: TMenuItem
        Action = FicheApercu
      end
      object Imprimer1: TMenuItem
        Action = FicheImprime
      end
    end
  end
  object ActionList1: TActionList
    Left = 448
    Top = 24
    object FicheApercu: TAction
      Tag = 1
      Category = 'Fiche'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = FicheApercuExecute
    end
    object FicheImprime: TAction
      Tag = 2
      Category = 'Fiche'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = FicheApercuExecute
    end
    object FicheModifier: TAction
      Category = 'Fiche'
      Caption = 'Modifier'
      ImageIndex = 13
      OnExecute = FicheModifierExecute
    end
  end
end
