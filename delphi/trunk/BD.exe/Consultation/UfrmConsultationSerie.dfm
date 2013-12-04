object frmConsultationSerie: TfrmConsultationSerie
  Left = 1349
  Top = 58
  Caption = 'frmConsultationSerie'
  ClientHeight = 805
  ClientWidth = 692
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
    Width = 692
    Height = 805
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    OnClick = EditeurClick
    DesignSize = (
      692
      805)
    object l_remarques: TLabel
      Left = 25
      Top = 324
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes'
      Color = clWhite
      FocusControl = edRemarques
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_sujet: TLabel
      Left = 17
      Top = 253
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire'
      Color = clWhite
      FocusControl = edSujet
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_acteurs: TLabel
      Left = 17
      Top = 168
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Dessins'
      Color = clWhite
      FocusControl = lvDessinateurs
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_realisation: TLabel
      Left = 12
      Top = 128
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Scenario'
      Color = clWhite
      FocusControl = lvScenaristes
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 61
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
    object Label7: TLabel
      Left = 11
      Top = 209
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Couleurs'
      Color = clWhite
      FocusControl = lvColoristes
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TitreSerie: TLabel
      Left = 96
      Top = 5
      Width = 590
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
      ExplicitWidth = 632
    end
    object Bevel1: TBevel
      Left = 0
      Top = 802
      Width = 692
      Height = 3
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 783
      ExplicitWidth = 862
    end
    object Label4: TLabel
      Left = 14
      Top = 521
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Para-BD'
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
    object Label3: TLabel
      Left = 19
      Top = 396
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Albums'
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
    object Lbl_type: TLabel
      Left = 19
      Top = 40
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur'
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
    object Editeur: TLabel
      Left = 59
      Top = 40
      Width = 34
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
      Font.Color = 12615680
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
    object VDTButton1: TVDTButton
      Left = 33
      Top = 495
      Width = 20
      Height = 20
      OnClick = VDTButton1Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000001974455874536F6674776172
        65007777772E696E6B73636170652E6F72679BEE3C1A0000034A4944415478DA
        75937B48935118C69F93BB7EDBD4B59679C9560E9D95974A4B9C66657F045D88
        2E1484DDB3A8C83F4ABAD3C5C8AE1661525610DD410A124ACBAC65585A2D4B03
        9D9F66B6DCB49AB9369DAEB6D3D12E98D07B78F8E09CF7F9BDDFF79DF7251810
        C973D6EE638FD94C8D4CC54C454F0ACF5AF09F2003CC116A957F6DF6FEEDA4C3
        E946FB670B8CC62A3C7DF1E6ADC3E9BACD52EE325532A0E77F80DCF435CB3788
        4362F083B223EA85807AA01052B83B2CA87E5581F2CAD71DCE4E573121642F03
        99483FB3AF42CE5976EECF92353904A0D4064A6CE87171E8F8E4823A4803A980
        601847515B59820B970AAEBE28BD9ED61F90B17CF1AC93EAD854981D79C82FDA
        025D4308A6E8233158ADC43BDE89C72FC558B229075DEF5F23E754EE0993B134
        F32F60FA828DFCF9D307B5652D35A8AAD063943715612951700A012F5B22E203
        D11721AEE556C22B4FA045B72ECFB5DB2C85E477F5F8A9FA09CF333356C162EF
        44CE8124842F9C0AA5928213FE2AE0703339F488F1DAB07AE5097B13CF27B0ED
        BA3F80437BB6ACDE9A9A1C079EE7C1D7E7C3AC1806DED30AB94880A1B26E74FE
        10629CDF0AF0A656945DCAF876A3A06624B3B6F70152E76F6828BC7C2C8C934A
        603018E0A51510BB93E1B45AA08A8C844A170EE2E303F32727EE94966350C361
        7BF6913225B352C2AA4725C647554B26BE47A85283A13418DF9B4B401B75189B
        960689BF7FDF277829C59B462B4A1EDC77DB8D39AD57AED78CE8EB0306D8B332
        7DDADEDD554BFFF6C3BC161D622367A03D6E0C027D83A19206C2DD2547B3F92B
        A4D579CEACBC6B379ACD8E357D80A4D9E986ECC3CB52763F5E8F77B67A56C98B
        1EB307DB464F863540830FDD41A01E0E81721516595B9070F11C72E3E56D19E7
        F918E66F23893357DD4C9A143B2F25713C4286ABF04D60C5DBB657B86FB80769
        D3478C1D1D0C2AE420700D4251410DBD7974915BF9B54EBCEECCB3FAFC624B1C
        098B4E5289C4DC0EA9CC572792C8B432995CA31D395C14A10D45F8A850700A8A
        CF5D6604C975D8BCEBB8D1F8F0EAA3DA0799E9DDA67244AF7BAAFFD348BDB7DD
        FB57FD8522C99080D088688532608C54E6A71549382DC7C9341E8FA7A7A9EE65
        D60793318FE5C5314D61CAFE6798068484C9AF17CADE500D4214EEEECEDE11AF
        EF9FF413DFF6506512AFC4930000000049454E44AE426082}
    end
    object Image1: TImage
      Left = 10
      Top = 3
      Width = 32
      Height = 32
      Center = True
      IncrementalDisplay = True
      PopupMenu = PopupMenu1
      Transparent = True
    end
    object Label2: TLabel
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
    object Label1: TLabel
      Left = 392
      Top = 90
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Genres'
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
    object edRemarques: TMemo
      Left = 59
      Top = 324
      Width = 627
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
    object edSujet: TMemo
      Left = 59
      Top = 252
      Width = 627
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
      Top = 128
      Width = 627
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
      TabOrder = 2
      OnData = lvScenaristesData
      OnDblClick = lvScenaristesDblClick
    end
    object lvDessinateurs: TVDTListView
      Left = 59
      Top = 168
      Width = 627
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
      OwnerData = True
      SortType = stData
      TabOrder = 3
      OnData = lvDessinateursData
      OnDblClick = lvScenaristesDblClick
    end
    object lvColoristes: TVDTListView
      Left = 59
      Top = 209
      Width = 627
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
      OwnerData = True
      SortType = stData
      TabOrder = 4
      OnData = lvColoristesData
      OnDblClick = lvScenaristesDblClick
    end
    object vtAlbums: TVirtualStringTree
      Left = 59
      Top = 396
      Width = 627
      Height = 119
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
      TabOrder = 5
      OnAfterItemPaint = vtAlbumsAfterItemPaint
      OnDblClick = vtAlbumsDblClick
      Columns = <>
    end
    object vtParaBD: TVirtualStringTree
      Left = 59
      Top = 521
      Width = 627
      Height = 130
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
      TabOrder = 6
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.StringOptions = []
      OnDblClick = vtParaBDDblClick
      Columns = <>
    end
    object cbTerminee: TLabeledCheckBox
      Left = 234
      Top = 40
      Width = 13
      Height = 13
      Alignment = taLeftJustify
      Caption = 'Termin'#233'e'
      Font.Charset = ANSI_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = 'Termin'#233'e'
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
      Width = 319
      Height = 35
      Anchors = [akLeft, akTop]
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
      TabOrder = 8
      OnData = lvUniversData
      OnDblClick = lvUniversDblClick
    end
    object Memo1: TMemo
      Left = 432
      Top = 87
      Width = 254
      Height = 35
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 9
    end
  end
  object MainMenu1: TMainMenu
    AutoMerge = True
    Images = frmFond.boutons_32x32_hot
    Left = 408
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
    Left = 440
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
  object PopupMenu1: TPopupMenu
    Images = frmFond.imlNotation_32x32
    Left = 120
    Top = 40
    object N2: TMenuItem
      Tag = 900
      Caption = 'Pas d'#39'avis'
      ImageIndex = 0
      OnClick = N7Click
    end
    object N3: TMenuItem
      Tag = 901
      Caption = 'Tr'#232's mauvais'
      ImageIndex = 1
      OnClick = N7Click
    end
    object N4: TMenuItem
      Tag = 902
      Caption = 'Mauvais'
      ImageIndex = 2
      OnClick = N7Click
    end
    object N5: TMenuItem
      Tag = 903
      Caption = 'Moyen'
      ImageIndex = 3
      OnClick = N7Click
    end
    object N6: TMenuItem
      Tag = 904
      Caption = 'Bien'
      ImageIndex = 4
      OnClick = N7Click
    end
    object N7: TMenuItem
      Tag = 905
      Caption = 'Tr'#232's bien'
      ImageIndex = 5
      OnClick = N7Click
    end
  end
end
