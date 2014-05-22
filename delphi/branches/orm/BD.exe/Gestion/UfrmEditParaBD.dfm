object frmEditParaBD: TfrmEditParaBD
  Left = 188
  Top = 180
  ActiveControl = edTitre
  Caption = 'frmEditParaBD'
  ClientHeight = 899
  ClientWidth = 734
  Color = clBtnFace
  Constraints.MinWidth = 750
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
    Width = 734
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
    Width = 734
    Height = 866
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      734
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
      Top = 134
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description :'
      FocusControl = edDescription
    end
    object btCreateur: TVDTButton
      Tag = 1
      Left = 412
      Top = 261
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
      Width = 734
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
      Width = 200
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      ExplicitWidth = 290
    end
    object Label24: TLabel
      Left = 150
      Top = 421
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
      Layout = tlCenter
    end
    object Label25: TLabel
      Left = 245
      Top = 421
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote :'
      Layout = tlCenter
    end
    object VDTButton14: TVDTButton
      Left = 358
      Top = 418
      Width = 21
      Height = 21
      OnClick = VDTButton14Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C180000033C4944415478DA
        8D934D6C54551886DF73CFDC9FB9F33FB52D9DB6606B33990E6905A58A0B1D35
        05230901A22C80545888606041485CB8538C71A13B88BA50C0850B2A42521522
        0926562D3F032833B1A528D24945683BED0CDC7B67E6FE9DE3F127D1200BDFE4
        AC4ECEF39DEF7BDF8FD8977BC13DD6641B4E8EB9AC8FAA8176DF6311EE7836A1
        648E503AA184E43CD5A4226704778BF0D2C39B8DDF660F38152B416371D4980A
        AFC1A0C97F1C0F9E6981C81C91B6451F70976C679E235EFD03223307FB0AC927
        97F505DA0240BD8EB9520576C381A42808108A96740BB8A962E1C204B4D8D541
        259138CDFD7F010E66B07369AEF3ADCC0B9978389D8014D4E0B936ECAA03DF24
        F0170C4C9F2C81E833C80E65416C6FD0B7EBA721497F010E0F85A59EB8790E65
        AC48AD8D20B4240C1A0C8033058D590F46C984A436A335DB8580B100E64EBE28
        07ED0F19FB1B609E7A70BDDABDF878E1E31FE15B55C4B21C7AAB0CAD390C25A2
        825205A46C61FEE21D5CF9AEFCED99CBEC713B06E83AC07C0138F294BEE1B10D
        DDC7F47412AE6C0A661D4A9481535B54B3C0674C142F85E1F4BE091E4E17BF3E
        F4EE9EFCD1E1AF3401106C9091EDEAD6EE54D361120A22B99C434D12304906F7
        397CC341F9873BF8F2C6B358B1ED3D6416CBB859B98DE1BD1B1F1AFF7CF4FB78
        8700544797FD3275E6465730A143BB4F58D7EC83EA32A400051A2EAE8E1AF866
        FE793CBDF50DA4DB43301C1FF9B363D73E7B754B8F356B82F81F0DF05BC9186A
        B7A7A0461CF103D1B72E41A2C26F9B63E2C43CC6AD55E8DFB61F6EF53A526D8B
        E069717C71E0B58D854F478E92D7FBB163D3FAD4FBC9C11690A80B22B9608CC1
        356BB06F7AF8356F62DABB1F2B5F19835599816554D19AEA44213F76B2F2F3E4
        1A9108228DAC53FCB56BA2402F852D8623692A08747806C0EB21942E94A10EEC
        43D31343183F7F16E1908E8A519BAB33D6F167A49604B16E68395E7EE451B53F
        DB1F690B36ABC242914CDFC7ADEB356FF8D0C2F4A4D164EEDC7FA22F9B7900F1
        6818856211CFAC5E1DBD7B3B3A85F5DD3420CA1348DC179DD4D110767371D733
        90E97A69EFBEB757E672391CFFE4C8B15DBB773FF7DFF5BAB7344AD0C938DA3B
        A2CAAA584BAAF6D3B5A977C48C6DC239FF9F8C7BEB776405579A8AA8E2790000
        000049454E44AE426082}
    end
    object Label10: TLabel
      Left = 24
      Top = 60
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
      Layout = tlCenter
    end
    object Label18: TLabel
      Left = 224
      Top = 356
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le :'
      Layout = tlCenter
    end
    object Label9: TLabel
      Left = 250
      Top = 383
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix :'
      Layout = tlCenter
    end
    object SpeedButton3: TVDTButton
      Left = 358
      Top = 379
      Width = 21
      Height = 21
      OnClick = SpeedButton3Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C180000033C4944415478DA
        8D934D6C54551886DF73CFDC9FB9F33FB52D9DB6606B33990E6905A58A0B1D35
        05230901A22C80545888606041485CB8538C71A13B88BA50C0850B2A42521522
        0926562D3F032833B1A528D24945683BED0CDC7B67E6FE9DE3F127D1200BDFE4
        AC4ECEF39DEF7BDF8FD8977BC13DD6641B4E8EB9AC8FAA8176DF6311EE7836A1
        648E503AA184E43CD5A4226704778BF0D2C39B8DDF660F38152B416371D4980A
        AFC1A0C97F1C0F9E6981C81C91B6451F70976C679E235EFD03223307FB0AC927
        97F505DA0240BD8EB9520576C381A42808108A96740BB8A962E1C204B4D8D541
        259138CDFD7F010E66B07369AEF3ADCC0B9978389D8014D4E0B936ECAA03DF24
        F0170C4C9F2C81E833C80E65416C6FD0B7EBA721497F010E0F85A59EB8790E65
        AC48AD8D20B4240C1A0C8033058D590F46C984A436A335DB8580B100E64EBE28
        07ED0F19FB1B609E7A70BDDABDF878E1E31FE15B55C4B21C7AAB0CAD390C25A2
        825205A46C61FEE21D5CF9AEFCED99CBEC713B06E83AC07C0138F294BEE1B10D
        DDC7F47412AE6C0A661D4A9481535B54B3C0674C142F85E1F4BE091E4E17BF3E
        F4EE9EFCD1E1AF3401106C9091EDEAD6EE54D361120A22B99C434D12304906F7
        397CC341F9873BF8F2C6B358B1ED3D6416CBB859B98DE1BD1B1F1AFF7CF4FB78
        8700544797FD3275E6465730A143BB4F58D7EC83EA32A400051A2EAE8E1AF866
        FE793CBDF50DA4DB43301C1FF9B363D73E7B754B8F356B82F81F0DF05BC9186A
        B7A7A0461CF103D1B72E41A2C26F9B63E2C43CC6AD55E8DFB61F6EF53A526D8B
        E069717C71E0B58D854F478E92D7FBB163D3FAD4FBC9C11690A80B22B9608CC1
        356BB06F7AF8356F62DABB1F2B5F19835599816554D19AEA44213F76B2F2F3E4
        1A9108228DAC53FCB56BA2402F852D8623692A08747806C0EB21942E94A10EEC
        43D31343183F7F16E1908E8A519BAB33D6F167A49604B16E68395E7EE451B53F
        DB1F690B36ABC242914CDFC7ADEB356FF8D0C2F4A4D164EEDC7FA22F9B7900F1
        6818856211CFAC5E1DBD7B3B3A85F5DD3420CA1348DC179DD4D110767371D733
        90E97A69EFBEB757E672391CFFE4C8B15DBB773FF7DFF5BAB7344AD0C938DA3B
        A2CAAA584BAAF6D3B5A977C48C6DC239FF9F8C7BEB776405579A8AA8E2790000
        000049454E44AE426082}
    end
    object Label12: TLabel
      Left = 117
      Top = 60
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type :'
      Layout = tlCenter
    end
    object cbxCategorie: TLightComboCheck
      Left = 154
      Top = 60
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
      Width = 200
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      ExplicitWidth = 290
    end
    object Label11: TLabel
      Left = 19
      Top = 87
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers :'
    end
    object btUnivers: TVDTButton
      Tag = 1
      Left = 412
      Top = 84
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
      Left = 599
      Top = 483
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
    end
    object VDTButton4: TVDTButton
      Left = 599
      Top = 462
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
    end
    object Bevel5: TBevel
      Left = 261
      Top = 450
      Width = 212
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      ExplicitWidth = 302
    end
    object Label1: TLabel
      Left = 371
      Top = 134
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Notes :'
      FocusControl = edNotes
    end
    object imgVisu: TImage
      Left = 627
      Top = 462
      Width = 104
      Height = 131
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Center = True
      OnClick = imgVisuClick
    end
    object edTitre: TEditLabeled
      Left = 68
      Top = 4
      Width = 663
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
      Top = 131
      Width = 289
      Height = 111
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 7
      LinkControls = <
        item
          Control = Label6
        end>
    end
    object lvAuteurs: TVDTListViewLabeled
      Left = 475
      Top = 261
      Width = 256
      Height = 72
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stNone
      TabOrder = 10
      OnData = lvAuteursData
      OnKeyDown = lvAuteursKeyDown
      LinkControls = <
        item
          Control = btCreateur
        end>
    end
    object edAnneeCote: TEditLabeled
      Left = 193
      Top = 418
      Width = 46
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 16
      LinkControls = <
        item
          Control = Label24
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edPrixCote: TEditLabeled
      Left = 278
      Top = 418
      Width = 79
      Height = 21
      AutoSelect = False
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 17
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
      Top = 57
      Width = 46
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 2
      LinkControls = <
        item
          Control = Label10
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object cbStock: TCheckBoxLabeled
      Left = 68
      Top = 383
      Width = 61
      Height = 13
      Caption = 'En stock'
      Checked = True
      Ctl3D = True
      ParentCtl3D = False
      State = cbChecked
      TabOrder = 13
      LinkControls = <
        item
          Control = cbStock
        end>
    end
    object cbGratuit: TCheckBoxLabeled
      Left = 150
      Top = 382
      Width = 53
      Height = 16
      Cursor = crHandPoint
      Caption = 'Gratuit'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 14
      OnClick = cbGratuitClick
      LinkControls = <
        item
          Control = cbGratuit
        end>
    end
    object cbOffert: TCheckBoxLabeled
      Left = 150
      Top = 355
      Width = 53
      Height = 16
      Cursor = crHandPoint
      Caption = 'Offert'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 11
      OnClick = cbOffertClick
      LinkControls = <
        item
          Control = cbOffert
        end>
    end
    object dtpAchat: TDateTimePickerLabeled
      Left = 278
      Top = 352
      Width = 101
      Height = 21
      Date = 38158.758085983800000000
      Time = 38158.758085983800000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 12
      LinkControls = <
        item
          Control = Label18
        end>
    end
    object edPrix: TEditLabeled
      Left = 278
      Top = 379
      Width = 79
      Height = 21
      AutoSelect = False
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 15
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
      Top = 60
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
      TabOrder = 3
      LinkControls = <
        item
          Control = cbDedicace
        end>
    end
    object cbNumerote: TCheckBoxLabeled
      Left = 405
      Top = 60
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'Num'#233'rot'#233
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
          Control = cbNumerote
        end>
    end
    inline vtEditSeries: TframVTEdit
      Left = 68
      Top = 30
      Width = 663
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 68
      ExplicitTop = 30
      ExplicitWidth = 663
      inherited btReset: TVDTButton
        Left = 600
        ExplicitLeft = 373
      end
      inherited btNew: TVDTButton
        Left = 642
        ExplicitLeft = 415
      end
      inherited btEdit: TVDTButton
        Left = 621
        ExplicitLeft = 394
      end
      inherited VTEdit: TJvComboEdit
        Width = 600
        OnChange = vtEditSeriesVTEditChange
        ExplicitWidth = 600
      end
    end
    inline vtEditPersonnes: TframVTEdit
      Left = 68
      Top = 261
      Width = 311
      Height = 21
      TabOrder = 9
      ExplicitLeft = 68
      ExplicitTop = 261
      ExplicitWidth = 311
      inherited btReset: TVDTButton
        Left = 254
        ExplicitLeft = 254
      end
      inherited btNew: TVDTButton
        Left = 290
        ExplicitLeft = 183
      end
      inherited btEdit: TVDTButton
        Left = 269
        ExplicitLeft = 162
      end
      inherited VTEdit: TJvComboEdit
        Width = 248
        OnChange = vtEditPersonnesVTEditChange
        ExplicitWidth = 248
      end
    end
    inline vtEditUnivers: TframVTEdit
      Left = 68
      Top = 84
      Width = 311
      Height = 21
      TabOrder = 5
      ExplicitLeft = 68
      ExplicitTop = 84
      ExplicitWidth = 311
      inherited btReset: TVDTButton
        Left = 248
        ExplicitLeft = 284
      end
      inherited btNew: TVDTButton
        Left = 290
        ExplicitLeft = 326
      end
      inherited btEdit: TVDTButton
        Left = 269
        ExplicitLeft = 305
      end
      inherited VTEdit: TJvComboEdit
        Width = 248
        OnChange = vtEditUniversVTEditChange
        ExplicitWidth = 248
      end
    end
    object lvUnivers: TVDTListViewLabeled
      Left = 475
      Top = 84
      Width = 256
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stNone
      TabOrder = 6
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
      Width = 533
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
          Width = 433
        end
        item
          Position = 0
          Width = 100
        end>
    end
    object edNotes: TMemoLabeled
      Left = 412
      Top = 131
      Width = 319
      Height = 111
      Anchors = [akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 8
      LinkControls = <
        item
          Control = Label1
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
    inherited btnOK: TButton
      Left = 555
      Width = 87
      Caption = 'Enregistrer'
      OnClick = btnOKClick
      ExplicitLeft = 555
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 651
      ExplicitLeft = 651
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
  object pmChoixCategorie: TPopupMenu
    OnPopup = pmChoixCategoriePopup
    Left = 416
  end
end
