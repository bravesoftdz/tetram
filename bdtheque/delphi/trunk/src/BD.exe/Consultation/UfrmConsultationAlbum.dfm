object frmConsultationAlbum: TfrmConsultationAlbum
  Left = 440
  Top = 64
  Caption = 'Fiche d'#39'album'
  ClientHeight = 722
  ClientWidth = 599
  Color = clWhite
  Constraints.MinWidth = 530
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
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
    Width = 599
    Height = 722
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      599
      722)
    object lbNoImage: TLabel
      Left = 408
      Top = 137
      Width = 89
      Height = 21
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Pas d'#39'image'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      ExplicitLeft = 327
    end
    object l_remarques: TLabel
      Left = 29
      Top = 434
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes'
      Color = clWhite
      FocusControl = remarques
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_sujet: TLabel
      Left = 21
      Top = 363
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire'
      Color = clWhite
      FocusControl = sujet
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 23
      Top = 136
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Genres'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lbTitreSerie: TLabel
      Left = 57
      Top = 8
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie :'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object l_acteurs: TLabel
      Left = 21
      Top = 217
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Dessins'
      Color = clWhite
      FocusControl = lvDessinateurs
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_realisation: TLabel
      Left = 16
      Top = 176
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Scenario'
      Color = clWhite
      FocusControl = lvScenaristes
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 33
      Top = 301
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TitreAlbum: TLabel
      Left = 94
      Top = 27
      Width = 517
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Titre'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      ExplicitWidth = 430
    end
    object Label6: TLabel
      Left = 59
      Top = 32
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Titre :'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object VDTButton3: TVDTButton
      Left = 515
      Top = 336
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
      ExplicitLeft = 434
    end
    object VDTButton4: TVDTButton
      Left = 539
      Top = 336
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
      ExplicitLeft = 458
    end
    object Label7: TLabel
      Left = 15
      Top = 258
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Couleurs'
      Color = clWhite
      FocusControl = lvColoristes
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label11: TLabel
      Left = 41
      Top = 66
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = 'Parution :'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object AnneeParution: TLabel
      Left = 91
      Top = 66
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Parution'
      Transparent = True
    end
    object TitreSerie: TLabel
      Left = 94
      Top = 3
      Width = 517
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'S'#233'rie'
      Font.Charset = DEFAULT_CHARSET
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
      ExplicitWidth = 433
    end
    object Label14: TLabel
      Left = 55
      Top = 51
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tome :'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object Tome: TLabel
      Left = 91
      Top = 51
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Tome'
      Transparent = True
    end
    object Bevel1: TBevel
      Left = 0
      Top = 719
      Width = 599
      Height = 3
      Align = alBottom
      Shape = bsSpacer
      ExplicitLeft = -3
      ExplicitTop = 602
      ExplicitWidth = 515
    end
    object lbInvalidImage: TLabel
      Left = 395
      Top = 177
      Width = 114
      Height = 42
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Impossible de charger l'#39'image'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      Visible = False
      WordWrap = True
      ExplicitLeft = 314
    end
    object Couverture: TImage
      Left = 348
      Top = 52
      Width = 215
      Height = 283
      Anchors = [akTop, akRight]
      Center = True
      IncrementalDisplay = True
      ExplicitLeft = 267
    end
    object VDTButton1: TVDTButton
      Left = 345
      Top = 336
      Width = 20
      Height = 20
      Anchors = [akTop, akRight]
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
      ExplicitLeft = 264
    end
    object VDTButton2: TVDTButton
      Left = 37
      Top = 336
      Width = 20
      Height = 20
      OnClick = VDTButton2Click
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
      Top = 11
      Width = 32
      Height = 32
      Center = True
      IncrementalDisplay = True
      PopupMenu = PopupMenu1
      Transparent = True
    end
    object Label2: TLabel
      Left = 21
      Top = 94
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object remarques: TMemo
      Left = 60
      Top = 434
      Width = 503
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object sujet: TMemo
      Left = 60
      Top = 362
      Width = 503
      Height = 67
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
    object lvScenaristes: TVDTListView
      Left = 60
      Top = 176
      Width = 279
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
      TabOrder = 1
      OnData = lvScenaristesData
      OnDblClick = lvScenaristesDblClick
    end
    object lvDessinateurs: TVDTListView
      Left = 60
      Top = 217
      Width = 279
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
      TabOrder = 2
      OnData = lvDessinateursData
      OnDblClick = lvScenaristesDblClick
    end
    object Memo1: TMemo
      Left = 60
      Top = 136
      Width = 279
      Height = 34
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
    object lvColoristes: TVDTListView
      Left = 60
      Top = 258
      Width = 279
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stData
      TabOrder = 3
      OnData = lvColoristesData
      OnDblClick = lvScenaristesDblClick
    end
    object PanelEdition: TPanel
      Left = 4
      Top = 505
      Width = 559
      Height = 203
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Caption = ' '
      ParentColor = True
      TabOrder = 6
      DesignSize = (
        559
        203)
      object ISBN: TLabel
        Left = 56
        Top = 3
        Width = 23
        Height = 13
        Caption = 'ISBN'
      end
      object Editeur: TLabel
        Left = 56
        Top = 18
        Width = 34
        Height = 13
        Caption = 'Editeur'
        ShowAccelChar = False
        OnClick = EditeurClick
      end
      object Prix: TLabel
        Left = 56
        Top = 52
        Width = 18
        Height = 13
        Caption = 'Prix'
      end
      object Lbl_numero: TLabel
        Left = 23
        Top = 3
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'ISBN :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Lbl_type: TLabel
        Left = 12
        Top = 18
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Editeur :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 28
        Top = 52
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prix :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label9: TLabel
        Left = 0
        Top = 33
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Collection :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Collection: TLabel
        Left = 56
        Top = 33
        Width = 46
        Height = 13
        Caption = 'Collection'
        ShowAccelChar = False
      end
      object Label16: TLabel
        Left = 262
        Top = 18
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ann'#233'e :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object AnneeEdition: TLabel
        Left = 305
        Top = 18
        Width = 31
        Height = 13
        Caption = 'Ann'#233'e'
      end
      object Etat: TLabel
        Left = 56
        Top = 85
        Width = 20
        Height = 13
        Caption = 'Etat'
        ShowAccelChar = False
      end
      object Label10: TLabel
        Left = 26
        Top = 85
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etat :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Reliure: TLabel
        Left = 208
        Top = 85
        Width = 33
        Height = 13
        Caption = 'Reliure'
        ShowAccelChar = False
      end
      object Label13: TLabel
        Left = 160
        Top = 85
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Reliure :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object TypeEdition: TLabel
        Left = 350
        Top = 85
        Width = 32
        Height = 13
        Caption = 'Edition'
        ShowAccelChar = False
      end
      object Label8: TLabel
        Left = 18
        Top = 134
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Notes :'
        Color = clWhite
        FocusControl = edNotes
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label12: TLabel
        Left = 148
        Top = 52
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Achet'#233' le :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object AcheteLe: TLabel
        Left = 208
        Top = 52
        Width = 45
        Height = 13
        Caption = 'Achet'#233' le'
      end
      object Label15: TLabel
        Left = 17
        Top = 101
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'Pages :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Pages: TLabel
        Left = 56
        Top = 101
        Width = 29
        Height = 13
        Caption = 'Pages'
      end
      object Label17: TLabel
        Left = 139
        Top = 101
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Orientation :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbOrientation: TLabel
        Left = 208
        Top = 101
        Width = 54
        Height = 13
        Caption = 'Orientation'
        ShowAccelChar = False
      end
      object Label19: TLabel
        Left = 350
        Top = 101
        Width = 41
        Height = 13
        Caption = 'Format :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbFormat: TLabel
        Left = 395
        Top = 101
        Width = 34
        Height = 13
        Caption = 'Format'
        ShowAccelChar = False
      end
      object lbCote: TLabel
        Left = 56
        Top = 68
        Width = 23
        Height = 13
        Caption = 'Cote'
      end
      object Label20: TLabel
        Left = 23
        Top = 68
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cote :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label21: TLabel
        Left = 119
        Top = 117
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sens de lecture :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbSensLecture: TLabel
        Left = 208
        Top = 117
        Width = 74
        Height = 13
        Caption = 'Sens de lecture'
        ShowAccelChar = False
      end
      object Label22: TLabel
        Left = 4
        Top = 181
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'N'#176' perso :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbNumeroPerso: TLabel
        Left = 56
        Top = 181
        Width = 87
        Height = 13
        Caption = 'Numero personnel'
        ShowAccelChar = False
      end
      object edNotes: TMemo
        Left = 56
        Top = 134
        Width = 503
        Height = 40
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
      object cbOffert: TLabeledCheckBox
        Left = 233
        Top = 3
        Width = 13
        Height = 13
        Alignment = taLeftJustify
        Caption = 'Offert'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Offert'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = 12615680
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        ReadOnly = True
      end
      object cbVO: TLabeledCheckBox
        Left = 233
        Top = 18
        Width = 13
        Height = 13
        Alignment = taLeftJustify
        Caption = 'VO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        EditLabel.Width = 14
        EditLabel.Height = 13
        EditLabel.Caption = 'VO'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = 12615680
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        ReadOnly = True
      end
      object cbDedicace: TLabeledCheckBox
        Left = 233
        Top = 33
        Width = 13
        Height = 13
        Alignment = taLeftJustify
        Caption = 'D'#233'dicac'#233
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        EditLabel.Width = 43
        EditLabel.Height = 13
        EditLabel.Caption = 'D'#233'dicac'#233
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = 12615680
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        ReadOnly = True
      end
      object cbStock: TLabeledCheckBox
        Left = 305
        Top = 3
        Width = 13
        Height = 13
        Alignment = taLeftJustify
        Caption = 'Stock'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'Stock'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = 12615680
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        ReadOnly = True
      end
      object cbCouleur: TLabeledCheckBox
        Left = 305
        Top = 33
        Width = 13
        Height = 13
        Alignment = taLeftJustify
        Caption = 'Couleur'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        EditLabel.Width = 37
        EditLabel.Height = 13
        EditLabel.Caption = 'Couleur'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = 12615680
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        ReadOnly = True
      end
    end
    object lvEditions: TListBox
      Left = 346
      Top = 505
      Width = 216
      Height = 62
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      ItemHeight = 13
      TabOrder = 7
      OnClick = lvEditionsClick
    end
    object vstSerie: TVirtualStringTree
      Left = 60
      Top = 301
      Width = 279
      Height = 55
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Height = 17
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      StateImages = dmPrinc.ShareImageList
      TabOrder = 8
      OnAfterItemPaint = vstSerieAfterItemPaint
      OnDblClick = vstSerieDblClick
      OnGetImageIndex = vstSerieGetImageIndex
      Columns = <>
    end
    object cbIntegrale: TLabeledCheckBox
      Left = 203
      Top = 51
      Width = 13
      Height = 13
      Caption = 'Int'#233'grale'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = 'Int'#233'grale'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 12615680
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ReadOnly = True
    end
    object HorsSerie: TLabeledCheckBox
      Left = 203
      Top = 66
      Width = 13
      Height = 13
      Caption = 'Hors s'#233'rie'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      EditLabel.Width = 48
      EditLabel.Height = 13
      EditLabel.Caption = 'Hors s'#233'rie'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 12615680
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ReadOnly = True
    end
    object lvUnivers: TVDTListView
      Left = 60
      Top = 94
      Width = 280
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
      TabOrder = 11
      OnData = lvUniversData
      OnDblClick = lvUniversDblClick
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 420
    Top = 14
    object EmpruntApercu: TAction
      Tag = 1
      Category = 'Emprunts'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
    end
    object FicheApercu: TAction
      Tag = 1
      Category = 'Fiche'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Impression1Click
    end
    object CouvertureApercu: TAction
      Tag = 1
      Category = 'Couverture'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer2Click
    end
    object FicheImprime: TAction
      Tag = 2
      Category = 'Fiche'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Impression1Click
    end
    object EmpruntImprime: TAction
      Tag = 2
      Category = 'Emprunts'
      Caption = 'Imprimer'
      ImageIndex = 3
    end
    object CouvertureImprime: TAction
      Tag = 2
      Category = 'Couverture'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer2Click
    end
    object FicheModifier: TAction
      Category = 'Fiche'
      Caption = 'Modifier'
      ImageIndex = 13
      OnExecute = FicheModifierExecute
    end
  end
  object MainMenu1: TMainMenu
    AutoMerge = True
    Images = frmFond.boutons_32x32_hot
    Left = 336
    Top = 16
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
    object Couverture1: TMenuItem
      Caption = 'Image'
      GroupIndex = 1
      object Aperuavantimpression5: TMenuItem
        Action = CouvertureApercu
      end
      object Aperuavantimpression6: TMenuItem
        Action = CouvertureImprime
      end
    end
    object Emprunts2: TMenuItem
      Caption = 'Emprunts'
      GroupIndex = 1
      object Aperuavantimpression3: TMenuItem
        Action = EmpruntApercu
      end
      object Aperuavantimpression4: TMenuItem
        Action = EmpruntImprime
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Images = frmFond.imlNotation_32x32
    Left = 8
    Top = 48
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
