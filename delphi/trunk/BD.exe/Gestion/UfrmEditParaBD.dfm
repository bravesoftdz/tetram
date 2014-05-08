object frmEditParaBD: TfrmEditParaBD
  Left = 188
  Top = 180
  ActiveControl = edTitre
  Caption = 'frmEditParaBD'
  ClientHeight = 899
  ClientWidth = 824
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 29
    Width = 824
    Height = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitTop = 25
    ExplicitWidth = 827
  end
  object Label28: TLabel
    Left = 8
    Top = 4
    Width = 69
    Height = 23
    Caption = 'ParaBD'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 33
    Width = 824
    Height = 866
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      824
      866)
    object Label2: TLabel
      Left = 33
      Top = 7
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Titre :'
      FocusControl = edTitre
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 2
      Top = 135
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description :'
      FocusControl = edDescription
    end
    object btCreateur: TVDTButton
      Tag = 1
      Left = 278
      Top = 260
      Width = 57
      Height = 72
      Caption = 'Auteur /'#13#10'Cr'#233'ateur'
      Enabled = False
      Layout = blGlyphBottom
      OnClick = btCreateurClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000001974455874536F6674776172
        65007777772E696E6B73636170652E6F72679BEE3C1A000001924944415478DA
        A593CF2B445114C7BFF7CD9B9937C3F363A8998D29358AB0D26C98291B4B2294
        85B261C972E41FB0100BAC44898D1FD9B04191321E121B56A4484D340B63E6CD
        AF37EFC77567AC14CF4CBE75EB9CFBED7C3A9D7B0FC13F454C3C8E1DA3744027
        0451B31D33CB4D29194B4AD99392001501FB0405E6052F8FEC8BC6422CF38212
        8A1D215E14A0BCC3BEE0A8B78E7B06AAE0FDF041DAB8849EA2118E1ABD7149BD
        2EA20361DBD5E31CAC6E1431E75FC2C1F31E5617D7F2DD2409C14022AC1C9A02
        C480FDD4332C06AD6EBE903755B640D70D48EB57C83EA92A285A6549B937033C
        78462A1AACB5966FF74A44437453CE8733F29932690678ABE973BA1D753610EB
        97ADC906129719A46E73119D58FCE970FAD504205CBBBA1D6D7CA5057C190735
        A1437BD7113BCC643818C1F8997A633E830EFB8ED82EF4DBDC5C21A71A416C3F
        0543A3434929B7F5E72B8841619A7362AABACB815C54877CAE5036B8101BDC6C
        91FFC0D64C08B9630E618549103A2C8773BBF8453FEE02EB629415FB884E5712
        17CA234C64B64C45E9DF804F400D9711AB9FEB370000000049454E44AE426082}
    end
    object Label19: TLabel
      Left = 17
      Top = 264
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs :'
    end
    object Bevel1: TBevel
      Left = 0
      Top = 862
      Width = 824
      Height = 4
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 866
      ExplicitWidth = 827
    end
    object Label20: TLabel
      Left = 31
      Top = 33
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie :'
    end
    object Bevel4: TBevel
      Left = 139
      Top = 339
      Width = 290
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label24: TLabel
      Left = 68
      Top = 421
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
      Layout = tlCenter
    end
    object Label25: TLabel
      Left = 163
      Top = 421
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote :'
      Layout = tlCenter
    end
    object VDTButton14: TVDTButton
      Left = 263
      Top = 418
      Width = 96
      Height = 21
      Caption = 'Convertisseur'
      OnClick = VDTButton14Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000001974455874536F6674776172
        65007777772E696E6B73636170652E6F72679BEE3C1A0000028A4944415478DA
        AD935D48537118C69F733CCB6D6ED99C2D3F5AD36698854BAA31592695A4158A
        05D1A7581984C9208930280AD2EC2633B192E80357575A4A6617F6412C0B23EB
        C214B53422974C6B76FC9CEE6CF39C7F674641687651EFDD1FDEE7C7FF79DFE7
        A50821F897A2FE3B809224C941485A94CABD5B1BEC8D7FD1C39C01DF7A47EC13
        FE081045E1A228C3A41DCD4ED18F9AD2970E31A68563A069A0B65D8D138F235F
        760FF8F208DFD93A0D2097992C47CDBDE539AB592A3AC433E33727BC34CE3546
        4E9635855E1BF7B0A7086F1FFC0558AB8F799DB5E29351A39062EBF2F159FD7E
        F826C5B106DD607D27D94EF82EDB14203E22AEE578F2BB04FFC339AE44AE690C
        32C974B17F547DC1C9E8D21E464A667101F8F652D13E4F21C09CBF65A5FDE20E
        BD038CD83820A7B141476090FE18AE8F96C0199D0D76491E3CF313E09AF0609B
        C1DC38C20DEE15AD3828306BD291D2F360F15C372CB26168BC0244CB885AB60A
        A1FA34B8627641A2502148A104EB75A0A1A60C374ADEF89CACD702A1B3D20FD8
        87F5762BA2472073313818E846A29B03492A4458791502CE5F815D338CBAB60B
        68E0BA911C9A8AA0578B70BFA23E5FB471D50F0841B0DB8675BD06A83940DC76
        86A041AA3107AEF71DA85736A12D8CC6A1D81CE41AF643A58884F5762D0A2CC5
        67C1BF2DFC9903068CAF0446E711C4B153DE033DF31091A84356EC01646A3741
        2D9742A594E16973334E5F2A251D0FFB6D981C38F95B1229C6BC195123D54872
        283187E0D61E1B74EA70CCA105D89E37E2F2CD4AAEBF75E82E84E10A081F5B44
        AD67A6284740C9D52DD849198BD2AD78F6E809EE55D77C71B3139510FAAE837C
        FDEC5FDFACC7244268D0934520C246089C157C5715E01D223334CF7A8D9458E4
        2FE7FA1D7C9B2366D9AB45ED0000000049454E44AE426082}
    end
    object Label10: TLabel
      Left = 24
      Top = 108
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
      Layout = tlCenter
    end
    object Label18: TLabel
      Left = 142
      Top = 356
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le :'
      Layout = tlCenter
    end
    object Label9: TLabel
      Left = 168
      Top = 383
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix :'
      Layout = tlCenter
    end
    object SpeedButton3: TVDTButton
      Left = 263
      Top = 379
      Width = 96
      Height = 21
      Caption = 'Convertisseur'
      OnClick = SpeedButton3Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000001974455874536F6674776172
        65007777772E696E6B73636170652E6F72679BEE3C1A0000028A4944415478DA
        AD935D48537118C69F733CCB6D6ED99C2D3F5AD36698854BAA31592695A4158A
        05D1A7581984C9208930280AD2EC2633B192E80357575A4A6617F6412C0B23EB
        C214B53422974C6B76FC9CEE6CF39C7F674641687651EFDD1FDEE7C7FF79DFE7
        A50821F897A2FE3B809224C941485A94CABD5B1BEC8D7FD1C39C01DF7A47EC13
        FE081045E1A228C3A41DCD4ED18F9AD2970E31A68563A069A0B65D8D138F235F
        760FF8F208DFD93A0D2097992C47CDBDE539AB592A3AC433E33727BC34CE3546
        4E9635855E1BF7B0A7086F1FFC0558AB8F799DB5E29351A39062EBF2F159FD7E
        F826C5B106DD607D27D94EF82EDB14203E22AEE578F2BB04FFC339AE44AE690C
        32C974B17F547DC1C9E8D21E464A667101F8F652D13E4F21C09CBF65A5FDE20E
        BD038CD83820A7B141476090FE18AE8F96C0199D0D76491E3CF313E09AF0609B
        C1DC38C20DEE15AD3828306BD291D2F360F15C372CB26168BC0244CB885AB60A
        A1FA34B8627641A2502148A104EB75A0A1A60C374ADEF89CACD702A1B3D20FD8
        87F5762BA2472073313818E846A29B03492A4458791502CE5F815D338CBAB60B
        68E0BA911C9A8AA0578B70BFA23E5FB471D50F0841B0DB8675BD06A83940DC76
        86A041AA3107AEF71DA85736A12D8CC6A1D81CE41AF643A58884F5762D0A2CC5
        67C1BF2DFC9903068CAF0446E711C4B153DE033DF31091A84356EC01646A3741
        2D9742A594E16973334E5F2A251D0FFB6D981C38F95B1229C6BC195123D54872
        283187E0D61E1B74EA70CCA105D89E37E2F2CD4AAEBF75E82E84E10A081F5B44
        AD67A6284740C9D52DD849198BD2AD78F6E809EE55D77C71B3139510FAAE837C
        FDEC5FDFACC7244268D0934520C246089C157C5715E01D223334CF7A8D9458E4
        2FE7FA1D7C9B2366D9AB45ED0000000049454E44AE426082}
    end
    object Label12: TLabel
      Left = 117
      Top = 108
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type :'
      Layout = tlCenter
    end
    object cbxCategorie: TLightComboCheck
      Left = 148
      Top = 108
      Width = 166
      Height = 13
      Checked = False
      PropertiesStored = False
      CheckVisible = False
      OnChange = cbxCategorieChange
      ShowCaptionHint = False
      AssignHint = False
      OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
      Items.CaptionComplet = True
      Items.Separateur = ' '
      Items = <>
    end
    object Bevel3: TBevel
      Left = 139
      Top = 249
      Width = 290
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label11: TLabel
      Left = 19
      Top = 58
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers :'
    end
    object btUnivers: TVDTButton
      Tag = 1
      Left = 278
      Top = 57
      Width = 57
      Height = 41
      Caption = 'Univers'
      Enabled = False
      Layout = blGlyphBottom
      OnClick = btUniversClick
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
    object ChoixImage: TVDTButton
      Tag = 1
      Left = 14
      Top = 463
      Width = 52
      Height = 130
      Caption = 'Images'
      Layout = blGlyphBottom
      OnClick = ChoixImageClick
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
    object VDTButton5: TVDTButton
      Left = 793
      Top = 483
      Width = 22
      Height = 20
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = False
      OnClick = VDTButton5Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000001954944415478DA63FCFFFF3F03258071181AB0F7D0AE1D
        4F5E3D967FF9FEA5C0EBF7AFB87838797F8B0A8A7E1113147F2B2E28FE44845F
        E4AEA6B64E1186013BF76FDB573BBBCAFEC6E31B4C4C5C8C0C1CF22C0CCCFCCC
        0CFFBF3330FCFBF98FE1CF877F0CBF5EFC61E062E7FA5F195DFD2C3FB15806C5
        80A8F2D09F5B8E6D661374E76260E2040A303130B00AB030B00A32C35D0732E0
        DDF66F0C6CDF39FE3FDFF59609C580B92B67DE2E9C92AF22ECCBC5C000D4C32E
        C5CAC0CCC904D71C2817C170E1D95986C3FDA719A2ECA2BF4DAF9FC38D1106D1
        E5613FB65DDAC22EE8C1C9C0C2C704B49D052C2EC026C850AEDBC490569DCC20
        FA4DE2FFB2BA953375F50C32310CB872F9E294A4F6F8CC074C7798784CD81938
        64D9181881AE7192F460D8B57307C3CB3D1F19E6962F381BEC1D668233164E9F
        39B1A4786A61E495B79798041C38183895D818FEDD626278BAE52D43865FD6C7
        AE923E0182E9E0EA954B931A1734A4EF3CBB9D8D458089E1F79BBF0C610E613F
        E6342FE22429211577E67D5ABE77194F8453D497BE8A497CF449897437000080
        F2B8E1D3A5D1600000000049454E44AE426082}
    end
    object VDTButton4: TVDTButton
      Left = 793
      Top = 462
      Width = 22
      Height = 21
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = False
      OnClick = VDTButton4Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000001934944415478DA63FCFFFF3F03258071981B50DC99F769
        F9DE653C114E515FFA2A26F1116DC0D52B9726352E6848DF79763B1B8B00D3FF
        DF6FFE32863984FD98D3BC8893A001A7CF9C58523CB530F2CADB4B8C020E1C8C
        9C4A6C0CFF6E31313CDDF29621C32FEB5357491F3F4E03AE5CBE3825A93D3EF3
        01D31D061E1376260E5936064666060627490F865D3B7730BCDCF391616EF982
        B3C1DE6126580D882E0FFBB1EDD21636410F4E46163E2606564116B0B8009B20
        43B96E13435A753283E83789FFCBEA564ED7D533C8463160EECA99B70BA7E4AB
        08FB723130006D6597626560E664821B1E2817C170E1D95986C3FDA719A2ECA2
        BF4DAF9FC38D62405479E8CF2DC736B309BA73313081820AA897558005E80A66
        B821BF5EFC6178B7FD1B03DB778EFFCF77BD65423160E7FE6DFB6A6757D9DF78
        7C8389898BF13F873CCB7F667E66A6FFDF1918FEFDFCC7F0E7C33FB0015CEC5C
        FF2BA3AB9FE52716CB608D85BD8776ED7CF2EAB1DCCBF72F055EBF7FC5C5C3C9
        FB5B5450F48B98A0F81B7141F1A722FC227735B5758AE89312E96200007E39BB
        E1E7DF03100000000049454E44AE426082}
    end
    object Bevel5: TBevel
      Left = 261
      Top = 450
      Width = 302
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object edTitre: TEditLabeled
      Left = 68
      Top = 4
      Width = 436
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      LinkControls = <
        item
          Control = Label2
        end>
      CurrencyChar = #0
    end
    object edDescription: TMemoLabeled
      Left = 68
      Top = 132
      Width = 436
      Height = 111
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 6
      LinkControls = <
        item
          Control = Label6
        end>
    end
    object lvAuteurs: TVDTListViewLabeled
      Left = 335
      Top = 261
      Width = 169
      Height = 72
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stNone
      TabOrder = 8
      OnData = lvAuteursData
      OnKeyDown = lvAuteursKeyDown
      LinkControls = <
        item
          Control = btCreateur
        end>
    end
    object edAnneeCote: TEditLabeled
      Left = 111
      Top = 418
      Width = 46
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 13
      LinkControls = <
        item
          Control = Label24
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edPrixCote: TEditLabeled
      Left = 196
      Top = 418
      Width = 64
      Height = 21
      AutoSelect = False
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 14
      LinkControls = <
        item
          Control = Label25
        end
        item
          Control = VDTButton14
        end>
      TypeDonnee = tdCurrency
      CurrencyChar = #0
    end
    object edAnneeEdition: TEditLabeled
      Left = 68
      Top = 105
      Width = 46
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 3
      LinkControls = <
        item
          Control = Label10
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object cbStock: TCheckBoxLabeled
      Left = 442
      Top = 356
      Width = 61
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'En stock'
      Checked = True
      Ctl3D = True
      ParentCtl3D = False
      State = cbChecked
      TabOrder = 15
      LinkControls = <
        item
          Control = cbStock
        end>
    end
    object cbGratuit: TCheckBoxLabeled
      Left = 68
      Top = 382
      Width = 53
      Height = 16
      Cursor = crHandPoint
      Caption = 'Gratuit'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 10
      OnClick = cbGratuitClick
      LinkControls = <
        item
          Control = cbGratuit
        end>
    end
    object cbOffert: TCheckBoxLabeled
      Left = 68
      Top = 355
      Width = 53
      Height = 16
      Cursor = crHandPoint
      Caption = 'Offert'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 9
      OnClick = cbOffertClick
      LinkControls = <
        item
          Control = cbOffert
        end>
    end
    object dtpAchat: TDateTimePickerLabeled
      Left = 196
      Top = 352
      Width = 101
      Height = 21
      Date = 38158.758085983800000000
      Time = 38158.758085983800000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 11
      LinkControls = <
        item
          Control = Label18
        end>
    end
    object edPrix: TEditLabeled
      Left = 196
      Top = 379
      Width = 64
      Height = 21
      AutoSelect = False
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 12
      OnChange = edPrixChange
      LinkControls = <
        item
          Control = Label9
        end
        item
          Control = SpeedButton3
        end>
      TypeDonnee = tdCurrency
      CurrencyChar = #0
    end
    object cbDedicace: TCheckBoxLabeled
      Left = 335
      Top = 110
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'D'#233'dicac'#233
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 4
      LinkControls = <
        item
          Control = cbDedicace
        end>
    end
    object Panel1: TPanel
      Left = 510
      Top = 4
      Width = 305
      Height = 435
      Anchors = [akTop, akRight]
      BevelInner = bvLowered
      Caption = ' '
      TabOrder = 16
      object imgVisu: TImage
        Left = 2
        Top = 2
        Width = 301
        Height = 431
        Align = alClient
        Center = True
        ExplicitTop = 25
        ExplicitHeight = 448
      end
    end
    object cbNumerote: TCheckBoxLabeled
      Left = 422
      Top = 107
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'Num'#233'rot'#233
      Color = clBtnFace
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 5
      LinkControls = <
        item
          Control = cbNumerote
        end>
    end
    inline vtEditSeries: TframVTEdit
      Left = 68
      Top = 30
      Width = 436
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 68
      ExplicitTop = 30
      ExplicitWidth = 436
      inherited btReset: TVDTButton
        Left = 373
        ExplicitLeft = 373
      end
      inherited btNew: TVDTButton
        Left = 415
        ExplicitLeft = 415
      end
      inherited btEdit: TVDTButton
        Left = 394
        ExplicitLeft = 394
      end
      inherited VTEdit: TJvComboEdit
        Top = 1
        Width = 373
        OnChange = vtEditSeriesVTEditChange
        ExplicitTop = 1
        ExplicitWidth = 373
      end
    end
    inline vtEditPersonnes: TframVTEdit
      Left = 68
      Top = 261
      Width = 204
      Height = 21
      TabOrder = 7
      ExplicitLeft = 68
      ExplicitTop = 261
      ExplicitWidth = 204
      inherited btReset: TVDTButton
        Left = 141
        ExplicitLeft = 141
      end
      inherited btNew: TVDTButton
        Left = 183
        ExplicitLeft = 183
      end
      inherited btEdit: TVDTButton
        Left = 162
        ExplicitLeft = 162
      end
      inherited VTEdit: TJvComboEdit
        Width = 141
        OnChange = vtEditPersonnesVTEditChange
        ExplicitWidth = 141
      end
    end
    inline vtEditUnivers: TframVTEdit
      Left = 68
      Top = 57
      Width = 204
      Height = 21
      TabOrder = 2
      ExplicitLeft = 68
      ExplicitTop = 57
      ExplicitWidth = 204
      inherited btReset: TVDTButton
        Left = 141
        ExplicitLeft = 284
      end
      inherited btNew: TVDTButton
        Left = 183
        ExplicitLeft = 326
      end
      inherited btEdit: TVDTButton
        Left = 162
        ExplicitLeft = 305
      end
      inherited VTEdit: TJvComboEdit
        Width = 141
        OnChange = vtEditUniversVTEditChange
        ExplicitWidth = 141
      end
    end
    object lvUnivers: TVDTListViewLabeled
      Left = 335
      Top = 57
      Width = 169
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stNone
      TabOrder = 17
      OnData = lvUniversData
      OnKeyDown = lvUniversKeyDown
      LinkControls = <
        item
          Control = btUnivers
        end>
    end
    object vstImages: TVirtualStringTree
      Left = 68
      Top = 462
      Width = 725
      Height = 130
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      CheckImageKind = ckDarkCheck
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      TabOrder = 18
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.StringOptions = []
      OnChange = vstImagesChange
      OnChecked = vstImagesChecked
      OnDblClick = vstImagesDblClick
      OnEditing = vstImagesEditing
      OnGetText = vstImagesGetText
      OnPaintText = vstImagesPaintText
      OnInitNode = vstImagesInitNode
      OnKeyDown = vstImagesKeyDown
      OnNewText = vstImagesNewText
      OnStructureChange = vstImagesStructureChange
      Columns = <
        item
          Position = 1
          Width = 625
        end
        item
          Position = 0
          Width = 100
        end>
    end
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 824
    Height = 29
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 824
    inherited btnOK: TButton
      Left = 645
      Width = 87
      Caption = 'Enregistrer'
      OnClick = btnOKClick
      ExplicitLeft = 645
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 741
      ExplicitLeft = 741
    end
  end
  object ChoixImageDialog: TOpenPictureDialog
    DefaultExt = 'bmp'
    Filter = 
      'Fichiers graphiques utilisables (*.bmp, *.jpg, *.jpeg, *.emf, *.' +
      'wmf)|*.bmp;*.jpg;*.jpeg;*.emf;*.wmf|Bitmaps (*.bmp)|*.bmp|JPEG (' +
      '*.jpg, *.jpeg)|*.jpg;*.jpeg|Metafile (*.wmf, *.emf)|*.wmf:*.emf'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist]
    Left = 378
    Top = 65535
  end
end
