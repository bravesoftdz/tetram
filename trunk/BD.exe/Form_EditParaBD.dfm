object FrmEditParaBD: TFrmEditParaBD
  Left = 492
  Top = 144
  Width = 870
  Height = 640
  Caption = 'FrmEditParaBD'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    DesignSize = (
      862
      23)
    object btnOK: TBitBtn
      Left = 699
      Top = 2
      Width = 74
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Caption = 'Enregistrer'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnAnnuler: TBitBtn
      Left = 780
      Top = 2
      Width = 72
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 23
    Width = 862
    Height = 585
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    DesignSize = (
      845
      585)
    object imgVisu: TImage
      Left = 735
      Top = 592
      Width = 105
      Height = 129
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Center = True
    end
    object Label3: TLabel
      Left = 107
      Top = 31
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = ' Parution:'
      FocusControl = edAnneeParution
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 27
      Top = 7
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = ' Titre:'
      FocusControl = edTitre
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 16
      Top = 50
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire:'
      FocusControl = histoire
    end
    object Label7: TLabel
      Left = 453
      Top = 50
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Notes:'
      FocusControl = remarques
    end
    object btScenariste: TVDTButton
      Tag = 1
      Left = 236
      Top = 146
      Width = 69
      Height = 41
      Cursor = crHandPoint
      Caption = 'Sc'#233'nariste'
      Enabled = False
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033334333333360603336
        5433333333333336654333333336333616543333333633362065433333363336
        2106543333363336211063333336333621163333333633362163333333363336
        26333333333633366333333333363336333333333336}
      Layout = blGlyphBottom
    end
    object btDessinateur: TVDTButton
      Tag = 2
      Left = 236
      Top = 190
      Width = 69
      Height = 41
      Cursor = crHandPoint
      Caption = 'Dessinateur'
      Enabled = False
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033334333333360603336
        5433333333333336654333333336333616543333333633362065433333363336
        2106543333363336211063333336333621163333333633362163333333363336
        26333333333633366333333333363336333333333336}
      Layout = blGlyphBottom
    end
    object VDTButton7: TVDTButton
      Left = 191
      Top = 146
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Caption = '...'
      Flat = True
    end
    object VDTButton8: TVDTButton
      Left = 212
      Top = 146
      Width = 20
      Height = 20
      Cursor = crHandPoint
      Caption = 'N'
      Flat = True
    end
    object Label19: TLabel
      Left = 15
      Top = 150
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs:'
      FocusControl = remarques
    end
    object ChoixImage: TVDTButton
      Tag = 1
      Left = 4
      Top = 591
      Width = 52
      Height = 130
      Cursor = crHandPoint
      Caption = 'Images'
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033334333333360603336
        5433333333333336654333333336333616543333333633362065433333363336
        2106543333363336211063333336333621163333333633362163333333363336
        26333333333633366333333333363336333333333336}
      Layout = blGlyphBottom
    end
    object VDTButton4: TVDTButton
      Left = 712
      Top = 591
      Width = 22
      Height = 21
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033333333333360603444
        4444444333334555555555543444666666666663455536210000163366663362
        1111633336213336211633333362333362633333333633333633333333333333
        33333333333333333333333333333333333333333333}
    end
    object VDTButton5: TVDTButton
      Left = 712
      Top = 612
      Width = 22
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C0000000000333333333333C0603333
        3333333333333333334333333333333336543333333333336065433333333336
        1106543333333361111065433336362222221654336166666666666336223333
        33333333666633333333333333333333333333333333}
    end
    object Bevel1: TBevel
      Left = 0
      Top = 721
      Width = 845
      Height = 4
      Align = alBottom
      Shape = bsSpacer
    end
    object Label20: TLabel
      Left = 514
      Top = 150
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie:'
      FocusControl = remarques
    end
    object VDTButton12: TVDTButton
      Left = 800
      Top = 146
      Width = 20
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '...'
      Flat = True
    end
    object btColoriste: TVDTButton
      Tag = 3
      Left = 236
      Top = 234
      Width = 69
      Height = 41
      Cursor = crHandPoint
      Caption = 'Coloriste'
      Enabled = False
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033334333333360603336
        5433333333333336654333333336333616543333333633362065433333363336
        2106543333363336211063333336333621163333333633362163333333363336
        26333333333633366333333333363336333333333336}
      Layout = blGlyphBottom
    end
    object Label1: TLabel
      Left = 21
      Top = 31
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = ' Tome:'
      FocusControl = edTome
      Layout = tlCenter
    end
    object VDTButton11: TVDTButton
      Left = 820
      Top = 146
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'N'
      Flat = True
    end
    object Label5: TLabel
      Left = 408
      Top = 293
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur:'
    end
    object VDTButton1: TVDTButton
      Left = 799
      Top = 290
      Width = 20
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '...'
      Flat = True
    end
    object Label8: TLabel
      Left = 395
      Top = 384
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Collection:'
    end
    object VDTButton2: TVDTButton
      Left = 799
      Top = 380
      Width = 20
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '...'
      Flat = True
    end
    object Label4: TLabel
      Left = 14
      Top = 293
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editions:'
      FocusControl = remarques
    end
    object VDTButton3: TVDTButton
      Left = 260
      Top = 336
      Width = 112
      Height = 20
      Cursor = crHandPoint
      Caption = 'Nouvelle'
      Flat = True
    end
    object Bevel3: TBevel
      Left = 216
      Top = 137
      Width = 413
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel4: TBevel
      Left = 216
      Top = 280
      Width = 413
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel5: TBevel
      Left = 189
      Top = 582
      Width = 413
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object VDTButton9: TVDTButton
      Left = 820
      Top = 290
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'N'
      Flat = True
    end
    object VDTButton10: TVDTButton
      Left = 820
      Top = 380
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'N'
      Enabled = False
      Flat = True
    end
    object Label15: TLabel
      Left = 413
      Top = 472
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes:'
    end
    object Label16: TLabel
      Left = 387
      Top = 30
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tomes:'
      FocusControl = edTomeDebut
      Font.Charset = ANSI_CHARSET
      Font.Color = clInactiveCaptionText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Label17: TLabel
      Left = 464
      Top = 30
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = #224
      FocusControl = edTomeFin
      Font.Charset = ANSI_CHARSET
      Font.Color = clInactiveCaptionText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object PanelEdition: TPanel
      Left = 18
      Top = 368
      Width = 355
      Height = 205
      AutoSize = True
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 23
      object SpeedButton3: TVDTButton
        Left = 282
        Top = 24
        Width = 72
        Height = 21
        Cursor = crHandPoint
        Caption = 'Convertisseur'
        Flat = True
      end
      object Label9: TLabel
        Left = 192
        Top = 28
        Width = 20
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prix:'
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 1
        Top = 4
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Edition:'
        Layout = tlCenter
      end
      object Label11: TLabel
        Left = 8
        Top = 52
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'ISBN:'
        Layout = tlCenter
      end
      object VDTButton6: TVDTButton
        Left = 282
        Top = 49
        Width = 48
        Height = 20
        Cursor = crHandPoint
        Caption = 'V'#233'rifier'
        Enabled = False
        Flat = True
      end
      object Label12: TLabel
        Left = 166
        Top = 79
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etat:'
        Layout = tlCenter
      end
      object Label13: TLabel
        Left = 152
        Top = 113
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'Reliure:'
        Layout = tlCenter
      end
      object cbxEtat: TLightComboCheck
        Left = 188
        Top = 79
        Width = 166
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
        Left = 188
        Top = 113
        Width = 166
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
        Left = 153
        Top = 96
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Edition:'
        Layout = tlCenter
      end
      object cbxEdition: TLightComboCheck
        Left = 188
        Top = 96
        Width = 166
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
        Left = 204
        Top = 4
        Width = 48
        Height = 13
        Alignment = taRightJustify
        Caption = 'Achet'#233' le:'
        Layout = tlCenter
      end
      object Label21: TLabel
        Left = 3
        Top = 156
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Pages:'
        Layout = tlCenter
      end
      object Label22: TLabel
        Left = 134
        Top = 130
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Orientation:'
        Layout = tlCenter
      end
      object cbxOrientation: TLightComboCheck
        Left = 188
        Top = 130
        Width = 166
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
        Left = 153
        Top = 148
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Format:'
        Layout = tlCenter
      end
      object cbxFormat: TLightComboCheck
        Left = 188
        Top = 148
        Width = 166
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
        Left = 333
        Top = 49
        Width = 21
        Height = 20
        Cursor = crHandPoint
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          0800000000000001000000000000000000000001000000010000000000000101
          0100020202000303030004040400050505000606060007070700080808000909
          09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
          1100121212001313130014141400151515001616160017171700181818001919
          19001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F1F00202020002121
          2100222222002323230024242400252525002626260027272700282828002929
          29002A2A2A002B2B2B002C2C2C002D2D2D002E2E2E002F2F2F00303030003131
          3100323232003333330034343400353535003636360037373700383838003939
          39003A3A3A003B3B3B003C3C3C003D3D3D003E3E3E003F3F3F00404040004141
          4100424242004343430044444400454545004646460047474700484848004949
          49004A4A4A004B4B4B004C4C4C004D4D4D004E4E4E004F4F4F00505050005151
          5100525252005353530054545400555555005656560057575700585858005959
          59005A5A5A005B5B5B005C5C5C005D5D5D005E5E5E005F5F5F00606060006161
          6100626262006363630064646400656565006666660067676700686868006969
          69006A6A6A006B6B6B006C6C6C006D6D6D006E6E6E006F6F6F00707070007171
          7100727272007373730074747400757575007676760077777700787878007979
          79007A7A7A007B7B7B007C7C7C007D7D7D007E7E7E007F7F7F00808080008181
          8100828282008383830084848400858585008686860087878700888888008989
          89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
          9100929292009393930094949400959595009696960097979700989898009999
          99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
          A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
          A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAFAF00B0B0B000B1B1
          B100B2B2B200B3B3B300B4B4B400B5B5B500B6B6B600B7B7B700B8B8B800B9B9
          B900BABABA00BBBBBB00BCBCBC00BDBDBD00BEBEBE00BFBFBF00C0C0C000C1C1
          C100C2C2C200C3C3C300C4C4C400C5C5C500C6C6C600C7C7C700C8C8C800C9C9
          C900CACACA00CBCBCB00CCCCCC00CDCDCD00CECECE00CFCFCF00D0D0D000D1D1
          D100D2D2D200D3D3D300D4D4D400D5D5D500D6D6D600D7D7D700D8D8D800D9D9
          D900DADADA00DBDBDB00DCDCDC00DDDDDD00DEDEDE00DFDFDF00E0E0E000E1E1
          E100E2E2E200E3E3E300E4E4E400E5E5E500E6E6E600E7E7E700E8E8E800E9E9
          E900EAEAEA00EBEBEB00ECECEC00EDEDED00EEEEEE00EFEFEF00F0F0F000F1F1
          F100F2F2F200F3F3F300F4F4F400F5F5F500F6F6F600F7F7F700F8F8F800F9F9
          F900FAFAFA00FBFBFB00FCFCFC00FDFDFD00FEFEFE00FFFFFF00FFFFF0FFFFF1
          FFFFF8F5FFF6FBFFFEFBED000BF700FF000003FFF508FFEB00FFFF00FFF014EF
          00FF00EDFF00EAFF04F1F0FF00FF00FE0EEC11EAFFFF00FF04FFFF0A0AFF00FF
          001800FB09000EFF00F4FDF3FFFEFAFFFFF6FCFFF7FFECEFFFFF0C00FF09F901
          00FE00FF00F60D0CFE000006FF00FF0302FE05FC00FF0000FF020208F700FF02
          00FF00FF00FF0009FD040008FF00FF0011FB08FF00F41600FF000201F200FF14
          00FF00FF04FF0000FF000600FF01FC0200FF00F80EFF000BFF030109FB14ED00
          19EC01FF00FC1F00FE020000FB00FF0700FF00F905FF0004F9001105FB0BF402
          0AFF05FD08FA0305FF0AF4FFF5FFFFFAF9FFF7FFFFF8FFFFF3FF}
      end
      object Label24: TLabel
        Left = 98
        Top = 188
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ann'#233'e:'
        Layout = tlCenter
      end
      object Label25: TLabel
        Left = 187
        Top = 188
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cote:'
        Layout = tlCenter
      end
      object VDTButton14: TVDTButton
        Left = 282
        Top = 184
        Width = 72
        Height = 21
        Cursor = crHandPoint
        Caption = 'Convertisseur'
        Flat = True
      end
      object edPrix: TEditLabeled
        Left = 215
        Top = 24
        Width = 64
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 5
        LinkLabel.LinkLabel.Strings = (
          'Label9'
          'SpeedButton3')
        TypeDonnee = tdCurrency
        CurrencyChar = #0
      end
      object edAnneeEdition: TEditLabeled
        Left = 38
        Top = 0
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 0
        LinkLabel.LinkLabel.Strings = (
          'Label10')
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edISBN: TEditLabeled
        Left = 38
        Top = 49
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
        TabOrder = 6
        LinkLabel.LinkLabel.Strings = (
          'Label11'
          'VDTButton6')
        TypeDonnee = tdISBN
        CurrencyChar = #0
      end
      object cbVO: TCheckBoxLabeled
        Left = 38
        Top = 85
        Width = 34
        Height = 16
        Cursor = crHandPoint
        Caption = 'VO'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 7
        LinkLabel.LinkLabel.Strings = (
          'cbVO')
      end
      object cbCouleur: TCheckBoxLabeled
        Left = 38
        Top = 107
        Width = 54
        Height = 16
        Cursor = crHandPoint
        Caption = 'Couleur'
        Checked = True
        Ctl3D = True
        ParentCtl3D = False
        State = cbChecked
        TabOrder = 8
        LinkLabel.LinkLabel.Strings = (
          'cbCouleur')
      end
      object cbStock: TCheckBoxLabeled
        Left = 38
        Top = 28
        Width = 61
        Height = 13
        Caption = 'En stock'
        Checked = True
        Ctl3D = True
        ParentCtl3D = False
        State = cbChecked
        TabOrder = 3
        LinkLabel.LinkLabel.Strings = (
          'cbStock')
      end
      object cbDedicace: TCheckBoxLabeled
        Left = 38
        Top = 129
        Width = 64
        Height = 16
        Cursor = crHandPoint
        Caption = 'D'#233'dicac'#233
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 9
        LinkLabel.LinkLabel.Strings = (
          'cbDedicace')
      end
      object dtpAchat: TDateTimePickerLabeled
        Left = 254
        Top = 0
        Width = 101
        Height = 21
        Date = 38158.758085983800000000
        Time = 38158.758085983800000000
        ShowCheckbox = True
        Checked = False
        TabOrder = 2
      end
      object cbGratuit: TCheckBoxLabeled
        Left = 118
        Top = 26
        Width = 53
        Height = 16
        Cursor = crHandPoint
        Caption = 'Gratuit'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 4
        LinkLabel.LinkLabel.Strings = (
          'cbVO')
      end
      object cbOffert: TCheckBoxLabeled
        Left = 118
        Top = 2
        Width = 53
        Height = 16
        Cursor = crHandPoint
        Caption = 'Offert'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
        LinkLabel.LinkLabel.Strings = (
          'cbVO')
      end
      object edNombreDePages: TEditLabeled
        Left = 38
        Top = 152
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 10
        LinkLabel.LinkLabel.Strings = (
          'Label21')
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edAnneeCote: TEditLabeled
        Left = 134
        Top = 184
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 11
        LinkLabel.LinkLabel.Strings = (
          'Label24')
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edPrixCote: TEditLabeled
        Left = 215
        Top = 184
        Width = 64
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 12
        LinkLabel.LinkLabel.Strings = (
          'Label25'
          'VDTButton14')
        TypeDonnee = tdCurrency
        CurrencyChar = #0
      end
    end
    object edAnneeParution: TEditLabeled
      Left = 175
      Top = 27
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 3
      LinkLabel.LinkLabel.Strings = (
        'Label3')
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edTitre: TEditLabeled
      Left = 56
      Top = 4
      Width = 785
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      LinkLabel.LinkLabel.Strings = (
        'Label2')
      CurrencyChar = #0
    end
    object histoire: TMemoLabeled
      Left = 56
      Top = 50
      Width = 384
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 8
      LinkLabel.LinkLabel.Strings = (
        'Label6')
    end
    object remarques: TMemoLabeled
      Left = 487
      Top = 50
      Width = 354
      Height = 81
      Anchors = [akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 9
      LinkLabel.LinkLabel.Strings = (
        'Label7')
    end
    object lvScenaristes: TVDTListViewLabeled
      Left = 305
      Top = 146
      Width = 198
      Height = 41
      BevelKind = bkTile
      BorderStyle = bsNone
      Columns = <
        item
          Width = 46
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stNone
      TabOrder = 12
      ViewStyle = vsReport
      LinkLabel.LinkLabel.Strings = (
        'btScenariste')
    end
    object lvDessinateurs: TVDTListViewLabeled
      Left = 305
      Top = 190
      Width = 198
      Height = 41
      BevelKind = bkTile
      BorderStyle = bsNone
      Columns = <
        item
          Width = 46
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stBoth
      TabOrder = 13
      ViewStyle = vsReport
      LinkLabel.LinkLabel.Strings = (
        'btDessinateur')
    end
    object vtPersonnes: TVirtualStringTree
      Left = 56
      Top = 169
      Width = 177
      Height = 105
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      Columns = <>
    end
    object Edit2: TEditLabeled
      Left = 56
      Top = 146
      Width = 135
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 10
      LinkLabel.LinkLabel.Strings = (
        'Label19'
        'VDTButton7'
        'VDTButton8')
      CurrencyChar = #0
    end
    object vstImages: TVirtualStringTree
      Left = 56
      Top = 591
      Width = 656
      Height = 130
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      CheckImageKind = ckDarkCheck
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      TabOrder = 24
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.StringOptions = []
      Columns = <
        item
          Position = 1
          Width = 552
        end
        item
          Position = 0
          Width = 100
        end>
    end
    object Edit3: TEditLabeled
      Left = 550
      Top = 146
      Width = 251
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 15
      LinkLabel.LinkLabel.Strings = (
        'Label20'
        'VDTButton11'
        'VDTButton12')
      CurrencyChar = #0
    end
    object vtSeries: TVirtualStringTree
      Left = 550
      Top = 169
      Width = 291
      Height = 105
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Columns = <>
    end
    object lvColoristes: TVDTListViewLabeled
      Left = 305
      Top = 234
      Width = 198
      Height = 41
      BevelKind = bkTile
      BorderStyle = bsNone
      Columns = <
        item
          Width = 46
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stBoth
      TabOrder = 14
      ViewStyle = vsReport
      LinkLabel.LinkLabel.Strings = (
        'btColoriste')
    end
    object cbIntegrale: TCheckBoxLabeled
      Left = 316
      Top = 29
      Width = 65
      Height = 16
      Cursor = crHandPoint
      Caption = 'Int'#233'grale'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 5
      LinkLabel.LinkLabel.Strings = (
        'cbIntegrale')
    end
    object edTome: TEditLabeled
      Left = 56
      Top = 27
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 3
      TabOrder = 1
      LinkLabel.LinkLabel.Strings = (
        'Label1')
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object EditLabeled1: TEditLabeled
      Left = 446
      Top = 290
      Width = 354
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 18
      LinkLabel.LinkLabel.Strings = (
        'Label5'
        'VDTButton1')
      CurrencyChar = #0
    end
    object vtEditeurs: TVirtualStringTree
      Left = 446
      Top = 313
      Width = 395
      Height = 59
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      Columns = <>
    end
    object EditLabeled2: TEditLabeled
      Left = 446
      Top = 380
      Width = 354
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 20
      LinkLabel.LinkLabel.Strings = (
        'Label8'
        'VDTButton2')
      CurrencyChar = #0
    end
    object vtCollections: TVirtualStringTree
      Left = 446
      Top = 403
      Width = 395
      Height = 59
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
      Columns = <>
    end
    object vtEditions: TListBoxLabeled
      Left = 56
      Top = 290
      Width = 317
      Height = 45
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
      TabOrder = 17
      LinkLabel.LinkLabel.Strings = (
        'Label4'
        'VDTButton3')
    end
    object cbHorsSerie: TCheckBoxLabeled
      Left = 234
      Top = 29
      Width = 73
      Height = 16
      Cursor = crHandPoint
      Caption = 'Hors s'#233'rie'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      LinkLabel.LinkLabel.Strings = (
        'cbHorsSerie')
    end
    object edNotes: TMemoLabeled
      Left = 446
      Top = 472
      Width = 395
      Height = 97
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 22
      LinkLabel.LinkLabel.Strings = (
        'Label15')
    end
    object edTomeDebut: TEditLabeled
      Left = 424
      Top = 27
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      Enabled = False
      MaxLength = 3
      TabOrder = 6
      LinkLabel.LinkLabel.Strings = (
        'Label16'
        'Label17')
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edTomeFin: TEditLabeled
      Left = 472
      Top = 27
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      Enabled = False
      MaxLength = 3
      TabOrder = 7
      LinkLabel.LinkLabel.Strings = (
        'Label16'
        'Label17')
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edMoisParution: TEditLabeled
      Left = 152
      Top = 27
      Width = 22
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 2
      TabOrder = 2
      LinkLabel.LinkLabel.Strings = (
        'Label3')
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
  end
end
