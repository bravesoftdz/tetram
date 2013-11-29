object frmConsultationUnivers: TfrmConsultationUnivers
  Left = 1405
  Top = 196
  Caption = 'frmConsultationUnivers'
  ClientHeight = 489
  ClientWidth = 842
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
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
    Width = 842
    Height = 489
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      842
      489)
    object l_sujet: TLabel
      Left = 29
      Top = 53
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description :'
      Color = clWhite
      FocusControl = Description
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object NomUnivers: TLabel
      Left = 95
      Top = 5
      Width = 739
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Nom'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      OnClick = NomUniversClick
    end
    object Label6: TLabel
      Left = 61
      Top = 10
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nom :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object Bevel1: TBevel
      Left = 0
      Top = 486
      Width = 842
      Height = 3
      Align = alBottom
      Shape = bsSpacer
    end
    object Label1: TLabel
      Left = 11
      Top = 29
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers parent :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object UniversParent: TLabel
      Left = 95
      Top = 29
      Width = 739
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Univers parent'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      OnClick = NomUniversClick
      OnDblClick = UniversParentDblClick
    end
    object Label3: TLabel
      Left = 48
      Top = 135
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Albums :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label4: TLabel
      Left = 43
      Top = 348
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Para-BD :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Description: TMemo
      Left = 95
      Top = 50
      Width = 739
      Height = 79
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
    object vtAlbums: TVirtualStringTree
      Left = 95
      Top = 135
      Width = 739
      Height = 207
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentColor = True
      TabOrder = 1
      OnAfterItemPaint = vtAlbumsAfterItemPaint
      OnDblClick = vtAlbumsDblClick
      Columns = <>
    end
    object vtParaBD: TVirtualStringTree
      Left = 95
      Top = 348
      Width = 739
      Height = 101
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      CheckImageKind = ckDarkCheck
      Header.AutoSizeIndex = -1
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      ParentColor = True
      TabOrder = 2
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.StringOptions = []
      OnDblClick = vtParaBDDblClick
      Columns = <>
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
    object ImageApercu: TAction
      Tag = 1
      Category = 'Image'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
    end
    object ImageImprime: TAction
      Tag = 2
      Category = 'Image'
      Caption = 'Imprimer'
      ImageIndex = 3
    end
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
