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
      Left = 0
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
      Left = 156
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
      Left = 216
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
    object VDTButton3: TVDTButton
      Left = 704
      Top = 493
      Width = 21
      Height = 20
      Anchors = [akTop, akRight]
      Visible = False
      OnClick = VDTButton3Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000001A44944415478DA63FCFFFF3F032580912E062CDBB0F872
        CBA2266D613EA1FF87179C6426DA80F3E74FCF9BB86642D4FAC3EBD8D9659919
        7E3CFAC3501A51F6B636BB4984A0019B76AC3D5134B5D0ECEDEFD78CD691160C
        8F04EE30BC58F381C15F29E4FBECC6F95C780D58B476DEB5B2E9251A6C324C8C
        9119E10C1E0A7E0CC5A7D319DEDFF8CC60F4CCFAF7DAFE4D6C380DD87360C7EE
        B086101716394606EB38330666662686EB1FAF80E57EBFFCC3207952F5EFC179
        C758701A90DB9AF165E18E05DC6211BC0CECD22C2872BFDFFC6560DB2EF0FFCA
        DA5B4C380D387EF2C8EAD896A8E0AF721F18F92C38195878216AFFFFFECFF0FD
        F12F86FF7B39FF3FD8FA14B701E000DCB9EE587267A225971313038B1033032B
        1F33C39FAFFF18FE7CFCCB207E49E1DFC925E798F11A000253174F7C5835B75C
        4ED0939B819105A2E6D7CB7F0C663F6D7EAF9FB8858DA001205037B1F2DDC4B5
        1304792CD918D8C49819DEEFFECE106F9FF46562E5545EA20C0081D92BA6DFA9
        9D53ADF4EDD73746460646868F87BE3322CB139594F71DDABD73C3E1F5D6B2E2
        B29F4A532AA54836001FA0D80000D0F2CAE110B865C00000000049454E44AE42
        6082}
    end
    object VDTButton4: TVDTButton
      Left = 728
      Top = 493
      Width = 21
      Height = 20
      Anchors = [akTop, akRight]
      Visible = False
      OnClick = VDTButton4Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000019F4944415478DA63FCFFFF3F032580912606D82698FF7D
        FBE91D634D5CDD95A880583D920C689E5AF7BA7B459708871C0BC3CFC77F1902
        6D837EE687142C3334344D22CA80D4FAC46F1BEFADE19408116090FBA0C27074
        F909066156D1FF7DD9FDA7FC3C822D081A105CE8F7EB9CD45156410D5E865ED3
        990C3B1E6C62983F792103D34BB6FF5D993D37E28293B4F01A609F64F5E7B9F9
        6D66567116305F935F87E1EFDF7F0C47179D62F8F3E83FC3AA86357B5C1C3C5C
        711AA013ACF6EF97E7074656116614F19F4FFF30BC5AF19921DE23E1EBE4EA19
        3C380D50F096FEC7E8FC9D9153968D819195112CF6E7F33F864F27BE33703F12
        F8BFB866D95A4B739B509C0698C718FD7DA9F78089859F9981859B89E1F7A7BF
        0C7FDEFD65F8B6EF1FC3DCF2F927FCDC832CF1864160BECFAF53EC4758D9C499
        C0FCFF7F1819DE6FFFCAD096DCF9303B365F81602CE4B7677F5E78701EB7A02B
        27E3AF577F19BE1CFFC5901F5CF0BE29BF5D88A8740002FC769C40D1FF0C5C6C
        5CFF9B535AEFA746642A33E000580DE89ED3FEECF1CBC77C01B681479CEC5C3D
        18F000DA642652000044DEC4E12EAFF41A0000000049454E44AE426082}
    end
    object l_notes: TLabel
      Left = 25
      Top = 328
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes'
      Color = clWhite
      FocusControl = Notes
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
      Height = 152
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
      Left = 172
      Top = 432
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
    end
    object Notes: TMemo
      Left = 59
      Top = 327
      Width = 371
      Height = 82
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 7
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
