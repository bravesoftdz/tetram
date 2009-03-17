object frmConsultationParaBD: TfrmConsultationParaBD
  Left = 1405
  Top = 196
  Caption = 'frmConsultationParaBD'
  ClientHeight = 489
  ClientWidth = 842
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
    Width = 842
    Height = 489
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      842
      489)
    object lbNoImage: TLabel
      Left = 636
      Top = 248
      Width = 89
      Height = 21
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Pas d'#39'image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object l_sujet: TLabel
      Left = 1
      Top = 137
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description'
      Color = clWhite
      FocusControl = Description
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
      Left = 22
      Top = 33
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie :'
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
    object l_realisation: TLabel
      Left = 15
      Top = 95
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs'
      Color = clWhite
      FocusControl = lvAuteurs
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TitreParaBD: TLabel
      Left = 59
      Top = 5
      Width = 775
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Titre'
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
    end
    object Label6: TLabel
      Left = 24
      Top = 11
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
    object Label11: TLabel
      Left = 15
      Top = 67
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
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
    object AnneeEdition: TLabel
      Left = 59
      Top = 67
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Ann'#233'e'
      Transparent = True
    end
    object TitreSerie: TLabel
      Left = 59
      Top = 27
      Width = 775
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
      OnDblClick = TitreSerieDblClick
    end
    object Bevel1: TBevel
      Left = 0
      Top = 486
      Width = 842
      Height = 3
      Align = alBottom
      Shape = bsSpacer
    end
    object lbInvalidImage: TLabel
      Left = 623
      Top = 292
      Width = 114
      Height = 42
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Impossible de charger l'#39'image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      Visible = False
      WordWrap = True
    end
    object Prix: TLabel
      Left = 88
      Top = 428
      Width = 17
      Height = 13
      Caption = 'Prix'
    end
    object Label3: TLabel
      Left = 57
      Top = 428
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix :'
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
    object Label12: TLabel
      Left = 124
      Top = 428
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le :'
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
    object AcheteLe: TLabel
      Left = 184
      Top = 428
      Width = 45
      Height = 13
      Caption = 'Achet'#233' le'
    end
    object TypeParaBD: TLabel
      Left = 59
      Top = 51
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Type'
      Transparent = True
    end
    object Label1: TLabel
      Left = 22
      Top = 51
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type :'
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
    object Label2: TLabel
      Left = 52
      Top = 444
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote :'
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
    object lbCote: TLabel
      Left = 88
      Top = 444
      Width = 22
      Height = 13
      Caption = 'Cote'
    end
    object ImageParaBD: TImage
      Left = 524
      Top = 51
      Width = 312
      Height = 414
      Anchors = [akTop, akRight]
      Center = True
      IncrementalDisplay = True
    end
    object Description: TMemo
      Left = 59
      Top = 136
      Width = 458
      Height = 257
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
    object lvAuteurs: TVDTListView
      Left = 59
      Top = 95
      Width = 458
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
      TabOrder = 1
      OnDblClick = lvAuteursDblClick
    end
    object cbNumerote: TReadOnlyCheckBox
      Left = 253
      Top = 66
      Width = 65
      Height = 15
      TabStop = False
      Caption = 'Num'#233'rot'#233
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 2
    end
    object cbStock: TReadOnlyCheckBox
      Left = 145
      Top = 401
      Width = 45
      Height = 15
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Stock'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 3
    end
    object cbOffert: TReadOnlyCheckBox
      Left = 69
      Top = 400
      Width = 49
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Offert'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 4
    end
    object cbDedicace: TReadOnlyCheckBox
      Left = 167
      Top = 65
      Width = 63
      Height = 16
      TabStop = False
      Caption = 'D'#233'dicac'#233
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 5
    end
  end
  object MainMenu1: TMainMenu
    AutoMerge = True
    Images = frmFond.boutons_32x32_hot
    Left = 416
    Top = 24
    object Fiche1: TMenuItem
      Caption = 'Fiche'
      object Aperuavantimpression1: TMenuItem
        Action = FicheApercu
      end
      object Imprimer1: TMenuItem
        Action = FicheImprime
      end
    end
    object Image1: TMenuItem
      Caption = 'Image'
      object Aperuavantimpression2: TMenuItem
        Action = ImageApercu
      end
      object Imprimer2: TMenuItem
        Action = ImageImprime
      end
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 448
    Top = 24
    object ImageApercu: TAction
      Tag = 1
      Category = 'Image'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = ImageApercuExecute
    end
    object ImageImprime: TAction
      Tag = 2
      Category = 'Image'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = ImageApercuExecute
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
  end
end
