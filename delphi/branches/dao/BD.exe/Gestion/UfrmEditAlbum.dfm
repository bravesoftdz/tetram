object frmEditAlbum: TfrmEditAlbum
  Left = 480
  Top = 108
  ActiveControl = edTitre
  Caption = 'Saisie d'#39'album'
  ClientHeight = 829
  ClientWidth = 734
  Color = clBtnFace
  Constraints.MinWidth = 750
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 29
    Width = 734
    Height = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitTop = 25
    ExplicitWidth = 742
  end
  object Label28: TLabel
    Left = 8
    Top = 4
    Width = 61
    Height = 23
    Caption = 'Album'
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
    Width = 734
    Height = 796
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      734
      779)
    object imgVisu: TImage
      Left = 624
      Top = 593
      Width = 104
      Height = 129
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Center = True
      OnClick = imgVisuClick
      ExplicitLeft = 632
    end
    object Label3: TLabel
      Left = 100
      Top = 59
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = ' Parution :'
      FocusControl = edAnneeParution
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 22
      Top = 7
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = ' Titre :'
      FocusControl = edTitre
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 11
      Top = 133
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire :'
      FocusControl = histoire
    end
    object Label7: TLabel
      Left = 338
      Top = 133
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Notes :'
      FocusControl = remarques
      ExplicitLeft = 346
    end
    object btScenariste: TVDTButton
      Tag = 1
      Left = 384
      Top = 227
      Width = 69
      Height = 41
      Caption = 'Sc'#233'nariste'
      Enabled = False
      Layout = blGlyphBottom
      OnClick = ajoutClick
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
    object btDessinateur: TVDTButton
      Tag = 2
      Left = 384
      Top = 271
      Width = 69
      Height = 41
      Caption = 'Dessinateur'
      Enabled = False
      Layout = blGlyphBottom
      OnClick = ajoutClick
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
    object Label19: TLabel
      Left = 9
      Top = 230
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs :'
      FocusControl = remarques
    end
    object ChoixImage: TVDTButton
      Tag = 1
      Left = 3
      Top = 593
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
    object VDTButton4: TVDTButton
      Left = 601
      Top = 592
      Width = 22
      Height = 21
      Anchors = [akTop, akRight]
      Enabled = False
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
      ExplicitLeft = 609
    end
    object VDTButton5: TVDTButton
      Left = 601
      Top = 613
      Width = 22
      Height = 20
      Anchors = [akTop, akRight]
      Enabled = False
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
      ExplicitLeft = 609
    end
    object Bevel1: TBevel
      Left = 0
      Top = 775
      Width = 736
      Height = 4
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 793
      ExplicitWidth = 742
    end
    object Label20: TLabel
      Left = 23
      Top = 33
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie :'
      FocusControl = remarques
    end
    object btColoriste: TVDTButton
      Tag = 3
      Left = 384
      Top = 315
      Width = 69
      Height = 41
      Caption = 'Coloriste'
      Enabled = False
      Layout = blGlyphBottom
      OnClick = ajoutClick
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
    object Label1: TLabel
      Left = 18
      Top = 59
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = ' Tome :'
      FocusControl = edTome
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 10
      Top = 268
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editions :'
      FocusControl = remarques
    end
    object VDTButton3: TVDTButton
      Left = 225
      Top = 343
      Width = 112
      Height = 20
      Caption = 'Nouvelle'
      Flat = False
      OnClick = VDTButton3Click
    end
    object Bevel3: TBevel
      Left = 52
      Top = 259
      Width = 292
      Height = 5
      Shape = bsTopLine
    end
    object Bevel4: TBevel
      Left = 343
      Top = 362
      Width = 387
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      ExplicitWidth = 395
    end
    object Bevel5: TBevel
      Left = 216
      Top = 580
      Width = 302
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      ExplicitWidth = 310
    end
    object Label16: TLabel
      Left = 384
      Top = 60
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tomes :'
      FocusControl = edTomeDebut
      Font.Charset = ANSI_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Label17: TLabel
      Left = 464
      Top = 60
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = #224
      FocusControl = edTomeFin
      Font.Charset = ANSI_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Bevel6: TBevel
      Left = 343
      Top = 259
      Width = 7
      Height = 103
      Shape = bsLeftLine
    end
    object Label29: TLabel
      Left = 11
      Top = 85
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers :'
    end
    object btUnivers: TVDTButton
      Tag = 1
      Left = 389
      Top = 83
      Width = 69
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
    object PanelEdition: TPanel
      Left = 56
      Top = 375
      Width = 680
      Height = 193
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 17
      object SpeedButton3: TVDTButton
        Left = 304
        Top = 93
        Width = 72
        Height = 21
        Caption = 'Convertisseur'
        Flat = False
        OnClick = SpeedButton3Click
      end
      object Label9: TLabel
        Left = 210
        Top = 96
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prix :'
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 15
        Top = 69
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'Edition :'
        Layout = tlCenter
      end
      object Label11: TLabel
        Left = 24
        Top = 123
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'ISBN :'
        Layout = tlCenter
      end
      object VDTButton6: TVDTButton
        Left = 304
        Top = 120
        Width = 48
        Height = 20
        Caption = 'V'#233'rifier'
        Enabled = False
        Flat = False
        OnClick = VDTButton6Click
      end
      object Label12: TLabel
        Left = 456
        Top = 19
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etat :'
        Layout = tlCenter
      end
      object Label13: TLabel
        Left = 443
        Top = 53
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Reliure :'
        Layout = tlCenter
      end
      object cbxEtat: TLightComboCheck
        Left = 496
        Top = 19
        Width = 184
        Height = 13
        Checked = False
        PropertiesStored = False
        CheckVisible = False
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object cbxReliure: TLightComboCheck
        Left = 496
        Top = 53
        Width = 184
        Height = 13
        Checked = False
        PropertiesStored = False
        CheckVisible = False
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object Label14: TLabel
        Left = 444
        Top = 36
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'Edition :'
        Layout = tlCenter
      end
      object cbxEdition: TLightComboCheck
        Left = 496
        Top = 36
        Width = 184
        Height = 13
        Checked = False
        PropertiesStored = False
        CheckVisible = False
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object Label18: TLabel
        Left = 222
        Top = 69
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Achet'#233' le :'
        Layout = tlCenter
      end
      object Label21: TLabel
        Left = 18
        Top = 149
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'Pages :'
        Layout = tlCenter
      end
      object Label22: TLabel
        Left = 422
        Top = 69
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Orientation :'
        Layout = tlCenter
      end
      object cbxOrientation: TLightComboCheck
        Left = 496
        Top = 69
        Width = 184
        Height = 13
        Checked = False
        PropertiesStored = False
        CheckVisible = False
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object Label23: TLabel
        Left = 442
        Top = 104
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Format :'
        Layout = tlCenter
      end
      object cbxFormat: TLightComboCheck
        Left = 496
        Top = 104
        Width = 185
        Height = 13
        Checked = False
        PropertiesStored = False
        CheckVisible = False
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object VDTButton13: TVDTButton
        Left = 355
        Top = 120
        Width = 21
        Height = 20
        OnClick = VDTButton13Click
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F
          530000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000009504C5445000000FFFFFFFFFFFF7378A5630000000374
          524E53FFFF00D7CA0D41000000384944415478DA63646240058C0C0C4CFF98FE
          810930356804305C0A950529042B06AAF807510E54FA0F2CF00F26C40046485A
          600268860200D68B4C1F0B8D881E0000000049454E44AE426082}
      end
      object Label24: TLabel
        Left = 108
        Top = 175
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ann'#233'e :'
        Layout = tlCenter
      end
      object Label25: TLabel
        Left = 204
        Top = 175
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cote :'
        Layout = tlCenter
      end
      object VDTButton14: TVDTButton
        Left = 304
        Top = 172
        Width = 72
        Height = 21
        Caption = 'Convertisseur'
        Flat = False
        OnClick = VDTButton14Click
      end
      object Label26: TLabel
        Left = 116
        Top = 149
        Width = 94
        Height = 13
        Alignment = taRightJustify
        Caption = 'Num'#233'ro personnel :'
        Layout = tlCenter
      end
      object Label27: TLabel
        Left = 402
        Top = 87
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sens de lecture :'
        Layout = tlCenter
      end
      object cbxSensLecture: TLightComboCheck
        Left = 496
        Top = 87
        Width = 184
        Height = 13
        Checked = False
        PropertiesStored = False
        CheckVisible = False
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object Label8: TLabel
        Left = 1
        Top = 30
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Collection :'
      end
      object Label5: TLabel
        Left = 13
        Top = 3
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Editeur :'
      end
      object Label15: TLabel
        Left = 405
        Top = 123
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Notes :'
      end
      object edPrix: TEditLabeled
        Left = 237
        Top = 93
        Width = 64
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 7
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
      object edAnneeEdition: TEditLabeled
        Left = 60
        Top = 66
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 2
        OnChange = edAnneeEditionChange
        LinkControls = <
          item
            Control = Label10
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edISBN: TEditLabeled
        Left = 60
        Top = 120
        Width = 241
        Height = 20
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        CharCase = ecUpperCase
        Ctl3D = True
        MaxLength = 13
        ParentCtl3D = False
        TabOrder = 8
        OnChange = edISBNChange
        OnExit = edISBNExit
        LinkControls = <
          item
            Control = Label11
          end
          item
            Control = VDTButton6
          end
          item
            Control = VDTButton13
          end>
        TypeDonnee = tdISBN
        CurrencyChar = #0
      end
      object cbVO: TCheckBoxLabeled
        Left = 510
        Top = 3
        Width = 34
        Height = 16
        Cursor = crHandPoint
        Caption = 'VO'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 9
        LinkControls = <
          item
            Control = cbVO
          end>
      end
      object cbCouleur: TCheckBoxLabeled
        Left = 550
        Top = 3
        Width = 54
        Height = 16
        Cursor = crHandPoint
        Caption = 'Couleur'
        Checked = True
        Ctl3D = True
        ParentCtl3D = False
        State = cbChecked
        TabOrder = 10
        LinkControls = <
          item
            Control = cbCouleur
          end>
      end
      object cbStock: TCheckBoxLabeled
        Left = 60
        Top = 97
        Width = 61
        Height = 13
        Caption = 'En stock'
        Checked = True
        Ctl3D = True
        ParentCtl3D = False
        State = cbChecked
        TabOrder = 5
        LinkControls = <
          item
            Control = cbStock
          end>
      end
      object cbDedicace: TCheckBoxLabeled
        Left = 610
        Top = 3
        Width = 64
        Height = 16
        Cursor = crHandPoint
        Caption = 'D'#233'dicac'#233
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 11
        LinkControls = <
          item
            Control = cbDedicace
          end>
      end
      object dtpAchat: TDateTimePickerLabeled
        Left = 275
        Top = 66
        Width = 101
        Height = 21
        Date = 38158.758085983800000000
        Time = 38158.758085983800000000
        ShowCheckbox = True
        Checked = False
        TabOrder = 4
        LinkControls = <
          item
            Control = Label18
          end>
      end
      object cbGratuit: TCheckBoxLabeled
        Left = 140
        Top = 96
        Width = 53
        Height = 16
        Cursor = crHandPoint
        Caption = 'Gratuit'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 6
        OnClick = cbGratuitClick
        LinkControls = <
          item
            Control = cbGratuit
          end>
      end
      object cbOffert: TCheckBoxLabeled
        Left = 140
        Top = 69
        Width = 53
        Height = 16
        Cursor = crHandPoint
        Caption = 'Offert'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 3
        OnClick = cbOffertClick
        LinkControls = <
          item
            Control = cbOffert
          end>
      end
      object edNombreDePages: TEditLabeled
        Left = 60
        Top = 146
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 12
        LinkControls = <
          item
            Control = Label21
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edAnneeCote: TEditLabeled
        Left = 152
        Top = 172
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 14
        LinkControls = <
          item
            Control = Label24
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edPrixCote: TEditLabeled
        Left = 240
        Top = 172
        Width = 64
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 15
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
      object edNumPerso: TEditLabeled
        Left = 216
        Top = 146
        Width = 160
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 13
        LinkControls = <
          item
            Control = Label2
          end>
        CurrencyChar = #0
      end
      inline vtEditCollections: TframVTEdit
        Left = 60
        Top = 27
        Width = 316
        Height = 21
        TabOrder = 1
        ExplicitLeft = 60
        ExplicitTop = 27
        ExplicitWidth = 316
        inherited btReset: TVDTButton
          Left = 253
          ExplicitLeft = 226
        end
        inherited btNew: TVDTButton
          Left = 295
          ExplicitLeft = 268
        end
        inherited btEdit: TVDTButton
          Left = 274
          ExplicitLeft = 247
        end
        inherited VTEdit: TJvComboEdit
          Width = 253
          OnChange = vtEditCollectionsVTEditChange
          ExplicitWidth = 253
        end
      end
      inline vtEditEditeurs: TframVTEdit
        Left = 60
        Top = 0
        Width = 316
        Height = 21
        TabOrder = 0
        ExplicitLeft = 60
        ExplicitWidth = 316
        inherited btReset: TVDTButton
          Left = 253
          ExplicitLeft = 226
        end
        inherited btNew: TVDTButton
          Left = 295
          ExplicitLeft = 268
        end
        inherited btEdit: TVDTButton
          Left = 274
          ExplicitLeft = 247
        end
        inherited VTEdit: TJvComboEdit
          Width = 253
          OnChange = vtEditEditeursVTEditChange
          ExplicitWidth = 253
        end
      end
      object edNotes: TMemoLabeled
        Left = 442
        Top = 123
        Width = 238
        Height = 70
        BevelKind = bkTile
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 16
        LinkControls = <
          item
            Control = Label15
          end>
      end
    end
    object edAnneeParution: TEditLabeled
      Left = 175
      Top = 57
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 5
      LinkControls = <
        item
          Control = Label3
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edTitre: TEditLabeled
      Left = 56
      Top = 4
      Width = 674
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      OnChange = edTitreChange
      LinkControls = <
        item
          Control = Label2
        end>
      CurrencyChar = #0
    end
    object histoire: TMemoLabeled
      Left = 56
      Top = 130
      Width = 273
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 10
      LinkControls = <
        item
          Control = Label6
        end>
    end
    object remarques: TMemoLabeled
      Left = 376
      Top = 130
      Width = 354
      Height = 81
      Anchors = [akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 11
      LinkControls = <
        item
          Control = Label7
        end>
    end
    object lvScenaristes: TVDTListViewLabeled
      Left = 459
      Top = 227
      Width = 271
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stNone
      TabOrder = 13
      OnData = lvScenaristesData
      OnKeyDown = lvDessinateursKeyDown
      LinkControls = <
        item
          Control = btScenariste
        end>
    end
    object lvDessinateurs: TVDTListViewLabeled
      Left = 459
      Top = 271
      Width = 271
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stBoth
      TabOrder = 14
      OnData = lvDessinateursData
      OnKeyDown = lvDessinateursKeyDown
      LinkControls = <
        item
          Control = btDessinateur
        end>
    end
    object vstImages: TVirtualStringTree
      Left = 56
      Top = 592
      Width = 545
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
      OnMouseUp = vstImagesMouseUp
      OnNewText = vstImagesNewText
      OnStructureChange = vstImagesStructureChange
      Columns = <
        item
          Position = 1
          Width = 445
        end
        item
          Position = 0
          Width = 100
        end>
    end
    object lvColoristes: TVDTListViewLabeled
      Left = 459
      Top = 315
      Width = 271
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stBoth
      TabOrder = 15
      OnData = lvColoristesData
      OnKeyDown = lvDessinateursKeyDown
      LinkControls = <
        item
          Control = btColoriste
        end>
    end
    object cbIntegrale: TCheckBoxLabeled
      Left = 316
      Top = 59
      Width = 65
      Height = 16
      Cursor = crHandPoint
      Caption = 'Int'#233'grale'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      OnClick = cbIntegraleClick
      LinkControls = <
        item
          Control = cbIntegrale
        end>
    end
    object edTome: TEditLabeled
      Left = 56
      Top = 57
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 3
      TabOrder = 3
      LinkControls = <
        item
          Control = Label1
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object vtEditions: TListBoxLabeled
      Left = 56
      Top = 268
      Width = 281
      Height = 69
      BevelKind = bkTile
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 11
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      OnClick = vtEditionsClick
      OnKeyDown = vtEditionsKeyDown
      LinkControls = <
        item
          Control = VDTButton3
        end
        item
          Control = Label4
        end>
    end
    object cbHorsSerie: TCheckBoxLabeled
      Left = 234
      Top = 59
      Width = 73
      Height = 16
      Cursor = crHandPoint
      Caption = 'Hors s'#233'rie'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      LinkControls = <
        item
          Control = cbHorsSerie
        end>
    end
    object edTomeDebut: TEditLabeled
      Left = 424
      Top = 57
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      Enabled = False
      MaxLength = 3
      TabOrder = 8
      LinkControls = <
        item
          Control = Label16
        end
        item
          Control = Label17
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edTomeFin: TEditLabeled
      Left = 472
      Top = 57
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      Enabled = False
      MaxLength = 3
      TabOrder = 9
      LinkControls = <
        item
          Control = Label16
        end
        item
          Control = Label17
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edMoisParution: TEditLabeled
      Left = 152
      Top = 57
      Width = 22
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 2
      TabOrder = 4
      LinkControls = <
        item
          Control = Label3
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    inline vtEditSerie: TframVTEdit
      Left = 56
      Top = 30
      Width = 674
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 56
      ExplicitTop = 30
      ExplicitWidth = 674
      inherited btReset: TVDTButton
        Left = 611
        ExplicitLeft = 619
      end
      inherited btNew: TVDTButton
        Left = 653
        ExplicitLeft = 661
      end
      inherited btEdit: TVDTButton
        Left = 632
        ExplicitLeft = 640
      end
      inherited VTEdit: TJvComboEdit
        Width = 611
        OnChange = JvComboEdit1Change
        ExplicitWidth = 611
      end
    end
    inline vtEditPersonnes: TframVTEdit
      Left = 56
      Top = 227
      Width = 281
      Height = 21
      TabOrder = 12
      ExplicitLeft = 56
      ExplicitTop = 227
      ExplicitWidth = 281
      inherited btReset: TVDTButton
        Left = 218
        ExplicitLeft = 218
      end
      inherited btNew: TVDTButton
        Left = 260
        ExplicitLeft = 260
      end
      inherited btEdit: TVDTButton
        Left = 239
        ExplicitLeft = 239
      end
      inherited VTEdit: TJvComboEdit
        Width = 218
        OnChange = framVTEdit1VTEditChange
        ExplicitWidth = 218
      end
    end
    inline vtEditUnivers: TframVTEdit
      Left = 56
      Top = 83
      Width = 281
      Height = 21
      TabOrder = 2
      ExplicitLeft = 56
      ExplicitTop = 83
      ExplicitWidth = 281
      inherited btReset: TVDTButton
        Left = 218
        ExplicitLeft = 284
      end
      inherited btNew: TVDTButton
        Left = 260
        ExplicitLeft = 326
      end
      inherited btEdit: TVDTButton
        Left = 239
        ExplicitLeft = 305
      end
      inherited VTEdit: TJvComboEdit
        Width = 218
        OnChange = vtEditUniversVTEditChange
        ExplicitWidth = 218
      end
    end
    object lvUnivers: TVDTListViewLabeled
      Left = 460
      Top = 83
      Width = 271
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stNone
      TabOrder = 19
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
    Width = 734
    Height = 29
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 734
    DesignSize = (
      734
      29)
    inherited btnOK: TButton
      Left = 563
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
      ExplicitLeft = 563
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 651
      ExplicitLeft = 651
    end
  end
  object btnScript: TButton
    Left = 185
    Top = 6
    Width = 69
    Height = 21
    Cursor = crHandPoint
    Hint = 'Valider les modifcations'
    Caption = 'Script'
    Default = True
    DoubleBuffered = True
    ImageIndex = 12
    Images = frmFond.ShareImageList
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = btnScriptClick
  end
  object Button1: TButton
    Left = 87
    Top = 6
    Width = 75
    Height = 21
    Caption = 'Button1'
    TabOrder = 3
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
  object ImageList1: TImageList
    Left = 344
    Bitmap = {
      494C010101000500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DE009400DE009400DE009400DE009400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DE009400DE009400DE009400DE009400DE009400DE0094000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DE009400FF4ABD00DE009400DE009400DE009400DE009400DE009400DE00
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DE009400FF4ABD00FFB5E700DE009400DE009400DE009400DE009400DE00
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DE009400FF4ABD00FFB5E700FFFFFF00DE009400DE009400DE009400DE00
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DE009400FF4ABD00FFB5E700FFB5E700FFB5E700DE009400DE009400DE00
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DE009400FF4ABD00FF4ABD00FF4ABD00FF4ABD00DE0094000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DE009400DE009400DE009400DE009400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFFF000000000000FFFF000000000000FC3F000000000000F81F000000000000
      F00F000000000000F00F000000000000F00F000000000000F00F000000000000
      F81F000000000000FC3F000000000000FFFF000000000000FFFF000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object pmChoixCategorie: TPopupMenu
    OnPopup = pmChoixCategoriePopup
    Left = 416
  end
end
