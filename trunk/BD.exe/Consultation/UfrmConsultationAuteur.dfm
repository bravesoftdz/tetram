object frmConsultationAuteur: TfrmConsultationAuteur
  Left = 486
  Top = 211
  Caption = 'Fiche d'#39'auteur'
  ClientHeight = 759
  ClientWidth = 522
  Color = clWhite
  Constraints.MinWidth = 530
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 0
    Width = 522
    Height = 759
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      522
      759)
    object l_sujet: TLabel
      Left = 3
      Top = 41
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Biographie'
      Color = clWhite
      FocusControl = edBiographie
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_annee: TLabel
      Left = 32
      Top = 11
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nom'
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
    object Label5: TLabel
      Left = 24
      Top = 291
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'ries'
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
    object edNom: TLabel
      Left = 59
      Top = 5
      Width = 455
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Nom'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      OnClick = edNomClick
    end
    object Bevel1: TBevel
      Left = 0
      Top = 756
      Width = 522
      Height = 3
      Align = alBottom
      Shape = bsSpacer
    end
    object edBiographie: TMemo
      Left = 59
      Top = 40
      Width = 457
      Height = 241
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
    object vstSeries: TVirtualStringTree
      Left = 59
      Top = 291
      Width = 457
      Height = 294
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag]
      TabOrder = 1
      OnDblClick = vstSeriesDblClick
      OnGetText = vstSeriesGetText
      OnPaintText = vstSeriesPaintText
      OnInitChildren = vstSeriesInitChildren
      OnInitNode = vstSeriesInitNode
      Columns = <
        item
          MinWidth = 140
          Position = 0
          Width = 231
        end>
    end
  end
  object Popup3: TPopupMenu
    Left = 304
    Top = 40
    object Informations1: TMenuItem
      Caption = '&Informations'
      object Emprunts1: TMenuItem
        Caption = 'Emprunts :'
      end
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object Adresse1: TMenuItem
      Caption = '&Adresse'
    end
  end
  object ActionList1: TActionList
    Left = 420
    Top = 38
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
  object MainMenu1: TMainMenu
    Left = 336
    Top = 40
    object Fiche1: TMenuItem
      Caption = 'Fiche'
      GroupIndex = 1
      object Modifier1: TMenuItem
        Action = FicheModifier
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Aperuavantimpression1: TMenuItem
        Action = FicheApercu
      end
      object Aperuavantimpression2: TMenuItem
        Action = FicheImprime
      end
    end
  end
end
