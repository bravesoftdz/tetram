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
      Left = 67
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
      Top = 107
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'D'#233'dicac'#233
      Ctl3D = True
      ParentCtl3D = False
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
      Height = 501
      Anchors = [akTop, akRight]
      BevelInner = bvLowered
      Caption = ' '
      TabOrder = 16
      object imgVisu: TImage
        Left = 2
        Top = 25
        Width = 301
        Height = 423
        Align = alClient
        Center = True
      end
      object Panel3: TPanel
        Left = 2
        Top = 448
        Width = 301
        Height = 51
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object ChoixImage: TVDTButton
          Tag = 1
          Left = 178
          Top = 5
          Width = 117
          Height = 41
          Caption = 'Image'
          Spacing = -1
          OnClick = ChoixImageClick
          PngImage.Data = {
            89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
            F40000000473424954080808087C0864880000001974455874536F6674776172
            65007777772E696E6B73636170652E6F72679BEE3C1A000006004944415478DA
            CD960B50945514C7FFFBE4F9111068E8A252B0A61856BEC5C0071A212289988E
            92A9BBBC9497082A2D2088821A0684BC91F2352432183A6385031131A681E323
            F201AE6020020B2EB08BBBCBBADBC7A62BDB87A5356867E6CC7EF77CE79EF3DB
            73EF3DDFA5E1250B8D544F369B5D686C6CAC7851492512095BA150AC241F4F6A
            007C7D7D0FED4E4E23EAEFF50E7BF2491C5384876C94E4E4E44490C3222DC0BC
            4FA28855E9D5C30E702E6E11F2F76C97E5E5E51D24878775010E9000EA970430
            7FFDA7C4EAAC9FA93386045243AD9002E266A8D5A4038D0E1899836668F18F00
            D5312EC84FDA460558C08B267C722F0C39492D9742DD7E03EA0E21549DB7A116
            09C99DD44E75B4B403E31D6FD046D882A66732247855D47CE4256EA502B8F8C6
            106B0B6A29FF5875BF198A533BA096743C57A96956F6D0F3DCF5A48C8FE25646
            3A2177F710000BFD638975872EE92697DE47DFE14040D6F3AFD6DB907F143403
            DD4A9487392277572415E0FD803862C3B12B3A0590D79640569EF5D404067A2C
            AC717F0F9EF3A6C1272A1D5D3D52DDF74B63C1B29DA9633B1B34133909115400
            D78DF104FF789D4EC57ABE0A82B2E5374AE2B1561608FC6811785EF361FE8AB1
            C676F946135CF80910899FF412FD19DE3098EF3B780BE0FB8069C8DEB9850AF0
            415002E1577C4DEB3900D099B2122AF13DEDFCB953272278B52B3CE64E058341
            A780D535FC8E05BC04B475756BC64C8E3DCCD6A73FCEAD9133FC77911D174E05
            700BD945049CBC89C1BBB03D790558D20EAC593C074B9CA7E0A7ABCDE8E993C3
            7DD678B8BDE7003A9D0A71B7BD0BA947CF20B7B81C62A9022304DF82C6646BDF
            9F5E3719593B3653011687ED26369E6ED0966AA289026DB7AEA3DC838EFA3BF7
            70B4A209B1824498999AE19B532770BEB21849C1CB34EEDDBD7D482FAA44636B
            37BCE6DAC3D5F12D48FB645855D808A1E574889966DAB8A53E9390191B460570
            0F4F2482CEDCD6F8EDE4B6C3C74804A99A4EF6172642F79F404262012E5EBA88
            BA6B75F05BEF87C0201FA404BB425F8F0D414629D6F0A261646884F4CC7D08F6
            9880D123CDA112C9D04F2E956FE318FCD069A4897D72E50464C4845201966CD9
            4384943581603CC42FE3EBC0124A0053166047809F7402B95945E08CE7A0A5B5
            0555DF55E1CA951A4CB1926086831DFCF796A04FC9C6E1C2C3283A5404514339
            FC973B0377C853D121470587830DD7AD3500C5CBED90113D048047E45E22ACA2
            19664C25CE712E833E309960026F9A4090598AC0D07D283955820BB51790F979
            260237ADC641C10ACD3E084D2E869B270F6515651833EA3538DBAAE0C01D0334
            913144729C1BC7C1C7376C3400459EAFE38020840AB074DB6744F88F77354E19
            E31A304FDA0E259D06E66803089BDB20C82E036F43086C6DB9C8CD4D01C7440E
            3F2F278DFFF5DBAD483E5A091A4B1FD6E66C44F3DDFE5C7332B98A454364A72D
            4E77996936C1D7EEE3901E154C05F08C4A2622AADBB4BB758E7137C44A060AED
            AEA3A6FA321CA6DBA3E86C0D842D9DE02D9D0D2B4B33CA09502A1F82C96468C7
            F1CDD6A89112B82533D09EAE63AED648DF1E4405F850B09FD87A5EA4D3344CE9
            FDA8E4D62233E94B38BBCEC2C4B7C7E379C453E800A15C5F27E6119751F862DB
            262AC0B29814627B4D974E002654386F530DF90339E24293E1B5D61D531D273F
            33C03CE13488552C1DDB21E79148DBBA910AE0159B4A082E75FFE563A886A751
            2BA2CC6E402153E07841296ED60931826CC526A6C6B0E18E85D3A29943266FEC
            378077EB54F2BE40D3B117385A202D32900AB03C3E8D88B92AD126560F22B163
            F6C2C7B809B3D922E8296590901F1D49AF144C1613569C913A091E925AF5C012
            C93D5C74A8F41E575EBB04F9334C911A310480F7CE7462C7B5BEC1EEBAD57834
            B0A0C960C394C086218535A93215039D6A3D74A9D8E824B5496904915A1F43C9
            4088DC290452C203A8002B761D20E26FCA9E3AF1EF0D4F35EABC1AF8C99A6C88
            94CDFE5480D4CC6C42DC3FCC3752525E25FB42A01F9F0A909D9D4D0C7BF647C2
            E7FFDF00B85CEE11272727C67F0DFCAC52595949ABAFAFCF7F0C6045EA0C5217
            BE28804742DEED513DB84BF05E30C080FC3A18E08D970020FE038879D6852647
            1E9B0000000049454E44AE426082}
        end
        object VDTButton1: TVDTButton
          Tag = 1
          Left = 6
          Top = 5
          Width = 117
          Height = 41
          Caption = 'Effacer'
          Spacing = -1
          OnClick = VDTButton1Click
          PngImage.Data = {
            89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
            F40000000473424954080808087C0864880000001974455874536F6674776172
            65007777772E696E6B73636170652E6F72679BEE3C1A000007A34944415478DA
            AD577B4C9BD715FFF9FBFCB6B1CDCB60CC23B480C1658452124A5068281D4993
            AE224997256BDA75FB63644BD34DEAA645D3B2555D37456DDA28EA92A66B55B5
            52B7AE1D635B1E4B9586051A9A411A161E0502E1E1F030C63660FCC26FEF7C26
            421B3118DA1DE9A7FB7DF77EF79CDFB9F79C73EFC7C35790AC8C7431353A42CF
            EDB1F1C097D1C15BA3411135DB08BB09A5843C024BB84D7895F0361199FFBF12
            20A39C816AC23EC24E82323B33013B6AF4D85AA5C3C09005F5673BD17AFD36C2
            615868FC04E12411B17D250264584DCD21421D21395DAB42EDA3F761FBD7F5D0
            E7A500E110CC93D308B302A4A4A86034D9F1D7F3DD6838D78521C3B483E69C26
            1C2722936B224086B5D41C217C876178E2EACA5C3CF944092ACBEF05C30BC36D
            9AC4F08D6E487DB378B97E184F6ED160C2C9A2607339D63F9017D1F1E9D521BC
            7AAA199D3D462FBDBE477885880CC62440C68BA8F90741BB7347217E72B00A5A
            8D1261BF0F43D7DAC19F1E855400F802213476CEE0A50F0771F6972550C90408
            86C2B86EF022B5683DCA2AEF8FE8BB78B91FAFBDD1849BB72C417AAD271C2522
            1D51099071EED9969DA1521CFFED4E14176A23FD134306CC775E8542C2A277CC
            89D31746F1F7360B3CBE50645C2C60B0BF4A8343DFC8825A298CF4F54C78A0C8
            D16343D5468A8B30CE5EECC5715A9191D1196EF85B44E2A3A82B9099AE75BD76
            40278D57491054A5E391ADC5E0F178B4D756FCE983261C7DA70B32B9020CC32C
            4CE62D4CE78C381D7654E6B1A82ED520233F0795356590C82491F139FB3C42B4
            42CF1E6E404BEB888DE6AD2312734B09C832B45AC3EB3FCC4F2ACB08E22679D1
            3CC2A0A45C8FC71E7B20628C0BB463A7AEA277C8059148B23871DEED424E9618
            CF7E6F03F4BAD4489FD71B407BE718246201B2B312A1524A70ECE465BCFE564B
            D86CB5667A3CDEF1A5048419DAB4FEDACDE9EB0ED72683F1B9229DBDE31EB4DC
            6651B4A1008F3F5EB2E8FDF94BC3F8B46D0AA5452AECDEA15BECEFEB37A1A77F
            0A6291008F3C940B3111E0C4EF0FA2F6A977D0DD37393936617C9ABA2E2D25C0
            D3A4A49C130A05DBC3E4EDBEAD05F841B508229F233268B078D1352D45F1A622
            6C7C50F73F91CC79CBEDAFDDEE419A4681F434D5E298CBEDC3BF3E37E0A3BF75
            E262533F110934194DA65F71C9122D0DB7A6A7694EB07CA12E2C2F8248224551
            A6173FDF1E8046E804B7E54E4F18F3F254E46D2A85481E073719F0FA02885749
            1795F40F9A71F9335AA14E1FAC7E3514EA75B8DE700C8160B0C3669B3BED72BB
            DBE8B38E680432B59AD43FF3F9FC8D509444826B21D81864A584F0D22E204741
            4410465C7E3164F7E42F4EECEA31E2CCA501B40EC821501722294307A1480C1E
            CB877D761ACD6F1E0C4D4C9AF6048341AE367C4E988A5A88D234A917047CFE36
            91BA025477C0B02C02013F2DB387F699455A328B17777950BC3E0B067F02CE7E
            32802BBD7C08137448D4DE0BB1540E562802CBA7BD678508F2589806BB70A3FE
            D756DAFBFD778CCF444DC30881D4943F0804826F173EFC1C7881C0629A39EC36
            58A68C70B9EC904865902BC4102B13A14CD24042A929929161891210481162A8
            3081A1755A506FFCF7198C34BDDB376E9C7C8A5EDB97AD849C6852D4278442E1
            73F7551D02130C2E1D86DBE580D33E0396A25C491ECB92D2C05724202C902DD6
            85A532DCF826263A3EBE629C341DE0126B4502A9EAE4232291E845FD96836043
            612C277697059A8A6F02BCD8277AEF5F5E8065F8468369CAFC3C97502B124849
            4E3A20168BDFD03D540761985D56A9CD36066DD5D3318D73D2FE761DEC56E3EF
            A90071E9675A91407252E26EA944529F5BF10CC4AC7459A57E260CD5FA87631A
            0F05BC683BB91F4EA7F33733B3B697B9C55B914062427C855C266BC9DEB00772
            49D2B28A19491C24F9A53109B82C0674FFF1A798B1D97EEC70384F71DC5724A0
            542872544AC52D6DE1A34848C85E56314F2485545F1693C0EC483BFACF1C85C9
            6CDEEBF5FA3EBC4BCF5D9E314C1C55439B3AA78249D5162FAF99725C56541193
            80A5B70983177FE71B1D9FA8A1D7E698044884742C9BE33505CA8CBCE5F73810
            F443595A13930057030CCDEF19A90871F7C96BAB21003A1547A5CAD48CDCFB9F
            5856B1C73387C4F2DA9804465BDEC7D8B5862E2A425C15EC5E15016D9AA6552C
            519415943FC395C1A88A5D4E0BD49BF7C4243070EE154CDDFCACD1689AE28AD0
            5DF7C2A804E2E4F2BD2A95F2A4501C97905DBC8BCE76F95DDFD8E7C6A0D9B272
            1D70986EA1B7FE05BAB038DE9F325B0E53D7C4AA089028A91C572727263C4F27
            E32695468F745D1578FF5519A72DB79059F3FDA893BDCE6958BE6884B1FD0C82
            7E4FD83A3353E776CF73F7C0B9D512E084BBCAE8931213BE4B85A98E2F108B73
            1FDC0F01238A0C9A27BB90BDFD478B1F87E93FC166E880F98B4F22A9C76D1D1D
            62F3F31ECFBB16EBF407F4C995684656F36B96249349B7C52B95BF6059569759
            B213CAB8344C18DA9057FB33F89C3330F73492E1467A9E8E4C0885426394F317
            66E76CFFA41BD03075F5119C5F9600272CC3E3E9D5C94987696BF626E794333C
            3A6E0361FF1D6F439CB701BAF1B4BADDEEF3B6393B77E68F11B88BA77B25C56B
            FA3925A1D854ECA3203D42054B73C75BABCFE7BF3067B77FECF17AFBEE18B6AE
            56E15A0944E68884C2AFD1B6D492CB0E92EB149AA35888F035FFA2FF077BA6F9
            3FBFFA68450000000049454E44AE426082}
        end
      end
      object Panel4: TPanel
        Left = 2
        Top = 2
        Width = 301
        Height = 23
        Align = alTop
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object cbImageBDD: TCheckBoxLabeled
          Left = 8
          Top = 6
          Width = 217
          Height = 13
          Caption = 'Image stock'#233'e dans la base de donn'#233'es'
          Checked = True
          Ctl3D = True
          ParentCtl3D = False
          State = cbChecked
          TabOrder = 0
          LinkControls = <
            item
              Control = cbImageBDD
            end>
        end
      end
    end
    object cbNumerote: TCheckBoxLabeled
      Left = 422
      Top = 107
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'Num'#233'rot'#233
      Ctl3D = True
      ParentCtl3D = False
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
