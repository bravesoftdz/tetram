object frmConsultationParaBD: TfrmConsultationParaBD
  Left = 1405
  Top = 196
  Caption = 'frmConsultationParaBD'
  ClientHeight = 575
  ClientWidth = 755
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
    Width = 755
    Height = 575
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      755
      575)
    object lbNoImage: TLabel
      Left = 549
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
      ExplicitLeft = 636
    end
    object l_sujet: TLabel
      Left = 1
      Top = 170
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description'
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
    object l_annee: TLabel
      Left = 22
      Top = 32
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie :'
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
    object l_realisation: TLabel
      Left = 15
      Top = 128
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs'
      Color = clWhite
      FocusControl = lvAuteurs
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
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
      Width = 688
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Titre'
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
      ExplicitWidth = 775
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
      Font.Color = 12615680
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
      Font.Color = 12615680
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
      Width = 688
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'S'#233'rie'
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
      OnClick = TitreSerieClick
      OnDblClick = TitreSerieDblClick
      ExplicitWidth = 775
    end
    object Bevel1: TBevel
      Left = 0
      Top = 572
      Width = 755
      Height = 3
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 486
      ExplicitWidth = 842
    end
    object lbInvalidImage: TLabel
      Left = 536
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
      ExplicitLeft = 623
    end
    object Prix: TLabel
      Left = 88
      Top = 461
      Width = 18
      Height = 13
      Caption = 'Prix'
    end
    object Label3: TLabel
      Left = 57
      Top = 461
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix :'
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
    object Label12: TLabel
      Left = 124
      Top = 461
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le :'
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
    object AcheteLe: TLabel
      Left = 184
      Top = 461
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
      Font.Color = 12615680
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
      Top = 477
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote :'
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
    object lbCote: TLabel
      Left = 88
      Top = 477
      Width = 23
      Height = 13
      Caption = 'Cote'
    end
    object ImageParaBD: TImage
      Left = 437
      Top = 51
      Width = 312
      Height = 439
      Anchors = [akTop, akRight]
      Center = True
      IncrementalDisplay = True
      ExplicitLeft = 524
    end
    object Label4: TLabel
      Left = 17
      Top = 87
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers'
      Color = clWhite
      FocusControl = lvUnivers
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
      Left = 59
      Top = 169
      Width = 371
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
      ExplicitWidth = 458
    end
    object lvAuteurs: TVDTListView
      Left = 59
      Top = 128
      Width = 371
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
      OwnerData = True
      TabOrder = 1
      OnData = lvAuteursData
      OnDblClick = lvAuteursDblClick
      ExplicitWidth = 458
    end
    object cbDedicace: TLabeledCheckBox
      Left = 172
      Top = 67
      Width = 13
      Height = 13
      Caption = 'D'#233'dicac'#233
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = 'D'#233'dicac'#233
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = 12615680
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ReadOnly = True
    end
    object cbNumerote: TLabeledCheckBox
      Left = 258
      Top = 67
      Width = 13
      Height = 13
      Caption = 'Num'#233'rot'#233
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      EditLabel.Width = 47
      EditLabel.Height = 13
      EditLabel.Caption = 'Num'#233'rot'#233
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = 12615680
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ReadOnly = True
    end
    object cbOffert: TLabeledCheckBox
      Left = 98
      Top = 433
      Width = 13
      Height = 13
      Alignment = taLeftJustify
      Caption = 'Offert'
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Offert'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = 12615680
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ReadOnly = True
    end
    object cbStock: TLabeledCheckBox
      Left = 185
      Top = 433
      Width = 13
      Height = 13
      Alignment = taLeftJustify
      Caption = 'Stock'
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Stock'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = 12615680
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ReadOnly = True
    end
    object lvUnivers: TVDTListView
      Left = 59
      Top = 87
      Width = 371
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
      OwnerData = True
      TabOrder = 6
      OnData = lvUniversData
      OnDblClick = lvUniversDblClick
      ExplicitWidth = 458
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
    object FicheModifier: TAction
      Category = 'Fiche'
      Caption = 'Modifier'
      ImageIndex = 13
      OnExecute = FicheModifierExecute
    end
  end
end
